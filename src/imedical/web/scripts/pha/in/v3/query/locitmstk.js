/**
 * 名称:	 库存查询
 * 编写人:	 pushuangcai
 * 编写日期: 2022-04-07
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.locitmstk.csp';
PHA_COM.App.Name = $g('库存查询');
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
	
	InitGridIncItmLoc();
	InitGridIncItmLcBt();
	
	InitEvents();
	InitDefVal();

	if (gOnlyResFlag == 'Y'){
		setTimeout(function(){Query()}, 500);
	}
})

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
        	{text: '医嘱可用', 		id: "ordActiveFlag" , 		selected: false},
        ]
	});	
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
 * 初始化界面默认值
 */
function InitDefVal(){
	$('#date').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
	if (gOnlyResFlag == 'Y'){
		$HUI.checkbox('#onlyResFlag').check();
	}
}

/**
 * 清屏、初始化默认值
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLcBt').datagrid('clear');
	$('#gridIncItmLcBtEmpty').datagrid('clear');
	$('#gridIncItmLcBtNotEmpty').datagrid('clear');
	$('#gridIncItmLoc').datagrid('clear');	
	InitDefVal();	
}

/**
 * 查询科室库存项
 */
function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'IncItmLoc',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridIncItmLoc').datagrid('loadData', data);
	    }
	);
}

/**
 * 查询批次
 */
function QueryBat(){
	var selectedRow = $('#gridIncItmLoc').datagrid('getSelected');
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

function GetParams(){
	var formData = QUE_FORM.GetFormData();
	var btKwArr = $('#btFilterKw').keywords('getSelected');
	for(var i = 0; i < btKwArr.length; i++){
		formData[btKwArr[i].id] = true;	
	}
	return formData;
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
			field: 'dirtyQtyWithUom',
			title: '占用库存',
			width: 100,
			hidden: false,
			align: 'right',
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("合计") > -1)){
					return "";	
				}
				return '<a class="pha-grid-a js-grid-dirtyQtyUom">' + value + '</a>';	
			}
		}, {
			field: 'resQtyWithUom',
			title: '在途数',
			width: 100,
			hidden: false,
			align: 'right',
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				if (value == 0){
					return value;
				}
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("合计") > -1)){
					return "";	
				}
				return '<a class="pha-grid-a js-grid-resQtyWithUom">' + value + '</a>';	
			}
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
			title: "pFac",
			field: "pFac",
			width: 100,
			hidden: true
		}, {
			title: "门诊加锁",
			field: "outLockFlag",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "住院加锁",
			field: "inLockFlag",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
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
		}, {
			title: "药品图标",
			field: "inciIcon",
			width: 120,
			formatter: PHA_COM.Drug.Icon
		}
	]];
	var frozenColumns = [[
		{
			title: "操作",
			field: "operate",
			width: 120,
			align: 'center',
			ifExport: false,
			formatter: function(val, rowData, rowIndex){
				if ($.isEmptyObject(rowData)){ return ""; }
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("合计") > -1)){
					return "";	
				}
				var retArr = [];
				if (ParamProp.TransShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-paper" title="台账信息查询">&ensp;</span>');
				}
				if (ParamProp.DayTotalShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-paper-eye-r" title="全院科室库存">&ensp;</span>');
				}
				if(ParamProp.ClrResQtyLocInciShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-uncheckin" title="科室单品在途数清除">&ensp;</span>');
				}
				return retArr.join('');
			}
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
		fitColumns: false,
		border: false,
		exportChkCol: true,
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
        gridSave: true,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
            if (data.total > 0){
	           $(this).datagrid('selectRow', 0); 
	        }
		},
		onSelect: function(rowIndex, rowData){
			QueryBat();
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);

	var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-resQtyWithUom');
	eventClassArr.push('pha-grid-a js-grid-dirtyQtyUom');
	eventClassArr.push('pha-grid-a icon icon-paper');
	eventClassArr.push('pha-grid-a icon icon-paper-eye-r');
	eventClassArr.push('pha-grid-a icon icon-uncheckin');

	PHA.GridEvent('gridIncItmLoc', 'click', eventClassArr, function(rowIndex, rowData, className){
		var opType = "";
		if (className === 'pha-grid-a js-grid-resQtyWithUom') {
			if (rowData.resQtyWithUom == 0){
				return;	
			}
			opType = "resQty"; 
		} else if (className === 'pha-grid-a js-grid-dirtyQtyUom') {
			if (rowData.dirtyQtyUom == 0){
				return;	
			}
			opType = "dirtyQty"; 
		} else if (className === 'pha-grid-a icon icon-paper') {
			opType = "Intr"; 
		} else if (className === 'pha-grid-a icon icon-paper-eye-r') {
			opType = "HospStk"; 
		} else if (className === 'pha-grid-a icon icon-uncheckin'){
			if ((!rowData.resQtyWithUom) || (rowData.resQtyWithUom == 0) || (rowData.resQtyWithUom == "")){
				PHA.Popover({
					msg: '在途数为0，无需清除！',
					type: 'alert'
				});
				return;	
			}
			PHA.BizPrompt({
			}, function (r) {
				if (typeof r === "undefined"){
					return;
				}
				ClearIncilResQty({incil: rowData.incil}, function(retJson){
					if (retJson.code == 0){		
						PHA_LOG.Operate({
							operate: 'D',
							logInput: JSON.stringify({incil: rowData.incil}),
							type: 'User.DHCIncReservedQtyDetail',
							pointer: '',
							origData: '',
							remarks: '科室单品在途数清除' + (r == '' ? '' : '（'+ r +'）')
						});
						$('#gridIncItmLoc').datagrid('updateRow',{
						    index: parseInt(rowIndex),
						    row: {
						        resQtyWithUom: retJson.data
						    }
						});
						QueryBat();
					}					
				});
			});
			return;
		}else {
			return;
		}
		OpenOperateWin({
			inci: rowData.incil.split("||")[0],
			incil: rowData.incil,
			opType: opType,
			inciDesc: rowData.inciDesc
		});	
	})
	QUE_COM.ComGridEvent("gridIncItmLoc");
}

/**
 * 批次明细表格
 */
function InitGridIncItmLcBt(){
	var frozenColumns = [[
		{
			title: "医嘱提示",
			field: "btTips",
			width: 65,
			ifExport: false,
			hidden: false,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.BtTips()
		},{
			title: "操作",
			field: "operate",
			width: 50,
			ifExport: false,
			align: 'center',
			formatter: function(val, rowData, rowIndex){
				if ($.isEmptyObject(rowData)){ return ""; }
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("合计") > -1)){
					return "";	
				}
				var retArr = [];
				if (ParamProp.TransShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-apply-check" title="批次台账查询">&ensp;</span>');
				}
				return retArr.join('');
			}
		},{
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
				field: 'dirtyQtyWithUom',
				title: '占用库存',
				width: 100,
				hidden: false,
				align: 'right',
				formatter: function(value, rowData){
					if (!value) { return ""; }
					if ($.isEmptyObject(rowData)){ return ""; }
					if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("合计") > -1)){
						return "";	
					}
					return '<a class="pha-grid-a js-grid-dirtyQtyUom">' + value + '</a>';	
				}
			}, {
				field: 'resQtyWithUom',
				title: '在途数',
				width: 100,
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
				title: "生产企业",
				field: "manfName",
				width: 250
			}, {
				title: "经营企业",
				field: "vendorName",
				width: 250
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
				title: "最近入库",
				field: "lastIngrDate",
				width: 100,
				align: 'center'
			}
		]
	];
	var dataGridOption = {
		url: "",	
		headerCls: 'panel-header-gray',
		//nowrap: false,
		fitColumns: false,
		border: false,
		exportChkCol: true,
		rownumbers: true,
		fixRowNumber: true,
		columns: columns,
		frozenColumns: frozenColumns,
		showFooter: false,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		pagination: true,
		singleSelect: true,
		isCellEdit: true,
		gridSave: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLcBt', dataGridOption);
	PHA.Grid('gridIncItmLcBtEmpty', dataGridOption);
	PHA.Grid('gridIncItmLcBtNotEmpty', dataGridOption);
	
	var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-dirtyQtyUom');
	eventClassArr.push('pha-grid-a icon icon-apply-check');
	PHA.GridEvent('gridIncItmLcBt', 'click', eventClassArr, BtGridCellClickEvent);
	PHA.GridEvent('gridIncItmLcBtEmpty', 'click', eventClassArr, BtGridCellClickEvent);
	PHA.GridEvent('gridIncItmLcBtNotEmpty', 'click', eventClassArr, BtGridCellClickEvent);
	
	QUE_COM.ComGridEvent("gridIncItmLcBt");
	QUE_COM.ComGridEvent("gridIncItmLcBtEmpty");
	QUE_COM.ComGridEvent("gridIncItmLcBtNotEmpty");
}

/**
 * 批次表格列点击事件
 */
function BtGridCellClickEvent(rowIndex, rowData, className){
	var opType = "";
	if (className === 'pha-grid-a js-grid-dirtyQtyUom') {
		opType = "dirtyQty"; 
		if (rowData.dirtyQtyUom == 0){
			return;	
		}
	} else if (className === 'pha-grid-a icon icon-apply-check') {
		opType = "Intr"; 
	} else {
		return;
	}
	OpenOperateWin({
		inci: rowData.inclb.split("||")[0],
		incil: rowData.inclb.split("||")[0] +"||"+ rowData.inclb.split("||")[1],
		inclb: rowData.inclb,
		opType: opType,
		inciDesc: rowData.inciDesc
	});	
}