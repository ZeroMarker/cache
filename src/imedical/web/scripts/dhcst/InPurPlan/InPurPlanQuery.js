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
				fieldLabel : $g('�ɹ�����'),
				id : 'PurNo',
				name : 'PurNo',
				anchor : '90%',
				width : 120
			});

	// ����������ҵ
    var Vendor = new Ext.ux.VendorComboBox({
				fieldLabel : $g('��Ӫ��ҵ'),
				id : 'Vendor',
				name : 'Vendor',
				anchor : '90%',
				emptyText : $g('��Ӫ��ҵ...')
	});

	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('�ɹ�����'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : $g('�ɹ�����...'),
				groupId:session['LOGON.GROUPID']
			});
	
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('��ʼ����'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : DefaultStDate()
				});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('��ֹ����'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : DefaultEdDate()
				});

			
		var InciDesc = new Ext.form.TextField({
			fieldLabel : $g('ҩƷ����'),
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
					text : $g('��ѯ'),
					tooltip : $g('�����ѯ'),
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
				Msg.info("warning", $g("��ѡ��ɹ�����!"));
				return;
			}
			var VenId = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var PurNo =  Ext.getCmp("PurNo").getValue();
			if(Ext.getCmp("InciDesc").getValue()==""){
				gIncId="";
			}
			//����id^��ʼ����^��ֹ����^�ƻ�����^����id^��Ӫ��ҵid^ҩƷid^��ɱ�־^��˱�־
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
					text : $g('����'),
					tooltip : $g('�������'),
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
			GridPagingToolbar.updateInfo();
			
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
					header : $g("�ƻ�����"),
					dataIndex : 'PurNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g('�ɹ�����'),
					dataIndex : 'Loc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("�ƻ�������"),
					dataIndex : 'Date',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : $g("�ɹ�Ա"),
					dataIndex : 'User',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("�Ƿ������ɶ���"),
					dataIndex : 'PoFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("��ɱ�־"),
					dataIndex : 'CmpFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("������־"),
					dataIndex : 'AuditFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
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
			displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
			emptyMsg:$g("û�м�¼")
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
					header : $g("�ɹ���ϸ��RowId"),
					dataIndex : 'RowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("ҩƷId"),
					dataIndex : 'IncId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('ҩƷ����'),
					dataIndex : 'IncCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('ҩƷ����'),
					dataIndex : 'IncDesc',
					width : 220,
					align : 'left',
					sortable : true
				}, {
					header : $g("���"),
					dataIndex : 'Spec',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("�ɹ�����"),
					dataIndex : 'Qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("��λ"),
					dataIndex : 'Uom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'Rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("���۽��"),
					dataIndex : 'RpAmt',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("��Ӫ��ҵ"),
					dataIndex : 'Vendor',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("������ҵ"),
					dataIndex : 'Manf',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("������ҵ"),
					dataIndex : 'Carrier',
					width : 120,
					align : 'right',
					sortable : true
				}, {
					header : $g("�깺����"),
					dataIndex : 'ReqLoc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("�������"),
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("δ��������"),
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
				title:$g('��ѯ����'),
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
			                title:$g('�ɹ���ִ�������ѯ'),
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
			                title: $g('�ɹ���'),			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'center',			               
			                title: $g('�ɹ�����ϸ'),
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
})