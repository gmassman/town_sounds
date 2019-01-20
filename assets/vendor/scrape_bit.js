const puppeteer = require('puppeteer')
const fs = require('fs')
// const { Readable } = require('stream')

const delay = ms => new Promise(res => setTimeout(res, ms));

process.on('unhandledRejection', error => {
    console.log('unhandledRejection', error.message)
    console.log(error.stack)
});

(async () => {
    const SCROLL_DOWN_EVENTS = process.env.SCROLL_DOWN_EVENTS || 1000
    const PLACE_ID = process.env.PLACE_ID || 'ChIJOwg_06VPwokRYv534QaPC8g' // NYC
    const FIFO_PATH = process.env.FIFO_PATH || '/tmp/test_pipe'

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
    const wstream = fs.createWriteStream(FIFO_PATH)

    let ok = true

    const htmlFromMatchNodes = (nodes) => {
        html = []
        for (node of nodes) {
            html.push(node.outerHTML)
        }
        return html
    }

    console.log('Scrolling down the page')
    for (i = 0; i < SCROLL_DOWN_EVENTS; i++) {
        await page.keyboard.press('ArrowDown', { delay: 20 })
        const events = await page.$$eval('.' + eventNode, htmlFromMatchNodes)

        for (html of events) {
            if (allHtml.has(html)) {
                continue
            }
            console.log(html)
            allHtml.add(html)
            ok = wstream.write('\n' + html)
        }
    }

    if (!ok) {
        console.log('WARN: wstream may not have finished writing!')
        delay(5000)
    }
    console.log('done scrolling, end writing')
    wstream.end('\nDONE')

    // Waiting for fifo writes to finish...

    await browser.close();
})();