# Copyright (c) 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

module "melbourne" {
  source  = "oracle-terraform-modules/oke/oci"
  version = "4.5.7"

  home_region = var.home_region
  region      = local.regions["melbourne"]

  tenancy_id = var.tenancy_id

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # ssh keys
  ssh_private_key_path = "~/.ssh/id_rsa"
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"

  # networking
  create_drg       = true
  drg_display_name = "melbourne"

  remote_peering_connections = var.connectivity_mode == "mesh" ? { for k, v in merge({ "admin" = true }, var.clusters) : "rpc-to-${k}" => {} if tobool(v) && k != "melbourne" } : { "rpc-to-admin" : {} }

  nat_gateway_route_rules = concat([
    {
      destination       = lookup(var.admin_region, "vcn_cidr")
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "drg"
      description       = "To Admin"
    }], var.connectivity_mode == "mesh" ?
    [for c in keys(var.clusters) :
      {
        destination       = lookup(lookup(var.cidrs, c), "vcn")
        destination_type  = "CIDR_BLOCK"
        network_entity_id = "drg"
        description       = "Routing to allow connectivity to ${title(c)} cluster"
    } if tobool(lookup(var.clusters, c) && c != "melbourne")] : []
  )

  vcn_cidrs     = [lookup(lookup(var.cidrs, lower("melbourne")), "vcn")]
  vcn_dns_label = "melbourne"
  vcn_name      = "melbourne"

  # bastion host
  create_bastion_host = false

  # operator host
  create_operator                    = false
  enable_operator_instance_principal = false


  # oke cluster options
  allow_worker_ssh_access     = false
  cluster_name                = "melbourne"
  control_plane_type          = var.control_plane_type
  control_plane_allowed_cidrs = ["0.0.0.0/0"]
  kubernetes_version          = var.kubernetes_version
  pods_cidr                   = lookup(lookup(var.cidrs, lower("melbourne")), "pods")
  services_cidr               = lookup(lookup(var.cidrs, lower("melbourne")), "services")


  # node pools
  node_pools = local.managed_nodepools

  node_pool_image_type = "oke"

  # oke load balancers
  load_balancers            = "both"
  preferred_load_balancer   = "public"
  internal_lb_allowed_cidrs = [lookup(var.admin_region, "vcn_cidr")]
  internal_lb_allowed_ports = [80, 443]
  public_lb_allowed_cidrs   = ["0.0.0.0/0"]
  public_lb_allowed_ports   = [80, 443]

  providers = {
    oci      = oci.melbourne
    oci.home = oci.home
  }

  count = lookup(var.clusters, "melbourne") == true ? 1 : 0

}

module "sydney" {
  source  = "oracle-terraform-modules/oke/oci"
  version = "4.5.7"

  home_region = var.home_region
  region      = local.regions["sydney"]

  tenancy_id = var.tenancy_id

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # ssh keys
  ssh_private_key_path = "~/.ssh/id_rsa"
  ssh_public_key_path  = "~/.ssh/id_rsa.pub"

  # networking
  create_drg       = true
  drg_display_name = "sydney"

  remote_peering_connections = var.connectivity_mode == "mesh" ? { for k, v in merge({ "admin" = true }, var.clusters) : "rpc-to-${k}" => {} if tobool(v) && k != "sydney" } : { "rpc-to-admin" : {} }

  nat_gateway_route_rules = concat([
    {
      destination       = lookup(var.admin_region, "vcn_cidr")
      destination_type  = "CIDR_BLOCK"
      network_entity_id = "drg"
      description       = "To Admin"
    }], var.connectivity_mode == "mesh" ?
    [for c in keys(var.clusters) :
      {
        destination       = lookup(lookup(var.cidrs, c), "vcn")
        destination_type  = "CIDR_BLOCK"
        network_entity_id = "drg"
        description       = "Routing to allow connectivity to ${title(c)} cluster"
    } if tobool(lookup(var.clusters, c) && c != "sydney")] : []
  )

  vcn_cidrs     = [lookup(lookup(var.cidrs, lower("sydney")), "vcn")]
  vcn_dns_label = "sydney"
  vcn_name      = "sydney"

  # bastion host
  create_bastion_host = false
  upgrade_bastion     = false

  # operator host
  create_operator                    = false
  upgrade_operator                   = false
  enable_operator_instance_principal = false


  # oke cluster options
  allow_worker_ssh_access     = false
  cluster_name                = "sydney"
  control_plane_type          = var.control_plane_type
  control_plane_allowed_cidrs = ["0.0.0.0/0"]
  kubernetes_version          = var.kubernetes_version
  pods_cidr                   = lookup(lookup(var.cidrs, lower("sydney")), "pods")
  services_cidr               = lookup(lookup(var.cidrs, lower("sydney")), "services")


  # node pools
  node_pools = local.managed_nodepools

  node_pool_image_type = "oke"

  # oke load balancers
  load_balancers            = "both"
  preferred_load_balancer   = "public"
  internal_lb_allowed_cidrs = [lookup(var.admin_region, "vcn_cidr")]
  internal_lb_allowed_ports = [80, 443]
  public_lb_allowed_cidrs   = ["0.0.0.0/0"]
  public_lb_allowed_ports   = [80, 443]

  providers = {
    oci      = oci.sydney
    oci.home = oci.home
  }

  count = lookup(var.clusters, "sydney") == true ? 1 : 0

}

