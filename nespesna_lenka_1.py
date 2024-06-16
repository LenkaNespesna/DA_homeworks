""" Napiš skript v Pythonu, který otevře soubor alice.txt (Alice’s Adventures in Wonderland od Lewise Carrolla) 
- ke stažení v [1] a spočítá četnost (počet výskytů) všech znaků. 

Velká písmena převeď za malá a ignoruj mezery a znaky nového řádku 
(ostatní znaky jako čárky nebo závorky zařaď do výsledku).

Jako výstup musí program vytvořit soubor ukol1_output.json. 
Vzorový výstup najdeš v souboru ukol1_output_vzor.json. 

Dodrž prosím následující pravidla
soubor ukol1_output.json je ve formátu JSON,
obsahuje slovník, kde klíče jsou znaky a hodnoty jejich četnost,
volitelně: slovník je seřazen podle klíčů

Jako řešení úkolu odevzdej program pojmenovaný jako prijmeni_jmeno_1.py. Soubor uploaduj na Google drive (nebo jiné úložiště), vytvoř na něj odkaz viditelný pro všechny a tento odkaz odevzdej přes moje.czechitas.cz.
Příklad výsledku
Pokud by soubor alice.txt obsahoval jen větu: 
 	‘datova akademie se mi moc libila’

dostali bychom následující výstup:

{
    "a": 5,
    "b": 1,
    "c": 1,
    "d": 2,
    "e": 3,
    "i": 4,
    "k": 1,
    "l": 2,
    "m": 3,
    "o": 2,
    "s": 1,
    "t": 1,
    "v": 1
}
"""

import json 
text=[]

# načtu text z .txt, každý řádek očistím od mezer, tabulátorů, enterů, a uložím do seznamu
with open ('domaci_ukol/alice.txt', 'r', encoding='utf-8') as file_in:
    for line in file_in:
        cleaned_line = ''.join(line.split())
        text.append(cleaned_line.lower())
print(text)


#procházím text seznam po znacích, když znak není v dictionary, vložím ho tam jako key, a přiřadím hodnotu value 1
#když už v dictionary je, k value přičtu 1

dictionary = {}

for item in sorted(text): #sorted, aby byl slovník seřazený podle abecedy
    for i in range(0,len(item)):
    
        character=item[i]
        if character not in dictionary:
            dictionary[character]=1
       
    
        else:
            dictionary[character]+=1
            
        i=i+1



#vyexportuju json s dictionary

with open ('domaci_ukol/kontrola_ukol_1.json', 'w', encoding='utf-8') as out_file:
    json.dump(dictionary, out_file, indent=4, ensure_ascii=False, sort_keys=True)