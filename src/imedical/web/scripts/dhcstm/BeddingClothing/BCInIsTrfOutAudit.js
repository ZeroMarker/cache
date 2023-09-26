// /名称: 转移出库审核
// /描述: 转移出库审核
// /编写者：zhangdongmei
// /编写日期: 2012.07.24

//保存参数值的object
var BCInIsTrfOutParamObj = GetAppPropValue('DHCSTBCM');

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '请求部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					emptyText:'请求部门',
					anchor:'90%',
					width : 120,
					defaultLoc:{}    //默认值为空
				});

		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					groupId:gGroupId
				});

		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '起始日期',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : AuditStDate()
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '截止日期',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
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
						Query();
					}
				});
		/**
		 * 查询方法
		 */
		function Query() {
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "请选择供应部门!");
				return;
			}
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
			if(startDate!=""){
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			if(endDate!=""){
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var statue = "11,30";
			var UserScgPar = supplyphaLoc + '%' + userId;
			var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^Y'
				+'^'+statue+'^^^^'
				+'^^^^'+UserScgPar;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			MasterStore.removeAll();
			MasterStore.load({
				params:{start:0, limit:Page},
				callback:function(r,options,success){
					if(!success){
						Msg.info("error","查询有误,请查看日志!");
					}else if (r.length>0){
						MasterGrid.getSelectionModel().selectFirstRow();
					}
				}
			});
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
			SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			//Ext.getCmp("SupplyPhaLoc").setValue("");
			Ext.getCmp("StartDate").setValue(AuditStDate());
			Ext.getCmp("EndDate").setValue(new Date());
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		// 审批按钮
		var CheckBT = new Ext.Toolbar.Button({
					id : "CheckBT",
					text : '审核通过',
					tooltip : '点击审核通过',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						Audit();
					}
				});

		/**
		 * 审批转移单出库
		 */
		function Audit() {
			// 判断转移单是否已审核
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "请选择审核的转移单!");
				return;
			}
			var INITState = rowData.get("status");
			if (INITState != "11") {
				Msg.info("warning", "转移单不是待审核状态，请核实!");
				return;
			}
			var Init = rowData.get("init");
			
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Audit";
			Ext.Ajax.request({
						url : url,
						params : {Rowid:Init,User:userId,BCFlag:"Y"},
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", "出库审核成功!");
								Query();
								//根据参数设置, 打印单据
								if(gParam[4]=='Y'){
									PrintInIsTrf(Init);
								}
							} else {
								var Ret=jsonData.info;
								if(Ret==-100){
									Msg.info("error", "出库单不是待审核状态!");
								}else if(Ret==-99){
									Msg.info("error", "加锁失败!");
								}else if(Ret==-1){
									Msg.info("error", "更新出库单状态失败!");
								}else if(Ret==-3){
									Msg.info("error", "处理库存失败!");
								}else if(Ret==-4){
									Msg.info("error", "插入台帐失败!");
								}else if(Ret==-5){
									Msg.info("error", "更新子表状态失败!");
								}else if(Ret==-6){
									Msg.info("error", "处理占用数量失败!");
								}else if(Ret==-7){
									Msg.info("error", "自动接收出库单失败，请手动接收!");
								}else{
									Msg.info("error", "审核失败:"+Ret);
								}
							}
						},
						scope : this
					});
		}

		// 出库审核拒绝按钮
		var AuditNoBT = new Ext.Toolbar.Button({
					id : "AuditNoBT",
					text : '审核不通过',
					tooltip : '点击审核不通过',
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					handler : function() {
						AuditNo();
					}
				});
		/**
		 * 出库单审核不通过
		*/
		function AuditNo() {
			// 判断转移单是否已审核
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "请选审核不通过的转移单!");
				return;
			}
			var INITState = rowData.get("status");
			if (INITState != "11" && INITState != "30") {
				Msg.info("warning", "转移单不是待审核状态，请核实!");
				return;
			}
			var Init = rowData.get("init");
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=AuditNo&Rowid="
					+ Init + "&User=" + userId;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 审核单据
								Msg.info("success", "成功!");
								Query();
							} else {
								var Ret=jsonData.info;
								if(Ret==-100){
									Msg.info("error", "出库单不是待审核状态!");
								}else if(Ret==-99){
									Msg.info("error", "加锁失败!");
								}else if(Ret==-1){
									Msg.info("error", "更新出库单状态失败!");
								}else if(Ret==-2){
									Msg.info("error", "更新出库单明细状态失败!");
								}else if(Ret==-3){
									Msg.info("error", "更新出库单完成状态失败!");
								}else{
									Msg.info("error", "失败:"+Ret);
								}
							}
						},
						scope : this
					});
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
		
		// 访问路径
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode"];
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
					reader : reader
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
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg:"没有记录"
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
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc',Parref:InIt}});
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
				"pp", "spec", "gene", "form","newSp",
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
				}, /*{
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
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg:"没有记录"
		});
		var DetailGrid = new Ext.grid.GridPanel({
			region: 'south',
			split: true,
			height: gGridHeight,
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
			title:"被服出库审核",
			tbar : [SearchBT, '-', ClearBT, '-', CheckBT,'-',AuditNoBT,'-',PrintBT],
			items:[{
				xtype : 'fieldset',
				title : '查询条件',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults:{border:false,columnWidth: 0.25,xtype:'fieldset'},
				items : [{
						items: [SupplyPhaLoc]
					},{
						items: [RequestPhaLoc]
					},{ 
						items: [StartDate]
					},{
						items: [EndDate]					
				}]
			}]			
		});

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,MasterGrid,DetailGrid],
			renderTo : 'mainPanel'
		});
		// 登录设置默认值
		SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");		
		Query();
	}

})