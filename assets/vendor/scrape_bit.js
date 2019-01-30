const _ = require('lodash')
const puppeteer = require('puppeteer')
const redis = require('redis')

process.on('unhandledRejection', error => {
    console.log('unhandledRejection', error.message)
    console.log(error.stack)
});

async function clickViewAll (page) {
    const eventList = 'eventList-23e37430'
    const lastListElementClass = (eventList) => {
        var divs = document.querySelector('.' + eventList).children
        return '.' + divs.item(divs.length - 1).classList[0]
    }
    const viewAll = await page.evaluate(lastListElementClass, eventList);
    await page.click(viewAll)
}

async function scrollDown (scrollInterval) {
    await this.page.keyboard.press('ArrowDown', { delay: scrollInterval - 5 })
}

async function batchUpcomingEvents (res) {
    if (!/upcomingEvents/.test(res.url())) return
    let body = await res.text()
    body = JSON.parse(body)
    _.forEach(body.events, event => {
        if (!this.seenJson.has(event)) {
            this.seenJson.add(event)
            this.batchOfJson.push(event)
        }
    })
}

async function publishEvents (channelId) {
    if (_.isEmpty(this.batchOfJson)) {
        console.log('done scrolling, stopped publishing')
        this.cleanup()
        return
    }

    console.log('got this much in batch:', this.batchOfJson.length, 'and seen:', this.seenJson.length)
    this.redisClient.publish(channelId, JSON.stringify(this.batchOfJson))
    this.batchOfJson = []
}

(async () => {
    const PLACE_ID = process.env.PLACE_ID || 'ChIJOwg_06VPwokRYv534QaPC8g' // NYC
    const REDIS_URL = process.env.REDIS_URL || 'redis://localhost:6379' // url for channel
    const CHANNEL_ID = process.env.CHANNEL_ID || `BIT_CHANNEL:${PLACE_ID}` // write data to this channel
    const SCROLL_INTERVAL = 10 // quicker scrolling blocks chromium's renderer from loading images, increasing JSON throughput
    const EVENTS_INTERVAL = 5000 // every 5 seconds, write new events to redis channel
    const NODE_CONFIG = /* { headless: false, devtools: true } || */ { headless: true }

    const baseUrl = `https://www.bandsintown.com/?place_id=${PLACE_ID}`

    this.browser = await puppeteer.launch(NODE_CONFIG);
    this.page = await this.browser.newPage();

    this.redisClient = redis.createClient(REDIS_URL);
    this.redisClient.on('error', function (err) {
        console.log('[Redis Error]', err);
    })

    console.log('visiting', baseUrl)
    await this.page.goto(baseUrl)
    await clickViewAll(this.page)

    this.seenJson = new Set()
    this.batchOfJson = []

    this.page.on('response', batchUpcomingEvents.bind(this))
    this.scrollTimeout = setInterval(scrollDown.bind(this), SCROLL_INTERVAL, SCROLL_INTERVAL)
    this.eventsTimeout = setInterval(publishEvents.bind(this), EVENTS_INTERVAL, CHANNEL_ID)

    this.cleanup = function () {
        clearInterval(this.scrollTimeout)
        clearInterval(this.eventsTimeout)
        this.redisClient.quit()
        this.browser.close().then(() => process.exit())
    }
})();