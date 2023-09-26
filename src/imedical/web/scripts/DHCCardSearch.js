//UDHCCardSearch//卡查询:WorkList[挂失/取消挂失/补卡/换卡]??CSP[退卡]
//组件引用js??ebsys.js,websys.listrows.js,websys.List.js,websys.List.Tools.js
//DHCOPAdm.Common.js,DHCWeb.OPCommon.js,DHCWeb.OPOEData.js,DHCPrtComm.js,DHCCPM_DOMComm.js
//DHCFCommCard.js
//dhtmlXCombo.js,dhtmlXCommon.js
//上次更改??007-12-5
//增加checkbox的监听事件组件Hospital2011-08-02,李相宗

var comb_CardTypeDefine=null;
var SelectedRow = 0;
var m_RowIndex=-1;
var SupportFlagobj;
var m_DefaultCardLength=0;

var m_CardNoLength=0;
var m_SelectCardTypeDR="";


document.body.onload = BodyLoadHandler;
var e=event;
function BodyLoadHandler(){	
	
	var Obj=document.getElementById('CardNo');
	if (Obj) Obj.onkeydown = CardNOclick;
	var Obj=document.getElementById('ReadCard');
	if (Obj) Obj.onclick = B_ReadCard
	var Obj=document.getElementById('BirthDay');
	if (Obj) Obj.onchange = BirthObj_onchange;
	var Obj=document.getElementById('BtnSearch');   //点查询按钮时,先判断时间格式是否符合要求,需要转换格式则转换时间格式
	if(Obj)Obj.onclick=BtnSearch_Clickjs;
	var Obj=document.getElementById('tDHCCardSearch');
	if(Obj)Obj.ondblclick=CardSearchDBClickHander;
	var Obj=document.getElementById('PatientNo');
	if(Obj){
		Obj.onkeydown=PatientNoKeyDownHander;
		Obj.onblur=PatientNoKeyOnBlur;
	}

	
	textimemode();
  
  //增加读医保卡的按钮
	var myobj = document.getElementById("ReadInsuICCardInfo");
	if (myobj){
		myobj.onclick = DHCCReadInsuCardInfo;
	}

	loadCardType()
	var objCardType=document.getElementById('CardTypeDefine');
	if (objCardType){
		objCardType.setAttribute("isDefualt","true");
		comb_CardTypeDefine=dhtmlXComboFromSelect("CardTypeDefine");
	  comb_CardTypeDefine.enableFilteringMode(true);
	  comb_CardTypeDefine.selectHandle=CardTypeDefine_OnChange;
	  
	  CardTypeDefine_OnChange();
	}
	var obj=document.getElementById('BInfoPrint');
	if(obj)obj.onclick=BInfoPrint_click;
	var obj=document.getElementById('BMedicalNoPrint');
	if(obj)obj.onclick=BMedicalNoPrint_click;
	document.onkeydown=DocumentOnKeyDownHandler;
	
	var obj=document.getElementById('BInsuranceInfo');
	if(obj)obj.onclick=BInsuranceInfo_click;
	
	//增加回车查询事件 
	var obj=document.getElementById('Name');
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;
	var obj=document.getElementById('CredNo'); 
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;
	var obj=document.getElementById('OutMedicareNo');
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;
	var obj=document.getElementById('InMedicareNo');
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;
	var obj=document.getElementById('EmMedicare');
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;	
	var obj=document.getElementById('InsuranceNo');
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;	
	var obj=document.getElementById('Telphone');
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;	
	var obj=document.getElementById('EmployeeNo');
	if(obj) obj.onkeydown=FindDocumentOnKeyDownHandler;	
}

function FindDocumentOnKeyDownHandler(e) {	
	var key=websys_getKey(e);
	if(key==13){ BtnSearch_click();}
	return 	
}

function BtnSearch_Clickjs()
{	
	var DateFlag=BirthObj_onchange();
	if (DateFlag) BtnSearch_click();
}

function B_ReadCard()
{
	//var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myEquipDR=comb_CardTypeDefine.getActualValue();
	var myEquipDR=comb_CardTypeDefine.getSelectedValue();
	var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    var CardSubInform=CardInform.split("^");
    var rtn=CardSubInform[0];
    switch (rtn){
			case "-200": //卡无效
				alert("卡无效");
				//PapmiNoObj=document.getElementById("PapmiNo");
    			//PapmiNoObj.value="";
    			CleartTbl();
				break
			default:
				//alert(myrtn)
				document.getElementById('CardNo').value=CardSubInform[1]
				BtnSearch_click();
				break;
		}
		
    
}

function CleartTbl()
{
	var objtbl=document.getElementById('tDHCCardSearch');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex;j++) {
		objtbl.deleteRow(1);
	//alert(j)
	}
	var objlastrow=objtbl.rows[1];
	if(objlastrow='undefind')return;
	var rowitems=objlastrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]="1";
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].innerText="";
		}
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
	if (comb_CardTypeDefine){
		var myoptval=comb_CardTypeDefine.getSelectedValue();
	}else{
		var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	}
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
			DHCC_AvailabilityBtn(obj)
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
function FormatCardNo(){
	var CardNo=document.getElementById('CardNo').value;
	if (CardNo!='') {
		if ((CardNo.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
			for (var i=(m_CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function FormatPatientNo(){
	if (document.getElementById("PatientNo")){
		var DefPatientNoLen=8;
		var PatientNoLenObj=document.getElementById('PatientNoLen');
		if (PatientNoLenObj)var PatientNoLen=PatientNoLenObj.value;
		else  var PatientNoLen=DefPatientNoLen
		var PatientNo=document.getElementById('PatientNo').value;
		if (PatientNo!='') {
			if ((PatientNo.length<PatientNoLen)&&(PatientNoLen!=0)) {
				for (var i=(PatientNoLen-PatientNo.length-1); i>=0; i--) {
					PatientNo="0"+PatientNo;
				}
			}
		}
		return PatientNo
	}
	
	return ""
}

function CardSearchDBClickHander()
{
	if (SelectedRow==0) return;
	
	var myPatientID="";
	var myobj=document.getElementById('TPatientIDz'+SelectedRow);
	if (myobj!=null) myPatientID=myobj.value;
	
	var cardno=document.getElementById('CardNOz'+SelectedRow).innerText;
	var Regno=document.getElementById('TRegNoz'+SelectedRow).innerText;
	//如果是从挂号界面打开的则将卡号带到挂号界面
    //var obj=document.getElementById('CardNo');
	//if (obj)cardno=obj.value;
	var Formobj=document.getElementById('fDHCCardSearch');
	 var win = Formobj.parentNode.parentNode;
	 //建卡界面弹出
	 if(win&&window.name=="FindPatBase")
	 {
		 var objCardNo=window.opener.opener.document.getElementById("CardNo")
		    if (objCardNo) objCardNo.value=cardno;
		    self.close();
		    window.opener.opener.websys_setfocus('CardNo');
		    window.opener.opener.focus();
	 }
	 //挂号界面弹出
	if (window.name=="FindPatReg"){
			var Parobj=window.opener
	    var objCardNo=Parobj.document.getElementById("CardNo")
	    if (objCardNo) objCardNo.value=cardno;
      self.close();
	    Parobj.websys_setfocus('CardNo'); 
	}
	if (window.name=="UDHCJFIPReg"){
			
			var Parobj=window.opener
		    var objRegno=Parobj.document.getElementById("Regno")
		    if (objRegno) objRegno.value=Regno;
		    self.close();
		    Parobj.getpatinfo1()
		    Parobj.websys_setfocus('name'); 
	}
	//注册建卡界面弹出
	if (window.name=="UDHCCardPatInfoRegExpFind"){
			
			var Parobj=window.opener;
			var Regno=document.getElementById('TRegNoz'+SelectedRow).innerText;
			Parobj.DHCWebD_SetObjValueA("PAPMINo", Regno);
		    self.close();
		    Parobj.ValidateRegInfoByCQU(myPatientID);
		    
	}
}

function textimemode()    
{	// 对于如下的元素,直接转化输入法,避免使用输入法的切换
	if (document.all.NewInMedicareNo)
	{
		document.all.NewInMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.InMedicareNo)      
	{
		document.all.InMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.CredNo)
	{
		document.all.CredNo.style.imeMode = "disabled";
	}
	if (document.all.InsuranceNo)
	{
		document.all.InsuranceNo.style.imeMode = "disabled";
	}
	if (document.all.CardNo)
	{
		document.all.CardNo.style.imeMode = "disabled";
	}
	if (document.all.NewOutMedicareNo)
	{
		document.all.NewOutMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.OutMedicareNo)
	{
		document.all.OutMedicareNo.style.imeMode = "disabled";
	}
	if (document.all.BirthDay)
	{
		document.all.BirthDay.style.imeMode = "disabled";
	}
	if (document.all.Telphone)
	{
		document.all.Telphone.style.imeMode = "disabled";
	}
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=comb_CardTypeDefine.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
} 
function CardNOclick(e) {
	//这边要与卡处理一致
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
			var CardNo=FormatCardNo()
		document.getElementById('CardNo').value=CardNo
		//var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		var CardTypeRowId=GetCardTypeRowId();
		//var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo");
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];
		switch (rtn){
			case "-200": //卡无效
				alert("卡无效");
				document.getElementById('CardNo').value=""
				websys_setfocus('CardNo');
				break;
			default:
				//document.getElementById('T_ID').value=myary[5]
				//alert(document.getElementById('T_ID').value)
				//FindPatQueue()
				break;
		}
		BtnSearch_click();
		return websys_cancel();
	}
}
function PatientNoKeyDownHander(){
	var key=websys_getKey(e);
	if (key==13) {
			var PatientNo=FormatPatientNo()
			if (document.getElementById('PatientNo')){
				document.getElementById('PatientNo').value=PatientNo;
			}
		BtnSearch_click();
		return websys_cancel();
	}
}

function PatientNoKeyOnBlur(){
	var PatientNo=FormatPatientNo()
	if (document.getElementById('PatientNo')){
		document.getElementById('PatientNo').value=PatientNo;
	}
}
function BirthObj_onchange(){
	var Obj=document.getElementById('BirthDay');
	BirLen=Obj.value.length
       if (BirLen==0) return true;
	if ((BirLen!=8)&&(BirLen!=10))
	{
		Obj.className='clsInvalid';
		websys_setfocus("BirthDay");
		return false;
	}
	if (BirLen==8)
	{
		if (dtformat=="DMY"){
			Obj.value=Obj.value.substring(6,8)+"/"+Obj.value.substring(4,6)+"/"+Obj.value.substring(0,4)
		}else{
			Obj.value=Obj.value.substring(0,4)+"-"+Obj.value.substring(4,6)+"-"+Obj.value.substring(6,8)
		}
		
		
	}
		var mybirth=Obj.value
		var myrtn=false
		if (dtformat=="DMY"){
			var myrtn=DHCWeb_IsDate(mybirth,"/")
		}else{
			var myrtn=DHCWeb_IsDate(mybirth,"-")
		}
		if (!myrtn){
			Obj.className='clsInvalid';
			websys_setfocus("BirthDay");
			return false;
		}
		return true;
		Obj.className='';
}

function BtnSearchClickHandler(){
	var CardTypeIDobj=document.getElementById('CardTypeID');//赋值隐藏对象CardTypeIDobj
	
	if (combo_CardTypeDefine.value)	{
		//CardTypeIDobj.value=combo_CardTypeDefine.getSelectedValue().split("^")[0];
		CardTypeIDobj.value=""
	}
	
	/*var ParInputObj=document.getElementById('ParInput')
	
	var Obj=document.getElementById('Name')
	if (Obj.value=="") {Obj.value="xxxx"}     //若Name为空?组件无法传递其他元素的参数?先用此法解决
	if (Obj) ParInputObj.value=Obj.value
	var Obj=document.getElementById('BirthDay')
	if (Obj) ParInputObj.value=ParInputObj.value+"^"+Obj.value
	var Obj=document.getElementById('Telphone')
	if (Obj) ParInputObj.value=ParInputObj.value+"^"+Obj.value
	var Obj=document.getElementById('OutMedicareNo')
	if (Obj) ParInputObj.value=ParInputObj.value+"^"+Obj.value
	var Obj=document.getElementById('InMedicareNo')
	if (Obj) ParInputObj.value=ParInputObj.value+"^"+Obj.value
	
	alert(Name.value)
	*/
	BtnSearch_click();
	var doc=parent.frames[1].document;
	if (doc) {
		try{
			doc.Script.Clear_Click();
		}catch(e){};
	}//调用WorkList里的下一个组件的清除事件
}

function Clear_Click(){	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardSearch";
}
function DocumentOnKeyDownHandler() {	
	var eSrc=window.event.srcElement;	
	var key=websys_getKey(e);	
	/* update at 2010/4/14
	if (key==13) {
		if (eSrc.name=='CardTypeDefine'){
			websys_setfocus('CardNo');
			return;
		}
		
		if (eSrc.name=='CardNo'){
			//alert(eSrc.name)
			//SetCardNOLength();
		}
		websys_nexttab(eSrc.tabIndex);
	}
	*/
	if(key==115) {
		B_ReadCard();
	}
}
function GetCardNOLength(){
	//return 15;//写死15位卡号
	var CardNOLength=0;
	var CardTypeValue=combo_CardTypeDefine.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNOLength=CardTypeArr[17];
	}
	if (CardNOLength>0){
		return CardNOLength;
	}else{
		return m_DefaultCardLength;
	}
}
function MoveDown (isMoveDown){
	try{
		var objtbl=document.getElementById('tUDHCCardSearch');
		if(!objtbl)	{
		   objtbl=document.getElementById('tUDHCCardSearch0');
		}
		if (isMoveDown){
			if (m_RowIndex>=(objtbl.rows.length-1)) return;
		}else{
			if ((m_RowIndex<1)) return;
		}
		if (isMoveDown==true){
			m_RowIndex+=1;
		}else{
			m_RowIndex-=1;
		}
		var rowObj=objtbl.rows[m_RowIndex];
		var selectrow=m_RowIndex;
		if (!selectrow) return;
		HighlightRow_OnLoad("TCardIDz"+selectrow);
	}catch(e){};
}
function ReSearch(){
	BtnSearch_click();
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCardSearch');
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

	SelectedRow = selectrow;
}
function SetCardNOLength(){
	m_CardNOLength=GetCardNOLength();
	var obj=document.getElementById('CardNo');
	var objValue=obj.value;
	objValue=objValue.replace(/(^\s*)|(\s*$)/g,"");
		if (objValue!='') {
			if ((objValue.length<m_CardNOLength)&&(m_CardNOLength!=0)) {
				for (var i=(m_CardNOLength-objValue.length-1); i>=0; i--) {
					objValue="0"+objValue
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=objValue;
			}
		}
		ChangeCardTypeByCardNO('CardNo',combo_CardTypeDefine,'getcardtypeclassbyCardNO');
}
function ReadInsuCardInfo(MCardNo){
	//调用医保js函数接口以为卡号为医保给 入28位出真正的卡号,给界面赋值
	var InfoStr="";
	var flag="";
	var MedicareNumber="";
	var PatName="";
	var CardTypeRowId='2';
  InfoStr=ReadINSUCard(MCardNo);
  var InfoStrarr=InfoStr.split("|");
  if (InfoStrarr[0]){
  	flag=InfoStrarr[0];
  	InsuCardType=InfoStrarr[1];    //0,1可以核对卡位数   在最后核对的时候check  全局变量
  	MedicareNumber=InfoStrarr[2];
  	MedicareNumber=Trim(MedicareNumber);
  	PatName=InfoStrarr[3];
  	if (flag=='0'){
  		//置医保卡类型
  		if (InsuCardType=='1'){
  			//芯片卡
  			CardTypeRowId="1";
  			combo_CardType.setComboText("医保IC卡");
  		}else if (InsuCardType=='0'){
  			//磁卡
  			CardTypeRowId="3";
  			combo_CardType.setComboText("社会保障卡");
  		}
  		//没解决,ind一直是-1,code,rowid都不行,cardtyperowid实际没使用
  		//SetComboValue(combo_CardType,CardTypeRowId);
  		DHCC_SetElementData("CardNo",MedicareNumber);
  	}else{
  		alert("读卡失败,请检查卡");
  		return;
  	}
  }
} 

function DHCCReadInsuCardInfo(){
	ReadInsuCardInfo("");
	var AppFlag=DHCC_GetElementData('AppFlag');
	var CardNo=DHCC_GetElementData("CardNo");
	var CardTypeRowId=GetCardTypeRowId();
	//if (CardTypeRowId!="") CardNo=FormatCardNo();
	//医保卡类型
	if (InsuCardType=='1'){CardTypeRowId='1';}
	if (InsuCardType=='0'){CardTypeRowId='3';}
	
	if ((InsuCardType=='1')||(InsuCardType=='0')){
	}else{
		CardNo=FormatCardNo();
	}
	if (CardNo=="") return;
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
	//alert(myrtn)
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			//通过卡号去找卡找到卡类型,如果采用这种方式1、卡类型的串会丢失，2、多种卡类型的同一个卡号无法找到多个  NewCardTypeRowId==""说明卡有多种卡类型gry
			//if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
			var RegType=GetCardTypeRegType();
			if (CardTypeRowId!=NewCardTypeRowId){
				alert(t['CardNoTypeNotMatch']);
				return;
			}
			var AppFlag=DHCC_GetElementData("AppFlag");
			if ((AppFlag==1)&&(RegType=="REG")){
				alert(t['CardOnlyForReg']);
				return;
			}
			DHCC_SetElementData("PayMode","CPP");
			SetPatientInfo(PatientNo,CardNo);
			break;
		case "-200": //卡无效
			alert(t['InvaildCard']);
			websys_setfocus('CardNo');
			break;
		case "-201": //卡有效无帐户
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			//通过卡号去找卡找到卡类型
			//if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
			var RegType=GetCardTypeRegType();
			if (CardTypeRowId!=NewCardTypeRowId){
				alert(t['CardNoTypeNotMatch']);
				return;
			}
			if ((AppFlag==1)&&(RegType=="临时医疗卡")){
				alert(t['CardOnlyForReg']);
				return;
			}
			
			//DHCC_SetElementData("PayMode","CASH");
			DHCC_SelectOptionByCode("PayMode","CASH");
			var obj=document.getElementById("PayMode");
			SetPatientInfo(PatientNo,CardNo);
      YBTypeCheck();
			break;
		default:
	}
}
function BInfoPrint_click()
{
	PatInfoPrint("Info");
}
function BMedicalNoPrint_click()
{
	PatInfoPrint("Unio");
}
function PatInfoPrint(Type)
{
	var PatInfoXMLPrint="PatInfoPrint";
	if (SelectedRow==0){
		alert("请首先选择一个人员");
		return false;
	}
	var Char_2="\2";
	if (Type=="Info"){
		var InMedicare=document.getElementById("TInMedicarez"+SelectedRow).innerText;;
		var Name=document.getElementById("TNamez"+SelectedRow).innerText;
		var RegNo=document.getElementById("TRegNoz"+SelectedRow).innerText; //DHCWebD_GetObjValue("PAPMINo");
		var TxtInfo="TPatName"+Char_2+"姓  名:"+"^Name"+Char_2+Name+"^TRegNo"+Char_2+"登记号:"+"^RegNo"+Char_2+RegNo+"^TMedicareNo"+Char_2+"病案号:"+"^MedicareNo"+Char_2+InMedicare;
	}else{
		var UnionNo=document.getElementById("TUnionNoz"+SelectedRow).innerText;
		var TxtInfo="UnionNo"+Char_2+UnionNo+"^BUnionNo"+Char_2+"*"+UnionNo+"*";
	}
	var ListInfo="";
	DHCP_GetXMLConfig("DepositPrintEncrypt",PatInfoXMLPrint);
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
function BInsuranceInfo_click()
{
	var PatientID=DHCC_GetColumnData("TPatientID",SelectedRow)
	//DHCWebD_GetObjValue("ID");
	//TPatientID
	if (PatientID==""){
		alert("请先保存基本信息")
		return false;
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCPATInsuranceInfo&PatientID="+PatientID;
	win=open(lnk,"_blank","status=1,scrollbars=1,top=100,left=100,width=860,height=520");
}