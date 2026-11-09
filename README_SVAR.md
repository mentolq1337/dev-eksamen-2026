Oppgave 1A)
Har kommer en dockerfile som er multistage. Jeg har laget en Dockerfile med flere trinn. I det første trinnet brukes Maven, som kjører på en JDK, til å bygge en JAR-fil. Den resulterende filen kopieres deretter over i et mindre image som kun inneholder en JRE.
Jeg valgte denne fremgangsmåten for å redusere størrelsen på det endelige Docker-imaget. Dermed inneholder imaget kun komponentene som er nødvendige for å kjøre applikasjonen uten Maven, JDK og kildekode.
Koden for å kjøre :

docker build -t wishifai .
docker run --rm -p 9999:8080 \
  -v ~/.aws:/root/.aws:ro \
  -e AWS_REGION=eu-west-1 \
  wishifai

B)
Jeg har opprettet en github actions workflow i filen .github/workflows/deploy.yml.
Workflow utløses automatisk hver gang jeg pusher endringer til main branch. Deretter bygges et Docker image som pusher til repositoriet wishifai-tomek` i AWS ECR.
AWS-påloggingsinformasjon er lagret i GitHub Secrets AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY noe som betyr at jeg ikke trenger å inkludere den direkte i koden.
Link til selve kjøring https://github.com/mentolq1337/dev-eksamen-2026/actions/runs/42641738882

Oppgave 2A)

service_url = https://wi-55cefe15590a47ba9fd78ea6eaaf7f39.ecs.eu-west-1.on.aws

Oppgave 2B)
State er i S3-bøtten pgr301-terraform-state.
Key: wishifai/20/terraform.tfstate
Slik unngår jeg konflikt med andre studenter.

Oppgave 2C)




