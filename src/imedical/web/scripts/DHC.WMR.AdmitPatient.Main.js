/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.AdmitPatient.Main

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-21

COMMENT: Event handler of DHC.WMR.AdmitPatient.Main

========================================================================= */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_10=String.fromCharCode(10);
var CHR_13=String.fromCharCode(13);

var objCurrentPatient = null;//current Patient
var objMrInitStatus = null; //store the first workflow object of the whole workflow
var objCurrentAdm = null;//store the current patient admiting information
var objCurrentVolume = null;//current mr volume
var strAdmTypeFlag = GetParam(window, "AdmTypeFlag");

var objFoundMain = null;//mr main info (DHCWMRMain)
var strCurrentMrType = GetParam(window, "MrType");
var objDicInPatientMr = GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "MrType", "1");
var objDicOutPatientMr = GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "MrType", "2");
var objDicOutPatientAdmit = GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "RequestType", "01");
var strWorkItemID = GetParam(window, "WorkItem");//target work item(mr main) 
var strRequestType = GetParam(window, "RequestType");//invoke request type
var strAutoTransfer = GetParam(window, "AutoTransfer");//auto transfer to specified workitem
var strAutoRequest = GetParam(window, "AutoRequest");//auto invoke a request
var HospitalCode = document.getElementById("HospitalCode").value; //add by liuxuefeng 2009-07-03


var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","AdmitPatientMain");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]+"||"+tmpChinese[3]+"||"+tmpChinese[4])
//alert(tmpChinese[5]+"||"+tmpChinese[6]+"||"+tmpChinese[7]+"||"+tmpChinese[8]+"||"+tmpChinese[9])
//alert(tmpChinese[10]+"||"+tmpChinese[11]+"||"+tmpChinese[12]+"||"+tmpChinese[13]);


//Validate Conetents
function ValidateContents()
{
	if(objCurrentPatient == null)
	{
		window.alert(t["InputRegNo"]);//not input Registration No yet
		return false;
	}
	
	if(objCurrentAdm == null)
	{
		window.alert(t["ChooseAdmInfo"]);//not select a patient admiting info
		return false;
	}
	var objVol = null;//check whether has been receipted
	var objMain = null;//check whether DHCWMRMain info has been deleted
	objVol = GetVolumeByAdm("MethodGetVolByAdm", objCurrentAdm.RowID);
	//objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", objVol.Main_Dr);
	//if(objMain != null)
	//{
	//	if(!objMain.IsActive)
	//	{
	//		return false;
	//	}
	//}
	if(objVol != null)
	{
		if(objVol.IsActive)
		{
			window.alert(t["AlreadyReceipted"]);//already receipted
			return false;
		}
	}
	if(getElementValue("txtNo") != "")
	{ 
	    if(!CheckPatient())
	        return false;
	    
	    //add by zf 2008-04-24
	    //If Auto Change MR?
	    var MRChange=getElementValue("MRChange",null);
	    if (MRChange=="Y"){
	    	var ret=0;
	    	var xMrType=GetParam(window, "MrType");
	    	var xMrNo=getElementValue("txtNo");
	    	var xPapmi=objCurrentPatient.RowID;
	    	var xNameSpell=GetPinYin(objCurrentPatient.PatientName);
	    	var obj=document.getElementById('MethodChangeMRToPatient');
		    if (obj) {var encmeth=obj.value} else {var encmeth=''}
		    ret=cspRunServerMethod(encmeth,xMrType,xMrNo,xPapmi,xNameSpell);
	    	if (ret<0){
		    	alert(t["MRAutoChange"]+ret);
		    }
	    }
	}
	
	/*if(window.event.srcElement.id == "cmdUseThisNumber")//
	{
		if((Trim(getElementValue("txtMRInfo")) == "") && (Trim(getElementValue("txtNo")) == ""))
		{
			window.alert(t["ChooseMrInfo"]);
			return false;
		}
		else
		{
			if(!CheckPatient())
				return;			
		}
	}*/ 
    
	return true;
}

//Display Mr Information
//Parameter:objMain Mr main info (DHCWMRMain)
function DisplayMrInfo(objMain)
{
	var objHis = null;
	if(objMain == null)
		return;
	objHis = GetPatientInfoByMrRowID("MethodGetHistory", objMain.RowID);
	setElementValue("txtMRInfo", objMain.RowID);	
	if(objHis != null)
	{
		//setElementValue("txtMrDisplay", objMain.MRNO  + "  " + objHis.PatientName);

		//setElementValue("txtNo", objMain.MRNO);
		setElementValue("txtMMrNo", objMain.MRNO);
		setElementValue("txtMName", objHis.PatientName);
		setElementValue("txtMSex", objHis.Sex);
		setElementValue("txtMCompany", objHis.Company);
		setElementValue("txtMBirthday", objHis.Birthday + "(" + objHis.Age + ")");
		setElementValue("txtMAddress", objHis.HomeAddress);
		setElementValue("txtMRelative", objHis.RelativeName);//add by liuxuefeng 2009-05-22 for FX to add Relative Name
		objMain.His = objHis;
	}
	else
	{
		//setElementValue("txtMrDisplay", "");
		//setElementValue("txtNo", "");
	
		setElementValue("txtMMrNo", "");
		setElementValue("txtMName", "");
		setElementValue("txtMSex", "");
		setElementValue("txtMCompany", "");
		setElementValue("txtMBirthday", "");
		setElementValue("txtMAddress", "");
		setElementValue("txtMRelative", "");//add by liuxuefeng 2009-05-22 for FX to add Relative Name
			
	}
}

//Print Patient Information Card
function PrintCard()
{
	var objPrinter = document.getElementById("clsPrinter");
	var objMain = GetDHCWMRMainByID("MethodGetMrBaseInfo", objCurrentVolume.Main_Dr);
	if(objPrinter == null)
	    objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter"); 
	
	objPrinter.Font = tmpChinese[0];
	objPrinter.FontBold = true;
	objPrinter.FontSize = 15;
	objPrinter.PrintContents(3.5, 0.5, tmpChinese[2]);
	
	
	objPrinter.Font = tmpChinese[0];
	objPrinter.FontBold = true;
	objPrinter.FontSize = 11;
	objPrinter.PrintContents(0.5, 1.5, tmpChinese[3]);
	objPrinter.PrintContents(4.5, 1.5, tmpChinese[4]);
	objPrinter.PrintContents(6.5, 1.5, tmpChinese[5]);
	objPrinter.PrintContents(0.5, 2.3, tmpChinese[6]);
	objPrinter.PrintContents(4.5, 2.3, tmpChinese[7]);
	objPrinter.PrintContents(0.5, 3.1, tmpChinese[8]);
	objPrinter.PrintContents(5, 3.1, tmpChinese[9]);
	objPrinter.PrintContents(0.5, 3.9, tmpChinese[10]);
	
	objPrinter.Font = tmpChinese[1];
	objPrinter.FontBold = false;
	objPrinter.FontSize = 11;
	objPrinter.PrintContents(1.7, 1.5, objCurrentPatient.PatientName);
	objPrinter.PrintContents(5.7, 1.5, objCurrentPatient.Sex);
	objPrinter.PrintContents(7.7, 1.5, objCurrentPatient.Age);
	objPrinter.PrintContents(2.1, 2.3, objMain.MRNO);
	objPrinter.PrintContents(5.7, 2.3, GetDesc(objCurrentAdm.LocDesc, "/"));
	objPrinter.PrintContents(2.5, 3.1, objCurrentAdm.AdmDate);
	objPrinter.PrintContents(7, 3.1, objCurrentPatient.Payment);
	
	objPrinter.Line(1.7, 1.9, 4.3, 1.9);
	objPrinter.Line(5.7, 1.9, 6.4, 1.9);
	objPrinter.Line(7.7, 1.9, 8.9, 1.9);
	
	objPrinter.Line(2.1, 2.7, 4.4, 2.7);
	objPrinter.Line(5.7, 2.7, 8.9, 2.7);
	
	objPrinter.Line(2.5, 3.5, 4.9, 3.5);
	objPrinter.Line(7, 3.5, 8.9, 3.5);
	
	objPrinter.Line(2.5, 4.3, 8.9, 4.3);
	objPrinter.EndDoc();
}

//Save Receipt info
//flag - 1 assign new Mr No,  2- Assign Old Mrno(Assign DHCWMRMain RowID)  3-Assign custom Medical Record Number
function SaveInfo(flag)
{
	var ret = "";
	switch(flag)
	{
		case 1:
			ret = Receipt("MethodReceipt", 
				getElementValue("AssignMrType"), 
				objCurrentPatient.RowID, 
				objCurrentAdm.RowID, 
				"",
				session["LOGON.CTLOCID"],
				GetPinYin(objCurrentPatient.PatientName),
				getElementValue("cboInState"),
				"",
				session['LOGON.USERID']);
			
			break;
		case 2:
			ret = Receipt("MethodReceipt", 
				getElementValue("AssignMrType"), 
				objCurrentPatient.RowID, 
				objCurrentAdm.RowID, 
				getElementValue("txtMRInfo"),
				session["LOGON.CTLOCID"],
				GetPinYin(objCurrentPatient.PatientName),
				getElementValue("cboInState"),
				"",
				session['LOGON.USERID']);
			
			break;
		case 3:
			ret = Receipt("MethodReceipt", 
				getElementValue("AssignMrType"), 
				objCurrentPatient.RowID, 
				objCurrentAdm.RowID, 
				"",
				session["LOGON.CTLOCID"],
				GetPinYin(objCurrentPatient.PatientName),
				getElementValue("cboInState"),
				Trim(getElementValue("txtNo")),
				session['LOGON.USERID']);
			
			break;
		default:
			window.alert(flag);
	}
	
	if(ret > -1)
	{
		InvokeRequest(ret);
		objCurrentVolume = GetDHCWMRMainVolumeByID("MethodGetVolume", 
			GetCode(ret, "||"), GetDesc(ret, "||"));
		SetControlVisitable("cmdUnReceipt", true);
	}
	else
	{
		objCurrentVolume = null;
		window.alert(t["AdmitFalse"]+"ErrorCode:" + ret);
	}
	DisplayPatientBaseInfo(objCurrentPatient.RowID, objCurrentAdm.RowID);
	return (ret > -1);
}

//Display Patient Base Info 
//PatientID:Patient infomation RowID
//Padm:Patient Admit Information RowID
function DisplayPatientBaseInfo(PatientID, Padm)
{
	var objPatient = GetPatientByID("MethodGetPatient", PatientID);
	var objAdm = GetPatientAdmitInfo("MethodGetAdm", Padm)
	var objVolume = null;
	var mrType = getElementValue("AssignMrType");

	var objMrPatientInfo = null;
	var dicMrNo = GetMrNoByRegNo("MethodGetMrNoByRegNo", objPatient.PatientNo);
	
	var objMrMain = null;//GetDHCWMRMainByPapmi("MethodGetMainByPapmi",  getElementValue("AssignMrType"), PatientID);
	if(dicMrNo.Exists(mrType))
		objMrMain = dicMrNo.Item(mrType);
	if(objPatient != null)
	{
		//Modify by wuqk 2008-04-09  no used
		//var objDicMr = GetMrNoList("MethodGetMrNoList", objPatient.PatientNo)
		objCurrentPatient = objPatient;
		setElementValue("txtRegNo", objPatient.PatientNo);	
		//setElementValue("txtPMRNo", objPatient.MedRecNo);
		setElementValue("txtPMRNo", (dicMrNo.Exists(strCurrentMrType) ? dicMrNo.Item(strCurrentMrType).MRNO : ""));
		//setElementValue("txtNo", objPatient.MedRecNo);
		setElementValue("txtNo", (dicMrNo.Exists(strCurrentMrType) ? dicMrNo.Item(strCurrentMrType).MRNO : ""));
		setElementValue("txtPName", objPatient.PatientName);
		setElementValue("txtPSex", objPatient.Sex);
		setElementValue("txtPBirthday", objPatient.Birthday + "   (" + objPatient.Age + ")");
		setElementValue("txtPPersonalID", objPatient.Identity);
		setElementValue("txtPCompany", objPatient.Company);
		setElementValue("txtPAddress", objPatient.NowAddress);
		setElementValue("txtPRelative", objPatient.RelationName);	//add by liuxuefeng 2009-05-22 for FX to add Relative Name
		if(objMrMain != null)
		{
			DisplayMrInfo(objMrMain);
		}
		txtNoOnChange();
		if(objAdm != null)
		{
			setElementValue("lblAdm", objAdm.AdmDate + "   " + GetDesc(objAdm.LocDesc, "/"));
			objCurrentAdm = objAdm;
			
			objCurrentVolume = GetVolumeByAdm("MethodGetVolByAdm", objAdm.RowID);
			if (objCurrentVolume!=null){
				if(objCurrentVolume.IsActive)
				{
					SetControlVisitable("cmdUnReceipt", true);
				}
				else
				{
					SetControlVisitable("cmdUnReceipt", false);
				}
				/*
				if(objCurrentAdm.AdmNo.indexOf(strAdmTypeFlag)== -1)
				{
					SetControlVisitable("cmdAdmit", false);
					window.alert(t['OPADMINFO']);					
				}
				*/
			}else{
				SetControlVisitable("cmdUnReceipt", false);
			}
			
		}
	}
	else
	{
		window.alert(t["NoAdmInfo"]);
	}
	
	/// by wuqk 2008-03-27
	/*
	if(objCurrentAdm.AdmNo.indexOf(strAdmTypeFlag)== -1)
	{
			SetControlVisitable("cmdAdmit", false);
			SetControlVisitable("cmdUnReceipt", false);
			window.alert(t['OPADMINFO']);					
	}
	*/
	
	/// by zf 2008-04-07
	if(strAdmTypeFlag.indexOf(objCurrentAdm.AdmType)== -1)
	{
			SetControlVisitable("cmdAdmit", false);
			SetControlVisitable("cmdUnReceipt", false);
	}
}

function CheckPatient()
{
	var objMain = null;
	var objHis = null;
	if(Trim(getElementValue("txtNo")) == "")
		return;
	objMain = GetDHCWMRMainByMrNo("MethodGetMrMainByNo", getElementValue("AssignMrType"), getElementValue("txtNo"), "Y");
	if(objMain == null)
	{
		if(window.confirm(t["ConfirmUseInputNumber"]) != true)
		{
			setElementValue("txtNo", "");
			return false;
		}
		else
		{
			return true;
		}
		
	}
	else
	{
		objHis = GetPatientInfoByMrRowID("MethodGetHistory", objMain.RowID);//get mr base information, DHCMWRHistory Format
		if(objHis != null){
			if(objCurrentPatient != null)
			{
				if((objHis.PatientName != objCurrentPatient.PatientName) && (GetPinYin(objHis.PatientName) != GetPinYin(objCurrentPatient.PatientName) ))
				{
					//if(window.confirm(t["NotSame"].replace("**", objHis.PatientName)) != true)
					//{
					//	setElementValue("txtNo", "");
					//	return fase;
					//}
					window.alert(t["NotSame"].replace("**", objHis.PatientName));
					return false;
				}
			}
			DisplayMrInfo(objMain);
			return true;
		}else{
			//window.alert(t["NoMrPatientInfoFound"]);
			//return false;
			return true;//has DHCWMRMain information,but has not History Info, this is caused by not inputed history information
		}
	}
}

function DrawTableBorder()
{
    var objArry = document.getElementsByTagName("Table");
    objArry[3].border = "1";
}

function InvokeRequest(VolumeID)
{
	var strRequestIns = "";
	var strRequestID = "";
	var objMainStatus = DHCWMRMainStatus();
	var objVol = GetDHCWMRMainVolumeByID("MethodGetDHCWMRMainVolumeByID", VolumeID);
	if ((strAutoRequest == "Y") && (strRequestType != ""))
	{
		var objRequest = DHCWMRRequest();
		objRequest.MrType_Dr = strCurrentMrType;
		objRequest.MrMain_Dr = objVol.Main_Dr;
		objRequest.RequestType = strRequestType;
		objRequest.WorkItem_Dr = strWorkItemID;
		objRequest.AimDate = getElementValue("txtAimDate");
		objRequest.AimCtLoc_Dr = GetCode(objCurrentAdm.LocDesc, "/");
		objRequest.AimUser_Dr = "";
		objRequest.RequestUser_Dr=session['LOGON.USERID'];
		objRequest.IsActive="Y";
		objRequest.Paadm_Dr = objCurrentAdm.RowID;
		var strRequestIns = SerializeDHCWMRRequest(objRequest);
		strRequestID = NewRequest("MethodNewRequest",strRequestIns);
		if(strRequestID < 0)
		{
			window.alert(t["RequestErr"] + strRequestID);
			return;
		}
	}
	if(strAutoTransfer == "Y" && (strWorkItemID != "") && (strRequestID > 0))
	{
		objMainStatus.Parref = objVol.Main_Dr;
		objMainStatus.Status_Dr = strWorkItemID;
		objMainStatus.UserFromDr = session['LOGON.USERID'];
		 var ret =SaveWorkDetail("MethodSaveWorkDetail", 
			"0", //----------------------0  ->Medical Record
			strWorkItemID,
			objVol.Main_Dr,
			"",
			SerializeDHCWMRMainStatus(objMainStatus),
			"",
			strRequestID);
		if(!ret)
		{
			window.alert(t["TransferErr"] + ret);
			return;
		}
	}		
}


function cmdAssignNewNoOnClick()
{
	if(!ValidateContents())
		return;
	if(SaveInfo(1))
	{
		window.alert(t["SaveSuccess"]);//Save successful
		window.location.reload();
	}
	else
	{
		window.alert(t["SaveFailed"]);//save faild
	}
}

function cmdUseThisNumberOnClick()
{
	if(!ValidateContents())
		return;
	var ret = false;
	if(getElementValue("txtMRInfo") != "")
	{
		ret = SaveInfo(2);
	}
	else
	{
		ret = SaveInfo(3)
	}
	if(ret)
	{
		window.alert(t["SaveSuccess"]);//save successful
		window.location.reload();
	}
	else
	{
		window.alert(t["SaveFailed"]);//save failed
	}
}

function cmdAdmitOnClick()
{
    var strMrNo = getElementValue("txtNo");
	 ///add by liuxuefeng 2009-07-03 for FX to  Verify HIS MrNo and Input MrNo////////
	 if(HospitalCode == "BeiJing_FX")
	 {
	 		var HISMrNo=getElementValue("HISMrNo");
	 		if (strMrNo != HISMrNo) 
	 			{
	 				alert("您分配的病案号与住院处录入的病案号不符,请确认病案号或与住院处联系!");
	 				return;
	 			}
	 }
	 /////////////////////////End/////////////////////////////////
	 ///cjb 2009-09-11
	 if(HospitalCode == "BeiJing_AZ")
	 {
	 		if (strMrNo != objCurrentPatient.PatientNo) 
	 			{
	 				alert("您分配的病案号与登记号不相符,请确认病案号!");
	 				return;
	 			}
	 }
	 
   var  strOldMrMainID = getElementValue("txtMRInfo");
   if((strMrNo == "") && (strOldMrMainID == "")) 
   {
        if(window.confirm(t["ConfirmNewNumber"]))//Assgin new Mr No
            cmdAssignNewNoOnClick();   
   }
   else 
  {
        cmdUseThisNumberOnClick();//use old mr no
  } 
}

function cmdPrintCardOnClick()
{
	if(objCurrentPatient == null)
	{
		window.alert(t["InputRegNo"]);
		return;
	}
	if(objCurrentVolume == null)//check whether has volume
	{
		window.alert(t["ReceiptFirst"]);
		return;
	}
	else
	{
		if(!objCurrentVolume.IsActive) //check whether current volume has been deleted
		{
			window.alert(t["ReceiptFirst"]);
			return;
		}
		
	}
	
	
	try
	{
		PrintCard();
	}catch(err)
	{
		window.alert(err.description);
	}
}

function cmdAdvancedQueryOnClick()
{
	//window.open("dhc.wmr.history.query.csp?MrType=" + getElementValue("AssignMrType") , "_blank",
	//	"height=600,width=850,status=yes,toolbar=no,menubar=no,location=no,top=50,left=100");
	
	window.open("dhc.wmr.history.query.csp?MrType=" + getElementValue("AssignMrType") + "&PatientName=" + StringEncode(objCurrentPatient.PatientName), "_blank",
		"height=600,width=850,status=yes,toolbar=no,menubar=no,location=no,top=50,left=100");
}

function cmdUnReceiptOnClick()
{
	var objVol = null;
	objVol = GetVolumeByAdm("MethodGetVolByAdm", objCurrentAdm.RowID);
	if(objVol == null)
	{
		window.alert(t["NotReceipted"]);//not assign mr no
		return;
	}
	else
	{
		if(!objVol.IsActive)
			return;
	}	
	if(!window.confirm(t["ConfirmUnReceipt"])) //confirm unreceiption
		return;
	//update by zf 2008-09-02 +LocId,UserId
	if(UnReceipt("MethodUnReceipt", objVol.RowID,session["LOGON.CTLOCID"],session['LOGON.USERID']))
	{
		SetControlVisitable("cmdUnReceipt", false);
		objCurrentVolume.IsActive = false;
		window.alert(t["UnReceiptSuccess"]);
		window.location.reload();
	}
	else
	{
		window.alert(t["UnReceiptFail"]);
	}
}


function txtNoOnChange()
{
    var strMrNo = getElementValue("txtNo"); 
    //update by zf 20090508
    /*
    if(strMrNo == "")
        return;
      objFoundMain = GetDHCWMRMainByMrNo("MethodGetMrMainByNo", getElementValue("AssignMrType"), strMrNo, "Y");
     if(objFoundMain != null)
        DisplayMrInfo(objFoundMain);
    */
    if(strMrNo == ""){
        return;
    }else{
    		/////////////add by liuxuefeng 2009-08-19///////////
				FormatInputMrNo("AssignMrType","txtNo");
				strMrNo = getElementValue("txtNo"); 
				///////////////////// End ////////////////////////
    		objFoundMain = GetDHCWMRMainByMrNo("MethodGetMrMainByNo", getElementValue("AssignMrType"), strMrNo, "Y");
    		if (objFoundMain!==null){
    			DisplayMrInfo(objFoundMain);
    		}else{
    			setElementValue("txtMRInfo", "");  //MainRowid
			    setElementValue("txtMMrNo", "");
					setElementValue("txtMName", "");
					setElementValue("txtMSex", "");
					setElementValue("txtMCompany", "");
					setElementValue("txtMBirthday", "");
					setElementValue("txtMAddress", "");
					setElementValue("txtMRelative", "");//add by liuxuefeng 2009-05-22 for FX to add Relative Name
    		}
    }
}



function cmdNewRequestOnClick()
{

	
	var objWorkItem = GetDHCWMRWorkItemByID("MethodGetDHCWMRWorkItemByID", "10");
	WMR_NewRequest(
		GetParam(window, "PatientID"),
		GetParam(window, "EpisodeID"),
		objDicOutPatientMr.RowID,
		objDicInPatientMr.RowID,
		"14",
		objDicOutPatientAdmit.RowID);
}

function btnPrintBarcodeOnClick()
{
	var objPrinter = new ActiveXObject("DHCMedWebPackage.clsWMRBarCode"); 
	var objMrType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", strCurrentMrType);
	if(objPrinter == null)
	{
		window.alert("fail to init Printer Control!");
		return;	
	}
	//objPrinter.BarCodeFontName = BarCodeFontName;//font name stored in DataAccess.js
	if(objFoundMain == null)
	{
		window.alert(t["ReceiptFirst1"]);//not find mr
		return;
	}
	var objMain = objFoundMain;
	if(objMain == null)
	{
		window.alert(t["ReceiptFirst1"]);//not find mr
		return;
	}
	var objBaseInfo = GetPatientInfoByMrRowID("MethodGetInfoByMainID", objMain.RowID);
	if(objBaseInfo == null)
	{
	    objBaseInfo = DHCWMRHistory();
		//window.alert(t["MrNotFound"]);//
		//return;
	}
	//objPrinter.PrintBarCode("01", objMain.RowID, objMrType.Description, objMain.MRNO, objBaseInfo.PatientName);
	/*Modify by wuqk 2008-04-28 for PrintBarcode*/
	var objHosptial = GetcurrHospital("MethodGetDefaultHosp");
	var BarCode = "01" + formatString(objMain.RowID,11);
	var ElseString = objMrType.Description + CHR_1 + objMain.MRNO + CHR_1 + objBaseInfo.PatientName + CHR_1 + 360 + CHR_1 + objBaseInfo.Sex + CHR_1 + objBaseInfo.Age + CHR_1 + objBaseInfo.Birthday;
	objPrinter.PrintWMRBarCode(objHosptial.MyHospitalCode, objHosptial.BarcodePrinter, BarCode, ElseString);
	/*end*/
	
}


function InitForm()
{
	var obj = null;
	var objInState=null;  					//add by liuxuefeng 2009-02-11
	
	var objDic = GetDHCWMRDictionaryByID("MethodGetDicItem", getElementValue("AssignMrType"));
	
	var strPatientID = GetParam(window, "PatientID");
	var strAdm = GetParam(window, "EpisodeID");
	try{
	var strNoCount = GetMrNoCountAndCurrNo("MethodGetMrNoCountAndCurrNo", getElementValue("AssignMrType"), session['LOGON.CTLOCID']);
	}catch(e){
		alert(e.message);	
	}
	var strCount = GetCode(strNoCount, "^");
	var strCrrNo = GetDesc(strNoCount, "^");
	
		
    var PatCondID=GetAdmPatCondIDByEpisodeID("MethodGetAdmPatCondID",strAdm);   //add by liuxuefeng 2009-02-11

	//var strOjbPinyin = cspRunServerMethod(getElementValue("MethodPinYin"));
	
	//document.write(strOjbPinyin);
	//var strObjPrinter = cspRunServerMethod(getElementValue("MethodPrinter"));
    
	     
	objInState = document.getElementById("cboInState");
	objInState.multiple = false;
	objInState.size = 1;
	DisplayMrInfo(null);
	DisplayPatientBaseInfo(strPatientID, strAdm);
	document.getElementById("txtCurrentMrType").innerText = objDic.Description;
	var obj=document.getElementById("txtNo");
	if (obj)
	{
		if (obj.disabled==false) {obj.focus();}
	}
	document.getElementById("cboInState").selectedIndex = 0;

	
	if(new Number(strCount) > 200)
	{
	    setElementValue("lblNoCount", tmpChinese[11] + strCount);	
	    document.getElementById("lblNoCount").style.color = "blue";
	}
	else
	{   
	    if(strCount == "-100")
	        strCount = "0" ;
	    setElementValue("lblNoCount", tmpChinese[11] + strCount + tmpChinese[12] );		
	    document.getElementById("lblNoCount").style.color = "red";
	    //if(new Number(strCount) <= 0) 
	        //window.alert(tmpChinese[13]);
	}
	
		
	 DrawTableBorder();
	
	 SetControlVisitable("cmdPrintCard", false);
	 SetControlVisitable("cmdNewRequest", false);
	 //document.write(strObjPrinter);
	
	//add by zf 2008-04-22
	if (getElementValue("txtNo",null)!==""){
		var obj=document.getElementById("txtNo");
		if (obj) {obj.disabled = false;}
		SetControlVisitable("cmdAdvancedQuery", false);
		if (GetParam(window,"MultiAdmit")!=="Y"){
			SetControlVisitable("cmdAdmit", false);
		}
	}else{
		QueryMRByPatInfo();
	}
	//add by liuxuefeng 2009-02-11////////
	if(PatCondID>0){
		 objInState.value=PatCondID;
	}
	/////////////////////////////////////
	
	/////////////////////start cjb//////////////////////
	if(HospitalCode == "BeiJing_AZ")
	 {
	 		setElementValue("txtNo", objCurrentPatient.PatientNo);
	 }
	txtNoOnChange();
	/////////////////////end cjb
	
	
}

//add by zf 2008-04-23
function QueryMRByPatInfo()
{
	var PatName=getElementValue("txtPName",null);
    var Birthday=getElementValue("txtPBirthday",null);
    var NameSpell=GetPinYin(PatName);
    var MrType=getElementValue("AssignMrType");
    if ((!PatName)||(PatName=="")) return;
    //if ((!Birthday)||(Birthday=="")) return;
    if (Birthday!==""){
	    var yList=Birthday.split(" ");
	    Birthday=yList[0];
    }
    
	var obj=document.getElementById('MethodQueryMR');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret="";
    ret=cspRunServerMethod(encmeth,MrType,NameSpell,PatName,"","","","",Birthday);
    if ((ret!=="")&&(ret!==null)){
	    var xTMP=t["xHaveMRPat"] + CHR_13 + CHR_10;
		var xList=ret.split(CHR_1);
		var xSubList;
		for (var i=0;i<xList.length;i++)
		{
			if (xList[i]!=="") {
				xSubList=xList[i].split("^");
				xTMP=xTMP + " " + t["xMrNo"] + ":" + xSubList[0] +" "+ t["xName"] + ":" + xSubList[1] +" "+ t["xBirthday"] + ":" + xSubList[2] + CHR_13 + CHR_10;
			}
		}
		alert(xTMP);
	}
}

function InitEvent()
{
	document.getElementById("cmdPrintCard").onclick = cmdPrintCardOnClick;
	document.getElementById("cmdAdvancedQuery").onclick = cmdAdvancedQueryOnClick;
	document.getElementById("cmdAdmit").onclick = cmdAdmitOnClick;
	document.getElementById("cmdNewRequest").onclick = cmdNewRequestOnClick;
	//document.getElementById("cmdAssignNewNo").onclick = cmdAssignNewNoOnClick;
	//document.getElementById("cmdUseThisNumber").onclick = cmdUseThisNumberOnClick;
	//document.getElementById("txtNo").onchange = txtNoOnLostFocus;
	document.getElementById("cmdUnReceipt").onclick = cmdUnReceiptOnClick;
	document.getElementById("txtNo").onblur = txtNoOnChange;
	document.getElementById("txtNo").onkeydown = txtNoOnKeyDown;
	document.getElementById("btnPrintBarcode").onclick = btnPrintBarcodeOnClick;

}

//add by zf 2008-04-22
function txtNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	txtNoOnChange();
	var obj=document.getElementById("txtNo")
	if (obj) 
	{
		if (obj.disabled==false) {obj.focus();}
	}
}

function BodyLoadHandler()
{
   InitForm();
   InitEvent();
}
window.onload = BodyLoadHandler;

/*
1. we need to rewrite "receiption" method 
2. we need to write a method to get every mr no of a patient by his or her registration card no.
*/
