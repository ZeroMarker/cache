var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var CardNoObj;
var CardTypeDefineObj;
var combo_LookPAPERCountryDR ;
var combo_LookPAPERNationDR;
var comb_ProvinceInfo;
var comb_LookPAPERCityCodeDR;
var comb_CTRelation;
var comb_LookPAPERSexDR;
var comb_LookPAPERSocialStatusDR;
var comb_CardTypeDefine;
var comb_PAPMICardType;
//var comb_PayMode;
var comb_Zip;
var comb_PAPEROccupationDR;
var SelectedRowIndex 
var LogStr
var FormerEastIPNo=""
var FormerWestIPNo=""
var EastIPNo=""
var WestIPNo=""
///���֤�����ֶ�
var m_IDCredTypePlate = "01";
var HospitalCode="";
var comb_PAPERMarital;
var comb_SecretLevel;
var comb_PoliticalLevel;
var comb_HCPDR;

document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	HospitalCode=DHCWebD_GetObjValue("HospitalCode");
	$('CardTypeDefine').setAttribute("isDefualt","true");
	var myobj=document.getElementById('CardTypeDefine');
	/*if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}

	loadCardType()

	//CardTypeDefine_OnChange()
	*/
	loadCardType();

	//myobj.selectindexchange=CardTypeSelectChangeHandler();
	comb_CardTypeDefine=dhtmlXComboFromSelect("CardTypeDefine");
	comb_CardTypeDefine.enableFilteringMode(true);
	//comb_CardTypeDefine.selectHandle=CardTypeDefine_OnChange();
	//comb_CardTypeDefine.disable(true);
	$('CardNo').onblur = 	SetCardNoLength;

	$('BtnUpdate').onclick = BtnUpdate_Click;

	loadCredType();
	comb_PAPMICardType = dhtmlXComboFromSelect("PAPMICardType");
	comb_PAPMICardType.enableFilteringMode(true);
		
	comb_PAPEROccupationDR= new dhtmlXComboFromSelect("LookPAPEROccupationDR");
	comb_PAPEROccupationDR.enableFilteringMode(true);

	DHCWebD_ClearAllListA("Sex");
	var encmeth=DHCWebD_GetObjValue("ReadSex");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","LookPAPERSexDR");
	}
	comb_LookPAPERSexDR =new dhtmlXComboFromSelect("LookPAPERSexDR");
	comb_LookPAPERSexDR.enableFilteringMode(true);

	DHCWebD_ClearAllListA("LookPAPERSocialStatusDR");
	var encmeth=DHCWebD_GetObjValue("ReadPatType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","LookPAPERSocialStatusDR");
	}
	comb_LookPAPERSocialStatusDR = new dhtmlXComboFromSelect("LookPAPERSocialStatusDR");
	comb_LookPAPERSocialStatusDR.enableFilteringMode(true);

	m_CardNoLength=GetCardNoLength();
	document.onkeydown=nextfocus1;	
	var mydata=$V("CTCountryData");
	$("LookPAPERCountryDR").setAttribute("isPre","true");
	$("LookPAPERCountryDR").setAttribute("isDefualt","true");		
	combo_LookPAPERCountryDR=new dhtmlXComboFromSelect("LookPAPERCountryDR",mydata);
	combo_LookPAPERCountryDR.enableFilteringMode(true);

	$("ProvinceInfo").setAttribute("isPre","true");
	$("ProvinceInfo").setAttribute("isDefualt","true");
	comb_ProvinceInfo = new dhtmlXComboFromSelect("ProvinceInfo","");
	comb_ProvinceInfo.enableFilteringMode(true);
	$("LookPAPERCityCodeDR").setAttribute("isPre","true");
	$("LookPAPERCityCodeDR").setAttribute("isDefualt","true");         
	comb_LookPAPERCityCodeDR = new dhtmlXComboFromSelect("LookPAPERCityCodeDR","");
	comb_LookPAPERCityCodeDR.enableFilteringMode(true);
	$("LookPAPERZipDR").setAttribute("isPre","true");   
	$("LookPAPERZipDR").setAttribute("isDefualt","true");  
	comb_Zip = new dhtmlXComboFromSelect("LookPAPERZipDR","");
	comb_Zip.enableFilteringMode(true);
	var nationdata = $V("CTNationData");
	$("LookPAPERNationDR").setAttribute("isPre","true");
	combo_LookPAPERNationDR = new dhtmlXComboFromSelect("LookPAPERNationDR",nationdata);
	combo_LookPAPERNationDR.enableFilteringMode(true);

	var relationdata = $V("CTCTRelationData");
	comb_CTRelation =  new dhtmlXComboFromSelect("CTRelation",relationdata);
	comb_CTRelation.enableFilteringMode(true);

	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","CTMarital","");
	var myobj=document.getElementById("PAPERMarital");
	if (myobj){
		comb_PAPERMarital=new dhtmlXComboFromSelect("PAPERMarital",mydata);
		comb_PAPERMarital.enableFilteringMode(true);
	}
	//���˼���
  	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","PoliticalLevel","");
	var myobj=document.getElementById("PoliticalLevel");
	if (myobj){
		comb_PoliticalLevel=new dhtmlXComboFromSelect("PoliticalLevel",mydata);
		comb_PoliticalLevel.enableFilteringMode(true);
	}
	//�����ܼ�
  	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","SecretLevel","");
	var myobj=document.getElementById("SecretLevel");
	if (myobj){
		comb_SecretLevel=new dhtmlXComboFromSelect("SecretLevel",mydata);
		comb_SecretLevel.enableFilteringMode(true);
	}
	
	//��ͬ��λ
	var mydata=tkMakeServerCall("web.DHCBL.CTBASEIF.ICTCardRegLB","ReadBaseData","HCPDR","");
	var myobj=document.getElementById("HCPDR");
	if (myobj){
		comb_HCPDR=new dhtmlXComboFromSelect("HCPDR",mydata);
		comb_HCPDR.enableFilteringMode(true);
	}
	

	//var ProvinceInfo = $("ProvinceInfo");  
	combo_LookPAPERCountryDR.attachEvent("onChange",function(event){ 
		setProvinceData();
	});
	//comb_ProvinceInfo.DOMelem_input.onfocus=function()
	//{
	//	setProvinceData();
	// }

	comb_ProvinceInfo.attachEvent("onChange",function(event){
		setCityData();
		setZipData();
	});
	//comb_LookPAPERCityCodeDR.DOMelem_input.onfocus=function()
	//{
	//	setCityData();
	//}
	comb_LookPAPERCityCodeDR.attachEvent("onChange",function(event){
	setZipData();
	})
	//comb_LookPAPERCityCodeDR.DOMelem_input.onblur = function()
	//{
	// setZipData();
	// }

	//   comb_Zip.DOMelem_input.onfocus=function()
	// {
	//    setZipData();	
	//  } 
	
	quickK.f8=BtnSearch_click;
	quickK.f9=BtnUpdate_Click;
	quickK.addMethod();
	InitAddNewInform();
	textimemode();

	var obj=document.getElementById('EastOPMedicareNo');
	if(obj) { obj.onchange =EastOPMedicareNoChange;}
	var obj=document.getElementById('EastIPMedicareNo');
	if(obj) { obj.onchange =EastIPMedicareNoChange;}
	var obj=document.getElementById('WestOPMedicareNo');
	if(obj) { obj.onchange =WestOPMedicareNoChange;}
	var obj=document.getElementById('WestIPMedicareNo');
	if(obj) { obj.onchange =WestIPMedicareNoChange;}

	var obj=document.getElementById('InsuranceNo');
	if(obj) { obj.onchange =InsuranceNoChange;}

	var obj=document.getElementById('BtnTransPatInform');
	if(obj) { obj.onclick =TransPatInformClick;}

	if (Obj) Obj.onclick = B_ReadCard;
	var Obj=document.getElementById('ReadCard');
	
 	var obj=document.getElementById('InsuranceNo');
	if(obj) var InsuNo=obj.value ;
	obj.value=InsuNo.toLocaleUpperCase();    //ҽ���ŵ����һλ'S',��ʾΪ��д
	websys_setfocus('CardNo');							 //���Ĭ�ϵ������ϡAxp,080418	
	var TPAPERNamez1obj=document.getElementById('TPAPERNamez1');
	if (TPAPERNamez1obj){
		HighlightRow_OnLoad("TPAPERNamez1");
	}else{
		websys_setfocus('CardNo');	
	}
	var obj=document.getElementById('PAPERID');
	if(obj)obj.onblur=PAPERID_OnKeyPress;
	
	//������������б���
	var myobj=document.getElementById('PAPERAge');
	if (myobj){
		myobj.onblur=PAPERAge_OnBlur;
		myobj.onkeypress=PAPERAge_OnKeypress;
	}
	var myobj=document.getElementById('PAPEREmail');
	if (myobj){
		myobj.onblur=PAPEREmail_OnBlur;
	}
	//$("PAPERDob").onblur=function (){$("PAPERDob").value = $("PAPERDob").value.toDate();}
	var myobj=document.getElementById('PAPERDob');
	if (myobj){
		myobj.onblur=PAPERDob_OnBlur;
	}
	var myobj=document.getElementById('OtherCredType');
	if (myobj){
		myobj.onclick=OtherCredTypeInput;
	}
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}

function PAPERDob_OnBlur()
{
	$("PAPERDob").value = $("PAPERDob").value.toDate();
	if ($("PAPERDob").value=="") return;

	var mybirth=DHCWebD_GetObjValue("PAPERDob");
	/*	
	if ((mybirth!="")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("PAPERDob");
		alert("��������ȷ������");
		websys_setfocus("PAPERDob");
		return websys_cancel();
	}else{
		var obj=document.getElementById("PAPERDob");
		obj.className='clsvalid';
	}	
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("PAPERDob",mybirth);
	}
	*/
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("PAPERDob");
		alert("��������ȷ������");
		websys_setfocus("PAPERDob");
		return websys_cancel();
	}else{
		var myAge=DHCWeb_GetAgeFromBirthDay("PAPERDob");
		DHCWebD_SetObjValueA("PAPERAge",myAge);
	}
	var mybirth1=DHCWebD_GetObjValue("PAPERDob");
	var Checkrtn=CheckBirth(mybirth1);
	if(Checkrtn==false){
		alert('�������ڲ��ܴ��ڽ������С�ڡ�����1840��!');
		websys_setfocus("PAPERDob");
		return websys_cancel();
	}

}
function CheckBirth(Birth)
{
	var Year,Mon,Day,Str;
	Str=Birth.split("-")
	Year=Str[0];
	Mon=Str[1];
	Day=Str[2];
	
	var Today,ToYear,ToMon,ToDay;
	Today=new Date();
	ToYear=Today.getYear();
	ToMon=(Today.getMonth()+1);
	ToDay=Today.getDate();
	if((Year > ToYear)||(Year<=1840)){
		return false;
	}
	else if((Year==ToYear)&&(Mon>ToMon)){
		return false;
	}
	else if((Year==ToYear)&&(Mon==ToMon)&&(Day>ToDay)){
		return false;
	}
	else {
		return true;
		}
}


function PAPERAge_OnBlur()
{
	var mybirth=DHCWebD_GetObjValue("PAPERDob");
	//if (mybirth==""){
	var myBirth=DHCWeb_GetBirthDayFromAge("PAPERAge");
	if (mybirth==""){
		DHCWebD_SetObjValueA("PAPERDob", myBirth);
	}else{
		var myage = DHCWebD_GetObjValue("PAPERAge");
		if (myage!=""){
			if (isNaN(myage)){myage=0;}
			var mynow = new Date();
	        var yy = mynow.getFullYear();
			var myYear=yy-myage;
			var myMDInfo = mybirth.substring(4, mybirth.length);
			DHCWebD_SetObjValueA("PAPERDob", myYear+""+myMDInfo);
		}
	}
}
function PAPERAge_OnKeypress(){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==45){window.event.keyCode=0;return websys_cancel();}

	if (((keycode>47)&&(keycode<58))||(keycode==46)){
	}else{
		window.event.keyCode=0;return websys_cancel();
	}	
}
function PAPEREmail_OnBlur(){
	var PAPEREmail=DHCWebD_GetObjValue("PAPEREmail");
	if (PAPEREmail!=""){
		var ret=DHCC_CheckEmailIsMatch(PAPEREmail);
		if (ret==false)websys_setfocus("PAPEREmail");
	}
	window.event.keyCode=0;
	return websys_cancel(); 
}

function IsCredTypeID()
{
	var myval=" ";
	if (comb_PAPMICardType.getSelectedText()!="") myval=comb_PAPMICardType.getSelectedValue();
	var myary = myval.split("^");
	if (myary[1]==m_IDCredTypePlate){
		return true;
	}else{
		return false;
	}
}

function PAPERID_OnKeyPress(e){
	//var e=window.event;
	//var mykey=e.keyCode;
	//if (mykey==13){

		var myrtn=IsCredTypeID();
		
		if (myrtn){
			var mypId = DHCWebD_GetObjValue("PAPERID");
			if (mypId!=""){
				var myary=DHCWeb_GetInfoFromId(mypId);
				if (myary[0]=="1"){
					var myBirth=DHCWebD_GetObjValue("PAPERDob");
					DHCWebD_SetObjValueC("PAPERDob",myary[2]);		////Birthday
					var myAge=DHCWebD_GetObjValue("PAPERAge");
					DHCWebD_SetObjValueC("PAPERAge",myary[4]);		////Age
				}else{
					websys_setfocus("PAPERID");
					return;
				}
			}
		}
	//}
}


function B_ReadCard()
{
	//var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myEquipDR=comb_CardTypeDefine.getSelectedValue();//.getActualValue();
    var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    var CardSubInform=CardInform.split("^");
    var rtn=CardSubInform[0];
    switch (rtn){
			case "-200": //����Ч
				alert("����Ч");
				//PapmiNoObj=document.getElementById("PapmiNo");
    			//PapmiNoObj.value="";
    			//CleartTbl()
				break;
			default:
				//alert(myrtn)
				document.getElementById('CardNo').value=CardSubInform[1]
				//alert(document.getElementById('T_ID').value)
				//FindPatQueue()
				
				break;
		}
		
    
}
function loadCardType(){
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
function CardTypeDefine_OnChange()
{
	DHCWeb_GetListBoxValue("CardTypeDefine");
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
			obj.onclick=B_ReadCard;
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
function GetCardTypeRowId(){
	var CardTypeRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=comb_CardTypeDefine.getActualValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

function textimemode()    
{	// �������µ�Ԫ��,ֱ��ת�����뷨,����ʹ�����뷨���л�
	
	if (document.all.SPAPERName)
	{
		document.all.SPAPERName.style.imeMode = "active";
	}
	if (document.all.Address)
	{
		document.all.Address.style.imeMode = "active";
	}
	if (document.all.ForeignName)
	{
		document.all.ForeignName.style.imeMode = "active";
	}
	if (document.all.PAPERAge)
	{
		document.all.PAPERAge.style.imeMode = "disabled";
	}
	if (document.all.PAPERDob)
	{
		document.all.PAPERDob.style.imeMode = "disabled";
	}
	if (document.all.SPAPERID)
	{
		document.all.SPAPERID.style.imeMode = "disabled";
	}
	if (document.all.PAPERTelH)
	{
		document.all.PAPERTelH.style.imeMode = "disabled";
	}
	if (document.all.InsuranceNo)
	{
		document.all.InsuranceNo.style.imeMode = "disabled";
	}
	if (document.all.EastOPMedicareNo)      
	{
		document.all.EastOPMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.WestOPMedicareNo)
	{
		document.all.WestOPMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.EastIPMedicareNo)
	{
		document.all.EastIPMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.WestIPMedicareNo)
	{
		document.all.WestIPMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.PAPERID)
	{
		document.all.PAPERID.style.imeMode = "disabled";
	}
	if (document.all.PAPEREmail)
	{
		document.all.PAPEREmail.style.imeMode = "disabled";
	}
}

function PatYBCodekeydownClick()
{
	if ((HospitalCode!="BJDTYY")&&(HospitalCode!="BJFCYY")) return true;
	//ҽ���źϷ��Ե��ж�
	var obj=document.getElementById('LookPAPERSocialStatusDR');
	var myobj=document.getElementById('InsuranceNo');
	if ((obj.value!="ҽ��")&&(obj.value!="ҽ���ز�")) 
	{	
		var objVal=document.getElementById('InsuranceNo');
		if (objVal.value=='')  {return true;}
		else 
		{	
			alert("����������ҽ���Ų���");
			return false;
		}
	}
	else
	{
		if (myobj.value=="99999999999S") return true;
		var tmp=myobj.value;
		var length=tmp.length;
		if(length!=12)
		{
			alert("ҽ����λ������?");
			return false;
		}
		var numtmp=tmp.substring(0,length-1);
		var numflag=isNumber(numtmp);
		if ((numflag!=true)||((tmp.substring(length-1,length)!="s")&&(tmp.substring(length-1,length)!="S")))
		{
			alert("ҽ���ַ�����?");
			return false;
		}
		else
		{
			return true;     //  	alert("aaaaaaaaaaaaaa")   //  00000000005s
		}
	}
}

function isNumber(objStr){
 strRef = "-1234567890.";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}

function GetCardNoLength(){
	
	/*var CardNoLength="";
	var CardTypeValue=comb_CardTypeDefine.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	*/
	return 12;    //��ʽ������12
}

function nextfocus1() {	
	var eSrc=window.event.srcElement;	
	//var t=eSrc.type;		&& t=='text'
	var key=websys_getKey(e);	
	if (key==13) {	
		
		if (eSrc.name=='CardNo')
		{
			SetCardNoLength();
			BtnSearch_click();			// ͨ�����Ų鲡����Ϣ�Aֱ�Ӵ�������,xp,080418
		}
		websys_nexttab(eSrc.tabIndex);
	}
}

function SetCardNoLength()
{
	m_CardNoLength=GetCardNoLength();
	var obj=document.getElementById('CardNo');
	var objValue=obj.value;
	objValue=objValue.replace(/(^\s*)|(\s*$)/g,"");
		if (objValue!='') {
			if ((objValue.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-objValue.length-1); i>=0; i--) {
					objValue="0"+objValue
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=objValue;
			}
			ChangeCardTypeByCardNo('CardNo',comb_CardTypeDefine,'getcardtypeclassbycardno');
		}
	//ChangeCardTypeByCardNo('CardNo',comb_CardTypeDefine,'getcardtypeclassbycardno');
}

////��Ϊ��̨�����л�ʱ�Ὣ�մ�ת��$C(0),����ʵ�Ŀմ��޷����֣��������ָ���ʱ�;ͻ���ɴ��󣬹�ת�ɿո�
////ͬʱ��web.DHCBL.Patient.DHCPatient.PAPersonUpdateҲ���˶�Ӧ����
function getComboValue(combo){
	var comboValue=" ";
	if (combo.getSelectedText()!="") comboValue=combo.getSelectedValue().split("^")[0];
	return comboValue;
}
function BtnUpdate_Click() {
  
	var rtn=CheckNull();
    if (!rtn){return false;}
    
    //var Rtn=CheckMedNo();               //fddΪ����һ�����������ǼǺŵ�����¸��²��˼�¼��ʱ����
    //if (!Rtn){return false;}            //fdd��ʱ����
    
    
    YBCodeflag=PatYBCodekeydownClick();
	if(YBCodeflag==false) {return false;}

	var returnvalue=UpdateOtherInform()
	if (returnvalue!=0) 
	{
		alert("����ʧ��")
		return 
		//SubRtnValue=returnvalue.split("^");
		//if (SubRtnValue[0]==99999)  alert(""+SubRtnValue[1])
	}
 var CityCodeDR=" ";
 if (comb_LookPAPERCityCodeDR.getSelectedText()!="") CityCodeDR=comb_LookPAPERCityCodeDR.getSelectedValue().split("^")[0];
 var ProvinceCodeDR=" ";
 if (comb_ProvinceInfo.getSelectedText()!="") ProvinceCodeDR=comb_ProvinceInfo.getSelectedValue().split("^")[0];

 var ProvinceCodeDR=" ";
 if (comb_ProvinceInfo.getSelectedText()!="") ProvinceCodeDR=comb_ProvinceInfo.getSelectedValue().split("^")[0];
//�������˽�������
var ParseInfo=["ID="+Trim($V("ID")),
                "PAPERCityAreaDR=",
                "PAPERCityCodeDR="+CityCodeDR,
                "PAPERCountryDR="+getComboValue(combo_LookPAPERCountryDR),
                "PAPERCTProvinceDR="+ProvinceCodeDR,
                "PAPERDob="+$V("PAPERDob"),
                "PAPEREducationDR=",
                "PAPEREmail="+$V("PAPEREmail"),
                "PAPERID="+$V('PAPERID'),
                "PAPERName="+$V("PAPERName"),
                "PAPERNationDR="+combo_LookPAPERNationDR.getSelectedValue().split("^")[0],
                "PAPEROccupationDR="+comb_PAPEROccupationDR.getSelectedValue().split("^")[0],
                "PAPERSexDR="+comb_LookPAPERSexDR.getSelectedValue().split("^")[0],
                "PAPERSocialStatusDR="+comb_LookPAPERSocialStatusDR.getSelectedValue().split("^")[0],
                "PAPERStName=",
                "PAPERTelH="+$V("PAPERTelH"),
               // "PAPERUpdateDate="+$V("PAPERUpdateDate"),
                "PAPERZipDR="+comb_Zip.getSelectedValue().split("^")[0],
                "PAPMIAllergy="+$V("PAPMIAllergy"),
                "TelHome="+$V("PAPERTelH"),
                "PAPERForeignId="+$V("ForeignName"),
                "PAPERCTRLTDR="+comb_CTRelation.getSelectedValue().split("^")[0],
                "PAPERForeignAddress="+$V("Address"),
                "PAPMICardTypeDR="+getComboValue(comb_PAPMICardType),
                "EmployeeNo="+$V("EmployeeNo"),
                "PAPERMarital="+comb_PAPERMarital.getSelectedValue(),
				"PoliticalLevel="+comb_PoliticalLevel.getSelectedValue(),
                "SecretLevel="+comb_SecretLevel.getSelectedValue(),
				"HCPDR="+comb_HCPDR.getSelectedValue(),
                "OtherCardInfo="+$V("OtherCardInfo"),
                "ForeignPhone="+$V("ForeignPhone")]       //��ϵ�˵绰;
var PAPerson=GetEntityClassInfoToXML(ParseInfo);

//���÷���˷���
var BtnUpdateclass=document.getElementById('BtnUpdateclass');
if (BtnUpdateclass) {var encmeth=BtnUpdateclass.value} else {var encmeth=''};
var returnvalue=cspRunServerMethod(encmeth,PAPerson);
if(returnvalue=='0')
{
	alert(t['4']);
	//LogStr=GetUpdateStr(LogStr)
	//SaveUpPersonLog(LogStr)
	EastIPNo=document.getElementById('EastIPMedicareNo').value;	//סԺ������(��)
	WestIPNo=document.getElementById('WestIPMedicareNo').value;	//���ﲡ����(��)
	var obj = $("BtnSearch");
	if (obj) obj.click();
}
else
{
	alert(t['5']);
}
	
//����ǴӹҺŽ���򿪵��򵱸�����͹رմ˽���
var obj=document.getElementById('CardNo');
if (obj)cardno=obj.value;
if (window.name=="QueryReg"){
	var Parobj=window.opener
	var objCardNo=Parobj.document.getElementById("CardNo")
	if (objCardNo) objCardNo.value=cardno;
	var Formobj=document.getElementById('fDHCPatient');
	//alert(Formobj);
	// Formobj.ACTION="websys.csp";
	//Formobj.method="post";
	// if (Formobj) Formobj.submit();
	window.close();
	Parobj.websys_setfocus('CardNo');
	}
}

function clearItem()
{
	var o;
  for(var i=0;i<arguments.length;i++)
  {
  	o=$(arguments[i]);
  	if(o!=undefined)
  	o.value="";
  }  
}
var SelectedRow = 0;
function SelectRowHandler()
{

	var eSrc=window.event.srcElement;
	var objtbl=$('tDHCPatient');
	if(!objtbl)
	{
	   objtbl=$('tDHCPatient0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	SelectedRowIndex=selectrow
	
	if (!selectrow) return;
	
	if (rowObj.className == 'clsRowSelected')
	{
		//rowItemObj(selectedRowObj);		
		$('ID').value=document.getElementById("TIDz"+selectrow).value;
		$('PAPERAge').value=document.getElementById("TPAPERAgez"+selectrow).innerText;
		$('PAPERDob').value=document.getElementById("TPAPERDobz"+selectrow).innerText;
		$('PAPERID').value=document.getElementById("TPAPERIDz"+selectrow).innerText.Trim();
		$('PAPERName').value =document.getElementById("TPAPERNamez"+selectrow).innerText;
		$('PAPERTelH').value =document.getElementById("TPAPERTelHz"+selectrow).value;
		$('ForeignName').value=document.getElementById("TPAPERForeignIdz"+selectrow).value;
		$('PAPEREmail').value=document.getElementById("TPAPEREmailz"+selectrow).value;
		$('PAPMIAllergy').value=document.getElementById("TPAPMIAllergyz"+selectrow).value;
		$('PAPERUpdateDate').value=document.getElementById("TPAPERUpdateDatez"+selectrow).value;
		$('Address').value=document.getElementById("TPAPERForeignAddressz"+selectrow).value;
		$('EmployeeNo').value=document.getElementById("TEmployeeNoz"+selectrow).value;
		$('ForeignPhone').value=document.getElementById("TForeignPhonez"+selectrow).value;
		TPAPERNationDR=document.getElementById("TPAPERNationDRz"+selectrow).value;
		TPAPERCTRLTDR=document.getElementById("TPAPERCTRLTDRz"+selectrow).value;
		TPAPERSexDR=document.getElementById("TPAPERSexDRz"+selectrow).value;
		TPAPERSocialStatusDR=document.getElementById("TPAPERSocialStatusDRz"+selectrow).value;
		TPAPEROccupationDR=document.getElementById("TPAPEROccupationDRz"+selectrow).value;
		TPAPMICardTypeDR=document.getElementById("TPAPMICardTypeDRz"+selectrow).value;
		TPAPERCountryDR=document.getElementById("TPAPERCountryDRz"+selectrow).value;
		TPAPERCTProvinceDR=document.getElementById("TPAPERCTProvinceDRz"+selectrow).value;
		TPAPERCityCodeDR=document.getElementById("TPAPERCityCodeDRz"+selectrow).value;
		TPAPERZipDR=document.getElementById("TPAPERZipDRz"+selectrow).value;
		TPAPERCompany=document.getElementById("TPAPERCompanyz"+selectrow).value;
		
		var TPoliticalLevel=document.getElementById("TPoliticalLevelz"+selectrow).value;
		var TSecretLevel=document.getElementById("TSecretLevelz"+selectrow).value;
		var HCPDR=document.getElementById("TPAPERHCPDRz"+selectrow).value;
		comb_PoliticalLevel.setComboValue(TPoliticalLevel);
		comb_SecretLevel.setComboValue(TSecretLevel);
		comb_HCPDR.setComboValue(HCPDR);
		
		CompanyObj=document.getElementById("PAPERCompany")
		if (CompanyObj) CompanyObj.value=TPAPERCompany
/*
		$('ID').value          = selectedRowObj.Item.TID;
		$('PAPERAge').value    = selectedRowObj.Item.TPAPERAge;
		$('PAPERDob').value    = selectedRowObj.Item.TPAPERDob;
		$('PAPERID').value     = selectedRowObj.Item.TPAPERID;
		$('PAPERName').value   = selectedRowObj.Item.TPAPERName;
		//$('PAPMINo').value     = selectedRowObj.Item.TPAPMINo;
		$('PAPERTelH').value   = selectedRowObj.Item.TPAPERTelH;
		$('ForeignName').value = selectedRowObj.Item.TPAPERForeignId;
		$('PAPEREmail').value  = selectedRowObj.Item.TPAPEREmail;
		$('PAPMIAllergy').value =selectedRowObj.Item.TPAPMIAllergy;
		$('PAPERUpdateDate').value = selectedRowObj.Item.TPAPERUpdateDate;
		$('Address').value=selectedRowObj.Item.TPAPERForeignAddress;

    	combo_LookPAPERNationDR.setComboValue(selectedRowObj.Item.TPAPERNationDR);
      comb_CTRelation.setComboValue(selectedRowObj.Item.TPAPERCTRLTDR);
      comb_LookPAPERSexDR.setComboValue(selectedRowObj.Item.TPAPERSexDR);
      comb_LookPAPERSocialStatusDR.setComboValue(selectedRowObj.Item.TPAPERSocialStatusDR);
      comb_PAPEROccupationDR.setComboValue(selectedRowObj.Item.TPAPEROccupationDR);
      comb_PAPMICardType.setComboValue(selectedRowObj.Item.TPAPMICardTypeDR);
      // comb_PayMode.setComboText(selectedRowObj.Item);
      combo_LookPAPERCountryDR.setComboValue(selectedRowObj.Item.TPAPERCountryDR) ;
 */  
      combo_LookPAPERNationDR.setComboValue(TPAPERNationDR);
      comb_CTRelation.setComboValue(TPAPERCTRLTDR);
      comb_LookPAPERSexDR.setComboValue(TPAPERSexDR);
      comb_LookPAPERSocialStatusDR.setComboValue(TPAPERSocialStatusDR);
      comb_PAPEROccupationDR.setComboValue(TPAPEROccupationDR);
      
      comb_PAPMICardType.setComboText('');
      comb_PAPMICardType.setComboValue(TPAPMICardTypeDR);
      
      combo_LookPAPERCountryDR.setComboText('');
      combo_LookPAPERCountryDR.setComboValue(TPAPERCountryDR) ;
       
			setProvinceData();
			comb_ProvinceInfo.setComboText('');
      comb_ProvinceInfo.setComboValue(TPAPERCTProvinceDR); 
                       
			//alert("^"+TPAPERCityCodeDR+"^");
			setCityData();
			comb_LookPAPERCityCodeDR.setComboText('');
			comb_LookPAPERCityCodeDR.setComboValue(TPAPERCityCodeDR);
			
			setZipData();
			comb_Zip.setComboText('');
			comb_Zip.setComboValue(TPAPERZipDR);
			
			comb_PAPERMarital.setComboValue(document.getElementById("TPAPERMaritalz"+selectrow).value);
			
			GetOtherInform()
	}                   
	else
	{
	  clearItem('ID','PAPERAge','PAPERDob','PAPERID','PAPERName','PAPERTelH','ForeignName','PAPEREmail','PAPMIAllergy','PAPERUpdateDate','Address','EmgMedicare','PAPERCompany','EmployeeNo','ForeignPhone');
      combo_LookPAPERCountryDR.setComboText('') ;
      combo_LookPAPERNationDR.setComboText('');
      comb_ProvinceInfo.setComboText('');
      comb_LookPAPERCityCodeDR.setComboText('');
      comb_CTRelation.setComboText('');
      comb_LookPAPERSexDR.setComboText('');
      comb_LookPAPERSocialStatusDR.setComboText('');
      //comb_CardTypeDefine.setComboText('');
      comb_PAPMICardType.setComboText('');
      //comb_PayMode.setComboText('');
      comb_PAPEROccupationDR.setComboText('');
      comb_Zip.setComboText('');
      comb_PAPERMarital.setComboValue('');
	  comb_HCPDR.setComboValue('');
	  comb_HCPDR.setComboText('');
	}
	
	SelectedRow = selectrow;
	
	LogStr=GetFormerStr()
	FormerEastIPNo=document.getElementById('EastIPMedicareNo').value;	//סԺ������(��)
	FormerWestIPNo=document.getElementById('WestIPMedicareNo').value;	//���ﲡ����(��)

	//alert(LogStr)

}

//��֤�����ֶ�
function CheckNull(){
if($V('ID')=="")
{
 alert("��ѡ��һ����¼");
 return false;	
}
	
if ($V('PAPERID')=="")
{	
	//alert(t['1']);
	//alert("���֤");
	//return false;
}	

if ($V('PAPERName')=="")
{
	alert(t['2']);
	return false;
}	

if (comb_LookPAPERSexDR.value=="")
{
	alert(t['3']);
	return false;
}	

	var myIDNo = DHCWebD_GetObjValue("PAPERID");
	if (myIDNo!=""){
		var myIDrtn=IsCredTypeID();
		if (myIDrtn){
			
			var myIsID=DHCWeb_IsIdCardNo(myIDNo);
			if (!myIsID){
				alert(t["ErrorId"]);
				websys_setfocus("PAPERID");
				return false;
			}
			
			//add by zhouzq 2010.09.10 У�����֤�е���Ϣ�ͳ�������
			var IDBirthday=DHCWeb_GetInfoFromId(myIDNo)[2];
			var myBirth=DHCWebD_GetObjValue("PAPERDob");
			if (myBirth!=IDBirthday){
				alert(t['BirthNotMatchId']);
	   		websys_setfocus('PAPERDob');
	   		return false;
			}
		}
	}
	
	//���ڲ�������Ϊ��Ժְ���ĶԹ��ŵ��ж� 20110719
	var myPatType= DHCWebD_GetObjValue("LookPAPERSocialStatusDR");
	if (myPatType.indexOf('��Ժ')>=0){
		var EmployeeNo=DHCWebD_GetObjValue("EmployeeNo");
		if (EmployeeNo==""){
			alert(t["noEmployeeNo"]);
			websys_setfocus('EmployeeNo');
			return false;
		}
		var curPAPMIRowID=tkMakeServerCall("web.DHCBL.CARDIF.ICardPaPatMasInfo","GetPAPMIRowIDByEmployeeNo",EmployeeNo);
		var name=curPAPMIRowID.split("^")[1];
		curPAPMIRowID=curPAPMIRowID.split("^")[0];
		var PAPMIRowID=DHCWebD_GetObjValue("ID");
		if ((PAPMIRowID!=curPAPMIRowID)&&(curPAPMIRowID!="")){
			alert("�˹����Ѿ���'"+name+"'����,�����Ⱥ�ʵ����");
			websys_setfocus('EmployeeNo');
			return false;
		}
	} //End

	return true;
}


function GetListData(tabName, QueryInfo)
{
	var myBData="";
	var myEncrpt=DHCWebD_GetObjValue("ReadCTBaseEncrypt");
	if (myEncrpt!=""){
		//if (tabName=="CTCITY")  {return;}
		//alert(tabName+"    "+QueryInfo);
		myBData=cspRunServerMethod(myEncrpt, tabName, QueryInfo)  
	}	// �ݲ���Ҫ���е���Ϣ,marked by xp,20080430
	return myBData;
}
	
function GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	try
	{
		
		
		
		//    
		//  
		//  
		//  
		//  
		//  
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		//     
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode("TransContent");
		for(var i=0;i<ParseInfo.length;i++)
		{
				xmlobj.BeginNode(ParseInfo[i].split("=")[0]);
				xmlobj.WriteString(ParseInfo[i].split("=")[1]);
				xmlobj.EndNode();
		}
		xmlobj.EndNode();
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
			
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}
	
	return myxmlstr;
}

function setProvinceData()
{
	   	var myval=combo_LookPAPERCountryDR.getSelectedValue();
	   	var myary=myval.split("^");
  	  var myQueryInfo=myary[0];
  	  var myBaseData=GetListData("CTPROVINCE", myQueryInfo);
	    comb_ProvinceInfo.addOptionStr(myBaseData);
}

function setCityData()
{
	     var myval=comb_ProvinceInfo.getSelectedValue();
	 	   var myary=myval.split("^");
  	   var myQueryInfo=myary[0];
  	   var myBaseData=GetListData("CTCITY", myQueryInfo);
	 	   comb_LookPAPERCityCodeDR.addOptionStr(myBaseData);
}

function setZipData()
{
	  var myBaseData = GetListData("CTZIP",comb_ProvinceInfo.getSelectedValue().split("^")[0]+"^"+comb_LookPAPERCityCodeDR.getSelectedValue().split("^")[0]+"^");
    comb_Zip.addOptionStr(myBaseData);
}

function InitAddNewInform()
{   //  ��ʼ��ʱ,����"����/�Ⲻ"ѡ��,xp add
	var obj=document.getElementById('LocalFlag');
	obj.size=1;
	obj.multiple=false;
	
	obj.length=0;
	var objItem=document.createElement("OPTION");
	obj.options.add(objItem);
	objItem.innerText="����";
	objItem.value=0;
	var objItem=document.createElement("OPTION");
	obj.options.add(objItem);
	objItem.innerText="�Ⲻ";
	objItem.value=1;
	obj.selectedIndex=0;
}

function GetOtherInform()
{  // ��ȡ������,ҽ���ŵ���Ϣ
	var PapmiNo=document.getElementById("TPAPMINoz"+SelectedRowIndex).innerText;   //�ǼǺ�
	var OtherInform=document.getElementById('OtherInform');
	if (OtherInform) {var encmeth=OtherInform.value} else {var encmeth=''};
	var OtherInformStr=cspRunServerMethod(encmeth,PapmiNo);
	var tmp=OtherInformStr.split("^");
    //var EastOPMedicareNo=document.getElementById('EastOPMedicareNo').value;
    if(document.getElementById('EastOPMedicareNo')) {document.getElementById('EastOPMedicareNo').value=tmp[0]}   	//���ﲡ����(��)
    document.getElementById('EastIPMedicareNo').value=tmp[1]	//סԺ������(��)
    if (document.getElementById('WestOPMedicareNo')) {document.getElementById('WestOPMedicareNo').value=tmp[2]}	//���ﲡ����(��)
    document.getElementById('WestIPMedicareNo').value=tmp[3]	//סԺ������(��)
    document.getElementById('InsuranceNo').value=tmp[4]			//ҽ����
    document.getElementById('EmgMedicare').value=tmp[6]	
    //����/�Ⲻ 
	var obj=document.getElementById('LocalFlag');
	for (var i=0;i<2;i++){
		if (obj.options[i].innerText==tmp[5]){
			obj.options.selectedIndex=i
		}
	}
	
	//����֤��
	tmp[7]=tmp[7].replace(/@/g,"^");
	var obj=document.getElementById('OtherCardInfo')
	if (obj)obj.value=tmp[7];
	
}

function UpdateOtherInform()          
{  // ���²�����,ҽ���ŵ���Ϣ
	var obj=document.getElementById('LocalFlag');
	var LocalFlag=obj.options[obj.options.selectedIndex].innerText;
    var EastOPMedicareNo=document.getElementById('EastOPMedicareNo').value; 		//���ﲡ����(��)
    var EastIPMedicareNo=document.getElementById('EastIPMedicareNo').value;		//סԺ������(��)
    var WestOPMedicareNo=document.getElementById('WestOPMedicareNo').value;		//���ﲡ����(��)
    var WestIPMedicareNo=document.getElementById('WestIPMedicareNo').value;		//סԺ������(��)
    var InsuranceNo=document.getElementById('InsuranceNo').value;				//ҽ����
	var PAPERCompany=document.getElementById('PAPERCompany').value; 
	
	var OtherInformStr=EastOPMedicareNo+"^"+EastIPMedicareNo+"^"+WestOPMedicareNo;
	OtherInformStr=OtherInformStr+"^"+WestIPMedicareNo+"^"+InsuranceNo+"^"+LocalFlag;
	OtherInformStr=OtherInformStr+"^"+PAPERCompany
	var PapmiNo=document.getElementById("TPAPMINoz"+SelectedRowIndex).innerText;   //�ǼǺ�
	
	var UpDateOtherInform=document.getElementById('UpDateOtherInform');
	if (UpDateOtherInform) {var encmeth=UpDateOtherInform.value} else {var encmeth=''};
	//alert(OtherInformStr+"    oooo   "+PapmiNo);
	var UpdateFlag=cspRunServerMethod(encmeth,OtherInformStr,PapmiNo);  //���ظ����Ƿ�ɹ��ı�־
	return UpdateFlag;
	
}

function SaveUpPersonLog(LogStr)   
{	//���²��˻�����Ϣʱ,����־
	var UpdateLog=document.getElementById('BtnUpdateLog')
	
	if (UpdateLog)    {var encmeth=UpdateLog.value} else {var encmeth=''};
	var RtnValue=cspRunServerMethod(encmeth,LogStr)
	if (RtnValue==0)
	{
		//alert("��־�ɹ�!")
	}
	else 
	{
		alert("������Ϣ�޸�,��־ʧ��,����ϵ����Ա!")
	}
}

//���²��˻�����Ϣǰ�Ĳ�����Ϣ��
function GetFormerStr()  
{   	
	var UPPSbor=document.getElementById('PAPERDob').value;				//��������				
 	var UPPSlx=document.getElementById('LookPAPERSocialStatusDR').value;//��������
 	var UPPSname=document.getElementById('PAPERName').value;			//����
 	var UPPSEastopno=document.getElementById('EastOPMedicareNo').value;	//���ﲡ����(��)
 	var UPPSEastipno=document.getElementById('EastIPMedicareNo').value;	//סԺ������(��)
 	var UPPSWestopno=document.getElementById('WestOPMedicareNo').value;	//���ﲡ����(��)
 	var UPPSWestipno=document.getElementById('WestIPMedicareNo').value;	//���ﲡ����(��)
 	var UPPSsex=document.getElementById('LookPAPERSexDR').value;		//�Ա�
 	var UPPSInsuranceNo=document.getElementById('InsuranceNo').value;			//ҽ����
 	var UPPSIDCardNo=document.getElementById('PAPERID').value;					//���֤��
 	var UPPSNation=document.getElementById('LookPAPERNationDR').value;			//����
 	var UPPSOccupation=document.getElementById('LookPAPEROccupationDR').value;	//ְҵ
 	var UPPSCompany='';	//������λ,��ʱû��
 	var UPPSAddress=document.getElementById('Address').value;					//��ַ
 	var UPPSRelation=document.getElementById('ForeignName').value;				//��ϵ��
 	var UPPSRelationship=document.getElementById('CTRelation').value;			//����ϵ�˵Ĺ�ϵ
 	var UPPSTelH=document.getElementById('PAPERTelH').value;					//��ϵ�绰
 	var LogStr=UPPSbor+"^"+UPPSlx+"^"+UPPSname+"^"+UPPSsex+"^"+UPPSEastopno;
 	LogStr=LogStr+"^"+UPPSEastipno+"^"+UPPSWestopno+"^"+UPPSWestipno;
 	LogStr=LogStr+"^"+UPPSInsuranceNo+"^"+UPPSIDCardNo+"^"+UPPSNation+"^"+UPPSOccupation+"^"+UPPSCompany
 	LogStr=LogStr+"^"+UPPSAddress+"^"+UPPSRelation+"^"+UPPSRelationship+"^"+UPPSTelH
 	return LogStr
}

//���²��˻�����Ϣ��Ĳ�����Ϣ��
function GetUpdateStr(LogStr)
{
	var obj=document.getElementById('CardTypeDefine');
	
	var UPPbor=document.getElementById('PAPERDob').value;
	var UPPlx=document.getElementById('LookPAPERSocialStatusDR').value;
	var UPPname=document.getElementById('PAPERName').value;
	var UPPsex=document.getElementById('LookPAPERSexDR').value;
 	var UPPEastopno=document.getElementById('EastOPMedicareNo').value;	//���ﲡ����(��)
 	var UPPEastipno=document.getElementById('EastIPMedicareNo').value;	//סԺ������(��)
 	var UPPWestopno=document.getElementById('WestOPMedicareNo').value;	//���ﲡ����(��)
 	var UPPWestipno=document.getElementById('WestIPMedicareNo').value;	//���ﲡ����(��)
 	var UPPInsuranceNo=document.getElementById('InsuranceNo').value;			//ҽ����
 	var UPPIDCardNo=document.getElementById('PAPERID').value;				//���֤��
 	var UPPNation=document.getElementById('LookPAPERNationDR').value;		//����
 	var UPPOccupation=document.getElementById('LookPAPEROccupationDR').value;	//ְҵ
 	var UPPCompany='' ;//������λ,��ʱû��
 	var UPPAddress=document.getElementById('Address').value;//��ַ
 	var UPPRelation=document.getElementById('ForeignName').value;//��ϵ��
 	var UPPRelationship=document.getElementById('CTRelation').value;//����ϵ�˵Ĺ�ϵ
 	var UPPTelH=document.getElementById('PAPERTelH').value;//��ϵ�绰
 	var UPPno=document.getElementById("TPAPMINoz"+SelectedRowIndex).innerText;   //�ǼǺ�
 	var UPPuserDr=session['LOGON.USERID'];
 	var UPCardTypeDesc=document.getElementById('CardTypeDefine').value;   //������
	LogStr=LogStr+"^"+UPPbor+"^"+UPPlx+"^"+UPPname+"^"+UPPsex;
	LogStr=LogStr+"^"+UPPEastopno+"^"+UPPEastipno+"^"+UPPWestopno+"^"+UPPWestipno;
 	LogStr=LogStr+"^"+UPPInsuranceNo+"^"+UPPIDCardNo+"^"+UPPNation+"^"+UPPOccupation+"^"+UPPCompany
 	LogStr=LogStr+"^"+UPPAddress+"^"+UPPRelation+"^"+UPPRelationship+"^"+UPPTelH
	LogStr=LogStr+"^"+UPPno+"^"+UPPuserDr+"^"+UPCardTypeDesc;
	return LogStr
}


function EastOPMedicareNoChange()
{
	var PapmiDr=""
	var EOPMedNo=""
	var obj=document.getElementById('ID');
	if(obj) var PapmiDr=obj.value
	var obj=document.getElementById('EastOPMedicareNo');
	if(obj) var EOPMedNo=obj.value
	var GetDetail=document.getElementById('GetUniInfoMethod');
	if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (EOPMedNo=="") {return}

	Rtn=cspRunServerMethod(encmeth,PapmiDr,"EOP",EOPMedNo)
	if(Rtn==""){
		alert("��ѡ����")
		return
	}
	if (Rtn>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch&OutMedicareNo="+EOPMedNo
			win=open(lnk,"DHCCardSearch","scrollbars=1,top=50,left=1,width=1000,height=600");
		}
		
}
function EastIPMedicareNoChange()
{
	var PapmiDr=""
	var EIPMedNo=""
	var obj=document.getElementById('ID');
	if(obj) var PapmiDr=obj.value
	var obj=document.getElementById('EastIPMedicareNo');
	if(obj) var EIPMedNo=obj.value
	var GetDetail=document.getElementById('GetUniInfoMethod');
	if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (EIPMedNo=="") {return}

	Rtn=cspRunServerMethod(encmeth,PapmiDr,"EIP",EIPMedNo)
	if(Rtn==""){
		alert("��ѡ����")
		return
	}
	if (Rtn>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch&InMedicareNo="+EIPMedNo
			win=open(lnk,"DHCCardSearch","scrollbars=1,top=50,left=1,width=1000,height=600");
		}
		
}
function WestOPMedicareNoChange()
{
	var PapmiDr=""
	var WOPMedNo=""
	var obj=document.getElementById('ID');
	if(obj) var PapmiDr=obj.value
	var obj=document.getElementById('WestOPMedicareNo');
	if(obj) var WOPMedNo=obj.value
	var GetDetail=document.getElementById('GetUniInfoMethod');
	if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (WOPMedNo=="") {return}
	Rtn=cspRunServerMethod(encmeth,PapmiDr,"WOP",WOPMedNo)
	if(Rtn==""){
		alert("��ѡ����")
		return
	}
	if (Rtn>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch&NewOutMedicareNo="+WOPMedNo
			win=open(lnk,"DHCCardSearch","scrollbars=1,top=50,left=1,width=1000,height=600");
		}
		
}
function WestIPMedicareNoChange()
{
	var PapmiDr=""
	var WIPMedNo=""
	var obj=document.getElementById('ID');
	if(obj) var PapmiDr=obj.value
	var obj=document.getElementById('WestIPMedicareNo');
	if(obj) var WIPMedNo=obj.value
	var GetDetail=document.getElementById('GetUniInfoMethod');
	if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (WIPMedNo=="") {return}

	Rtn=cspRunServerMethod(encmeth,PapmiDr,"WIP",WIPMedNo)

	if(Rtn==""){
		alert("��ѡ����")
		return
	}
	if (Rtn>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch&NewInMedicareNo="+WIPMedNo
			win=open(lnk,"DHCCardSearch","scrollbars=1,top=50,left=1,width=1000,height=600");
		}
		
}



function InsuranceNoChange()
{
	var PapmiDr=""
	var InsuNo=""
	var obj=document.getElementById('ID');
	if(obj) var PapmiDr=obj.value
	var obj=document.getElementById('InsuranceNo');
	if(obj) var InsuNo=obj.value
	var GetDetail=document.getElementById('GetUniInfoMethod');
	if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if ((InsuNo=="")||(InsuNo=="99999999999S")) {return}
	var InsuFlag=PatYBCodekeydownClick();
	if (InsuFlag==false) {return;}
	Rtn=cspRunServerMethod(encmeth,PapmiDr,"InsuNo",InsuNo)
	if(Rtn==""){
		alert("��ѡ����")
		return
	}
	if (Rtn>0) {
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch&InsuranceNo="+InsuNo
			win=open(lnk,"DHCCardSearch","scrollbars=1,top=50,left=1,width=1000,height=600");
		}
}		

function CheckMedNo()
{
	
	var obj=document.getElementById('ID');
	if(obj) var PapmiDr=obj.value
	var GetDetail=document.getElementById('GetUniInfoMethod');
	if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	
	//ҽ���ֲ��
	var obj=document.getElementById('InsuranceNo');
	if(obj) var InsuNo=obj.value
	if ((InsuNo!="")&&(InsuNo!="99999999999S")) {
		Rtn=cspRunServerMethod(encmeth,PapmiDr,"InsuNo",InsuNo)
		if(Rtn>0){	
			alert("ҽ���ֲ���ظ�")
			return false
		}
	}
	
	//��ԺסԺ������
	var obj=document.getElementById('WestIPMedicareNo');
	if(obj) var WIPMedNo=obj.value
	//var GetDetail=document.getElementById('GetUniInfoMethod');
	//if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (WIPMedNo!=""){
		Rtn=cspRunServerMethod(encmeth,PapmiDr,"WIP",WIPMedNo)
		if (Rtn>0) {
			alert("��ԺסԺ�������ظ�")
			return false
		}
	}
	
	
	//��Ժ���ﲡ����
	var obj=document.getElementById('WestOPMedicareNo');
	if(obj) var WOPMedNo=obj.value
	//var GetDetail=document.getElementById('GetUniInfoMethod');
	//if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (WOPMedNo!=""){
		Rtn=cspRunServerMethod(encmeth,PapmiDr,"WOP",WOPMedNo)
		if (Rtn>0) {
			alert("��Ժ���ﲡ�����ظ�")
			return false
		}
	}
		
	//��ԺסԺ������
	var obj=document.getElementById('EastIPMedicareNo');
	if(obj) var EIPMedNo=obj.value
	//var GetDetail=document.getElementById('GetUniInfoMethod');
	//if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (EIPMedNo!=""){
		Rtn=cspRunServerMethod(encmeth,PapmiDr,"EIP",EIPMedNo)
		if (Rtn>0) {
			alert("��ԺסԺ�������ظ�")
			return false
		}
	}	
	
	//��Ժ���ﲡ����
	var obj=document.getElementById('EastOPMedicareNo');
	if(obj) var EOPMedNo=obj.value
	//var GetDetail=document.getElementById('GetUniInfoMethod');
	//if (GetDetail) {var encmeth=GetDetail.value;} else {var encmeth=''};
	if (EOPMedNo!=""){
		Rtn=cspRunServerMethod(encmeth,PapmiDr,"EOP",EOPMedNo)
		if (Rtn>0) {
			alert("��Ժ���ﲡ�����ظ�")
			return false
		}
	}	
	
	return true
}






function TransPatInformClick(){
	// �򸾲�ҽԺ��ϵͳ�д����˲����ŵȲ��˻�����Ϣ
	EastIPNo=document.getElementById('EastIPMedicareNo').value;	//סԺ������(��)
	WestIPNo=document.getElementById('WestIPMedicareNo').value;	//���ﲡ����(��)
	if (!SelectedRowIndex) {alert('��ѡ��Ҫ�����Ĳ��˼�¼'); return;}
	var PapmiNo=document.getElementById("TPAPMINoz"+SelectedRowIndex).innerText;   //�ǼǺ�
	var CardTypeDesc=document.getElementById('CardTypeDefine').value;   //������
	var CardNo=GetCardNo(PapmiNo,CardTypeDesc)
	PapmiNo='A'+PapmiNo
	var InsertMedicareNo=GetInsertMedicareNo()  		 //ȡ��Ҫ����Ĳ�����
	var UpMedicareNo=GetUpMedicareNo(InsertMedicareNo)   //ȡ��Ҫ���µĲ�����
	if ((InsertMedicareNo=="")||(UpMedicareNo==""))  {alert("סԺ�����Ų���Ϊ��,�����벡����");}
	var Name=document.getElementById('PAPERName').value;						//����
	var Sex=GetPatSex()     
	var BirthDay=document.getElementById('PAPERDob').value;						//��������
 	var SocailStatus=comb_LookPAPERSocialStatusDR.getSelectedValue().split("^")[0] ;
 	var InsuranceNo=document.getElementById('InsuranceNo').value;			//ҽ����
 	var Address=document.getElementById('Address').value;						//��ַ
 	var Relation=document.getElementById('ForeignName').value;					//��ϵ��
	var TelH=document.getElementById('PAPERTelH').value;						//��ϵ�绰 	
	var OperDate=GetCurrentDate()     //����Ϣ������
 	//�������ݿ�
	var objdbConn = new ActiveXObject("ADODB.Connection");
	var strdsn = "Provider=MSDAORA.1;Password=yygl;Persist Security Info=True;User ID=yygl;Data Source=DH";  //chisdb";
	objdbConn.Open(strdsn);
	//CardNo='000000000441'   //������
	var sql="select cardid from card_br where CARDID="+"'"+CardNo+"'" 
	var rs=objdbConn.Execute(sql);
	var Maxid=rs.Fields(0);
	Maxid=Maxid+1;
	rs.Close();
    rs = null;
    alert(!Maxid);
	if (!Maxid){
		//CardNo='000000000441'   	//����,12λ,������,��ʽ�ⲻ��Ҫ
		PapmiNo='A0000441'      	//����  8λ
		//InsertMedicareNo='c0036' 	//����
		//CRATE_DATE    //��Ҫȷ���ڸ�ʽ
		sql="insert into dh_card(Cardid,id,name,bah,sex,sflb,address,lxr,ybh,birth)values("
		sql=sql+"'"+CardNo+"'"+","+"'"+PapmiNo+"'"+","+"'"+Name+"'"+','+"'"+InsertMedicareNo+"'"
		sql=sql+','+"'"+Sex+"'"+','+"'"+SocailStatus+"'"+','+"'"+Address+"'"+','+"'"+Relation+"'"
		sql=sql+','+"'"+InsuranceNo+"'"+','+"to_date("+"'"+BirthDay+"'"+','+"'yyyy-mm-dd'"+')'
		//sql=sql+','+"'"+OperDate+"'"+")"      //   
		sql=sql+")" 
  		objdbConn.Execute(sql);
  		var mmret=objdbConn.State
  		if (mmret==1){alert("��������ϵͳ�ɹ�");}
  		else{alert("��������ϵͳʧ��?����ϵ����Ա");}
	}
	//else{alert("�ò�����Ϣ�Ѿ�������ϵͳ,����Ҫ����")}	
	else{
		//CardNo='000000000036'   	//����,12λ,������,��ʽ�ⲻ��Ҫ
		PapmiNo='A0000439'      	//����  8λ
		//InsertMedicareNo='c0039' 	//����
		sql="update dh_card set id="+"'"+PapmiNo+"'"+",name="+"'"+Name+"'"+',bah='+"'"+UpMedicareNo+"'"
		sql=sql+',sex='+"'"+Sex+"'"+',sflb='+"'"+SocailStatus+"'"+',address='+"'"+Address+"'"+',lxr='+"'"+Relation+"'"
		sql=sql+',ybh='+"'"+InsuranceNo+"'"+',birth='+"to_date("+"'"+BirthDay+"'"+','+"'yyyy-mm-dd'"+')'
		//sql="update dh_card set name='EEEEE' where Cardid='000000000035'"
		//sql=sql+',id='+"'"+OperDate+"'"+")"      //   
		//sql=sql+")" 
		sql=sql+"where Cardid="+"'"+CardNo+"'"
		//sql=sql+'"'
		alert(sql);
  		objdbConn.Execute(sql);
  		var mmret=objdbConn.State
  		alert(mmret);
  		if (mmret==1){alert("���¾�ϵͳ������Ϣ�ɹ�");}
  		else{alert("���¾�ϵͳ������Ϣʧ��?����ϵ����Ա");}
	}
	
	objdbConn.Close();
	objdbConn=null;
}

function GetCardNo(PapmiNo,CardTypeDesc)
{
	var ObjGetCardNo=document.getElementById('GetCardNo');
	if (ObjGetCardNo) {var encmeth=ObjGetCardNo.value} else {var encmeth=''};
	var PatCardNo=cspRunServerMethod(encmeth,PapmiNo,CardTypeDesc);
	return PatCardNo
}

function GetUpMedicareNo(InsertMedicareNo)
{    //ȡ�޸Ĺ��Ĳ����� 
	if (EastIPNo!=FormerEastIPNo)
	{ alert(EastIPNo+"^"+FormerEastIPNo) ;  
	return EastIPNo; }

	if (WestIPNo!=FormerWestIPNo)
	{	alert(WestIPNo+"^"+FormerWestIPNo)
		return WestIPNo; }
	return InsertMedicareNo;	
}

function GetPatSex()     
{	
	var Sex=document.getElementById('LookPAPERSexDR').value
	if (Sex=="��") return 1
	if (Sex=="Ů") return 2
	return 0
}

function GetInsertMedicareNo()
{
	var EastIPNo=document.getElementById('EastIPMedicareNo').value;	//סԺ������(��)
	var WestIPNo=document.getElementById('WestIPMedicareNo').value;	//סԺ������(��)
	if (EastIPNo!="") {return EastIPNo; }
	if (WestIPNo!=""){return WestIPNo; }    //return '';	

}

function GetCurrentDate(){    				 //��ȡ��ǰ����
   var Today;
   var Str;
   Today = new Date();                            		// ���� Date ����?
   Str = Today.getYear()+ "-";                     		// ��ȡ���?
   Str += (Today.getMonth() + 1)+ "-";        	 		// ��ȡ�·�?
   Str += Today.getDate()                          		// ��ȡ��?
   return(Str);                                			// ��������?
}

///��ȡ֤������
function loadCredType(){
	
	DHCWebD_ClearAllListA("PAPMICardType");
	var encmeth=DHCWebD_GetObjValue("ReadCredType");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PAPMICardType");
	}
}
function OtherCredTypeInput()
{
 var url="dhcothercredtype.csp";
 var windesc="����֤������"
 var features="top=30,left=200,width=650,height=600,scrollbars=yes,toolbar=no,resizable=yes";
 open(url,windesc,features); 	
}

function CardTypeSave(val)
{
  document.getElementById("OtherCardInfo").value=val;
}