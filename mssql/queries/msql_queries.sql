-- Get all User Ids
SELECT [Id] 
FROM [MsQaMig].dbo.Users u 
LEFT JOIN [MsQaMig].dbo.Roles r 
ON u.RoleId = r.Id 
WHERE r.Name = 'User'


-- Get All Emails for user
SELECT [Email] 
FROM [MsQaMig].dbo.Users;

-- Get user/profile/restaurant/address
SELECT u.UserId, u.UserName, u.Email UserEmail, u.EmailConfirmed, u.DateCreated,
        p.Gender, p.FirstName, p.LastName, p.ProfileImage, p.Description UserDescription, 
        a.Country UserCountry, a.Street UserStreet, a.HouseNumber UserHouseNumber, a.City UserCity, a.PostalCode UserPostalCode,
        a.PhoneNumber1 UserPhoneNumber1, a.PhoneNumber2 UserPhoneNumber2,
        r.Name RestaurantName, r.Email RestaurantEmail, r.PIB, r.LogoImage, r.Description RestaurantDescription, r.NotPartner IsPartner,
        ar.Country RestaurantCountry, ar.Street RestaurantStreet, ar.HouseNumber RestaurantHouseNumber, ar.City RestaurantCity, 
        ar.PostalCode RestaurantPostalCode, ar.PhoneNumber1 RestaurantPhoneNumber1, ar.PhoneNumber2 RestaurantPhoneNumber2,
        r2.Name RoleName
FROM MsQaMig.dbo.Users u 
LEFT JOIN MsQaMig.dbo.Profiles p ON u.UserId  = p.ProfileId 
LEFT JOIN MsQaMig.dbo.Address a ON p.AddressId = a.AddressId 
LEFT JOIN MsQaMig.dbo.Restaurants r ON r.RestaurantId = p.RestaurantId 
LEFT JOIN MsQaMig.dbo.Address ar ON r.AddressId = ar.AddressId 
LEFT JOIN MsQaMig.dbo.Roles r2 ON u.RoleId = r2.Id 
WHERE u.Email = 'kupac@gmail.com'

-- Get Foods/Metadata/Prices
SELECT RestaurantName, OrderCounter, DateCreated, DeleteDate DateDeleted, IsAvailable, Description, Title,
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
WHERE u.Email = 'restoran@gmail.com') x 
PIVOT (Max(Value) FOR MetadataName IN (
Small, Medium, [Large])) pvt;

-- Get photos
SELECT PhotoId, FoodId, Photo, [Type]
FROM MsQaMig.dbo.Photos
ORDER BY FoodId, [Type] ASC;