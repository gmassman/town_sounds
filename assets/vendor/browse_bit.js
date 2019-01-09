const puppeteer = require('puppeteer');

const delay = ms => new Promise(res => setTimeout(res, ms));

process.on('unhandledRejection', error => {
    // Will print "unhandledRejection err is not defined"
    console.log('unhandledRejection', error.message);
});

(async () => {
    const browser = await puppeteer.launch({ headless: false, devtools: true });
    const page = await browser.newPage();
    const baseUrl = "https://www.bandsintown.com/?place_id=ChIJOwg_06VPwokRYv534QaPC8g" // NYC
    await page.goto(baseUrl);
    console.log("Processing...");

    // const inputElement = await page.$(".locationSelector-722b9b05")
    // await page.click(".locationSelector-722b9b05");
    // await page.type(".locationInput-77204640", "New York");
    // const resultsList = page.$(".resultsList-cc1648d8");
    // setTimeout(page.evaluate(() => {
        // debugger;
    // }), 1000);
    // await delay(1500);
// await page.evaluate(() => { debugger; });
// debugger;
    // const clickable = await page.$eval('.resultsList-cc1648d8 > div:eq(1)', uiElement => {
    // const uiElement = page.
    // const clickableClass = await page.evaluate(() => {
        // debugger;
        // console.log(document.querySelector('.resultsList-cc1648d8').children[1].classList[0])
        // return '.' + document.querySelector('.resultsList-cc1648d8').children[1].classList[0]
    // });
    // console.log(clickable);
    // const [_res1] = await Promise.all([
        // page.click(clickableClass)
    // ]);
    // await;
// console.log(await page.url())
    const [_res1] = await Promise.all([
        page.waitForNavigation(),
        page.click('.topEvents-40dbb4d2')
    ])

    await delay(1500);

    const viewAll = await page.evaluate(() => {
        // debugger
        var divs = document.querySelector('.eventList-23e37430').children
        // debugger
        return '.' + divs.item(divs.length-1).classList[0]
    });
    console.log(viewAll)
    const [_res2] = await Promise.all([
        page.waitForNavigation(),
        page.click(viewAll)
    ])
    // .slice(-1).pop()

    // await page.evaluate(() => { debugger });
    // const results = await page.$('.resultsList-cc1648d8');
    // await results.$$eval('div:eq(1)', nodes => { console.log(nodes) });
    await delay(50000);
    // await page.click();
    // await page.evaluate(() => {debugger;})
    // const [response] = await Promise.all([
        // page.waitForNavigation()
        // page.click(selector)
    //   ]);
    // await resultsList[1].click()
    // console.log(inputElement)
    // page.on('console', msg => console.log('PAGE LOG:', msg.text()));
    // await page.evaluate(() => console.log(`url is ${location.href}`));
    await browser.close();
})();