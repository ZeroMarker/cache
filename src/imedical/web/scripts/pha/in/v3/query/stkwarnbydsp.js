/**
 * 名称: 库存报警(按消耗)
 * 作者: pushuangcai
 * 日期: 2022-05-09
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.stkwarnbydsp.csp';
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
	QUE_FORM.InitComponents(); 
	
	InitComponent();
	InitGridIncItmLoc();
	
	InitDefVal();
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLoc').datagrid('getPanel'), $g("库存报警(按消耗)"));

	setTimeout(function(){Query()}, 500);
})

/**
 * 查询台账汇总
 */
function Query(){
	var pJson = GetParams();
	if(pJson === null){
		return;
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'StkWarnByDsp',
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
	var formData = QUE_FORM.GetFormData();
	var intrTypeStr = $('#businessType').combobox('getValues').join(",");
	formData.intrTypeStr = intrTypeStr;
	return formData;
}

/**
 * 初始化界面默认值
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t-30"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#dspDays').numberbox('setValue', 30);
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
	$('#businessType').combobox('setValues', ['P','Y','F','H']);
}

/**
 * 绑定事件
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
}

function InitComponent(){
	PHA.ComboBox('businessType', {
		multiple: true,
		rowStyle: 'checkbox',
		width: 402,
		url: PHA_STORE.BusinessType().url,
		onLoadSuccess: function(){
			$(this).combobox('setValues', ['P','Y','F','H']);
		}
	});
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');	
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
			title: "消耗总量",
			field: "dspTotalQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "日均消耗",
			field: "avgDspQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
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
			hidden: true
		}, {
			title: "需求量(预估)",
			field: "requiredQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			field: 'avaQtyWithUom',
			title: '可用库存',
			width: 150,
			hidden: false,
			align: 'right'
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
			title: "进价(入库)",
			field: "TPRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "售价(入库)",
			field: "TPSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "进价(基本)",
			field: "TBRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "售价(基本)",
			field: "TBSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "进价金额",
			field: "TRpAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "售价金额",
			field: "TRpAmt",
			width: 100,
			align: 'right',
			hidden: false
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
			width: 130
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
			title: "药品代码",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "药品名称",
			field: "inciDesc",
			width: 200
		}, {
			title: "药品规格",
			field: "inciSpec",
			width: 100
		}
	]]
	var dataGridOption = {
		url: "",	
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