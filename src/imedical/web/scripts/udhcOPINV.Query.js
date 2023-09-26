////udhcOPINV.Query.js
var m_CardNoLength,m_SelectCardTypeDR;
var m_SelectCardTypeRowID;

function bodyLoadHandler(){
	ValidateDocumentData()
	var TabListObj=document.getElementById("tudhcOPINV_Query");
	if (TabListObj){
		TabListObj.ondblclick=AdmSelect_Click;
	}	
	
	var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
	}
	
	CardTypeDefine_OnChange();
	var obj=document.getElementById("CardNo");
	if (obj){
		if (obj.type!="Hiden"){
			obj.onkeydown=RCardNo_KeyDown;
		}
	}
	
	var Obj=document.getElementById('ReadCard');
	if (Obj) {Obj.onclick = ReadHFMagCard_Click;}
	
	document.onkeydown = Doc_OnKeyDown;
   
   var framNameObj=document.getElementById("FramName");
   if((framNameObj)&&(framNameObj.value=="")){ 
		if((parent)&&(parent.window)&&(parent.window.opener)){
			framNameObj.value=parent.window.opener.FramName;	
		}
   }
    /*
    var obj=document.getElementById('CardTypeDefine');
	if (obj) {
	          ReadCardType();
	          obj.setAttribute("isDefualt","true");
	          combo_CardType=dhtmlXComboFromSelect("CardTypeDefine");
	          }
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	
	combo_CardTypeKeydownHandler();
    */
	var PatNONode=websys_$('PatientNO');
	if(PatNONode){
		PatNONode.onkeydown=PatientID_KeyDown
	}
	IntDoc();
	
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
		///DHCWeb_DisBtnA("ReadPCSC");
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
			obj.onclick=ReadHFMagCard_Click;
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

function SetCardNOLength(){
	var obj=document.getElementById('CardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=obj.value;
			}
		}
}
function ValidateDocumentData()
{
	var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.size=1;
		myobj.multiple=false;
		//myobj.onchange=CardTypeDefine_OnChange;
	}
		
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function IntDoc(){
	var obj=document.getElementById("PatientNO");
	if ((obj)&&(obj.value!="")){
		///obj.readOnly=true;
	}

	
}
function RCardNo_KeyDown(){
	var e = event?event:(window.event?window.event:null);
	var key = websys_getKey(e);
	if ((key==13)){
	  
		SetCardNOLength();

		var myCardNo=DHCWebD_GetObjValue("CardNo");
		var mySecurityNo="";
		
		///var myrtn=DHCACC_GetAccInfo();
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo,"PatInfo")
		var myary=myrtn.split("^");
		//alert(myary);
		var rtn=myary[0];
		switch (rtn){
			case "0":
				///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
				var obj=document.getElementById("PatientID");
				obj.value=myary[5];
				var obj=document.getElementById("CardNo");
				DHCWebD_SetObjValueB("CardNo",myary[1]);
				
				break;
			case "-200":
				alert(t["-200"]);
				break;
			case "-201":
				var myPAPMNo=myary[5];
				var obj=document.getElementById("PatientID");
				if(obj){
					obj.value = myary[5];
				}
				var obj=document.getElementById("PatientNO");
				if(obj){
					obj.value = myary[5];
				}
				DHCWebD_SetObjValueB("CardNo",myary[1]);
				break;
			default:
				///alert("");
		}
		
		return;
	}
}
function Doc_OnKeyDown()
{
	var e = event?event:(window.event?window.event:null);
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
	
	///F7
	///F8
	///F9
	///F8	119   查询
	///Alt+R
	switch (key){
		case 119:
			Find_click();
			break;
		case 115:
			ReadHFMagCard_Click();
			break;
	}
	
	DHCWeb_EStopSpaceKey();
}


function AddLink(){
	///add Link to Table;
	///onclick;
	var TabListObj=document.getElementById("tudhcOPINV_Query");
	if (TabListObj){
		var rowidxs=TabListObj.rows.length;  ///-1
		for (var i=1;i<rowidxs;i++){
			alert(i);
			var selobj=document.getElementById("TINVRowidz"+i);
			if (selobj){
				selobj.ondblclick=SetParValue;
			}
		}
	}
}

function AdmSelect_Click()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	if (rowObj.tagName=='TH') return;
	var row=rowObj.rowIndex;
	var RecRowId=document.getElementById('TINVRowidz'+row).value;
	var ReloadFlag="PRT";
	var InvType="PRT"
	var myobj=document.getElementById('InvTypez'+row);
	if (myobj)  InvType=DHCWebD_GetCellValue(myobj)
	if (InvType=="API")  ReloadFlag="API";
	var myobj=document.getElementById('TINVNOz'+row);
	var myReceipNO=DHCWebD_GetCellValue(myobj);
	InitRefundMain(ReloadFlag,RecRowId, myReceipNO)
	window.close();
}

function InitRefundMain(Reload,ReceipID, myReceipNO){
	var fobj=document.getElementById("FramName");
	if (fobj){
		var framName=fobj.value;
	}
	
	var myary=framName.split("_");
	var comName=myary.join(".");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+comName
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+comName+"&ReloadFlag="+Reload
	//lnk=lnk+"&ReceipID="+ReceipID+"&ReceipNO="+myReceipNO ;
	lnk=lnk+"&ReceipID="+ReceipID+"&ReceipNO="+myReceipNO+"&TabFlag="+Reload ;

	var PatInfo=opener.parent.frames(framName);
	PatInfo.location.href=lnk;
	
	///alert();
}


function SetParValue(){
	var par_win=window.opener;
	
	if (!parwin){
		return;
	}
	var TabListObj=document.getElementById("udhcOPINV_Query");
	var vIdx=TabListObj.rows.selectedIndex;
}
function CardNo_OnKeyDown()
{
	var e = event?event:(window.event?window.event:null);
	var key = websys_getKey(e);
	if ((key==13)){
		///var myDHCVersion=DHCWebD_GetObjValue("DHCVersion");
		////switch (myDHCVersion){
		///	case "7":
		var myTMPRCardNo=DHCWebD_GetObjValue("CardNo");
		myTMPRCardNo=DHCWeb_replaceAll(myTMPRCardNo,";","")
		myTMPRCardNo=DHCWeb_replaceAll(myTMPRCardNo,"?","")
		DHCWebD_SetObjValueB("CardNo",myTMPRCardNo);
		SetCardNOLength();
	}
}

function SetCardNOLength(){
	var obj=document.getElementById('CardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=obj.value;
			}
		}
}

function ReadMagCard_Click()
{
	//m_CCMRowID  == HardType
	//var rtn=DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	var myCCMRowID="";
	var myval=myCombAry["CardTypeDefine"].getSelectedValue();
	myCCMRowID=myval.split("^")[14];
	if ((myCCMRowID=="")||(myCCMRowID==null)){
		return;
	}
	var rtn=DHCACC_ReadMagCard(myCCMRowID);
	
	var myary=rtn.split("^");
	if (myary[0]=='0'){
		DHCWebD_SetObjValueB("CardNo",myary[1]);
		///CardVerify=myary[2];
		//m_CardValidateCode=myary[2];
		///m_CardSecrityNo=myary[2];
		///GetValidatePatbyCard();
	}
}

function ReadHFMagCard_Click(){

	var myCardTypeValue=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,myCardTypeValue);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("PatientNO");
			obj.value=myary[5];
			Find_click();
			//ReadCardQueryINV(myary[5]);
			break;
		case "-200":
			alert("无效卡");
			break;
		case "-201":
		    var obj=document.getElementById("PatientNO");
			obj.value=myary[5];
			Find_click();
			//ReadCardQueryINV(myary[5]);
			break;
		default:	
	    }
	
	}
function ReadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function combo_CardTypeKeydownHandler(){
	//var myoptval=combo_CardType.getActualValue();
	var myoptval=combo_CardType.getSelectedValue();
	
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeRowID=myCardTypeDR
	
	if (myCardTypeDR=="")	{	return;	}


}

function PatientID_KeyDown(){
	if(window.event.keyCode==13){
		var PatIDNode=websys_$("PatientNO");
		if((PatIDNode)&&(PatIDNode.value!="")){
			var PatNo=PatIDNode.value;
			PatNo=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",PatNo);
			PatIDNode.value=PatNo;
			var myExpStr="";
			var PatDr=tkMakeServerCall("web.DHCOPCashierIF","GetPAPMIByNo",PatNo,myExpStr);
			if (PatDr=="") {
				PatIDNode.value="";
				alert('登记号错误,请重新输入?');
				PatIDNode.className='clsInvalid';
				websys_setfocus('PatientID');
				return websys_cancel();
			} else {
				PatIDNode.className='clsvalid';
			}
		}
	}
}

document.body.onload=bodyLoadHandler;
