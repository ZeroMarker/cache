/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkFlow.Run.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-7

COMMENT: ������ӦDHC.WMR.WorkFlow.Run���¼�

============================================================================ */
var objWorkFlowDic = new ActiveXObject("Scripting.Dictionary"); //���湤�����ֵ�
var objWorkFlowList = new Array(); //���湤�����б�

var objMainList = new ActiveXObject("Scripting.Dictionary");
var objVolList = new ActiveXObject("Scripting.Dictionary");

var objCurrentFlow = null; //��ǰѡ��Ĺ�������
var intCurrentFlowPos = -1;//��ǰѡ�����������λ�ã������ͻ�����̣�����-1


function InitWorkFlow()
{
	var objWorkTypeDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetWorkType", "WorkType", "Y");//��ȡ������Ŀ���ͣ�˳��/ͻ����
	var objFlow = GetDHCWMRWorkFlowByTypeFlag("MethodGetWorkFlow", getElementValue("MrType"), "Y");
	var objItm = null; //������������
	var objDetail = null;//���������ݵ���ϸ
	var objDic = null;
	var strEmergencyRowID = ""; //ͻ���¼��ֵ�RowID;
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
			objDetail.IsEmergency = false;//ע����˳������
		}
		objWorkFlowList[i] = objDetail;
		objWorkFlowDic.Add(objDetail.RowID,  objDetail);		
	}	
	for(var i = 0; i < objWorkTypeDic.length; i ++)
	{
		objDic = objWorkTypeDic[i];
		//window.alert(objDic.Description);
		if(objDic.Description.indexOf("ͻ��") > -1)
		{
			strEmergencyRowID = objDic.RowID;
			arryEm = GetDHCWMRWorkItemByTypeFlag("MethodGetEmergeWorkItem", strEmergencyRowID, "Y");
			for(var j = 0; j < arryEm.length; j ++)
			{
				objDetail = arryEm[j];
				//window.alert(objDetail.Description);
				if(HasPower("MethodUserFunction", session["LOGON.GROUPID"], objDetail.Description))
				{
					AddListItem("cboWorkFlowItem", objDetail.Description + "(ͻ��)", objDetail.RowID);
					objDetail.IsEmergency = true;//ע����ͻ��������
				}
				objWorkFlowDic.Add(objDetail.RowID,  objDetail);				
			}
		}
	}
	cboWorkFlowItemSelected();
}

/***********************************************************

//��鹤����
//������
//objStatus:��ǰ���״̬
//����ֵ��������Խ��뵱ǰѡ��Ĺ�����������True���򷵻�False
//���ĳ����Ĺ�����״̬*/
function CheckWorkStatus(objStatus)
{
	var objItem = null;
	var objSavedStatus = null;
	
	/*�����Ŀ��
	1.�����Ĺ�����Ŀ�Ƿ��ڵ�ǰ�Ĺ������У�����˳��ͻ����
	2.����Ƿ񽫴���ͻ���¼��ľ�ֱ�ӽ���˳������
	3.��������λ�ü��
	
	*/
	if(!objWorkFlowDic.Exists(objStatus.RowID))//���1
	{
		window.alert(t["NotInFlow"]);
		return false;		
	}
	objSavedStatus = objWorkFlowDic.Item(objStatus.RowID);
	if((objSavedStatus.IsEmergency == true) && (objCurrentFlow.IsEmergency == false))//���2
	{
		window.alert(t["InEmergency"]);
		return false;
	}
	if((objSavedStatus.IsEmergency == false) && (objCurrentFlow.IsEmergency == false))//���3
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

//��鲡����Ϣ
function CheckMainStatus(obj)
{
			/*
			��Ϊ���ݲ�����Ҫ�������¼�飺
			1.ֻ�ܽ���ͻ���¼�
			2.�ҵ���ݲ���
			3.���״̬IsStayIn�����Ƿ��ڲ�������
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
		window.alert(t["WorkFlowError"]);//���ݲ���ֻ����ͻ���������̣����ܽ���˳������
		return false;
	}
	objMain = GetDHCWMRMainByID("MethodGetMrMain", obj.RowID);
	if(objMain == null)//�Ƿ��ҵ���ݲ���
	{
		window.alert(t["NoMr"]);
		return false;
	}
	if(objMain.MrType != getElementValue("MrType"))//���������Ƿ����
	{
		window.alert(t["MrTypeError"]);
		return false;
	}
	if(!objMain.IsStayIn)//����Ƿ��ڲ�������
	{
		window.alert(t["LendOut"]);
		return false;
	}
	objHis = 
		GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//��ȡ����������Ϣ(��ʷ��Ϣ��ʽ)	
	if(objHis == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	return true;
}


//��鲡������Ϣ
function CheckVolStatus(objVolMr)
{
	var objMain = null;
	var objVol = null;
	var objHis = null;
	var objStatus = null;
	var objCurrWorkItem = null;

	objMain = GetDHCWMRMainByID("MethodGetMrMain", objVolMr.Parref);//�ҵ�����Ϣ
	if(objMain == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	if(objMain.MrType != getElementValue("MrType"))//���������Ƿ����
	{
		window.alert(t["MrTypeError"]);
		return false;
	}
	objHis = 
		GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//��ȡ����������Ϣ(��ʷ��Ϣ��ʽ)	
	if(objHis == null)
	{
		window.alert(t["NoMr"]);
		return false;
	}
	objVol = GetDHCWMRMainVolumeByID("MethodGetMainVolume", objVolMr.Parref, objVolMr.ChildSub)//��ȡ����Ϣ
	objVol.Parref = objVolMr.Parref;
	objVol.ChildSub = objVolMr.ChildSub;
	objVol.RowID = objVolMr.RowID;
	if(objVol == null)
	{
		window.alert(t["NoVolume"]);
		return false;
	}
	if(!objVol.InFlow)//��鲡�����Ƿ��ڹ������У������Ѿ����
	{
		window.alert(t["FlowComplete"]);
		return false;
	}
	objCurrWorkItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", objVol.Status_Dr);//��ȡ��ǰ���״̬
	if(objCurrWorkItem == null)
	{
		window.alert(t["NoWorkItem"]);
		return false;
	}
	if(!CheckWorkStatus(objCurrWorkItem))//���״̬
		return false;
		
	return true;
}

//*********************************************************************


//��ʾ������Ϣ
//������
//objBarCode:������Ϣ
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
			��Ϊ���ݲ�����Ҫ�������¼�飺
			1.ֻ�ܽ���ͻ���¼�
			2.�ҵ���ݲ���
			3.���״̬IsStayIn�����Ƿ��ڲ�������
			4.
			*/
			if(!objCurrentFlow.IsEmergency)
			{
				window.alert(t["WorkFlowError"]);//���ݲ���ֻ����ͻ���������̣����ܽ���˳������
				return;
			}
			objMain = GetDHCWMRMainByID("MethodGetMrMain", objBarCode.RowID);
			if(objMain == null)//�Ƿ��ҵ���ݲ���
			{
				window.alert(t["NoMr"]);
				return;
			}
			if(objMain.MrType != getElementValue("MrType"))//���������Ƿ����
			{
				window.alert(t["MrTypeError"]);
				return;
			}
			if(!objMain.IsStayIn)//����Ƿ��ڲ�������
			{
				window.alert(t["LendOut"]);
				return;
			}
			objHis = 
				GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//��ȡ����������Ϣ(��ʷ��Ϣ��ʽ)	
			if(objHis == null)
			{
				window.alert(t["NoMr"]);
				return;
			}			
			if(!objMainList.Exists(objMain.RowID))
			{
				objMain.History = objHis;//��������Ϣ�ҵ�����Ϣ��
				objMainList.Add(objMain.RowID, objMain);
				AddListItem("LstVols", 
					Trim(objMain.MRNO) + "     " + Trim(objHis.PatientName) + "     (��������)",
					objMain.RowID);
			}
			else
			{
				window.alert(t["MrExist"]);
			}	
			
			break;
		case "2":
			objMain = GetDHCWMRMainByID("MethodGetMrMain", objBarCode.Parref);//�ҵ�����Ϣ
			if(objMain == null)
			{
				window.alert(t["NoMr"]);
				return;
			}
			if(objMain.MrType != getElementValue("MrType"))//���������Ƿ����
			{
				window.alert(t["MrTypeError"]);
				return;
			}
			objHis = 
				GetPatientInfoByMrRowID("MethodGetPatient", objMain.RowID);//��ȡ����������Ϣ(��ʷ��Ϣ��ʽ)	
			if(objHis == null)
			{
				window.alert(t["NoMr"]);
				return;
			}
			objVol = GetDHCWMRMainVolumeByID("MethodGetMainVolume", objBarCode.Parref, objBarCode.ChildSub)//��ȡ����Ϣ
			objVol.Parref = objBarCode.Parref;
			objVol.ChildSub = objBarCode.ChildSub;
			objVol.RowID = objBarCode.RowID;
			if(objVol == null)
			{
				window.alert(t["NoVolume"]);
				return;
			}
			if(!objVol.InFlow)//��鲡�����Ƿ��ڹ������У������Ѿ����
			{
				window.alert(t["FlowComplete"]);
				return;
			}
			objCurrWorkItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", objVol.Status_Dr);//��ȡ��ǰ���״̬
			if(objCurrWorkItem == null)
			{
				window.alert(t["NoWorkItem"]);
				return;
			}
			if(!CheckWorkStatus(objCurrWorkItem))//���״̬
				return;
			if(!objVolList.Exists(objMain.RowID))
			{
				objMain.History = objHis;//��������Ϣ�ҵ�����Ϣ��
				objMain.Volume = objVol;//������Ϣ�ҵ�����Ϣ��
				objVolList.Add(objMain.RowID, objMain);
				AddListItem("LstVols", 
					Trim(objMain.MRNO) + "     " + Trim(objHis.PatientName) + "     (������)",
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

//���渽����Ϣ�б�
//pos:���б��е�λ��
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
//���渽����Ϣ�б�
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



//���� 
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
			case "(��������)":
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
			case "(������)":
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

//�������¼�
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
	objCurrentFlow = objWorkFlowDic.Item(getElementValue("cboWorkFlowItem"));//���õ�ǰ����״̬
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
		case "(��������)":
			objMainList.Remove(objItem.value);
			break;
		case "(������)":
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