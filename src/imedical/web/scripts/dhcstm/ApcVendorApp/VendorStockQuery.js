
// /描述: 供应商库存查询
// /编写者：gwj
// /编写日期: 2013.05.16

	var gStrParam='';
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
var Vendor = new Ext.ux.UsrVendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	userId :gUserId,
	emptyText : '供应商...'
});

	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});
	// 日期
	var DateTime = new Ext.ux.DateField({
			fieldLabel : '日期',
			id : 'DateTime',
			name : 'DateTime',
			anchor : '90%',
			value : new Date()
	});
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId

	});

	


		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var vendr = Ext.getCmp("Vendor").getValue();
			if (vendr == null || vendr.length <= 0) {
				Msg.info("warning", "供应商不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			var stkDate = Ext.getCmp("DateTime").getValue();
			if (stkDate == undefined || stkDate.length <= 0) {
				Msg.info("warning", "请选择日期!");
				return;
			}
			stkDate = stkDate.format(ARG_DATEFORMAT);
			var stkGrpId=Ext.getCmp("StkGrpType").getValue();
			gStrParam=vendr+"^"+phaLoc+"^"+stkDate+"^"+stkGrpId;
			BatchGrid.store.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});
			StockQtyStore.on('load',function(){
				if (StockQtyStore.getCount()>0){
					StockQtyGrid.getSelectionModel().selectFirstRow();
					StockQtyGrid.getView().focusRow(0);
				}
			});
		}
				
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});
	//导出按钮
		var ExportBT = new Ext.Toolbar.Button({
			text : '导出',
			tooltip : '点击导出',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				ExportData();
			}
		});
		
		//导出方法
		function ExportData(){
			if (StockQtyGrid.getStore().getCount() > 0)
			{
				var strFileName="供应商库存查询";
				var objExcelTool=Ext.dhcc.DataToExcelTool;
				objExcelTool.ExprotGrid(StockQtyGrid,strFileName);
			} else {
				Msg.info("warning", "查询列表数据为空!");
				return;
			}
		}
		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("DateTime").setValue(new Date());
			Ext.getCmp("PhaLoc").setValue('');
			Ext.getCmp("StkGrpType").setValue('');
					
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
			BatchGrid.store.removeAll();
		}

		var nm = new Ext.grid.RowNumberer();
		//var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "Pid",
					dataIndex : 'Pid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : "INCIRowID",
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : '代码',
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "名称",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : '库存(包装单位)',
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					hidden:true,
					sortable : true
				}, {
					header : "包装单位",
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "库存(基本单位)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "基本单位",
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, {
					header : "库存(单位)",
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "零售价",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : "最新进价",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : '售价金额',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : '进价金额',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : '规格',
					dataIndex : 'Spec',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : '厂商',
					dataIndex : 'ManfDesc',
					width : 150,
					align : 'left',
					sortable : false
				}, {
					header : "占用库存",
					dataIndex : 'DirtyQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}, {
					header : "可用库存",
					dataIndex : 'AvaQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl ='dhcstm.apcvendorstataction.csp?actiontype=VendorStk&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["Pid","Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty","StkQtyUom","PurUomDesc",
		             "PurUomId","PurStockQty","Spec","ManfDesc","Sp","SpAmt","Rp","RpAmt","DirtyQtyUom","AvaQtyUom"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inclb",
					fields : fields
				});
				
		
		
		// 数据集
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		
		
		// 访问路径
		var BatchUrl = 'dhcstm.apcvendorstataction.csp?actiontype=VendorBan&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxyBatch = new Ext.data.HttpProxy({
					url : BatchUrl,
					method : "POST"
				});
		// 指定列参数
		var fieldsBatch = ["Locdesc","Inclb","StkBin","Btno","Expdate","BUomDesc","BUomId","StockQty","PurUomDesc","PurUomId","PurStockQty","DirtyQtyUom","AvaQtyUom"];
		// 支持分页显示的读取方式
		var readerBatch = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsBatch
				});
		// 数据集
		var BatchStore = new Ext.data.Store({
					proxy : proxyBatch,
					reader : readerBatch
				});
		
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
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
					emptyMsg : "没有数据",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='desc';
						B[A.dir]='ASC';
						
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
				
		var StatuTabPagingToolbarBatch = new Ext.PagingToolbar({
					store : BatchStore,
					pageSize : PageSize,
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
					emptyMsg : "没有数据",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='Rowid';
						B[A.dir]='desc';
						B['Params']=gStrParamBatch;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
		});
		
		var StockQtyGrid = new Ext.ux.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar
            	
		});
	
	// 添加表格单击行事件
		StockQtyGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var strPid = StockQtyStore.getAt(rowIndex).get("Pid");
			var strInci=StockQtyStore.getAt(rowIndex).get("Inci");			
			
			gStrParamBatch=strPid+"^"+strInci;
			var pageSize=StatuTabPagingToolbarBatch.pageSize;
			BatchStore.load({params:{start:0,limit:pageSize,Params:gStrParamBatch}});
			
		});
	
	var BatchCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
				{
					header : "所在科室",
					dataIndex : 'Locdesc',
					width : 150,
					align : 'left',
					sortable : true
					
				},{
					header : "INClbRowID",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : '批号',
					dataIndex : 'Btno',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "效期",
					dataIndex : 'Expdate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "货位",
					dataIndex : 'StkBin',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '库存(包装单位)',
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					hidden:true,
					sortable : true
				}, {
					header : "包装单位",
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "库存(基本单位)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "基本单位",
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, {
					header : "库存(单位)",
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "零售价",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : "最新进价",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : '售价金额',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : '进价金额',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : "占用库存",
					dataIndex : 'DirtyQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}, {
					header : "可用库存",
					dataIndex : 'AvaQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}]);
		BatchCm.defaultSortable = true;	
		
	var BatchGrid = new Ext.grid.GridPanel({
			cm : BatchCm,
			store : BatchStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true,
			bbar : StatuTabPagingToolbarBatch					
	});
		
	var HisListTab = new Ext.form.FormPanel({
			labelwidth : 20,
			region : 'north',
			title:"供应商库存查询",
			height : 170,
			labelAlign : 'right',
			frame : true,
			bodyStyle : 'padding:10px 1px 1px 0px;',
			tbar : [SearchBT, '-', RefreshBT,'-',ExportBT],	
			items:[{
				layout : 'column',
			    defaults: { border:false},	
			    xtype: 'fieldset',
			    title:'查询条件',
			    
			    items:[{
					columnWidth:0.3,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width: 150, border:false},    // Default config options for child items
					items : [Vendor]
				  },{
					columnWidth:0.3,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width:150, border:false},    // Default config options for child items
					items : [PhaLoc]
				  },{
					columnWidth:0.2,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width:150, border:false},    // Default config options for child items
					items : [DateTime]
				  },{
					columnWidth:0.2,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width:120, border:false},    // Default config options for child items
					items : [StkGrpType]
				  }]	
			}]				
			
		});
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	

	// 5.2.页面布局
	var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [ HisListTab  			               
			        , {
			            region: 'center',
			            title: '项目明细',			               
			            layout: 'fit', // specify layout manager for items
			            items: StockQtyGrid       
			        },{
			            region:'south',
			            title:'批次信息',
			            split:true,
			            height:150,
			            minSize:100,
			            maxSize:200,
			            collapsible:true,
			            layout:'fit',
			            items:BatchGrid			                
			        }],
		  renderTo : 'mainPanel'
	});
	
})