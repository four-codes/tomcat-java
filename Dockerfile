FROM openjdk:8-jdk-alpine as build
ARG VERSION=3.8.3
WORKDIR /app
RUN wget https://downloads.apache.org/maven/maven-3/$VERSION/binaries/apache-maven-$VERSION-bin.zip
RUN unzip apache-maven-$VERSION-bin.zip
RUN rm -rf apache-maven-$VERSION-bin.zip
ENV MAVEN_HOME=/app/apache-maven-$VERSION
ENV PATH="$MAVEN_HOME/bin:$PATH"
COPY . .
RUN mvn clean package

FROM tomcat:8.0
COPY --from=build /app/target/dependency/webapp-runner.jar /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
