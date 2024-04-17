# Using for ECS
internet_cidr_blocks = "0.0.0.0/0"
ecs_cluster_name = "Production-ECS-Cluster"
task_cpu = 512
task_ram = 1024

## Key for S3
remote_state_key = "layer1/infrastructure.tfstate"
remote_state_bucket = "trourest-s3"