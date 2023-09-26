//Creare by LiYang 2008-10-22
//Event Handler of DHCMedIPBookNew
var EpisodeID = GetParam(window.parent, "EpisodeID");
//alert("EpisodeID="+EpisodeID);
var objCurrentPatient = null; //CurrentPatient
var objCurrentAdm = null; //Current Patient Admit info
var objInPatientAdm = null;
var arryStateDic = QueryDicItemByTypeFlag("MethodQueryDicItemByTypeFlag", "IPBookingState", "Y");
var arryStateChangeReason = QueryDicItemByTypeFlag("MethodQueryDicItemByTypeFlag", "IPBookingStateChangeReason", "Y");
var arryTemplate = GetDHCMedIPBookingTemplateArry("MethodGetDHCMedIPBookingTemplateArry");

var objCurrentBook = null;
var strInpatientAdm = "";

var txtAdmCat = "1"; //Inpatient Type

var TemplateIDAvailable="";//add this property to record the only template aviliable in configuration 

//if IPBKFlag='SignBed',disable all elements except cboAdmWard,cboBed and txtAdmDep
var IPBKFlagVal=document.getElementById("IPBKFlag").value;
//alert("IPBKFlagVal="+IPBKFlagVal);

var CurrentStatus = GetMedDicIDByCode("MethodGetMedDicIDByCode","IPBookingState", IPBKFlagVal)
//alert("CurrentStatus111="+CurrentStatus);

var MRDiagnose=GetMRDiagnosByEpisodeID("MethodGetMRDiagnosByEpisodeID",EpisodeID);

var HospName=GetHospName("MethodGetHospName");

function DisableElements()
{
	DisableElementsByTagName("input")
	HideHrefElements();
	document.getElementById("dtBookingDate").disabled=false;
	document.getElementById("btnSaveBookInfo").style.display ="inline";
	document.getElementById("cboTemplate").disabled=true;
}
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

    objCurrentPatient = objPatient;
}

function LookupDoctor(str) {
    var arryTmp = str.split(CHR_Up);
    objCurrDoctor = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", arryTmp[0]);
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
        objCurrentBook = new DHCMedIPBooking();
    objCurrentBook.PatientID = objCurrentPatient.RowID;
    objCurrentBook.EpisodeIDFrom = objCurrentAdm.RowID;
    objCurrentBook.EpisodeIDTo = strInpatientAdm;
    objCurrentBook.CreateDate = "";
    objCurrentBook.CreateTime = "";
    objCurrentBook.CreateUserID = session['LOGON.USERID'];
    objCurrentBook.CreateDocID = getElementValue("txtDoctorDr");
    objCurrentBook.CurrentStateID = getElementValue("cboCurrStatus");
    objCurrentBook.IsActive = "Y";
    objCurrentBook.BookingDate = getElementValue("dtBookingDate");
    objCurrentBook.Text1 = getElementValue("cboAdmWard");
    //objCurrentBook.Text2 = getElementValue("cboBed");
    objCurrentBook.Text3 = getElementValue("DepRowId");  
    //objCurrentBook.Text4 = getElementValue("MRDiagnosRowID");
    objCurrentBook.Text4 = getElementValue("txtMRDiagnos"); 
    return objCurrentBook;
}

function SaveDetailToObjectArry() {
    var objArry = new Array();
    var objDetail = null;
    var objTable = window.parent.frames["RPExtra"].document.getElementById("tDHC_Med_IPBook_Extra");
    if (objTable == null)
        return objArry;
    for (var i = 1; i < objTable.rows.length; i++) {
        objDetail = new DHCMedIPBKDetail();
        objDetail.RowID = getElementValue("RowIDz" + i, window.parent.frames["RPExtra"].document);
        objDetail.BookID = objCurrentBook.RowID;
        objDetail.ItemID = getElementValue("ItemDrz" + i, window.parent.frames["RPExtra"].document, null);
        objDetail.ItemValue = getElementValue("txtValuez" + i, window.parent.frames["RPExtra"].document, null);
        objArry.push(objDetail);
    }
    return objArry;
}

function SaveStateInfoToObject() {
    var objState = new DHCMedIPBKState();
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
    str += "PRE";
    return str;
}

function ValidateBookingInfo() {

    if (IPBKFlagVal=="SignBed"&&getElementValue("dtBookingDate") == "") {
        window.alert(t["RequireBookingDate"]);
        return false;
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
	/*if ((getElementValue("MRDiagnos") == "")||(getElementValue("MRDiagnosRowID") == "")) {
		document.getElementById("MRDiagnos").focus();
        window.alert(t["RequireMRDiagnos"]);
        return false;
    }*/
		if (getElementValue("txtMRDiagnos") == ""){
		document.getElementById("txtMRDiagnos").focus();
        window.alert(t["RequireMRDiagnos"]);
        return false;
    }
    var objDoc = window.parent.frames["RPExtra"].document
    var objTable = objDoc.getElementById("tDHC_Med_IPBook_Extra");
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
        if ((IPBKFlagVal=="SignBed")&&(getElementValue("Itemz" + i, objDoc)=="预交金")&&(getElementValue("txtValuez" + i, objDoc)==""))
        {
	        window.alert(getElementValue("Itemz" + i, objDoc)+"is required")
	        objDoc.getElementById("txtValuez" + i).focus();
	        return false;
        }
        
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
    var objDoc = window.parent.frames["RPExtra"].document;
    var objTable = window.parent.frames["RPExtra"].document.getElementById("tDHC_Med_IPBook_Extra");
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


	var objBook = GetDHCMedIPBookingByPaadm("MethodGetDHCMedIPBookingByPaadm", EpisodeID);
	if (objBook != null)
	{
	}
	else
		{
			alert("请先保存再打印!")
			return
		}
//alert(objBook)
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
        }
        else{
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
        }
        else{
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
        //var DiagnoseDesc=GetMRDiagnosByID("MethodGetMRDiagnosByID",getElementValue("MRDiagnosRowID"));
        var DiagnoseDesc=getElementValue("txtMRDiagnos")
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

}

function btnSaveOnClick() {
	//document.getElementById("btnSaveBookInfo").style.display="none";
    if (!ValidateBookingInfo())
        return
    var strAdm = "";
    if (objCurrentBook == null) {
            strAdm = SaveAdmInfoToObject();
    }
    var objBook = SaveBookToObject();
    var retMain = SaveDHCMedIPBooking("MethodSaveDHCMedIPBooking", objBook);
    var arryDetail = SaveDetailToObjectArry();
    var objState = SaveStateInfoToObject();
    var objDetail = null;
    
    if (retMain > 0) {
        for (var i = 0; i < arryDetail.length; i++) {
            objDetail = arryDetail[i];
            SaveDHCMedIPBKDetail("MethodSaveDHCMedIPBKDetail", objDetail);
        }
        SaveDHCMedIPBKState("MethodSaveDHCMedIPBKState", objState);
        SaveBookingPatientBaseInfo(
            "MethodSaveBookingPatientBaseInfo",
            objCurrentPatient.RowID,
            getElementValue("txtCompany"),
            getElementValue("txtAddress"),
            getElementValue("txtTel"),
            getElementValue("txtPersonalID"),
            getElementValue("txtFName"),
            getElementValue("txtFPhone"),
            getElementValue("RelationID")
            );
        objCurrentBook = objBook;
        objCurrentPatient = GetPatientByID("MethodGetPatientByID", objCurrentAdm.PatientID);
        window.alert(t["SaveOK"]);
        self.location.reload();
    }
    else {
        window.alert(t["SaveFail"]);
    }
    if (IPBKFlagVal=="SignBed"){
	    self.parent.close();
    	//window.parent.close();
    	//opener.parent.location["RPList"].reload();
    	//opener.parent.frames["RPList"].location.reload();
    	//opener.location.reload();
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
    SaveDHCMedIPBKState("MethodSaveDHCMedIPBKState", objState);
    window.alert(t["SaveStateOK"]);   
}

function btnStateList() {
    if (objCurrentBook == null) {
        window.alert(t["NotSave"]);
        return;
    }
    var strURL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.Med.IPBook.StateList&BookID=" + objCurrentBook.RowID;
    window.open(strURL, "_blank", "height=300,width=700,status=yes,toolbar=no,menubar=no,location=no,top=50,left=100");
}

function cboTemplateListIndexChange() {
    var BookID = "";
    var TemplateID = getElementValue("cboTemplate");
    if (objCurrentBook != null)
        BookID = objCurrentBook.RowID;
    var strURL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.Med.IPBook.Extra&BookID=" + BookID + "&TemplateID=" + TemplateID+ "&IPBKFlag=" + IPBKFlagVal;
    window.parent.frames["RPExtra"].location.href = strURL;
}


function txtAdmitDepOnPropertyChange(DepRowId) {
	var DepRowId=document.getElementById("DepRowId").value;
	arry = GetLocByDep("MethodGetLocByDep", DepRowId);

    var objLoc = null;
    ClearListBox("cboAdmWard");
    AddListItem("cboAdmWard", "", "");
    for (var i = 0; i < arry.length; i++) {
        objLoc = arry[i];
        AddListItem("cboAdmWard", objLoc.Department, objLoc.RowID);
    }
    txtAdmitWardOnPropertyChange();
}

function txtAdmitWardOnPropertyChange()
{
	/*var arry = QueryBedByDep("MethodQueryBedByDep", getElementValue("cboAdmWard"));
    var objBed = null;
    ClearListBox("cboBed");
    AddListItem("cboBed", "", "");
    for (var i = 0; i < arry.length; i++) {
        objBed = arry[i];
        AddListItem("cboBed", objBed.Desc, objBed.RowID);
	}*/
}

function InitForm() 
{
 	var objTable = document.getElementsByTagName("table")[1];
 	var strPrinter = "<OBJECT ID='clsPrinter' CLASSID='clsPrinter' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,45'>aaasssssssss</OBJECT>"
    objTable.rows[0].cells[0].appendChild(document.createElement(GetVBPrinterObjectString("MethodPrinter")));

    var objBook = null;
    var PatientID = "";

    objCurrentAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", EpisodeID)
    if (objCurrentAdm == null) {
        window.alert("Paadm Error!!!!!");
        return;
    }
    objCurrentPatient = GetPatientByID("MethodGetPatientByID", objCurrentAdm.PatientID);
    //alert("PatientID="+objCurrentAdm.PatientID);
    var Relation=GetRelationByPersonID("MethodGetRelationByPersonID",objCurrentAdm.PatientID);
    if(Relation){
    	var RelationArray=Relation.split("^");
    	setElementValue("Relation", RelationArray[1]);
    	setElementValue("RelationID",RelationArray[0]);
		}
	var FPhone=GetFPhoneByPersonID("MethodGetFPhoneByPersonID", objCurrentAdm.PatientID);
    setElementValue("txtFPhone",FPhone);
    
    var objDic = null;
    var objUser = null;
    MakeComboBox("cboCurrStatus");
    MakeComboBox("cboOpeReason");
    MakeComboBox("cboTemplate");
    //MakeComboBox("txtAdmDep");
    MakeComboBox("cboAdmWard");  
    //MakeComboBox("cboBed");
  
    InitDeptList();
    
    for (var i = 0; i < arryStateDic.length; i++) {
        objDic = arryStateDic[i];
        AddListItem("cboCurrStatus", objDic.Desc, objDic.RowID)
    }
    for (var i = 0; i < arryStateChangeReason.length; i++) {
        objDic = arryStateChangeReason[i];
        AddListItem("cboOpeReason", objDic.Desc, objDic.RowID)
    }
    
    var TemplateLength=arryTemplate.length;
    if(TemplateLength>1) {
	    document.getElementById("btnSaveBookInfo").style.display ="none";
    	alert(t['TemplateNotUnique']);
    }
    for (var i = 0; i < arryTemplate.length; i++) {
        objDic = arryTemplate[i];
        AddListItem("cboTemplate", objDic.TempDesc, objDic.RowID);
        TemplateIDAvailable=objDic.RowID;
    }
//    for (var i = 0; i < arryDepartment.length; i++) {
//        objDic = arryDepartment[i];
//        AddListItem("txtAdmDep", objDic.RowID + objDic.Department, objDic.RowID)
//    }

    setElementValue("txtDoctorDr", session['LOGON.USERID']);
    setElementValue("txtDoctor", session['LOGON.USERNAME']);
    InitEvent();
    DisplayPatientInfo(objCurrentPatient);
    var objBook = GetDHCMedIPBookingByPaadm("MethodGetDHCMedIPBookingByPaadm", EpisodeID);

    if (objBook != null) {
        setElementValue("cboCurrStatus", objBook.CurrentStateID);
        objUser = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", objBook.CreateDocID);
        setElementValue("txtDoctorDr", objUser.RowID);
        setElementValue("txtDoctor", objUser.UserName);
        objCurrentBook = objBook;
        var ctLocDesc=GetCTLocDescByID(objBook.Text3);

        setElementValue("txtAdmDep", ctLocDesc);
        setElementValue("DepRowId", objBook.Text3);  //set Hide DepRowId value
        
        txtAdmitDepOnPropertyChange();
        setElementValue("cboAdmWard", objBook.Text1);
        txtAdmitWardOnPropertyChange();
        //setElementValue("cboBed", objBook.Text2);
          
        /*var DiagnoseDesc=GetMRDiagnosByID("MethodGetMRDiagnosByID",objBook.Text4);
        setElementValue("MRDiagnos", DiagnoseDesc); 
        setElementValue("MRDiagnosRowID", objBook.Text4);*/
        setElementValue("txtMRDiagnos", objBook.Text4);
        cboTemplateListIndexChange();
        
        if (IPBKFlagVal=="SignBed"){
        	DisableElements();
        	var wardID=GetWardRowIDByLocDR("MethodGetWardRowIDByLocDR",session['LOGON.CTLOCID']);
        	setElementValue("cboAdmWard", wardID);
        	document.getElementById("cboAdmWard").disabled=true;
        	DisableComponentById("Relation");
        	//DisableComponentById("MRDiagnos");
        	DisableComponentById("txtMRDiagnos");
        	document.getElementById("btnState").style.display="none";
        }
        if (IPBKFlagVal=="Register"){
	        document.getElementById("cboAdmWard").disabled=true;
	        //document.getElementById("cboBed").disabled=true;
	        document.getElementById("cboAdmWard").style.display="none";
	        document.getElementById("ccboAdmWard").style.display="none";
	        //document.getElementById("cboBed").style.display="none";
	        //document.getElementById("ccboBed").style.display="none";
	        document.getElementById("dtBookingDate").style.display="none";
	        document.getElementById("cdtBookingDate").style.display="none";
	        document.getElementById("btnPrintBookInfo").style.display="none";
	        document.getElementById("btnState").style.display="none";
	        DisableComponentById("dtBookingDate"); 
	        DisableComponentById("txtMRDiagnos");
	        DisableComponentById("txtAdmDep");
        }
     } 
     if (IPBKFlagVal=="Booking"){
        setElementValue("cboAdmWard","");
        //setElementValue("cboBed","");
        document.getElementById("cboAdmWard").disabled=true;
        //document.getElementById("cboBed").disabled=true;
        document.getElementById("cboAdmWard").style.display="none";
        document.getElementById("ccboAdmWard").style.display="none";
        //document.getElementById("cboBed").style.display="none";
        //document.getElementById("ccboBed").style.display="none";
        document.getElementById("dtBookingDate").style.display="none";
        document.getElementById("cdtBookingDate").style.display="none";
        document.getElementById("btnState").style.display="none";
        DisableComponentById("dtBookingDate");
        /*if(MRDiagnose){
        	var MRDiagnoseArray=MRDiagnose.split("^");
        	setElementValue("MRDiagnos",MRDiagnoseArray[1]);
        	setElementValue("MRDiagnosRowID",MRDiagnoseArray[0]);
        }*/
     }
     setElementValue("cboTemplate", TemplateIDAvailable);
     if(CurrentStatus>0){
        setElementValue("cboCurrStatus", CurrentStatus);
        document.getElementById("cboCurrStatus").disabled=true;
     }
     //Get Patient Status to judge whether the patient is Inpatient
     var strMethodGetPatStatusFlag=document.getElementById("MethodGetPatStatusFlag").value;
     var patStatusFlag=cspRunServerMethod(strMethodGetPatStatusFlag,EpisodeID);
     if(patStatusFlag=='1'){
        HideHrefElements();
        alert(t['AlreadyInPatient']);
     }
     
     DisablePatBaseInfo()
     /*var objMRDiagnos=document.getElementById("MRDiagnos")
     if(objMRDiagnos)
     {
	     objMRDiagnos.onkeydown=MRDiagnosDown;
     }*/
     cboTemplateListIndexChange();
}

function InitEvent() {
    document.getElementById("btnModifyState").onclick = btnModifyState;
    document.getElementById("btnPrintBookInfo").onclick = btnPrintOnClick;
    document.getElementById("btnSaveBookInfo").onclick = btnSaveOnClick;
    document.getElementById("btnState").onclick = btnStateList;
    document.getElementById("cboTemplate").onpropertychange = cboTemplateListIndexChange;
    //document.getElementById("txtAdmDep").onpropertychange = txtAdmitDepOnPropertyChange;
    document.getElementById("cboAdmWard").onpropertychange = txtAdmitWardOnPropertyChange;
    //document.getElementById("cboCurrStatus").onpropertychange = cboCurrStatusOnPropertyChange;
    
}
function DisablePatBaseInfo(){
	DisableElementsByNameList("txtRegNo^txtName^txtSex^txtAge^txtMrNo^txtWedlock^txtPatientType^txtPersonalID");
}

////////////////////////////////////////////////////////////////////
function InitDeptList()
{
 	var DeptStr=DHCC_GetElementData('DeptStr');
 	combo_DeptList=dhtmlXComboFromStr("txtAdmDep",DeptStr);
 	combo_DeptList.enableFilteringMode(true);
 	combo_DeptList.selectHandle=combo_DeptListKeydownhandler;
 	combo_DeptList.keyenterHandle=combo_DeptListKeyenterhandler;
 	combo_DeptList.attachEvent("onKeyPressed",combo_DeptListKeyenterhandler);
}

function combo_DeptListKeydownhandler(){
 	var obj=combo_DeptList;
 	var DepRowId=obj.getActualValue();
 	var DepDesc=obj.getSelectedText();
 	DHCC_SetElementData('DepRowId',DepRowId);
 	if(DepRowId!="")
	{
	 txtAdmitDepOnPropertyChange(DepRowId);
	}
 	else
	{
 	//alert('alert:selectCtLoc')
	}
}

function combo_DeptListKeyenterhandler(e){
	try{keycode=websys_getKey(e);}catch(e){keycode=websys_getKey();}
	if(keycode==13){
		combo_DeptListKeydownhandler();
	}
}
//////////////////////////////////////////////////////////////////////
function MRDiagnosDown()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=117;
		MRDiagnos_lookuphandler();
	}
}
window.onload = InitForm;