# Anfangs mit Terrform eine AWS Infrastruktur aufbauen mit folgenden bestandteilen:

    * Provider = AWS
    * VPC
    * subnet public
    * routing table public mit route ins internet gateway
    * internet gateway
    * route table association
    * security group mit ausgang alles, eingang über Ports: 80,22,443
    * Ec2-instance Master (Public)
    * Ec2-instance Slave  (Public) mit key
    * Ec2-instance Slave2 (Public) mit key
    * Ec2-instance Slave3 (Public) mit key

//Dies kann in einer "main.tf" datei abgespeichert werden oder mann teilt die die bereiche auf und macht für alle eine eigene .tf datei
    dafür habe ich mich entschieden somit sind die folgenden .tf dateien entstanden://

        * 1Provider.tf
        * 2netze.tf
        * 3sicherheit.tf
        * instanzen.tf
        
nach dem erstellen der tf dateien:


# aws anmeldung über shell:

im webbrowser auf die aws seite und "Command line or programmatic acces" öffnen
passende Shell auswählen und den Code im Fenster Option1 kopieren
in Visual Studio Code im ProjektOrdner ein Terminal öffnen und mit rechter Maustaste einfügen, enter
**jetzt ist VSC mit dem AWS Konto verbunden [///INFO: ca alle 30 minuten wiederholen von aws vorgegeben///]


# Terraform ausführen:

folgende befehle ausfüren um terraform das ganze bauen zu lassen

    terraform init
    terraform plan
    terraform apply


# Auf Ec2-Master anmelden:

dannach übrers terminal auf die master ec2
einloggen mit folgenden befehle:
    ssh -i ./schluessendatei.pem ec2-user@[ip der master ec2]

//achtung schluesseldatei muss auch hier (vsc) in der Ordnerstruktur sein"//

## Auf der Ec3 Master:>>

    ls -la  >>  wir sehen die Ordner:
    cd .ssh >>  wir wechseln in den Ordner .ssh
    ls      >>  wir sehen alles in dem Ordner in dem wir uns befinden zb den Schlüsselordner namens "authorize_keys"
    cat authorize_keys  >>  damit können wir uns den Inhalt der Datei anzeigen lassen.


# Schlüssel erstellen:

Nun müssen wir einen Schlüssel erstellen lassen der dann manuel auf jeder Slave-Ec2 seperat kopiert werden muss.
    ssh-keygen  >>  dass ist der key generator es werden 2 Dateien erstellt:
    id_rsa      >>  dass ist die Schlüsseldatei
    id_rsa.pub  >>  dass ist die öffentliche Schlüsseldatei besser gesagt dass Schlüsselschloss [dass muss auf die slave's]


# Schlüssel auf jede Slave kopieren:

Jetzt noch immer auf der Master-Ec2 den code mit "ctrl + shift +c" den gesamten Text aus der Datei id_rsa.pub kopieren.
    cat id_rsa.pub  >> mit cat lesen bzw öffnen wir die Datei.
****************************************************************

diesen Schlüssel wie folgt auf jeder Slave seperat manuell abspeichern in der "authorize_keys"-Datei:
    cd .ssh     >>   in den Ordner .ssh wechseln
    sudo nano authorize_keys    >>  sudo[adminrechte] nano [schreibprogramm] authorize_keys [Schlüsseldatei]
        >> öffnet mit einem Schreibprogramm [nano] die Schlüsseldatei
    code rein kopieren
    ctrl x      >>   =beenden, frage speichern  = y [yes]
    enter       >>   ausgestiegen aus nano


# Anmelden auf Master:

jetzt auf der Master-Ec2 einloggen und anmelden:
    einlog befehl:       ssh -i ./schluessendatei.pem ec2-user@[ip der master ec2]
    anmelde benutzer:   ec2-user


# Anmelden auf Slave aus der Master heraus:

von Master-Ec2 ist es jetzt mit folgende befehl möglich sich auf die einzelnen Slave-Ec2 einloggen:
    ssh ec2-user@ip (ip von der slave-ec2)

<!--Achtung!! sollten fehler auftreten muss die berechtigung  der "authorize_keys" datei auf 600 (nur user lesen und schreiben) gestellt sein -->

****************************************************************
# ausslogen von der Slave: 

 mit den Befehl:
    exit    >>  1x zurück auf die Master-Ec2
    exit    >>  2x zurück bzw ein 2. mal eingeben und man landet im Projektordner des localhosts
****************************************************************


# Auf der Master-Ec2 ansible installieren:

**dafür brauchen wir einen package manager wir nehmen den von python

    sudo dnf install python3-pip
* nun ansible istallieren:
    pip3 install ansible

* Nun weiter auf jeder Slave-Ec2, aber achtung nur von der Master-Ec2 auf die Slave-Ec2 zugreifen mit folgenden befehl:
# inventory und playbook erstellen:

Wir arbeiten auf der Master-Ec2 theoretisch egal in welchen Ordner, ich bevorzuge "ping project":

    pwd    >>>      zeig mir an wo ich mich befind ggf. vezeichniss wechseln,
*im home verzeichniss :
    mkdir ping project  >>      erstellt mir den Ordner "ping project"
    cd ping project     >>>     wechselt in den neuen Ordner

## inventory:
    nano inventory.ini  >>      schreibprogramm nano erstellt und öffet eine Datei namens "inventory.ini"
## inventory Inhalt einfügen:
    [webserver]
    slave ansible_ssh_host=18.195.49.187
    slave2 ansible_ssh_host=3.64.179.27

    [rest]
    slave3 ansible_ssh_host=3.71.85.2

///INFO: Die inventory.ini Datei ist so etwas wie ein Telefonbuch mit den Adressen:////

[webser oder rest] = hier stehen die Gruppen namen
slave (=eine Ec2 instance mit den namen slave)
        ansible_ssh_host (=eine Variable mit der die ip des slave für die ssh zugriff definiert)


##playbook 1 erstellen

Mein 1. playbook hat den namen "nginx_installieren.yaml":

    nano nginx_installieren.yaml    >>>     schreibprogramm nano erstellt und öffnet eine Datei namens "nginx_installieren.yaml"
##playbook Inhalt einfügen:
---
- hosts: webserver
  become: yes
  tasks:
  - name: Hier wollen wir nginx installieren
    dnf:
      name: nginx
      state: latest
  - name: Starte Nginx-Dienst
    service:
      name: nginx
      state: started
      enabled: yes

////INFO: Achtung in Yaml ist die formatierung mit den Tabs sehr wichtig!!/ ////

** erklährung der Zeilen 149 bis 161:**
Dieses Playbook installiert den Nginx-Webserver auf allen Hosts in der Gruppe “webserver” und stellt sicher, dass er läuft und beim Systemstart automatisch gestartet wird. 
Es verwendet das dnf-Modul zum Installieren von Paketen und das service-Modul zum Verwalten von Systemdiensten.
Bitte beachten Sie, dass Sie für die Ausführung dieses Playbooks Root-Berechtigungen benötigen, 
was durch "become: yes" erreicht wird.**

- hosts: webserver                 # Definiert die Zielhosts für dieses Playbook. In diesem Fall sind es die Hosts in der Gruppe "webserver".
  become: yes                      # Erlaubt dem Benutzer, Root-Berechtigungen zu erlangen. Dies ist notwendig für Aufgaben, die Root-Berechtigungen erfordern.
  tasks:                           # Beginnt die Liste der Aufgaben, die auf den Zielhosts ausgeführt werden sollen.
  - name:                            Hier wollen wir nginx installieren  # Gibt der Aufgabe einen Namen, der in der Ausgabe von Ansible angezeigt wird.
    dnf:                           # Ruft das dnf-Modul auf, ein Paketmanager für Fedora-basierte Systeme.
      name: nginx                  # Gibt an, dass das Paket "nginx" installiert werden soll.
      state: latest                # Stellt sicher, dass die neueste Version von nginx installiert ist.
  - name: Starte Nginx-Dienst      # Gibt der nächsten Aufgabe einen Namen.
    service:                       # Ruft das Service-Modul auf, das zum Verwalten von Systemdiensten verwendet wird.
      name: nginx                  # Gibt an, dass der Dienst "nginx" verwaltet werden soll.
      state: started               # Stellt sicher, dass der nginx-Dienst gestartet ist.
      enabled: yes                 # Stellt sicher, dass der nginx-Dienst beim Booten des Systems automatisch gestartet wird.
**************************************


##playbook 2 erstellen

Mein 2. playbook hat den namen "cowsay.yaml":

    nano cowsay.yaml    >>>     schreibprogramm nano erstellt und öffnet eine Datei namens "cowsay.yaml"
##playbook Inhalt einfügen:

---
- hosts: rest
  become: yes
  tasks:
  - name: Hier wollen wir cowsy installieren
    dnf:
      name: cowsay
      state: latest

/////hier noch einmal mit erklährung:

- hosts: rest               # Definiert die Zielhosts für dieses Playbook. In diesem Fall sind es die Hosts in der Gruppe "rest".
  become: yes               # Erlaubt dem Benutzer, Root-Berechtigungen zu erlangen. Dies ist notwendig für Aufgaben, die Root-Berechtigungen erfordern.
  tasks:                    # Beginnt die Liste der Aufgaben, die auf den Zielhosts ausgeführt werden sollen.
  - name:                     Hier wollen wir cowsay installieren  # Gibt der Aufgabe einen Namen, der in der Ausgabe von Ansible angezeigt wird.
    dnf:                    # Ruft das dnf-Modul auf, ein Paketmanager für Fedora-basierte Systeme.
      name: cowsay          # Gibt an, dass das Paket "cowsay" installiert werden soll.
      state: latest         # Stellt sicher, dass die neueste Version von cowsay installiert ist.

**Dieses Playbook installiert das Paket “cowsay” auf allen Hosts in der Gruppe “rest”. 
Es verwendet das dnf-Modul zum Installieren von Paketen. 
Bitte beachten Sie, dass Sie für die Ausführung dieses Playbooks Root-Berechtigungen benötigen, 
was durch become: yes erreicht wird. Cowsay ist ein Programm, das eine Kuh generiert, 
die den Text Ihrer Wahl sagt oder denkt.**


# Ansible ausführen

*noch immer auf der Ec2-Master, nun den folgenden ansible befehl ausführen: 
    ansible-playbook -i inventory.ini ngnix_installieren.yml
    ansible-playbook -i inventory.ini cowsay.yml


# Kontrolle der Server:

*ob jetzt alles erfolgreich installiert und ausgefürht ist.

mit der Ip[einer der Slave-Server] im webbrowser öffnen!!!

////Fehlermeldung: sollte eine Fehlermeldung im Webbrowser erscheinen, dann statt "https://" einfach "http://"ändern!!!/////

