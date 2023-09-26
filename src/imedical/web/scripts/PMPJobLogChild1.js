//PMPJobLogChild1.js

var userid=session['LOGON.USERID'];
function BodyLoadHandler(){
	document.getElementById("User").value=session['LOGON.USERNAME'];
	var obj=document.getElementById("Update");
	if (obj){obj.onclick=Update_Click;}
	}
	
function Update_Click()
{
	var Rowid = document.getElementById("Rowid").value;
    var User = document.getElementById("User").value;
    var Desc = document.getElementById("Desc").value;
    var Content = document.getElementById("Content").value;
    var Solution = document.getElementById("Solution").value;
    var str=tkMakeServerCall("web.PMPJobLogging","UpdateJobLogging",Rowid,Content,Desc,Solution,userid)
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMPJobLogging";
    window.location.href=lnk;
}
document.body.onload=BodyLoadHandler;