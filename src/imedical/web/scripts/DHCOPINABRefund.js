///DHCOPINABRefund.js

var m_SelectCardTypeDR = "";
var SelectedRow=0;
var m_CardNoLength = 12;
var sessobjtbl=document.getElementById('tDHCOPINABRefund');
function BodyLoadHandler() {
	var obj = document.getElementById("BClear");
	if (obj) {
		obj.onclick = BClear_Click;
	}
	/*
	var obj = document.getElementById("Audit");
	if (obj) {
		obj.onclick = Audit_Click;
		Audit_Click();
	}*/
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = ReceipNO_OnKeyDown;
	}
	var obj = document.getElementById("ReadCardQuery");
	if (obj) {
		obj.onclick = CardQuery_Click;
	}
	var obj = document.getElementById("PatientNO");
	if (obj) {
		obj.onkeydown = PatientNoKeyDown
	}
	var obj = document.getElementById("RCardNo");
	if (obj) {
		if (obj.type != "Hiden") {
			obj.onkeydown = RCardNo_KeyDown;
		}
	}
	var obj = document.getElementById('ReadInsuCard');
	if (obj) {
		obj.onclick = ReadInsuCard_OnClick;
	}
	var obj = document.getElementById("Deal");
	if (obj){
		obj.onclick = Deal_click;				
	}
	var obj = document.getElementById("ChargeUser");
	if (obj){
		//obj.onkeydown = ChargeUserChangeHandle;	
		obj.onblur = ChargeUserChangeHandle;			
	}
	var obj=document.getElementById("AllSelect");
	if (obj){obj.onclick=SelectAllClickHandler;}
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
		myobj.onchange = CardTypeDefine_OnChange;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
	CardTypeDefine_OnChange();
	//document.onkeydown = DocumentOnKeydown;
}
function ChargeUserChangeHandle(){
	var obj=document.getElementById("ChargeUser");
	var myobj=document.getElementById("UserId");
	if((obj)&&(myobj)){
		if(obj.value==""){myobj.value="";}
	}
}
function SelectAllClickHandler(e){
  var obj=document.getElementById("AllSelect");
  var Objtbl=document.getElementById('tDHCOPINABRefund');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('ReciptSelectz'+i); 
	if (!selobj.disabled)	{selobj.checked=obj.checked;}  
	}
}
function Deal_click()
{
	var UserID=session['LOGON.USERID'];
    var IsSelectFlag=false;
	var UserId=session['LOGON.USERID'];
	try{
		var eTABLE=document.getElementById("tDHCOPINABRefund");
		for (var i=1; i<eTABLE.rows.length; i++) {
			var ReciptSelectObj=document.getElementById("ReciptSelectz"+i);
			if (ReciptSelectObj.checked) {
				var Row=GetRow(sessobjtbl,i);
				var IsSelectFlag=true;
				var obj=document.getElementById("InsuAdmRowidz"+i);
				if (obj) var InsuAdmInfoDr=obj.value;
				var obj=document.getElementById("TabAdmReasonz"+i);
				if (obj) var AdmReason=obj.value;
				//alert(InsuAdmRowid+"$"+AdmReason)
				//挂号的异常订单产生于HIS挂号失败，撤销医保挂号失败时，处理步骤是进行医保退号
				//退号的异常订单产生于医保退号失败，回退HIS退号失败时，处理步骤是进行医保退号，而不是回退HIS退号
                var InsuRetValue=InsuOPRegStrike(0,UserID,InsuAdmInfoDr,"",AdmReason,"");
                if (InsuRetValue=='-1'){	                		   
					alert("异常订单处理失败!");
                    return false;					
	            }
	            //else{alert("异常订单处理成功!");return;}		    
			}			
		}
    }catch(e){alert(e.message)}
	if (!IsSelectFlag) {alert("请先选择一条记录后再处理!");return;}	
	return true;
}
function GetRow(objtbl,Rowindex){
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

function BClear_Click() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPINABRefund";
	window.location.href = lnk;
}

function Audit_Click() {
	var Auditobj = document.getElementById("Audit");
	var obj = document.getElementById("AuditFlag");
	if (obj) {
		if (Auditobj.checked) {
			obj.value = "A";
		} else {
			obj.value = "ALL";
		}
	}
}

function CardQuery_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		websys_$("RCardNo").value = myary[1];
		var obj = document.getElementById("PatientNO");
		obj.value = myary[5];
		ReadPatInfo();
		break;
	case "-200":
		alert("无效卡");
		break;
	case "-201":
		websys_$("RCardNo").value = myary[1];
		var obj = document.getElementById("PatientNO");
		obj.value = myary[5];
		ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("RCardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCardQuery");
	} else {
		var myobj = document.getElementById("RCardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCardQuery");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, CardQuery_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("RCardNo");

	} else {
		DHCWeb_setfocus("ReadCardQuery");
	}
	m_CardNoLength = myary[17];
	DHCWeb_setfocus("PatientNO");
}

function DocumentOnKeydown() {
	DHCWeb_EStopSpaceKey();
	var e = event ? event : (window.event ? window.event : null);
	var keycode;
	try {
		keycode = websys_getKey(e);
	} catch (e) {
		keycode = websys_getKey();
	}
	if (keycode == 115) {
		var obj = document.getElementById("ReadCardQuery");
		if (obj) {
			obj.click();
		}
	}
	websys_setfocus('PatientNO');
}
function ReceipNO_OnKeyDown(e) {
	if (!e)
		var key = websys_getKey(e);
	if (key == 13) {
		Find_click();
	}
}

function PatientNoKeyDown(e) {
	var key = websys_getKey(e);
	if ((key == 13)) {
		ReadPatInfo();
	}
}

function RCardNo_KeyDown(e) {
	var key = websys_getKey(e);
	if ((key == 13)) {
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("RCardNo");
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj = document.getElementById("PatientNO");
			obj.value = myary[5];
			ReadPatInfo();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			var myPAPMNo = myary[5];
			var obj = document.getElementById("PatientNO");
			obj.value = myary[5];
			ReadPatInfo();
			break;
		default:
		}
		return;
	}
}

function ReadInsuCard_OnClick() {
	try {
		var rtn = ReadCard("N");
		if ((rtn == "-1") || (rtn == "")) {
			return;
		}
		var myArr = rtn.split("|");
		var obj = document.getElementById('RCardNo');
		if (obj) {
			obj.value = myArr[0];
		}
		var CardNo = myArr[0];
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, CardNo, "", "PatInfo");
		if (CardNo == "") {
			return;
		}
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var obj = document.getElementById("PatientNO");
			obj.value = myary[5];
			ReadPatInfo();
			break;
		case "-200": //卡无效,InvaildCard:卡无效
			alert("卡无效");
			//websys_setfocus('RegNo');
			break;
		case "-201": //现金,Cashpayment:使用现金
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var obj = document.getElementById("PatientNO");
			obj.value = myary[5];
			ReadPatInfo();
			break;
		default:
		}
	} catch (e) {
		alert("读卡错误:" + " " + e.message);
		return;
	}
}

function SetCardNOLength() {
	var obj = document.getElementById('RCardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value
			}
		}
		var myCardobj = document.getElementById('CardNo');
		if (myCardobj) {
			myCardobj.value = obj.value;
		}
	}
}

function ReadPatInfo() {
	var PatientNO = document.getElementById("PatientNO");
	if ((PatientNO) && (PatientNO.value != "")) {
		var PatNo = PatientNO.value;
		var GetPAPMI = document.getElementById('GetPAPMI');
		if (GetPAPMI) {
			var encmeth = GetPAPMI.value;
		} else {
			var encmeth = '';
		}
		var myExpStr = "";
		var PatDr = cspRunServerMethod(encmeth, PatNo, myExpStr);
		if (PatDr == "") {
			alert("此登记号不存在对应病人，请确认.");
			DHCC_SetElementData("PatientNO","")
			websys_setfocus('PatientNO');
			return websys_cancel();
		}
		SetPatientInfo(PatDr); //设置基本信息
		Find_click();
	}
}

function SetPatientInfo(PatDr) {
	var GetPatInfo = document.getElementById('GetPatInfo');
	if (GetPatInfo) {
		var encmeth = GetPatInfo.value;
	} else {
		var encmeth = '';
	}
	var myExpStr = "";
	var PatInfoStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	var PatInfo = PatInfoStr.split("^");
	//PatInfo[0]		PAPMI_RowId
	//PatInfo[1]		PAPMI_NO
	//PatInfo[2]		PatientName
	//PatInfo[3]		PatientSex
	//PatInfo[4]		AgeDesc
	//PatInfo[5]		PatientBirthday
	//PatInfo[6]		Patient Social Status
	//PatInfo[7]		Patient Social Staus DR
	//PatInfo[8]		Patient Sex Dr
	//PatInfo[9]		PatientDOB
	//PatInfo[10]		PatientCompany
	//PatInfo[11]		AgeYear
	//PatInfo[12]		AgeMonth
	//PatInfo[13]		AgeDay
	//PatInfo[14]		Patient Company Address
	//PatInfo[15]		EmployeeNO
	//PatInfo[16]		PatientMarital
	//PatInfo[17]		PatCategoryRowId
	//PatInfo[18]		Medcare
	var PatientID = document.getElementById('PatientNO');
	var PatName = document.getElementById('PatientName');
	var PatSex = document.getElementById('PatSex');
	var PatAge = document.getElementById('PatAge');
	PatientID.value = PatInfo[1];
	PatName.value = PatInfo[2];
	PatSex.value = PatInfo[3];
	PatAge.value = PatInfo[4];
	var EncryptLevelObj = document.getElementById('EncryptLevel');
	if (EncryptLevelObj) {
		EncryptLevelObj.value = PatInfo[22];
	}
	var PatLevelObj = document.getElementById('PatLevel');
	if (PatLevelObj) {
		PatLevelObj.value = PatInfo[23];
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tDHCOPINABRefund');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	if (SelectedRow==selectrow){
		SelectedRow=0;
	}else{
		SelectedRow = selectrow;
	}
	if (selectrow!=0){
		//alert(selectrow)
		//自动选中一行
		var ReciptSelectObj=document.getElementById("ReciptSelectz"+selectrow);
		if(!ReciptSelectObj.disabled) ReciptSelectObj.checked=true;
		var DealId="Dealz"+selectrow;
		if (eSrc.id==DealId){
			var ret=Deal_click();
			if(ret){alert("异常订单处理成功.");}
			return false;
		}
	}
}

function GetColumnData(ColName, Row) {
	var CellObj = document.getElementById(ColName + "z" + Row);
	if (CellObj) {
		if (CellObj.tagName == 'LABEL') {
			return CellObj.innerText;
		} else {
			if (CellObj.type == "checkbox") {
				return CellObj.checked;
			} else {
				return CellObj.value;
			}
		}
	}
	return "";
}

function cashierselect(val){
	var UserId=document.getElementById("UserId");
	var ChargeUser=document.getElementById("ChargeUser");
	if (val.split("^").length>0){
		ChargeUser.value=val.split("^")[1];
		UserId.value=val.split("^")[2];
	}
}

function DHCC_SetElementData(ElementName,value){
 	var obj=document.getElementById(ElementName);
 	if(obj){
 		obj.value=value;
	}
 	return "";
}

document.body.onload = BodyLoadHandler;
