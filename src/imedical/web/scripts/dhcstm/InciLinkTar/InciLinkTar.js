// ����:�Ʒ�����������
// ��д����:2015-03-27

var gTarItemRowId = '';
var InciLinkTarUrl = 'dhcstm.incilinktaraction.csp';

var QueryTarButton = new Ext.Button({
	id : 'QueryTarButton',
	text : '��ѯ',
	height : 30,
	width : 70,
	iconCls : 'page_find',
	handler : function(){
		QueryTar();
	}
});

function QueryTar(){
	var TarCode = Ext.getCmp('TarCode').getValue();
	var TarDesc = Ext.getCmp('TarDesc').getValue();
	var NoInciFlag = Ext.getCmp('NoInciFlag').getValue()? 1 : 0;
	var SubTypeFee=Ext.getCmp('SubTypeFee').getValue();
	var InSubTypeFee=Ext.getCmp('InSubTypeFee').getValue();
	var OutSubTypeFee=Ext.getCmp('OutSubTypeFee').getValue();
	var AccSubTypeFee=Ext.getCmp('AccSubTypeFee').getValue();
	var MedSubTypeFee=Ext.getCmp('MedSubTypeFee').getValue();
	var AccountSubTypeFee=Ext.getCmp('AccountSubTypeFee').getValue();
	
	var StrParam = TarCode + '^' + TarDesc + '^' + NoInciFlag + '^' + SubTypeFee + '^' + InSubTypeFee
		+ '^' + OutSubTypeFee + '^' + AccSubTypeFee + '^' + MedSubTypeFee + '^' + AccountSubTypeFee;
	TarItemStore.setBaseParam('StrParam',StrParam);
	var pageSize = TarItemPagingbar.pageSize;
	TarItemStore.load({
		params : {start:0,limit:pageSize}
	});
}

var ClearButton = new Ext.Button({
	id : 'ClearButton',
	text : '���',
	height : 30,
	width : 70,
	iconCls : 'page_clearscreen',
	handler : function(){
		clearPanel(TarItemForm);
		Ext.getCmp('NoInciFlag').setValue(true);
		TarItemStore.baseParams = null;
		TarItemStore.removeAll();
		TarItemPagingbar.updateInfo();
		InciLinkStore.removeAll();
	}
});

var TarCode = new Ext.form.TextField({
	id : 'TarCode',
	fieldLabel : '����',
	anchor : '90%'
});

var TarDesc = new Ext.form.TextField({
	id : 'TarDesc',
	fieldLabel : '����',
	anchor : '90%'
});

var NoInciFlag = new Ext.form.Checkbox({
	id : 'NoInciFlag',
	fieldLabel : 'δ���������',
	checked : true,
	anchor : '90%'
});

var SubTypeFee = new Ext.ux.ComboBox({
	fieldLabel : '�ӷ���',
	id : 'SubTypeFee',
	store : TarSubCateStore,
	filterName : 'Desc'
});

var InSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel : 'סԺ�ӷ���',
	id : 'InSubTypeFee',
	store : TarInpatCateStore,
	filterName : 'Desc'
});

var OutSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel : '�����ӷ���',
	id : 'OutSubTypeFee',
	store : TarOutpatCateStore,
	filterName : 'Desc'
});

var AccSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel : '�����ӷ���',
	id : 'AccSubTypeFee',
	store : TarEMCCateStore,
	filterName : 'Desc'
});

var MedSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel : '������ҳ����',
	id : 'MedSubTypeFee',
	store : TarMRCateStore,
	filterName : 'Desc'
});

var AccountSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel : '����ӷ���',
	id : 'AccountSubTypeFee',
	store : TarAcctCateStore,
	filterName : 'Desc'
});

var TarItemForm = new Ext.ux.FormPanel({
	title : '�Ʒ���',
	id : 'TarItemForm',
	tbar : [QueryTarButton, ClearButton],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',
		style : 'padding:5px 0px 0px 5px',
		defaults : {border : false, xtype : 'fieldset'},
		items : [{
			columnWidth : 0.33,
			items : [TarCode, SubTypeFee, OutSubTypeFee]
		}, {
			columnWidth : 0.33,
			items : [TarDesc, InSubTypeFee, AccSubTypeFee]
		}, {
			columnWidth : 0.33,
			labelWidth : 90,
			items : [NoInciFlag, MedSubTypeFee, AccountSubTypeFee]
		}]
	}]
});

var TarItemStore = new Ext.data.JsonStore({
	url : InciLinkTarUrl + '?actiontype=QueryTar',
	totalProperty : 'results',
	root : 'rows',
	fields : ['TARIRowId', 'TARICode', 'TARIDesc', 'UomId', 'UomDesc',
			'ActiveFlag'],
	pruneModifiedRecords : true,
	listeners : {
		clear : function(store, recordArr){
			gTarItemRowId = '';		//��ѯ���Ϊ��ʱ, ȫ�ֱ���gTarItemRowId�ÿ�
		}
	}
});

//ģ��
var TarItemCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : 'RowId',
		dataIndex : 'TARIRowId',
		hidden : true
	},{
		header:'����',
		dataIndex:'TARICode',
		width:150,
		align:'left',
		sortable:true
	},{
		header:'����',
		dataIndex:'TARIDesc',
		width:300,
		align:'left',
		sortable:true
	},{
		header:'��λ',
		dataIndex:'UomDesc',
		width:60,
		align:'left'
	}
]);

var TarItemPagingbar = new Ext.PagingToolbar({
	pageSize : 30,
	store : TarItemStore,
	displayInfo : true
});

var TarItemGrid = new Ext.ux.GridPanel({
	region:'west',
	width:600,
	split: true,
	minSize: 0,
	maxSize: 600,
	id : 'TarItemGrid',
	store : TarItemStore,
	cm : TarItemCm,
	sm : new Ext.grid.RowSelectionModel({
		listeners : {
			rowselect : function(sm,rowIndex,r){
				gTarItemRowId = r.get('TARIRowId');
				InciLinkStore.setBaseParam('Tariff', gTarItemRowId);
				InciLinkStore.load({params:{start : 0, limit : 999}});
			}
		}
	}),
	bbar : TarItemPagingbar
});

//============================================================
/////////////////////////////////////////////////����Ĳ�����Ҫע������
function GetPhaOrderInfo(item, stkgrp) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, '', 'N', '0', '',getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == '') {
		return;
	}
	var cell = InciLinkGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	
	var InciDr = record.get('InciDr');
	var InciCode = record.get('InciCode');
	var InciDesc = record.get('InciDesc');
	var FindIndex = InciLinkStore.findExact('InciDr', InciDr, 0);
	if(FindIndex >= 0){
		Msg.info('warning', InciDesc + ' �Ѵ����ڵ�' + (FindIndex + 1) + '��!');
		var col = GetColIndex(InciLinkGrid, 'InciDesc');
		InciLinkGrid.startEditing(row, col);
		return false;
	}
	var Spec = record.get('Spec');
	var UomId = record.get('BuomDr');
	var UomDesc = record.get('BuomDesc');
	var Rp = record.get('bRp');
	var Sp = record.get('bSp');

	var rowData = InciLinkGrid.getStore().getAt(row);
	rowData.set('InciDr', InciDr);
	rowData.set('InciCode', InciCode);
	rowData.set('InciDesc', InciDesc);
	rowData.set('Spec', Spec);
	addComboData(ItmUomStore, UomId, UomDesc);
	rowData.set('UomId', UomId);
	rowData.set('UomDesc', UomDesc);
	rowData.set('Rp', Rp);
	rowData.set('Sp', Sp);
	
	var col = GetColIndex(InciLinkGrid, 'LinkQty');
	InciLinkGrid.startEditing(row, col);
}

// ��λ
var CTUom = new Ext.ux.ComboBox({
	fieldLabel : '��λ',
	id : 'CTUom',
	store : ItmUomStore,
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '��λ...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''
});
		
CTUom.on('beforequery', function(combo) {
	var cell = InciLinkGrid.getSelectionModel().getSelectedCell();
	var record = InciLinkGrid.getStore().getAt(cell[0]);
	var InciDr = record.get('InciDr');
	ItmUomStore.setBaseParam('ItmRowid', InciDr);
	ItmUomStore.removeAll();
	ItmUomStore.load();
});
/*
		CTUom.on('select', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					
					var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
					var BUom = record.get("BUomId");
					var ConFac = record.get("ConFac");   //��λ��С��λ��ת����ϵ					
					var TrUom = record.get("uom");    //Ŀǰ��ʾ�ĳ��ⵥλ
					var Sp = record.get("sp");
					var Rp = record.get("rp");
					var NewSp = record.get("newSp");
					var InclbQty=record.get("inclbQty");
					var ReqStkQty=record.get("reqLocStkQty");
					var inclbDirtyQty=record.get("inclbDirtyQty");
					var AvaQty=record.get("inclbAvaQty");
					var ReqQty=record.get("reqQty");
					var TrQty=record.get("qty");
					var dirtyQty=record.get("dirtyQty");
					var AllAvaQty=record.get("AllAvaQty");
					if (value == null || value.length <= 0) {
						return;
					} else if (TrUom == value) {
						return;
					} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
						record.set("sp", accDiv(Sp,ConFac));
						record.set("newSp", accDiv(NewSp,ConFac));
						record.set("rp", accDiv(Rp,ConFac));
						record.set("inclbQty", accMul(InclbQty,ConFac));
						record.set("reqLocStkQty", accMul(ReqStkQty,ConFac));
						record.set("inclbDirtyQty", accMul(inclbDirtyQty,ConFac));
						record.set("inclbAvaQty", accMul(AvaQty,ConFac));
						record.set("reqQty", accMul(ReqQty,ConFac));
						record.set("dirtyQty",accMul(dirtyQty,ConFac));
						record.set("AllAvaQty",accMul(AllAvaQty,ConFac));
					} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
						record.set("sp", accMul(Sp,ConFac));
						record.set("newSp", accMul(NewSp,ConFac));
						record.set("rp", accMul(Rp,ConFac));
						record.set("inclbQty", accDiv(InclbQty,ConFac));
						record.set("reqLocStkQty", accDiv(ReqStkQty,ConFac));
						record.set("inclbDirtyQty", accDiv(inclbDirtyQty,ConFac));
						record.set("inclbAvaQty", accDiv(AvaQty,ConFac));
						record.set("reqQty", accDiv(ReqQty,ConFac));
						record.set("dirtyQty",accDiv(dirtyQty,ConFac));
						record.set("AllAvaQty",accDiv(AllAvaQty,ConFac));
					}
					record.set("uom", combo.getValue());
		});
*/
		
var InciLinkStore = new Ext.data.JsonStore({
	url : InciLinkTarUrl + '?actiontype=GetLinkData',
	totalProperty : 'results',
	root : 'rows',
	fields : ['RowId', 'InciDr', 'InciCode', 'InciDesc', 'Spec',
			'LinkQty', 'UomId', 'UomDesc'],
	pruneModifiedRecords : true,
	listeners : {
		beforeload : function(store, options){
			store.removeAll();
		}
	}
});

var InciLinkCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : 'InciDr',
		dataIndex : 'InciDr',
		hidden : true,
		sortable : true
	},{
		header : '���ʴ���',
		dataIndex : 'InciCode',
		width : 120,
		sortable : true
	},{
		header : '��������',
		dataIndex : 'InciDesc',
		width : 200,
		sortable : true,
        editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo(field.getValue(), '');
					}
				}
			}
		}))
	},{
		header : '���',
		dataIndex : 'Spec',
		width : 100
	},{
		header : '����',
		dataIndex : 'LinkQty',
		width : 80,
		align : 'right',
		editor : new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : false,
			allowNegative : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						AddInciLinkRow();
					}
				}
			}
		})
	},{
		header : '��λ',
		dataIndex : 'UomId',
		width : 100,
		editor : new Ext.grid.GridEditor(CTUom),
		renderer : Ext.util.Format.comboRenderer2(CTUom,"UomId","UomDesc")
	}
	/////���۱����, ���һ��������, �����ۼ�, �Ʒ������
]);

var AddInciButton = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½�',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(gTarItemRowId != ''){
			AddInciLinkRow();
		}else{
			Msg.info('warning','��ѡ��Ʒ���!');
			return false;
		}
	}
});

function AddInciLinkRow() {
	var col = GetColIndex(InciLinkGrid, 'InciDesc');
	var rowCount = InciLinkStore.getCount();
	if (rowCount > 0) {
		var rowData =InciLinkStore.data.items[rowCount - 1];
		var InciDr = rowData.get("InciDr");
		if (Ext.isEmpty(InciDr)) {
			InciLinkGrid.startEditing(rowCount - 1, col);
			return;
		}
	}
	var InciLinkRecord = CreateRecordInstance(InciLinkStore.fields);
	InciLinkStore.add(InciLinkRecord);
	InciLinkGrid.startEditing(InciLinkStore.getCount() - 1, col);
}

var SaveInciLinkButton = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(InciLinkGrid.activeEditor != null){
			InciLinkGrid.activeEditor.compleEdit();
		}
		var mr = InciLinkStore.getModifiedRecords();
		var ListData = '';
		for(var i = 0; i < mr.length; i++){
			var RowId = mr[i].get('RowId');
			var InciDr = mr[i].get('InciDr');
			if(Ext.isEmpty(InciDr)){
				continue;
			}
			var LinkQty = mr[i].get('LinkQty');
			var InciDesc = mr[i].get('InciDesc');
			if(Ext.isEmpty(LinkQty) || LinkQty <= 0){
				Msg.info('warning', InciDesc + '��������Ϊ��!');
				return;
			}
			var UomId = mr[i].get('UomId');
			var RowData = RowId + '^' + InciDr + '^' + LinkQty + '^' + UomId;
			if(ListData == ''){
				ListData = RowData;
			}else{
				ListData = ListData + xRowDelim() + RowData;
			}
		}
		if(ListData == ''){
			Msg.info('error', 'û���޸Ļ����������!');
			return false;
		}
		var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
		Ext.Ajax.request({
			url: InciLinkTarUrl + '?actiontype=Save',
			params: {Tariff : gTarItemRowId, ListData : ListData},
			failure: function(result, request) {
				mask.hide();
				Msg.info('error', '������������!');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsonData.success=='true') {
					Msg.info('success', '�����ɹ�!');
					InciLinkStore.reload();
				}else if(jsonData.info == -1){
					Msg.info('error', '�����ظ�!');
				}else{
					Msg.info('error', 'ʧ��:' +  jsonData.info);
				}
			},
			scope : this
		});
	}
});


var DelInciLinkButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
    tooltip : 'ɾ��',
    iconCls : 'page_delete',
	width : 70,
	height : 30,
	handler : function(){
		var cell = InciLinkGrid.getSelectionModel().getSelectedCell();
		if(cell == null){
			Msg.info('warning', '��ѡ������!');
			return false;
		}else{
			var record = InciLinkGrid.getStore().getAt(cell[0]);
			var RowId = record.get('RowId');
			if(RowId != ''){
				Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							var mask = ShowLoadMask(Ext.getBody(), '���������Ժ�...');
							Ext.Ajax.request({
								url : InciLinkTarUrl + '?actiontype=Delete&RowId=' + RowId,
								waitMsg :'ɾ����...',
								failure : function(result, request) {
									mask.hide();
									Msg.info('error','������������!');
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									mask.hide();
									if (jsonData.success == 'true') {
										Msg.info('success', 'ɾ���ɹ�!');
										InciLinkStore.reload();
									}else{
										Msg.info('error','ɾ��ʧ��!');
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				InciLinkStore.remove(record);
				InciLinkGrid.getView().refresh();
			}
		}
    }
});


var InciLinkGrid = new Ext.ux.EditorGridPanel({
	region:'center',
	id : 'InciLinkGrid',
	store : InciLinkStore,
	cm : InciLinkCm,
	sm : new Ext.grid.CellSelectionModel({}),
	tbar : [AddInciButton, '-', SaveInciLinkButton, '-', DelInciLinkButton],
	listeners : {
		beforeedit : function(e){
			if(e.field == 'InciDesc' && !Ext.isEmpty(e.record.get('RowId'))){
				e.cancel = true;
			}
		}
	}
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [TarItemForm, TarItemGrid, InciLinkGrid],
		renderTo : 'mainPanel'
	});
	
	QueryTarButton.handler();
});