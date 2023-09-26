// ����:		��ֵ������ʱ����ҵ��(�ڼ��յ�ʱ�乩��ʿ�Ƚ�ɫʹ��)
// ��д�ˣ�	wangjiabin
// ��д����:	2016-11-07
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var gHospId = session['LOGON.HOSPID'];
var inciDr = "";
var CURRENT_INGR = '', CURRENT_INIT = '';		//���β�¼��ⵥrowidStr, ���ⵥrowidStr

//�������ֵ��object
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');
var DEFA_RECLOC_DESC = ItmTrackParamObj.DefaRecLoc;
var DEFA_RECLOC_ID = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'LocToRowID', DEFA_RECLOC_DESC);
if(Ext.isEmpty(DEFA_RECLOC_ID)){
	DEFA_RECLOC_DESC = '';
	Msg.info('error', '����ϵ����Ա����������!');
}

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
	var CurStartRow;		//��¼����¼��ĵ�һ��
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records,function(record,index,allItems){
		inciDr = record.get("InciDr");
		var inciCode = record.get("InciCode");
		var inciDesc = record.get("InciDesc");
		var Spec = record.get("Spec");
		var pbrp= record.get("PbRp");
		var PFac=record.get("PFac");
		var pSp=record.get("pSp");
		var CertNo=record.get("CertNo");
		var CertExpDate=toDate(record.get("CertExpDate"));

		var cell = BarCodeGrid.getSelectionModel().getSelectedCell();	// ѡ����
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
		rowData.set('Qty', PFac);  //��ⵥλ�ͻ�����λ��һ��  Ĭ�ϴ�ӡ��������Ϊת��ϵ��
		rowData.set('PbRp',pbrp);
		rowData.set('CerNo',CertNo);
		rowData.set('CerExpDate',CertExpDate);
		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;   //ȡ����������Ϣ
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
				rowData.set("BatNo", data[6]);
				rowData.set("ExpDate", toDate(data[7]));
				rowData.set("BUomId", data[10]);
				var Marginnow = '';
				if(Number(data[4]) > 0){
					Marginnow = accDiv(Number(data[5]), Number(data[4]));
				}
				rowData.set('Marginnow',Marginnow);
			}
			//��ʵ������Ϣ
			var StrParam = '^' + inciDr + '^' + data[0];		//vendor^inci^manf
			var AlarmDays = 30;
			var CheckInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'Check', StrParam, AlarmDays);
			if(!Ext.isEmpty(CheckInfo)){
				Msg.info("warning", inciDesc + ':' + CheckInfo);
			}
		}
		if(!CurStartRow){
			CurStartRow = row;
		}
		BarCodeGrid.addNewRow();
	});
	
	var col = GetColIndex(BarCodeGrid, 'Qty');
	if (!BarCodeGrid.getColumnModel().isHidden(col)){
		BarCodeGrid.startEditing(CurStartRow, col);
	}
}

//������
var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '������',
	id : 'PhaLoc',
	anchor : '90%',
	emptyText : '������...',
	disabled : true,
	defaultLoc : {RowId : DEFA_RECLOC_ID, Description : DEFA_RECLOC_DESC}
});
//PhaLoc.setValue(DEFA_RECLOC_DESC)
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
var RegFlag = new Ext.form.Checkbox({
		hideLabel: true,
		boxLabel: "�����",
		id: 'RegFlag',
		//anchor: '90%',
		checked: false
	});
var startDate = new Ext.ux.DateField({
	id : 'startDate',
	//disabled : true,
	fieldLabel : '��ʼ����',
	anchor : '95%',
	value : new Date()
});
// ��ֹ����
var endDate = new Ext.ux.DateField({
	id : 'endDate',
	//disabled : true,
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
				GetPhaOrderInfo2(field.getValue(), stktype);
			}
		},
		blur : function(field) {
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
function getDrugList2(record){
	inciDr = record.get("InciDr");
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(inciDesc);
	Ext.getCmp("M_InciCode").setValue(inciCode);
}
var Vendor=new Ext.ux.VendorComboBox({
	id : 'Vendor',
	name : 'Vendor',
	anchor:'95%'
});		
var UsePhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '���տ���',
	id : 'UsePhaLoc',
	anchor : '90%',
	emptyText : '���տ���...',
	listeners:{
		'select':function(cb){
			var OperLoc=cb.getValue();
			var IfAllowDo=tkMakeServerCall("web.DHCSTM.HVUsePermissonLoc","IfAllowDo",OperLoc,gUserId);
			if (IfAllowDo==-1)
			{
				Msg.info("warning","�˽��տ��ҵ�ǰû�в�����ֵ���Ȩ��!");
				return false;
			}
		}
	}
	//groupId : gGroupId
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
			width : 100,
			align : 'left',
			renderer :Ext.util.Format.InciPicRenderer('IncId'),
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
			width : 80,
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
			header : "��������",
			dataIndex : 'BarCode',
			width : 150,
			align : 'left',
			sortable : false,
			saveColIndex : 2,
			editable : false,		//2015-12-28 ���ɱ༭
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
						if (e.getKey() == Ext.EventObject.ENTER) {							//�Դ����뾭���ֶ�,���ﲻ��ת��
							return false;
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
		},{
			header : "ƽ̨�ӱ�id",
			dataIndex : 'OrderDetailSubId',
			width : 80,
			align : 'left',
			saveColIndex : 15,
			sortable : true,
			hidden:true
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
	var vendor = Ext.getCmp("Vendor").getValue();
	var reqloc = '';
	var batno= Ext.getCmp("BatNo").getValue();
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Status = Ext.getCmp("RegFlag").getValue()==true? 'Enable' : '';		//����״̬
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate+"^"+vendor+"^"+reqloc+"^"+batno+"^"+gHospId
			 + "^" + gUserId+"^"+""+"^"+""+"^"+Status;
	return {'Param' : Param};
}

function beforeAddFn(){
	if(Ext.isEmpty(DEFA_RECLOC_ID)){
		Msg.info('error', '����ϵ����Ա����������!');
		return false;
	}
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
	smRowSelFn : Ext.emptyFn,
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
		},
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().select(rowindex,1);
			//����δ�����������ϸ�����Ҽ��˵�
			if(grid.getStore().getAt(rowindex).get('InctrackId')==''){
				rightClick.showAt(e.getXY());
			}
		},
		'rowdblclick' : function(grid, rowIndex, e){
			var record = grid.getStore().getAt(rowIndex)
			var dhcit = record.get('InctrackId');
			if(Ext.isEmpty(dhcit)){
				return;
			}
			var BarCode = record.get('BarCode');
			var IncDesc = record.get('IncDesc');
			var InfoStr = BarCode + ' : ' + IncDesc;
			BarCodePackItm(dhcit, InfoStr);
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

//>>>>>>>>>>��ⵥ���Բ���>>>>>>>>>>
var GrMasterInfoStore = new Ext.data.JsonStore({
	url : DictUrl	+ 'ingdrecaction.csp?actiontype=QueryIngrStr',
	totalProperty : "results",
	root : 'rows',
	fields : ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
		"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
		"StkGrp","RpAmt","SpAmt","AcceptUser","InvAmt"],
	listeners : {
		load : function(store, records, option){
			if(records.length > 0){
				GrMasterInfoGrid.getSelectionModel().selectFirstRow();
				GrMasterInfoGrid.getView().focusRow(0);
			}
		}
	}
});

var GrMasterInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'IngrId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : "��ⵥ��",
		dataIndex : 'IngrNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : '��ⲿ��',
		dataIndex : 'RecLoc',
		width : 120,
		align : 'left',
		sortable : true
	},  {
		header : "��Ӧ��",
		dataIndex : 'Vendor',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		dataIndex : "StkGrp",
		hidden : true,
		hideable : false
	}, {
		header : '�ɹ�Ա',
		dataIndex : 'PurchUser',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "��ɱ�־",
		dataIndex : 'Complete',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ���",
		dataIndex : 'InvAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "���۽��",
		dataIndex : 'RpAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		xtype : 'numbercolumn',
		width : 80,
		align : 'right'
	}, {
		header : "��ע",
		dataIndex : 'InGrRemarks',
		width : 160,
		align : 'left'
	}
]);

var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
	id : 'GrMasterInfoGrid',
	title : '',
	//autoHeight: true,
	cm : GrMasterInfoCm,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var InGr = r.get("IngrId");
				GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:InGr}});
			}
		}
	}),
	store : GrMasterInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:[GridPagingToolbar]
});

var GrDetailInfoStore = new Ext.data.JsonStore({
	url : DictUrl + 'ingdrecaction.csp?actiontype=QueryDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
		"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
		"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
		"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:DateFormat},"AdmNo",
		{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"CheckPack","InvMoney"]
});

var GrDetailInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "Ingri",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : '���ʴ���',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'Manf',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'BatchNo',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "��Ч��",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'IngrUom',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'RecQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "�ۼ�",
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "��Ʊ��",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ����",
		dataIndex : 'InvDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ���",
		dataIndex : 'InvMoney',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "���۽��",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var GrDetailInfoGrid = new Ext.grid.GridPanel({
	id : 'GrDetailInfoGrid',
	title : '',
	height : 170,
	cm : GrDetailInfoCm,
	store : GrDetailInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true
});

var IngrInfoPanel = new Ext.Panel({
	layout : 'border',
	items : [{split:true,region:'north',layout:'fit',height:200,items:GrMasterInfoGrid}, 
			{split:true,region:'center',layout:'fit',items:GrDetailInfoGrid}]
});
//<<<<<<<<<<��ⵥ���Բ���<<<<<<<<<<

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
var saveBarCode = new Ext.ux.Button({
	text : '����',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		save();
	}
});

function GetRecordPrtStr(record){
	var barcode=record.get('BarCode');
	var IncDesc=record.get('IncDesc');
	var Spec=record.get('SpecDesc');
	var ReqNo=record.get('ReqNo');
	var Brand=record.get('Brand');
	var ReqLocDesc=record.get('ReqLocDesc');
	var Sp=record.get('Sp');
	var BatNo=record.get('BatNo');
	var ExpDate=record.get('ExpDate')
	if(Ext.isEmpty(ExpDate)){
		ExpDate="";
	}else{
		ExpDate=ExpDate.format(ARG_DATEFORMAT);
	}
	
	var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
			+'^IncDesc'+String.fromCharCode(2)+IncDesc
			+'^ReqNo'+String.fromCharCode(2)+ReqNo
			+'^Brand'+String.fromCharCode(2)+Brand
			+'^Spec'+String.fromCharCode(2)+Spec
			+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
			+'^Sp'+String.fromCharCode(2)+Sp
			+'^BatNo'+String.fromCharCode(2)+BatNo
			+'^ExpDate'+String.fromCharCode(2)+ExpDate;
	return MyPara;
}

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
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara = GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
		}
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
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara=GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
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
		for(var rowIndex=0; rowIndex<rowsCount; rowIndex++){
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara=GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
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
		for(var rowIndex=0; rowIndex<rowsCount; rowIndex++){
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara=GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
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
		clearData();
	}
});
/**
 * ��շ���
 */
function clearData() {
	CURRENT_INGR = '', CURRENT_INIT = '';
	inciDr = "";
	Ext.getCmp("ImpVendor").setValue("");
	Ext.getCmp("SourceOfFund").setValue("");
	Ext.getCmp("UsePhaLoc").setValue("");
	clearPanel(formPanel);
	GrMasterInfoGrid.getStore().removeAll();
	GrDetailInfoGrid.getStore().removeAll();
	BarCodeGrid.removeAll();
	formPanel.getForm().setValues({"startDate":new Date(),"endDate":new Date()});	
}
	
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
	tooltip : '������һ�е����ź�Ч��',
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
		var expDateValue = BarCodeGrid.getStore().getAt(i).get("ExpDate");
		var item = BarCodeGrid.getStore().getAt(i).get("IncId");
		var ExpDate = new Date(Date.parse(expDateValue));
		if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			 
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var qty = BarCodeGrid.getStore().getAt(i).get("Qty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "�����������С�ڻ����0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var realPrice = BarCodeGrid.getAt(i).get("Rp");
		if ((item != "")&& (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "�����۲���С�ڻ����0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
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
	var LocId = Ext.getCmp("PhaLoc").getValue();
	var CreateUser = gUserId;
	var ExchangeFlag ='N';
	var PresentFlag = 'N';
	var IngrTypeId = "";    //�������		
	var PurUserId =""
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var PoId="";  //����id
	var SourceOfFund = Ext.getCmp('SourceOfFund').getValue();
	var UsePhaLoc = Ext.getCmp('UsePhaLoc').getValue();
	if(Ext.isEmpty(UsePhaLoc)){
		Msg.info('error', 'δ¼����տ���!');
		return false;
	}
	var AllowFlag=tkMakeServerCall("web.DHCSTM.HVUsePermissonLoc","IfAllowDo",UsePhaLoc,gUserId);
	if (AllowFlag==-1) {
		Msg.info("warning", "�˽��տ��ҵ�ǰû�в�����ֵ���Ȩ��!");
		return false;
	}
	if (AllowFlag==-2) {
		Msg.info("warning", "��ǰ��½��Աû�в�����ֵ���Ȩ��!");
		return false;
	}
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag 
			+ "^" + IngrTypeId + "^" + PurUserId + "^"+ StkGrpId +"^"+ PoId + '^' + ''
			+ '^' + SourceOfFund + '^' + UsePhaLoc;
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
	var ret = tkMakeServerCall('web.DHCSTM.DHCINGdRec', 'CreateUrgencyIngr', Ingr, MainInfo, ListDetail);
	if(ret.split('^').length > 1){
		Msg.info('success', '����ɹ�!');
		//findBarCode.handler();
		BarCodeGrid.removeAll();
		CURRENT_INGR = ret.split('^')[0];
		CURRENT_INIT = ret.split('^')[1];
		if(CURRENT_INGR != ''){
			tabPanel.activate('CurrentIngrPanel');
		}
	}else{
		Msg.info('error', '����ʧ��:' + ret);
	}
}

var PrintSplitButton = new Ext.SplitButton({
	text: '��ӡѡ��',
	width : 70,
	height : 30,
	iconCls : 'page_add',
	tooltip: '�������밴ť',
	menu : {
		items: [{
			text: '<b>��ӡ����</b>', handler: printBarCode.handler
		},{
			text: '<b>��ӡ��ҳ����</b>', handler: printBarCodeTotal.handler
		},{
			text: '<b>��ӡ����(2��)</b>', handler: printBarCode2.handler
		},{
			text: '<b>��ӡ��ҳ����(2��)</b>', handler: printBarCodeTotal2.handler
		}]
	}
});

var PrintIngrButton = new Ext.Toolbar.Button({
	text:'��ӡ��ⵥ',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		var rowData = GrMasterInfoGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
			return;
		}
		var DhcIngr = rowData.get("IngrId");
		PrintRec(DhcIngr);
	}
});

var formPanel = new Ext.form.FormPanel({
	columnWidth : .65,
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	trackResetOnLoad : true,
	tbar : [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode, '-', PrintSplitButton, '-', copybutton],
	items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',
			items : [{
						columnWidth : .4,
						layout : 'form',
						items : [BarCodeField, startDate, endDate, Vendor]
					}, {
						columnWidth : .4,
						layout : 'form',
						items : [StkGrpType, M_InciCode, M_InciDesc, BatNo]
					}, {
						columnWidth : .2,
						layout : 'form',
						items : [RegFlag]
					}]
		}]
});

var RecPanel = new Ext.form.FormPanel({
	columnWidth : .35,
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	trackResetOnLoad : true,
	tbar : [saveImp, '-', PrintIngrButton],
	items : [{
		xtype : 'fieldset',
		title : '���ѡ��',
		labelWidth : 100,
		layout : 'form',
		items : [PhaLoc, ImpVendor, SourceOfFund, UsePhaLoc]
	}]
});

var tabPanel = new Ext.TabPanel({
	region : 'center',
	split:true,
	activeTab: 0,
	items:[
		{title: '��ֵ������Ϣ',id:'HVMatPanel',layout:'fit',items:BarCodeGrid},
		{title: '���β�¼�����Ϣ',id:'CurrentIngrPanel',layout:'fit',items:IngrInfoPanel}
//		,
//		{title: '���β�¼������Ϣ',id:'CurrentInitPanel',layout:'fit',items:InitInfoPanel}
	],
	listeners:{
		'tabchange' : function(t,p){
			if (p.getId()=='CurrentIngrPanel'){
				if (CURRENT_INGR!=""){
					GrMasterInfoGrid.getStore().load({params:{IngrStr:CURRENT_INGR}});
				}
			}else if (p.getId()=='CurrentInitPanel'){
				if (CURRENT_INIT!=""){
					InitMasterGrid.getStore().load({params:{InitStr:CURRENT_INIT}});
				}
			}
		}
	}
});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title : '��ֵ��������(����ҵ��)',
		region : 'north',
		autoHeight : true,
		layout : 'column',
		items : [formPanel, RecPanel]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [panel, tabPanel],
		renderTo : 'mainPanel'
	});
	
});
function SavePrintFlag(PrintFlag,Barecode){
	tkMakeServerCall("web.DHCSTM.DHCItmTrack","SavePrintFlag",PrintFlag,Barecode);
}