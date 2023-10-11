/**
 * 名称: 库存报警（按上下限）
 * 作者: pushuangcai
 * 日期: 2022-04-29
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.stkwarnbylimit.csp';
PHA_COM.App.Name = $g('库存报警');
PHA_COM.App.AppName = 'DHCSTLOCSTKMOVE';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;

var ParamProp = PHA_COM.ParamProp(PHA_COM.App.AppName);

PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};

$(function(){	
	QUE_FORM.InitComponents(); 		// 公共组件 component.js

	InitGridIncItmLoc();
	
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLoc').datagrid('getPanel'), "库存报警(按上下限)");
	InitDefVal();
	
	setTimeout(function(){Query()}, 500);
})

/**
 * 查询
 */
function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'StkWarnByLimit',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridIncItmLoc').datagrid('loadData', data);
	    }
	);
}

/**
 * 获取界面参数
 */
function GetParams(){
	return QUE_FORM.GetFormData();
}

/**
 * 初始化界面默认值
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
	if (gLowStock == "Y"){
		$HUI.checkbox('#lessFlag').check();
	} else{
		$HUI.checkbox('#lessFlag').uncheck();
	}
	if (gHighStock == "Y"){
		$HUI.checkbox('#moreFlag').check();
	} else{
		$HUI.checkbox('#moreFlag').uncheck();
	}	
}

/**
 * 绑定事件
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	$('#gridIncItmLoc').datagrid('clear');
	QUE_FORM.ClearFormData();	
	InitDefVal();	
}

/**
 * 科室库存项表格
 */
function InitGridIncItmLoc(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		},{
			title: "incil",
			field: "incil",
			width: 100,
			hidden: true
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
		}, {
			title: "基本单位",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "入库单位",
			field: "pUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
		}, {
			title: "库存(基本)",
			field: "bQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "库存(入库)",
			field: "pQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "库存(单位)",
			field: "qtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "库存上限",
			field: "maxQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "库存下限",
			field: "minQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "标准库存",
			field: "repQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "上月消耗量",
			field: "lastMIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "本月消耗量",
			field: "thisMIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "昨日消耗量",
			field: "lastDIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "今日消耗量",
			field: "toDIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "进价(入库)",
			field: "pRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "售价(入库)",
			field: "pSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "进价(基本)",
			field: "bRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "售价(基本)",
			field: "bSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "进价金额",
			field: "rpAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "售价金额",
			field: "spAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			field: 'avaQtyWithUom',
			title: '可用库存',
			width: 150,
			hidden: false,
			align: 'right'
		}, {
			title: "货位",
			field: "stkBin",
			width: 100
		}, {
			title: "剂型",
			field: "phcFormDesc",
			width: 100
		}, {
			title: "商品名",
			field: "goodName",
			width: 130
		}, {
			title: "处方通用名",
			field: "geneName",
			width: 150
		}, {
			title: "不可用",
			field: "notUseFlag",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "贵重药",
			field: "highPrice",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "国家医保编码",
			field: "insuCode",
			width: 100
		}, {
			title: "国家医保名称",
			field: "insuName",
			width: 100
		}
	]];
	var frozenColumns = [[
		{
			title: "状态",
			field: "stkState",
			width: 80,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.StkLimitState()
		}, {
			title: "药品代码",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "药品名称",
			field: "inciDesc",
			width: 300
		}, {
			title: "药品规格",
			field: "inciSpec",
			width: 100
		}
	]]
	var dataGridOption = {
		url: "",	
		nowrap: false,
		fitColumns: false,
		border: true,
		headerCls: 'panel-header-gray',
		toolbar: '#gridIncItmLocTool',
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);
	
	QUE_COM.ComGridEvent("gridIncItmLoc");
}