// ����:��������Ƶ�
// ��д����:2017-10-20
//=========================����ȫ�ֱ���=================================

var gGroupId=session['LOGON.GROUPID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.paycoveraction.csp';
var CvrID="" 
//�������ֵ��object
var PayParamObj = GetAppPropValue('DHCSTPAYM');

var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	name:'LocField',
	fieldLabel:'����',
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%',
	childCombo : 'Vendor'
});

var ordlocField = new Ext.ux.LocComboBox({
	id:'ordlocField',
	fieldLabel:'ҽ�����տ���',
	anchor:'90%',
	defaultLoc:{}
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...',
	params : {LocId : 'LocField'}
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'��ʼ����',
	
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'��ֹ����',
	
	anchor:'90%',
	value:new Date()
});

var totalrp = new Ext.form.TextField({
	fieldLabel : '���ϼ�',
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
	Ext.getCmp("totalrp").setValue("����:"+totalqty+" ���ϼ�:"+totalrp);
}

var INVNnmber = new Ext.form.TextField({
	id:'INVNnmber',
	fieldLabel:'��Ʊ��',
	allowBlank:true,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

var onlyRequest = new Ext.form.Checkbox({
	id: 'onlyRequest',
	fieldLabel:'������ƻ�',
	allowBlank:true
});

var InvoiceField = new Ext.form.Radio({ 
	id:'InvoiceField',
	name:'InvoiceCondition',
	checked:true,
	boxLabel:'�з�Ʊ'  
});

var noInvoiceField = new Ext.form.Radio({  
	id:'noInvoiceField',
	name:'InvoiceCondition',
	boxLabel:'�޷�Ʊ'  
});

var allInvoiceField = new Ext.form.Radio({ 
	id:'allInvoiceField',
	name:'InvoiceCondition',
	boxLabel:'ȫ��'
});

var hvField = new Ext.form.Radio({ 
	id:'hvField',
	name:'hvCondition',
	boxLabel:'����ֵ'  
});

var noHvField = new Ext.form.Radio({  
	id:'noHvField',
	name:'hvCondition',
	boxLabel:'����ֵ'  
});

var allHvField = new Ext.form.Radio({ 
	id:'allHvField',
	name:'hvCondition',
	boxLabel:'ȫ��',
	checked:true
});
	
	
var IncludeRet = new Ext.form.Checkbox({
	id: 'IncludeRet',
	boxLabel:'�����˻�',
	anchor:'100%',
	allowBlank:true
});

var IncludeGift = new Ext.form.Checkbox({
	id:'IncludeGift',
	fieldLabel:'��������',
	anchor:'90%',
	allowBlank:true
});

function Types(value){
    if (value=="G"){
	    return  '���' ;
	}else if (value=="R"){
		return  '�˻�' ;
	}
}

var find = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
			
		var locId = Ext.getCmp('LocField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ����!");
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
	text:'���',
	tooltip:'���',
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
	text:'���ɸ������',
	tooltip:'���ɸ������',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		save();
	}
});

function save(){
	if(RecRetGrid.getSelectionModel().getCount()==0){
		Msg.info("warning","��ѡ�����/�˻���!");
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
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url: URL+'?actiontype=Save',
			params:{ListDetail:ListDetail,UserId:UserId,LocId:locId},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","���ɸ������!");
					CvrID=jsonData.info
					refreshRecList();
				}else{
						Msg.info("error","���ɸ������ʧ��!");
				}
			},
			scope: this
		});
	}
}

var UpdateBT = new Ext.Toolbar.Button({
	text:'��ӷ�����Ϣ',
	tooltip:'��ӷ�����Ϣ',
	iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		Update();
	}
});

function Update(){
	if(RecRetGrid.getSelectionModel().getCount()==0){
		Msg.info("warning","��ѡ�����/�˻���!");
		return false;
	}
	if(CvrID==""){
	    Msg.info("warning","û����Ҫ�����ϸ�ĸ������!");
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
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url: URL+'?actiontype=Update',
			params:{ListDetail:ListDetail,UserId:UserId,LocId:locId,CvrID:CvrID},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","�ɹ���Ӹ��������ϸ!");
					refreshRecList();
				}else{
						Msg.info("error","��Ӹ��������ϸʧ��!");
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



//=========================���/�˻�������Ϣ=================================

//=========================���/�˻�����ϸ=============================
//��������Դ
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
//ģ��
var RecRetGridCm = new Ext.grid.ColumnModel([nm,chkSm
	,{
		header:"RowId",
		dataIndex:'RowId',
		width:50,
		align:'left',
		sortable:true,
		hidden : true
	},{
		header:"��Ӧ��",
		dataIndex:'vendorName',
		width:300,
		align:'left',
		sortable:true
	},{
		header:"���տ���",
		dataIndex:'ordlocdesc',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'gdNo',
		width:220,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'type',
		width:40,
		align:'left',
		sortable:true,
		renderer:Types
	},{
		header:"����",
		dataIndex:'ScgDesc',
		width:80,
		align:'left',
		sortable:true
	}
	,{
		header:"����",
		dataIndex:'QtyAmt',
		width:70,
		align:'right',
		sortable:true
	},{
		header:"���۽��",
		dataIndex:'RpAmt',
		width:70,
		align:'right',
		sortable:true
	},{
		header:"�Ƶ���",
		dataIndex:'CreateUser',
		width:60,
		align:'left',
		sortable:true
	},{
		header:"�Ƶ�����",
		dataIndex:'CreateDate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"�����",
		dataIndex:'AuditUser',
		width:60,
		align:'left',
		sortable:true
	},{
		header:"�������",
		dataIndex:'AuditDate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"�ۼ۽��",
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

//���
var RecRetGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	title:'���/�˻���',
	id:'RecRetGrid',
	store:RecRetGridDs,
	cm:RecRetGridCm,
	tbar:['->','�ϼ�:','-',totalrp],
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
		title:'��������Ƶ�',
		tbar:[find,'-',SaveBT,'-',UpdateBT,'-',clear], //,'-',noApproval
		layout: 'fit',
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
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
