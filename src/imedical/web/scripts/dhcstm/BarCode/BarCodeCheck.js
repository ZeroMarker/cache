// ����:��Ӧ��excel׼��������Ϣ,ҽԺ���մ���(��̨��ֵ-��ҽ��ģʽ)

var impWindow = null;
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
					Marginnow = accDiv(Number(data[5]), Number(data[4]));
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

//��⹩Ӧ��
var ImpVendor = new Ext.ux.VendorComboBox({
			fieldLabel : '<font color=red>*��Ӧ��</font>',
			id : 'ImpVendor',
			anchor : '90%'
		});

var startDate = new Ext.ux.DateField({
			id : 'startDate',
			allowBlank : true,
			fieldLabel : '��ʼ����',
			anchor : '90%',
			value : new Date()
		});
// ��ֹ����
var endDate = new Ext.ux.DateField({
			id : 'endDate',
			allowBlank : true,
			fieldLabel : '��ֹ����',
			anchor : '90%',
			value : new Date()
		});
// ����
var StkGrpType = new Ext.ux.StkGrpComboBox({
			id : 'StkGrpType',
			fieldLabel : '����',
			StkType : App_StkTypeCode, // ��ʶ��������
			UserId : gUserId,
			LocId : gLocId,
			anchor : '90%'
		});

var BarCodeField = new Ext.form.TextField({
			id : 'BarCodeField',
			fieldLabel : '������',
			allowBlank : true,
			anchor : '90%',
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
			anchor : '90%',
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

var OriginalCode = new Ext.form.TextField({
	id : 'OriginalCode',
	fieldLabel : '�Դ�����',
	allowBlank : true,
	anchor : '90%',
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				findBarCode.handler();
			}
		}
	}
});

var BatchCode = new Ext.form.TextField({
	id : 'BatchCode',
	fieldLabel : '������',
	allowBlank : true,
	anchor : '90%',
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				findBarCode.handler();
			}
		}
	}
});

var RequestPhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '������',
	id : 'RequestPhaLoc',
	name : 'RequestPhaLoc',
	anchor:'90%',
	emptyText : '������...',
	defaultLoc:{},
	hidden : true
});

var StatusFlag = new Ext.form.RadioGroup({
	id : 'StatusFlag',
	hideLabel : true,
	items : [
		{boxLabel:'δʹ��',name:'StatusFlag',id:'StatusFlag_Temp',inputValue:'Temp',checked:true},
		{boxLabel:'��ʹ��',name:'StatusFlag',id:'StatusFlag_Used',inputValue:'Used'}
	]
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
			editable : false,
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
			saveColIndex : 2
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
			hidden : true,
			width : 40
		}, {
			header : "ɾ��",
			xtype:'checkcolumn',
			dataIndex : 'DeleteCheck',
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
			header : "������",
			dataIndex : 'BatchCode',
			saveColIndex : 17,
			allowBlank : false,
//			editable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
//						if (e.getKey() == Ext.EventObject.ENTER) {
//							var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
//							var col = GetColIndex(BarCodeGrid, 'Rp');
//							BarCodeGrid.startEditing(row, col);
//						}
					}
				}
			}))
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
		}, {
			header : "��������",
			dataIndex : 'Stauts',
			saveColIndex : 18,
			defaultValue : 'Temp',
			hidden : true
		}
	];

function paramsFn(time){
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
	
	var reqloc = Ext.getCmp("RequestPhaLoc").getValue();
	var batno= Ext.getCmp("BatNo").getValue();
	var time = Ext.isEmpty(time)? '' : time;
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var CreatLoc = '';
	var Status = Ext.getCmp('StatusFlag').getValue().getGroupValue();
	var OriginalCode = Ext.getCmp('OriginalCode').getValue();
	var OriginalStatus = 'Temp';
	var BatchCode = Ext.getCmp('BatchCode').getValue();
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			+ "^" + endDate+"^"+vendor+"^"+reqloc+"^"+batno+"^"+gHospId
			+ "^" + "" + "^" + gLocId + "^" + CreatLoc + "^" + Status + '^' + OriginalCode
			+ '^' + BatchCode + '^' + OriginalStatus;
	return {'Param' : Param};
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
	//smRowSelFn : cellSelectFn,
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
	paging : false,
	listeners : {
		'beforeedit' : function(e) {
			if(e.field == 'BarCode'){
				if(e.record.get('IncId') != ''){
					e.cancel = true;
				}
			}
		}
	}
});
BarCodeGrid.AddNewRowButton.disable();


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
			text : '����Excel',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				ImportExcelFN();
			}
		});
function ImportExcelFN(){
	if (Ext.getCmp('ImpVendor').getValue()==''){
		Msg.info('error','��ѡ��Ӧ��!');
		Ext.getCmp('ImpVendor').focus();
		return;
	}
	
	impWindow = new ActiveXObject("MSComDlg.CommonDialog");
	impWindow.Filter = "Excel(*.xls;*xlsx)|*.xls;*.xlsx";
	impWindow.FilterIndex = 1;
	impWindow.MaxFileSize = 32767;
	impWindow.FileName = '';
	impWindow.ShowOpen();
	
	if (impWindow.Flags == 0){
		return;
	}
	var fileName = impWindow.FileName;
	if (fileName==''){
		Msg.info('error','��ѡ��Excel�ļ�!');
		return;
	}
	ReadFromExcel(fileName, impLine);
}

function ReadFromExcel(fileName, Fn){
	try{
		var xlsApp = new ActiveXObject("Excel.Application");
	}catch(e){
		Msg.info("warning","���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�");
		return false;
	}

	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: ʹ�õ�һ��sheet
		ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn);
	}catch(e){
		Msg.info('error', '��ȡExcelʧ��:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return;
}

function ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	
	var StartRow = 1;		//��2�п�ʼ
	for(var i = StartRow; i < rowsLen; i++){
		var rowData = '';
		for(var j = 0; j < colsLen; j++){
			var CellContent = xlsSheet.Cells((i + 1), (j + 1)).value;
			CellContent = typeof(CellContent)=='undefined'? '' : CellContent;
			if(!Ext.isEmpty(CellContent) && typeof(CellContent) == 'date'){
				CellContent = new Date(CellContent).format(ARG_DATEFORMAT);
			}
			if(j == 0){
				rowData = CellContent;
			}else{
				rowData = rowData + '\t' + CellContent;
			}
		}
		Fn(rowData, i+1);
	}
}
///���������ݵ���һ����¼
function impLine(Str, rowNumber){
	var RowData = Str.split('\t');
	try {
		//���ʴ���,��������,���,�Դ�����,������,����,Ч��
		var InciCode = RowData[0];
		var InciDesc = RowData[1];
		var Spec = RowData[2];
		var OriginalCode = RowData[3];
		var BatchCode = RowData[4];
		var BatchNo = RowData[5];
		var ExpDate = RowData[6];
		if(ExpDate != ''){
			ExpDate = Date.parseDate(ExpDate, "Y-n-j");
		}
		var HospId = session["LOGON.HOSPID"];
		if(Ext.isEmpty(InciCode)){
			return false;
		}
		var url="dhcstm.drugutil.csp?actiontype=GetItmInfoByCode&ItmCode="+InciCode+"&HospId="+HospId ;	
		var responseText = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responseText);
		if (jsonData.success == 'true') {
			var list = jsonData.info.split("^");
			if(list.length < 16 || Ext.isEmpty(list[15])){
				Msg.info('error', '��'+rowNumber+'����Ϣ����!');
				return;
			}
			var InciId = list[15];
			var InciCode = list[0];
			var InciDesc = list[1];
			var BUomId = list[6], BUomDesc = list[7];
			var Spec = list[16];
			var Sp = list[11];
			var ManfId = list[17], Manf = list[18];
			var IngrUomId = list[8], IngrUom = list[9];
			var BUomId = list[6];
			var NotUseFlag = list[19];
			var BatchReq = list[20];
			var ExpReq = list[21];
			var BRp = list[22], BSp = list[23];
			if(NotUseFlag=='Y'){
				Msg.info('warning', '��'+rowNumber+'��: '+InciCode+' Ϊ"������"״̬!');
				return;
			}
			var VendorId = Ext.getCmp('ImpVendor').getValue();
			var VendorDesc = Ext.getCmp('ImpVendor').getRawValue();
//			colArr = sortColoumByEnterSort(BarCodeGrid); //���س��ĵ���˳���ʼ����
			// ����һ��
			BarCodeGrid.addNewRow();
			addComboData(PhManufacturerStore,ManfId,Manf);
			var row = BarCodeGrid.getStore().getCount();
			var rec = BarCodeGrid.getStore().getAt(row-1);
			
			rec.set('OriginalCode', OriginalCode);
			rec.set('BatchCode', BatchCode);
			rec.set('IncId', InciId);
			rec.set('IncCode', InciCode);
			rec.set('IncDesc', InciDesc);
			rec.set('Spec', Spec);
			rec.set('Qty', 1);
			rec.set('Rp',BRp);
			rec.set('Sp', BSp);
			rec.set('BatNo', BatchNo);
			rec.set('ExpDate', ExpDate);
			rec.set('ManfId', ManfId);
			rec.set('IngrUomId',IngrUomId);
			rec.set('BUomId', BUomId);
			rec.set('BatchReq', BatchReq);
			rec.set('ExpReq', ExpReq);
			rec.set('VendorId', VendorId);
			rec.set('VendorDesc', VendorDesc);
		}else{
			Msg.info('error','��'+rowNumber+'�ж�ȡ����!');
			return false ;
		}
		return true;
	}catch(e){
		Msg.info('error','��ȡ���ݴ���:' + e);
		return false;
	}
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

var DeleteButton = new Ext.ux.Button({
	text : 'ɾ������',
	iconCls : 'page_delete',
	width : 70,
	height : 30,
	handler : function(button, e) {
		var DelRowIdStr = '';
		var count = BarCodeGrid.getCount();
		for(var rowIndex = count - 1; rowIndex >= 0; rowIndex--){
			var RowData = BarCodeGrid.getAt(rowIndex);
			var DeleteFlag = RowData.get('DeleteCheck');
			if(DeleteFlag != "Y"){
				continue;
			}
			var RowId = RowData.get('InctrackId');
			if(Ext.isEmpty(RowId)){
				BarCodeGrid.remove(RowData);
			}else{
				if(DelRowIdStr == ''){
					DelRowIdStr = RowId;
				}else{
					DelRowIdStr = DelRowIdStr + '^' + RowId;
				}
			}
		}
		if(DelRowIdStr != ''){
			if(confirm('����Ҫɾ���Ѿ������������Ϣ,�Ƿ����?')){
				var Ret = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'DeleteLabel', DelRowIdStr);
				if(Ret != ''){
					Msg.info('error', 'ɾ��ʧ��: ' + Ret);
				}else{
					BarCodeGrid.reload();
				}
			}
		}else{
			BarCodeGrid.getView().refresh();
		}
	}
});
var DelSelectAllBtn = new Ext.Button({
	text : 'ɾ��ȫѡ',
	iconCls : 'page_gear',
	width : 70,
	height : 30,
	handler : function(button, e) {
		var count = BarCodeGrid.getCount();
		if(count > 0){
			var YesNo = BarCodeGrid.getAt(0).get('DeleteCheck') == 'Y'? 'N' : 'Y';
		}
		for(var rowIndex = 0; rowIndex < count; rowIndex++){
			var RowData = BarCodeGrid.getAt(rowIndex);
			RowData.set('DeleteCheck', YesNo);
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
				Ext.getCmp('StatusFlag').setValue('Temp');
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
	var MainInfo = CreateUser + "^" + StkGrpId + '^' + gLocId;
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
						var ParamObj = paramsFn(time);
						var Param = ParamObj['Param'];
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

var DownLoadBT = new Ext.Button({
	text : '����ģ��',
	height : 30,
	width : 70,
	iconCls : 'page_excel',
	handler : function(){
		window.open("../scripts/dhcstm/BarCode/��̨��ֵ�Ĳ���Ϣ����ģ��.xls", "_blank");
	}
});
	
var formPanel = new Ext.ux.FormPanel({
			title : '��Ӧ�̸�ֵ��������',
			labelWidth : 60,
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', clearBarCode, '-', saveBarCode, '-',impByPo, '-', DeleteButton,
				DelSelectAllBtn,
				'->', DownLoadBT
				// '-', addBarCode
			],
			layout : 'column',
			items : [{
					columnWidth : 1,
					xtype : 'fieldset',
					title : '��ѯ����',
					layout : 'column',
					items : [{
								columnWidth : .25,
								layout : 'form',
								items : [startDate, endDate, OriginalCode]
							}, {
								columnWidth : .25,
								layout : 'form',
								items : [BarCodeField,BatNo, BatchCode]
							}, {
								columnWidth : .25,
								layout : 'form',
								items : [RequestPhaLoc, StkGrpType, ImpVendor, StatusFlag]
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
				items : [formPanel, BarCodeGrid],		//reportPanel
				renderTo : 'mainPanel'
			});
});