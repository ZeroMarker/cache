
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);


var m_CardNoLength=0;
var m_SelectCardTypeDR="";

function loadCardType()
{
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}

function SetCardNoLength(){
	var obj=document.getElementById('CardNo');
	if (obj.value!='') 
	{
		if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) 
		{
			for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--)
			{
				obj.value="0"+obj.value;
			}
		}
	}
}

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

function ReadCard_Click()
{
	ClearItems();
	var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
    var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    var CardSubInform=CardInform.split("^");
    var rtn=CardSubInform[0];
    switch (rtn){
		case "-200":                    //Card Invalid
			alert(t["CardInvalid"]);
			break;
		default:                        //rtn is 0 or -201
			var CardNo=CardSubInform[1];
			var PatNo=CardSubInform[5];
			setElementValue("CardNo",CardNo,null);
			setElementValue("PatNo",PatNo,null);
			break;
	}
	xPatNoOnKeyDown();
}

function CardNo_OnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	SetCardNoLength();
	var CardNo=getElementValue("CardNo",null);
	ClearItems();
    var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,CardNo,"","PatInfo")
    var CardSubInform=CardInform.split("^");
    var rtn=CardSubInform[0];
    switch (rtn){
		case "-200":    //Card Invalid
			alert(t["CardInvalid"]);
			break;
		default:        //rtn is 0 or -201
			var CardNo=CardSubInform[1];
			var PatNo=CardSubInform[5];
			setElementValue("CardNo",CardNo,null);
			setElementValue("PatNo",PatNo,null);
			break;
		}
	xPatNoOnKeyDown();
	return false;
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
	var obj=document.getElementById('CardTypeDefine');
	if (obj){
		obj.onchange=CardTypeDefine_OnChange;
		obj.size=1;
		obj.multiple=false;
	}
	loadCardType();
	CardTypeDefine_OnChange();
	
	var obj=document.getElementById("ReadCard");
	if (obj){
		obj.onclick=ReadCard_Click;
	}
	
	var obj=document.getElementById("CardNo");
	if (obj){
		obj.onkeydown=CardNo_OnKeyDown;
	}
	
	var obj=document.getElementById("PatNo");
	if (obj){
		obj.onkeydown=PatNo_OnKeyDown;
	}
}

function ClearItems()
{
	setElementValue("CardNo","",null);
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
	var OMrType = document.getElementById("OMrType").value;
	var IMrType = document.getElementById("IMrType").value;
	var sWorkItem= document.getElementById("sWorkItem").value;
	var sReqType= document.getElementById("sReqType").value;
	var cPapmi="",cAdmType="",cAdmDate="";
	var obj=document.getElementById("Papmi");
	if (obj){cPapmi=obj.value;}
	var obj=document.getElementById("AdmDate");
	if (obj){cAdmDate=obj.value;}
	var obj=document.getElementById("AdmType");
	if (obj){cAdmType=obj.value;}
	if ((!cPapmi)||(!cAdmDate)) return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ReqFirstFlag.List"+"&AdmDate="+cAdmDate+"&Papmi="+cPapmi+"&AdmType="+cAdmType+"&FirstFlag=No"+"&OMrType="+OMrType+"&IMrType="+IMrType+"&sWorkItem="+sWorkItem+"&sReqType="+sReqType+"&FirstFlg=N";
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
