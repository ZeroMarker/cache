//
//UDHCJFOP.HandinRegHis11


var Guser,GuserCode,GuserName;
var FootInfo="",PrintInfo="";



function BodyLoadHandler()
{
   Guser=session['LOGON.USERID'];
   GuserCode=session['LOGON.USERCODE'];
   GuserName=session['LOGON.USERNAME'];
   var myobj=document.getElementById("UserID");
   if (myobj) myobj.value=Guser;
}


function UnloadHandler(){
	///
	
}

document.body.onload = BodyLoadHandler;

document.body.onunload =UnloadHandler;