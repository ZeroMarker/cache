// 名称:凭证单查询
// 编写日期:2017-02-09
//=========================定义全局变量=================================

var gGroupId=session['LOGON.GROUPID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.payvoucheraction.csp';
var PayParamObj = GetAppPropValue('DHCSTPAYM');

var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	name:'LocField',
	fieldLabel:'科室',
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%',
	childCombo : 'Vendor'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...',
	params : {LocId : 'LocField'}
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'起始日期',
	
	anchor:'90%',
	value : new Date().add(Date.DAY, - 30)
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'截止日期',
	
	anchor:'90%',
	value:new Date()
});

var voucherno = new Ext.form.TextField({
	id:'voucherno',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'凭证号',
	anchor:'90%'
});

//业务类型
function Types(value){
    if (value=="G"){
	    return  '入库' ;
	}else if (value=="R"){
		return  '退货' ;
	}
}

var find = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择起始日期!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择截止日期!");
			return false;
		}
			
		var locId = Ext.getCmp('LocField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择申请部门!");
			return false;
		}
		var voucherno= Ext.getCmp('voucherno').getValue();
	
		var vendorId = Ext.getCmp('Vendor').getValue();	
		
		var strParam = locId+"^"+startDate+"^"+endDate+"^"+vendorId+"^"+voucherno;
		VoucherGridDs.setBaseParam('sort', 'RowId');
		VoucherGridDs.setBaseParam('dir', 'desc');
		VoucherGridDs.setBaseParam('strParam', strParam);
		VoucherGridDs.removeAll();
		VoucherGridDs.load({params:{start:0,limit:VoucherPagingToolbar.pageSize}});
		
	}
});

var clear = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('Vendor').setValue(""); 
		Ext.getCmp('voucherno').setValue("");
		Ext.getCmp('startDateField').setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp('endDateField').setValue(new Date());
		Ext.getCmp("VoucherGrid").getStore().removeAll();
		Ext.getCmp("RecRetGrid").getStore().removeAll();
		Ext.getCmp("RecRetDetailGrid").getStore().removeAll();
		VoucherGridDs.load({params:{start:0,limit:0}})
		RecRetGridDs.load({params:{start:0,limit:0}})
		RecRetDetailGridDs.load({params:{start:0,limit:0}});
	}
});

var delVoucher = new Ext.Toolbar.Button({
	text:'删除凭证',
	tooltip:'删除凭证',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var svcrowid="";
		if(VoucherGrid.getSelectionModel().getCount()==0){
			Msg.info("warning","请选择一条凭证记录!");
			return false;
		}
		var VoucherSels = VoucherGrid.getSelectionModel().getSelections();
		for(var i=0,len=VoucherSels.length;i<len;i++){
			var rowData = VoucherSels[i];
			svcrowid=rowData.data["svcrowid"];
		}
		Ext.MessageBox.confirm('提示','确定要删除选定的行?',
		function(btn){
			if(btn=="yes"){
				var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
				Ext.Ajax.request({
					url: URL+'?actiontype=DeleteVoucher&svcrowid='+svcrowid,
					failure: function(result, request) {
						mask.hide();
						Msg.info("error","请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						mask.hide();	
						if (jsonData.success=='true') {
							VoucherGridDs.removeAll();
	                        VoucherGridDs.reload();
							Msg.info("success","删除凭证成功");
						}
						else
						{
							Msg.info("warning","删除凭证失败");
						}
					},
					scope: this
				});
			}
		})
	}
});
var print = new Ext.Toolbar.Button({
	text:'打印',
	tooltip:'打印凭证',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		var svcrowid="";
		if(VoucherGrid.getSelectionModel().getCount()==0){
			Msg.info("warning","请选择一条凭证记录!");
			return false;
		}
		var VoucherSels = VoucherGrid.getSelectionModel().getSelections();
		for(var i=0,len=VoucherSels.length;i<len;i++){
			var rowData = VoucherSels[i];
			svcrowid=rowData.data["svcrowid"];
		}
		PrintPayVoucher(svcrowid);
	}
});

//=========================凭证单信息=================================

var Vouchernm=new Ext.grid.RowNumberer();

//配置数据源
var VoucherGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryvoucher'});
var VoucherFields=['svcrowid','svcVoucherNo','svcapcvm','svcdate','vendorid','vendorCode','type','loccode','locdesc','month','startdate','enddate','rpamt','spamt','scgcode','scgdesc'];
var VoucherGridDs = new Ext.data.Store({
	proxy:VoucherGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty : "results",
		id : "svcrowid",
		fields:VoucherFields
	}),
	remoteSort:false,
	listeners:{
		'load':function(store,recs,o)   {	
			Ext.getCmp('RecRetGrid').getStore().removeAll();
			Ext.getCmp('RecRetGrid').getView().refresh();
			Ext.getCmp('RecRetDetailGrid').getStore().removeAll();
			Ext.getCmp('RecRetDetailGrid').getView().refresh();
			VoucherGrid.getSelectionModel().selectFirstRow();
            RecRetGridDs.removeAll();
			strParam=""
			if(VoucherGridDs.getCount()>0)
			{
				var selectedRow = VoucherGridDs.data.items[0];
				svcrowid = selectedRow.data["svcrowid"];
				strParam = svcrowid;
			}
			RecRetGridDs.setBaseParam('sort', 'RowId');
			RecRetGridDs.setBaseParam('dir', 'desc');
			RecRetGridDs.setBaseParam('strParam', strParam);
			RecRetGridDs.removeAll();
			RecRetGridDs.load({params:{start:0,limit:RecRetPagingToolbar.pageSize}});			
		}   
	}
});
//模型
var VoucherGridCm = new Ext.grid.ColumnModel([Vouchernm,
	 {
		header:"svcrowid",
		dataIndex:'svcrowid',
		width:50,
		align:'left',
		sortable:true,
		hidden : true
	},{
		header:"凭证号",
		dataIndex:'svcVoucherNo',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"月份",
		dataIndex:'month',
		width:50,
		align:'left',
		sortable:true
	},{
		header:"供应商代码",
		dataIndex:'vendorCode',
		width:110,
		align:'left',
		sortable:true
	},{
		header:"供应商名称",
		dataIndex:'svcapcvm',
		width:160,
		align:'left',
		sortable:true
	},{
		header:"类型",
		dataIndex:'type',
		width:50,
		align:'left',
		sortable:true
	},{
		header:"开始日期",
		dataIndex:'startdate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"结束日期",
		dataIndex:'enddate',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"结算日期",
		dataIndex:'svcdate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"进价金额",
		dataIndex:'rpamt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"售价金额",
		dataIndex:'spamt',
		width:100,
		align:'right',
		sortable:true
	}
]);

//初始化默认排序功能
VoucherGridCm.defaultSortable = true;
var VoucherPagingToolbar = new Ext.PagingToolbar({
	store:VoucherGridDs,
	pageSize:20,
	displayInfo:true
});

//表格
VoucherGrid = new Ext.grid.EditorGridPanel({
	title:'凭证信息',
	region:'west',
	layout:'fit',
	width:450,
	split: true,
	collapsible: true,
	id:'VoucherGrid',
	store:VoucherGridDs,
	cm:VoucherGridCm,
	trackMouseOver:true,
	sm : new Ext.grid.RowSelectionModel({
			singleSelect : true
		}),
	stripeRows:true,	
	loadMask:true,	
	bbar:[VoucherPagingToolbar]
});
//=========================入库/退货单主信息=================================

//配置数据源
var RecRetGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=querygdrecbyvoucher',method:'GET'});
var RecRetFields=[
	{name:'RowId',mapping:'ingr'},
	{name:'gdNo',mapping:'gdNo'},
	{name:'RpAmt',mapping:'rpAmt'},
	{name:'ApprvFlag',mapping:'payAllowed'},
	{name:'CreateUser',mapping:'createUserName'},
	{name:'CreateDate',mapping:'createDate'},
	{name:'AuditUser',mapping:'gdAuditUserName'},
	{name:'AuditDate',mapping:'gdDate'},
	{name:'PayedFlag',mapping:'payOverFlag'},
	'type','AllowUser','AllowDate','AllowTime','Scg',
	'ScgDesc','vendorName','ordlocdesc','QtyAmt'
];
	
var RecRetGridDs = new Ext.data.Store({
	proxy:RecRetGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		id:'ingr',
		fields:RecRetFields
	}),
	listeners:{
		'load':function(store,recs,o) {
			Ext.getCmp('RecRetDetailGrid').getStore().removeAll();
			Ext.getCmp('RecRetDetailGrid').getView().refresh();
			RecRetGrid.getSelectionModel().selectFirstRow(); 
			
			RecRetDetailGridDs.removeAll();
	        var selectedRow = RecRetGridDs.data.items[0];
			var parref=""
			var type=""
			var pagesize=RecRetDetailToolbar.pageSize;
			if(RecRetGridDs.getCount()>0)
			{
				var selectedRow = RecRetGridDs.data.items[0];
				parref = selectedRow.data["RowId"];
			    type = selectedRow.data["type"];
			}
			RecRetDetailGridDs.setBaseParam('sort','RowId');
			RecRetDetailGridDs.setBaseParam('dir','desc');
			RecRetDetailGridDs.setBaseParam('InGrId',parref);
			RecRetDetailGridDs.setBaseParam('type',type);
			RecRetDetailGridDs.removeAll();
			RecRetDetailGridDs.load({params:{start:0,limit:pagesize}});
			
		}
	},
	remoteSort:true
});

var nm=new Ext.grid.RowNumberer();
var chkSm=new Ext.grid.CheckboxSelectionModel({
	listeners:{

	}
});
//模型 
var RecRetGridCm = new Ext.grid.ColumnModel([nm
	,{
		header:"RowId",
		dataIndex:'RowId',
		width:50,
		align:'left',
		sortable:true,
		hidden : true
	},{
		header:"供应商",
		dataIndex:'vendorName',
		width:300,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"接收科室",
		dataIndex:'ordlocdesc',
		width:140,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"单号",
		dataIndex:'gdNo',
		width:120,
		align:'left',
		sortable:true
	},{
		header:"类型",
		dataIndex:'type',
		width:40,
		align:'left',
		sortable:true,
		renderer:Types
	},{
		header:"类组",
		dataIndex:'ScgDesc',
		width:80,
		align:'left',
		sortable:true
	}
	,{
		header:"数量",
		dataIndex:'QtyAmt',
		width:70,
		align:'right',
		sortable:true
	},{
		header:"进价金额",
		dataIndex:'RpAmt',
		width:70,
		align:'right',
		sortable:true
	},{
		header:"审批标志",
		dataIndex:'ApprvFlag',
		width:70,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn',
		hidden:true
	},{
		header:"制单人",
		dataIndex:'CreateUser',
		width:60,
		align:'left',
		sortable:true
	},{
		header:"制单日期",
		dataIndex:'CreateDate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"审核人",
		dataIndex:'AuditUser',
		width:60,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"审核日期",
		dataIndex:'AuditDate',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"付清标志",
		dataIndex:'PayedFlag',
		width:70,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	},{
		header:"审批人",
		dataIndex:'AllowUser',
		width:80,
		sortable:true,
		hidden:true
	},{
		header:"审批日期",
		dataIndex:'AllowDate',
		width:80,
		sortable:true,
		hidden:true
	},{
		header:"审批时间",
		dataIndex:'AllowTime',
		width:80,
		sortable:true,
		hidden:true
	}
]);

var RecRetPagingToolbar = new Ext.PagingToolbar({
	store:RecRetGridDs,
	pageSize:20,
	displayInfo:true
});

//表格
var RecRetGrid = new Ext.grid.EditorGridPanel({
	title:'入库/退货单',
	region:'center',
	id:'RecRetGrid',
	store:RecRetGridDs,
	cm:RecRetGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:chkSm,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	bbar:RecRetPagingToolbar,
	listeners:{
		'rowclick':function(grid,rowIndex,e){
			var rec=grid.getStore().getAt(rowIndex)
			parref=rec.get('RowId');
			type=rec.get('type');
			var pagesize=RecRetDetailToolbar.pageSize;
			RecRetDetailGridDs.setBaseParam('sort','RowId');
			RecRetDetailGridDs.setBaseParam('dir','desc');
			RecRetDetailGridDs.setBaseParam('InGrId',parref);
			RecRetDetailGridDs.setBaseParam('type',type);
			RecRetDetailGridDs.removeAll();
			RecRetDetailGridDs.load({params:{start:0,limit:pagesize}});
		}
	}
});
//=========================入库/退货单明细=============================


//配置数据源
var RecRetDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryItem',method:'GET'});
var RecRetDetailFields=['RowId','IncId','IncCode','IncDesc','Spec','Manf','Qty','Uom','BatchNo','ExpDate','Rp','RpAmt','Sp','SpAmt','InvNo','InvDate','InvMoney','SxNo'];

var RecRetDetailGridDs = new Ext.data.Store({
	proxy:RecRetDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		id:'RowId',
		fields:RecRetDetailFields
	}),
	remoteSort:false
});
function toFixedTwo(val){
 	if(val==0||val==null&&val==undefined){
  	return '<div style="text-align: right">0.00</div>';      
 	}else{
 	 var values = Number(val).toFixed(2);
   	 }
 	return "<div style='text-align: right'>" + values + "</div>";
};
//模型
var RecRetDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "rowid",
		dataIndex : 'RowId',
		width : 60,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	},{
		header:"物资Id",
		dataIndex:'IncId',
		width:180,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"代码",
		dataIndex:'IncCode',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"名称",
		dataIndex:'IncDesc',
		width:200,
		align:'left',
		sortable:true
	},{
		header : '厂商',
		dataIndex : 'Manf',
		width : 170,
		align : 'left',
		sortable : true
	}, {
		header : "批号",
		dataIndex : 'BatchNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "有效期",
		dataIndex : 'ExpDate',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : '单位',
		dataIndex : 'Uom',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "数量",
		dataIndex : 'Qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header:"进价",
		dataIndex:'Rp',
		width:100,
		align:'right',
		sortable:true,
		renderer:toFixedTwo
	}, {
		header:"进价金额",
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		sortable:true,
		renderer:toFixedTwo
	}, {
		header : "售价",
		dataIndex : 'Sp',
		width : 80,
		align : 'right',
		sortable : true,
		renderer:toFixedTwo
	}, {
		header:"售价金额",
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		sortable:true,
		renderer:toFixedTwo
	},{
		header : "发票号",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : "发票日期",
		dataIndex : 'InvDate',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : "发票金额",
		dataIndex : 'InvMoney',
		width : 80,
		align : 'right',
		sortable : true,
		renderer:toFixedTwo
	},{
		header : "随行单号",
		dataIndex : 'SxNo',
		width : 80,
		align : 'left',
		sortable : true
	}
]);

//初始化默认排序功能
RecRetDetailGridCm.defaultSortable = true;

var RecRetDetailToolbar = new Ext.PagingToolbar({
	store:RecRetDetailGridDs,
	pageSize:20,
	displayInfo:true
});

//表格
RecRetDetailGrid = new Ext.grid.EditorGridPanel({
	deferredRender : true,
	title:'入库/退货明细信息',
	region:'south',
	height:220,
	layout:'fit',
	id:'RecRetDetailGrid',
	store:RecRetDetailGridDs,
	cm:RecRetDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel(),
	loadMask:true,
	clicksToEdit:1,
	bbar:RecRetDetailToolbar,
	viewConfig:{
		getRowClass : function(record,rowIndex,rowParams,store){ 
			var InvDate=record.get("InvDate");
			var dt=new Date().add(Date.DAY,-365).format(ARG_DATEFORMAT)
				if(dt>InvDate){
					return 'classRed';
				}
			}
	}
});

//-----------凭证单与入库/退货单间的联动-------------
VoucherGrid.on('rowclick',function(grid,rowIndex,e){
	RecRetGridDs.removeAll();
	var selectedRow = VoucherGridDs.data.items[rowIndex];
	svcrowid = selectedRow.data["svcrowid"];
	var strParam = svcrowid;
	RecRetGridDs.setBaseParam('sort', 'RowId');
	RecRetGridDs.setBaseParam('dir', 'desc');
	RecRetGridDs.setBaseParam('strParam', strParam);
	RecRetGridDs.removeAll();
	RecRetGridDs.load({params:{start:0,limit:RecRetPagingToolbar.pageSize}});
});


Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var MainPanel = new Ext.ux.FormPanel({
		title:'凭证查询',
		region:'north',
		tbar:[find,'-',delVoucher,'-',clear,'-',print],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			layout:'column',
			items:[{layout:'form',columnWidth:'0.25',items:[LocField,Vendor]}, 
					{layout:'form',columnWidth:'0.25',items:[startDateField,endDateField]},
					{layout:'form',columnWidth:'0.25',items:[voucherno]}
			]
		}]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[MainPanel,VoucherGrid,RecRetGrid,RecRetDetailGrid],
		renderTo:'mainPanel'
	});
});
