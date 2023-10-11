// /名称: 订单查询
// /描述: 订单查询
// /编写者：zhangdongmei
// /编写日期: 2012.10.08
Ext.onReady(function() {
	
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var HDCMhiddenFlag = false
	var inpoProp = PHA_COM.ParamProp("DHCSTPO")

	if(inpoProp.HDCMFlag == "N") HDCMhiddenFlag = true
	//alert(gParam)
	
	//订购科室
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : $g('科室'),
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : $g('订购科室...')
	});
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('起始日期'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : $g('截止日期'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});
	
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : $g('未入库'),
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : $g('部分入库'),
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : $g('全部入库'),
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	
	// 经营企业
	var apcVendorField=new Ext.ux.VendorComboBox({
		id : 'apcVendorField',
		name : 'apcVendorField',
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
			
	/**
	 * 清空方法
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		Ext.getCmp("AllImp").setValue(true);
		
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		GridPagingToolbar.updateInfo();
		DetailPagingToolbar.updateInfo();
	}
	
	// 发送至医共体主院
var SendMainHospBT = new Ext.Toolbar.Button({
	id : "SendMainHosp",
	text : $g('上传主院'),
	tooltip : $g('上传至医共体主院'),
	width : 70,
	height : 30,
	iconCls : 'page_goto',
	hidden : HDCMhiddenFlag,
	handler : function() {
		
		alert("本功能暂时以本院同时担任医共体子院主院。如果需要配置医共体主子院区请联系药库开发工程师")
		//return false;
		var record = MasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", $g("没有需要上传的数据!"));				
			return false;
		}
		
		var INPoId = record.get('PoId');
		var ret=tkMakeServerCall("PHA.IN.HDCM.Client.DHCMClient","INPOItm",INPoId)
		if(ret==0)
		{
			Msg.info("success", $g("上传成功!"));
			MasterGrid.store.reload();
		}
		else 
		{
			if(ret==-1){
				Msg.info("error", $g("订单为空!"));
			}else if(ret==-2){
				Msg.info("error", $g("该订单已完成上传!"));
			}else {
				Msg.info("error", $g("主院保存订单失败：")+ret);
			}
				
		}
	}
});

	// 取消已经发送的订单
var CancelMainHospBT = new Ext.Toolbar.Button({
	id : "CancelMainHospBT",
	text : $g('取消上传主院'),
	tooltip : $g('取消医共体主院订单'),
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	hidden : HDCMhiddenFlag,
	handler : function() {
		var record = MasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", $g("没有需要取消的数据!"));				
			return false;
		}
		
		var INPoId = record.get('PoId');
		var ret=tkMakeServerCall("PHA.IN.HDCM.Client.DHCMClient","DeleteINPo",INPoId)
		if(ret==0)
		{
			Msg.info("success", $g("取消成功!"));
			MasterGrid.store.reload();
		}
		else 
		{
			if(ret==-2){
				Msg.info("error", $g("订单未上传!"));
			}else if(ret==-3){
				Msg.info("error", $g("订单缺失附加信息!"));
			}else {
				Msg.info("error", $g("取消主院订单失败：")+ret);
			}
		}
	}
});




	// 显示订单数据
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", $g("请选择订购部门!"));
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var Status=notimp+','+partlyimp+','+allimp;
		//开始日期^截止日期^订单号^经营企业id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+phaLoc+'^Y^Y^'+Status;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		DetailPagingToolbar.updateInfo();
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
				    
	    MasterStore.on('load',function(){
			if (MasterStore.getCount()>0){
				MasterGrid.getSelectionModel().selectFirstRow();
				MasterGrid.getView().focusRow(0);
			}
		})
	
		//DetailGrid.store.removeAll();
		//DetailGrid.getView().refresh();
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
	
	
	function SendHDCMrender(value){
		if(value=="Y"){
			value=$g('√');			
		}
		return value;
	}
	// 访问路径
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","VendorTel","SendHDCMFlag"];
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
				header : $g("订单号"),
				dataIndex : 'PoNo',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g("订购科室"),
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("经营企业"),
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("经营企业电话"),
				dataIndex : 'VendorTel',
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
				align : 'left',
				sortable : true
			}, {
				header : $g("上传主院"),
				dataIndex : 'SendHDCMFlag',
				width : 80,
				align : 'center',
				renderer:SendHDCMrender,
				sortable : true,
				hidden : HDCMhiddenFlag,
			}
			]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
	var MasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 360,
				region:'west',
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				tbar: { items: [SendMainHospBT, '-', CancelMainHospBT] },
				bbar:[GridPagingToolbar]
			});

	// 添加表格单击行事件
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		var Size=DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('Parref',PoId);
		DetailStore.removeAll();
		DetailStore.load({params:{start:0,limit:Size}});
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
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : $g("订单明细id"),
		dataIndex : 'PoItmId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g("药品RowId"),
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : $g('药品代码'),
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g('药品名称'),
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
		renderer:notimpqtyrender,
		sortable : true
	}]);
function notimpqtyrender(val){
		if(val<0){
			return 0;
		}else{
		return val;}
	}
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
		labelWidth : 80,
		width : 300,
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-',  ClearBT ],
		//autoHeight:true,
		layout: 'fit',    // Specifies that the items will now be arranged in columns
		items : [{
			xtype : 'fieldset',
			title : $g('查询信息'),
			//layout : 'column',
			autoHeight:true,
			style : DHCSTFormStyle.FrmPaddingV,
			items : [PhaLoc,apcVendorField,StartDate,EndDate,NotImp,PartlyImp,AllImp
			
			/*{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	defaults: {width: 140, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	//autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	items: [PhaLoc,apcVendorField]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	defaults: {width: 140, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	//autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	//style: {
	            //	"margin-left": "10px", // when you add custom margin in IE 6...
	            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	        	//},
        		items: [StartDate,EndDate]
			},{ 				
				columnWidth: 0.1,
	        	xtype: 'fieldset',
	        	defaults: {width: 80, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	//autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	//style: {
	            //	"margin-left": "10px", // when you add custom margin in IE 6...
	            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	        	//},
	        	items: [NotImp,PartlyImp]
			},{ 				
				columnWidth: 0.15,
	        	xtype: 'fieldset',
	        	defaults: {width: 80, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	//style: {
	            //	"margin-left": "10px", // when you add custom margin in IE 6...
	            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	        	//},
	        	items: [AllImp]
			}*/
			
			]
		}]
	});
	
	var poPanel = new Ext.Panel({
		title:$g('订单'),
		activeTab:0,
		height:410,
		collapsible:true,
        split:true,
		region:'west',
		width:550,
        minSize:0,
        maxSize:550,
		items:[MasterGrid]                                 
	});
				
	var poItemPanel = new Ext.Panel({
		title:$g('订单明细'),
		activeTab:0,
		height:410,
		deferredRender:true,
		region:'center',
		width:1125,
		items:[DetailGrid]                                 
	});

	// 页面布局
	
	
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[{
			title:$g('订单到货情况查询'),
			region:'west',
			width:300,
			height:DHCSTFormStyle.FrmHeight(2),
			layout:'fit',
			items:HisListTab
		},/*{
			region:'west',
			title: $g('订单'),
		    collapsible: true,
		    split: true,
		    width: 450, // give east and west regions a width
		    minSize: 175,
		    maxSize: 450,
		    margins: '0 5 0 0',
		    layout: 'fit', // specify layout manager for items
			items:MasterGrid
		},{
			region: 'center',
		    title: $g('订单明细'),
		    layout: 'fit', // specify layout manager for items
			items:DetailGrid
		}*/
		{             
			                region: 'center',
			                boder:false,	
			                layout:'border',
			                items:[{
			                	region:'north',
			                	title: $g('订单'),
			                	split:true,
			                	height:300,
			                	minSize:100,
			                	maxSize:400,
			                	collapsible:true,
			                	layout: 'fit', // specify layout manager for items
			                	items: MasterGrid    
			                },{
			                	region:'center',
			                	title:$g('订单明细'),
			                	
			                	layout:'fit',
			                	items:DetailGrid			                
			                }]             	
			               
			            }
		
		
		],
		renderTo:'mainPanel'
	});

	
});
