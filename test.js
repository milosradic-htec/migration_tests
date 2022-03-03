const mssqlUtils = require("./mssql/mssqlUtils");
const pgUtils = require("./pg/pgUtils");
const { checkAndSaveReport } = require("./utils/utils");
const test = require("ava");

var testSetup = {
  userEmails: []
};

test.before("Get all emails", async () => {
  (await mssqlUtils.getAllEmails()).forEach(function (User) {
    testSetup.userEmails.push(User.Email);
  });
});

test("Check Users/Profiles/Restaurants/Addresses", async (t) => {
  for (let i = 0; i < testSetup.userEmails.length; i++) {
    var userEmail = testSetup.userEmails[i];
    var msqlDb = await mssqlUtils.msGetUserByEmail(userEmail);
    var pgDb = await pgUtils.pgGetUserByEmail(userEmail);

    checkAndSaveReport(
      t,
      msqlDb,
      pgDb,
      "users_profiles_restaurants_diff"
    );
  }
});

test("Check Foods/Metadata/Prices", async (t) => {
  for (let i = 0; i < testSetup.userEmails.length; i++) {
    var userEmail = testSetup.userEmails[i];
    var msqlDb = await mssqlUtils.msGetFoodsByRestorauntEmail(userEmail);
    var pgDb = await pgUtils.pgGetFoodsByRestaurantEmail(userEmail);

    checkAndSaveReport(
      t,
      msqlDb,
      pgDb,
      "foods_metadata_prices_diff"
    );
  }
});
