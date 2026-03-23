## **Die Budget-Info-App**  
  
### **Überblick & Erste Schritte**  
Das Projekt "Budget-Info" bietet eine einfache und benutzerfreundliche Möglichkeit, das verbleibende (monatliche) Budget zu verwalten.  
Es kann auch als einfache To-do-Liste, Einkaufsliste usw. verwendet werden.  
  
- **Kurzbeschreibung:**  
Es handelt sich um eine Liste mit Haupt- und Untereinträgen. Die Untereinträge haben einen Status: Gelb für "in Bearbeitung" und Grün für "abgeschlossen". Wenn der Status auf Grün wechselt, wird das aktuelle Datum eingetragen. Geldtransfers können für jeden Untereintrag gespeichert werden.  
Der Zweck dieser App war es, ein bestehendes Budget für jedes Jahr (Haupteintrag) und jeden Monat (Untereintrag) zu nutzen, um Ausgaben abzuziehen und den verbleibenden Betrag am Monatsende als Ersparnis zu verwenden (das verbleibende Budget anzulegen und den Status auf Grün zu setzen).  
  
- **Mehrsprachigkeit:** Deutsch und Englisch  
  
- **Unterstützte Plattformen:** Android und Windows  
  
- **Erforderliche Berechtigungen:** Die App speichert ihre Einstellungen ausschließlich im eigenen Dokumentenverzeichnis und benötigt keine weiteren Berechtigungen. Wenn der Benutzer im Hauptmenü "Exportieren" oder "Importieren" auswählt, müssen Dateien außerhalb der App gespeichert, freigegeben und gelesen werden, um die Einstellungen zu speichern und zu synchronisieren.  
  
- **Schnellstartanleitung für Windows:** Kopieren Sie die ZIP-Datei in ein neues Verzeichnis Ihrer Wahl (z. B. C:\Tools\BudgetInfo) und extrahieren Sie sie, beispielsweise mit dem Datei-Explorer. Klicken Sie mit der rechten Maustaste auf die Datei "budget_info.exe" und wählen Sie "An Start anheften", um sie bequem über das Startmenü aufrufen zu können. Für Aktualisierungen extrahieren Sie einfach die neue ZIP-Datei zurück in dieses Verzeichnis und überschreiben die alten Dateien.  
  
- **Schnellstartanleitung für Android:**  
Solange die App noch nicht im Google Play Store verfügbar ist, speichern Sie die APK-Datei auf Ihrem Android-Tablet oder -Smartphone und installieren Sie sie mit einem Dateimanager, der über die entsprechenden Berechtigungen verfügt (z. B. die Google-App "Dateien" oder Ihren Browser).  
  
## **App-Funktionen**  
  
- **Startseite / Haupt-/Untereinträge verwalten** Die Liste besteht im Prinzip aus einem Haupteintrag für das Jahr (z.B. "2026") und Untereinträgen für "Januar", "Februar" usw.. Die Listen können natürlich auch für andere Zwecke verwendet werden. Da sowohl der Text in der Liste als auch der Dateiname zum Speichern und Laden der Einträge frei gewählt werden können, sind den Inhalten dieser Listen keine Grenzen gesetzt. Beispielsweise könnte es eine Aufgabenliste geben. Durch wiederholtes Ändern des Dateinamens der Vorschlagsliste können Sie beliebige Einträge aus verschiedenen (Template-) Listen zur Liste auf der linken Seite hinzufügen usw.  
Durch Doppelklicken auf einen Haupteintrag können Sie den Text ändern.  
Durch Doppelklicken auf einen Untereintrag öffnen Sie das Detailfenster für diesen Eintrag. Dies wird weiter unten genauer beschrieben.  
  
> **Hauptmenü:**  
> Hier wird die App-Version angezeigt  
> Ein Hilfefenster kann angezeigt werden  
> Die linke Liste kann ein-/ausgeblendet werden  
> Die rechte Liste (Vorlagen) kann ein-/ausgeblendet werden  
> Die linke Liste kann gedruckt oder als PDF gespeichert werden  
> Einstellungen und Daten als ZIP-Datei für Backup und Datenaustausch exportieren  
> Einstellungen und Daten aus einer zuvor exportierten ZIP-Datei importieren  
> Die App-Einstellungen können geändert werden  
  
### **Details**  
  
- **Export/Import**  
  
Mit der Export-/Importfunktion können Sie jederzeit ein vollständiges Backup Ihrer Daten und Einstellungen erstellen. Dies sollte regelmäßig nach Änderungen erfolgen. Die resultierende ZIP-Datei mit dem Datum kann vom Benutzer gespeichert und jederzeit wieder importiert werden. So können Sie Jahre verwalten, verschiedene Dinge ausprobieren usw. Außerdem lassen sich Daten problemlos zwischen der Windows- und der Android-App austauschen. Die App-Daten sind identisch, können sich aber von Version zu Version ändern. Verwenden Sie daher immer dieselbe Version auf allen Geräten. Die Versionsnummer finden Sie oben im Menü des Startbildschirms.  
Um alle Dateien zu löschen (auf Werkseinstellungen zurücksetzen), verwenden Sie die Android-Funktion "App-Info" und "Speicher löschen" oder den Windows-Explorer im Ordner "Dokumente" unter "BudgetInfo". Schließen Sie die App vorher.  
  
- **Zusätzliche Schaltflächen in der Startansicht**  
  
Mit der Schaltfläche "+ Kopfzeile" fügen Sie einen Haupteintrag (Kopfzeile) zur Liste hinzu. Dieser kann mit den Pfeiltasten nach oben/unten verschoben werden. Durch Doppelklicken auf eine Zeile kann der Text bearbeitet werden.  
Wenn eine Kopfzeile ausgewählt ist, kann mit der Schaltfläche "+ Subzeile" ein weiterer Untereintrag (Subzeile) hinzugefügt und mit den entsprechenden Pfeiltasten nach oben/unten verschoben werden. Durch Doppelklicken auf eine Zeile wird die Detailansicht angezeigt.  
Wenn die rechte Liste (Vorlagenliste) sichtbar ist, können Sie mit den beiden Schaltflächen "<= Kopfzeile" und "<= Subzeile" ganze Haupt- und Subzeilen oder einzelne Subzeilen aus der rechten Liste in die linke Liste kopieren. Dazu muss rechts eine Haupt- oder Subzeile ausgewählt sein. Im Falle einer Subzeile muss zusätzlich links eine Kopfzeile ausgewählt sein, um die Subzeile einzufügen.  
Das rote Minuszeichen im Kreis löscht einen gesamten Block oder eine Zeile aus einer Liste.  
Alle Änderungen werden automatisch gespeichert.  
  
– **Statusverwaltung in der Liste**  
Die Liste verfügt am Anfang der Subzeile über eine farbige Statusanzeige, die den aktuellen Status des Elements darstellt. Aktuell sind die farbigen Kreise gelb, das bedeutet "in Bearbeitung", oder grün für "abgeschlossen". Durch Klicken auf den farbigen Kreis ändert sich der Status nacheinander gelb, grün und wieder gelb. So erkennen Sie auf einen Blick, welche Zeilen bereits abgeschlossen wurden und welche noch ausstehen. Sobald alle Subzeilen einer Kopfzeile abgeschlossen sind, wird der Block beim Öffnen des Fensters zusammengeklappt angezeigt, was die Übersichtlichkeit verbessert.  
  
- **Die App-Einstellungen**  
  
Hier können Sie den App-Titel ändern.  
Hier können Sie das Startbudget für neue Subzeilen festlegen. Dieses kann in der Detailansicht jeder Subzeile geändert werden.  
Hier können Sie den Dateinamen der Liste (ohne Dateiendung) ändern (Standard: "budgetInfoList").  
Hier können Sie den Dateinamen der Vorlagenliste (ohne Dateiendung) ändern (Standard: "templateList").  
Da derzeit kein Datei-Explorer vorhanden ist, notieren Sie sich die Dateinamen oder exportieren Sie die Daten und sehen Sie in der ZIP-Datei nach, welche Dateien enthalten sind.  
Alle Änderungen werden automatisch gespeichert.  
  
**Die Detailseite**  
  
Mit der Schaltfläche "+ Buchung" wird ein Eintrag zur Liste hinzugefügt, der anschließend mit dem Stiftsymbol oder durch Doppelklicken auf die Zeile bearbeitet werden kann.  
Es gibt ein Freitextfeld und ein Betragsfeld. Diese Felder dienen hauptsächlich der Erfassung von Ausgaben oder Einnahmen. Beispiel: Mittagessen – 20,45. Kommas oder Punkte sind als Trennzeichen zulässig, Tausendertrennzeichen jedoch nicht. Ein Minuszeichen vor dem Betrag kennzeichnet Einnahmen, die zum Startbudget addiert werden. Alle anderen Ausgaben werden davon abgezogen.  
Das rote Minuszeichen im Kreis löscht diese Zeile aus der Liste.  
Alle Änderungen werden automatisch gespeichert.  
  
> **Menü Detailansicht:**  
> Der Text der Subzeile kann geändert werden.  
> Das Startbudget dieser Subzeile kann geändert werden.  
> Die Fertigstellungszeit kann geändert werden.  
> Die Detailliste kann gedruckt oder als PDF gespeichert werden.  
    
### **Sonstiges**  
Dieses Programm wird in der Hoffnung bereitgestellt, dass es nützlich sein wird, jedoch OHNE JEDE GEWÄHR, sogar ohne die implizite Gewähr der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.  
  
Copyright 2026 dieEichenApps - https://dieEichenApps.de  
  
- Häufig gestellte Fragen (FAQ)  
  
