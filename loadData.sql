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

-- Loading in events --
/* INSERT INTO USER_EVENTS
(EVENT_ID, EVENT_CREATOR_ID, EVENT_NAME, EVENT_TAGLINE, EVENT_DESCRIPTION, EVENT_HOST,
		EVENT_TYPE, EVENT_SUBTYPE, EVENT_ADDRESS, EVENT_CITY_ID, EVENT_START_TIME, EVENT_END_TIME)
SELECT EVENT_ID, EVENT_CREATOR_ID, EVENT_NAME, EVENT_TAGLINE, EVENT_DESCRIPTION, EVENT_HOST,
		EVENT_TYPE, EVENT_SUBTYPE, EVENT_ADDRESS, EVENT_START_TIME, EVENT_END_TIME
FROM project1.PUBLIC_EVENT_INFORMATION; */

-- Loading in Users --
/* INSERT INTO USERS
SELECT USER_ID,
    min(FIRST_NAME),
    min(LAST_NAME),
    min(YEAR_OF_BIRTH),
    min(MONTH_OF_BIRTH),
    min(DAY_OF_BIRTH),
    min(GENDER)
FROM project1.PUBLIC_USER_INFORMATION
GROUP BY USER_ID;

-- CITIES SEQUENCES --
CREATE SEQUENCE citySeq START WITH 1 INCREMENT BY 1;
CREATE TRIGGER cityTrigger
    BEFORE INSERT ON CITIES
    FOR EACH ROW
    BEGIN
        SELECT citySeq.NEXTVAL INTO :NEW.CITY_ID FROM DUAL;
END;
/

-- Loading in cities --
INSERT INTO CITIES(CITY_NAME, STATE_NAME, COUNTRY_NAME)
SELECT CURRENT_CITY, CURRENT_STATE, CURRENT_COUNTRY
FROM project1.PUBLIC_USER_INFORMATION;

INSERT INTO CITIES(CITY_NAME, STATE_NAME, COUNTRY_NAME)
SELECT HOMETOWN_CITY, HOMETOWN_STATE, HOMETOWN_COUNTRY
FROM project1.PUBLIC_USER_INFORMATION;

INSERT INTO USER_CURRENT_CITIES
SELECT project1.PUBLIC_USER_INFORMATION.USER_ID, CITIES.CITY_ID
FROM project1.PUBLIC_USER_INFORMATION
INNER JOIN CITIES ON CURRENT_CITY=CITY_NAME
                    AND CURRENT_STATE=STATE_NAME
                    AND CURRENT_COUNTRY=COUNTRY_NAME;

INSERT INTO USER_HOMETOWN_CITIES
SELECT project1.PUBLIC_USER_INFORMATION.USER_ID, CITIES.CITY_ID
FROM project1.PUBLIC_USER_INFORMATION
INNER JOIN CITIES ON HOMETOWN_CITY=CITY_NAME
                    AND HOMETOWN_STATE=STATE_NAME
                    AND HOMETOWN_COUNTRY=COUNTRY_NAME;

CREATE SEQUENCE programSeq START WITH 1 INCREMENT BY 1;
CREATE TRIGGER programTrigger
    BEFORE INSERT ON PROGRAMS
    FOR EACH ROW
    BEGIN
        SELECT programSeq.NEXTVAL INTO :NEW.PROGRAM_ID FROM DUAL;
END;
/

-- Loading in Programs --
INSERT INTO PROGRAMS(INSTITUTION, CONCENTRATION, DEGREE)
SELECT INSTITUTION_NAME, PROGRAM_CONCENTRATION, PROGRAM_DEGREE
FROM project1.PUBLIC_USER_INFORMATION;

-- Loading in Education --
INSERT INTO EDUCATION
SELECT project1.PUBLIC_USER_INFORMATION.USER_ID, PROGRAMS.PROGRAM_ID, project1.PUBLIC_USER_INFORMATION.PROGRAM_YEAR
from project1.PUBLIC_USER_INFORMATION
INNER JOIN PROGRAMS ON INSTITUTION_NAME=INSTITUTION
                    AND PROGRAM_CONCENTRATION=CONCENTRATION
                    AND PROGRAM_DEGREE=DEGREE;

-- Loading in Friends --
INSERT INTO FRIENDS
SELECT * FROM project1.PUBLIC_ARE_FRIENDS;

-- Loading in Tags --
INSERT INTO TAGS
SELECT * FROM project1.PUBLIC_TAG_INFORMATION; */
