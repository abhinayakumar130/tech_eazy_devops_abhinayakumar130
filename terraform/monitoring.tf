# Create Log Group explicitly
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ec2/app/logs"
  retention_in_days = 7
}

# Metric Filter for "ERROR" or "Exception"
resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "error-metric-filter"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
  pattern        = "?ERROR ?Exception"

  metric_transformation {
    name      = "ErrorCount"
    namespace = "AppMetrics"
    value     = "1"
  }
    # Ensure log group is created first
  depends_on = [aws_cloudwatch_log_group.app_log_group]
}

# Alarm based on the metric
resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "AppErrorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  alarm_description   = "Triggered when ERROR or Exception found in app.log"
  alarm_actions       = [aws_sns_topic.app_alerts.arn]

  depends_on = [aws_cloudwatch_log_metric_filter.error_filter]
}

