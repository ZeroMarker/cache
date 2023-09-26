// /名称: 采购计划审批
// /描述: 采购计划审批
// /编写者：zhangdongmei
// /编写日期: 2012.07.30
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 采购科室
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '采购部门',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '采购部门...',
				groupId:session['LOGON.GROUPID']
			});

var PurNo = new Ext.form.TextField({
			fieldLabel : '采购单号',
			id : 'PurNo',
			name : 'PurNo',
			anchor : '90%',
			width : 120
		});

	// 供货厂商
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '供应商',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			emptyText : '供应商...'
	});
		
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
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
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择采购部门!");
			return;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var purno = Ext.getCmp("PurNo").getValue();
		var CmpFlag = "Y";
		var PlanAuditFlag = (Ext.getCmp("PlanAuditFlag").getValue()==true?'Y':'N');
		//科室id^开始日期^截止日期^计划单号^类组id^供应商id^药品id^完成标志^审核标志
		var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+purno+'^^'+vendor+'^^'+CmpFlag+'^'+PlanAuditFlag;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('strParam',ListParam);
		MasterStore.removeAll();
		MasterStore.load({params:{start:0, limit:Page}});
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		   MasterStore.on('load',function(){
			if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
	}

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				text : '清屏',
				tooltip : '点击清屏',
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("PurNo").setValue("");
		Ext.getCmp("PlanAuditFlag").setValue("");
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	// 审批
	var PlanAuditFlag = new Ext.form.Checkbox({
		fieldLabel : '已审批',
		id : 'PlanAuditFlag',
		name : 'PlanAuditFlag',
		anchor : '90%',
		width : 120,
		checked : false
	});
	// 审批按钮
	var CheckBT = new Ext.Toolbar.Button({
				id : "CheckBT",
				text : '审批',
				tooltip : '点击审批',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					Audit();
				}
			});

	/**
	 * 审批采购计划单
	 */
	function Audit() {
		
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择要审批的采购单!");
			return;
		}
		
		var PurId = rowData.get("RowId");
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=Audit&rowid="
				+ PurId + "&userId=" + userId;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							Msg.info("success", "审批成功!");
							Query();
						} else {
							var Ret=jsonData.info;
							if(Ret==-10){
								Msg.info("warning","采购药品中存在供应商为空的记录，不能生成订单!");
							}
							else if(Ret==-2){
								Msg.info("error", "更新计划单审批标志失败!");
							}else if(Ret==-3){
								Msg.info("error", "保存订单主表信息失败!");
							}else if(Ret==-4){
								Msg.info("error", "保存订单明细失败!");
							}else if(Ret==-5){
								Msg.info("error", "计划单已经审批!");
							}else{
								Msg.info("error", "审批失败:"+Ret);
							}
						}
					},
					scope : this
				});
	}
	
	function rendorPoFlag(value){
        return value=='Y'? '是': '否';
    }
    function rendorCmpFlag(value){
        return value=='Y'? '完成': '未完成';
    }
	

	// 访问路径
	var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["RowId", "PurNo", "LocId", "Loc", "Date", "User","PoFlag", "CmpFlag","StkGrpId", "StkGrp"];
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
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "采购计划单号",
				dataIndex : 'PurNo',
				width : 200,
				align : 'center',
				sortable : true
			}, {
				header : "采购部门",
				dataIndex : 'Loc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "制单日期",
				dataIndex : 'Date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'User',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "是否已生成订单",
				dataIndex : 'PoFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorPoFlag
			}, {
				header : "完成标志",
				dataIndex : 'CmpFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorCmpFlag
			}, {
				header : "类组",
				dataIndex : 'StkGrp',
				width : 200,
				align : 'center',
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

	// 添加表格单击行事件
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PurId = MasterStore.getAt(rowIndex).get("RowId");
		DetailStore.removeAll();
		DetailStore.setBaseParam('sort','Rowid');
		DetailStore.setBaseParam('dir','Desc');
		DetailStore.setBaseParam('parref',PurId);
		DetailStore.load({params:{start:0,limit:20,sort:'Rowid',dir:'Desc',parref:PurId}});
	});

	// 转移明细
	// 访问路径
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=queryItem';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["RowId", "IncId","IncCode","IncDesc", "Spec", "Manf", {name:"Qty",type:'double'},"UomId",
			 "Uom", "Rp", "Sp","RpAmt","SpAmt","Vendor", "Carrier", "Gene", "GoodName",
			"Form", "ReqLoc", "StkQty", "MaxQty","MinQty","HospitalQty","PackUomDesc"];
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
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品Id",
				dataIndex : 'IncId',
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
				dataIndex : 'IncDesc',
				width : 220,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'Spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "采购数量",
				dataIndex : 'Qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'Uom',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
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
				header : "供应商",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "配送商",
				dataIndex : 'Carrier',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "处方通用名",
				dataIndex : 'Gene',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "商品名",
				dataIndex : 'GoodName',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'Form',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "请求科室",
				dataIndex : 'ReqLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "库存",
				dataIndex : 'StkQty',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : "库存上限",
				dataIndex : 'MaxQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "库存下限",
				dataIndex : 'MinQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "全院库存",
				dataIndex : 'HospitalQty',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "大包装单位",
				dataIndex : 'PackUomDesc',
				width : 100,
				align : 'center',
				sortable : true
			}]);
	var DetailGridPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:20,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});


	var DetailGrid = new Ext.grid.GridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				//======
				bbar:DetailGridPagingToolbar,
	            clicksToEdit:1
			});

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {width: 220, border:false},    // Default config options for child items
			style : DHCSTFormStyle.FrmPaddingV,
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',        	
	        	items: [PhaLoc,Vendor]				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.33,
	        	xtype: 'fieldset',	      
	        	items: [PurNo,PlanAuditFlag]
				
			}]
		}]
		
	});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'采购计划审批',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '采购单',			               
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'south',
		                split: true,
            			height: 250,
            			minSize: 200,
            			maxSize: 350,
            			collapsible: true,
		                title: '采购单明细',
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
			
	Query();


})