# Scheduler 2.0
- Main program composing schedule from given subject list. Implementation in SWI-Prolog.
- User interface of Prolog scheduler parsing data from information system of Charles University. Written in PHP7.

##### Sample:
```
+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+
| D\H  |  1   |  2   |  3   |  4   |  5   |  6   |  7   |  8   |  9   |  10  |  11  |  12  |  13  |  14  |  15  |  16  |
+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+
| mon  |      |      | NPG  | NPG  | cNPG | cNPG | cLA  | cLA  | Unix | Unix |      |  AJ  |  AJ  |      |      |      |
+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+
| tue  |      |      | ADS  | ADS  | Arch | Arch |cUnix |cUnix |      |      | cPGM | cPGM |  FS  |  FS  |      |      |
+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+
| wed  |      |  Tv  |  Tv  |  Tv  |  Tv  |      | cMA  | cMA  | PGM  | PGM  |      |      |      |      |      |      |
+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+
| thu  |      |      |  LA  |  LA  | cKG  | cKG  | cADS | cADS |      |      |  NJ  |  NJ  | IPS  | IPS  | IPS  |      |
+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+
| fri  |      |      |  KG  |  KG  |      |      |  MA  |  MA  |      |      |      |      |      |      |      |      |
+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+------+
```

- [Interface documentation](https://htmlpreview.github.io/?http://github.com/marek094/Schedule/blob/master/doc_interface.html)
- [Developer documentation](https://htmlpreview.github.io/?http://github.com/marek094/Schedule/blob/master/doc.html) 

## Scheduler 3.0
##### Plans:
- replace Prolog-part with faster algorithm written in C.
- web (drag and drop?) interface
