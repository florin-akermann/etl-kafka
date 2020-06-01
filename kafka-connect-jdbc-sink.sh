curl --location --request PUT 'http://localhost:8083/connectors/jdbc-test-sink/config' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
	"connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
	"key.converter": "org.apache.kafka.connect.storage.StringConverter",
	"connection.url": "jdbc:postgresql://postgres:5432/",
	"connection.user": "postgres",
	"connection.password": "postgres",
	"auto.create": true,
	"auto.evolve": true,
	"insert.mode": "upsert",
	"pk.mode": "record_key",
	"pk.fields": "testField",
	"topics": "test",
	"transforms": "dropArrays",
	"transforms.dropArrays.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
	"transforms.dropArrays.blacklist": "SCHEDULE_SEGMENT_LOCATION, HEADER"
}'
