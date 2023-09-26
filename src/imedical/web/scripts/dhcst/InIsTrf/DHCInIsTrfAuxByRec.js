// /名称: 根据入库单出库
// /描述: 根据入库单出库
// /编写者：zhangdongmei
// /编写日期: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gInitId='';
	Ext.QuickTips.init();
	var ProType=GetRecTransType();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	
	
	// 供给部门
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '供给部门',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '80%',
				emptyText : '供给部门...',
				listWidth : 250,
				groupId : session['LOGON.GROUPID']
			});
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				width : 120,
				value : DefaultEdDate()
			});
	
	var TransStatus = new Ext.form.Checkbox({
				fieldLabel : '包含已转移',
				id : 'TransStatus',
				name : 'TransStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
	// 供货厂商
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '供应商',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '80%',			
			listWidth : 250
		});
		
	// 查询转移单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询入库单',
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
				text : '清屏',
				tooltip : '点击清屏',
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
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("TransStatus").setValue(false);
		MasterGrid.store.removeAll();
		DetailGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
	}

	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
				id : "SaveBT",
				text : '保存',
				tooltip : '点击保存',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {						
						getReqLoc();						
				}
			});
    /**
	 * 选取请求部门并保存
	 */
	function getReqLoc() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '请求部门',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '80%',
				emptyText : '请求部门...',
				listWidth : 250,
				defaultLoc:'',
				relid:Ext.getCmp("SupplyPhaLoc").getValue(),
				protype:ProType,
				params : {relid:'SupplyPhaLoc'}
		});
		var ConfirmBT = new Ext.Button({
			id:'ConfirmBT',
			name:'ConfirmBT',
			iconCls:'page_save',
			text:'确定',
			handler:function(){
				var requestPhaLoc=Ext.getCmp("RequestPhaLoc").getValue();
			    if(requestPhaLoc==null || requestPhaLoc.length<1){
					Msg.info("warning", "请选择请求科室!");
					return;
				}
				save(requestPhaLoc);
				RequestPhaLocWin.close();
				
			}
		});
		var panel = new Ext.form.FormPanel({
			id:'panel',
			region:'center',
			layout:'form',
			labelWidth:60,
			frame:true,
			labelAlign:'right',
			bodyStyle:'padding:10px;',
			items:[RequestPhaLoc]
		});
		
		var RequestPhaLocWin = new Ext.Window({
			title : '请求部门',
			width :350,
			height : 130,
			modal:true,
			layout : 'border',
			bodyStyle:'padding:10px;',
			items : [panel],
			buttons:[ConfirmBT],
			buttonAlign : 'center'
		});
		RequestPhaLocWin.show();
	}
	/**
	 * 保存转移单
	 */
	function save(requestPhaLoc) {
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		if(selectRecords=="" || selectRecords=='undefined'){
			Msg.info("warning","没有选中的入库单!");
			return;
		}
		var record = selectRecords[0];
		var Status = record.get("Status");				
		if (Status =="已转移") {
			Msg.info("warning", "该入库单已经出库，不能再出库!");
			
			return;
		}			
		
		//供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注
		var inItNo = '';
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var ingrid=record.get("IngrId");
		var reqid='';
		var operatetype = '';	
		var Complete='N';
		var Status=10;
		var StkGrpId =record.get("StkGrpId");	
		var StkType = App_StkTypeCode;					
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark+"^"+ingrid;
		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
			var Initi = '';
			var Inclb = rowData.get("Inclb");
			var Qty = rowData.get("TrQty");
			if(Qty==0){
				continue;
			}
			var UomId = rowData.get("TrUomId");
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
							window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

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
	 * 删除选中行药品
	 */
	function deleteDetail() {
		// 判断转移单是否已完成
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

	// 显示入库单数据
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "请选择供给部门!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var status = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var Vendor = Ext.getCmp("Vendor").getValue();
		
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+supplyphaLoc+'^'+status;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam("ParamStr",ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "查询错误，请查看日志!");
     			}else{
     				if(r.length>=1){
     					MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
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
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
	
	// 访问路径
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryImport';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["IngrId", "IngrNo", "RecLoc", "ReqLoc", "Vendor","CreateUser", "CreateDate","Status","StkGrpId","StkGrpDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'IngrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "入库单号",
				dataIndex : 'IngrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "请求部门",
				dataIndex : 'ReqLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供给部门",
				dataIndex : 'RecLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "入库日期",
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "入库人",
				dataIndex : 'CreateUser',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "转移状态",
				dataIndex : 'Status',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'StkGrpDesc',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var MasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners:{
								rowselect:function(sm,rowIndex,rec){
									var IngrId = rec.get("IngrId");
									DetailStore.load({params:{start:0,limit:999,Parref:IngrId}});
								}
							}
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// 添加表格单击行事件
//	MasterGrid.on('rowclick', function(grid, rowIndex, e) {
//		var IngrId = MasterStore.getAt(rowIndex).get("IngrId");
//		DetailStore.load({params:{start:0,limit:999,Parref:IngrId}});
//	});
	
	// 转移明细
	// 访问路径
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryImportDetail&Parref=&start=0&limit=999';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["Ingri", "BatchNo", "TrUomId","TrUom","ExpDate", "Inclb", "TrQty", "IncId",
			 "IncCode", "IncDesc", "Manf","Rp","RpAmt", "Sp", "SpAmt", "BUomId",
			 "ConFacPur", "StkQty", "DirtyQty","AvaQty","BatExp"
			];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Ingri",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	/**
	 * 显示明细前，装载必要的combox
	 */
	DetailStore.on('beforeload',function(store,options){
		//装载所有单位
		var url = DictUrl
						+ 'drugutil.csp?actiontype=CTUom&CTUomDesc=&start=0&limit=9999';
		CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
		CTUomStore.load();
	});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "入库明细id",
				dataIndex : 'Ingri',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品RowId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '药品代码',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '药品名称',
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "批次RowId",
				dataIndex : 'Inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批号/效期",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "批次库存",
				dataIndex : 'StkQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "转移数量",
				dataIndex : 'TrQty',
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
								var salePriceAMT = record
										.get("Sp")
										* qty;
								record.set("SpAmt",
										salePriceAMT);
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
				dataIndex : 'TrUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer(CTUom), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
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
				header : "占用数量",
				dataIndex : 'DirtyQty',
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
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "转换率",
				dataIndex : 'ConFacPur',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "基本单位",
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
			});

	DetailGrid.on('beforeedit',function(e){
		if(e.field=="TrQty"){
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if(rowData!=null && rowData!=""){
				if(rowData.get('Status')=='已转移'){
					e.cancel=true;	//已转移的单据,不可修改转移数量
				}
			}
		}
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
		rightClick.showAt(e.getXY()); 
	}

	/**
	 * 单位展开事件
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
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
				var ConFac = record.get("ConFacPur");   //大单位到小单位的转换关系					
				var TrUom = record.get("TrUomId");    //目前显示的出库单位
				var Sp = record.get("Sp");
				var Rp = record.get("Rp");
				var InclbQty=record.get("StkQty");
				var DirtyQty=record.get("DirtyQty");
				var AvaQty=record.get("AvaQty");
			
				if (value == null || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("Sp", Sp/ConFac);
					record.set("Rp", Rp/ConFac);
					record.set("StkQty", InclbQty*ConFac);
					record.set("DirtyQty", DirtyQty*ConFac);
					record.set("AvaQty", AvaQty*ConFac);						
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("Sp", Sp*ConFac);
					record.set("Rp", Rp*ConFac);
					record.set("StkQty", InclbQty/ConFac);
					record.set("DirtyQty", DirtyQty/ConFac);
					record.set("AvaQty", AvaQty/ConFac);
				}
				record.set("TrUomId", combo.getValue());
	});

	// 变换行颜色
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.form.FormPanel({
		//labelWidth: 60,	
		labelAlign : 'right',
		frame : true,		
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],		
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px',
			defaults: {width: 220, border:false},    // Default config options for child items
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        
	        	items: [SupplyPhaLoc,Vendor]				
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        	
	        	items: [TransStatus]				
			}]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		            	title:'库存转移-依据入库单',
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: '入库单',
		                collapsible: true,
		                split: true,
		                width: document.body.clientWidth*0.3, // give east and west regions a width
		                minSize: document.body.clientWidth*0.1,
		                maxSize: document.body.clientWidth*0.6,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'center',
		                title: '入库单明细',
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
	
})