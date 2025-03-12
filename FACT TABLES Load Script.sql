--FCT_PERSON_ROLE TABLE LOAD

INSERT INTO FCT_PERSON_ROLE (MOVIES_SK, PERSON_SK, ROLE_SK, SERIES_SK, CHARACTERS, ORDERING, DI_JOB_ID, DI_LOAD_DT)
SELECT 
	1 AS MOVIES_SK,
    person.PERSON_SK,         -- Person ID (actor/director)
    role.ROLE_SK,             -- Role ID (actor, director, etc.)
	series.SERIES_SK,         -- Series ID (if applicable)     
    tp.characters,            -- Character played by the person
    tp.ordering,              -- Ordering of the person in the credits
    'DI_JOB_001',             -- Example job ID
    CURRENT_DATE()              -- Current load date
FROM STG_TITLE_PRINCIPALS tp
JOIN DIM_SERIES series ON LOWER(trim(tp.tconst)) = lower(trim(series.SRS_TITLE_ID))
JOIN DIM_PERSON person ON lower(trim(tp.nconst)) = lower(trim(person.PERSON_ID))
JOIN DIM_ROLE role ON lower(trim(tp.category)) = lower(trim(role.ROLE_NAME))



INSERT INTO FCT_PERSON_ROLE (MOVIES_SK, PERSON_SK, ROLE_SK, SERIES_SK, CHARACTERS, ORDERING, DI_JOB_ID, DI_LOAD_DT)
SELECT 
	movies.MOVIES_SK, 
    person.PERSON_SK,         -- Person ID (actor/director)
    role.ROLE_SK,             -- Role ID (actor, director, etc.)
    1 AS SERIES_SK,
    tp.characters,            -- Character played by the person
    tp.ordering,              -- Ordering of the person in the credits
    'DI_JOB_001',             -- Example job ID
    CURRENT_DATE()              -- Current load date
FROM STG_TITLE_PRINCIPALS tp
JOIN DIM_PERSON person ON lower(trim(tp.nconst)) = lower(trim(person.PERSON_ID))
JOIN DIM_ROLE role ON lower(trim(tp.category)) = lower(trim(role.ROLE_NAME))
JOIN DIM_MOVIES movies ON LOWER(trim(tp.tconst)) = lower(trim(movies.MOV_TITLE_ID))


-- FCT_TITLE_DETAILS TABLE LOAD


INSERT INTO FCT_Title_Details (
    MOVIES_SK,
    LANGUAGE_SK,
    COUNTRY_SK,
    SERIES_SK,
    IS_ADULT,
    START_YEAR,
    END_YEAR,
    NUM_VOTES,
    AVG_RATING,
    DI_JOB_ID,
    DI_LOAD_DT
)SELECT
    NVL(movies.MOVIES_SK, 1) AS MOVIES_SK,
    lang.LANGUAGE_SK,
    country.COUNTRY_SK,
    NVL(series.SERIES_SK, 1) AS SERIES_SK,
    stb.isAdult AS IS_ADULT,
    stb.startYear AS START_YEAR,
    stb.endYear AS END_YEAR,
    ratings.numVotes AS NUM_VOTES,
    ratings.averageRating AS AVG_RATING, -- Corrected alias to match fact table column
    'DI_JOB_001' AS DI_JOB_ID,
    CURRENT_DATE() AS DI_LOAD_DT
FROM STG_TITLE_BASICS stb
LEFT JOIN DIM_MOVIES movies ON LOWER(TRIM(stb.tconst)) = LOWER(TRIM(movies.MOV_TITLE_ID))
JOIN STG_TITLE_AKAS sta ON LOWER(TRIM(sta.TITLEID)) = LOWER(TRIM(stb.tconst))
JOIN DIM_LANGUAGE lang ON LOWER(TRIM(sta.LANGUAGE)) = LOWER(TRIM(lang.LANGUAGE_code))
JOIN DIM_COUNTRY country ON LOWER(TRIM(sta.REGION)) = LOWER(TRIM(country.COUNTRY_CODE))
LEFT JOIN DIM_SERIES series ON LOWER(TRIM(stb.tconst)) = LOWER(TRIM(series.SRS_TITLE_ID))
LEFT JOIN STG_TITLE_RATINGS ratings ON LOWER(TRIM(stb.tconst)) = LOWER(TRIM(ratings.tconst))
WHERE movies.MOVIES_SK IS not NULL or SERIES_SK IS not NULL 

 





