# syntax=docker/dockerfile:1

# Build
FROM eclipse-temurin:26-jdk-ubi10-minimal AS build
WORKDIR /app
COPY gradlew settings.gradle.kts build.gradle.kts ./
COPY gradle ./gradle
RUN chmod +x gradlew
COPY src ./src
RUN ./gradlew bootJar -x test --no-daemon

# Runtime
FROM eclipse-temurin:26-jre-ubi10-minimal AS runtime
WORKDIR /app
# RUN addgroup --system spring && adduser --system --ingroup spring spring
USER 1001:1001
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
