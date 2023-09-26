var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function SetPatNoLength(PatNo)
{
	var obj=document.getElementById('PatNo');
	if (obj) {
		var PatNo=obj.value;
		if (PatNo!==""){
			var objM=document.getElementById('MethodRegNoCon');
		    if (objM) {var encmeth=objM.value} else {var encmeth=''}
		    var ret=cspRunServerMethod(encmeth,PatNo);
		    obj.value=ret;
		}
	}
}

function PatNo_OnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	SetPatNoLength();
	var PatNo=getElementValue("PatNo",null);
	ClearItems();
	setElementValue("PatNo",PatNo,null);
	xPatNoOnKeyDown();
	return false;
}

function InitForm()
{
	var obj=document.getElementById("PatNo");
	if (obj){
		obj.onkeydown=PatNo_OnKeyDown;
	}
	
	var obj=document.getElementById('cmdUpdatePatient');
	if (obj){
		obj.onclick=cmdUpdatePatient_Click;
	}
}
/*
function cmdUpdatePatient_Click()
{
	var CardNo="";
	var obj=document.getElementById("CardNo");
	if (obj){
		CardNo=obj.value;
	}
	//if ((CardNo=="")||(!CardNo)) return;
	
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCPatient"+"&CardNo="+CardNo;
	window.open(lnk,null,"status=1,scrollbars=1,top=100,left=100,width=900,height=800,resizable=yes");
	return false;
}
*/

function ClearItems()
{
	setElementValue("PatNo","",null);
	setElementValue("PatName","",null);
	setElementValue("PatSex","",null);
	setElementValue("PatAge","",null);
	setElementValue("PatHomeAddress","",null);
	setElementValue("PatJobComponey","",null);
	setElementValue("Papmi","",null);
}

function xPatNoOnKeyDown()
{
	var PatNo=getElementValue("PatNo",null);
	if (PatNo){
		DisplayBaseInfo();
		DisplayAdmInfo();
	}
}

function DisplayAdmInfo()
{
	var MrType = document.getElementById("MrType").value;
	var AdmTypeFlag = document.getElementById("AdmTypeFlag").value;
	var WorkItem = document.getElementById("WorkItem").value;
	var RequestType = document.getElementById("RequestType").value;
	var AutoTransfer= document.getElementById("AutoTransfer").value;
	var AutoRequest= document.getElementById("AutoRequest").value;
	var MultiAdmit= document.getElementById("MultiAdmit").value;
	var MRChange= document.getElementById("MRChange").value;
	var cPapmi="",cAdmType="",cAdmDate="";
	var obj=document.getElementById("Papmi");
	if (obj){cPapmi=obj.value;}
	
	/*
	var obj=document.getElementById("AdmDate");
	if (obj){cAdmDate=obj.value;}
	if (AdmTypeFlag=="O"){
		cAdmType="O|E"
	}else if (AdmTypeFlag=="I"){
		cAdmType="I"
	}*/
	
	cAdmType=AdmTypeFlag;
	if ((!cPapmi)||(!cAdmType)) return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Paadm.List"+"&Papmi="+cPapmi+"&AdmDate="+cAdmDate+"&AdmType="+cAdmType+"&MrType="+MrType+"&AdmTypeFlag="+AdmTypeFlag+"&WorkItem="+WorkItem+"&RequestType="+RequestType+"&AutoTransfer="+AutoTransfer+"&AutoRequest="+AutoRequest+"&MultiAdmit="+MultiAdmit+"&MRChange="+MRChange;
	lnk=lnk+"&PatNo="+getElementValue("PatNo",null);
	lnk=lnk+"&PatName="+getElementValue("PatName",null);
	lnk=lnk+"&PatSex="+getElementValue("PatSex",null);
	lnk=lnk+"&PatAge="+getElementValue("PatAge",null);
	lnk=lnk+"&PatHomeAddress="+getElementValue("PatHomeAddress",null);
	lnk=lnk+"&PatJobComponey="+getElementValue("PatJobComponey",null);
	lnk=lnk+"&Papmi="+getElementValue("Papmi",null);
    parent.RPbottom.location.href=lnk;
}

function DisplayBaseInfo()
{
	var obj=document.getElementById("PatNo");
	if (obj){cRegNo=obj.value;}
	if (cRegNo!==""){
		var obj=document.getElementById('MethodGetPatInfo');
	    if (obj) {var encmeth=obj.value} else {var encmeth=''}
	    var ret=cspRunServerMethod(encmeth,"",cRegNo);
	   	if (ret){
			var tmpList=ret.split(CHR_2);
			setElementValue("PatName",tmpList[0],null);
			setElementValue("PatSex",tmpList[1],null);
			setElementValue("PatAge",tmpList[3],null);
			setElementValue("PatHomeAddress",tmpList[5],null);
			setElementValue("PatJobComponey",tmpList[10],null);
			setElementValue("Papmi",tmpList[21],null);
		}
	}
}

InitForm();
