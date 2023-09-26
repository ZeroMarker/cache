// /����: ��ѯ����
// /����: ��ѯ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18

function DrugImportGrSearch(dataStore,Fn) {
	var gUserId = session['LOGON.USERID'];
	var flg = false;
	var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['N', 'δ���'], ['Y', '�����']]
		});
	var Status = new Ext.form.ComboBox({
			fieldLabel : '����״̬',
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 120,
			store : StatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
	// ��ⵥ��
	var InGrNoS = new Ext.form.TextField({
				fieldLabel : '��ⵥ��',
				id : 'InGrNoS',
				name : 'InGrNoS',
				anchor : '90%',
				width : 120
			});

	// ��Ӧ��
	var VendorS = new Ext.ux.VendorComboBox({
				fieldLabel : '��Ӧ��',
				id : 'VendorS',
				name : 'VendorS',
				anchor : '90%',
				emptyText : '��Ӧ��...',
				params : {LocId : 'PhaLocS'}
			});

	// ��ⲿ��
	var PhaLocS = new Ext.ux.LocComboBox({
				fieldLabel : '��ⲿ��',
				id : 'PhaLocS',
				name : 'PhaLocS',
				anchor : '90%',
				emptyText : '��ⲿ��...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'VendorS',
				defaultLoc : {
					'RowId' : Ext.getCmp('PhaLoc').getValue(),
					'Description' : Ext.getCmp('PhaLoc').getRawValue()
				}
			});
	
	// ��ʼ����
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDateS',
				name : 'StartDateS',
				anchor : '90%',
				
				anchor : '90%',
				value : DefaultStDate()
			});

	// ��������
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '��������',
				id : 'EndDateS',
				name : 'EndDateS',
				anchor : '90%',
				
				value : DefaultEdDate()
			});
	
	var InfoFormS = new Ext.ux.FormPanel({
				id : "InfoFormS",
				labelWidth: 60,
				items : [{
					layout: 'column',    // Specifies that the items will now be arranged in columns
					xtype:'fieldset',
					title:'��ѯ����',
					style:'padding:5px 0px 0px 0px',
					defaults: {border:false},    // Default config options for child items
					items:[{
						columnWidth: 0.33,
						xtype: 'fieldset',
						defaultType: 'textfield',
						items: [PhaLocS,VendorS]
						
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [StartDateS,EndDateS]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						items: [InGrNoS,Status]
					}]
				}]
			});

	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ��ⵥ��Ϣ',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var StartDate = Ext.getCmp("StartDateS").getValue();
		if((StartDate!="")&&(StartDate!=null)){
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		var EndDate = Ext.getCmp("EndDateS").getValue();
		if((EndDate!="")&&(EndDate!=null)){
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		var InGrNo = Ext.getCmp("InGrNoS").getValue();
		var Vendor = Ext.getCmp("VendorS").getValue();
		var PhaLoc = Ext.getCmp("PhaLocS").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "��ѡ����ⲿ��!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return;
		}
		var Status=Ext.getCmp("Status").getValue();
		var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc+'^'+Status+'^^N'+"^"+""+"^"+gUserId;
		var Page=GridPagingToolbar.pageSize;
		GrMasterInfoStore.baseParams={ParamStr:ListParam};
		GrMasterInfoStore.removeAll();
		GrMasterInfoGrid.store.removeAll();
		GrDetailInfoGrid.store.removeAll();
		GrMasterInfoStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
					Msg.info("error", "��ѯ������鿴��־!");
				}else{
					if(r.length>0){
						GrMasterInfoGrid.getSelectionModel().selectFirstRow();
						GrMasterInfoGrid.getView().focusRow(0);
					}
				}
			}
		});
	}

	// ѡȡ��ť
	var returnBT = new Ext.Toolbar.Button({
				text : 'ѡȡ',
				tooltip : '���ѡȡ',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					returnData();
				}
			});

	// ��հ�ť
	var clearBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '������',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		Ext.getCmp("InGrNoS").setValue("");
		Ext.getCmp("VendorS").setValue("");
		Ext.getCmp("PhaLocS").setValue(session['LOGON.CTLOCID']);
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		
		GrMasterInfoGrid.store.removeAll();
		GrDetailInfoGrid.store.removeAll();
	}

	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					flg = false;
					window.close();
				}
			});

	// ����·��
	var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});

	// ָ���в���
	var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp","RpAmt","SpAmt","ReqLocDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// ���ݼ�
	var GrMasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var GrMasterInfoCm = new Ext.grid.ColumnModel([nm, {
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
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'ReqLocDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '������',
				dataIndex : 'CreateUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'CreateDate',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '�ɹ�Ա',
				dataIndex : 'PurchUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'IngrType',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��ɱ�־",
				dataIndex : 'Complete',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}]);
	GrMasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:GrMasterInfoStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var GrMasterInfoGrid = new Ext.grid.GridPanel({
				region: 'west',
				title: '��ⵥ',
				collapsible: true,
				split: true,
				width: 225,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
				id : 'GrMasterInfoGrid',
				cm : GrMasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners:{
								'rowselect':function(sm,rowIndex,r){
									var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
									var pagesize=DetailGridPagingToolbar.pageSize;
									GrDetailInfoStore.setBaseParam('Parref',InGr);
									GrDetailInfoStore.load({params:{start:0,limit:pagesize,sort:'Rowid',dir:'Desc'}});
								}
							}
						}),
				store : GrMasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});

	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Ingri",
				fields : fields
			});
	// ���ݼ�
	var GrDetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
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
				header : "����",
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
			}]);
	GrDetailInfoCm.defaultSortable = true;
	var DetailGridPagingToolbar = new Ext.PagingToolbar({
		store:GrDetailInfoStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var GrDetailInfoGrid = new Ext.grid.GridPanel({
				region: 'center',
				title: '��ⵥ��ϸ',
				cm : GrDetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:DetailGridPagingToolbar
			});

	// ˫���¼�
	GrMasterInfoGrid.on('rowdblclick', function() {
				returnData();
			});

	
	var window = new Ext.Window({
				title : '��ⵥ��ѯ',
				width : gWinWidth,
				height : gWinHeight,
				modal : true,
				layout : 'border',
				items : [InfoFormS, GrMasterInfoGrid, GrDetailInfoGrid],
				tbar : [searchBT, '-', returnBT, '-', clearBT, '-', closeBT]
			});
	window.show();
	searchDurgData();
	
	window.on('close', function(panel) {
			var selectRows = GrMasterInfoGrid.getSelectionModel().getSelections();
			if (selectRows==undefined ||selectRows.length == 0) {
				Fn("");
			} else {
				if(flg){
					var InGrRowId = selectRows[0].get("IngrId");				
					Fn(InGrRowId);	
				}else{
					Fn("");
				}			
			}
		});

	function returnData() {
		var selectRows = GrMasterInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Ext.Msg.show({
						title : '����',
						msg : '��ѡ��Ҫ���ص���ⵥ��Ϣ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		} else {
			flg = true;
			var InGrRowId = selectRows[0].get("IngrId");
			//getInGrInfoByInGrRowId(InGrRowId, selectRows[0]);
			window.close();
		}
	}
}