FROM eclipse-temurin:21-jre-ubi9-minimal

# Crea grupo y usuario del sistema
RUN groupadd -r appgroup \
 && useradd -r -g appgroup -d /app -s /sbin/nologin appuser

WORKDIR /app
RUN chown -R appuser:appgroup /app \
 && chmod -R 770 /app
COPY --chown=appuser:appgroup target/*.jar /app/app.jar

USER appuser
EXPOSE 8000
COPY target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]