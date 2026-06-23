FROM eclipse-temurin:17
WORKDIR /app
ARG UID=10001
ARG GID=10001
RUN groupadd -g ${GID} spring && useradd -u ${UID} -g spring -m -s /usr/sbin/nologin spring
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
USER ${UID}:${GID}
EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "app.jar" ]
