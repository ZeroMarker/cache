// /名称: 转移入库审核
// /描述: 转移入库审核
// /编写者：zhangyong
// /编写日期: 2012.1.16
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		// 请求部门
		var RequestPhaLoc = new Ext.form.ComboBox({
					fieldLabel : '请求部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor : '90%',
					width : 120,
					store : PhaDeptStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					emptyText : '请求部门...',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		// 供给部门
		var SupplyPhaLoc = new Ext.form.ComboBox({
					fieldLabel : '供给部门',
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor : '90%',
					width : 120,
					store : PhaDeptStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					emptyText : '供给部门...',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '起始日期',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 120,
					value : new Date().add(Date.DAY, - 7)
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '截止日期',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 120,
					value : new Date()
				});

		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						searchData();
					}
				});
		/**
		 * 查询方法
		 */
		function searchData() {
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", "请选择请求部门!");
				return;
			}

			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var statue = "21";

			MasterStore.proxy = new Ext.data.HttpProxy({
				url : DictUrl
						+ 'stocktransferaction.csp?actiontype=DHCInIsTrfQuery&StartDate='
						+ startDate + '&EndDate=' + endDate + '&SupplyPhaLoc='
						+ supplyphaLoc + '&RequestPhaLoc=' + requestphaLoc
						+ '&State=' + statue
			});
			MasterStore.load();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		/**
		 * 清空方法
		 */
		function clearData() {
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("SupplyPhaLoc").setValue("");
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		// 审批按钮
		var CheckBT = new Ext.Toolbar.Button({
					id : "CheckBT",
					text : '审批',
					tooltip : '点击审批',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						checkData();
					}
				});

		/**
		 * 审批转移单入库
		 */
		function checkData() {
			// 判断转移单是否已审批
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "请选择审核的转移单!");
				return;
			}

			var INITState = rowData.get("INITStateCode");
			if (INITState != "21") {
				Msg.info("warning", "转移单状态不正确!");
				return;
			}

			var trno = rowData.get("INITNo");
			var state = "31";
			var url = DictUrl
					+ "stocktransferaction.csp?actiontype=TransInCheck&trno="
					+ trno + "&userId=" + userId + "&state=" + state;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", "审批入库成功!");
								clearData();
							} else {
								Msg.info("error", "审批入库失败!");
							}
						},
						scope : this
					});
		}

		// 访问路径
		var MasterUrl = "";
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		// 转移单号RowId，转移单号，请求单号，请求部门，供给部门，转移日期，单据状态，出库人员，制单人，批价金额，售价金额，进销差价，备注
		var fields = ["INITRowId", "INITNo", "INRQNo", "INITToLocDesc",
				"INITFrLocDesc", "INITDate", "INITState", "AckUser",
				"MakeUser", "PurPriceAmt", "SalePriceAmt", "DiffAmt",
				"INITRemarks", "INITStateCode"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "INITRowId",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "转移单号RowId",
					dataIndex : 'INITRowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "转移单号",
					dataIndex : 'INITNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '请求单号',
					dataIndex : 'INRQNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "请求部门",
					dataIndex : 'INITToLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "供给部门",
					dataIndex : 'INITFrLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "转移日期",
					dataIndex : 'INITDate',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "单据状态",
					dataIndex : 'INITState',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '出库人员',
					dataIndex : 'AckUser',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "制单人",
					dataIndex : 'MakeUser',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "批价金额",
					dataIndex : 'PurPriceAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "售价金额",
					dataIndex : 'SalePriceAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "进销差价",
					dataIndex : 'DiffAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "备注",
					dataIndex : 'INITRemarks',
					width : 100,
					align : 'left',
					sortable : true
				}]);
		MasterCm.defaultSortable = true;
		var MasterGrid = new Ext.grid.GridPanel({
					region : 'center',
					title : '',
					height : 170,
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true
				});

		// 添加表格单击行事件
		MasterGrid.on('rowclick', function(grid, rowIndex, e) {
			var InIt = MasterStore.getAt(rowIndex).get("INITRowId");
			DetailStore.proxy = new Ext.data.HttpProxy({
				url : DictUrl
						+ 'stocktransferaction.csp?actiontype=GetTransferDetail&InIt='
						+ InIt
			});
			DetailStore.load();
		});

		// 转移明细
		// 访问路径
		var DetailUrl = "";
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		// 药品代码 药品名称 批次/效期 生产厂商 批次库存 转移数量 转移单位 单价 请求数量 基本单位 转移单位进价 供应方库存 请求方库存
		// 批次售价
		var fields = ["INITIRowId", "IncRowId", "IncCode", "IncName",
				"INITIINCLBDR", "INITIINCLB", "InItmPhmnfDr", "INITIINCLBQty",
				"INITIQty", "INITICTUOMDR", "DHCITISalePrice", "INRQIQty",
				"SupplyStockQty", "RequrstStockQty", "INCSB", "DHCITIPurPrice",
				"Sepc", "GenericName", "PHCForm", "DHCITISalePriceAMT",
				"INCICTUOMDR", "INCICTUOMPurchDR", "ReailPrice", "Fact",
				"UomTH", "Uom", "DirtyQty", "UseQty", "INITICTUOMDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "INITIRowId",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "转移细项RowId",
					dataIndex : 'INITIRowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "药品编号RowId",
					dataIndex : 'IncRowId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '药品代码',
					dataIndex : 'IncCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '药品名称',
					dataIndex : 'IncName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "批次/效期RowId",
					dataIndex : 'INITIINCLBDR',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "批次/效期",
					dataIndex : 'INITIINCLB',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "生产厂商",
					dataIndex : 'InItmPhmnfDr',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "批次库存",
					dataIndex : 'INITIINCLBQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "转移数量",
					dataIndex : 'INITIQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "转移单位",
					dataIndex : 'INITICTUOMDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "进价",
					dataIndex : 'ReailPrice',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "售价",
					dataIndex : 'DHCITISalePrice',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "请求数量",
					dataIndex : 'INRQIQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "货位码",
					dataIndex : 'INCSB',
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
					header : "占用数量",
					dataIndex : 'DirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "可用数量",
					dataIndex : 'UseQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "批次售价",
					dataIndex : 'DHCITIPurPrice',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'Sepc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "通用名",
					dataIndex : 'GenericName',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "剂型",
					dataIndex : 'PHCForm',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "售价金额",
					dataIndex : 'DHCITISalePriceAMT',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "转换率",
					dataIndex : 'Fact',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "替换单位",
					dataIndex : 'UomTH',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "单位",
					dataIndex : 'Uom',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}]);

		var DetailGrid = new Ext.grid.GridPanel({
					region : 'south',
					title : '',
					height : 200,
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true
				});

		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px;',
			tbar : [SearchBT, '-', ClearBT, '-', CheckBT],
			items : [{
						autoHeight : true,
						items : [{
									xtype : 'fieldset',
									title : '查询条件',
									autoHeight : true,
									items : [{
												layout : 'column',
												items : [{
															columnWidth : .25,
															layout : 'form',
															items : [RequestPhaLoc]
														}, {
															columnWidth : .25,
															layout : 'form',
															items : [SupplyPhaLoc]
														}, {
															columnWidth : .25,
															layout : 'form',
															items : [StartDate]
														}, {
															columnWidth : .25,
															layout : 'form',
															items : [EndDate]
														}]
											}]
								}]
					}]
		});

		// 属性页签
		var tabPanel = new Ext.Panel({
					activeTab : 0,
					region : 'north',
					height : 120,
					items : [HisListTab]
				});

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [tabPanel, MasterGrid, DetailGrid],
					renderTo : 'mainPanel'
				});
	}

})