#####################################################
# KAFKA 
#####################################################
resource "aws_security_group" "sg_kafka" {
  name = "${var.common.env}-${var.common.project}-sg-kafka"
  description = "SG for kafka"
  vpc_id = var.network.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sg_rule_kafka" {
  type = "ingress"
  from_port = 9092
  to_port = 9092
  protocol = "TCP"
  source_security_group_id = var.network.sg_container
  security_group_id = aws_security_group.sg_kafka.id
}

resource "aws_cloudwatch_log_group" "log_group_kafka" {
  name = "${var.common.env}-${var.common.project}-kafka"
  retention_in_days = 7
}

# S3
# KMS
resource "aws_kms_key" "kms" {
  description = "sotaicg-kafka-kms"
}

resource "aws_msk_cluster" "example" {
  cluster_name           = "example"
  kafka_version          = "3.2.0"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = var.subnets
    storage_info {
      ebs_storage_info {
        volume_size = 1000
      }
    }
    security_groups = [aws_security_group.sg_kafka.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.log_group_kafka.name
      }
      firehose {
        enabled         = false
      }
      s3 {
        enabled = false
        # bucket  = aws_s3_bucket.bucket.id
        # prefix  = "logs/msk-"
      }
    }
  }
  configuration_info {
    arn = aws_msk_configuration.kafka_config.arn
    revision = var.kafka_config_revision
  }

  tags = {
    project = "Sota-data-platform"
  }
}

resource "aws_msk_configuration" "kafka_config" {
  name           = "${var.common.env}-${var.common.project}"

  server_properties = <<PROPERTIES
    auto.create.topics.enable=true
    default.replication.factor=2
    min.insync.replicas=2
    num.io.threads=8
    num.network.threads=5
    num.partitions=1
    num.replica.fetchers=2
    replica.lag.time.max.ms=30000
    socket.receive.buffer.bytes=102400
    socket.request.max.bytes=104857600
    socket.send.buffer.bytes=102400
    unclean.leader.election.enable=true
    zookeeper.session.timeout.ms=18000
  PROPERTIES
}
