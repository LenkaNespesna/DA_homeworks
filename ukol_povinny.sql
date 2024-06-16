/*
SQL POVINNÝ

1. Použijte schéma SCH_TEROR a tabulku TEROR (platí pro všechny úlohy).

Vypište vývoj po dnech (použijte pole IDAY, IMONTH, IYEAR a funkci DATE_FROM_PARTS) v roce 2015 v zemích Iraq, Nigeria a Syria. Tabulka by měla obsahovat stát, počet útoků (EVENTID), počet zabitých obětí (rozdíl NKILL a NKILLTER), počet zabitých teroristů a počet zraněných na daný den a danou zemi. Výsledek omezte pouze na dny, kdy bylo v dané zemi provedeno alespoň 10 útoků a počet obětí byl nejméně 8 (rozdíl NKILL a NKILLTER). Sloupečky rozumně přejmenujte (alias – AS), aby bylo poznat, jaká informace se v daném sloupečku nachází. Výsledek seřaďte podle země abecedně (A-Z) a zároveň vzestupně dle datumu. 
Pozn. správnost výpočtu si ověř třeba na počtech ze Sýrie.
 screen výsledku 
 */ 
 
SELECT 
     COUNTRY_TXT AS STAT
    ,DATE_FROM_PARTS(IYEAR,IMONTH,IDAY) AS DATUM_UTOKU
   ,COUNT(EVENTID) AS POCET_UTOKU
   ,SUM(IFNULL(NKILLTER,0)) AS POCET_ZABITYCH_TERORISTU
   ,SUM(IFNULL(NKILL,0)-IFNULL(NKILLTER,0)) AS POCET_OBETI
   ,SUM(NWOUND) AS POCET_RANENYCH
   
FROM TEROR
WHERE IYEAR=2015
    AND COUNTRY_TXT IN ('Iraq','Nigeria','Syria')
GROUP BY COUNTRY_TXT, DATUM_UTOKU
HAVING POCET_UTOKU >=10 AND POCET_OBETI>=8
ORDER BY STAT ASC, DATUM_UTOKU ASC
;


 /*
 
2. Vypočítejte vzdálenost útoků od Prahy (latitude = 50.0755, longitude = 14.4378) a tuto hodnotu kategorizujte a spočítejte počet útoků (EVENTID) a počet obětí (rozdíl NKILL a NKILLTER). 
Kategorie: '0-99 km', '100-499 km', '500-999 km', '1000+ km', 'exact location unknown'. Berte v úvahu pouze roky 2014 a 2015. Seřaďte sestupně dle počtu útoků. Při kategorizaci dejte pozor, abyste skutečně pokryly všechny vzdálenosti a nestalo se vám, že na přelomu kategorií vám bude chybět jeden kilometr (nebo 1 metr 😊), např. hodnota 499,5 má spadat do kategorie '100-499 km' - je nežádoucí, aby spadla do 'exact location unknown'.
 screen výsledku 
 */




SELECT COUNT(EVENTID) AS POCET_UTOKU
    ,SUM(IFNULL(NKILL,0)-IFNULL(NKILLTER,0)) AS POCET_OBETI
    ,CASE
        WHEN (HAVERSINE(50.0755,14.4378,LATITUDE,LONGITUDE)) >=1000 THEN '1000+ km'
        WHEN HAVERSINE(50.0755,14.4378,LATITUDE,LONGITUDE)>=500 THEN '500-999 km'
        WHEN HAVERSINE(50.0755,14.4378,LATITUDE,LONGITUDE)>=100 THEN '100-499 km'
        WHEN HAVERSINE(50.0755,14.4378,LATITUDE,LONGITUDE)>=0 THEN '0-99 km'
    ELSE 'exact location unknown'
    END AS KATEGORIE_VZDALENOSTI 
FROM TEROR
WHERE IYEAR IN (2014,2015)
GROUP BY KATEGORIE_VZDALENOSTI
ORDER BY POCET_UTOKU DESC
;


 
/*
 
3. Zobrazte 15 útoků s největším počtem mrtvých (NKILL) ze zemí Iraq, Afghanistan, Pakistan, Nigeria. Z výsledku odfiltrujte targtype1_txt ‘Private Citizens & Property’, pro gname ‘Taliban’ tato výjimka neplatí (u této skupiny vypište i útoky s targtype1_txt ‘Private Citizens & Property’). Vypište pouze sloupečky eventid, iyear, country_txt, city, attacktype1_txt, targtype1_txt, gname, weaptype1_txt, nkill. Vyřešte bez použití UNION.
 screen výsledku 
________________________
Pro řešení používejte tabulku TEROR, kterou znáte z lekcí. Úkoly odevzdávejte do složky se svým jménem pro povinné úkoly, ne k sobě na disk. Vaše řešení odevzdejte formou GOOGLE DOKUMENTU. Odevzdávejte link na GOOGLE DOKUMENT, ve kterém bude vaše řešení. Do vašeho GOOGLE DOKUMENTU vám budu úkoly komentovat. V případě, že vás upozorním na chyby, je třeba vaše řešení opravit, jinak úkol nebude uznán jako splněný.
________________________
*/




SELECT EVENTID
    ,IYEAR
    ,COUNTRY_TXT
    ,CITY
    ,ATTACKTYPE1_TXT
    ,TARGTYPE1_TXT
    ,GNAME
    ,WEAPTYPE1_TXT
    ,NKILL
    
FROM TEROR
WHERE IFF(GNAME='Taliban',(COUNTRY_TXT IN ('Iraq', 'Afghanistan', 'Pakistan', 'Nigeria')),(TARGTYPE1_TXT <> 'Private Citizens & Property') AND COUNTRY_TXT IN ('Iraq', 'Afghanistan', 'Pakistan', 'Nigeria'))
ORDER BY NKILL DESC NULLS LAST
LIMIT 15
;



SELECT EVENTID
    ,IYEAR
    ,COUNTRY_TXT
    ,CITY
    ,ATTACKTYPE1_TXT
    ,TARGTYPE1_TXT
    ,GNAME
    ,WEAPTYPE1_TXT
    ,NKILL
    
FROM TEROR
WHERE COUNTRY_TXT IN ('Iraq', 'Afghanistan', 'Pakistan', 'Nigeria') AND ((TARGTYPE1_TXT <> 'Private Citizens & Property') OR (GNAME='Taliban'))
ORDER BY NKILL DESC NULLS LAST
LIMIT 15
;




