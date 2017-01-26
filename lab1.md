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

Du borde få en användare i databasen som heter postgres. och kan
använda den för att skapa en databas. Du kan skapa en databas med
hjälp utav `createdb mycooldatabasename`. 

2) Installera Go och kör ett hello world exempel.

3) Installera NGINX och kör ett hello world exempel.

4) Använd git för att clona
"git@gitlab.ida.liu.se:large-scale-dev/ci-sample-project.git" och följ
instruktionerna för att kompilera och köra applikationen.

Du har nu lyckats köra applikationen och få den att fungera. I nästa
del kommer du att automatisera att dra ner repot ifrån GitHub, testa
alla delar och skicka mail/slack-meddelande.

i todo.go så kommer du behöva uppdatera vissa konstanter. De listas i
början av filen och kallas databaseHost och databaseName. Om du skapar
en databas med namnet X så ska du sätta databaseName till "X". Du får
också se till att rikta om databaseHost till där du kör din
applikation. Gissningsvis kommer detta vara på din egen dator och då
kan du ge den värdet "localhost".

För att sätta upp tabellerna i din databas så finns `schema.sql` i
root mappen. Den kommer att definiera alla tabeller som behövs och du
kan köra `psql -f schema.sql db_name` på kommandoraden för att sätta
upp din databas.

När du installerar go så kommer du troligtvis behöva trixa lite med
din GOPATH environment variable. Enklast är att köra på ett
unix-liknande system och lägga in följande i `~/.bashrc`

```
export GOPATH="/path/to/git/repository";
export PATH="$PATH:$GOPATH/bin"
```

I din GOPATH så kommer du att behöva tre stycken mappar. bin, src och
pkg. Dessa kan du enkelt skapa med `mkdir -p $GOPATH/bin $GOPATH/src
$GOPATH/pkg`

Ett annat problem du kan stöta på är att du inte kan få ner den
dependency som behövs för projektet. Om du får felmeddelandet "no
install location for directory .... outside GOPATH" så behöver du
flytta dina filer in i ett packet (en folder) inuti $GOPATH/src och gå
in i det packetet och köra `go get`. Exempelvis:

```
mkdir -p src/main
cp todo.go src/main
cd src/main
go get
```

Se filen [insert file here] för ett exempel på hur din NGINX
konfiguration kan se ut. Den borde finnas som filen
`/etc/nginx/nginx.conf`. Det viktiga är att den pekar om trafik ifrån
port 80 (HTTP) till en annan port som definieras av din applikation (i
detta fall 8080).

5) Installera Jenkins och kör ett hello world exempel.

Installation av Jenkins är väldigt enkelt, sudo pacman -S jenkins bör
fungera utan problem. Sedan kör du igång jenkins på lämpligt sätt och
därfeter är den nåbar på port 8090.

En viktig detalj om man kör Jenkins på en lite svagare CPU, till exempel
på en Raspberry Pi 2, är att det krävs en del tålamod för att låta Jenkins
köra igång. Efter "INFO: Beginning extraction from war file" kan det dröja ca
5 minuter innan något händer efter det. Tillfälle för :coffee:

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