// /����: �ɹ��ƻ���ִ�������ѯ
// /����: �ɹ��ƻ���ִ�������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
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

	// ��Ӧ��
	var Vendor = new Ext.ux.VendorComboBox({
				fieldLabel : '��Ӧ��',
				id : 'Vendor',
				name : 'Vendor',
				anchor : '90%',
				emptyText : '��Ӧ��...',
				params : {LocId : 'PhaLoc'}
	});
// ��������
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '�ɹ�����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '�ɹ�����...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});
	// ������
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '������',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '������...',
					defaultLoc:{}
		});
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '��ʼ����',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					
					width : 120,
					value : new Date().add(Date.DAY, - 7)
				});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '��ֹ����',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					
					width : 120,
					value : new Date()
				});

			
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
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
		 * �������ʴ��岢���ؽ��
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
			var reqloc=Ext.getCmp("RequestPhaLoc").getValue();
			var VenId = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getValue();
			if(Ext.isEmpty(startDate)){
				Msg.info('warning', '��ʼ���ڲ���Ϊ��');
				return false;
			}
			startDate = startDate.format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp("EndDate").getValue();
			if(Ext.isEmpty(endDate)){
				Msg.info('warning', '��ֹ���ڲ���Ϊ��');
				return false;
			}
			endDate = endDate.format(ARG_DATEFORMAT);
			var PurNo =  Ext.getCmp("PurNo").getValue();
			if(Ext.getCmp("InciDesc").getValue()==""){
				gIncId="";
			}
			var StkGrp=Ext.getCmp("StkGrpType").getValue();
			var AuditLevel=2;
			//����id^��ʼ����^��ֹ����^�ƻ�����^����id^��Ӧ��id^����id^��ɱ�־^��˱�־^����֧�����^��˼���
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+PurNo+'^'+StkGrp+'^'+VenId+'^'+gIncId+'^^^'+"^"+AuditLevel+"^"+reqloc;
			var Page=GridPagingToolbar.pageSize;
			//MasterStore.setBaseParam("strParam",ListParam);
			DetailStore.setBaseParam("strParam",ListParam);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			MasterStore.removeAll();
			DetailStore.load({params:{start:0, limit:99999}})
//			MasterStore.load({
//				params:{start:0, limit:Page},
//				callback:function(r,options,success){
//					if(!success){
//						Msg.info("error","��ѯ����,��鿴��־!");
//					}else if(r.length>0){
//						MasterGrid.getSelectionModel().selectFirstRow();
//						MasterGrid.getView().focusRow(0);
//					}
//				}
//			});
		}

		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
				
		var DHCPlanStatusStore = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
		});
		// ���״̬
		var DHCPlanStatus=new Ext.form.ComboBox({ 
			fieldLabel:'<font color=blue>���״̬</font>',
			id : 'DHCPlanStatus',
			name : 'DHCPlanStatus',
			StkType:App_StkTypeCode,     //��ʶ��������
			store : DHCPlanStatusStore,
	        valueField : 'RowId',
	        displayField : 'Description',
	        allowBlank : true,
	        triggerAction : 'all',
	        selectOnFocus : true,
	        forceSelection : true,
	        minChars : 1,
	        pageSize : 999,
	        listWidth : 250,
	        valueNotFoundText : '',
			emptyText : '���״̬...',
			anchor : '90%'
		});
		
		
	DHCPlanStatus.on('beforequery', function(e){
		this.store.removeAll();
		this.store.proxy=new Ext.data.HttpProxy({url : 'dhcstm.orgutil.csp?actiontype=GetPlanStatus',method:'POST'});
	    this.store.load({params:{start:0,limit:999}});
		});			
		/**
		 * ��շ���
		 */
		function clearData() {
			//Ext.getCmp("PhaLoc").setValue("");
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("PurNo").setValue("");
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, -7));
			Ext.getCmp("EndDate").setValue(new Date());
			MasterGrid.store.removeAll();
			//MasterGrid.getView().refresh();
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
				
		var fields = ["RowId", "PurNo", "Loc", "Date", "User", "PoFlag","CmpFlag", "StkGrp", "AuditFlag", "DHCPlanStatus", "DHCPlanStatusDesc"];
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
				},{
	            header:"���״̬",
                dataIndex:'DHCPlanStatus',
                width:250,
                align:'left',
                sortable:true,
               // editor : new Ext.grid.GridEditor(conditionNameField),
                renderer :Ext.util.Format.comboRenderer2(DHCPlanStatus,"DHCPlanStatus","DHCPlanStatusDesc")
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
            DetailPanel.fireEvent('tabchange',DetailPanel,DetailPanel.getActiveTab());
//			var PurId = MasterStore.getAt(rowIndex).get("RowId");
//			DetailStore.removeAll();
//			DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PurId}});
		});

		// ת����ϸ
		// ����·��
		var DetailUrl =  DictUrl
					+ 'inpurplanaction.csp?actiontype=queryAll';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["PurNo", "Loc", "Date", "User", "PoFlag","CmpFlag", "StkGrp", "AuditFlag", "DHCPlanStatus", "DHCPlanStatusDesc","RowId", "IncId", "IncCode","IncDesc","Spec", "Manf", "Qty", "Uom","Rp",
				 "RpAmt", "Vendor", "Carrier","ReqLoc","RecQty","LeftQty","SpecDesc"];
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
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "�Ƿ������ɶ���",
					dataIndex : 'PoFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "��ɱ�־",
					dataIndex : 'CmpFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "������־",
					dataIndex : 'AuditFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "�ɹ���ϸ��RowId",
					dataIndex : 'RowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "����Id",
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
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "���",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'SpecDesc',
					width : 100,
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
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'Manf',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'Carrier',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�깺����",
					dataIndex : 'ReqLoc',
					width : 80,
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

		var DetailGrid = new Ext.ux.GridPanel({
					title : '',
					id:'DetailGrid',
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
			frame : true,
			tbar : [SearchBT, '-', ClearBT],			
			items : [{
				xtype:'fieldset',
				title:'��ѯ����',
				style : 'padding:5px 0px 0px 5px;',
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
	            	items: [PurNo,RequestPhaLoc]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [InciDesc,StkGrpType]					
				}]
			}]			
		});


		var DetailGridPanel = new Ext.Panel({
			title : '�ɹ�����ϸ',
			id : 'DetailGridPanel',
			autoScroll:true,
			layout:'fit',
			items : DetailGrid
		});
		
		var INPURPlanInfoPanel = new Ext.Panel({
		    title : '������ϸ',
			id : 'INPURPlanInfoPanel',
			autoScroll:true,
			layout:'fit',
			html:'<iframe id="frameINPURPlanInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		});
	
		var LocInfoPanel = new Ext.Panel({
			title : '����������ϸ',
			id : 'LocInfoPanel',
			autoScroll:true,
			layout:'fit',
			html:'<iframe id="frameLocInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		});
	
		var DetailPanel = new Ext.TabPanel({
			activeTab : 0,
			deferredRender : true,
			items : [DetailGridPanel],
			listeners : {
				tabchange : function(tabpanel,panel){
					var PlanRec = MasterGrid.getSelectionModel().getSelected();
					if(Ext.isEmpty(PlanRec)){
						return;
					}
					var PurId = PlanRec.get('RowId');
					if(panel.id == 'DetailGridPanel'){
						DetailStore.removeAll();
			            DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PurId}});
					}else if(panel.id == 'INPURPlanInfoPanel'){
						var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPURPLAN_ReqInfo.raq'
							+"&Parref=" + PurId;
						var reportFrame=document.getElementById("frameINPURPlanInfo");
						reportFrame.src=p_URL;
					}else if(panel.id == 'LocInfoPanel'){
						var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPURPLAN_ReqLocInfo.raq'
							+"&Parref=" + PurId;
						var reportFrame=document.getElementById("frameLocInfo");
						reportFrame.src=p_URL;
					}
				}
			}
		});


		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                title:'�ɹ���ִ�������ѯ',
			                height: 170, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }
//			            , {
//			                region: 'west',
//			                width:300,
//			                minSize: 200,
//                			maxSize: 350,
//                			collapsible: true,
//                			split:true,
//			                title: '�ɹ���',			               
//			                layout: 'fit', // specify layout manager for items
//			                items: MasterGrid
//			            }
			            , {
			                region: 'center',
			                layout: 'fit', // specify layout manager for items
			                items: DetailPanel
			            }
	       			],
					renderTo : 'mainPanel'
				});
})