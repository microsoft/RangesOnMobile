# Experiment Application Source Code

A mobile-only web application for evaluating alternative visual representations of quantitative ranges for value retrieval and comparison tasks spanning different granularities of time. 

An instance of the application is running at [aka.ms/ranges](http://aka.ms/ranges), which can be viewed device running the Chrome or Safary mobile web browser.

Maintained by [Matthew Brehmer](https://github.com/mattbrehmer).

## Setup / Testing

1. Open a terminal and navigate to this directory

2. Ensure that [nodejs](https://nodejs.org/) and the [yarn package manager](https://yarnpkg.com/en/docs/getting-started) are installed

3. Install the necessary packages with the `yarn` command

4. Start the node server with: `npm start`

5. Open [localhost:8080](http://localhost:8080/) in Chrome. For emulating a mobile usage environment, launch the Chrome debugger (`CTRL + SHIFT + J`) and toggle the device emulator (`CTRL + SHIFT + M`); select your desired mobile device. Note that the application will only be visible in portrait mode in the mobile emulator. 

The application source code can be found in the src/ directory. Toggle the type of data shown by setting the `first_datatype` variable in src\initTasks.js to `'temperature'` or `'sleep'`. 

## Stimuli Data

sleepData.js is synthetic sleep data for every day in 2012 (rounded to include a full week), where bedtimes and waking times follow normal distributions (bedtime: M = 12AM, SD = 2 hours; waking time: M = 7AM, SD = 2 hours), with values for the weekdays sampling from the first 5/7ths of this distribtion (without replacement) and values for the two weekends days sampling from the last 2/7ths of this distribution. The baseline sleeping range is 8 hours, from 11:30pm to 7:30am.

temperatureData.js contains Seattle's high and low daily temperatures for every day in 2015 (rounded to include a full week), as indicated on [wunderground.com](https://www.wunderground.com/history/airport/KSEA/2015/1/1/CustomHistory.html?dayend=31&monthend=12&yearend=2015&req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=). The average high and low daily temperatures are as indicated on [intellicast.com](http://www.intellicast.com/Local/History.aspx?location=USWA0395)

Replace these files with your own sleep / temperature / range data as you see fit. Ensure that each day in your data contains a valid timestamp value for `date_val` (ISO 8601 format, e.g., `2012-01-01T12:00:00.000Z`), valid whole number values for `year`, `month`, `weekday`, `week_of_yearday`, `day_of_year`, and valid decimal values for `start`, `end`, `start_baseline`, and `end_baseline`. 

## Logging

If you use [Azure Application Insights](https://azure.microsoft.com/en-us/services/application-insights/), you can initialize `appInsights` logging by adding your own appInsights `instrumentationKey` in src/globals.js and uncommenting calls to `appInsights` throughout /src.

Otherwise, you can implement your own logging protocol throughout /src that logs events in the same JSON format.

## Usage

Press any keyboard key to unlock all phases of the study application. 

Tap on the word "VISUALIZING" in the application's header to reveal an interactive sandbox where you can navigate the data. Press any keyboard key to return to the main menu.

## Icon Attribution

The application incorporates (and modifies) the following [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) icons from [the Noun Project](https://thenounproject.com/):
- [Sleeping #947845](https://thenounproject.com/icon/947845/) by Adrien Coquet
- [Sunrise #1165588](https://thenounproject.com/icon/1165588/) by sanjivini
- [Temperature #1021702](https://thenounproject.com/icon/1021702/) by Nikita Kozin
- [Temperature #1021699](https://thenounproject.com/icon/1021699/) by Nikita Kozin
- [Hand Holding Smartphone #1248199](https://thenounproject.com/icon/1248199/) by UNiCORN
- [Portrait Orientation #456515](https://thenounproject.com/icon/456515/) by Guilhem
- [Phone Brightness #753458](https://thenounproject.com/icon/753458/) by corpus delicti
- [Brightness #662615](https://thenounproject.com/icon/662615/) by Creaticca Creative Agency
- [Wifi #688371](https://thenounproject.com/icon/688371/) by Kid A
- [Battery #1099945](https://thenounproject.com/icon/1099945/) by ProSymbols
- [Back #1263570](https://thenounproject.com/icon/1263570/) by praveen patchu
- [Refresh #1176415](https://thenounproject.com/icon/1176415/) by il Capitano
- [Ban #46000](https://thenounproject.com/icon/46000/) by useiconic.com
- [Pointing Hand #1025751](https://thenounproject.com/icon/1025751/) by GreenHill

## 3rd party package dependencies:

- [d3](https://www.npmjs.com/package/d3) ([BSD-3 license](https://github.com/d3/d3/blob/master/LICENSE))
- [moment](https://www.npmjs.com/package/moment) ([MIT license](https://github.com/moment/moment/blob/develop/LICENSE))
- [clipboard](https://www.npmjs.com/package/clipboard) ([MIT license](http://zenorocha.mit-license.org/))

## 3rd party package dev dependencies:

- [serve](https://www.npmjs.com/package/serve) ([MIT license](http://spdx.org/licenses/MIT.html))
- [webpack](https://www.npmjs.com/package/webpack) ([MIT license](http://spdx.org/licenses/MIT.html))
- [webpack-dev-server](https://www.npmjs.com/package/webpack-dev-server) ([MIT license](http://spdx.org/licenses/MIT.html))
- [webpack-dev-middleware](https://www.npmjs.com/package/webpack-dev-middleware) ([MIT license](http://spdx.org/licenses/MIT.html))
- [jshint](https://www.npmjs.com/package/jshint) ([MIT license](http://spdx.org/licenses/MIT.html) and [JSON license](http://spdx.org/licenses/JSON.html))
- [jshint-loader](https://www.npmjs.com/package/jshint-loader) ([MIT license](http://spdx.org/licenses/MIT.html))
- [express](https://www.npmjs.com/package/express) ([MIT license](http://spdx.org/licenses/MIT.html))
- [concurrently](https://www.npmjs.com/package/concurrently) ([MIT license](http://spdx.org/licenses/MIT.html))

## Additional attribution

`public/preloader.js` (preloading image assets) uses code published in a blog post by Dimitar Christoff on 2012-05-18 (no license provided) "[Preloading images using javascript, the right way and without frameworks](http://fragged.org/preloading-images-using-javascript-the-right-way-and-without-frameworks_744.html)": [http://fragged.org/preloading-images-using-javascript-the-right-way-and-without-frameworks_744.html](http://fragged.org/preloading-images-using-javascript-the-right-way-and-without-frameworks_744.html)

`public/src/rangeChart.js` features a radial layout that incorporates aspects of [a bl.ocks.org example by Nadieh Bremer](http://bl.ocks.org/nbremer/a43dbd5690ccd5ac4c6cc392415140e7). For generating SVG gradients for each range mark, we drew inspiration from [Nadieh](https://www.visualcinnamon.com/)'s 2016 blog post "[Boost D3.js charts with SVG gradients](https://www.creativebloq.com/how-to/boost-d3js-charts-with-svg-gradients)".

## See also

Other implementations of radial range charts include a [bl.ocks.org example by Susie Lu](https://bl.ocks.org/susielu/b6bdb82045c2aa8225f5) and a [subsequent interactive version by Elijah Meeks](https://bl.ocks.org/emeeks/2fffa9abe50ac97603c7). 

For an example of a linear range chart spanning 7 months, see this [bl.ocks.org example by Mike Bostock](https://bl.ocks.org/mbostock/3cfa2d1dbae2162a60203b287431382c).