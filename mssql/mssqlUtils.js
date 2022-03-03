const sql = require("mssql");
const dbConfig = require("../utils/utils").mssqlConfig;

async function getAllEmails() {
  try {
    let pool = await sql.connect(dbConfig);
    const result = await pool.query`SELECT [Email] FROM [MsQaMig].dbo.Users;`;
    return result.recordset;
  } catch (err) {
    console.log(err);
  }
  sql.pool.close();
}

async function msGetUserByEmail(email) {
  try {
    let pool = await sql.connect(dbConfig);
    const result =
      await pool.query`SELECT u.UserId, u.Email UserEmail, u.EmailConfirmed, u.DateCreated,
        p.Gender, p.FirstName, p.LastName, p.ProfileImage, p.Description UserDescription, 
        a.Country UserCountry, a.Street UserStreet, a.HouseNumber UserHouseNumber, a.City UserCity, a.PostalCode UserPostalCode,
        a.PhoneNumber1 UserPhoneNumber1, a.PhoneNumber2 UserPhoneNumber2, r.Name RestaurantName, r.Email RestaurantEmail, 
        r.PIB, r.LogoImage, r.Description RestaurantDescription, r.NotPartner IsPartner,
        ar.Country RestaurantCountry, ar.Street RestaurantStreet, ar.HouseNumber RestaurantHouseNumber, ar.City RestaurantCity, 
        ar.PostalCode RestaurantPostalCode, ar.PhoneNumber1 RestaurantPhoneNumber1, ar.PhoneNumber2 RestaurantPhoneNumber2,
        r2.Name RoleName
        FROM MsQaMig.dbo.Users u 
        LEFT JOIN MsQaMig.dbo.Profiles p ON u.UserId  = p.ProfileId 
        LEFT JOIN MsQaMig.dbo.Address a ON p.AddressId = a.AddressId 
        LEFT JOIN MsQaMig.dbo.Restaurants r ON r.RestaurantId = p.RestaurantId 
        LEFT JOIN MsQaMig.dbo.Address ar ON r.AddressId = ar.AddressId 
        LEFT JOIN MsQaMig.dbo.Roles r2 ON u.RoleId = r2.Id 
        WHERE u.Email = ${email}`;
    if (result.recordset[0].IsPartner) {
      result.recordset[0].IsPartner = !result.recordset[0].IsPartner;
    }
    return result.recordset[0];
  } catch (err) {
    console.log(err);
  }
  sql.pool.close();
}

async function msGetFoodsByRestorauntEmail(email) {
  try {
    let pool = await sql.connect(dbConfig);
    const result =
      await pool.query`SELECT RestaurantName, OrderCounter, DateCreated, DeleteDate, IsAvailable, Description, Title,
  PhotoPath, Small SmallSize, Medium MediumSize, [Large] LargeSize,
  SmallSizePrice, MediumSizePrice, LargeSizePrice
  FROM(SELECT r.Name RestaurantName , f.OrderCounter, f.DateCreated, f.DeleteDate, f.IsAvailable, f.Description, f.Title, f.PhotoPath, f.PriceId,
  m.FoodId, m.MetadataName, m.Value,
  price.Small SmallSizePrice, price.Medium MediumSizePrice, price.Large LargeSizePrice
  FROM MsQaMig.dbo.Metadata m
  LEFT JOIN MsQaMig.dbo.Foods f ON f.FoodId = m.FoodId
  LEFT JOIN MsQaMig.dbo.Prices price ON price.PriceId = f.PriceId 
  LEFT JOIN MsQaMig.dbo.Restaurants r ON f.RestaurantId = r.RestaurantId 
  LEFT JOIN MsQaMig.dbo.Profiles p ON r.RestaurantId = p.RestaurantId 
  LEFT JOIN MsQaMig.dbo.Users u ON p.ProfileId = u.UserId 
  WHERE u.Email = ${email}) x 
  PIVOT (Max(Value) FOR MetadataName IN (
  Small, Medium, [Large])) pvt;`;

    var prices = ["SmallSizePrice", "MediumSizePrice", "LargeSizePrice"];
    for (let i = 0; i < result.recordset.length; i++) {
      var result2 = result.recordset[i];
      prices.every((key) => result2[key] !== null && result2[key] !== "" ? (result2[key] = result2[key].toString()) : result2[key]);
    }
    return result.recordset;
  } catch (error) {
    console.log(error);
  }
  sql.pool.close();

}

async function msGetAllPhotoUrls() {
  try {
    let pool = await sql.connect(dbConfig)
    const result = await pool.query`SELECT PhotoId, FoodId, Photo, [Type]
    FROM MsQaMig.dbo.Photos
    ORDER BY FoodId, [Type] ASC;`
    return result.recordset;
  } catch (error) {
    console.log(error)
  }
  sql.pool.close();
}
module.exports = {
  getAllEmails,
  msGetUserByEmail,
  msGetFoodsByRestorauntEmail,
  msGetAllPhotoUrls,
};
