// /名称: 转移入库单据查询		2013-07-17 根据转移出库查询修改
// /编写者：zhangdongmei
// /编写日期: 2012.07.24

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '接收部门',
					id : 'RequestPhaLoc',
					anchor:'90%',
					emptyText : '接收部门...',
					groupId:gGroupId,
					listeners:{
						'select':function(cb)
						{
							var requestLoc=cb.getValue();
							var provLoc=Ext.getCmp('SupplyPhaLoc').getValue();
							Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);
						}
					}
		});
		
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'SupplyPhaLoc',
					anchor:'90%',
					emptyText : '供给部门...',
					defaultLoc:{},
					listeners:{
						'select':function(cb)
						{
							var provLoc=cb.getValue();
							var requestLoc=Ext.getCmp('RequestPhaLoc').getValue();
							Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);
						}
					}
				});


		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '起始日期',
					id : 'StartDate',
					anchor : '90%',
					value : DefaultStDate()
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '截止日期',
					id : 'EndDate',
					anchor : '90%',
					value : DefaultEdDate()
				});
		
		var FindTypeData=[['全部','1'],['已确认','2'],['未确认','3']];
		var FindTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : FindTypeData
		});
		var ConfirmFlag = new Ext.form.ComboBox({
			store: FindTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'ConfirmFlag',
			fieldLabel : '是否确认',
			triggerAction:'all',
			valueField : 'typeid'
		});
		Ext.getCmp("ConfirmFlag").setValue("1");
		
		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', '未完成'], ['11', '已完成'],['20', '出库审核不通过'],['21', '出库审核通过'],['30', '拒绝接收'],['31', '已接收']]
		});
		
		var Status = new Ext.form.ComboBox({
			fieldLabel : '转移单状态',
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 100,
			store : StatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
		
		// 物资类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%'
		}); 
		// 物资名称
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});

			/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(InciDesc);
			gInciRowId=inciDr;
		}
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						Query();
					}
				});
		/**
		 * 查询方法
		 */
		function Query() {
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", "请选择请求部门!");
				return;
			}
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
			if(startDate!=""){
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			if(endDate!=""){
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var statue =  Ext.getCmp("Status").getValue();
			var ConfirmFlag = Ext.getCmp("ConfirmFlag").getValue();
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var inciDesc = Ext.getCmp("InciDesc").getValue();
			if (inciDesc == "" || inciDesc == null){
				gInciRowId="";
			}
			if(gInciRowId!=""&gInciRowId!=null){
				inciDesc="";
			}
			var inci=gInciRowId;
			var UserScgPar = requestphaLoc + '%' + userId;
			var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'
				+'^'+statue+'^^^'+stkgrpid+"^"+inci
				+"^"+ConfirmFlag+"^"+inciDesc+'^^'+UserScgPar;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			DetailGrid.store.removeAll();
			MasterStore.removeAll();
			MasterStore.load({params:{start:0, limit:Page}});
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
			SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			//Ext.getCmp("SupplyPhaLoc").setValue("");
			Ext.getCmp("Status").setValue("");
			Ext.getCmp("StkGrpType").setValue("");
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("ConfirmFlag").setValue("1");
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}
		
		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					text : '打印',
					tooltip : '点击打印',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", "请选择需要打印的转移单!");
							return;
						}
						var init = rowData.get("init");
						PrintInIsTrf(init);
					}
				});
		
		// 库房确认按钮
		var ConfirmBT = new Ext.Toolbar.Button({
			text : '库房确认',
			tooltip : '点击确认',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				Confirm();
			}
		});
		/**
		 * 库房确认方法
		 */
		function Confirm() {
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "请选择确认的转移单!");
				return;
			}
			var ConfirmFlag = rowData.get("confirmFlag");
			if (ConfirmFlag == "Y") {
				Msg.info("warning", "转移单已确认!");
				return;
			}
			var Init = rowData.get("init");
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Confirm&Rowid="+ Init;
			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "库房确认成功!");
						Query();
					} else {
						var Ret=jsonData.info;
						if(Ret<0){
							Msg.info("error", "确认失败:"+Ret);
						}
					}
				},
				scope : this
			});
		}
		
		// 访问路径
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","inAckDate","inAckTime","inAckUser","confirmFlag"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "init",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					listeners : {
						load : function(store,records,options){
							if (records.length>0){
								MasterGrid.getSelectionModel().selectFirstRow();
							}
						}
					}
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "RowId",
					dataIndex : 'init',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "转移单号",
					dataIndex : 'initNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '请求单号',
					dataIndex : 'reqNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "请求部门",
					dataIndex : 'toLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "供给部门",
					dataIndex : 'frLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "转移日期",
					dataIndex : 'dd',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "单据状态",
					dataIndex : 'StatusCode',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "制单人",
					dataIndex : 'userName',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "入库确认标记",
					dataIndex : 'confirmFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "入库确认日期",
					dataIndex : 'inAckDate',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "入库确认时间",
					dataIndex : 'inAckTime',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "入库确认人",
					dataIndex : 'inAckUser',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "售价金额",
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "进销差价",
					dataIndex : 'MarginAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "备注",
					dataIndex : 'Remark',
					width : 100,
					align : 'left',
					sortable : true
				}]);
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true
		});
		var MasterGrid = new Ext.grid.GridPanel({
					region: 'center',
					title: '出库单',
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					bbar:GridPagingToolbar
				});

		// 添加表格单击行事件
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			DetailStore.setBaseParam('Parref',InIt);
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		});

		// 转移明细
		// 访问路径
		var DetailUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec", "gene", "form","newSp","HVBarCode",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
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
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "物资Id",
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '物资名称',
					dataIndex : 'inciDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : '高值条码',
					dataIndex : 'HVBarCode',
					width : 120,
					align : 'left'
				}, {
					header : "批次Id",
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "批次/效期",
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "生产厂商",
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "批次库存",
					dataIndex : 'inclbQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "转移数量",
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "转移单位",
					dataIndex : 'TrUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "进价",
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "售价",
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "请求数量",
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "货位码",
					dataIndex : 'stkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "请求方库存",
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "占用数量",
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "可用数量",
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "批次售价",
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				},/*{
					header : "通用名",
					dataIndex : 'gene',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "剂型",
					dataIndex : 'form',
					width : 100,
					align : 'left',
					sortable : true
				},*/ {
					header : "售价金额",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}]);
       var GridDetailPagingToolbar = new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true
		});
		var DetailGrid = new Ext.grid.GridPanel({
					region: 'south',
					split: true,
					height: gGridHeight,
					minSize: 200,
					maxSize: 350,
					collapsible: true,
					title: '出库单明细',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					bbar:GridDetailPagingToolbar,
					loadMask : true
				});

		var HisListTab = new Ext.ux.FormPanel({
			title:"转移入库查询",
			tbar : [SearchBT, '-', ClearBT, '-', PrintBT, '-', ConfirmBT],
			items:[{
				xtype:'fieldset',
				layout:'column',
				defaults:{layout:'form'},
				title:'查询条件',
				items : [{ 				
					columnWidth: 0.3,
	            	items: [RequestPhaLoc,Status]
				},{ 				
					columnWidth: 0.23,
	            	items: [SupplyPhaLoc,StkGrpType]
				},{ 				
					columnWidth: 0.23,
	            	items: [StartDate,InciDesc]
				},{ 				
					columnWidth: 0.23,
	            	items: [EndDate,ConfirmFlag]
				}]
			}]
		});

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [HisListTab, MasterGrid, DetailGrid],
					renderTo : 'mainPanel'
				});
	}

})