FROM confluentinc/cp-server:6.2.0

WORKDIR /home/appuser
COPY . .

# Root access needed to install maven
USER 0

RUN dnf install -y maven

ENV JAVA_HOME=/lib/jvm/zulu-11
RUN mvn clean install

ENV KAFKA_LIB_DIR=/usr/share/java/kafka

RUN mv oauth-common/target/kafka-oauth-common-*.jar $KAFKA_LIB_DIR
RUN mv oauth-server/target/kafka-oauth-server-*.jar $KAFKA_LIB_DIR
RUN mv oauth-server-plain/target/kafka-oauth-server-plain-*.jar $KAFKA_LIB_DIR
RUN mv oauth-keycloak-authorizer/target/kafka-oauth-keycloak-authorizer-*.jar $KAFKA_LIB_DIR
RUN mv oauth-client/target/kafka-oauth-client-*.jar $KAFKA_LIB_DIR
RUN mv oauth-common/target/lib/nimbus-jose-jwt-*.jar $KAFKA_LIB_DIR

ENV KAFKA_SUPER_USERS=User:service-account-floin-broker

# TODO use same secrets as in crypto_next_wallet service
COPY ./secrets/ /opt/kafka/config/

# AppUser
USER 1000
