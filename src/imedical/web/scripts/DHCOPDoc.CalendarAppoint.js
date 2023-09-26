document.body.onload = BodyLoadHandler;
var e=event;
function BodyLoadHandler() {
	var obj=document.getElementById('CancelApp');
	if (obj) obj.onclick=CancelAppClickHandler;
	
	var obj=document.getElementById('PrintAppInfo');
	if (obj) obj.onclick=PrintAppInfo;
	var objtbl=document.getElementById('tDHCOPDoc_CalendarAppoint');
	var rows=objtbl.rows.length;
	for (var j=1; j<rows; j++){
		var Row=GetRow(j);
		var RowId=DHCC_GetColumnData("RowId",Row);
	}	
	
	//读卡  //////////////////////zlj
	//DHCWeb_DisBtnA("Update");
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;
	var obj=document.getElementById('CardNo');
	if (obj) obj.onkeydown = CardNoKeydownHandler;
	var obj=document.getElementById('Papmino');
	if (obj) {
		obj.onkeydown = PapminoKeydownHandler;
		if (obj.value!="") SetPatientInfo(obj.value);
	}
	ReadCardType();
	var obj=document.getElementById('CardType');
	
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");	
	if (combo_CardType) 
	{
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	combo_CardTypeKeydownHandler();
	var obj=document.getElementById('Clear');
	if (obj) obj.onclick=ClearClick;

	
}

function ClearClick()
{
	DHCC_SetElementData("MarkDocID","");
	DHCC_SetElementData("RBResID","");
	DHCC_SetElementData("StartDay","");	
	DHCC_SetElementData("EndDay","");
	DHCC_SetElementData("Papmino","");
	DHCC_SetElementData("PatientID","");
	DHCC_SetElementData("PatientID","");
	DHCC_SetElementData("CardNo","");
	DHCC_SetElementData("Name","");
	return Find_click()
	
}

///zlj  
/// 2012-08-10 
/// 读取卡类型
function ReadCardType(){   
	DHCC_ClearList("CardType");	
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");	
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCC_AddToListA","CardType");		
	}
}
///zlj   2012-08-10  手动输入卡号
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
		
		//m_CCMRowID=GetCardEqRowId();        
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
///zlj   2012-08-10  读卡查询
function ReadCardClickHandler()
{
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
				DHCC_SetElementData("CardNo",CardNo);							
				DHCC_SetElementData("Papmino",PatientNo);
				DHCC_SetElementData("PatientID",PatientID);
				var obj=document.getElementById('Papmino');
				SetPatientInfo(PatientNo);
				WindowReLoad();
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
			DHCC_SetElementData("Papmino",PatientNo);
			DHCC_SetElementData("PatientID",PatientID);			
			var obj=document.getElementById('Papmino');
			SetPatientInfo(PatientNo);
			WindowReLoad();
			break;
		default:
	}
}

function PapminoKeydownHandler(e) {
	var key=websys_getKey(e);
	if (key==13) {
		var obj=document.getElementById('Papmino');
		if (obj) {
			var PatientNo=DHCC_GetElementData("Papmino");
			if (PatientNo!='') {
				if (PatientNo.length<10) {
					for (var i=(10-PatientNo.length-1); i>=0; i--) {
						PatientNo="0"+PatientNo;
					}
				}
			}
			DHCC_SetElementData("Papmino",PatientNo);
			SetPatientInfo(obj.value);
			WindowReLoad();
		}
	}
}
///zlj   2012-07-27  根据卡号查询
function CardNoKeydownHandler()
{
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
		DHCC_SetElementData("CardNo",CardNo);
		
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];		
		switch (rtn){
			case "0": //卡有效有帐户
				var PatientID=myary[4];						
				var PatientNo=myary[5];				
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo);			
				var obj=document.getElementById('Papmino');		  
				event.keyCode=13;
				WindowReLoad();
				//FID_key(e);				
				break;
			case "-200": //卡无效
				alert(t['InvaildCard']);
				websys_setfocus('CardNo');
				break;
			case "-201": //卡有效无帐户
				//alert(t['21']);
				var PatientID=myary[4];					
				var PatientNo=myary[5];				
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
                SetPatientInfo(PatientNo);		
			   var obj=document.getElementById('Papmino');			   
				event.keyCode=13;	
				WindowReLoad();			
				break;
			default:
		}
	}
}
///zlj   2012-08-10  得到卡类型
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
///zlj   2012-07-27  校正卡号长度
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

///zlj   2012-07-27  得到卡长度
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

//----取消预约
function CancelAppClickHandler(){
    var SelectedRows=0;
	var objtbl=document.getElementById('tDHCOPDoc_CalendarAppoint');
	var Length=objtbl.rows.length;
	for (var j=1;j<Length;j++) {
		var Obj=document.getElementById('SelectRz'+j)
		if (Obj){
			if (Obj.checked){
				var Obj=document.getElementById('RowIdz'+j)
				if (Obj){
						var APPID=Obj.value;
						if (APPID!=""){
							var PatName=""; var AppDate="";var AppDep="";var AppDoc="";
							var AppMethod=""; var AppSeqNo=""
							var Obj=document.getElementById('PatNamez'+j)
							if (Obj){PatName=Obj.innerText}
							var Obj=document.getElementById('AppDatez'+j)
							if (Obj){AppDate=Obj.innerText}
							var Obj=document.getElementById('AppDepz'+j)
							if (Obj){AppDep=Obj.innerText}
							var Obj=document.getElementById('AppDocz'+j)
							if (Obj){AppDoc=Obj.innerText}
							var Obj=document.getElementById('AppMethodz'+j)
							if (Obj){AppMethod=Obj.innerText}
							var Obj=document.getElementById('AppSeqNoz'+j)
							if (Obj){AppSeqNo=Obj.innerText}
							var Rtn=tkMakeServerCall('web.DHCRBAppointment','CancelAppointment',APPID,session['LOGON.USERID']);
							if (Rtn!=0){
								if (Rtn=="-201"){alert(PatName+"预约取消失败,已取号！"+"\n["+AppDate+" "+AppDep+" "+AppDoc+" "+AppSeqNo+" "+AppMethod+"]")}
								else if (Rtn=="-202"){alert(PatName+"预约取消失败,已经取消,不能重复取消!"+"\n["+AppDate+" "+AppDep+" "+AppDoc+" "+AppSeqNo+" "+AppMethod+"]")}
								else{alert(PatName+"预约取消失败!"+"\n["+AppDate+" "+AppDep+" "+AppDoc+" "+AppSeqNo+" "+AppMethod+"]")}
							}
							SelectedRows=SelectedRows+1;
						}
						
				}
				
			}
		}
	}
	if (SelectedRows!=0){
		window.parent.location.reload();
	}else{
		alert("请选择需要取消预约的记录!")
	}
	

}


function GetRow(Rowindex){
	var objtbl=document.getElementById('tDHCOPDoc_CalendarAppoint');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;			
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}
function DHCC_GetElementData(ElementName){
	var obj=document.getElementById(ElementName);
	if (obj){
		if (obj.tagName=='LABEL'){
			return obj.innerText
		}else{
			if (obj.type=='checkbox') return obj.checked;
			return obj.value
		}
	}
	return "";
}
function SetPatientInfo(PatientNo) {
	//var PatientNo=DHCC_GetElementData('Papmino');
	if (PatientNo!="") {
		var GetDetail=document.getElementById('GetDetail');
		if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'SetPatient_Sel','',PatientNo)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('Papmino');
			return websys_cancel();
		}
		
	}
	return websys_cancel();
}
function WindowReLoad(){
	var Url=window.location.href
    var HeadUrl=Url.split("?")[0]
    var BackUrl=Url.split("?")[1]
    var strArr=BackUrl.split("&")
    if (strArr.length>2){
	    var strArrNew=strArr.slice(1,strArr.length-4)
		strArrNew="&"+strArrNew.join("&")
	}else{
		var strArrNew="";
	}
    var NewStr=strArrNew+"&CardNo="+DHCC_GetElementData("CardNo")+"&Papmino="+DHCC_GetElementData("Papmino")+"&Name="+DHCC_GetElementData("Name")+"&PatientID="+DHCC_GetElementData("PatientID"); 
    var Url=HeadUrl+"?"+strArr[0]+NewStr //
    window.location.href=Url
}
function SetPatient_Sel(value) {
	try {  
		var Patdetail=value.split("^");
		DHCC_SetElementData("Name",Patdetail[0]);
		DHCC_SetElementData("Age",Patdetail[1]);
		DHCC_SetElementData("Sex",Patdetail[2]);
		//门诊病历号和住院病历号
		DHCC_SetElementData("OPMRN",Patdetail[3]);
		DHCC_SetElementData("IPMRN",Patdetail[4]);
		//医保号
		DHCC_SetElementData("PatYBCode",Patdetail[11]);
		//医保类型
		DHCC_SetElementData("YBType",Patdetail[12]);
		//西院门诊病历号和住院病历号
		var PAPERSGMedicareCode1=Patdetail[13];
		var PAPERSGMedicareCode2=Patdetail[14];
		DHCC_SetElementData("SGMedicareCode1",PAPERSGMedicareCode1);
		DHCC_SetElementData("SGMedicareCode2",PAPERSGMedicareCode2);
		DHCC_SetElementData("PatCat",Patdetail[5]);
		DHCC_SetElementData("PatientID",Patdetail[6]);
		DHCC_SetElementData("IDCardNo",Patdetail[7]);
		DHCC_SetElementData("Company",Patdetail[8]);
		DHCC_SetElementData("PatientNo",Patdetail[9]);
		DHCC_SetElementData("Papmino",Patdetail[9]);
		DHCC_SetElementData("AppBreakCount",Patdetail[10]);	
		//工号
		DHCC_SetElementData("EmployeeNo",Patdetail[18]);

	} catch(e) {
		alert(e.message)
	};
}

function PrintAppInfo()
{
	DHCP_GetXMLConfig("XMLObject","DHCOPAppointPrint");
	var objtbl=document.getElementById('tDHCOPDoc_CalendarAppoint');
	var Length=objtbl.rows.length;
	for (var j=1;j<Length;j++) {
		var Obj=document.getElementById('SelectRz'+j)
		if (Obj){
			if (Obj.checked){
				var Obj=document.getElementById('RowIdz'+j)
				if (Obj){
						var APPID=Obj.value;
						if (APPID!=""){
						var Rtn=tkMakeServerCall('web.DHCOPAdmReg','GetAppPrintData',APPID)
						var RtnArry=Rtn.split("^")
						var PDlime=String.fromCharCode(2);
						var MyPara="CardNo"+PDlime+RtnArry[0]+"^"+"PatNo"+PDlime+RtnArry[13]+"^"+"PatName"+PDlime+RtnArry[2]+"^"+"RegDep"+PDlime+RtnArry[6]
						var MyPara=MyPara+"^"+"SessionType"+PDlime+RtnArry[18]+"^"+"MarkDesc"+PDlime+RtnArry[7]+"^"+"Total"+PDlime+RtnArry[17];
						var MyPara=MyPara+"^"+"AdmDate"+PDlime+RtnArry[10]+"^"+"APPDate"+PDlime+RtnArry[8]+" "+RtnArry[9]+"^"+"SeqNo"+PDlime+RtnArry[4]
						var MyPara=MyPara+"^"+"UserCode"+PDlime+RtnArry[15];
						var MyPara=MyPara+"^"+"MethType"+PDlime+"["+RtnArry[16]+"]"
						var MyPara=MyPara+"^"+"AdmTimeRange"+PDlime+RtnArry[14] //建议就诊时间
						var MyPara=MyPara+"^"+"tel"+PDlime+RtnArry[20] //电话
						var MyPara=MyPara+"^"+"opDate"+PDlime+RtnArry[21] //操作时间

						var myobj=document.getElementById("ClsBillPrint");
						DHCP_PrintFun(myobj,MyPara,"")
						}
				}
			}
		}
	}
	
}