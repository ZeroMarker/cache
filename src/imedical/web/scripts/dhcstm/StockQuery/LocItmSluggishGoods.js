// /名称: 呆滞品报警查询
// /描述: 呆滞品报警查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.15
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];	
	var gGroupId=session['LOGON.GROUPID'];
	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});

		var StkGrpType = new Ext.ux.StkGrpComboBox({
				id: 'StkGrpType',
				name: 'StkGrpType',
				StkType: App_StkTypeCode, //标识类组类型
				anchor: '90%',
				LocId: gLocId,
				UserId: gUserId
			});		
		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '开始日期',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					
					width : 120,
					value : new Date().add(Date.DAY, - 30)
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

		var GFlag = new Ext.form.Checkbox({
			fieldLabel : '入库',
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

		//门诊发/退药参考数量
		var FQty =new Ext.form.NumberField({
			id : 'FQty',
			name : 'FQty',
			anchor : '90%',
			width : 50
		});	
		var TFlag = new Ext.form.Checkbox({
			fieldLabel : '转出',
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
			fieldLabel : '转入',
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

			var StkGrpType = Ext.getCmp("StkGrpType").getValue();			
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
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
			var TransType=null;
			var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');    //转出
			var TQty=Ext.getCmp("TQty").getValue();
			var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');	//转入
			var KQty=Ext.getCmp("KQty").getValue();
			var GFlag=(Ext.getCmp("GFlag").getValue()==true?'G':''); 	//入库
			var GQty=Ext.getCmp("GQty").getValue();
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
				Msg.info("warning", "请选择业务类型!");
				return;
			}
			
			gStrParam=phaLoc+"^"+startDate+"^"+endDate
			+"^"+TransType+"^"+StkGrpType;
			
			StockQtyStore.setBaseParam("Params",gStrParam);
			StockQtyStore.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize}});
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
			Ext.getCmp("GFlag").setValue(false);
			Ext.getCmp("TFlag").setValue(false);
			Ext.getCmp("KFlag").setValue(false);
			Ext.getCmp("GQty").setValue('');
			Ext.getCmp("TQty").setValue('');
			Ext.getCmp("KQty").setValue('');
		
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "inclb",
					dataIndex : 'inclb',
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
					header : "批次库存",
					dataIndex : 'stkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "售价",
					dataIndex : 'sp',
					width : 60,
					align : 'right',					
					sortable : true
				}, {
					header : "批号",
					dataIndex : 'batNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "效期",
					dataIndex : 'expDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "厂商",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "供应商",
					dataIndex : 'vendor',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "货位",
					dataIndex : 'sbDesc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "最后一次入库日期",
					dataIndex : 'LastImpDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "最后一次出库日期",
					dataIndex : 'LastTrOutDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "最后一次转入日期",
					dataIndex : 'LastTrInDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "最后一次发药日期(住院)",
					dataIndex : 'LastIpDate',
					width : 150,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "最后一次发药日期(门诊)",
					dataIndex : 'LastOpDate',
					width : 150,
					align : 'left',
					hidden : true,
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
					emptyMsg : "没有数据"
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
			sm : sm,
			loadMask : true,
			bbar : StatuTabPagingToolbar
		});
		
	var HisListTab = new Ext.ux.FormPanel({
			title:"呆滞品报警查询",
			tbar : [SearchBT, '-', RefreshBT],
			items:[{
				xtype : 'fieldset',
				title : '查询条件',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items:[{
					columnWidth:0.4,
					items : [PhaLoc,StkGrpType,StartDate,EndDate]
				},{
					columnWidth:0.2,																	
					xtype: 'fieldset',
					title:'业务类型',	
					style : 'padding:5px 0px 0px 5px;margin:0px 0px 5px 0px;',
					border:true,
					items:[
						{
							xtype: 'compositefield',
							items : [TFlag,TQty]
						},{
							xtype: 'compositefield',
							items : [KFlag,KQty]
						},{
							xtype: 'compositefield',								
							items : [GFlag,GQty]
					}]
				}]
			}]
			
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [ HisListTab,StockQtyGrid],
		renderTo : 'mainPanel'
	});
})