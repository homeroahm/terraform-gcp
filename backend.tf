# The block below configures backend to use the 'GCS' bucket.
# variables or functions cannot be used.
# validate values match your environment. 
# specially the bucket value, it should match the bucket you created in GCP. 



terraform {
  backend "gcs" {
    bucket = "terraform-bucket-ycit021"
    prefix = "terraform/state"
  }
}
