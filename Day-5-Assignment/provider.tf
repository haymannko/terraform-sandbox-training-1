provider "aws" {
    profile = "iamadmin-prod"
    default_tags {
        tags = {
          "Managed-By" = "terraform"
        }
      
    }
  
}