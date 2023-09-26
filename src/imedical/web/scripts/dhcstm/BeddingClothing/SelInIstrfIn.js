// /名称: 被服类--根据转入单制作出库单
// /描述: 
// /编写者：	wangjiabin
// /编写日期: 2013-12-30
var SelInIsTrfIn=function(SupplyLocId,Fn) {
	var gUserId = session['LOGON.USERID'];

	// 接收部门
	var RequestPhaLocS = new Ext.ux.LocComboBox({
		fieldLabel : '来源部门',
		id : 'RequestPhaLocS',
		name : 'RequestPhaLocS',
		emptyText:'来源部门',
		anchor : '90%',
		width : 120,
		defaultLoc:{}
	}); 
	
	// 起始日期
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDateS',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDateS',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});
	
	// 3关闭按钮
	var CloseBTIn = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				width : 70,
				height : 30,
				handler : function() {
					findInWin.close();
				}
			});
			
	// 查询请求单按钮
	var SearchBTIn = new Ext.Toolbar.Button({
				id : "SearchBTIn",
				text : '查询',
				tooltip : '点击查询请求单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					QueryIn();
				}
			});

	// 清空按钮
	var ClearBTIn = new Ext.Toolbar.Button({
				id : "ClearBTIn",
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
		Ext.getCmp("RequestPhaLocS").setValue("");
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		InMasterGrid.store.removeAll();
		InDetailGrid.store.removeAll();	
	}

	// 保存按钮
	var SaveBTIn = new Ext.ux.Button({
				id : "SaveBTIn",
				text : '保存',
				tooltip : '点击生成转出单',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(InDetailGrid.activeEditor!=null){
						InDetailGrid.activeEditor.completeEdit();
					}
					save();
				}
			});
	
	/**
	 * 保存转移单
	 */
	function save() {
		var InitRowid="";
		var selectRow=InMasterGrid.getSelectionModel().getSelected();
		if(selectRow==null || selectRow==""){
			Msg.info("warning","请选择要出库的请求单!");
			return;
		}
		var init=selectRow.get("init");
		
//		var frLocIn = selectRow.get("toLoc");	//根据出库单制转入单, 出入科室对调
//		var toLocIn = selectRow.get("frLoc");
//		
//		var scg=selectRow.get("scg");
//		var reqid="",operatetype="",Complete="N",Status=10;
//		var styType=App_StkTypeCode;
//		var remark="";
//		var MainInfo = frLocIn + "^" + toLocIn + "^"+ reqid + "^" + operatetype + "^" + Complete
//					+ "^" + Status + "^" + gUserId + "^" + scg + "^" + styType + "^" + remark;
		
		var rowCount=DetailInStore.getCount();
		var ListDetail="";
		for(var i=0;i<rowCount;i++){
			var rowData = DetailInStore.getAt(i);
			var initi = rowData.get("initi");
			var qty = rowData.get("qty");
			if(qty=="" || qty==null){continue;}
			var detailData=initi+"^"+qty;
			if(ListDetail==""){
				ListDetail=detailData;
			}else{
				ListDetail=ListDetail+xRowDelim()+detailData;
			}
		}
		if(ListDetail==""){
			Msg.info("warning","没有需要保存的明细数据!");
			return;
		}
		
		var mask=ShowLoadMask(findInWin.body,"正在生成转入单...");
		Ext.Ajax.request({
			url : DictUrl+ "dhcinistrfaction.csp?actiontype=CreateInIsTrf",
			method : 'POST',
			params : {InIt:init,ListDetail:ListDetail,UserId:gUserId},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success","保存成功!");
					InitRowid = jsonData.info;
					findInWin.close();
					Fn(InitRowid);
				}else{
					var ret=jsonData.info;
					Msg.info("error", "保存不成功："+ret);
				}
				mask.hide();
			}
		});
	}
	
	// 显示请求单数据
	function QueryIn() {
		var toLoc = Ext.getCmp("SupplyPhaLoc").getValue();	//主界面"供给部门"
		if (toLoc =='' || toLoc.length <= 0) {
			Msg.info("warning", "请选择供给部门!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLocS").getValue();		
		var startDate = Ext.getCmp("StartDateS").getValue();
		var endDate = Ext.getCmp("EndDateS").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var comp="Y",status="31";
		var UserScgPar = toLoc + '%' + gUserId;
		var ListParam=startDate+'^'+endDate+'^'+requestphaLoc+'^'+toLoc+'^'+comp
			+"^"+status+'^^^^'
			+'^^^^'+UserScgPar;
		MasterInStore.setBaseParam('ParamStr',ListParam);
		DetailInStore.removeAll();
		MasterInStore.removeAll();
		MasterInStore.load({
			params:{start:0, limit:MasterInToolbar.pageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info("error", "查询错误, 请查看日志!");
				}else{
					if(r.length>0){
						InMasterGrid.getSelectionModel().selectFirstRow();
					}
				}
			}
		});
	}
	
	// 访问路径
	var MasterInUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["init", "initNo", "toLoc","toLocDesc","frLoc", "frLocDesc", "dd","tt", "comp", "userName","status","StatusCode",
					"scg","scgDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
				fields : fields
			});
	// 数据集
	var MasterInStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInCm = new Ext.grid.ColumnModel([nm, {
				header : "出库单id",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "转入单号",
				dataIndex : 'initNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "来源部门",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "接收部门",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "出库日期",
				dataIndex : 'dd',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "出库时间",
				dataIndex : 'tt',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'scgDesc',
				width : 80,
				align : 'left',
				sortable : true
			}
		/*	, {
				header : "单据状态",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}	*/
			]);
	MasterInCm.defaultSortable = true;
	
	var MasterInToolbar= new Ext.PagingToolbar({
		store:MasterInStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var smIn = new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners:{
			rowselect:function(sm,rowIndex,r){
				var InIt = MasterInStore.getAt(rowIndex).get("init");
				DetailInStore.setBaseParam('Parref',InIt);
				DetailInStore.removeAll();
				DetailInStore.load({params:{start:0,limit:999}});
			}
		}
	});
	
	var InMasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterInCm,
				sm : smIn,
				store : MasterInStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:MasterInToolbar
			});
			
	// 访问路径
	var DetailUrl =DictUrl+'dhcinistrfaction.csp?actiontype=QueryDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin","pp", "spec","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// 数据集
	var DetailInStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var DetailInCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header : "转移细项RowId",
				dataIndex : 'initi',
				width : 100,
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
				header : "批次id",
				dataIndex : 'inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "转移数量",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "数量不能为空!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "数量不能小于或等于0!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "转移单位",
				dataIndex : 'TrUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批次~效期",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manfName',
				width : 140,
				align : 'left'
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
				header : "货位码",
				dataIndex : 'stkbin',
				width : 80,
				align : 'left',
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
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'spAmt',
				width : 80,
				align : 'right',
				sortable : true
			}]);

	var InDetailGrid = new Ext.grid.EditorGridPanel({
				id : 'InDetailGrid',
				region : 'center',
				title : '',
				cm : DetailInCm,
				store : DetailInStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel(),
				clicksToEdit : 1,
				listeners : {
					//右键菜单代码关键部分
					'rowcontextmenu': rightClickFn
				}
			});
			
	var rightClick = new Ext.menu.Menu({
		id:'InRightClickCont',
		items: [
			{
				id: 'mnuDelete',
				handler: deleteDetail,
				text: '删除'
			}
		]
	});
	//右键菜单代码关键部分
	function rightClickFn(grid,rowindex,e){
		grid.getSelectionModel().select(rowindex,1);
		e.preventDefault();
		rightClick.showAt(e.getXY());
	}
	/**
	 * 删除选中行物资
	 */
	function deleteDetail() {
		// 判断转移单是否已完成
		var cell = InDetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = InDetailGrid.getStore().getAt(row);
		InDetailGrid.getStore().remove(record);
	}
	
	var HisListTab = new Ext.form.FormPanel({
		labelwidth : 60,
		labelAlign : 'right',
		frame : true,
		height : 100,
		bodyStyle : 'padding:0px 0px 0px 0px;',
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			defaults: {border:false}, 
			style:"padding:5px 0px 0px 0px",
			layout: 'column',
			items : [{
				columnWidth: 0.34,
				xtype: 'fieldset',
				defaults: {width: 220},
				defaultType: 'textfield',
				autoHeight: true,
				items: [RequestPhaLocS]	
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				defaults: {width: 140},
				defaultType: 'textfield',
				autoHeight: true,
				items: [StartDateS,EndDateS]
			}]
		}]		
	});

//	// 双击事件
//	InMasterGrid.on('rowdblclick', function() {
//		// 保存转移单
//		if(CheckDataBeforeSave()==true){
//			save();
//		}
//	});

	var findInWin = new Ext.Window({
		title:'选取转入单',
		id:'findInWin',
		width:1000,
		height:520,
		minWidth:1000, 
		minHeight:620,
		plain:true,
		modal:true,
		layout : 'border',
		items : [
			{
				region: 'north',
				height: 110,
				layout: 'fit',
				items:HisListTab
			}, {
				region: 'west',
				title: '转入单',
				collapsible: true,
				split: true,
				width: 300,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
				layout: 'fit',
				items: InMasterGrid
			}, {
				region: 'center',
				title: '转入单明细',
				layout: 'fit',
				items: InDetailGrid
			}
		],
		tbar : [SearchBTIn, '-',  ClearBTIn, '-', SaveBTIn, '-', CloseBTIn]
	});
		
	//显示窗口
	findInWin.show();
	QueryIn();
}