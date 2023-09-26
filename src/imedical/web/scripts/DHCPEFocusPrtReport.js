var SelectedRow=-1
var PayModeLength=0;
function BodyLoadHandler()
{
	obj=document.getElementById('BReport');
	if (obj) { obj.onclick = BReport_click; }
	obj=document.getElementById('BDetail');
	if (obj) { obj.onclick = BDetail_click; }
	
	var tbl=document.getElementById('tDHCPEFocusPrtReport'); 
	var row=tbl.rows.length;
	
	for (var i=1;i<row;i++) {
	    var obj=document.getElementById("TID"+i);
	    if(obj){obj.onclick=ShowDetail22;}
	}

}
function BReport_click()
{
	var encmeth="",UserID="",obj,Ret="";
	UserID=session['LOGON.USERID'];
	obj=document.getElementById("ReportClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,UserID);
	var Arr=Ret.split("^");
	if (Arr[0]<0){
		alert(Arr[1]);
		return false;
	}else{
		obj=document.getElementById("BFind");
		if (obj) obj.click();
	}
}
function BDetail_click()
{
	UserID=session['LOGON.USERID'];
	ShowDetailApp("",UserID);
}
function ShowDetail22(e)
{
	
	var ReportID=e.id;
	ShowDetailApp(ReportID,"");
}
var ReportWin;

function ShowDetailApp(ReportID,UserID)
{
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
			+',left=100'
			+',top=50'
			//+',width='+window.screen.availWidth
			//+',height='+(window.screen.availHeight-40)
			//;
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEFocusPrintDetail"
			+"&ReportID="+ReportID
			+"&UserID="+UserID;
			
	if (ReportWin) ReportWin.close();
	ReportWin=window.open(lnk,"ReportWin",nwin);
	
	
}

/*
function ShowDetailApp(ReportID,UserID)
{
	
	
	 var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEFocusPrintDetail"
			+"&ReportID="+ReportID
			+"&UserID="+UserID;
			
	var  iWidth=1000; //模态窗口宽度
  	var  iHeight=700;//模态窗口高度
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	var ret=window.showModalDialog(lnk, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
 
	if(!ret){
               ret=window.returnValue;
            }

     return false;
	return ret;

}
*/
document.body.onload = BodyLoadHandler;
