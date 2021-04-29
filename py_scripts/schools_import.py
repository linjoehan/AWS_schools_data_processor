import sys
sys.path.append("./py_scripts/libs")
import psycopg2
import openpyxl
import tempfile

#conn = psycopg2.connect(database="schools_data")
xlsxfile = "./data/Western Cape.xlsx"
workbook_object = openpyxl.load_workbook(xlsxfile)
sheet_object = workbook_object.active

print(sheet_object.max_row)
print(sheet_object.max_column)