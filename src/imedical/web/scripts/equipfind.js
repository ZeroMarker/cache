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
	//QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	//QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp",
	QUERY_GRID_URL : "./dhceq.jquery.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.csp"
};
var GlobalObj = {
	EquipCatDR : "",
	UseLocDR : "",
	LocationDR:"",
	FundsTypeDR : "",
	EquipTypeDR : "",
	StatCatDR : "",
	ProviderDR : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="EquipCat") {this.EquipCatDR = "";}
		if (vElementID=="UseLoc") {this.UseLocDR = "";}
		if (vElementID=="Location") {this.LocationDR = "";}
		if (vElementID=="FundsType") {this.FundsTypeDR = "";}
		if (vElementID=="EquipType") {this.EquipTypeDR = "";}
		if (vElementID=="StatCat") {this.StatCatDR = "";}
		if (vElementID=="Provider") {this.ProviderDR = "";}		
	},
	ClearAll : function()
	{
		this.EquipCatDR = "";
		this.UseLocDR = "";
		this.LocationDR = "";
		this.FundsTypeDR = "";
		this.EquipTypeDR = "";
		this.StatCatDR = "";
		this.ProviderDR = "";
	}
}

/// modefied by by zc 2017-05-25 ZC0030 begin
Array.prototype.indexOf = function(val) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == val) return i;
	}
	return -1;
};
Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};
var fileview = $.extend({}, $.fn.datagrid.defaults.view, { onAfterRender: function (target) { isselectItem(); } });
var selectItems = new Array();
var InfoStr="";  /// modefied by by zc 2017-08-29 ZC0032
/// modefied by by zc 2017-05-25 ZC0030 end 
///11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备 
///61：工程管理 62：科研课题  
///63：证件：63-1：供应商,63-2：生产厂家,63-3：计量证书 64：租赁 
///71：是保养；72：检查，73：保修;81：监控
///91：采购申请 92：采购计划 93：采购招标 94：采购合同
///用busscode做数组的索引
var columns=GetCurColumnsInfo('51','','','');  /// modefied by by zc 2017-08-29 ZC0032
//GR0064 增加生命周期链接
//var lifeinfocolumn={field:"lifeinfo",title:"生命周期",width:40,align:"center",formatter:lifeinfoOperation}
//columns[0].push(lifeinfocolumn)
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
	//setFocus("Equip");;
}


function initPanel()
{

	initTopPanel();
	initStatusData();		//在保标志
	//initTopData();	//整体加载数据初始化。
}

//初始化查询头面板
function initTopPanel()
{
	jQuery("#EndInStockDate").datebox("setValue",jQuery("#CurDate").val());
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-redo'});   /// modefied by by zc 2017-08-29 ZC0033
	jQuery("#BSaveExcel").on("click", BSaveExcel_Click);
	jQuery("#BColSet").linkbutton({iconCls: 'icon-config'});   /// modefied by by zc 2017-08-29 ZC0033
	jQuery("#BColSet").on("click", BColSet_Click);
	jQuery("#BBatchDisuse").linkbutton({iconCls: 'icon-save'});  /// modefied by by zc 2017-08-29 ZC0033
	jQuery("#BBatchDisuse").on("click", BBatchDisuse_Click);  /// modefied by by zc 2017-05-25 ZC0030
	jQuery("#BSelectAll").on("click", BSelectAll_Click);  /// modefied by by zc 2017-05-25 ZC0031
	jQuery("#BUnSelectAll").on("click",BUnSelectAll_Click);  /// modefied by by zc 2017-05-25 ZC0031
	//数值元素定义onchange事件,可校验有效性
	initNumElement("MinValue^MaxValue");
	initEquipCatPanel();			//设备分类
	initUseLocPanel();			//科室
	initLocationPanel();			//存放位置
	initFundsTypePanel();			//资金来源
	initEquipTypePanel();		//设备类组
	initStatCatPanel();			//设备类型
	//initEquipPanel();			//设备
	
	//initServicePanel();			//维修商
	//initMaintUserPanel();		//维修人
	initProviderPanel();			//供应商
	//initManuFacturerPanel();		//生产厂家
	//initModelPanel();			//型号
	//initMaintGroupPanel();		//维修组
	//initItemPanel();				//设备项
	

	initMaindatagrid();			//初始化表格
}
///add by lmm 2017-06-28 394342 状态下拉框增加全部状态
function initStatusData()
{
	if (jQuery("#Status").prop("type")!="hidden")
	{
		
		jQuery("#Status").combobox({
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
				id: '0',
				text: '在库'
			},{
				id: '1',
				text: '启用'
			},{
				id: '2',
				text: '停用'
			}],
			onSelect: function() {GlobalObj.StatusDR=jQuery("#Status").combobox("getValue");}
		});
	}
}
function initTopData()
{
	initEquipData();			//设备
	initUseLocData();			//科室
	initServiceData();			//维修商
	initMaintUserData();		//维修人
	initProviderData();			//供应商
	initManuFacturerData();		//生产厂家
	initModelData();			//型号
	initMaintGroupData();		//维修组
	initItemData();				//设备项
	initEquipTypeData();		//设备类组
	initStatCatData();			//设备类型
	initEquipCatData();			//设备分类
	initInsurFlagData();		//状态
	
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
function initComboGrid(vElementID,vElementName,vElementCode,vWidth,vEditFlag)
{
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
		        {field:'TCode',title:vElementCode,width:150},
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
	if (vElementID=="EquipCat") {initEquipCatData();}
	if (vElementID=="UseLoc") {initUseLocData();}
	if (vElementID=="Location") {initLocationData();}
	if (vElementID=="FundsType") {initFundsTypeData();}
	if (vElementID=="EquipType") {initEquipTypeData();}
	if (vElementID=="StatCat") {initStatCatData();}
	if (vElementID=="Provider") {initProviderData();}
	
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="EquipCat") {GlobalObj.EquipCatDR = CurValue;}
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}
	if (vElementID=="Location") {GlobalObj.LocationDR = CurValue;}
	if (vElementID=="FundsType") {GlobalObj.FundsTypeDR = CurValue;}
	if (vElementID=="EquipType") {GlobalObj.EquipTypeDR = CurValue;}
	if (vElementID=="StatCat") {GlobalObj.StatCatDR = CurValue;}
	if (vElementID=="Provider") {GlobalObj.ProviderDR = CurValue;}
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
/*****************************************初始化放大镜******************************************/
/*function initEquipPanel()
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
}*/
function initUseLocPanel()
{
	initComboGrid("UseLoc","科室名称","代码",400,true);
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}
/*function initServicePanel()
{
	initComboGrid("Service","维修商","代码",400,true);
}
function initServiceData()
{
	var vParams=jQuery("#Service").combogrid("getText")
	initComboData("Service","web.DHCEQ.Process.DHCEQFind","ServiceLookUp",vParams,1)
}*/
/*
function initMaintUserPanel()
{
	initComboGrid("MaintUser","维修人","代码",400,true);
}
function initMaintUserData()
{
	var vParams=jQuery("#MaintUser").combogrid("getText")
	initComboData("MaintUser","web.DHCEQ.Process.DHCEQFind","User",vParams,1)
}*/
/*function initManuFacturerPanel()
{
	initComboGrid("ManuFacturer","生产厂家","代码",400,true);
}
function initManuFacturerData()
{
	var vParams=jQuery("#ManuFacturer").combogrid("getText")
	initComboData("ManuFacturer","web.DHCEQ.Process.DHCEQFind","GetManuFacturer",vParams,1)
}*/
/*function initModelPanel()
{
	initComboGrid("Model","规格型号","代码",400,true);
}
function initModelData()
{
	var vParams=GlobalObj.ItemDR+","+jQuery("#Model").combogrid("getText")
	initComboData("Model","web.DHCEQ.Process.DHCEQFind","GetModel",vParams,2)
}*/
/*function initMaintGroupPanel()
{
	initComboGrid("MaintGroup","维修组","代码",400,true);
}
function initMaintGroupData()
{
	var vParams=jQuery("#MaintGroup").combogrid("getText")
	initComboData("MaintGroup","web.DHCEQ.Process.DHCEQFind","MaintGroupLookUp",vParams,1)
}*/
/*
function initItemPanel()
{
	initComboGrid("Item","设备项","代码",400,true);
}
function initItemData()
{
	var vParams=GlobalObj.EquipTypeDR+","+GlobalObj.StatCatDR+","+jQuery("#Item").combogrid("getText")+","
	initComboData("Item","web.DHCEQ.Process.DHCEQFind","GetMasterItem",vParams,4)
}*/
function initEquipTypePanel()
{
	initComboGrid("EquipType","设备类组","代码",400,true);
}
function initEquipTypeData()
{
	var vParams=jQuery("#EquipType").combogrid("getText")
	initComboData("EquipType","web.DHCEQ.Process.DHCEQFind","GetEquipType",vParams,1)
}
function initStatCatPanel()
{
	initComboGrid("StatCat","设备类型","代码",400,true);
}
function initStatCatData()
{
	var vParams=jQuery("#StatCat").combogrid("getText")+","+GlobalObj.EquipTypeDR
	initComboData("StatCat","web.DHCEQ.Process.DHCEQFind","StatCatLookUp",vParams,2)
}
function initEquipCatPanel()
{
	initComboGrid("EquipCat","设备分类","代码",400,true);
}
function initEquipCatData()
{
	var vParams=jQuery("#EquipCat").combogrid("getText")
	initComboData("EquipCat","web.DHCEQ.Process.DHCEQFind","EquipCatLookUp",vParams,1)
}
function initFundsTypePanel()
{
	initComboGrid("FundsType","资金来源","代码",400,true);
}
function initFundsTypeData()
{
	//var vParams=jQuery("#FundsType").combogrid("getText")
	initComboData("FundsType","web.DHCEQ.Process.DHCEQFind","FundsType","",0)
}
function initLocationPanel()
{
	initComboGrid("Location","存放位置","代码",400,true);
}
function initLocationData()
{
	var vParams=jQuery("#Location").combogrid("getText")
	initComboData("Location","web.DHCEQ.Process.DHCEQFind","GetShortLocation",vParams,1)
}
function initProviderPanel()
{
	initComboGrid("Provider","供应商",400,"代码",true);
}
function initProviderData()
{
	var vParams=jQuery("#Provider").combogrid("getText")
	initComboData("Provider","web.DHCEQ.Process.DHCEQFind","GetVendor",vParams,1)
}
function initMaindatagrid()
{
	jQuery('#maindatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQEquip",
        QueryName:"GetEquipList",
        Arg1:"^IsOut=N^IsDisused=N^",        //modified by czf 需求号：353982
        Arg2:"",
        ArgCnt:2
    },
    idField: 'TRowID',   /// modefied by by zc 2017-05-25 ZC0030 唯一视图标识
    fit:true,
    fitColumns:true,	//modified by czf 562160
	autoRowHeight:true,
	remoteSort:false,
	cache: false,
    border:false,
    //height:'100%',
    //layout:'fit',
    striped: true,
    //region:"center",
    //rownumbers : true,
    //singleSelect:true,
    //seletOnCheck: true,
 	//checkOnSelect: true,
 	view: fileview ,  /// modefied by by zc 2017-05-25 ZC0030   视图
    columns:columns, 
    toolbar:[	/// modefied by by zc 2017-06-25 ZC0031 begin
			{
				iconCls:'icon-allselected', /// modefied by by zc 2017-09-27
				text:'全选',
				handler:function(){BSelectAll_Click();}
			},'-----------------------------------',
			{
				iconCls:'icon-allunselected', /// modefied by by zc 2017-09-27
				text:'取消全选',
				handler:function(){BUnSelectAll_Click();}
			}  /// modefied by by zc 2017-06-25 ZC0031  end
		],   
    onClickRow : function (rowIndex, rowData) {
    },
    rowStyler:setRowBgColor,
    onSelectAll: addselectItem,  /// modefied by by zc 2017-05-25 ZC0030 begin
    onSelect: addselectItem,
    onUnselectAll: removeAllItem,
    onUnselect: removeSingleItem, /// modefied by by zc 2017-05-25 ZC0030 end
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
	});
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
function BFind_Clicked()
{
	var lnk=GetLnk()
	jQuery('#maindatagrid').datagrid('load',{
					ClassName:"web.DHCEQEquip",
        			QueryName:"GetEquipList",
        			Arg1:lnk,
        			Arg2:"",
        			ArgCnt:2
				});
	selectItems.splice(0,selectItems.length); /// modefied by by zc 2017-05-25 ZC0030
	jQuery('#maindatagrid').datagrid('unselectAll') /// modefied by by zc 2017-05-25 ZC0030
	InfoStr="";  /// modefied by by zc 2017-08-29 ZC0032
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
function YMD2DMY(YMDDate)
{
	if (YMDDate=="") return ""
	var temp=YMDDate.split("-")
	return temp[2]+"/"+temp[1]+"/"+temp[0]
}
function detailOperation(value,row,index)
{
	if(row.TRowID=="") return ""
	var para="&RowID="+row.TRowID+"&ReadOnly="+jQuery('#ReadOnly').val()+"&BatchFlag="+row.TBatchFlag+"&InStockListDR="+row.TInStockListDR+"&StoreLocDR="+row.TStoreLocDR
	var url="dhceqequiplistnew.csp?"+para;
	var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	return btn;
}
function GetLnk()
{
	var lnk="";
	lnk=lnk+"^No="+document.getElementById("No").value;
	lnk=lnk+"^Name="+document.getElementById("Name").value;
	lnk=lnk+"^EquipCatDR="+GlobalObj.EquipCatDR;
	lnk=lnk+"^Code="+document.getElementById("Code").value;
	lnk=lnk+"^UseLocDR="+GlobalObj.UseLocDR;
	if (document.getElementById("IncludeFlag").checked==true)
		lnk=lnk+"^IncludeFlag=1"
	else 
		lnk=lnk+"^IncludeFlag=0"
	lnk=lnk+"^MinValue="+document.getElementById("MinValue").value;
	lnk=lnk+"^MaxValue="+document.getElementById("MaxValue").value;
	lnk=lnk+"^FundsTypeDR="+GlobalObj.FundsTypeDR;
	lnk=lnk+"^LocationDR="+GlobalObj.LocationDR;
	lnk=lnk+"^BeginInStockDate="+jQuery('#BeginInStockDate').datebox('getText');   //modified by czf 369762
	lnk=lnk+"^EndInStockDate="+jQuery('#EndInStockDate').datebox('getText');
	lnk=lnk+"^EquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"^StatCatDR="+GlobalObj.StatCatDR;
	lnk=lnk+"^ProviderDR="+GlobalObj.ProviderDR;
	lnk=lnk+"^Status="+jQuery("#Status").combobox("getValue");
	lnk=lnk+"^InStockNo="+document.getElementById("InStockNo").value;
	lnk=lnk+"^StoreMoveNo="+document.getElementById("StoreMoveNo").value;
	lnk=lnk+"^QXType="+document.getElementById("QXType").value;
	lnk=lnk+"^IsDisused=N"                //modified by czf 需求号：353982
	lnk=lnk+"^IsOut=N" 
	return lnk
}
function BSaveExcel_Click() //导出
{	
	var vData=GetLnk()
	var Job=document.getElementById("Job");
	PrintDHCEQEquipNew("Equip",1,"",vData,"",100);
	return
}
function BColSet_Click() //导出数据列设置
{
	var para="&TableName=Equip&SetType=0&SetID=0"
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	OpenNewWindow(url)
}
//GR0064 增加生命周期链接
function lifeinfoOperation(value,row,index)
{
	if(row.TRowID=="") return ""
	var para="&EquipDR="+row.TRowID
	var url="dhceq.process.lifeinfo.csp?"+para;
	var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	return btn;
}
//add by lmm 2017-10-19 begin
function BBatchDisuse_Click()
{
	BatchDisuse("");
}
//add by lmm 2017-10-19 end
/// modefied by by zc 2017-05-25 ZC0030 begin
function BatchDisuse(BatchRequestFlag) //批量报废申请  //add by lmm 2017-10-19
{
	var row = jQuery('#maindatagrid').datagrid('getSelections');
	for (var i = 0; i < row.length; i++) {
            	if (findSelectItem(row[i].TRowID) == -1) {
                	selectItems.push(row[i].TRowID);
            	}
        	}
	if(selectItems=="")
	{
		jQuery.messager.alert("提示", "未选择设备报废！")
		return false;
	}
	var length=selectItems.length;
	var str=""
	for(i=0;i<selectItems.length;i++)//开始循环
	{
		if (str=="")
		{
			str=selectItems[i];//循环赋值
		}
		else
		{
			str=str+","+selectItems[i]
		}
	}
	selectItems.splice(0,selectItems.length);
	//add by lmm 2017-10-11 begin
	if (BatchRequestFlag=="") 
	{
		var BatchRequestFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","601004") 
		if (BatchRequestFlag==3)
		{
			var str='dhceq.process.disusetype.csp?RowID=';
		    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				str += "&MWToken="+websys_getMWToken()
			}
		    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=380,height=380,left=120,top=0')
			return;
		}
	}
	/// modefied by by zc 2017-06-25 ZC0031 begin
	var data = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "BatchDisuseEquipIDs",str,InfoStr,BatchRequestFlag);
	//add by lmm 2017-10-18 end
	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	data=data.split("^");
	var num=data[0];
	var errmesg=data[1];
	var Info=data[2]
	if (errmesg=="")
	{
		if(Info=="")
		{
			jQuery.messager.alert("提示", "批量报废申请成功,生成"+num+"张报废单");
		}
		else
		{
			jQuery.messager.alert("提示", "批量报废申请成功,生成"+num+"张报废单,其中"+Info);
		}
	}
	else
	{
		if (num!="0")
		{
			if(Info=="")
			{
				jQuery.messager.alert("提示", "批量报废成功生成"+num+"张报废单,有编号为"+errmesg+"报废失败");
			}
			else
			{
				jQuery.messager.alert("提示", "批量报废成功生成"+num+"张报废单,有编号为"+errmesg+"报废失败,其中"+Info);
			}
		}
		else
		{
			jQuery.messager.alert("提示", "批量报废失败");
		}
	}
	jQuery('#maindatagrid').datagrid('unselectAll');
	jQuery('#maindatagrid').datagrid('reload');
	InfoStr=""
	/// modefied by by zc 2017-06-25 ZC0031 end
	
}
function setRowBgColor(rowIndex, rowData) {
        if (rowData.TRowID=="") {
            return 'background-color:#fff7ff;color:black;';
        }
        var re = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowData.TRowID,'','','Y');   /// modefied by by zc 2017-08-29 ZC0032 begin
	    var rt=re.split("^");
	    if (rt[0]!="0")
	    {
		    if (InfoStr=="")
			{
				InfoStr=rowData.TRowID;//循环赋值
			}
			else
			{
				InfoStr=InfoStr+","+rowData.TRowID;
			}
			/// modefied by by zc 2017-08-29 ZC0032 end
		    return 'background-color:#fff7ff;color:black;';
		}
    }
function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#maindatagrid').datagrid('selectRecord', selectItems[i]); //根据id选中行 
        }
}

//判断选中记录的ID是否已存在checkedItems这个数组里
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
//将选中记录的ID是存储checkedItems这个数组里
function addselectItem(rowIndex, rowData) {
        var row = jQuery('#maindatagrid').datagrid('getSelections');
	    var rowid=rowData.TRowID;
	    /// modefied by by zc 2017-06-25 ZC0031 begin
	    var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowData.TRowID,'','','Y');
	    var ret=res.split("^");
	    if (ret[0]!="0")
		{
		    jQuery.messager.alert("提示",ret[1] );
		}
		/// modefied by by zc 2017-06-25 ZC0031 end
		if (ret[0]=="0")
		{
        	for (var i = 0; i < row.length; i++) {
            	if (findSelectItem(row[i].TRowID) == -1) {
                	selectItems.push(row[i].TRowID);
            	}
        	}
		}
}
//清楚所有选中记录的ID
function removeAllItem(rows) {

        for (var i = 0; i < rows.length; i++) {
            var k = findSelectItem(rows[i].TRowID);
            if (k != -1) {
                selectItems.splice(i, 1);
            }
        }
}
//清楚单条选中记录的ID
function removeSingleItem(rowIndex, rowData) {
        var k = findSelectItem(rowData.TRowID);
        if (k != -1) {
            selectItems.splice(k, 1);
        }
}
/// modefied by by zc 2017-05-25 ZC0030 end

/// modefied by by zc 2017-06-25 ZC0031 begin
function BSelectAll_Click() //批量报废申请
{
	jQuery.messager.alert("提示","当前页面未被选中的设备被其他业务单据占用");  /// modefied by by zc 2017-08-29 ZC0032
	jQuery('#maindatagrid').datagrid('selectAll');
}
/// modefied by by zc 2017-06-25 ZC0031 begin
function BUnSelectAll_Click() //批量报废申请
{
	selectItems.splice(0,selectItems.length);
	jQuery('#maindatagrid').datagrid('unselectAll');
}

