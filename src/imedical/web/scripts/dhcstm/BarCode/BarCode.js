// ����:��ֵ�������ɹ���
// ��д�ˣ��쳬
// ��д����:2013-09-17
var gGroupId = session['LOGON.GROUPID'];
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var inciDr = "";
var BarcodeArr = [];
var colArr = [];
/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N",
			"0", gHospId, getDrugList, "", "",
			"", "", "", "", "Y",
			"", "Y");
	}
}

/**
 * ���ط���
 */
function getDrugList(records) {
	var CurStartRow; //��¼����¼��ĵ�һ��
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records, function (record, index, allItems) {
		var inciDr = record.get("InciDr");

		var cell = BarCodeGrid.getSelectionModel().getSelectedCell(); // ѡ����
		var row = cell[0];
		var col = cell[1];
		var HVFlag = record.get("HVFlag");
		if (HVFlag == 'N') {
			Msg.info("warning", "�ò��ϲ��Ǹ�ֵ����!");
			BarCodeGrid.startEditing(row, col);
			return;
		}
		var rowData = BarCodeGrid.getAt(row);
		rowData.set("IncId", inciDr);
		
		var Params = session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + gUserId; //ȡ����������Ϣ
		var url = DictUrl + "ingdrecaction.csp?actiontype=GetItmInfo&IncId=" + inciDr + "&Params=" + Params;
		var response = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(response);
		if (jsonData.success == 'true') {
			var info = jsonData.info;
			if (info != null || info != '') {
				var data = jsonData.info.split("^");
				var inciCode = data[26], inciDesc = data[27];
				rowData.set("IncCode", inciCode);
				rowData.set("IncDesc", inciDesc);
				
				addComboData(PhManufacturerStore, data[0], data[1]);
				rowData.set("ManfId", data[0]);
				rowData.set("PurUomId", data[2]);
				var ConFac = data[11];
				rowData.set('Qty', ConFac);			//��ⵥλ�ͻ�����λ��һ��, Ĭ�ϴ�ӡ��������Ϊת��ϵ��
				rowData.set("PurUom", data[3]);
				rowData.set('Spec', data[17]);
				rowData.set("Rp", Number(data[23])); //2016-01-21 ��������λ����
				rowData.set("Sp", Number(data[24]));
				rowData.set("NewSp", Number(data[24]));
				//rowData.set("BatNo", data[6]);			//���ﲻҪ������Ч�ڸ�ֵ��,�����������ͻ,Ҳû��������,���������ر����
				//rowData.set("ExpDate", toDate(data[7]));
				rowData.set("BUomId", data[10]);
				rowData.set("BUom", data[25]);
				rowData.set('CerNo', data[28]);
				rowData.set('CerExpDate', data[29]);
				rowData.set('BatchCodeFlag', data[32]);
				var Marginnow = '';
				if (Number(data[4]) > 0) {
					Marginnow = accSub(accDiv(Number(data[5]), Number(data[4])), 1);
				}
				rowData.set('Marginnow', Marginnow);
				if (row > 0 && (data[20] == null || data[20] == "")) {
					var vendorId = BarCodeGrid.getAt(row - 1).get('VendorId');
					rowData.set("VendorId", vendorId);
				} else {
					addComboData(Ext.getCmp("VendorField").getStore(), data[20], data[21]);
					rowData.set("VendorId", data[20]);
				}
			
				//��ʵ������Ϣ
				var StrParam = '^' + inciDr + '^' + data[0]; //vendor^inci^manf
				var AlarmDays = 30;
				var CheckInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'Check', StrParam, AlarmDays);
				if (!Ext.isEmpty(CheckInfo)) {
					Msg.info("warning", inciDesc + ':' + CheckInfo);
				}
			}
		}
		if (!CurStartRow) {
			CurStartRow = row;
		}
		if(index < allItems.length - 1){
			BarCodeGrid.addNewRow();
		}
	});
	
	if(setEnterSort(BarCodeGrid, colArr)){
		BarCodeGrid.addNewRow();
	}
}

//������
var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '����',
		id: 'PhaLoc',
		anchor: '90%',
		emptyText: '����...',
		groupId: session['LOGON.GROUPID']
	});

var VirtualFlag = new Ext.form.Checkbox({
		hideLabel: true,
		boxLabel: G_VIRTUAL_STORE,
		id: 'VirtualFlag',
		anchor: '90%',
		checked: false,
		listeners: {
			check: function (chk, bool) {
				if (bool) {
					var phaloc = Ext.getCmp("PhaLoc").getValue();
					var info = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLoc', phaloc);
					var url = "dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc=" + phaloc;
					var infoArr = info.split("^");
					var vituralLoc = infoArr[0],
					vituralLocDesc = infoArr[1];
					addComboData(Ext.getCmp("PhaLoc").getStore(), vituralLoc, vituralLocDesc);
					Ext.getCmp("PhaLoc").setValue(vituralLoc);
				} else {
					SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
				}
			}
		}
	});

VirtualFlag.setValue(true);

var RegFlag = new Ext.form.Checkbox({
		hideLabel: true,
		boxLabel: "�����",
		id: 'RegFlag',
		anchor: '90%',
		checked: false
	});
//��⹩Ӧ��
var ImpVendor = new Ext.ux.VendorComboBox({
		fieldLabel: '��⹩Ӧ��',
		id: 'ImpVendor',
		anchor: '90%'
	});
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel: '������',
		id: 'INFOPbCarrier',
		name: 'INFOPbCarrier',
		store: CarrierStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CADesc'
	});    
var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel: '�ʽ���Դ',
		id: 'SourceOfFund',
		anchor: '90%',
		store: SourceOfFundStore
	});

var ToLoc = new Ext.ux.LocComboBox({
		fieldLabel: '���տ���',
		id: 'ToLoc',
		anchor: '90%',
		emptyText: '���տ���...',
		groupId: gGroupId,
		linkloc: gLocId,
		defaultLoc: {}
	});
	
var startDate = new Ext.ux.DateField({
		id: 'startDate',
		allowBlank: true,
		fieldLabel: '��ʼ����',
		anchor: '90%',
		value: DefaultStDate()
	});
// ��ֹ����
var endDate = new Ext.ux.DateField({
		id: 'endDate',
		allowBlank: true,
		fieldLabel: '��ֹ����',
		anchor: '90%',
		value: DefaultEdDate()
	});
// ����
var StkGrpType = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		fieldLabel: '<font color=red>*����</font>',
		StkType: App_StkTypeCode, // ��ʶ��������
		UserId: gUserId,
		LocId: gLocId,
		anchor: '90%'
	});

var BarCodeField = new Ext.form.TextField({
		id: 'BarCodeField',
		fieldLabel: '������',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()
				}
			}
		}
	});
var BatNo = new Ext.form.TextField({
		id: 'BatNo',
		fieldLabel: '����',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()
				}
			}
		}
	});

var LocField = new Ext.ux.LocComboBox({
		fieldLabel: '���ɿ���',
		id: 'LocField',
		name: 'LocField',
		anchor: '90%',
		emptyText: '���ɿ���...',
		groupId: gGroupId,
		linkloc: gLocId,
		listeners: {
			'select': function (cb) {
				var requestLoc = cb.getValue();
				var defprovLocs = tkMakeServerCall("web.DHCSTM.DHCTransferLocConf", "GetDefLoc", requestLoc, gGroupId);
				var mainArr = defprovLocs.split("^");
				var defprovLoc = mainArr[0];
				var defprovLocdesc = mainArr[1];
			}
		},
		defaultLoc: {}
		//Ĭ��ֵΪ��
	});

// ���ʱ���
var M_InciCode = new Ext.form.TextField({
		fieldLabel: '���ʱ���',
		id: 'M_InciCode',
		name: 'M_InciCode',
		anchor: '90%',
		width: 150,
		disabled: true,
		valueNotFoundText: ''
	});

// ��������
var M_InciDesc = new Ext.form.TextField({
		fieldLabel: '��������',
		id: 'M_InciDesc',
		name: 'M_InciDesc',
		anchor: '90%',
		width: 150,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo2(field.getValue(), stktype);
				}
			},
			blur: function (field) {
				if (field.getValue() == "") {
					inciDr = "";
					Ext.getCmp("M_InciCode").setValue("");
				}
			}
		}
	});
function GetPhaOrderInfo2(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N",
			"0", gHospId, getDrugList2, "", "",
			"", "", "", "", "",
			"", "Y");
	}
}
function getDrugList2(record) {
	inciDr = record.get("InciDr");
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(inciDesc);
	Ext.getCmp("M_InciCode").setValue(inciCode);
}

var Vendor = new Ext.ux.VendorComboBox({
		id: 'Vendor',
		name: 'Vendor',
		anchor: '90%'
	});
var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '������',
		id: 'RequestPhaLoc',
		name: 'RequestPhaLoc',
		anchor: '90%',
		emptyText: '������...',
		defaultLoc: {}
	});

var Specom = new Ext.form.ComboBox({
		fieldLabel: '������',
		id: 'Specom',
		name: 'Specom',
		anchor: '90%',
		width: 120,
		listWidth: 210,
		store: SpecDescStore,
		valueField: 'Description',
		displayField: 'Description',
		triggerAction: 'all',
		emptyText: '������...',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		pageSize: 10,
		valueNotFoundText: '',
		listeners: ({
			'beforequery': function () {
				var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
				var record = BarCodeGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("IncId");
				var desc = this.getRawValue();
				this.store.removeAll(); //load֮ǰremoveԭ��¼���������׳���
				this.store.setBaseParam('SpecItmRowId', IncRowid)
				this.store.setBaseParam('desc', desc)
				this.store.load({
					params: {
						start: 0,
						limit: this.pageSize
					}
				})
			},
			specialkey : function(field, e){
				if(e.getKey() == Ext.EventObject.ENTER){
					if(setEnterSort(BarCodeGrid, colArr)){
						BarCodeGrid.addNewRow();
					}
				}
			}
		})
	});

var Manf = new Ext.ux.ComboBox({
		fieldLabel: '����',
		id: 'Manf',
		store: PhManufacturerStore,
		emptyText: ' ����...',
		filterName: 'PHMNFName',
		params: {
			ScgId: 'StkGrpType'
		}
	});

var VendorField = new Ext.ux.VendorComboBox({
		id: 'VendorField',
		name: 'VendorField',
		allowBlank: gItmTrackParam[7] == "Y" ? false : true,
		anchor: '90%'
	});
/// �ж��Դ������Ƿ����
function  GetRepeatResult(store,colName,colValue,beginIndex,inciDesc,row){
	beginIndex=store.findExact(colName,colValue,beginIndex);
	return beginIndex;
}
var BarCodeGridCm = [{
		header: "dhcit",
		dataIndex: 'InctrackId',
		saveColIndex: 0,
		hidden: true
	}, {
		header: "IncId",
		dataIndex: 'IncId',
		saveColIndex: 1,
		hidden: true,
		hideable: false
	}, {
		header: "���ʴ���",
		dataIndex: 'IncCode',
		width: 150,
		align: 'left',
		renderer: Ext.util.Format.InciPicRenderer('IncId'),
		sortable: true
	}, {
		header: "��������",
		dataIndex: 'IncDesc',
		width: 200,
		align: 'left',
		sortable: true,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: false,
				allowBlank: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var row = BarCodeGrid.getSelectedCell()[0];
							var RowData = BarCodeGrid.getAt(row);
							
							var Input = field.getValue();
							var BarCodeObj = GetBarCodeSplitInfo(Input);
							var InciId = BarCodeObj['InciId'];
							var BatchNo = BarCodeObj['BatchNo'];
							var ExpDate = BarCodeObj['ExpDate'];
							if(!Ext.isEmpty(InciId)){
								if(!Ext.isEmpty(BatchNo) || !Ext.isEmpty(ExpDate)){
									field.setValue('');		//û�����Ļ�,��������set����ֵ
									RowData.set('OriginalCode', Input);
									//RowData.set('OldOriginalCode', Input);
									RowData.set('BatNo', BatchNo);
									RowData.set('ExpDate', ExpDate);
									var ExpDateStr = Ext.isEmpty(ExpDate) ? '' : ExpDate.format(DateFormat);
									Msg.info('warning', '�Զ����������:' + BatchNo + ',��Ч��:' + ExpDateStr + ', ��ע��˶�!');
									
									//���������ܻ�ȡ����¼��,��ֱ�ӽ�������set
									var record = Ext.data.Record.create([
										{
											name : 'InciDr',
											type : 'string'
										}
									]);
									var InciRecord = new record({
										InciDr : InciId
									});
									getDrugList(InciRecord);
								}else{
									if(Input.length > 22){
										Msg.info('warning', '����Ч���޷�����, ���������ֹ���!')
									}
									return false;
								}
							}else if(Input.length >= 22){
								Msg.info('warning', '����ɨ�����뵫�޷�����, ��ά�������ֹ���!')
							}else{
								var group = Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(), group);
							}
						}
					}
				}
			}))
	}, {
		header: "���",
		dataIndex: 'Spec'
	}, {
		header: "������",
		dataIndex: 'SpecDesc',
		saveColIndex: 8,
		width: 100,
		align: 'left',
		sortable: true,
		editor: new Ext.grid.GridEditor(Specom),
		renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
	}, {
		header: "����",
		dataIndex: 'Qty',
		width: 80,
		align: 'right',
		saveColIndex: 3,
		editor: new Ext.form.NumberField({
			selectOnFocus: true,
			allowBlank: false,
			allowNegative: false,
			allowDecimals: false,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var qty = field.getValue();
						if (qty == null || qty.length <= 0) {
							Msg.info("warning", "��������Ϊ��!");
							return;
						}
						if(setEnterSort(BarCodeGrid, colArr)){
							BarCodeGrid.addNewRow();
						}
					}
				}
			}
		})
	}, {
		header: "��������",
		dataIndex: 'BarCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex: 2,
		editable: false, //2015-12-28 ���ɱ༭
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if(setEnterSort(BarCodeGrid, colArr)){
								BarCodeGrid.addNewRow();
							}
						}
					}
				}
			}))
	}, {
		header: "��ӡ",
		xtype: 'checkcolumn',
		dataIndex: 'print',
		width: 40
	}, {
		header: "�����Դ�����",
		dataIndex: 'OldOriginalCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex: 19,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
							var row = cell[0];
							
							var RowData = BarCodeGrid.getAt(row);
							var OriginalCode = field.getValue();
							if(!Ext.isEmpty(OriginalCode)){
								var BarCodeObj = GetBarCodeSplitInfo(OriginalCode);
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'];
								if(!Ext.isEmpty(BatchNo) && !Ext.isEmpty(ExpDate)){
									var ExpDateStr = Ext.isEmpty(ExpDate) ? '' : ExpDate.format(DateFormat);
									Msg.info('warning', '�Զ����������:' + BatchNo + ',��Ч��:' + ExpDateStr + ', ��ע��˶�!');
									RowData.set('BatNo', BatchNo);
									RowData.set('ExpDate', ExpDate);
								}
							}
							
							if(OriginalCode.length <= 22){
								//�Դ����뾭���ֶ�,̫��˵���ֶ���,���ﲻ��ת
								return false;
							}else{
								if(setEnterSort(BarCodeGrid, colArr)){
									BarCodeGrid.addNewRow();
								}
							}
						}
					}
				}
			}))
	}, {
		header: "�Դ�����",
		dataIndex: 'OriginalCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex: 4,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							//�Դ����뾭���ֶ�,���ﲻ��ת��
							var oribarcode=field.getValue();
							if(!Ext.isEmpty(oribarcode)){
								var BarCodestore=BarCodeGrid.getStore();
								var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
								var row = cell[0];
								var RowData = BarCodeGrid.getAt(row);
								var retinfo=GetRepeatResult(BarCodestore,'OriginalCode',oribarcode,0,oribarcode,row);
								var ret=tkMakeServerCall("web.DHCSTM.DHCItmTrack","OriBarIfExit",oribarcode);
								if(ret==1){
									Msg.info("warning",oribarcode+"�Ѿ����ڣ�");
									field.setValue("");
									return false;
								}
								if(retinfo!=-1){
									Msg.info("warning",oribarcode+"�Ѿ����ڣ�");
									field.setValue("");
									return false;
								}
								
								//�Զ��������Ч��
								var BarCodeObj = GetBarCodeSplitInfo(oribarcode);
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'];
								if(!Ext.isEmpty(BatchNo) && !Ext.isEmpty(ExpDate)){
									var ExpDateStr = Ext.isEmpty(ExpDate) ? '' : ExpDate.format(DateFormat);
									Msg.info('warning', '�Զ����������:' + BatchNo + ',��Ч��:' + ExpDateStr + ', ��ע��˶�!');
									RowData.set('BatNo', BatchNo);
									RowData.set('ExpDate', ExpDate);
								}
							}
							
							if(oribarcode.length <= 22){
								//�Դ����뾭���ֶ�,̫��˵���ֶ���,���ﲻ��ת
								return false;
							}else{
								if(setEnterSort(BarCodeGrid, colArr)){
									BarCodeGrid.addNewRow();
								}
							}
						}
					}
				}
			}))
	}, {
		header: "����(ע��)��Ա",
		dataIndex: 'User'
	}, {
		header: "����(ע��)����",
		dataIndex: 'Date'
	}, {
		header: "����(ע��)ʱ��",
		dataIndex: 'Time'
	}, {
		header: "PoItmId",
		dataIndex: 'PoItmId',
		saveColIndex: 5,
		hidden: true
	}, {
		header: "���󵥺�",
		dataIndex: 'ReqNo',
		hidden: true
	}, {
		header: "Ʒ��",
		dataIndex: 'Brand',
		hidden: true
	}, {
		header: "����",
		dataIndex: 'Rp',
		width: 60,
		align: 'right',
		sortable: true,
		saveColIndex: 12,
		summaryType : 'sum',
		editor: new Ext.ux.NumberField({
			formatType: 'FmtRP',
			selectOnFocus: true,
			allowBlank: false,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						if (cost == null || cost.length <= 0) {
							Msg.info("warning", "���۲���Ϊ��!");
							return;
						}
						if (cost <= 0) {
							Msg.info("warning", "���۲���С�ڻ����0!");
							return;
						}
						if(setEnterSort(BarCodeGrid, colArr)){
							BarCodeGrid.addNewRow();
						}
					}
				}
			}
		})
	}, {
		header: "����",
		dataIndex: 'BatNo',
		width: 90,
		align: 'center',
		sortable: true,
		saveColIndex: 6,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if(setEnterSort(BarCodeGrid, colArr)){
								BarCodeGrid.addNewRow();
							}
						}
					}
				}
			}))
	}, {
		header: "��Ч��",
		xtype: 'datecolumn',
		dataIndex: 'ExpDate',
		width: 100,
		align: 'center',
		sortable: true,
		saveColIndex: 7,
		editor: new Ext.ux.DateField({
			selectOnFocus: true,
			allowBlank: true,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var expDate = field.getValue();
						if (expDate == null || expDate.length <= 0) {
							Msg.info("warning", "��Ч�ڲ���Ϊ��!");
							return;
						}
						var nowdate = new Date();
						if (expDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT)) {
							Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
							return;
						}
						BarCodeGrid.addNewRow();
					}
				}
			}
		})
	}, {
		header: "��ǰ�ۼ�",
		dataIndex: 'Sp',
		align: 'right'
	}, {
		header: "�������",
		dataIndex: 'ReqLocDesc'
	}, {
		header: "�б����",
		dataIndex: 'PbRp'
	}, {
		header: "�ӳ���",
		dataIndex: 'Marginnow',
		align: 'right'
	}, {
		header: "ע��֤��",
		dataIndex: 'CerNo',
		saveColIndex: 10,
		editor: new Ext.form.TextField({
			selectOnFocus: true,
			allowBlank: true
		})
	}, {
		header: "ע��֤Ч��",
		xtype: 'datecolumn',
		dataIndex: 'CerExpDate',
		saveColIndex: 11,
		sortable: true,
		editor: new Ext.ux.DateField({
			selectOnFocus: true,
			allowBlank: true
		})
	}, {
		header: "��������",
		xtype: 'datecolumn',
		dataIndex: 'ProduceDate',
		width: 100,
		align: 'center',
		sortable: true,
		saveColIndex: 9,
		editor: new Ext.ux.DateField({
			selectOnFocus: true,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(BarCodeGrid, colArr)){
							BarCodeGrid.addNewRow();
						}
					}
				}
			}
		})
	}, {
		header: "��ⵥλ",
		dataIndex: 'PurUomId',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "������λ",
		dataIndex: 'BUomId',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "������λ����",
		dataIndex: 'BUom',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "����ӱ�id",
		dataIndex: 'Ingri',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: '����',
		dataIndex: 'ManfId',
		saveColIndex: 13,
		xtype: 'combocolumn',
		valueField: 'ManfId',
		displayField: 'ManfDesc',
		editor: Manf
	}, {
		header: "��Ӧ��",
		dataIndex: 'VendorId',
		saveColIndex: 14,
		xtype: 'combocolumn',
		valueField: 'VendorId',
		displayField: 'VendorDesc',
		editor: VendorField
	}, {
		header: "ƽ̨�ӱ�id",
		dataIndex: 'OrderDetailSubId',
		width: 80,
		align: 'left',
		saveColIndex: 15,
		sortable: true,
		hidden: true
	},{
		header : "���е���",
		dataIndex : 'SxNo',
		width : 90,
		align : 'left',
		saveColIndex : 16,
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true
		})
	}, {
		header: "����Ҫ��",
		dataIndex: 'BatchReq',
		hidden: true
	}, {
		header: "Ч��Ҫ��",
		dataIndex: 'ExpReq',
		hidden: true
	}, {
		header: "������",
		dataIndex: 'BatchCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex : 17,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) { 
						        BarCodeGrid.startEditing(row + 1, col);
							
						}
					}
				}
			}))
	},{
		header : "�������־",
		dataIndex : 'BatchCodeFlag',
		hidden : false  //20190525
	}
];

function paramsFn() {
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var startDate = Ext.getCmp("startDate").getValue();
	if(startDate==""){
		startDate=(new Date())
		}
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = Ext.getCmp("endDate").getValue();
	if(endDate==""){
		endDate=(new Date())
		}
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '��ֹ���ڲ���Ϊ��!');
		return false;
	}
	endDate = endDate.format(ARG_DATEFORMAT);
	var vendor = Ext.getCmp("Vendor").getValue();
	var reqloc = Ext.getCmp("RequestPhaLoc").getValue();
	var batno = Ext.getCmp("BatNo").getValue();
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var CreatLoc = Ext.getCmp("LocField").getValue();
	
	var Status = Ext.getCmp("RegFlag").getValue()==true? 'Enable' : '';
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
		 + "^" + endDate + "^" + vendor + "^" + reqloc + "^" + batno + "^" + gHospId
		 + "^" + "" + "^" + gLocId + "^" + CreatLoc+"^"+Status;
	return {
		'Param': Param
	};
}

function cellSelectFn(sm, rowIndex, colIndex) {
	/*
	var InctrackId = BarCodeGrid.getCell(rowIndex,BarCodeGrid.idProperty);
	//����ɱ༭, �Ͳ���ִ�и÷�����, ���������Ӧ����
	var ColumnHeader = sm.grid.getColumnModel().getDataIndex(colIndex);
	if (!Ext.isEmpty(InctrackId) && (ColumnHeader=='OriginalCode' || ColumnHeader=='Rp' || ColumnHeader=='BatNo' || ColumnHeader=='ExpDate' || ColumnHeader=='SpecDesc' || ColumnHeader=='ProduceDate')) {
	return false;
	}

	var rowData = BarCodeGrid.getAt(rowIndex);
	var BarCode = rowData.get("BarCode");
	if(BarCode!=""){
	$("#SaveBarCodeDiv").barcode(BarCode, "code39",{barWidth:1, barHeight:40,showHRI:true,fontSize:20}); ///�ȴ浽һ��div
	//�����ݸ��Ƶ���һ��div
	var addBarCode=Ext.get("SaveBarCodeDiv").dom.innerHTML;
	var totalBarcode=Ext.get("ShowBarCodeDiv").dom.innerHTML
	var index=totalBarcode.indexOf(addBarCode);
	var len=addBarCode.length;
	if(index>=0){
	var str1=totalBarcode.slice(0,index);
	var str2=totalBarcode.slice(index+len);
	Ext.get("ShowBarCodeDiv").dom.innerHTML=str1.concat(str2);
	BarcodeArr.remove(BarCode);
	}else{
	Ext.get("ShowBarCodeDiv").dom.innerHTML=Ext.get("ShowBarCodeDiv").dom.innerHTML+addBarCode;
	BarcodeArr.push(BarCode);
	}
	}
	 */
}

function beforeAddFn() {
	var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
	if (StkGrpType == null || StkGrpType.length <= 0) {
		Msg.info("warning", "��ѡ������!");
		return false;
	}
	colArr = sortColoumByEnterSort(BarCodeGrid);
}

var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// ���
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'center',
		id: 'BarCodeGrid',
		contentColumns: BarCodeGridCm,
		smRowSelFn: cellSelectFn,
		singleSelect: false,
		selectFirst: false,
		actionUrl: BarCodeGridUrl,
		queryAction: "query",
		idProperty: "InctrackId",
		checkProperty: "IncId",
		paramsFn: paramsFn,
		beforeAddFn: beforeAddFn,
		delRowAction: "Delete",
		delRowParam: "RowId",
		//plugins : new Ext.grid.GridSummary(),
		paging: false, //2015-12-23 ���ֱ����⹦�ܺ�,�ݲ�ʹ�÷�ҳ������
		listeners: {
			'beforeedit': function (e) {
				var InctrackId = BarCodeGrid.getCell(e.row, "InctrackId");
				var BatchCodeFlag=BarCodeGrid.getCell(e.row, "BatchCodeFlag");
				if (!Ext.isEmpty(InctrackId) && e.field != 'OriginalCode' && e.field != 'OldOriginalCode' && e.field != 'BatNo' && e.field != 'ExpDate' && e.field != 'SpecDesc' && e.field != 'ProduceDate' && e.field != 'Rp' && e.field != 'ManfId' && e.field != 'CerNo' && e.field != 'CerExpDate' && e.field != 'VendorId'&& e.field != 'BatchCode'&&(e.field != 'Qty')) {
					return false; // �����޸� ��������Ĳ������޸�
				}
				if (!Ext.isEmpty(InctrackId)&&(e.field == 'Qty')&&(BatchCodeFlag!="Y")){
				   return false;
				}
				
			},
			'rowcontextmenu': function (grid, rowindex, e) {
				e.preventDefault();
				grid.getSelectionModel().select(rowindex, 1);
				//����δ�����������ϸ�����Ҽ��˵�
				if (grid.getStore().getAt(rowindex).get('InctrackId') == '') {
					rightClick.showAt(e.getXY());
				}
			},
			'rowdblclick': function (grid, rowIndex, e) {
				var record = grid.getStore().getAt(rowIndex)
					var dhcit = record.get('InctrackId');
				if (Ext.isEmpty(dhcit)) {
					return;
				}
				var BarCode = record.get('BarCode');
				var IncDesc = record.get('IncDesc');
				var InfoStr = BarCode + ' : ' + IncDesc;
				BarCodePackItm(dhcit, InfoStr);
			},
			'afteredit': function (e) {
				if (e.field == 'Rp') {
					var cost = e.value;
					if (Ext.isEmpty(cost)) {
						Msg.info("warning", "���۲���Ϊ��!");
						e.record.set('Rp', e.originalValue);
						return;
					} else if (cost < 0) {
						//2016-09-26���ۿ�Ϊ0
						Msg.info("warning", "���۲���С��0!");
						e.record.set('Rp', e.originalValue);
						return;
					}
					//�����ۼۻ��������۸��ݽ������¼����ۼ�
					var AllowAspWhileReceive=GetRecAdjspFlag();
					if (BatSpFlag == 1||AllowAspWhileReceive=="Y") {
						var IncId = e.record.get('IncId');
						var UomId = e.record.get('BUomId');
						var Rp = e.value;
						var url = 'dhcstm.ingdrecaction.csp?actiontype=GetMtSp&IncId=' + IncId + '&UomId=' + UomId + '&Rp=' + Rp;
						var responseText = ExecuteDBSynAccess(url);
						var jsonData = Ext.util.JSON.decode(responseText);
						if (jsonData.success == 'true') {
							var MtSp = jsonData.info;
							e.record.set("Sp", MtSp);
						}
					}
				}else if(e.field == 'Qty'){
					if (!Ext.isNumber(e.value) || e.value > 1000) {
						Msg.info("warning", "�������ܳ���1000!");
						e.record.set('Qty',e.originalValue);
						return;
					}
				}
			}
		}
	});

var rightClick = new Ext.menu.Menu({
		id: 'rightClickCont',
		items: [{
				id: 'mnuDelete',
				handler: function (item, e) {
					BarCodeGrid.deleteRow();
				},
				text: 'ɾ��'
			}, {
				id: 'mnuSplit',
				handler: SplitDetail,
				text: '�����ϸ'
			}
		]
	});

var rowsAdd = 1000;
function SplitDetail(item, e) {
	var cell = BarCodeGrid.getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "û��ѡ����!");
		return;
	}
	var row = cell[0];
	var record = BarCodeGrid.getStore().getAt(row);
	if (record.get('InctrackId') != "") {
		Msg.info('error', '�ѱ������벻�ɲ��!');
		return;
	}
	var qty = record.get('Qty');
	var qty = (Ext.isEmpty(qty) || qty <= 1) ? 2 : record.get('Qty');
	record.set('Qty', 1);
	var BarCodeStore = BarCodeGrid.getStore();
	for (var i = 1; i < qty; i++) {
		var newRecord = new BarCodeStore.recordType(record.copy().data, ++rowsAdd);
		BarCodeStore.insert(++row, newRecord);
	}
	BarCodeGrid.view.refresh();
}

var findBarCode = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			clear.handler();
			BarCodeGrid.load();
		}
	});

var addBarCode = new Ext.Toolbar.Button({
		text: '�½�',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			BarCodeGrid.removeAll();
			BarCodeGrid.addNewRow();
		}
	});

var ImportButton = new Ext.SplitButton({
		text: '����',
		width: 70,
		height: 30,
		iconCls: 'page_add',
		tooltip: '�������밴ť',
		menu: {
			items: [{
					text: '<b>���붩��</b>',
					handler: ImpByPoFN
				}, {
					text: '<b>������ƽ̨����</b>',
					handler: ImpBySciPoFN
				}
			]
		}
	})

function ImpByPoFN() {
	ImportByPo(getlist);
}
/*
function ImpBySciPoFN() {
	ImportBySciPo(getlist2);
}*/
//����������ѯ lihui
function ImpBySciPoFN() {
	ImportBySciPo(QueryForSciPo);
}

function getlist(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	var count = BarCodeGrid.getCount();
	Ext.each(records, function (record, index, allItems) {
		var IncId = record.get("IncId");
		var IncCode = record.get("IncCode");
		var IncDesc = record.get("IncDesc");
		var Qty = record.get("AvaBarcodeQty");
		var Spec = record.get("Spec");
		var SpecDesc = record.get("SpecDesc");
		var PoItmId = record.get("PoItmId");
		var CerNo = record.get("CerNo");
		var CerExpDate = toDate(record.get("CerExpDate"));
		var defaData = {
			IncId: IncId,
			IncCode: IncCode,
			IncDesc: IncDesc,
			Qty: Qty,
			Spec: Spec,
			PoItmId: PoItmId,
			CerNo: CerNo,
			CerExpDate: CerExpDate

		};
		var DataRecord = CreateRecordInstance(BarCodeGrid.getStore().fields, defaData);
		if (Qty > 0) {
			BarCodeGrid.getStore().add(DataRecord)
			var Rowcount = BarCodeGrid.getStore().getCount();
			var rowData = BarCodeGrid.getStore().getAt(Rowcount - 1);
			addComboData(SpecDescStore, SpecDesc, SpecDesc);
			rowData.set("SpecDesc", SpecDesc);
		}
	});
}
function getlist2(records,sxno) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	var count = BarCodeGrid.getCount();
	Ext.each(records, function (record, index, allItems) {
		var IncId = record.get("IncId");
		var IncCode = record.get("IncCode");
		var IncDesc = record.get("IncDesc");
		var Qty = record.get("AvaBarcodeQty");
		var Spec = record.get("Spec");
		var SpecDesc = record.get("SpecDesc");
		var PoItmId = record.get("PoItmId");
		var CerNo = record.get("CerNo");
		var CerExpDate = record.get("CerExpDate");
		var BarCode = record.get("BarCode");
		var BatNo = record.get("BatNo");
		var ExpDate = record.get("ExpDate");
		var ProduceDate = record.get("ProduceDate");
		var OrderDetailSubId = record.get("OrderDetailSubId");
		var defaData = {
			IncId: IncId,
			IncCode: IncCode,
			IncDesc: IncDesc,
			Qty: Qty,
			Spec: Spec,
			PoItmId: PoItmId,
			CerNo: CerNo,
			CerExpDate: CerExpDate,
			BarCode: BarCode,
			BatNo: BatNo,
			ExpDate: Date.parseDate(ExpDate, ARG_DATEFORMAT),
			ProduceDate: ProduceDate,
			OrderDetailSubId:OrderDetailSubId,
			SxNo : sxno
		};
		var DataRecord = CreateRecordInstance(BarCodeGrid.getStore().fields, defaData);
		if (Qty > 0) {
			BarCodeGrid.getStore().add(DataRecord)
			var Rowcount = BarCodeGrid.getStore().getCount();
			var rowData = BarCodeGrid.getStore().getAt(Rowcount - 1);
			addComboData(SpecDescStore, SpecDesc, SpecDesc);
			rowData.set("SpecDesc", SpecDesc);
		}
	});
}
function QueryForSciPo(DateTime,SCIPoVendorId,SCIPoVendorDesc)
{
	if (DateTime == null || DateTime =='') 
	{return;}	
	var startDate = DateTime.split("^")[0];
	var time = DateTime.split("^")[1];
	var endDate = startDate;
	addComboData(Ext.getCmp("ImpVendor").getStore(),SCIPoVendorId,SCIPoVendorDesc);
	Ext.getCmp("ImpVendor").setValue(SCIPoVendorId);
	BarCodeGrid.removeAll();
	clear.handler();
	var Param = "" + "^" + "" + "^" + "" + "^" + startDate + "^" + time
		 + "^" + endDate + "^^^^" + gHospId;
	BarCodeGrid.store.setBaseParam('Param', Param);
	BarCodeGrid.load({
		params: {
			'Param': Param
		}
	});
}
// ���水ť
var saveBarCode = new Ext.ux.Button({
		text: '����',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			var AllowAspWhileReceive=GetRecAdjspFlag();
			if(BatSpFlag != '1' && AllowAspWhileReceive == 'Y'){
				var rowCount = BarCodeGrid.getStore().getCount();
				AdjPriceShow(0, rowCount-1);
			}else{
				save();
			}
		}
	});
///���ɵ��۵�
function AdjPriceShow(ind,rowCount){
	try{
		var record = BarCodeGrid.getStore().getAt(ind);
		var IncRowid=record.get("IncId");
	}catch(e){}
	if(Ext.isEmpty(IncRowid)){
		//���������зǿ���
		save();
		return;
	}
	var AdjSpUomId=record.get("BUomId");  //����Ĭ�ϻ�����λ,��˵��۵�λĬ�ϻ�����λ
	var uomdesc=record.get("BUom");
	var ResultSp= record.get("Sp"); 
	var ResultRp=record.get("Rp");
	var incicode=record.get("IncCode");
	var incidesc=record.get("IncDesc");
	var StkGrpType = Ext.getCmp("StkGrpType").getValue();
	var strParam=gGroupId+"^"+gLocId+"^"+gUserId;
	var url=DictUrl + "ingdrecaction.csp?actiontype=GetPrice&InciId="+IncRowid+"&UomId="+AdjSpUomId+"&StrParam="+strParam;
	var pricestr=ExecuteDBSynAccess(url);
	var priceArr=pricestr.split("^");
	var PriorRp=priceArr[0];
	var PriorSp=priceArr[1];
	var data = IncRowid + "^" + AdjSpUomId + "^" + PriorSp + "^" + ResultRp + "^" + gUserId
			+ "^" +PriorRp+"^"+ResultSp+"^"+StkGrpType+"^"+gLocId+ "^" +incicode
			+ "^" +incidesc+ "^" +uomdesc;
	var adjspFlag=tkMakeServerCall("web.DHCSTM.INAdjSalePrice","CheckItmAdjSp",IncRowid,"");
	if((IncRowid!="")&&(Number(PriorSp)!=Number(ResultSp))&&(adjspFlag!=1)){
		var ret=confirm(incidesc+"�۸����仯���Ƿ����ɵ��۵�?");
		if (ret==true){
			SetAdjPrice(data,ind,rowCount,AdjPriceShow);	//ѭ������
		}else{
			if(ind >= rowCount){
				save();
			}else{
				AdjPriceShow(++ind,rowCount);}
		}
	}else{
		if(ind >= rowCount){
			save();
		}else{
			AdjPriceShow(++ind,rowCount);}
	}
}

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
		text: '���',
		tooltip: '������',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function () {
			inciDr = "";
			clearPanel(formPanel);
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp('startDate').setValue(new Date().add(Date.DAY,-30));
			Ext.getCmp('endDate').setValue(new Date());
			Ext.getCmp("LocField").setValue("");
			
			BarCodeGrid.removeAll();
			
		}
	});

// ��հ�ť����
var clear = new Ext.Toolbar.Button({
		text: '���������Ϣ',
		tooltip: '������',
		width: 70,
		height: 30,
		iconCls: 'page_delete',
		handler: function () {
			BarcodeArr = [];
		}
	});

function save() {
	var CreateUser = gUserId;
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var MainInfo = CreateUser + "^" + StkGrpId + "^" + gLocId;
	var ListDetail = BarCodeGrid.getModifiedInfo();
	if (ListDetail == "") {
		Msg.info("warning", "û����Ҫ���������!");
		return;
	}
	if (BarCodeGrid.activeEditor != null) {
		this.activeEditor.completeEdit();
	}
	var mr = BarCodeGrid.getModifiedRecords();
	for (var i = 0, mrLen = mr.length; i < mrLen; i++) {
		var record = mr[i];
		var inci = record.get('IncId');
		if ((inci == "") || (inci == null)) {
			continue;
		}
		var Code = record.get('IncCode');
		var ProduceDate = record.get('ProduceDate');
		var CerDate = record.get("CerExpDate");
		if (!Ext.isEmpty(ProduceDate) && !Ext.isEmpty(CerDate) && (CerDate <= ProduceDate)) {
			Msg.info("warning", "���ʴ���Ϊ" + Code + "�������ڳ���ע��֤Ч��!�����������±���");
			return false;
		}
		var vendorId = record.get("VendorId");
		if (gItmTrackParam[7] == "Y" && vendorId == "") {
			Msg.info("warning", "���ʴ���Ϊ" + Code + "�Ĺ�Ӧ��δ��,���ܱ���!");
			return false;
		}
		var qty = record.get("Qty");
		if (qty > 1000) {
			Msg.info("warning", "�������ܳ���1000!");
			return false;
		}
	}
	var url = DictUrl + "barcodeaction.csp?actiontype=save";
	var loadMask = ShowLoadMask(Ext.getBody(), "������...");
	Ext.Ajax.timeout=120000;
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			MainInfo: MainInfo,
			ListDetail: ListDetail
		},
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				var datetime = jsonData.info;
				var startDate = datetime.split("^")[0];
				var time = datetime.split("^")[1];
				var endDate = startDate;
				Msg.info("success", "����ɹ�!");
				clear.handler();
				var Param = "" + "^" + "" + "^" + "" + "^" + startDate + "^" + time
					 + "^" + endDate + "^^^^" + gHospId;
				BarCodeGrid.store.setBaseParam('Param', Param);
				BarCodeGrid.load({
					params: {
						'Param': Param
					}
				});
			} else {
				Msg.info("error", "����ʧ��!" + jsonData.info);
			}
			loadMask.hide();
		},
		scope: this
	});
}
// ���水ť
var copybutton = new Ext.Button({
		text: '��������Ч��',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			try {
				var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
				var batno = BarCodeGrid.getAt(row - 1).get('BatNo');
				var expdate = BarCodeGrid.getAt(row - 1).get('ExpDate');
				BarCodeGrid.getAt(row).set("BatNo", batno);
				BarCodeGrid.getAt(row).set("ExpDate", expdate);
				var col = GetColIndex(BarCodeGrid, 'BatNo');
				if (row + 1 < BarCodeGrid.getCount()) {
					BarCodeGrid.startEditing(row + 1, col);
				}
			} catch (e) {}
		}
	});

var saveImp = new Ext.ux.Button({
		id: "saveImp",
		text: '������ⵥ',
		tooltip: '�������',
		iconCls: 'page_save',
		handler: function () {
			if (CheckDataBeforeSave() == true) {
				CheckVendor();
			}
		}
	});

function CheckDataBeforeSave() {
	var nowdate = new Date();
	// �ж���ⲿ�ź͹������Ƿ�Ϊ��
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "��ѡ����ⲿ��!");
		return false;
	}
	var VenId = Ext.getCmp("ImpVendor").getValue();
	if (VenId == null || VenId.length <= 0) {
		Msg.info("warning", "��ѡ��Ӧ��!");
		return false;
	}
	var StkGrpType = Ext.getCmp("StkGrpType").getValue();
	if (Ext.isEmpty(StkGrpType)) {
		Msg.info("warning", "���鲻��Ϊ��!");
		return false;
	}
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
	if (Ext.isEmpty(SourceOfFund)) {
		//Msg.info("warning", "�ʽ���Դ����Ϊ��!");
		//return false;
	}
	var rowCount = BarCodeGrid.getStore().getCount();
	var count = 0;
	for (var i = 0; i < rowCount; i++) {
		var item = BarCodeGrid.getStore().getAt(i).get("IncId");
		if (item != "") {
			count++;
		}
	}
	if (rowCount <= 0 || count <= 0) {
		Msg.info("warning", "�����������ϸ!");
		return false;
	}
	for (var i = 0; i < rowCount; i++) {
		SetGridBgColor(BarCodeGrid, i, "white");
	}
	
	for (var i = 0; i < rowCount; i++) {
		var rowData = BarCodeGrid.getStore().getAt(i);
		
		var ExpReq = rowData.get('ExpReq');
		var item = rowData.get("IncId");
		var expDateValue = rowData.get("ExpDate");
		var ExpDate = new Date(Date.parse(expDateValue));
		if ((ExpReq == 'R') && (item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "��"+(i+1)+"����Ч�ڲ���С�ڻ���ڵ�ǰ����!");
			var col = GetColIndex(BarCodeGrid, 'ExpDate');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		
		var BatchReq = rowData.get('BatchReq');
		var BatchNo = rowData.get('BatNo');
		if ((BatchReq == 'R') && (item != "") && (BatchNo == '')) {
			Msg.info("warning", "��"+(i+1)+"�����Ų���Ϊ��!");
			var col = GetColIndex(BarCodeGrid, 'BatNo');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		
		var qty = BarCodeGrid.getStore().getAt(i).get("Qty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "��"+(i+1)+"�������������С�ڻ����0!");
			var col = GetColIndex(BarCodeGrid, 'Qty');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var realPrice = BarCodeGrid.getAt(i).get("Rp");
		if ((item != "") && (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "�����۲���С�ڻ����0!");
			var col = GetColIndex(BarCodeGrid, 'Rp');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
	}
	return true;
}

function CheckVendor() {
	var VenId = Ext.getCmp("ImpVendor").getValue();
	var rowCount = BarCodeGrid.getStore().getCount();
	var count = 0;
	for (var i = 0; i < rowCount; i++) {
		var vendor = BarCodeGrid.getStore().getAt(i).get("VendorId");
		if (vendor != "" && vendor != VenId) {
			count++;
		}
	}
	if (count > 0) {
		Ext.MessageBox.show({
			title: '��ʾ',
			msg: "���ڲ�ͬ��Ӧ��,�Ƿ��������?",
			buttons: Ext.MessageBox.YESNO,
			fn: function (btn) {
				if (btn == 'yes') {
					SaveImp();
				}
			}
		});
	} else {
		SaveImp();
	}
}

/**
 * ������ⵥ
 */
function SaveImp() {
	var Ingr = '';
	var VenId = Ext.getCmp("ImpVendor").getValue();
	var Completed = 'N';
	var LocId = Ext.getCmp("PhaLoc").getValue();
	var CreateUser = gUserId;
	var ExchangeFlag = 'N';
	var PresentFlag = 'N';
	var IngrTypeId = ""; //�������
	var PurUserId = "";
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var PoId = ""; //����id
	var SourceOfFund = Ext.getCmp('SourceOfFund').getValue();
	var ToLoc = Ext.getCmp('ToLoc').getValue();
	var Carrid=Ext.getCmp('INFOPbCarrier').getValue();
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag
		 + "^" + IngrTypeId + "^" + PurUserId + "^" + StkGrpId + "^" + PoId + '^' + ''
		 + '^' + SourceOfFund + '^' + ToLoc+"^^^^^^"+Carrid;
	var ListDetail = "";
	var rowCount = BarCodeGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = BarCodeGrid.getStore().getAt(i);
		var Ingri = rowData.get('Ingri');
		if (!Ext.isEmpty(Ingri)) {
			continue; //�Ѿ�����,����
		}
		var IncId = rowData.get("IncId");
		if (Ext.isEmpty(IncId)) {
			continue;
		}
		var BatchNo = rowData.get("BatNo");
		var ExpDate = Ext.util.Format.date(rowData.get("ExpDate"), ARG_DATEFORMAT);
		var ManfId = rowData.get("ManfId");
		var IngrUomId = rowData.get("BUomId");
		if (Ext.isEmpty(IngrUomId)) {
			Msg.info('error', 'δȡ����λ��Ϣ,���ʵ!');
			return;
		}
		var RecQty = rowData.get("Qty");
		var Rp = rowData.get("Rp");
		var Sp = rowData.get("Sp");
		var NewSp = Sp;
		var SxNo = rowData.get('SxNo');
		var InvNo = '';
		var InvDate = '';
		var PoItmId = rowData.get("PoItmId");
		var BarCode = rowData.get("BarCode");
		var dhcit = rowData.get('InctrackId');
		if (Ext.isEmpty(dhcit)) {
			Msg.info('warning', '��' + (i + 1) + '������δע��!');
			return;
		}
		var CerNo = rowData.get("CerNo");
		var CerExpDate = Ext.util.Format.date(rowData.get("CerExpDate"), ARG_DATEFORMAT);
		var SpecDesc = rowData.get('SpecDesc');
		var OrderDetailSubId=rowData.get('OrderDetailSubId');
		var str = Ingri + "^" + IncId + "^" + BatchNo + "^" + ExpDate + "^" + ManfId
			+ "^" + IngrUomId + "^" + RecQty + "^" + Rp + "^" + NewSp + "^" + SxNo
			+ "^" + InvNo + "^" + InvDate + "^"+PoItmId + "^^"
			+ "^^^" + BarCode + "^^" + CerNo
			+ "^" + CerExpDate + "^^" + SpecDesc + "^"+OrderDetailSubId+"^"
			+ "^" + Sp;
		if (ListDetail == "") {
			ListDetail = str;
		} else {
			ListDetail = ListDetail + RowDelim + str;
		}
	}
	if (ListDetail==""){
		Msg.info("warning","û����Ҫ��������!");
		return;
	}
	var url = DictUrl
		 + "ingdrecaction.csp?actiontype=Save";
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			Ingr: Ingr,
			MainInfo: MainInfo,
			ListDetail: ListDetail
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				var IngrRowid = jsonData.info;
				Msg.info("success", "����ɹ�!");
				// ��ת������Ƶ�����
				window.location.href = 'dhcstm.ingdrechv.csp?Rowid=' + IngrRowid + '&QueryFlag=1';
			} else {
				var ret = jsonData.info;
				if (ret == -99) {
					Msg.info("error", "����ʧ��,���ܱ���!");
				} else if (ret == -2) {
					Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
				} else if (ret == -3) {
					Msg.info("error", "������ⵥʧ��!");
				} else if (ret == -4) {
					Msg.info("error", "δ�ҵ�����µ���ⵥ,���ܱ���!");
				} else if (ret == -5) {
					Msg.info("error", "������ⵥ��ϸʧ��!");
				} else {
					Msg.info("error", "������ϸ���治�ɹ���" + ret);
				}
			}
		},
		scope: this
	});
}

var formPanel = new Ext.ux.FormPanel({
		title: '��ֵ��������(ע��)',
		trackResetOnLoad: true,
		tbar: [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode, '-', ImportButton,
			'-', printBarCode, '-', printBarCodeTotal, '-', printBarCode2, '-', printBarCodeTotal2, '-', copybutton,
			'-', saveImp],
		items: [{
				layout: 'column',
				items: [{
						columnWidth: .7,
						xtype: 'fieldset',
						title: '��ѯ����',
						layout: 'column',
						style: 'padding:5px 0px 0px 5px',
						defaults: {
							border: false,
							columnWidth: .33,
							xtype: 'fieldset'
						},
						items: [{
								items: [BarCodeField, startDate, endDate,LocField]
							}, {
								items: [StkGrpType, M_InciCode, M_InciDesc,RegFlag]
							}, {
								items: [Vendor, RequestPhaLoc, BatNo]
							}
						]
					}, {
						columnWidth: .3,
						xtype: 'fieldset',
						title: '���ѡ��',
						layout: 'column',
						style: 'padding:5px 0px 0px 5px;margin:0px 0px 0px 5px;',
						defaults: {
							border: false,
							xtype: 'fieldset'
						},
						items: [{
								columnWidth: .75,
								items: [PhaLoc, ImpVendor, SourceOfFund, ToLoc,INFOPbCarrier]
							}, {
								columnWidth: .25,
								items: [VirtualFlag]
							}
						]
					}
				]
			}
		]
	});

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, BarCodeGrid],
			renderTo: 'mainPanel'
		});
	RefreshGridColSet(BarCodeGrid, "DHCSTCOMMONM"); //�����Զ�������������������
});

function GetRecAdjspFlag() {
	var RecParams=tkMakeServerCall("web.DHCSTM.DHCINGdRec","GetParamProp",gGroupId,gLocId,gUserId);
	var AllowAspWhileReceive=RecParams.split("^")[17];
	return AllowAspWhileReceive;
}
