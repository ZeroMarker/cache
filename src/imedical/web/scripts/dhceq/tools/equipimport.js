$(document).ready(function () {
    initDocument();
});
function initDocument()
{
	initUserInfo();
	initMessage();
	initEvent();
	initEquipTypeIDS();
	initStoreLocDR();
	initDepreTypeDR();
	initKeepDepreFee();
	initAdjustFlag();
	initInputFlag();
	initIsCurMonth();
	initReportEquipTypeIDS();
	initReportStoreLocDR();
	hiddenDepreElements(true);
	initTaskGrid();
	//initDepreGrid();
	//initReportGrid();
	//initSnapGrid();
	$HUI.tabs("#TabsData",{
		onSelect:function(title)
		{
			if (title=="新加数据导入")
			{
				hiddenDepreElements(true);
			}
			else if (title=="追加数据导入")
			{
				hiddenDepreElements(false);
			}
		}
	});
	$HUI.checkbox('#IsManageLocData',{
		onChecked:function(event,val){
			$("#AddAdjust").css('display','none');
			$("#AddInitReport").css('display','block');
		},
		onUnchecked:function(event,val){
			$("#AddAdjust").css('display','block');
			$("#AddInitReport").css('display','none');
		}
	});
}

function initEvent()
{
	jQuery("#BImport").on("click", BImport_Clicked);
	jQuery("#BDownLoad").on("click", BDownLoad_Clicked);
	jQuery("#BAddImport").on("click", BImport_Clicked);
	jQuery("#BAddDownLoad").on("click", BDownLoad_Clicked);
	jQuery("#BAdustData").on("click", BAdustData_Clicked);
	jQuery("#BDownLoadAdustdata").on("click", BDownLoadAdustdata_Clicked);
	
	jQuery("#BInitDepre").on("click", BInitDepre_Clicked);	//初始化折旧
	jQuery("#BInitSnap").on("click", BInitSnap_Clicked);	//初始化快照
	jQuery("#BInitReport").on("click", BInitReport_Clicked);	//初始化月报
	jQuery("#BAddInitDepre").on("click", BAddInitDepre_Clicked);	//追加数据初始化折旧
	jQuery("#BAddInitReport").on("click", BInitReport_Clicked);	//追加数据初始化月报
	
	jQuery("#BExeInitDepre").on("click", BExeInitDepre_Clicked);
	jQuery("#BCloseDepre").on("click", BCloseDepre_Clicked);
	jQuery("#BExeInitReport").on("click", BExeInitReport_Clicked);
	jQuery("#BCloseReport").on("click", BCloseReport_Clicked);
}

//初始化类组
function initEquipTypeIDS()
{
	$HUI.combogrid('#EquipType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'全选',width:150},
	    ]]
	});
}

//初始化科室
function initStoreLocDR()
{
	singlelookup("StoreLoc","PLAT.L.Loc");
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID);
}

//初始化折旧类型
function initDepreTypeDR()
{
	$HUI.combogrid('#DepreType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQCDepreMethod",
	        QueryName:"DepreType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    columns:[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'折旧类型',width:150}
	    ]],
	    onSelect:function(index,rowData){
			setElement("DepreTypeDR",rowData.TRowID);
		}
	});
}
	
function initKeepDepreFee()
{
	var KeepDepreFee = $HUI.combobox("#KeepDepreFee",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:'否'},
			{id:'1',text:'是'}
		]
	});
}
function initAdjustFlag()
{
	var AdjustFlag = $HUI.combobox("#AdjustFlag",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'N',text:'否'},
			{id:'Y',text:'是'}
		]
	});
}
function initInputFlag()
{
	var InputFlag = $HUI.combobox("#InputFlag",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'N',text:'否'},
			{id:'Y',text:'是'}
		]
	});
}
function initIsCurMonth()
{
	var IsCurMonth = $HUI.combobox("#IsCurMonth",{
		valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'0',text:'上月'},
			{id:'1',text:'当月'}
		]
	});
}

function initReportEquipTypeIDS()
{
	$HUI.combogrid('#ReportEquipType',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'全选',width:150},
	    ]]
	});
}

function initReportStoreLocDR()
{
	singlelookup("ReportStoreLoc","PLAT.L.Loc");
}

function BImport_Clicked()
{
	var url="dhceqimportdata.csp?";
	showWindow(url,"数据导入","","","icon-w-paper","modal","","","verylarge"); 
}

function BDownLoad_Clicked()
{
	/*ecp路径配置取不到主web信息
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQEquipImport.xls";
	window.open(TemplatePath)
	*/
	//czf 2022-04-06
	var AFRowID=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetAppenfFileIDBySource","67","1",32,"数据准备模板");
	if (AFRowID=="")
	{
		alertShow("数据准备模板不存在,请在公告管理中上传《数据准备模板.xls》!")
		return;
	}
	var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetFtpStreamSrcByAFRowID",AFRowID);
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		ftpappendfilename += "&MWToken="+websys_getMWToken()
	}
	window.open(ftpappendfilename)
}

function BAdustData_Clicked()
{
	messageShow("confirm","alert","","确认是否是整个管理科室数据追加？","",function(){
		$("#IsManageLocData").checkbox('setValue',true);
		alertShow("请执行初始化月报!")
		return;
	},function(){
		$("#IsManageLocData").checkbox('setValue',false);
		var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAdjustDataFind&UserFlag=false";
		showWindow(url,"批量数据调整","","","icon-w-paper","modal","","","verylarge");
	},"是","否");
}

function BDownLoadAdustdata_Clicked()
{
	/*
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath")+"DHCEQAdjustData.xls";
	window.open(TemplatePath)
	*/
	//czf 2022-04-06
	var AFRowID=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetAppenfFileIDBySource","67","2",32,"批量数据调整");
	if (AFRowID=="")
	{
		alertShow("批量数据调整模板不存在,请在公告管理中上传《批量数据调整.xls》模板!")
		return;
	}
	var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetFtpStreamSrcByAFRowID",AFRowID);
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		ftpappendfilename += "&MWToken="+websys_getMWToken()
	}
	window.open(ftpappendfilename)
}

function BInitDepre_Clicked()
{
	messageShow("confirm","alert","","请仔细阅读注意事项内容,确保参数已配置后再执行！","",function(){
		clearDepreData();
		setRequiredElements("vDate^KeepDepreFee");
		$HUI.dialog('#DepreWin', {
			iconCls:'icon-w-paper',
			width: 1100,
			height: 335,
			modal:true,
			title: '初始化折旧',
			onOpen: function(){
				
			}
		}).open();
	},function(){
		return;
	},"继续","取消");
}

function BAddInitDepre_Clicked()
{
	messageShow("confirm","alert","","请仔细阅读注意事项内容,确保参数已配置后再执行！","",function(){
		clearDepreData();
		setElement("InputFlag","Y");
		setRequiredElements("vDate^KeepDepreFee");
		$HUI.dialog('#DepreWin', {
			iconCls:'icon-w-paper',
			width: 1100,
			height: 485,
			modal:true,
			title: '追加数据初始化折旧',
			onOpen: function(){
				
			}
		}).open();
	},function(){
		return;
	},"继续","取消");
}

//初始化快照
function BInitSnap_Clicked()
{
	var	result=tkMakeServerCall("web.DHCEQInit","InitSnap")
	if (result==0)
	{
		alertShow("执行成功!")
	}
	else
	{
		alertShow("执行失败!")
	}
	//initSnapGrid();
	initTaskGrid();
}

function BInitReport_Clicked()
{
	messageShow("confirm","alert","","请仔细阅读注意事项内容,并确认之前步骤已执行！","",function(){
		clearReportData();
		setRequiredElements("IsCurMonth");
		$HUI.dialog('#ReportWin', {
			iconCls:'icon-w-paper',
			width: 750,
			height: 205,
			modal:true,
			title: '初始化月报',
			onOpen: function(){
				//
			}
		}).open();
	},function(){
		return;
	},"继续","取消");
}

//初始化折旧
function BExeInitDepre_Clicked()
{
	if (checkMustItemNull("")) return
	var EquipTypeIDS=$("#EquipType").combogrid('getValues').toString()
	var	result=tkMakeServerCall("web.DHCEQInit","InitEquipDepre",getElementValue("vDate"),EquipTypeIDS,getElementValue("StoreLocDR"),getElementValue("DepreTypeDR"),getElementValue("KeepDepreFee"),getElementValue("MinEquipID"),getElementValue("MaxEquipID"),getElementValue("DepreMonthNum"),getElementValue("AdjustFlag"),getElementValue("InputFlag"))
	if (result==0)
	{
		alertShow("执行成功!")
		BCloseDepre_Clicked()
	}
	else
	{
		alertShow("有"+result+"条数据未初始化!")
	}
	//initDepreGrid();
	initTaskGrid();
}

//初始化月报
function BExeInitReport_Clicked()
{
	if (getElementValue("IsCurMonth")=="") 
	{
		alertShow("初始化月份不能为空!")
		return;
	}
	var ReportEquipTypeIDS=$("#ReportEquipType").combogrid('getValues').toString()
	var ReportStoreLocDR=getElementValue("ReportStoreLocDR");
	var result=tkMakeServerCall("web.DHCEQInit","InitReport",getElementValue("IsCurMonth"),ReportEquipTypeIDS,ReportStoreLocDR)
	alertShow("执行完成!")
	BCloseReport_Clicked()
	//initReportGrid();
	initTaskGrid();
}

function BCloseDepre_Clicked()
{
	$HUI.dialog("#DepreWin").close();
}

function BCloseReport_Clicked()
{
	$HUI.dialog("#ReportWin").close();
}

function hiddenDepreElements(value)
{
	hiddenObj("cMinEquipID",value);
	hiddenObj("MinEquipID",value);
	hiddenObj("cMaxEquipID",value);
	hiddenObj("MaxEquipID",value);
	hiddenObj("cDepreMonthNum",value);
	hiddenObj("DepreMonthNum",value);
	hiddenObj("cAdjustFlag",value);
	hiddenObj("miniddesc",value);
	hiddenObj("maxiddesc",value);
	hiddenObj("deprenumdesc",value);
	hiddenObj("adjustdesc",value);
	hiddenObj("inputdesc",value);
	if (value==true||value==1) $("#AdjustFlag").next().hide();
	else $("#AdjustFlag").next().show();
	hiddenObj("cInputFlag",value);
	if (value==true||value==1) $("#InputFlag").next().hide();
	else $("#InputFlag").next().show();
}

function initTaskGrid()
{
	var initTaskObj=$HUI.datagrid("#tDHCEQInitTask",{
		url:$URL,
		border:false,
	    fit:true,
	    toolbar:[],
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitTaskInfo"
		},
	    columns:[[
	    	{field:'TaskType',title:'任务类型'},
			{field:'ExeDate',title:'执行时间'},
			{field:'result',title:'执行结果'},
			{field:'InitDate',title:'初始化至该日期'},
			{field:'EquipTypes',title:'管理类组'},
			{field:'StoreLoc',title:'科室'},
			{field:'DepreType',title:'折旧类型'},
			{field:'KeepDepreFee',title:'是否保留累计折旧'},
			{field:'MinEquipID',title:'最小设备ID'},
			{field:'MaxEquipID',title:'最大设备ID'},
			{field:'DepreMonthNum',title:'补提折旧月数'},
			{field:'AdjustFlag',title:'是否新增数据调整'},
			{field:'InputFlag',title:'是否只初始化导入数据'},
			{field:'IsCurMonth',title:'是否当前月'}
		]]
	});
}

///初始化折旧结果
function initDepreGrid()
{
	var initDepreObj=$HUI.datagrid("#tDHCEQInitDepre",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitDepreInfo"
		},
	    columns:[[
			{field:'ExeDate',title:'执行时间'},
			{field:'result',title:'执行结果'},
			{field:'InitDate',title:'初始化至该日期'},
			{field:'EquipTypes',title:'管理类组'},
			{field:'StoreLoc',title:'科室'},
			{field:'DepreType',title:'折旧类型'},
			{field:'KeepDepreFee',title:'是否保留累计折旧'},
			{field:'MinEquipID',title:'最小设备ID'},
			{field:'MaxEquipID',title:'最大设备ID'},
			{field:'DepreMonthNum',title:'补提折旧月数'},
			{field:'AdjustFlag',title:'是否新增数据调整'},
			{field:'InputFlag',title:'是否只初始化导入数据'}
		]]
	});
}

///初始化月报结果
function initReportGrid()
{
	var initReportObj=$HUI.datagrid("#tDHCEQInitReport",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitReportInfo"
		},
	    columns:[[
			{field:'ExeDate',title:'执行时间'},
			{field:'result',title:'执行结果'},
			{field:'IsCurMonth',title:'是否当前月'},
			{field:'EquipTypes',title:'管理类组'},
			{field:'StoreLoc',title:'科室'}
		]]
	});
}

///初始化快照结果
function initSnapGrid()
{
	var initSnapObj=$HUI.datagrid("#tDHCEQInitSnap",{
		url:$URL,
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
		pagination:true,
		pageSize:15,
		pageList:[15,30,50],
		queryParams:{
			ClassName:"web.DHCEQInit",
			QueryName:"GetInitSnapInfo"
		},
	    columns:[[
			{field:'ExeDate',title:'执行时间'},
			{field:'result',title:'执行结果'}
		]]
	});
}

function clearDepreData()
{
	setElement("vDate","");
	setElement("MinEquipID","");
	setElement("EquipType","");
	setElement("MaxEquipID","");
	setElement("StoreLoc","");
	setElement("DepreMonthNum","");
	setElement("DepreType","");
	setElement("AdjustFlag","");
	setElement("KeepDepreFee","");
	setElement("InputFlag","");
	setElement("DepreTypeDR","");
	setElement("StoreLocDR","");
}

function clearReportData()
{
	setElement("IsCurMonth","");
	setElement("ReportEquipType","");
	setElement("ReportStoreLoc","");
	setElement("ReportStoreLocDR","");
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","");
}
