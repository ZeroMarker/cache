
// /描述: 付款单制单
// /编写者：gwj
// /编写日期: 2012.09.20

var payRwoId="";
var URL="dhcst.dhcpayaction.CSP"
// /是否需要审批参数
var ApprovalFlag
var gParam

var payN0Field = new Ext.form.TextField({
	id:'payN0Field',
	fieldLabel:'付款单号',
	allowBlank:true,
	width:120,
	listWidth:120,
	emptyText:'付款单号...',
	anchor:'90%',
	selectOnFocus:true
});		

		// 根据输入值过滤
	function refill(store, filter,type) {
		if(type=="PhaLoc"){
			store.reload({
				params : {
					start : 0,
					limit : 20,
					locDesc:filter
					}
				});
		}
		if(type=="Vendor"){
			store.reload({
				params : {
					start : 0,
					limit : 20,
					filter:filter
				}
			});
		}
	}
	// 入库科室
	var PhaLoc = new Ext.form.ComboBox({
		fieldLabel : '入库科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width : 120,
		store : GetGroupDeptStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		emptyText : '入库科室...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		listeners : {
			'beforequery' : function(e) {
				refill(GetGroupDeptStore, Ext.getCmp('PhaLoc')
					.getRawValue(),"PhaLoc");
			}
		}
	});
	// 登录设置默认值
	SetLogInDept(GetGroupDeptStore, "PhaLoc");
	//取是否需要审批参数
	GetParam();
	
	function GetParam(){
		var ssacode="DHCSTPAY"
		var ssapcode="APPROVALFLAG"
		var pftype="D"
		var url='dhcst.dhcpayaction.CSP?actiontype=GetParam&SSACode='+ssacode+'&SSAPCode='+ssapcode+'&PFType='+pftype;
		Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '更新中...',
						success : function(result, request) {
							var s=result.responseText;
							s=s.replace(/\r/g,"")
							s=s.replace(/\n/g,"")

							gParam=s.split('^');
							
						//scope : this
					}
					
					
		
		});

	//return;
	}
	
	// 供货厂商
	var Vendor = new Ext.form.ComboBox({
				fieldLabel : '供货厂商',
				id : 'Vendor',
				name : 'Vendor',
				anchor : '90%',
				width : 120,
				store : APCVendorStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				emptyText : '供货厂商...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				valueNotFoundText : '',
				enableKeyEvents : true,
				listeners : {
					'beforequery' : function(e) {
						refill(APCVendorStore, Ext.getCmp('Vendor')
										.getRawValue(),"Vendor");
					}
				}
			});
			
		// 起始日期
		var StartDate = new Ext.form.DateField({
					fieldLabel : '起始日期',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 120,
					value : new Date().add(Date.DAY, - 30)
				});
		// 截止日期
		var EndDate = new Ext.form.DateField({
					fieldLabel : '截止日期',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 120,
					value : new Date()
				});
	var ack1lag = new Ext.form.Checkbox({
			fieldLabel : '采购确认',
			id : 'ack1lag',
			name : 'ack1lag',
			anchor : '90%',
			//width : 80,
			checked : false
	});
	var ack2lag = new Ext.form.Checkbox({
			fieldLabel : '会计确认',
			id : 'ack2lag',
			name : 'ack2lag',
			anchor : '90%',
			//width : 80,
			checked : false
	});
	var PoisonFlag = new Ext.form.Checkbox({
			fieldLabel : '毒麻标志',
			id : 'PoisonFlag',
			name : 'PoisonFlag',
			anchor : '90%',
			//width : 80,
			checked : false
	});
	var CreatUsr =new Ext.form.NumberField({
				fieldLabel : '制单人',
				id : 'CreatUsr',
				name : 'CreatUsr',
				anchor : '90%',
				width : 120
	});
	var CreatDate =new Ext.form.NumberField({
				fieldLabel : '制单日期',
				id : 'CreatDate',
				name : 'CreatDate',
				anchor : '90%',
				width : 120
	});
	var Ack1Usr =new Ext.form.NumberField({
				fieldLabel : '采购确认人',
				id : 'Ack1Usr',
				name : 'Ack1Usr',
				anchor : '90%',
				width : 120
	});
	var CreatTim =new Ext.form.NumberField({
				fieldLabel : '制单时间',
				id : 'CreatTim',
				name : 'CreatTim',
				anchor : '90%',
				width : 120
	});
	var Ack2Usr =new Ext.form.NumberField({
				fieldLabel : '会计确认人',
				id : 'Ack2Usr',
				name : 'Ack2Usr',
				anchor : '90%',
				width : 120
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
	// 完成按钮
		var CompleteBT = new Ext.Toolbar.Button({
					id : "CompleteBT",
					text : '完成',
					tooltip : '点击完成',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						Complete();
					}
				});

		// 取消完成按钮
		var CancleCompleteBT = new Ext.Toolbar.Button({
					id : "CancleCompleteBT",
					text : '取消完成',
					tooltip : '点击取消完成',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						CancleComplete();
					}
				});
	// 生成付款单按钮
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '生成付款单',
					tooltip : '点击生成新单',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						Save();
					}
				});

	// 加入已有付款单按钮
	var UpdateBT = new Ext.Toolbar.Button({
				id : "UpdateBT",
				text : '加入已有付款单',
				tooltip : '点击加入已有付款单',
				width : 70,
				Height : 30,
				iconCls : 'page_gear',
				handler : function() {
					Update();
				}
	});
		/**
		 * 查询方法
		 */
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择采购部门!");
			return;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		
		var CmpFlag = "Y";
		ApprovalFlag=gparam[0];
		//科室id^供应商id^开始日期^截止日期^审核标志^发票标志
		var ListParam=phaLoc+'^'+vendor+'^'+startDate+'^'+endDate+'^'+ApprovalFlag+'^0';
		var Page=GridPagingToolbar.pageSize;
		MasterStore.load({params:{start:0, limit:Page,strParam:ListParam}});
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

  /**
		 * 完成付款单
		 */
		function Complete() {
			
			var payNo = Ext.getCmp("payN0Field").getValue();			
			if (payNo == null || payNo.length <= 0) {
				Msg.info("warning", "没有需要完成的付款单!");
				return;
			}
			if (payRwoId== null || payRwoId.length <= 0) {
				Msg.info("warning", "没有需要完成的付款单!");
				return;
			}
			var url = URL+ "?actiontype=SetComp&payid="+ payRwoId ;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '更新中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 完成单据
								Msg.info("success", "成功!");								
										
			
							} else {
								var Ret=jsonData.info;
								if(Ret==-1){
									Msg.info("error", "操作失败,付款单Id为空或付款单不存在!");
								}else if(Ret==-2){
									Msg.info("error", "付款单已经完成!");
								}else {
									Msg.info("error", "操作失败!");
								}
								
							}
						},
						scope : this
					});
		}

		/**
		 * 取消完成入库单
		 */
		function CancleComplete() {
			
			var payNo = Ext.getCmp("payN0Field").getValue();			
			if (payNo == null || payNo.length <= 0) {
				Msg.info("warning", "没有需要完成的付款单!");
				return;
			}
			if (payRwoId== null || payRwoId.length <= 0) {
				Msg.info("warning", "没有需要完成的付款单!");
				return;
			}
			var url = URL+ "?actiontype=CnlComp&payid="+ payRwoId ;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '更新中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 完成单据
								Msg.info("success", "成功!");								
										
			
							} else {
								var Ret=jsonData.info;
								if(Ret==-1){
									Msg.info("error", "操作失败,付款单Id为空或付款单不存在!");
								}else if(Ret==-2){
									Msg.info("error", "付款单已经完成!");
								}else {
									Msg.info("error", "操作失败!");
								}
								
							}
						},
						scope : this
					});
		}
	
	/*生成新的付款单*/
	function Save() {
			
			var payNo = Ext.getCmp("payN0Field").getValue();		
			var VenId = Ext.getCmp("Vendor").getValue();	
			var LocId = Ext.getCmp("PhaLoc").getValue();
			var CreateUser = gUserId;
			var PonFlag = (Ext.getCmp("PoisonFlag").getValue()==true?'Y':'N');
			var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PonFlag ;
			var url = URL+ "?actiontype=save&PayNo="+ payNo +"&MainInfo=" + MainInfo+"&ListDetail="+ListDetail;
			var ListDetail="";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				if(sm.isSelected(rowIndex)==true){
					var PayiId=rowData.get("PayiId");
					var IncDesc=rowData.get("IncDesc");
					var Ingri=rowData.get("Ingri");
					var IncId = rowData.get("IncId");
					var RpAmt = rowData.get("RpAmt");
					var DataType = rowData.get("Type");
					var str = PayiId + "^" + IncDesc + "^"	+ Ingri + "^" + IncId + "^" +RpAmt + "^^^^"+ DataType
					
					if(ListDetail==""){
						ListDetail=str;
					}
					else{
						ListDetail=ListDetail+","+str;
					}
				}
			}
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '更新中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 完成单据
								Msg.info("success", "成功!");								
								// 刷新界面
								var payRwoId = jsonData.info;
								
								// 显示付款单数据
								
								Querypay(payRwoId);		
			
							} else {
								var Ret=jsonData.info;
								if(ret==-99){
									Msg.info("error", "加锁失败,不能保存!");
								}else if(ret==-4){
									Msg.info("error", "保存付款单主表信息失败!");
								}else if(ret==-5){
									Msg.info("error", "保存付款单明细失败!");
								}else {
									Msg.info("error", "部分明细保存不成功："+ret);
								}
								
							}
						},
						scope : this
					});
		}
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					width : 70,
					height : 30,
					iconCls : 'page_refresh',
					handler : function() {
						clearData();
					}
				});
		/**
		 * 清空方法
		 */
		function clearData() {
			Ext.getCmp("PhaLoc").setValue("");
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("payN0Field").setValue("");
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		
		
		function rendorPoFlag(value){
	        return value=='Y'? '是': '否';
	    }
	    function rendorCmpFlag(value){
	        return value=='Y'? '完成': '未完成';
	    }
		
	var sm = new Ext.grid.CheckboxSelectionModel(); 
		// 访问路径
		var MasterUrl = URL	+ '?actiontype=query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["RowId", "IngrNo", "RpAmt", "ApprvFlag", "CreateUser", "CreateDate","AuditUser", "AuditDate","PayedFlag", "type"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "RowId",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([sm, {
					header : "RowId",
					dataIndex : 'RowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "单号",
					dataIndex : 'IngrNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "审批标志",
					dataIndex : 'ApprvFlag',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "制单人",
					dataIndex : 'CreateUser',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "制单日期",
					dataIndex : 'CreateDate',
					width : 100,
					align : 'left',
					sortable : true,
					renderer:rendorPoFlag
				}, {
					header : "审核人",
					dataIndex : 'AuditUser',
					width : 100,
					align : 'left',
					sortable : true,
					renderer:rendorCmpFlag
				}, {
					header : "审核日期",
					dataIndex : 'AuditDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "结清标志",
					dataIndex : 'PayedFlag',
					width : 100,
					align : 'left',
					sortable : true,
					renderer:rendorCmpFlag
				}, {
					header : "类型",
					dataIndex : 'type',
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
					title : '',
					height : 170,
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					bbar:[GridPagingToolbar]
				});



		// 入库单明细
		var sm1 = new Ext.grid.CheckboxSelectionModel();
		// 访问路径
		var DetailUrl =  DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryDetail';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"IncId", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc","Type","PayiId"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "RowId",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([sm1, {
					header : "Ingri",
					dataIndex : 'Ingri',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true,
					hideable : false
				}, {
					header : "代码",
					dataIndex : 'IncCode',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : '名称',
					dataIndex : 'IncDesc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : 'IncId',
					dataIndex : 'IncId',
					width : 150,
					align : 'left',
					sortable : true,
					hideable : false
				}, {
					header : "生产厂商",
					dataIndex : 'Manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "批号",
					dataIndex : 'BatchNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "有效期",
					dataIndex : 'ExpDate',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : '单位',
					dataIndex : 'IngrUom',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : "数量",
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "进价",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "售价",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "发票号",
					dataIndex : 'InvNo',
					width : 80,
					align : 'left',
					sortable : true
					
				}, {
					header : "发票日期",
					dataIndex : 'InvDate',
					width : 90,
					align : 'center',
					sortable : true
					
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "售价金额",
					dataIndex : 'SpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "进销差价",
					dataIndex : 'Margin',
					width : 80,
					align : 'right',
					
					sortable : true
				}]);

		var DetailGrid = new Ext.grid.GridPanel({
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
			tbar : [SearchBT, '-', ClearBT, '-', CompleteBT,'-',CancleCompleteBT,'-',SaveBT,'-',UpdateBT],
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 220, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
               	//	"margin-bottom": "10px"
            	//},
            	items: [PhaLoc,payN0Field,ack1lag]
				
			},{ 				
				columnWidth: 0.2,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [Vendor,CreatUsr,Ack1Usr]
				
			},{ 				
				columnWidth: 0.2,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [StartDate,CreatDate,ack2lag]
				
			},{ 				
				columnWidth: 0.2,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [EndDate,CreatTim,Ack2Usr]
				
			},{ 				
				columnWidth: 0.15,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [PoisonFlag]
				
			}]
			
		});

		
				
	
//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var gUserId = session['LOGON.USERID'];	
	
	// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: 130, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: '入库单',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '入库单明细',
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
});
//===========模块主页面=============================================