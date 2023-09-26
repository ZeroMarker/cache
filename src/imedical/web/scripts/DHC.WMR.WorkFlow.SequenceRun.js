/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkFlow.SequenceRun.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-4-18

COMMENT: DHC.WMR.WorkFlow.SequenceRun event handler

============================================================================ */
var objWorkFlowDic = new ActiveXObject("Scripting.Dictionary"); //save workflow dictionary
var objWorkFlowList = new Array(); //Save workflow item list
var objMrList = new ActiveXObject("Scripting.Dictionary");
var objCurrentFlow = null; //current workflow item selected
var intCurrentFlowPos = -1;//position of current workflow item at whole workflow,emergency workflow is -1
var objMrType = null;//current medical record type
var objChineseDic = GetChineseDic("MethodChinese", "DHC.WMR.WorkFlow.SequenceRun");
var objHospital = GetcurrHospital("MethodGetCurrHospital"); //get hospital configure profile

objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", GetParam(window, "MrType"));
//var objDicOutPatientMr = GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "MrType", "1");
//var objDicInPatientMr = GetDHCWMRDictionaryByTypeCode("MethodGetDHCWMRDictionaryByTypeCode", "MrType", "2");

var objArryExtra = new Array();//save extra information
//init workflow
function InitWorkFlow()
{
	var objWorkTypeDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetWorkType", "WorkType", "Y");
	var objFlow = GetDHCWMRWorkFlowByTypeFlag("MethodGetWorkFlow", GetParam(window, "MrType"), "Y");
	var objItm = null; //workflow item
	var objDetail = null;//workflow detail
	var objDic = null;
	var strEmergencyRowID = ""; //emergency workflow item RowID;
	var arryEm = null;
	if(objFlow == null)
	{
		window.alert(t["WorkFlowError"]);
		return;
	}
	var arryItems = GetDHCWMRWokrFlowSubList("MethodGetWorkFlowArry", objFlow.RowID);
	for(var i = 0; i < arryItems.length; i ++)
	{
		objItm = arryItems[i];
		objDetail = GetDHCWMRWorkItemByID("MethodGetWorkItem", objItm.Item_Dr);
		if(HasPower("MethodUserFunction", session["LOGON.GROUPID"], objDetail.Description))
		{
			AddListItem("lstWorkFlow", objDetail.Description, objDetail.RowID);
		}
		objDetail.IsEmergency = false;//indicate that it is sequence workflow
		objWorkFlowList[i] = objDetail;
		objWorkFlowDic.Add(objDetail.RowID,  objDetail);		
	}
	for(var i = 0; i < objWorkTypeDic.length; i ++)
	{
		objDic = objWorkTypeDic[i];
		if(objDic.Code == '2')//2--means emergency work item
		{
			strEmergencyRowID = objDic.RowID;
			arryEm = GetDHCWMRWorkItemByTypeFlag("MethodGetEmergeWorkItem", strEmergencyRowID, "Y");
			for(var j = 0; j < arryEm.length; j ++)
			{
				objDetail = arryEm[j];
				//window.alert(objDetail.Description);
				if(HasPower("MethodUserFunction", session["LOGON.GROUPID"], objDetail.Description))
				{
					AddListItem("lstWorkFlow", objDetail.Description + objChineseDic.Item("Emergency1"), objDetail.RowID);
					objDetail.IsEmergency = true;//emergency workflow
				}
				objWorkFlowDic.Add(objDetail.RowID,  objDetail);				
			}
		}
	}
	var objList = document.getElementById("lstWorkFlow");
	if(objList.options.length > 0)
		objList.selectedIndex = 0;
	lstWorkFlowSelected();
}

/***********************************************************

//check workflow
//parameter
//objStatus:current volume status
//return value:if next workflow is correct return true,else false*/

function CheckWorkStatus(objStatus)
{
	var objItem = null;
	var objSavedStatus = null;
	var objNextStatus = null;//next work flow
	var objSysOpeDic = null;//Modified By LiYang 2008-11-27 fix the logical problem of workflow
	var objSysOpeDic1 = null;
	/*Items to be checked
	1.whether a volume status is in the current workflow line.
	2.check whether next status is sequence workflow and the current status is emergency workflow.(not return to sequence work flow)
	3.position check;
	
	*/
	if(!objWorkFlowDic.Exists(objStatus.RowID))//check item 1
	{
		window.alert(t["NotInFlow"]);
		return false;		
	}
	objSavedStatus = objWorkFlowDic.Item(objStatus.RowID);
	if((objSavedStatus.IsEmergency == true) && (objCurrentFlow.IsEmergency == false))//check item 2
	{
		window.alert(t["InEmergency"]);
		return false;
	}
	if(objSavedStatus.RowID == objCurrentFlow.RowID)//repeated emergency workflow
	{
		window.alert(t["WorkFlowDuplicate"]);
		return false;
	}
	
	//Modified By LiYang 2008-11-27 fix the logical problem of workflow
	/*
	if(objCurrentFlow.SysOper_Dr != "")
	{
		objSysOpeDic = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
		if ((objSysOpeDic.Code != "3") && (objSysOpeDic.Code != "6") && (objSavedStatus.IsEmergency == true))
		{
			window.alert(t["LendOut"]);
			return false;			
		}
	}
	*/
	//update by zf 2008-12-05
	if((objCurrentFlow.SysOper_Dr != "")&&(objSavedStatus.SysOper_Dr != ""))
	{
		objSysOpeDic = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
		objSysOpeDic1 = GetDHCWMRDictionaryByID("MethodGetDicItem", objSavedStatus.SysOper_Dr);
		if (((objSysOpeDic.Code=="2")||(objSysOpeDic.Code=="4")||(objSysOpeDic.Code=="5")) && ((objSysOpeDic1.Code=="2")||(objSysOpeDic1.Code=="4")||(objSysOpeDic1.Code=="5")))
		{
			window.alert(t["StayOut"]);
			return false;
		}
		if ((objSysOpeDic.Code=="3") && (objSysOpeDic1.Code=="3"))
		{
			window.alert(t["StayIn"]);
			return false;
		}
	}else if ((objCurrentFlow.SysOper_Dr != "")&&(objSavedStatus.SysOper_Dr == "")){
		objSysOpeDic = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
		if (objSysOpeDic.Code=="3")
		{
			window.alert(t["StayIn"]);
			return false;
		}
	}else if ((objCurrentFlow.SysOper_Dr == "")&&(objSavedStatus.SysOper_Dr != "")){
		//
	}else{
		//
	}
	if((objSavedStatus.IsEmergency == false) && (objCurrentFlow.IsEmergency == false))//check item 3
	{
		for(var i = 0; i < objWorkFlowList.length; i ++)
		{
			objItem = objWorkFlowList[i];
			if(objItem.RowID == objStatus.RowID)
				break;
		}	
		if(intCurrentFlowPos != (i + 1))
		{
			objNextStatus = objWorkFlowList[i + 1];
			if(objNextStatus="undefined")
			{
				window.alert("Error:"+t["CurrentStatus"] + objStatus.Description);
				}
			else{
			window.alert(t["CurrentStatus"] + objStatus.Description + "\n" + 
			t["ErrorWorkFlowPos"].replace("***", objNextStatus.Description));
			}
			return false;
		}
	}
	return true;	
}


//check medical record info
function CheckMainStatus(obj)
{
			/*
			Items to be checked
			1.only emergency workflow 
			2.is medical record exist?
			3.check "stayin " property
			4.
			*/
	var objMainTmp = null;
	var objMain = null;
	var objStatus = null;
	var objCurrWorkItem = null;
	var objSysOpeDic = null;  //Modified By LiYang 2008-11-27 fix the logical problem of workflow
	if(!objCurrentFlow.IsEmergency)
	{
		window.alert(t["NotAVolume"]);//check item 1
		return false;
	}
	objMain = GetDHCWMRMainByID("MethodGetMrMainByID", obj.RowID);
	if(objMain == null)//check item 2
	{
		window.alert(t["NoMr"]);
		return false;
	}
	//if((!objMain.IsStayIn) && (objCurrentFlow.SysOper_Dr == ""))//check item 3
	//{
	//	window.alert(t["LendOut"]);
	//	return false;
	//}
	//Modified By LiYang 2008-11-27 fix the logical problem of workflow
	/*
	if(objCurrentFlow.SysOper_Dr != "")
	{
		objSysOpeDic = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
		if ((objSysOpeDic.Code != "3") && (objSysOpeDic.Code != "6") && (objMain.IsStayIn == false))  //Code=3  --Return operation   Code=6--Empty System operation
		{
			window.alert(t["LendOut"]);
			return false;			
		}
	}
	*/
	//update by zf 2008-12-05
	if(objCurrentFlow.SysOper_Dr != "")
	{
		objSysOpeDic = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
		if (((objSysOpeDic.Code == "2") || (objSysOpeDic.Code == "4") || (objSysOpeDic.Code == "5")) && (objMain.IsStayIn == false))
		{
			window.alert(t["StayOut"]);
			return false;
		}
		if ((objSysOpeDic.Code == "3") && (objMain.IsStayIn == true))  //Code=3  --Return operation   Code=6--Empty System operation
		{
			window.alert(t["StayIn"]);
			return false;
		}
	}else{
		////update by zf 2010-01-25
		//if (objMain.IsStayIn == true){
		//		window.alert(t["StayIn"]);
		//		return false;
		//}
	}
	
	//Add new validation function~~~~~~~~~~~~
	return true;
}

//check volume status
function CheckVolStatus(objVolMr)
{
	var objMain = null;
	var objVol = null;
	var objHis = null;
	var objStatus = null;
	var objCurrWorkItem = null;
	var objSysDicItem = null;//System dictionary
	objMain = GetDHCWMRMainByID("MethodGetMrMainByID", objVolMr.RowID);//find DHCWMRMain
	if(objMain == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	if(objMain.MrType != GetParam(window, "MrType"))//Is Mr Type correct
	{
		window.alert(t["MrTypeError"]);
		return false;
	}
	objHis = 
		GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//get patient base information
	if(objHis == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	objVol = GetDHCWMRMainVolumeByID("MethodGetMainVolume", objVolMr.Volume.RowID)//get volume information
	if(objVol == null)
	{
		window.alert(t["NoVolume"]);
		return false;
	}
	if((!objVol.InFlow) && (!objCurrentFlow.IsEmergency))//check whether volume status in workflow line
	{
		window.alert(t["FlowComplete"]);
		return false;
	}
	objCurrWorkItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", objVol.Status_Dr);//get current workflow
	if(objCurrWorkItem == null)
	{
		window.alert(t["NoWorkItem"]);
		return false;
	}
	/*objCurrWorkItem = objWorkFlowDic.Item(objCurrWorkItem.RowID);//repeated emergency workflow
	objSysDicItem = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
	if((objCurrWorkItem.IsEmergency) && (objSysDicItem.Code != "3"))//objSysDicItem.Code =3 // code 3 is recall
	{
		window.alert(t["InEmergency"]);
		return false;
	}
	if((!objCurrWorkItem.IsEmergency) && (objSysDicItem.Code == "3"))//objSysDicItem.Code =3
	{
		window.alert(t["NotInEmergency"]);
		return false;
	}*/
	if(!CheckWorkStatus(objCurrWorkItem))//check volume status
		return false;
		
	return true;
}

//*********************************************************************


//display volume info
//param
//objBarCode:barcode information
function DisplayMrInfo(objBarCode)
{
	var objMain = null;//DHCWMRMain
	var objVol = null;//Volume
	var objHis = null;//history info
	var objItm = null;//store ListItem item
	var objCurrWorkItem = null;//current workflow item
	var objAdm = null;
	var objSysDicItem = null;//store system dictionary item
	var arryRequest = null;//Store the request if the work flow need a request~~~
	if((objBarCode.Type != "02") && (!objCurrentFlow.IsEmergency))//return is it is not a volume
	{
		window.alert(t["NotAVolume"]);
		return;
	}
	switch(objBarCode.Type)
	{
		case "01"://mr barcode
			objMain = GetDHCWMRMainByID("MethodGetMrMainByID", objBarCode.ID);//found main info		
			break;
		case "02"://volume barcode
			objVol = GetDHCWMRMainVolumeByID("MethodGetVolumeById", objBarCode.ID);
			objMain = GetDHCWMRMainByID("MethodGetMrMainByID", objVol.Main_Dr);
			break;		
	}	
	if(objMain == null)
	{
		window.alert(t["NoMr"]);
		return;
	}
	if(objMain.MrType != GetParam(window, "MrType"))//is mr tpye match?
	{
		window.alert(t["MrTypeError"]);
		return;
	}
	objHis = 
		GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//get patient base information
	if(objHis == null)
	{
	    objHis = new DHCWMRHistory();
		//window.alert(t["NoMr"]);
		//return;
	}
	switch(objBarCode.Type)
	{
		case "02"://volume
			if(objVol == null)
			{
				window.alert(t["NoVolume"]);
				return;
			}
			if((!objVol.InFlow) && (!objCurrentFlow.IsEmergency))//is in workflow?
			{
				window.alert(t["FlowComplete"]);
				return;
			}
			objCurrWorkItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", objVol.Status_Dr);//get current status
			if(objCurrWorkItem == null)
			{
				window.alert(t["NoWorkItem"]);
				return;
			}
			/*objCurrWorkItem = objWorkFlowDic.Item(objCurrWorkItem.RowID);//repeat emergency workflow
			objSysDicItem = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
			if((objCurrWorkItem.IsEmergency) && (objSysDicItem.Code != "3"))//objSysDicItem.Code =3//recall
			{
				window.alert(t["InEmergency"]);
				return false;
			}
			if((!objCurrWorkItem.IsEmergency) && (objSysDicItem.Code == "3"))//objSysDicItem.Code =3//
			{
				window.alert(t["NotInEmergency"]);
				return false;
			}*/
			if(!CheckWorkStatus(objCurrWorkItem))//check work flow
				return;
			objMain.Volume = objVol;//add volume info to main info
			break;
		case "01"://whole mr info 
			if(!objCurrentFlow.IsEmergency)
			{
				window.alert(t["WorkFlowError"]);//only emergency workflow
				return;
			}
			//a();
			if(!CheckMainStatus(objMain))
				return;
				

			/*objCurrWorkItem = objWorkFlowDic.Item(objCurrWorkItem.RowID);//
			objSysDicItem = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
			if((!objMain.IsStayIn) && (objSysDicItem.Code != "3"))////objSysDicItem.Code =3
			{
				window.alert(t["LendOut"]);
				return;
			}
			if((objMain.IsStayIn) && (objSysDicItem.Code == "3"))//objSysDicItem.Code =3
			{
				window.alert(t["NotInEmergency"]);
				return false;
			}*/
			break;
		default:
			break;
	}
	
	objMain.History = objHis;////add volume info to main info
	//Add By LiYang 2011-02-19 If Patient is dead, display to user
	var isDead = false;
	if(cspRunServerMethod(
		document.getElementById("MethodIsPatientDead").value,
		objMain.Papmi_Dr
	) == "1")
		isDead = true;
	if(!objMrList.Exists(objBarCode.Text))
	{
		switch(objBarCode.Type)
		{
			case "01":
				objItem = AddListItem("lstBarCode", 
					Trim(objMain.MRNO) + "(" + (objMain.IsStayIn ? objChineseDic.Item("Normal") : objChineseDic.Item("NotStayIn")) + (isDead ? "*死亡病历* " : "") + ")     " + 
					Trim(objHis.PatientName) + "     " +
					objHis.Sex + "     " +
					objHis.HomeAddress, objBarCode.Text);
					PrintMrBarCode(objMain.RowID, "", objMain.MRNO, objMain.History.PatientName, objMain); //Modified By LiYang 2009-07-06 use to print extra info
					if(!objMain.IsStayIn)//not stay in use red color
						objItem.style.color = "red";
					setElementValue("lblCount", document.getElementById("lstBarCode").length);
				break;
			case "02":
				if(objVol.Paadm_Dr != "")
				{
					objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVol.Paadm_Dr);
					///////////////////////Start//////add by liuxuefeng 2009-06-05///////////////////////
					if(objHospital.MyHospitalCode=='WeiFang_RMYY')
					{
						var FSStatus=GetFSStatus("MethodGetFSStatus", objVol.Paadm_Dr);
						//alert("FSStatus="+FSStatus);
						if (FSStatus!='N') {
							alert(t['CannotReceive']);
							return false;
						}
					}	
					///////////////////////////////End////////////////////////////////////////
					objItem = AddListItem("lstBarCode", 
						Trim(objMain.MRNO) + "(" +objCurrWorkItem.Description + (isDead ? "*死亡病历* " : "")  + ")     " +
						Trim(objHis.PatientName) + "     " + 
						objAdm.DischgDate + "     " +
						GetDesc(objAdm.LocDesc, "/") 
						, objBarCode.Text);							

				}
				else
				{
					objAdm = GetDHCWMRHistoryAdmByID("MethodGetHistoryPatientAdmitInfo", objVol.HistroyAdm_Dr);
					objItem = AddListItem("lstBarCode", 
						Trim(objMain.MRNO) + "(" +objCurrWorkItem.Description + ")     " +
						Trim(objHis.PatientName) + "     " + 
						objAdm.DischargeDate + "     " +
						objAdm.AdmitDep + "     " 
						, objBarCode.Text);
										
				}
				setElementValue("lblCount", document.getElementById("lstBarCode").length);	
				objCurrWorkItem = objWorkFlowDic.Item(objCurrWorkItem.RowID);
				if((objCurrWorkItem.IsEmergency)||isDead)//emergency workflow and dead patient use red color  Add BY LiYang 2011-02-19
					objItem.style.color = "red";
				if(objVol.IsReprography)
				    objItem.style.color = "blue";
				if(objVol.IsSeal)
				    objItem.style.color = "green";				   
				PrintMrBarCode(objMain.RowID, objMain.Volume.RowID, objMain.MRNO, objMain.History.PatientName, objMain, objMain.Volume);
				
				break;
		}
		objMrList.Add(objBarCode.Text, objMain);
	}
	else
	{
		window.alert(t["MrExist"]);
	}
}


function CheckTMPWorkStatus(objStatus)
{
	var objItem = null;
	var objSavedStatus = null;
	var objNextStatus = null;
	var objSysOpeDic = null;
	var objSysOpeDic1 = null;
	if(!objWorkFlowDic.Exists(objStatus.RowID))//check item 1
	{
		//window.alert(t["NotInFlow"]);
		return false;		
	}
	objSavedStatus = objWorkFlowDic.Item(objStatus.RowID);
	if((objSavedStatus.IsEmergency == true) && (objCurrentFlow.IsEmergency == false))//check item 2
	{
		//window.alert(t["InEmergency"]);
		return false;
	}
	if(objSavedStatus.RowID == objCurrentFlow.RowID)//repeated emergency workflow
	{
		//window.alert(t["WorkFlowDuplicate"]);
		return false;
	}
	if((objCurrentFlow.SysOper_Dr != "")&&(objSavedStatus.SysOper_Dr != ""))
	{
		objSysOpeDic = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
		objSysOpeDic1 = GetDHCWMRDictionaryByID("MethodGetDicItem", objSavedStatus.SysOper_Dr);
		if (((objSysOpeDic.Code=="2")||(objSysOpeDic.Code=="4")||(objSysOpeDic.Code=="5")) && ((objSysOpeDic1.Code=="2")||(objSysOpeDic1.Code=="4")||(objSysOpeDic1.Code=="5")))
		{
			//window.alert(t["StayOut"]);
			return false;
		}
		if ((objSysOpeDic.Code=="3") && (objSysOpeDic1.Code=="3"))
		{
			//window.alert(t["StayIn"]);
			return false;
		}
	}else if ((objCurrentFlow.SysOper_Dr != "")&&(objSavedStatus.SysOper_Dr == "")){
		objSysOpeDic = GetDHCWMRDictionaryByID("MethodGetDicItem", objCurrentFlow.SysOper_Dr);
		if (objSysOpeDic.Code=="3")
		{
			//window.alert(t["StayIn"]);
			return false;
		}
	}else if ((objCurrentFlow.SysOper_Dr == "")&&(objSavedStatus.SysOper_Dr != "")){
		//
	}else{
		//
	}
	if((objSavedStatus.IsEmergency == false) && (objCurrentFlow.IsEmergency == false))//check item 3
	{
		for(var i = 0; i < objWorkFlowList.length; i ++)
		{
			objItem = objWorkFlowList[i];
			if(objItem.RowID == objStatus.RowID)
				break;
		}	
		if(intCurrentFlowPos != (i + 1))
		{
			objNextStatus = objWorkFlowList[i + 1];
			if(objNextStatus="undefined")
			{
				//window.alert("Error:"+t["CurrentStatus"] + objStatus.Description);
			}else{
				//window.alert(t["CurrentStatus"] + objStatus.Description + "\n" + 
				//t["ErrorWorkFlowPos"].replace("***", objNextStatus.Description));
			}
			return false;
		}
	}
	return true;	
}

//display volume list
function DisplayMrVolumeList(objMain)
{
	var objVol = null;
	var objAdm = null;
	var count=0;
	var objArry = GetDHCWMRMainVolumeArryByMainID("MethodGetVolumeArry", objMain.RowID);
	var objBaseInfo = GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);
	for(var i = 0; i < objArry.length; i ++)
	{
		objVol = objArry[i];
		
		//update by zf 20100421
		//验证卷状态是否符合当前操作，符合加载到卷列表，否则不加载
		if((!objVol.InFlow) && (!objCurrentFlow.IsEmergency))  continue;
		if((objVol.InFlow) && (objCurrentFlow.IsEmergency))  continue;
		if(!objVol.IsActive)  continue;
		var objTMPCurrWorkItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", objVol.Status_Dr);//get current status
		if(objTMPCurrWorkItem == null) continue;
		if(!CheckTMPWorkStatus(objTMPCurrWorkItem)) continue;
		
		var AdmStatus="*出院";
		if(objVol.Paadm_Dr != "")
		{
			objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVol.Paadm_Dr);

			if (objAdm.DischgDate != ""){
				AdmStatus="出院";
			}else{
				AdmStatus="在院";
				continue;
			}
			switch(objHospital.MyHospitalCode)
			{
				case "BeiJing_YY": //Beijing Friendship Hospital
					if(objAdm.DischgDate != "")
					{
						AddListItem("lstVols", 
						//Trim(objMain.MRNO) + "     " + 

						Trim(objBaseInfo.PatientName) + "     " + 
						AdmStatus + "     " + 
						objAdm.DischgDate + "     " +
						GetDesc(objAdm.LocDesc, "/") 
						, "02" + AddZero(objVol.RowID, 11));					
					}	
					break;
				default: //Default
				  
					AddListItem("lstVols", 
						//Trim(objMain.MRNO) + "     " + 
						Trim(objBaseInfo.PatientName) + "     " + 
						AdmStatus + "     " + 
						objAdm.DischgDate + "     " +
						GetDesc(objAdm.LocDesc, "/") 
						, "02" + AddZero(objVol.RowID, 11));
					break;
			}	
		}else{
		    if(!objCurrentFlow.IsEmergency)//don't display volume list if it is seguence workflow
		        continue; 
			objAdm = GetDHCWMRHistoryAdmByID("MethodGetHistoryPatientAdmitInfo", objVol.HistroyAdm_Dr);
			AddListItem("lstVols", 
				//Trim(objMain.MRNO) + "     " + 
				Trim(objBaseInfo.PatientName) + "     " + 
				AdmStatus + "     " + 
				objAdm.DischargeDate + "     " +
				objAdm.AdmitDep 
				, "02" + AddZero(objVol.RowID, 11));						
		}
	}
	var obj = document.getElementById("lstVols");
	if(obj.options.length > 0)
		obj.selectedIndex =0; //obj.options.length -1;Modify by liuxuefeng 2009-06-04
		obj.focus();
	//cjb 2009-10-26
	if(obj.options.length == "0"){
		alert(t['ErrorCode1']);
		document.getElementById("txtMrNoVol").focus();
		//alert(document.getElementById("txtMrNoVol"));
		setElementValue("txtMrNoVol", "");
	}else if(obj.options.length == "1"){
		//lstVolsOnKeyDown();
		var tmp = getElementValue("lstVols");
	  	if(tmp == "") return;
		var objBarCode = DHCWMRBarCode(tmp);
		DisplayMrInfo(objBarCode);
		ClearListBox("lstVols");
		//document.getElementById("txtMrNoVol").focus();
		setElementValue("txtMrNoVol", "");
		document.getElementById("txtMrNoVol").focus();
	}else{
		//不做任何操作
	}
}



//save extra info
//pos:position in the list
//flag:1-mainStatus 2-volStatus
function SaveStatusToObject(pos , flag)
{
	var obj = null;
	var objMr = null;	
	var objItm = null;
	var objLst = document.getElementById("lstBarCode");
	objItm = objLst.options.item(pos);
	if(flag == "1")
	{
		obj = DHCWMRMainStatus();
		objMr = objMrList.Item(objItm.value);
		obj.Parref = objMr.RowID;
	}
	else
	{
		obj = DHCWMRVolStatus();
		objMr = objMrList.Item(objItm.value);
		obj.Parref = objMr.Volume.RowID;
	}
	obj.Status_Dr = objCurrentFlow.RowID;
	obj.UserFromDr = session['LOGON.USERID'];
	return obj;
}
//save extra info
//pos:position in the list
//1-mainStatus 2-volStatus
function SaveStatusDetailToObject(flag)
{
	/*var arry = new Array();
	var obj = null;
	var objTbl = parent.frames[1].document.getElementById("tDHC_WMR_WorkDetail");
	for(var i = 1; i < objTbl.rows.length; i ++)
	{
		if(flag == 1)
			obj = DHCWMRMainStatusDtl();
		else
			obj = DHCWMRVolStatusDtl();
		obj.WorkItemList_Dr = getElementValue("WorkItemListDrz" + i, parent.frames[1].document);
		obj.Detail_Dr = getElementValue("WorkDetailRowidz" + i, parent.frames[1].document);
		obj.ItemValue = getElementValue("ItemValuez" + i, parent.frames[1].document);
		arry.push(obj);
	}
	return arry;
	"websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdFeedBackQry"
	*/
	
	var strUrl = "dhc.wmr.workflow.extra.csp?";
	var objReturn = null;
	var arg = "MainStatusRowid=" +
			"&VolStatusRowid=" + 
			"&WorkItemRowid=" + objCurrentFlow.RowID +
			"&IsEdit=" + "Y" +
			"&StatusFrom=" + 
			"&StatusTo=" + 
			"&ValidateUser=" + "N" + 
			"&MainRowid=" + 
			"&VolRowid=" + 
			"&flag=" + flag;
	/*
	objReturn = window.showModalDialog(strUrl + arg,"dialogWidth=300,dialogHeight=500");
	if(objReturn == null)
		objReturn = new Array();
		*/
	var pars = new Object();
	pars.window = window;
	objReturn = window.showModalDialog(strUrl + arg,pars,"dialogWidth=300,dialogHeight=500"); 
	if(objReturn == null)
		objReturn = new Array();
	return objReturn;
}

//Print barcode
//MainRowID DHCMWMain ID
//VolumeRowID Volume RowID
//MrNO MrNo
function PrintMrBarCode(MainRowID, VolumeRowID, MrNO, PatientName, MainObj, VolObj)  //Modified By LiYang 2009-07-15
{
	//objPrinter = document.getElementById("clsWMRBarCode");
	//if(objPrinter == null) objPrinter = new ActiveXObject("DHCWMRWebPackage.clsWMRBarCode")
	/*Modify by wuqk 2008-04-28 for PrintBarcode*/
	//var objHosptial = GetcurrHospital("MethodGetDefaultHosp");  //This setting become global setting now~
	//First:Print MainBarCode
	var MainBarCode="";	//modify by liuxuefeng 2009-07-03
	var ElseString="";
	if((getElementValue("chkPrintMainBarCode")) && (MainRowID != ""))//print whole mr barcode ?
	{
		MainBarCode = "01" + formatString(MainRowID,11);
		//Modified By LiYang 2009-7-15 FuXing Hospital do not need print mr tpye description  on  barcode label
		switch(objHospital.MyHospitalCode)
		{
			//Fu Xing Hospital need to print volume number
			case "BeiJing_FX":
				//Notice:String.fromCharCode(21367) is Chinese Character "Volume"
				//360 is backfeed, you can modify this
				ElseString = "" + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex + CHR_1 + MainObj.History.Sex.Age + CHR_1 + MainObj.History.Sex.Birthday;
				break;
			case "BeiJing_AZ":
				//Notice:String.fromCharCode(21367) is Chinese Character "Volume"
				//360 is backfeed, you can modify this
				ElseString = "" + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex + CHR_1 + MainObj.History.Age + CHR_1 + MainObj.History.Birthday; //Update by LiuYuHui 2009-12-15
				break;
			default:
				ElseString = objMrType.Description + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex + CHR_1 + MainObj.History.Age + CHR_1 + MainObj.History.Birthday;
				break;
		}
	}
	
	//add by liuxuefeng 2009-07-03
	//Can Print MainBarCode and VolBarCode At The Same Time
	if (MainBarCode!="")
	{
		objPrinter = new ActiveXObject("DHCWMRWebPackage.clsWMRBarCode");
		objPrinter.PrintWMRBarCode(objHospital.MyHospitalCode, objHospital.BarcodePrinter, MainBarCode, ElseString);
	}
	
	//Second:Print VolBarCode
	var VolBarCode="";	//add by liuxuefeng 2009-07-03
	if(getElementValue("chkPrintVolumeBarCode") && (VolumeRowID != ""))//print volume barcode ?
	{
		VolBarCode = "02" + formatString(VolumeRowID,11);
		var ElseString = "";
		var VolumeNumber = "";
		//Modified By LiYang 2009-7-15 FuXing Hospital need printing volume number on the barcode label .
		switch(objHospital.MyHospitalCode)
		{
			//Fu Xing Hospital need to print volume number
			case "BeiJing_FX":
				if (VolObj.Paadm_Dr != "")
				{
					VolumeNumber = " " + VolObj.ResumeText;
				}
				//Notice:String.fromCharCode(21367) is Chinese Character "Volume"
				//360 is backfeed, you can modify this
				//ElseString = String.fromCharCode(21367) + VolumeNumber + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex.Sex + CHR_1 + MainObj.History.Sex.Age + CHR_1 + MainObj.History.Sex.Birthday; //2009-12-25 LiuYuHui 注释掉
				ElseString = String.fromCharCode(21367) + VolumeNumber + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex + CHR_1 + MainObj.History.Age + CHR_1 + MainObj.History.Birthday;
				break;
			case "BeiJing_AZ":
				if (VolObj.Paadm_Dr != "")
				{
					VolumeNumber = " " + VolObj.ResumeText;
				}
				//Notice:String.fromCharCode(21367) is Chinese Character "Volume"
				//360 is backfeed, you can modify this
				//ElseString = String.fromCharCode(21367) + VolumeNumber + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex.Sex + CHR_1 + MainObj.History.Sex.Age + CHR_1 + MainObj.History.Sex.Birthday; //2009-12-25 LiuYuHui 注释掉
				ElseString = String.fromCharCode(21367) + VolumeNumber + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex + CHR_1 + MainObj.History.Age + CHR_1 + MainObj.History.Birthday;
				break;
			default:
				ElseString = objMrType.Description + objChineseDic.Item("Volume") + CHR_1 + MrNO + CHR_1 + PatientName + CHR_1 + 360 + CHR_1 + MainObj.History.Sex + CHR_1 + MainObj.History.Age + CHR_1 + MainObj.History.Birthday;
				break;
		}
	}
	if(VolBarCode!="")
	{
		objPrinter = new ActiveXObject("DHCWMRWebPackage.clsWMRBarCode");
		objPrinter.PrintWMRBarCode(objHospital.MyHospitalCode, objHospital.BarcodePrinter, VolBarCode, ElseString);
	}

}

function ValidateRequest(objMain)
{
	//2008-3-3 by liyang
	var arryRequest = null;
	if(!objCurrentFlow.BeRequest)
		return true;
		
	arryRequest = GetReqList("MethodGetReqList", 
		objMain.RowID,
		getElementValue("txtAimDateFrom"),
		getElementValue("txtAimDateTo"),
		"Y" );//GetRequest List to Check
	if(arryRequest.length <= 0)
	{
		window.alert(t["NeedRequest"]);
		if(objMain.Papmi_Dr == "")
		{
			window.alert(t["NeedAdmit"]);
			return;
		}
		//WMR_NewRequest(objMain.Papmi_Dr, "", objDicOutPatientMr.RowID, objDicInPatientMr.RowID, objCurrentFlow.RowID, "");
		WMR_NewRequest(objMain.Papmi_Dr, "", objMrType.RowID, "", objCurrentFlow.RowID, "");
		arryRequest = GetReqList("MethodGetReqList", 
			objMain.RowID,
			getElementValue("txtAimDateFrom"),
			getElementValue("txtAimDateTo"),
			"Y" );
		if(arryRequest.length == 0)
		{
			window.alert(t["CancelRequest"]);
			return false;//if user cancel input the request
		}
	}
	
	/*
	if(arryRequest.length >= 1)
	{
		if(arryRequest.length > 1)
		{
			for (var i=0;i<arryRequest.length;i++){
				if (arryRequest[i].FirstFlag) {
					objMain.Request = arryRequest[i];
					break;
				}
			}
			objMain.Request = ShowChooseRequest(objMain.RowID, 
				getElementValue("txtAimDateFrom"),
				getElementValue("txtAimDateTo"),
				"Y");
		}
		else
		{
			objMain.Request = arryRequest[0];
		}
	}
	*/
	//update by zf 2008-04-14
	if(arryRequest.length >= 1)
	{
		if(arryRequest.length > 1)
		{
			var flgFirst=true;
			for (var i=0;i<arryRequest.length;i++){
				if (arryRequest[i].FirstFlag) {
					objMain.Request = arryRequest[i];
					flgFirst=false;
					break;
				}
			}
			
			if (flgFirst){
				objMain.Request = ShowChooseRequest(objMain.RowID, 
					getElementValue("txtAimDateFrom"),
					getElementValue("txtAimDateTo"),
					"Y");
			}
		}
		else
		{
			objMain.Request = arryRequest[0];
		}
	}
	
	//objMain.Request = arryRequest[0];

	if(objMain.Request == null)
	{
		window.alert(t["CancelRequest"]);
		return false;
	}
	return true;
}


//save
function SaveInfo()
{
	var objList = document.getElementById("lstBarCode");
	var objItem = null;
	var obj = null;
	var objStatus = null;
	var objStatusDetailList = null;
	var returnValue = false;
	var arrySuccess = new Array();
	var objUser = null;
	var blnKeep = getElementValue("chkKeepList");
	var blnReturn = true;
	var strRequestDr = "";
	
	
	if(objArryExtra.length > 0)
	{
		objStatusDetailList = SaveStatusDetailToObject(2);
		if(objStatusDetailList.length == 0)
		{
			window.alert(t["ExtraInfoCanceled"]);
			return false;
		}
	}
	else
	{
		objStatusDetailList = new Array();
	}		
	if(objCurrentFlow.CheckUser)//check if it need sign?
	{
		objUser = ValidateUser(t["ValidateUser"]);
		if(objUser == null)//user canceled the sign process
		{
			window.alert(t["ValidateUserCanceled"]);
			return false;
		}
	}
	else
	{
		objUser = DHCWMRUser(); 
	}	
	for(var i = objList.options.length - 1 ; i >= 0;  i --)
	{

		objItem = objList.options.item(i);
		obj = objMrList.Item(objItem.value);
			
		switch(objItem.value.substr(0, 2))
		{
			case "01":
				if(!CheckMainStatus(obj))
					continue;
				if(!ValidateRequest(obj))
					continue;
					
				if(objCurrentFlow.BeRequest)
				{
					strRequestDr = obj.Request.RowID;
				}
				else
				{
					strRequestDr = "";
				}						
				
				objStatus = SaveStatusToObject(i, "1");
				objStatus.UserToDr = objUser.RowID;			
				returnValue = SaveWorkDetail("MethodSaveWorkDetail", 
					"0", 
					objCurrentFlow.RowID, 
					DHCWMRBarCode(objItem.value).ID, 
					"",
					SerializeDHCWMRVolStatus(objStatus),
					SerializeDHCWMRMainStatusDtlArry(objStatusDetailList),
					strRequestDr);
				
				//Print Request Note   
				//add by zf 2008-04-16
				if ((strRequestDr!=="")&&(returnValue)) {
					//PrintRequestNote(strRequestDr);
				}
				
				break;
			case "02":
				if(!CheckVolStatus(obj))
					continue;
				objStatus = SaveStatusToObject(i, "2");
				objStatus.UserToDr = objUser.RowID;
				returnValue = SaveWorkDetail("MethodSaveWorkDetail", 
					"1", 
					objCurrentFlow.RowID, 
					"",
					DHCWMRBarCode(objItem.value).ID,
					SerializeDHCWMRVolStatus(objStatus),
					SerializeDHCWMRMainStatusDtlArry(objStatusDetailList),
					strRequestDr);
				break;
		}
		if(returnValue)
		{
			if(!blnKeep)
			{
				objMrList.Remove(objItem.value);
				RemoveListItem("lstBarCode", i );
			}
			setElementValue("lblCount", document.getElementById("lstBarCode").length);
		}
		else
		{
			blnReturn = false;
		}		
	}
	return blnReturn;
}




//process key events
//barcode text box
function txtBarCodeOnKeyDown()
{
	var objBarCode = null;
	if(window.event.keyCode != 13)
		return;
	if(getElementValue("txtBarCode") == "")
		return;
	if(getElementValue("lstWorkFlow") == "")
	{
		window.alert(t["NoWorkFlowAllowed"]); //not such power
		return;
	}
	try
	{
		objBarCode = DHCWMRBarCode(getElementValue("txtBarCode"));	
		DisplayMrInfo(objBarCode);
	}
	catch(err)
	{
		window.alert(err.message);
	}
	setElementValue("txtBarCode", "");
}

//process key events
//MrNo text box
function txtMrNoOnKeyDown()
{
	var objBarCode = null;
	var objMain = null;
	var objVolume = null;
	if(window.event.keyCode != 13)
		return;
	if(getElementValue("txtMrNo") == "")
		return;
	/////////////add by liuxuefeng 2009-08-19///////////
	FormatInputMrNo("MrType","txtMrNo");
	///////////////////// End ////////////////////////
	if(getElementValue("lstWorkFlow") == "")
	{
		window.alert(t["NoWorkFlowAllowed"]); //no power
		return;
	}
	//try
	//{
		objMain = GetDHCWMRMainByMrNo("MethodGetMrMainByMrNo",
				GetParam(window, "MrType"),
				getElementValue("txtMrNo"),
					"Y"
					);

		if(objMain != null)
		{
			objBarCode = DHCWMRBarCode("01" + AddZero(objMain.RowID, 11));
			DisplayMrInfo(objBarCode);
		}
		else
		{
			window.alert(t["NoMr"]);
		}
		
	//}
	//catch(err)
	//{
	//	window.alert(err.description);
	//}
	setElementValue("txtMrNo", "");
}

function txtMrNoVolOnKeyDown()
{
	var objBarCode = null;
	var objMain = null;
	var objVolume = null;
	if(window.event.keyCode != 13)
		return;
	/////////////add by liuxuefeng 2009-08-19///////////
	FormatInputMrNo("MrType","txtMrNoVol");
	///////////////////// End ////////////////////////
	if(getElementValue("lstWorkFlow") == "")
	{
		window.alert(t["NoWorkFlowAllowed"]); //no power
		return;
	}
	ClearListBox("lstVols");
	if(getElementValue("txtMrNoVol") == "")
		return;	
		
	objMain = GetDHCWMRMainByMrNo("MethodGetMrMainByMrNo",
		GetParam(window, "MrType"),
		getElementValue("txtMrNoVol"),
		"Y");
		
	if(objMain != null)
	{
		
		DisplayMrVolumeList(objMain);
		//document.getElementById("lstVols").focus();
	}
	else
	{
		window.alert(t["NoMr"]);
	}
}


function lstWorkFlowSelected()
{
	if(window.event != null)
	{
		//if(window.event.propertyName != "value")
			//return;
	}
	var objWork = null;
	var objList = document.getElementById("lstWorkFlow");
	if(objList.options.length == 0)
	{
		window.alert(objChineseDic.Item("NoPower")); 
		return;
	}
	objCurrentFlow = objWorkFlowDic.Item(getElementValue("lstWorkFlow"));//modify current status
	
	objArryExtra = GetDHCWMRWorkItemListArry("MethodGetWorkItemExtra",objCurrentFlow.RowID, "Y");
	for(var i = 0; i < objWorkFlowList.length; i ++)
	{
		objWork = objWorkFlowList[i];
		if(objCurrentFlow.RowID == objWork.RowID)
			intCurrentFlowPos = i;
	}
	
	//update by zf 20100125
/*
	var tmpListAA=tmpText.split(getElementValue('VolumeFlag'));
	if (tmpListAA.length>1)
	{
		document.getElementById("txtMrNoVol").disabled=false;
		document.getElementById("txtMrNo").disabled=true;
	}else{
		document.getElementById("txtMrNoVol").disabled=true;
		document.getElementById("txtMrNo").disabled=false;
	}
	*/
	cmdClearOnClick();
}

function lstVolsOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	var tmp = getElementValue("lstVols");
	if(tmp == "")
		return;
	var objBarCode = DHCWMRBarCode(tmp);
	DisplayMrInfo(objBarCode);
	ClearListBox("lstVols");
	document.getElementById("txtMrNoVol").focus();
	setElementValue("txtMrNoVol", "");
}

function cmdSaveOnClick()
{	
	

	var objList = document.getElementById("lstBarCode");
	if(objList.options.length == 0)
		return;
	if(SaveInfo())
	{
		window.alert(t["SaveOK"]);
	}
	else
	{
		window.alert(t["SaveFail"]);
	}
}

function cmdRemoveItemOnClick()
{
	var objList = null;
	var objItem = null;
	if(Trim(getElementValue("lstBarCode")) == "")
	{
		window.alert(t["SelectOneEntry"]);
		return;
	}
	objList = document.getElementById("lstBarCode")
	objItem = objList.options[objList.selectedIndex];
	objMrList.Remove(objItem.value);
	RemoveListItem("lstBarCode");
	setElementValue("lblCount", document.getElementById("lstBarCode").length);
}

function cmdClearOnClick()
{
	objMrList.RemoveAll();
	ClearListBox("lstBarCode");
	setElementValue("lblCount", document.getElementById("lstBarCode").length);
}

function InitForm()
{
	var strMrType = GetParam(window, "MrType");
	if(strMrType != "")
	{
		setElementValue("MrType", strMrType);
	}
	else
	{
		window.alert(t["MrTypeError"]);
		return;
	}
//	document.write(GetWMRBarCodeObjectString("MethodBarCodeObj"));
	
	MakeComboBox("lstWorkFlow");
	MakeComboBox("lstVols");
	document.getElementById("txtMrType").readOnly = true;
	objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", GetParam(window, "MrType"));
	if(objMrType != null)
	{
		setElementValue("txtMrType", objMrType.Description);
		InitWorkFlow();
	}
	else
	{
		window.alert(t["MrTypeError"]);
	}
	
	
}
//add by wuqk 2012-02-08
function txtPatNoOnKeyDown(){

	var objBarCode = null;
	var objMain = null;
	var objVolume = null;
	if(window.event.keyCode != 13)
		return;
	if(getElementValue("txtPatNo") == "")
		return;
		
	//setElementValue("txtPatNo", FormatRegNo("txtPatNo"));
	
	if(getElementValue("lstWorkFlow") == "")
	{
		window.alert(t["NoWorkFlowAllowed"]); //no power
		return;
	}
	try
	{
		
		objMain = GetMainByTypeRegNo("MethodGetMainByTypeRegNo",
				GetParam(window, "MrType"),
				getElementValue("txtPatNo"),
					"Y"
					);
     
		if(objMain != null)
		{
			 DisplayMrVolumeList(objMain);
			//objBarCode = DHCWMRBarCode("01" + AddZero(objMain.RowID, 11));
			//DisplayMrInfo(objBarCode);
		}
		else
		{
			window.alert(t["NoMr"]);
		}
		
	}
	catch(err)
	{
		window.alert(err.description);
	}
	setElementValue("txtPatNo", "");
}

function InitEvents()
{
	var obj=document.getElementById("txtBarCode");
	if (obj){obj.onkeydown = txtBarCodeOnKeyDown;}
	//document.getElementById("txtMrNo").onkeydown = txtMrNoOnKeyDown;
	document.getElementById("txtMrNoVol").onkeydown = txtMrNoVolOnKeyDown;
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
	document.getElementById("cmdRemoveItem").onclick = cmdRemoveItemOnClick;
	document.getElementById("cmdClear").onclick = cmdClearOnClick;
	document.getElementById("lstWorkFlow").onpropertychange = lstWorkFlowSelected;
	document.getElementById("lstVols").onkeydown = lstVolsOnKeyDown;
	var objbtnPrint=document.getElementById("btnPrint");
	if (objbtnPrint){objbtnPrint.onclick=btnPrint_onclick;}
	
	//add by wuqk 2012-02-08
	var obj=document.getElementById("txtPatNo");
	if (obj){obj.onkeydown = txtPatNoOnKeyDown;}
}
window.onload=function(){
	InitForm();
  InitEvents();
}

//window.alert("AAA");


//add by zf 2008-04-16
function PrintRequestNote(RequestRowid)
{
	var objPrinter = new ActiveXObject("DHCWMRWebPackage.clsPrinter"); 
	if(objPrinter == null)
	{
		window.alert("fail to init Printer Control");
		return;	
	}

	var obj = GetReqData(RequestRowid);
	if (obj==null)
	{
		alert(t["GetAdmReqError"]);
		return;
	}
	
	var pLeft=0.5,pTop=1.5,rowHeight=0.6,titleHeight=1;
	var intRow = 0, CurrLeft = pLeft, CurrTop = pTop;
	
	//Title
	objPrinter.FontSize = 13;
	objPrinter.FontBold = true;
	objPrinter.PrintContents(CurrLeft + 0, CurrTop, t["cCardTitle"]);
	CurrLeft = pLeft, CurrTop = CurrTop + titleHeight;
	
	//Sub Title
	var SubTitle=t['cCardSubTitle'];
	if (obj.EmergencyFlag=="Yes") {SubTitle=SubTitle+" "+t['cCardEmergencyDesc'];}
	if (obj.AdmStatus=="No") {SubTitle=SubTitle+" "+t['cAdmStatus'];}
	
	objPrinter.PrintContents(CurrLeft + 1.5,CurrTop, SubTitle);
	CurrLeft = pLeft, CurrTop = CurrTop + titleHeight;
	
	//Card Info
	objPrinter.fontSize = 11;
	objPrinter.FontBold = false;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cCardNo']+":"+obj.CardNo);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cPatName']+":"+obj.PatName);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cMrNo']+":"+obj.MrNo);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqLocDesc']+":"+obj.ReqLocDesc);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cRegfeeDoc']+":"+obj.RegfeeDoc);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqDateTime']+":"+obj.RequestDate+" "+obj.RequestTime);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cRegDateTime']+":"+obj.RegDate+" "+obj.RegTime);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqUpLocDesc']+":"+obj.ReqUpLocDesc);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqTypeDesc']+":"+obj.ReqTypeDesc);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['cWorkItemDesc']+":"+obj.WorkItemDesc);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	objPrinter.EndDoc();
}

function GetReqData(xRequestRowid)
{
	var objReq = new Object();
	var obj=document.getElementById('MethodGetAdmReqInfo');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,xRequestRowid);
    if (ret!==""){
	    var tmpList=ret.split("^");
	    if (tmpList.length>=25){
		    objReq.ReqRowid=tmpList[0]      //ReqRowid;
		    objReq.Paadm=tmpList[1]         //Paadm;
		    objReq.PatientId=tmpList[2]     //PatientId;
		    objReq.MrTypeDesc=tmpList[3]    //MrTypeDesc;
		    objReq.MrNo=tmpList[4]          //MrNo;
		    objReq.CardNo=tmpList[5]        //CardNo;
		    objReq.PatNo=tmpList[6]         //PatNo;
		    objReq.PatName=tmpList[7]       //PatName;
		    objReq.PaadmType=tmpList[8]     //PaadmType;
		    objReq.AdmStatus=tmpList[9]     //AdmStatus;
		    objReq.EmergencyFlag=tmpList[10]//EmergencyFlag;
		    objReq.FirstFlag=tmpList[11]    //FirstFlag;
		    objReq.IsActive=tmpList[12]     //IsActive;
		    objReq.ReqLocDesc=tmpList[13]   //ReqLocDesc;
		    objReq.AimDate=tmpList[14]      //AimDate;
		    objReq.AimUserName=tmpList[15]  //AimUserName;
		    objReq.ReqTypeDesc=tmpList[16]  //ReqTypeDesc;
		    objReq.WorkItemDesc=tmpList[17] //WorkItemDesc;
		    objReq.RequestDate=tmpList[18]  //RequestDate;
		    objReq.RequestTime=tmpList[19]  //RequestTime;
		    objReq.RequestUser=tmpList[20]  //RequestUser;
		    objReq.RegfeeDoc=tmpList[21]    //RegfeeDoc;
		    objReq.RegDate=tmpList[22]      //RegDate;
		    objReq.RegTime=tmpList[23]      //RegTime;
		    objReq.RegTimeRange=tmpList[24] //RegTimeRange;
		    objReq.ReqUpLocDesc=""          //ReqUpLocDesc;
	    }
	}
	return objReq;
}

//add by zf 20091013 add Print Button
function btnPrint_onclick()
{
	var objList=document.getElementById("lstBarCode");
	var objItem=null,objBarCode=null,objMain=null,objVol=null,objHis=null;
	var MainID="",VolID="",PatName="",MrNo="";
	
	for(var i=objList.options.length-1;i>=0;i--)
	{
		objItem=null,objBarCode=null,objMain=null,objVol=null,objHis=null;
		MainID="",VolID="",PatName="",MrNo="";
		
		objItem=objList.options.item(i);
		objBarCode=DHCWMRBarCode(objItem.value);
		if (objBarCode==null) continue;
		switch(objBarCode.Type)
		{
			case "01":
				objMain=GetDHCWMRMainByID("MethodGetMrMainByID",objBarCode.ID);
				VolID="";
				break;
			case "02":
				objVol=GetDHCWMRMainVolumeByID("MethodGetVolumeById",objBarCode.ID);
				if (objVol==null) break;
				objMain=GetDHCWMRMainByID("MethodGetMrMainByID",objVol.Main_Dr);
				VolID=objVol.RowID;
				break;
		}
		if (objMain==null) continue;
		objHis=GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);
		if(objHis==null){objHis=new DHCWMRHistory();}
		objMain.History=objHis;
		MainID=objMain.RowID;
		MrNo=objMain.MRNO;
		PatName=objMain.History.PatientName;
		PrintMrBarCode(MainID,VolID,MrNo,PatName,objMain,objVol);
	}
}