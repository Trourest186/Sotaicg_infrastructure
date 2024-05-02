output "cluster_name" {
  value = aws_ecs_cluster.production-fargate-cluster.arn
}

output "cluster_name_id" {
  value = aws_ecs_cluster.production-fargate-cluster.id
}