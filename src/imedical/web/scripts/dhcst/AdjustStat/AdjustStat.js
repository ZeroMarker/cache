///Description:������ͳ��
//==================UI===================//
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>����</font>',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	emptyText : '����...',
	groupId:gGroupId,
		listeners : {
			'select' : function(e) {
              var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
              StkGrpField.getStore().removeAll();
              StkGrpField.getStore().setBaseParam("locId",SelLocId)
              StkGrpField.getStore().setBaseParam("userId",UserId)
              StkGrpField.getStore().setBaseParam("type",App_StkTypeCode)
              StkGrpField.getStore().load();
			}
	}
});

var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ʼ����</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%',
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ֹ����</font>',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%',
	value : new Date()
});

// ҩƷ����
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'����',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
});

// ����ԭ��
var AdjReasonField = new Ext.form.ComboBox({
	id:'AdjustField',
	fieldLabel:'����ԭ��',
	listWidth:200,
	allowBlank:true,
	store:ReasonForAdjustMentStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'����ԭ��...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:200,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	anchor:'90%'
});

ReasonForAdjustMentStore.load();

var IncDesc = new Ext.form.TextField({
	fieldLabel : 'ҩƷ����',
	id : 'IncDesc',
	name : 'IncDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stkGrp=Ext.getCmp("StkGrpType").getValue();
				var inputText=field.getValue();
				GetPhaOrderInfo(inputText,stkGrp);
			}
		}
	}
});

var InciDr = new Ext.form.TextField({
	fieldLabel : 'ҩƷRowId',
	id : 'InciDr',
	name : 'InciDr',
	anchor : '90%',
	valueNotFoundText : ''
});
	
var findINAdjBT = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindAdjustStat();
	}
});

var printAdjBT = new Ext.Toolbar.Button({
	text:'��ӡ',
    tooltip:'��ӡ',
    iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		Print();
	}
});

var exportINAdjBT = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_export',
	width : 70,
	height : 30,
	handler:function(){
		Export();
	}
});

var clearINAdjBT = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		ClearData();
	}
});

var formPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	labelAlign : 'right',
	autoScroll:true,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findINAdjBT,'-',clearINAdjBT,'-',printAdjBT,'-',exportINAdjBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout:'column',
		style:'padding:5px 0px 0px 0px',
		defaults:{border:false},
		items:[{
			columnWidth:0.25,
			xtype:'fieldset',
			defaults:{width:200},
			items:[DateFrom,DateTo]
		},{
			columnWidth:0.25,
			xtype:'fieldset',
			defaults:{width:120},
			items:[PhaLoc,StkGrpField]
		},{
			columnWidth:0.25,
			xtype:'fieldset',
			defaults:{width:120},
			items:[AdjReasonField,IncDesc]
		}]
	}]
});

var DetailStore=new Ext.data.JsonStore({
	autoDestroy:true,
	url:DictUrl+"adjuststataction.csp?actiontype=AdjustStat",
	storeId:'DetailStore',
	remoteSort:true,
	idProperty:'',
	root:'rows',
	totalProperty:'results',
	fields:['InciCode','InciDesc','AdjUom','AdjQty','bAdjQty','bUomDesc',
	'Rp','RpAmt','Sp','SpAmt','Manf','Spec'],
	baseParams:{
		ParStr:''
	}
});

var nm=new Ext.grid.RowNumberer();
var DetailCm=new Ext.grid.ColumnModel([nm,
    {
		header:'ҩƷ����',
		dataIndex:'InciCode',
		width:100,
		sortable:true
	},{
		header:'ҩƷ����',
		dataIndex:'InciDesc',
		width:200,
		sortable:true
	},{
		header:'��������',
		dataIndex:'AdjQty',
		width:80,
		align:'right',
		sortable:true
	},{
		header:'��λ',
		dataIndex:'AdjUom',
		width:80,
		align:'right',
		sortable:false
	},{
		header:'��������(����)',
		dataIndex:'bAdjQty',
		width:100,
		align:'right',
		sortable:false
	},{
		header:'��λ(����)',
		dataIndex:'bUomDesc',
		width:80,
		align:'right',
		sortable:false
	},{
		header:'����',
		dataIndex:'Rp',
		width:60,
		align:'right',
		sortable:false
	},{
		header:'���۽��',
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:'�ۼ�',
		dataIndex:'Sp',
		width:60,
		align:'right',
		sortable:false
	},{
		header:'�ۼ۽��',
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:'����',
		dataIndex:'Manf',
		width:200,
		sortable:false
	},{
		header:'���',
		dataIndex:'Spec',
		width:100,
		sortable:false
	}	
]);

var PagingToolBar=new Ext.PagingToolbar({
	id:'PagingToolBar',
	store:DetailStore,
	displayInfo:true,
	pageSize:PageSize,
	displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
	emptyMsg:"û������",
	firstText:'��һҳ',
	lastText:'���һҳ',
	prevText:'��һҳ',
	refreshText:'ˢ��',
	nextText:'��һҳ'		
});
	
var DetailGrid=new Ext.grid.GridPanel({
	title:'��ϸ',
	id:'DetailGrid',
	height : 140,
	region:'center',
	store:DetailStore,
	stripeRows : true,
	loadMask:true,
	cm:DetailCm,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	takeMouseOver:true,
	bbar:PagingToolBar
});

//=======================================//

//==================Events===============//
/**
 * ����ҩƷ���岢���ؽ��
 */
function GetPhaOrderInfo(item, group) {
				
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
				getDrugList);
	}
}

/**
 * ���ط���
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	
	Ext.getCmp("InciDr").setValue(inciDr);
	Ext.getCmp("IncDesc").setValue(inciDesc);
}

/**
 * ���
 */
function ClearData()
{
	Ext.getCmp("PhaLoc").setValue(gLocId);
	Ext.getCmp("DateFrom").setValue(new Date());
	Ext.getCmp("DateTo").setValue(new Date());
	Ext.getCmp("AdjustField").setValue('');
	Ext.getCmp("InciDr").setValue('');
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	DetailGrid.store.removeAll();
}

/**
  *��ѯ
  */
function FindAdjustStat()
{
	var StartDate=Ext.getCmp("DateFrom").getValue()
	var EndDate=Ext.getCmp("DateTo").getValue()
	if(StartDate==""||EndDate=="")
	{
		Msg.info("warning", "��ʼ���ںͽ�ֹ���ڲ��ܿգ�");
		return;
	}
	var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
	var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
	var LocId=Ext.getCmp("PhaLoc").getValue();		

	if(LocId==null || LocId==""){
		Msg.info("warning","���Ҳ���Ϊ��!");
		return;
	}
	if(StartDate==null || StartDate==""){
		Msg.info("warning","��ʼ���ڲ���Ϊ��!");
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning","��ֹ���ڲ���Ϊ��!");
		return;
	}
	
	var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
	var ReasonDr=Ext.getCmp("AdjustField").getValue();			//����id
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	var IncRowid="";
	if(IncDesc!=null&IncDesc!=""){
		IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
		if (IncRowid == undefined) {
			IncRowid = "";
		}
	}
	
	var ParStr=StartDate+"^"+EndDate+"^"+"G"+"^"+LocId+"^"+IncRowid+"^"+ReasonDr+"^"+GrpType;
	var pageSize=PagingToolBar.pageSize;
	DetailStore.setBaseParam("ParStr",ParStr);
	DetailStore.load({params:{start:0,limit:pageSize,sort:"",dir:""}});
}

/**
 * ��ӡ
 */
function Print()
{
    var str=getParaList();
    if (str==""){return;}
	PrintAdjustStat(str);
}

/**
 * ����
 */
function Export()
{
    var str=getParaList();
    if (str==""){return;}
	ExportAdjustStat(str);
}


/**
 * ׼����ѯ���ӡ����
 */
function getParaList()
{
	var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
	var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
	var LocId=Ext.getCmp("PhaLoc").getValue();
	var LocDesc=Ext.getCmp("PhaLoc").getRawValue();		
	
	if(LocId==null || LocId==""){
		Msg.info("warning","���Ҳ���Ϊ��!");
		return;
	}
	if(StartDate==null || StartDate==""){
		Msg.info("warning","��ʼ���ڲ���Ϊ��!");
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning","��ֹ���ڲ���Ϊ��!");
		return;
	}

	var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
	var ReasonDr=Ext.getCmp("AdjustField").getValue();			//����id
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	var IncRowid="";
	if(IncDesc!=null&IncDesc!=""){
		IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
		if (IncRowid == undefined) {
			IncRowid = "";
		}
	}
    var User=session['LOGON.USERNAME'];
	var ParStr=StartDate+"^"+EndDate+"^"+"G"+"^"+LocId+"^"+IncRowid+"^"+ReasonDr+"^"+GrpType+"^"+LocDesc+"^"+User;
	return ParStr;
}
//=======================================//

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	var panel = new Ext.Panel({
		title:'������ͳ��',
		activeTab:0,
		layout:'fit',
		region:'north',
		height:170,
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,DetailGrid],
		renderTo:'mainPanel'
	});
});