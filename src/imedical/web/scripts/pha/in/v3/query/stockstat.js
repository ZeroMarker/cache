/**
 * 名称:	 库存统计
 * 编写人:	 pushuangcai
 * 编写日期: 2022-03-28
 */
 
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.stockstat.csp';
PHA_COM.App.Name = $g('库存统计');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID'],
	batGridType: 'group'
};

$(function(){
	InitComponent();				// 页面组件
	QUE_FORM.InitComponents(); 		// 公共组件 component.js
		
	InitGridIncItmLoc();
	InitGridIncItmLcBtAll();
	InitGridIncItmLocSimple();
	InitGridIncItmLcBt();
	PHA_COM.SetPanel('#tabMain', "库存统计");
	
	InitEvents();
	InitDefVal();
})

/**
 * 查询
 */
function Query(){
	var pJson = GetParams();	
	if (pJson === null){
		return;	
	}
	var $selTabs = $('#mainTabs').tabs('getSelected');
	var selIndex = $('#mainTabs').tabs('getTabIndex', $selTabs);

	if (selIndex === 0){		
		$('#gridIncItmLoc').datagrid('loading');
	    PHA.CM({
			    pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'LocItmStat',
		        pJsonStr: JSON.stringify(pJson)
		    },function(data){
		        $('#gridIncItmLoc').datagrid('loadData', data);
		    }
		);
	} else if (selIndex === 1){
		if ($HUI.checkbox('#NotEmptyFlag').getValue()){
			pJson.batFlag = "NotEmpty";	
		};
		$('#gridIncItmLcBtAll').datagrid('options').url = PHA.$URL;
		$('#gridIncItmLcBtAll').datagrid('query', {
			pJsonStr: JSON.stringify(pJson)
		});
	} else if (selIndex === 2){
		$('#gridIncItmLocSimple').datagrid('loading');
	    PHA.CM({
			    pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'LocItmStat',
		        pJsonStr: JSON.stringify(pJson)
		    },function(data){
		        $('#gridIncItmLocSimple').datagrid('loadData', data);
		    }
		);
	}
}

/**
 * 查询批次
 */
function QueryBat(){
	var selectedRow = $('#gridIncItmLocSimple').datagrid('getSelected');
	if (!selectedRow){
		return;	
	}
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	pJson.incil = selectedRow.incil;

	var tab = $('#lcBtTabs').tabs('getSelected');
	var index = $('#lcBtTabs').tabs('getTabIndex', tab);
	var $btGrid = "";
	if (index === 1){
		$btGrid = $('#gridIncItmLcBtNotEmpty');
		pJson.batFlag = "NotEmpty";
	} else if (index === 2){
		$btGrid = $('#gridIncItmLcBtEmpty');
		pJson.batFlag = "Empty";
	} else if (index === 3){
		$btGrid = $('#gridIncItmLcBt');
	}
	
	$btGrid.datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'IncItmLcBatPorxy',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $btGrid.datagrid('loadData', data);
	    }
	);
}

/**
 * 参数
 */
function GetParams(){
	var formData = QUE_FORM.GetFormData();
	var kwArr = $('#btFilterKw').keywords('getSelected');
	for(var i = 0; i < kwArr.length; i++){
		formData[kwArr[i].id] = true;	
	}
	return formData;
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');
	$('#gridIncItmLcBtAll').datagrid('clear');	
	$('#gridIncItmLocSimple').datagrid('clear');	
	$('#gridIncItmLcBtNotEmpty').datagrid('clear');	
	$('#gridIncItmLcBtEmpty').datagrid('clear');	
	$('#gridIncItmLcBt').datagrid('clear');	
	InitDefVal();	
}

/**
 * 绑定事件
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
	$('#lcBtTabs').tabs({
		onSelect: function(title, index){
			QueryBat();
		}
	});	
}

/**
 * 初始化界面组件
 */
function InitComponent(){
	$('#btFilterKw').keywords({
        onClick:function(v){
	        QueryBat();
	    },
	    singleSelect: false,
        items:[
        	{text: '库存可用', 		id: "stkActiveFlag" , 		selected: false},
        	{text: '医嘱可用', 		id: "ordActiveFlag" , 		selected: false}
        ]
	});	
}

/**
 * 初始化界面默认值
 */
function InitDefVal(){
	$('#date').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
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
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
		}, {
			title: "库存(入库)",
			field: "pQty",
			width: 90,
			align: 'right'
		}, {
			title: "入库单位",
			field: "pUomDesc",
			width: 80,
			align: 'left'
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
		}, {
			title: "库存(基本)",
			field: "bQty",
			width: 90,
			align: 'right'
		}, {
			title: "基本单位",
			field: "bUomDesc",
			width: 80,
			align: 'left'
		}, {
			field: 'avaQtyWithUom',
			title: '可用库存',
			width: 150,
			hidden: false,
			align: 'right'
		}, {
			title: "进价(入库)",
			field: "TPRp",
			width: 90,
			align: 'right'
		}, {
			title: "售价(入库)",
			field: "TPSp",
			width: 90,
			align: 'right'
		}, {
			title: "进价(基本)",
			field: "TBRp",
			width: 90,
			align: 'right'
		}, {
			title: "售价(基本)",
			field: "TBSp",
			width: 90,
			align: 'right'
		}, {
			title: "进价金额",
			field: "TRpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "售价金额",
			field: "TSpAmt",
			width: 120,
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
		nowrap: false,
		fitColumns: false,
		border: false,
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

/**
 * 批次明细表格
 */
function InitGridIncItmLcBtAll(){
	var frozenColumns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "药品代码",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode(),
			hidden: true
		}, {
			title: "药品名称",
			field: "inciDesc",
			width: 200,
			hidden: true
		}, {
			title: "批号",
			field: "batNo",
			width: 110,
		}
	]];
	var columns = [[
		{
			title: "效期",
			field: "expDate",
			align: 'center',
			width: 100,
			styler: QUE_COM.Grid.Styler.ExpDate,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}, {
			title: "库存(入库)",
			field: "pQty",
			width: 100,
			align: 'right'
		}, {
			title: "入库单位",
			field: "pUomDesc",
			width: 70,
			align: 'left'
		}, {
			title: "库存(基本)",
			field: "bQty",
			width: 100,
			align: 'right'
		}, {
			title: "基本单位",
			field: "bUomDesc",
			width: 80,
			align: 'left'
		}, {
			field: 'avaQtyWithUom',
			title: '可用库存',
			width: 150,
			hidden: false,
			align: 'right'
		}, {
			title: "进价(基本)",
			field: "TBRp",
			width: 90,
			align: 'right'
		}, {
			title: "售价(基本)",
			field: "TBSp",
			width: 90,
			align: 'right'
		}, {
			title: "进价(入库)",
			field: "TPRp",
			width: 90,
			align: 'right'
		}, {
			title: "售价(入库)",
			field: "TPSp",
			width: 90,
			align: 'right'
		}, {
			title: "进价金额",
			field: "TRpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "售价金额",
			field: "TSpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "生产企业",
			field: "manfName",
			width: 180
		}, {
			title: "经营企业",
			field: "vendorName",
			width: 180
		}, {
			title: "货位",
			field: "stkBin",
			width: 120,
			hidden: true
		}, {
			title: "最近入库",
			field: "lastIngrDate",
			width: 100,
			align: 'center'
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
		}
	]]
	var dataGridOption = {
		url: "",
		queryParams: {
			pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'LocItmBatStat'
		},	
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		nowrap: false,
		fitColumns: false,
		border: false,
		toolbar: '#gridIncItmLcBtAllTool',
		rownumbers: true,
		fixRowNumber: true,
		columns: columns,
		showFooter: true,
		frozenColumns: frozenColumns,
        pageNumber: 1,
		pagination: true,
		singleSelect: true,
		groupField: 'inci',
        view: groupview,
        groupFormatter: function(value, rows){
			return '' +rows[0].inciDesc +'</b>'
					+ '<font style="font-weight:100;">&ensp; | &ensp;'+ $g('代码') + '：' + rows[0].inciCode
					+ '&ensp;|&ensp;'+ $g('规格') + '：' + (rows[0].inciSpec || "")
					+ '&ensp;|&ensp;'+ $g('处方通用名') + '：' + (rows[0].geneName || "")
					+ '&ensp;|&ensp;'+ $g('剂型') + '：' + (rows[0].phcFormDesc || "")
					+ '&ensp;|&ensp;'+ $g('货位') + '：' + (rows[0].stkBin || "")
					+ '</font>';
        }
	};
	PHA.Grid('gridIncItmLcBtAll', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBtAll");
}


/**
 * 科室库存项表格
 */
function InitGridIncItmLocSimple(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
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
			title: "药品规格",
			field: "inciSpec",
			width: 100
		}
	]]
	var dataGridOption = {
		url: "",	
		fitColumns: false,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		showFooter: false,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		},
		onSelect: function(){
			QueryBat();
		}
	};
	PHA.Grid('gridIncItmLocSimple', dataGridOption);
	
    QUE_COM.ComGridEvent("gridIncItmLocSimple");
}

/**
 * 批次明细表格
 */
function InitGridIncItmLcBt(){
	var frozenColumns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "批号",
			field: "batNo",
			width: 110,
		}
	]];
	var columns = [[
		{
			title: "效期",
			field: "expDate",
			align: 'center',
			width: 100,
			styler: QUE_COM.Grid.Styler.ExpDate,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}, {
			title: "库存(入库)",
			field: "pQty",
			width: 100,
			align: 'right'
		}, {
			title: "入库单位",
			field: "pUomDesc",
			width: 70,
			align: 'left'
		}, {
			title: "库存(基本)",
			field: "bQty",
			width: 100,
			align: 'right'
		}, {
			title: "基本单位",
			field: "bUomDesc",
			width: 80,
			align: 'left'
		}, {
			field: 'avaQtyWithUom',
			title: '可用库存',
			width: 150,
			hidden: false,
			align: 'right'
		}, {
			title: "进价(基本)",
			field: "TBRp",
			width: 90,
			align: 'right'
		}, {
			title: "售价(基本)",
			field: "TBSp",
			width: 90,
			align: 'right'
		}, {
			title: "进价(入库)",
			field: "TPRp",
			width: 90,
			align: 'right'
		}, {
			title: "售价(入库)",
			field: "TPSp",
			width: 90,
			align: 'right'
		}, {
			title: "进价金额",
			field: "TRpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "售价金额",
			field: "TSpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "生产企业",
			field: "manfName",
			width: 180
		}, {
			title: "经营企业",
			field: "vendorName",
			width: 180
		}, {
			title: "货位",
			field: "stkBin",
			width: 100
		}, {
			title: "最近入库",
			field: "lastIngrDate",
			width: 100,
			align: 'center'
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
		}
	]];
	var dataGridOption = {
		url: "",	
		headerCls: 'panel-header-gray',
		nowrap: false,
		fitColumns: false,
		border: false,
		rownumbers: true,
		fixRowNumber: true,
		columns: columns,
		frozenColumns: frozenColumns,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		pagination: true,
		singleSelect: true,
		isCellEdit: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLcBt', dataGridOption);
	PHA.Grid('gridIncItmLcBtEmpty', dataGridOption);
	PHA.Grid('gridIncItmLcBtNotEmpty', dataGridOption);	
	
    QUE_COM.ComGridEvent("gridIncItmLcBt");
    QUE_COM.ComGridEvent("gridIncItmLcBtEmpty");
    QUE_COM.ComGridEvent("gridIncItmLcBtNotEmpty");

}