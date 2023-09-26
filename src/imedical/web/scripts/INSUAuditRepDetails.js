function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	var obj=document.getElementById("UserDr");
	if(obj)
	{
		//alert(obj.value);
	}

}

document.body.onload = BodyLoadHandler;