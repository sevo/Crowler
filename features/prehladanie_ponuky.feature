Feature: Prehladanie celej ponuky produktov na stranke

Bakground: 
	Given kategorie najvyssej urovne su 
		|Auto moto |
		|Foto      |
	And kategoria "Foto" ma podkategorie
		|Akumulátory           |
		|Objektí­vy             |
		|Digitálne fotoaparáty |
	And kategoria "Digitálne fotoaparáty" obsahuje produkt "Sony Cyber-shot DSC-W350 Black"
		
Scenario: Prehladavanie kategorii v zozname kategorii na prehladanie
	Given je vytvoreny zoznam kaetgorii na prehladanie
	When kategorie "Digitálne fotoaparáty, Objektí­vy, Akumulátory, Auto moto" nemaju podkategorie
	Then prehladaj kategorie "Digitálne fotoaparáty, Objektí­vy, Akumulátory, Auto moto"

Scenario: Spracovanie kategorie ked sa da pokracovat na dalsiu stranku
	Given som na stranke "Digitálne fotoaparáty"
	And vidim zoznam produktov
	And vidim tlacidlo "Ďalej"
	When prehladam zoznam produktov
	Then kliknem na tlacidlo "Ďalej"
	And prehladam zoznam produktov

Scenario: Spracovanie kategorie ked sa neda pokracovat na dalsiu stranku
	Given som na stranke "Digitálne fotoaparáty"
	And vidim zoznam produktov
	When vidim tlacidlo "Ďalej"
	Then  prehladam zoznam produktov
	And oznacim kategoriu "Digitálne fotoaparáty" za prehladanu

Scenario: Prehladanie zoznamu produktov
	Given nachadzam sa na stranke kategorie "Digitálne fotoaparáty"
	And vidim zoznamom produktov
	When zo stranky ziskam zoznam produktov
	Then spracujem stranky produktov
	And ulozim ziskane produkty

Scenario: Spracovanie stranky produktu
	Given nachadzam sa na stranke produktu "Sony Cyber-shot DSC-W350 Black"
	And vidim zoznam obchodov
	When zo stranky ziskam zoznam nazvov obchodov a nazvov produktov
	And zoznam nazvov obchodov a nazvov produktov obsahuje:
		|kalicomp.sk       |DSCW350B.CEE8 Sony digitalne fotoaparaty cybershot|
		|tpd.sk            |Sony DSC-W350 Black                               |
		|talkive.sk        |Sony Cyber-shot DSC-W350 čierny                   |
		|domoss.sk         |fotoaparát digitálny SONY DSC-W350B Black         |
		|andreashopsala.sk |Sony DSCW350B.CEE8                                |
	Then vytvorim zoznam prepojeni medzi obchodmi a produktom "Sony Cyber-shot DSC-W350 Black"
	And ulozim prepojenia medzi obchodmi a produktom


