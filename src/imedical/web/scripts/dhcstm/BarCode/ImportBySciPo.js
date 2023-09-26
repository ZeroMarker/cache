// /����: ����
function ImportBySciPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];

	// ��ⵥ��
	var SxNo = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'SxNo',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					PoQuery();
				}
			}
		}
	});

	var SCIPoReqLoc = new Ext.ux.LocComboBox({
		fieldLabel : '�깺����',
		id : 'SCIPoReqLoc',
		emptyText : '�깺����...',
		defaultLoc : {},
		disabled : true
	});

	var SCIPoNo = new Ext.form.TextField({
		fieldLabel : '������',
		readOnly:true,
		id : 'SCIPoNo',
		anchor : '90%'
	});

	var SCIPoVendor = new Ext.ux.VendorComboBox({
		id : 'SCIPoVendor',
		fieldLabel : '��Ӧ��',
		disabled : true
	});
	var SCIPoDate = new Ext.form.TextField({
		fieldLabel : '��������',
		readOnly:true,
		id : 'SCIPoDate',
		anchor : '90%'
	});
	// ��ѯ������ť
	var PoSearchBT = new Ext.ux.Button({
				id : "PoSearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				iconCls : 'page_find',
				handler : function() {
					PoQuery();
				}
			});


	// ��հ�ť
	var PoClearBT = new Ext.ux.Button({
				id : "PoClearBT",
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					PoclearData();
				}
			});
	/**
	 * ��շ���
	 */
	function PoclearData() {
		SciPoDetailGrid.store.removeAll();
		SciPoDetailGrid.getView().refresh();
		clearPanel(PoHisListTab);
	}

	/**
	 * �رշ���
	 */
	var PoDeleteBT = new Ext.Toolbar.Button({
				id : "PoDeleteBT",
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					//var flg = false;
					Powin.close();
				}
			});
	// ���水ť
	var PoSaveBT = new Ext.ux.Button({
				id : "PoSaveBT",
				text : '����',
				tooltip : '�������',
				iconCls : 'page_save',
				handler : function() {
					if(SciPoDetailGrid.activeEditor != null){
						SciPoDetailGrid.activeEditor.completeEdit();
					}
					if(PoCheckDataBeforeSave()==true){
						Posave();
					}
				}
			});

	/**
	 * ������ⵥǰ���ݼ��
	 */
	function PoCheckDataBeforeSave() {
		// 1.�ж���������Ƿ�Ϊ��
		var rowCount = SciPoDetailGrid.getStore().getCount();
		if (rowCount <= 0) {
			Msg.info("warning", "����ϸ!");
			return false;
		}
		return true;
	}

	/**
	 * ������ⵥ
	function Posave() {
		var selectRecords = SciPoDetailGrid.getSelectionModel().getSelections();
		if(Ext.isEmpty(selectRecords)){
			Msg.info('warning', '��ѡ����Ҫ���������!');
			return false;
		}
		var venid=arrinfo[1]
		var vendesc=arrinfo[2]
		addComboData(Ext.getCmp("ImpVendor").getStore(),venid,vendesc);
		Ext.getCmp("ImpVendor").setValue(venid);
		var phaloc = Ext.getCmp("PhaLoc").getValue();
		var SxNo = Ext.getCmp("SxNo").getValue();
		Fn(selectRecords,phaloc,SxNo);
		Powin.close()
	}*/
	/**
	 * �������е����ұ���
	 */
	function Posave() {
		var selectRecords = SciPoDetailGrid.getSelectionModel().getSelections();
		if(Ext.isEmpty(selectRecords)){
			Msg.info('warning', '��ѡ����Ҫ���������!');
			return false;
		}
		var maindatalist=gUserId+"^"+gLocId;
		var detaildatalist="";
		var vendorid=Ext.getCmp("SCIPoVendor").getValue();
		var SxNo = Ext.getCmp("SxNo").getValue();
		for (j=0;j<selectRecords.length;j++)
		{
			//s data=InPoI+"^"+IncId+"^"+BarCode+"^"+Qty+"^"+BatchNo+"^"+Expdate+"^"+SpecDesc+"^"+CertNo+"^"+CertExpDate+"^"+Rp+"^"+ManfId+"^"+VendorId+"^"+OrderDetailSubId;
			var record=selectRecords[j];
			var Poid=record.get("PoItmId");
			var inci=record.get("IncId");
			var barcode=record.get("BarCode");
			var qty=record.get("AvaBarcodeQty");
			var batchno=record.get("BatNo");
			var expdate=Ext.util.Format.date(record.get("ExpDate"),ARG_DATEFORMAT);
			var specdesc=record.get("SpecDesc");
			var certno=record.get("CerNo");
			var certexpdate=Ext.util.Format.date(record.get("CerExpDate"),ARG_DATEFORMAT);
			var rp=record.get("Rp");
			var manfid=record.get("ManfId");
			var orddetailsubid=record.get("OrderDetailSubId");
			var OriginalCode = record.get('OriginalCode');
			var data=Poid+"^"+inci+"^"+barcode+"^"+qty+"^"+batchno
				+"^"+expdate+"^"+specdesc+"^"+certno+"^"+certexpdate+"^"+rp
				+"^"+manfid+"^"+vendorid+"^"+orddetailsubid+"^"+SxNo+"^"+OriginalCode;
			if (detaildatalist==""){
				detaildatalist=data;
			}else{
				detaildatalist=detaildatalist+RowDelim+data;
			}
		}
		if(detaildatalist==""){
				Msg.info("warning","û����Ҫ���������!");
				return false;
		}
		var mask=ShowLoadMask(Powin.body, "���ڵ�������...");
		var url = "dhcstm.barcodeaction.csp?actiontype=SaveBySciPo";
		Ext.Ajax.timeout=240000;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{MainInfo: maindatalist,ListDetail: detaildatalist},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					var datetimeinfo = jsonData.info;
					var SCIPoVendorId=Ext.getCmp("SCIPoVendor").getValue();
					var SCIPoVendorDesc=Ext.getCmp("SCIPoVendor").getRawValue();
					Powin.close();
					Fn(datetimeinfo,SCIPoVendorId,SCIPoVendorDesc);
				} else {
					var ret=jsonData.info;
					Msg.info("error", "�����ֵ����ʧ��!"+ret);
				}
				mask.hide();
			},
			scope : this
		});
	}
	// ��ʾ��������
	function PoQuery() {
		var SxNo = Ext.getCmp("SxNo").getValue();
		var HVFlag = 'Y';		//����ȡ��ֵ����
		var mask = ShowLoadMask(Powin.body, "���������Ժ�...");
		Ext.Ajax.request({
			url: 'dhcstm.sciaction.csp?actiontype=getOrderDetail',
			params: {SxNo : SxNo, HVFlag : HVFlag},
			waitMsg: '������...',
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if(!Ext.isEmpty(jsonData)){
					if(!Ext.isEmpty(jsonData['Main']) && !Ext.isEmpty(jsonData['Detail'])){
						if(jsonData['Detail']['results'] > 0){
							PoHisListTab.getForm().setValues(jsonData['Main']);
							SciPoDetailGrid.getStore().loadData(jsonData['Detail']);
						}else{
							Msg.info('warning', 'δ�ҵ����ϵĵ�����ϸ,��ȷ���Ƿ��ֵ����!');
						}
					}else{
						Msg.info('warning', '�õ����Ѵ���!');
					}
				}else{
					Msg.info("warning", "δ�ҵ����ϵĵ���!");
				}
			},
			scope: this
		});
	}
	// ����·��
	var DetailUrl =DictUrl+
		'sciaction.csp?actiontype=getOrderDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:'ExpDate',type:'date',dateFormat:DateFormat}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo",
			 {name:'CerExpDate',type:'date',dateFormat:DateFormat},
			 "HighValueFlag","BarCode","OrderDetailSubId","OriginalCode"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				fields : fields
			});
	// ���ݼ�
	var SciPoDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				pruneModifiedRecords:true
			});
	var sm2=new Ext.grid.CheckboxSelectionModel({
			listeners : {
				beforerowselect :function(sm,rowIndex,keepExisting ,record  ) {
					var hvflag=record.get("HighValueFlag")
					if (hvflag!='Y'){Msg.info("warning","��ѡ���ֵ����!");return false}
				}
			}
	})
	var nm = new Ext.grid.RowNumberer();
	var SciPoDetailCm = new Ext.grid.ColumnModel([nm,sm2,{
				header : "������ϸid",
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����RowId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
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
				header : '���',
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '������',
				dataIndex : 'SpecDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '��ֵ��־',
				dataIndex : 'HighValueFlag',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'AvaBarcodeQty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {

								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "��������Ϊ��!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "��������С�ڻ����0!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "����",
				dataIndex : 'BarCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�����Դ�����",
				dataIndex : 'OriginalCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'BatNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "Ч��",
				dataIndex : 'ExpDate',
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				width : 80,
				align : 'left',
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
			},{
				header : "��������",
				dataIndex : 'PurQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "���������",
				dataIndex : 'ImpQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����������",
				dataIndex : 'BarcodeQty',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "ע��֤����",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "ע��֤Ч��",
				dataIndex : 'CerExpDate',
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				width : 80,
				align : 'left',
				sortable : true
			}]);

	var SciPoDetailGrid = new Ext.ux.EditorGridPanel({
				id:'SciPoDetailGrid',
				region: 'center',
				title: '������ϸ',
				cm : SciPoDetailCm,
				store : SciPoDetailStore,
				sm:sm2,
				clicksToEdit:1
			});
	var PoHisListTab = new Ext.ux.FormPanel({
		region: 'north',
		tbar : [PoSearchBT,'-',PoClearBT, '-',PoSaveBT,'-',PoDeleteBT],
		layout: 'column',
		items:[{
			columnWidth: 0.3,
			layout: 'column',
			xtype:'fieldset',
			title:'��ѯ����',
			defaults: {xtype: 'fieldset', border:false},
			items:[{
				columnWidth: 1,
				items: [SxNo]
			}]
		},{
			columnWidth: 0.7,
			layout: 'column',
			xtype:'fieldset',
			title:'������Ϣ',
			defaults: {xtype: 'fieldset', border:false},
			items:[{
				columnWidth: 0.5,
				items: [SCIPoNo,SCIPoVendor]
			},{
				columnWidth: 0.5,
				items: [SCIPoReqLoc,SCIPoDate]
			}]
		}]
	});

	// ҳ�沼��
	var Powin = new Ext.ux.Window({
				title:'�����ӡ-������ƽ̨��������',
				width : gWinWidth,
				height : gWinHeight,
				layout : 'border',
				items : [PoHisListTab,SciPoDetailGrid]
			});
	//ҳ�������ɺ��Զ���������
	Powin.show()
	SxNo.focus(true,100)

}