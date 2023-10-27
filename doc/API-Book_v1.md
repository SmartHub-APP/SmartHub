# Smarthub API book

## Information
### Version
- v1
- latest
### Author
- Connection
### Usage
1. Copy command
2. Replae content between `{}`
	- e.g. replace `{SERVER}` by ```123.123.123.123:123```

## Outline
1. Login

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
clear; curl -X GET -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' http://140.113.120.235:25000/smarthub/role
2. POST
clear; curl -X POST -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"Name":"Boss","Perm":"123123"}' http://140.113.120.235:25000/smarthub/role
3. PUT
clear; curl -X PUT -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"Name":" Test008","Perm":"888888","ID":8}' http://140.113.120.235:25000/smarthub/role -v
4. DELETE
clear; curl -X DELETE -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '[7,8]' http://140.113.120.235:25000/smarthub/role -v

## Member
1. GET
clear; curl -X GET -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' http://140.113.120.235:25000/smarthub/member
2. POST
clear; curl -X POST -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"Name":"Boss","Perm":"123123"}' http://140.113.120.235:25000/smarthub/role
3. PUT
clear; curl -X PUT -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '{"Name":" Test008","Perm":"888888","ID":8}' http://140.113.120.235:25000/smarthub/role -v
4. DELETE
clear; curl -X DELETE -H 'Content-Type: application/json; charset=utf-8' -H 'Authorization: Bearer "{ACCESS_TOKEN}"' -d '[7,8]' http://140.113.120.235:25000/smarthub/role -v

