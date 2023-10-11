var EQInOutColumns=getCurColumnsInfo('BA.G.EquipBenefitInfo','','','');
var EQInOutLength=EQInOutColumns[0].length;
for (var i=0;i<EQInOutLength;i++)
{
	var FieldName=EQInOutColumns[0][i].field;
	if ((FieldName=="TName")||(FieldName=="TEquipNo")||(FieldName=="TStoreLoc")||(FieldName=="TStatCat")||(FieldName=="TEquipCat")||(FieldName=="TItem")||(FieldName=="TModel")||(FieldName=="TOriginalFee"))
	{
		EQInOutColumns[0][i].hidden=true;
	}
}
var ResearchColumns=getCurColumnsInfo("EM.G.Research",'','','');
var ResearchSColumns=getCurColumnsInfo("EM.G.ResearchS",'','','');
var ConsumableColumns=getCurColumnsInfo("EM.G.UseConsumable",'','','');
var OperatingColumns=getCurColumnsInfo('BA.G.EQStateInfo','','','')
var MaintRequestColumns=getCurColumnsInfo("EM.G.EQMaintRequest",'','','');
var MaintenanceColumns=getCurColumnsInfo("DHCEQ.G.Maint.MaintList",'','','');
var MaintenanceLength=MaintenanceColumns[0].length;
for (var i=0;i<MaintenanceLength;i++)
{
	var FieldName=MaintenanceColumns[0][i].field;
	if ((FieldName=="TRow")||(FieldName=="TEquipNo")||(FieldName=="TEquip")||(FieldName=="TModel")||(FieldName=="TUseLoc"))
	{
		MaintenanceColumns[0][i].hidden=true;
	}
}
var node="web.DHCEQ.BA.RPTEchart_GetEquipBenefit";

jQuery(document).ready(function()
{
	defindTitleStyle();
	initUserInfo();
	var ChartsParams=node+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+curSSUserID+","+curSSLocID+","+curSSGroupID+","+$("#EQRowID").val();
	initEchartsObjMap();
	initChartsDefine("BAEQInOutAmount^BAEQCheckPerson^BAEQWorkAmount^BAEQCostAmount^BAEQMaintAmount^EQMonthInOut^EQMonthWorkLoad^EQFixedCost^EQVariableCost^CompareServiceIncome^CompareMaterialFee^CompareMaintFee^CompareFeeOfEmployee",ChartsParams);
	initPersonCharts();
	//initButton();
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BFind").linkbutton({text:'��ѯ'});
	fillData();
	initEQInOutGrid();		//�豸��֧��ϸ
	initEQConsumableGrid();	//ʹ�úĲ���ϸ
	initEQResearchGrid();	//��������
	initEQFuncDevelop();	//���ܿ���
	initEQOperatingGrid();	//�豸������Ϣ
	initEQMaintGrid();		//�豸ά�޼�¼
	initEQMaintenanceGrid();//�豸Ѳ�졢������������¼
});

function initEchartsObjMap()
{
	EchartsObjMap["BAEQInOutAmount"]="BAEQInOutAmount";
	EchartsObjMap["BAEQCheckPerson"]="BAEQCheckPerson";
	EchartsObjMap["BAEQWorkAmount"]="BAEQWorkAmount";
	EchartsObjMap["BAEQCostAmount"]="BAEQCostAmount";
	EchartsObjMap["BAEQMaintAmount"]="BAEQMaintAmount";
	EchartsObjMap["EQMonthInOut"]="EQInOutAnaly";
	EchartsObjMap["EQMonthWorkLoad"]="EQWorkLoadAnaly";
	EchartsObjMap["EQFixedCost"]="EQFixedCost";
	EchartsObjMap["EQVariableCost"]="EQVariableCost";
	EchartsObjMap["CompareServiceIncome"]="CompareServiceIncome";
	EchartsObjMap["CompareMaterialFee"]="CompareMaterialFee";
	EchartsObjMap["CompareMaintFee"]="CompareMaintFee";
	EchartsObjMap["CompareFeeOfEmployee"]="CompareFeeOfEmployee";
}

function initPersonCharts()
{
	var StartDate=$('#StartDate').datebox('getText')+"-01"
	var EndDate=$('#EndDate').datebox('getText');
	if (EndDate=="") return;
	EndDate=EndDate+"-"+GetMonthEndDate(EndDate);
	var vData="^EquipID="+getElementValue("EQRowID")+"^StartDate="+StartDate+"^EndDate="+EndDate;
	var ChartsParams=vData+","+"web.DHCEQ.BA.RPTEchart_PersonTimes"+","+$('#Job').val();
	EchartsObj=new Array();
	EchartsObjMap=new Array();
	EchartsObjOption=new Array();
	EchartsObjMap["PatientNum"]="PatientNum";
	EchartsObjMap["AvgTime"]="AvgTime";
	initChartsDefine("PatientNum^AvgTime",ChartsParams);
}

function fillData()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
	var Data=jsonData.Data;
	$("#EQName").text(Data.EQName);
	$("#EQNo").text(Data.EQNo);
	$("#EQModel").text(Data.EQModelDR_MDesc);
	$("#EQUseLoc").text(Data.EQStoreLocDR_CTLOCDesc);
	$("#EQProvider").text(Data.EQProviderDR_VName);
	$("#EQManuFactory").text(Data.EQManuFactoryDR_MFName);
	$("#EQLeaveFactoryNo").text(Data.EQLeaveFactoryNo);
	$("#EQOriginalFee").text(Data.EQOriginalFee);
	$("#EQStartDate").text(Data.EQStartDate);
	$("#EQLimitYearsNum").text(Data.EQLimitYearsNum);
}

//�豸Ч����ϸ��Ϣ
function initEQInOutGrid()
{
	$HUI.datagrid("#EQInOutGrid",{
		url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.BA.RPTBaseList",
	        	QueryName:"GetBenefitEquip",
				StartDate:$('#StartDate').datebox('getText'),
				EndDate:$('#EndDate').datebox('getText'),
				CurUserID:curUserID,
				CurLocID:curLocID,
				CurGroupID:curSSGroupID,
				EquipDR:getElementValue('EQRowID')
			},
			toolbar:[],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:EQInOutColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

//�Ĳ�ʹ����Ϣ
function initEQConsumableGrid()
{
	$HUI.datagrid("#EQConsumableGrid",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.BA.RPTBaseList",
	        	QueryName:"GetUseComsumable",
		        EquipDR:getElementValue('EQRowID'), 		        
		        StartDate:$('#StartDate').datebox('getText'),
		        EndDate:$('#EndDate').datebox('getText'),
		        CurLocID:curLocID,
		        CurGroupID:curSSGroupID
			},
			toolbar:[],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:ConsumableColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

//��������
function initEQResearchGrid()
{
	$HUI.datagrid("#EQResearchInfo",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSResearch",
	        	QueryName:"ResearchList",
		        BussType:"0", 		        
		        SourceType:"2",
		        SourceID:getElementValue("EQRowID"),
		        RFunProFlag:0
			},
			toolbar:[],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:ResearchColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

//���ܿ���
function initEQFuncDevelop()
{
	$HUI.datagrid("#EQFuncDevelopment",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSResearch",
	        	QueryName:"ResearchList",
		        BussType:"0", 		        
		        SourceType:"2",
		        SourceID:getElementValue("EQRowID"),
		        RFunProFlag:1
			},
			toolbar:[],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:ResearchSColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

//������Ϣ
function initEQOperatingGrid()
{
	$HUI.datagrid("#EQOperatingInfo",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.BA.StateInfo",
	        	QueryName:"EQStateInfo",
        		EquipDR:getElementValue("EQRowID"),
       		 	StartMonth:$('#StartDate').datebox('getText'),
        		EndMonth:$('#EndDate').datebox('getText')
			},
			toolbar:[],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:OperatingColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

//ά�޼�¼
function initEQMaintGrid()
{
	$HUI.datagrid("#EQMaintRequestInfo",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSMMaintRequest",
	        	QueryName:"GetEQMaintHistory",
		        EquipDR:getElementValue("EQRowID"),
       		 	StartMonth:$('#StartDate').datebox('getText'),
        		EndMonth:$('#EndDate').datebox('getText')
			},
			toolbar:[],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:MaintRequestColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

//ά����¼
function initEQMaintenanceGrid()
{
	var StartDate=$('#StartDate').datebox('getText')+"-01"
	var EndDate=$('#EndDate').datebox('getText');
	if (EndDate=="") return;
	EndDate=EndDate+"-"+GetMonthEndDate(EndDate);
	$HUI.datagrid("#EQMaintenanceInfo",{
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSMaint",
	        	QueryName:"GetMaint",
		        EquipDR:getElementValue("EQRowID"),
		        StartDate:StartDate,
		        EndDate:EndDate,
		        Status:"2"
			},
			toolbar:[],
			rownumbers: true,
			singleSelect:true,
			fit:true,
			border:false,
			columns:MaintenanceColumns,
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100]
	});
}

function BFind_Clicked()
{
	var val="&StartDate="+$('#StartDate').datebox('getText')+"&EndDate="+$('#EndDate').datebox('getText')+"&Job="+$("#Job").val()+"&EQRowID="+$("#EQRowID").val();
	url="dhceq.ba.equipbenefitanaly.csp?"+val;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}

function GetResearchType()
{}

function EQUser()
{}

function GetUsedFlag()
{}

function GetFuncProjType()
{}

function GetInvalidFlag()
{}

function maintHistoryList(index)
{
	var curRowObj=$('#EQMaintenanceInfo').datagrid('getRows')[index];
	var MPType="";
	var MaintType="";
	var EquipDR=getElementValue("EQRowID");
	$.cm({
		ClassName:"web.DHCEQ.EM.BUSMaint",
		QueryName:"GetMaint",
		BussType:MPType,
		EquipDR:EquipDR,
		MaintTypeDR:MaintType
	},function(jsonData){
		if(jsonData.rows.length<1)
		{
			alertShow("û����ʷά����¼");
			return;
		}
		else
		{
			var url="dhceq.em.mainthistorylist.csp?&MPType="+MPType+"&MaintType="+MaintType+"&EquipDR="+EquipDR;
			showWindow(url,"��ʷά����¼","","16row","icon-w-paper","modal","","","small")
		}
	});
}