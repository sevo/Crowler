Feature: Vytvorenie zoznamu obchodov, ktore stranka podporuje
  
  Scenario: Spracovanie zoznamu obchodov ked sa da pokracovat na dalsiu stranku
    Given nachadzam sa v sekcii "Obchody"
    And vidim zoznam obchodov
    And vidim tlacidlo "Ďalej"
    When spracujem detaily o obchodoch v zozname
    And kliknem na tlacidlo "Ďalej"
    Then nachadzam sa v sekcii "Obchody"
    And vidim iny zoznam obchodov
    And spracujem detaily o obchodoch v zozname

  Scenario: Spracovanie zoznamu obchodov ked sa neda pokracovat na dalsiu stranku
    Given nachadzam sa v sekcii "Obchody"
    And vidim zoznam obchodov
    And nevidim tlacidlo "Ďalej"
    Then spracujem detaily o obchodoch v zozname

  Scenario: Spracovanie detailov o obchode
    Given som na stranke obchodu "alza.sk"
    When ziskam zo stranky meno obchodu "alza.sk" a URL obchodu "http://www.alza.sk"
    Then ulozim informacie o obchode

