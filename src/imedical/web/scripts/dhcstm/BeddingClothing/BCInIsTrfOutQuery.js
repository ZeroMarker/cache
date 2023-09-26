// /����: ���ⵥ��ѯ
// /����: ���ⵥ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.24

//�������ֵ��object
var BCInIsTrfOutParamObj = GetAppPropValue('DHCSTBCM');

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	ChartInfoAddFun();
	// ��¼����Ĭ��ֵ
	SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
	
	function ChartInfoAddFun() {
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
	
		// ��������
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '��������',
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '��������...',
					groupId:gGroupId
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

		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', 'δ���'], ['11', '�����'],
					['20', '������˲�ͨ��'],['21', '�������ͨ��'],['30', '�ܾ�����'],['31', '�ѽ���']]
		});
		
		var Status = new Ext.form.ComboBox({
			fieldLabel : 'ת�Ƶ�״̬',
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 100,
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
		// ��������
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
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
			var inciDr = record.get("InciDr");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(InciDesc);
			gInciRowId=inciDr;
		}
		
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
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "��ѡ��Ӧ����!");
				return;
			}
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();		
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
			if(startDate!=""){
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			if(endDate!=""){
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var statue =  Ext.getCmp("Status").getValue();
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var inci=gInciRowId;
			if(Ext.getCmp("InciDesc").getValue()==""){
				inci="";
			}
			var UserScgPar = supplyphaLoc + '%' + userId;
			var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'
				+'^'+statue+'^^^'+stkgrpid+"^"+inci
				+'^^^^'+UserScgPar;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			DetailGrid.store.removeAll();
			MasterStore.removeAll();
			MasterStore.load({
				params:{start:0, limit:Page},
				callback:function(r,options,success){
					if(!success){
						Msg.info("error","��ѯ����, ��鿴��־!");
					}
				}
			});
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
		/**
		 * ��շ���
		 */
		function clearData() {
			SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			//Ext.getCmp("SupplyPhaLoc").setValue("");
			Ext.getCmp("Status").setValue("");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
			Ext.getCmp("EndDate").setValue(new Date());
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}
		
		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
					text : '��ӡ',
					tooltip : '�����ӡ',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", "��ѡ����Ҫ��ӡ��ת�Ƶ�!");
							return;
						}
						var init = rowData.get("init");
						PrintInIsTrf(init);
					}
				});
		
		// ����·��
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "init",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					listeners : {
						load : function(store,records,options){
							if (records.length > 0){
								MasterGrid.getSelectionModel().selectFirstRow();
							}
						}
					}
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "RowId",
					dataIndex : 'init',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "ת�Ƶ���",
					dataIndex : 'initNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '���󵥺�',
					dataIndex : 'reqNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'toLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'frLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "ת������",
					dataIndex : 'dd',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "����״̬",
					dataIndex : 'StatusCode',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "�Ƶ���",
					dataIndex : 'userName',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "�ۼ۽��",
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'MarginAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "��ע",
					dataIndex : 'Remark',
					width : 100,
					align : 'left',
					sortable : true
				}]);
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}��, һ�� {2} ��',
			emptyMsg:"û�м�¼"
		});
		var MasterGrid = new Ext.grid.GridPanel({
			region: 'center',
			title: '���ⵥ',
			cm : MasterCm,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			store : MasterStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar:GridPagingToolbar
		});

		// ��ӱ�񵥻����¼�
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			DetailStore.setBaseParam('Parref',InIt)
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		});

		// ת����ϸ
		// ����·��
		var DetailUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec", "newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
					fields : fields
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "ת��ϸ��RowId",
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "����Id",
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '���ʴ���',
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '��������',
					dataIndex : 'inciDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "����Id",
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "����/Ч��",
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "���ο��",
					dataIndex : 'inclbQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "ת������",
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "ת�Ƶ�λ",
					dataIndex : 'TrUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "�ۼ�",
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "��λ��",
					dataIndex : 'stkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "���󷽿��",
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "ռ������",
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "�����ۼ�",
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "���",
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�ۼ۽��",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}]);
       var GridDetailPagingToolbar = new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}��, һ�� {2} ��',
			emptyMsg:"û�м�¼"
		});
		var DetailGrid = new Ext.grid.GridPanel({
			region: 'south',
			split: true,
			height: gGridHeight,
			collapsible: true,
			title: '���ⵥ��ϸ',
			cm : DetailCm,
			store : DetailStore,
			trackMouseOver : true,
			stripeRows : true,
			bbar:GridDetailPagingToolbar,
			loadMask : true
		});

		var HisListTab = new Ext.ux.FormPanel({
			title:"���ⵥ��ѯ",
			tbar : [SearchBT, '-', ClearBT, '-', PrintBT],
			items:[{
				xtype : 'fieldset',
				title : '��ѯ����',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults:{border:false,xtype:'fieldset'},
				items : [{ 				
					columnWidth: 0.3,
	            	items: [SupplyPhaLoc,Status]
				},{ 				
					columnWidth: 0.23,
	            	items: [RequestPhaLoc,StkGrpType]
				},{ 				
					columnWidth: 0.23,
	            	items: [StartDate,InciDesc]
				},{ 				
					columnWidth: 0.23,
	            	items: [EndDate]
				}]
			}]
		});

		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,MasterGrid,DetailGrid],
			renderTo : 'mainPanel'
		});
	}

})