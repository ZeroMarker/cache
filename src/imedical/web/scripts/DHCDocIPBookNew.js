//Creare by LiYang 2008-10-22
//Event Handler of DHCDocIPBookNew
var EpisodeID = GetParam(window.parent, "EpisodeID");
var RowID = GetParam(window.parent,"RowID")
setElementValue("RowID", RowID);
//alert("EpisodeID="+EpisodeID);
var objCurrentPatient = null; //CurrentPatient
var objCurrentAdm = null; //Current Patient Admit info
var objInPatientAdm = null;
var arryStateDic = QueryDicItemByTypeFlag("MethodQueryDicItemByTypeFlag", "IPBookingState", "Y", 0);
var arryStateChangeReason = QueryDicItemByTypeFlag("MethodQueryDicItemByTypeFlag", "IPBookingStateChangeReason", "Y", 0);
var arryTemplate = GetDHCDocIPBookingTemplateArry("MethodGetDHCDocIPBookingTemplateArry");
var objCurrentBook = null;
var strInpatientAdm = "";
var txtAdmCat = "1"; //Inpatient Type
var TemplateIDAvailable="";//add this property to record the only template aviliable in configuration 
//if IPBKFlag='SignBed',disable all elements except cboAdmWard,cboBed and txtAdmDep
var IPBKFlagVal=document.getElementById("IPBKFlag").value;

var CurrentStatus = GetMedDicIDByCode("MethodGetMedDicIDByCode", "IPBookingState", IPBKFlagVal);
var CurrentStateID = "";
//alert("CurrentStatus111="+CurrentStatus);
var MRDiagnose=GetMRDiagnosByEpisodeID("MethodGetMRDiagnosByEpisodeID",EpisodeID);
var HospName=GetHospName("MethodGetHospName");
var BookStr="Booking^PreInPatient^SignBed" //预约时候可显示状态
var OtherBookStr="Admission^Booking^Cancel^PreInPatient^SignBed"
//住院:Admission
//预约:Booking
//撤销:Cancel
//预住院:PreInPatient
//收住院:Register
//签床:SignBed

var OperationStatusID = "";
function DisableElements() {
	DisableElementsByTagName("input")
	HideHrefElements();
	document.getElementById("dtBookingDate").disabled=false;
	document.getElementById("btnSaveBookInfo").style.display ="inline";
	document.getElementById("btnSaveOutPrintBookInfo").style.display ="inline";
	
	//document.getElementById("cboTemplate").disabled=true;
}
//赋值
function DisplayPatientInfo(objPatient) {
    setElementValue("txtRegNo", objPatient.PatientNo);
    setElementValue("txtName", objPatient.PatientName);
    setElementValue("txtSex", objPatient.Sex);
    setElementValue("txtPatientType", objPatient.Payment);
    setElementValue("txtMrNo", objPatient.MedRecNo);
    setElementValue("txtAge", objPatient.Age);
    setElementValue("txtAddress", objPatient.NowAddress);
    setElementValue("txtCompany", objPatient.Company);
    setElementValue("txtPersonalID", objPatient.Identity);
    setElementValue("txtWedlock", objPatient.Marriage);
    setElementValue("txtTel", objPatient.Telephone);
    setElementValue("txtFName", objPatient.RelationName);
    setElementValue("FPhone", objPatient.Telephone);
    setElementValue("PoliticalLevel", objPatient.PoliticalLevel);
    setElementValue("SecretLevel", objPatient.SecretLevel);
    objCurrentPatient = objPatient;
}

function LookupDoctor(str) {
    var arryTmp = str.split(CHR_Up);
    objCurrDoctor = GetDHCWMRUserByID("MethodGetDHCDocIPBUserByID", arryTmp[0]);
    setElementValue("txtDoctor", arryTmp[2]);
    setElementValue("txtDoctorDr", arryTmp[0]);
}

function LookUpadmdep(str) {
    var obj = document.getElementById('txtAdmDep');
    var tem = str.split("^");
    obj.value = tem[1];
}

function admrealookup(str) {
    var obj = document.getElementById('admreasonid');
    var tem = str.split("^");
    obj.value = tem[1];
}

function LookUpadmward(str) {
    var obj = document.getElementById('txtAdmWardID');
    var tem = str.split("^");
    obj.value = tem[1];

}

function LookUpReason(str) {
    var obj = document.getElementById('txtAdmReasonID');
    var tem = str.split("^");
    obj.value = tem[1];
}

function LookUpWithAlias(str) {
    var obj = document.getElementById('MRDiagnosRowID');
    var tem = str.split("^");
    obj.value = tem[1];
}

function LookUpRelationAll(str) {
    var obj = document.getElementById('RelationID');
    var tem = str.split("^");
    obj.value = tem[1];
}
//AdmDoc == BookDoctor
//AdmReason 未填写
//AdmSubType 未填写
function SaveBookToObject() {
    if (objCurrentBook == null)
        objCurrentBook = new DHCDocIPBooking();
    objCurrentBook.PatientID = objCurrentPatient.RowID;
    objCurrentBook.EpisodeIDFrom = objCurrentAdm.RowID;
    objCurrentBook.EpisodeIDTo = strInpatientAdm;
    objCurrentBook.CreateDate = "";
    objCurrentBook.CreateTime = "";
    objCurrentBook.CreateUserID = session['LOGON.USERID'];
    objCurrentBook.CreateDocID = getElementValue("txtDoctorDr");
	//当前状态
    objCurrentBook.CurrentStateID = getElementValue("cboCurrStatus");
    objCurrentBook.IsActive = "Y";
    
    
    objCurrentBook.BookingDate = getElementValue("dtBookingDate");
    
    
    objCurrentBook.Text1 = getElementValue("cboAdmWard");
    objCurrentBook.Text2 = getElementValue("cboBed");      //shp
    objCurrentBook.Text3 = getElementValue("DepRowId");  
    objCurrentBook.Text4 = getElementValue("MRDiagnosRowID");
    //alert(getElementValue("MRDiagnosRowID"))
    //objCurrentBook.Text4 = getElementValue("txtMRDiagnos"); 
	objCurrentBook.IPDeposit = getElementValue("IPDeposit")
	objCurrentBook.AdmCondition = getElementValue("AdmCondition")
	objCurrentBook.IPBookNo = getElementValue("IPBookNo")
    return objCurrentBook;
}

function SaveDetailToObjectArry() {
    var objArry = new Array();
    var objDetail = null;
    var objTable = window.parent.frames["RPExtra"].document.getElementById("tDHCDocIPBookExtra");
    if (objTable == null) return objArry;
    for (var i = 1; i < objTable.rows.length; i++) {
        objDetail = new DHCDocIPBKDetail();
        objDetail.RowID = getElementValue("RowIDz" + i, window.parent.frames["RPExtra"].document);
        objDetail.BookID = objCurrentBook.RowID;
        objDetail.ItemID = getElementValue("ItemDrz" + i, window.parent.frames["RPExtra"].document, null);
        objDetail.ItemValue = getElementValue("txtValuez" + i, window.parent.frames["RPExtra"].document, null);
        objArry.push(objDetail);
    }
    return objArry;
}

function SaveStateInfoToObject() {
    var objState = new DHCDocIPBKState();
    objState.BookID = objCurrentBook.RowID;
    objState.StateID = getElementValue("cboCurrStatus");
    objState.ChangeUserID = session['LOGON.USERID'];
    objState.ReasonID = getElementValue("cboOpeReason");
    objState.ResumeText = getElementValue("txtResumeText");
    return objState;
}

function SaveAdmInfoToObject() {
    var str = "";
    str += objCurrentPatient.RowID + CHR_Up;
    str += "I" + CHR_Up;
    str += getElementValue("txtAdmDate") + CHR_Up;
    str += getElementValue("txtAdmTime") + CHR_Up;
    str += getElementValue("cboAdmWard") + CHR_Up;
    str += getElementValue("txtDoctorDr") + CHR_Up;
    str += getElementValue("txtAdmReasonID") + CHR_Up;
    str += session['LOGON.USERID'] + CHR_Up;
    str += getElementValue("txtAdmWardID") + CHR_Up;
    str += "" + CHR_Up; //Room
    str += "" + CHR_Up; //Bed
    str += "" + CHR_Up; //Epissubtype
    str += txtAdmCat + CHR_Up; //Adm Cat
    str += "" + CHR_Up; //AdmRefDocListDR
    str += "PRE" + CHR_Up;
   //str += "PRE";
    str +=getElementValue("IPBookNo")
    return str;
}

function ValidateBookingInfo() {
	var StatusObj = document.getElementById("cboCurrStatus")
		var StatusDesc = StatusObj.options[StatusObj.selectedIndex].text
		if (StatusDesc == "收住院" && getElementValue("dtBookingDate") == "") {
        window.alert(t["RequireBookingDate"]);
        return false;
    }
		//判断此就诊是否已经收住院
		if (StatusDesc == "收住院") {
			var RowID = getElementValue("RowID");
			var ret = tkMakeServerCall("web.DHCDocIPBookingCtl", "CheckIsRecIPByAdmId", EpisodeID);
			if ((ret.split("^")[0] == "1") && (ret.split("^")[1] != RowID)) {
				alert(ret.split("^")[2] + ",不能再收住院.");
				return false;
			}
		}
	var appIpatientStatusID = "";
	var recInatientStatusID = "";
	if (StatusObj.selectedIndex != -1) {
		var changedStatusID = getElementValue("cboCurrStatus");
		var changedStatusDesc = StatusObj.options[StatusObj.selectedIndex].text;
		var statusLength = StatusObj.options.length;
		for (var k = 0; k < statusLength; k++) {
			if (StatusObj.options[k].text == "预约住院") {
				appIpatientStatusID = StatusObj.options[k].value;
			}
			if (StatusObj.options[k].text == "收住院") {
				recInatientStatusID = StatusObj.options[k].value;
			}
		}
		if ((CurrentStateID != appIpatientStatusID) && (CurrentStateID != recInatientStatusID) && (changedStatusDesc == "撤销")) {
			//alert("预约住院和收住院状态才能改为撤销状态,请确认.");
			//return false;
		}
	}
	
    
    if(getElementValue("dtBookingDate")!=""){
    	var currentDate=getElementValue("currentDate");
    	var bookingDate=getElementValue("dtBookingDate");
    	var currentDateArray=currentDate.split("/");
    	var bookingDateArray=bookingDate.split("/");
    	var currentDateStr="";
    	var bookingDateStr="";
    	for(var i=2;i>=0;i--){
	   		currentDateStr=currentDateStr+currentDateArray[i];
	   		bookingDateStr=bookingDateStr+bookingDateArray[i];
		}
    	var currentDateNum=Number(currentDateStr);
    	var bookingDateNum=Number(bookingDateStr);

    	if(bookingDateNum<currentDateNum){
    		alert(t['BookingDateError']);
    		document.getElementById("dtBookingDate").focus();
    		return false;
    	}
    }
    if (((StatusDesc=="预约")||(StatusDesc=="预住院"))&&(getElementValue("dtBookingDate")=="")){alert("请填写预约日期!");return false}
    if (IPBKFlagVal=="SignBed"&&getElementValue("cboBed") == "") {
        //window.alert(t["RequireBed"]);
        //return false;
    }

    if (getElementValue("txtTel") == "") {
        window.alert(t["RequireTel"]);
        document.getElementById("txtTel").focus();
        return false;
    }
    if ((getElementValue("txtAdmDep") == "")||(getElementValue("DepRowId") == "")) {
	    document.getElementById("txtAdmDep").focus();
        window.alert(t["RequireAdmDep"]);
        return false;
    }
	/*
	if ((getElementValue("MRDiagnos") == "")||(getElementValue("MRDiagnosRowID") == "")) {
		document.getElementById("MRDiagnos").focus();
        window.alert(t["RequireMRDiagnos"]);
        return false;
    }
	*/
    if (document.getElementById("txtMRDiagnos")){
			if (getElementValue("txtMRDiagnos") == ""){
			document.getElementById("txtMRDiagnos").focus();
	        window.alert(t["RequireMRDiagnos"]);
	        return false;
	    }
    }
    
	
	var objDoc = window.parent.frames["RPExtra"].document
    var objTable = objDoc.getElementById("tDHCDocIPBookExtra");
    var blnIsNeed = false;
    var strDataType = "";
    for (var i = 1; i < objTable.rows.length; i++) {
        blnIsNeed = getElementValue("IsNeedz" + i, objDoc);
        strDataType = getElementValue("DataTypez" + i, objDoc);
        if (blnIsNeed && (getElementValue("txtValuez" + i, objDoc)) == "") {
            window.alert(getElementValue("Itemz" + i, objDoc) + t["IsRequiredField"]);
            objDoc.getElementById("txtValuez" + i).focus();
            return false;
        }
		/*
		if ((IPBKFlagVal=="SignBed")&&(getElementValue("Itemz" + i, objDoc)=="预交金")&&(getElementValue("txtValuez" + i, objDoc)=="")){
	        window.alert(getElementValue("Itemz" + i, objDoc)+"is required")
	        objDoc.getElementById("txtValuez" + i).focus();
	        return false;
        }
		*/
        
	}
	
    return true;
}

function ValidateControlDataType(controlID, type, errString) {
    var strValue = document.getElementById(controlID).value;
    var tmp = "";
    if (strValue == null) {
        window.alert(errString);
        return false;
    }
    switch (type) {
        case "int":
            if (!isNaN(parseInt(strValue))) {
                window.alert(errString);
                return false;
            }
            break;
        case "float":
            if (!isNaN(parseFloat(strValue))) {
                window.alert(errString);
                return false;
            }
            break;
    }
    return true;
}
	


function GetExtraItem(ItemKey) {
	//return ""
    var objDoc = window.parent.frames["RPExtra"].document;
    var objTable = window.parent.frames["RPExtra"].document.getElementById("tDHCDocIPBookExtra");
    var tempValue = "";
    var tmp = "";
    for (var i = 1; i < objTable.rows.length; i++) { 
        tmp = getElementValue("ItemCodez" + i, window.parent.frames["RPExtra"].document, null);
        if (tmp == ItemKey)
            return getElementValue("txtValuez" + i, window.parent.frames["RPExtra"].document, null);
    
    }
    return "";
 }




function btnPrintOnClick() {
	var RowID = getElementValue("RowID");
	var objBook = GetDHCDocIPBookingByPaadm("MethodGetDHCDocIPBookingByPaadm", EpisodeID, RowID);
	//alert(objBook+","+EpisodeID+","+RowID)
	if (objBook != null){
		//
	}else{
		alert("请先保存再打印!")
		return
	}
//alert(objBook)
/*
    var objPrinter = null;
//    try {
		var leftMargin=0.3;
		var vertiMargin=0.6;
		var vertiLine=0.5;
        objPrinter = new ActiveXObject("DHCMedVBPrinter.clsPrinter");
        objPrinter.Font = t["HeiTi"];
        objPrinter.FontBold = true;
        objPrinter.FontSize = 14;
        objPrinter.PrintContents(1.6, vertiLine, HospName);
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(2.3, vertiLine, t["Title"]);

        objPrinter.Font = t["SongTi"];
        objPrinter.FontBold = false;
        objPrinter.FontSize = 10;
        
        vertiLine=vertiLine+1;
        objPrinter.PrintContents(leftMargin, vertiLine, t["Name"] + objCurrentPatient.PatientName);
        objPrinter.PrintContents(3.0, vertiLine, t["Sex"] + objCurrentPatient.Sex);
        objPrinter.PrintContents(5.0, vertiLine, t["Age"] + objCurrentPatient.Age);
        
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, t["PatientNo"] + objCurrentPatient.PatientNo);
        objPrinter.PrintContents(5.0, vertiLine, t["CurrentState"]);
      
				vertiLine=vertiLine+vertiMargin;
        var Company=objCurrentPatient.Company;
        if(Company.length>13){
        	var Company1=Company.substr(0,13);
        	objPrinter.PrintContents(leftMargin, vertiLine, t["Company"] +Company1 );
        	vertiLine=vertiLine+0.5;
        	var Company2=Company.substr(13,Company.length);
        	objPrinter.PrintContents(leftMargin+1.5, vertiLine,Company2 );
        }else{
        	objPrinter.PrintContents(leftMargin, vertiLine, t["Company"] +Company);
        }
        
        vertiLine=vertiLine+vertiMargin;
        var Address=objCurrentPatient.NowAddress;
        if(Address.length>13){
        	var Address1=Address.substr(0,13);
        	objPrinter.PrintContents(leftMargin, vertiLine, t["Address"] +Address1 );
        	vertiLine=vertiLine+0.5;
        	var Address2=Address.substr(13,Address.length);
        	objPrinter.PrintContents(leftMargin+1.5, vertiLine,Address2 );
        }else{
        	objPrinter.PrintContents(leftMargin, vertiLine, t["Address"] +Address);
        }
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, t["Tel"] + objCurrentPatient.Telephone);

        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, t["ForeignID"] +getElementValue("txtFName"));
        objPrinter.PrintContents(4.5, vertiLine, t["Relation"] +getElementValue("Relation"));

        vertiLine=vertiLine+vertiMargin;
		    objPrinter.PrintContents(leftMargin, vertiLine, t["ForeignPhone"] +getElementValue("txtFPhone"));
      
        vertiLine=vertiLine+vertiMargin;  
        var DiagnoseDesc=GetMRDiagnosByID("MethodGetMRDiagnosByID",getElementValue("MRDiagnosRowID"));
        //var DiagnoseDesc=getElementValue("txtMRDiagnos")
        var DiagnoseDesc=getElementValue("MRDiagnos")
        //alert(DiagnoseDesc)
        objPrinter.PrintContents(leftMargin, vertiLine, t["FirstVisitDiagnose"]+DiagnoseDesc);

		vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, t["IpDep"] + getElementValue("txtAdmDep"));
        
        vertiLine=vertiLine+vertiMargin;
		objPrinter.PrintContents(leftMargin,vertiLine, t["Days"] + GetExtraItem("Days"));
		
		vertiLine=vertiLine+vertiMargin;
		objPrinter.PrintContents(leftMargin,vertiLine, t["FristVisitHospital"] + GetExtraItem("FristVisitHospital"));
		
		vertiLine=vertiLine+vertiMargin;
		objPrinter.PrintContents(leftMargin,vertiLine, t["SignDoctor"] + session['LOGON.USERNAME']);
		
		vertiLine=vertiLine+1.0;
        objPrinter.PrintContents(3.0, vertiLine, t["Sign"]);
        
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(3.0, vertiLine, t["CreateDay"] + getElementValue("txtCreateDay"));
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, "请持就诊卡或健康龙卡办理入院手续");
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, "如持临时卡请到门诊前台转换就诊卡");
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, "请确认入院证上患者姓名正确,签名:_______");
        vertiLine=vertiLine+vertiMargin;
        objPrinter.PrintContents(leftMargin, vertiLine, "该入院证在办理入院手续后请交入院处备档");
        
        objPrinter.EndDoc();        
//    } catch (e) {
//        window.alert(e.description);    
//    }
*/
    var IPBookNo=objBook.IPBookNo
	var StatusDesc ="预约"
	var StatusObj = document.getElementById("cboCurrStatus")
	if (StatusObj){ StatusDesc = StatusObj.options[StatusObj.selectedIndex].text}
	var AdmConditionobj=document.getElementById("AdmCondition")
	var AdmConditionobj1=AdmConditionobj.options[AdmConditionobj.selectedIndex]
	var AdmCondition=""
	if(AdmConditionobj1) AdmCondition =AdmConditionobj1.text
	var MyPara='';
	var PDlime=String.fromCharCode(2);
	MyPara=MyPara+"PatName"+PDlime+objCurrentPatient.PatientName+"^"+"PatSex"+PDlime+objCurrentPatient.Sex+"^"+"PatAge"+PDlime+objCurrentPatient.Age;
	MyPara=MyPara+"^"+"PatRegNo"+PDlime+objCurrentPatient.PatientNo+"^"+"PatStat"+PDlime+StatusDesc;
	MyPara=MyPara+"^"+"PatCom"+PDlime+objCurrentPatient.Company+"^"+"PatAdd"+PDlime+objCurrentPatient.NowAddress+"^"+"PatTel"+PDlime+objCurrentPatient.Telephone;
	MyPara=MyPara+"^"+"PatContact"+PDlime+getElementValue("txtFName")+"^"+"PatRelation"+PDlime+getElementValue("Relation");
	MyPara=MyPara+"^"+"PatReTel"+PDlime+getElementValue("txtFPhone")+"^"+"PatMR"+PDlime+getElementValue("MRDiagnos");
	MyPara=MyPara+"^"+"PatInDep"+PDlime+getElementValue("txtAdmDep") //+"^"+"PatInDays"+PDlime+GetExtraItem("Days");
	//MyPara=MyPara+"^"+"PatFirHos"+PDlime+GetExtraItem("FristVisitHospital")+"^"+"PatUserCode"+PDlime+session['LOGON.USERNAME'];
	MyPara=MyPara+"^"+"PatUserCode"+PDlime+session['LOGON.USERNAME'];
	MyPara=MyPara+"^"+"PatDocSign"+PDlime+"________"+"^"+"PatDate"+PDlime+getElementValue("txtCreateDay")+"^"+"AdmCondition"+PDlime+AdmCondition;
	var HosName1=document.getElementById("HospitalName").value
	if(HosName1!="")MyPara=MyPara+"^"+"HosName1"+PDlime+HosName1
	MyPara=MyPara+"^"+"IPBookNo"+PDlime+IPBookNo
	var myobj=document.getElementById("ClsBillPrint");
	PrintFun(myobj,MyPara,"");

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

function SaveToServer() {
	if (!ValidateBookingInfo()) return false;
    var strAdm = "";
    if (objCurrentBook == null) {
            strAdm = SaveAdmInfoToObject();
    }
    var objBook = SaveBookToObject();
    var retMain = SaveDHCDocIPBooking("MethodSaveDHCDocIPBooking", objBook);
    var arryDetail = SaveDetailToObjectArry();
    var objState = SaveStateInfoToObject();
    var objDetail = null;
    if (retMain > 0) {
        for (var i = 0; i < arryDetail.length; i++) {
            objDetail = arryDetail[i];
            //alert(objDetail)
            SaveDHCDocIPBKDetail("MethodSaveDHCDocIPBKDetail", objDetail);
        }
        //补充增加
        SaveDHCDocIPBKState("MethodSaveDHCDocIPBKState", objState);
        //保存
        var CurrPatID=objCurrentPatient.RowID;
        var Company=getElementValue("txtCompany");
        var Address=getElementValue("txtAddress");
        var Tel=getElementValue("txtTel");
        var PersonalID=getElementValue("txtPersonalID");
        var FName=getElementValue("txtFName");
        var FPhone=getElementValue("txtFPhone");
        var RelationID=getElementValue("RelationID");
        
        SaveBookingPatientBaseInfo("MethodSaveBookingPatientBaseInfo",CurrPatID,Company,Address,Tel,PersonalID,FName,FPhone,RelationID);
        objCurrentBook = objBook;
        setElementValue("RowID", objCurrentBook.RowID);
        objCurrentPatient = GetPatientByID("MethodGetPatientByID", objCurrentAdm.PatientID);
    }
    if (IPBKFlagVal=="SignBed"){
	    self.parent.close();
    	//window.parent.close();
    	//opener.parent.location["RPList"].reload();
    	//opener.parent.frames["RPList"].location.reload();
    	//opener.location.reload();
    }
	return retMain;
}

//保存并打印
function btnSaveOnClick() {
    var retMain=SaveToServer();
	if (retMain==false) return;
    if (retMain > 0) {
		btnPrintOnClick();
        window.alert(t["SaveOK"]);
        self.location.reload();
    }else {
        window.alert(t["SaveFail"]);
    }
}

//保存不打印
function btnSaveOutPrintOnClick() {
    var retMain=SaveToServer();
	if (retMain==false) return;
    if (retMain > 0) {
        window.alert(t["SaveOK"]);
        self.location.reload();
    }else {
        window.alert(t["SaveFail"]);
    }
}
function btnModifyState() {
    if (objCurrentBook == null) {
        window.alert(t["NotSave"]);
        return;
    }
    if (getElementValue("cboCurrStatus") == "") {
        window.alert(t["ChooseState"]);
        return;
    }
    var objState = SaveStateInfoToObject();
    SaveDHCDocIPBKState("MethodSaveDHCDocIPBKState", objState);
    window.alert(t["SaveStateOK"]);   
}

function btnStateList() {
    if (objCurrentBook == null) {
        window.alert(t["NotSave"]);
        return;
    }
    var strURL = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocIPBookStateList&BookID=" + objCurrentBook.RowID;
	if(typeof websys_writeMWToken=='function') strURL=websys_writeMWToken(strURL);
    window.open(strURL, "_blank", "height=300,width=700,status=yes,toolbar=no,menubar=no,location=no,top=50,left=100");
}

function cboTemplateListIndexChange() {
    var BookID = "";
    var TemplateID = getElementValue("cboTemplate");
    if (objCurrentBook != null)
        BookID = objCurrentBook.RowID;
    var strURL = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDocIPBookExtra&BookID=" + BookID + "&TemplateID=" + TemplateID+ "&IPBKFlag=" + IPBKFlagVal;
    if(typeof websys_writeMWToken=='function') strURL=websys_writeMWToken(strURL);
	window.parent.frames["RPExtra"].location.href = strURL;
}


function txtAdmitDepOnPropertyChange(DepRowId) {
	var DepRowId=document.getElementById("DepRowId").value;
	arry = GetLocByDep("MethodGetLocByDep", DepRowId);

    var objLoc = null;
    ClearListBox("cboAdmWard");
    //AddListItem("cboAdmWard", "", "");
    for (var i = 0; i < arry.length; i++) {
        objLoc = arry[i];
        AddListItem("cboAdmWard", objLoc.Department, objLoc.RowID);
    }
    txtAdmitWardOnPropertyChange();
}

function txtAdmitWardOnPropertyChange()
{
	var arry = QueryBedByDep("MethodQueryBedByDep", getElementValue("cboAdmWard"));
    var objBed = null;
    ClearListBox("cboBed");
    AddListItem("cboBed", "", "");
    for (var i = 0; i < arry.length; i++) {
        objBed = arry[i];
        AddListItem("cboBed", objBed.Desc, objBed.RowID);
	}
}

function InitForm() {
 	var objTable = document.getElementsByTagName("table")[1];
 	var strPrinter = "<OBJECT ID='clsPrinter' CLASSID='clsPrinter' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,45'>aaasssssssss</OBJECT>"
   //objTable.rows[0].cells[0].appendChild(document.createElement(GetVBPrinterObjectString("MethodPrinter"))); 
    var objBook = null;
    var PatientID = "";
	if (EpisodeID != "") {
		objCurrentAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", EpisodeID)
		if (objCurrentAdm == null) {
			window.alert("Paadm Error!!!!!");
			return;
		}
		//获得病人信息web.DHCDocIPBBaseCtl.GetPatInfo
		objCurrentPatient = GetPatientByID("MethodGetPatientByID", objCurrentAdm.PatientID);
		var Relation=GetRelationByPersonID("MethodGetRelationByPersonID",objCurrentAdm.PatientID);
		if(Relation){
			var RelationArray=Relation.split("^");
			setElementValue("Relation", RelationArray[1]);
			setElementValue("RelationID",RelationArray[0]);
		}
		var FPhone=GetFPhoneByPersonID("MethodGetFPhoneByPersonID", objCurrentAdm.PatientID);
		setElementValue("txtFPhone",FPhone);
	}
    var objDic = null;
    var objUser = null;
    MakeComboBox("cboCurrStatus");
    MakeComboBox("cboOpeReason");
    //MakeComboBox("cboTemplate");
    //MakeComboBox("txtAdmDep");
    MakeComboBox("cboAdmWard");  
    MakeComboBox("cboBed");
	MakeComboBox("AdmCondition");
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocIPBookPrt");
    //InitDeptList();
    if (EpisodeID != "") {
	    objCurrentAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", EpisodeID)
	    if (objCurrentAdm == null) {
	        window.alert("Paadm Error!!!!!");
	        return;
	    }
		//获得病人信息web.DHCDocIPBBaseCtl.GetPatInfo
	    objCurrentPatient = GetPatientByID("MethodGetPatientByID", objCurrentAdm.PatientID);
    }
	//DHCC_ClearList("AdmCondition");
	//var encmeth=DHCWebD_GetObjValue("GetSelectInsuTrad");
	var rtn=tkMakeServerCall("web.DHCDocIPBookingCtl","GetAdmCondition","DHCWeb_AddToList","AdmCondition")
	//objBook所用发法?]web.DHCDocIPBookingCtl.GetIPBookByPaadm通过门诊的Paadm取得住院证信息?^
   	var RowID = getElementValue("RowID");
	var objBook = GetDHCDocIPBookingByPaadm("MethodGetDHCDocIPBookingByPaadm", EpisodeID, RowID);
    for (var i = 0; i < arryStateDic.length; i++) {
        objDic = arryStateDic[i];
		if (RowID==""){if (BookStr.indexOf(objDic.Code)<0){continue}}
        else{if (OtherBookStr.indexOf(objDic.Code)<0){continue}}
        AddListItem("cboCurrStatus", objDic.Desc, objDic.RowID)
        //alert(objDic.RowID);
    }
    for (var i = 0; i < arryStateChangeReason.length; i++) {
        objDic = arryStateChangeReason[i];
        AddListItem("cboOpeReason", objDic.Desc, objDic.RowID)
    }
    var TemplateLength=arryTemplate.length;
    if(TemplateLength>1) {
	    document.getElementById("btnSaveBookInfo").style.display ="none";
	    document.getElementById("btnSaveOutPrintBookInfo").style.display ="none";
	    alert(t['TemplateNotUnique']);
    }
    /*for (var i = 0; i < arryTemplate.length; i++) {
        objDic = arryTemplate[i];
        AddListItem("cboTemplate", objDic.TempDesc, objDic.RowID);
        TemplateIDAvailable=objDic.RowID;
    }*/
    //for (var i = 0; i < arryDepartment.length; i++) {
        //objDic = arryDepartment[i];
        //AddListItem("txtAdmDep", objDic.RowID + objDic.Department, objDic.RowID)
    //}
	setElementValue("txtDoctorDr", session['LOGON.USERID']);
	setElementValue("txtDoctor", session['LOGON.USERNAME']);
	InitEvent();
	DisplayPatientInfo(objCurrentPatient);
	AddShowMRDiagnos();
    //取值
    if (objBook != null) {
			setElementValue("cboCurrStatus", objBook.CurrentStateID);
			cboCurrStatusobj=document.getElementById("cboCurrStatus")
			cboCurrStatusobj.disabled=true
			CurrentStateID = objBook.CurrentStateID;
			strInpatientAdm = objBook.EpisodeIDTo;
			objUser = GetDHCWMRUserByID("MethodGetDHCDocIPBUserByID", objBook.CreateDocID);
			setElementValue("txtDoctorDr", objUser.RowID);
			setElementValue("txtDoctor", objUser.UserName);
			objCurrentBook = objBook;
			var ctLocDesc=GetCTLocDescByID(objBook.Text3);
			setElementValue("txtAdmDep", ctLocDesc);
			setElementValue("DepRowId", objBook.Text3);  //set Hide DepRowId value
            setElementValue("AdmCondition",objBook.MRCCondtion)
			txtAdmitDepOnPropertyChange();
			//alert(objBook.Text1)
			setElementValue("cboAdmWard", objBook.Text1);
			txtAdmitWardOnPropertyChange();
			setElementValue("cboBed", objBook.Text2);
            setElementValue("IPBookNo", objBook.IPBookNo);
			var DiagnoseDesc=GetMRDiagnosByID("MethodGetMRDiagnosByID",objBook.Text4);
			setElementValue("MRDiagnos", DiagnoseDesc); 
			setElementValue("MRDiagnosRowID", objBook.Text4);
			//setElementValue("txtMRDiagnos", objBook.Text4);
			setElementValue("dtBookingDate",objBook.BookingDate);
			//cboTemplateListIndexChange();
			var StateStr = GetIPBookStateStr(EpisodeID, RowID);
			setElementValue("txtResumeText", StateStr);
			setElementValue("IPDeposit", objBook.IPDeposit);
      }
       
     if (IPBKFlagVal=="SignBed"){
        	DisableElements();
        	var wardID=GetWardRowIDByLocDR("MethodGetWardRowIDByLocDR",session['LOGON.CTLOCID']);
        	setElementValue("cboAdmWard", wardID);
        	//document.getElementById("cboAdmWard").disabled=true;
        	DisableComponentById("Relation");
        	//DisableComponentById("MRDiagnos");
        	DisableComponentById("txtMRDiagnos");
        	document.getElementById("btnState").style.display="none";
        	var DiagnoseDesc=GetMRDiagnosByID("MethodGetMRDiagnosByID",objBook.Text4);
			setElementValue("MRDiagnos", DiagnoseDesc); 
			//alert(objBook.Text4+"#"+DiagnoseDesc)
			setElementValue("MRDiagnosRowID", objBook.Text4);
			//setElementValue("dtBookingDate",objBook.BookingDate);
        }
          
	if (IPBKFlagVal=="Register"){
			//document.getElementById("cboAdmWard").disabled=true;
			//document.getElementById("cboBed").disabled=true;
			//document.getElementById("cboAdmWard").style.display="none";
			//document.getElementById("cboAdmWard").style.display="none";
			//document.getElementById("cboBed").style.display="none";
			//document.getElementById("ccboBed").style.display="none";
			//document.getElementById("dtBookingDate").style.display="none";
			document.getElementById("cdtBookingDate").style.display="none";
			document.getElementById("btnPrintBookInfo").style.display="none";
			document.getElementById("btnState").style.display="none";
			DisableComponentById("dtBookingDate"); 
			DisableComponentById("txtMRDiagnos");
			DisableComponentById("txtAdmDep");
			var DiagnoseDesc=GetMRDiagnosByID("MethodGetMRDiagnosByID",objBook.Text4);
			setElementValue("MRDiagnos", DiagnoseDesc); 
			setElementValue("MRDiagnosRowID", objBook.Text4);
			// setElementValue("dtBookingDate",objBook.BookingDate);
        }
	if (IPBKFlagVal=="Booking"){
			//setElementValue("cboAdmWard","");
			//setElementValue("cboBed","");
			//document.getElementById("cboAdmWard").disabled=true;
			//document.getElementById("cboBed").disabled=true;
			//document.getElementById("cboAdmWard").style.display="none";
			//document.getElementById("ccboAdmWard").style.display="none";
			//document.getElementById("cboBed").style.display="none";
			//document.getElementById("ccboBed").style.display="none";
			// document.getElementById("dtBookingDate").style.display="none";
			//document.getElementById("cdtBookingDate").style.display="none";
			document.getElementById("btnState").style.display="none";
			// DisableComponentById("dtBookingDate");
			//alert(MRDiagnose)
			if(objBook != null){
				var DiagnoseDesc=GetMRDiagnosByID("MethodGetMRDiagnosByID",objBook.Text4);
				setElementValue("MRDiagnos", DiagnoseDesc); 
				setElementValue("MRDiagnosRowID", objBook.Text4);
				//setElementValue("dtBookingDate",objBook.BookingDate);
			}
			//setElementValue("cboTemplate", TemplateIDAvailable);
			if ((CurrentStatus > 0) && (getElementValue("cboCurrStatus") == "")) {
				setElementValue("cboCurrStatus", CurrentStatus);
				document.getElementById("cboCurrStatus").disabled=true;
			}
		}
	if ((CurrentStatus > 0) && (objBook == null)) {
				setElementValue("cboCurrStatus", CurrentStatus);
				//此刻是否需要控制cboCurrStatus的下拉列表只出现预约和预住院
				//document.getElementById("cboCurrStatus").disabled=true;
			}
	//Get Patient Status to judge whether the patient is Inpatient
	var strMethodGetPatStatusFlag=document.getElementById("MethodGetPatStatusFlag").value;
	var patStatusFlag=cspRunServerMethod(strMethodGetPatStatusFlag,EpisodeID);
    if(patStatusFlag=='1'){
        HideHrefElements();
        alert(t['AlreadyInPatient']);
     }
     DisablePatBaseInfo();
     AddShowMRDiagnos();
     
     /*var objMRDiagnos=document.getElementById("MRDiagnos")
	if(objMRDiagnos){
	     objMRDiagnos.onkeydown=MRDiagnosDown;
     }*/
    //cboTemplateListIndexChange();
	//加入状态改变的监听事件
	var obj=document.getElementById('cboCurrStatus');
	if(obj){obj.onchange=cboCurrStatusChange;}
    
}
 
//加入的对状态改变的监听事件DHCDocIPBCommonFunction.js中的方法
function cboCurrStatusChange() {
	var obj = document.getElementById('cboCurrStatus');
	if(obj.options(obj.selectedIndex).text=="撤销"){
	 alert("请选择撤销理由");
	}
	if(obj.value!=8){
		//document.getElementById("dtBookingDate").style.display="none";
		//document.getElementById("cdtBookingDate").style.display="none";
		//DisableComponentById("dtBookingDate"); //
	} else {
		document.getElementById("dtBookingDate").style.display='';
		document.getElementById("cdtBookingDate").style.display='';
		AbleComponentById("dtBookingDate");
	}
}




function InitEvent() {
    document.getElementById("btnModifyState").onclick = btnModifyState;
    //document.getElementById("btnPrintBookInfo").onclick = btnPrintOnClick;
    //保存按钮事件
    document.getElementById("btnSaveBookInfo").onclick = btnSaveOnClick;
    document.getElementById("btnSaveOutPrintBookInfo").onclick = btnSaveOutPrintOnClick;
    document.getElementById("btnState").onclick = btnStateList;
   // document.getElementById("cboTemplate").onpropertychange = cboTemplateListIndexChange;
    //document.getElementById("txtAdmDep").onpropertychange = txtAdmitDepOnPropertyChange;
    //document.getElementById("cboAdmWard").onpropertychange = txtAdmitWardOnPropertyChange;
	document.getElementById("cboAdmWard").onchange = txtAdmitWardOnPropertyChange;
    //document.getElementById("cboCurrStatus").onpropertychange = cboCurrStatusOnPropertyChange;
    
}
function GetIPBookStateStr(paadm, RowID) {
	var tkClass='web.DHCDocIPBookingCtl';
	var tkMethod='GetBookState';
	var ret = tkMakeServerCall(tkClass, tkMethod, paadm, RowID);
	return ret;
}
function DisablePatBaseInfo(){
	DisableElementsByNameList("txtRegNo^txtName^txtSex^txtAge^txtMrNo^txtWedlock^txtPatientType^txtPersonalID^PoliticalLevel^SecretLevel");
}

////////////////////////////////////////////////////////////////////
function InitDeptList() {
 	var DeptStr=DHCC_GetElementData('DeptStr');
 	combo_DeptList=dhtmlXComboFromStr("txtAdmDep",DeptStr);
 	combo_DeptList.enableFilteringMode(true);
 	combo_DeptList.selectHandle=combo_DeptListKeydownhandler;
 	combo_DeptList.keyenterHandle=combo_DeptListKeyenterhandler;
 	combo_DeptList.attachEvent("onKeyPressed",combo_DeptListKeyenterhandler);
}
function LoclookupSelect(str)
{
	var strArry=str.split("^")
	var DepRowId=strArry[1]
	DHCC_SetElementData('DepRowId',DepRowId);
	if (DepRowId != "") {
		txtAdmitDepOnPropertyChange(DepRowId);
	} 
}
function combo_DeptListKeydownhandler(){
 	var obj=combo_DeptList;
 	var DepRowId=obj.getSelectedValue();
 	var DepDesc=obj.getSelectedText();
 	DHCC_SetElementData('DepRowId',DepRowId);
	if (DepRowId != "") {
		txtAdmitDepOnPropertyChange(DepRowId);
	} else {
		//alert('alert:selectCtLoc')
	}
}

function combo_DeptListKeyenterhandler(e){
	try {
		keycode = websys_getKey(e);
	} catch (e) {
		keycode = websys_getKey();
	}
	if(keycode==13){
		combo_DeptListKeydownhandler();
	}
}
//////////////////////////////////////////////////////////////////////
function MRDiagnosDown() {
	if (event.keyCode == 13) {
		window.event.keyCode=117;
		MRDiagnos_lookuphandler();
	}
}
function AddShowMRDiagnos(){
	var mrid=document.getElementById("MRDiagnosRowID");
	if (mrid){
		if (mrid.value==''){
			var FirstMRTmp=MRDiagnose.split('^');
			if (FirstMRTmp[0]){
				setElementValue("MRDiagnosRowID", FirstMRTmp[0]); 
				setElementValue("MRDiagnos", FirstMRTmp[1]); 
			}
		}
	}
}
document.body.onload = InitForm;
