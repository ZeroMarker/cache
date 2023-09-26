// 2015-06-09
// �����п���ע���������а�

var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var gHospId = session['LOGON.HOSPID'];
var gInciId = '';
var BindBarcodeUrl = 'dhcstm.bindinclbbarcodeaction.csp'

var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '����',
	id : 'PhaLoc',
	anchor : '90%',
	emptyText : '����...',
	groupId : gGroupId,
	stkGrpId : 'StkGrpType'
});

var StkGrpType = new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	anchor : '90%',
	StkType : App_StkTypeCode,
	LocId : gLocId,
	UserId : gUserId
});

var InciCode = new Ext.form.TextField({
	fieldLabel : '���ʴ���',
	id : 'InciCode',
	anchor : '90%',
	disabled : true
});

var InciDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp('StkGrpType').getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		},
		blur : function(field){
			if(field.getValue() == ''){
				Ext.getCmp('InciCode').setValue('');
			}
		}
	}
});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, '', 'N', '0', gHospId, getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == '') {
		return;
	}
	gInciId = record.get('InciDr');
	var inciCode = record.get('InciCode');
	var inciDesc = record.get('InciDesc');
	Ext.getCmp('InciDesc').setValue(inciDesc);
	Ext.getCmp('InciCode').setValue(inciCode);
	SearchBT.handler();
}

var ExcludeZero = new Ext.form.Checkbox({
	hideLabel : true,
	boxLabel : '�ų�����',
	id : 'ExcludeZero',
	anchor : '90%',
	checked : true
});

var SearchBT = new Ext.Button({
	text : '��ѯ',
	iconCls : 'page_find',
	width : 70,
	height : 30,
	handler : function() {
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		if(PhaLoc == ''){
			Msg.info('warning', '���Ҳ���Ϊ��!');
			return false;
		}
		var Inci = Ext.getCmp('InciDesc').getValue()==''?'':gInciId;
		if(Inci == ''){
			Msg.info('warning', '�������Ʋ���Ϊ��!');
			return false;
		}
		var ExcludeZero = Ext.getCmp('ExcludeZero').getValue()?'Y':'N';
		var StrParam1 = PhaLoc + '^' + Inci + '^' + ExcludeZero;
		SearchInclbInfo(StrParam1);
		var StrParam2 = Inci + '^' + 'Y';
		SearchBarcodes(StrParam2);
	}
});

/**
 * ����������Ϣ
 */
function SearchInclbInfo(StrParam){
	InclbStore.setBaseParam('StrParam', StrParam);
	InclbStore.load({
		params : {start : 0, limit : 999},
		callback : function(r,options,success){
			if(!success){
				Msg.info('error','������Ϣ��ѯ����, ��鿴��־!');
			}
		}
	});
}

/**
 * ����ע��״̬��������Ϣ
 */
function SearchBarcodes(StrParam){
	NoBindStore.setBaseParam('StrParam', StrParam);
	NoBindStore.load({
		params : {start : 0, limit : 999},
		callback : function(r,options,success){
			if(!success){
				Msg.info('error','�����ѯ����, ��鿴��־!');
			}
		}
	});
}

/**
 * ���������Ѿ��󶨵�������Ϣ
 */
function SearchInclbBarcodes(StrParam){
	NoBindStore.setBaseParam('StrParam', StrParam);
	NoBindStore.load({
		params : {start : 0, limit : 999},
		callback : function(r,options,success){
			if(!success){
				Msg.info('error','�����ѯ����, ��鿴��־!');
			}
		}
	});
}

var SaveBT = new Ext.Button({
	text : '����',
	iconCls : 'page_save',
	width : 70,
	height : 30,
	handler : function() {
		BindInblbBarcode();
	}
});

function BindInblbBarcode(){
	var InclbSel = InclbGrid.getSelectionModel().getSelected();
	if(Ext.isEmpty(InclbSel)){
		Msg.info('error', '����ѡ��Ҫ�󶨵�����!');
		return false;
	}
	var Inclb = InclbSel.get('Inclb');
	var BindQty = InclbSel.get('BindQty');
	if(BindQty <=0){
		Msg.info('error', '������δ������Ϊ0!');
		return false;
	}
	
	var dhcitStr = '', dhcitCount = 0;
	var mr = BindStore.getModifiedRecords();
	for(var i=0, mrLen = mr.length; i < mrLen; i++){
		var Status = mr[i].get('Status');
		if(!Ext.isEmpty(Status)){
			continue;
		}
		dhcitCount++;
		var dhcit = mr[i].get('dhcit');
		if(dhcitStr == ''){
			dhcitStr = dhcit;
		}else{
			dhcitStr = dhcitStr + '^' + dhcit;
		}
	}
	if(dhcitCount == 0){
		Msg.info('warning', '��ѡ����Ҫ�󶨵���Ч����!');
		return false;
	}else if(dhcitCount > BindQty){
		Msg.info('error', 'Ԥ��������������δ������!');
		return false;
	}
	
	Ext.Ajax.request({
		url : BindBarcodeUrl + '?actiontype=Save',
		params : {inclb : Inclb, dhcitStr : dhcitStr},
		waitMsg : 'ɾ����...',
		failure : function(result, request) {
			Msg.info('error', '������������!');
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success == 'true') {
				Msg.info('success', '�󶨳ɹ�!');
				BindStore.reload();
				NoBindStore.reload();
				var BindedEnableQty = accAdd(InclbSel.get('BindedEnableQty'), dhcitCount);
				var BindQty = accSub(InclbSel.get('BindQty'), dhcitCount);
				InclbSel.set('BindedEnableQty', BindedEnableQty);
				InclbSel.set('BindQty', BindQty);
			}else{
				var info = jsonData.info;
				Msg.info('error','��ʧ��:' + info);
			}
		},
		scope : this
	});
}

var ClearBT = new Ext.Button({
	text : '���',
	iconCls : 'page_clearscreen',
	width : 70,
	height : 30,
	handler : function() {
		clearPanel(HisListTab);
		gInciId = '';
		Ext.getCmp('ExcludeZero').setValue(true);
		InclbStore.removeAll();
		BindStore.removeAll();
		NoBindStore.removeAll();
	}
});

var HisListTab = new Ext.ux.FormPanel({
	id : 'HisListTab',
	labelWidth : 60,
	title : '���п�������',
	tbar : [SearchBT, '-', SaveBT, '-',ClearBT],
	items:[{
		xtype:'fieldset',
		title:'�����Ϣ',
		style:'padding:1px 0px 0px 10px',
		layout: 'column',
		defaults: {border:false},
		items : [{
			columnWidth: 0.3,
			xtype: 'fieldset',
			items: [PhaLoc, StkGrpType]
		},{
			columnWidth: 0.25,
			xtype: 'fieldset',
			items: [InciCode, InciDesc]
		},{
			columnWidth: 0.2,
			xtype: 'fieldset',
			items: [ExcludeZero]
		}]
	}]
});

var InclbStore = new Ext.data.JsonStore({
	url : BindBarcodeUrl + '?actiontype=GetInclbInfo',
	totalProperty : 'results',
	root : 'rows',
    fields : ['Inclb', 'BatchNo', 'ExpDate', 'InclbQty', 'AvaQty',
    		'BindedEnableQty', 'BindQty']
});

//ģ��
var InclbGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'Inclb',
		dataIndex : 'Inclb',
		hidden : true
	}, {
		header : '����',
		dataIndex : 'BatchNo',
		width : 160,
		sortable : true
	}, {
		header : 'Ч��',
		dataIndex : 'ExpDate',
		width : 80,
		sortable : true
	}, {
		header : '���ο��',
		dataIndex : 'InclbQty',
		width : 80,
		align : 'right'
	}, {
		header : '��������',
		dataIndex : 'AvaQty',
		width : 80,
		align : 'right'
	}, {
		header : '�Ѱ󶨿�����������',
		dataIndex : 'BindedEnableQty',
		width : 120,
		align : 'right'
	}, {
		header : 'δ������',
		dataIndex : 'BindQty',
		width : 80,
		align : 'right'
	}
]);

var InclbSm = new Ext.grid.RowSelectionModel({
	singleSelect:true,
	listeners:{
		'rowselect':function(sm,rowIndex,r){
			var Inclb = InclbStore.getAt(rowIndex).get('Inclb');
			var NullStatus = 'N';	//ȡ״̬�ǿյĿ�������
			var StrParam = Inclb + '^' + NullStatus;
			BindStore.setBaseParam('StrParam', StrParam);
			BindStore.load({
				params : {start : 0, limit : 999},
				callback : function(r, options, success){
					if(!success){
						Msg.info('warning', '�Ѱ������ѯ����, ���ʵ!');
					}
				}
			});
		}
	}
});

var InclbGrid = new Ext.ux.GridPanel({
	region : 'center',
	width : 500,
	id : 'InclbGrid',
	title : '������Ϣ',
	store : InclbStore,
	sm : InclbSm,
	cm : InclbGridCm,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true
});

var BindStore = new Ext.data.JsonStore({
	url : BindBarcodeUrl + '?actiontype=GetBarcodes',
	totalProperty : 'results',
	root : 'rows',
    fields : ['dhcit', 'HVBarcode', 'Status'],
    pruneModifiedRecords : true
});

//ģ��
var BindGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'dhcit',
		dataIndex : 'dhcit',
		hidden : true
	}, {
		header : '��ֵ����',
		dataIndex : 'HVBarcode',
		width : 200
	}, {
		header : '����״̬',
		dataIndex : 'Status',
		renderer : statusRenderer,
		width : 60
	}
]);

var BindGrid = new Ext.grid.GridPanel({
	region : 'west',
	width : 300,
	id : 'BindGrid',
	title : 'Ԥ������',
	store : BindStore,
	sm : new Ext.grid.RowSelectionModel(),
	cm : BindGridCm,
	viewConfig : {forceFit : true},
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	listeners : {
		rowdblclick : DelBarcodes
	}
});

var NoBindStore = new Ext.data.JsonStore({
	url : BindBarcodeUrl + '?actiontype=GetBarcodes',
	totalProperty : 'results',
	root : 'rows',
    fields : ['dhcit', 'HVBarcode', 'Status']
});

//ģ��
var NoBindGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'dhcit',
		dataIndex : 'dhcit',
		hidden : true
	}, {
		header : '��ֵ����',
		dataIndex : 'HVBarcode',
		width : 200
	}, {
		header : '����״̬',
		dataIndex : 'Status',
		width : 60,
		hidden : true
	}, {
		header : '����״̬',
		dataIndex : 'Status',
		width : 60
	}
]);

var NoBindGrid = new Ext.grid.GridPanel({
	region : 'east',
	width : 300,
	id : 'NoBindGrid',
	title : 'δ������',
	store : NoBindStore,
	sm : new Ext.grid.RowSelectionModel(),
	cm : NoBindGridCm,
	viewConfig : {forceFit : true},
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	listeners : {
		rowdblclick : AddBarcodes
	}
});

var AddSome = {
	xtype : 'uxbutton',
	//text : '<<<',
	iconCls : 'tag_add',
	width : 45,
	handler : AddBarcodes
}
var ButtonSpace = {
	xtype : 'spacer',
	height : 20
}
var DelSome = {
	xtype : 'uxbutton',
	//text : '>>',
	iconCls : 'tag_delete',
	width : 45,
	handler : DelBarcodes
}

function AddBarcodes(){
	BindStore.add(NoBindGrid.getSelectionModel().getSelections());
	BindGrid.getView().refresh();
	NoBindStore.remove(NoBindGrid.getSelectionModel().getSelections());
	NoBindGrid.getView().refresh();
}
function DelBarcodes(){
	var SelRecords = BindGrid.getSelectionModel().getSelections();
	var tmpSelRecords = SelRecords.concat();
	for(var i = 0, len = SelRecords.length; i < len; i++){
		if(!Ext.isEmpty(SelRecords[i].get('Status'))){
			tmpSelRecords.remove(SelRecords[i]);
		}
	}
	NoBindStore.add(tmpSelRecords);
	NoBindGrid.getView().refresh();
	BindStore.remove(tmpSelRecords);
	BindGrid.getView().refresh();
}

var ButtonPanel = {
	xtype : 'panel',
	region : 'center',
	layout : 'vbox',
	layoutConfig : {
		align : 'center',
		pack : 'center'
	},
	items : [AddSome, ButtonSpace, DelSome]
};

var HVBarcodePanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[BindGrid, ButtonPanel, NoBindGrid]
});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, InclbGrid, HVBarcodePanel],
		renderTo : 'mainPanel'
	});
});