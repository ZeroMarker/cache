// ����:��Ӧ��ͨ��С�����ӡ���������մ���
// ��д�ˣ��쳬	2016-04-25��д,������js(����)
// ��д����:2013-09-17
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var DrugListFlag = 0;// ��־ �����ж��ǲ�ѯ����¼��
var inciDr = "";
var BarcodeArr = [];

/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N",
				"0", "", getDrugList, "", "",
				"", "", "", "", "",
				"", "Y");
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
	var pbrp= record.get("PbRp");
	var PFac=record.get("PFac");
	var pSp=record.get("pSp");
	var CertNo=record.get("CertNo");
	var CertExpDate=record.get("CertExpDate");

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
		rowData.set('Spec', Spec);
		rowData.set('Qty', 1);
		rowData.set('PbRp',pbrp);
		//rowData.set('Sp',pSp);
		//rowData.set('Marginnow',Marginnow);
		rowData.set('CerNo',CertNo);
		rowData.set('CerExpDate',toDate(CertExpDate));
		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;   
		//ȡ����������Ϣ
		var url = DictUrl + "ingdrecaction.csp?actiontype=GetItmInfo&IncId=" + inciDr+"&Params="+Params;
		var response=ExecuteDBSynAccess(url);
		var jsonData=Ext.util.JSON.decode(response);
		if(jsonData.success=='true'){
		var info=jsonData.info;
			if(info!=null || info!=''){
				var data=jsonData.info.split("^");
				addComboData(PhManufacturerStore, data[0], data[1]);
				rowData.set("ManfId", data[0]);
				rowData.set("PurUomId", data[2]);
				var ConFac = data[11];
				rowData.set("Rp",Number(data[23]));			//2016-01-21 ��������λ����
				rowData.set("Sp", Number(data[24]));
				rowData.set("NewSp", Number(data[24]));
//				rowData.set("Rp",Number(data[4]));
//				rowData.set("Sp", Number(data[5]));
//				rowData.set("NewSp", Number(data[5]));
				rowData.set("BatNo", data[6]);
				rowData.set("ExpDate", toDate(data[7]));
				rowData.set("BUomId", data[10]);
				var Marginnow = '';
				if(Number(data[4]) > 0){
					Marginnow = accSub(accDiv(Number(data[5]), Number(data[4])), 1);
					Marginnow=Marginnow.toFixed(3)
				}
				rowData.set('Marginnow',Marginnow);
			}
		}
		var colIndex = GetColIndex(BarCodeGrid, 'Qty');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

/**
 * ����inci_rowid��ȡ����,������ϸ��Ϣ
 * @param {} inciDr
 */
function getDrugListDetail(inciDr, rowData) {
	var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	
	rowData.set("IncId", inciDr);
	
	var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
	var info = tkMakeServerCall('web.DHCSTM.DHCINGdRec', 'GetItmInfo', inciDr, Params);
	if(Ext.isEmpty(info)){
		Msg.info('error', '������Ϣ��ȡ����!');
		return false;
	}else{
		var data=info.split("^");
		rowData.set("IncCode", data[26]);
		rowData.set("IncDesc", data[27]);
		addComboData(PhManufacturerStore, data[0], data[1]);
		rowData.set("ManfId", data[0]);
		rowData.set("PurUomId", data[2]);
		rowData.set('Qty', 1);
		rowData.set("Rp",Number(data[23]));			//2016-01-21 ��������λ����
		rowData.set("Sp", Number(data[24]));
		rowData.set("NewSp", Number(data[24]));
		rowData.set('Spec', data[17]);
//		rowData.set("BatNo", data[6]);				//2017-06-15 ͨ����������
//		if(Ext.isEmpty(rowData.get('ExpDate'))){
//			rowData.set("ExpDate", toDate(data[7]));
//		}
		rowData.set("BUomId", data[10]);
		var Marginnow = '';
		if(Number(data[4]) > 0){
			Marginnow = accDiv(Number(data[5]), Number(data[4]));
		}
		rowData.set('Marginnow',Marginnow);
		rowData.set('CerNo', data[28]);
		rowData.set('CerExpDate',toDate(data[29]));
		var colIndex = GetColIndex(BarCodeGrid, 'Rp');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

//������
var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			anchor : '90%',
			emptyText : '����...',
			groupId:session['LOGON.GROUPID']
		});

var VirtualFlag = new Ext.form.Checkbox({
		hideLabel:true,
		boxLabel : G_VIRTUAL_STORE,
		id : 'VirtualFlag',
		anchor : '90%',
		checked : false,
		listeners:{
			check:function(chk,bool){
				if(bool){
					var phaloc=Ext.getCmp("PhaLoc").getValue();
					var info = tkMakeServerCall('web.DHCSTM.Common.UtilCommon','GetMainLoc',phaloc);
					var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
					var infoArr=info.split("^");
					var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
					addComboData(Ext.getCmp("PhaLoc").getStore(),vituralLoc,vituralLocDesc);
					Ext.getCmp("PhaLoc").setValue(vituralLoc);
				}else{
					SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
				}
			}
		}
	});
VirtualFlag.setValue(true);

//��⹩Ӧ��
var ImpVendor = new Ext.ux.VendorComboBox({
			fieldLabel : '��⹩Ӧ��',
			id : 'ImpVendor',
			anchor : '90%'
		});

var SourceOfFund = new Ext.ux.ComboBox({
	fieldLabel : '�ʽ���Դ',
	id : 'SourceOfFund',
	anchor : '90%',
	store : SourceOfFundStore
});

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
			fieldLabel : '<font color=red>*����</font>',
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
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()	
					}
				}
			}			
		});
var BatNo = new Ext.form.TextField({
			id : 'BatNo',
			fieldLabel : '����',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()	
					}
				}
			}		
		});
// ���ʱ���
var M_InciCode = new Ext.form.TextField({
			fieldLabel : '���ʱ���',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '95%',
			width : 150,
			disabled : true,
			valueNotFoundText : ''
		});

// ��������
var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '95%',
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
//var Vendor=new Ext.ux.VendorComboBox({
//		id : 'Vendor',
//		name : 'Vendor',
//		anchor:'95%'
//	});
var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '������',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'95%',
					emptyText : '������...',
					defaultLoc:{}
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
		'beforequery':function(){
				var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
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

var Manf = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Manf',
	store : PhManufacturerStore,
	emptyText : ' ����...',
	filterName : 'PHMNFName',
	params : {ScgId : 'StkGrpType'}
});

var BarCodeGridCm = [{
			header : "dhcit",
			dataIndex : 'InctrackId',
			saveColIndex : 0,
			hidden : true,
			hideable : false
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
			renderer : Ext.util.Format.InciPicRenderer('IncId'),
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
									var group = Ext.getCmp("StkGrpType").getValue();
									GetPhaOrderInfo(field.getValue(), group);
								}
							}
						}
					}))
		}, {
			header : "���",
			dataIndex : 'Spec'
		}, {
			header : "����",
			dataIndex : 'Qty',
			width : 40,
			align : 'right',
			saveColIndex : 3
		}, {
			header : "��ֵ����",
			dataIndex : 'BarCode',
			width : 220,
			align : 'left',
			sortable : false,
			saveColIndex : 2,
//			editable : false,		//2015-12-28 ���ɱ༭
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var BarCode = this.getValue();
							if(Ext.isEmpty(BarCode)){
								return false;
							}
							var BarCodeArr = BarCode.split('-');
							var SerialNo = BarCodeArr[BarCodeArr.length - 1];
							if(SerialNo.length < 10){
								//��ˮ��Ϊyymmdd0001(������+4λ), ����Ϊ10
								Msg.info('warning', '��ˮ�ų��Ȳ���, ���ʵ¼���Ƿ���ȷ!');
								return false;
							}
							BarCode = ToDBC(BarCode);
							field.setValue(BarCode);
							
							var ItmInfo = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'GetItmInfoByBarcode', BarCode);
							var InfoArr = ItmInfo.split('^');
							var Inci = InfoArr[0], VendorId = InfoArr[3], VendorDesc = InfoArr[4];
							if(Number(Inci) <= 0){
								Msg.info('error', '�����ȡ����:' + ItmInfo);
								return;
							}
							var ExpDate = InfoArr[5], Scg = InfoArr[6], ScgDesc = InfoArr[7], BatchNo = InfoArr[8], SpecDesc = InfoArr[9];
							var ExpDate = Date.parseDate(ExpDate, 'ymd');
							var row = BarCodeGrid.getSelectedCell()[0];
							var rowData = BarCodeGrid.getAt(row);
							var ImpVendor = Ext.getCmp('ImpVendor').getValue();
							if(!Ext.isEmpty(ImpVendor) && (VendorId != ImpVendor)){
								Msg.info('warning', '�����빩Ӧ�̺���⹩Ӧ�̲�һ��!');
								//�����Ƿ����ϸ����,�ٿ���
								//return false;
							}
							var StkGrpType = Ext.getCmp('StkGrpType').getValue();
							if(!Ext.isEmpty(StkGrpType) && (Scg != StkGrpType)){
								var count = BarCodeGrid.getStore().getCount();
								if(count == 1){
									addComboData('', Scg, ScgDesc, Ext.getCmp('StkGrpType'));
									Ext.getCmp('StkGrpType').setValue(Scg);
								}else{
									Msg.info('warning', '�����������������鲻��!');
									return false;
								}
							}
							rowData.set('VendorId', VendorId);
							rowData.set('VendorDesc', VendorDesc);
							if(ExpDate){
								rowData.set('ExpDate', ExpDate);
							}
							rowData.set('BatNo', BatchNo);
							addComboData(SpecDescStore, SpecDesc, SpecDesc);
							rowData.set('SpecDesc', SpecDesc);
							//Ϊrecord set�����ֶ���Ϣ
							getDrugListDetail(Inci, rowData);
							addComboData(Ext.getCmp('ImpVendor').getStore(), VendorId, VendorDesc);
							Ext.getCmp('ImpVendor').setValue(VendorId);
						}
					}
				}
			}))
		}, {
			header : "��Ӧ��id",
			dataIndex : 'VendorId',
			hidden : true,
			saveColIndex : 14
		}, {
			header : "��Ӧ��",
			dataIndex : 'VendorDesc',
			width: 150
		}, {
			header : "��ӡ",
			xtype:'checkcolumn',
			dataIndex : 'print',
			width : 40
		}, {
			header : "�Դ�����",
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : false,
			saveColIndex : 4,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							//�Դ����뾭���ֶ�,���ﲻ��ת��
							return false;
//							var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
//							var col = GetColIndex(BarCodeGrid, 'Rp')
//							BarCodeGrid.startEditing(row, col);
						}
					}
				}
			}))
		},{
			header : "PoItmId",
			dataIndex : 'PoItmId',
			saveColIndex : 5,
			hidden : true
		},{
			header : "���󵥺�",
			dataIndex : 'ReqNo',
			hidden : true
		},{
			header : "Ʒ��",
			dataIndex : 'Brand',
			hidden : true
		},{
			header : "����",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true,
			saveColIndex : 12,
			editor : new Ext.ux.NumberField({
						formatType : 'FmtRP',
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cost = field.getValue();
									if (cost == null
											|| cost.length <= 0) {
										Msg.info("warning", "���۲���Ϊ��!");
										return;
									}
									if (cost <= 0) {
										Msg.info("warning",
												"���۲���С�ڻ����0!");
										return;
									}
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'BatNo');
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
			})
		},{
			header : "����",
			dataIndex : 'BatNo',
			width : 90,
			align : 'center',
			sortable : true,
			saveColIndex : 6,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
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
								if (expDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT)) {
									Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
									return;
								}
								BarCodeGrid.addNewRow();
//								var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
//								var col = GetColIndex(BarCodeGrid, 'BatNo')
//								if(row+1<BarCodeGrid.getCount()){
//									BarCodeGrid.startEditing(row+1, col);
//								}
							}
						}
					}
				})
		},{
			header : "��ǰ�ۼ�",
			dataIndex : 'Sp',
			align : 'right'
		},{
			header : "�������",
			dataIndex : 'ReqLocDesc'
		},{
			header : "�б����",
			dataIndex : 'PbRp'
		},{
			header : "�ӳ���",
			dataIndex : 'Marginnow',
			align : 'right'
		},{
			header:"������",
			dataIndex:'SpecDesc',
			saveColIndex:8,
			width:100,
			align:'left',
			sortable:true,
			editor : new Ext.grid.GridEditor(Specom),
			renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
		},{
			header : "ע��֤��",
			dataIndex : 'CerNo',
			saveColIndex:10,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : true
			})
		},{
			header : "ע��֤Ч��",
			xtype:'datecolumn',
			dataIndex : 'CerExpDate',
			saveColIndex:11,
			sortable : true,
			editor : new Ext.ux.DateField({
				selectOnFocus : true,
				allowBlank : true	
			})
		}, {
			header : "��������",
			xtype:'datecolumn',
			dataIndex : 'ProduceDate',
			width : 100,
			align : 'center',
			sortable : true,	
			saveColIndex : 9,
			editor : new Ext.ux.DateField({
					selectOnFocus : true,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
//								var ProduceDate = field.getValue();
//								if (ProduceDate == null || ProduceDate.length <= 0) {
//									Msg.info("warning", "�������ڲ���Ϊ��!");
//									return;
//								}
								var col = GetColIndex(BarCodeGrid, 'BatNo')
								var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
								if(row+1<BarCodeGrid.getCount()){
									BarCodeGrid.startEditing(row+1, col);
								}
							}
						}
					}
				})
		}, {
			header : "��ⵥλ",
			dataIndex : 'PurUomId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden:true
		}, {
			header : "������λ",
			dataIndex : 'BUomId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden:true
		}, {
			header : "����ӱ�id",
			dataIndex : 'Ingri',
			width : 80,
			align : 'left',
			sortable : true,
			hidden:true
		}, {
			header : '����',
			dataIndex : 'ManfId',
			saveColIndex : 13,
			xtype : 'combocolumn',
			valueField : 'ManfId',
			displayField : 'ManfDesc',
			editor : Manf
		}, {
			header : "ע����Ա",
			dataIndex : 'User'
		}, {
			header : "ע������",
			dataIndex : 'Date'
		}];

function paramsFn(){
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var startDate = Ext.getCmp("startDate").getValue();
	if(Ext.isEmpty(startDate)){
		Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = Ext.getCmp("endDate").getValue();
	if(Ext.isEmpty(endDate)){
		Msg.info('warning', '��ֹ���ڲ���Ϊ��!');
		return false;
	}
	endDate = endDate.format(ARG_DATEFORMAT);
	var vendor = Ext.getCmp("ImpVendor").getValue();
	if(Ext.isEmpty(vendor)){
		Msg.info('warning', '��ѡ����⹩Ӧ��!');
		return false;
	}
	var reqloc = Ext.getCmp("RequestPhaLoc").getValue();
	var batno= Ext.getCmp("BatNo").getValue();
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate+"^"+vendor+"^"+reqloc+"^"+batno+"^"+gHospId;
	return {'Param' : Param};
}

function cellSelectFn(sm,rowIndex,colIndex){
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

function beforeAddFn(){
	var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
	if (StkGrpType == null || StkGrpType.length <= 0) {
		Msg.info("warning", "��ѡ������!");
		return false;
	}
}

var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// ���
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'BarCodeGrid',
	contentColumns : BarCodeGridCm,
	smRowSelFn : cellSelectFn,
	firstFocusCell : 'BarCode',
	singleSelect:false,
	selectFirst : false,
	actionUrl : BarCodeGridUrl,
	queryAction : "query",
	idProperty : "InctrackId",
	checkProperty : "IncId",
	paramsFn : paramsFn,
	beforeAddFn : beforeAddFn,
	delRowAction : "Delete",
	delRowParam : "RowId",
	paging : false,		//2015-12-23 ���ֱ����⹦�ܺ�,�ݲ�ʹ�÷�ҳ������
	listeners : {
		'beforeedit' : function(e) {
			var InctrackId = BarCodeGrid.getCell(e.row,"InctrackId");
			if (!Ext.isEmpty(InctrackId) && e.field!='OriginalCode'&& e.field!='BatNo'&& e.field!='ExpDate'&& e.field!='SpecDesc'&& e.field!='ProduceDate' && e.field!='Rp' && e.field!='ManfId' && e.field!='CerNo' && e.field!='CerExpDate') {
				return false;	// �����޸� ��������Ĳ������޸�
			}
			if(e.field == 'BarCode'){
				if(e.record.get('IncId') != ''){
					e.cancel = true;
				}
			}
		},
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().select(rowindex,1);
			//����δ�����������ϸ�����Ҽ��˵�
			if(grid.getStore().getAt(rowindex).get('InctrackId')==''){
				rightClick.showAt(e.getXY());
			}
		}
	}
});

var rightClick = new Ext.menu.Menu({
	id : 'rightClickCont',
	items: [
		{
			id : 'mnuDelete',
			handler : function(item,e){
				BarCodeGrid.deleteRow();
			},
			text : 'ɾ��'
		},{
			id : 'mnuSplit',
			handler : SplitDetail,
			text : '�����ϸ'
		}
	] 
});

var rowsAdd = 1000;
function SplitDetail(item,e){
	var cell = BarCodeGrid.getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "û��ѡ����!");
		return;
	}
	var row = cell[0];
	var record = BarCodeGrid.getStore().getAt(row);
	if(record.get('InctrackId')!=""){
		Msg.info('error','�ѱ������벻�ɲ��!');
		return;
	}
	var qty = record.get('Qty');
	var qty = (Ext.isEmpty(qty)||qty<=1)?2:record.get('Qty');
	record.set('Qty',1);
	var BarCodeStore = BarCodeGrid.getStore();
	for(var i=1;i<qty;i++){
		var newRecord = new BarCodeStore.recordType(record.copy().data, ++rowsAdd);
		BarCodeStore.insert(++row, newRecord);
	}
	BarCodeGrid.view.refresh();
}

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
				BarCodeGrid.addNewRow();
			}
		});
var impByPo= new Ext.Toolbar.Button({
			text : '���붩��',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				
				ImportByPo(getlist);
			}
		});
function getlist(records)
		{
		records = [].concat(records);
		
		if (records == null || records == "") {
				return;
		}
		
		var count=BarCodeGrid.getCount();
		Ext.each(records,function(record,index,allItems){
			var IncId=record.get("IncId");
			var IncCode=record.get("IncCode");
			var IncDesc=record.get("IncDesc");
			var Qty=record.get("AvaBarcodeQty");
			var Spec=record.get("Spec");
			var SpecDesc=record.get("SpecDesc");
			var PoItmId=record.get("PoItmId");
			var CerNo=record.get("CerNo");
			var CerExpDate=record.get("CerExpDate");
		var defaData = {
						IncId : IncId,
						IncCode :IncCode ,
						IncDesc : IncDesc,
						Qty : Qty,
						Spec:Spec,
						SpecDesc:SpecDesc,
						PoItmId:PoItmId,
						CerNo:CerNo,
						CerExpDate:CerExpDate
					};
		var DataRecord = CreateRecordInstance(BarCodeGrid.getStore().fields,defaData);
	    if(Qty>0){BarCodeGrid.getStore().add(DataRecord);}
	});
	
		}
// ���水ť
var saveBarCode = new Ext.ux.Button({
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
					if(print!="Y"){continue}
					//var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
					var barcode=BarCodeGrid.getAt(rowIndex).get('BarCode');
					var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
					var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
					var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
					var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
					var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
					var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
					var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
					var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate')
					if(Ext.isEmpty(ExpDate)){ExpDate="";}
					else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
					
					var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
							+'^IncDesc'+String.fromCharCode(2)+IncDesc
							+'^ReqNo'+String.fromCharCode(2)+ReqNo
							+'^Brand'+String.fromCharCode(2)+Brand
							+'^Spec'+String.fromCharCode(2)+Spec
							+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
							+'^Sp'+String.fromCharCode(2)+Sp
							+'^BatNo'+String.fromCharCode(2)+BatNo
							+'^ExpDate'+String.fromCharCode(2)+ExpDate;
					DHCP_PrintFun(MyPara,"");
				}
				/*
				var rowCount = BarCodeGrid.getCount();
				for (var i = 0; i < rowCount; i++) {
					var rowData = BarCodeGrid.getAt(i);
					// ���������ݷ����仯ʱִ����������
					var BarCode = rowData.get("BarCode");
					var IncDesc = rowData.get("IncDesc");
					
					fileName = "{DHCSTM_BarCodePrint.raq(BarCode=" + BarCode
							+ ";IncDesc=" + IncDesc + ";HospDesc=" + App_LogonHospDesc + ")}";
					DHCCPM_RQDirectPrint(fileName);
					
				}
				*/
			}
		});
var printBarCode2 = new Ext.Toolbar.Button({
			text : '��ӡ����2��',
			iconCls : 'page_print',
			width : 70,
			height : 30,
			handler : function(button, e) {
				DHCP_GetXMLConfig("DHCSTM_Barcode");
				var count=BarCodeGrid.getCount();
				
				for(var rowIndex=0;rowIndex<count;rowIndex++){
					
					var print=BarCodeGrid.getAt(rowIndex).get('print');
					if(print!="Y"){continue}
					//var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
					var barcode=BarCodeGrid.getAt(rowIndex).get('BarCode');
					var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
					var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
					var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
					var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
					var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
					var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
					var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
					var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate')
					if(Ext.isEmpty(ExpDate)){ExpDate="";}
					else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
					
					var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
							+'^IncDesc'+String.fromCharCode(2)+IncDesc
							+'^ReqNo'+String.fromCharCode(2)+ReqNo
							+'^Brand'+String.fromCharCode(2)+Brand
							+'^Spec'+String.fromCharCode(2)+Spec
							+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
							+'^Sp'+String.fromCharCode(2)+Sp
							+'^BatNo'+String.fromCharCode(2)+BatNo
							+'^ExpDate'+String.fromCharCode(2)+ExpDate;
					DHCP_PrintFun(MyPara,"");
					DHCP_PrintFun(MyPara,"");
				}
			
				/*
				var rowCount = BarCodeGrid.getCount();
				for (var i = 0; i < rowCount; i++) {
					var rowData = BarCodeGrid.getAt(i);
					// ���������ݷ����仯ʱִ����������
					var BarCode = rowData.get("BarCode");
					var IncDesc = rowData.get("IncDesc");
					
					fileName = "{DHCSTM_BarCodePrint.raq(BarCode=" + BarCode
							+ ";IncDesc=" + IncDesc + ";HospDesc=" + App_LogonHospDesc + ")}";
					DHCCPM_RQDirectPrint(fileName);
					
				}
				*/
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
		var BarcodeTotalArr=[];
		for(var n=0;n<rowsCount;n++){
			var rowBarcode=BarCodeGrid.getAt(n).get('BarCode');
			BarcodeTotalArr[n]=rowBarcode;
		}
		
		for(var i=0;i<BarcodeTotalArr.length;i++){
			if(!(i in BarcodeTotalArr)){continue;}
			var barcode=BarcodeTotalArr[i];
			
			var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
			var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
			var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
			var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
			var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
			var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
			var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
			var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
			var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate');
			if(Ext.isEmpty(ExpDate)){ExpDate="";}
			else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
			var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
					+'^IncDesc'+String.fromCharCode(2)+IncDesc
					+'^ReqNo'+String.fromCharCode(2)+ReqNo
					+'^Brand'+String.fromCharCode(2)+Brand
					+'^Spec'+String.fromCharCode(2)+Spec
					+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
					+'^Sp'+String.fromCharCode(2)+Sp
					+'^BatNo'+String.fromCharCode(2)+BatNo
					+'^ExpDate'+String.fromCharCode(2)+ExpDate;
			DHCP_PrintFun(MyPara,"");
		}
	}
});
var printBarCodeTotal2 = new Ext.Toolbar.Button({
	text:'��ӡ��ҳ����2��',
    iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(button,e){
		DHCP_GetXMLConfig("DHCSTM_Barcode");
		var rowsCount=BarCodeGrid.getCount();
		var BarcodeTotalArr=[];
		for(var n=0;n<rowsCount;n++){
			var rowBarcode=BarCodeGrid.getAt(n).get('BarCode');
			BarcodeTotalArr[n]=rowBarcode;
		}
		
		for(var i=0;i<BarcodeTotalArr.length;i++){
			if(!(i in BarcodeTotalArr)){continue;}
			var barcode=BarcodeTotalArr[i];
			
			var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
			var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
			var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
			var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
			var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
			var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
			var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
			var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
			var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate');
			if(Ext.isEmpty(ExpDate)){ExpDate="";}
			else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
			var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
					+'^IncDesc'+String.fromCharCode(2)+IncDesc
					+'^ReqNo'+String.fromCharCode(2)+ReqNo
					+'^Brand'+String.fromCharCode(2)+Brand
					+'^Spec'+String.fromCharCode(2)+Spec
					+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
					+'^Sp'+String.fromCharCode(2)+Sp
					+'^BatNo'+String.fromCharCode(2)+BatNo
					+'^ExpDate'+String.fromCharCode(2)+ExpDate;
			DHCP_PrintFun(MyPara,"");
			DHCP_PrintFun(MyPara,"");
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
				formPanel.getForm().setValues({"startDate":new Date(),"endDate":new Date()});
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
		
function save() {
	var CreateUser = gUserId;
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var MainInfo = CreateUser + "^" + StkGrpId;
	var ListDetail = BarCodeGrid.getModifiedInfo();
	if (ListDetail == "") {
		Msg.info("warning", "û����Ҫ���������!");
		return;
	}
	
	if(BarCodeGrid.activeEditor!=null){this.activeEditor.completeEdit();}
	var mr = BarCodeGrid.getModifiedRecords();
	for(var i=0,mrLen=mr.length; i<mrLen; i++){
		var record = mr[i]
		var Code=record.get('IncCode')
		var ProduceDate = record.get('ProduceDate')
		var CerDate=record.get("CerExpDate");
		if (!Ext.isEmpty(ProduceDate)&&(CerDate<= ProduceDate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "���ʴ���Ϊ"+Code+"�������ڳ���ע��֤Ч��!�����������±���");
			return false;
		}
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
						clear.handler();
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
// ���水ť
var copybutton = new Ext.Button({
			text : '��������Ч��',
			width : 70,
			height : 30,
			iconCls : 'page_save',
			handler : function() {
				try{
					var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
					var batno=BarCodeGrid.getAt(row-1).get('BatNo');
					var expdate=BarCodeGrid.getAt(row-1).get('ExpDate');
					BarCodeGrid.getAt(row).set("BatNo",batno);
					BarCodeGrid.getAt(row).set("ExpDate",expdate);
					var col = GetColIndex(BarCodeGrid, 'BatNo');
					if(row+1<BarCodeGrid.getCount()){
						BarCodeGrid.startEditing(row+1, col);
					}
				}catch(e){}
			}
		});

var saveImp = new Ext.ux.Button({
			id : "saveImp",
			text : '������ⵥ',
			tooltip : '�������',
			iconCls : 'page_save',
			handler : function() {
				if(CheckDataBeforeSave() == true){
					SaveImp();
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
	if(Ext.isEmpty(StkGrpType)){
		Msg.info("warning", "���鲻��Ϊ��!");
		return false;
	}
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
	if(Ext.isEmpty(SourceOfFund)){
		//Msg.info("warning", "�ʽ���Դ����Ϊ��!");
		//return false;
	}
	// 1.�ж���������Ƿ�Ϊ��
	var rowCount = BarCodeGrid.getStore().getCount();
	// ��Ч����
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
	// 2.������䱳��
	for (var i = 0; i < rowCount; i++) {
		SetGridBgColor(BarCodeGrid, i, "white");
	}
	// 4.������Ϣ�������
	for (var i = 0; i < rowCount; i++) {
		var RowData = BarCodeGrid.getAt(i);
		var BarCode = RowData.get('BarCode');
		var expDateValue = RowData.get("ExpDate");
		var item = RowData.get("IncId");
		var ExpDate = new Date(Date.parse(expDateValue));
		if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			 
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var qty = RowData.get("Qty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "�����������С�ڻ����0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var realPrice = RowData.get("Rp");
		if ((item != "")&& (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "�����۲���С�ڻ����0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var VendorId = RowData.get('VendorId');
		if(VendorId != VenId){
			Msg.info('error', '���� ' + BarCode + ' ��Ӧ�̲���!');
			return false;
		}
	}
	
	return true;
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
	var ExchangeFlag ='N';
	var PresentFlag = 'N';
	var IngrTypeId = "";    //�������		
	var PurUserId =""
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var PoId="";  //����id
	var SourceOfFund = Ext.getCmp('SourceOfFund').getValue();
	
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag 
			+ "^" + IngrTypeId + "^" + PurUserId + "^"+ StkGrpId +"^"+ PoId + '^' + ''
			+ '^' + SourceOfFund;
	var ListDetail="";
	var rowCount = BarCodeGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = BarCodeGrid.getStore().getAt(i);
		var Ingri = rowData.get('Ingri');
		if(!Ext.isEmpty(Ingri)){
			continue;	//�Ѿ�����,����
		}
		var IncId = rowData.get("IncId");
		if(Ext.isEmpty(IncId)){
			continue;
		}
		var BatchNo = rowData.get("BatNo");
		var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
		var ManfId = rowData.get("ManfId");
		var IngrUomId = rowData.get("BUomId");
		if(Ext.isEmpty(IngrUomId)){
			Msg.info('error', 'δȡ����λ��Ϣ,���ʵ!');
			return;
		}
		var RecQty = rowData.get("Qty");
		var Rp = rowData.get("Rp");
		var Sp = rowData.get("Sp");
		var NewSp = Sp;
		var SxNo ='';
		var InvNo ='';
		var InvDate ='';
		var PoItmId="";
		var BarCode=rowData.get("BarCode");
		var dhcit = rowData.get('InctrackId');
		if(Ext.isEmpty(dhcit)){
			Msg.info('warning', '��' + (i+1) + '������δע��!');
			return;
		}
		var CerNo = rowData.get("CerNo");
		var CerExpDate = Ext.util.Format.date(rowData.get("CerExpDate"),ARG_DATEFORMAT);
		var SpecDesc = rowData.get("SpecDesc");
		var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
				+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo 
				+ "^" + InvNo + "^" + InvDate + "^^^"
				+ "^^^" + BarCode + "^^" + CerNo
				+ "^" + CerExpDate + "^^" + SpecDesc + "^^"
				+ "^" + Sp;
		if(ListDetail == ""){
			ListDetail = str;
		}else{
			ListDetail = ListDetail + RowDelim + str;
		}
	}
	var url = DictUrl
			+ "ingdrecaction.csp?actiontype=Save";
	Ext.Ajax.request({
				url : url,
				method : 'POST',
				params : {Ingr:Ingr, MainInfo:MainInfo, ListDetail:ListDetail},
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						// ˢ�½���
						var IngrRowid = jsonData.info;
						Msg.info("success", "����ɹ�!");
						// 7.��ʾ��ⵥ����
						// ��ת������Ƶ�����
						window.location.href='dhcstm.ingdrechv.csp?Rowid='+IngrRowid+'&QueryFlag=1';

					} else {
						var ret=jsonData.info;
						if(ret==-99){
							Msg.info("error", "����ʧ��,���ܱ���!");
						}else if(ret==-2){
							Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
						}else if(ret==-3){
							Msg.info("error", "������ⵥʧ��!");
						}else if(ret==-4){
							Msg.info("error", "δ�ҵ�����µ���ⵥ,���ܱ���!");
						}else if(ret==-5){
							Msg.info("error", "������ⵥ��ϸʧ��!");
						}else {
							Msg.info("error", "������ϸ���治�ɹ���"+ret);
						}
						
					}
				},
				scope : this
			});
}
	
var formPanel = new Ext.ux.FormPanel({
			title : '��Ӧ�̸�ֵ��������',
			labelWidth : 60,
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode,		//'-',impByPo,
				'-', printBarCode, '-', printBarCodeTotal,'-',printBarCode2,'-',printBarCodeTotal2,'-',copybutton,
				'-', saveImp],
			layout : 'column',
			items : [{
					columnWidth : .7,
					xtype : 'fieldset',
					title : '��ѯ����',
					layout : 'column',
					items : [{
								columnWidth : .33,
								layout : 'form',
								items : [BarCodeField, startDate, endDate]
							}, {
								columnWidth : .33,
								layout : 'form',
								items : [StkGrpType, M_InciCode, M_InciDesc]
							}, {
								columnWidth : .33,
								layout : 'form',
								items : [RequestPhaLoc, BatNo]
							}]
				}, {
					columnWidth : .3,
					xtype : 'fieldset',
					title : '���ѡ��',
					layout : 'column',
					labelWidth : 100,
					items : [{
								columnWidth : .75,
								layout : 'form',
								items : [PhaLoc, ImpVendor, SourceOfFund]
							}, {
								columnWidth : .25,
								layout : 'form',
								items : [VirtualFlag]
							}]
				}]
		});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [formPanel, BarCodeGrid],		//reportPanel
				renderTo : 'mainPanel'
			});
});