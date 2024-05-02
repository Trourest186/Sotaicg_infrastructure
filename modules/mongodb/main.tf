resource "aws_docdb_subnet_group" "service" {
  name       = "tf-${var.documentdb_name}"
  subnet_ids = ["${module.vpc.private_subnets}"]
}

resource "aws_docdb_cluster_instance" "service" {
  count              = 1
  identifier         = "tf-${var.documentdb_name}-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.service.id}"
  instance_class     = "${var.docdb_instance_class}"
}

resource "aws_docdb_cluster" "service" {
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_docdb_subnet_group.service.name}"
  cluster_identifier      = "tf-${var.documentdb_name}"
  engine                  = "docdb"
  master_username         = "tf_${replace(var.documentdb_name, "-", "_")}_admin"
  master_password         = "${var.docdb_password}"
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.service.name}"
  vpc_security_group_ids = ["${aws_security_group.service.id}"]
}

resource "aws_docdb_cluster_parameter_group" "service" {
  family = "docdb3.6"
  name = "tf-${var.documentdb_name}"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

## Security for documentDB
resource "aws_security_group" "service" {
  name        = "tf-${var.documentdb_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}