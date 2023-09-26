// /����: �ɹ��ƻ���ִ�������ѯ
// /����: �ɹ��ƻ���ִ�������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gIncId='';
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var PurNo = new Ext.form.TextField({
				fieldLabel : '�ɹ�����',
				id : 'PurNo',
				name : 'PurNo',
				anchor : '90%',
				width : 120
			});

	// ��������
    var Vendor = new Ext.ux.VendorComboBox({
				fieldLabel : '������',
				id : 'Vendor',
				name : 'Vendor',
				anchor : '90%',
				emptyText : '��������...'
	});

	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '�ɹ�����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '�ɹ�����...',
				groupId:session['LOGON.GROUPID']
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

			
		var InciDesc = new Ext.form.TextField({
			fieldLabel : 'ҩƷ����',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = '';
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
		
				/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
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
			Ext.getCmp("InciDesc").setValue(record.get("InciDesc"));
		}
		
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : '��ѯ',
					tooltip : '�����ѯ',
					width : 70,
					height : 30,
					iconCls:'page_find',
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
			var VenId = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var PurNo =  Ext.getCmp("PurNo").getValue();
			if(Ext.getCmp("InciDesc").getValue()==""){
				gIncId="";
			}
			//����id^��ʼ����^��ֹ����^�ƻ�����^����id^��Ӧ��id^ҩƷid^��ɱ�־^��˱�־
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+PurNo+'^^'+VenId+'^'+gIncId+'^^^';
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam("strParam",ListParam);
			
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			MasterStore.removeAll();
			MasterStore.load({params:{start:0, limit:Page}});
		
			MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			});
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
			SetLogInDept(PhaLoc.getStore(),"PhaLoc")
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("PurNo").setValue("");
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		// ����·��
		var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=query';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
				
		var fields = ["RowId", "PurNo", "Loc", "Date", "User", "PoFlag","CmpFlag", "StkGrp", "AuditFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Rowid",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams:{strParam:""}
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
					header : "�ƻ�����",
					dataIndex : 'PurNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '�ɹ�����',
					dataIndex : 'Loc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "�ƻ�������",
					dataIndex : 'Date',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "�ɹ�Ա",
					dataIndex : 'User',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "�Ƿ������ɶ���",
					dataIndex : 'PoFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "��ɱ�־",
					dataIndex : 'CmpFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "������־",
					dataIndex : 'AuditFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'StkGrp',
					width : 100,
					align : 'left',
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
			DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PurId}});
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
		var fields = ["RowId", "IncId", "IncCode","IncDesc","Spec", "Manf", "Qty", "Uom","Rp",
				 "RpAmt", "Vendor", "Carrier","ReqLoc","RecQty","LeftQty"];
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
					header : "�ɹ���ϸ��RowId",
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
					width : 180,
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
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'Rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'RpAmt',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "��Ӧ��",
					dataIndex : 'Vendor',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'Manf',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'Carrier',
					width : 120,
					align : 'right',
					sortable : true
				}, {
					header : "�깺����",
					dataIndex : 'ReqLoc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "δ��������",
					dataIndex : 'LeftQty',
					width : 100,
					align : 'right',
					sortable : true
				}]);

		var DetailGrid = new Ext.grid.GridPanel({
					title : '',
					height : 200,
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true
				});

		var HisListTab = new Ext.form.FormPanel({
			labelWidth: 60,	
			labelAlign : 'right',
			autoHeight:true,
			frame : true,
			tbar : [SearchBT, '-', ClearBT],			
			items : [{
				xtype:'fieldset',
				title:'��ѯ����',
				style : DHCSTFormStyle.FrmPaddingV,
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults: {border:false},    // Default config options for child items
				items:[{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',
	            	items: [PhaLoc,Vendor]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            
	            	items: [StartDate,EndDate]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [PurNo]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [InciDesc]					
				}]
			}]			
		});

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                title:'�ɹ���ִ�������ѯ',
			                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'west',
			                width:document.body.clientWidth*0.3,
			                minSize: document.body.clientWidth*0.1,
                			maxSize: document.body.clientWidth*0.8,
                			collapsible: true,
                			split:true,
			                title: '�ɹ���',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'center',			               
			                title: '�ɹ�����ϸ',
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
})