# Islander Eleven

Islander Eleven is a personal website deployed on AWS using Terraform. The website is designed to plot sports data and is built using a variety of AWS services including S3, CloudFront, Lambda, Step Functions, ECR, IAM, SNS, CloudWatch, and API Gateway.

## Architecture

    [CloudFront] ↔ [Browser]
    
		↕               ↕
    
    [S3 Website]   [Data API]

		↕               ↕

    [Lambda Jobs] ↔ [S3 Data Lake]

        ↕
    
    [ext Data: Garmin, Intervals.icu]

### Components

1. **CloudFront**: Acts as a Content Delivery Network (CDN) to distribute content globally with low latency.
2. **S3 Website**: Hosts the static website content.
3. **Data API**: Delivers pre computed charts to the frontend.
4. **Lambda Jobs**: Serverless functions that process and analyze sports data.
5. **S3 Data Lake**: Stores raw and processed sports data.
6. **External Data Sources**: Integrates with external data sources like Garmin and Intervals.icu to fetch sports data.
7. **SNS, Simple Notification Service**: Used to send alerts and notifications for monitoring and alerting purposes.
8. **CloudWatch**: Monitors AWS resources and applications, providing data and actionable insights to optimize performance and maintain availability.
9. **API Gateway**: Serves as an interface to access data from the S3 Data Lake via Lambda functions.

## Technologies Used

- **AWS Services**:
  - S3: Storage for website content and data lake.
  - CloudFront: CDN for content distribution.
  - Lambda: Serverless compute for data processing.
  - Step Functions: Orchestration of Lambda functions.
  - ECR: Container registry for Docker images.
  - IAM: Identity and Access Management for secure access control.
  - SNS: Notification service for sending alerts.
  - CloudWatch: Monitoring and observability service.
  - API Gateway: Managed service to create, publish, maintain, monitor, and secure APIs

- **Terraform**: Infrastructure as Code (IaC) tool for managing AWS resources.

## Features

- **Sports Data Plotting**: Visualize sports data using interactive plots.
- **Scalable Architecture**: Designed to handle varying loads efficiently.
- **Serverless Computing**: Leverages AWS Lambda for cost-effective and scalable data processing.
- **Monitoring and Alerting**: Uses SNS and CloudWatch to monitor system health and send alerts for issues, particularly for Step Functions.
- **Data Access**: Utilizes API Gateway to serve data from the S3 Data Lake using Lambda functions.

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.