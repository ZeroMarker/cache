var SessionObj = {
	GUSERID : curUserID,
	GUSERCODE : curUserCode,
	GUSERNAME : curUserName,
	GGROURPID : session['LOGON.GROUPID'],
	GGROURPDESC : session['LOGON.GROUPDESC'],
	GLOCID : curLocID,
	GHOSPID : session['LOGON.HOSPID'],
	LANGID : session['LOGON.LANGID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp"
};
var GlobalObj = {
	PlanDR : "",
	SourceTypeDR : "",
	EquipDR : "",
	ModelDR : "",
	MaintUserDR : "",
	MaintLocDR : "",
	MaintTypeDR : "",
	NotSendMessFlagDR : "",
	UseLocDR : "",
	InvalidMsgFlagDR : "",
	ItemDR : "",
	EquipTypeDR : "",
	StatCatDR : "",
	EquipCatDR : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="Plan") {this.PlanDR = "";}
		if (vElementID=="SourceType") {this.SourceTypeDR = "";}
		if (vElementID=="Equip") {this.EquipDR = "";}
		if (vElementID=="Model") {this.ModelDR = "";}
		if (vElementID=="MaintUser") {this.MaintUserDR = "";}
		if (vElementID=="MaintLoc") {this.MaintLocDR = "";}
		if (vElementID=="MaintType") {this.MaintTypeDR = "";}
		if (vElementID=="NotSendMessFlag") {this.NotSendMessFlagDR = "";}
		if (vElementID=="UseLoc") {this.UseLocDR = "";}
		if (vElementID=="InvalidMsgFlag") {this.InvalidMsgFlagDR = "";}
		if (vElementID=="Item") {this.ItemDR = "";}
		if (vElementID=="EquipType") {this.EquipTypeDR = "";}
		if (vElementID=="StatCat") {this.StatCatDR = "";}
		if (vElementID=="EquipCat") {this.EquipCatDR = "";}
	},
	ClearAll : function()
	{
		this.PlanDR = "";
		this.SourceTypeDR = "";
		this.EquipDR = "";
		this.ModelDR = "";
		this.MaintUserDR = "";
		this.MaintLocDR = "";
		this.MaintTypeDR = "";
		this.NotSendMessFlagDR = "";
		this.UseLocDR = "";
		this.InvalidMsgFlagDR = "";
		this.ItemDR = "";
		this.EquipTypeDR = "";
		this.StatCatDR = "";
		this.EquipCatDR = "";
	}
}

function log(val)
{
	//console.log(val);
}
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
	//GlobalObj.ClearAll();
	initPanel();
}


function initPanel()
{
	initTopPanel();
	initTopData();				//整体加载数据初始化。
}

//初始化查询头面板
function initTopPanel()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BPrint").linkbutton({iconCls: 'icon-print'});
	jQuery("#BPrint").on("click", BPrint_Clicked);
	//数值元素定义onchange事件,可校验有效性
	initNumElement("FromYear^ToYear");
	initPlanPanel();			//计划
	initEquipPanel();			//设备
	initModelPanel();			//型号
	initMaintTypePanel();		//维护类型
	initMaintUserPanel();		//维护人
	initMaintLocPanel();		//维护科室
	initUseLocPanel();			//科室
	initItemPanel();			//设备项
	initEquipTypePanel();		//设备类组
	initStatCatPanel();			//设备类型
	initEquipCatPanel();		//设备分类
}
function initSourceTypeData()
{
	if (jQuery("#SourceType").prop("type")!="hidden")
	{
		jQuery("#SourceType").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '11',
				text: '开箱验收'
			},{
				id: '21',
				text: '入库'
			},{
				id: '22',
				text: '转移'
			},{
				id: '23',
				text: '减少'
			},{
				id: '31',
				text: '维修'
			},{
				id: '34',
				text: '报废'
			},{
				id: '64',
				text: '租赁'
			}],
			onSelect: function() {GlobalObj.SourceTypeDR=jQuery("#SourceType").combobox("getValue");}
		});
	}
}
function initInvalidMsgFlagData()
{
	if (jQuery("#InvalidMsgFlag").prop("type")!="hidden")
	{
		jQuery("#InvalidMsgFlag").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: 'All'
			},{
				id: 'Y',
				text: 'Yes'
			},{
				id: 'N',
				text: 'No'
			}],
			onSelect: function() {GlobalObj.InvalidMsgFlagDR=jQuery("#InvalidMsgFlag").combobox("getValue");}
		});
	}
}
function initNotSendMessFlagData()
{
	if (jQuery("#NotSendMessFlag").prop("type")!="hidden")
	{
		jQuery("#NotSendMessFlag").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: '全部'
			},{
				id: 'N',
				text: '已接收消息'
			},{
				id: 'Y',
				text: '未接收消息'
			}],
			onSelect: function() {GlobalObj.NotSendMessFlagDR=jQuery("#NotSendMessFlag").combobox("getValue");}
		});
	}
}

function initTopData()
{
	/*
	initPlanData();				//计划
	initEquipData();			//设备
	initModelData();			//型号
	initMaintTypeData();		//维护类型
	initMaintUserData();		//维护人
	initMaintLocData();			//维护科室
	initUseLocData();			//科室
	initItemData();				//设备项
	initEquipTypeData();		//设备类组
	initStatCatData();			//设备类型
	initEquipCatData();			//设备分类
	*/
	initSourceTypeData();		//业务类型
	initNotSendMessFlagData();			//未接收标志
	initInvalidMsgFlagData();		//异常消息
}
/**********************************************公共函数******************************************/
//设置默认焦点
function setFocus(id)
{
	if(jQuery("#" + id).length)
	{
		jQuery("#" + id).focus();
	}
}

/***加载DataGrid数据*/
function loadDataGridStore(DataGridID, queryParams)
{
	window.setTimeout(function()
	{
		var jQueryGridObj = jQuery("#" + DataGridID);
		jQuery.extend(jQueryGridObj.datagrid("options"),{
			url : QUERY_URL.QUERY_GRID_URL,
			queryParams : queryParams
		});
		jQueryGridObj.datagrid("load");
	},0);
}

/***加载ComboGrid数据*/
function loadComboGridStore(ComboGridID, queryParams)
{
	var jQueryComboGridObj = jQuery("#" + ComboGridID);
	var grid = jQueryComboGridObj.combogrid('grid');	// 获取数据表格对象
	var opts = grid.datagrid("options");
	opts.url = QUERY_URL.QUERY_GRID_URL;
	grid.datagrid('load', queryParams);
}
function initComboGrid(vElementID,vElementName,vWidth,vEditFlag)
{
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//显示元素加载
	{
		jQuery("#"+vElementID).combogrid({
			fit:true,
			panelWidth:vWidth,
			border:false,
			checkOnSelect: false, 
			selectOnCheck: false,
			striped: true,
			singleSelect : true,
			url: null,
			fitColumns:false,
			autoRowHeight:false,
			cache: false,
			editable: vEditFlag,
			loadMsg:'数据加载中……', 
			rownumbers: true,  //如果为true，则显示一个行号列。
		    idField: 'TRowID',    
		    textField: 'TName',
		    pagination:true,
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
		    columns:[[
		        {field:'TName',title:vElementName,width:350},
		        {field:'TRowID',title:'ID',width:30,hidden:true},
		        ]],
		    onLoadSuccess:function(data) {},
		    onLoadError:function() {jQuery.messager.messageShow("","","",vElementName, "加载"+vElementName+"列表失败!");},
			onChange:function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
		    onSelect: function(rowIndex, rowData) {SetValue(vElementID);},
		    keyHandler:{
			    query:function(){},
			    enter:function(){ComboGridKeyEnter(vElementID);},
			    up:function(){ComboGridKeyUp(vElementID);},
			    down:function(){ComboGridKeyDown(vElementID);},
			    left:function(){},
			    right:function(){}
			    }
		});
		jQuery("#TD"+vElementID).focusin(function(){LoadData(vElementID)});
	}
}
function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="Plan") {initPlanData();}
	if (vElementID=="Equip") {initEquipData();}
	if (vElementID=="Model") {initModelData();}
	if (vElementID=="MaintType") {initMaintTypeData();}
	if (vElementID=="MaintUser") {initMaintUserData();}
	if (vElementID=="MaintLoc") {initMaintLocData();}
	if (vElementID=="UseLoc") {initUseLocData();}
	if (vElementID=="Item") {initItemData();}
	if (vElementID=="EquipType") {initEquipTypeData();}
	if (vElementID=="StatCat") {initStatCatData();}
	if (vElementID=="EquipCat") {initEquipCatData();}
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="Plan") {GlobalObj.PlanDR = CurValue;}
	if (vElementID=="Equip") {GlobalObj.EquipDR = CurValue;}
	if (vElementID=="Model") {GlobalObj.ModelDR = CurValue;}
	if (vElementID=="MaintType") {GlobalObj.MaintTypeDR = CurValue;}
	if (vElementID=="MaintUser") {GlobalObj.MaintUserDR = CurValue;}
	if (vElementID=="MaintLoc") {GlobalObj.MaintLocDR = CurValue;}
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}
	if (vElementID=="Item") {GlobalObj.ItemDR = CurValue;}
	if (vElementID=="EquipType") {GlobalObj.EquipTypeDR = CurValue;}
	if (vElementID=="StatCat") {GlobalObj.StatCatDR = CurValue;}
	if (vElementID=="EquipCat") {GlobalObj.EquipCatDR = CurValue;}
	
}
//初始化放大镜数据
function initComboData(vElementID,vClassName,vQueryName,vQueryParams,vQueryParamsNum)
{
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//显示元素加载
	{
		var queryParams = new Object();
		var ParamsInfo=vQueryParams.split(",")
		queryParams.ClassName = vClassName;
		queryParams.QueryName = vQueryName;
		for(var i=1; i<=vQueryParamsNum; i++)
		{
			if (i==1) {queryParams.Arg1 = ParamsInfo[0];}
			if (i==2) {queryParams.Arg2 = ParamsInfo[1];}
			if (i==3) {queryParams.Arg3 = ParamsInfo[2];}
			if (i==4) {queryParams.Arg4 = ParamsInfo[3];}
			if (i==5) {queryParams.Arg5 = ParamsInfo[4];}
			if (i==6) {queryParams.Arg6 = ParamsInfo[5];}
			if (i==7) {queryParams.Arg7 = ParamsInfo[6];}
			if (i==8) {queryParams.Arg8 = ParamsInfo[7];}
			if (i==9) {queryParams.Arg9 = ParamsInfo[8];}
			if (i==10) {queryParams.Arg10 = ParamsInfo[9];}
			if (i==11) {queryParams.Arg11 = ParamsInfo[10];}
			if (i==12) {queryParams.Arg12 = ParamsInfo[11];}
			if (i==13) {queryParams.Arg13 = ParamsInfo[12];}
			if (i==14) {queryParams.Arg14 = ParamsInfo[13];}
			if (i==15) {queryParams.Arg15 = ParamsInfo[14];}
			if (i==16) {queryParams.Arg16 = ParamsInfo[15];}
		}
		queryParams.ArgCnt = vQueryParamsNum;
		loadComboGridStore(vElementID, queryParams);
	}
}
function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			jQuery("#"+CurElement).change(function(){NumChange(CurElement)});

		}
	}
}
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		alertShow("请正确输入数值!")
		return
	}
}
function GetComboGridDesc(vElements,vElements2)
{
	var ReturnStr=""
	if (vElements!="")
	{
		var ElementsInfo=vElements.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var vElementID=ElementsInfo[i-1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vElementID+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	if (vElements2!="")
	{
		var ElementsInfo=vElements2.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var CurElement=ElementsInfo[i-1]
			var CurElementInfo=CurElement.split("=");
			var vParamName=CurElementInfo[0];
			var vElementID=CurElementInfo[1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vParamName+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	return ReturnStr
}
/*****************************************初始化放大镜******************************************/
function initPlanPanel()
{
	initComboGrid("Plan","维护计划",400,true);
}
function initPlanData()
{
	var vParams=GlobalObj.SourceTypeDR+","+jQuery("#Plan").combogrid("getText")+","+GlobalObj.EquipDR+","+GlobalObj.MaintLocDR+","+jQuery("#QXType").val();
	initComboData("Plan","web.DHCEQ.Process.DHCEQFind","GetPlanName",vParams,5)
}
function initMaintTypePanel()
{
	initComboGrid("MaintType","维护类型",400,true);
}
function initMaintTypeData()
{
	var vParams=jQuery("#MaintType").combogrid("getText")+","+GlobalObj.SourceTypeDR
	initComboData("MaintType","web.DHCEQ.Process.DHCEQFind","MaintTypeLookUp",vParams,2)
}
function initMaintLocPanel()
{
	initComboGrid("MaintLoc","维护科室",400,true);
}
function initMaintLocData()
{
	var vParams=","+jQuery("#MaintLoc").combogrid("getText")+",,0102,"
	initComboData("MaintLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}
function initEquipPanel()
{
	var vElementID="Equip"
	var vElementName="设备名称"
	var vWidth=450
	var vEditFlag=true
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//显示元素加载
	{
		jQuery("#"+vElementID).combogrid({
			panelWidth:vWidth,
			border:false,
			checkOnSelect: false, 
			selectOnCheck: false,
			striped: true,
			singleSelect : true,
			url: null,
			fitColumns:false,
			autoRowHeight:false,
			cache: false,
			editable: vEditFlag,
			loadMsg:'数据加载中……', 
			rownumbers: true,  //如果为true，则显示一个行号列。
		    idField: 'TRowID',    
		    textField: 'TName',
		    pagination:true,
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
		    columns:[[
		        {field:'TName',title:vElementName,width:250},
		        {field:'TRowID',title:'ID',width:30,hidden:true},
		        {field:'TNo',title:'设备编号',width:30,width:150},
		        ]],
		    onLoadSuccess:function(data) {},
		    onLoadError:function() {jQuery.messager.messageShow("","","",vElementName, "加载"+vElementName+"列表失败!");},
			onChange: function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
			onSelect: function(rowIndex, rowData) {SetValue(vElementID);},
		    keyHandler:{
			    query:function(){},
			    enter:function(){ComboGridKeyEnter(vElementID);},
			    up:function(){ComboGridKeyUp(vElementID);},
			    down:function(){ComboGridKeyDown(vElementID);},
			    left:function(){},
			    right:function(){}
			    }
		});
		jQuery("#TD"+vElementID).focusin(function(){LoadData(vElementID)});
	}
}
function initEquipData()
{
	var vParams=jQuery("#Equip").combogrid("getText")+",,,,,"
	initComboData("Equip","web.DHCEQ.Process.DHCEQFind","GetShortEquip",vParams,6)
}
function initUseLocPanel()
{
	initComboGrid("UseLoc","科室名称",400,true);
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}

function initMaintUserPanel()
{
	initComboGrid("MaintUser","维护人",400,true);
}
function initMaintUserData()
{
	var vParams=jQuery("#MaintUser").combogrid("getText")
	initComboData("MaintUser","web.DHCEQ.Process.DHCEQFind","User",vParams,1)
}
function initModelPanel()
{
	initComboGrid("Model","规格型号",400,true);
}
function initModelData()
{
	var vParams=GlobalObj.ItemDR+","+jQuery("#Model").combogrid("getText")
	initComboData("Model","web.DHCEQ.Process.DHCEQFind","GetModel",vParams,2)
}
function initItemPanel()
{
	initComboGrid("Item","设备项",400,true);
}
function initItemData()
{
	var vParams=GlobalObj.EquipTypeDR+","+GlobalObj.StatCatDR+","+jQuery("#Item").combogrid("getText")+","
	initComboData("Item","web.DHCEQ.Process.DHCEQFind","GetMasterItem",vParams,4)
}
function initEquipTypePanel()
{
	initComboGrid("EquipType","设备类组",400,true);
}
function initEquipTypeData()
{
	var vParams=jQuery("#EquipType").combogrid("getText")
	initComboData("EquipType","web.DHCEQ.Process.DHCEQFind","GetEquipType",vParams,1)
}
function initStatCatPanel()
{
	initComboGrid("StatCat","设备类型",400,true);
}
function initStatCatData()
{
	var vParams=jQuery("#StatCat").combogrid("getText")+GlobalObj.EquipTypeDR
	initComboData("StatCat","web.DHCEQ.Process.DHCEQFind","StatCatLookUp",vParams,2)
}
function initEquipCatPanel()
{
	initComboGrid("EquipCat","设备分类",400,true);
}
function initEquipCatData()
{
	var vParams=jQuery("#EquipCat").combogrid("getText")
	initComboData("EquipCat","web.DHCEQ.Process.DHCEQFind","EquipCatLookUp",vParams,1)
}
/***************************************放大镜回车事件触发函数*******************************************/
function ComboGridKeyUp(vElementID)
{
    var pClosed = jQuery("#"+vElementID).combogrid("panel").panel("options").closed;
    if (pClosed) {jQuery("#"+vElementID).combogrid("showPanel");}
    var grid = jQuery("#"+vElementID).combogrid("grid");
    var rowSelected = grid.datagrid("getSelected");
    if (rowSelected != null)
    {
        var rowIndex = grid.datagrid("getRowIndex", rowSelected);
        if (rowIndex > 0)
        {
            rowIndex = rowIndex - 1;
            grid.datagrid("selectRow", rowIndex);
        }
    }
    else if (grid.datagrid("getRows").length > 0)
    {
        grid.datagrid("selectRow", 0);
    }
}
function ComboGridKeyDown(vElementID)
{
    var pClosed = jQuery("#"+vElementID).combogrid("panel").panel("options").closed;
    if (pClosed) {jQuery("#"+vElementID).combogrid("showPanel");}
    var grid = jQuery("#"+vElementID).combogrid("grid");
    var rowSelected = grid.datagrid("getSelected");
    if (rowSelected != null)
    {
        var totalRow = grid.datagrid("getRows").length;
        var rowIndex = grid.datagrid("getRowIndex", rowSelected);
        if (rowIndex < totalRow - 1)
        {
            rowIndex = rowIndex + 1;
            grid.datagrid("selectRow", rowIndex);
        }
    }
    else if (grid.datagrid("getRows").length > 0)
    {
        grid.datagrid("selectRow", 0);
    }
}
function ComboGridKeyEnter(vElementID)
{
    var grid = jQuery("#"+vElementID).combogrid("grid");
    var rowSelected = grid.datagrid("getSelected");
    var SelectTxt=""
    if (rowSelected!=null)
    {
	    SelectTxt=rowSelected[grid.datagrid('options').textField]
    }
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if ((rowSelected!=null)&&(SelectTxt==ElementTxt))
	{
		var pClosed = jQuery("#"+vElementID).combogrid("panel").panel("options").closed;
		if (!pClosed){jQuery("#"+vElementID).combogrid("hidePanel");}
	}
	else
	{
		GlobalObj.ClearData(vElementID);
	    LoadData(vElementID);
	}
}
/***************************************按钮调用函数*****************************************************/
function BPrint_Clicked()
{
	document.getElementById('ReportFilePrint').contentWindow.document.frames["RunQianReport"].report1_print()
}
function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&vBussTypeDR="+GlobalObj.SourceTypeDR;
	lnk=lnk+"&vStartDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&vEndDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&vNotSendMessFlag="+GlobalObj.NotSendMessFlagDR;
	lnk=lnk+"&InvalidMsgFlag="+GlobalObj.InvalidMsgFlagDR;
	lnk=lnk+"&vBussNo="+jQuery("#BussNo").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}
