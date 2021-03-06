-- Roles table
CREATE TABLE IF NOT EXISTS public."Roles"
(
    "Id" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    "Name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "PK_Roles" PRIMARY KEY ("Id")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Roles"
    OWNER to admin;

-- Users table
CREATE TABLE IF NOT EXISTS public."Users"
(
    "Id" integer NOT NULL,
    "FirstName" text COLLATE pg_catalog."default",
    "LastName" text COLLATE pg_catalog."default",
    "Email" character varying(300) COLLATE pg_catalog."default" NOT NULL,
    "Activated" boolean NOT NULL DEFAULT false,
    CONSTRAINT "PK_Users" PRIMARY KEY ("Id")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Users"
    OWNER to admin;

-- Index: IX_Users_Email

CREATE UNIQUE INDEX IF NOT EXISTS "IX_Users_Email"
    ON public."Users" USING btree
    ("Email" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Addresses table

CREATE TABLE IF NOT EXISTS public."Addresses"
(
    "Id" integer NOT NULL,
    "Street" text COLLATE pg_catalog."default" NOT NULL,
    "Number" text COLLATE pg_catalog."default",
    "City" text COLLATE pg_catalog."default" NOT NULL,
    "PostalCode" text COLLATE pg_catalog."default" DEFAULT ''::text,
    "Country" text COLLATE pg_catalog."default",
    "PhoneNumber1" character varying(50) COLLATE pg_catalog."default",
    "PhoneNumber2" character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT "PK_Addresses" PRIMARY KEY ("Id")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Addresses"
    OWNER to admin;

-- Index: IX_Addresses_CountryId

-- Restaurants table
CREATE TABLE IF NOT EXISTS public."Restaurants"
(
    "Id" integer NOT NULL,
    "AddressId" integer,
    "RestaurantName" character varying(100) COLLATE pg_catalog."default" NOT NULL,
    "RestaurantEmail" character varying(300) COLLATE pg_catalog."default" NOT NULL,
    "RestaurantPhoto" text COLLATE pg_catalog."default",
    "Description" text COLLATE pg_catalog."default",
    "PIB" text COLLATE pg_catalog."default",
    "IsPartner" boolean NOT NULL DEFAULT false,
    CONSTRAINT "PK_Restaurants" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Restaurants_Addresses_AddressId" FOREIGN KEY ("AddressId")
        REFERENCES public."Addresses" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Restaurants"
    OWNER to admin;

-- Index: IX_Restaurants_AddressId

CREATE UNIQUE INDEX IF NOT EXISTS "IX_Restaurants_AddressId"
    ON public."Restaurants" USING btree
    ("AddressId" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Profiles table
    CREATE TABLE IF NOT EXISTS public."Profiles"
(
    "Id" integer NOT NULL,
    "Created" timestamp without time zone NOT NULL,
    "Modified" timestamp without time zone NOT NULL,
    "AddressId" integer,
    "RestaurantId" integer,
    "ImageUrl" text COLLATE pg_catalog."default",
    "Gender" text COLLATE pg_catalog."default",
    "Description" text COLLATE pg_catalog."default",
    CONSTRAINT "PK_Profiles" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Profiles_Addresses_AddressId" FOREIGN KEY ("AddressId")
        REFERENCES public."Addresses" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT "FK_Profiles_Users_Id" FOREIGN KEY ("Id")
        REFERENCES public."Users" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT "FK_Profiles_Restaurants_RestaurantId" FOREIGN KEY ("RestaurantId")
        REFERENCES public."Restaurants" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Profiles"
    OWNER to admin;

-- Index: IX_Profiles_AddressId

CREATE UNIQUE INDEX IF NOT EXISTS "IX_Profiles_AddressId"
    ON public."Profiles" USING btree
    ("AddressId" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Index: IX_Profiles_RestaurantId

CREATE UNIQUE INDEX IF NOT EXISTS "IX_Profiles_RestaurantId"
    ON public."Profiles" USING btree
    ("RestaurantId" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Foods table

CREATE TABLE IF NOT EXISTS public."Foods"
(
    "Id" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    "OwnerId" integer,
    "Title" text COLLATE pg_catalog."default" NOT NULL,
    "Description" text COLLATE pg_catalog."default",
    "OrderCounter" integer NOT NULL DEFAULT 0,
    "IsAvailable" boolean NOT NULL DEFAULT false,
    "Created" timestamp without time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
    "Deleted" timestamp without time zone,
    "Photo" text COLLATE pg_catalog."default",
    CONSTRAINT "PK_Foods" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Foods_Users_OwnerId" FOREIGN KEY ("OwnerId")
        REFERENCES public."Users" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Foods"
    OWNER to admin;

-- Index: IX_Foods_OwnerId

CREATE INDEX IF NOT EXISTS "IX_Foods_OwnerId"
    ON public."Foods" USING btree
    ("OwnerId" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Prices table
CREATE TABLE IF NOT EXISTS public."Prices"
(
    "Id" integer NOT NULL,
    "Small" numeric,
    "Medium" numeric,
    "Large" numeric,
    "UniSize" numeric,
    CONSTRAINT "PK_Prices" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Prices_Foods_Id" FOREIGN KEY ("Id")
        REFERENCES public."Foods" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Prices"
    OWNER to admin;

--Metadata table
CREATE TABLE IF NOT EXISTS public."Metadata" (
    "Id" integer NOT NULL,
    "SmallSize" text COLLATE pg_catalog."default",
    "MediumSize" text COLLATE pg_catalog."default",
    "LargeSize" text COLLATE pg_catalog."default",
    "UniSize" text COLLATE pg_catalog."default",
    CONSTRAINT "PK_Metadata" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Metadata_Foods_Id" FOREIGN KEY ("Id")
        REFERENCES public."Foods" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

ALTER TABLE IF EXISTS public."Metadata"
    OWNER to admin;

--UserRoles table
CREATE TABLE IF NOT EXISTS public."UserRoles"
(
    "Id" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    "UserId" integer,
    "RoleId" integer,
    CONSTRAINT "PK_UserRoles" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_UserRoles_Roles_RoleId" FOREIGN KEY ("RoleId")
        REFERENCES public."Roles" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT "FK_UserRoles_Users_UserId" FOREIGN KEY ("UserId")
        REFERENCES public."Users" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."UserRoles"
    OWNER to admin;

-- Index: IX_UserRoles_RoleId

CREATE INDEX IF NOT EXISTS "IX_UserRoles_RoleId"
    ON public."UserRoles" USING btree
    ("RoleId" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Index: IX_UserRoles_UserId


CREATE INDEX IF NOT EXISTS "IX_UserRoles_UserId"
    ON public."UserRoles" USING btree
    ("UserId" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Index: IX_UserRoles_UserId_RoleId

CREATE UNIQUE INDEX IF NOT EXISTS "IX_UserRoles_UserId_RoleId"
    ON public."UserRoles" USING btree
    ("UserId" ASC NULLS LAST, "RoleId" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Photos table
CREATE TABLE IF NOT EXISTS public."Photos"
(
    "PhotoId" integer NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    "FoodId" integer,
    "Photo" text COLLATE pg_catalog."default",
    "Type" integer,
    CONSTRAINT "PK_Photos" PRIMARY KEY ("PhotoId")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Photos"
    OWNER to admin;

INSERT INTO public."Roles"(
	"Name")
	VALUES ('User');

INSERT INTO public."Roles"(
	"Name")
	VALUES ('PremiumUser');

INSERT INTO public."Roles"(
	"Name")
	VALUES ('Seller');

INSERT INTO public."Roles"(
	"Name")
	VALUES ('Admin');

-- Kupac insert query

INSERT INTO public."Addresses"(
	"Id", "Street", "Number", "City", "PostalCode", "Country", "PhoneNumber1", "PhoneNumber2")
	VALUES (1, 'Nikole Pa??i??a', 23, 'Ni??', 18000, 'Srbija', '+38161111111', '+3816222222');

INSERT INTO public."Users"(
	"Id","FirstName", "LastName", "Email", "Activated")
	VALUES (1, 'Kupac', 'Kupic', 'kupac@gmail.com', true);

INSERT INTO public."Profiles"(
	"Id", "Created", "Modified", "AddressId", "RestaurantId", "ImageUrl", "Gender", "Description")
	VALUES (1, '2022-01-15T00:00:00.000', '2022-01-15T00:00:00.000', 1, NULL, 'https://sm.ign.com/t/ign_sr/news/m/mr-robot-e/mr-robot-ending-after-season-4_qt7j.1280.jpg', 'Male', 'Lorem ipsum');

INSERT INTO public."UserRoles"(
	"UserId", "RoleId")
	VALUES (1, 1);

-- Restoran insert query

INSERT INTO public."Addresses"(
	"Id", "Street", "Number", "City", "PostalCode", "Country", "PhoneNumber1", "PhoneNumber2")
	VALUES (2, 'Nikole Pa??i??a', 24, 'Ni??', 18000, 'Srbija', '+38163333333', '+3816444444444');

INSERT INTO public."Addresses"(
	"Id", "Street", "Number", "City", "PostalCode", "Country", "PhoneNumber1", "PhoneNumber2")
	VALUES (3, 'Nikole Pa??i??a', 25, 'Ni??', 18000, 'Srbija', '+38165555555', '+38166666666');

INSERT INTO public."Restaurants"(
	"Id", "AddressId", "RestaurantName", "RestaurantEmail", "RestaurantPhoto", "Description", "IsPartner", "PIB")
	VALUES (1, 3, 'Jakarta', 'jakarta@gmail.com', 'https://indonesia.tripcanvas.co/wp-content/uploads/2016/09/3-1-outdoor-via-jojothen.jpg', 'Lorem ipsum jakarta', false, '666');

INSERT INTO public."Users"(
	"Id","FirstName", "LastName", "Email", "Activated")
	VALUES (2, 'Restoran', 'Restoranic', 'restoran@gmail.com', true);

INSERT INTO public."Profiles"(
	"Id", "Created", "Modified", "AddressId", "RestaurantId", "ImageUrl", "Gender", "Description")
	VALUES (2, '2022-01-15T00:00:00.000', '2022-01-15T00:00:00.000', 2, 1, 'https://indonesia.tripcanvas.co/wp-content/uploads/2016/09/3-1-outdoor-via-jojothen.jpg', 'Male', '');

INSERT INTO public."UserRoles"(
	"UserId", "RoleId")
	VALUES (2, 3);

-- Foods insert query

INSERT INTO public."Foods"(
	"Id", "OwnerId", "Title", "Description", "OrderCounter", "IsAvailable", "Created", "Deleted", "Photo")
	VALUES (1, 1, 'Pita sa sirom', 'Pita sa sirom i jajima', 0, true, '2022-01-15T00:00:00.000', NULL, 'https://i.ytimg.com/vi/wvRXhxNDbBA/maxresdefault.jpg');

INSERT INTO public."Prices"(
	"Id", "Small", "Medium", "Large", "UniSize")
	VALUES (1, 100, 150, 200,NULL);

INSERT INTO public."Metadata"(
	"Id", "SmallSize", "MediumSize", "LargeSize", "UniSize")
	VALUES (1, '100gr', '200gr', '300gr', NULL);

-- Photos insert query
INSERT INTO public."Photos"(
	"FoodId", "Photo", "Type")
	VALUES (1, 'https://i.ytimg.com/vi/wvRXhxNDbBA/maxresdefault.jpg', 1);
INSERT INTO public."Photos"(
	"FoodId", "Photo", "Type")
	VALUES (1, 'https://i.ytimg.com/vi/eakTCIumbJM/maxresdefault.jpg', 2);
INSERT INTO public."Photos"(
	"FoodId", "Photo", "Type")
	VALUES (2, 'https://i.ytimg.com/vi/d2QUKZHrpVM/maxresdefault.jpg', 1);
INSERT INTO public."Photos"(
	"FoodId", "Photo", "Type")
	VALUES (2, 'https://i.ytimg.com/vi/3PB_8U5sEjE/maxresdefault.jpg', 2);