// ����:��ֵ�������ɹ���
// ��д�ˣ��쳬
// ��д����:2013-09-17
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var DrugListFlag = 0;// ��־ �����ж��ǲ�ѯ����¼��
var inciDr = ""
var BarcodeArr = [];

/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", gHospId,
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

	inciDr = record.get("InciDr");
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	var pbrp= record.get("PbRp");
	var PFac=record.get("PFac");
	var pSp=record.get("pSp");
	var Marginnow=accDiv(pSp,pbrp)
	if (DrugListFlag == 0) {
		Ext.getCmp("M_InciDesc").setValue(inciDesc);
		Ext.getCmp("M_InciCode").setValue(inciCode);
	} else {
		var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
		// ѡ����
		var row = cell[0];
		var col = cell[1];
		var HVFlag = record.get("HVFlag");
		if (HVFlag == 'N') {
			Msg.info("warning", "�ò��ϲ��Ǹ�ֵ����!");
			BarCodeGrid.startEditing(row, col);
			return;
		}
		var rowData = BarCodeGrid.getStore().getAt(row);
		rowData.set("IncId", inciDr);
		rowData.set("IncCode", inciCode);
		rowData.set("IncDesc", inciDesc);
		rowData.set('Qty', 1);
		rowData.set('PbRp',pbrp);
		rowData.set('Sp',pSp);
		rowData.set('Marginnow',Marginnow);
		var colIndex = GetColIndex(BarCodeGrid, 'Qty');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

var startDate = new Ext.ux.DateField({
			id : 'startDate',
			allowBlank : true,
			fieldLabel : '��ʼ����',
			anchor : '95%',
			value : new Date()
		});
// ��ֹ����
var endDate = new Ext.ux.DateField({
			id : 'endDate',
			allowBlank : true,
			fieldLabel : '��ֹ����',
			anchor : '95%',
			value : new Date()
		});
// ����
var StkGrpType = new Ext.ux.StkGrpComboBox({
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType : App_StkTypeCode, // ��ʶ��������
			UserId : gUserId,
			LocId : gLocId,
			anchor : '95%'
		});

var BarCodeField = new Ext.form.TextField({
			id : 'BarCodeField',
			fieldLabel : '������',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true
		});
var OldBarCodeField = new Ext.form.TextField({
			id : 'OldBarCodeField',
			fieldLabel : 'ԭʼ������',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true,
				listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var oldbarcode=field.getValue()
						save(oldbarcode)
					}
				}
			}
		});
// ���ʱ���
var M_InciCode = new Ext.form.TextField({
			fieldLabel : '���ʱ���',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			width : 150,
			disabled : true,
			valueNotFoundText : ''
		});

// ��������
var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				},
				focus : function(field) {
					DrugListFlag = 0;
				},
				blur : function(field) {
					if (field.getValue() == "") {
						inciDr = "";
						Ext.getCmp("M_InciCode").setValue("");
					}
				}
			}
		});
var Specom = new Ext.form.ComboBox({
	fieldLabel : '������',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
	width : 120,
	listWidth :210,
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '������...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function()
		
			{	var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
				var record = BarCodeGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("IncId");	
				var desc=this.getRawValue();
				this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
				this.store.setBaseParam('SpecItmRowId',IncRowid)
				this.store.setBaseParam('desc',desc)
				this.store.load({params:{start:0,limit:this.pageSize}})
			} 
	})
});
var BarCodeGridCm = [{
			header : "dhcit",
			dataIndex : 'InctrackId',
			hidden : true,
			hideable : false
		}, {
			header : "IncId",
			dataIndex : 'IncId',
			hidden : true,
			hideable : false
		}, {
			header : "���ʴ���",
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'IncDesc',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : "���",
			dataIndex : 'Spec'
		}, {
			header : "����",
			dataIndex : 'Qty',
			width : 80,
			align : 'right'
		}, {
			header : "����������",
			dataIndex : 'BarCode',
			width : 150,
			align : 'left',
			sortable : false
		}, {
			header : "��ӡ",
			xtype:'checkcolumn',
			dataIndex : 'print'
		}, {
			header : "�Դ�����",
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : false
		}, {
			header : "ע����Ա",
			dataIndex : 'User'
		}, {
			header : "ע������",
			dataIndex : 'Date'
		},{
			header : "PoItmId",
			dataIndex : 'PoItmId',
			hidden : true
		},{
			header : "���󵥺�",
			dataIndex : 'ReqNo'
		},{
			header : "Ʒ��",
			dataIndex : 'Brand'
		}, {
			header : "����",
			dataIndex : 'BatNo',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			header : "��Ч��",
			xtype: 'datecolumn',
			dataIndex : 'ExpDate',
			width : 100,
			align : 'center',
			sortable : true
		},{
			header : "��ǰ�ۼ�",
			dataIndex : 'Sp'
		},{
			header : "�������",
			dataIndex : 'ReqLocDesc'
		},{
			header : "�б����",
			dataIndex : 'PbRp'
		},{
			header : "�ӳ���",
			dataIndex : 'Marginnow'
		},{
        	header:"������",
       		dataIndex:'SpecDesc',
        	width:100,
       		align:'left',
        	sortable:true
        }];
function paramsFn(){
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var startDate = Ext.getCmp("startDate").getValue();
	var endDate = Ext.getCmp("endDate").getValue();
	if(startDate!=""){
		startDate = startDate.format(ARG_DATEFORMAT);
	}
	if(endDate!=""){
		endDate = endDate.format(ARG_DATEFORMAT);
	}
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate;
	return {'Param' : Param};
}

function beforeAddFn(){
	var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
	if (StkGrpType == null || StkGrpType.length <= 0) {
		Msg.info("warning", "��ѡ������!");
		return false;
	}
}
var DeleteDetailBT=new Ext.ux.Button({
	id:'DeleteDetailBT',
	text:'ɾ��һ��',
	iconCls:'page_delete',
	handler:function(){
		deleteDetail();
	}
});
function deleteDetail() {
	var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "û��ѡ����!");
		return;
	}
	Ext.MessageBox.show({
			title : '��ʾ',
			msg : '�Ƿ�ȷ��ɾ��������Ϣ?',
			buttons : Ext.MessageBox.YESNO,
			fn : showResult,
			icon : Ext.MessageBox.QUESTION
		});
}
/**
 * ɾ����ʾ
 */
function showResult(btn) {
	if (btn == "yes") {
		var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = BarCodeGrid.getStore().getAt(row);
		var RowId = record.get("InctrackId");
		// ɾ����������
		var url =BarCodeGridUrl+"?actiontype=Delete&RowId="+RowId;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "ɾ���ɹ�!");
					BarCodeGrid.getStore().remove(record);
					BarCodeGrid.getView().refresh();
				} else {
						Msg.info("error", "ɾ��ʧ��!");
				}
			},
			scope : this
		});
	}
}


var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// ���
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'BarCodeGrid',
	tbar:['ԭʼ����:',OldBarCodeField,'-',DeleteDetailBT],
	contentColumns : BarCodeGridCm,
	smRowSelFn : Ext.emptyFn,
	singleSelect:false,
	selectFirst : false,
	actionUrl : BarCodeGridUrl,
	queryAction : "query",
	idProperty : "InctrackId",
	checkProperty : "IncId",
	paramsFn : paramsFn,
	beforeAddFn : beforeAddFn,
	//delRowAction : "Delete",
	//delRowParam : "RowId",
	showTBar:false,
	listeners : {
		'beforeedit' : function(e) {
			var InctrackId = BarCodeGrid.getCell(e.row,"InctrackId");
			if (!Ext.isEmpty(InctrackId) && e.field!='OriginalCode'&& e.field!='BatNo'&& e.field!='ExpDate'&& e.field!='SpecDesc') {
				return false;	// �����޸� ��������Ĳ������޸�
			}
		}
		/*,
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().select(rowindex,1);
			//����δ�����������ϸ�����Ҽ��˵�
			if(grid.getStore().getAt(rowindex).get('InctrackId')==''){
				rightClick.showAt(e.getXY());
			}
		}
		*/
	}
});
//BarCodeGrid.AddNewRowButton.hidden = true;		//�����ò�����"����һ��"��ť


var findBarCode = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				clear.handler();
				BarCodeGrid.load();
			}
		});

var addBarCode = new Ext.Toolbar.Button({
			text : '�½�',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				BarCodeGrid.removeAll();
			}
		});

var printBarCode = new Ext.Toolbar.Button({
		text: '��ӡ����',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = BarCodeGrid.getCount();
			for (var rowIndex = 0; rowIndex < count; rowIndex++) {
				var RowData = BarCodeGrid.getAt(rowIndex);
				var print = RowData.get('print');
				if (print != "Y") {
					continue;
				}
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode);
			}
		}
	});
var printBarCode2 = new Ext.Toolbar.Button({
		text: '��ӡ����2��',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = BarCodeGrid.getCount();
			for (var rowIndex = 0; rowIndex < count; rowIndex++) {
				var RowData = BarCodeGrid.getAt(rowIndex);
				var print = RowData.get('print');
				if (print != "Y") {
					continue;
				}
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode,2);
			}
		}
	});
var printBarCodeTotal = new Ext.Toolbar.Button({
		text: '��ӡ��ҳ����',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var rowsCount = BarCodeGrid.getCount();
			for (var n = 0; n < rowsCount; n++) {
				var RowData = BarCodeGrid.getAt(n);
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode);
			}
		}
	});
var printBarCodeTotal2 = new Ext.Toolbar.Button({
		text: '��ӡ��ҳ����2��',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var rowsCount = BarCodeGrid.getCount();
			for (var n = 0; n < rowsCount; n++) {
				var RowData = BarCodeGrid.getAt(n);
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode,2);
			}
		}
	});

// ��հ�ť
var clearBarCode = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				inciDr = "";
				clearPanel(formPanel);
				BarCodeGrid.removeAll();
				BarCodeGrid.getBottomToolbar().updateInfo();
				formPanel.getForm().setValues({"startDate":new Date(),"endDate":new Date()});
				Ext.getCmp("OldBarCodeField").setValue("");
				clear.handler();
			}
		});
		
// ��հ�ť����
var clear = new Ext.Toolbar.Button({
			text : '���������Ϣ',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_delete',
			handler : function() {
				BarcodeArr=[];
			}
		});
		
function save(barcode) {
	var CreateUser = gUserId;
	var MainInfo = barcode + "^" + CreateUser;
	var ret = tkMakeServerCall("web.DHCSTM.DHCItmTrack","NewBarcode",MainInfo);
	try{
		var ret = Ext.decode(ret);
		var NewRecord = CreateRecordInstance(BarCodeGrid.getStore().fields,ret);
		BarCodeGrid.getStore().insert(0,NewRecord);
		BarCodeGrid.getView().refresh();
	}catch(e){
		Msg.info('error', '����ʧ��:' + ret);
	}
}


var formPanel = new Ext.ux.FormPanel({
			title : '��ֵ����Ǽ�',
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', addBarCode, '-', clearBarCode,'-', printBarCode, '-', printBarCodeTotal,'-',printBarCode2,'-',printBarCodeTotal2],
			items : [{
						xtype : 'fieldset',
						title : '��ѯ����',
						layout : 'column',
						items : [{
									columnWidth : .25,
									layout : 'form',
									items : [BarCodeField, startDate]
								}, {
									columnWidth : .25,
									layout : 'form',
									items : [StkGrpType, endDate]
								}, {
									columnWidth : .25,
									layout : 'form',
									items : [M_InciCode, M_InciDesc]
								}]
					}]
		});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [formPanel, BarCodeGrid],
				renderTo : 'mainPanel'
			});
});
