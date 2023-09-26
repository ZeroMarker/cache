// /名称: 库存转移单辅助制单（依据请求方消耗）
// /描述: 库存转移单辅助制单（依据请求方消耗）
// /编写者：zhangdongmei
// /编写日期: 2012.07.26

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var locId = session['LOGON.CTLOCID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '请求部门',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '90%',				
				emptyText : '请求部门...',
				listWidth : 250,
				defaultLoc:""
			});

	// 供给部门
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '供给部门',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '90%',				
				emptyText : '供给部门...',
				listWidth : 250,
				groupId:session['LOGON.GROUPID']
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
			
	var UseDays =new Ext.form.NumberField({
			fieldLabel : '参考天数',
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%',
			width : 120
	});

	var IntFac =new Ext.form.NumberField({
		fieldLabel : '取整系数',
		id : 'IntFac',
		name : 'IntFac',
		anchor : '90%',
		width : 120
	});
	
	var ManageFlag = new Ext.form.Checkbox({
		hideLabel:true,
		boxLabel : '重点关注标志',
		id : 'ManageFlag',
		name : 'ManageFlag',
		anchor : '90%',
		width : 120,
		checked : false
	});
	
	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:locId,
		UserId:userId,
		anchor : '90%',
		width : 200
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
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		var UseDays = Ext.getCmp("UseDays").getValue();
		if (supplyphaLoc == undefined || supplyphaLoc.length <= 0) {
			Msg.info("warning", "请选择供应部门!");
			return;
		}
		if (requestphaLoc == undefined || requestphaLoc.length <= 0) {
			Msg.info("warning", "请选择请求部门!");
			return;
		}
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
			Msg.info("warning", "请填写参考天数!");
			return;
		}
		var fac =  Ext.getCmp("IntFac").getValue();
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		//var PhaWin=Ext.getCmp("PhaWin").getValue();
		//var DispUser=Ext.getCmp("DispUser").getValue();
		var ManFlag=Ext.getCmp("ManageFlag").getValue();
		var ListParam=supplyphaLoc+'^'+requestphaLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+fac+'^'+ManFlag+'^'+""+'^'+"";
		DetailStore.load({params:{start:0, limit:999,ParamStr:ListParam}});
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
		Ext.getCmp("UseDays").setValue("");
		Ext.getCmp("IntFac").setValue("");
		//Ext.getCmp("PhaWin").setValue("");
		//Ext.getCmp("DispUser").setValue("");
		Ext.getCmp("ManageFlag").setValue(false);
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
				text : '保存',
				tooltip : '点击保存',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					save();
				}
			});
			// 单位
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '单位',
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '单位...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});
	/**
	 * 单位展开事件
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("inci");
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
				CTUom.store.load();
			});

	/**
	 * 单位变换事件
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);

				var value = combo.getValue();        //目前选择的单位id
				var BUom = record.get("BUomId");
				var ConFac = record.get("Fac");   //大单位到小单位的转换关系					
				var TrUom = record.get("pUom");    //目前显示的出库单位
				var Sp = record.get("sp");
				var StkQty = record.get("stkQty");
				var DirtyQty=record.get("ResQty");
				var AvaQty=record.get("AvaQty");
				var PurQty=record.get("purQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("sp", accDiv(Sp,ConFac));
					record.set("stkQty", accMul(StkQty,ConFac));
					record.set("ResQty", accMul(DirtyQty,ConFac));
					record.set("AvaQty", accMul(AvaQty,ConFac));
					record.set("purQty", accMul(PurQty,ConFac));
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("sp", accMul(Sp,ConFac));
					record.set("stkQty", accDiv(StkQty,ConFac));
					record.set("ResQty", accDiv(DirtyQty,ConFac));
					record.set("AvaQty", accDiv(AvaQty,ConFac));
					record.set("purQty", accDiv(PurQty,ConFac));
				}
				record.set("pUom", combo.getValue());
	});
	
	/**
	 * 生成转移单
	 */
	function save() {
		//供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注
		var inItNo = '';
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if(supplyPhaLoc==""){
			Msg.info("warning","请选择供给部门!");
			return;
		}
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if(requestPhaLoc==""){
			Msg.info("warning","请选择请求部门!");
			return;
		}
		var reqid='';
		var operatetype = '';	
		var Complete='N';
		var Status=10;
		var StkGrpId = Ext.getCmp("StkGrpType").getValue();
		var StkType = App_StkTypeCode;					
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
			var Initi = '';
			var Inclb = rowData.get("INCLB");
			var Qty = rowData.get("tranQty");
			if(Qty==0){
				continue;
			}
			var UomId = rowData.get("pUom");
			var ReqItmId = '';
			var Remark ='';
			
			var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
					+ ReqItmId + "^" + Remark;	
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+xRowDelim()+str;
			}				
		}
		if(ListDetail==""){
			Msg.info("warning","没有需要保存的数据!");
			return;
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					params:{Rowid:'',MainInfo:MainInfo,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : '处理中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							var InitRowid = jsonData.info;
							Msg.info("success", "保存成功!");
							// 跳转到出库制单界面
							window.location.href='dhcstm.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';
						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", "加锁失败,不能保存!");
							}else if(ret==-2){
								Msg.info("error", "生成出库单号失败,不能保存!");
							}else if(ret==-1){
								Msg.info("error", "保存出库单失败!");
							}else if(ret==-5){
								Msg.info("error", "保存出库单明细失败!");
							}else {
								Msg.info("error", "部分明细保存不成功："+ret);
							}
						}
					},
					scope : this
				});
	}
	
			/**
	 * 删除选中行物资
	 */
	function deleteDetail() {
		
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
	}
	
	// 转移明细
	// 访问路径
	var DetailUrl =  DictUrl
				+ 'dhcinistrfaction.csp?actiontype=QueryDetailForTransByConsume';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = [ "INCI","code","desc", "pUom", "pUomDesc", "tranQty","manf",
			 "batNo", "expDate", "stkQty","INCLB","sp","stkbin", "purQty", "ResQty", "AvaQty","BUomId","Fac"];
			
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCLB",
				fields : fields
			});
	
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "物资Id",
				dataIndex : 'INCI',
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
				header : '物资名称',
				dataIndex : 'desc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "批次Id",
				dataIndex : 'INCLB',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批号",
				dataIndex : 'batNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "效期",
				dataIndex : 'expDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "转移数量",
				dataIndex : 'tranQty',
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
									Msg.info("warning", "转移数量不能为空!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "转移数量不能小于或等于0!");
									return;
								}
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								var record = DetailGrid.getStore()
										.getAt(cell[0]);									
								var AvaQty = record.get("AvaQty");
								if (qty > AvaQty) {
									Msg.info("warning", "转移数量不能大于可用库存数量!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "转移单位",
				dataIndex : 'pUom',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer2(CTUom,'pUom','pUomDesc'),
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "售价",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "货位码",
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "批次库存",
				dataIndex : 'stkQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "占用数量",
				dataIndex : 'ResQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "可用数量",
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "消耗数量",
				dataIndex : 'purQty',
				width : 80,
				align : 'right',
				sortable : true
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				region : 'center',
				title: '待出库明细',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
			});
	/***
	**添加右键菜单
	**/		
	DetailGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
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
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,0);
		rightClick.showAt(e.getXY()); 
	}

	var HisListTab = new Ext.ux.FormPanel({
		labelAlign : 'right',
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px;',
			defaults: {xtype: 'fieldset', border:false},    // Default config options for child items
			items:[{
				columnWidth: 0.27,
	        	items: [SupplyPhaLoc,RequestPhaLoc,StkGrpType]
			},{
				columnWidth: 0.25,
	        	items: [StartDate,EndDate,UseDays]
			},{
				columnWidth: 0.23,
	        	items: [IntFac]
			},{
				columnWidth: 0.25,
	        	items: [ManageFlag]
			}]
		}]
		
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, DetailGrid],
				renderTo : 'mainPanel'
			});
})