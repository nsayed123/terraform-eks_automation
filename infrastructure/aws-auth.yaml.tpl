- rolearn: ${bastion_role_arn}
  username: bastion-role
  groups:
    - system:masters
- rolearn: ${node_group_role_arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes