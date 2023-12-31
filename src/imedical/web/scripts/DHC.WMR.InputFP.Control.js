
//Front page input control

var strSave = "";
var strPleaseInputMrNoAndVol = "";
var strSaveFail = "";

var strMrType = "";//GetParam(window,"MrType");//"7";
var strVolRowID = GetParam(window,"VolId");
var strDisplayOnly = GetParam(window,"DisplayOnly");


//var dicVol = new ActiveXObject("Scripting.Dictionary");
var objCurrentFPMain = null;//FP Main
//var strCurrentVolumeID = "";
var strDelstr = "";
var strWorkFlowItem = ""; //If Current Flow Is not strWorkFlowItem, validation will not passed
var strCurrWorkFlow = ""; //Current work flow (Passed by parameter)


var objTabs = null;  //tab for all control;
var objExtraTab = null;
var objDisTab = null;
var objOpeTab = null;
var objBaseInfo = null;
var btnSave = null;

var objHospital = null;
var flag="";
var LeadingFactor = "" ;//主导因素

function initControl()
{
	strMrType = document.getElementById("MrType").value;
	LeadingFactor =document.getElementById("LeadingFactor").value;//主导因素
	objHospital=GetcurrHospital("MethodGetCurrHospital"); //Get Hostpial Setting Add By LiYang 2008-08-29
	flag=GetParam(window,"flag"); 	//add by liuxuefeng 2009-03-09
	if (flag=="view") {
		document.getElementById("Condition").style.display='none';
	}else{
		document.getElementById("txtMrNo").focus();
	}
	//Add By LiYang 2009-3-17 Fix Problem: Ext always connect to ext web site to download image.
	Ext.BLANK_IMAGE_URL = '../scripts/css/ExtCss/images/default/s.gif';
	//Add By LiYang 2009-11-08 hide scroll bar 
	document.body.scroll = "no";
	
	strSave = t["strSave"];
	strPleaseInputMrNoAndVol = t["strPleaseInputMrNoAndVol"];
	strSaveFail = t["strSaveFail"];
	btnSave = new Ext.Button({text:strSave, handler:btnSaveOnClick});
	InitBaseInfo();
	InitExtra();
	InitDiseaseGrid();
	InitOperationGrid();
	InitCondition();//add 2010-09-10
	InitWorkFlow();
	// 
	var tab = new Ext.TabPanel({
	        renderTo: 'MainPanel',
	        width:1000,
	        height:580,
	        activeTab: 0,
	        frame:true,
	        buttons:[btnSave]
	});
   
	objBaseInfo = tab.add(frmBaseInfo);
	objBaseInfo.setTitle(strBaseFromTitle); 
	objExtraTab = tab.add(frmExtra);
	objExtraTab.setTitle(strSummaryGridTitle);
	objDisTab = tab.add(frmDisease);
	objDisTab.setTitle(strDiseaseGridTitle);
	objOpeTab = tab.add(frmOperation);
	objOpeTab.setTitle(strOperationGridTitle);  
	
	tab.activate(frmBaseInfo);
	objTabs = tab; 

	/*objTabs =  new Ext.TabPanel({
		renderTo: 'MainPanel',
		width:800,
		activeTab: 0,
		frame:true,
		defaults:{autoHeight: true},
		items:[
			//{items:[frmExtra], title: strSummaryGridTitle}//,
			{items:[frmExtra], title: strSummaryGridTitle},
			{items:[frmDisease], title: strDiseaseGridTitle}//,
			// {items:[frmOperation], title: strOperationGridTitle}
		]
	});
	a();
	*/
	
	for(var i = 3; i >= 0; i --)
	{
		tab.setActiveTab(i);
	}
	
	
	if(strVolRowID != "")
	{
		document.DisplayInfo(strVolRowID);
		window.scrollTo(0, 0);
	}
	if(strDisplayOnly.toLowerCase() == "yes")
	{
		btnSave.hide();
	}
}

document.DisplayInfo = function(strVolID)
{
    var objVolume = null;
    if(strVolID == "")
        return;
    //if(!dicVol.Exists(strVolID))
    //    return;
    //objVolume = dicVol.Item(strVolID); 
    strVolRowID = strVolID;
    var objInfo = GetDHCWMRVolInfoByVolumeID("MethodGetDHCWMRVolInfoByVolumeID", strVolID);
    var objVolume = GetDHCWMRMainVolumeByID("MethodGetDHCWMRMainVolumeByID", strVolID);
    //var objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVolume.Paadm_Dr);
    var objAdm = null;
    if (objVolume.Paadm_Dr != "")
    {
    	objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVolume.Paadm_Dr);
    	DisplayPatientAdmitInformation(objAdm);
    }
    else
    {
    	objAdm = GetDHCWMRHistoryAdmByID("MethodGetDHCWMRHistoryAdmByID", objVolume.HistroyAdm_Dr);
    	DisplayPatientHistoryAdmitInformation(objAdm);
    }
    var objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", objVolume.Main_Dr);
    var objPatient = null;
    var arryPaadm = GetVolumeAdmList("MethodGetVolumeAdmList", strVolID);
    
    
    //---CheckVolumeStatus
		if((strWorkFlowItem != "") && (objVolume.Status_Dr != strWorkFlowItem))
		{
			window.alert(t["FlowError"]);	
			return;
		}
		//
    
    
    
    ClearOperationList();
    ClearDiseaseList();
    ClearExtraControlList();
    ClearOperationTableInputControl(false);
    ClearDiseaseTableInputControl();
    objPatient = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", objMain.RowID);
    /*if(objMain.Papmi_Dr != "")    
    {
    	objPatient = GetPatientByID("MethodGetPatientByID", objMain.Papmi_Dr);
    }
    else
    {
    	objPatient = GetDHCWMRHistoryByID("MethodGetDHCWMRHistoryByID", objMain.History_DR);
    	
    }*/
    DisplayPatientBaseInformation(objInfo, objMain, objPatient);
    if(objInfo != null)
    {
        DisplayPatientBaseInformation(objInfo, objMain, objPatient);//defined in DHC.WMR.InputFP.BaseInfo.JS
        DisplayPatientAdmitInformation(objAdm);
        for(var i = 0; i < arryPaadm.length; i ++)
        {
		if(arryPaadm[i] == "")
			continue;
		DisplayHISDiagnose(arryPaadm[i]);
		DisplayHISOperation(arryPaadm[i]);
        }
    }
    DisplayFrontPageInfo(strVolID);
    //strCurrentVolumeID = strVolID;
    objTabs.activate(objBaseInfo); 
    btnNextPage.focus(); 
}


function DisplayFrontPageInfo(ID)
{
	objCurrentFPMain = GetFrontPageInfo("MethodGetFrontPageInfo", ID);
	strDelstr = "";  
	if(objCurrentFPMain != null){
		DisplayDiseaseList(objCurrentFPMain.ICDList);
		DisplayOperationList(objCurrentFPMain.ICDList);
		DisplayExtraInfo(objCurrentFPMain.ExtraList);
	}else{
		LoadTemplate();
	}
}


function ValidateContents()
{
    //var strVolumeID = getElementValue("cboVolume");
    var MainDiagnoseCode="";													//add by liuxuefeng 2010-06-17 记录主要诊断代码
    if(strVolRowID == "")
    {
        window.alert(strPleaseInputMrNoAndVol);
        return false;
    } 
    //Modified By LiYang 2009-3-2 Ensure Main Diagnose can not be empty
    var objStore = objGridDisease.getStore();
    var objData = null;
    var intCnt = 0;
    for(var i = 0; i < objStore.getCount(); i ++)
    {
    	objData = objStore.getAt(i);
    	if(objData.get("RelatedDiagnoseType").Code=='1')
    	{
    		MainDiagnoseCode=objData.get("ICDCode");			//add by liuxuefeng 2010-06-17 记录主要诊断代码
    		//alert("MainDiagnoseCode="+MainDiagnoseCode);
    		intCnt ++;
    	}
    }
    if (intCnt == 0)
    {
    	Ext.MessageBox.show({title: strNoticeTitle, msg: t["MainDiagnoseRequired"], buttons: Ext.MessageBox.OK});  
    	return false;
    }
    
    var objDisease = GetDiseaseList();
    var MainDiseas=0;
    var InHosDiseas=0;
    var ErrInfo="";
    for(var i = 0; i < objDisease.length; i ++)
    {
        obj = objDisease[i];
        if ((obj.ICDDr=="")||(obj.FPICDType=="")||(obj.ItemTypeDr==""))
        {
        	alert(t['ErrDiagContent']);
        	return false;
        }
        
        var objFPICDType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID",obj.FPICDType);
        if (((objFPICDType.Code=="1")||(objFPICDType.Code=="2"))&&(obj.Result==""))
        {
        	alert("主要诊断和其他诊断,出院情况不能为空!");
        	return false;
        }
        
				if (objFPICDType.Code=="1"){MainDiseas=MainDiseas+1;}
				//if (objFPICDType.Code=="7"){InHosDiseas=InHosDiseas+1;}
    }
    //if (MainDiseas<1){ErrInfo=ErrInfo+t["strMainDiseasErr"];}
    //if (InHosDiseas<1){ErrInfo=ErrInfo+t["strInHospDiseasErr"];}
    //if ((MainDiseas<1)||(InHosDiseas<1))
    if (MainDiseas<1)
    {
			alert("请录入主要诊断!");
			return false;
		}

    
    var objOperation = GetOperationList();
    for(var i = 0; i < objOperation.length; i ++)
    {
        obj = objOperation[i];
        //modify by liuxuefeng 只有当类型为"手术"时,才进行判断
        //alert(obj.FPICDType);
        if ((obj.FPICDType==110)&&((obj.ICDDr=="")||(obj.Operator=="")||(obj.OperationDate=="")||(obj.FPICDType=="")||(obj.ItemTypeDr=="")))
        {
        	alert("手术信息必须录入手术编码、手术日期和术者!");
        	return false;
        }
        
        var objFPICDType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID",obj.FPICDType);
        
        //下面这点代码貌似不起作用，objFPICDType.Code不为O，为1
        if ((objFPICDType.Code=="O")&&((obj.AssistantDr1=="")||(obj.NarcosisType=="")||(obj.NarcosisDoctorDr=="")||(obj.CloseUp=="")))
        {
        	alert(t['ErrOperContent']);
        	return false;
        }
        
	    //add by liuxuefeng 2010-04-28 麻醉方式不为空或者不为“无”，必须有麻醉医师
	    if ((cboNarcosisType.getRawValue()!="")&&(cboNarcosisType.getRawValue()!="无"))
	    {
				if((cboNarcosisDoctor.getValue()=="")||(cboNarcosisDoctor.getRawValue()==""))
				{
					alert("麻醉方式不为空或者不为“无”,必须有麻醉医师!");
					return false;
				}
	    }
    }  
    
    var MianDiagCheckFlg="";	//add by liuxuefeng 2010-06-17 妇产医院检查附加项目
    //add by zf 20090508 妇产医院校验
    if (objHospital.MyHospitalCode=="BeiJing_FC"){
			var objFPDiseas=GetDiseaseList();
			var MainDiseas=0;
			var InHosDiseas=0;
			var ErrInfo="";
			
			for(var i=0;i<objFPDiseas.length;i++)
			{
				var obj = objFPDiseas[i];
				if (obj.FPICDType=="105"){//BeiJing FC : Main Diagnose Type Rowid=105
					MainDiseas=MainDiseas+1;
					}         
				if (obj.FPICDType=="255"){InHosDiseas=InHosDiseas+1;}       //BeiJing FC : In Diagnose Type Rowid=255
			}
			if (MainDiseas<1){ErrInfo="请录入主要诊断!";}
			if (InHosDiseas<1){ErrInfo=ErrInfo+"请录入入院诊断!";}
			if (ErrInfo!=="")
			{
				alert(ErrInfo);
				return false;
			}
			//add by liuxuefeng 2010-06-17 妇产医院检查附加项目
			MianDiagCheckFlg =tkMakeServerCall("web.DHCWMRQuality.BOACRExpFunction","CheckMainDiagCode",MainDiagnoseCode);
			//alert("MianDiagCheckFlg="+MianDiagCheckFlg);
			if(MianDiagCheckFlg=="Y"){
					var objExtra = GetExtraList();
					for(var i=0;i<objExtra.length;i++)
					{
						var obj=objExtra[i];
						var ItemId=obj.ItemId;
						var ItemValue=obj.ItemValue;
						//alert("ItemId="+ItemId+";ItemValue='"+ItemValue+"'");
						if(((ItemId=="1")||(ItemId=="2"))&&(ItemValue=="")) {
								alert("主要诊断编码以C或D开头时，病理分化程度、最高诊断依据不能为空!");
								return false;
						}
					}
				}
    }
    
    //Add By LiYang 2009-12-07
    if(objHospital.MyHospitalCode == "WeiFang_RMYY"||"BeiJing_FC")
    {
	    var objDisStore = objGridDisease.getStore(); 
	    var objDic = null;
	    var itm = null;
	    var DPFlag = false;
	    var ICDFlag= false;   
	    var PAFlag= false; //add by liuxuefeng 2010-06-24 病理诊断标志 	Pathology Diagnose
    	for(var i = 0; i < objDisStore.getCount(); i ++)
    	{
    		itm = objDisStore.getAt(i);
    		objDic = itm.get("RelatedDiagnoseType");
    		if (objDic.Code == "5")
    			DPFlag = true;
    		if ((objDic.Code == "1")&&((itm.get("ICDCode").indexOf("S") > -1) ||(itm.get("ICDCode").indexOf("T") > -1)))
    			ICDFlag = true;
    		//add by liuxuefeng 2010-06-24 病理诊断标志 	Pathology Diagnose
    		if (objDic.Code == "4")
    			PAFlag = true;
    	}
    	if ((ICDFlag == true)&&(DPFlag == false))
    	{
    		window.alert("主要诊断编码以S或T开头,请录入损伤中毒诊断!");
    		return false;
    	}
    	//add by liuxuefeng 2010-06-24 病理诊断标志 	Pathology Diagnose
    	//alert("MianDiagCheckFlg="+MianDiagCheckFlg+";PAFlag="+PAFlag)
    	if ((MianDiagCheckFlg == "Y")&&(PAFlag == false))
    	{
    		window.alert("主要诊断编码以C或D开头时, 疾病信息必须录入病理诊断!");
    		return false;
    	}
    }
    
    
    return true;
}

function SaveToObject()
{
    var objDisease = GetDiseaseList();
    var objOperation = GetOperationList(); 
    var objExtra = GetExtraList();
    var strDel = strDelstr.toString(); 
   var strExtra = ""; 
    var objMain = null;
    var strTmp = ""; 
    var obj = null;  
    if(objCurrentFPMain == null) 
    {
        objMain = DHCWMRFrontPage();
        objMain.VolumeDr = strVolRowID;
        objMain.ResumeText = "";
        objMain.RepUserDr = session['LOGON.USERID'];
    }
    else
    {
        objMain =  objCurrentFPMain;
    } 
    var strMain = SerializeDHCWMRFrontPage(objMain);
    var strICD = "";
    var strOperation = "";
    for(var i = 0; i < objDisease.length; i ++)
    {
        obj = objDisease[i];
        strTmp = SerializeDHCWMRFPICD(obj);
        if(strTmp != "")
        {
            strICD += strTmp + CHR_1;
        }
    }
     for(var i = 0; i < objOperation.length; i ++)
    {
        obj = objOperation[i];
        strTmp = SerializeDHCWMRFPICD(obj);
        if(strTmp != "")
        {
            strICD += strTmp + CHR_1;
        }
    }  
    
    for(var i = 0; i < objExtra.length; i ++)
    {
    	obj = objExtra[i];
    	strTmp = SerializeDHCWMRFPExtra(objExtra[i]);
      if(strTmp != "")
      {
            strExtra += strTmp + CHR_1;
      }
    }
    var ret = SaveFrontPageInfo("MethodSaveFrontPageInfo", strDel, strMain, strICD.toString(), strExtra);
    if(ret > 0)
    {
    		if((strMrType != "") && (strCurrWorkFlow != "")) //Bug!!!! Modified By LiYang 2008-09-01  Both MrType AND WorkItem RowID must be not null
    		{
    			var objStatus = {
    				Parref:strVolRowID,
    				ChildSub:"",
    				Status_Dr:strCurrWorkFlow,
    				UserFromDr:session['LOGON.USERID'],
    				CurrDate:"",
    				CurrTime:"",
    				UserToDr:""
    				};
    			ret = SaveWorkDetail("MethodSaveWorkDetail", 
						"1", 
						strCurrWorkFlow, 
						"",
						strVolRowID,
						SerializeDHCWMRVolStatus(objStatus),
						"",
						"");
    		}
    	  if(flag==""){										//add by liuxuefeng 2009-03-09
		        ClearDiseaseList();
		        ClearOperationList();
		        ClearExtraControlList();
		        ClearPatientBaseInformation();
		        objTabs.activate(objBaseInfo); 
			      ClearListBox("cboVolume") //add by liuxuefeng 2009-03-09
		    		btnNextPage.focus(); 
		    		if(GetParam(window,"VolId")!="")
		    			window.close();
		    		else
		    		{
		    			document.getElementById("txtMrNo").focus();
		    			document.getElementById("txtMrNo").value = "";
		    		}
    	  }	else if(flag=="view")												//add by liuxuefeng 2009-03-09
    	  {
    	  	  alert("保存成功!");
    	  }
    }
    else
    {
        window.alert(strSaveFail + "\n  ErrorCode:" + ret); 
    }  
}

function btnSaveOnClick()
{
    if(!ValidateContents())
        return;
    SaveToObject(); 
}

function InitWorkFlow()
{
	var objWorkTypeDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetWorkType", "WorkType", "Y");
	var strCurrSelWorkItemID = "";
	//modify by liuxuefeng 2010-02-12
	strCurrSelWorkItemID = GetParam(window, "WorkItem");
	//alert("MrType="+strMrType+";WorkItem="+strCurrSelWorkItemID);
	if((strMrType == "") || (strCurrSelWorkItemID == ""))
		return;
	strCurrWorkFlow = strCurrSelWorkItemID;
	var objFlow = GetDHCWMRWorkFlowByTypeFlag("MethodGetWorkFlow", strMrType, "Y");
	var objItm = null; //workflow item
	var objDetail = null;//workflow detail
	var objDic = null;
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
		if(strCurrSelWorkItemID == objItm.Item_Dr)
		{
			strWorkFlowItem = arryItems[i - 1].Item_Dr;
			break;	
		}	
	}	
}

function BodyEventHandler()
{
	initControl();
	
	
	//Add By LiYang 2013-12-01
	//window.alert();
	var objTxt = document.getElementById(cboDiseaseICD.getId());
	objTxt.ondblclick = function()
	{
			ShowICDDir("000001006",
				function(objResult){
					//debugger;
					var objRec = new Ext.data.Record({
							id : objResult.RowID,
							code : objResult.Code,
							desc : objResult.Description,
							alias : ''
						});
					cboDiseaseICD.store.removeAll();
					cboDiseaseICD.store.add([objRec]);
					cboDiseaseICD.setValue(objResult.RowID);
					cboDiseaseICD.focus()
				}
			)
	}
	
  objTxt = document.getElementById(cboOperationICD.getId());
	objTxt.ondblclick = function()
	{
			ShowICDDir("000001008",
				function(objResult){
					//debugger;
					var objRec = new Ext.data.Record({
							id : objResult.RowID,
							code : objResult.Code,
							desc : objResult.Description,
							alias : ''
						});
					cboOperationICD.store.removeAll();
					cboOperationICD.store.add([objRec]);
					cboOperationICD.setValue(objResult.RowID);
					cboOperationICD.focus();
				}
			)
	}
	
}
