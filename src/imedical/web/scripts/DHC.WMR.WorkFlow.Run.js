/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkFlow.Run.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-7

COMMENT: 用来响应DHC.WMR.WorkFlow.Run的事件

============================================================================ */
var objWorkFlowDic = new ActiveXObject("Scripting.Dictionary"); //保存工作流字典
var objWorkFlowList = new Array(); //保存工作流列表

var objMainList = new ActiveXObject("Scripting.Dictionary");
var objVolList = new ActiveXObject("Scripting.Dictionary");

var objCurrentFlow = null; //当前选择的工作流程
var intCurrentFlowPos = -1;//当前选择个工作流程位置，如果是突发流程，返回-1


function InitWorkFlow()
{
	var objWorkTypeDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetWorkType", "WorkType", "Y");//获取工作项目类型（顺序/突发）
	var objFlow = GetDHCWMRWorkFlowByTypeFlag("MethodGetWorkFlow", getElementValue("MrType"), "Y");
	var objItm = null; //工作流的内容
	var objDetail = null;//工作流内容的详细
	var objDic = null;
	var strEmergencyRowID = ""; //突发事件字典RowID;
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
			AddListItem("cboWorkFlowItem", objDetail.Description, objDetail.RowID);
			objDetail.IsEmergency = false;//注明是顺序工作流
		}
		objWorkFlowList[i] = objDetail;
		objWorkFlowDic.Add(objDetail.RowID,  objDetail);		
	}	
	for(var i = 0; i < objWorkTypeDic.length; i ++)
	{
		objDic = objWorkTypeDic[i];
		//window.alert(objDic.Description);
		if(objDic.Description.indexOf("突发") > -1)
		{
			strEmergencyRowID = objDic.RowID;
			arryEm = GetDHCWMRWorkItemByTypeFlag("MethodGetEmergeWorkItem", strEmergencyRowID, "Y");
			for(var j = 0; j < arryEm.length; j ++)
			{
				objDetail = arryEm[j];
				//window.alert(objDetail.Description);
				if(HasPower("MethodUserFunction", session["LOGON.GROUPID"], objDetail.Description))
				{
					AddListItem("cboWorkFlowItem", objDetail.Description + "(突发)", objDetail.RowID);
					objDetail.IsEmergency = true;//注明是突发工作流
				}
				objWorkFlowDic.Add(objDetail.RowID,  objDetail);				
			}
		}
	}
	cboWorkFlowItemSelected();
}

/***********************************************************

//检查工作流
//参数：
//objStatus:当前卷的状态
//返回值：如果可以进入当前选择的工作流，返回True否则返回False
//检查某个卷的工作流状态*/
function CheckWorkStatus(objStatus)
{
	var objItem = null;
	var objSavedStatus = null;
	
	/*检查项目：
	1.这个卷的工作项目是否在当前的工作流中（包括顺序、突发）
	2.检查是否将处于突发事件的卷直接进行顺序工作流
	3.工作流的位置检查
	
	*/
	if(!objWorkFlowDic.Exists(objStatus.RowID))//检查1
	{
		window.alert(t["NotInFlow"]);
		return false;		
	}
	objSavedStatus = objWorkFlowDic.Item(objStatus.RowID);
	if((objSavedStatus.IsEmergency == true) && (objCurrentFlow.IsEmergency == false))//检查2
	{
		window.alert(t["InEmergency"]);
		return false;
	}
	if((objSavedStatus.IsEmergency == false) && (objCurrentFlow.IsEmergency == false))//检查3
	{
		for(var i = 0; i < objWorkFlowList.length; i ++)
		{
			objItem = objWorkFlowList[i];
			if(objItem.RowID == objStatus.RowID)
				break;
		}	
		if(intCurrentFlowPos != (i + 1))
		{
			window.alert(t["CurrentStatus"] + objStatus.Description + "\n" + 
				t["ErrorWorkFlowPos"] + objCurrentFlow.Description + "!");
			return false;
		}
	}
	return true;	
}

//检查病案信息
function CheckMainStatus(obj)
{
			/*
			作为整份病案需要进行如下检查：
			1.只能进行突发事件
			2.找到这份病案
			3.检查状态IsStayIn，即是否在病案架上
			4.
			*/
	var objMainTmp = null;
	var objMain = null;
	var objVol = null;
	var objHis = null;
	var objStatus = null;
	var objCurrWorkItem = null;
	if(!objCurrentFlow.IsEmergency)
	{
		window.alert(t["WorkFlowError"]);//整份病案只能有突发工作流程，不能进行顺序工作流
		return false;
	}
	objMain = GetDHCWMRMainByID("MethodGetMrMain", obj.RowID);
	if(objMain == null)//是否找到这份病案
	{
		window.alert(t["NoMr"]);
		return false;
	}
	if(objMain.MrType != getElementValue("MrType"))//病案类型是否符合
	{
		window.alert(t["MrTypeError"]);
		return false;
	}
	if(!objMain.IsStayIn)//检查是否在病案架上
	{
		window.alert(t["LendOut"]);
		return false;
	}
	objHis = 
		GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//获取病案基本信息(历史信息格式)	
	if(objHis == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	return true;
}


//检查病案卷信息
function CheckVolStatus(objVolMr)
{
	var objMain = null;
	var objVol = null;
	var objHis = null;
	var objStatus = null;
	var objCurrWorkItem = null;

	objMain = GetDHCWMRMainByID("MethodGetMrMain", objVolMr.Parref);//找到主信息
	if(objMain == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	if(objMain.MrType != getElementValue("MrType"))//病案类型是否符合
	{
		window.alert(t["MrTypeError"]);
		return false;
	}
	objHis = 
		GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//获取病案基本信息(历史信息格式)	
	if(objHis == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	objVol = GetDHCWMRMainVolumeByID("MethodGetMainVolume", objVolMr.Parref, objVolMr.ChildSub)//获取卷信息
	objVol.Parref = objVolMr.Parref;
	objVol.ChildSub = objVolMr.ChildSub;
	objVol.RowID = objVolMr.RowID;
	if(objVol == null)
	{
		window.alert(t["NoVolume"]);
		return false;
	}
	if(!objVol.InFlow)//检查病案卷是否在工作流中，还是已经完成
	{
		window.alert(t["FlowComplete"]);
		return false;
	}
	objCurrWorkItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", objVol.Status_Dr);//获取当前卷的状态
	if(objCurrWorkItem == null)
	{
		window.alert(t["NoWorkItem"]);
		return false;
	}
	if(!CheckWorkStatus(objCurrWorkItem))//检查状态
		return false;
		
	return true;
}

//*********************************************************************


//显示病案信息
//参数：
//objBarCode:条码信息
function DisplayMrInfo(objBarCode)
{

	var objMain = null;
	var objVol = null;
	var objHis = null;
	var objStatus = null;
	var objCurrWorkItem = null;
	

	switch(objBarCode.Type)
	{
		case "1":
			/*
			作为整份病案需要进行如下检查：
			1.只能进行突发事件
			2.找到这份病案
			3.检查状态IsStayIn，即是否在病案架上
			4.
			*/
			if(!objCurrentFlow.IsEmergency)
			{
				window.alert(t["WorkFlowError"]);//整份病案只能有突发工作流程，不能进行顺序工作流
				return;
			}
			objMain = GetDHCWMRMainByID("MethodGetMrMain", objBarCode.RowID);
			if(objMain == null)//是否找到这份病案
			{
				window.alert(t["NoMr"]);
				return;
			}
			if(objMain.MrType != getElementValue("MrType"))//病案类型是否符合
			{
				window.alert(t["MrTypeError"]);
				return;
			}
			if(!objMain.IsStayIn)//检查是否在病案架上
			{
				window.alert(t["LendOut"]);
				return;
			}
			objHis = 
				GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//获取病案基本信息(历史信息格式)	
			if(objHis == null)
			{
				window.alert(t["NoMr"]);
				return;
			}			
			if(!objMainList.Exists(objMain.RowID))
			{
				objMain.History = objHis;//将基本信息挂到主信息下
				objMainList.Add(objMain.RowID, objMain);
				AddListItem("LstVols", 
					Trim(objMain.MRNO) + "     " + Trim(objHis.PatientName) + "     (完整病案)",
					objMain.RowID);
			}
			else
			{
				window.alert(t["MrExist"]);
			}	
			
			break;
		case "2":
			objMain = GetDHCWMRMainByID("MethodGetMrMain", objBarCode.Parref);//找到主信息
			if(objMain == null)
			{
				window.alert(t["NoMr"]);
				return;
			}
			if(objMain.MrType != getElementValue("MrType"))//病案类型是否符合
			{
				window.alert(t["MrTypeError"]);
				return;
			}
			objHis = 
				GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//获取病案基本信息(历史信息格式)	
			if(objHis == null)
			{
				window.alert(t["NoMr"]);
				return;
			}
			objVol = GetDHCWMRMainVolumeByID("MethodGetMainVolume", objBarCode.Parref, objBarCode.ChildSub)//获取卷信息
			objVol.Parref = objBarCode.Parref;
			objVol.ChildSub = objBarCode.ChildSub;
			objVol.RowID = objBarCode.RowID;
			if(objVol == null)
			{
				window.alert(t["NoVolume"]);
				return;
			}
			if(!objVol.InFlow)//检查病案卷是否在工作流中，还是已经完成
			{
				window.alert(t["FlowComplete"]);
				return;
			}
			objCurrWorkItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", objVol.Status_Dr);//获取当前卷的状态
			if(objCurrWorkItem == null)
			{
				window.alert(t["NoWorkItem"]);
				return;
			}
			if(!CheckWorkStatus(objCurrWorkItem))//检查状态
				return;
			if(!objVolList.Exists(objMain.RowID))
			{
				objMain.History = objHis;//将基本信息挂到主信息下
				objMain.Volume = objVol;//将卷信息挂到主信息下
				objVolList.Add(objMain.RowID, objMain);
				AddListItem("LstVols", 
					Trim(objMain.MRNO) + "     " + Trim(objHis.PatientName) + "     (病案卷)",
					objMain.RowID);
			}
			else
			{
				window.alert(t["MrExist"]);
			}	
			break;
		default:
			//window.alert(t["BarCodeError"]);
			break;
	}

}

//保存附加信息列表
//pos:在列表中的位置
//flag:1-mainStatus 2-volStatus
function SaveStatusToObject(pos , flag)
{
	var obj = null;
	var objMr = null;	
	var objItm = null;
	var objLst = document.getElementById("LstVols");
	objItm = objLst.options.item(pos);
	if(flag == 1)
	{
		obj = DHCWMRMainStatus();
		objMr = objMainList.Item(objItm.value);
		obj.Parref = objMr.RowID;
	}
	else
	{
		obj = DHCWMRVolStatus();
		objMr = objVolList.Item(objItm.value);
		obj.Parref = objMr.Volume.RowID;
	}
	obj.Status_Dr = objCurrentFlow.RowID;
	obj.UserFromDr = session['LOGON.USERID'];
	return obj;
}
//保存附加信息列表
//1-mainStatus 2-volStatus
function SaveStatusDetailToObject(flag)
{
	var arry = new Array();
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
}



//保存 
function SaveInfo()
{
	var objList = document.getElementById("LstVols");
	var objItem = null;
	var obj = null;
	var objStatus = null;
	var objStatusDetailList = null;
	var returnValue = false;
	var arrySuccess = new Array();
	for(var i = 0; i < objList.options.length; i ++)
	{
		objItem = objList.options.item(i);
		switch(GetArryItem(objItem.innerText, "     ", 2))
		{
			case "(完整病案)":
				obj = objMainList[objItem.value];
				if(!CheckMainStatus(obj))
					continue;
				objStatus = SaveStatusToObject(i, 1);
				objStatusDetailList = SaveStatusDetailToObject(1);
				returnValue = SaveWorkDetail("MethodSaveWorkDetail", 
					SerializeDHCWMRMainStatus(objStatus),
					SerializeDHCWMRMainStatusDtlArry(objStatusDetailList),
					"","");
				break;
			case "(病案卷)":
				obj = objVolList[objItem.value];
				if(!CheckMainStatus(obj))
					continue;
				objStatus = SaveStatusToObject(i, 2);
				objStatusDetailList = SaveStatusDetailToObject(2);				
				returnValue = SaveWorkDetail("MethodSaveWorkDetail", 
					"","",
					SerializeDHCWMRVolStatus(objStatus),
					SerializeDHCWMRVolStatusDtlArry(objStatusDetailList));
				break;
			default:
				window.alert(GetArryItem(objItem.innerText, "     ", 2));
		}
		if(returnValue)
		{
			arrySuccess.push(objItem.value);
		}
	}
	if(arrySuccess.length == objList.options.length)
		return true;
	else
		return false;
}

//处理按键事件
function txtVolRowIDOnKeyDown()
{
	var objBarCode = null;
	if(window.event.keyCode != 13)
		return;
	if(getElementValue("txtVolRowID") == "")
		return;
	try
	{
		objBarCode = DHCWMRBarCode(getElementValue("txtVolRowID"));
		DisplayMrInfo(objBarCode);
	}
	catch(err)
	{
		window.alert(t["BarCodeError"]);
	}
	setElementValue("txtVolRowID", "");
}

function cboWorkFlowItemSelected()
{
	var link = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.WorkDetail";
	if(window.event != null)
	{
		if(window.event.propertyName != "value")
			return;
	}
	objCurrentFlow = objWorkFlowDic.Item(getElementValue("cboWorkFlowItem"));//更该当前操作状态
	link += "&MainStatusRowid=" +
			"&VolStatusRowid=" + 
			"&WorkItemRowid=" + getElementValue("cboWorkFlowItem") +
			"&IsEdit=" + "Y" +
			"&StatusFrom=" + 
			"&StatusTo=" + 
			"&ValidateUser=" + "N" + 
			"&MainRowid=" + 
			"&VolRowid=";
	parent.frames[1].location.href = link;
}

function cmdSaveOnClick()
{
	if(SaveInfo())
	{
		window.alert(t["SaveOK"]);
	}
	else
	{
		window.alert(t["SaveFail"]);
	}
}

function cmdRemoveOnClick()
{
	var objList = null;
	var objItem = null;
	if(Trim(getElementValue("LstVols")) == "")
	{
		window.alert(t["SelectOneEntry"]);
		return;
	}
	objList = document.getElementById("lstVols")
	objItem = objList.options[objList.selectedIndex];
	switch(GetArryItem(objItem.innerText, "     ", 2))
	{
		case "(完整病案)":
			objMainList.Remove(objItem.value);
			break;
		case "(病案卷)":
			objVolList.Remove(objItem.value);
			break;
	}
	RemoveListItem("lstVols");
}

function cmdRemoveAllOnClick()
{
	objMainList.RemoveAll();
	objVolList.RemoveAll();
	ClearListBox("lstVols");
}

function InitForm()
{

	var strMrType = GetParam(parent, "MrType");
	if(strMrType != "")
	{
		setElementValue("MrType", strMrType);
	}
	else
	{
		window.alert("MrTypeError");
		return;
	}
	MakeComboBox("cboWorkFlowItem");
	var objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", getElementValue("MrType"));
	if(objMrType != null)
	{
		setElementValue("lblMrType", objMrType.Description);
		InitWorkFlow();
	}
	else
	{
		window.alert(t["MrTypeError"]);
	}
}


function InitEvents()
{
	document.getElementById("txtVolRowID").onkeydown = txtVolRowIDOnKeyDown;
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
	document.getElementById("cboWorkFlowItem").onpropertychange = cboWorkFlowItemSelected; 
	document.getElementById("cmdRemove").onclick = cmdRemoveOnClick;
	document.getElementById("cmdRemoveAll").onclick = cmdRemoveAllOnClick;
}

InitForm();
InitEvents();
//window.alert("AAA");