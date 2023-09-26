// /����: �ɹ��ƻ�����
// /����: �ɹ��ƻ�����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.30
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// �ɹ�����
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '�ɹ�����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '�ɹ�����...',
				groupId:session['LOGON.GROUPID']
			});

var PurNo = new Ext.form.TextField({
			fieldLabel : '�ɹ�����',
			id : 'PurNo',
			name : 'PurNo',
			anchor : '90%',
			width : 120
		});

	// ��������
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '��Ӧ��',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			emptyText : '��Ӧ��...'
	});
		
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});

	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	/**
	 * ��ѯ����
	 */
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var purno = Ext.getCmp("PurNo").getValue();
		var CmpFlag = "Y";
		var PlanAuditFlag = (Ext.getCmp("PlanAuditFlag").getValue()==true?'Y':'N');
		//����id^��ʼ����^��ֹ����^�ƻ�����^����id^��Ӧ��id^ҩƷid^��ɱ�־^��˱�־
		var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+purno+'^^'+vendor+'^^'+CmpFlag+'^'+PlanAuditFlag;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('strParam',ListParam);
		MasterStore.removeAll();
		MasterStore.load({params:{start:0, limit:Page}});
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		   MasterStore.on('load',function(){
			if (MasterStore.getCount()>0){
		      MasterGrid.getSelectionModel().selectFirstRow();
		      MasterGrid.getView().focusRow(0);
	        }
				})
	}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������',
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("PurNo").setValue("");
		Ext.getCmp("PlanAuditFlag").setValue("");
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	// ����
	var PlanAuditFlag = new Ext.form.Checkbox({
		fieldLabel : '������',
		id : 'PlanAuditFlag',
		name : 'PlanAuditFlag',
		anchor : '90%',
		width : 120,
		checked : false
	});
	// ������ť
	var CheckBT = new Ext.Toolbar.Button({
				id : "CheckBT",
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					Audit();
				}
			});

	/**
	 * �����ɹ��ƻ���
	 */
	function Audit() {
		
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ��Ҫ�����Ĳɹ���!");
			return;
		}
		
		var PurId = rowData.get("RowId");
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=Audit&rowid="
				+ PurId + "&userId=" + userId;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", "�����ɹ�!");
							Query();
						} else {
							var Ret=jsonData.info;
							if(Ret==-10){
								Msg.info("warning","�ɹ�ҩƷ�д��ڹ�Ӧ��Ϊ�յļ�¼���������ɶ���!");
							}
							else if(Ret==-2){
								Msg.info("error", "���¼ƻ���������־ʧ��!");
							}else if(Ret==-3){
								Msg.info("error", "���涩��������Ϣʧ��!");
							}else if(Ret==-4){
								Msg.info("error", "���涩����ϸʧ��!");
							}else if(Ret==-5){
								Msg.info("error", "�ƻ����Ѿ�����!");
							}else{
								Msg.info("error", "����ʧ��:"+Ret);
							}
						}
					},
					scope : this
				});
	}
	
	function rendorPoFlag(value){
        return value=='Y'? '��': '��';
    }
    function rendorCmpFlag(value){
        return value=='Y'? '���': 'δ���';
    }
	

	// ����·��
	var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["RowId", "PurNo", "LocId", "Loc", "Date", "User","PoFlag", "CmpFlag","StkGrpId", "StkGrp"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "RowId",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "�ɹ��ƻ�����",
				dataIndex : 'PurNo',
				width : 200,
				align : 'center',
				sortable : true
			}, {
				header : "�ɹ�����",
				dataIndex : 'Loc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ�����",
				dataIndex : 'Date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'User',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "�Ƿ������ɶ���",
				dataIndex : 'PoFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorPoFlag
			}, {
				header : "��ɱ�־",
				dataIndex : 'CmpFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorCmpFlag
			}, {
				header : "����",
				dataIndex : 'StkGrp',
				width : 200,
				align : 'center',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var MasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PurId = MasterStore.getAt(rowIndex).get("RowId");
		DetailStore.removeAll();
		DetailStore.setBaseParam('sort','Rowid');
		DetailStore.setBaseParam('dir','Desc');
		DetailStore.setBaseParam('parref',PurId);
		DetailStore.load({params:{start:0,limit:20,sort:'Rowid',dir:'Desc',parref:PurId}});
	});

	// ת����ϸ
	// ����·��
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=queryItem';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["RowId", "IncId","IncCode","IncDesc", "Spec", "Manf", {name:"Qty",type:'double'},"UomId",
			 "Uom", "Rp", "Sp","RpAmt","SpAmt","Vendor", "Carrier", "Gene", "GoodName",
			"Form", "ReqLoc", "StkQty", "MaxQty","MinQty","HospitalQty","PackUomDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "RowId",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ҩƷId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'IncDesc',
				width : 220,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "�ɹ�����",
				dataIndex : 'Qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'Uom',
				width : 80,
				align : 'center',
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
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'Carrier',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����ͨ����",
				dataIndex : 'Gene',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��Ʒ��",
				dataIndex : 'GoodName',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Form',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'ReqLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'StkQty',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MaxQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MinQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "ȫԺ���",
				dataIndex : 'HospitalQty',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���װ��λ",
				dataIndex : 'PackUomDesc',
				width : 100,
				align : 'center',
				sortable : true
			}]);
	var DetailGridPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:20,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
});


	var DetailGrid = new Ext.grid.GridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				//======
				bbar:DetailGridPagingToolbar,
	            clicksToEdit:1
			});

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {width: 220, border:false},    // Default config options for child items
			style : DHCSTFormStyle.FrmPaddingV,
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',        	
	        	items: [PhaLoc,Vendor]				
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.33,
	        	xtype: 'fieldset',	      
	        	items: [PurNo,PlanAuditFlag]
				
			}]
		}]
		
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'�ɹ��ƻ�����',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '�ɹ���',			               
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'south',
		                split: true,
            			height: 250,
            			minSize: 200,
            			maxSize: 350,
            			collapsible: true,
		                title: '�ɹ�����ϸ',
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
			
	Query();


})