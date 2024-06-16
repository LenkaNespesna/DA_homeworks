/*
V nepovinném úkolu budeme pracovat s tabulkami NETFLIX_TITLES2 a IMDB_TITLES2, navíc budeme pracovat ještě s tabulkou IMDB_RATINGS2, kde jsou uložená hodnocení k titulům IMDB.
Jsou to následující tabulky:
SELECT * FROM SCH_CZECHITA.NETFLIX_TITLES2;
SELECT * FROM SCH_CZECHITA.IMDB_TITLES2;
SELECT * FROM SCH_CZECHITA.IMDB_RATINGS2;

Tvým úkolem je spojit všechny tři tabulky pomoci INNER JOIN (chceme jen ty tituly, které mají všechny tři datasety společné). Spojení tabulek proveď následujícím postupem:

1. Nejdříve spoj IMDB_TITLES2 & IMDB_RATINGS2 (INNER JOIN) pomocí id (IMDB_TITLES2.TCONST = IMDB_RATINGS2.TCONST) do pomocné dočasné tabulky (CREATE TEMPORARY TABLE).
2. Pro napojení na Netflix potřebujeme vytvořit nový sloupeček, který upraví hodnoty ze sloupce TITLETYPE tak, abychom hodnoty mohly napojit na sloupeček TYPE z NETFLIX_TITLES2.
    --> Vytvoř v další pomocné tabulce (CREATE TEMPORARY TABLE) nový sloupeček TITLETYPE_NEW pomocí CASE WHEN.
  --> V novém sloupečku bude hodnota 'Movie' pro hodnoty TITLETYPE 'movie', 'short', 'tvMovie', 'tvShort' a hodnota 'TV Show' pro hodnoty TITLETYPE 'tvSeries', 'tvMiniSeries'.
3. Pomocnou tabulku s napojenými IMDB datasety a sloupečkem TITLETYPE a napojte pomocí INNER JOIN na NETFLIX_TITLES2 pomocí názvu, roku vydání a typu titulu a uložte do finální tabulky NETFLIX_IMDB (CREATE TABLE) 
    --> Nezapomeň na nastavení svého schématu, abys mohla vytvářet tabulky.
    --> Zachovej všechny sloupce z IMDB_TITLES2, pouze sloupce AVERAGERATING a NUMVOTES z tabulky IMDB_RATINGS2 a všechny sloupce z tabulky NETFLIX_TITLES2
        (IMDB_TITLES2.PRIMARYTITLE = NETFLIX_TITLES2.TITLE 
        AND IMDB_TITLES2.STARTYEAR = NETFLIX_TITLES2.RELEASE_YEAR
        AND IMDB_TITLES2.TITLETYPE_NEW = NETFLIX_TITLES2.TYPE)
4. Kolik je ve výsledku duplicit? (GROUP BY & HAVING). (Duplicity posuzujte tak, ze se neopakuje SHOW_ID (id Netflix datasetu)). Úkolem není duplicity smazat! Pouze napište dotaz, který vás k duplicitám dovede a napište, kolik jich tam vidíte.
________________________
Až budeš mít úkol vypracovaný, okopíruj tvůj script do Google Docs a link na něj odevzdej do úkolu jako hyperlink. 
Vkládej jen relevantní části řešení. 
Do vašeho GOOGLE DOKUMENTU vám budu řešení komentovat. V případě, že vás upozorním na chyby, je třeba vaše řešení opravit, jinak úkol nebude uznán jako splněný.

*/




CREATE OR REPLACE TEMPORARY TABLE TEMP_IMDB_TITLES2_RATINGS2 AS
SELECT  
    IMDB_TITLES2.*
    ,AVERAGERATING
    ,NUMVOTES
FROM SCH_CZECHITA.IMDB_TITLES2
    INNER JOIN SCH_CZECHITA.IMDB_RATINGS2 ON IMDB_TITLES2.TCONST = IMDB_RATINGS2.TCONST
;






SELECT *
FROM TEMP_IMDB_TITLES2_RATINGS2
;

--ALTER TABLE TEMP_IMDB_TITLES2_RATINGS2 DROP COLUMN TITLETYPE_NEW;

ALTER TABLE TEMP_IMDB_TITLES2_RATINGS2 ADD TITLETYPE_NEW VARCHAR(50);


UPDATE TEMP_IMDB_TITLES2_RATINGS2 SET TITLETYPE_NEW=CASE 
    WHEN TITLETYPE IN ('movie', 'short', 'tvMovie', 'tvShort') THEN 'Movie'
    WHEN TITLETYPE IN ('tvSeries', 'tvMiniSeries') THEN 'TV Show'
    WHEN TITLETYPE = 'video' THEN 'Video'
    END 
;

--OPRAVA, AD BOD 2:

CREATE OR REPLACE TABLE TEMP_IMDB_TITLES2_RATINGS2_TITLETYPE_NEW AS
SELECT * 
    ,CASE 
        WHEN TITLETYPE IN ('movie', 'short', 'tvMovie', 'tvShort') THEN 'Movie'
        WHEN TITLETYPE IN ('tvSeries', 'tvMiniSeries') THEN 'TV Show'
    END AS TITLETYPE_NEW
FROM TEMP_IMDB_TITLES2_RATINGS2;

SELECT *
FROM TEMP_IMDB_TITLES2_RATINGS2_TITLETYPE_NEW;

--3)

CREATE TABLE NETFLIX_IMDB AS

SELECT P.TCONST
    ,P.TITLETYPE
    ,P.PRIMARYTITLE
    ,P.ORIGINALTITLE
    ,P.ISADULT
    ,P.STARTYEAR
    ,P.ENDYEAR
    ,P.RUNTIMEMINUTES
    ,P.GENRES
    ,P.AVERAGERATING
    ,P.NUMVOTES
    ,N.SHOW_ID
    ,N.TYPE
    ,N.TITLE
    ,N.DIRECTOR
    ,N.CAST
    ,N.COUNTRY
    ,N.DATE_ADDED
    ,N.RELEASE_YEAR
    ,N.RATING
    ,N.DURATION  
FROM POMOCNA_IMDB AS P
    INNER JOIN SCH_CZECHITA.NETFLIX_TITLES2 AS N ON (P.PRIMARYTITLE = N.TITLE 
                                            AND P.STARTYEAR = N.RELEASE_YEAR
                                             AND P.TITLETYPE_NEW = N.TYPE)



--OPRAVA AD BOD 3

CREATE TABLE NETFLIX_IMDB AS

SELECT P.TCONST
    ,P.TITLETYPE
    ,P.PRIMARYTITLE
    ,P.ORIGINALTITLE
    ,P.ISADULT
    ,P.STARTYEAR
    ,P.ENDYEAR
    ,P.RUNTIMEMINUTES
    ,P.GENRES
    ,P.AVERAGERATING
    ,P.NUMVOTES
    ,N.SHOW_ID
    ,N.TYPE
    ,N.TITLE
    ,N.DIRECTOR
    ,N.CAST
    ,N.COUNTRY
    ,N.DATE_ADDED
    ,N.RELEASE_YEAR
    ,N.RATING
    ,N.DURATION  
FROM TEMP_IMDB_TITLES2_RATINGS2_TITLETYPE_NEW AS P
    INNER JOIN SCH_CZECHITA.NETFLIX_TITLES2 AS N ON (P.PRIMARYTITLE = N.TITLE 
                                            AND P.STARTYEAR = N.RELEASE_YEAR
                                             AND P.TITLETYPE_NEW = N.TYPE)
;



SELECT P.* EXCLUDE (TITLETYPE_NEW)
    ,N.* EXCLUDE (LISTED_IN,DESCRIPTION)
FROM TEMP_IMDB_TITLES2_RATINGS2_TITLETYPE_NEW AS P
    INNER JOIN SCH_CZECHITA.NETFLIX_TITLES2 AS N ON (P.PRIMARYTITLE = N.TITLE 
                                            AND P.STARTYEAR = N.RELEASE_YEAR
                                             AND P.TITLETYPE_NEW = N.TYPE)
;



SELECT *
FROM NETFLIX_IMDB
;

--Kolik je ve výsledku duplicit? (GROUP BY & HAVING). (Duplicity posuzujte tak, ze se neopakuje SHOW_ID (id Netflix datasetu)). Úkolem není duplicity smazat! Pouze napište dotaz, který vás k duplicitám dovede a napište, kolik jich tam vidíte.
--CELKEM VIDÍM 6 DUPLICIT

SELECT SHOW_ID
    ,COUNT(SHOW_ID)
FROM NETFLIX_IMDB
GROUP BY SHOW_ID
HAVING COUNT(SHOW_ID)>1
;