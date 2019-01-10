const puppeteer = require('puppeteer');
const { Pool } = require('pg');

const delay = ms => new Promise(res => setTimeout(res, ms));

process.on('unhandledRejection', error => {
    console.log('unhandledRejection', error.message);
});

const newPgPool = () => {
    const pool = new Pool({
        user: 'postgres',
        password: 'postgres',
        host: 'localhost',
        database: 'town_sounds_dev',
        port: 5432
    })
    pool.on('error', (err, _client) => {
        console.error('Unexpected error on idle client', err)
        process.exit(-1)
    })

    return pool
}

(async () => {
    const browser = await puppeteer.launch({ headless: false });
    const page = await browser.newPage();
    const pgClient = await newPgPool().connect()

    const place_id = process.argv[process.argv.length - 1]
    const baseUrl = `https://www.bandsintown.com/?place_id=${place_id}` // NYC

    await page.goto(baseUrl);

    const [_res1] = await Promise.all([
        page.waitForNavigation(),
        page.click('.topEvents-40dbb4d2')
    ])

    await delay(1500);

    const lastListElementClass = () => {
        var divs = document.querySelector('.eventList-23e37430').children
        return '.' + divs.item(divs.length-1).classList[0]
    }
    const viewAll = await page.evaluate(lastListElementClass);
    await page.click(viewAll)

    // await page.focus('.upcomingEvents-bee28721');

    const downEvents = 1000;
    // const downEvents = 10;
    for (var i = 0; i < downEvents; i++) {
        await page.keyboard.press('ArrowDown', { delay: 10 });
    }

    // Waiting for downEvents to process...
    delay(downEvents)

    const raw_html = await page.$eval('.upcomingEvents-bee28721', e => e.outerHTML);

    // const text = 'INSERT INTO upcoming_events(raw_html, place_id, inserted_at, updated_at) VALUES($1, $2, NOW(), NOW())'
    const values = [raw_html, place_id]
    try {
        // const res = await pool.query(text, values)
        console.log(`Saved record for place_id ${place_id}`);
    } catch(err) {
        console.log(err.stack)
    }

    await pgClient.end();
    await browser.close();
})();