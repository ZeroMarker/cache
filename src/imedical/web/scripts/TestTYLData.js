//TestTYLData.js

function BodyOnloadHandler()
{
	alert(session['LOGON.USERNAME'])
	var obj=document.getElementById('SearchUser')
	if(obj) { obj.onclick=SearchInfo_click }
}

function SearchInfo_click()
{
	var userid
	var useridobj=document.getElementById('UserID')
	if(useridobj) { userid=document.getElementById('UserID').value }
	var getinfobj=document.getElementById('GetUserInfo')
	if(getinfobj) { var encmeth=getinfobj.value } else { var encmeth="" }
	cspRunServerMethod(encmeth,'RetVal',userid)
}

function RetVal(value)
{
	var tmp=value.split("^")
	document.getElementById('UName').value=tmp[0]
	document.getElementById('UPassword').value=tmp[1]	
}



document.body.onload=BodyOnloadHandler