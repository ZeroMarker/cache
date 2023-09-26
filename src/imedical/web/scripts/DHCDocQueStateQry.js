document.body.onload = BodyLoadHandler;
var CardNoLength=0;
var PatientNoLen="";
function BodyLoadHandler() {
	//����
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;
	var obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;
	var obj=document.getElementById('CardNo');
	if (obj) {
		obj.onkeydown = CardNoKeydownHandler;
		//obj.onblur=CheckCardNo
	}
	var obj=document.getElementById('PatientNoLen');
	if (obj) PatientNoLen=obj.value;
	
	ReadCardType();
	var obj=document.getElementById('CardType');
	//��ΪdhtmlXComboFromSelectҪ�ж�isDefualt����,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	combo_CardTypeKeydownHandler();
	var RegNoObj=document.getElementById('PatNo');
	if (RegNoObj) RegNoObj.onkeydown = RegNoObj_keydown;
	var obj=document.getElementById("State");
	if(obj){
		obj.multiple=false;
		obj.size=1;
		obj.options[obj.length]=new Option("","");
		obj.options[obj.length]=new Option("�Ⱥ�","�Ⱥ�");
		obj.options[obj.length]=new Option("����","����");
		obj.options[obj.length]=new Option("����","����");
		obj.options[obj.length]=new Option("����","����");
		obj.options[obj.length]=new Option("����","����");
		obj.options[obj.length]=new Option("�˺�","�˺�");
	}
}
function RegNoObj_keydown(e) {
	if (evtName=='PatNo') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var obj=document.getElementById('PatNo');
		var PatNo=obj.value
		if (PatNo!="") {
			if(PatientNoLen=="")PatientNoLen="10";
			if (PatNo.length<PatientNoLen){
				for (var i=(PatientNoLen-PatNo.length-1); i>=0; i--) {
					//obj.value="0"+obj.value
					PatNo="0"+PatNo
				}
			}
		}
		SetPatientInfo(PatNo,"");
		Find_click();
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
		//DHCWeb_DisBtnA("ReadCard");
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=true;
			obj.onclick="";
		}
		DHCWeb_setfocus("CardNo");
	}else{
		m_CCMRowID=GetCardEqRowId();
		var myobj=document.getElementById("CardNo");
		//if (myobj){myobj.readOnly = true;}
		if (myobj){myobj.readOnly = false;}     //������ ֧�����俨�Ź���
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadCardClickHandler;
		}
		DHCWeb_setfocus("ReadCard");
	}
	
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
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
function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType");
	}
}

function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=combo_CardType.getSelectedValue();
	//alert(CardTypeRowId+"&&"+myoptval)
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	//alert("myrtn+"+myrtn)
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];

	switch (rtn){
		case "0": //����Ч
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
			SetPatientInfo(PatientNo,CardNo);
			event.keyCode=13;
			Find_click(e);				
			break;
		case "-200": //����Ч
			alert(t['InvaildCard']);
			websys_setfocus('PatNo');
			break;
		case "-201": //�ֽ�
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);

			SetPatientInfo(PatientNo,CardNo);
			Find_click();				
			//DHCC_SelectOptionByCode("PayMode","CASH")
			break;
		default:
	}
}
function FindClickHandler(e){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!=""){
		event.keyCode=13;
		CardNoKeydownHandler(e);
		return false;
	}else{
		Find_click();
	}
}
function CardNoKeydownHandler(e) {
	//���Ҫ�뿨����һ��
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		CheckCardNo();
		Find_click()
	}
}
function CheckCardNo(){
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
			case "0": //����Ч���ʻ�
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo);
				
				event.keyCode=13;
				//FID_key(e);				
				break;
			case "-200": //����Ч
				alert(t['InvaildCard']);
				websys_setfocus('CardNo');
				break;
			case "-201": //����Ч���ʻ�
				//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);

				SetPatientInfo(PatientNo,CardNo);
				event.keyCode=13;
				//DHCC_SelectOptionByCode("PayMode","CASH")
				break;
			default:
		}
}
function GetCardNoLength(){
	var CardNoLength="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	//var CardTypeValue=combo_CardType.getActualValue();
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	//return 15
	return CardNoLength;
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

function SetPatientInfo(PatientNo,CardNo){
	//alert("PatientNo+"+PatientNo)
	if (PatientNo!='') {
		DHCC_SetElementData("PatNo",PatientNo);
		//DHCC_SetElementData("PatientID","");
		DHCC_SetElementData("CardNo",CardNo);
		//��Ϊ��ClearPatInfo()ʱ���PatientNo��ֵ���,����Ҫ���¸�ֵ
	
		var encmeth=DHCC_GetElementData('GetPatDetailEncrypt');
		if (encmeth!=""){
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',PatientNo)=='0') {
				var obj=document.getElementById('CardNo');
				obj.className='clsInvalid';
				websys_setfocus('CardNo');
				return websys_cancel();
			}else{
				var obj=document.getElementById('CardNo');
				obj.className='';
				//websys_setfocus('CardNo');
				return websys_cancel();				
			}
		}
	} else {
		websys_setfocus('CardNo');
		return websys_cancel();
	}
}
function SetPatient_Sel(value) {
	try {
		var Patdetail=value.split("^");	
		//DHCC_SetElementData("PatientID",Patdetail[6]);
		//alert(Patdetail[9])
		//var PatNo=document.getElementById("PatNo");
		//if(PatNo)PatNo.value=Patdetail[9];
		DHCC_SetElementData("PatNo",Patdetail[9]);
		//Find_click();
	} catch(e) {
		alert(e.message)
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
	return CardTypeRowId
}
