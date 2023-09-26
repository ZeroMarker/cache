// ����:�Ѳ�¼��ֵ�޸Ĺ�Ӧ��
// ��д����:2019-1-9
//��д��:����
var UserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
var gLocId = session['LOGON.CTLOCID'];
var gIncId = '';
var CURRENT_INGR = '', CURRENT_INIT = ''; //���β�¼��ⵥrowidStr, ���ⵥrowidStr

var StkGrpType = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		name: 'StkGrpType',
		StkType: App_StkTypeCode, //��ʶ��������
		LocId: gLocId,
		UserId: UserId,
		anchor: '90%'
	});

var Vendor = new Ext.ux.VendorComboBox({
		id: 'Vendor',
		fieldLabel:'<font color=red>��Ӧ��</font>',
		anchor: '90%',
		params: {
			ScgId: 'StkGrpType'
		},
		valueParams: {
			LocId: gLocId,
			UserId: UserId
		}
	});

var InciDesc = new Ext.form.TextField({
		fieldLabel: '��������',
		id: 'InciDesc',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "", getDrugList);
	}
}

/**
 * ���ط���
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	gIncId = record.get("InciDr");
	var InciCode = record.get("InciCode");
	var InciDesc = record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(InciDesc);

	findhaveMatord.handler();
}

var PresentFlag = new Ext.form.Checkbox({
		fieldLabel: '����',
		id: 'PresentFlag',
		name: 'PresentFlag',
		anchor: '90%',
		checked: false
	});

// ���ۻ�Ʊ��־
var ExchangeFlag = new Ext.form.Checkbox({
		id: 'ExchangeFlag',
		name: 'ExchangeFlag',
		anchor: '90%',
		checked: false,
		fieldLabel: '���ۻ�Ʊ'
	});
//��ֵ����
var Label =	new Ext.form.TextField({
		fieldLabel:'��ֵ����',
		id:'Label',
		achor:'90%',
		listeners:{
			specialkey:function(field,e){
				if(e.getKey()==Ext.EventObject.ENTER){
						findhaveMat()
					}
				}
			}
	});
var OperateInType = new Ext.form.ComboBox({
		fieldLabel: '�������',
		id: 'OperateInType',
		name: 'OperateInType',
		anchor: '90%',
		store: OperateInTypeStore,
		valueField: 'RowId',
		displayField: 'Description',
		allowBlank: true,
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		valueNotFoundText: ''
	});
// Ĭ��ѡ�е�һ������
OperateInTypeStore.load({
	callback: function (r, options, success) {
		if (success && r.length > 0) {
			OperateInType.setValue(r[0].get(OperateInType.valueField));
		}
	}
});

// �ɹ���Ա
var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel: '�ɹ���Ա',
		id: 'PurchaseUser',
		store: PurchaseUserStore,
		valueField: 'RowId',
		displayField: 'Description'
	});

var reclocField = new Ext.ux.LocComboBox({
		id: 'reclocField',
		fieldLabel: '������',
		name: 'reclocField',
		groupId: gGroupId,
		anchor: '90%'
	});

var ordlocField = new Ext.ux.LocComboBox({
		id: 'ordlocField',
		fieldLabel: 'ҽ�����տ���',
		anchor: '90%',
		defaultLoc: {}
	});

var startDateField = new Ext.ux.DateField({
		id: 'startDateField',
		anchor: '90%',
		allowBlank: false,
		fieldLabel: 'ҽ����ʼ����',
		value: new Date()
	});

var endDateField = new Ext.ux.DateField({
		id: 'endDateField',
		anchor: '90%',
		allowBlank: false,
		fieldLabel: 'ҽ����������',
		value: new Date()
	});

var IngrFlag = new Ext.form.RadioGroup({
		id: 'IngrFlag',
		columns: 3,
		height: 20,
		disabled:true,
		itemCls: 'x-check-group-alt',
		items: [{
				boxLabel: 'ȫ��',
				name: 'IngrFlag',
				id: 'AllFlag',
				inputValue: 0
			}, {
				boxLabel: 'δ��¼',
				name: 'IngrFlag',
				id: 'NoIngrFlag',
				inputValue: 1	
			}, {
				boxLabel: '�Ѳ�¼',
				name: 'IngrFlag',
				id: 'IngredFlag',
				checked: true,
				inputValue: 2
			}
		]
	});
var OrdRegno = new Ext.form.TextField({
		fieldLabel: '�ǼǺ�',
		id: 'OrdRegno',
		anchor: '90%',
		enableKeyEvents: true,
		listeners: {
			keydown: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var OrdRegno = field.getValue();
					Ext.Ajax.request({
						url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
						params: {
							regno: OrdRegno
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								var value = jsonData.info;
								var arr = value.split("^");
								//������Ϣ
								field.setValue(arr[0]);
								Ext.getCmp('OrdRegnoDetail').setValue(arr.slice(1));
							}
						},
						scope: this
					});
				}
			}
		}
	});
var OrdRegnoDetail = new Ext.form.TextField({
		fieldLabel: '�ǼǺ���Ϣ',
		id: 'OrdRegnoDetail',
		disabled: true,
		anchor: '90%'
	});
// ����ܺϼ�
var totalrp = new Ext.form.TextField({
		fieldLabel: '���ϼ�',
		id: 'totalrp',
		name: 'totalrp',
		anchor: '90%',
		readOnly: true
	});
// ����ܺϼ�


function findhaveMat() {
	var LocId = Ext.getCmp('reclocField').getValue();
	if (LocId == '') {
		Msg.info('warning', '��ѡ�����!');
		return false;
	}
	var startDate = Ext.getCmp('startDateField').getValue();
	if ((startDate != "") && (startDate != null)) {
		startDate = startDate.format(ARG_DATEFORMAT);
	} else {
		Msg.info("error", "��ѡ����ʼ����!");
		return false;
	}
	var endDate = Ext.getCmp('endDateField').getValue();
	if ((endDate != "") && (endDate != null)) {
		endDate = endDate.format(ARG_DATEFORMAT);
	} else {
		Msg.info("error", "��ѡ���ֹ����!");
		return false;
	}
	var Vendor = Ext.getCmp('Vendor').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var InciDesc = Ext.getCmp('InciDesc').getValue();
	if (InciDesc == '') {
		gIncId = '';
	}
	var IngrFlag = Ext.getCmp('IngrFlag').getValue().getGroupValue();
	var ordlocField = Ext.getCmp('ordlocField').getValue();
	var OrdRegno = Ext.getCmp("OrdRegno").getValue();
	var Label = Ext.getCmp("Label").getValue();
	var strPar = startDate + "^" + endDate + "^" + Vendor + "^" + StkGrpType + "^" + gIncId
		 + "^" + LocId + "^" + IngrFlag + "^" + ordlocField + "^^^" + OrdRegno + "^" + InciDesc+"^^"+gGroupId+"^"+UserId+"^"+Label;
	MatordGridDs.setBaseParam('strPar', strPar);
	MatordGridDs.removeAll();
	MatordGridDs.load({
		params: {
			start: 0,
			limit: 9999
		},
		callback: function (r, options, success) {
			if (success == false) {
				Msg.info("error", "��ѯ����, ��鿴��־!");
			}
		}
	});
}
var findhaveMatord = new Ext.Toolbar.Button({
		text: '����ҽ����Ϣ',
		tooltip: '����ҽ����Ϣ',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			findhaveMat();
		}
	});
var clearMatord = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '���',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			CURRENT_INGR = '';
			CURRENT_INIT = '';
			GrMasterInfoGrid.getStore().removeAll();
			GrDetailInfoGrid.getStore().removeAll();
			MatordGridDs.removeAll();
			clearPanel(formPanel);
			startDateField.setValue(new Date());
			endDateField.setValue(new Date());
			Ext.getCmp('IngredFlag').setValue(true)
		}
	});
var createMatord = new Ext.ux.Button({
		text: '���¹�Ӧ�̲�¼',
		tooltip: '�����˿��˻��������ù�Ӧ�����������ⵥ',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			var loadMask = ShowLoadMask(Ext.getBody(), "������...");
			var LocId = Ext.getCmp("reclocField").getValue();
			if (LocId == '') {
				Msg.info('warning', '�����Ҳ���Ϊ��!');
				loadMask.hide();
				return false;
			}
			var Vendor=Ext.getCmp("Vendor").getValue();
			if(Vendor==""){
				Msg.info('warning','�滻��Ӧ�̲���Ϊ��!')
				loadMask.hide();
				return false;
			}
			var MainInfo =Vendor;

			var ListDetail = "";
			var sm = MatordGrid.getSelectionModel();
			var store = MatordGrid.getStore();
			var rowCount = MatordGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				if (sm.isSelected(i)) {
					var rowData = store.getAt(i);
					var BarCode = rowData.get("barcode");
					var IngrFlag = rowData.get('IngrFlag');
					var canceled = rowData.get("canceled");
					if (IngrFlag != "Y" ) {
						Msg.info("warning", "û�н��в�¼,�������޸Ĺ�Ӧ�̲�¼!");
						sm.deselectRow(i);
						loadMask.hide();
						return;
					}
					var Ingri = "" //rowData.get("Ingri");
					var IncId = rowData.get("inci");
					var VendorId = rowData.get("vendordr");
					if (Ext.isEmpty(VendorId)) {
						Msg.info("warning", "��" + (i + 1) + "�й�Ӧ�̲���Ϊ��!");
						loadMask.hide();
						return;
					}
					if (VendorId==Vendor) {
						Msg.info("warning", "��" + (i + 1) + "�й�Ӧ����Ҫ���²�¼�Ĺ�Ӧ����ͬ!");
						loadMask.hide();
						return;
					}
					
					var VendorRowid = rowData.get("vendorrowid");
					var oeori = rowData.get("oeori");
					var hvmat = rowData.get('orirowid');
					var vendordr = rowData.get('vendordr');
					var str = hvmat
					if (ListDetail == "") {
						ListDetail = str;
					} else {
						ListDetail = ListDetail + RowDelim + str;
					}
				}
			}
			if (ListDetail == "") {
				Msg.info("error", "û����Ҫ���²�¼����Ϣ!");
				loadMask.hide();
				return;
			}
			
			var url = "dhcstm.hvingdrecmodvendoraction.csp?actiontype=Create";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					MainInfo: MainInfo,
					ListDetail: ListDetail,
					user: UserId
				},
				waitMsg: '������...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON
						.decode(result.responseText);
					loadMask.hide();
					if (jsonData.success == 'true') {
						// ˢ�½���
						Msg.info("success", "����ɹ�!");
						findhaveMatord.handler();
						var CurrentInfo = jsonData.info;
						var CurrentInfoArr = CurrentInfo.split(xRowDelim());
						CURRENT_INGR = CurrentInfoArr[0];
						CURRENT_INIT = CurrentInfoArr[1];
						if (CURRENT_INGR != '') {
							tabPanel.activate('CurrentIngrPanel');
						}
					} else {
						var ret = jsonData.info;
						loadMask.hide();
						if (ret == -99) {
							Msg.info("error", "����ʧ��,���ܱ���!");
						} else if (ret == -1) {
							Msg.info("error", "���Ϊ��,�������²�¼!");
						} else if (ret == -3) {
							Msg.info("error", "�����뻹δ���в�¼!");
						} else if (ret == -4) {
							Msg.info("error", "ԭ��Ӧ����Ҫ�޸ĵĹ�Ӧ����ͬ,�������²�¼!");
						}  else {
							Msg.info("error", "������ϸ���治�ɹ���" + ret);
						}
					}
				},
				scope: this
			});
		}
	});

var PrintIngrButton = new Ext.Toolbar.Button({
		text: '��ӡ��ⵥ',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			var rowData = GrMasterInfoGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
				return;
			}
			var DhcIngr = rowData.get("IngrId");
			PrintRec(DhcIngr);
		}
	});

var PrintInitButton = new Ext.Toolbar.Button({
		text: '��ӡ���ⵥ',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			var rowData = InitMasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "��ѡ����Ҫ��ӡ�ĳ��ⵥ!");
				return;
			}
			var init = rowData.get("init");
			PrintInIsTrf(init);
		}
	});
var PrintHvMatButton = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			var LocId = Ext.getCmp('reclocField').getValue();
			if (LocId == '') {
				Msg.info('warning', '��ѡ�����!');
				return false;
			}
			var startDate = Ext.getCmp('startDateField').getValue();
			if ((startDate != "") && (startDate != null)) {
				startDate = startDate.format(ARG_DATEFORMAT);
			} else {
				Msg.info("error", "��ѡ����ʼ����!");
				return false;
			}
			var endDate = Ext.getCmp('endDateField').getValue();
			if ((endDate != "") && (endDate != null)) {
				endDate = endDate.format(ARG_DATEFORMAT);
			} else {
				Msg.info("error", "��ѡ���ֹ����!");
				return false;
			}
			
			var strPar = MatordGridDs.lastOptions.params['strPar'];
			fileName = "DHCSTM_HVMatItm.raq&&sd=" + startDate + "&ed=" + endDate + "&strParam=" + strPar;
			DHCSTM_DHCCPM_RQPrint(fileName);
		}
	});
///ȥ�ظ�
function filterRepeatStr(str) {
	var ar2 = str.split("^");
	var array = new Array();
	var j = 0
		for (var i = 0; i < ar2.length; i++) {
			if ((array == "" || array.toString().match(new RegExp(ar2[i], "g")) == null) && ar2[i] != "") {
				array[j] = ar2[i];
				array.sort();
				j++;
			}
		}
		return array.toString();
}

function SendSms(btn) {
	if (btn == "no") {
		return;
	}
	var count = MatordGrid.getStore().getCount()
		var vendorstr = ""
		for (i = 0; i < count; i++) {
			var rowData = MatordGrid.getStore().getAt(i);
			var vendor = rowData.get('vendordr');
			if (vendorstr == "") {
				vendorstr = vendor
			} else {
				vendorstr = vendorstr + "^" + vendor
			}

		}
		var LocId = Ext.getCmp('reclocField').getValue();
	vendorstr = filterRepeatStr(vendorstr)
		var ret = tkMakeServerCall("web.DHCSTM.HVMatOrdItm", "Sms", vendorstr, UserId, LocId);
	Msg.info("success", "�������!");

}

var formPanel = new Ext.ux.FormPanel({
		title: '�Ѳ�¼��ֵ�޸Ĺ�Ӧ��',
		tbar: [findhaveMatord, '-', createMatord, '-', clearMatord, '-', PrintIngrButton, '-', PrintInitButton, '-', PrintHvMatButton],
		items: [{
				xtype: 'fieldset',
				title: '����ѡ��',
				items: [{
						layout: 'column',
						defaults: {
							layout: 'form'
						},
						items: [{
								columnWidth: .3,
								labelWidth: 100,
								items: [reclocField, ordlocField, StkGrpType]
							}, {
								columnWidth: .22,
								labelWidth: 100,
								items: [startDateField, endDateField, InciDesc]
							}, {
								columnWidth: .25,
								labelWidth: 100,
								items: [Vendor, OrdRegno, OrdRegnoDetail]
							}, {
								columnWidth: .23,
								items: [Label, IngrFlag]
							}
						]
					}
				]
			}
		]	
	});

var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly: true,
		singleSelect: true,
		listeners: {
			beforerowselect: function (sm, rowIndex, keepExisting, record) {
				var IngrFlag = record.data["IngrFlag"];
				var canceled = record.data["canceled"];
				var barcode = record.data["barcode"];
			},
			rowselect: function (sm, rowIndex, record) {
				if (MatordGrid.activeEditor != null) {
					MatordGrid.activeEditor.completeEdit();
				}
				
				getTotalrp();
			},
			rowdeselect: function (sm, rowIndex, record) {
				getTotalrp();
			}
		}
	});
var MatordGrid = "";
//��������Դ
var MatordGridUrl = 'dhcstm.hvingdrecmodvendoraction.csp';
var MatordGridProxy = new Ext.data.HttpProxy({
		url: MatordGridUrl + '?actiontype=query',
		method: 'GET'
	});
var MatordGridDs = new Ext.data.Store({
		proxy: MatordGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			id: 'orirowid',
			totalProperty: 'results'
		}, [{
					name: 'oeori'
				}, {
					name: 'orirowid'
				}, {
					name: 'invamt'
				}, {
					name: 'code'
				}, {
					name: 'desc'
				}, {
					name: 'doctordr'
				}, {
					name: 'doctor'
				}, {
					name: 'orddate'
				}, {
					name: 'ordtime'
				}, {
					name: 'qty'
				}, {
					name: 'uomdr'
				}, {
					name: 'uomdesc'
				}, {
					name: 'pano'
				}, {
					name: 'paname'
				}, {
					name: 'ward'
				}, {
					name: 'bed'
				}, {
					name: 'prescno'
				}, {
					name: 'oeori'
				}, {
					name: 'vendorrowid'
				}, {
					name: 'manfdr'
				}, {
					name: 'vendor'
				}, {
					name: 'manf'
				}, {
					name: 'rp'
				}, {
					name: 'batno'
				}, {
					name: 'expdate',
					type: 'date',
					dateFormat: DateFormat
				}, {
					name: 'sp'
				}, {
					name: 'ordstatus'
				}, {
					name: 'admlocdr'
				}, {
					name: 'admloc'
				}, {
					name: 'date'
				}, {
					name: 'time'
				}, {
					name: 'user'
				}, {
					name: 'ingno'
				}, {
					name: 'dateofmanu'
				}, {
					name: 'canceled'
				}, {
					name: 'usercanceled'
				}, {
					name: 'datecanceled'
				}, {
					name: 'timecanceled'
				}, {
					name: 'ingrtno'
				}, {
					name: 'barcode'
				}, {
					name: 'inci'
				}, {
					name: 'dhcit'
				},
				'IngrFlag', 'vendordr', 'ingri',
				'IngriModify', 'IngriModifyNo', 'InitRecLoc'
			]),
		remoteSort: false
	});

var IngrVendor = new Ext.ux.VendorComboBox({
		valueParams: {
			LocId: gLocId,
			UserId: UserId
		}
	});

var canceled = new Ext.grid.CheckColumn({
		header: 'ȡ����־',
		dataIndex: 'canceled',
		width: 100,
		sortable: true,
		hidden: true,
		renderer: function (v, p, record) {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + ((v == 'Y') || (v == true) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		}
	});

//ģ��
var MatordGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			sm, {
				header: "oeori",
				dataIndex: 'oeori',
				width: 90,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "���ʴ���",
				dataIndex: 'code',
				width: 110,
				align: 'left',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'desc',
				width: 140,
				align: 'left',
				sortable: true
			}, {
				header: "����id",
				dataIndex: 'dhcit',
				width: 60,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "��ֵ����",
				dataIndex: 'barcode',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "��¼���",
				dataIndex: 'IngrFlag',
				width: 60,
				xtype: 'checkcolumn',
				isPlugin: false,
				align: 'center',
				sortable: true
			}, {
				header: "��¼��ⵥDr",
				dataIndex: 'IngriModify',
				width: 80,
				hidden: true
			}, {
				header: "��¼��ⵥ",
				dataIndex: 'IngriModifyNo',
				width: 160,
				align: 'left',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'dateofmanu',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'rp',
				width: 80,
				align: 'right',
				sortable: true,
				editable: false, //2015-06-16 �������޸Ľ���,����,Ч��
				editor: new Ext.form.TextField({
					id: 'rpField',
					allowBlank: false,
					selectOnFocus: true,
					tabIndex: 1
				})
			}, {
				header: "<font color=blue>��Ʊ���</font>",
				dataIndex: 'invamt',
				width: 80,
				align: 'right',
				sortable: true,
				editor: new Ext.form.NumberField({
					allowBlank: false,
					selectOnFocus: true
				})
			}, {
				header: "����",
				dataIndex: 'batno',
				width: 80,
				align: 'left',
				sortable: true,
				editable: false, //2015-06-16 �������޸Ľ���,����,Ч��
				editor: new Ext.form.TextField({
					id: 'batnoField',
					allowBlank: false,
					selectOnFocus: true
				})
			}, {
				header: "��Ч��",
				dataIndex: 'expdate',
				width: 80,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				editable: false, //2015-06-16 �������޸Ľ���,����,Ч��
				editor: new Ext.ux.DateField({
					id: 'expdateField'
				})
			}, {
				header: "��ⵥ��",
				dataIndex: 'ingno',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "���ߵǼǺ�",
				dataIndex: 'pano',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'paname',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "ҽ��",
				dataIndex: 'doctor',
				width: 60,
				align: 'left',
				sortable: true
			}, {
				header: "ҽ��״̬",
				dataIndex: 'ordstatus',
				width: 40,
				align: 'center',
				renderer: function (value) {
					var PoStatus = '';
					if (value == 'V') {
						PoStatus = '��ʵ';
					} else if (value == 'U') {
						PoStatus = '����';
					} else if (value == 'E') {
						PoStatus = 'ִ��';
					} else if (value == 'C') {
						PoStatus = '����';
					}
					return PoStatus;
				},
				sortable: true
			}, {
				header: "ҽ������",
				dataIndex: 'orddate',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "ҽ��ʱ��",
				dataIndex: 'ordtime',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'qty',
				width: 50,
				align: 'right',
				sortable: true
			}, {
				header: "��λ",
				dataIndex: 'uomdesc',
				width: 40,
				align: 'left'
			}, {
				header: "��¼���տ���",
				dataIndex: 'InitRecLoc',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "���߲���",
				dataIndex: 'admloc',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'bed',
				width: 40,
				align: 'left',
				sortable: true
			}, {
				header: "������",
				dataIndex: 'prescno',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��Ӧ��",
				dataIndex: 'vendordr',
				editor: new Ext.grid.GridEditor(IngrVendor),
				renderer: Ext.util.Format.comboRenderer2(IngrVendor, 'vendordr', 'vendor')
			}, {
				header: "����",
				dataIndex: 'manf',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "�ۼ�",
				dataIndex: 'sp',
				width: 80,
				align: 'right',
				sortable: true
			}, canceled
		]);
function getTotalrp() {
	var selarr = MatordGrid.getSelectionModel().getSelections();
	var totalrp = 0
		for (var i = 0; i < selarr.length; i++) {
			var rowData = selarr[i];
			var Rp = rowData.get("rp");
			totalrp = accAdd(totalrp, Rp)
		}
		Ext.getCmp("totalrp").setValue(totalrp);
}


//���
MatordGrid = new Ext.ux.EditorGridPanel({
		id: 'MatordGrid',
		store: MatordGridDs,
		tbar: ['���ϼ�:', '-', totalrp],
		//title:'��ϸ��Ϣ',
		cm: MatordGridCm,
		plugins: canceled,
		trackMouseOver: true,
		stripeRows: true,
		sm: sm,
		loadMask: true,
		clicksToEdit: 1,
		listeners: {
			beforeedit: function (e) {
				var IngrFlag = e.record.get('IngrFlag');
				if (IngrFlag == "Y") {
					return false;
				}
				if (e.field == 'vendordr' && !Ext.isEmpty(e.record.get('ingri'))) {
					e.cancel = true;
					Msg.info('warning', '������������¼,�������޸Ĺ�Ӧ��!');
				}
			}
		}
	});

//>>>>>>>>>>��ⵥ���Բ���>>>>>>>>>>
var GrMasterInfoStore = new Ext.data.JsonStore({
		url: DictUrl + 'ingdrecaction.csp?actiontype=QueryIngrStr',
		totalProperty: "results",
		root: 'rows',
		fields: ["IngrId", "IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp", "RpAmt", "SpAmt", "AcceptUser", "InvAmt"],
		listeners: {
			load: function (store, records, option) {
				if (records.length > 0) {
					GrMasterInfoGrid.getSelectionModel().selectFirstRow();
					GrMasterInfoGrid.getView().focusRow(0);
				}
			}
		}
	});

var GrMasterInfoCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "RowId",
				dataIndex: 'IngrId',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true,
				hideable: false
			}, {
				header: "��ⵥ��",
				dataIndex: 'IngrNo',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: '��ⲿ��',
				dataIndex: 'RecLoc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "��Ӧ��",
				dataIndex: 'Vendor',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				dataIndex: "StkGrp",
				hidden: true,
				hideable: false
			}, {
				header: '�ɹ�Ա',
				dataIndex: 'PurchUser',
				width: 70,
				align: 'left',
				sortable: true
			}, {
				header: "��ɱ�־",
				dataIndex: 'Complete',
				width: 70,
				align: 'left',
				sortable: true
			}, {
				header: "��Ʊ���",
				dataIndex: 'InvAmt',
				width: 80,
				xtype: 'numbercolumn',
				align: 'right'
			}, {
				header: "���۽��",
				dataIndex: 'RpAmt',
				width: 80,
				xtype: 'numbercolumn',
				align: 'right'
			}, {
				header: "�ۼ۽��",
				dataIndex: 'SpAmt',
				xtype: 'numbercolumn',
				width: 80,
				align: 'right'
			}, {
				header: "��ע",
				dataIndex: 'InGrRemarks',
				width: 160,
				align: 'left'
			}
		]);

var GridPagingToolbar = new Ext.PagingToolbar({
		store: GrMasterInfoStore,
		pageSize: PageSize,
		displayInfo: true
	});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
		id: 'GrMasterInfoGrid',
		title: '',
		//autoHeight: true,
		cm: GrMasterInfoCm,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function (sm, rowIndex, r) {
					var InGr = r.get("IngrId");
					GrDetailInfoStore.load({
						params: {
							start: 0,
							limit: 999,
							sort: 'Rowid',
							dir: 'Desc',
							Parref: InGr
						}
					});
				}
			}
		}),
		store: GrMasterInfoStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		bbar: [GridPagingToolbar]
	});

var GrDetailInfoStore = new Ext.data.JsonStore({
		url: DictUrl + 'ingdrecaction.csp?actiontype=QueryDetail',
		totalProperty: "results",
		root: 'rows',
		fields: ["Ingri", "BatchNo", "IngrUom", "ExpDate", "Inclb", "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc", "InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate", "QualityNo", "SxNo", "Remark", "MtDesc", "PubDesc",
			"CheckPort", "CheckRepNo", {
				name: 'CheckRepDate',
				type: 'date',
				dateFormat: DateFormat
			}, "AdmNo", {
				name: 'AdmExpdate',
				type: 'date',
				dateFormat: DateFormat
			}, "CheckPack", "InvMoney"]
	});

var GrDetailInfoCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "Ingri",
				dataIndex: 'Ingri',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true,
				hideable: false
			}, {
				header: '���ʴ���',
				dataIndex: 'IncCode',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: '��������',
				dataIndex: 'IncDesc',
				width: 230,
				align: 'left',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'Manf',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'BatchNo',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "��Ч��",
				dataIndex: 'ExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��λ",
				dataIndex: 'IngrUom',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'RecQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'Rp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "�ۼ�",
				dataIndex: 'Sp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "��Ʊ��",
				dataIndex: 'InvNo',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "��Ʊ����",
				dataIndex: 'InvDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��Ʊ���",
				dataIndex: 'InvMoney',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "���۽��",
				dataIndex: 'RpAmt',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "�ۼ۽��",
				dataIndex: 'SpAmt',
				width: 100,
				align: 'left',
				sortable: true
			}
		]);

var GrDetailInfoGrid = new Ext.grid.GridPanel({
		id: 'GrDetailInfoGrid',
		title: '',
		height: 170,
		cm: GrDetailInfoCm,
		store: GrDetailInfoStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true
	});

var IngrInfoPanel = new Ext.Panel({
		layout: 'border',
		items: [{
				region: 'north',
				layout: 'fit',
				height: 200,
				items: GrMasterInfoGrid
			}, {
				region: 'center',
				layout: 'fit',
				items: GrDetailInfoGrid
			}
		]
	});
//<<<<<<<<<<��ⵥ���Բ���<<<<<<<<<<

//>>>>>>>>>>���ⵥ���Բ���>>>>>>>>>>
var InitMasterStore = new Ext.data.JsonStore({
		url: DictUrl + 'dhcinistrfaction.csp?actiontype=QueryTrans',
		totalProperty: "results",
		root: 'rows',
		fields: ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd", "tt", "comp", "userName",
			"status", "RpAmt", "SpAmt", "MarginAmt", "Remark", "StatusCode", "confirmFlag"],
		listeners: {
			load: function (store, records, options) {
				if (records.length > 0) {
					InitMasterGrid.getSelectionModel().selectFirstRow();
					InitMasterGrid.getView().focusRow(0);
				}
			}
		}
	});

var InitMasterCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "RowId",
				dataIndex: 'init',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "ת�Ƶ���",
				dataIndex: 'initNo',
				width: 160,
				align: 'left',
				sortable: true
			}, {
				header: "������",
				dataIndex: 'toLocDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'frLocDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "ת������",
				dataIndex: 'dd',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				header: "�Ƶ���",
				dataIndex: 'userName',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "���۽��",
				dataIndex: 'RpAmt',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "�ۼ۽��",
				dataIndex: 'SpAmt',
				width: 80,
				align: 'right',
				sortable: true
			}
		]);

var InitMasterPagingToolbar = new Ext.PagingToolbar({
		store: InitMasterStore,
		pageSize: PageSize,
		displayInfo: true
	});
var InitMasterGrid = new Ext.grid.GridPanel({
		title: '',
		height: 170,
		cm: InitMasterCm,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function (sm, rowIndex, r) {
					var InIt = r.get("init");
					InitDetailStore.setBaseParam('Parref', InIt);
					InitDetailStore.removeAll();
					InitDetailStore.load({
						params: {
							start: 0,
							limit: InitDetailPagingToolbar.pageSize,
							sort: 'Rowid',
							dir: 'Desc'
						}
					})
				}
			}
		}),
		store: InitMasterStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		bbar: InitMasterPagingToolbar
	});

var InitDetailStore = new Ext.data.JsonStore({
		url: DictUrl + 'dhcinistrfaction.csp?actiontype=QueryDetail',
		totalProperty: "results",
		root: 'rows',
		fields: ["initi", "inrqi", "inci", "inciCode",
			"inciDesc", "inclb", "batexp", "manf", "manfName",
			"qty", "uom", "sp", "status", "remark",
			"reqQty", "inclbQty", "reqLocStkQty", "stkbin", "pp", "spec", "newSp",
			"spAmt", "rp", "rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty", "TrUomDesc"]
	});

var InitDetailCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "ת��ϸ��RowId",
				dataIndex: 'initi',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "����Id",
				dataIndex: 'inci',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: '���ʴ���',
				dataIndex: 'inciCode',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: '��������',
				dataIndex: 'inciDesc',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "����Id",
				dataIndex: 'inclb',
				width: 180,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "����/Ч��",
				dataIndex: 'batexp',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'manfName',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "���ο��",
				dataIndex: 'inclbQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "ת������",
				dataIndex: 'qty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "ת�Ƶ�λ",
				dataIndex: 'TrUomDesc',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'rp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "�ۼ�",
				dataIndex: 'sp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'reqQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "��λ��",
				dataIndex: 'stkbin',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "���󷽿��",
				dataIndex: 'reqLocStkQty',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "ռ������",
				dataIndex: 'inclbDirtyQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'inclbAvaQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "�����ۼ�",
				dataIndex: 'newSp',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "���",
				dataIndex: 'spec',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "�ۼ۽��",
				dataIndex: 'spAmt',
				width: 100,
				align: 'right',

				sortable: true
			}, {
				header: "���۽��",
				dataIndex: 'rpAmt',
				width: 100,
				align: 'right',
				sortable: true
			}
		]);

var InitDetailPagingToolbar = new Ext.PagingToolbar({
		store: InitDetailStore,
		pageSize: PageSize,
		displayInfo: true
	});

var InitDetailGrid = new Ext.grid.GridPanel({
		title: '',
		height: 200,
		cm: InitDetailCm,
		store: InitDetailStore,
		trackMouseOver: true,
		stripeRows: true,
		bbar: InitDetailPagingToolbar,
		loadMask: true
	});

var InitInfoPanel = new Ext.Panel({
		layout: 'border',
		items: [{
				region: 'north',
				layout: 'fit',
				height: 200,
				items: InitMasterGrid
			}, {
				region: 'center',
				layout: 'fit',
				items: InitDetailGrid
			}
		]
	});
//<<<<<<<<<<���ⵥ���Բ���<<<<<<<<<<

var tabPanel = new Ext.TabPanel({
		region: 'center',
		activeTab: 0,
		items: [{
				title: '��ֵҽ����Ϣ',
				id: 'HVMatPanel',
				layout: 'fit',
				items: MatordGrid
			}, {
				title: '���β�¼�����Ϣ',
				id: 'CurrentIngrPanel',
				layout: 'fit',
				items: IngrInfoPanel
			}, {
				title: '���β�¼������Ϣ',
				id: 'CurrentInitPanel',
				layout: 'fit',
				items: InitInfoPanel
			}
		],
		listeners: {
			'tabchange': function (t, p) {
				if (p.getId() == 'CurrentIngrPanel') {
					if (CURRENT_INGR != "") {
						GrMasterInfoGrid.getStore().load({
							params: {
								IngrStr: CURRENT_INGR
							}
						});
					}
				} else if (p.getId() == 'CurrentInitPanel') {
					if (CURRENT_INIT != "") {
						InitMasterGrid.getStore().load({
							params: {
								InitStr: CURRENT_INIT
							}
						});
					}
				}
			}
		}
	});

//===========ģ����ҳ��=============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, tabPanel]
		});
});
//===========ģ����ҳ��=============================================
