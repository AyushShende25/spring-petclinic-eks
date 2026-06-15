./mvnw -DskipTests clean package

docker run -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:9.7

java -jar target/spring-petclinic-4.0.0-SNAPSHOT.jar

docker build -t petclinic .

docker run -p 8080:8080 -e SPRING_DATASOURCE_URL=jdbc:mysql://host.docker.internal:3306/petclinic petclinic

docker compose up -d
docker compose down
docker compose logs

