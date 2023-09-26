// /名称: 转移入库审核
// /描述: 转移入库审核
// /编写者：zhangdongmei
// /编写日期: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
		// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '请求部门',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',					
				anchor: '90%',
				emptyText:'请求部门',
				groupId:gGroupId
				//defaultLoc:''
			});

	// 供给部门
	/*var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '供给部门',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',	
				emptyText:'供给部门',
				anchor : '90%',
				//groupId:gGroupId
				defaultLoc:''
			});*/
	var SupplyPhaLoc = new Ext.ux.ComboBox({
		id:'SupplyPhaLoc',
		fieldLabel:'供给部门',
		anchor:'90%',
		store:frLocListStore,
		displayField:'Description',
		valueField:'RowId',
		listWidth:210,
		emptyText:'供给部门...',
		params:{LocId:'RequestPhaLoc'},
		filterName : 'FilterDesc'
	});
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				
				width : 120,
				value : AuditStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				
				width : 120,
				value : new Date()
			});
    var HVBarCodeField = new Ext.form.TextField({
	              fieldLabel : '高值条码',
	              id : 'HVBarCodeField',
	              name : 'HVBarCodeField',
	              anchor : '90%',
	              listeners : {
	              specialkey : function(field, e) {
			             if (e.getKey() == Ext.EventObject.ENTER) {
				             CheckHVBarCodeBT.handler()
			             }
		             }
             	}
      });
     // 高值条码验收
	var CheckHVBarCodeBT = new Ext.Toolbar.Button({
				id : "CheckHVBarCodeBT",
				text : '高值条码验收',
				tooltip : '点击接收',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					CheckHVBarCode();
				}
			}); 
	function CheckHVBarCode() {
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "请选择要验收的转移单!");
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning", "转移单不是待接收状态，请核实!");
			return;
		}
		var Init = rowData.get("init");
		var HvBarcode=Ext.getCmp("HVBarCodeField").getValue()
		if (HvBarcode=="") {
			Msg.info("warning", "高值条码不能为空!");
			return;
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CheckHVBarCode&Rowid="
				+ Init + "&User=" + userId+ "&HvBarcode=" + HvBarcode;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							//Msg.info("success", "高值条码验收成功!");
							var Data = tkMakeServerCall("web.DHCSTM.DHCINIsTrf","GetDataByBarcode",HvBarcode);
							Msg.info("success", "高值条码验收成功!物资信息为: "+Data);
							DetailStore.setBaseParam('Parref',Init)
		                    DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		                    
						} else {
							var Ret=jsonData.info;
							if(Ret==-1){
								Msg.info("error", "没有出库单!");
							}else if(Ret==-2){
								Msg.info("error", "没有验收人!");
							}else if(Ret==-5 || Ret==-6){
								Msg.info("error", "高值条码未在此出库单中!");
							}else if(Ret==-4){
								Msg.info("error", "高值条码未登记!");
							}else if(Ret==-7){
								Msg.info("error", "高值条码验收失败!");
							}else{
								Msg.info("error", "高值条码验收失败:"+Ret);
							}
						}
					},
					scope : this
				});
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
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var statue = "21";
		var UserScgPar = requestphaLoc + '%' + userId;
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^Y'
			+'^'+statue+'^^^^'
			+'^^^^'+UserScgPar;
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
				text : '接收',
				tooltip : '点击接收',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					Audit();
				}
			});

	/**
	 * 审批转移单入库
	 */
	function Audit() {
		// 判断转移单是否已审核
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "请选择要接收的转移单!");
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning", "转移单不是待接收状态，请核实!");
			return;
		}
		var Init = rowData.get("init");
		
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditIn&Rowid="
				+ Init + "&User=" + userId;
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							Msg.info("success", "接收成功!");
							Query();
							//根据参数设置自动打印
							if(gParam[5]=='Y'){
								PrintInIsTrf(Init);
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", "出库单不是待接收状态!");
							}else if(Ret==-99){
								Msg.info("error", "加锁失败!");
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", "更新出库单状态失败!");
							}else if(Ret==-3){
								Msg.info("error", "处理库存失败!");
							}else if(Ret==-4){
								Msg.info("error", "插入台帐失败!");
							}else{
								Msg.info("error", "接收失败:"+Ret);
							}
						}
						loadMask.hide();
					},
					scope : this
				});
	}

	// 入库审核拒绝按钮
	var AuditNoBT = new Ext.Toolbar.Button({
				id : "AuditNoBT",
				text : '拒绝接收',
				tooltip : '点击拒绝接收',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					AuditNo();
				}
			});
	/**
	 * 入库单审核不通过
	*/
	function AuditNo() {
		// 判断转移单是否已审核
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "请选择需要拒绝的转移单!");
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning", "转移单不是待接收状态，请核实!");
			return;
		}
		var Init = rowData.get("init");
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditInNo&Rowid="
				+ Init + "&User=" + userId;
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
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
								Msg.info("error", "出库单不是待接收状态!");
							}else if(Ret==-101){
								Msg.info("error", "出库单已经超过一个月的期限不能拒绝接受!");
							}else if(Ret==-102){
								Msg.info("error", "出库科室已经生成月报,不可拒绝接收!");
							}else if(Ret==-99){
								Msg.info("error", "加锁失败!");
							}else if(Ret==-1){
								Msg.info("error", "更新出库单状态失败!");
							}else if(Ret==-3){
								Msg.info("error", "恢复库存，处理台帐失败!");
							}else if(Ret==-4){
								Msg.info("error", "恢复占用数量失败!");
							}else if(Ret==-5){
								Msg.info("error", "更新出库明细状态失败!");
							}else{
								Msg.info("error", "失败:"+Ret);
							}
						}
						loadMask.hide();
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
				reader : reader,
				listeners : {
					load : function(store,records,options){
						if (records.length > 0){
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
		DetailStore.setBaseParam('Parref',InIt)
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
	});

	// 转移明细
	// 访问路径
	var DetailUrl =  DictUrl
				+ 'dhcinistrfaction.csp?actiontype=QueryDetail';;;
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
			"pp", "spec", "gene", "form","newSp","HVBarCode","checkflag",
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
				header : "验收状态",
				dataIndex : 'checkflag',
				width : 60,
				align : 'center',
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
		displayInfo:true
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
				loadMask : true,
					viewConfig:{
					getRowClass : function(record,rowIndex,rowParams,store){ 
						var checkflag=record.get("checkflag");
						
							if(checkflag=="Y"){   //该情况不能出库 用红色表示
								return 'classGreen';
							}
							
					}
				}
			});
	
	var HisListTab = new Ext.ux.FormPanel({
		title : '转移入库接收',
		labelWidth: 60,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT,'-',AuditNoBT,'-',CheckHVBarCodeBT],
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			style:'padding:5px 0px 0px 5px',
			defaults: {xtype: 'fieldset', border:false},    // Default config options for child items
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.25,
            	items: [SupplyPhaLoc,HVBarCodeField]
			},{
				columnWidth: 0.25,
            	items: [RequestPhaLoc]
			},{ 				
				columnWidth: 0.25,
            	items: [StartDate]
			},{
				columnWidth: 0.25,
            	items: [EndDate]
			}]
		}]			
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, DetailGrid],
				renderTo : 'mainPanel'
			});
	
	Query();
})