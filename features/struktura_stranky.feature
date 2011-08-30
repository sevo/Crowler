Feature: Struktura stranky
  Opis ako sa da po stranke pohybovat a ake su jej casti

  Scenario: Uvodna stranka
    When som na uvodnej stranke
    Then vidim zoznam kategorii

  Scenario Outline: Otvorenie stranky kategorie
    Given som na uvodnej stranke
    When kliknem na <kategoria> v zozname kategorii
    Then vidim stranku kategorie <kategoria>

    Scenarios: kategorie
    |kategoria           |
    |Auto, foto, video   |
    |Auto moto           |
    |Chovateľské potreby |
    |Darčekové predmety  |
    |Detský tovar        |
    |Mix                 |
    
  Scenario Outline: Stranka kategorie
    When som na stranke kategorie <kategoria>
    Then pod nadpisom "Najprezeranejšie kategórie v Audio, foto, video" vidim zoznam kategorii
    And pod nadpisom "Ostatné kategórie" vidim zoznam kategorii

    Scenarios: kategorie
    |kategoria           |
    |Auto, foto, video   |
    |Auto moto           |
    |Chovateľské potreby |
    |Darčekové predmety  |
    |Detský tovar        |
    |Mix                 |

  Scenario: Stranka kategorii obsahuje odkaz na stranku so zoznamom produktov
    Given som na stranke kategorie "Auto, foto, video"
    When kliknem na odkaz "Digitálne fotoaparáty kompaktné"
    Then vidim zoznam produktov

  Scenario: Stranka kategorii obsahuje odkaz na dalsiu stranku kategorii
    Given som na stranke kategorie "Auto, foto, video"
    When kliknem na odkaz "Digitálne fotoaparáty"
    Then som na strane kategorie "Digitálne fotoaparáty"
    And nevidim zoznam produktov
    And pod nadpisom "Najprezeranejšie kategórie v Digitálne fotoaparáty" vidim zoznam kategorii
    And pod nadpisom "Ostatné kategórie" vidim zoznam kategorii

  Scenario: Zobrazenie dalsich produktov
    Given som na stranke kategorie "Digitálne fotoaparáty kompaktné"
    And vidim zoznam produktov
    And vidim odkaz "Ďalej"
    When kliknem na tlačidlo "Ďalej"
    Then som na stranke kategorie "Digitálne fotoaparáty kompaktné"
    And vidim zoznam inych produktov
    
  Scenario: Otvorenie stranky produktu
    Given som na stranke "Digitálne fotoaparáty kompaktné"
    And vidim zoznam produktov
    When kliknem na odkaz "Sony Cyber-shot DSC-W350 Black"
    Then som na stranke produktu "Sony Cyber-shot DSC-W350 Black"
    Then vidim zoznam obchodov

  Scenario: Zobrazenie sekcie "Obchody"
    Given som na uvodnej stranke
    When kliknem na zalozku "Obchody"
    Then nachadzam sa v sekcii "Obchody"
    And vidim zoznam obchodov

  Scenario: Otvorenie stranky obchodu
    Given som v sekcii "Obchody"
    When kliknem na "alza.sk"
    Then som na stranke obchodu "alza.sk"
    Then vidim detaily o obchode "alza.sk"
