const puppeteer = require('puppeteer')
const redis = require("redis")


const delay = ms => new Promise(res => setTimeout(res, ms));

process.on('unhandledRejection', error => {
    console.log('unhandledRejection', error.message)
    console.log(error.stack)
});

(async () => {
    const SCROLL_DOWN_EVENTS = process.env.SCROLL_DOWN_EVENTS || 1000
    const PLACE_ID = process.env.PLACE_ID || 'ChIJOwg_06VPwokRYv534QaPC8g' // NYC
    const REDIS_URL = process.env.REDIS_URL || 'redis://localhost:6379'
    const FIFO_CHANNEL = process.env.FIFO_CHANNEL || `BIT_CHANNEL:${PLACE_ID}`

    // const config = { headless: false, devtools: true } // use for testing
    const config = { headless: true }
    const browser = await puppeteer.launch(config);
    const page = await browser.newPage();
    const baseUrl = `https://www.bandsintown.com/?place_id=${PLACE_ID}`

    console.log('visiting', baseUrl)
    await page.goto(baseUrl);

    // load the topEvents page
    const [_res1] = await Promise.all([
        page.waitForNavigation(),
        page.click('.topEvents-40dbb4d2')
    ])

    await delay(1500);

    // get the lazy loaded elements
    const eventList = 'eventList-23e37430'
    const lastListElementClass = (eventList) => {
        var divs = document.querySelector('.' + eventList).children
        return '.' + divs.item(divs.length - 1).classList[0]
    }
    const viewAll = await page.evaluate(lastListElementClass, eventList);
    await page.click(viewAll)

    const eventNode = 'event-0fe45b3b'
    const allHtml = new Set()
    const redisClient = redis.createClient(REDIS_URL);

    redisClient.on("error", function (err) {
        console.log("[Redis Error]", err);
    })

    const htmlFromMatchNodes = (nodes) => {
        html = []
        for (node of nodes) {
            html.push(node.outerHTML)
        }
        return html
    }

    console.log('Scrolling down the page...')
    for (i = 0; i < SCROLL_DOWN_EVENTS; i++) {
        await page.keyboard.press('ArrowDown', { delay: 20 })
        const events = await page.$$eval('.' + eventNode, htmlFromMatchNodes)

        for (html of events) {
            if (allHtml.has(html)) {
                continue
            }

            allHtml.add(html)
            redisClient.publish(FIFO_CHANNEL, html)
        }
    }

    console.log('done scrolling, quit publishing')
    redisClient.quit()

    await browser.close();
})();