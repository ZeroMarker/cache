
// /描述: 付款单制单
// /编写者：gwj
// /编写日期: 2012.09.24

var payRowId="";
var URL="dhcst.payaction.csp"
var gGroupId=session['LOGON.GROUPID'];

// 入库科室
var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '采购科室',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor:'90%',
	width : 120,
	emptyText : '采购科室...',
	groupId:gGroupId
});

// 登录设置默认值
//SetLogInDept(GetGroupDeptStore, "PhaLoc");

// 供货厂商
var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...'
});
			
// 起始日期
var StartDate = new Ext.ux.DateField({
	fieldLabel : '起始日期',
	id : 'StartDate',
	name : 'StartDate',
	anchor : '90%',
	value : new Date().add(Date.DAY, - 30)
});
// 截止日期
var EndDate = new Ext.ux.DateField({
	fieldLabel : '截止日期',
	id : 'EndDate',
	name : 'EndDate',
	anchor : '90%',
	value : new Date()
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
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "请选择采购科室!");
		return;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	var startDate = Ext.getCmp("StartDate").getRawValue();
	var endDate = Ext.getCmp("EndDate").getRawValue();
	
	
	//var purno = Ext.getCmp("PurNo").getValue();
	
	
	var CmpFlag = "Y";
	//开始日期^截止日期^科室id^供应商id
	var ListParam=startDate+'^'+endDate+'^'+phaLoc+'^'+vendor;
	var Page=GridPagingToolbar.pageSize;
	//MasterStore.load({params:{start:0, limit:Page,strParam:ListParam}});
	MasterStore.load();
		MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
	
	//DetailGrid.store.removeAll();
	//DetailGrid.getView().refresh();
}

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
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
	Ext.getCmp("PhaLoc").setValue("");
	Ext.getCmp("Vendor").setValue("");
	
	MasterGrid.store.removeAll();
	MasterGrid.store.load({params:{start:0,limit:0}})
	MasterGrid.getView().refresh();
	
	DetailGrid.store.removeAll();
	DetailGrid.store.load({params:{start:0,limit:0}})
	DetailGrid.getView().refresh();
}

// 采购确认按钮
var Ack1BT = new Ext.Toolbar.Button({
	id : "Ack1BT",
	text : '采购确认',
	tooltip : '点击确认',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		SetAck1();
	}
});
// 会计确认按钮
var Ack2BT = new Ext.Toolbar.Button({
	id : "Ack2BT",
	text : '会计确认',
	tooltip : '点击确认',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		SetAck2();
	}
});
/**
 * 采购确认付款单
 */
function SetAck1() {
	var rec=MasterGrid.getSelectionModel().getSelected();
	if (rec==undefined) {return;}
	var PayId=rec.get('RowId');
	if (PayId=='')  {return; }
	
	var url = URL	+ "?actiontype=SetAck1&PayId=" + PayId ;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '更新中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 确认单据
				Msg.info("success", "确认成功!");
				Query();
			} else {
				var Ret=jsonData.info;
				if(Ret==-2){
					Msg.info("error", "此付款单未完成!");
				}else if(Ret==-3){
					Msg.info("error", "此付款单已经确认!");
				}else if(Ret==-1){
					Msg.info("error", "未找到此付款单!");
				}else{
					Msg.info("error", "确认失败:");
				}
			}
		},
		scope : this
	});
}	

function ExecuteAck2(rowid,paymodeInfo)
{
	var url = URL+ "?actiontype=SetAck2&PayId=" + rowid +"&PayInfo=" + paymodeInfo;		
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '更新中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 确认单据
				Msg.info("success", "确认成功!");
				Query();
			} else {
				var Ret=jsonData.info;
				if(Ret==-2){
					Msg.info("error", "此付款单未完成!");
				}else if(Ret==-3){
					Msg.info("error", "此付款单已经确认!");
				}else if(Ret==-1){
					Msg.info("error", "未找到此付款单!");
				}else{
					Msg.info("error", "确认失败:"+Ret);
				}
			}
		},
		scope : this
	});

}


/**
 * 会计确认付款单
 */
function SetAck2() {
	var rowData=MasterGrid.getSelectionModel().getSelected();	
	if (rowData==undefined) {return;}
	payRowId=rowData.get('RowId');
	if (payRowId=='')  {return; }
	
	var IfAlReadyAck=tkMakeServerCall("web.DHCST.DHCPayQuery","GetPayInfo",payRowId).split("^")[1];
	if(IfAlReadyAck=="Y"){
		Msg.info("error", "此付款单会计已经确认!");
		return;
	}
	
	if (payRowId!=""){
		 
		var vendorName= rowData.get("vendorName");
		var payNo= rowData.get("payNo");
		var payAmt= rowData.get("payAmt");
		var PayNoinfo=payNo+"^"+vendorName+"^"+payAmt;
		SetInfo(PayNoinfo);   //确认附加信息
	}
}	

// 访问路径
var MasterUrl = URL	+ '?actiontype=query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
	url : MasterUrl,
	method : "POST"
});
// 指定列参数
var fields = [{name:"RowId",mapping:'pay'}, "PurNo", "payNo", "locDesc", "vendorName","payDate", "payTime","payUserName","payAmt",
{name:"ack1Flag",mapping:'ack1'}, "ack1UserName","ack1Date", {name:"ack2Flag",mapping:'ack2'}, "ack2UserName","ack2Date","PoisonFlag","payMode","checkNo","checkDate","checkAmt",{name:"completed",mapping:'payComp'}];
// 支持分页显示的读取方式
var mReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : fields
});
// 数据集
var MasterStore = new Ext.data.Store({
	proxy : proxy,
	reader : mReader,
	remoteSort:true,
	listeners:{					
		'beforeload':function(store){
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			var vendor = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
	
			var completed="Y"  ;   //完成标志="Y"
			var ListParam=startDate+'^'+endDate+'^'+phaLoc+'^'+vendor+'^'+completed;
				var Page=GridPagingToolbar.pageSize;
				MasterStore.baseParams={start:0, limit:Page,strParam:ListParam};
				
			//MasterStore.load({params:{}})
		}
	}
});
var nm = new Ext.grid.RowNumberer();
var MasterCm = new Ext.grid.ColumnModel([nm, {
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "付款单号",
		dataIndex : 'payNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "采购科室",
		dataIndex : 'locDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "供应商",
		dataIndex : 'vendorName',
		width : 190,
		align : 'center',
		sortable : true,
		align:'left'
	}, {
		header : "制单日期",
		dataIndex : 'payDate',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "制单时间",
		dataIndex : 'payTime',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "制单人",
		dataIndex : 'payUserName',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "付款金额",
		dataIndex : 'payAmt',
		width : 90,
		sortable : true,
		align:'right'
	},{
		header : "完成标志",
		dataIndex : 'completed',
		width : 50,
		align : 'center'
		//,
		//xtype:'booleancolumn',
		//falseText:'否',
		//trueText:'是'
	}, {
		header : "是否采购确认",
		dataIndex : 'ack1Flag',
		width : 100,
		align : 'center',
		sortable : true					
	}, {
		header : "采购确认人",
		dataIndex : 'ack1UserName',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "采购确认日期",
		dataIndex : 'ack1Date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "是否会计确认",
		dataIndex : 'ack2Flag',
		width : 100,
		align : 'center',
		sortable : true
		
	}, {
		header : "会计确认人",
		dataIndex : 'ack2UserName',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "会计确认日期",
		dataIndex : 'ack2Date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "毒麻标志",
		dataIndex : 'PoisonFlag',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "支付方式",
		dataIndex : 'payMode',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "支付票据号",
		dataIndex : 'checkNo',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "支付票据日期",
		dataIndex : 'checkDate',
		width : 100,
		align : 'left',
		sortable : true
		
	}, {
		header : "支付票据金额",
		dataIndex : 'checkAmt',
		width : 100,
		align : 'left',
		sortable : true,
		align:'right'
	}
]);
	
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
				singleSelect : true
			}),
	store : MasterStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:GridPagingToolbar
});

// 添加表格单击行事件
MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
	var PayId = MasterStore.getAt(rowIndex).get("RowId");
	//alert(PayId);
	DetailStore.setBaseParam('parref',PayId)
	DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize}});
});

// 转移明细
// 访问路径
var DetailUrl =  URL
			+ '?actiontype=queryItem';;;
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// 指定列参数
var fields = ["RowId", "pointer","TransType","INCI","inciCode","inciDesc", "spec", "manf", "qty",
		 "uomDesc", "rp", "sp","rpAmt","spAmt","OverFlag", "invNo", "invDate", "invAmt","batNo", "ExpDate"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : fields
});
// 数据集
var DetailStore = new Ext.data.Store({
	proxy : proxy,
	reader : reader,
	remoteSort:true
});
var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "入库退货Id",
		dataIndex : 'pointer',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "药品Id",
		dataIndex : 'INCI',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '药品代码',
		dataIndex : 'inciCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '药品名称',
		dataIndex : 'inciDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "规格",
		dataIndex : 'spec',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "厂商",
		dataIndex : 'manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "数量",
		dataIndex : 'qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "单位",
		dataIndex : 'uomDesc',
		width : 80,
		align : 'left',
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
		header : "进价金额",
		dataIndex : 'rpAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : "售价金额",
		dataIndex : 'spAmt',
		width : 100,
		align : 'right',
		
		sortable : true
	}, {
		header : "结清标志",
		dataIndex : 'OverFlag',
		width : 80,
		align : 'center',
		sortable : true
	}, {
		header : "发票号",
		dataIndex : 'invNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "发票日期",
		dataIndex : 'invDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "发票金额",
		dataIndex : 'invAmt',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "批号",
		dataIndex : 'batNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "效期",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "类型",
		dataIndex : 'TransType',
		width : 100,
		align : 'left',
		sortable : true
	}]);
var GridDetailPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});
var DetailGrid = new Ext.grid.GridPanel({
	title : '',
	height : 200,
	cm : DetailCm,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	bbar:GridDetailPagingToolbar,
	loadMask : true
});

var HisListTab = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	tbar : [SearchBT, '-', ClearBT, '-', Ack1BT, '-', Ack2BT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout:'column',
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{ 				
				columnWidth: 0.25,
				layout:'form',
				items: [PhaLoc]			
			},{ 				
				columnWidth: 0.35,
				layout:'form',
				items: [Vendor]
			},{ 				
				columnWidth: 0.2,
				layout:'form',
				items: [StartDate]				
			},{ 				
				columnWidth: 0.2,
				layout:'form',
				items: [EndDate]
			}]	
	}]
	  // Specifies that the items will now be arranged in columns
});				
	
//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 页面布局
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [            // create instance immediately
			{   
				title: '付款单管理',		
				region: 'north',
				height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
				layout: 'fit', // specify layout manager for items
				items:HisListTab
			}, {
				region: 'center',
				title: '付款单',			               
				layout: 'fit', // specify layout manager for items
				items: MasterGrid       
			   
			}, {
				region: 'south',
				split: true,
				height: 300,
				minSize: 200,
				maxSize: 350,
				collapsible: true,
				title: '付款单明细',
				layout: 'fit', // specify layout manager for items
				items: DetailGrid       
			   
			}
		],
		renderTo : 'mainPanel'
	});
});
//===========模块主页面=============================================