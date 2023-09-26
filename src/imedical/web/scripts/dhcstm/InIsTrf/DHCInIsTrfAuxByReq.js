// /名称: 根据转移请求制单
// /描述: 根据转移请求制单
// /编写者：zhangdongmei
// /编写日期: 2012.07.24
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gInitId='';
	var reqid=''; ///声明全局变量以保存请求单号到转移单
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;


	// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '请求部门',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '70%',				
				emptyText : '请求部门...',				
				listWidth : 250,
				//groupId:session['LOGON.GROUPID'],
				defaultLoc:""
			});
	
	// 供给部门
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '供给部门',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '70%',
				emptyText : '供给部门...',
				listWidth : 250,
				groupId:session['LOGON.GROUPID']
			});
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '70%',
				
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '70%',
				
				width : 120,
				value : new Date()
			});
	
	// 包含部分转移
	var PartlyStatus = new Ext.form.Checkbox({
				//fieldLabel : '包含部分转移',
				fieldLabel:'包含部分转移',
				hideLable:true,
				id : 'PartlyStatus',
				name : 'PartlyStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
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
			
	// 查询转移单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询请求单',
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
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-7));
		Ext.getCmp("EndDate").setValue(new Date());
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// 保存按钮
	var SaveBT = new Ext.ux.Button({
				id : "SaveBT",
				text : '保存',
				tooltip : '点击保存',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {

					// 保存转移单
					if(CheckDataBeforeSave()==true){
						saveOrder();
					}
				}
			});
			
	/**
	 * 保存出库单前数据检查
	 */		
	function CheckDataBeforeSave() {
				
		var requestphaLoc = Ext.getCmp("RequestPhaLoc")
				.getValue();
		if (requestphaLoc == null || requestphaLoc.length <= 0) {
			Msg.info("warning", "请选择请求部门!");
			return false;
		}
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
				.getValue();
		if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
			Msg.info("warning", "请选择供应部门!");
			return false;
		}
		if (requestphaLoc == supplyphaLoc) {
			Msg.info("warning", "请求部门和供应部门不能相同!");
			return false;
		}
		
		// 1.判断转移物资是否为空
		var rowCount = DetailGrid.getStore().getCount();
		// 有效行数
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = DetailStore.getAt(i).get("incidr");
			if (item != undefined) {
				count++;
			}
		}
		if(rowCount<=0){
			Msg.info("warning", "没有需要保存的数据!");
			return false;
		}
		if (count <= 0) {
			Msg.info("warning", "需要保存的数据无效!");
			return false;
		}
		// 2.重新填充背景
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		// 3.判断重复输入批次库存物资
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = DetailStore.getAt(i).get("inclb");;
				var item_j = DetailStore.getAt(j).get("inclb");;
				if (item_i != undefined && item_j != undefined
						&& item_i == item_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", "物资批次重复，请重新输入!");
					return false;
				}
			}
		}
		// 4.物资信息输入错误
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			var code = rowData.get("incicode");
			if (code == null || code.length == 0) {
				continue;
			}
			var item = rowData.get("incidr");
			if (item == undefined) {
				Msg.info("warning", "物资信息输入错误!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var qty = DetailStore.getAt(i).get("qty");
			if ((item != undefined) && (qty == null || qty <= 0)) {
				Msg.info("warning", "转移数量不能小于或等于0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}

			var avaQty = DetailStore.getAt(i).get("avaqty");
			if ((item != undefined) && ((qty - avaQty) > 0)) {
				Msg.info("warning", "转移数量不能大于可用库存数量!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		
		return true;
	}
	

	/**
	 * 保存转移单
	 */
	function saveOrder() {
		//供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var rowData=MasterGrid.getSelectionModel().getSelected();
		if(rowData==null || rowData==""){
			Msg.info("warning","没有选择的请求单!");
			return;
		}else{
			reqid=rowData.get('req');
		}
		var operatetype = "";	
		var Complete='N';
		var Status=10;
		var StkGrpId = "";
		var StkType = App_StkTypeCode;					
		var remark = "";
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				var Initi = rowData.get("initi");
				var Inclb = rowData.get("inclb");
				var Qty = rowData.get("qty");
				var UomId = rowData.get("uomdr");
				var ReqItmId =rowData.get("inrqi");
				var Remark ="";
				
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

	// 显示出库单数据
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "请选择供应部门!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var PartlyStatus = (Ext.getCmp("PartlyStatus").getRawValue()==true?1:0);
		var TransStatus = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+PartlyStatus+'^'+TransStatus+'^'+"Y";
		var Page=GridPagingToolbar.pageSize;
	
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}
	// 显示入库单明细数据
	function getDetail(InitRowid) {
		if (InitRowid == null || InitRowid=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:InitRowid}});
	}
	
	// 访问路径
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryReq';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["req", "reqNo", "toLoc","toLocDesc", "frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
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
				dataIndex : 'req',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "请求单号",
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "请求部门",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供给部门",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "请求日期",
				dataIndex : 'date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "单据状态",
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer : renderReqType,
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "转移状态",
				dataIndex : 'transferStatus',
				width : 80,
				align : 'left',
				renderer : renderStatus,
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	
	function renderStatus(value){
		var InstrfStatus='';
		if(value==0){
			InstrfStatus='未转移';			
		}else if(value==1){
			InstrfStatus='部分转移';
		}else if(value==2){
			InstrfStatus='全部转移';
		}
		return InstrfStatus;
	}
	function renderReqType(value){
		var ReqType='';
		if(value=='O'){
			ReqType='请领单';
		}else if(value=='C'){
			ReqType='申领计划';
		}
		return ReqType;
	}
	
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
		var ReqId = MasterStore.getAt(rowIndex).get("req"); 
		var ReqLocDesc=MasterStore.getAt(rowIndex).get("toLocDesc");
		var ReqLocId=MasterStore.getAt(rowIndex).get("toLoc");
		addComboData(GetGroupDeptStore,ReqLocId,ReqLocDesc);
		Ext.getCmp("RequestPhaLoc").setValue(ReqLocId);
		DetailStore.load({params:{start:0,limit:999,sort:'req',dir:'Desc',Parref:ReqId}});
	});
	
	// 转移明细
	// 访问路径
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryReqDetail&Parref=&start=0&limit=999';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["initi", "inrqi", "incidr","incicode","incidesc", "inclb", "batexp", "manfName",
			 "qty", "uomdr", "sp","uomdesc","rqty", "inclbqty", "reqstkqty", "stkbin",
			 "spec", "geneDesc", "formDesc","newsp","spamt", "rp","rpamt", "confac", "buomdr", 
			 "dirtyqty", "avaqty","transqty"
			];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "initi",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "转移细项RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "物资RowId",
				dataIndex : 'incidr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '物资代码',
				dataIndex : 'incicode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'incidesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "批次RowId",
				dataIndex : 'inclb',
				width : 180,
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
									Msg.info("warning", "转移数量不能为空!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "转移数量不能小于或等于0!");
									return;
								}
								var cell = DetailGrid.getSelectionModel().getSelectedCell();
								var record = DetailGrid.getStore().getAt(cell[0]);
								var salePriceAMT = record.get("sp")* qty;
								record.set("spamt",	salePriceAMT);
								var AvaQty = record.get("avaqty");
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
				dataIndex : 'uomdesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批号/效期",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "可用数量",
				dataIndex : 'avaqty',
				width : 80,
				align : 'right',
				sortable : true
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
				header : "请求数量",
				dataIndex : 'rqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "货位码",
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "请求方库存",
				dataIndex : 'reqstkqty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "批次库存",
				dataIndex : 'inclbqty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "占用数量",
				dataIndex : 'dirtyqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'newsp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, /*{
				header : "通用名",
				dataIndex : 'geneDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'formDesc',
				width : 100,
				align : 'left',
				sortable : true
			},*/ {
				header : "售价金额",
				dataIndex : 'spamt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "转换率",
				dataIndex : 'confac',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "基本单位",
				dataIndex : 'buomdr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "转移请求子表RowId",
				dataIndex : 'inrqi',
				width : 100,
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

	
	// 变换行颜色
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	

	var HisListTab = new Ext.form.FormPanel({
		//labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		height : 160,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'查询条件',
			defaults: {border:false},    // Default config options for child items
			style : 'padding:5px 0px 0px 5px;',
			items:[{ 				
				columnWidth: 0.34,
	        	xtype: 'fieldset',
	        	items: [SupplyPhaLoc,RequestPhaLoc]				
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	        	
	        	items: [PartlyStatus,TransStatus]
				
			}]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		            	title:'库存转移-依据请求单',
		                region: 'north',
		                height: 180, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: '请求单',
		                collapsible: true,
		                split: true,
		                width: 225, // give east and west regions a width
		                minSize: 175,
		                maxSize: 400,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'center',
		                title: '请求单明细',
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
			
	
	Query();
	
	
	
})