
output "docdb_endpoint" {
  value = "${aws_docdb_cluster.service.endpoint}"
}

output "docdb_username" {
  value = "${aws_docdb_cluster.service.master_username}"
}