call environment_setup.bat

del /S .\aws_lambda /Q
mkdir "aws_lambda"

xcopy .\py_scripts\schools_import.py ./aws_lambda \y

pip install psycopg2 -t ./aws_lambda
pip install openpyxl -t ./aws_lambda

del /S aws_lambda.zip /Q

7z a aws_lambda.zip ./aws_lambda/*

del /S .\aws_lambda /Q