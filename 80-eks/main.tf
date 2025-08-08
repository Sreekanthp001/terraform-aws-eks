module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 21.0" # this is module version

    name           = "${var.project}-${var.environment}"
    kubernetes_version = "1.32"

    addons = {
        coredns        = {}
        eks-pod-identity-agent = {
            before_compute = true
        }
        kube-proxy           = {}
        vpc-cni              = {
            before_compute = true
        }   
        metrics-server = {}
    }

    #optional
    endpoint_public_access = false

    # optional: adds the current caller identity as an administrator
    enable_cluster_creator_admin_permissions = true

    vpc_id                = local.vpc_id
    subnet_ids            = local.private_subnet_ids
    control_plane_subnet_ids = local.private_subnet_ids

    create_node_security_group = false
    create_security_group = false
    security_group_id = local.eks_control_plane_sg_id
    node_security_group_id = local.eks_node_sg_id

    # eks managed node group(s)
    eks_managed_node_groups = {
        blue = {
            # starting on 1.30 al2023 is the default ami type for eks managed node groups
            ami_type      = "AL2023_x86_64_STANDARD" # user name is ec2-user
            instance_type = ["m5.xlarge"]

            min_size     = 2
            max_size     = 10
            desired_size = 2
        }

    }

    tags = merge(
        local.common_tags, 
        {
            Name = "${var.project}-${var.environment}"
        }
    )
}