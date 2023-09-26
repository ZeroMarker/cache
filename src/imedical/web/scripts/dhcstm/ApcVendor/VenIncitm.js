// ����:		��Ӧ������˫����Ȩά��
// ��д����:	20190429
// ��д�ˣ�lihui

var VenInciUrl = 'dhcstm.venincitmaction.csp';
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];

//>>>>>>>>>>>>>>>��Ӧ��--������Ȩ>>>>>>>>>>>>>>>
var CodeField = {
	id : 'CodeField',
	xtype : 'textfield',
	fieldLabel : '����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '��Ӧ�̴���...'
};
	
var NameField = {
	id:'NameField',
	xtype : 'textfield',
	fieldLabel:'����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '��Ӧ������...'
};

var FindVenButton = {
	xtype : 'uxbutton',
	text : '��ѯ',
	iconCls : 'page_find',
	handler : function(){
		VendorGrid.load();
	}
}

var VendorCm = [{
		dataIndex : 'Venid',
		header : 'Venid',
		hidden : true
	},{
		dataIndex : 'Code',
		header : '��Ӧ�̴���',
		width : 150
	},{
		dataIndex : 'Name',
		header : '��Ӧ������',
		width : 260
	}
];

function VendorParamsFn(){
	var Code = Ext.getCmp("CodeField").getValue();
	var Name = Ext.getCmp("NameField").getValue();
	var Status = "A";
	var StrParam = Code + "^" + Name + "^" + Status;
	return {StrParam : StrParam};
}

function VendorRowSelFn(grid,rowIndex,r){
	var VendorId = r.get('Venid');
	var StrParam = VendorId;
	VenInciGrid.load({params:{StrParam:StrParam}});
}

var VendorGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'VendorGrid',
	title : '��Ӧ��',
	editable : false,
	childGrid : ["VenInciGrid"],
	contentColumns : VendorCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : VendorRowSelFn,
	autoLoadStore : true,
	actionUrl : VenInciUrl,
	queryAction : "GetAllVendor",
	idProperty : "Venid",
	checkProperty : "",
	paramsFn : VendorParamsFn,
	showTBar : false,
	tbar : [CodeField, ' ', NameField, ' ', FindVenButton]
});

VendorGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	VenInciGrid.removeAll();
});

var VenInciCm = [
	{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : 'IncId',
		dataIndex : 'IncId',
		hidden : true
	},{
		header : '���ʴ���',
		dataIndex : 'Incicode',
		width : 100
	},{
		header : '��������',
		dataIndex : 'Incidesc',
		width : 200
	}
];
var AddUnApcInciButton = {
	xtype : 'uxbutton',
	text : '���',
	iconCls : 'page_find',
	handler : function(){
		var rowdata=VendorGrid.getSelectionModel().getSelected();
		var venid=rowdata.get("Venid");
		if (Ext.isEmpty(venid)){Msg.info("warning","���ڹ�Ӧ���б�ѡ��һ����Ӧ��");return false;}
		SelectItmToApcInci(venid,RefreshVenInci);
	}
}
function StopApcInci(){
	var rowdata=VendorGrid.getSelectionModel().getSelected();
	var venid=rowdata.get("Venid");
	if (Ext.isEmpty(venid)){Msg.info("warning","���ڹ�Ӧ���б�ѡ��һ����Ӧ��");return false;}
	var apcinciRowData=VenInciGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(apcinciRowData)){Msg.info("warning","��ѡ��Ӧ��ȡ����Ȩ������");return false;}
	var RowIdStr="";
	for(var i=0;i<apcinciRowData.length;i++){
		var Rowid=apcinciRowData[i].get("RowId");
		if (RowIdStr==""){
			RowIdStr=Rowid;
		}else{
			RowIdStr=RowIdStr+"^"+Rowid;
		}
	}
	if (Ext.isEmpty(RowIdStr)){Msg.info("warning","��ѡ��Ӧ��ȡ����Ȩ������");return false;}
	Ext.Ajax.request({
		url:VenInciUrl + '?actiontype=StopInciVendor',
		params:{RowIdStr:RowIdStr},
		waitMsg:"������...",
		failure:function(result,request){
				Msg.info("error","�����������ӣ�");
			},
		success:function(result,request){
				var jsonData=Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=="true"){
					Msg.info("success","ȡ����Ȩ�ɹ�");
					RefreshVenInci();
				}else{
					Msg.info("error","ȡ����Ȩʧ��"+jsonData.info);
				}
			},
		scope:this
	});
	
}
var StopApcInciButton = {
	xtype : 'uxbutton',
	text : 'ȡ����Ȩ',
	iconCls : 'page_find',
	handler : function(){
		StopApcInci();
	}
}
var VenInciGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'VenInciGrid',
	title : '�����б�',
	region : 'center',
	contentColumns : VenInciCm,
	smType : "checkbox",
	singleSelect : false,
	selectFirst : false,
	actionUrl : VenInciUrl,
	queryAction : "GetVenInci",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	paging : true,
	tbar : [AddUnApcInciButton,StopApcInciButton]
});


function RefreshVenInci(){
	VenInciGrid.reload();
}

var VenInciPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[VenInciGrid]
});

//<<<<<<<<<<<<<<<��Ӧ��--������Ȩ<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>����--��Ӧ����Ȩ>>>>>>>>>>>>>>>
var IncidCm = [{
		dataIndex : 'InciRowid',
		header : 'InciRowid',
		hidden : true
	},{
		dataIndex : 'InciCode',
		header : '���ʴ���',
		width : 150
	},{
		dataIndex : 'InciDesc',
		header : '��������',
		width : 260
	}
];

function IncidRowSelFn(grid,rowIndex,r){
	var Incid = r.get('InciRowid');
	var StrParam = Incid+"^A";
	InciApcGrid.load({params:{StrParam:StrParam}});
	UnInciApcGrid.load({params:{StrParam:StrParam}});
}
var inciurl="dhcstm.druginfomaintainaction.csp";
var InciGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'InciGrid',
	title : '����',
	editable : false,
	childGrid : ["InciApcGrid", "UnInciApcGrid"],
	contentColumns : IncidCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : IncidRowSelFn,
	autoLoadStore : true,
	actionUrl : inciurl,
	queryAction : "GetItm",
	idProperty : "InciRowid",
	checkProperty : "",
	showTBar : false
});

InciGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	InciApcGrid.removeAll();
	UnInciApcGrid.removeAll();
});

var InciApcCm = [{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : 'Vendor',
		dataIndex : 'Vendor',
		hidden : true
	},{
		header : '��Ӧ������',
		dataIndex : 'VendorDesc',
		width : 200
	}
];

var InciApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'InciApcGrid',
	title : '��Ӧ���б�',
	region : 'west',
	width : 300,
	contentColumns : InciApcCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : VenInciUrl,
	queryAction : "GetInciApc",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	paging : true,
	remoteSort : true,
	listeners : {
		rowdblclick : StopInciVendor
	}
});
function StopInciVendor(){
	var RowIdStr = "";
	var RowData = InciApcGrid.getSelections();
	if(Ext.isEmpty(RowData)){
		Msg.info("warning","��ѡ����Ҫȡ����Ȩ�Ĺ�Ӧ��!");
		return;
	}else{
		for(var i=0,len=RowData.length; i<len; i++){
			var RowId = RowData[i].get('RowId');
			if(RowIdStr==""){
				RowIdStr = RowId;
			}else{
				RowIdStr = RowIdStr + "^" + RowId;
			}
		}
	}
	Ext.Ajax.request({
		url : VenInciUrl + '?actiontype=StopInciVendor',
		params : {RowIdStr : RowIdStr},
		waitMsg:'������...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","ȡ����Ȩ�ɹ�!");
				RefreshScgApc();
			}else{
				Msg.info("error","ȡ����Ȩʧ��!"+jsonData.info);
			}
		},
		scope: this
	});
}

var UnInciApcCm = [{
		header : 'Venid',
		dataIndex : 'Venid',
		hidden : true
	},{
		header : '��Ӧ������',
		dataIndex : 'Name',
		width : 200
	}
];

var UnInciApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnInciApcGrid',
	title : 'δ��Ȩ',
	region : 'east',
	width : 300,
	editable : false,
	contentColumns : UnInciApcCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : VenInciUrl,
	queryAction : "GetUnInciApc",
	idProperty : "venid",
	showTBar : false,
	paging : true,
	remoteSort : true,
	listeners : {
		rowdblclick : AddInciVendor
	}
});

function AddInciVendor(){
	var VendorIdStr = "";
	var RowData = UnInciApcGrid.getSelections();
	if(Ext.isEmpty(RowData)){
		Msg.info("warning","��ѡ����Ҫ��Ȩ�Ĺ�Ӧ��!");
		return;
	}else{
		for(var i=0,len=RowData.length; i<len; i++){
			var VenorId = RowData[i].get('Venid');
			if(VendorIdStr==""){
				VendorIdStr = VenorId;
			}else{
				VendorIdStr = VendorIdStr + "^" + VenorId;
			}
		}
	}
	var RowData = InciGrid.getSelected();
	if(Ext.isEmpty(RowData)){
		Msg.info("warning","��ѡ����Ҫ��Ȩ����!");
		return;
	}else{
		var Incid=RowData.get("InciRowid");
	}
	Ext.Ajax.request({
		url: VenInciUrl + '?actiontype=AddInciVendor',
		params: {Incid:Incid, VendorIdStr:VendorIdStr},
		failure: function(result, request) {
			Msg.info("error", "������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "����ɹ�!");
				RefreshScgApc();
			}else{
				var retinfo=jsonData.info;
				Msg.info("error", "����ʧ��!"+retinfo);
			}
		},
		scope: this
	});
}

function RefreshScgApc(){
	InciApcGrid.reload();
	UnInciApcGrid.reload();
}

var AddSomeVendor = {
	xtype : 'uxbutton',
	//text : '<<<',
	iconCls : 'tag_add',
	width : 45,
	handler : AddInciVendor
}

var ButtonSpaceScg = {
	xtype : 'spacer',
	height : 20
}

var StopSomeVendor = {
	xtype : 'uxbutton',
	//text : '>>',
	iconCls : 'tag_delete',
	width : 45,
	handler : StopInciVendor
}

var InciApcButtonPanel = {
	xtype : 'panel',
	region : 'center',
	layout : 'vbox',
	layoutConfig : {
		align : 'center',
		pack : 'center'
	},
	items : [AddSomeVendor, ButtonSpaceScg, StopSomeVendor]
};

var InciVenPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[InciApcGrid, InciApcButtonPanel, UnInciApcGrid]
});
// ���ʱ���
var M_InciCode = new Ext.form.TextField({
	fieldLabel : '<font color=blue>���ʱ���</font>',
	id : 'M_InciCode',
	name : 'M_InciCode',
	anchor : '90%',
	valueNotFoundText : '',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				search();
			}
		}
	}
});

// ��������
var M_InciDesc = new Ext.form.TextField({
	fieldLabel : '<font color=blue>��������</font>',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("M_StkGrpType").getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});
// ���ʱ���
var M_GeneName = new Ext.form.TextField({
	fieldLabel : '<font color=blue>���ʱ���</font>',
	id : 'M_GeneName',
	name : 'M_GeneName',
	anchor : '90%',
	valueNotFoundText : '',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				search();
			}
		}
	}
});
// ��������
var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
	fieldLabel:'<font color=blue>����</font>',
	id : 'M_StkGrpType',
	name : 'M_StkGrpType',
	StkType:App_StkTypeCode,     //��ʶ��������
	UserId:gUserId,
	LocId:gLocId,
	DrugInfo:"Y",
	anchor : '90%',
	//listWidth : 200,
	listeners:{
		'select':function(){
			Ext.getCmp("M_StkCat").setValue('');
		}
	}
});

// ������
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '<font color=blue>������</font>',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'StkCatName',
	params:{StkGrpId:'M_StkGrpType'}
});
var SearchBT = new Ext.Toolbar.Button({
	text : '��ѯ',
	tooltip : '�����ѯ',
	iconCls : 'page_find',
	width : 70,
	height : 30,
	handler : function() {
		search();
	}
});
function search(){
	InciGrid.getStore().removeAll();
	InciGrid.getView().refresh();
	var inciDesc = Ext.getCmp("M_InciDesc").getValue();
	var inciCode = Ext.getCmp("M_InciCode").getValue();
	var alias = Ext.getCmp("M_GeneName").getValue();
	var stkCatId = Ext.getCmp("M_StkCat").getValue();
	var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
	if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
		Msg.info("error", "��ѡ���ѯ����!");
		return false;
	}
	var allFlag=2;
	var Createday= "";
	var Updateday= "";
	//ҩѧ����id^ҩѧ����id^ҩѧ��С����id^����id^^^^^^^����ʱ��^����ʱ��
	var others = "^^^"+StkGrpType+"^^^^^^^"+Createday+"^"+Updateday;
	// ��ҳ��������
	InciGrid.getStore().setBaseParam('InciDesc',inciDesc);
	InciGrid.getStore().setBaseParam('InciCode',inciCode);
	InciGrid.getStore().setBaseParam('Alias',alias);
	InciGrid.getStore().setBaseParam('StkCatId',stkCatId);
	InciGrid.getStore().setBaseParam('AllFlag',allFlag);
	InciGrid.getStore().setBaseParam('Others',others);
	InciGrid.getStore().load();
}
var HisListTab = new Ext.ux.FormPanel({
	//labelWidth: 60,
	tbar : [SearchBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout: 'column',				
		style : 'padding:5px 0px 0px 5px',
		defaults : {border:false,xtype:'fieldset'},
		items : [{
			columnWidth: 0.5,
			items: [M_InciCode,M_InciDesc,M_GeneName]
		}, {
			columnWidth: 0.5,
			items : [M_StkGrpType,M_StkCat]
		}]
	}]
});
//<<<<<<<<<<<<<<<����--��Ӧ����Ȩ<<<<<<<<<<<<<<<

var VenInciTab = new Ext.TabPanel({
	region : 'center',
	activeTab : 0,
	items : [{
			title : '��Ӧ��--����',
			id : 'VenInciDetail',
			layout : 'border',
			items:[VendorGrid, VenInciPanel]
		},{
			title:'����--��Ӧ��',
			id:'InciVenDetail',
			layout:'border',
			items:[HisListTab,InciGrid, InciVenPanel]
		}]
})

Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'fit',
		items : [VenInciTab],
		renderTo:'mainPanel'
	});
});
