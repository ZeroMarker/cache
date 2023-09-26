// /����: ת�Ƴ������
// /����: ת�Ƴ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.24
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}	
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// ������
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '������',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					emptyText:'������',
					anchor:'90%',
					width : 120,
					defaultLoc:{}    //Ĭ��ֵΪ��
				});

		// ��������
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '��������',
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					groupId:gGroupId
				});

		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '��ʼ����',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : AuditStDate()
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
		var AuditFlag = new Ext.form.Checkbox({
					fieldLabel : '�������',
					id : 'AuditFlag',
					name : 'AuditFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false,
					handler:function(){
						var flag = Ext.getCmp("AuditFlag").getValue(); 
						if (flag == true) {
							CheckBT.setDisabled(true);
							AuditNoBT.setDisabled(true);
						} else {
							CheckBT.setDisabled(false);
							AuditNoBT.setDisabled(false);
						}
						Query();
					}
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
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "��ѡ��Ӧ����!");
				return;
			}
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var statue = "11,30";
			var statue=(Ext.getCmp("AuditFlag").getValue() == true ? '21': '11,30');
			var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^Y^'+statue+'^^';
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			
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
			SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("StartDate").setValue(AuditStDate());
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("AuditFlag").setValue(false);
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		// ������ť
		var CheckBT = new Ext.Toolbar.Button({
					id : "CheckBT",
					text : '���ͨ��',
					tooltip : '������ͨ��',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						Audit();
					}
				});

		/**
		 * ����ת�Ƶ�����
		 */
		function Audit() {
			// �ж�ת�Ƶ��Ƿ������
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "��ѡ����˵�ת�Ƶ�!");
				return;
			}
			var INITState = rowData.get("status");
			if (INITState != "11") {
				Msg.info("warning", "ת�Ƶ����Ǵ����״̬�����ʵ!");
				return;
			}
			var Init = rowData.get("init");
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Audit&Rowid="
					+ Init + "&User=" + userId;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��˵���
								Msg.info("success", "������˳ɹ�!");
								Query();
								//���ݲ�������, ��ӡ����
								if(gParam[4]=='Y'){
									PrintInIsTrf(Init,gParam[8]);
								}
							} else {
								var Ret=jsonData.info;
								if(Ret==-100){
									Msg.info("error", "���ⵥ���Ǵ����״̬!");
								}else if(Ret==-99){
									Msg.info("error", "����ʧ��!");
								}else if(Ret==-1){
									Msg.info("error", "���³��ⵥ״̬ʧ��!");
								}else if(Ret==-3){
									Msg.info("error", "������ʧ��!");
								}else if(Ret==-4){
									Msg.info("error", "����̨��ʧ��!");
								}else if(Ret==-5){
									Msg.info("error", "�����ӱ�״̬ʧ��!");
								}else if(Ret==-6){
									Msg.info("error", "����ռ������ʧ��!");
								}else if(Ret==-7){
									Msg.info("error", "�Զ����ճ��ⵥʧ�ܣ����ֶ�����!");
								}else{
									Msg.info("error", "���ʧ��:"+Ret);
								}
							}
						},
						scope : this
					});
		}

		// ������˾ܾ���ť
		var AuditNoBT = new Ext.Toolbar.Button({
					id : "AuditNoBT",
					text : '��˲�ͨ��',
					tooltip : '�����˲�ͨ��',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						AuditNo();
					}
				});
		/**
		 * ���ⵥ��˲�ͨ��
		*/
		function AuditNo() {
			// �ж�ת�Ƶ��Ƿ������
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "��ѡ��˲�ͨ����ת�Ƶ�!");
				return;
			}
			var INITState = rowData.get("status");
			if (INITState != "11" && INITState != "30") {
				Msg.info("warning", "ת�Ƶ����Ǵ����״̬�����ʵ!");
				return;
			}
			var Init = rowData.get("init");
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=AuditNo&Rowid="
					+ Init + "&User=" + userId;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��˵���
								Msg.info("success", "�ɹ�!");
								Query();
							} else {
								var Ret=jsonData.info;
								if(Ret==-100){
									Msg.info("error", "���ⵥ���Ǵ����״̬!");
								}else if(Ret==-99){
									Msg.info("error", "����ʧ��!");
								}else if(Ret==-1){
									Msg.info("error", "���³��ⵥ״̬ʧ��!");
								}else if(Ret==-2){
									Msg.info("error", "���³��ⵥ��ϸ״̬ʧ��!");
								}else if(Ret==-3){
									Msg.info("error", "���³��ⵥ���״̬ʧ��!");
								}else{
									Msg.info("error", "ʧ��:"+Ret);
								}
							}
						},
						scope : this
					});
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
						PrintInIsTrf(init,gParam[8]);
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
					reader : reader
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
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'frLocDesc',
					width : 150,
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
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : "�ۼ۽��",
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : "�������",
					dataIndex : 'MarginAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
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
					bbar:GridPagingToolbar
				});

		// ��ӱ�񵥻����¼�
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			DetailStore.setBaseParam('Parref',InIt);
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc',Parref:InIt}});
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
				"pp", "spec", "gene", "formDesc","newSp",
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
					header : "ҩƷId",
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : 'ҩƷ����',
					dataIndex : 'inciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : 'ҩƷ����',
					dataIndex : 'inciDesc',
					width : 220,
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
					width : 180,
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
					header : "����ͨ����",
					dataIndex : 'gene',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'formDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�ۼ۽��",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : "���۽��",
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}]);
       var GridDetailPagingToolbar = new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
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
					bbar:GridDetailPagingToolbar,
					loadMask : true
				});

		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			labelAlign : 'right',
			title:"ת�Ƴ������",
			frame : true,
			autoHeight:true,
			//bodyStyle : 'padding:5px;',
			tbar : [SearchBT, '-', ClearBT, '-', CheckBT,'-',AuditNoBT,'-',PrintBT],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����',
				style:DHCSTFormStyle.FrmPaddingV,
				layout: 'column',    // Specifies that the items will now be arranged in columns
				items : [{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',
	            	labelWidth: 60,	
	            	defaults: {width: 220},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
	               	//	"margin-bottom": "10px"
	            	//},
	            	items: [SupplyPhaLoc]
					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',
	            	labelWidth: 60,	
	            	defaults: {width: 140},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [RequestPhaLoc]
					
				},{ 				
					columnWidth: 0.2,
	            	xtype: 'fieldset',
	            	labelWidth: 60,	
	            	defaults: {width: 140},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [StartDate]
					
				},{ 				
					columnWidth: 0.2,
	            	xtype: 'fieldset',
	            	labelWidth: 60,	
	            	defaults: {width: 140},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [EndDate]					
				},{ 				
					columnWidth: 0.1,
	            	xtype: 'fieldset',
	            	labelWidth: 60,	
	            	defaults: {width: 160},    // Default config options for child items
	            	defaultType: 'textfield',
	            	autoHeight: true,
	            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	            	border: false,
	            	//style: {
	                //	"margin-left": "10px", // when you add custom margin in IE 6...
	                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	            	//},
	            	items: [AuditFlag]					
				}]
				
			}]			
		});

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: '���ⵥ',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '���ⵥ��ϸ',
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
		// ��¼����Ĭ��ֵ
		SetLogInDept(PhaDeptStore, "SupplyPhaLoc");		
		Query();
	}

})