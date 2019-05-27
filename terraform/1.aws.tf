provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "eu-central-1"
  alias      = "regional"
}
