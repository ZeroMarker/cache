// /名称: 采购计划单执行情况查询
// /描述: 采购计划单执行情况查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gIncId='';
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var PurNo = new Ext.form.TextField({
				fieldLabel : $g('采购单号'),
				id : 'PurNo',
				name : 'PurNo',
				anchor : '90%',
				width : 120
			});

	// 供货生产企业
    var Vendor = new Ext.ux.VendorComboBox({
				fieldLabel : $g('经营企业'),
				id : 'Vendor',
				name : 'Vendor',
				anchor : '90%',
				emptyText : $g('经营企业...')
	});

	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('采购部门'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : $g('采购部门...'),
				groupId:session['LOGON.GROUPID']
			});
	
		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('起始日期'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : DefaultStDate()
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('截止日期'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : DefaultEdDate()
				});

			
		var InciDesc = new Ext.form.TextField({
			fieldLabel : $g('药品名称'),
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = '';
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
		
				/**
		 * 调用药品窗体并返回结果
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
			gIncId = record.get("InciDr");
			Ext.getCmp("InciDesc").setValue(record.get("InciDesc"));
		}
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('查询'),
					tooltip : $g('点击查询'),
					width : 70,
					height : 30,
					iconCls:'page_find',
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
				Msg.info("warning", $g("请选择采购部门!"));
				return;
			}
			var VenId = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var PurNo =  Ext.getCmp("PurNo").getValue();
			if(Ext.getCmp("InciDesc").getValue()==""){
				gIncId="";
			}
			//科室id^开始日期^截止日期^计划单号^类组id^经营企业id^药品id^完成标志^审核标志
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+PurNo+'^^'+VenId+'^'+gIncId+'^^^';
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam("strParam",ListParam);
			
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			MasterStore.removeAll();
			MasterStore.load({params:{start:0, limit:Page}});
		
			MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			});
		}

		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					text : $g('清屏'),
					tooltip : $g('点击清屏'),
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
			SetLogInDept(PhaLoc.getStore(),"PhaLoc")
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("PurNo").setValue("");
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			GridPagingToolbar.updateInfo();
			
		}

		// 访问路径
		var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
				
		var fields = ["RowId", "PurNo", "Loc", "Date", "User", "PoFlag","CmpFlag", "StkGrp", "AuditFlag"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Rowid",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams:{strParam:""}
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
					header : $g("计划单号"),
					dataIndex : 'PurNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g('采购科室'),
					dataIndex : 'Loc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("计划单日期"),
					dataIndex : 'Date',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : $g("采购员"),
					dataIndex : 'User',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("是否已生成订单"),
					dataIndex : 'PoFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("完成标志"),
					dataIndex : 'CmpFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("审批标志"),
					dataIndex : 'AuditFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("类组"),
					dataIndex : 'StkGrp',
					width : 100,
					align : 'left',
					sortable : true
				}]);
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
			emptyMsg:$g("没有记录")
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
			DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PurId}});
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
		var fields = ["RowId", "IncId", "IncCode","IncDesc","Spec", "Manf", "Qty", "Uom","Rp",
				 "RpAmt", "Vendor", "Carrier","ReqLoc","RecQty","LeftQty"];
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
					header : $g("采购明细项RowId"),
					dataIndex : 'RowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("药品Id"),
					dataIndex : 'IncId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('药品代码'),
					dataIndex : 'IncCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('药品名称'),
					dataIndex : 'IncDesc',
					width : 220,
					align : 'left',
					sortable : true
				}, {
					header : $g("规格"),
					dataIndex : 'Spec',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("采购数量"),
					dataIndex : 'Qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("单位"),
					dataIndex : 'Uom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("进价"),
					dataIndex : 'Rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("进价金额"),
					dataIndex : 'RpAmt',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("经营企业"),
					dataIndex : 'Vendor',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("生产企业"),
					dataIndex : 'Manf',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("配送企业"),
					dataIndex : 'Carrier',
					width : 120,
					align : 'right',
					sortable : true
				}, {
					header : $g("申购科室"),
					dataIndex : 'ReqLoc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("入库数量"),
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("未到货数量"),
					dataIndex : 'LeftQty',
					width : 100,
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
			labelWidth: 60,	
			labelAlign : 'right',
			autoHeight:true,
			frame : true,
			tbar : [SearchBT, '-', ClearBT],			
			items : [{
				xtype:'fieldset',
				title:$g('查询条件'),
				style : DHCSTFormStyle.FrmPaddingV,
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults: {border:false},    // Default config options for child items
				items:[{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',
	            	items: [PhaLoc,Vendor]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            
	            	items: [StartDate,EndDate]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [PurNo]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [InciDesc]					
				}]
			}]			
		});

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                title:$g('采购单执行情况查询'),
			                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'west',
			                width:document.body.clientWidth*0.3,
			                minSize: document.body.clientWidth*0.1,
                			maxSize: document.body.clientWidth*0.8,
                			collapsible: true,
                			split:true,
			                title: $g('采购单'),			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'center',			               
			                title: $g('采购单明细'),
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
})