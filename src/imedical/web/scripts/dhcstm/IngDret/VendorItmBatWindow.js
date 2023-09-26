// /名称: 选物资及相应批次窗口
// /描述: 选物资及相应批次
// /编写者：zhangdongmei
// /编写日期: 2013.01.22

/**
 Input: 物资别名录入值
 StkGrpRowId：类组id
 StkGrpType：类组类型,G/M
 Locdr: 科室id
 Vendor: 供应商id
 VendorName: 供应商名称
 NotUseFlag：不可用标志
 QtyFlag：是否包含0库存项目,1-不包含/0-包含
 HospID：医院id
 ReqLoc: 请求科室id(请求科室id为空时，请求科室库存显示为空)
 Fn：回调函数
 */
var RetVendorRowId='';
var RetURL = 'dhcstm.ingdretaction.csp';

VendorItmBatWindow =function(Input, StkGrpRowId, StkGrpType, Locdr, Vendor,VendorName,NotUseFlag,
		QtyFlag, HospID, ReqLoc,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}
	
	/*物资窗口------------------------------*/
	var PhaOrderUrl = 'dhcstm.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input='
			+ encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag
			+ '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15;

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "InciItem",
		fields : fields
	});
	// 数据集
	var PhaOrderStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : PhaOrderStore,
		pageSize : 15,
		displayInfo : true
	});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect:true,
		listeners:{
			'rowselect':function(selmod,rowindex,record){
					queryIngri();
					
					var inci=record.get("InciDr");
					var loc=Locdr;
					var zeroFlag='0';
					var strPar=inci+"^"+loc+"^"+zeroFlag;
					VendorForIncItmStore.setBaseParam('strPar',strPar);
					VendorForIncItmStore.load();
			}
		}
	});
	
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
		header: '不可用',
		dataIndex: 'NotUseFlag',
		width: 45,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
			header : "代码",
			dataIndex : 'InciCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '名称',
			dataIndex : 'InciDesc',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : "规格",
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "厂商",
			dataIndex : 'ManfName',
			width : 160,
			align : 'left',
			sortable : true
		}, {
			header : '入库单位',
			dataIndex : 'PuomDesc',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : "进价(入库单位)",
			dataIndex : 'pRp',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "售价(入库单位)",
			dataIndex : 'pSp',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "数量(入库单位)",
			dataIndex : 'PuomQty',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "基本单位",
			dataIndex : 'BuomDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "进价(基本单位)",
			dataIndex : 'bRp',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "售价(基本单位)",
			dataIndex : 'bSp',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "数量(基本单位)",
			dataIndex : 'BuomQty',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "计价单位",
			dataIndex : 'BillUomDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "进价(计价单位)",
			dataIndex : 'BillRp',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "售价(计价单位)",
			dataIndex : 'BillSp',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "数量(计价单位)",
			dataIndex : 'BillUomQty',
			width : 100,
			align : 'right',
			sortable : true
		}, ColumnNotUseFlag]);
	PhaOrderCm.defaultSortable = true;
	
	var PhaOrderGrid = new Ext.grid.GridPanel({
		cm : PhaOrderCm,
		store : PhaOrderStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,			
		loadMask : true,
		bbar : StatuTabPagingToolbar,
		deferRowRender : false
	});

	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
              Msg.info('warning','没有任何记录！');
			 	if(window){window.focus();}
			} else {
				PhaOrderGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
				row = PhaOrderGrid.getView().getRow(0);
				if(row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
						PhaOrderGrid.getView().focusRow(0);
					}
				}
			}
		}
	});
		// 回车事件
	PhaOrderGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			VendorRecItmGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
			row = VendorRecItmGrid.getView().getRow(0);
			if (row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
				}	
			}
		}
	});
	
	//库存项目的供应商列表 Store
	var VendorForIncItmStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:RetURL	+ '?actiontype=selectVendor',
		root : 'rows',
		totalProperty : "results",	
		fields :  [{name:"RowId",mapping:'vendor'},{name:"Description",mapping:'vendorName'}],
		baseParams:{
			strPar:''
		}
	});	
	
	//科室库存项目的供应商入库记录
	var VendorRecItmStore = new Ext.data.Store({
		autoDestroy: true,
		url:RetURL + '?actiontype=selectBatch',
		reader: new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results" ,
			id:'INGRI',
			fields:["code","desc","mnf","batch","expdate","recqty","uom","uomDesc","stkqty","INGRI","pp","sven","idate","rp","sp","INCLB","iniflag","Drugform","invNo","invDate","invAmt","venid","buom","confac","HVFlag","Spec","SpecDesc"]
		})	
	});	
	
	var IngriToolBar = new Ext.PagingToolbar({
		store : VendorRecItmStore,
		pageSize : 15,
		displayInfo : true
	});

	var nm2 = new Ext.grid.RowNumberer();
	var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});

	var VendorRecItmCm=new Ext.grid.ColumnModel([nm2, sm2,{
		header : "入库日期",
		dataIndex : 'idate',
		width : 100,
		align : ''
	},{
		header : "代码",
		dataIndex : 'code',
		width : 100,
		align : '',
		hidden:true
	},{	
		header : "名称",
		dataIndex : 'desc',
		width : 100,
		align : '',
		hidden:true
	},{
		header : "厂商",
		dataIndex : 'mnf',
		width : 100,
		align : ''
	},{
		header : "批号",
		dataIndex : 'batch',
		width : 100,
		align : ''
	},{
		header : "效期",
		dataIndex : 'expdate',
		width : 100,
		align : ''
	},{
		header : "具体规格",
		dataIndex : 'SpecDesc',
		width : 100
	},{
		header : "入库数",
		dataIndex : 'recqty',
		width : 100,
		align : 'right'
	},{
		header : "单位rowid",
		dataIndex : 'uom',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "单位",
		dataIndex : 'uomDesc',
		width : 100,
		align : ''
	},{
		header : "库存数",
		dataIndex : 'stkqty',
		width : 60,
		align : 'right'
	},{
		header : "入库明细rowid",
		dataIndex : 'INGRI',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "批价",
		dataIndex : 'pp',
		width : 60,
		align : 'right'
	},{
		header : "供应商名称",
		dataIndex : 'sven',
		width : 100,
		align : '',
		hidden:true
	},{
		header : "进价",
		dataIndex : 'rp',
		width : 60,
		align : 'right'
	},{
		header : "售价",
		dataIndex : 'sp',
		width : 60,
		align : 'right'
	},{
		header : "批次rowid",
		dataIndex : 'INCLB',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "初始化标志",
		dataIndex : 'iniflag',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "发票号",
		dataIndex : 'invNo',
		width : 100,
		align : '',
		hidden : false
	},{
		header : "发票日期",
		dataIndex : 'invDate',
		width : 100,
		align : '',
		hidden : false
	},{
		header : "发票金额",
		dataIndex : 'invAmt',
		width : 100,
		align : 'right',
		hidden : false
	},{
		header : "供应商rowid",
		dataIndex : 'venid',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "基本单位",
		dataIndex : 'buom',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "单位转换系数",
		dataIndex : 'confac',
		width : 100,
		align : '',
		hidden : true
	},{
		header : "高值标志",
		dataIndex : 'HVFlag',
		width : 60,
		align : 'center',
		hidden : true
	},{
		header : "规格",
		dataIndex : 'Spec',
		width : 60,
		align : 'left',
		hideable : false,
		hidden : true
	}]);
	
	var VendorRecItmGrid = new Ext.grid.GridPanel({
		cm:VendorRecItmCm,
		store:VendorRecItmStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm2,
		loadMask : true,
		bbar : IngriToolBar	,
		deferRowRender : false
	});
	// 回车事件
	VendorRecItmGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			returnData();
		}
	});
	// 双击事件
	VendorRecItmGrid.on('rowdblclick', function() {
				returnData();
	});		
	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
		text : '返回',
		tooltip : '点击返回',
		iconCls : 'page_goto',
		handler : function() {
			returnData();
		}
	});

	var RetVendor=new Ext.form.ComboBox({
		fieldLabel : '选择退货供应商',
		id : 'RetVendor',
		anchor : '60%',
		width : 210,
		store:VendorForIncItmStore,
		valueField : 'RowId',
		displayField : 'Description',		
		editable:false,
		allowBlank : true,
		triggerAction : 'all',
		emptyText : '选择供应商',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		listWidth : 300,
		valueNotFoundText : '',
		listeners:{
			'select':function(cb,rec,index){
				queryIngri();
			}
		}
	});
	
	/**
	 * 返回数据
	 */
	function returnData() {
		var selectRows = VendorRecItmGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择一条批次信息！");
		}else if(selectRows.length>1){
			Msg.info("warning", "只能选择一条批次信息！");
		} else {
			flg = true;
			window.close();
		}
	}

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击关闭',
		iconCls : 'page_delete',
		handler : function() {
			flg = false;
			window.close();
		}
	});

	//设置供应商
	function setVendor(Vendor,VendorName)
	{
		if ((Vendor!='')&&(VendorName!=''))
		{
			Ext.getCmp("RetVendor").clearValue();			
			//构造record
			var rec=new Ext.data.Record({'RowId':Vendor,"Description":VendorName});			
			//插入record
			Ext.getCmp("RetVendor").getStore().add(rec);	
			Ext.getCmp("RetVendor").setValue(Vendor);
			Ext.getCmp("RetVendor").disabled=true;
		}
	}
	
	//检索供应商入库明细记录
	function queryIngri()
	{
		var loc='';
		var vendor='';
		var inci='';	
		var rec=PhaOrderGrid.getSelectionModel().getSelected();
		var inci=rec.get('InciDr');
		var vendor=Ext.getCmp('RetVendor').getValue();
		var loc=Locdr;
		var zeroFlag='Y';	//不显示零批次
		var strPar=loc+"^"+inci+"^"+vendor+"^"+zeroFlag;
		var pageSize=IngriToolBar.pageSize;
		VendorRecItmStore.setBaseParam('strPar',strPar);
		VendorRecItmStore.load({params:{start:0,limit:pageSize}});
	}
	
	if (Vendor!='')	{setVendor(Vendor,VendorName);}  //设定供应商
	
	var window = new Ext.Window({
		title : '科室库存项批次信息',
		width : 900,
		height : 600,
		layout : 'border',
		plain : true,
		tbar : [returnBT, '-', closeBT],
		modal : true,
		buttonAlign : 'center',
		autoScroll : true,
		items : [{
			region:'north',
			height:200,
			split:true,
			layout:'fit',
			items:PhaOrderGrid
		},{
			region:'center',
			layout:'fit',
			height:250,
			items:VendorRecItmGrid
		},{
			region:'south',
			layout:'form',
			frame:true,
			height:40,
			items:RetVendor
		}]
	});

	window.show();

	window.on('close', function(panel) {
		var selectRows = VendorRecItmGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Fn("");
		}  else {
			if (flg) {
				var batRecord=selectRows[0];
				Fn(batRecord);
			} else {
				Fn("");
			}
		}
	});
}