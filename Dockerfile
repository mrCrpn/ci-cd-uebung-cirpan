# Multi-Stage Dockerfile for Java Maven Project
# Stage 1: Build
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app

# Copy Maven files first for better caching
COPY pom.xml .
COPY src ./src

# Build the application and verify JAR exists
RUN apk add --no-cache maven && \
    mvn clean package -DskipTests && \
    ls -la target/ && \
    echo "JAR file created successfully"

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port (if needed in future)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
