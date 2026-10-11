# =====================================================================
# Stage 1: Build the Application using Maven and JDK 17
# =====================================================================
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and package production WAR
COPY src ./src
RUN mvn clean package -DskipTests

# =====================================================================
# Stage 2: Production Apache Tomcat 10.1 Container Runtime
# =====================================================================
FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

# Remove default sample webapps to optimize security & startup speed
RUN rm -rf webapps/*

# Copy compiled production WAR as ROOT.war to serve at the root domain '/'
COPY --from=builder /app/target/complaint-portal.war webapps/ROOT.war

# Set Production Environment Defaults
ENV PORT=8080
ENV MONGODB_DATABASE=complaint_portal

EXPOSE 8080

CMD ["catalina.sh", "run"]
