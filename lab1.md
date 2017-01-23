Verktyg som används och användare borde bli van vid att använda efter slutförd tutorial:

	Docker
	Jenkins
	Git
	Chef
	PostgreSQL
	Go (hela toolchainen)
	NGINX

# Mål

Slutmålet med uppgiften är att ha ett github repository som använder
sig av continuous integration på ett sådant sätt att när en utvecklare
pushar upp en ändring så kommer systemet automatiskt att byggas och
testas. Systemet kommer att byggas och testas med hjälp av verktyget
Jenkins. Ett krav är att Jenkins måste använda sig utav Docker. Till
sist så kommer utvecklare att notifieras med resultat utav tester
antingen via email eller Slack (eller annan kanal).

# Steg 0 - Installation

Det första som behövs göras är att sätta upp de olika verktyg som
används. De verktyg som ska installeras är:

/** Needs some links to actual webpages */

	 - [Docker](https://docs.docker.com/engine/installation/linux/archlinux/)
	 - [Jenkins](https://jenkins.io/download/)
	 - [Git](https://git-scm.com/) (installerad version på piff: 2.11.0)
	 - [Chef](https://www.chef.io/) 
	 - [PostgreSQL](https://www.postgresql.org/) (installerad version på piff: 9.6.1)
	 - [Go](https://wiki.archlinux.org/index.php/Go)
	 - [NGINX](http://nginx.org/) (installerad version på piff: 1.10.2 på grund av installerat paketet nginx istället för nginx-mainline. Om senare version krävs, byt till nginx-mainline)

Notera att inte all mjukvara behöver vara på en och samma dator men
det kan vara praktiskt om det är det, ur ett utvecklingsperspektiv.
Datorn som vi hoppas använda är en Raspberry Pi 2 vid namn piff.
Denna går att nå via beer.henziger.com och kör Arch linux med linuxkärnan 4.4.43-1-ARCH.

Den applikation som används kommer att ha följande struktur:

/** Import image from git repo */

(NGINX <-> Go <-> PostgreSQL)

När projektet sedan testas så bör flödet se ut såhär:

/** Make an image for this */

GitHub --> Jenkins Runner
Jenkins Runner --> A
A === NGINX (as docker image) <-> Go (as docker image) <-> PostgreSQL (as docker image)
A === tester för ovan och dessutom en jenkins slav
Jenkins Runner --> Email / Slack-meddelande

För ett högre betyg krävs även att Chef används för att deploy:a, dvs.
"Jenkins Runner --> Chef" läggs till ovan.

Den rekommenderade ordningen att lösa delar i är:

1) Installera PostgreSQL och kör ett hello world exempel.

2) Installera Go och kör ett hello world exempel.

3) Installera NGINX och kör ett hello world exempel.

4) Använd git för att clona
"git@gitlab.ida.liu.se:large-scale-dev/ci-sample-project.git" och följ
instruktionerna för att kompilera och köra applikationen.

Du har nu lyckats köra applikationen och få den att fungera. I nästa
del kommer du att automatisera att dra ner repot ifrån GitHub, testa
alla delar och skicka mail/slack-meddelande.

5) Installera Jenkins och kör ett hello world exempel.

6) Sätt upp Jenkins att dra ner dit repo då en ändring sker (denna
instans av Jenkins kommer att kallas för master).

7) Sätt upp en Jenkins slav och kör ett hello world exempel.

8) Låt Jenkins master skicka vidare test till Jenkins slaven.

9) Skicka resultat ifrån Jenkins slav till email.

Nu finns en runner som klarar av att göra alla delar som behövs. Nu
krävs bara att processen ska containeriseras. Detta betyder att
Jenkins slaven behöver använda sig utav docker när den testar
allting. I nästa del kommer vi att installera docker och få Jenkins
att använda sig utav det.

10) Installera docker och skapa en hello world bild.

11) Skapa en bild för att köra applikationen

12) Skapa en bild för att köra nginx

13) Skapa en bild för att köra postgresql

14) Släng in alla bilderna i Jenkins slaven.