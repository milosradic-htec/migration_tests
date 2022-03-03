var fs = require("fs");
const concordance = require("concordance");
const args = require("minimist")(process.argv.slice(2));
const mssqlConfigs = require("../configs/mssql_configs");
const pgConfigs = require("../configs/pg_configs");
const axios = require("axios");
const compareImages = require("resemblejs/compareImages");

// Parse env argument from command line
var env = args["env"];

// Set config for environment
var mssqlConfig = mssqlConfigs[env];
var pgConfig = pgConfigs[env];

function checkAndSaveReport(t, msqlDb, pgDb, testName) {
  var fileName = "./reports/" + env + "_" + testName + ".log";

  if (!t.deepEqual(msqlDb, pgDb)) {


    var difference = JSON.stringify(concordance.diff(msqlDb, pgDb));

    var differenceEscaped = difference.replace(/\\n/g, "\n");

    console.log(differenceEscaped);

    var reportResults =
      "Difference: \r \n" +
      differenceEscaped +
      "\r \n ==================================================================== \r \n";

    fs.appendFile(fileName, reportResults, function (err) {
      if (err) throw err;
    });
  }
}

async function getBufferFromImgUrl(imgUrl) {
  try {
    var imgArray = await axios.get(imgUrl, { responseType: "arraybuffer" });

    if (imgArray.status != 200) return false;

    var imageBuffer = Buffer.from(imgArray.data, "base64");
    return imageBuffer;
  } catch (error) {
    console.log(error.response.status);
  }
}

async function imgCompareAndReport(
  t,
  msPhotoBuff,
  pgPhotoBuff,
  msPhotoId,
  pgPhotoId,
  testName
) {
  var fileName = "./reports/" + env + "_" + testName + ".log";

  const diff = await compareImages(msPhotoBuff, pgPhotoBuff);
  console.log(diff.rawMisMatchPercentage);
  if (!t.deepEqual(diff.rawMisMatchPercentage, 0)) {
    var reportResults =
      "Difference: \r \n" +
      "Msql photo id: " + msPhotoId + " \r \n" +
      "Postgres photo id: " + pgPhotoId +
      "\r \n ==================================================================== \r \n";

    fs.appendFile(fileName, reportResults, function (err) {
      if (err) throw err;
    });
  }
}

module.exports = {
  mssqlConfig,
  pgConfig,
  checkAndSaveReport,
  getBufferFromImgUrl,
  imgCompareAndReport,
};
