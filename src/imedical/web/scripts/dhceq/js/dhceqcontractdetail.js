//if (window.opener==undefined) window.open(window.location.href)
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
	UseLocDR : "",
	ProviderDR : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="UseLoc") {this.UseLocDR = "";}
		if (vElementID=="Provider") {this.ProviderDR = "";}
	},
	ClearAll : function()
	{
		this.UseLocDR = "";
		this.ProviderDR = "";
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
	//setFocus("Equip");;
}


function initPanel()
{
	initTopPanel();
	//initInsurFlagData();		//在保标志
	//initTopData();	//整体加载数据初始化。
}

//初始化查询头面板
function initTopPanel()
{
	jQuery("#EndDate").datebox("setValue",jQuery("#CurDate").val());
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	//数值元素定义onchange事件,可校验有效性
	//initNumElement("FromOriginalFee^ToOriginalFee^FromYear^ToYear");
	initUseLocPanel();			//科室
	initProviderPanel();			//供应商
}
function initTopData()
{
	initUseLocData();			//科室
	initProviderData();			//供应商
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
		    onLoadSuccess:function(data) {
	    	
		    },
		    onLoadError:function() {
		    	jQuery.messager.messageShow("","","",vElementName, "加载"+vElementName+"列表失败!");
		    },
			onChange:function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
		    onSelect: function(rowIndex, rowData) {SetValue(vElementID);}
		});
		jQuery("#"+vElementID).combogrid("textbox").keydown(function (e) {StandKeyDown(e,vElementID)});
		jQuery("#TD"+vElementID).focusin(function(){GetFocus(vElementID)});
	}
}
function GetFocus(vElementID)
{
	if (vElementID=="UseLoc") {initUseLocData();}
	if (vElementID=="Provider") {initProviderData();}
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}
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
	for(var i=1; i<=ElementInfo.lenght; i++)
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
function initUseLocPanel()
{
	initComboGrid("UseLoc","签订部门",400,true);
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}
function initProviderPanel()
{
	initComboGrid("Provider","供应商",400,true);
	//initProviderData();
}
function initProviderData()
{
	var vParams=jQuery("#Provider").combogrid("getText")
	initComboData("Provider","web.DHCEQ.Process.DHCEQFind","GetVendor",vParams,1)
}
/***************************************放大镜回车事件触发函数*******************************************/
function StandKeyDown(e,vElementID)
{
	var e = e || window.event;
	if (e.keyCode == 13)
	{
		if (vElementID=="UseLoc") {initUseLocData();}
		if (vElementID=="Provider") {initProviderData()}
	}
}
/***************************************按钮调用函数*****************************************************/
function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&StartDate="+ToEnsembleDate(jQuery('#StartDate').datebox('getValue'));
	lnk=lnk+"&EndDate="+ToEnsembleDate(jQuery('#EndDate').datebox('getValue'));
	lnk=lnk+"&ProviderDR="+GlobalObj.ProviderDR;
	lnk=lnk+"&SignLocDR="+GlobalObj.UseLocDR;
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
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
//将js中Date对象转化为Ensemble中日期，即计算从1840.12.31起经过的日子
function ToEnsembleDate(date)
{
	try
	{
	if(date=="") return ""
	var temp=date.split("-")
	date=new Date(temp[0],temp[1]-1,temp[2])
	var zerodate=new Date(1840,11,31)
	return (date.getTime()-zerodate.getTime())/1000/60/60/24
	
	}
	catch(e)
	{
		return date
	}
	
}