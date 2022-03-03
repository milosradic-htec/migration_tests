const mssqlUtils = require("./mssql/mssqlUtils");
const pgUtils = require("./pg/pgUtils");
const { imgCompareAndReport, getBufferFromImgUrl } = require("./utils/utils");
const test = require("ava");

var testSetup = {
  msqlPhotoUrls: [],
  pgPhotoUrls: []
};

test.before("Get all photo URLs", async () => {
  testSetup.msqlPhotoUrls = await mssqlUtils.msGetAllPhotoUrls();
  testSetup.pgPhotoUrls = await pgUtils.pgGetAllPhotoUrls();
});

test.serial("Compare images", async (t) => {
  for (let i = 0; i < testSetup.msqlPhotoUrls.length; i++) {
    var msPhotoUrl = testSetup.msqlPhotoUrls[i].Photo;
    var pgPhotoUrl = testSetup.pgPhotoUrls[i].Photo;

    var msPhotoId = testSetup.msqlPhotoUrls[i].PhotoId
    var pgPhotoId = testSetup.pgPhotoUrls[i].PhotoId;

  
    var msPhotoBuff = await getBufferFromImgUrl(msPhotoUrl);
    var pgPhotoBuff = await getBufferFromImgUrl(pgPhotoUrl);

    imgCompareAndReport(t, msPhotoBuff, pgPhotoBuff, msPhotoId, pgPhotoId, "photo_diff");
  }
});
