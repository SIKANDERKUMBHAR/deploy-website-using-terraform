
resource "aws_s3_object" "folder1_files" {
  for_each = fileset("${path.module}/assets", "**")

  bucket = "myfirstbucketforecommercewebsite"  # Specify your existing S3 bucket name
  key    = "assets/${each.value}"
  source = "${path.module}/assets/${each.value}"
}

resource "aws_s3_object" "folder2_files" {
  for_each = fileset("${path.module}/website-demo-image", "**")

  bucket = "myfirstbucketforecommercewebsite"  # Specify your existing S3 bucket name
  key    = "website-demo-image/${each.value}"
  source = "${path.module}/website-demo-image/${each.value}"
}



resource "aws_s3_object" "index_html" {
  bucket = "myfirstbucketforecommercewebsite"  # Specify your existing S3 bucket name
  key    = "index.html"
  source = "${path.module}/index.html"
}
