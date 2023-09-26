// 名称:付款封面制单
// 编写日期:2017-10-20
//=========================定义全局变量=================================

var gGroupId=session['LOGON.GROUPID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.paycoveraction.csp';
var CvrID="" 
//保存参数值的object
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

var ordlocField = new Ext.ux.LocComboBox({
	id:'ordlocField',
	fieldLabel:'医嘱接收科室',
	anchor:'90%',
	defaultLoc:{}
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
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'截止日期',
	
	anchor:'90%',
	value:new Date()
});

var totalrp = new Ext.form.TextField({
	fieldLabel : '金额合计',
	width:200,
	id : 'totalrp',
	name : 'totalrp',
	anchor : '100%',
	readOnly : true
});

function getTotalrp(){   
	var selarr = RecRetGrid.getSelectionModel().getSelections();
	var totalrp=0
	var totalqty=0
	for (var i = 0; i < selarr.length; i++) {
		var rowData = selarr[i];
		var Rp = rowData.get("RpAmt");
		var Qty= rowData.get("QtyAmt");
		totalrp=accAdd(totalrp,Rp)
		totalqty=accAdd(totalqty,Qty)
	}
	Ext.getCmp("totalrp").setValue("数量:"+totalqty+" 金额合计:"+totalrp);
}

var INVNnmber = new Ext.form.TextField({
	id:'INVNnmber',
	fieldLabel:'发票号',
	allowBlank:true,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

var onlyRequest = new Ext.form.Checkbox({
	id: 'onlyRequest',
	fieldLabel:'仅申请计划',
	allowBlank:true
});

var InvoiceField = new Ext.form.Radio({ 
	id:'InvoiceField',
	name:'InvoiceCondition',
	checked:true,
	boxLabel:'有发票'  
});

var noInvoiceField = new Ext.form.Radio({  
	id:'noInvoiceField',
	name:'InvoiceCondition',
	boxLabel:'无发票'  
});

var allInvoiceField = new Ext.form.Radio({ 
	id:'allInvoiceField',
	name:'InvoiceCondition',
	boxLabel:'全部'
});

var hvField = new Ext.form.Radio({ 
	id:'hvField',
	name:'hvCondition',
	boxLabel:'仅高值'  
});

var noHvField = new Ext.form.Radio({  
	id:'noHvField',
	name:'hvCondition',
	boxLabel:'仅低值'  
});

var allHvField = new Ext.form.Radio({ 
	id:'allHvField',
	name:'hvCondition',
	boxLabel:'全部',
	checked:true
});
	
	
var IncludeRet = new Ext.form.Checkbox({
	id: 'IncludeRet',
	boxLabel:'包含退货',
	anchor:'100%',
	allowBlank:true
});

var IncludeGift = new Ext.form.Checkbox({
	id:'IncludeGift',
	fieldLabel:'包含赠送',
	anchor:'90%',
	allowBlank:true
});

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
			Msg.info("error","请选择部门!");
			return false;
		}
		var ordloc= Ext.getCmp('ordlocField').getValue();
	
		var vendorId = Ext.getCmp('Vendor').getValue();	
		var IncludeRetflag = (Ext.getCmp('IncludeRet').getValue()==true?'Y':'N');
		var IncludeGiftflag = (Ext.getCmp('IncludeGift').getValue()==true?'Y':'N');	
		var INVNnmber=Ext.getCmp('INVNnmber').getValue();

		var Inv="";
		var Inv1 = Ext.getCmp('InvoiceField').getValue();
		var Inv2 = Ext.getCmp('noInvoiceField').getValue();
		Inv = (Inv1==true?'Y':(Inv2==true?'N':''));
		var Hv="";
		var Hv1 = Ext.getCmp('hvField').getValue();
		var Hv2 = Ext.getCmp('noHvField').getValue();
		Hv = (Hv1==true?'Y':(Hv2==true?'N':''));
		var strParam = locId+"^"+startDate+"^"+endDate+"^"+vendorId+"^"+IncludeRetflag
			+"^"+IncludeGiftflag+"^"+Inv+"^"+INVNnmber+"^"+Hv+"^"+ordloc;
		RecRetGridDs.setBaseParam('sort', 'RowId');
		RecRetGridDs.setBaseParam('dir', 'desc');
		RecRetGridDs.setBaseParam('strParam', strParam);
		RecRetGridDs.removeAll();
		RecRetGridDs.load({params:{start:0,limit:RecRetPagingToolbar.pageSize}});
	}
});

var clear = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('IncludeRet').setValue(false);
		Ext.getCmp('IncludeGift').setValue(false);
		Ext.getCmp('INVNnmber').setValue("");
		Ext.getCmp('Vendor').setValue("");	
		Ext.getCmp("RecRetGrid").getStore().removeAll();
		Ext.getCmp("RecRetGrid").getView().refresh();		
        CvrID="" 	
		RecRetGridDs.load({params:{start:0,limit:0}})
	}
});

var SaveBT = new Ext.Toolbar.Button({
	text:'生成付款封面',
	tooltip:'生成付款封面',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		save();
	}
});

function save(){
	if(RecRetGrid.getSelectionModel().getCount()==0){
		Msg.info("warning","请选择入库/退货单!");
		return false;
	}
	var RecRetSels = RecRetGrid.getSelectionModel().getSelections();
	var ListDetail="";
	for(var i=0,len=RecRetSels.length;i<len;i++){
		var rowData = RecRetSels[i];
		var IngrId=rowData.data["RowId"];
		var type=rowData.data["type"];
		var str=IngrId+"^"+type
		if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
	}
	var locId = Ext.getCmp('LocField').getValue();
	Audio(ListDetail,locId)
}

function Audio(ListDetail,locId){
	if((ListDetail!="")&&(ListDetail!=null)){
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: URL+'?actiontype=Save',
			params:{ListDetail:ListDetail,UserId:UserId,LocId:locId},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","生成付款封面!");
					CvrID=jsonData.info
					refreshRecList();
				}else{
						Msg.info("error","生成付款封面失败!");
				}
			},
			scope: this
		});
	}
}

var UpdateBT = new Ext.Toolbar.Button({
	text:'添加封面信息',
	tooltip:'添加封面信息',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		Update();
	}
});

function Update(){
	if(RecRetGrid.getSelectionModel().getCount()==0){
		Msg.info("warning","请选择入库/退货单!");
		return false;
	}
	if(CvrID==""){
	    Msg.info("warning","没有需要添加明细的付款封面!");
		return false;
	}
	var RecRetSels = RecRetGrid.getSelectionModel().getSelections();
	var ListDetail="";
	for(var i=0,len=RecRetSels.length;i<len;i++){
		var rowData = RecRetSels[i];
		var IngrId=rowData.data["RowId"];
		var type=rowData.data["type"];
		var str=IngrId+"^"+type
		if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
	}
	var locId = Ext.getCmp('LocField').getValue();
	UpdateCover(ListDetail,locId)
}

function UpdateCover(ListDetail,locId){
	if((ListDetail!="")&&(ListDetail!=null)){
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: URL+'?actiontype=Update',
			params:{ListDetail:ListDetail,UserId:UserId,LocId:locId,CvrID:CvrID},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","成功添加付款封面明细!");
					refreshRecList();
				}else{
						Msg.info("error","添加付款封面明细失败!");
				}
			},
			scope: this
		});
	}
}

function ClearDataVoucher()
{
	Ext.getCmp("RecRetGrid").getStore().removeAll();
	Ext.getCmp("RecRetGrid").getView().refresh();
}



//=========================入库/退货单主信息=================================

//=========================入库/退货单明细=============================
//配置数据源
var RecRetGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=querygdrec',method:'GET'});
var RecRetFields=[
		{name:'RowId',mapping:'ingr'},
		{name:'gdNo',mapping:'gdNo'},
		{name:'RpAmt',mapping:'rpAmt'},
		{name:'SpAmt',mapping:'spAmt'},
		{name:'CreateUser',mapping:'createUserName'},
		{name:'CreateDate',mapping:'createDate'},
		{name:'AuditUser',mapping:'gdAuditUserName'},
		{name:'AuditDate',mapping:'gdDate'},
		'type','Scg','ScgDesc','vendorName',
		'ordlocdesc','QtyAmt'
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
			
		}
	},
	remoteSort:true
});

var nm=new Ext.grid.RowNumberer();
var chkSm=new Ext.grid.CheckboxSelectionModel({
	listeners:{
		selectionchange:function(){
			getTotalrp()
		} 
	}
});
//模型
var RecRetGridCm = new Ext.grid.ColumnModel([nm,chkSm
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
		sortable:true
	},{
		header:"接收科室",
		dataIndex:'ordlocdesc',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"单号",
		dataIndex:'gdNo',
		width:220,
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
		sortable:true
	},{
		header:"审核日期",
		dataIndex:'AuditDate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"售价金额",
		dataIndex:'SpAmt',
		width:70,
		align:'right',
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
	region:'center',
	title:'入库/退货单',
	id:'RecRetGrid',
	store:RecRetGridDs,
	cm:RecRetGridCm,
	tbar:['->','合计:','-',totalrp],
	trackMouseOver:true,
	stripeRows:true,
	sm:chkSm,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	bbar:RecRetPagingToolbar
});

function refreshRecList()
{
	RecRetGridDs.removeAll();
	RecRetGridDs.reload();
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var col5={
		columnWidth: 0.15,
		xtype: 'fieldset',
		defaultType: 'textfield',
		autoHeight: true,
		border: false,
		items:[IncludeRet,IncludeGift]
	};
	
	var MainPanel = new Ext.ux.FormPanel({
		title:'付款封面制单',
		tbar:[find,'-',SaveBT,'-',UpdateBT,'-',clear], //,'-',noApproval
		layout: 'fit',
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			autoHeight:true,
			layout:'column',
			items:[{layout:'form',columnWidth:'0.25',items:[LocField,Vendor,INVNnmber]},  ///,IncludeGift]},
					{layout:'form',columnWidth:'0.25',items:[startDateField,endDateField],labelWidth:100},
					{layout:'form',columnWidth:'0.1',labelWidth:15,items:[allInvoiceField,InvoiceField,noInvoiceField]},
					{layout:'form',columnWidth:'0.1',labelWidth:15,items:[allHvField,hvField,noHvField]},
					{layout:'form',columnWidth:'0.2',items:[IncludeRet]}
				]
		}]
	});

	
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[MainPanel,RecRetGrid],
		renderTo:'mainPanel'
	});
});
