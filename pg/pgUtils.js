const { Client } = require("pg");
const pgConfig = require("../utils/utils").pgConfig;

async function pgGetUserByEmail(email) {
  const client = new Client(pgConfig);
  client.connect();
  const result =
    await client.query(`SELECT u."Id" "UserId", u."Email" "UserEmail", u."Activated" "EmailConfirmed",
    p."Created" "DateCreated", p."Gender", u."FirstName", 
    u."LastName", p."ImageUrl" "ProfileImage", p."Description" "UserDescription", 
    a1."Country" "UserCountry", a1."Street" "UserStreet", a1."Number" "UserHouseNumber",
    a1."City" "UserCity", a1."PostalCode" "UserPostalCode", a1."PhoneNumber1" "UserPhoneNumber1",a1."PhoneNumber2" "UserPhoneNumber2",
    r."RestaurantName", r."RestaurantEmail", r."PIB", r."RestaurantPhoto" "LogoImage", 
    r."Description" "RestaurantDescription", r."IsPartner",
    ar."Country" "RestaurantCountry", ar."Street" "RestaurantStreet", ar."Number" "RestaurantHouseNumber", 
    ar."City" "RestaurantCity", ar."PostalCode" "RestaurantPostalCode", 
    ar."PhoneNumber1" "RestaurantPhoneNumber1", ar."PhoneNumber2" "RestaurantPhoneNumber2", r2."Name" "RoleName"
    FROM public."Users" u
    LEFT JOIN public."Profiles" p ON u."Id" = p."Id"
    LEFT JOIN public."Addresses" a1 ON p."AddressId" = a1."Id"
    LEFT JOIN public."Restaurants" r ON p."RestaurantId" = r."Id"
    LEFT JOIN public."Addresses" ar ON r."AddressId" = ar."Id"
    LEFT JOIN public."UserRoles" rl ON u."Id" = rl."UserId"
    LEFT JOIN public."Roles" r2 ON rl."RoleId" = r2."Id"
    WHERE u."Email" = '${email}';`);
  client.end();
  return result.rows[0];
}

async function pgGetFoodsByRestaurantEmail(email) {
  const client = new Client(pgConfig);
  client.connect();
  const result =
    await client.query(`SELECT r."RestaurantName" "RestaurantName", f."OrderCounter", 
  f."Created" "DateCreated", f."Deleted" "DateDeleted",
  f."IsAvailable", f."Description", f."Title", f."Photo" "PhotoPath",  m."SmallSize", m."MediumSize", m."LargeSize", 
  p."Small" "SmallSizePrice", p."Medium" "MediumSizePrice", p."Large" "LargeSizePrice"
  FROM public."Foods" f
  LEFT JOIN public."Restaurants" r ON f."OwnerId" = r."Id"
  LEFT JOIN public."Profiles" prof ON r."Id" = prof."RestaurantId"
  LEFT JOIN public."Users" users ON prof."Id" = users."Id"
  LEFT JOIN public."Metadata" m ON m."Id" = f."Id"
  LEFT JOIN public."Prices" p ON p."Id" = f."Id"
  WHERE users."Email" = '${email}';`);
  client.end();
 return result.rows;
}
async function pgGetAllPhotoUrls(){
  const client = new Client(pgConfig);
  client.connect();
  const result = await client.query(`SELECT "PhotoId", "FoodId", "Photo", "Type"
  FROM public."Photos"
  ORDER BY "FoodId", "Type" ASC;`)
  client.end();
  return result.rows;
}

module.exports = {
  pgGetUserByEmail,
  pgGetFoodsByRestaurantEmail,
  pgGetAllPhotoUrls,
};
