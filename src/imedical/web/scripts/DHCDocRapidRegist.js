document.body.onload = BodyLoadHandler;
//document.onkeydown=documentkeydown;

var CardNoLength=0;

function BodyLoadHandler() {
	var obj=document.getElementById('PatientNoNew');
	if (obj) obj.onkeydown = PatientNoKeydownHandler;

	//读卡
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;
 
	var obj=document.getElementById('CardNo');
	if (obj) obj.onkeydown = CardNoKeydownHandler;

	var obj=document.getElementById('Save');
	if (obj) obj.onclick = SaveClickHandler;

	ReadCardType();

	var obj=document.getElementById('CardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}

	//科室	
	if (document.getElementById("DepList")){
		var SessionLocID=session['LOGON.CTLOCID'];
		var DepStr=DHCC_GetElementData('DepStr');
		combo_DepList=dhtmlXComboFromStr("DepList",DepStr);
		combo_DepList.enableFilteringMode(true);
		combo_DepList.selectHandle=combo_DepListKeydownhandler;
		//combo_DeptList.keyenterHandle=combo_DeptListKeyenterhandler;
		//combo_DepList.attachEvent("onKeyPressed",combo_DepListKeyenterhandler)
		combo_DepList.setComboValue(SessionLocID);
		DHCC_SetElementData("DepRowId",SessionLocID);
		document.getElementById("DepList").disabled=true;
	}

	//号别
	if (document.getElementById("DocList")){
		combo_MarkCode=dhtmlXComboFromStr("DocList","");
		combo_MarkCode.enableFilteringMode(true);
		combo_MarkCode.selectHandle=combo_MarkCodeKeydownhandler;
		var DepRowId=DHCC_GetElementData("DepRowId");
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if (encmeth!=""){
			var DocStr=cspRunServerMethod(encmeth,session['LOGON.USERID'],DepRowId);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				if (combo_MarkCode) combo_MarkCode.addOption(Arr);
				if (DocStr.indexOf("^") < 0) {
					var DefaultMarkID=DocStr.split(String.fromCharCode(1))[0]
					combo_MarkCode.setComboValue(DefaultMarkID);
					DHCC_SetElementData("DocRowId",DefaultMarkID);
					document.getElementById("DocList").disabled=true;
				}
			}
		}
	}
	combo_CardTypeKeydownHandler();
}
function SaveClickHandler(){
	var DepRowId=DHCC_GetElementData("DepRowId");
	var DocRowId=DHCC_GetElementData("DocRowId");
	if (DepRowId=="")DocRowId=session['LOGON.CTLOCID'];
	
	if (DocRowId=="") {
		alert("请选择号别.");
		return;
	}
	var UserID=session['LOGON.USERID'];
	var ASRowId="";
	var encmeth=DHCC_GetElementData("GetRapidASRowId");
	if (encmeth!=""){
		ASRowId=cspRunServerMethod(encmeth,DepRowId,"","","","",DocRowId);
	}
	
	var PatientID=DHCC_GetElementData("PatientID");
	if (PatientID==""){
		alert("请输入病人卡号或登记号.");
		return;
	}
	
	var FeeStr="1||1||0||0";
	var conFlag=confirm("是否收取诊查费?");
	if (conFlag==false) FeeStr="0||0||0||0";
	
	var GroupID=session['LOGON.GROUPID'];
	var encmeth=DHCC_GetElementData("SaveAdm");
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,PatientID,ASRowId,"",FeeStr,UserID,GroupID,DepRowId,DocRowId);
		var TempArr=ret.split("^");
		if (TempArr[0]!="0"){
			if (TempArr[0]=="-101") {
				alert("没有找到出诊记录,或者从未排班.");
			}else if (TempArr[0]=="-102") {
				alert("此病人已经存在相同的登记记录,请使用病人列表查询.");
			}else{
				alert("失败! 错误代码:"+ret);
			}
		}else{
			alert("成功!");
			var GetStartTMENUObj=document.getElementById("GetStartTMENU");			
			if (GetStartTMENUObj){	
				var GroupID=session["LOGON.GROUPID"];
				var GetStartTMENUMethod=GetStartTMENUObj.value;
				var StartTMENU=cspRunServerMethod(GetStartTMENUMethod,GroupID);	
				
				var EpisodeID=TempArr[1]	
				//var frm=parent.parent.parent.document.forms['fEPRMENU'];
				var frm=dhcsys_getmenuform();
				var frmPatientID=frm.PatientID;
				var frmEpisodeID=frm.EpisodeID;
				var frmmradm=frm.mradm;
				var mradm=""
				
				frmPatientID.value=PatientID;
				frmEpisodeID.value=EpisodeID;
				frmmradm.value=mradm;
				
				var lnk="websys.csp?a=a&TMENU="+StartTMENU;
				//var lnk="websys.csp?a=a&TMENU=56395&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
				
				if (StartTMENU!=""){
					//获取相应菜单表达式
					var ValueExpression=tkMakeServerCall("web.DHCDocOrderEntry", "GetValueExpressionByMenuId", StartTMENU)
					if (ValueExpression!="") lnk=lnk+ValueExpression.replace(/^[\'\"]+|[\'\"]+$/g,"");
				}
				window.location=lnk;
				
			}
		}
	}
}

function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCC_AddToListA","CardType");
	}
}
function combo_CardTypeKeydownHandler(){
	var myoptval=combo_CardType.getSelectedValue();
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR=="")	{	return;	}
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo");
	}	else{
		
		m_CCMRowID=GetCardEqRowId();
		var myobj=document.getElementById("CardNo");
		//if (myobj){myobj.readOnly = true;}
		if (myobj){myobj.readOnly = false;}     //郭荣勇 支持手输卡号功能
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			DHCC_AvailabilityBtn(obj)
			obj.onclick=ReadCardClickHandler;
		}
		DHCWeb_setfocus("ReadCard");
	}
	
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}
function combo_DepListKeydownhandler(e){
	var DepRowId=combo_DepList.getSelectedValue();
	DHCC_SetElementData("DepRowId",DepRowId);
	//号别
	    combo_MarkCode.clearAll();
		combo_MarkCode.setComboText("");
		DHCC_SetElementData('DocRowId','');
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if (encmeth!=""){
			var DocStr=cspRunServerMethod(encmeth,session['LOGON.USERID'],DepRowId);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				if (combo_MarkCode) combo_MarkCode.addOption(Arr);
				if (DocStr.indexOf("^") < 0) {
					var DefaultMarkID=DocStr.split(String.fromCharCode(1))[0]
					combo_MarkCode.setComboValue(DefaultMarkID);
					DHCC_SetElementData("DocRowId",DefaultMarkID);
					document.getElementById("DocList").disabled=true;
				}
			}
		}
	//end
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		websys_nexttab(combo_DepList.tabIndex);
	}
}
function combo_MarkCodeKeydownhandler(e){
	var DocRowId=combo_MarkCode.getSelectedValue();
	DHCC_SetElementData("DocRowId",DocRowId);
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		websys_nexttab(combo_MarkCode.tabIndex);
	}
}
function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	myrtn=myrtn.toString();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];

	switch (rtn){
		case "0": //卡有效
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo,PatientID);
				event.keyCode=13;			
			break;
		case "-200": //卡无效
			alert(t['InvaildCard']);
			websys_setfocus('RegNo');
			break;
		case "-201": //现金
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
			SetPatientInfo(PatientNo,CardNo,PatientID);
			
			//DHCC_SelectOptionByCode("PayMode","CASH")
			break;
		default:
	}
}
function CardNoKeydownHandler(e) {
	//这边要与卡处理一致
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {

		var CardNo=DHCC_GetElementData("CardNo");
		var CardTypeRowId=GetCardTypeRowId();
		var CardNo=FormatCardNo();

		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		//alert(myrtn);
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];
		switch (rtn){
			case "0": //卡有效有帐户
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo,PatientID);
				event.keyCode=13;		
				break;
			case "-200": //卡无效
				DHCC_SetElementData("PatientNoNew","");
				DHCC_SetElementData("PatName","");
				alert(t['InvaildCard']);
				websys_setfocus('CardNo');
				
				break;
			case "-201": //卡有效无帐户
				//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				//SetPatientInfo("","","");
				SetPatientInfo(PatientNo,CardNo,PatientID);
				event.keyCode=13;
				//DHCC_SelectOptionByCode("PayMode","CASH")
				break;
			default:
		}
	}
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	DHCC_SetElementData("PatientID",PatientID);
	DHCC_SetElementData("PatientNo",PatientNo);
	DHCC_SetElementData("CardNo",CardNo);
	
	if (PatientID!=""){
		var encmeth=DHCC_GetElementData("GetPatInfo");
		if (encmeth!=""){
			var PatInfo=cspRunServerMethod(encmeth,PatientID);
			var tempArr=PatInfo.split("^");
			var PatName=tempArr[2];
			var PatEncryptLevel=tkMakeServerCall("web.DHCBL.CARD.UCardPaPatMasInfo","GetPatEncryptLevel",PatientID,"");
			//alert(PatEncryptLevel)
			if (PatEncryptLevel!="") {
				var PatEncryptLevelArr=PatEncryptLevel.split("^");
				var obj1=document.getElementById("PoliticalLevel");
				if(obj1) obj1.value=PatEncryptLevelArr[1];
				var obj1=document.getElementById("SecretLevel");
				if(obj1) obj1.value=PatEncryptLevelArr[0];
			}
			DHCC_SetElementData("PatName",PatName);
			if (combo_MarkCode) combo_MarkCode.DOMelem_input.focus();
		}
	}
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}
function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();   //BY guorongyong 取所选卡类型传出字符串 2008-02-27
    //var CardTypeValue=tempclear
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}
function GetCardEqRowId(){
	var CardEqRowId="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}
function PatientNoKeydownHandler(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var m_PatientNoLength=""
		if (document.getElementById("PatientNoLen")){
			m_PatientNoLength=document.getElementById("PatientNoLen").value;
		}
		if (m_PatientNoLength=="") return;
		var PatientNoNewobj=document.getElementById("PatientNoNew");
		if (PatientNoNewobj.value!=""){
			if ((PatientNoNewobj.value.length<m_PatientNoLength)&&(m_PatientNoLength!=0)) {
				for (var i=(m_PatientNoLength-PatientNoNewobj.value.length-1); i>=0; i--) {
					PatientNoNewobj.value="0"+PatientNoNewobj.value;
				}
			}
		}
		CheckPatientNoNew();
	}
	
}
function CheckPatientNoNew()
{
	   var PatientNoNew=DHCC_GetElementData("PatientNoNew");
	   var CardNoStr=tkMakeServerCall('web.DHCOPAdmReg','GetCardNoByPatientNo',PatientNoNew);
	    var CardNo=CardNoStr.split("^")[0]
		if (CardNo=="") {
			alert("该登记号无对应卡号信息，请建卡！");
			DHCC_SetElementData("CardNo","");
			DHCC_SetElementData("PatName","");
			SetPatientInfo("","","")
			return;
		}
		var NewCardTypeRowId=CardNoStr.split("^")[1]
	    combo_CardType.setComboValue(NewCardTypeRowId);
		DHCC_SetElementData("CardNo",CardNo);
		CardNoKeydownHandlerNew();

}

function CardNoKeydownHandlerNew(e) {
	/*
	//这边要与卡处理一致
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
	*/
		var CardNo=DHCC_GetElementData("CardNo");
		var CardTypeRowId=GetCardTypeRowId();
		var CardNo=FormatCardNo();

		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		//alert(myrtn);
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];
		
		switch (rtn){
			case "0": //卡有效有帐户
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo,PatientID);
				event.keyCode=13;		
				break;
			case "-200": //卡无效
				alert(t['InvaildCard']);
				websys_setfocus('CardNo');
				break;
			case "-201": //卡有效无帐户
				//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);

				SetPatientInfo(PatientNo,CardNo,PatientID);
				event.keyCode=13;
				//DHCC_SelectOptionByCode("PayMode","CASH")
				break;
			default:
		}
	//}
}