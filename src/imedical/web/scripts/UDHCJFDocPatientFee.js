var userid
function BodyLoadHandler()
{
	userid=session['LOGON.USERID'];
	var obj=document.getElementById('guser');
    obj.value=userid;
    
}
document.body.onload=BodyLoadHandler;
