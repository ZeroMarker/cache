// /名称: 订单查询
// /描述: 订单查询
// /编写者：yangshijie
// /编写日期: 2019-12-19
Ext.onReady(function() {

	var gGroupId = session['LOGON.GROUPID'];
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : $g('科室'),
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		groupId : gGroupId
	});
	// 登录设置默认值
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel : $g('起始日期'),
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		//width : 120,
		value : DefaultStDate()
	});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
		fieldLabel : $g('截止日期'),
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		//width : 120,
		value : DefaultEdDate()
	});

	var inpoNoField = new Ext.form.TextField({
		id:'inpoNoField2',
		fieldLabel:$g('订单号'),
		allowBlank:true,
		emptyText:$g('订单号...'),
		anchor:'90%',
		selectOnFocus:true
	});
	
	// 物资名称
	var InciDesc = new Ext.form.TextField({
		fieldLabel : $g('名称'),
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		width : 150,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = '';  //Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});
	var IncId = new Ext.form.TextField({
		fieldLabel : $g('名称'),
		id : 'IncId',
		name : 'IncId',
		hidden:true
	});
		/**
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, stktype) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "", "",getDrugList);
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
		Ext.getCmp("IncId").setValue(inciDr);
	}
	// 经营企业
	var apcVendorField = new Ext.ux.VendorComboBox({
		fieldLabel : $g('经营企业'),
		id : 'apcVendorField',
		name : 'apcVendorField',
		anchor : '90%',
		emptyText : $g('经营企业...')
	});
	
	
	var finishflag = new Ext.form.Checkbox({
		id: 'finishflag',
		fieldLabel:$g('完成'),
		allowBlank:true,
		anchor:'90%'
	});
		
	// 查询订单按钮
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : $g('查询'),
		tooltip : $g('点击查询订单'),
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});


	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : $g('清屏'),
		tooltip : $g('点击清屏'),
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	

	// 打印按钮
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : $g('打印'),
		tooltip : $g('点击打印'),
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", $g("请选择需要打印的入库单!"));
							return;
						}
						var PoId = rowData.get("PoId");
						var PoNo = rowData.get("PoNo");
						var Vendor = rowData.get("Vendor");
						var PoDate = rowData.get("PoDate");
						
						PrintInPo(PoId); 
						
					}
	});
	
	
	/**
	 * 清空方法
	 */
	function clearData() {
		SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("inpoNoField2").setValue("");
		Ext.getCmp("IncId").setValue("");
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp('finishflag').setValue(false);
		Ext.getCmp('StartDate').setValue(DefaultStDate());
		Ext.getCmp('EndDate').setValue(DefaultEdDate());
		
		MasterStore.load({params:{start:0,limit:999,ParamStr:""}});
		DetailStore.load({params:{start:0,limit:999,Parref:""}});
	}

	// 显示订单数据
	function Query() {
		DetailStore.load({params:{start:0,limit:999,Parref:""}});
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", $g("请选择订购部门!"));
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var venDesc=Ext.getCmp("apcVendorField").getValue();
		if (venDesc==""){
			Ext.getCmp("apcVendorField").setValue("");
		}
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var PoNo = Ext.getCmp('inpoNoField2').getValue();
		var Status='';
		var Complete="";
		var Complete1 = Ext.getCmp('finishflag').getValue();
		Complete = (Complete1==true?'Y':(Complete1==false?'N':''));
		var inciDesc=Ext.getCmp("InciDesc").getValue();
		if (inciDesc==""){
			Ext.getCmp("IncId").setValue("");
		}
		var InciId=Ext.getCmp("IncId").getRawValue();
		//开始日期^截止日期^订单号^经营企业id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^物资id
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+Vendor+'^'+phaLoc+'^'+Complete+'^N^'+Status+'^'+InciId;
		//alert(ListParam);
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
		  
		/*
		   MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
		
		*/
	}
	// 显示订单明细数据
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
		
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus=$g('未入库');			
		}else if(value==1){
			PoStatus=$g('部分入库');
		}else if(value==2){
			PoStatus=$g('全部入库');
		}
		return PoStatus;
	}
	// 访问路径
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","CmpFlag"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				listeners:{
					'load':function(ds){
						DetailGrid.store.removeAll();
						DetailGrid.getView().refresh();
						
						if (ds.getCount()>0)
						{
							MasterGrid.getSelectionModel().selectFirstRow();
							MasterGrid.getView().focusRow(0);
						}
					}
				
					
				}
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
		header : "RowId",
		dataIndex : 'PoId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g("订单号"),
		dataIndex : 'PoNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : $g("订购科室"),
		dataIndex : 'PoLoc',
		width : 120,
		align : 'left',
		sortable : true,
		hidden:true
	}, {
		header : $g("经营企业"),
		dataIndex : 'Vendor',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : $g("订单状态"),
		dataIndex : 'PoStatus',
		width : 90,
		align : 'left',
		sortable : true,
		renderer:renderPoStatus
	}, {
		header : $g("订单日期"),
		dataIndex : 'PoDate',
		width : 80,
		align : 'right',
		sortable : true
	},{
		header : $g("完成"),
		dataIndex : 'CmpFlag',
		width : 60,
		align : 'center',
		sortable : true,
		renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}	
	}
	
	]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({ 
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:$g("没有记录"),
		beforePageText : $g("当前页"),
		afterPageText : $g("共{0}页"),
	});
	var MasterGrid = new Ext.grid.GridPanel({
		title : '',
		height : 360,
		autoScroll:true,
		//region:'west',
		layout:'fit',
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
	MasterGrid.on('rowclick', function(grid, rowIndex, e) {
		//var PoId = MasterStore.getAt(rowIndex).get("PoId");
		//var Size=DetailPagingToolbar.pageSize;
		//DetailStore.setBaseParam('Parref',PoId);
		//DetailStore.load({params:{start:0,limit:Size}});
	});
	
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
		var PoId = rec.get("PoId");
		var Size=DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('Parref',PoId);
		DetailStore.load({params:{start:0,limit:Size}}); 
	});		
		
	MasterGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		if (PoId!='')	{
			fn(PoId);
			if (win) win.close();
		}
	});
	
		
	// 订单明细
	// 访问路径
	var DetailUrl =DictUrl+
		'inpoaction.csp?actiontype=QueryDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	// 指定列参数
	//PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "PoItmId",
		fields : fields
	});
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:$g("没有记录"),
		beforePageText : $g("当前页"),
		afterPageText : $g("共{0}页"),
	});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "订单明细id",
		dataIndex : 'PoItmId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "RowId",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g('代码'),
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g('名称'),
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : $g("单位"),
		dataIndex : 'PurUom',
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
		header : $g("订购数量"),
		dataIndex : 'PurQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : $g("到货数量"),
		dataIndex : 'ImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : $g("未到货数量"),
		dataIndex : 'NotImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}]);

	var DetailGrid = new Ext.grid.GridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '',
		height : 360,
		region:'center',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:[DetailPagingToolbar]
	});
	
	var HisListTab = new Ext.form.FormPanel({
			region:'north',
			labelWidth : 60,
			height:DHCSTFormStyle.FrmHeight(1),
			labelAlign : 'right',
			frame : true,
			tbar : [SearchBT, '-',  ClearBT,'-',PrintBT],
			layout:'fit',
			items : [{
				xtype : 'fieldset',
				title : $g('查询信息'),
				layout : 'column',
				style:DHCSTFormStyle.FrmPaddingV,				
				items : [{
					columnWidth : .3,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					defaults: {width: 140, border:false},   
					border: false,
					items : [PhaLoc,apcVendorField]
				}, {
					columnWidth : .25,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					autoHeight: true,
					border: false,
					items : [StartDate,EndDate]
				}, {
					columnWidth : .3,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					autoHeight: true,
					border: false,
					items : [inpoNoField,InciDesc]
				},{
					columnWidth : .15,
					labelAlign : 'right',		
					xtype: 'fieldset',	
					autoHeight: true,
					border: false,
					items : [finishflag]
				}]
				
			}]		
						
		});
				
	
	/*
	var poPanel = new Ext.Panel({
		title:'订单',
		activeTab:0,
		height:410,
		//autoScroll:true,
		collapsible:true,
        split:true,
		layout:'fit',
		width:550,
        minSize:0,
        maxSize:550,
		items:[MasterGrid]                                 
	});
				
	var poItemPanel = new Ext.Panel({
		title:'订单明细',
		activeTab:0,
		height:410,
		deferredRender:true,
		region:'center',
		width:1125,
		items:[DetailGrid]                                 
	});
	*/
	// 页面布局
	var mainPanel = new Ext.form.FormPanel({
		activeTab:0,
		height:410,
		width:1200,
		region:'center',
		layout:'border',
		items : [{
			region:'west',		
			title:$g('订单'),
			activeTab:0,
			height:410,
			autoScroll:true,
			collapsible:true,
	        split:true,
			layout:'fit',
			width:550,
	        minSize:0,
	        maxSize:550,
			items:[MasterGrid]     			
		},{
			region:'center',
			layout:'fit',
			title:$g('订单明细'),
			activeTab:0,
			height:410,
			deferredRender:true,
			region:'center',
			width:1125,
			items:[DetailGrid]    				
		}]
		//renderTo : 'mainPanel'
	});
	
		// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [HisListTab  ,mainPanel]          // create instance immediately
       			,
				renderTo : 'mainPanel'
			});
	
	
	
});