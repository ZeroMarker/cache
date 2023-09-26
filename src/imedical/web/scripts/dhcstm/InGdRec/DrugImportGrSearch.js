// /名称: 查询界面
// /描述: 查询界面
// /编写者：zhangdongmei
// /编写日期: 2012.07.18

function DrugImportGrSearch(dataStore,Fn) {
	var gUserId = session['LOGON.USERID'];
	var flg = false;
	var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['N', '未完成'], ['Y', '已完成']]
		});
	var Status = new Ext.form.ComboBox({
			fieldLabel : '单据状态',
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 120,
			store : StatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
	// 入库单号
	var InGrNoS = new Ext.form.TextField({
				fieldLabel : '入库单号',
				id : 'InGrNoS',
				name : 'InGrNoS',
				anchor : '90%',
				width : 120
			});

	// 供应商
	var VendorS = new Ext.ux.VendorComboBox({
				fieldLabel : '供应商',
				id : 'VendorS',
				name : 'VendorS',
				anchor : '90%',
				emptyText : '供应商...',
				params : {LocId : 'PhaLocS'}
			});

	// 入库部门
	var PhaLocS = new Ext.ux.LocComboBox({
				fieldLabel : '入库部门',
				id : 'PhaLocS',
				name : 'PhaLocS',
				anchor : '90%',
				emptyText : '入库部门...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'VendorS',
				defaultLoc : {
					'RowId' : Ext.getCmp('PhaLoc').getValue(),
					'Description' : Ext.getCmp('PhaLoc').getRawValue()
				}
			});
	
	// 起始日期
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDateS',
				name : 'StartDateS',
				anchor : '90%',
				
				anchor : '90%',
				value : DefaultStDate()
			});

	// 结束日期
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDateS',
				name : 'EndDateS',
				anchor : '90%',
				
				value : DefaultEdDate()
			});
	
	var InfoFormS = new Ext.ux.FormPanel({
				id : "InfoFormS",
				labelWidth: 60,
				items : [{
					layout: 'column',    // Specifies that the items will now be arranged in columns
					xtype:'fieldset',
					title:'查询条件',
					style:'padding:5px 0px 0px 0px',
					defaults: {border:false},    // Default config options for child items
					items:[{
						columnWidth: 0.33,
						xtype: 'fieldset',
						defaultType: 'textfield',
						items: [PhaLocS,VendorS]
						
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [StartDateS,EndDateS]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [InGrNoS,Status]
					}]
				}]
			});

	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询入库单信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var StartDate = Ext.getCmp("StartDateS").getValue();
		if((StartDate!="")&&(StartDate!=null)){
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		var EndDate = Ext.getCmp("EndDateS").getValue();
		if((EndDate!="")&&(EndDate!=null)){
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		var InGrNo = Ext.getCmp("InGrNoS").getValue();
		var Vendor = Ext.getCmp("VendorS").getValue();
		var PhaLoc = Ext.getCmp("PhaLocS").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择入库部门!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return;
		}
		var Status=Ext.getCmp("Status").getValue();
		var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc+'^'+Status+'^^N'+"^"+""+"^"+gUserId;
		var Page=GridPagingToolbar.pageSize;
		GrMasterInfoStore.baseParams={ParamStr:ListParam};
		GrMasterInfoStore.removeAll();
		GrMasterInfoGrid.store.removeAll();
		GrDetailInfoGrid.store.removeAll();
		GrMasterInfoStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
				}else{
					if(r.length>0){
						GrMasterInfoGrid.getSelectionModel().selectFirstRow();
						GrMasterInfoGrid.getView().focusRow(0);
					}
				}
			}
		});
	}

	// 选取按钮
	var returnBT = new Ext.Toolbar.Button({
				text : '选取',
				tooltip : '点击选取',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					returnData();
				}
			});

	// 清空按钮
	var clearBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		Ext.getCmp("InGrNoS").setValue("");
		Ext.getCmp("VendorS").setValue("");
		Ext.getCmp("PhaLocS").setValue(session['LOGON.CTLOCID']);
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		
		GrMasterInfoGrid.store.removeAll();
		GrDetailInfoGrid.store.removeAll();
	}

	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					flg = false;
					window.close();
				}
			});

	// 访问路径
	var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});

	// 指定列参数
	var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp","RpAmt","SpAmt","ReqLocDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// 数据集
	var GrMasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var GrMasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'IngrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "入库单号",
				dataIndex : 'IngrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : '订购科室',
				dataIndex : 'ReqLocDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '创建人',
				dataIndex : 'CreateUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '创建日期',
				dataIndex : 'CreateDate',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '采购员',
				dataIndex : 'PurchUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "入库类型",
				dataIndex : 'IngrType',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "完成标志",
				dataIndex : 'Complete',
				width : 70,
				align : 'left',
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
			}]);
	GrMasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:GrMasterInfoStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var GrMasterInfoGrid = new Ext.grid.GridPanel({
				region: 'west',
				title: '入库单',
				collapsible: true,
				split: true,
				width: 225,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
				id : 'GrMasterInfoGrid',
				cm : GrMasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners:{
								'rowselect':function(sm,rowIndex,r){
									var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
									var pagesize=DetailGridPagingToolbar.pageSize;
									GrDetailInfoStore.setBaseParam('Parref',InGr);
									GrDetailInfoStore.load({params:{start:0,limit:pagesize,sort:'Rowid',dir:'Desc'}});
								}
							}
						}),
				store : GrMasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});

	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Ingri",
				fields : fields
			});
	// 数据集
	var GrDetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "Ingri",
				dataIndex : 'Ingri',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : '物资代码',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "批号",
				dataIndex : 'BatchNo',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "有效期",
				dataIndex : 'ExpDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'IngrUom',
				width : 80,
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
				header : "发票号",
				dataIndex : 'InvNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "发票日期",
				dataIndex : 'InvDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'left',
				
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'left',
				
				sortable : true
			}]);
	GrDetailInfoCm.defaultSortable = true;
	var DetailGridPagingToolbar = new Ext.PagingToolbar({
		store:GrDetailInfoStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var GrDetailInfoGrid = new Ext.grid.GridPanel({
				region: 'center',
				title: '入库单明细',
				cm : GrDetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:DetailGridPagingToolbar
			});

	// 双击事件
	GrMasterInfoGrid.on('rowdblclick', function() {
				returnData();
			});

	
	var window = new Ext.Window({
				title : '入库单查询',
				width : gWinWidth,
				height : gWinHeight,
				modal : true,
				layout : 'border',
				items : [InfoFormS, GrMasterInfoGrid, GrDetailInfoGrid],
				tbar : [searchBT, '-', returnBT, '-', clearBT, '-', closeBT]
			});
	window.show();
	searchDurgData();
	
	window.on('close', function(panel) {
			var selectRows = GrMasterInfoGrid.getSelectionModel().getSelections();
			if (selectRows==undefined ||selectRows.length == 0) {
				Fn("");
			} else {
				if(flg){
					var InGrRowId = selectRows[0].get("IngrId");				
					Fn(InGrRowId);	
				}else{
					Fn("");
				}			
			}
		});

	function returnData() {
		var selectRows = GrMasterInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Ext.Msg.show({
						title : '错误',
						msg : '请选择要返回的入库单信息！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		} else {
			flg = true;
			var InGrRowId = selectRows[0].get("IngrId");
			//getInGrInfoByInGrRowId(InGrRowId, selectRows[0]);
			window.close();
		}
	}
}