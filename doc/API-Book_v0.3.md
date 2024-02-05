# Smarthub API book

## Information

### Usage
1. Copy command
2. Replae content between `{}`
	- e.g. replace `{SERVER}` by ```123.123.123.123:123```

## Login
### URI
- URL
	- ```/smarthub/login```
- Method :
	- **POST**
### Sample call
1. Normal login

	```curl -X POST -H 'Content-Type: application/json; charset=utf-8' -d '{"Account":"{ACCOUNT}","Password":"{PASSWORD}"}' http://{SERVER}/smarthub/login```

2. Refresh

	```curl -X POST -H 'Content-Type: application/json; charset=utf-8' -d '{"AccessToken":"{ACCESS_TOKEN}","RefreshToken":"{REFRESH_TOKEN}"}' http://{SERVER}/smarthub/login```

## Role
1. GET
clear; curl -X GET -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' http://140.113.120.235:25000/smarthub/role -v
2. POST
clear; curl -X POST -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"Name":"Boss","Perm":"123123"}' http://140.113.120.235:25000/smarthub/role -v
3. PUT
clear; curl -X PUT -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"Name":" Test008","Perm":"888888","ID":8}' http://140.113.120.235:25000/smarthub/role -v
4. DELETE
clear; curl -X DELETE -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '[7,8]' http://140.113.120.235:25000/smarthub/role -v

## Member
1. GET
http://140.113.120.235:25000/smarthub/member?q=**&s=-1
2. POST
clear; curl -X POST -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"Status":1,"RoleID":2,"Name":"NameTest1","Account":"AccountTest1","Password":"PasswordTest1","BankCode":"546","BankAccount":"5465"}' http://140.113.120.235:25000/smarthub/member -v
3. PUT
clear; curl -X PUT -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"ID":6,"Status":1,"RoleID":2,"Name":"HAHAHA","Account":"123123123","Password":"94879487","BankCode":"456","BankAccount":"789"}' http://140.113.120.235:25000/smarthub/member -v
4. DELETE
clear; curl -X DELETE -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '[9,10]' http://140.113.120.235:25000/smarthub/member -v

## File
1. GET
clear; curl -X GET -H 'Authorization: Bearer "{ACCESS_TOKEN}"' http://140.113.120.235:25000/smarthub/file?TID=123 -v
2. POST
 curl -X POST -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -F "FileContent=@Poker.c" http://140.113.120.235:25000/smarthub/file?TID=123 -v
3. DELETE
clear; curl -X DELETE -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' http://140.113.120.235:25000/smarthub/file?file=06400aa33c0e207610d1f4aeea7c8ef9aaecfd9be026c3ef6ce355697e0f73f5.c -v

## Transaction
1. GET
curl -X GET "http://140.113.120.235:25000/smarthub/transaction?Name=Test&ProjectName=Test&Status=1&PayStatus=1&Unit=Test&LaunchDateStart=2020-01-01&LaunchDateEnd=2020-12-31&SaleDateStart=2020-01-01&SaleDateEnd=2020-12-31"
2. POST
clear; curl -X POST -H "Content-Type: application/json" -d '{"Name":"test","ProjectName":"test","Price":1000000,"PriceSQFT":500,"Commission":20.87,"Status":2,"PayStatus":2,"Unit":"test","Location":"test","Developer":"test","Description":"test","Appoint":"1;2","Client":"1","Agent":"3","SaleDate":"2020-01-01","LaunchDate":"2025-01-01"}' http://140.113.120.235:25000/smarthub/transaction
3. PUT
clear; curl -X PUT -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"ID":6,"Status":1,"RoleID":2,"Name":"HAHAHA","Account":"123123123","Password":"94879487","BankCode":"456","BankAccount":"789"}' http://140.113.120.235:25000/smarthub/transaction -v
4. DELETE
clear; curl -X DELETE -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '[9,10]' http://140.113.120.235:25000/smarthub/transaction -v