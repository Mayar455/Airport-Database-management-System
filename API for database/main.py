import pymysql
from app import app
from db import mysql
import pymysql
from flask import jsonify
from flask import flash, request

@app.route('/')
def page():
    return message

@app.route('/customer')
def customer():
	try:
		conn = mysql.connect()
		cursor = conn.cursor(pymysql.cursors.DictCursor)
		cursor.execute("SELECT * FROM CUSTOMER")
		rows = cursor.fetchall()
		resp = jsonify(rows)
		resp.status_code = 200
		return resp
	except Exception as e:
		print(e)
	finally:
		cursor.close() 
		conn.close()
@app.errorhandler(404)
def not_found(error=None):
    message = {
        'status': 404,
        'message': 'Not Found: ' + request.url,
    }
    resp = jsonify(message)
    resp.status_code = 404
    return resp
conn = mysql.connect()
cursor = conn.cursor()
cursor.execute("SELECT * FROM CUSTOMER")
rows = cursor.fetchall()
p=[]
msg=""
for j in rows:
    msg+="<tr><td>"+str(j[0])+"</td><td>"+str(j[1])+"</td><td>"+str(j[2])+"</td><td>"+str(j[3])+"</td><td>"+str(j[4])+"</td><td>"+str(j[5])+"</td><td>"
    sql="SELECT Total_mileage FROM FFC WHERE Passport_no = %s"
    cursor.execute(sql,j[0])
    level=cursor.fetchone()
    msg+=str(level[0])+"</td><td>"
    if(int(level[0])>=10000):
	    l="Gold"
    elif(int(level[0])>=5000):
	    l="Silver"
    else:
	    l="Bronze"
    msg+=l+"</td></tr>"
message = """<html>
<head></head>"""+"""<body><table border=1><tr><td><b><font size="5">Passport_no</font></b></td>
<td><b><font size="5">Address</font></b></td>
<td><b><font size="5">Country</font></b></td>
<td><b><font size="5">E_mail</font></b></td>
<td><b><font size="5">Customer_name</font></b></td>
<td><b><font size="5">Customer_phone</font></b></td>
<td><b><font size="5">Total_mileage</font></b></td>
<td><b><font size="5">Level</font></b></td></tr>"""+msg+"""</table></body>
</html>"""

if __name__ == "__main__":
	app.run(debug=True)

