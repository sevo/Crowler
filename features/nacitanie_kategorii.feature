Feature: Nacitanie hierarchie kategorii

Bakground: 
	Given kategorie najvyssej urovne su 
		|Auto moto     |
		|Knihy         |
		|Filmy a hudba |
	And kategoria "Filmy a hudba" ma podkategorie
		|Akčné       |
		|Animované   |
		|Rozprávky   |
		|Dobrodružné |

Scenario: Prehladanie kategorii na hlavnej stranke
	Given som na uvodnej stranke
	When vidim zoznam kategorii
	Then zo stranky ziskam kategorie
	And vytvorim zoznam kategorii
	And do zoznamu zaradim kategorie
		|Auto moto     |
		|Knihy         |
		|Filmy a hudba |
	And prehladam kategorie v zozname

Scenario: Prehladavana stranka obsahuje dalsie kategorie
	Given som na stranke "Filmy a hudba"
	And kategoria "Filmy a hudba" nieje prehladana
	When vidim zoznam kategorii
	Then zo stranky ziskam zoznam kategorii
	And zaradim kategorie do zoznamu
	And ziskam rodicovsku kategoriu z rychlej navigacie #rychla navigacia = breadcrumbs
	And nastavim rodica "hlavna stranka" kategorii "Filmy a hudba"
	And oznacim kategoriu "Filmy a hudba" za prehladanu

Scenario: Prehladavana stranka neobsahuje dalsie kategorie
	Given som na stranke "Dobrodružné"
	And kategoria "Dobrodružné" nieje prehladana
	When nevidim zoznam kategorii
	And vidim zoznam produktov
	Then ziskam rodicovsku kategoriu z rychlej navigacie #rychla navigacia = breadcrumbs 
	And nastavim rodica "Filmy a hudba" kategorii "Dobrodružné"
	And oznacim kategori "Dobrodružné" za prehladanu

Scenario: Zaradenie kategorie do zoznamu
	Given mam vytvoreny zoznam kategorii
	And zoznam kategorii obsahuje
		|Filmy a hudba |
		|Dobrodružné   |
	And zoznam kategorii neobsahuje
		|Auto moto |
		|Knihy     |
		|Akčné     |
		|Animované |
		|Rozprávky |
	When som na stranke "Filmy a hudba"
	And zo stranky ziskam kategorie
		|Akčné       |
		|Animované   |
		|Rozprávky   |
		|Dobrodružné |
	Then do zoznamu kategorii zaradim kategorie
		|Akčné     |
		|Animované |
		|Rozprávky |
	And do zoznamu kategorii nezaradim kategorie
		|Dobrodružné |

Scenario: Vsetky kategorie v zozname kategorii su prehladane
	Given mam vytvoreny zoznam kategorii
	When vsetky kategorie v zozname su oznacene ako prehladane
	And ukoncim vyhladavanie kategorii
