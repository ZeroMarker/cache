// ����: ��ֵ�������ɹ���(��Ӧ���û�ʹ��)(����)
// 2016-05-22
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var DrugListFlag = 0;// ��־ �����ж��ǲ�ѯ����¼��
var inciDr = ""
var BarcodeArr = [];

/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",
				getDrugList,VENDORID);
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
	var Spec = record.get("Spec");
	var Manf = record.get("ManfName");
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
		rowData.set("Spec", Spec);
		rowData.set("Manf", Manf);
		rowData.set('Qty', 1);
		var colIndex = GetColIndex(BarCodeGrid, 'SpecDesc');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

var startDate = new Ext.ux.DateField({
			id : 'startDate',
			allowBlank : true,
			fieldLabel : '����',
			anchor : '95%',
			value : new Date()
		});

var BarCodeField = new Ext.form.TextField({
			id : 'BarCodeField',
			fieldLabel : '������',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true
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
						GetPhaOrderInfo(field.getValue(), '');
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

var BarCodeGridCm = [{
			header : "dhcit",
			dataIndex : 'InctrackId',
			saveColIndex : 0,
			hidden : true
		}, {
			header : "IncId",
			dataIndex : 'IncId',
			saveColIndex : 1,
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
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									DrugListFlag = 1;
									GetPhaOrderInfo(field.getValue(), '');
								}
							}
						}
					}))
		}, {
			header : "����",
			dataIndex : 'Manf'
		}, {
			header : "���",
			dataIndex : 'Spec'
		}, {
			header : "������",
			dataIndex : 'SpecDesc',
			saveColIndex : 8,
			allowBlank : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var SpecDesc = field.getValue();
									if (SpecDesc.length < 4) {
										Msg.info("warning", "�����񳤶Ȳ���!");
										return;
									}
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'Qty')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					}))
		}, {
			header : "����",
			dataIndex : 'Qty',
			width : 60,
			align : 'right',
			saveColIndex : 3,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						allowNegative : false,
						allowDecimals :false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", "��������Ϊ��!");
										return;
									}
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'OriginalCode')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					})
		}, {
			header : "��ӡ",
			xtype:'checkcolumn',
			dataIndex : 'print',
			width : 40
		}, {
			header : "��������",
			dataIndex : 'BarCode',
			width : 200,
			align : 'left',
			sortable : false,
			saveColIndex : 2,
			editable : false, // 2015-05-01 rem
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'OriginalCode')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					}))
		}, {
			header : "�Դ�����",
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : false,
			saveColIndex : 4,
			allowBlank : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank:false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'BatNo')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					}))
		}, {
			header : "����",
			dataIndex : 'BatNo',
			width : 90,
			align : 'center',
			sortable : true,
			saveColIndex : 6,
			allowBlank : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank:false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
							var col = GetColIndex(BarCodeGrid, 'ExpDate')
							BarCodeGrid.startEditing(row, col);
						}
					}
				}
			}))
		}, {
			header : "��Ч��",
			xtype:'datecolumn',
			dataIndex : 'ExpDate',
			width : 100,
			align : 'center',
			sortable : true,	
			saveColIndex : 7,
			allowBlank : false,
			editor : new Ext.ux.DateField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var expDate = field.getValue();
								if (expDate == null || expDate.length <= 0) {
									Msg.info("warning", "��Ч�ڲ���Ϊ��!");
									return;
								}
								var nowdate = new Date();
								if (expDate.format("Y-m-d") <= nowdate.format("Y-m-d")) {
									Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
									return;
								}
								BarCodeGrid.addNewRow();
							}
						}
					}
				})
		}, {
			header : "ע����Ա",
			dataIndex : 'User'
		}, {
			header : "ע������",
			dataIndex : 'Date'
		}, {
			header : "��Ӧ��ID",
			dataIndex : 'Vendor',
			saveColIndex : 14,
			hidden : true,
			hideable : false
		}];

function paramsFn(){
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = '';
	var startDate = Ext.getCmp("startDate").getValue();
	if(Ext.isEmpty(startDate)){
		Msg.info('warning', '���ڲ���Ϊ��!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = startDate;
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate + "^" + VENDORID;
	return {'Param' : Param};
}

function cellSelectFn(sm,rowIndex,colIndex){
	/*
	var InctrackId = BarCodeGrid.getCell(rowIndex,BarCodeGrid.idProperty);
	//BarCodeGrid.DelRowButton.setDisabled(!Ext.isEmpty(InctrackId));	//2015-05-01 ����ɾ��
	*/
}

var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// ���
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'BarCodeGrid',
	contentColumns : BarCodeGridCm,
	smRowSelFn : cellSelectFn,
	selectFirst : false,
	actionUrl : BarCodeGridUrl,
	queryAction : "query",
	idProperty : "InctrackId",
	checkProperty : "IncId",
	paramsFn : paramsFn,
	beforeAddFn : Ext.emptyFn,		//beforeAddFn
	delRowAction : "Delete",
	delRowParam : "RowId",
	paging : false,
	createHeadMenu : Ext.emptyFn,	//�ÿ�
	listeners : {
		'beforeedit' : function(e) {
			var InctrackId = BarCodeGrid.getCell(e.row,"InctrackId");
			if (!Ext.isEmpty(InctrackId) && e.field!='OriginalCode' && e.field!='BatNo' && e.field!='ExpDate') {
				return false;	// �����޸� ��������Ĳ������޸�
			}
		},
		'afteredit': function (e) {
			if(e.field == 'Qty'){
				if (!Ext.isNumber(e.value) || e.value > 1000) {
					Msg.info("warning", "�������ܳ���1000!");
					e.record.set('Qty',e.originalValue);
					return;
				}
			}
		}
	}
});

var findBarCode = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
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
				BarCodeGrid.addNewRow();
			}
		});

// ���水ť
var saveBarCode = new Ext.Toolbar.Button({
			text : '����',
			width : 70,
			height : 30,
			iconCls : 'page_save',
			handler : function() {
				save();
			}
		});

var printBarCode = new Ext.Toolbar.Button({
			text : '��ӡ����',
			iconCls : 'page_print',
			width : 70,
			height : 30,
			handler : function(button, e) {
				DHCP_GetXMLConfig("DHCSTM_Barcode");
				var count=BarCodeGrid.getCount();
				for(var rowIndex=0;rowIndex<count;rowIndex++){
					var print=BarCodeGrid.getAt(rowIndex).get('print');
					if(print!="Y"){
						continue;
					}
					var barcode=BarCodeGrid.getAt(rowIndex).get('BarCode');
					PrintBarcode(barcode);
				}
			}
		});



var printBarCodeTotal = new Ext.Toolbar.Button({
	text:'��ӡ��ҳ����',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(button,e){
		DHCP_GetXMLConfig("DHCSTM_Barcode");
		var rowsCount=BarCodeGrid.getCount();
		for(var n=0;n<rowsCount;n++){
			var barcode=BarCodeGrid.getAt(n).get('BarCode');
			PrintBarcode(barcode);
		}
	}
});
		
// ��հ�ť
var clearBarCode = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_refresh',
			handler : function() {
				inciDr = "";
				clearPanel(formPanel);
				BarCodeGrid.removeAll();
				BarCodeGrid.getBottomToolbar().updateInfo();
				formPanel.getForm().setValues({"startDate":new Date()});
				Ext.get("SaveBarCodeDiv").dom.innerHTML="";
			}
		});
		
function save() {
	var CreateUser = gUserId;
	var StkGrpId = '';
	var MainInfo = CreateUser + "^" + StkGrpId;
	var ListDetail = BarCodeGrid.getModifiedInfo();
	if (ListDetail == "") {
		Msg.info("warning", "û����Ҫ���������!");
		return;
	}
	var url = DictUrl + "barcodeaction.csp?actiontype=save";
	var loadMask = ShowLoadMask(Ext.getBody(), "������...");
	Ext.Ajax.request({
				url : url,
				method : 'POST',
				params : {
					MainInfo : MainInfo,
					ListDetail : ListDetail
				},
				waitMsg : '������...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						// ˢ�½���
						var datetime = jsonData.info;
						var startDate = datetime.split("^")[0];
						var time = datetime.split("^")[1];
						var endDate = startDate;
						Msg.info("success", "����ɹ�!");
						var Param = "" + "^" + "" + "^" + "" + "^" + startDate
								+ "^" + time + "^" + endDate
						BarCodeGrid.store.setBaseParam('Param', Param);
						BarCodeGrid.load({params : {'Param': Param}});
					} else {
						Msg.info("error", "����ʧ��!" + jsonData.info);
					}
					loadMask.hide();
				},
				scope : this
			});
}

var VenItmList = new Ext.Button({
	text : '�����б�',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function(){
		VenItmListWindow();
	}
});

var ChangePswdButton = new Ext.Button({
	text : '�޸�����',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	anchor : '90%',
	handler : function(){
		ChangePswd();
	}
});

var formPanel = new Ext.form.FormPanel({
			labelwidth : 30,
			labelAlign : 'right',
			frame : true,
			bodyStyle : 'padding:5px;',
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode, '-', printBarCode,
				'-', printBarCodeTotal, '-', VenItmList, '-', ChangePswdButton],
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
									items : [M_InciCode, M_InciDesc]
								}]
					}]

		});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
				title : '��ֵ����ע��(��Ӧ��)' + ':  ' + VENDOR_DESC,
				region : 'north',
				height : 180,
				layout : 'fit',
				items : [formPanel]
			});
	
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [panel, BarCodeGrid],
				renderTo : 'mainPanel'
			});
});