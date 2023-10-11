///Description:��汨��ͳ��
//==================UI===================//
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>'+$g('����')+'</font>',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	emptyText : $g('����...'),
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
	fieldLabel : '<font color=blue>'+$g('��ʼ����')+'</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%',
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>'+$g('��ֹ����')+'</font>',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%',
	value : new Date()
});

// ҩƷ����
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:$g('����'),
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
});

// ����ԭ��
var ScrapReasonField = new Ext.form.ComboBox({
	id:'ScrapField',
	fieldLabel:$g('����ԭ��'),
	listWidth:200,
	allowBlank:true,
	store:ReasonForScrapurnStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:$g('����ԭ��...'),
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
	fieldLabel : $g('ҩƷ����'),
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
	fieldLabel : $g('ҩƷRowId'),
	id : 'InciDr',
	name : 'InciDr',
	anchor : '90%',
	valueNotFoundText : ''
});
	
var findScrapBT = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindScrapStat();
	}
});

var printScrapBT = new Ext.Toolbar.Button({
	text:$g('��ӡ'),
    tooltip:$g('��ӡ'),
    iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		Print();
	}
});

var exportScrapBT = new Ext.Toolbar.Button({
	text:$g('���'),
    tooltip:$g('���'),
    iconCls:'page_export',
	width : 70,
	height : 30,
	handler:function(){
		Export();
	}
});

var clearScrapBT = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
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
	//autoHeight : true,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findScrapBT,'-',clearScrapBT,'-',printScrapBT,'-',exportScrapBT],
	items:[{
		xtype:'fieldset',
		title:$g('��ѯ����'),
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
			items:[ScrapReasonField,IncDesc]
		}]
	}]
});

var DetailStore=new Ext.data.JsonStore({
	autoDestroy:true,
	url:DictUrl+"scrapstataction.csp?actiontype=ScrapStat",
	storeId:'DetailStore',
	remoteSort:true,
	idProperty:'',
	root:'rows',
	totalProperty:'results',
	fields:['InciCode','InciDesc','ScrapUom','ScrapQty',
	'Rp','RpAmt','Sp','SpAmt','Manf','Spec'],
	baseParams:{
		ParStr:''
	}
});

var nm=new Ext.grid.RowNumberer();
var DetailCm=new Ext.grid.ColumnModel([nm,
    {
		header:$g('ҩƷ����'),
		dataIndex:'InciCode',
		width:100,
		sortable:false
	},{
		header:$g('ҩƷ����'),
		dataIndex:'InciDesc',
		width:200,
		sortable:true
	},{
		header:$g('��������'),
		dataIndex:'ScrapQty',
		width:80,
		align:'right',
		sortable:false
	},{
		header:$g('��λ'),
		dataIndex:'ScrapUom',
		width:80,
		align:'right',
		sortable:false
	},{
		header:$g('����'),
		dataIndex:'Rp',
		width:60,
		align:'right',
		sortable:false
	},{
		header:$g('���۽��'),
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		sortable:false
	},{
		header:$g('�ۼ�'),
		dataIndex:'Sp',
		width:60,
		align:'right',
		sortable:false
	},{
		header:$g('�ۼ۽��'),
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		sortable:false
	},{
		header:$g('������ҵ'),
		dataIndex:'Manf',
		width:200,
		sortable:false
	},{
		header:$g('���'),
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
	displayMsg:$g("��ǰ��¼{0}---{1}��  ��{2}����¼"),
	emptyMsg:$g("û������"),
	firstText:$g('��һҳ'),
	lastText:$g('���һҳ'),
	prevText:$g('��һҳ'),
	refreshText:$g('ˢ��'),
	nextText:$g('��һҳ')		
});
var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('������'),
    tooltip:$g('������'),
    iconCls:'page_gear',
    //	width : 70,
    //	height : 30,
	handler:function(){
		GridColSet(DetailGrid,"DHCSTSCRAPSTAT");
	}
    });
	
var DetailGrid=new Ext.grid.EditorGridPanel({
	title:$g('��ϸ'),
	id:'DetailGrid',
	height : 140,
	region:'center',
	store:DetailStore,
	stripeRows : true,
	loadMask:true,
	cm:DetailCm,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	takeMouseOver:true,
	bbar:PagingToolBar,
	tbar:[GridColSetBT]
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
	Ext.getCmp("ScrapField").setValue('');
	Ext.getCmp("InciDr").setValue('');
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	DetailGrid.store.removeAll();
}

/**
  *��ѯ
  */
function FindScrapStat()
{
	var StartDate=Ext.getCmp("DateFrom").getValue()
	var EndDate=Ext.getCmp("DateTo").getValue()
	if(StartDate==""||EndDate=="")
	{
		Msg.info("warning", $g("��ʼ���ںͽ�ֹ���ڲ��ܿգ�"));
		return;
	}
	var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();
	var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();
	var LocId=Ext.getCmp("PhaLoc").getValue();		

	if(LocId==null || LocId==""){
		Msg.info("warning",$g("���Ҳ���Ϊ��!"));
		return;
	}
	if(StartDate==null || StartDate==""){
		Msg.info("warning",$g("��ʼ���ڲ���Ϊ��!"));
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning",$g("��ֹ���ڲ���Ϊ��!"));
		return;
	}
	
	var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
	var ReasonDr=Ext.getCmp("ScrapField").getValue();			//����id
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
	DetailStore.load({params:{start:0,limit:pageSize}});
}

/**
 * ��ӡ
 */
function Print()
{
    var str=getParaList();
    if (str==""){return;}
	PrintScrapStat(str);
}

/**
 * ����
 */
function Export()
{
    var str=getParaList();
    if (str==""){return;}
	ExportScrapStat(str);
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
		Msg.info("warning",$g("���Ҳ���Ϊ��!"));
		return;
	}
	if(StartDate==null || StartDate==""){
		Msg.info("warning",$g("��ʼ���ڲ���Ϊ��!"));
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning",$g("��ֹ���ڲ���Ϊ��!"));
		return;
	}

	var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
	var ReasonDr=Ext.getCmp("ScrapField").getValue();			//����id
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
		title:$g('��汨��ͳ��'),
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