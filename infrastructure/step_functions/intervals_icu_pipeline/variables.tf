variable "sns_email"{
    default = "seanvedrinelle@gmail.com"
    type = string
}

variable "sns_topic_name"{
    default = "intervals_icu_pipeline_topic"
    type = string
}

variable "cloudwatch_log_group_name"{
    default = "/aws/states/intervals_icu_pipeline"
    type = string
}