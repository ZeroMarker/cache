function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	var obj=document.getElementById("UserDr");
	if(obj)
	{
		//alert(obj.value);
	}
	$('.datagrid-sort-icon').text('')
	$('body').css("padding-Top","0px");

}

document.body.onload = BodyLoadHandler;