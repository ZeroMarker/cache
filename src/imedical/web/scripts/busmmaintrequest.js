var tableList=new Array();
var tEvaluate=new Array();
var CurApproveFlowID="";
var FromDeptStr=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503014")
var MaintModeIDs=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503005")	//add by zc0125 2022-11-14 获取自修ID串
//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);

function initDocument()
{
	initUserInfo();
	initMessage("Maint");
	initPage();			//放大镜及按钮初始化
	initMRSourceTypeData();
	var AssignDate=getElementValue("MRAssignDate");
	//Modefied by zc 2022-4-8 begin
	hiddenObj("RetrieveInfo",1)
	hiddenObj("ReturnInfo",1)
	$("#MRRetrieveFlag").checkbox({
		onCheckChange:function(){
			if(this.checked){
				if (FromDeptStr=="")
				{
					hiddenObj("RetrieveInfo",1)
				}
				else
				{
					hiddenObj("RetrieveInfo",0)
				}
			}
			else{
				hiddenObj("RetrieveInfo",1)
			}
		}
	})
	$("#EmergencyFlag").checkbox({
		onCheckChange:function(){
			if(this.checked){
				setElement("MREmergencyLevelDR",2);
			}
			else{
				setElement("MREmergencyLevelDR","");
			}
		}
	})
	//Modefied by zc 2022-4-8 begin
	//刷新数据
	fillData()
	totalFee_Change()
	//按钮控制
	setEnabled()
	initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"),getElementValue("Action"));
	setElementEnabled();
	initApproveButton();
	initButtonWidth(); //初始化按钮宽度
	muilt_Tab()  //add by lmm 2020-06-29 回车下一输入框
	var HiddenCostAllot=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503007")		//modified by czf 1251797 begin
	if ((HiddenCostAllot==0)||(HiddenCostAllot==""))
	{
		hiddenTab("tMaintTabs","tCostAllot");		//modified by czf 1251797 end
	}
	//Modefied by zc 2022-4-8 begin'
	var EmergencyFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503010")
	if (EmergencyFlag=="0")
	{
		hiddenObj("cEmergencyFlag",1)	//add by ZY0308 20220725  2786508
		hiddenObj("EmergencyInfo",1)
	}
	var RetrieveInfo=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503013")//modified by zyq begin 2022-10-09
	if (RetrieveInfo=="0")
	{
		hiddenObj("cMRRetrieveFlag",1)
		hiddenObj("RetrieveFlag",1)
	}
	var ReplayInfo=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503011")
	if (ReplayInfo=="0")
	{
		hiddenObj("cMRReplaceFlag",1)
		hiddenObj("ReplayInfo",1)
	}
	var DisusedInfo=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503012")
	if (DisusedInfo=="0")
	{
		hiddenObj("cMRDisuesdFlag",1)
		hiddenObj("DisusedInfo",1)
	}
	if (FromDeptStr=="")
	{
		hiddenObj("RetrieveInfo",1)
		hiddenObj("ReturnInfo",1)
	}
	//Modefied by zc 2022-4-8
	//点击维修配件也签刷新
	$HUI.tabs("#tMaintTabs",{
		onSelect:function(title)
		{
			if (title=="维修配件")
			{
				var AccessorySrc="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR="+getElementValue("RowID")+"&MaintItemDR="+getElementValue("MaintItemDR")+"&Status="+getElementValue("MRStatus")+"&MaintType="+getElementValue("MRMaintType")+"&ReadOnly="+getElementValue("ReadOnly");	// MZY0080	1891466		2021-06-03
				if ((getElementValue("Action")!="")&&(getElementValue("Action")!="WX_Maint"))
				{
					AccessorySrc="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR="+getElementValue("RowID")+"&MaintItemDR="+getElementValue("MaintItemDR")+"&Status=0"+"&MaintType="+getElementValue("MRMaintType")+"&ReadOnly="+getElementValue("ReadOnly");	// MZY0080	1891466		2021-06-03
				}
				$('#Accessory').attr('src', AccessorySrc);
			}
			if(title=="维修图片")
			{
				// MZY0080	1891466		2021-06-03
				var url='dhceq.plat.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+getElementValue("RowID")+'&Status='+getElementValue("MRStatus")+'&Action='+getElementValue("Action")+"&MaintType="+getElementValue("MRMaintType")+'&ReadOnly=';
				if (getElementValue("ReadOnly")=="Y") url=url+"1";
				$('#MaintPic').attr('src', url);
			}
			if (title=="维修费用分摊")
			{
				//modified by ZY0297 修改分摊设置功能
				//var CostAllotSrc="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCostAllotNew&SourceID="+getElementValue("RowID")+"&Types=2"+"&EquipDR="+getElementValue("MRExObjDR_EQRowID")+"&Status="+getElementValue("MRStatus")+"&MaintType="+getElementValue("MRMaintType")+"&ReadOnly="+getElementValue("ReadOnly");	// MZY0080	1891466		2021-06-03
				var CostAllotSrc="dhceq.em.costallot.csp?&CAHold2="+getElementValue("RowID")+"&CATypes=2&Status="+getElementValue("MRStatus")+"&MaintType="+getElementValue("MRMaintType")+"&ReadOnly="+getElementValue("ReadOnly");	// MZY0080	1891466		2021-06-03
				if ((getElementValue("Action")!="")&&(getElementValue("Action")!="WX_Maint"))
				{
					CostAllotSrc="dhceq.em.costallot.csp?&CAHold2="+getElementValue("RowID")+"&CATypes=2&Status=0&ReadOnly="+getElementValue("ReadOnly");	// MZY0080	1891466		2021-06-03	
				}
				$('#CostAllot').attr('src', CostAllotSrc);
			}
		}
	});
	//检测是否需要评价
	if (jQuery("#CheckEvaluate").length>0)
	{
		var EvaluateFlag=getElementValue("CheckEvaluate")
		var EvaluateFlagObj=JSON.parse(EvaluateFlag)
		if (EvaluateFlagObj.SQLCODE==0)
		{
			if (EvaluateFlagObj.Data.EvaluateStatus>=0)
			{
				//生成评价窗口
				var EReadOnly=false
				if (EvaluateFlagObj.Data.EvaluateStatus==1)
				{
					EReadOnly=true
				}
				createEvaluateWin("tEvaluateWin",EvaluateFlagObj.Data.EvaluationID,EReadOnly);
			}
		}
		else
		{
			hiddenTab("tOtherTabs","tEvaluate")
		}
	}
	if (getElementValue("Action")=="WX_Maint")	//add by wy 2022-1-23
	{
		disableElement("MRHold15",false)
		if (getElementValue("MRAcceptUserDR")=="") //add by wy 2022-5-30 维修时维修人为空时取当前用户
		{
			setElement("MRAcceptUserDR",curUserID)}
	}
	if(getElementValue("Action")!="WX_Assign"){ //add by zyq 2022-11-07 不为派单步骤时，派单按钮不可使用
		disableElement("BApprove1",true)
		}
	//加载审批进度
	createApproveSchedule("ApproveSchedule","25",getElementValue("RowID"))
	//加载维修历史,知识库
	if ($("#tMaintHistorytree")){createMaintHistory(getElementValue("MRExObjDR_EQRowID"))}
	jQuery(window).resize(function(){window.location.reload()})
	var MaintType=getElementValue("MRMaintType")		//add by CZF0075 2020-02-25
	var Status=getElementValue("MRStatus");
	if (MaintType==1)
	{
		if ((Status=="")||(Status==0))
		{
			// MZY0080	1943263	
			setDisableElements("MRRequestDate^MRAssignDR_UserName^MRAssignDate^MREmergencyLevelDR_ELDesc^MRSeverityLevelDR_SLDesc^MRMaintGroupDR_MGDesc^MRAcceptUserDR_UserName^MREstimateWorkHour^MRAcceptDate^MRMaintModeDR_MMDesc^MRServiceDR_SVName^MRFaultTypeDR_FTDesc^MRInsurFlag^MRFaultReasonDR_FRDesc^MRDealMethodDR_DMDesc^MREndDate^MRMaintResultsDR_MRDesc^MRFaultReasonRemark^MRDealMethodRemark^MRWorkHour^MRMaintFee^MRSaveCostFee^MRGuaranteePeriod^MRAccountDate^MRAssessment^MROtherFee",false) //modify by zyq 2023-02-13 配件费可以编辑
			singlelookup("MRAssignDR_UserName","PLAT.L.EQUser","","")		//20200318
		}
		setRequiredElements("MRAcceptUserDR_UserName^MRAcceptDate^MRWorkHour^MREndDate^MRDealMethodRemark^MRFaultReasonRemark^MRMaintModeDR_MMDesc^MRFaultTypeDR_FTDesc^MRMaintFee^MROtherFee")//modify by zyq 2023-02-13 配件费可以编辑
	}
	var LinkLocFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","992011");		//modified by czf 2020-08-21 begin 1476453
	if (LinkLocFlag!=1)
	{
		$("#AllLocFalg").next().css("display","none");
		hiddenObj("cAllLocFalg",1);
	}
	disableElement("AllLocFalg",false);
	$("#AllLocFalg").click(function (e) {
		if(getElementValue("AllLocFalg"))
		{
			singlelookup("MRObjLocDR_LocDesc","PLAT.L.Loc",[{name:'LocDesc',type:'4',value:'MRObjLocDR_LocDesc'}])
		}
		else
		{
			singlelookup("MRObjLocDR_LocDesc","PLAT.L.Loc",[{name:'LocDesc',type:'4',value:'MRObjLocDR_LocDesc'},{name:'LinkLocID',type:'4',value:'MRRequestLocDR'}])
		}
	})			
	//modified by czf 2020-08-21 end 1476453
	//add by csj 2020-09-29 需求号：1539976
	var observer = new MutationObserver(function(mutations) {
	    mutations.forEach(function(mutationRecord) {
	        $("#tMaintTabs>div").width($("#tMaintTabs").width()-2)
	    });    
	});
	var target = document.getElementById('tMaintTabs');
	observer.observe(target, { attributes : true, attributeFilter : ['style'] });
}
//modified by 2022-4-12 MRSourceType关键字 begin
function initMRSourceTypeData()
{
	var MaintType=getElementValue("MRMaintType");
	if(MaintType=="2")
	{
		   var MRSourceType =$("#MRSourceType").keywords({
			   singleSelect:true,
               items:[{
					id: '1',
					text: '设备'
				},{
					id: '2',
					text: '简易台账'
				},{
					id: '3',
					text: '泛类设备'
				}],
				onClick : function(v){
				var SourceType=v.id
				setElement("FacilityFlag",SourceType-1)
				if (SourceType==3){setElement("FacilityFlag",SourceType-2)}
				setElement("MRExObjDR_ExObj","")		//Modify DJ 2019-06-06
				clearData("MRExObjDR_ExObj")			//Modify DJ 2019-06-06
	            var vParams=[{name:'Equip',type:'4',value:'MRExObjDR_ExObj'},{name:'VUseLoc',type:'4',value:'MRObjLocDR'},{name:'FacilityFlag',type:'4',value:'FacilityFlag'},{name:'vData',type:'2',value:"SSLocID=^SSGroupID=^SSUserID=^EquipAttribute=^vAllInFlag="+"^SourceType="+SourceType}]
	            singlelookup("MRExObjDR_ExObj","EM.L.Equip",vParams)


				}
        });}
        else{
	          $("#MRSourceType").keywords({
			   singleSelect:true,
               items:[{
					id: '1',
					text: '设备',selected:true
				},{
					id: '3',
					text: '泛类设备'
				}],
			    onClick : function(v){				    
				var SourceType=v.id
				setElement("FacilityFlag",SourceType-1)
				if (SourceType==3){setElement("FacilityFlag",SourceType-2)}
				setElement("MRExObjDR_ExObj","")		//Modify DJ 2019-06-06
				clearData("MRExObjDR_ExObj")			//Modify DJ 2019-06-06
				var vParams=[{name:'Equip',type:'4',value:'MRExObjDR_ExObj'},{name:'VUseLoc',type:'4',value:'MRObjLocDR'},{name:'FacilityFlag',type:'4',value:'FacilityFlag'},{name:'vData',type:'2',value:"SSLocID=^SSGroupID=^SSUserID=^EquipAttribute=^vAllInFlag="+"^MRSourceType="+SourceType}]
	            singlelookup("MRExObjDR_ExObj","EM.L.Equip",vParams)

				},

	          })

	        }

}
function initPage()
{
	initLookUp();		//初始化放大镜
	defindTitleStyle();
	//设备名称放大镜显示前事件
	$("#MRExObjDR_ExObj").lookup({onBeforeShowPanel:function(){ return onBeforeShowPanel("MRExObjDR_ExObj");}})
	initButton();
	if (jQuery("#BMaintUser").length>0)
	{
		jQuery("#BMaintUser").linkbutton({iconCls: 'icon-w-other'});  ///Modefidy by zc 2018-10-29 ZC0041  多人协助
		jQuery("#BMaintUser").click(function(){BMaintUser_Click()});  ///Modefidy by zc 2018-10-29 ZC0041  多人协助
	}
	jQuery("#BSelfCancelSubmit").linkbutton({iconCls: 'icon-w-back'}); //Add By QW20210916 BUG:QW0150 增加图标
	var obj=document.getElementById("BSelfCancelSubmit");  //add by mwz 2021-01-18 MWZ0048
    if (obj) obj.onclick=BSelfCancelSubmit_Clicked;
	//setElement("MRSourceType","1")	
	
	//setRequiredElements("MRObjLocDR_LocDesc^MRSourceType^MRExObjDR_ExObj^MRFaultCaseRemark")
	setRequiredElements("MRExObjDR_ExObj^MRFaultCaseRemark")  //modified by wy 2022-4-8		
	// Mozy0256		1221190		2020-3-13	初始化维修方式并增加默认参数Type
	var paramsFrom=[{"name":"MaintMode","type":"1","value":"MRMaintModeDR_MMDesc"},{"name":"Type","type":"2","value":"3"}];
    singlelookup("MRMaintModeDR_MMDesc","EM.L.MaintMode",paramsFrom,"");
	if (jQuery("#MRMaintFee").length>0)
	{
		jQuery("#MRMaintFee").change(function(){totalFee_Change()});
	}
	if (jQuery("#MROtherFee").length>0)
	{
		jQuery("#MROtherFee").change(function(){totalFee_Change()});
	}
    var obj=document.getElementById("BEquipList");  //add by wy 2021-11-15 报修界面增加台帐编译界面
    if (obj) obj.onclick=BEquipList_Clicked;
    var obj=document.getElementById("BMaintProcess");//add by wy 2022-1-23 维修进度
	if (obj) obj.onclick=MaintProcess; 
		//Modefied by zc 2022-4-8  begin
	if (jQuery("#RetrieveInfo").length>0)
	{
		jQuery("#RetrieveInfo").on("click", BRetrieve_Clicked);
	}
	if (jQuery("#ReturnInfo").length>0)
	{
		jQuery("#ReturnInfo").on("click", BReturn_Clicked);
	}
	//Modefied by zc 2022-4-8 end
        

}
//Modefied by zc 2022-4-8 end
//Modefied by zc 2022-4-8 
function BRetrieve_Clicked()
{
	var url="dhceq.em.maintmoveinfo.csp?&MRowID=&SourceType=31&EventType=1&ObjType=1&SourceID="+getElementValue("RowID")+"&EquipDR="+getElementValue("MRExObjDR_EQRowID")+"&Action="+getElementValue("Action");
	showWindow(url,"取回信息","600","380","icon-w-paper","modal","","","small");
}
//Modefied by zc 2022-4-8 
function BReturn_Clicked()
{
	var url="dhceq.em.maintmoveinfo.csp?&MRowID=&SourceType=31&EventType=2&ObjType=1&SourceID="+getElementValue("RowID")+"&EquipDR="+getElementValue("MRExObjDR_EQRowID")+"&Action="+getElementValue("Action");
	showWindow(url,"归还信息","600","380","icon-w-paper","modal","","","small");
}
function setSelectValue(vElementID,rowData)
{
	//modified by 2022-4-12 MRSourceType关键字
	var SourceType=$("#MRSourceType").keywords("getSelected")
	if ((SourceType!="")&&(SourceType!=undefined)) SourceType=SourceType[0].id
	if (vElementID=="MRObjLocDR_LocDesc")
	{
		setElement("MRObjLocDR",rowData.TRowID)
		setElement("MRRequestTel",rowData.TTel)
		if ((SourceType=="1")||(SourceType=="2")){
		setElement("MRExObjDR_ExObj","")}	// MZY0063	1580308		2020-12-11
	}
	else if (vElementID=="MRExObjDR_ExObj")
	{
		rowData.TExType=1
		setElement("MRExObjDR_ExObj",rowData.TName);			//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQNo",rowData.TNo);
		setElement("MRExObjDR_EQModel",rowData.TModel);
		if ((SourceType=="1")||(SourceType=="2")){
		setElement("MRObjLocDR_LocDesc",rowData.TUseLoc);		//Modify DJ 2019-06-06  modified by wy 2021-5-6 1904435 选择设备带出使用科室
		setElement("MRObjLocDR",rowData.TUseLocDR);			//Modify DJ 2019-06-06
		}
		//setElement("MRSourceType",rowData.TExType);			//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQOriginalFee",rowData.TOriginalFee);
		setElement("MRPlace",rowData.TLocation);
		setElement("MRExObjDR_EQFileNo",rowData.TFileNo);
		setElement("MRExObjDR_EQRowID",rowData.TRowID);
		setElement("MRObjTypeDR",rowData.TTypeDR);
		setElement("MREquipTypeDR",rowData.TEquipTypeDR);
		setElement("MRExObjDR_EQClassFlag",rowData.TClassFlag);		//Modify DJ 2019-06-27
		//来自设备时自动保存维护对象[待屏蔽]
		if ((SourceType=="1")||(SourceType=="2")||(SourceType=="3"))			  //Modified By QW20211229 
		{
			var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AutoSaveExObj",rowData.TRowID)
			var jsonObj=JSON.parse(jsonData)
			if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;}
			setElement("MRExObjDR",jsonObj.Data)
		}
		//add by wy 2022-4-18 检测设备是否存在对照故障现象
		var PParams=[{name:'FaultCase',type:'4',value:'MRFaultCaseDR_FCDesc'},{name:'Equip',type:'2',value:rowData.TRowID}]
	    singlelookup("MRFaultCaseDR_FCDesc","EM.L.FaultCase",PParams)

		var obj=document.getElementById("Banner");
		if (obj){$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+rowData.TRowID)}
	}
	else if (vElementID=="MRAcceptUserDR_UserName")
	{
		setElement("MRAcceptUserDR",rowData.TUserdr)
		setElement("MRAcceptUserDR_Initials",rowData.TInitials)
		setElement("MRMaintGroupDR",rowData.TMaintGroupDR);
		setElement("MRMaintGroupDR_MGDesc",rowData.TMaintGroup);
	}
	else if (vElementID=="MRAssignDR_UserName"){setElement("MRAssignDR",rowData.TRowID)}		//20200318
	else if (vElementID=="MRRequestUserDR_UserName"){  //Modified By QW20211229 
		setElement("MRRequestUserDR",rowData.TRowID)
		setElement("MRRequestLocDR",rowData.TUserLocDR)
		setElement("MRRequestLocDR_LocDesc",rowData.TUserLoc)
		setElement("MRRequestTel",rowData.TMobilePhone)
	}
	else if (vElementID=="MREquipStatusDR_ESDesc"){setElement("MREquipStatusDR",rowData.TRowID)}
	else if (vElementID=="MRMaintModeDR_MMDesc")
	{
		setElement("MRMaintModeDR",rowData.TRowID)
		//add by zc0125 2022-11-14 维修方式为自修时，灰化勾选框（是否保内，现场返厂维修） begin
		var MaintModeFlag=tkMakeServerCall("web.DHCEQCommon","IdInIds",rowData.TRowID,MaintModeIDs);
		if ((MaintModeFlag=="1")&&(MaintModeIDs!=""))
		{
			disableElement("MRInsurFlag",true)
			disableElement("MRReturnFlag",true)
			setElement("MRInsurFlag","")
			setElement("MRReturnFlag","")
		}
		else
		{
			disableElement("MRInsurFlag",false)
			disableElement("MRReturnFlag",false)
		}
		//add by zc0125 2022-11-14 维修方式为自修时，灰化勾选框（是否保内，现场返厂维修） end
	}
	else if (vElementID=="MRServiceDR_SVName"){setElement("MRServiceDR",rowData.TRowID)}
	else if (vElementID=="MRFaultTypeDR_FTDesc"){setElement("MRFaultTypeDR",rowData.TRowID)}
	else if (vElementID=="MRFaultReasonDR_FRDesc"){setElement("MRFaultReasonDR",rowData.TRowID)}
	else if (vElementID=="MRDealMethodDR_DMDesc"){setElement("MRDealMethodDR",rowData.TRowID)}
	else if (vElementID=="MRMaintResultsDR_MRDesc"){setElement("MRMaintResultsDR",rowData.TRowID)}
	else if (vElementID=="MRMaintGroupDR_MGDesc"){setElement("MRMaintGroupDR",rowData.TRowID)}
	else if (vElementID=="MREmergencyLevelDR_ELDesc"){setElement("MREmergencyLevelDR",rowData.TRowID)}
	else if (vElementID=="MRSeverityLevelDR_SLDesc"){setElement("MRSeverityLevelDR",rowData.TRowID)}
	else if (vElementID=="MRFaultCaseDR_FCDesc"){setElement("MRFaultCaseDR",rowData.TRowID)}
	else if (vElementID=="MRAccessoryOriginalDR_AODesc"){setElement("MRAccessoryOriginalDR",rowData.TRowID)}  //Modify by zx BUG ZX0077
}

function clearData(vElementID)
{
	var DRElementName=vElementID.split("_")[0]
	setElement(DRElementName,"")
	//modified by 2022-4-12 MRSourceType关键字
	var SourceType=$("#MRSourceType").keywords("getSelected")
	if ((SourceType!="")&&(SourceType!=undefined)) SourceType=SourceType[0].id
	if (vElementID=="MRObjLocDR_LocDesc") 
	{
		setElement("MRRequestTel","")
		if (SourceType=="1"){
		setElement("MRExObjDR_ExObj","");
		setElement("MRExObjDR","");
		clearData("MRExObjDR_ExObj")}
	}
	else if (vElementID=="MRExObjDR_ExObj") 
	{
		//setElement("MRExObjDR_EQNo","");		//Modify DJ 2019-06-06
		//setElement("MRExObjDR_EQModel","");	//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQOriginalFee","");
		//setElement("MRPlace","");				//Modify DJ 2019-06-06
		setElement("MRExObjDR_EQFileNo","");
		setElement("MRExObjDR_EQRowID","");
		setElement("MRObjTypeDR","");
		setElement("MREquipTypeDR","");
		setElement("MRExObjDR_EQClassFlag","");		//Modify DJ 2019-06-27
	}
	else if (vElementID=="MRAcceptUserDR_UserName")	
	{
		setElement("MRAcceptUserDR_Initials","");
	}
	else if (vElementID=="MRMaintGroupDR_MGDesc")	
	{
		setElement("MRAcceptUserDR_Initials","")
		setElement("MRAcceptUserDR_UserName","");
		setElement("MRAcceptUserDR","");
	}
}

function fillData()
{
	//start by csj 20190125 台账链接填充设备及科室
	var EquipDR=getElementValue("MRExObjDR");
	var RowID=getElementValue("RowID");
	if ((EquipDR!="")&&(RowID==""))
	{
		$cm({
			ClassName:"web.DHCEQ.EM.BUSEquip",
			MethodName:"GetOneEquip",
			RowID:EquipDR
		},function(jsonData){
			if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
    			setElement("MRExObjDR_ExObj",jsonData.Data["EQName"]);
				setElement("MRObjLocDR",jsonData.Data["EQUseLocDR"]);
				setElement("MRObjLocDR_LocDesc",jsonData.Data["EQUseLocDR_CTLOCDesc"]);
				// add by zx 2019-02-19 ZX0057 台账报修保存失败处理
				setElement("MRExObjDR_EQNo",jsonData.Data["EQNo"]);
				setElement("MRExObjDR_EQModel",jsonData.Data["EQModelDR_MDesc"]);
				setElement("MRSourceType","1");  // '1'为设备
				setElement("MRExObjDR_EQOriginalFee",jsonData.Data["EQOriginalFee"]);
				setElement("MRPlace",jsonData.Data["EQLocationDR_LDesc"]);
				setElement("MRExObjDR_EQFileNo",jsonData.Data["EQFileNo"]);
				setElement("MRExObjDR_EQRowID",EquipDR);
				setElement("MRObjTypeDR","1");  // '1'为设备
				setElement("MREquipTypeDR",jsonData.Data["EQEquipTypeDR"]);
				setElement("MRExObjDR_EQClassFlag",jsonData.Data["EQClassFlag"]);		//Modify DJ 2019-06-27
				//来自设备时自动保存维护对象[待屏蔽]
				var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AutoSaveExObj",EquipDR);
				var jsonObj=JSON.parse(jsonData);
				if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;};
				setElement("MRExObjDR",jsonObj.Data);
		});
	}
	//end by csj 20190125 
	var obj=document.getElementById("RowID");
	if (obj) var RowID=getElementValue("RowID");
	if (RowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	var CurRole=getElementValue("CurRole")  //modified by wy 2022-7-22 2767477 审批角色改取当前角色
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetOneMaintRequest",RowID,CurRole,Action,Step)
	var jsonObj=jQuery.parseJSON(jsonData)
	if (jsonObj.SQLCODE<0) {messageShow("","","",jsonObj.Data);return;}
	$("#MRSourceType").keywords("select",jsonObj.Data["MRSourceType"]); //modified by 2022-4-12 MRSourceType关键字
	setElementByJson(jsonObj.Data)
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+getElementValue("MRExObjDR_EQRowID"))
	setContratByEquip(jsonObj.Data["MRExObjDR"])
    if (jsonObj.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
}

function setContratByEquip(ExObjDR)
{
	var ContractInfo=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SetContrat",ExObjDR)
	var ContractObj=jQuery.parseJSON(ContractInfo)
	if (ContractObj.SQLCODE<0) {messageShow("","","",ContractObj.Data);return;} 
	var ValueList=ContractObj.Data
	var Value=ValueList.split("^");
	setSerContract(Value[0],Value[1],Value[2]);
}
function setSerContract(Type,StartDate,EndDate)
{
	if (Type=="0")  //没有保修
	{
		disableElement("BSerContract",true);
	}
	else
	{
		disableElement("BSerContract",false);
		var obj=document.getElementById("BSerContract");
		if (obj)
		{
			jQuery("#BSerContract").on("click", BSerContract_Click);
		}
	}
	setElement("MRMaintStartDate",StartDate);
	setElement("MRMaintEndDate",EndDate);
}


function setEnabled()
{
	var Status=getElementValue("MRStatus");
	var curRole=getElementValue("RoleStep");
	var nextRole=getElementValue("NextFlowStep");
	var RowID=getElementValue("RowID");
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly=="Y")
	{
		disableElement("BSave",true)
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		//disableElement("BPicture",true)	// MZY0063	1580653		2020-12-11
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
		//Modefied by zc 2022-4-8 begin
		if (getElementValue("MRRetrieveFlag")==true)
		{
			hiddenObj("ReturnInfo",0)
		}
		//Modefied by zc 2022-4-8 end
	}
	if(RowID=="")
	{
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		disableElement("BPicture",true)
		disableElement("BAppendFile",true); 
	}
	if ((Status!=0)||((curRole!=0)&&(curRole!=nextRole)))
	{
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		disableElement("BSave",true)
	}
	var Action=getElementValue("Action")
	if ((Action=="WX_Assign")||(Action=="WX_Accept"))        //派单和受理时维修配件按钮不可用
	{
		disableElement("BMaintDetail",true)
		disableElement("BMaintUser",true)  ///Modefidy by zc 2018-10-29 ZC0041  多人协助
	}
	//Modefied by zc 2022-4-8  begin
	if ((Action=="WX_Finish")||(Action=="WX_Return"))       //维修完成和归还时，可访问归还链接
	{
		if (getElementValue("MRRetrieveFlag")==true)
		{
			hiddenObj("ReturnInfo",0)
		}
	}
	//Modefied by zc 2022-4-8  end
	if (Status>0)
	{
		hiddenObj("BSave",1)
		hiddenObj("BSubmit",1)
		disableAllElements()
	}
	else
	{
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
		disableAllElements("MRObjLocDR_LocDesc^MRSourceType^MRExObjDR_ExObj^MREquipStatusDR_ESDesc^MRFaultCaseDR_FCDesc^MRFaultCaseRemark^MRStartDate^MRRequestUserDR_UserName^MRRequestTel^MRPlace^MRPackageState^MRAcceptUserDR_UserName^MRMaintModeDR_MMDesc^MRRetrieveFlag^MRReplaceFlag^MRDisuesdFlag^EmergencyFlag")  //modify by lmm 2019-08-28 989278   modify by zyq 2022-09-22 2827765   
	}
		if (Status!=2)
	{
		disableElement("BCancel",true)  //add by jyp 2020-03-12 JYP0023
		disableElement("BPrint",true)
	} 
	//Moidefied by zc0066 2020-4-11  生命周期链接按钮灰化 begin
	if (ReadOnly=="1")
	{
		disableElement("BCancel",true)
		disableElement("BPrint",true)
	}
	if (Status=="2")
	{
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
	}
	
	//Moidefied by zc0066 2020-4-11  生命周期链接按钮灰化 end
}

function setElementEnabled()
{
	var Status=getElementValue("MRStatus");
	var RoleStep=getElementValue("RoleStep");
	var Action=getElementValue("Action");
	var MaintType=getElementValue("MRMaintType")
	if (Status>0)	//提交之后
	{
		if (Action=="WX_Assign")
		{
			if (MaintType!="1")
			{
				setElement("MRAssignDR_UserName",curUserName);
				setElement("MRAssignDR",curUserID);
				setElement("MRAssignDate",getElementValue("CurDate"));
			}
			disableElement("MRAssignDR_UserName",true)
			disableElement("MRAssignDate",true)
			disableElement("MRAcceptUserDR_Initials",true)
		}
		if ((Action=="WX_Accept")||(Action=="WX_Maint")||(Action=="WX_Finish"))
		{
			disableElement("MROtherFee",true)
			disableElement("MRTotalFee",true)
			disableElement("MREmergencyLevelDR_ELDesc",true)
			disableElement("EmergencyFlag",false)  //Modefied by zc 2022-4-8 
//			var result=getMaintNumForAffix();	//南方医院个性需求
//			if (result!="")
//			{
//				result=result.replace("^","维修");
//				result=result.replace(",","次,");
//				result=result+"次."
//				messageShow("","","",t[-600199]+"\n"+result);
//			}
			if (Action=="WX_Accept")	//(getElementValue("MRAcceptDate")=="")
			{
				disableElement("MRAcceptDate",true)
				setElement("MRAcceptDate",getElementValue("CurDate"));
				disableElement("EmergencyFlag",true)  //Modefied by zc 2022-4-8
			}
			if ((Action=="WX_Finish")&&(getElementValue("EndDate")==""))
			{
				disableElement("MREndDate",true)
				setElement("MREndDate",getElementValue("CurDate"));
				disableElement("EmergencyFlag",true)  //Modefied by zc 2022-4-8 
			}
		}
	}
	else
	{
		if (MaintType!="1")
		{
			setElement("MRAssignDR_UserName","");
			setElement("MRAssignDR","");
			setElement("MRAssignDate","");
		}
	}
}

function getMaintNumForAffix()
{
	var AffixMaintInfo=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetMaintNumForAffix",getElementValue("RowID"))
	var AffixMaintObj=JSON.parse(AffixMaintInfo)
	if (AffixMaintObj.SQLCODE<0) {messageShow("","","",AffixMaintObj.Data);return;}
	return AffixMaintObj.Data
}

function totalFee_Change()
{
	var MaintFee=getElementValue("MRMaintFee")
	if (MaintFee=="") MaintFee=0
	MaintFee=parseFloat(MaintFee);
	var OtherFee=getElementValue("MROtherFee")
	if (OtherFee=="") OtherFee=0
	OtherFee=parseFloat(OtherFee);
	var tmpValue=(MaintFee.toFixed(2)*1)+(OtherFee.toFixed(2)*1);
	tmpValue=parseFloat(tmpValue);
	setElement("MRTotalFee",tmpValue.toFixed(2))
}

//////////////////////////////////业务处理函数/////////////////////////////////////////////
function BSave_Clicked()
{
	if (checkMustItemNull()) return
	// MZY0063	1580308		2020-12-11
	//modified by 2022-4-12 MRSourceType关键字
	var SourceType=$("#MRSourceType").keywords("getSelected")
	if ((SourceType)||(SourceType!=undefined)) SourceType=SourceType[0].id
	if (SourceType=="1")
	{
	var MRObjLocDR=getElementValue("MRObjLocDR")
	if (MRObjLocDR=="")
	{
		messageShow("","","","使用科室不能为空,请选择科室!")
		return
	}
	}
	//add by wy 2022-4-23当泛类维修时，只输入设备名称即可以完成建单 begin
	if (SourceType=="3")
	{ 
	     var ExObjDR=getElementValue("MRExObjDR")
	     var ExObj=getElementValue("MRExObjDR_ExObj")
	     if ((ExObjDR=="")&&(ExObj!=""))
	     {   
	           var EquipStr=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503015")
	           if (EquipStr=="") {return;}
	           var list=EquipStr.split("^");
	           var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SaveExObj",ExObj,"","")
	           jsonData=jQuery.parseJSON(jsonData);
				if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
				setElement("MRExObjDR",jsonData.Data)
				setElement("MREquipTypeDR",list[0]);
	      }
		}  
		//add by wy 2022-4-23当泛类维修时，只输入设备名称即可以完成建单 end 
		var ExObjDR=getElementValue("MRExObjDR")
		if (ExObjDR=="")
		{
			messageShow("","","","设备名称不能为空,请选择设备!")
			return
		}

	// add by sjh SJH0035 2020-09-23 START 判断控制费用不能包含非数字类型字符串
	var MaintFee=Number(getElementValue("MRMaintFee"))
	var OtherFee=Number(getElementValue("MROtherFee"))
	var SaveCostFee=Number(getElementValue("MRSaveCostFee"))
	var MaintType=getElementValue("MRMaintType");
	if(((isNaN(MaintFee))||(isNaN(OtherFee))||(isNaN(SaveCostFee)))&&(MaintType=="1"))
	{
		messageShow("","","","费用类型要为数值类型！")
		return
	} 
	// add by sjh SJH0035 2020-09-23 END
	var SourceTypeDR=SourceType     //getElementValue("MRSourceType")
	//存储数据
	var RowID=getElementValue("RowID")
	var CheckValue=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CheckMaintProcess",SourceTypeDR,ExObjDR,RowID)
	var CheckObj=JSON.parse(CheckValue)
	if (CheckObj.SQLCODE<0) {messageShow("","","",CheckObj.Data);return;}
	if (CheckObj.Data["ReturnFlag"]=="1")
	{
		var CheckInfo=t[-5600]
		CheckInfo=CheckInfo.replace("[RequestUser]",CheckObj.Data["RequestUser"]);
		CheckInfo=CheckInfo.replace("[RequestDate]",CheckObj.Data["RequestDate"]);
		CheckInfo=CheckInfo.replace("[RequestNo]",CheckObj.Data["RequestNo"]);
		messageShow("confirm","info","提示",CheckInfo,"",checkEquipStatus,"");
	}
	else
	{
		checkEquipStatus()
	}
}
function checkEquipStatus()
{
	var MREquipStatus=getElementValue("MREquipStatusDR");
	//add by wy 2021-5-6 1882906设备状态异常停用设备，先判断设备是否已停用
	var EQRowID=getElementValue("MRExObjDR_EQRowID")
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag")
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag")
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","","",EQRowID,"2");
	if ( (MREquipStatus>1)&&(GetEQStopStartFlag==1)&&(EQClassFlag!="Y"))
	{
		messageShow("confirm","info","提示","设备状态异常是否停用设备？","",function(){
			bsavechecktrue("Y")
			},function(){
			bsavechecktrue("N")
				})
	}
	else
	{
		bsavechecktrue("N")
	}
}
function bsavechecktrue(MREquipStatusFlag)
{
	var combindata=getDataList();
	var Evaluate=""	
	var ReturnValue=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","UpdateMaintRequest",combindata,Evaluate,MREquipStatusFlag)
	var ReturnObj=JSON.parse(ReturnValue)
	if (ReturnObj.SQLCODE<0) 
	{
		messageShow("","","",ReturnObj.Data);
		return;
	}
	else
	{
		//Modified BY QW20211229 begin
		/*var data={"URowID":getElementValue("MRRequestUserDR"),"UMobilePhone":getElementValue("MRRequestTel"),"UActiveFlag":"Y","ULoginName":getElementValue("MRRequestUserDR")}
		data=JSON.stringify(data);
		var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTUser","SaveData",data,"");
		//Modified BY QW20211229 end
		messageShow("","","",t[0])*/
		//Modified BY WY 2022-4-19 生成设备与故障现象对照
		if (getElementValue("MRFaultCaseDR")!="") {		
		var EquipDR=getElementValue("MRExObjDR_EQRowID")
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",EquipDR);
		var jsonData=JSON.parse(jsonData)
		var ItemDR=jsonData.Data["EQItemDR"]
	   	var valList="^1^"+getElementValue("MRFaultCaseDR")+"^2^"+ItemDR+"^^^Y^^^^^"
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveFaultEquipMapData",valList);
		messageShow("","","",t[0])
		}
	
	}
	//刷新界面
	//modifiedd by CZF0075 2020-02-25 begin
	var MaintType=getElementValue("MRMaintType");
	var src="dhceq.em.mmaintrequestsimple.csp?";
	 //Modified BY QW20211229
	var MRManageTypeDR=getElementValue("MRManageTypeDR");
	var QXType=getElementValue("QXType")
	if ((MRManageTypeDR==1)&&(QXType==1))
	{
		var src="dhceq.em.hardwaremaintsimple.csp?";
	}else{
		if (MaintType==1)
		{
			src="dhceq.em.mmaintrequest.csp?";
		}
	}
	var url=src+"&RowID="+ReturnObj.Data+"&CurRole="+getElementValue("CurRole")+"&ApproveRoleDR="+getElementValue("ApproveRoleDR")+"&QXType="+getElementValue("QXType")+"&MaintType="+MaintType;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url},50); 
	//modifiedd by CZF0075 2020-02-25 end
}
function BSubmit_Clicked()
{
	if (checkMustItemNull()) return
	var IRowID=getElementValue("RowID");
	if (IRowID=="")	{messageShow("","","",t[-9205]);return 0;}
	//modified by 2022-4-12 MRSourceType关键字
	var SourceType=$("#MRSourceType").keywords("getSelected")
	if ((SourceType)||(SourceType!=undefined)) SourceType=SourceType[0].id
	var SourceTypeDR=SourceType  //getElementValue("MRSourceType")		//Modify DJ 2019-06-27
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag")
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag")
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",IRowID,"","2");
	if (((SourceTypeDR==1)&&(EQClassFlag!="Y"))&&(GetEQStopStartFlag==1))		//除简易台账泛类外处理停用启用 Modify DJ 2019-06-27
	{
		if (GetStopEquipFlag==1)
		{
			messageShow("confirm","info","提示",t[-9260],"",bstopstartture,bsubmit)
		}
		else if (GetStopEquipFlag==2)
		{
			bstopstartture()
		}
		else
		{
			bsubmit()
		}
	}
	else
	{
		bsubmit()
	}
}
function bstopstartture()
{
	var IRowID=getElementValue("RowID");
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",IRowID,"1");
	var resultObj=JSON.parse(result)
	if (resultObj.SQLCODE<0)	{messageShow("","","",t[-9200]+resultObj.Data);return;}
	bsubmit()
}
function bsubmit()
{
	var IRowID=getElementValue("RowID");
	var Ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SubmitMaintRequest",IRowID,"1",curUserID);
	var RetObj=JSON.parse(Ret)
	if (RetObj.SQLCODE<0) 
	{
		messageShow("","","",RetObj.Data)
		return 0;
	}
	messageShow("","","",t[0])
	var SimpleFlag=getElementValue("SimpleFlag");
	//modifiedd by CZF0075 2020-02-25 begin
	var MaintType=getElementValue("MRMaintType");
	var src="dhceq.em.mmaintrequestsimple.csp?";
	 //Modified BY QW20211229
	var MRManageTypeDR=getElementValue("MRManageTypeDR");
	var QXType=getElementValue("QXType")
	if ((MRManageTypeDR==1)&&(QXType==1)) 
	{
		var src="dhceq.em.hardwaremaintsimple.csp?";
	}else{
		if ((MaintType==1)||(SimpleFlag==""))
		{
			src="dhceq.em.mmaintrequest.csp?";
		}
	}
	var url=src+"&RowID="+IRowID+"&CurRole="+getElementValue("CurRole")+"&QXType="+getElementValue("QXType")+"&MaintType="+MaintType;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url},50); // modified by zyq 2022-10-09
	//modifiedd by CZF0075 2020-02-25 end
}
function BDelete_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")	{messageShow("","","",t[-9205]);	return;	}
	messageShow("confirm","info","提示",t[-9203],"",bdeletetrue,"")
}
function bdeletetrue()
{
	var RowID=getElementValue("RowID")
	var Ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","DeleteMaintRequest",RowID)
	var RetObj=jQuery.parseJSON(Ret)
	if (RetObj.SQLCODE<0)
	{
		messageShow("","","",RetObj.Data)
		return;
	}
	messageShow("","","",t[0]);
	//modifiedd by CZF0075 2020-02-25 begin
	var MaintType=getElementValue("MRMaintType");
	var src="dhceq.em.mmaintrequestsimple.csp?";
	//Modified BY QW20211229
	var MRManageTypeDR=getElementValue("MRManageTypeDR");
	var QXType=getElementValue("QXType")
	if ((MRManageTypeDR==1)&&(QXType==1)) 
	{
		var src="dhceq.em.hardwaremaintsimple.csp?";
	}else
	{
		if (MaintType==1)
		{
			src="dhceq.em.mmaintrequest.csp?";
		}
	}
	var url=src+"&RowID=&Status=0&MaintType="+MaintType;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.setTimeout(function(){window.location.href=url},50); 
	//modifiedd by CZF0075 2020-02-25 end
}

function BCancelSubmit_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	if (getElementValue("RejectReason")=="") //add by wy 2022-7-22 2766212 拒绝意见	 
	{
		setFocus("RejectReason");
		messageShow('alert','error','提示',t[-9234])	
		return
	}
	//modified by 2022-4-12 MRSourceType关键字
	var SourceType=$("#MRSourceType").keywords("getSelected")
	if ((SourceType!="")&&(SourceType!=undefined)) SourceType=SourceType[0].id

	var SourceTypeDR=SourceType   //getElementValue("MRSourceType")		//Modify DJ 2019-06-27
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag")
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag")
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",RowID,"","1");
	if (((SourceTypeDR!=2)||(EQClassFlag!="Y"))&&(GetEQStopStartFlag==1))		//除简易台账泛类外处理停用启用 Modify DJ 2019-06-27
	{
		if (GetStopEquipFlag==1)
		{
			messageShow("confirm","info","提示",t[-9261],"",bcancelstopstarttrue,bcancelsubmit)
		}
		else if (GetStopEquipFlag==2)
		{
			bcancelstopstarttrue()
		}
		else
		{
			bcancelsubmit()
		}
	}
	else
	{
		bcancelsubmit()
	}
}
function bcancelstopstarttrue()
{
	var RowID=getElementValue("RowID")
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",RowID,"0");
	var resultObj=JSON.parse(result)
	if (resultObj.SQLCODE<0)
	{
		messageShow("","","",t[-9200]+resultObj.Data)
		return;
	}
	bcancelsubmit()
}
function bcancelsubmit()
{
	var RowID=getElementValue("RowID")
	var CurRole=getElementValue("CurRole")
	var RoleStep=getElementValue("RoleStep")
	var RowID=getElementValue("RowID");
	var ApproveTypeCode="25";
	var Type="1";
	var GotoType=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveFlow","GetApproveFlowType",RowID,CurRole,ApproveTypeCode,Type,RoleStep)
	var GotoTypeObj=JSON.parse(GotoType)
	setElement("ApproveTypeCode","25");
	setElement("Type","1")
	if (GotoTypeObj.Data==2)
	{
		var vParams={
			ClassName:"web.DHCEQCApproveFlow",
			QueryName:"GetUserApproves",
			Arg1:getElementValue("RowID"),
			Arg2:getElementValue("CurRole"),
			Arg3:getElementValue("ApproveTypeCode"),
			Arg4:getElementValue("Type"),
			Arg5:getElementValue("RoleStep"),
			ArgCnt:5
			};
		var vcolumns=[[
		{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
		{field:'TRoleDR',title:'TRoleDR',width:50,align:'center',hidden:true},
		{field:'TRole',title:'TRole',width:50,align:'center',hidden:true},
		{field:'TStep',title:'TStep',width:50,align:'center',hidden:true},
		{field:'TAction',title:'动作',width:200,align:'center'},
		]];
		initApproveFlowGrid("ApproveFlowWin","tApproveFlowGrid",vParams,vcolumns,1)
		jQuery('#ApproveFlowWin').window('open');
		return ;	
	}

	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
	    var url="dhceq.em.mmaintrequest.csp?&RowID="+RtnObj.Data+"&CurRole="+getElementValue("CurRole");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
}

function BApprove_Clicked()
{
	if (checkMustItemNull()) return
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	var MRWorkHour=getElementValue("MRWorkHour")
	if ((MRWorkHour!="")&&(MRWorkHour<0))	{messageShow("","","","实际工时小于0");	return;	}
	var MRMaintFee=getElementValue("MRMaintFee")
	if ((MRMaintFee!="")&&(MRMaintFee<0))	{messageShow("","","","人工费小于0");	return;	}
	var GetFaultReasonOperMethod=getElementValue("GetFaultReasonOperMethod");
  	var FaultReasonDR=getFaultReasonRowID(GetFaultReasonOperMethod);
  	if (FaultReasonDR<0) return;
  	setElement("MRFaultReasonDR",FaultReasonDR);
  	var GetDealMethodOperMethod=getElementValue("GetDealMethodOperMethod");
  	var DealMethodDR=getDealMethodRowID(GetDealMethodOperMethod);
  	if (DealMethodDR<0) return;
  	setElement("MRDealMethodDR",DealMethodDR);
  	var GetFaultTypeOperMethod=getElementValue("GetFaultTypeOperMethod");
  	var FaultTypeDR=getFaultTypeRowID(GetFaultTypeOperMethod);
  	if (FaultTypeDR<0) return;
  	setElement("MRFaultTypeDR",FaultTypeDR);
  	
  	var type=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","201006")
	var ServiceDR=getServiceRowID(type,"MRServiceDR","MRServiceDR_SVName")  //modified by wy 2022-9-28 2955208
	if (ServiceDR<0){ServiceDR=""}
  	setElement("MRServiceDR",ServiceDR);
	//保存评价信息 Modify DJ 2015-08-28 DJ0159
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
	var Action=getElementValue("Action")
	var RowID=getElementValue("RowID");
	var ApproveTypeCode="25";
	var Type="0";
	//Modefied by zc 2022-4-8 begin
	if (getElementValue("MRDisuesdFlag")!=true) 
	{
		var GotoType=tkMakeServerCall("web.DHCEQ.Plat.CTCApproveFlow","GetApproveFlowType",RowID,CurRole,ApproveTypeCode,Type,RoleStep)
		var GotoTypeObj=JSON.parse(GotoType)
		setElement("ApproveTypeCode","25");
		setElement("Type","0");
		if (GotoTypeObj.Data==2)
		{
			var vParams={
			ClassName:"web.DHCEQCApproveFlow",
			QueryName:"GetUserApproves",
			Arg1:getElementValue("RowID"),
			Arg2:getElementValue("CurRole"),
			Arg3:getElementValue("ApproveTypeCode"),
			Arg4:getElementValue("Type"),
			Arg5:getElementValue("RoleStep"),
			ArgCnt:5
			};
			var vcolumns=[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TRoleDR',title:'TRoleDR',width:50,align:'center',hidden:true},
			{field:'TRole',title:'TRole',width:50,align:'center',hidden:true},
			{field:'TStep',title:'TStep',width:50,align:'center',hidden:true},
			{field:'TAction',title:'动作',width:200,align:'center'},
			]];
			initApproveFlowGrid("ApproveFlowWin","tApproveFlowGrid",vParams,vcolumns,0)
			jQuery('#ApproveFlowWin').window('open');
			return;	
		}
	}
	//Modefied by zc 2022-4-8 end
	var EvaluatInfo=""
	var GetCheckEvaluate=checkEvaluate("31",RowID,CurRole,"","","",Action)
	setElement("CheckEvaluate",GetCheckEvaluate)
	var GetCheckEvaluateObj=JSON.parse(GetCheckEvaluate)
	if (GetCheckEvaluateObj.SQLCODE==0)
	{
		EvaluatInfo=getEvaluateInfo();
		var EvaluatScore=EvaluatInfo.split("@")
		if ((GetCheckEvaluateObj.Data.EvaluateStatus==0)&&(EvaluatScore[0]==0))
		{
			//激活评价窗口
			selectTab("tOtherTabs","tEvaluate")
			if (GetCheckEvaluateObj.Data.EIndependentFlag=="Y")
			{
				messageShow("confirm","info","提示",t[-9230],"","",bapprovestartstop)
			}
			else
			{
				messageShow("confirm","info","提示",t[-9231],"","",bapprovestartstop)
			}
		}
		else
		{
			bapprovestartstop()
		}
	}
	else
	{
		if (GetCheckEvaluateObj.SQLCODE==-9031)
		{
			messageShow("","","",GetCheckEvaluateObj.Data)
			return
		}
		else
		{
			bapprovestartstop()
		}
	}
}
function bapprovestartstop()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")  {messageShow("","","",t[-9205]);	return;	}
	//modified by 2022-4-12 MRSourceType关键字
	var SourceType=$("#MRSourceType").keywords("getSelected")
	if ((SourceType!="")&&(SourceType!=undefined)) SourceType=SourceType[0].id
	var SourceTypeDR=SourceType  //getElementValue("MRSourceType")
	var EQClassFlag=getElementValue("MRExObjDR_EQClassFlag")
	var GetStopEquipFlag=getElementValue("GetStopEquipFlag")
	var Action=getElementValue("Action")
	var GetEQStopStartFlag=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetEQStopStartFlag","31",RowID,"","1");
	if (((SourceTypeDR!=2)||(EQClassFlag!="Y"))&&(GetEQStopStartFlag==1)&&(Action=="WX_Finish"))		//除简易台账泛类外处理停用启用 Modify DJ 2019-06-27
	{
		if (GetStopEquipFlag==1)
		{
			messageShow("confirm","info","提示",t[-9261],"",bapprovestartstoptrue,bapprove)
		}
		else if (GetStopEquipFlag==2)
		{
			bapprovestartstoptrue()
		}
		else
		{
			bapprove()
		}
	}
	else
	{
		bapprove()
	}
}
function bapprovestartstoptrue()
{
	var RowID=getElementValue("RowID")
	var result=tkMakeServerCall("web.DHCEQ.Plat.BUSChangeInfo","StopEquipBySource","31",RowID,"0");
	var resultObj=JSON.parse(result)
	if (resultObj.SQLCODE<0)
	{
		messageShow("","","",t[-9200]+resultObj.Data)
		return;
	}
	bapprove()
}
function bapprove()
{
	var CurRole=getElementValue("CurRole")
	var RoleStep=getElementValue("RoleStep")
	var EvaluatInfo=getEvaluateInfo();
	var objtbl=getParentTable("MRRequestNo")
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	var combindata=getValueList();
  	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo,"","","",EvaluatInfo);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
		websys_showModal("options").mth("31");  //modify by zx 2022-04-11 bug ZX0144
	    window.setTimeout(function(){window.location.reload()},50); 
    }
}

function getDataList()
{
	var FaultCaseDR=getFaultCaseRowID(getElementValue("GetFaultCaseOperMethod"))
	if (FaultCaseDR<0){FaultCaseDR=""}
	var FaultReasonDR=getFaultReasonRowID(getElementValue("GetFaultReasonOperMethod"))
	if (FaultReasonDR<0){FaultReasonDR=""}
	var DealMethodDR=getDealMethodRowID(getElementValue("GetDealMethodOperMethod"))
	if (DealMethodDR<0){DealMethodDR=""}
	var FaultTypeDR=getFaultTypeRowID(getElementValue("GetFaultTypeOperMethod"))
	if (FaultTypeDR<0){FaultTypeDR=""}
	var ServiceDR=""
  	var type=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","201006")
	var ServiceDR=getServiceRowID(type,"MRServiceDR","MRServiceDR_SVName") //add by wy 2022-9-28 2955208
	if (ServiceDR<0){ServiceDR=""}
	var combindata="";
  	combindata=getElementValue("RowID") ;
	combindata=combindata+"^"+getElementValue("MRRequestNo") ;
	combindata=combindata+"^"+getElementValue("MRManageTypeDR") ;
	combindata=combindata+"^"+getElementValue("MREquipTypeDR") ;
	combindata=combindata+"^"+getElementValue("MRObjTypeDR") ;
	combindata=combindata+"^"+getElementValue("MRExObjDR") ;
	//modified by 2022-4-12 MRSourceType关键字
	var SourceType=$("#MRSourceType").keywords("getSelected")
	if ((SourceType)||(SourceType!=undefined)) SourceType=SourceType[0].id
	if ((SourceType=="3")&&(getElementValue("MRObjLocDR")==""))//modified by zyq 2022-09-28
	 {
		combindata=combindata+"^"+getElementValue("MRRequestLocDR") ;
	 }
	else {
		combindata=combindata+"^"+getElementValue("MRObjLocDR");
	}
	combindata=combindata+"^"+getElementValue("MRRequestLocDR") ;
	combindata=combindata+"^"+getElementValue("MRStartDate") ;
	combindata=combindata+"^"+getElementValue("MRStartTime") ;	//10
	combindata=combindata+"^"+FaultCaseDR;
	combindata=combindata+"^"+getElementValue("MRFaultCaseRemark") ;
	combindata=combindata+"^"+FaultReasonDR;
	combindata=combindata+"^"+getElementValue("MRFaultReasonRemark") ;
	combindata=combindata+"^"+DealMethodDR;
	combindata=combindata+"^"+getElementValue("MRDealMethodRemark") ;
	combindata=combindata+"^"+getElementValue("MREndDate") ;
	combindata=combindata+"^"+getElementValue("MREndTime") ;
	combindata=combindata+"^"+getElementValue("MRRequestDate") ;
	combindata=combindata+"^"+getElementValue("MRRequestTime") ;	//20
	combindata=combindata+"^"+getElementValue("MRRequestUserDR") ;
	combindata=combindata+"^"+getElementValue("MRRequestTel") ;
	combindata=combindata+"^"+getElementValue("MRPlace") ;
	combindata=combindata+"^"+FaultTypeDR;
	combindata=combindata+"^"+getElementValue("MRAcceptDate") ;
	combindata=combindata+"^"+getElementValue("MRAcceptTime") ;
	combindata=combindata+"^"+getElementValue("MRAcceptUserDR") ;
	combindata=combindata+"^"+getElementValue("MRAssignDR") ;
	combindata=combindata+"^"+getElementValue("MRMaintModeDR") ;	//29
	if (getElementValue("MRMaintModeDR")==3)
	{
	    combindata=combindata+"^"+"^"+getElementValue("MRMaintModeWayDR")+"^" ;
	}
    else if (getElementValue("MRMaintModeDR")==2)
    {
        combindata=combindata+"^"+"^"+"^"+getElementValue("MRMaintModeWayDR") ;
    }
    else
    {
        combindata=combindata+"^"+getElementValue("MRMaintModeWayDR")+"^"+"^" ;
    }
	combindata=combindata+"^"+getElementValue("MRUserSignDR") ;
	combindata=combindata+"^"+getElementValue("MRUserOpinion") ;
	combindata=combindata+"^"+getElementValue("MRManageLocDR") ;
	var obj = document.getElementById("ReturnFlag") ;
	if (obj){combindata=combindata+"^"+getElementValue("ReturnFlag");}
	else combindata=combindata+"^"+"N" ;
	combindata=combindata+"^"+getElementValue("MRMaintRequestDR") ;
	combindata=combindata+"^"+getElementValue("MRMaintRemark") ;
	combindata=combindata+"^"+getElementValue("MREstimateWorkHour") ;
	combindata=combindata+"^"+getElementValue("MRWorkHour") ;	//40
	combindata=combindata+"^"+getElementValue("MRRemark") ;
	combindata=combindata+"^"+getElementValue("MRStatus") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+getElementValue("MRInvalidFlag") ;
	combindata=combindata+"^"+getElementValue("MRMaintFee") ;
	combindata=combindata+"^"+getElementValue("MROtherFee") ;
	combindata=combindata+"^"+getElementValue("MRTotalFee") ;
	combindata=combindata+"^"+getElementValue("MREmergencyLevelDR") ;
	combindata=combindata+"^"+getElementValue("MRSeverityLevelDR") ;
	combindata=combindata+"^"+SourceType;    //getElementValue("MRSourceType") ;//modified by 2022-4-12 MRSourceType关键字
	combindata=combindata+"^"+getElementValue("MRAssignDate") ;
	combindata=combindata+"^"+getElementValue("MRPackageState") ;
	combindata=combindata+"^"+getElementValue("MRInsurFlag") ;
	combindata=combindata+"^"+getElementValue("MRMaintResultsDR") ;
	combindata=combindata+"^"+getElementValue("MREquipStatusDR") ;
	combindata=combindata+"^"+getElementValue("MRMaintProcessDR") ;
	combindata=combindata+"^"+getElementValue("MRGuaranteePeriod") ;	//add by CZF0072 2020-02-25 begin
	combindata=combindata+"^"+getElementValue("MRAccountDate") ;
	combindata=combindata+"^"+getElementValue("MRAssessment") ;		//add by CZF0072 2020-02-25 end
	combindata=combindata+"^"+getElementValue("MRMaintType") ;		//add by CZF0075 2020-02-25
	combindata=combindata+"^"+getElementValue("MRMaintGroupDR") ;	//20200318
	combindata=combindata+"^"+ServiceDR    //getElementValue("MRServiceDR") ;		//20200318
	combindata=combindata+"^"+getElementValue("MRSaveCostFee") ;		//20200328
	combindata=combindata+"^"+getElementValue("MRRetrieveFlag") ; //add by zyq 20221106 begin
	combindata=combindata+"^"+getElementValue("MRReplaceFlag") ; 
	combindata=combindata+"^"+getElementValue("MRDisuesdFlag") ; //add by zyq 20221106 end
    return combindata;
}

function dataGridSelect(vType,vRowData)
{
	if (vType==0)
	{
		var vDataStr=vRowData.TRowID+"^"+vRowData.TRoleDR+"^"+vRowData.TRole+"^"+vRowData.TStep+"^"+vRowData.TAction
		getUserApprove(vDataStr)
	}
	if (vType==1)
	{
		var vDataStr=vRowData.TRowID+"^"+vRowData.TRoleDR+"^"+vRowData.TRole+"^"+vRowData.TStep+"^"+vRowData.TAction
		getUserCancelApprove(vDataStr)
	}
}

function getUserApprove(Value)
{
	var list=Value.split("^");
	var ApproveFlowID=list[0];
	CurApproveFlowID=list[0];
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
	var Action=getElementValue("Action")
	var RowID=getElementValue("RowID")
	var objtbl=getParentTable("MRRequestNo")
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	var EvaluatInfo=""
	var GetCheckEvaluate=checkEvaluate("31",RowID,CurRole,"","","",Action)
	setElement("CheckEvaluate",GetCheckEvaluate)
	var GetCheckEvaluateObj=JSON.parse(GetCheckEvaluate)
	if (GetCheckEvaluateObj.SQLCODE==0)
	{
		EvaluatInfo=getEvaluateInfo();
		var EvaluatScore=EvaluatInfo.split("@")
		if ((GetCheckEvaluateObj.Data.EvaluateStatus==0)&&(EvaluatScore[0]==0))
		{
			selectTab("tOtherTabs","tEvaluate")
			if (GetCheckEvaluateObj.Data.EIndependentFlag=="Y")
			{
				messageShow("confirm","info","提示",t[-9230],"",buserapprove,"")
			}
			else
			{
				messageShow("confirm","info","提示",t[-9231],"",buserapprove,"")
			}
		}
		else
		{
			buserapprove()
		}
	}
	else
	{
		if (GetCheckEvaluateObj.SQLCODE==-9031)
		{
			messageShow("","","",GetCheckEvaluateObj.Data)
			return
		}
		else
		{
			buserapprove()
		}
	}
}
function buserapprove()
{
	var CurRole=getElementValue("CurRole")
	var RoleStep=getElementValue("RoleStep")
	var objtbl=getParentTable("MRRequestNo")
	var EditFieldsInfo=approveEditFieldsInfo(objtbl);
	var EvaluatInfo=getEvaluateInfo();
	var combindata=getValueList();
	var MaintProcess=getElementValue("MaintProcess");
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo,CurApproveFlowID,MaintProcess,"",EvaluatInfo);
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
		websys_showModal("options").mth("31");  //modify by zx 2022-04-11 bug ZX0144
	    window.setTimeout(function(){window.location.reload()},50);
    }
}

function getUserCancelApprove(Value)
{
	var list=Value.split("^");
	setElement("CancelToFlowDR",list[0]);
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
		websys_showModal("options").mth("31");  //modify by zx 2022-04-11 bug ZX0144
		var url="dhceq.em.mmaintrequest.csp?&RowID="+RtnObj.Data+"&CurRole="+getElementValue("CurRole");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
    }
}
function getValueList()
{
	var ValueList="";
	ValueList=getElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EvaluateGroup");
	ValueList=ValueList+"^^"+getElementValue("RejectReason"); //add by wy 2022-7-22 2766212 拒绝意见
	
	return ValueList;
}

function getEvaluateInfo()
{
	//主表
	var EInfo=""
	var GetEvaInfo=getElementValue("CheckEvaluate")
	var GetEvaInfoObj=JSON.parse(GetEvaInfo)
	if (GetEvaInfoObj.SQLCODE<0) return ""
	if (GetEvaInfoObj.Data.EvaluateStatus!=0) return ""
	var EvaluationDR=GetEvaInfoObj.Data.EvaluationID
	var RowID=getElementValue("RowID")
	var CurRole=getElementValue("CurRole")
	var Action=getElementValue("Action")
	var User=curUserID
	var EInfo="^31^"+RowID+"^^"+CurRole+"^^^^^^^"+Action+"^^"+EvaluationDR
	//明细
	var EListInfo=""
	var EvaScoreSum=0
	var EvaCount=tEvaluate.length
	for (var i=0;i<EvaCount;i++)
	{
		var EvaInfo=tEvaluate[i].split("^")
		var EvaElement=EvaInfo[0]
		var ELRowID=EvaInfo[1]
		var EvaTypeDR=EvaInfo[2]
		var EvaGroupDR=EvaInfo[3]
		var EvaScore=jQuery("#"+EvaElement).raty("score")
		if (EvaScore==undefined) EvaScore=0
		EvaScoreSum=EvaScoreSum+EvaScore
		if (EListInfo!="")
		{
			EListInfo=EListInfo+"*"+"^"+ELRowID+"^"+EvaTypeDR+"^"+EvaScore+"^^"+EvaGroupDR
		}
		else
		{
			EListInfo="^"+ELRowID+"^"+EvaTypeDR+"^"+EvaScore+"^^"+EvaGroupDR
		}
	}
	return EvaScoreSum+"@"+EInfo+"@"+EListInfo
}

//////////////////////////////////////功能处理函数///////////////////////////////////
///图片
function BPicture_Clicked()
{
	var Status=getElementValue("MRStatus");
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+getElementValue("RowID")+'&Status='+Status;
	if ((Status==2)||(getElementValue("ReadOnly")=="Y")) str=str+"&ReadOnly=1";		// MZY0063	1580653		2020-12-11
	var title="图片信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(str,title,width,height,icon,showtype,"","","middle"); //modify by lmm 2020-06-05 UI
}
///维修配件
function BMaintDetail_Click()
{
	var BRLRowID=getElementValue("RowID");
	if (BRLRowID=="")
	{
		messageShow("","","",t[-9205]);
		return;
	}
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+getElementValue("RowID")+'&MaintItemDR='+getElementValue("MaintItemDR")+'&Status='+getElementValue("Status");
    if (getElementValue("RoleStep")!=6) var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+getElementValue("RowID")+'&MaintItemDR='+getElementValue("MaintItemDR")+'&Status=0';		//非维修选择配件步骤
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=500,left=80,top=0')
}
///保修
function BSerContract_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&EquipDR="+getElementValue("MREXObjDR")+"&ReadOnly=1"
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
///设备信息
function BEquipInfo_Click()
{
	if (getElementValue("EQNo")=="") return;
  	var EQNo=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",getElementValue("EQNo"));
	if (EQNo=="") return;
	var str="dhceqequiplistnew.csp?&ReadOnly=1&RowID="+EQNo;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		str += "&MWToken="+websys_getMWToken()
	}
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=980,height=800,left=200,top=10');
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function createEvaluateWin(vElementID,vEvaluationDR,vEReadOnly)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		//生成DIV前先清空原有内容
		jQuery("#"+vElementID).empty();
		if (vEReadOnly==false)
		{
			var GetEvaluateInfo=tkMakeServerCall("web.DHCEQ.EM.BUSEvaluate","GetEvaluateInfo",vEvaluationDR);
		}
		else
		{
			var GetEvaluateInfo=tkMakeServerCall("web.DHCEQ.EM.BUSEvaluate","GetUserEvaluateInfo",vEvaluationDR);
		}
		var GetEvaluateObj=JSON.parse(GetEvaluateInfo)
		var MLEvaluateInfo=GetEvaluateObj.Data.split("&")
		var GetEvaluateMaster=MLEvaluateInfo[0]
		var GetEvaluateList=MLEvaluateInfo[1]
		var EvaluateInfo=GetEvaluateList.split("@")
		var table=jQuery("<table>");
	 	table.appendTo(jQuery("#"+vElementID));
		for (var i=0;i<EvaluateInfo.length;i++)
		{
			var OneEvaluateInfo=EvaluateInfo[i].split("^")
			var caption=OneEvaluateInfo[2]+":"
			var id="StarEvaluate"+(i+1)
			var starnum=OneEvaluateInfo[3]
			var escore=OneEvaluateInfo[6]
			var tHints=new Array();
			if (OneEvaluateInfo[4]!="")
			{
				var HintsInfo=OneEvaluateInfo[4].split(",")
				for (var j=0;j<HintsInfo.length;j++)
				{
					tHints.push(HintsInfo[j])
				}
			}
			var tr=jQuery("<tr height=\"30px\">")
			tr.appendTo(table);
			var td="<td align=\"right\">"+caption+"</td>"
			td=td+"<td><div id=\""+id+"\" style=\"margin-left:5px;\"></div></td>"
			//td=td+"<td><lable id=\""+id+"Score\"></lable></td>"
			td=jQuery(td)
			td.appendTo(tr);
			var trend=jQuery("</tr>")
			trend.appendTo(table);
			//生成星号评价插件
			fStarEvaluate(id,1,starnum,true,escore,tHints,vEReadOnly);
//			if (escore>starnum)
//			{
//				jQuery("#"+id+"Score").text(starnum+"分")
//			}
//			else
//			{
//				jQuery("#"+id+"Score").text(escore+"分")
//			}
			tEvaluate[i]=id+"^"+OneEvaluateInfo[0]+"^"+OneEvaluateInfo[1]+"^"+OneEvaluateInfo[5];
		}
		jQuery("#"+vElementID).append("</table>");
	}
}

function linkClick()
{
	selectTab("tOtherTabs","tMaintBuss")
}
function createMaintHistory(vEQRowID)
{
	if (vEQRowID=="") return
	var MaintHistory=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetMaintHistory",vEQRowID)
	var MaintHistoryObj=jQuery.parseJSON(MaintHistory)
	if (MaintHistoryObj.SQLCODE<0) return
	var MaxKey=""
	for (var key in MaintHistoryObj.Data){MaxKey=key}
	for (var key in MaintHistoryObj.Data)
	{
		var RowID="MaintHistoryID"+key
		var OntMaintInfo=MaintHistoryObj.Data[key]
		var RequestDate=OntMaintInfo["RequestDate"]
		var RequestUser=OntMaintInfo["RequestUser"]
		var FaultCaseDR=OntMaintInfo["FaultCaseDR"]
		var FaultCase=OntMaintInfo["FaultCase"]
		var FaultReasonDR=OntMaintInfo["FaultReasonDR"]
		var FaultReason=OntMaintInfo["FaultReason"]
		var DealMethodDR=OntMaintInfo["DealMethodDR"]
		var DealMethod=OntMaintInfo["DealMethod"]
		var AcceptUser=OntMaintInfo["AcceptUser"]
//		//历史维修记录
//		var treeObj=$("#tMaintHistorytree").tree("find",RowID)
//		if (!treeObj)
//		{
//			var childdata=[{"id":RowID+"_U","text":RequestUser},{"id":RowID+"_F","text":FaultCase}]
//			var treedata=[{"id":RowID,"text":RequestDate,"children":childdata}]
//			$("#tMaintHistorytree").tree('append', {data:treedata});
//			
//			$("#tMaintHistory").find("span").removeClass("tree-folder")
//			var spanobj=$("#tMaintHistory").find("span.tree-icon")
//			spanobj.eq(0).attr("class","")
//			spanobj.eq(1).prev().attr("class","")
//			spanobj.eq(1).attr("class","tree-file")
//			spanobj.eq(2).prev().attr("class","")
//			spanobj.eq(2).attr("class","tree-file")
//		}
		//历史维修记录
		var flag=""
		if (key==MaxKey) flag=1
		var options={id:'tMaintHistorytree',section:'',item:'^^'+RequestDate+'%eq-user.png^^'+AcceptUser+'%eq-faultcase.png^^'+FaultCase,lastFlag:flag}
		createTimeLine(options)
		//知识库
		if (FaultCaseDR!="")
		{
			var KnowledgeF="Knowledge_"+FaultCaseDR
			var FaultCaseObj=appendTree("tKnowledgetree","Knowledge_"+FaultCaseDR,FaultCase,"")
			if ((FaultCaseObj!=null)&&(FaultReasonDR!=""))
			{
				var KnowledgeR=KnowledgeF+"_"+FaultReasonDR
				var FaultReasonObj=appendTree("tKnowledgetree",KnowledgeR,FaultReason,KnowledgeF)
				if ((FaultReasonObj!=null)&&(DealMethodDR!=""))
				{
					var KnowledgeD=KnowledgeR+"_"+DealMethodDR
					appendTree("tKnowledgetree",KnowledgeD,DealMethod,KnowledgeR)
				}
			}
			//$("#tKnowledge").find("span").removeClass("tree-folder tree-file")
		}
	}
}
function onBeforeShowPanel(vElementID)
{
	if (vElementID=="MRExObjDR_ExObj")
	{
		//modified by 2022-4-12 MRSourceType关键字
		var SourceType=$("#MRSourceType").keywords("getSelected")
	    if ((SourceType)||(SourceType!=undefined)) SourceType=SourceType[0].id

		setElement("FacilityFlag",0)
		if ((SourceType=="2")||(SourceType=="3")){setElement("FacilityFlag",1)}
		if (getElementValue("MRObjLocDR")=="")
		{
			var Info=t[-9202]
			Info=Info.replace("[Caption]",getElementValue("cMRObjLocDR_LocDesc"));
			messageShow("","","",Info)
			return false
		}
	}
	return true
}
// add by sjh 2019-12-03 BUG00018 
//modify by wl 2019-12-16 WL0027 删除不必要的值,修正UserName,该界面加上直接打印方法报错
function BPrint_Clicked()
{
	var PreviewRptFlag=getElementValue("PreviewRptFlag");
	var RowID=getElementValue("RowID")
	var fileName=""	
	var HOSPDESC = getElementValue("GetHospitalDesc");
	//Add By QW20210913 BUG:QW0147 标题增加补打标记	begin
	var EQTitle="";
	var PrintNumFlag=getElementValue("PrintNumFlag");
	if(PrintNumFlag==1)  
	{
		var num=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","GetOperateTimes","31",RowID)
		if(num>0) EQTitle="(补打)";
	}
	if(PreviewRptFlag==1)
	{
		var fileName="DHCEQMMaintRequestPrint.raq&RowID="+RowID
			+"&HOSPDESC="+HOSPDESC
			+"&USERNAME="+curUserName+"&EQTitle="+EQTitle
			DHCCPM_RQPrint(fileName);
	}
	if(PreviewRptFlag==0)
	{
		var fileName="{DHCEQMMaintRequestPrint.raq(RowID="+RowID
			+";HOSPDESC="+HOSPDESC
			+";USERNAME="+curUserName
			+";EQTitle="+EQTitle+")}"; 
			DHCCPM_RQDirectPrint(fileName);
	}	
	var MaintRequestPrintOperateInfo="^31^"+RowID+"^^维修打印操作^0"
	var PrintFlag=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","SaveData",MaintRequestPrintOperateInfo)
	//Modified By QW20210913 BUG:QW0147 修改打印次数  end
}

function BEvaluate_Clicked()
{
	alertShow("待开发")
}
///Modefidy by zc 2018-10-29 ZC0041  多人协助
function BMaintUser_Click()
{
	var SourceID=getElementValue("RowID");
	if (SourceID=="")
	{
		alertShow("无设备维修申请信息!");
		return;
	}
	var para="SourceType=31&SourceID="+SourceID+"&Action="+getElementValue("Action")
    var url='dhceq.em.maintuserlist.csp?'+para;
    openModelDlg(url,"1200","650","维修协助人员","")
}
///add by jyp 2020-03-12 JYP0023
function BCancel_Clicked()
{
	var RowID=getElementValue("RowID")
	if (RowID=="")	{messageShow("","","",t[-9205]);	return;	}
	messageShow("confirm","info","提示",t[-9206],"",bcanceltrue,"")
}
function bcanceltrue()
{
	var RowID=getElementValue("RowID")
	var Ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelMaintRequest",RowID)
	var RetObj=jQuery.parseJSON(Ret)
	if (RetObj.SQLCODE<0)
	{
		messageShow("","","",RetObj.Data)
		return;
	}
	messageShow("","","",RetObj.Data);
	websys_showModal("options").mth("31");  //modify by zx 2022-04-11 bug ZX0144
	//Modeied by zc0094 2021-1-14 修正维修单作废页面问题 begin
	window.setTimeout(function()
	{	
		if (getElementValue("MRMaintType")!="1")
		{
			var url="dhceq.em.hardwaremaintsimple.csp?&RowID=&Status=0";
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			if ((getElementValue("MRManageTypeDR")=="4")&&(getElementValue("QXType")==1)) //Modified BY QW20211229
			{
				window.location.href= url
			}
			else{
				window.location.href= url
			}
		}
		else
		{
			var url="dhceq.em.mmaintrequest.csp?&RowID=&Status=0&MaintType=1";
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			window.location.href= url
		}
	},50); 
	//Modeied by zc0094 2021-1-14 修正维修单作废页面问题 end
}
function confirmselect(confirminfo)
{
	return messageShow("confirm","info","提示",confirminfo,"",selecttrue,selectfalse)
}

//add by mwz 2021-01-18 MWZ0048
function BSelfCancelSubmit_Clicked()
{
	var RowID=getElementValue("RowID");
	var Status=getElementValue("Status")
	
	if (Status>1)
	{
		messageShow('alert','error','提示',"该单据已审核完成,无法撤消");
		return;
		}
	var combindata=RowID+"^"+getElementValue("RoleStep")+"^"+getElementValue("Action")   /// Modify by mwz 20210529 MWZ0050
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","SelfCancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE==0)
    {
	  	messageShow("alert","info","提示","撤回成功");
		var val="&RowID="+RowID+"&QXType="+getElementValue("QXType")+"&CurRole="+getElementValue("CurRole");
		if (getElementValue("CurRole")=="")
		{
			if ((getElementValue("MRManageTypeDR")=="4")&&(getElementValue("QXType")==1)) //Modified BY QW20211229
			{
				url="dhceq.em.hardwaremaintsimple.csp?"+val;
			}else{
				url="dhceq.em.mmaintrequestsimple.csp?"+val;
			}			
		}
		else
		{
			url="dhceq.em.mmaintrequest.csp?"+val;	
		}
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
    else
    {
	     messageShow("alert","error","错误提示","错误信息:"+RtnObj.Data);
    }
  }
///add by wy 2021-11-15 报修界面增加台帐编译界面
function BEquipList_Clicked()
{   
	var RowID=getElementValue("RowID");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetOneMaintRequest",RowID,"","","")
	var jsonObj=jQuery.parseJSON(jsonData)
	var EquipDR=jsonObj.Data["MRExObjDR_EQRowID"]
	var ReadOnly=getElementValue("ReadOnly");
	var url="dhceq.em.equipedit.csp?RowID="+EquipDR+"&ReadOnly="+ReadOnly;
	showWindow(url,"资产信息编辑","","15row","icon-w-paper","modal","","","large"); 
}
///add by wy 2021-11-15
///描述:获取服务商录入方式 0:放大镜 1:手工录入,并自动检测更新服务商 2:
function getServiceRowID(type,ElementID,ElementName)
{
	if((type=="0")||(type==""))
	{
		 var ServiceRowID=getElementValue(ElementID)  //modified by wy 2022-9-28 2955208
	}
	else
	{
		var ServiceRowID=""
		var ServiceName=getElementValue(ElementName);
		if (ServiceName=="") return "";
		var FirmType=4
	 	var val="^"+ServiceName+"^^^"+FirmType;		//2163109 czf
		var ServiceRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		//if (ServiceRowID>0) setElement(ElementID,ServiceRowID);
	}
	return ServiceRowID
}
function MaintProcess()
{
	var RowID=getElementValue("RowID");
	var MaintProcess=getElementValue("MRHold15");
	var Result=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","UpdMaintProcess",RowID,MaintProcess);		
	window.setTimeout(function(){window.location.reload()},50); 
}

function BAppendFile_Clicked()
{
	var RowID=getElementValue("RowID")
	var Status=getElementValue("Status");
	var str='dhceq.plat.appendfile.csp?&CurrentSourceType=31&CurrentSourceID='+RowID+'&Status='+Status+'&ReadOnly=';
	showWindow(str,"电子资料","","","icon-w-paper","modal","","","large");
}
