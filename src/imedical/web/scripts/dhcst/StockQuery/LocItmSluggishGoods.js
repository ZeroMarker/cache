// /名称: 呆滞品报警查询
// /描述: 呆滞品报警查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.15
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('科室'),
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});
		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('开始日期'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : new Date().add(Date.DAY, - 30)
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('截止日期'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : new Date()
				});
		var PFlag = new Ext.form.Checkbox({
			fieldLabel : $g('住院发/退药'),
			id : 'PFlag',
			name : 'PFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//住院发/退药参考数量
		var PQty =new Ext.form.NumberField({
			id : 'PQty',
			name : 'PQty',
			anchor : '90%',
			width : 50
		});
		var GFlag = new Ext.form.Checkbox({
			fieldLabel : $g('入库'),
			id : 'GFlag',
			name : 'GFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//入库参考数量
		var GQty =new Ext.form.NumberField({
			id : 'GQty',
			name : 'GQty',
			anchor : '90%',
			width : 50
		});
		var FFlag = new Ext.form.Checkbox({
			fieldLabel : $g('门诊发/退药'),
			id : 'FFlag',
			name : 'FFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//门诊发/退药参考数量
		var FQty =new Ext.form.NumberField({
			id : 'FQty',
			name : 'FQty',
			anchor : '90%',
			width : 50
		});	
		var TFlag = new Ext.form.Checkbox({
			fieldLabel : $g('转出'),
			id : 'TFlag',
			name : 'TFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//转出参考数量
		var TQty =new Ext.form.NumberField({
			id : 'TQty',
			name : 'TQty',
			anchor : '90%',
			width : 50
		});	
		var KFlag = new Ext.form.Checkbox({
			fieldLabel : $g('转入'),
			id : 'KFlag',
			name : 'KFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//转入参考数量
		var KQty =new Ext.form.NumberField({
			id : 'KQty',
			name : 'KQty',
			anchor : '90%',
			width : 50
		});					
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('查询'),
					tooltip : $g('点击查询'),
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
				Msg.info("warning", $g("科室不能为空！"));
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			if (startDate == undefined || startDate.length <= 0) {
				Msg.info("warning", $g("请选择开始日期!"));
				return;
			}
			if (endDate == undefined || endDate.length <= 0) {
				Msg.info("warning", $g("请选择截止日期!"));
				return;
			}
			var TransType=null;
			var PFlag=(Ext.getCmp("PFlag").getValue()==true?'P':'');    // 住院发/退药
			var PQty=Ext.getCmp("PQty").getValue();
			var FFlag=(Ext.getCmp("FFlag").getValue()==true?'F':'');	//门诊发/退药
			var FQty=Ext.getCmp("FQty").getValue();
			var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');    //转出
			var TQty=Ext.getCmp("TQty").getValue();
			var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');	//转入
			var KQty=Ext.getCmp("KQty").getValue();
			var GFlag=(Ext.getCmp("GFlag").getValue()==true?'G':''); 	//入库
			var GQty=Ext.getCmp("GQty").getValue();
			if(PFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+PFlag+'$'+PQty+',Y$'+PQty;
				}else{
					TransType=PFlag+'$'+PQty+',Y$'+PQty;
				}
			}
			if(FFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+FFlag+'$'+FQty+',H$'+FQty;
				}else{
					TransType=FFlag+'$'+FQty+',H$'+FQty;
				}
			}
			if(GFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+GFlag+'$'+GQty;
				}else{
					TransType=GFlag+'$'+GQty;
				}
			}
			if(TFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+TFlag+'$'+TQty;
				}else{
					TransType=TFlag+'$'+TQty;
				}
			}
			if(KFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+KFlag+'$'+KQty;
				}else{
					TransType=KFlag+'$'+KQty;
				}
			}
			if (TransType == null || TransType.length <= 0) {
				Msg.info("warning", $g("请选择业务类型!"));
				return;
			}
			
			gStrParam=phaLoc+"^"+startDate+"^"+endDate
			+"^"+TransType;
			StockQtyStore.setBaseParam("Params",gStrParam);
			StockQtyStore.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize},
				callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert($g("查询错误"),StockQtyStore.reader.jsonData.Error);  
					}
				}
			});

		}
				
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('清屏'),
					tooltip : $g('点击清屏'),
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
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("PFlag").setValue(false);
			Ext.getCmp("FFlag").setValue(false);
			Ext.getCmp("GFlag").setValue(false);
			Ext.getCmp("TFlag").setValue(false);
			Ext.getCmp("KFlag").setValue(false);
			Ext.getCmp("PQty").setValue('');
			Ext.getCmp("FQty").setValue('');
			Ext.getCmp("GQty").setValue('');
			Ext.getCmp("TQty").setValue('');
			Ext.getCmp("KQty").setValue('');
		
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}
		// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
					text : $g('另存'),
					tooltip : $g('另存为Excel'),
					iconCls : 'page_export',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);
						//gridSaveAsExcel(StockQtyGrid);
					}
				});
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "inclb",
					dataIndex : 'inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('代码'),
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("名称"),
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : $g("规格"),
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("单位"),
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("可用库存"),
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("批次库存"),
					dataIndex : 'stkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("售价"),
					dataIndex : 'sp',
					width : 60,
					align : 'right',					
					sortable : true
				}, {
					header : $g("批号"),
					dataIndex : 'batNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("效期"),
					dataIndex : 'expDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("生产企业"),
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("经营企业"),
					dataIndex : 'vendor',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("货位"),
					dataIndex : 'sbDesc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("最后一次入库日期"),
					dataIndex : 'LastImpDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("最后一次出库日期"),
					dataIndex : 'LastTrOutDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("最后一次转入日期"),
					dataIndex : 'LastTrInDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header :$g( "最后一次发药日期(住院)"),
					dataIndex : 'LastIpDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("最后一次发药日期(门诊)"),
					dataIndex : 'LastOpDate',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmSluggishGoods&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["inclb","code", "desc","spec", "manf", "batNo","expDate","vendor","stkUom",
				"stkQty", "avaQty", "sp", "sbDesc","LastImpDate","LastTrOutDate","LastTrInDate","LastIpDate","LastOpDate"];
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
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
					emptyMsg : "No results to display",
					prevText : $g("上一页"),
					nextText : $g("下一页"),
					refreshText : $g("刷新"),
					lastText : $g("最后页"),
					firstText : $g("第一页"),
					beforePageText : $g("当前页"),
					afterPageText : $g("共{0}页"),
					emptyMsg : $g("没有数据")
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar
            	
		});
		
	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			region : 'north',
			title:$g("呆滞品报警查询"),
			autoHeight : true,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT, '-', RefreshBT,'-',SaveAsBT],	
			items:[{
				layout : 'column',
				defaults: { border:false},	
				title:$g('查询条件'),
				xtype: 'fieldset',
				style:'padding-top:5px;padding-bottom:5px',	
					items:[{
						columnWidth:0.3,
						xtype: 'fieldset',
						//style:'padding-top:10px;padding-bottom:10px',									
						defaults: {width: 250, border:false},    // Default config options for child items
						items : [PhaLoc,StartDate,EndDate]
					  },{
						columnWidth:0.55,																	
						xtype: 'fieldset',
						title:$g('业务类型<业务发生数少于录入数(入库单位)认定为呆滞品>'),	
						//style:'padding-top:5px;padding-bottom:5px',		
						border:true,
						hideLabels:false,
						labelWidth:80,
						//style:'margin-left:10px',
						layout: 'column',  
						items:[{ 				
								columnWidth: 0.25,
				            	xtype: 'fieldset',
				            	//labelWidth: 50,	
				            	//defaults: {width: 80, border:false},    // Default config options for child items
				            	defaultType: 'textfield',
				            	border: false,
				            	style:'padding-top:3px;padding-bottom:3px',	          
				            	items: [{
											xtype: 'compositefield',								
											items : [PFlag,PQty]
										},{
											xtype: 'compositefield',								
											items : [FFlag,FQty]
										}]
							
							},{ 				
								columnWidth: 0.25,
				            	xtype: 'fieldset',
				            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
				            	border: false,
				            	style:'padding-top:3px;padding-bottom:3px',	
				            	items: [{
											xtype: 'compositefield',								
											items : [TFlag,TQty]
										},{
											xtype: 'compositefield',								
											items : [KFlag,KQty]
										}]
							
							},{ 				
								columnWidth: 0.25,
				            	xtype: 'fieldset',
				            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
				            	border: false,
				            	style:'padding-top:3px;padding-bottom:3px',	
				            	items: [{
											xtype: 'compositefield',								
											items : [GFlag,GQty]
										}]
							
							}]			
				
					}]
			}]	
			
		});

		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ 
						{
			                region: 'north',
			                height: 195, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('明细'),			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
})