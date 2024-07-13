# this will upload files and folder in existing s3 bucket
resource "aws_s3_object" "folder1_files" {
  for_each = fileset("${path.module}/assets", "**")

  bucket = "your-bucket-name"  # Specify your existing S3 bucket name
  key    = "assets/${each.value}"
  source = "${path.module}/assets/${each.value}"
}

resource "aws_s3_object" "folder2_files" {
  for_each = fileset("${path.module}/website-demo-image", "**")

  bucket = "your-bucket-name"  # Specify your existing S3 bucket name
  key    = "website-demo-image/${each.value}"
  source = "${path.module}/website-demo-image/${each.value}"
}



resource "aws_s3_object" "index_html" {
  bucket = "your-bucket-name"  # Specify your existing S3 bucket name
  key    = "index.html"
  source = "${path.module}/index.html"
}
