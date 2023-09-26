/// DHCPEQMType.js

var CurrentSel=0

function BodyLoadHandler() {
   
	var obj,EpisodeID="",encmeth="",BaseInfo="";
	obj=document.getElementById("BDelete");
	if (obj){
		obj.onclick=BDelete_click;
		Showobj=document.getElementById("ShowDelete");
		var ShowDelete=0;
		if (Showobj) ShowDelete=Showobj.value;
		//alert("ShowDelete:"+ShowDelete)
		if (ShowDelete==0) obj.style.display = "none";
	}
	
	var tbl=document.getElementById("tDHCPEInPatientToHP");
	if(tbl) tbl.ondblclick=DHC_SelectPat;
	
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	obj=document.getElementById("EpisodeID");
	if (obj){ EpisodeID=obj.value;}
	if (EpisodeID!=""){
		var flag=tkMakeServerCall("web.DHCPE.OtherPatientToHP","IsOtherPatientToHP",EpisodeID);
		if(flag=="1"){return false;}
		obj=document.getElementById("BaseInfo")
		if (obj) BaseInfo=obj.value;
		if (BaseInfo!=""){
			var Arr=BaseInfo.split("^");
			if (!confirm("确定要将'"+Arr[1]+"'设置为体检人员吗?")) return false;
		}
		obj=document.getElementById("ToHPClass");
		if (obj) encmeth=obj.value;
		var User=session['LOGON.USERID'];
		var Ret=cspRunServerMethod(encmeth,EpisodeID,User);
		var Arr=Ret.split("^");
		if (Arr[0]=="-1"){
			alert(Ret);
			return false;
		}
		if (Arr[0]=="0"){
			obj=document.getElementById("BFind");
			if (obj) obj.click();
		}
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function BFind_click()
{
	var StartDate="",EndDate="",ShowDelete=0,obj;
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("ShowDelete");
	if (obj) ShowDelete=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEInPatientToHP"
   	+"&StartDate="+StartDate+"&EndDate="+EndDate+"&EpisodeID="+""+"&ShowDelete="+ShowDelete;
   	window.location.href=lnk;
}
function BDelete_click()
{
	var encmeth="",ID="",UserID="";
	var obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	var obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	UserID=session['LOGON.USERID']
	var Ret=cspRunServerMethod(encmeth,ID,UserID);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		obj=document.getElementById("BFind");
		if (obj) obj.click();
	}else{
		alert(Arr[1]);
	} 
}
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	
	SelRowObj=document.getElementById('EpisodeID'+'z'+selectrow);
	obj=document.getElementById("ID");
	if (SelRowObj && obj) { obj.value=SelRowObj.value;}
}

function SelectRowHandler() {
	
	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {
		var obj=document.getElementById("ID");
		if (obj) obj.value="";	    
		CurrentSel=0;
		return;
	}
	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);
}
function DHC_SelectPat()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow !=0) {
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		if (EpisodeObj) EpisodeID=EpisodeObj.value;
		//var lnk="dhcpedocpatient.zj.csp"+"?EpisodeID="+EpisodeID;
		var lnk="dhcpedocpatient.hisui.csp"+"?EpisodeID="+EpisodeID+"&Type=ZJ";
		var wwidth=screen.width-10;
		var wheight=screen.height-10;
		var xposition = (screen.width - wwidth) / 2;
		var yposition = (screen.height - wheight) / 2;
		var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
		+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
		;
		var cwin=window.open(lnk,"_blank",nwin)	
		
	}
}
document.body.onload = BodyLoadHandler;