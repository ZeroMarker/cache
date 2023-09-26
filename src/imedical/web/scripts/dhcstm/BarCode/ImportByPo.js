// /名称: 订单
function ImportByPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var PoPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PoPhaLoc',
				name : 'PoPhaLoc',
				anchor : '90%',
				emptyText : '订购科室...',
				groupId:gGroupId,
				childCombo : 'PoVendor'
			});
	// 起始日期
	var StartDatex = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDatex',
				name : 'StartDatex',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// 截止日期
	var EndDatex = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDatex',
				name : 'EndDatex',
				anchor : '90%',
				width : 120,
				value : new Date()
			});
	var PoNotImp = new Ext.form.Checkbox({
				fieldLabel : '未入库',
				id : 'PoNotImp',
				name : 'PoNotImp',
				anchor : '90%',
				checked : true
			});
	var PoPartlyImp = new Ext.form.Checkbox({
		fieldLabel : '部分入库',
		id : 'PoPartlyImp',
		name : 'PoPartlyImp',
		anchor : '90%',
		checked : true
	});
	// 供应商
	var PoVendor = new Ext.ux.VendorComboBox({
			id : 'PoVendor',
			name : 'PoVendor',
			anchor : '90%',
			params : {LocId : 'PoPhaLoc'}
	});
	// 入库单号
	var PoNo = new Ext.form.TextField({
		fieldLabel : '订单号',
		id : 'PoNo',
		name : 'PoNo',
		anchor : '90%',
		listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					PoQuery();	
					}
				}
			}
	});
	
		
	// 查询订单按钮
	var PoSearchBT = new Ext.Toolbar.Button({
				id : "PoSearchBT",
				text : '查询',
				tooltip : '点击查询订单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					PoQuery();
				}
			});


	// 清空按钮
	var PoClearBT = new Ext.Toolbar.Button({
				id : "PoClearBT",
				text : '清空',
				tooltip : '点击清空',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					PoclearData();
				}
			});
	/**
	 * 清空方法
	 */
	function PoclearData() {
		SetLogInDept(Ext.getCmp("PoPhaLoc").getStore(),"PoPhaLoc");
		Ext.getCmp("PoVendor").setDisabled(0);
		Ext.getCmp("PoNotImp").setValue(true);
		Ext.getCmp("PoPartlyImp").setValue(true);
		
		PoMasterGrid.store.removeAll();
		PoDetailGrid.store.removeAll();
		PoDetailGrid.getView().refresh();
		
	}

	// 保存按钮
	var PoSaveBT = new Ext.Toolbar.Button({
				id : "PoSaveBT",
				text : '导入',
				tooltip : '点击导入',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(PoDetailGrid.activeEditor != null){
						PoDetailGrid.activeEditor.completeEdit();
					}
					if(PoCheckDataBeforeSave()==true){
						Posave();						
					}
				}
			});

	/**
	 * 保存入库单前数据检查
	 */		
	function PoCheckDataBeforeSave() {
		var nowdate = new Date();
		var record = PoMasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", "没有需要导入的数据!");				
			return false;
		}
		var Status = record.get("PoStatus");				
		if (Status ==2) {
			Msg.info("warning", "该订单已经全部导入，不能再导入!");				
			return false;
		}			
		// 判断入库部门和供货商是否为空
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc == null || PoPhaLoc.length <= 0) {
			Msg.info("warning", "请选择入库部门!");
			return false;
		}
		// 1.判断入库物资是否为空
		var rowCount = PoDetailGrid.getStore().getCount();
		// 有效行数
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = PoDetailStore.getAt(i).get("IncId");
			if (item != "") {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", "请输入入库明细!");
			return false;
		}
		
		var record = PoDetailGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", "请选择明细!");				
			return false;
		}
		
		return true;
	}
	
	/**
	 * 保存入库单
	 */
	function Posave() {
		var selectRecords = PoDetailGrid.getSelectionModel().getSelections();
		Fn(selectRecords)
		Powin.close()
		
	}
	// 显示订单数据
	function PoQuery() {
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc =='' || PoPhaLoc.length <= 0) {
			Msg.info("warning", "请选择订购部门!");
			return;
		}
		var startDate = Ext.getCmp("StartDatex").getValue();
		var endDate = Ext.getCmp("EndDatex").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var PoNotImp = (Ext.getCmp("PoNotImp").getValue()==true?0:'');
		var PoPartlyImp = (Ext.getCmp("PoPartlyImp").getValue()==true?1:'');
		var Status=PoNotImp+","+PoPartlyImp;
		var PoVendor = Ext.getCmp("PoVendor").getValue();
		var PoNo = Ext.getCmp("PoNo").getValue();
		
		//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+PoVendor+'^'+PoPhaLoc+'^Y^1^'+Status;
		var Page=PoGridPagingToolbar.pageSize;
		PoMasterStore.removeAll();
		PoDetailGrid.store.removeAll();
		PoMasterStore.setBaseParam("ParamStr",ListParam);
		PoMasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(r.length==0){
     				Msg.info("warning", "未找到符合的单据!");
     			}else{
     				if(r.length>0){
	     				PoMasterGrid.getSelectionModel().selectFirstRow();
	     				PoMasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				PoMasterGrid.getView().focusRow(0);
     				}
     			}
     		}
		});

	}
	// 显示入库单明细数据
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		PoDetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='未入库';			
		}else if(value==1){
			PoStatus='部分入库';
		}else if(value==2){
			PoStatus='全部入库';
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
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","ReqLocDesc","ReqLoc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// 数据集
	var PoMasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
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
				header : "订单号",
				dataIndex : 'PoNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "申购科室",
				dataIndex : 'ReqLocDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "订购科室",
				dataIndex : 'PoLoc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 250,
				align : 'left',
				sortable : true
			}, {
				header : "订单日期",
				dataIndex : 'PoDate',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var PoGridPagingToolbar = new Ext.PagingToolbar({
		store:PoMasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var PoMasterGrid = new Ext.grid.GridPanel({
				region: 'center',
				title: '订单',
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : PoMasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:PoGridPagingToolbar
			});

	// 添加表格单击行事件
	PoMasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = PoMasterStore.getAt(rowIndex).get("PoId");
		PoDetailStore.load({params:{start:0,limit:999,Parref:PoId}});
	});
	
	// 订单明细
	// 访问路径
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryPoDetailForRec&Parref=&start=0&limit=999';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:"ExpDate",type:"date",dateFormat:ARG_DATEFORMAT}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo","CerExpDate","HighValueFlag"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// 数据集
	var PoDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				pruneModifiedRecords:true
			});
	var sm2=new Ext.grid.CheckboxSelectionModel({
			listeners : {
				beforerowselect :function(sm,rowIndex,keepExisting ,record  ) {
					var hvflag=record.get("HighValueFlag")
					if (hvflag!='Y'){Msg.info("warning","请选择高值材料!");return false}
				}
			}
	})
	var nm = new Ext.grid.RowNumberer();
	var PoDetailCm = new Ext.grid.ColumnModel([nm,sm2,{
				header : "订单明细id",
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "物资RowId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
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
				header : '规格',
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '具体规格',
				dataIndex : 'SpecDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '高值标志',
				dataIndex : 'HighValueFlag',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'AvaBarcodeQty',
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
			},{
				header : "订购数量",
				dataIndex : 'PurQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "已入库数量",
				dataIndex : 'ImpQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "已生成数量",
				dataIndex : 'BarcodeQty',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "注册证号码",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "注册证效期",
				dataIndex : 'CerExpDate',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	
	var PoDetailGrid = new Ext.grid.EditorGridPanel({
                region: 'south',
                title: '订单明细',
                height: gGridHeight,
				cm : PoDetailCm,
				store : PoDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm:sm2,
				clicksToEdit : 1
			});
	var PoHisListTab = new Ext.ux.FormPanel({
		labelWidth : 60,
		tbar : [PoSearchBT,'-',PoClearBT, '-',PoSaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px;',
			defaults: {border:false},    // Default config options for child itemsPoNo
			items:[{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoNo]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoPhaLoc]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoVendor]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [StartDatex]
			},{ 				
				columnWidth: 0.2,
				xtype: 'fieldset',
	        	items: [EndDatex]
			}]
		}]
	});

	// 页面布局
	var Powin = new Ext.ux.Window({
				title : '条码打印-依据订单条码',
				layout : 'border',
				items : [PoHisListTab, PoMasterGrid, PoDetailGrid]
			});
	//页面加载完成后自动检索订单
	Powin.show()
	PoNo.focus(true,100)
}