""" Úkol 2
V tomto úkolu budeš pracovat se souborem netflix_titles.tsv. 
Jedná se o textový soubor ve formátu TSV (Tabulator Separated Values), 
kde jsou jako oddělovače sloupců použity tabulátory (“\t”). 

Tvým úkolem bude soubor načíst, vytáhnout z něj některé údaje a uložit je ve formátu JSON.

Z každého řádku nás budou zajímat tyto údaje: 
PRIMARYTITLE (název),
DIRECTOR (režisér/režiséři),
CAST (herci),
GENRES (seznam žánrů),
STARTYEAR (rok vydani).

Údaje o filmech převeď do seznamu, 
kde bude každý film reprezentován jako slovník obsahující následující položky:
- title (název filmu),
- directors (seznam všech režisérů nebo prázdný seznam, pokud není režisér uveden),
- cast (seznam všech herců nebo prázdný seznam, pokud není žádný herec uveden),
- genres (seznam všech žánrů, do kterých byl film zařazen),
- decade (dekáda, ve které film vznikl).

Herci a režiséři jsou v souboru netflix_titles.tsv zadání jako jeden řetězec 
a jednotlivé hodnoty jsou oddělené čárkami (např: “Morgan Freeman, Monica Potter, Michael Wincott”). 
Ve formátu JSON použij pro větší přehlednost seznam, aby bylo například vidět, 
kolik herců nebo režisérů v seznamu je (např. [“Morgan Freeman”, “Monica Potter”, “Michael Wincott”]).
Dekáda je vždy první rok desetiletí, např. rok 1987 patří do dekády 1980 a rok 2017 do dekády 2010.
Vytvořený seznam slovníků ulož do souboru movies.json. Svůj program odevzdej pod názvem prijmeni_jmeno_2.py.
Dodrž prosím následující pravidla:
Může se stát, že film neobsahuje údaj o režisérech nebo hercích (ostatní data jsou vždy uvedená). 
Pokud není uveden žádný režisér nebo herec, daná položka musí být prázdný seznam [], 
nikoli seznam s řetězcem o nulové délce [“”]. Zkontrolovat to můžeš u seriálu Power Rangers Turbo, 
který je v souboru jako třetí (při počítání od jedničky).
Funkce json.dump (jakož i json.dumps) berou volitelný parametr indent, kterým můžete nastavit počet mezer, 
kterými má být odsazený každý vnořený řádek. Tím lze docílit hezky zformátovaného výstupu, 
jaký vidíte na příkladu níže (tam jsou použity 4 mezery). """

import json

full_list=[] 

with open('domaci_ukol/netflix_titles.tsv', 'r', encoding='utf-8') as file_in:
     for line in file_in:
        cleaned_line = line.strip().split('\t')  # Split by tab
        full_list.append(cleaned_line) 

#prvni člen v seznamu jsou názvy kategorií (klíče)

category=(full_list[0])
#delka_seznamu=(len(full_list))

searched_category=['PRIMARYTITLE','DIRECTOR','CAST','GENRES','STARTYEAR']

#zjistím indexy hledaných kategorií
position_list=[]
for item in searched_category:
    if item in category:
        position=category.index(item)
        position_list.append(position)
print(position_list)
#position_list = [category.index(item) for item in searched_category]
    
#zadané klíče slovníku

key_list=['title','directors', 'cast','genres','decade']

final_film_list=[]

for j in range(1, len(full_list)): #procházím řádky načteného výchozího seznamu filmů
    film = {}
    for i in range(len(key_list)):  #v každém řádku vybírám hodnoty podle klíčů
        value = full_list[j][position_list[i]]
        if value != "":
            film[key_list[i]] = [value]
        else:   
             film[key_list[i]] = []   #když není hodnota, vlož prázdný seznam
    
        film[key_list[4]] = [value[0:3]+'0']  #rok nahradím dekádou, do které daný rok patří      
    
    final_film_list.append(film)


print(final_film_list)


with open ('domaci_ukol/kontrola_ukol_2.json', 'w', encoding='utf-8') as out_file:
    json.dump(final_film_list, out_file, indent=4, ensure_ascii=False, sort_keys=True)