/**
 * 名称:	 库存查询 - 弹窗、操作相关
 * 编写人:	 pushuangcai
 * 编写日期: 2022-04-07
 */
 
PHA_COM.VAR.OPER = {
	incil: '',
	inclb: '',
	opType: '',
	winId: "PHA_Query_LocStk_Win",
	gridId: "PHA_Query_LocStk_Grid"
};
	
/**
 * 初始化明细窗口
 * @params {string} incil 科室库存项id
 * @params {function} fun 初始化明细表格的函数
 */
function InitOperateWin(opts, fun){
	
	if(opts.opType !== PHA_COM.VAR.OPER.opType){
		var $widow = $('#'+ PHA_COM.VAR.OPER.winId);
		if ($widow.length === 0){
			var $widow = $('<div id="'+ PHA_COM.VAR.OPER.winId +'" class="pha-panel-body-content"></div>').appendTo('body');
		}
		$widow.empty();
		$widow.append('<div id="'+ PHA_COM.VAR.OPER.gridId +'"></div>');
		PHA_COM.VAR.OPER.opType = opts.opType;
	} else {
		return;	
	}
	
	if (typeof opts === "undefined"){
		var opts = {};	
	}
	$widow.window({
		collapsible: false,
		minimizable: false,
		aximizable: false,
		closed: true,
		modal: true,
		title: opts.title || $g("操作窗口"),
		width: opts.width || $(this).width() * 0.65,
		height: opts.height || $(this).height() * 0.65,
		iconCls: 'icon-w-list',
		onOpen: function(){
			$(this).window('center');
		},
		onClose: function(){
			PHA_UX.BusiTimeLine({},{}, "close");
		}
	});
	if (fun) {
		fun();	
	}
}

function OpenOperateWin(pJson){
	PHA_COM.VAR.OPER.incil = pJson.incil || "";
	PHA_COM.VAR.OPER.inclb = pJson.inclb || "";
	
	if (pJson.inciDesc !== ""){
		pJson.inciDesc = "："+ pJson.inciDesc;	
	}
	var winOpts = {};
	winOpts.opType = pJson.opType;
	if (pJson.opType === "resQty"){
		
		winOpts.title = $g("在途数明细") + pJson.inciDesc;
		winOpts.width = $(this).width() * 0.65;
		winOpts.height = $(this).height() * 0.65;	
		InitOperateWin(winOpts, InitResQtyGrid);
		
	} else if (pJson.opType === "dirtyQty"){
		
		winOpts.title = $g("占用单据明细") + pJson.inciDesc;
		winOpts.width = 800;
		winOpts.height = $(this).height() * 0.5;	
		InitOperateWin(winOpts, InitDirtyQtyGrid);

	} else if (pJson.opType === "HospStk"){
		
		winOpts.title = $g("全院科室库存") + pJson.inciDesc;
		winOpts.width = 550;
		winOpts.height = $(this).height() * 0.6;		
		InitOperateWin(winOpts, InitHospStockGrid);

	}  else if (pJson.opType === "Intr"){
		
		winOpts.title = $g("台账信息") + pJson.inciDesc;
		winOpts.width = $(this).width() * 0.7;
		winOpts.height = $(this).height() * 0.7;	
		InitOperateWin(winOpts, InitIntrGrid);
		
	}

	// 重置页码
	var $grid = $('#'+ PHA_COM.VAR.OPER.gridId);
	if ($grid.length > 0){
		var gridOpts = $grid.datagrid('options');
	    gridOpts.pageNumber = 1;
	    var pager = $grid.datagrid('getPager');
	    pager.pagination('refresh', {
		    pageNumber: 1
		});
	} 
	// 查询方法
	GetOperateDetail(pJson);
	// 修改窗口标题
	$('#'+ PHA_COM.VAR.OPER.winId).window('setTitle', winOpts.title);
	$('#'+ PHA_COM.VAR.OPER.winId).window('open');
}

/**
 * 查询业务数据明细
 * @params {object} pJson 
 * @params {string} pJson.incil 	科室库存项id
 * @params {string} pJson.inclb 	科室库存批次id
 * @params {string} pJson.opType 	查询类别
 */
function GetOperateDetail(pJson){
	if (pJson.opType === "Intr"){
		var trStDate = $('#trStDate').datebox('getValue');
		var trEnDate = $('#trEnDate').datebox('getValue');
		pJson.trStDate = trStDate;
		pJson.trEnDate = trEnDate;
	}
	var $grid = $('#'+ PHA_COM.VAR.OPER.gridId);
	$grid.datagrid('loading');
	
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'GetOperateDetail',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $grid.datagrid('loadData', data);
	    }
	);
}

/**
 * 清除科室单品在途数
 * @params {string} pJson.incil 	科室库存项id
 */
function ClearIncilResQty(pJson, callback){
	PHA.CM(
		{
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'ClrReserveByIncil',
	        pJsonStr: JSON.stringify(pJson)
	    },function(retJson){
		    PHA.Ret(retJson);
		    if (callback){
				callback(retJson);    
			}
		}
	);
}

/**
 * 初始化在途数表格
 */
function InitResQtyGrid() {
    var columns = [[
		{ 
			field: 'gridDetailSelect', 
			checkbox: true 
		}, { 
			field: 'rowId', 
			title: 'rowId', 
			hidden: true 
		}, { 
			field: 'incil', 
			title: 'incil', 
			hidden: true 
		}, { 
			field: 'pointer', 
			title: 'pointer', 
			hidden: true 
		}, { 
			field: 'patNo', 
			title: '登记号', 
			align: 'left', 
			width: 150 
		}, { 
			field: 'patName', 
			title: '姓名', 
			align: 'left', 
			width: 100 
		}, { 
			field: 'ordDeptDesc', 
			title: '医嘱科室', 
			align: 'left', 
			width: 200 
		}, { 
			field: 'prescno', 
			title: '处方号', 
			align: 'left', 
			width: 150 
		}, { 
			field: 'qtyUom', 
			title: '在途数', 
			align: 'right', 
			width: 100 
		}, { 
			field: 'batNo', 
			title: '批号', 
			align: 'right', 
			width: 100,
			hidden: true
		}, { 
			field: 'dateTime', 
			title: '时间', 
			align: 'left', 
			width: 150 
		}
	]];
    var dataGridOption = {
        url: "",
        singleSelect: false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: '',
        rownumbers: true,
		border: true,
        gridSave: false,
        loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		checkOnSelect: false,
		selectOnCheck: false,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		toolbar: [{
			iconCls: 'icon-cancel',
			text: '清除在途数',
			handler: function(){
			    var rowsChecked = $('#'+ PHA_COM.VAR.OPER.gridId).datagrid('getChecked');
			    if (rowsChecked.length === 0) {
			        PHA.Popover({ 
			        	showType: 'show', 
			        	msg: '请勾选需要清除的在途明细', 
			        	type: 'alert' 
			        });
			        return;
			    }
			    var pJson = [];
			    for (var i = 0; i < rowsChecked.length; i++) {
			        pJson.push(rowsChecked[i].pointer);
			    }
				PHA.BizPrompt({
				}, function (r) {
					if (typeof r === "undefined"){
						return;
					}
					PHA.CM({
							pClassName: 'PHA.IN.Query.Api',
							pMethodName: 'ClrReserveByPointer',
							pJsonStr: JSON.stringify(pJson)
						},function(retJson){
							PHA.Ret(retJson);
							if (retJson.code == 0){
								PHA_LOG.Operate({
									operate: 'D',
									logInput: JSON.stringify(pJson),
									type: 'User.DHCIncReservedQtyDetail',
									pointer: '',
									origData: '',
									remarks: '清除在途数'+ (r == '' ? '' : '（'+ r +'）')
								});
								GetOperateDetail(PHA_COM.VAR.OPER);
							}
						}
					);
			    });
			}
		}],
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		}
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
}

/**
 * 占用单据明细表格
 */
function InitDirtyQtyGrid(){
	var columns = [[
		{ 
    		field: 'initck', 
    		title: 'initck',
			checkbox: true
    	}, { 
    		field: 'initItmId', 
    		title: 'initItmId', 
    		align: 'left', 
    		width: 200, 
    		hidden: true 
    	}, { 
        	field: 'trNo', 
        	title: '转移单号', 
        	align: 'left', 
        	width: 220,
			formatter: QUE_COM.Grid.Formatter.TransNo()
        }, { 
        	field: 'batNo', 
        	title: '批号', 
        	align: 'left', 
        	width: 100 
        }, { 
        	field: 'qty', 
        	title: '占用数量', 
        	align: 'right', 
        	width: 100 
        }, { 
        	field: 'uomDesc', 
        	title: '单位', 
        	align: 'left', 
        	width: 100 
        }, { 
        	field: 'trDate', 
        	title: '单据日期', 
        	align: 'left', 
        	width: 150, 
        	formatter: function(value, rowData, rowIndex){
	        	return value +" "+ rowData.trTime;
	        }
        }
	]];
	var dataGridOption = {
        url: "",
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        loadFilter: PHA.LocalFilter,
		pageSize: 30,
        border: true,
		gridSave: false,
        pageNumber: 1,
		fixRowNumber: true,
		checkOnSelect: false,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		selectOnCheck: false,
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		},
		toolbar: [{
			iconCls: 'icon-cancel',
			text: '删除占用',
			handler: function(){
			    var checkedRows = $('#'+ PHA_COM.VAR.OPER.gridId).datagrid('getChecked');
			    if (checkedRows.length === 0) {
			        PHA.Popover({ 
			        	showType: 'show', 
			        	msg: '请勾选需要删除占用的单据', 
			        	type: 'alert' 
			        });
			        return;
			    }
				var initiArr = [];
				for (var i = 0; i < checkedRows.length; i++){
					initiArr.push(checkedRows[i].initItmId);
				}
			    var pJson = {
					rows: initiArr   
				}
				PHA.BizPrompt({
					info: "该操作将删除对应单据中的药品明细"
					}, function (r) {
						if (typeof r === "undefined"){
							return;
						}
						PHA.CM(
							{
								pClassName: 'PHA.IN.Query.Api',
								pMethodName: 'DelDirtyQty',
								pJsonStr: JSON.stringify(pJson)
							},function(retJson){
								PHA.Ret(retJson);
								if (retJson.code == 0){
									GetOperateDetail(PHA_COM.VAR.OPER);		
									PHA_LOG.Operate({
										operate: 'D',
										logInput: JSON.stringify(pJson),
										type: 'User.DHCInIsTrfItm',
										pointer: '',
										origData: JSON.stringify(PHA_COM.VAR.OPER),
										remarks: '删除占用'+ (r == '' ? '' : '（'+ r +'）')
									});	
								}		    
							}
						);
					}
				);
			}
		}],
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
	QUE_COM.ComGridEvent(PHA_COM.VAR.OPER.gridId);
}

function InitHospStockGrid(){
	var columns = [[
    	{ 
    		field: 'locDesc', 
    		title: '科室', 
    		align: 'left', 
    		width: 250 
    	}, { 
    		field: 'qtyWithUom', 
    		title: '库存(单位)', 
    		align: 'right', 
    		width: 250,
    		hidden: false
    	}, {
			title: "库存(入库)",
			field: "pQty",
			width: 150,
			align: 'right',
			hidden: true
		}, {
			title: "入库单位",
			field: "pUomDesc",
			width: 70,
			align: 'left',
			hidden: true
		}, {
			title: "库存(基本)",
			field: "bQty",
			width: 150,
			align: 'right',
			hidden: true
		}, {
			title: "基本单位",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}
    ]];
	var dataGridOption = {
        url: "",
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        border: true,
		toolbar: '',
        gridSave: false,
		loadFilter: PHA.LocalFilter,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		pageSize: 30,
        pageNumber: 1,
        showFooter: true,
		fixRowNumber: true,
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		}
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
}

function InitIntrGrid(){
	var columns = [[
    	{ 
    		field: 'intrId',
    		title: 'intrId',
    		align: 'left',
    		width: 100, 
    		hidden: true 
    	}, { 
    		field: 'typeDesc',
    		title: '业务类型', 		
    		align: 'left',	
    		width: 100, 
    		hidden: false
		}, { 
			field: 'date', 		
			title: '时间', 			
			align: 'left', 	
			width: 160, 
			hidden: false,
            formatter: function(val, row, index){
	            return val +" "+ row.time;
	        }
		}, { 
			field: 'operator', 	
			title: '操作人', 		
			align: 'left', 	
			width: 100, 
			hidden: false 
		}, { 
			field: 'batNo', 		
			title: '批号', 			
			align: 'left', 
			width: 100
		}, { 
			field: 'expDate', 	
			title: '效期', 			
			align: 'left', 	
			width: 100, 
			hidden: true
		}, { 
			field: 'qtyWithUom', 		
			title: '数量(单位)', 			
			align: 'right', 
			width: 100,
			formatter: function(value, rowData, index){
				if (rowData.qty > 0){
					value = "+" + value;
				}
				return value;
			},
			styler: function(value, rowData, index){
				var styleStr = "";
				if (rowData.qty > 0){
					styleStr = "color:#5DB42F;"
				} else if (rowData.qty < 0){
					styleStr = "color:#F25757;"	
				}
	            return 'font-weight:bold;' + styleStr;	
	        }
		}, { 
			field: 'endQtyWithUom', 	
			title: '结余数量(单位)', 		
			align: 'right', 
			width: 150 
		}, { 
			field: 'pQty', 		
			title: '数量(入库)', 			
			align: 'right', 
			width: 100,
			hidden: true 
		}, { 
			field: 'endPQty', 	
			title: '结余数量(入库)', 		
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'pUomDesc', 	
			title: '入库单位', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'bQty', 		
			title: '数量(基本)', 			
			align: 'right', 
			width: 100,
			hidden: true 
		}, { 
			field: 'endBQty', 	
			title: '结余数量(基本)', 		
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'bUomDesc', 	
			title: '基本单位', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'qty', 		
			title: '数量', 			
			align: 'right', 
			width: 100,
			hidden: true 
		}, { 
			field: 'uomDesc', 	
			title: '单位', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'intrNo', 		
			title: '处理号', 		
			align: 'left', 	
			width: 150 
		}, { 
			field: 'rp', 			
			title: '进价', 			
			align: 'right', 
			width: 100 
		}, { 
			field: 'sp', 			
			title: '售价', 			
			align: 'right', 
			width: 100 
		}, { 
			field: 'rpAmt', 		
			title: '进价金额', 		
			align: 'right', 
			width: 100 
		}, { 
			field: 'spAmt', 		
			title: '售价金额', 		
			align: 'right', 
			width: 100 
		}, { 
			field: 'type', 		
			title: '业务类型Code', 	
			align: 'left',
			width: 100, 
			hidden: true 
		}, { 
			field: 'endRpAmt', 	
			title: '结余金额(进价)',
			align: 'right', 
			width: 100 
		}, { 
			field: 'endSpAmt', 	
			title: '结余金额(售价)',
			align: 'right', 
			width: 100 
		}            
	]];
    var $toolbar = $('<div><table class="pha-con-table"><tr>'
    	+ '<td>'+ $g('开始日期')+ '</td>'
	    + '<td><input id="trStDate"></td>'
	    + '<td>'+ $g('截止日期') +'</td>'
	    + '<td><input id="trEnDate"></td>'
	    + '<td><a id="btnFindIntr">'+ $g('查询')+ '</a></td>'
    +'</tr></table></div>').prependTo('#'+ PHA_COM.VAR.OPER.winId);
	$('#trStDate').datebox({value: PHA_UTIL.SysDate("t")});
 	$('#trEnDate').datebox({value: PHA_UTIL.SysDate("t")});
 	
 	$('#btnFindIntr').linkbutton({
		onClick: function(){
			GetOperateDetail(PHA_COM.VAR.OPER);
		}	
	});
	
    var dataGridOption = {
        url: "",
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: $toolbar,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		border: true,
        loadFilter: PHA.LocalFilter,
		pageSize: 30,
		gridSave: false,
        pageNumber: 1,
        fit: true,
		fixRowNumber: true,
		nowrap: false,
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		}
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
}