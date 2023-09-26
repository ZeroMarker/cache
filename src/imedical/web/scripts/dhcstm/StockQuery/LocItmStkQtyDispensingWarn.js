// /名称: 库存报警-按消耗量
// /描述:  库存报警-按消耗量
// /编写者：zhangdongmei
// /编写日期: 2012.08.15
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
		//统计科室
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});

		var NotUseFlag = new Ext.form.Checkbox({
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',
					boxLabel:'包含不可用品种',
					checked : false
				});

			// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					
					width : 120,
					hideLabel:true,
					value : new Date().add(Date.DAY, - 30)
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '至',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					
					width : 120,
					value : new Date()
				});
		//用药天数
		var UseDays=new Ext.form.NumberField({
					id : 'UseDays',
					name : 'UseDays',
					anchor : '90%',
					fieldLabel:'用药天数',
					value:30
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
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();			
			var UseDays = Ext.getCmp("UseDays").getValue();
			if (startDate == undefined || startDate.length <= 0) {
				Msg.info("warning", "请选择开始日期!");
				return;
			}
			if (endDate == undefined || endDate.length <= 0) {
				Msg.info("warning", "请选择截止日期!");
				return;
			}
			startDate = startDate.format(ARG_DATEFORMAT);
			endDate = endDate.format(ARG_DATEFORMAT);
			if (UseDays == undefined || UseDays.length <= 0) {
				Msg.info("warning", "请填写用药天数!");
				return;
			}
			// 可选条件
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			
			gStrParam=phaLoc+"^"+startDate+"^"+endDate
			+"^"+UseDays+"^"+NotUseFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

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

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("UseDays").setValue(30);
			
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "incil",
					dataIndex : 'incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "单位",
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "可用库存",
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "日消耗量",
					dataIndex : 'oneDspQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "需求量",
					dataIndex : 'reqQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "厂商",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmStkQtyDispensingWarn&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["incil", "inci", "code", "desc","spec", "manf", 
				"reqQty", "avaQty", "oneDspQty", "stkUom"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "incil",
					fields : fields
				});
		// 数据集
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
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

		var StockQtyGrid = new Ext.ux.GridPanel({
					id:'StockQtyGrid',
					region: 'center',
					title: '明细',			               
					layout: 'fit',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("avaQty");
						var MaxQty=record.get("maxQty");
						var MinQty=record.get("minQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }
            	}
		});
		
	var HisListTab = new Ext.ux.FormPanel({
			title:"库存报警-按消耗量",
			tbar : [SearchBT, '-', RefreshBT],				
			items:[{
				xtype : 'fieldset',
				title : '查询条件',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items:[{
					columnWidth:0.3,
					items : [PhaLoc,NotUseFlag]
				  },{
					columnWidth:0.45,
					title:'参考月份范围、用药时间',	
					border:true,
					style : 'padding:5px 0px 0px 5px;margin:0px 0px 5px 5px;',
					hideLabels:true,
					items : [{
						xtype: 'compositefield',								
						items : [
							StartDate,
							{ xtype: 'displayfield', value: '--'},
							EndDate,
							UseDays,
							{ xtype: 'displayfield', value: '天'}
						]
					}]
				
				}]	
			}]
		});

		// 5.2.页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [ HisListTab, StockQtyGrid ],
			renderTo : 'mainPanel'
		});
	
})