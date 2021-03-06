-- Loading in Users --
INSERT INTO USERS
SELECT DISTINCT USER_ID,
    FIRST_NAME,
    LAST_NAME,
    YEAR_OF_BIRTH,
    MONTH_OF_BIRTH,
    DAY_OF_BIRTH,
    GENDER
FROM project1.PUBLIC_USER_INFORMATION;

-- Loading in Friends --
INSERT INTO FRIENDS
SELECT DISTINCT LEAST(USER1_ID, USER2_ID), GREATEST(USER1_ID, USER2_ID)
FROM project1.PUBLIC_ARE_FRIENDS;

-- Loading in cities --
INSERT INTO CITIES(CITY_NAME, STATE_NAME, COUNTRY_NAME)
SELECT CURRENT_CITY, CURRENT_STATE, CURRENT_COUNTRY
FROM project1.PUBLIC_USER_INFORMATION
UNION
SELECT HOMETOWN_CITY, HOMETOWN_STATE, HOMETOWN_COUNTRY
FROM project1.PUBLIC_USER_INFORMATION
UNION
SELECT EVENT_CITY, EVENT_STATE, EVENT_COUNTRY
FROM project1.PUBLIC_EVENT_INFORMATION;

-- Loading in current cities --
INSERT INTO USER_CURRENT_CITIES
SELECT DISTINCT project1.PUBLIC_USER_INFORMATION.USER_ID, CITIES.CITY_ID
FROM project1.PUBLIC_USER_INFORMATION
INNER JOIN CITIES ON CURRENT_CITY=CITY_NAME
                    AND CURRENT_STATE=STATE_NAME
                    AND CURRENT_COUNTRY=COUNTRY_NAME;

-- Loading in hometown cities --
INSERT INTO USER_HOMETOWN_CITIES
SELECT DISTINCT project1.PUBLIC_USER_INFORMATION.USER_ID, CITIES.CITY_ID
FROM project1.PUBLIC_USER_INFORMATION
INNER JOIN CITIES ON HOMETOWN_CITY=CITY_NAME
                    AND HOMETOWN_STATE=STATE_NAME
                    AND HOMETOWN_COUNTRY=COUNTRY_NAME;

-- Loading in Programs --
INSERT INTO PROGRAMS(INSTITUTION, CONCENTRATION, DEGREE)
SELECT DISTINCT INSTITUTION_NAME, PROGRAM_CONCENTRATION, PROGRAM_DEGREE
FROM project1.PUBLIC_USER_INFORMATION
WHERE INSTITUTION_NAME IS NOT NULL;

-- Loading in Education --
INSERT INTO EDUCATION
SELECT project1.PUBLIC_USER_INFORMATION.USER_ID, PROGRAMS.PROGRAM_ID, project1.PUBLIC_USER_INFORMATION.PROGRAM_YEAR
from project1.PUBLIC_USER_INFORMATION
INNER JOIN PROGRAMS ON INSTITUTION_NAME=INSTITUTION
                    AND PROGRAM_CONCENTRATION=CONCENTRATION
                    AND PROGRAM_DEGREE=DEGREE;

SET AUTOCOMMIT OFF
-- Loading in albums --
INSERT INTO ALBUMS
(ALBUM_ID, ALBUM_OWNER_ID, ALBUM_NAME, ALBUM_CREATED_TIME, ALBUM_MODIFIED_TIME, ALBUM_LINK, ALBUM_VISIBILITY, COVER_PHOTO_ID)
SELECT ALBUM_ID,
		MIN(OWNER_ID),
		MIN(ALBUM_NAME),
		MIN(ALBUM_CREATED_TIME),
		MIN(ALBUM_MODIFIED_TIME),
		MIN(ALBUM_LINK),
		MIN(ALBUM_VISIBILITY),
		MIN(COVER_PHOTO_ID)
FROM project1.PUBLIC_PHOTO_INFORMATION
GROUP BY ALBUM_ID;

-- Loading in photos --
INSERT INTO PHOTOS
(PHOTO_ID, ALBUM_ID, PHOTO_CAPTION, PHOTO_CREATED_TIME, PHOTO_MODIFIED_TIME, PHOTO_LINK)
SELECT PHOTO_ID, ALBUM_ID, PHOTO_CAPTION, PHOTO_CREATED_TIME, PHOTO_MODIFIED_TIME, PHOTO_LINK
FROM project1.PUBLIC_PHOTO_INFORMATION;
COMMIT
SET AUTOCOMMIT ON

-- SELECT temp_public.*
-- FROM project1.PUBLIC_EVENT_INFORMATION temp_public
-- FULL OUTER JOIN(
-- 		SELECT CITIES.CITY_ID as CITY_ID, CITIES.CITY_NAME
-- 		FROM CITIES
-- ) temp_cities
-- ON temp_public.EVENT_CITY = temp_cities.CITY_NAME
-- WHERE ROWNUM <= 5

-- Loading in events --
INSERT INTO USER_EVENTS
(EVENT_ID, EVENT_CREATOR_ID, EVENT_NAME, EVENT_TAGLINE, EVENT_DESCRIPTION, EVENT_HOST,
		EVENT_TYPE, EVENT_SUBTYPE, EVENT_ADDRESS, EVENT_CITY_ID, EVENT_START_TIME, EVENT_END_TIME)
SELECT final_table.EVENT_ID, final_table.EVENT_CREATOR_ID, final_table.EVENT_NAME,
		final_table.EVENT_TAGLINE, final_table.EVENT_DESCRIPTION, final_table.EVENT_HOST,
		final_table.EVENT_TYPE, final_table.EVENT_SUBTYPE, final_table.EVENT_ADDRESS,
		final_table.CITY_ID, final_table.EVENT_START_TIME, final_table.EVENT_END_TIME
FROM(
		SELECT temp_public.*, CITIES.CITY_ID as CITY_ID, CITIES.CITY_NAME
		FROM project1.PUBLIC_EVENT_INFORMATION temp_public
		INNER JOIN CITIES
		ON temp_public.EVENT_CITY = CITIES.CITY_NAME
) final_table;

-- Loading in tags --
INSERT INTO TAGS
SELECT * FROM project1.PUBLIC_TAG_INFORMATION;
