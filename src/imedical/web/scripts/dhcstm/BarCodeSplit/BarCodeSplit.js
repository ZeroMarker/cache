// /����: ���������ȡ��Ϣά��(һ�����ʿɶ�Ӧ�������)
// /��д�ߣ�wangjiabin
// /��д����: 2015.08.18

var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var actionUrl = DictUrl + 'barcodesplitaction.csp';
var G_INCI = '';

var StkGrpType = new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	anchor : '90%',
	StkType : App_StkTypeCode,
	LocId : gLocId,
	UserId : UserId,
	childCombo : 'StkCat'
});

var StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'StkCat',
	store : StkCatStore,
	params : {StkGrpId : 'StkGrpType'}
});

var InciCode = new Ext.form.TextField({
	fieldLabel : '���ʴ���',
	id : 'InciCode',
	anchor : '90%',
	disabled : true,
	valueNotFoundText : ''
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
		blur : function(field) {
			if (field.getValue() == '') {
				G_INCI = '';
				Ext.getCmp('InciCode').setValue('');
			}
		}
	}
});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, '', 'N', '0', '',getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == '') {
		return;
	}
	G_INCI = record.get('InciDr');
	var inciCode = record.get('InciCode');
	var inciDesc = record.get('InciDesc');
	Ext.getCmp('InciCode').setValue(inciCode);
	Ext.getCmp('InciDesc').setValue(inciDesc);
}

var InciBarCode = new Ext.form.TextField({
	id : 'InciBarCode',
	fieldLabel : '��������',
	anchor : '90%',
	listeners : {
		specialKey : function(field, e){
			if(e.getKey() == Ext.EventObject.ENTER){
				MasterGrid.load();
			}
		}
	}
});

// ��ѯ��ť
var SearchBT = new Ext.Toolbar.Button({
	id:'SearchBT',
	text : '��ѯ',
	tooltip : '�����ѯ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		MasterGrid.load();
	}
});

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
	id:'ClearBT',
	text : '���',
	tooltip : '������',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});

function clearData() {
	clearPanel(HisListTab);
	G_INCI = '';
	MasterGrid.removeAll();
}

var SaveBT = new Ext.ux.Button({
	id:'SaveBT',
	text : '����',
	tooltip : '�����ֵ������Ϣ',
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});

function Save(){
	var ListDetail = MasterGrid.getModifiedInfo();
	if(ListDetail == ''){
		Msg.info('warning', 'û����Ҫ���������');
		return false;
	}
	var loadMask = ShowLoadMask(Ext.getBody(), '������...');
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=Save',
		params : {ListDetail : ListDetail, UserId : gUserId},
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '����ɹ�!');
				MasterGrid.reload();
			} else {
				var Ret=jsonData.info;
				Msg.info('error', '����ʧ��:'+Ret);
			}
		},
		scope : this
	});
}

var HisListTab = new Ext.ux.FormPanel({
	title:'���������ȡ��Ϣά��',
	tbar : [SearchBT, '-', ClearBT, '-', SaveBT],
	items:[{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults : {border:false,xtype:'fieldset'},
		items : [{
				columnWidth: 0.25,
				items: [StkGrpType, StkCat, InciBarCode]
			},{
				columnWidth: 0.25,
				items: [InciCode, InciDesc]
			},{
				columnWidth : 0.5,
				html : "<font color=blue>1. ά��Ч����ʼλ�ú�������ʼλ��, ��������."
					+ "<br>��������(01)00613994819994(17)161214(10)0007260386, Ч����ʼλ��,Ч�ڳ���,������ʼλ��,���ų��ȷֱ�Ϊ19,6,27,10."
					+ "<br>2. ���������Ǳ����, ����ѡ��. ����Щ��Ϣ����д, Ч����ʼλ�����������+3, Ч�ڳ���Ĭ��Ϊ6, ������ʼλ����Ч�ں���+3, ����Ĭ�ϵ�ɨ����������һλ."
					+ "<br>3. ����������û��Ч����Ϣʱ, Ч�ڳ�������0; ��ʱ, ��������ʼλ��Ϊ��, Ĭ���������+9."
					+ "</font>"
			}]
	}]
});

function GetPhaOrderInfo2(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, '', 'N', '0', '',getDrugList2);
	}
}

function getDrugList2(record) {
	if (record == null || record == '') {
		return;
	}
	var InciId = record.get('InciDr');
	var InciCode = record.get('InciCode');
	var InciDesc = record.get('InciDesc');
	var cell = MasterGrid.getSelectedCell();
	var rowData = MasterGrid.getAt(cell[0]);
	rowData.set('InciId', InciId);
	rowData.set('InciCode', InciCode);
	rowData.set('InciDesc', InciDesc);
	var row = MasterGrid.getSelectedCell()[0];
	var col = GetColIndex(MasterGrid,'SplitBarCode');
	MasterGrid.startEditing(row, col);
}

var SpecCombo = new Ext.form.ComboBox({
	fieldLabel : '������',
	id : 'SpecCombo',
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '������...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listeners: {
		'beforequery' : function(){
			var cell = MasterGrid.getSelectionModel().getSelectedCell();
			var record = MasterGrid.getStore().getAt(cell[0]);
			var InciId = record.get("InciId");
			var desc=this.getRawValue();
			this.store.removeAll();
			this.store.setBaseParam('SpecItmRowId',InciId);
			this.store.setBaseParam('desc',desc)
			this.store.load({params:{start:0,limit:this.pageSize}})
		},
		'specialkey' : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				MasterGrid.addNewRow();
			}
		}
	}
});

var MasterCm = [{
		saveColIndex : 0,
		header : 'SplitId',
		dataIndex : 'SplitId',
		width : 60,
		hidden : true
	}, {
		saveColIndex : 1,
		header : 'InciId',
		dataIndex : 'InciId',
		width : 120,
		sortable : true,
		hidden : true
	}, {
		header : '���ʴ���',
		dataIndex : 'InciCode',
		width : 100,
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'InciDesc',
		width : 140,
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var group = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo2(field.getValue(), group);
					}
				}
			}
		}))
	}, {
		saveColIndex : 2,
		header : '��������',
		dataIndex : 'SplitBarCode',
		width : 180,
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var code = field.getValue();
						var BarCodeObj = GetBarCodeSplitInfo(code);
						var BarCode = BarCodeObj['Code'];
						field.setValue(BarCode);
						var row = MasterGrid.getSelectedCell()[0];
						var col = GetColIndex(MasterGrid,'ExpStartPosition');
						MasterGrid.startEditing(row, col);
					}
				}
			}
		}))
	}, {
		saveColIndex : 3,
		header : 'Ч����ʼλ��',
		dataIndex : 'ExpStartPosition',
		width : 100,
		align : 'right',
		editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : true,
			allowNegative : false,
			allowDecimals : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = MasterGrid.getSelectedCell()[0];
						var col = GetColIndex(MasterGrid,'ExpLength');
						MasterGrid.startEditing(row, col);
					}
				}
			}
		}))
	}, {
		saveColIndex : 4,
		header : 'Ч�ڳ���',
		dataIndex : 'ExpLength',
		width : 80,
		align : 'right',
		editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : true,
			allowNegative : false,
			allowDecimals : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = MasterGrid.getSelectedCell()[0];
						var col = GetColIndex(MasterGrid,'BatStartPosition');
						MasterGrid.startEditing(row, col);
					}
				}
			}
		}))
	}, {
		saveColIndex : 5,
		header : '������ʼλ��',
		dataIndex : 'BatStartPosition',
		width : 100,
		align : 'right',
		editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : true,
			allowNegative : false,
			allowDecimals : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = MasterGrid.getSelectedCell()[0];
						var col = GetColIndex(MasterGrid,'BatLength');
						MasterGrid.startEditing(row, col);
					}
				}
			}
		}))
	}, {
		saveColIndex : 6,
		header : '���ų���',
		dataIndex : 'BatLength',
		width : 80,
		align : 'right',
		editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : true,
			allowNegative : false,
			allowDecimals : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = MasterGrid.getSelectedCell()[0];
						var col = GetColIndex(MasterGrid,'ProStartPosition');
						MasterGrid.startEditing(row, col);
					}
				}
			}
		}))
	}, {
		saveColIndex : 7,
		header : '����������ʼλ��',
		dataIndex : 'ProStartPosition',
		width : 100,
		align : 'right',
		editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : true,
			allowNegative : false,
			allowDecimals : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = MasterGrid.getSelectedCell()[0];
						var col = GetColIndex(MasterGrid,'ProLength');
						MasterGrid.startEditing(row, col);
					}
				}
			}
		}))
	}, {
		saveColIndex : 8,
		header : '�������ڳ���',
		dataIndex : 'ProLength',
		width : 80,
		align : 'right',
		editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : true,
			allowNegative : false,
			allowDecimals : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = MasterGrid.getSelectedCell()[0];
						var col = GetColIndex(MasterGrid,'SpecDesc');
						MasterGrid.startEditing(row, col);
					}
				}
			}
		}))
	}, {
		saveColIndex : 9,
		header : '������',
		dataIndex : 'SpecDesc',
		width : 180,
		sortable : true,
		editor : new Ext.grid.GridEditor(SpecCombo),
		renderer : Ext.util.Format.comboRenderer2(SpecCombo, 'SpecDesc', 'SpecDesc')
	}, {
		header : '��������',
		dataIndex : 'SplitUpdateDate',
		width : 80
	}, {
		header : '����ʱ��',
		dataIndex : 'SplitUpdateTime',
		width : 80
	}, {
		header : '������',
		dataIndex : 'SplitUpdateUser',
		width : 80
	}, {
		header : 'ʹ�ñ��',
		dataIndex : 'UsedFlag',
		xtype : 'checkcolumn',
		isPlugin : false
	}
];

var MasterGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'MasterGrid',
	title : '����������Ϣ',
	region : 'center',
	editable : true,
	contentColumns : MasterCm,
	smType : 'cell',
	singleSelect : true,
	autoLoadStore : false,
	actionUrl : actionUrl,
	queryAction : 'Query',
	paramsFn : GetMasterParams,
	idProperty : 'SplitId',
	checkProperty : 'InciId',
	delRowAction : "Delete",
	delRowParam : "RowId",
	showTBar : true,
	listeners : {
		beforeedit : function(e){
			if(e.record.get('UsedFlag') == 'Y'){
				return false;
			}
		}
	}
});

function GetMasterParams(){
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var StkCat = Ext.getCmp('StkCat').getValue();
	var InciDesc = Ext.getCmp('InciDesc').getValue();
	if(InciDesc == ''){
		G_INCI = '';
	}
	if(!Ext.isEmpty(G_INCI)){
		InciDesc = '';
	}
	var InciBarCode = Ext.getCmp('InciBarCode').getValue();
	var StrParam = StkGrpType + '^' + StkCat + '^' + G_INCI + '^' + InciBarCode + '^' + InciDesc;
	return {'Sort' : '', 'Dir' : '','StrParam' : StrParam};
}

Ext.onReady(function() {
	Ext.QuickTips.init();
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab,MasterGrid],
		renderTo : 'mainPanel'
	});
	
	MasterGrid.load();
});