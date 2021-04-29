call environment_setup.bat

rmdir /S .\aws_lambda /Q
mkdir "aws_lambda"

xcopy .\py_scripts\schools_import.py .\aws_lambda /y

xcopy .\sql_scripts\* .\aws_lambda\sql_scripts\ /y

pip install psycopg2 -t ./aws_lambda
pip install openpyxl -t ./aws_lambda

del /S aws_lambda.zip /Q

7z a aws_lambda.zip ./aws_lambda/*

rmdir /S .\aws_lambda /Q

pause