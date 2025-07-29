# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ec2/app/logs"
  retention_in_days = 7
}

# Metric Filter for detecting "ERROR" or "Exception" in logs
resource "aws_cloudwatch_log_metric_filter" "app_error_filter" {
  name           = "app-error-filter"
  log_group_name = aws_cloudwatch_log_group.app_logs.name
  pattern        = "?ERROR ?Exception"

  metric_transformation {
    name      = "AppErrorCount"
    namespace = "AppMonitoring"
    value     = "1"
  }
}

# Alarm based on error metric
resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name                = "app-error-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "AppErrorCount"
  namespace                 = "AppMonitoring"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  alarm_description         = "Alarm for error logs in application"
  alarm_actions             = [aws_sns_topic.app_alerts.arn]

  depends_on = [aws_cloudwatch_log_metric_filter.app_error_filter]
}

