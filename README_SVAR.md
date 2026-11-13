Kandidatnummer : 20
Oppgave 1A)
Har kommer en dockerfile som er multistage. Jeg har laget en Dockerfile med flere trinn. I det første trinnet brukes Maven, som kjører på en JDK, til å bygge en JAR-fil. Den resulterende filen kopieres deretter over i et mindre image som kun inneholder en JRE.
Jeg valgte denne fremgangsmåten for å redusere størrelsen på det endelige Docker-imaget. Dermed inneholder imaget kun komponentene som er nødvendige for å kjøre applikasjonen uten Maven, JDK og kildekode.
Koden for å kjøre :

docker build -t wishifai .
docker run --rm -p 9999:8080 \
  -v ~/.aws:/root/.aws:ro \
  -e AWS_REGION=eu-west-1 \
  wishifai

Oppgave 1B)
Jeg har opprettet en github actions workflow i filen .github/workflows/deploy.yml.
Workflow utløses automatisk hver gang jeg pusher endringer til main branch. Deretter bygges et Docker image som pusher til repositoriet wishifai-tomek` i AWS ECR.
AWS-påloggingsinformasjon er lagret i GitHub Secrets AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY noe som betyr at jeg ikke trenger å inkludere den direkte i koden.
Link til selve kjøring https://github.com/mentolq1337/dev-eksamen-2026/actions/runs/42641738882

Oppgave 2A)
I infra har jeg satt opp ECS og S3 for bilder. Bucketen heter wishifai-uploads-20. Task role heter wishifai-task-role-20. De to andre rollene har jeg hentet fra oppgaveteksten. Terraform setter automatisk navnet på bucketen som S3_BUCKET så appen kan lagre bildene der. Appen bruker et image fra ECR. Taggen settes med image_tag.

URL = https://wi-55cefe15590a47ba9fd78ea6eaaf7f39.ecs.eu-west-1.on.aws

Oppgave 2B)
State er i S3 pgr301-terraform-state.
Key: wishifai/20/terraform.tfstate
Slik unngår jeg konflikt med andre.

Oppgave 2C)
Terraform ligger i samme workflow som build og bruker needs: build for å vente til alt er up. På den måten blir imaget bygget og pushet først før terraform apply kjører i gang med commit SHA som image_tag. Hvis de to hadde kjørt samtidig kune ECS risikere å prøve å hente et bilde som ikke finnes i ECR. I tillegg har jeg lagt inn terraform fmt -check så pipelinen tryner med en gang hvis koden ikke er riktig formatert.
Link til kjøring : https://github.com/mentolq1337/dev-eksamen-2026/actions/runs/42665704615

Oppgave 3
Har ikke oppgave 3 

Oppgave 4

Hvis en chatbot i en nettbutikk gir feil produktbeskrivelse, er konsekvensene som regel ganske små. Da holder det med automatiske tester som fungerer som en enkel kvalitetskontroll. Men i helsevesenet hvor en lege kan få feil opplysninger om en pasients behandling eller medisiner kan feilen få ekstremt alvorlige konsekvenser. Derfor kreves det mye strengere tester og menneskelig overvåking som kan gripe inn hvis noe går galt.

Når vi tester er det ikke nok å bare sjekke om systemet er raskt og gir riktig svar. Vi må også tenke på kvalitet og sikkerhet. Ved lav risiko trenger vi ikke å følge med på alt hele tiden. Men når alt må stemme med dataene er det viktig med jevnlige tester og overvåking. Vi bør ikke bare sjekke ett bestemt resultat. Vi må også se om svaret er trygt og passer til oppgaven. Tester som assert er nyttige, men de er ikke nok alene. Vi må også sjekke om AI faktisk gir riktig informasjon. Det samme bildet av et rom kan for eksempel gi ulike lister med ting så resultatet er ikke alltid likt.

En API-health check viser ikke om forslagene er gode. Den viser bare om tjenesten svarte. Derfor må vi også sjekke Bedrock og se om lista inneholder noen ting eller om den er tom. Hvis tokenbruken plutselig endrer seg kan det være et tegn på at prompten er endret. I denne oppgaven trenger vi kanskje ikke å overvåke alt hele tiden men overvåking er fortsatt viktig. Uten den kan vi overse feil og reagere for sent.

Når vi legger ut en ny versjon av koden for Wishfai, kan vi også ha endret modellen og prompten. Hvert bilde i ECR har en SHA-tag. Da kan vi se hvilken versjon og prompt som ligger i ECS. Hvis prompten ikke fungerer som den skal, kan jeg gå tilbake til den forrige SHA versjonen. Da slipper jeg å fikse alt med en gang. Det er også viktig å huske at en ny modell kan endre hvordan appen fungerer selv om koden ikke er endret. Terraform kjøres etter byggingen fordi ECS bruker SHA taggen og den må allerede finnes i ECR.

Derfor kan det oppstå problemer hvis vi stoler helt på AI uten å forstå eller kontrollere svarene den gir. Vi bør bruke AI som hjelp, men ikke stole bare på den. Den kan være nyttig men vi må fortsatt følge med på hva den faktisk gjør.