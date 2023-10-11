/**
 * 名称: 呆滞品报警
 * 作者: pushuangcai
 * 日期: 2022-05-09
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.sluggish.csp';
PHA_COM.App.Name = $g('呆滞品报警');
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
	InitComponent();
	QUE_FORM.InitComponents(); 		// 公共组件 component.js
	
	InitGridIncItmLoc();
	
	InitDefVal();
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLoc').datagrid('getPanel'), "呆滞品报警查询");
	
	setTimeout(function(){Query()}, 500);
})

/**
 * 查询台账汇总
 */
function Query(){
	var pJson = GetParams();
	/*
	if (pJson.intrTypeArr.length === 0){
		PHA.Popover({ 
        	showType: 'show', 
        	msg: '请选择业务类型！', 
        	type: 'alert' 
        });
        return;
	}
	*/
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'SluggishGoods',
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
	var intrTypeArr = [];
	$('input[name="intrType"]:checked').each(function(k, e){
		var type = e.value
		intrTypeArr.push({
			type: type,
			qty: $("#qty-"+ type).val()
		});
	});
	formData.intrTypeArr = intrTypeArr;
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
}

/**
 * 绑定事件
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
}

function InitComponent(){
	var content = '<div class="pha-row">';
	   content += '<div class="pha-col">' + $g('1、不勾选业务类型时默认计算所有业务') + '</div>';
	   content += '</div>';
	   content += '<div class="pha-row">';
	   content += '<div class="pha-col">' + $g('2、业务数量为空时默认为0') + '</div>';
	   content += '</div>';

	$('#btnHelp').popover({
		title: '帮助信息', 
		content: content,
		trigger: 'click',
		multi: true,
		width: 500
	});
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');	
	$HUI.checkbox('#intr-F').check();
	$HUI.checkbox('#intr-P').check();
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
			hidden: true
		}, {
			title: "最近入库日期",
			field: "lastIngrDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "最近转出日期",
			field: "lastTDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "最近转入日期",
			field: "lastKDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "最近门诊发药",
			field: "lastFDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "最近住院发药",
			field: "lastPDate",
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
			field: "TSpAmt",
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
			width: 60,
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
			width: 300
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