variable google_cloud_region {
    default = "asia-southeast1"
    description = "The region to deploy the virtual machine"
    type = string
}

variable stack_name {
    default = "remote-machine"
    description = "Name of TF stack, is is pre-pended to most resources"
    type = string
}
