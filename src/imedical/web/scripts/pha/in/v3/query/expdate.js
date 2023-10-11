/**
 * 名称:	 效期报警、查询
 * 编写人:	 pushuangcai
 * 编写日期: 2022-04-26
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.expdate.csp';
PHA_COM.App.Name = $g('效期报警');
PHA_COM.App.AppName = 'DHCSTLOCITMSTK';
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
	InitComponent();				// 页面组件
	QUE_FORM.InitComponents(); 		// 公共组件 component.js
	
	InitGridIncItmLcBt();
	InitGridIncItmLcBtExpired();
	
	InitDefVal();
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLcBt').datagrid('getPanel'), "效期报警");

	setTimeout(function(){Query()}, 500);
})

function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	var selTabIndex = $('#expTabs').tabs('getTabIndex', $('#expTabs').tabs('getSelected'));
	if (selTabIndex == 0){
		var nearlyPJson = _.cloneDeep(pJson);
		// 近效期
		nearlyPJson.expRangeType = "DAY";
		nearlyPJson.expRangeSt = 0;
		nearlyPJson.expRangeEd = ParamProp.ExpDateWarnDays;
		$('#gridIncItmLcBtNearlyExp').datagrid('loading');
		PHA.CM({
				pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'ExpDateDetail',
				pJsonStr: JSON.stringify(nearlyPJson)
			},function(data){
				$('#gridIncItmLcBtNearlyExp').datagrid('loadData', data);
			}
		);
	} else if (selTabIndex == 1){
		// 已过期
		var expiredPJson = _.cloneDeep(pJson);
		expiredPJson.expiredFlag = "Y";
		$('#gridIncItmLcBtExpired').datagrid('loading');
		PHA.CM({
				pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'ExpDateDetail',
				pJsonStr: JSON.stringify(expiredPJson)
			},function(data){
				$('#gridIncItmLcBtExpired').datagrid('loadData', data);
			}
		);
	} else{
		var expRangeSt = parseInt(pJson.expRangeSt);
		var expRangeEd = parseInt(pJson.expRangeEd);
		if (expRangeSt > expRangeEd){
			PHA.Popover({ 
				showType: 'show', 
				msg: '效期开始范围不能大于截止范围', 
				type: 'alert' 
			});
			$('#expRangeSt').focus();
			$('#expRangeSt').select();
			return;
		}
		$('#gridIncItmLcBt').datagrid('loading');
		PHA.CM({
				pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'ExpDateDetail',
				pJsonStr: JSON.stringify(pJson)
			},function(data){
				$('#gridIncItmLcBt').datagrid('loadData', data);
			}
		);	
	}
}

/**
 * 药品养护
 */
function AddConserve(){
	var checkedRows = $('#gridIncItmLcBt').datagrid('getChecked');
	if (checkedRows.length === 0){
		PHA.Popover({ 
        	showType: 'show', 
        	msg: '请勾选需要养护的药品批次！', 
        	type: 'alert' 
        });
		return;
	}
	PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'DrgMgrSave',
	        pJsonStr: JSON.stringify(pJson),
	        dataType: 'text'
	    },function(data){
		    PHA.Ret(data);
	        window.parent.CloseExpBatDilog();
	    }
	);
}

function InitComponent(){
	PHA.ComboBox('expRangeType', {
		valueField: 'id',
		textField: 'text',
		width: 70,
		data: [
			{text:'天', id: 'DAY', selected: true},
        	{text:'月', id: 'MONTH'}
		]
	}); 
	$('#expTabs').tabs({
		onSelect: function(){
			Query();
		}
	});
}

/**
 * 获取界面参数
 */
function GetParams(){
	var formData = QUE_FORM.GetFormData();
	if (formData === null){
		return null;	
	}
	var incExpFilterArr = PHA.DomData("#incExpFilter", {
		doType: 'query',
		retType: 'Json'
	});	
	var formData = $.extend({}, formData, incExpFilterArr[0]);
	return formData;
}

/**
 * 初始化界面默认值
 */
function InitDefVal(){
	$('#endExpDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
	$HUI.checkbox('#stkActiveFlag').check();
	$HUI.checkbox('#ordActiveFlag').check();
	$('#expRangeSt').numberbox('setValue', 1);
	$('#expRangeEd').numberbox('setValue', ParamProp.ExpDateWarnDays || "");
	$('#expRangeType').combobox('setValue', 'DAY');
}

/**
 * 绑定事件
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
	PHA_EVENT.Bind('#btbtnAddConservenClear', 'click', AddConserve);
	$('#expRangeSt').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $('#expRangeEd').focus();
        }
    });
	$('#expRangeEd').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            Query();
        }
    });
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLcBt').datagrid('clear');
	$('#gridIncItmLcBtNearlyExp').datagrid('clear');
	$('#gridIncItmLcBtExpired').datagrid('clear');
	InitDefVal();
}

/**
 * 科室库存项表格
 */
function InitGridIncItmLcBt(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "剩余效期(月)",
			field: "expMonths",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "剩余效期(天)",
			field: "expDays",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "药品规格",
			field: "inciSpec",
			width: 100
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
			title: "医嘱可用",
			field: "ordActive",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "库存可用",
			field: "stkActive",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
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
			field: 'manfName', 	
			title: '生产企业',
			align: 'left', 
			width: 150 
		}, { 
			field: 'vendorName', 	
			title: '经营企业',
			align: 'left', 
			width: 150 
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
		{	field:'ck', title:'sel', checkbox:true
		}, {
			title: "状态",
			field: "expState",
			width: 80,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.ExpState()
		}, {
			title: "药品代码",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "药品名称",
			field: "inciDesc",
			width: 200
		}, {
			title: "批号",
			field: "batNo",
			width: 100
		}, {
			title: "效期",
			field: "expDate",
			width: 100,
			align: 'center',
			hidden: false,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}
	]]
	var dataGridOption = {
		url: "",	
		fitColumns: false,
		border: false,
		headerCls: 'panel-header-gray',
		toolbar: '#gridIncItmLcBtTool',
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		exportXls: false,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	// 效期查询
	PHA.Grid('gridIncItmLcBt', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBt");
	// 近效期
	delete dataGridOption.toolbar;
	PHA.Grid('gridIncItmLcBtNearlyExp', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBtNearlyExp");
	// 药品养护勾选
	if (conserveFlag){
		$('#gridIncItmLcBt').datagrid('showColumn', "ck");
		$('#gridIncItmLcBtNearlyExp').datagrid('showColumn', "ck")
	} else {
		$('#gridIncItmLcBt').datagrid('hideColumn', "ck");
		$('#gridIncItmLcBtNearlyExp').datagrid('hideColumn', "ck");
	}
	
}

/**
 * 科室库存项表格
 */
function InitGridIncItmLcBtExpired(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "药品规格",
			field: "inciSpec",
			width: 100
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
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
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
			field: 'manfName', 	
			title: '生产企业',
			align: 'left', 
			width: 150 
		}, { 
			field: 'vendorName', 	
			title: '经营企业',
			align: 'left', 
			width: 150 
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
			field: "expState",
			width: 80,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.ExpState()
		}, {
			title: "药品代码",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "药品名称",
			field: "inciDesc",
			width: 200
		}, {
			title: "批号",
			field: "batNo",
			width: 100
		}, {
			title: "效期",
			field: "expDate",
			width: 100,
			align: 'center',
			hidden: false,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}
	]]
	var dataGridOption = {
		url: "",	
		fitColumns: false,
		border: false,
		headerCls: 'panel-header-gray',
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		exportXls: false,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLcBtExpired', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBtExpired");
}