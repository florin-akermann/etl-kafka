# ETL with Kafka

This is a small experiment with kafka-connect jdbc-sink.
It is a condensed version of what can be found on:

* https://github.com/confluentinc/demo-scene/blob/master/kafka-to-database/ksqldb-jdbc-sink.adoc
* https://www.confluent.io/stream-processing-cookbook/ksql-recipes/setting-kafka-message-key/
* https://docs.confluent.io/current/connect/kafka-connect-jdbc/sink-connector/index.html
* https://kafka-tutorials.confluent.io/create-stateful-aggregation-count/ksql.html#initialize-the-project
* https://www.confluent.io/blog/build-streaming-etl-solutions-with-kafka-and-rail-data/
* https://blog.softwaremill.com/do-not-reinvent-the-wheel-use-kafka-connect-4bcabb143292
* https://www.confluent.io/blog/kafka-connect-deep-dive-error-handling-dead-letter-queues/

The goal is to persist data in a relational database without writing a single line of java code.
* Currently the example just covers: `` kafka topic (avro) -> jdbc ``
* In the future the example should be: `` kafka topic (xml) -> kafka topic (avro) -> jdbc `` (including an example with a dead letter queue).

## docker
Fire up all needed services [zookeeper, broker, schema-registry, kafka-connect, ksqldb-server, kqsql-cli, postgres, pgadmin]

````
docker-compose up
````

## ksql-cli
Let's create a topic and add some data via ksql.
Fire up the ksql-cli by calling:

````
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
````

Create stream with and the underlying test topic

````
create stream test (testField varchar) with (kafka_topic='test', Partitions=1, value_format='avro', key='testField');
````

Insert some arbitrary values into the test stream, e.g: 

````
insert into test (testField) values ('someValue');
````

Optional: fire up second ksqldb cli and observe new values being added to the stream by running:
````
select * from test emit changes;
````

## kafka-connect
Spawn Jdbc sink by running ``kafka-connect-jdbc-sink.sh``

## postgresql
Goto ``localhost:18080`` with: ``username: postgres@example.com pw: postgres`` <br>
and connect to ``postgres:5432`` with: ``username: postgres pw: postgres``

verify that your data has reached postgres by querying something long the lines:
````
select * from test;
````

#### Considerations:

* What if messages cannot be persisted due to some invalid property of the entity? <br>[Send it of to a error / dead letter queue](https://www.confluent.io/blog/kafka-connect-deep-dive-error-handling-dead-letter-queues/)


#### Pros & Cons of using Kafka-Connect:

Pros:
* no code, only config -> no code maintenance
* easy to setup
* different clearly defined strategies for dead-letters & errors
* tbc...

Cons:
 * dependency on framework / toolkit
 * unclear line between open source & commercial 
 * tbc...


#### Cheat-Sheet:
* check existing topics:<br>
``docker exec -it broker kafka-topics --list --zookeeper zookeeper:2181``


