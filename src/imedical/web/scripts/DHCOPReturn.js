//DHCOPReturn.js
var SelectedRow = 0;
var ReturnStatus=0
var m_CardNo="";
var MagCardNo="";  //28位
var InsuCardType=""; //判断是否是医保卡, 调用医保实时接口
var EncryptObj=new Object();
var BillPrtXMLName="";
var BillPrtINVFlag="";
var CloseFlag="Y";

function BodyLoadHandler() {
	//得到挂号条打印的参数
	
	var obj=document.getElementById('readcard');
	if (obj) obj.onclick=ReadCardClickHandler;
	var ObjReturnMR=document.getElementById('ReturnMR');
	if(ObjReturnMR) ObjReturnMR.onchange=ReturnMRClickHandler
	var Obj=document.getElementById('TiltleName1');
	if (window.name=="SwitchReg")	{
		if (Obj){Obj.value=t["07"]}
	}else{
		if (Obj){Obj.value=t["08"]}
	}
	var Obj=document.getElementById('RegNo');
	if (Obj) {
		Obj.onchange = FID_onchange;
		Obj.onkeydown = FID_key;
	}

	var Obj=document.getElementById('UpdatePatAdmReason');
	if (Obj) Obj.onclick = UpdatePatAdmReason_click;
	
	m_CardNo="";
	
	//DHCC_SetListStyle("CardType",false);
	ReadCardType();
	
	var obj=document.getElementById('CardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	if(obj.value!=""){websys_setfocus('CardNo');}
	
	//读卡
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;

	var obj=document.getElementById('CardNo');
	if (obj) obj.onkeydown = CardNoKeydownHandler;
	//退号
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=Update_click;

	var obj=document.getElementById('Change');
	if (obj) obj.onclick = ChangeClickHandler;

	var obj=document.getElementById('Reprint');
	if (obj) obj.onclick = ReprintClickHandler;
	
	var obj=document.getElementById('OldRegPrint');
	if (obj) obj.onclick = OldRegPrintClickHandler;

	var obj=document.getElementById('Find');
	if (obj) obj.onclick = Find_clickHandler;
	
	var obj=document.getElementById('ChangeAdm');
	if (obj) obj.onclick = ChangeAdm_clickHandler;

	var obj=document.getElementById('QueryCancel');
	if (obj) obj.onclick = QueryCancel_clickHandler;

	var obj=document.getElementById('Restore');
	if (obj) obj.onclick = Restore_clickHandler;
	
	var objSR=document.getElementById("SwichReg");	
	if (objSR) objSR.onclick = SwichReg_click;
	
	var objReturnMR=document.getElementById("ReturnMR");	
	if (objReturnMR) objReturnMR.onclick = objReturnMR_click;
	
	//单独收病历本费
	var obj=document.getElementById("ChargeMedicalBook");
	if (obj) obj.onclick = ChargeMedicalBook;
	//单独退病历本费
	var obj=document.getElementById("CancelMedicalBook");
	if (obj) obj.onclick = CancelMedicalBook;
	

	//增加读医保卡的按钮
	var myobj = document.getElementById("ReadInsuICCardInfo");
	if (myobj){
		myobj.onclick = DHCCReadInsuCardInfo;
	}
	
	EncryptObj=new DHCBodyLoadInitEncrypt();
	EncryptObj.GetAllEncrypt("web.DHCBodyLoadInitEncrypt.GetAllEncryptStr");
	
	GetReceiptNo();
	
	admobjtbl=document.getElementById('tDHCOPReturn');
	if (admobjtbl) {
		admobjtbl.onkeydown = TableKeydownHandler;
		//退号原因初始化
		var rows=admobjtbl.rows.length;   
		var lastrowindex=rows-1;
		for(var i=1;i<=lastrowindex;i++)
		{   
			var Obj=document.getElementById('TabReturnReasonz'+i);
			if (Obj){
				Obj.size=1;
				Obj.multiple=false;
				var varItem = new Option("","");
				Obj.options.add(varItem);
				var ReturnStr=tkMakeServerCall('web.DHCOPReturnReason','FindReason')
				var ReturnStrArry=ReturnStr.split("^");
				var LenR=ReturnStrArry.length
				for (var j=0;j<LenR;j++)
				{
					var Desc=ReturnStrArry[j].split("!")[0];
					var RowID=ReturnStrArry[j].split("!")[1];
					var varItem = new Option(Desc,RowID);
					Obj.options.add(varItem);
				}
			}
		}
	}
	
	//收取并打印病历本(病历本记入收费)
	///Load Bill Base Config
	var encmeth=DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,session['LOGON.GROUPID']);
	}
	var myary=myrtn.split("^");
	if (myary[0]==0){
		///_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		var billobj=document.getElementById("Bill");
		if ((billobj)&&(myary[2]==0)){
			DHCWeb_DisBtn(billobj);
		}
		BillPrtINVFlag=myary[4];
		var myPrtXMLName=myary[10];
	}
	BillPrtXMLName=myPrtXMLName;
	
}
function ClearNormal(){
	DHCC_SetElementData("PatientID","");
	DHCC_SetElementData("RegNo","");
	DHCC_SetElementData("Mon","");
	DHCC_SetElementData("CardNo","");
	DHCC_SetElementData("InvoiceNo","");
	DHCC_SetElementData("nday","");
	DHCC_SetElementData("ReceiptNo","");
	var DefType=tkMakeServerCall('web.UDHCOPOtherLB','getDefaultCardType');
	var DefTypeArr=DefType.split('^');
	var DefTypeId=DefTypeArr[0];
	var DefTypeDesc=DefTypeArr[2];
	combo_CardType.setComboValue(DefType);

}
function ChargeMedicalBook(){
	var GroupID=session['LOGON.GROUPID'];
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	if (SelectedRow==0){
		alert(t['06']);
		return;
	}
	
	var myMedicalBookInv="";
	var AdmID=document.getElementById('AdmIdz'+SelectedRow).value;
	var encmeth=DHCWebD_GetObjValue("ChargeMedicalBookMethod");
	if (encmeth!=""){
		myMedicalBookInv=cspRunServerMethod(encmeth,AdmID,GroupID,UserID,LocID);
	}
	if (myMedicalBookInv!=""){
		BillPrintNew(myMedicalBookInv);
		PrintMedicalBook(AdmID);
	}
	
}

function CancelMedicalBook(){
	var GroupID=session['LOGON.GROUPID'];
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	if (SelectedRow==0){
		alert(t['06']);
		return;
	}
	
	var NewInvoiceId="";
	var RegfeeId=document.getElementById('TabRowIdz'+SelectedRow).value;
	if (RegfeeId=="") {
		alert("请选择有效记录.")
		return;
	}
	var encmeth=DHCWebD_GetObjValue("CancelMedicalBookMethod");
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,RegfeeId,UserID,GroupID,LocID);
		if (ret.split('^')[0]!="0") {
			alert("退病历本费失败:"+ret.split('^')[1]);
			return;
		}else{
			NewInvoiceId=ret.split('^')[1];
		}
	}
	if (NewInvoiceId!=""){
		var APIFlag=ret.split('^')[2];
		if (APIFlag=="Y"){
			PrintInvCPP(RegfeeId);
		}else{
			PrintInv(RegfeeId);
		}
		//BillPrintNew('0^'+NewInvoiceId);
		alert("退病历本费成功!")
		GetReceiptNo();
		SelectedRow=0
		Find_click();
	}
	
}

function BillPrintNew(INVstr){
	DHCP_GetXMLConfig("InvPrintEncrypt",BillPrtXMLName);
	if (BillPrtXMLName==""){
		////not alert to Print
		return;
	}
	var INVtmp=INVstr.split("^");
	///
	///INVstr
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var myPreDep=DHCWebD_GetObjValue("Actualmoney");
			var myCharge=DHCWebD_GetObjValue("Change");
			var myCurGroupDR=session['LOGON.GROUPID'];
			
			var myExpStr=myPreDep+"^"+myCharge+"^"+myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
            
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",BillPrtXMLName,INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}
function BillInvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
	
}
function PrintMedicalBook(AdmNo){
	//alert(AdmNo);
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCOPAdmReg.GetPaperInfo"))
  MyPara="";
  var myobj=document.getElementById("ClsBillPrint");
	DHCP_GetXMLConfig("InvPrintEncrypt","MedicalBook");
	var PrintMedicalbencmeth=document.getElementById('PrintMedicalBookMethod').value;
  if (PrintMedicalbencmeth!=""){
      rtn=cspRunServerMethod(PrintMedicalbencmeth,AdmNo);
	}
	if (rtn!=''){
		//alert(rtn)
		rtnarry=rtn.split('^');
		PatientName=rtnarry[2];
		PatientSex=rtnarry[3];
		AgeDesc=rtnarry[4];
		PatientNo=rtnarry[1];
		PatientBirthday=rtnarry[5];
		PatientYear=PatientBirthday.split('-')[0];
		Patientmonth=PatientBirthday.split('-')[1];
		ALLERGY=rtnarry[25];
		PatientMarital=rtnarry[16];
		Tel=rtnarry[24];
		PatientComAdd=rtnarry[10];
		MyPara=MyPara+"PatientName"+String.fromCharCode(2)+PatientName;
		MyPara=MyPara+"^PatientSex"+String.fromCharCode(2)+PatientSex;
		MyPara=MyPara+"^AgeDesc"+String.fromCharCode(2)+AgeDesc;
		MyPara=MyPara+"^PatientYear"+String.fromCharCode(2)+PatientYear;
		MyPara=MyPara+"^Patientmonth"+String.fromCharCode(2)+Patientmonth;
		MyPara=MyPara+"^ALLERGY"+String.fromCharCode(2)+ALLERGY;
		MyPara=MyPara+"^PatientMarital"+String.fromCharCode(2)+PatientMarital;
		MyPara=MyPara+"^Tel"+String.fromCharCode(2)+Tel;
		MyPara=MyPara+"^PatientComAdd"+String.fromCharCode(2)+PatientComAdd;
    var DHCOPPrint=new ActiveXObject("DHCOP.DHCPrint");
    //DHCPrint.OutStr="430$970$医大一院^430$630$女^430$350$1975       03^500$580$未婚^500$300$62662348^580$950$沈阳市和平区"
    DHCOPPrint.OutStr="430$970$"+PatientName+"^430$630$"+PatientSex+"^430$350$"+PatientYear+"        "+Patientmonth+"^500$580$"+PatientMarital+"^500$940$"+ALLERGY+"^500$300$"+Tel+"^580$950$"+PatientComAdd+"^350$500$"+'登记号:'+PatientNo       
    DHCOPPrint.PrintStr()
		
		}
}
function SwichReg_click()
{
	 var obj=document.getElementById('SwichReg');
	 if (obj.style.display=='none') return;
    selectrow=SelectedRow;
     CloseFlag="Y";
	if (selectrow!="0"){
		//alert(t['06']);
		//return;
	Update_click();
	//var PatNo=document.getElementById('TabRegnoz'+selectrow).value;
	//var PatName=document.getElementById('TabPatNamez'+selectrow).value;
    var userid=session['LOGON.USERID'];	
	var groupid=session['LOGON.GROUPID'];	
	var ctlocid=session['LOGON.CTLOCID'];
	//alert(InvoiceId)
	var kname=session['LOGON.USERNAME'];
	//var pno=document.getElementById('RegNo').value;
	var Pid=document.getElementById('PatientID').value;
	var m_CardNo=document.getElementById('CardNo').value;
    var RegFee=document.getElementById('Mon');
    var amount=RegFee.value;
    var Info=document.getElementById('PatInfo');
	if (Info) {var encmeth=Info.value} else {var encmeth=''};
	    var rtn=cspRunServerMethod(encmeth,Pid);
	    var Str=rtn.split("^");
	 var PatName=Str[0];
	 var PatSex=Str[1];
	 var PatAge=Str[2];
	if (window.name=="CacelReg")
	{   
		var Parobj=window.opener
		/*
		var myobj=Parobj.document.getElementById("CardNo");
		if (myobj){
			myobj.value=m_CardNo;
		}
		*/
		var objName=Parobj.document.getElementById("Name");
		var objSex=Parobj.document.getElementById("Sex");
		var objAge=Parobj.document.getElementById("Age");
	
		if (objName){
			objName.style.visibility="visible";
			objName.value=PatName;
		}
		if (objSex){
			objSex.style.visibility="visible";
			objSex.value=PatSex;
		}
		if (objAge){
			objAge.style.visibility="visible";
			objAge.value=PatAge
		}	
	}
	//var Formobj=document.getElementById('fDHCOPReturn');
	//Formobj.ACTION="websys.csp";
	//Formobj.method="post";
	//if (Formobj) Formobj.submit();	
	if(CloseFlag=="Y"){
		window.close();
		Parobj.websys_setfocus('ReadCard');
		
		var CardNo=DHCC_GetElementData("CardNo");
		var CardTypeStr=combo_CardType.getSelectedValue();
		var CardTypeArr=CardTypeStr.split("^");
		var CardTypeValue=CardTypeArr[0];
		var RegNo=DHCC_GetElementData("RegNo");
		Parobj.websys_setfocus('ReadCard');
		if (Parobj){
			if(CardNo!=''){
				Parobj.SetPassCardNo(CardNo,CardTypeValue);
			}else if(RegNo!=''){
				var objPatientNo=Parobj.document.getElementById("PatientNo");
				if(objPatientNo)objPatientNo.value=RegNo
				Parobj.CheckPatientNo();
				Parobj.websys_setfocus('DeptList');
			}
			
		}
		
	}
	}
	else
	{
		alert(t['06']);	
	}
}

function Restore_clickHandler(){
	selectrow=SelectedRow;
	if (selectrow!="0"){
		var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];
		var pno=DHCC_GetElementData('RegNo');
		var amount=DHCC_GetElementData('mon');
		if (RegRowId=="") return;
	  	var encmeth=DHCC_GetElementData('RestoreOPRegistMethod');  
		if (encmeth!=''){
			alert(RegRowId+","+userid+","+groupid+","+ctlocid);
			var ret=cspRunServerMethod(encmeth,RegRowId,userid,groupid,ctlocid)
			if (ret="0"){
				QueryCancel_clickHandler();
			}else{
				alert('撤销失败!'+ret);
			}
		}
	}else{
		alert(t['06']);	
	}
}


function QueryCancel_clickHandler(){
	DHCC_ClearTable('tDHCOPReturn');
	var encmeth=DHCC_GetElementData('GetOPAdmMethod')
	if (encmeth!=''){
		var PatientID=DHCC_GetElementData('PatientID');
		var InvoiceNo=DHCC_GetElementData('InvoiceNo');	
		var nday=DHCC_GetElementData('nday');	
		var RegNo="";
		var userid=session['LOGON.USERID'];
		var CancelFlag="1";
		//alert(PatientID+"^"+InvoiceNo+"^"+nday);
		var retDetail=cspRunServerMethod(encmeth,"AddDataToTable",RegNo,nday,InvoiceNo,PatientID,userid,CancelFlag);
		if (retDetail>0) {
			if (admobjtbl.rows.length>1){
				var objrow=admobjtbl.rows[1];
				objrow.click();
				admobjtbl.focus();
			}
			var obj=document.getElementById("Update");
			if (obj) obj.style.display='none';

			var obj=document.getElementById('Change');
			if (obj) obj.style.display='none';

	    var obj=document.getElementById('SwichReg');
			if (obj) obj.style.display='none';

			var obj=document.getElementById('Reprint');
			if (obj) obj.style.display='none';

			var obj=document.getElementById('Restore');
			if (obj) obj.style.display='';

		}else{
			websys_setfocus('CardNo');
		}				
	}
}	

function Find_clickHandler(e)	{
	/*
	var RegNo=document.getElementById('RegNo');
	if (RegNo.value=="") {
		alert("Reg No is Null!!")
		return false;
	}
	*/
	var CardNo=DHCC_GetElementData('CardNo');
	var RegNo=DHCC_GetElementData('RegNo');
	var InvoiceNo=DHCC_GetElementData('InvoiceNo');
	if ((CardNo=='')&&(InvoiceNo=='')&&(RegNo=='')){
		websys_setfocus('CardNo');
		alert(t['NotCondition']);
		return;
	}
	if (CardNo!=""){
		event.keyCode=13;
		CardNoKeydownHandler(e);
		return false;
	}else{
		Find_click();
	}
}

function FID_key(e){
	var key=websys_getKey(e);
	if (key==13) {
		//FID_onchange();
		var PatientNo=DHCC_GetElementData("RegNo");
		if (PatientNo!='') {
			if (PatientNo.length<10) {
				for (var i=(10-PatientNo.length-1); i>=0; i--) {
					PatientNo="0"+PatientNo;
				}
			}
		}
		DHCC_SetElementData("RegNo",PatientNo);
		Find_clickHandler();
	}
}


function Find_click(){
	DHCC_ClearTable('tDHCOPReturn');
	var encmeth=DHCC_GetElementData('GetOPAdmMethod')
	if (encmeth!=''){
		var PatientID=DHCC_GetElementData('PatientID');
		var InvoiceNo=DHCC_GetElementData('InvoiceNo');	
		var nday=DHCC_GetElementData('nday');	
		var RegNo=DHCC_GetElementData('RegNo');
		var userid=session['LOGON.USERID'];

		//alert(PatientID+"^"+InvoiceNo+"^"+nday);
		var retDetail=cspRunServerMethod(encmeth,"AddDataToTable",RegNo,nday,InvoiceNo,PatientID,userid);
		if (retDetail>0) {
			if (admobjtbl.rows.length>1){
				var objrow=admobjtbl.rows[1];
				selectedRowObj=""
				objrow.click();
				SelectedRow=1;
				var ReturnFee=GetReturnSum(SelectedRow)
		        DHCC_SetElementData("Mon",ReturnFee)
				admobjtbl.focus();
			}
			var obj=document.getElementById("Update");
			if (obj) obj.style.display='';

			var obj=document.getElementById('Change');
			if (obj) obj.style.display='';
			
			var obj=document.getElementById('SwichReg');
			if (obj) obj.style.display='';

			var obj=document.getElementById('Reprint');
			if (obj) obj.style.display='';

			var obj=document.getElementById('Restore');
			if (obj) obj.style.display='none';

		}else{
			websys_setfocus('CardNo');
		}				
	}
}
function AddDataToTable(val){
	//alert(val);
	try{
		if (admobjtbl.rows.length==2) {
			var TabRowId=DHCC_GetColumnData("TabRowId",1)
			if (TabRowId!=''){DHCC_InsertRowToTable(admobjtbl);}
		}else{
			DHCC_InsertRowToTable(admobjtbl);
		}

		var Row=admobjtbl.rows.length-1;
  
  	//Deptid,Dept,Doctorid,Doctor,TabTime,UserName,AdmId,TabPrice,Arcdr,Regno,Tph,InvoiceId,TabDate,RegfeeDate,
  	//RegfeeTime,RegfeeRowId,TabInvoiceNo,TabRBASRowId,TabTRRBASRowId,TabTRDoc,TabRBASStatus,TabRBASStatusCode,
  	//TabRegType,TabAppFee,RBASStatusReason,PatName,TRSum,ChangeSum
  	
		var Split_Value=val.split("^");
		var Doctorid=Split_Value[2];
		var Doctor=Split_Value[3];
		var Dept=Split_Value[1];
		var Deptid=Split_Value[0];
		var Tph1=Split_Value[10];
		var UserName=Split_Value[5];
		var AdmId=Split_Value[6];
		var TabPrice=Split_Value[7];
		var Arcdr='';
		var TabRegno=Split_Value[9];
		var TabTime=Split_Value[4];
		var InvoiceId=Split_Value[11];
		var TabDate=Split_Value[12];
		var TabRegDate=Split_Value[13];
		var TabRegTime=Split_Value[14];
		var TabRowId=Split_Value[15];
		var TabInvoiceNo=Split_Value[16];
		var TabTRDoc=Split_Value[19];
		var TabRBASRowId=Split_Value[17];
		var TabTRRBASRowId=Split_Value[18]
		var TabRRBASStatus=Split_Value[20];
		var TabRegType=Split_Value[22];
		var TabAppFee=Split_Value[23];
		var TabRBASStatusCode=Split_Value[21];
		var TabRBASStatusReason=Split_Value[24];
		var TabPatName=Split_Value[25];
		var TabTRSum=Split_Value[26];
		var TabChangeSum=Split_Value[27];
		var TabINVPayMode=Split_Value[28];
		var TabRegFee=Split_Value[29];
		var TabCheckFee=Split_Value[30];
		var TabAppFee=Split_Value[31];
		var TabReCheckFee=Split_Value[32];
		var TabOtherFee=Split_Value[33];
		var TabHoliFee=Split_Value[34];
		var TabReturnFlag=Split_Value[35];
		var PatientID=Split_Value[36];
		var MRFee=Split_Value[37];
		var TabInsuAdmInfoDr=Split_Value[38];
		var TabAdmReasonId=Split_Value[39];
		var RegNo=DHCC_GetElementData("RegNo")
		DHCC_SetElementData("RegNo",TabRegno); //if(RegNo=="") 
		DHCC_SetElementData("PatientID",PatientID);
		DHCC_SetColumnData("Doctorid",Row,Doctorid);
		DHCC_SetColumnData("Doctor",Row,Doctor);
		DHCC_SetColumnData("Dept",Row,Dept);
		DHCC_SetColumnData("Deptid",Row,Deptid);
		DHCC_SetColumnData("Tph1",Row,Tph1);
		DHCC_SetColumnData("UserName",Row,UserName);
		DHCC_SetColumnData("AdmId",Row,AdmId);
		DHCC_SetColumnData("TabPrice",Row,TabPrice);
		DHCC_SetColumnData("TabRegno",Row,TabRegno);
		DHCC_SetColumnData("TabTime",Row,TabTime);
		DHCC_SetColumnData("InvoiceId",Row,InvoiceId);
		DHCC_SetColumnData("TabDate",Row,TabDate);
		DHCC_SetColumnData("TabRegDate",Row,TabRegDate);
		DHCC_SetColumnData("TabRegTime",Row,TabRegTime);
		DHCC_SetColumnData("TabRowId",Row,TabRowId);
		DHCC_SetColumnData("TabInvoiceNo",Row,TabInvoiceNo);
		DHCC_SetColumnData("TabTRDoc",Row,TabTRDoc);
		DHCC_SetColumnData("TabRBASRowId",Row,TabRBASRowId);
		DHCC_SetColumnData("TabTRRBASRowId",Row,TabTRRBASRowId);
		DHCC_SetColumnData("TabRRBASStatus",Row,TabRRBASStatus);
		DHCC_SetColumnData("TabRegType",Row,TabRegType);
		DHCC_SetColumnData("TabAppFee",Row,TabAppFee);
		DHCC_SetColumnData("TabRBASStatusCode",Row,TabRBASStatusCode);
		DHCC_SetColumnData("TabRBASStatusReason",Row,TabRBASStatusReason);
		DHCC_SetColumnData("TabPatName",Row,TabPatName);
		DHCC_SetColumnData("TabTRSum",Row,TabTRSum);
		DHCC_SetColumnData("TabChangeSum",Row,TabChangeSum);
		DHCC_SetColumnData("TabINVPayMode",Row,TabINVPayMode);
		DHCC_SetColumnData("TabRegFee",Row,TabRegFee);
		DHCC_SetColumnData("TabCheckFee",Row,TabCheckFee);
		DHCC_SetColumnData("TabAppFee",Row,TabAppFee);
		DHCC_SetColumnData("TabReCheckFee",Row,TabReCheckFee);
		DHCC_SetColumnData("TabOtherFee",Row,TabOtherFee);
		DHCC_SetColumnData("TabHoliFee",Row,TabHoliFee);
		DHCC_SetColumnData("TabReturnFlag",Row,TabReturnFlag);
		DHCC_SetColumnData("TMRFee",Row,MRFee);
		DHCC_SetColumnData("TabInsuAdmInfoDr",Row,TabInsuAdmInfoDr);
		DHCC_SetColumnData("TabAdmReasonId",Row,TabAdmReasonId);
		switch(TabRBASStatusCode)	{
			case 'S':
			 	admobjtbl.rows[Row].className='ScheduleStop';
			 	break;
			case 'TR':
				admobjtbl.rows[Row].className='PublicHol';
				break;
			case 'R':
				admobjtbl.rows[Row].className='ScheduleReplace';
				break;
		}

	}catch(e){
		alert(e.message);
	}
}

function documentkeydown(e) { 
	var keycode;
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==120){
		Update_click();
	}else if (keycode==119) {
		//ChangeClickHandler();
		ReprintClickHandler();
	}else if(keycode==121) {
		ReprintClickHandler();
	}else if(keycode==115) {
		ReadCardClickHandler();
	}else if(keycode==116){
		//F5
		ReadInsuCardInfo();
	}else if(keycode==117) {
		SwichReg_click();
	}else if(keycode==118) {
		Find_clickHandler(e);
	}else{
		websys_sckey(e)
	}
}
function GetTableSelectRow(e){
	if (selectedRowObj.rowIndex==""){return "";}
	var selectrow=selectedRowObj.rowIndex;
	return selectrow
}

function TableKeydownHandler(e){
	var key=websys_getKey(e);

	var selectrow=GetTableSelectRow();
	var objtbl=window.document.getElementById('tDHCOPReturn');
	if (selectrow=="") return
	if (key==38){
		if (selectrow==1) return;
		var objrow=objtbl.rows[selectrow-1];
		objrow.click();
		//window.event.cancelBubble=true
	}
	if (key==40){
		if (selectrow==(objtbl.rows.length-1)) return;
		var objrow=objtbl.rows[selectrow+1];
		objrow.click();
			//window.event.cancelBubble=true
	}
}

function combo_CardTypeKeydownHandler(){
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=combo_CardType.getSelectedValue();
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR=="")	{	return;	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo");
	}	else{
		
		var myobj=document.getElementById("CardNo");
		//if (myobj){myobj.readOnly = true;}
		if (myobj){myobj.readOnly = false;}     //郭荣勇 支持手输卡号功能
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadCardClickHandler;
			
		}
		DHCWeb_setfocus("ReadCard");
	}
	if (myary[16]=="Handle"){
		
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
	
	
}

function rcard_Click(){
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	leftmon=myary[3];
	///alert(myary);
	//var RegNoObj=document.getElementById('RegNo');
	switch (rtn){
		case "0": //卡有效
			var obj=document.getElementById("RegNo");
			//alert(myary[1]);
			obj.value=myary[5]; //lglxiugai myary[5]
			m_CardNo=myary[1];
			event.keyCode=13;
			//RegNoObj_keydown(event);
			FID_key(e);
			break;
		case "-200": //卡无效
			alert(t['18']);
			websys_setfocus('RegNo');
			break;
		case "-201": //现金
			//alert(t['21']);
			var obj=document.getElementById("RegNo");
			obj.value=myary[5];
			event.keyCode=13;
			FID_key(e);
			break;
		default:
	}
}

function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
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
				Find_click();
				//event.keyCode=13;
				//Find_click(e);				
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
            Find_click();
			SetPatientInfo(PatientNo,CardNo,PatientID);
			//Find_click();				
			//DHCC_SelectOptionByCode("PayMode","CASH")
			break;
		default:
	}
}

function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCC_AddToListA","CardType");
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

function GetCardNoLength(){
	var CardNoLength="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	//return 15;
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
				FID_key(e);				
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
				Find_click();				

				//DHCC_SelectOptionByCode("PayMode","CASH")
				break;
			default:
		}
	}
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	if (PatientNo!='') {
		DHCC_SetElementData("RegNo",PatientNo);
		DHCC_SetElementData("CardNo",CardNo);
		DHCC_SetElementData("PatientID",PatientID);
	}
}
function UpdatePatAdmReason_click(){
	var selectrow=SelectedRow;
	if (selectrow>0){
		var admid=document.getElementById('AdmIdz'+selectrow).value;
		if(admid==""){
			alert(t['09'])
			return false;
		}
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPChgAdmreason";
	    win=open(lnk,"Cquery","top=150,left=400,width=650,height=500,scrollbars=yes,resizable=yes")
	}else{
		alert(t['09'])
	}		
	
}

function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var obj=document.getElementById('Mon');
		var obj1=document.getElementById('RegNo');
		var ReturnFee=GetReturnSum(selectrow)
		var ChangeSum=DHCC_GetColumnData('TabChangeSum',selectrow);
		DHCC_SetElementData("Mon",ReturnFee)
		DHCC_SetElementData("ChangeSum",ChangeSum)
		SelectedRow = selectrow;
	}else{
		SelectedRow=0;
		DHCC_SetElementData("Mon",0)
		DHCC_SetElementData("ChangeSum","")
		DHCC_SetElementData("ReturnCash","");
	}
	
	/*
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var obj=document.getElementById('Mon');
		var obj1=document.getElementById('RegNo');
		
		var TotalFee=DHCC_GetColumnData('TabPrice',selectrow);
		var AppFee=DHCC_GetColumnData('TabAppFee',selectrow);
		var ChangeSum=DHCC_GetColumnData('TabChangeSum',selectrow);
		var ReturnFee=TotalFee-AppFee;
		DHCC_SetElementData("mon",ReturnFee)
		DHCC_SetElementData("ChangeSum",ChangeSum)
		SelectedRow = selectrow;
	}else{
		SelectedRow=0;
		DHCC_SetElementData("mon",0)
		DHCC_SetElementData("ChangeSum","")
		}
		*/
}

function FID_onchange() {
	var obj=document.getElementById('RegNo');
	if(obj.value=="") return 
	if (obj){
		if (obj.value.length<10) {
			for (var i=(10-obj.value.length-1); i>=0; i--) {obj.value="0"+obj.value}
		}
	}
}


function RetSS_Click(){
	selectrow=SelectedRow;
	var aid=document.getElementById('Arcdrz'+selectrow).value;
	var dep=document.getElementById('Deptidz'+selectrow).value;
	var doc=document.getElementById('Doctoridz'+selectrow).value;
	var admid=document.getElementById('AdmIdz'+selectrow).value;
	var kname=session['LOGON.USERNAME'];
	
	var pno=document.getElementById('RegNo').value;
	var Pid=document.getElementById('Pid');
	if (Pid) {var encmeth=Pid.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPid','',aid,dep,doc,admid,kname)=='0') {}
}

function ChangeAdm_clickHandler(e){
	selectrow=SelectedRow;
	var NewCardNo=DHCC_GetElementData('ChangeCardNo');
	if (NewCardNo==""){alert(t['NewCardNoIsNull']);return;}

	if (selectrow!="0"){
		var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];
		
	  var encmeth=DHCC_GetElementData('TransferOPRegistMethod');  
		if (encmeth!=''){
			var ret=cspRunServerMethod(encmeth,'','',RegRowId,NewCardNo,userid,groupid,ctlocid)
			var retarr=ret.split("$");	
			if (retarr[0]=="0"){
				PrintOut(retarr[1]);
				GetReceiptNo();
				alert(t['TransferOk']);
				Find_click(e);			
			}else{
				if(retarr[0]=="diagnos") {alert(t['05']);}
				else if (retarr[0]=="orditem") {alert(t['10']);}
				else if (retarr[0]=="Invoice") {alert(t['11']);}
				else if (retarr[0]=="-301") {alert(t['InvaildNewCard']);}
				else {alert(t['TransferFail']+retarr[0]);}
				websys_setfocus('ChangeCardNo');
				return;
			}
		}
		DHCC_SetElementData('ChangeCardNo','')
		Find_click();
	}else{
		alert(t['NotSelectChangeAdmRow']);	
	}
}	


function ChangeClickHandler(e){
	var obj=document.getElementById('Change');
	if (obj.style.display=='none') return;

	selectrow=SelectedRow;
	var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
	RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
	if ((selectrow!="0")&&(RegRowId!="")){
		var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
		var TRRBASRowId=DHCC_GetColumnData('TabTRRBASRowId',selectrow);
		if (TRRBASRowId==""){
			alert(t['NoReplaceDoctor']);
			return;
		}
		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];
		
	  var encmeth=DHCC_GetElementData('ChangeOPRegistMethod');  
		if (encmeth!=''){
			var ret=cspRunServerMethod(encmeth,'','',RegRowId,TRRBASRowId,userid,groupid,ctlocid)
			var retarr=ret.split("$");	
			if (retarr[0]=="0"){
				PrintOut(retarr[1]);
				GetReceiptNo();
				alert(t['ChangeOk']);
				Find_click(e);
			}else{
				if(retarr[0]=="diagnos") {alert(t['05']);}
				else if (retarr[0]=="orditem") {alert(t['10']);}
				else if (retarr[0]=="Invoice") {alert(t['11']);}
				else {alert(t['ChangeFail']+retarr[0]);}
			}
		}
	}else{
		alert(t['NotSelectChangeRow']);	
	}	
}

function ReprintClickHandler(e){
  DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var obj=document.getElementById('Reprint');
	if (obj.style.display=='none') return;

	selectrow=SelectedRow;
	var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
	RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
	if ((selectrow!="0")&&(RegRowId!="")){
		var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);

		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];
		
	  var encmeth=DHCC_GetElementData('RePrintMethod');  
		if (encmeth!=''){
			var ret=cspRunServerMethod(encmeth,'','',RegRowId,userid,groupid,ctlocid)
			var retarr=ret.split("$");	
			if (retarr[0]=="0"){
				//PrintOut(retarr[1]);
				//打印发票 --如果存在医保需要判断是调用医保接口打印发票还是调用HIS打印发票-医保修改按照项目上线自行修改
				var PrintArr=retarr[1].split("^");
				var RegfeeRowID=PrintArr[42];
				PrintInv(RegfeeRowID)
				alert(t['RePrintOk']);
				GetReceiptNo();
				SelectedRow=0
				Find_click();
			}else{
				if (retarr[0]=="-200"){
					alert(t['InvoiceNotSelf']);
				}else if (retarr[0]=="-300"){
					alert("发票号为空的挂号记录,不能作废重打!");
				}else if (retarr[0]=="-201"){
					alert("门诊收费确认完成失败!请在门诊收费异常处理界面重新结算!")
				}else{
					alert(t['RePrintFail']);
				}
			}
		}
	}else{
		alert(t['NotSelectReprintRow']);	
	}	
}

function Update_click(){
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var obj=document.getElementById('Update');
	if (obj.style.display=='none') return;
	selectrow=SelectedRow;
	var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
	RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
	if ((selectrow!="0")&&(RegRowId!="")){
		var UpdateSure=confirm("是否确定要退号?");
		if(UpdateSure==false)
		{
			CloseFlag="N";
			//SelectedRow=0
			return ;
	    }
		var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
		var RBASRowId=DHCC_GetColumnData('TabRBASRowId',selectrow);
		var InsuAdmInfoDr=DHCC_GetColumnData('TabInsuAdmInfoDr',selectrow);
		var AdmReasonId=DHCC_GetColumnData('TabAdmReasonId',selectrow);
		var TabPayMode=DHCC_GetColumnData('TabPayMode',selectrow);
		var TabPrice=DHCC_GetColumnData('TabPrice',selectrow);
		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];
		var pno=DHCC_GetElementData('RegNo');
		var amount=DHCC_GetElementData('mon');
		var PatientNo=DHCC_GetElementData('RegNo');		
        var PatientID=DHCC_GetElementData('PatientID');
		if (RegRowId=="") return;
		
		//add by zf 2008-05-23  Invalid  Request
		var xPaadm=DHCC_GetColumnData('AdmId',selectrow);
		if (xPaadm){var xret=InvalidRequest(xPaadm);}
		
		//在HIS退号之前先进行医保退钱
		//不可退的原因
		var encmeth=DHCC_GetElementData('CheckDiagnosMethod');  
		if (encmeth!=''){
			var rtn=cspRunServerMethod(encmeth,xPaadm,groupid);
			var rtnArray=rtn.split("^");
			if (rtnArray[0]==1){
				alert("病人"+rtnArray[1]);
				return;
			}
		}
		/*var diagnosflag=cspRunServerMethod(EncryptObj.CheckAdmDiagnos,xPaadm);
		if (diagnosflag=='diagnos'){
			alert("您好由于病人已经就诊不能进行退号!");
			return;
		}*/
		/*var ReturnMR="N"
		var ObjReturnMR=document.getElementById('ReturnMR');
		if (ObjReturnMR){if (ObjReturnMR.checked){ReturnMR="Y"}}*/
		var ReturnMR="N"
		var ObjReturnMR=document.getElementById('ReturnMR');
		if (ObjReturnMR){if (ObjReturnMR.checked){ReturnMR="Y"}};
		if(ReturnMR=="Y"){
			var conMRFlag=confirm("是否退病历本费?");
			if(conMRFlag==false){
			  ObjReturnMR.checked=false;
			  ReturnMR="N"
			}
		}else{
			var MRFee=DHCC_GetColumnData('TabOtherFee',selectrow);
			if(+MRFee!=0){
				var conMRFlag=confirm("是否退病历本费?");
				if(conMRFlag==false){
				    ObjReturnMR.checked=false;
				    ReturnMR="N"
				}else{
					ObjReturnMR.checked=true
					ReturnMR="Y"
				}
			}
		}
		objReturnMR_click()
		//退号原因
		var ReturnReasonDr=""
		var Obj=document.getElementById('TabReturnReasonz'+selectrow);
		if (Obj){
			ReturnReasonDr=Obj.value;
		}
		//医保结算退号,如果失败需要加入异常订单
		if (InsuAdmInfoDr!="") {
			var UseInsuFlag="N";
			var InsuReadCardInfo="";
			var EnableInsuBillFlag=IsEnableInsuBill("",RBASRowId,UseInsuFlag,AdmReasonId,InsuReadCardInfo)
			if (EnableInsuBillFlag==true) {
				var InsuRetValue=InsuOPRegStrike(0,userid,InsuAdmInfoDr,"",AdmReasonId,"");
				if(InsuRetValue!=0) {
					alert("医保退号失败,请重新退号.");
					//TODO 增加异常订单数据,退号不增加，因为退号已经为医保退在前，如果HIS不成功继续退号即可(医保退号方法可多次调用，医保已经做判断)
					// 医保退号失败，回退HIS挂号失败，存储异常订单
                    //信息串：病人ID^就诊ID^医保指针^操作人^订单状态^排班ID^是否挂号							    
                    //var OPRegINABInfo=PatientID+"^"+xPaadm+"^"+InsuAdmInfoDr+"^"+userid+"^"+"N"+"^"+RegRowId+"^"+"N"+"^"+AdmReasonId;	
                    //var ret=tkMakeServerCall("web.DHCOPAdmReg","SaveDHCOPAdmINAB",OPRegINABInfo);
					return;
				}
			}
		}
	  	var encmeth=DHCC_GetElementData('CancelOPRegistMethod');  
		if (encmeth!=''){
			var ret=cspRunServerMethod(encmeth,'','',RegRowId,userid,groupid,ctlocid,ReturnMR,ReturnReasonDr)
			//alert(ret)
			var retarr=ret.split("$");	
			if (retarr[0]!="0"){
				SetPid(retarr[0]);
			}else{
				var RetInfo=""
				if(TabPayMode=="CASH") RetInfo=t['NoticeInfoXJ']+TabPrice+"元"
				if(TabPayMode=="CPP") RetInfo=t['NoticeInfoCPP']
				//alert(retarr[1])
				if (retarr[1]!="") {
					//PrintOut(retarr[1]);
					var PrintArr=retarr[1].split("^");
					var RegfeeRowID=PrintArr[42];
					var APIFlag=retarr[2];
					if (APIFlag=="Y"){
						PrintInvCPP(RegfeeRowID);
					}else{
						PrintInv(RegfeeRowID);
					}
					//PrintInv(RegfeeRowID)
				}
				alert(t['15']+RetInfo);
				GetReceiptNo();
				SelectedRow=0
				Find_click();
			}
		}
	}else{
		alert(t['06']);	
	}
}


function SetPid(value){

	if (value!="0") {
		CloseFlag="N";
		if(value=="cancel") {alert(t['AdmIsCanceled']);}
		if(value=="diagnos") {alert(t['05']);}
		if(value=="orditem") {alert(t['10']);}
		if(value=="Invoice") {alert(t['11']);}
		if(value=="overtime") {alert(t['OverTime']);}
		if(value=="NotSameHosp") {alert("不能跨院退号,请核实所退号所在医院!");}
		if ((value!="Invoice")&&(value!="orditem")&&(value!="diagnos")&&(value!="overtime")&&(value!="cancel")){
			alert(t['CancelFail']+value);
		}
		ReturnStatus=1;
	}else{
	  alert(t['15']);
		ReturnStatus=0;
	}
}

function SaveNumbleFaxed(str)
{
	var len,StrTemp;	
	if((str=="")||(!str)) return 0;
	if(parseInt(str)==str){
		str=str+".00";
		}else{
		StrTemp=str.toString().split(".")[1];
		len=StrTemp.length;
		if(len==1){
			str=str+"0";
		}else{
			var myAry=str.toString().split(".");
			str=myAry[0]+"."+myAry[1].substring(0,2);
		}
	}
	
	return str;
}
function PrintOut(PrintData) {
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	try {
		if (PrintData=="") return;
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+" "+TimeRange;
		var TimeD=TimeRange.substring(0,2);
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[10];
		var RegDateYear=PrintArr[12];
		var RegDateMonth=PrintArr[13];
		var RegDateDay=PrintArr[14];
		var TransactionNo=PrintArr[15];
		var Total=PrintArr[16];
		var RegFee=PrintArr[17];
		var AppFee=PrintArr[18];
		var OtherFee=PrintArr[19];
		var ClinicGroup=PrintArr[20];
		var RegTime=PrintArr[21];
		var ExabMemo=PrintArr[23];
		var InsuPayCash=PrintArr[24];
		var InsuPayCount=PrintArr[25];
		var InsuPayFund=PrintArr[26];
		var InsuPayOverallPlanning=PrintArr[27];
		var InsuPayOther=PrintArr[28];
		var TotalRMBDX=PrintArr[29];
		var INVPRTNo=PrintArr[30];
		var CardNo=PrintArr[31];
		var Room=PrintArr[32];
		var AdmReason=PrintArr[33];
		var Regitems=PrintArr[34];
		var AccBalance=PrintArr[35];
		var PatNo=PrintArr[36];
		var TimeRangeInfo=PrintArr[37];
		var HospitalDesc=PrintArr[38];
		var PersonPay=PrintArr[39];
		var YBPay=PrintArr[40];
		var DYIPMRN=PrintArr[41];
		var RowID=PrintArr[42];
		var DYOPMRN=PrintArr[44];
		var DYIPMRN=PrintArr[45];
		var MyList="";
		for (var i=0;i<Regitems.split("!").length-1;i++){
			var tempBillStr=Regitems.split("!")[i];
			if (tempBillStr=="") continue;
			var tempBillDesc=tempBillStr.split("[")[0];
			var tempBillAmount=tempBillStr.split("[")[1];
			if (MyList=="") MyList=tempBillDesc+"   "+tempBillAmount;
			else  MyList = MyList + String.fromCharCode(2)+tempBillDesc+"   "+tempBillAmount;
		}
		//病人自负比例的备注
		var ProportionNote="";
		var ProportionNote1="";
		var ProportionNote2="";
		InsuPayCash="";
		InsuPayCount="";
		InsuPayOverallPlanning="";
		InsuPayOther="";
		ProportionNote="本收据中,"+RegFee+"元"+"不属于医保报销范围";
		ProportionNote1="";
		ProportionNote2="";
		var CardFee=""
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime
		if (AccBalance=="") AccBalance=0;
		//消费后金额
		AccTotal="" //SaveNumbleFaxed(AccBalance);
		//消费前金额
    	AccAmount="" //SaveNumbleFaxed(parseFloat(AccBalance)+parseFloat(Total));
		var cardnoprint=DHCC_GetElementData('CardNo');
		if (cardnoprint=="") cardnoprint=DHCC_GetColumnData('TPatCardNo',SelectedRow); 
		var TimeD=TimeRange;

		if (AppFee!=0){AppFee="预约费:"+AppFee}else{AppFee=""}
		if (OtherFee!=0) {OtherFee="治疗费:"+OtherFee}else{OtherFee=""}
		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo+"^"+"AccTotal"+PDlime+AccTotal+"^"+"AccAmount"+PDlime+AccAmount;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup+"^"+"SessionType"+PDlime+SessionType+"^"+"TimeD"+PDlime+TimeD+"^"+"RegTime"+PDlime+RegTime+"^"+"cardnoprint"+PDlime+cardnoprint;
		var MyPara=MyPara+"^"+"INVPRTNo"+PDlime+INVPRTNo;
		var MyPara=MyPara+"^"+"TimeRangeInfo"+PDlime+TimeRangeInfo;
		var MyPara=MyPara+"^"+"YBPay"+PDlime+YBPay;
		var MyPara=MyPara+"^"+"PersonPay"+PDlime+PersonPay;
		var MyPara=MyPara+"^"+"RowID"+PDlime+RowID;
		var MyPara=MyPara+"^"+"DYIPMRN"+PDlime+Trim(DYIPMRN);
		var MyPara=MyPara+"^"+"ExabMemo"+PDlime+ExabMemo;
		var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo;       //打印登记号
		var MyPara=MyPara+"^"+"DYOPMRN"+PDlime+DYOPMRN+"^DYIPMRN"+PDlime+DYIPMRN
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");	
	} catch(e) {alert(e.message)};
}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}
function GetReceiptNo(){
	var encmeth=DHCC_GetElementData('GetreceipNO');
	var p1=session['LOGON.USERID']+"^"+"^"+session['LOGON.GROUPID']+"^"+"R"
	if (encmeth!=""){
		if (cspRunServerMethod(encmeth,'SetReceipNO','',p1)!='0') {
			alert(t['InvalidReceiptNo']);
			return
		}
	}
}


function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	DHCC_SetElementData('ReceiptNo',ls_ReceipNo);
	
	//DHCWebD_SetObjValueA("INVLeftNum",myary[2]);
	///如果张数小于最小提示额change the Txt Color
	var obj=document.getElementById("ReceiptNo")
	if (myary[1]!="0"){	obj.className='clsInvalid';}
}


function CleartDHCOPAdm(){
	var objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex+1;j++) {objtbl.deleteRow(1);}
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
function objReturnMR_click()
{
	var ReturnFee=""
	var selectrow=SelectedRow;
	if (selectrow!="0"){
		ReturnFee=GetReturnSum(selectrow)
		DHCC_SetElementData("Mon",ReturnFee)
	}
	else{
		DHCC_SetElementData("Mon",ReturnFee)
		}
}
function GetReturnSum(selectrow)
{
		var TotalFee=DHCC_GetColumnData('TabPrice',selectrow);
		var AppFee=DHCC_GetColumnData('TabAppFee',selectrow);
		var ReturnFee=TotalFee-AppFee;
		var InvoiceId=DHCC_GetColumnData('InvoiceId',selectrow);
		var TabINVPayMode=DHCC_GetColumnData('TabINVPayMode',selectrow);
		var CashPayMode=document.getElementById('CashPayMode').value;
		var CashAmt=0,MRFee=0;
		if (InvoiceId!=""){
			for (var m=0;m<TabINVPayMode.split(",").length;m++){
				var OnePayModeStr=TabINVPayMode.split(",")[m];
				var OnePayMode=OnePayModeStr.split(":")[0];
				var OnePayModeAmt=OnePayModeStr.split(":")[1];
				if (OnePayMode==CashPayMode){
					var CashAmt=OnePayModeAmt;
					break;
				}
		    }
		}else{
			//var TotalFee=DHCC_GetColumnData('TabPrice',selectrow);
			//var AppFee=DHCC_GetColumnData('TabAppFee',selectrow);
			CashAmt=TotalFee-AppFee;
		}
		if (InvoiceId!=""){
			var FeeTypeStr="MR";
			var MRFee=tkMakeServerCall('web.DHCOPAdmReg','GetRegINVAppFee',InvoiceId,FeeTypeStr,0);
		}else{
			var MRFee=DHCC_GetColumnData('TMRFee',selectrow);
		}
		var ObjReturnMR=document.getElementById('ReturnMR');
		if ((ObjReturnMR)&&(ObjReturnMR.checked)){
			DHCC_SetElementData("ReturnCash",+CashAmt);
			return (+ReturnFee)
			//return (+CashAmt);
		}else{
			if ((+CashAmt)==0) var sum=+CashAmt 
			else  var sum=(+CashAmt)-(+MRFee);
			DHCC_SetElementData("ReturnCash",sum);
			return ((+ReturnFee)-(+MRFee)).toFixed(2);
			//return ReturnFee;
		}
		
		/*if (InvoiceId!=""){
			var FeeTypeStr="App^MR^Card"
			var ObjReturnMR=document.getElementById('ReturnMR');
			if (ObjReturnMR){if (ObjReturnMR.checked){FeeTypeStr="App^Card"}}
			ReturnFee=tkMakeServerCall('web.DHCOPAdmReg','GetRegINVAppFee',InvoiceId,FeeTypeStr,1)
		}else{
			var TotalFee=DHCC_GetColumnData('TabPrice',selectrow);
			var AppFee=DHCC_GetColumnData('TabAppFee',selectrow);
			ReturnFee=TotalFee-AppFee;
		}
		return ReturnFee*/
}
function ReturnMRClickHandler()
{
	if(SelectedRow!=0){
		var ReturnFee=GetReturnSum(SelectedRow)
        DHCC_SetElementData("Mon",ReturnFee)
	}
  
}
function OldRegPrintClickHandler(e){
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	var obj=document.getElementById('OldRegPrint');
	if (obj.style.display=='none') return;

	selectrow=SelectedRow;
	var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);
	RegRowId=RegRowId.replace(/(^\s*)|(\s*$)/g,'');
	if ((selectrow!="0")&&(RegRowId!="")){
		var RegRowId=DHCC_GetColumnData('TabRowId',selectrow);

		var userid=session['LOGON.USERID'];	
		var groupid=session['LOGON.GROUPID'];	
		var ctlocid=session['LOGON.CTLOCID'];

		var encmeth=DHCC_GetElementData('OldRegRePrintMethod');  
		if (encmeth!=''){

			var ret=cspRunServerMethod(encmeth,'','',RegRowId,userid,groupid,ctlocid)

			var retarr=ret.split("$");	

			if (retarr[0]=="0"){
				//PrintOut(retarr[1]);
				//打印发票 --如果存在医保需要判断是调用医保接口打印发票还是调用HIS打印发票-医保修改按照项目上线自行修改
				var PrintArr=retarr[1].split("^");
				var RegfeeRowID=PrintArr[42];
				PrintInv(RegfeeRowID)
				alert(t['RePrintOk']);
				GetReceiptNo();
				SelectedRow=0
				Find_click();
			}else{
				if (retarr[0]=="-200"){
					alert(t['InvoiceNotSelf']);
				}else if (retarr[0]=="-300"){
					alert("发票号为空的挂号记录,不能作废重打!");
				}else{
					alert(t['RePrintFail']);
				}
			}
		}
	}else{
		alert(t['NotSelectReprintRow']);	
	}	
}

//挂号发票打印
function PrintInv(RegFeeID)
{   
	var UserID=session['LOGON.USERID'];
	var Return=tkMakeServerCall("web.DHCOPAdmReg","GetPrintInvInfo","InvPrint","INVPrtFlag2007",RegFeeID, UserID, "","");
}
function PrintInvCPP(RegFeeID){
	var UserID=session['LOGON.USERID'];
	var Return=tkMakeServerCall("web.DHCOPAdmReg","GetPrintInvInfo","InvPrintNewCPP","INVPrtFlagCPP", RegFeeID, UserID, "","");
}
function InvPrintNewCPP(TxtInfo, ListInfo){
	DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlagCPP");
	InvPrintNew(TxtInfo, ListInfo);
}
function InvPrint(TxtInfo, ListInfo){
	DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlag2007");
	InvPrintNew(TxtInfo, ListInfo);
}
function InvPrintNew(TxtInfo,ListInfo)
{   
	//DHCP_GetXMLConfig("InvPrintEncrypt","INVPrtFlag2007");
	var myobj=document.getElementById("ClsBillPrint");
	//------和收费使用同模板，解决多打印出一张空白页的情况------
	var tmpListInfo="";
	var tmpListAry=ListInfo.split(String.fromCharCode(2));
	var ListLen=tmpListAry.length;
	for (var i = 0; i < ListLen; i++) {
		if (i>7) break;
		if (tmpListInfo=="") {
			tmpListInfo=tmpListAry[i];
		}else{
			tmpListInfo=tmpListInfo+String.fromCharCode(2)+tmpListAry[i];
		}	
	}
	ListInfo=tmpListInfo;
	//------
	PrintFun(myobj,TxtInfo,ListInfo);	
}
//是否启用挂号医保实时结算,方法同DHCOPAdm.Reg.js同名方法
/*params*
*PatientID:患者ID
*ASRowId:出诊记录ID
*UseInsuFlag:界面医保标识(Y/N)【可选】
*[AdmReasonId]:费别ID【可选】
*[InsuReadCardInfo]:读医保卡的返回信息【可选】
*/
function IsEnableInsuBill(PatientID,ASRowId,UseInsuFlag,AdmReasonId,InsuReadCardInfo) {
	//启用医保实时结算
	var CFEnableInsuBill="";
	var Obj=document.getElementById('CFEnableInsuBill');
	if (Obj){
		CFEnableInsuBill=Obj.value;
	}
	var IsEnableInsuBillFlag=false;
	var InsurFlag=tkMakeServerCall("web.DHCDocOrderCommon","GetInsurFlag",AdmReasonId,"O");
	//1.按费别优先
	if (CFEnableInsuBill==1) {
		if (InsurFlag==1){IsEnableInsuBillFlag=true}else{IsEnableInsuBillFlag=false}
	}
	//2.按界面传入参数优先
	if (CFEnableInsuBill==2) {
		if (UseInsuFlag=='Y') {
			if (InsurFlag==1){IsEnableInsuBillFlag=true}else{IsEnableInsuBillFlag=false}
		}else{
			IsEnableInsuBillFlag=false;
		}
	}
	return IsEnableInsuBillFlag;
}

document.body.onload = BodyLoadHandler;
document.onkeydown=documentkeydown;
