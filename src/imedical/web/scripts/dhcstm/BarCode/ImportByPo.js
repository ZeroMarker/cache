// /����: ����
function ImportByPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var PoPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PoPhaLoc',
				name : 'PoPhaLoc',
				anchor : '90%',
				emptyText : '��������...',
				groupId:gGroupId,
				childCombo : 'PoVendor'
			});
	// ��ʼ����
	var StartDatex = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDatex',
				name : 'StartDatex',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// ��ֹ����
	var EndDatex = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDatex',
				name : 'EndDatex',
				anchor : '90%',
				width : 120,
				value : new Date()
			});
	var PoNotImp = new Ext.form.Checkbox({
				fieldLabel : 'δ���',
				id : 'PoNotImp',
				name : 'PoNotImp',
				anchor : '90%',
				checked : true
			});
	var PoPartlyImp = new Ext.form.Checkbox({
		fieldLabel : '�������',
		id : 'PoPartlyImp',
		name : 'PoPartlyImp',
		anchor : '90%',
		checked : true
	});
	// ��Ӧ��
	var PoVendor = new Ext.ux.VendorComboBox({
			id : 'PoVendor',
			name : 'PoVendor',
			anchor : '90%',
			params : {LocId : 'PoPhaLoc'}
	});
	// ��ⵥ��
	var PoNo = new Ext.form.TextField({
		fieldLabel : '������',
		id : 'PoNo',
		name : 'PoNo',
		anchor : '90%',
		listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					PoQuery();	
					}
				}
			}
	});
	
		
	// ��ѯ������ť
	var PoSearchBT = new Ext.Toolbar.Button({
				id : "PoSearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					PoQuery();
				}
			});


	// ��հ�ť
	var PoClearBT = new Ext.Toolbar.Button({
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
		SetLogInDept(Ext.getCmp("PoPhaLoc").getStore(),"PoPhaLoc");
		Ext.getCmp("PoVendor").setDisabled(0);
		Ext.getCmp("PoNotImp").setValue(true);
		Ext.getCmp("PoPartlyImp").setValue(true);
		
		PoMasterGrid.store.removeAll();
		PoDetailGrid.store.removeAll();
		PoDetailGrid.getView().refresh();
		
	}

	// ���水ť
	var PoSaveBT = new Ext.Toolbar.Button({
				id : "PoSaveBT",
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(PoDetailGrid.activeEditor != null){
						PoDetailGrid.activeEditor.completeEdit();
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
		var nowdate = new Date();
		var record = PoMasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", "û����Ҫ���������!");				
			return false;
		}
		var Status = record.get("PoStatus");				
		if (Status ==2) {
			Msg.info("warning", "�ö����Ѿ�ȫ�����룬�����ٵ���!");				
			return false;
		}			
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc == null || PoPhaLoc.length <= 0) {
			Msg.info("warning", "��ѡ����ⲿ��!");
			return false;
		}
		// 1.�ж���������Ƿ�Ϊ��
		var rowCount = PoDetailGrid.getStore().getCount();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = PoDetailStore.getAt(i).get("IncId");
			if (item != "") {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", "�����������ϸ!");
			return false;
		}
		
		var record = PoDetailGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", "��ѡ����ϸ!");				
			return false;
		}
		
		return true;
	}
	
	/**
	 * ������ⵥ
	 */
	function Posave() {
		var selectRecords = PoDetailGrid.getSelectionModel().getSelections();
		Fn(selectRecords)
		Powin.close()
		
	}
	// ��ʾ��������
	function PoQuery() {
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc =='' || PoPhaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
			return;
		}
		var startDate = Ext.getCmp("StartDatex").getValue();
		var endDate = Ext.getCmp("EndDatex").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var PoNotImp = (Ext.getCmp("PoNotImp").getValue()==true?0:'');
		var PoPartlyImp = (Ext.getCmp("PoPartlyImp").getValue()==true?1:'');
		var Status=PoNotImp+","+PoPartlyImp;
		var PoVendor = Ext.getCmp("PoVendor").getValue();
		var PoNo = Ext.getCmp("PoNo").getValue();
		
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+PoVendor+'^'+PoPhaLoc+'^Y^1^'+Status;
		var Page=PoGridPagingToolbar.pageSize;
		PoMasterStore.removeAll();
		PoDetailGrid.store.removeAll();
		PoMasterStore.setBaseParam("ParamStr",ListParam);
		PoMasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(r.length==0){
     				Msg.info("warning", "δ�ҵ����ϵĵ���!");
     			}else{
     				if(r.length>0){
	     				PoMasterGrid.getSelectionModel().selectFirstRow();
	     				PoMasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				PoMasterGrid.getView().focusRow(0);
     				}
     			}
     		}
		});

	}
	// ��ʾ��ⵥ��ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		PoDetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='δ���';			
		}else if(value==1){
			PoStatus='�������';
		}else if(value==2){
			PoStatus='ȫ�����';
		}
		return PoStatus;
	}
	// ����·��
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","ReqLocDesc","ReqLoc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// ���ݼ�
	var PoMasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'PoId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "������",
				dataIndex : 'PoNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "�깺����",
				dataIndex : 'ReqLocDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'PoLoc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 250,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'PoDate',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var PoGridPagingToolbar = new Ext.PagingToolbar({
		store:PoMasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var PoMasterGrid = new Ext.grid.GridPanel({
				region: 'center',
				title: '����',
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : PoMasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:PoGridPagingToolbar
			});

	// ��ӱ�񵥻����¼�
	PoMasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = PoMasterStore.getAt(rowIndex).get("PoId");
		PoDetailStore.load({params:{start:0,limit:999,Parref:PoId}});
	});
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryPoDetailForRec&Parref=&start=0&limit=999';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:"ExpDate",type:"date",dateFormat:ARG_DATEFORMAT}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo","CerExpDate","HighValueFlag"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// ���ݼ�
	var PoDetailStore = new Ext.data.Store({
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
	var PoDetailCm = new Ext.grid.ColumnModel([nm,sm2,{
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
			},{
				header : "ע��֤����",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "ע��֤Ч��",
				dataIndex : 'CerExpDate',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	
	var PoDetailGrid = new Ext.grid.EditorGridPanel({
                region: 'south',
                title: '������ϸ',
                height: gGridHeight,
				cm : PoDetailCm,
				store : PoDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm:sm2,
				clicksToEdit : 1
			});
	var PoHisListTab = new Ext.ux.FormPanel({
		labelWidth : 60,
		tbar : [PoSearchBT,'-',PoClearBT, '-',PoSaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'��ѯ����',
			style : 'padding:5px 0px 0px 5px;',
			defaults: {border:false},    // Default config options for child itemsPoNo
			items:[{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoNo]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoPhaLoc]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoVendor]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [StartDatex]
			},{ 				
				columnWidth: 0.2,
				xtype: 'fieldset',
	        	items: [EndDatex]
			}]
		}]
	});

	// ҳ�沼��
	var Powin = new Ext.ux.Window({
				title : '�����ӡ-���ݶ�������',
				layout : 'border',
				items : [PoHisListTab, PoMasterGrid, PoDetailGrid]
			});
	//ҳ�������ɺ��Զ���������
	Powin.show()
	PoNo.focus(true,100)
}