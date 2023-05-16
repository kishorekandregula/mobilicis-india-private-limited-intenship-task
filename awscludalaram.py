def create_cpu_alarm(instance_id):
    client = aws.client('cloudwatch')

    alarm_name = 'High_CPU_Utilization'
    alarm_description = 'Triggered when CPU usage exceeds 80% for 5 consecutive minutes'
    metric_name = 'CPUUtilization'
    namespace = 'AWS/EC2'
    comparison_operator = 'GreaterThanThreshold'
    threshold = 80.0
    evaluation_periods = 5
    period = 60
    statistic = 'Average'
    alarm_actions = ['YOUR_SNS_TOPIC_ARN']

    dimensions = [
        {
            'Name': 'InstanceId',
            'Value': instance_id
        },
    ]

    response = client.put_metric_alarm(
        AlarmName=alarm_name,
        AlarmDescription=alarm_description,
        MetricName=metric_name,
        Namespace=namespace,
        ComparisonOperator=comparison_operator,
        Threshold=threshold,
        EvaluationPeriods=evaluation_periods,
        Period=period,
        Statistic=statistic,
        AlarmActions=alarm_actions,
        Dimensions=dimensions
    )

    print("CloudWatch alarm created successfully.")

# Replace 'INSTANCE_ID' with the actual EC2 instance ID
create_cpu_alarm('INSTANCE_ID'):
