/**
 * 名称: 科室库存项批次
 * 
 * 描述: 科室库存项批次 编写者：zhangyong 编写日期: 2012.1.11
 * 
 */
INCItmLcBtInfo = function(InciDr, PhaLoc, PhaLocRQ, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	var ItmLcBtUrl = DictUrl
			+ 'dhcinistrfaction.csp?actiontype=GetDrugInvInfo&IncId='
			+ InciDr + '&ProLocId=' + PhaLoc + '&ReqLocId=' + PhaLocRQ
			+ '&start=' + 0 + '&limit=' + 15;;

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : ItmLcBtUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["Inclb", "IncRowId", "IncCode", "IncName",
			"BatExp", "Manf", "InclbQty", "InitQty",
			"PurUomDesc", "Sp", "Transfer", "ReqQty",
			"BUomDesc", "Rp", "StkBin", "SupplyStockQty",
			"RequrstStockQty", "IngrDate", "Sepc", "GeneDesc", "FormDesc",
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty",
			"BatSp"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Inclb",
				fields : fields
			});
	// 数据集
	var ItmLcBtStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
				emptyMsg : "No results to display",
				prevText : "上一页",
				nextText : "下一页",
				refreshText : "刷新",
				lastText : "最后页",
				firstText : "第一页",
				beforePageText : "当前页",
				afterPageText : "共{0}页",
				emptyMsg : "没有数据"
			});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel();

	var ItmLcBtCm = new Ext.grid.ColumnModel([nm, sm, {
				header : "批次RowID",
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "物资编号RowId",
				dataIndex : 'IncRowId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '物资代码',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'IncName',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "批次/效期",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "批次库存",
				dataIndex : 'InclbQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "转移数量",
				dataIndex : 'InitQty',
				width : 80,
				align : 'right',
				sortable : true,
				hidden : true
			}, {
				header : "生产厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "单位RowId",
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "单位",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'BatSp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "类型",
				dataIndex : 'Transfer',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "请求数量",
				dataIndex : 'ReqQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "基本单位RowId",
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "基本单位",
				dataIndex : 'BUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "货位码",
				dataIndex : 'StkBin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "供应方库存",
				dataIndex : 'SupplyStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "请求方库存",
				dataIndex : 'RequrstStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "入库日期",
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'Sepc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "通用名",
				dataIndex : 'GeneDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'FormDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "转换率",
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "批次占用库存",
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "批次可用库存",
				dataIndex : 'AvaQty',
				width : 90,
				align : 'right',
				sortable : true
			}]);
	ItmLcBtCm.defaultSortable = true;

	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
				text : '返回',
				tooltip : '点击返回',
				iconCls : 'page_goto',
				handler : function() {
					returnData();
				}
			});
	/**
	 * 返回数据
	 */
	function returnData() {
		var selectRows = ItmLcBtGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择一条批次信息！");
		}else if(selectRows.length>1){
			Msg.info("warning", "只能选择一条批次信息！");
		} else {
			flg = true;
			window.close();
		}
	}

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '点击关闭',
				iconCls : 'page_delete',
				handler : function() {
					flg = false;
					window.close();
				}
			});

	var ItmLcBtGrid = new Ext.grid.GridPanel({
				cm : ItmLcBtCm,
				store : ItmLcBtStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
				loadMask : true,
				tbar : [returnBT, '-', closeBT],
				bbar : StatuTabPagingToolbar,
				deferRowRender : false
			});

	// 双击事件
	ItmLcBtGrid.on('rowdblclick', function() {
				returnData();
			});
	// 回车事件
	ItmLcBtGrid.on('keydown', function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnData();
				}
			});

	var window = new Ext.Window({
				title : '科室库存项批次信息',
				width : 700,
				height : 400,
				layout : 'fit',
				plain : true,
				modal : true,
				buttonAlign : 'center',
				autoScroll : true,
				items : ItmLcBtGrid
			});

	window.show();

	window.on('close', function(panel) {
				var selectRows = ItmLcBtGrid.getSelectionModel()
						.getSelections();
				if (selectRows.length == 0) {
					Fn("");
				}  else {
					if (flg) {
						Fn(selectRows[0]);
					} else {
						Fn("");
					}
				}
			});

	ItmLcBtStore.load({
				callback : function(r, options, success) {
					if (success == false) {

					} else {
						ItmLcBtGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
						row = ItmLcBtGrid.getView().getRow(0);
						var element = Ext.get(row);
						if (typeof(element) != "undefined" && element != null) {
							element.focus();
						}
					}
				}
			});
}
