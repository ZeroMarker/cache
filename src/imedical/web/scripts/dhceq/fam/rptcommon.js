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

function log(val)
{
	//console.log(val);
}
//Modify By DJ 2017-12-14 JQuery+润乾开发报表界面入库改自各报表对应JS内
//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
///modify by lmm 2018-09-29 hisui改造：添加标题样式 lookup初始化 按钮长度一致
function initDocument()
{
	defindTitleStyle()
	initLookUp();
	initPanel();
	initButtonWidth();
	//setFocus("Equip");;
}


function initPanel()
{
	initTopPanel();
	//initInsurFlagData();		//在保标志
	//initReportTypeData();		//报表类型
	//initTopData();	//整体加载数据初始化。
}

//初始化查询头面板
///modify by lmm 2018-09-20
///描述：hisui改造：按钮图标修改
function initTopPanel()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BPrint").linkbutton({iconCls: 'icon-w-print'});
	jQuery("#BPrint").on("click", BPrint_Clicked);
	//数值元素定义onchange事件,可校验有效性
	
	//initNumElement("FromOriginalFee^ToOriginalFee^FromYear^ToYear");

}
function initInsurFlagData()
{
	if (jQuery("#InsurFlag").prop("type")!="hidden")
	{
		jQuery("#InsurFlag").combobox({
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
			onSelect: function() {GlobalObj.InsurFlagDR=jQuery("#InsurFlag").combobox("getValue");}
		});
	}
}
function initReportTypeData()
{
	if (jQuery("#ReportType").prop("type")!="hidden")
	{
		jQuery("#ReportType").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '1',
				text: '财务月结'
			},{
				id: '0',
				text: '实物月结'
			}],
			onSelect: function() {GlobalObj.ReportTypeDR=jQuery("#ReportType").combobox("getValue");}
		});
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
/***************************************按钮调用函数*****************************************************/
function BPrint_Clicked()
{
	document.getElementById('ReportFilePrint').contentWindow.document.frames["RunQianReport"].report1_print()
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
///add by lmm 2018-09-20
///描述：下拉框dr赋值
///入参：vElementID 下拉框id
///      item 选中行数据
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}