
function LookupLoc(str) {
    var arryTmp = str.split(CHR_Up);
    setElementValue("txtCtLoc", arryTmp[2]);
    setElementValue("txtCtLocDr", arryTmp[0]);
}

function btnQueryOnclick() {
	if(getElementValue("txtPacWard")!="") var txtPacWardId=getElementValue("txtPacWardId")
	else var txtPacWardId=""
	if(getElementValue("txtCtLoc")!="") var txtAdmDepID=getElementValue("txtAdmDepID")
	else var txtAdmDepID=""
    var strURL = "./websys.default.csp?WEBSYS.TCOMPONENT=DHC.Med.IPBook.List" + 
        "&FromDate=" + getElementValue("txtFromDate") +
        "&ToDate="  + getElementValue("txtToDate") +
        "&CtLoc="  + txtAdmDepID+
        "&State=" + getElementValue("cboState")+
        "&RegNo=" + getElementValue("Regno")+
        "&CtLocId=" + txtAdmDepID+
        "&PacWardId=" + txtPacWardId;
    window.parent.frames["RPList"].location.href = strURL;
    ///getElementValue("txtCtLocDr") +
}

function LookUpadmdep(str) {
    var obj = document.getElementById('txtAdmDepID');
    var tem = str.split("^");
    obj.value = tem[0];
    setElementValue("txtCtLoc", tem[1]);
    setElementValue("txtCtLocDr", tem[0]);
}

function InitForm() {
    var arryStateDic = QueryDicItemByTypeFlag("MethodQueryDicItemByTypeFlag", "IPBookingState", "Y");
    var objDic = null;
    AddListItem("cboState", "", "");
    for (var i = 0; i < arryStateDic.length; i++) {
        objDic = arryStateDic[i];
        AddListItem("cboState", objDic.Desc, objDic.RowID)
    }
    MakeComboBox("cboState");
    InitEvents();
    var objState=document.getElementById("stateIndex")
    var objCboState=document.getElementById("cboState")
    if(objState) objCboState.selectedIndex=objState.value
    //btnQueryOnclick();
    document.getElementById("opcardno").focus();
}

function InitEvents() {
    document.getElementById("btnQuery").onclick = btnQueryOnclick;
	var readcard=document.getElementById('readcard');
	if (readcard) readcard.onclick=readcard_click; 
	var obj=document.getElementById('OPCardType');
	if (obj){
		obj.size=1
		obj.multiple=false;
		loadCardType()
		obj.onchange=OPCardType_OnChange;
	}

	var obj=document.getElementById('opcardno');
	if (obj) obj.onkeydown = CardNo_KeyDown  //CardNoKeydownHandler;
	var obj=document.getElementById('Regno');
	if (obj) obj.onkeydown =RegNoKeydownHandler;
	websys_setfocus('opcardno');
}
function loadCardType(){
	DHCWebD_ClearAllListA("OPCardType");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","OPCardType");	
	}
	OPCardType_OnChange()
}
function readcard_click()
{ 
	websys_setfocus('Regno');
	ReadCardClickHandler();  
}
function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	//var CardEqRowId=GetCardEqRowId();
	var myoptval=DHCWeb_GetListBoxValue("OPCardType");
	var papnoobj=document.getElementById('Regno');
	//var myoptval=tempclear
	//通过读卡按钮时调用函数需要这个
	//m_CCMRowID=GetCardEqRowId();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	//AccAmount=myary[3];

	switch (rtn){
		case "0": //
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				papnoobj.value=PatientNo
				document.getElementById("opcardno").value=CardNo
			break;
		case "-200": //
			alert(t['InvaildCard']);
			websys_setfocus('opcardno');
			break;
		case "-201": //
			//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
				papnoobj.value=PatientNo
				document.getElementById("opcardno").value=CardNo								
			break;
		default:
	}
}
function OPCardType_OnChange()
{   var myoptval=DHCWeb_GetListBoxValue("OPCardType");	
	var myary=myoptval.split("^");		
	//myary[16]="Handle"
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("opcardno");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("readcard");
		
	}
	else
	{
		var myobj=document.getElementById("opcardno");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("readcard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadCardClickHandler;
		}
	}
	if (myary[16]=="Handle"){
		 websys_setfocus("opcardno");
	}else{
		 websys_setfocus("readcard");
	}
	
	m_CardNoLength=myary[17];
	
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=DHCWeb_GetListBoxValue("OPCardType");
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId
}
/*function CardNoKeydownHandler()
{
	var key=websys_getKey(e);
	if (key==13) {
        var CardNo=DHCC_GetElementData("opcardno");
		for(var i=0; i<CardNo.length; i++)
		{
			if(CardNo.charAt(i)<'0' || CardNo.charAt(i)>'9')
			{
				CardNo=CardNo.replace(CardNo.charAt(i),"")
				i=i-1
			}
		}        
        var objCardNo=document.getElementById("opcardno");
        var cardLen=CardNo.length
        for(var i=0;i<15-cardLen;i++)
        {
	        CardNo="0"+CardNo
        }
        objCardNo.value=CardNo
        if (CardNo=="") return;
        var GetRegNoByCardNo=document.getElementById('GetRegNoByCardNo').value;
		var ret=cspRunServerMethod(GetRegNoByCardNo,CardNo);
		var regNoObj=document.getElementById('Regno');
		if((regNoObj)&&(ret!="")) 
		{
			regNoObj.value=ret;
			websys_setfocus('Regno');
			btnQueryOnclick();
		}
	}
}*/
function CardNoKeydownHandler(e) {
	if (evtName=='opcardno') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
        var CardNo=DHCC_GetElementData("opcardno");
        var CardTypeRowId=GetCardTypeRowId();
				var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
				var myary=myrtn.split("^");
				var rtn=myary[0];
				var flag=0				
				switch (rtn){
					case "0": //
						var PatientID=myary[4];
						var PatientNo=myary[5];
						var CardNo=myary[1];
						var regNoObj=document.getElementById('Regno');
		        			regNoObj.value=PatientNo;
		        			document.getElementById("opcardno").value=CardNo;
		        			flag=1;			
						break;
					case "-200": //
						alert(t['InvaildCard']);
						websys_setfocus('opcardno');
						flag=0;
						break;
					case "-201": //
						var PatientID=myary[4];
						var PatientNo=myary[5];
						var CardNo=myary[1];
						var regNoObj=document.getElementById('Regno');
		        			regNoObj.value=PatientNo;
		        			document.getElementById("opcardno").value=CardNo;
		        			flag=1;
						break;
					default:
		}
		if(flag) {
			btnQueryOnclick();
		}
	}
}
function RegNoKeydownHandler()
{
	var key=websys_getKey(e);
	if (key==13) {
		var RegNoCon=document.getElementById('RegNoCon');
		var RegNo=document.getElementById('RegNo');
		if((RegNoCon)&&(RegNo.value!=""))
		{
			var ret=cspRunServerMethod(RegNoCon.value,RegNo.value);
			RegNo.value=ret;
			btnQueryOnclick();
		}
		
	}
}
function CardNo_KeyDown()
{
	if(event.keyCode==13) {
	var obj=document.getElementById('HXSpecialCard');	
	if(obj)
	{
		var oldCardNoObj=document.getElementById('opcardno');
		var cardno=	TranslateCard(obj,oldCardNoObj.value);
		oldCardNoObj.value=cardno;
		CardNoKeydownHandler();
		
	}
	}
}
window.onload = InitForm;

