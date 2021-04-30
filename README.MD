# Basic AWS Data Pipeline

## Overview
This Project uses the AWS cloud platform to ingest a data into a database. It uses S3 to store the original data files, An RDS Postgresql 
database instance, Lambda, and an S3 trigger. I've used a public South African schools data set which can be found on the 
[Department of Education](https://www.education.gov.za/Programmes/EMIS/EMISDownloads.aspx) website.

Any file uploaded to the S3 bucket will trigger a lambda which processes the file into our database instance.

## Setting up the Environment
This Project requires some locally setup resources.
You will need to edit `environment_setup.bat` with your local environment variables.

#### Python
Python installation guide found [here](https://www.tutorialspoint.com/python/python_environment.htm)
I used [version 3.94](https://www.python.org/downloads/release/python-394/)

#### 7-zip
7zip is a free opensource project. It's a file archiver with a high compression ratio. Installation instructions can be found at [7-Zip](https://www.7-zip.org/)

#### Local Postgresql Database (Optional)
An installation guide can be found [here](https://www.tutorialspoint.com/postgresql/postgresql_environment.htm) and the download page [here](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)
I got errors when trying to unpack this though as it tries to install an older version of VC++ runtime redistributables. This can be remedied by installing it with
```
postgresql-9.6.21-2-windows.exe --install_runtimes 0
```

## Batch files in this project
* db_init.bat - Sets up the database and database table used in this project. WARNING: This script drops existing databases when they exist
* environment_setup.bat - This contains local environment variables.
* lambda_setup.bat - This builds a zip file containing all the resources required for the lambda.
* py_build.bat - Installs required python libraries for local testing.
* py_run.bat - Runs the python script locally.

# Setting up AWS Resources

## RDS Postgres Database
From the management console you can setup a RDS instance with Postgres. It will need to allow all access if you want to setup the database from you local machine. 
You may also need to add a rule to the security group to allow connections to the port you've used for your Postgresql. A video tutorial can be foune [here](https://www.youtube.com/watch?v=XGt0vEUZXYw)

## S3 Bucket
This project will need an S3 bucket. Since this project also uses a trigger on all files uploaded to S3 It's recomended to use a dedicated S3 bucket for this project, however an existing one can also be used, you will however need to take care in creating the trigger.

## Lambda Function
Since this lambda function requires external libraries, it must be uploaded with a zip file containing all the resources. Running `lambda_setup.bat` will create a zip file containing all the required libraries.
Ensure that the lambda entry point is set up correctly, and increase the maximum runtime and memory (I've used 10 minutes and 2048MB respectively).
The lambda will also need read access to S3. And you will need to setup environment variables for connecting to the database. see `environment_setup.bat` for examples of which variables are needed.

This is a good time to run a test, before installing the trigger. Uploading a sample file to your S3 bucket and setting up a test to ensure that the file is being processed to the database. In the test example below you will need to use the correct bucket name and key / file name for the test
```
{
  "Records": [
    {
      "eventVersion": "2.0",
      "eventSource": "aws:s3",
      "awsRegion": "us-west-2",
      "eventTime": "1970-01-01T00:00:00.000Z",
      "eventName": "ObjectCreated:Put",
      "userIdentity": {
        "principalId": "EXAMPLE"
      },
      "requestParameters": {
        "sourceIPAddress": "127.0.0.1"
      },
      "responseElements": {
        "x-amz-request-id": "EXAMPLE123456789",
        "x-amz-id-2": "EXAMPLE123/5678abcdefghijklambdaisawesome/mnopqrstuvwxyzABCDEFGH"
      },
      "s3": {
        "s3SchemaVersion": "1.0",
        "configurationId": "testConfigRule",
        "bucket": {
          "name": "schoolsdata-zar",
          "ownerIdentity": {
            "principalId": "EXAMPLE"
          },
          "arn": "arn:aws:s3:::example-bucket"
        },
        "object": {
          "key": "Eastern Cape.xlsx",
          "size": 1024,
          "eTag": "0123456789abcdef0123456789abcdef",
          "sequencer": "0A1B2C3D4E5F678901"
        }
      }
    }
  ]
}
```

## S3 Trigger to Lambda

Now set up a trigger for your Lambda from S3. If you are using your S3 bucket for other things you will need to take care in creating the trigger only for on files in a specivic folder.

# Possible Improvments and Considerations

## Database selection
This is a small data set so a Postgresql database works well here, however if the data size were to grow large a distributed database might be more suited.

## Data Processing

#### Processing Spped and file formats
The data received is in xlsx format which is not directly supported by most databse technologies, In my solution I load the file into memory, to extract the data and load it into the database. However this process is cumbersome, it may be worth exploring other options for example using a seperate lambda to transform the xlsx file to csv then direcly loading the csv into the database.

#### Data validations
The database has been set up to prevent bad data from being inserted into the database tables, however it may be better to validate the data before trying to insert it into the table. Things like number of columns, checking that the column names are in the expecte order, the data contained is in the correct format etc.

## Logging
The Lambda has limited logging of errors to cloudwatch. Since imports are triggered, errors during processing will not attempt to re process a file nor will it aleart when errors do occur. This can be done by either setting up alarms on errors, or attempting to reprocess a file a fixed number of time should an error occur, this can be done by using another queue service, SQS or SNS for example to trigger reprocessing of a file should it have failed.

## Environment Setup
All services in this project was setup using the aws console. To ease replication, this can be done with scripts using the AWS-CLI or a service like Cloudformation.

# A look at the data

## Number of Schools in each province
```
schools_data=# select province,count(*) from schools group by province;
 province | count
----------+-------
 KZN      |  6094
 NW       |  1564
 EC       |  5526
 GT       |  3116
 FS       |  1148
 NC       |   596
 LP       |  3914
 MP       |  1801
 WC       |  1913
(9 rows)
```

## Top 10 Student to Teacher ration
```
schools_data=# select province,institution_name,learners,educators,learners/educators as student_teacher_ratio from schools where educators is not null order by student_teacher_ratio desc limit 30;
 province |           institution_name            | learners | educators | student_teacher_ratio
----------+---------------------------------------+----------+-----------+-----------------------
 GT       | CRAWFORD PREPARATORY PRETORIA         |     1154 |         1 |                  1154
 GT       | TRINITY HOUSE PREPARATORY SCHOOL      |      990 |         1 |                   990
 NW       | Pecanwood College                     |      670 |         2 |                   335
 GT       | ABBOTTS COLLEGE-JOHANNESBURG SOUTH    |      292 |         1 |                   292
 KZN      | CRAWFORD COLLEGE LA LUCIA             |      489 |         2 |                   244
 LP       | SETSEKANA                             |      483 |         2 |                   241
 NW       | Boitekong II Secondary                |      721 |         3 |                   240
 GT       | ABBOTTS COLLEGE-NORTHCLIFF            |      224 |         1 |                   224
 LP       | KGABEDI                               |      168 |         1 |                   168
 LP       | MOTSERERENG                           |      141 |         1 |                   141
 GT       | NEW GENERATION PRIVATE SCHOOL         |     1331 |        11 |                   121
 LP       | NORTHERN ACADEMY                      |     2264 |        19 |                   119
 LP       | ELIM                                  |     1107 |        10 |                   110
 LP       | TSHABELANG DINOKO                     |      546 |         5 |                   109
 KZN      | NYENYEZI SENIOR PRIMARY SCHOOL        |      219 |         2 |                   109
 GT       | RUIMSIG MONTESSORI PRIMARY SCHOOL     |      203 |         2 |                   101
 LP       | APPLE SEEDS                           |      997 |        10 |                    99
 EC       | JOHAN CARINUS ART CENTRE              |     1075 |        11 |                    97
 GT       | FUNDAMENTAL FACULTY                   |       96 |         1 |                    96
 LP       | MASETE                                |      366 |         4 |                    91
 MP       | SHABALALA SECONDARY                   |      624 |         7 |                    89
 LP       | ITIRELE                               |     1191 |        14 |                    85
 EC       | MTHAWELANGA JUNIOR PRIMARY SCHOOL     |       82 |         1 |                    82
 EC       | BEBULE PRIMARY SCHOOL                 |       81 |         1 |                    81
 EC       | PHUTHALICHABA SENIOR SECONDARY SCHOOL |      402 |         5 |                    80
 LP       | MOGOLAHLOGO                           |      239 |         3 |                    79
 KZN      | KWAZIBUSELE PRIMARY SCHOOL            |       79 |         1 |                    79
 LP       | KGOTLHO                               |      158 |         2 |                    79
 KZN      | AMAZIZI SECONDARY SCHOOL              |      479 |         6 |                    79
 KZN      | NCINCI  JUNIOR PRIMARY SCHOOL         |      316 |         4 |                    79
(30 rows)
```