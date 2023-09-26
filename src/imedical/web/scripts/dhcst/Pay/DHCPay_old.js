
// /����: ����Ƶ�
// /��д�ߣ�gwj
// /��д����: 2012.09.20

var payRwoId="";
var URL="dhcst.dhcpayaction.CSP"
// /�Ƿ���Ҫ��������
var ApprovalFlag
var gParam

var payN0Field = new Ext.form.TextField({
	id:'payN0Field',
	fieldLabel:'�����',
	allowBlank:true,
	width:120,
	listWidth:120,
	emptyText:'�����...',
	anchor:'90%',
	selectOnFocus:true
});		

		// ��������ֵ����
	function refill(store, filter,type) {
		if(type=="PhaLoc"){
			store.reload({
				params : {
					start : 0,
					limit : 20,
					locDesc:filter
					}
				});
		}
		if(type=="Vendor"){
			store.reload({
				params : {
					start : 0,
					limit : 20,
					filter:filter
				}
			});
		}
	}
	// ������
	var PhaLoc = new Ext.form.ComboBox({
		fieldLabel : '������',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width : 120,
		store : GetGroupDeptStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		emptyText : '������...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		listeners : {
			'beforequery' : function(e) {
				refill(GetGroupDeptStore, Ext.getCmp('PhaLoc')
					.getRawValue(),"PhaLoc");
			}
		}
	});
	// ��¼����Ĭ��ֵ
	SetLogInDept(GetGroupDeptStore, "PhaLoc");
	//ȡ�Ƿ���Ҫ��������
	GetParam();
	
	function GetParam(){
		var ssacode="DHCSTPAY"
		var ssapcode="APPROVALFLAG"
		var pftype="D"
		var url='dhcst.dhcpayaction.CSP?actiontype=GetParam&SSACode='+ssacode+'&SSAPCode='+ssapcode+'&PFType='+pftype;
		Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var s=result.responseText;
							s=s.replace(/\r/g,"")
							s=s.replace(/\n/g,"")

							gParam=s.split('^');
							
						//scope : this
					}
					
					
		
		});

	//return;
	}
	
	// ��������
	var Vendor = new Ext.form.ComboBox({
				fieldLabel : '��������',
				id : 'Vendor',
				name : 'Vendor',
				anchor : '90%',
				width : 120,
				store : APCVendorStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				emptyText : '��������...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				valueNotFoundText : '',
				enableKeyEvents : true,
				listeners : {
					'beforequery' : function(e) {
						refill(APCVendorStore, Ext.getCmp('Vendor')
										.getRawValue(),"Vendor");
					}
				}
			});
			
		// ��ʼ����
		var StartDate = new Ext.form.DateField({
					fieldLabel : '��ʼ����',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 120,
					value : new Date().add(Date.DAY, - 30)
				});
		// ��ֹ����
		var EndDate = new Ext.form.DateField({
					fieldLabel : '��ֹ����',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					format : 'Y-m-d',
					width : 120,
					value : new Date()
				});
	var ack1lag = new Ext.form.Checkbox({
			fieldLabel : '�ɹ�ȷ��',
			id : 'ack1lag',
			name : 'ack1lag',
			anchor : '90%',
			//width : 80,
			checked : false
	});
	var ack2lag = new Ext.form.Checkbox({
			fieldLabel : '���ȷ��',
			id : 'ack2lag',
			name : 'ack2lag',
			anchor : '90%',
			//width : 80,
			checked : false
	});
	var PoisonFlag = new Ext.form.Checkbox({
			fieldLabel : '�����־',
			id : 'PoisonFlag',
			name : 'PoisonFlag',
			anchor : '90%',
			//width : 80,
			checked : false
	});
	var CreatUsr =new Ext.form.NumberField({
				fieldLabel : '�Ƶ���',
				id : 'CreatUsr',
				name : 'CreatUsr',
				anchor : '90%',
				width : 120
	});
	var CreatDate =new Ext.form.NumberField({
				fieldLabel : '�Ƶ�����',
				id : 'CreatDate',
				name : 'CreatDate',
				anchor : '90%',
				width : 120
	});
	var Ack1Usr =new Ext.form.NumberField({
				fieldLabel : '�ɹ�ȷ����',
				id : 'Ack1Usr',
				name : 'Ack1Usr',
				anchor : '90%',
				width : 120
	});
	var CreatTim =new Ext.form.NumberField({
				fieldLabel : '�Ƶ�ʱ��',
				id : 'CreatTim',
				name : 'CreatTim',
				anchor : '90%',
				width : 120
	});
	var Ack2Usr =new Ext.form.NumberField({
				fieldLabel : '���ȷ����',
				id : 'Ack2Usr',
				name : 'Ack2Usr',
				anchor : '90%',
				width : 120
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
	// ��ɰ�ť
		var CompleteBT = new Ext.Toolbar.Button({
					id : "CompleteBT",
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						Complete();
					}
				});

		// ȡ����ɰ�ť
		var CancleCompleteBT = new Ext.Toolbar.Button({
					id : "CancleCompleteBT",
					text : 'ȡ�����',
					tooltip : '���ȡ�����',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						CancleComplete();
					}
				});
	// ���ɸ����ť
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '���ɸ��',
					tooltip : '��������µ�',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						Save();
					}
				});

	// �������и����ť
	var UpdateBT = new Ext.Toolbar.Button({
				id : "UpdateBT",
				text : '�������и��',
				tooltip : '����������и��',
				width : 70,
				Height : 30,
				iconCls : 'page_gear',
				handler : function() {
					Update();
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
		
		var CmpFlag = "Y";
		ApprovalFlag=gparam[0];
		//����id^��Ӧ��id^��ʼ����^��ֹ����^��˱�־^��Ʊ��־
		var ListParam=phaLoc+'^'+vendor+'^'+startDate+'^'+endDate+'^'+ApprovalFlag+'^0';
		var Page=GridPagingToolbar.pageSize;
		MasterStore.load({params:{start:0, limit:Page,strParam:ListParam}});
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

  /**
		 * ��ɸ��
		 */
		function Complete() {
			
			var payNo = Ext.getCmp("payN0Field").getValue();			
			if (payNo == null || payNo.length <= 0) {
				Msg.info("warning", "û����Ҫ��ɵĸ��!");
				return;
			}
			if (payRwoId== null || payRwoId.length <= 0) {
				Msg.info("warning", "û����Ҫ��ɵĸ��!");
				return;
			}
			var url = URL+ "?actiontype=SetComp&payid="+ payRwoId ;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��ɵ���
								Msg.info("success", "�ɹ�!");								
										
			
							} else {
								var Ret=jsonData.info;
								if(Ret==-1){
									Msg.info("error", "����ʧ��,���IdΪ�ջ򸶿������!");
								}else if(Ret==-2){
									Msg.info("error", "����Ѿ����!");
								}else {
									Msg.info("error", "����ʧ��!");
								}
								
							}
						},
						scope : this
					});
		}

		/**
		 * ȡ�������ⵥ
		 */
		function CancleComplete() {
			
			var payNo = Ext.getCmp("payN0Field").getValue();			
			if (payNo == null || payNo.length <= 0) {
				Msg.info("warning", "û����Ҫ��ɵĸ��!");
				return;
			}
			if (payRwoId== null || payRwoId.length <= 0) {
				Msg.info("warning", "û����Ҫ��ɵĸ��!");
				return;
			}
			var url = URL+ "?actiontype=CnlComp&payid="+ payRwoId ;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��ɵ���
								Msg.info("success", "�ɹ�!");								
										
			
							} else {
								var Ret=jsonData.info;
								if(Ret==-1){
									Msg.info("error", "����ʧ��,���IdΪ�ջ򸶿������!");
								}else if(Ret==-2){
									Msg.info("error", "����Ѿ����!");
								}else {
									Msg.info("error", "����ʧ��!");
								}
								
							}
						},
						scope : this
					});
		}
	
	/*�����µĸ��*/
	function Save() {
			
			var payNo = Ext.getCmp("payN0Field").getValue();		
			var VenId = Ext.getCmp("Vendor").getValue();	
			var LocId = Ext.getCmp("PhaLoc").getValue();
			var CreateUser = gUserId;
			var PonFlag = (Ext.getCmp("PoisonFlag").getValue()==true?'Y':'N');
			var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PonFlag ;
			var url = URL+ "?actiontype=save&PayNo="+ payNo +"&MainInfo=" + MainInfo+"&ListDetail="+ListDetail;
			var ListDetail="";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				if(sm.isSelected(rowIndex)==true){
					var PayiId=rowData.get("PayiId");
					var IncDesc=rowData.get("IncDesc");
					var Ingri=rowData.get("Ingri");
					var IncId = rowData.get("IncId");
					var RpAmt = rowData.get("RpAmt");
					var DataType = rowData.get("Type");
					var str = PayiId + "^" + IncDesc + "^"	+ Ingri + "^" + IncId + "^" +RpAmt + "^^^^"+ DataType
					
					if(ListDetail==""){
						ListDetail=str;
					}
					else{
						ListDetail=ListDetail+","+str;
					}
				}
			}
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��ɵ���
								Msg.info("success", "�ɹ�!");								
								// ˢ�½���
								var payRwoId = jsonData.info;
								
								// ��ʾ�������
								
								Querypay(payRwoId);		
			
							} else {
								var Ret=jsonData.info;
								if(ret==-99){
									Msg.info("error", "����ʧ��,���ܱ���!");
								}else if(ret==-4){
									Msg.info("error", "���渶�������Ϣʧ��!");
								}else if(ret==-5){
									Msg.info("error", "���渶���ϸʧ��!");
								}else {
									Msg.info("error", "������ϸ���治�ɹ���"+ret);
								}
								
							}
						},
						scope : this
					});
		}
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_refresh',
					handler : function() {
						clearData();
					}
				});
		/**
		 * ��շ���
		 */
		function clearData() {
			Ext.getCmp("PhaLoc").setValue("");
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("payN0Field").setValue("");
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		
		
		function rendorPoFlag(value){
	        return value=='Y'? '��': '��';
	    }
	    function rendorCmpFlag(value){
	        return value=='Y'? '���': 'δ���';
	    }
		
	var sm = new Ext.grid.CheckboxSelectionModel(); 
		// ����·��
		var MasterUrl = URL	+ '?actiontype=query';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["RowId", "IngrNo", "RpAmt", "ApprvFlag", "CreateUser", "CreateDate","AuditUser", "AuditDate","PayedFlag", "type"];
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
		var MasterCm = new Ext.grid.ColumnModel([sm, {
					header : "RowId",
					dataIndex : 'RowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "����",
					dataIndex : 'IngrNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'RpAmt',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "������־",
					dataIndex : 'ApprvFlag',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "�Ƶ���",
					dataIndex : 'CreateUser',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "�Ƶ�����",
					dataIndex : 'CreateDate',
					width : 100,
					align : 'left',
					sortable : true,
					renderer:rendorPoFlag
				}, {
					header : "�����",
					dataIndex : 'AuditUser',
					width : 100,
					align : 'left',
					sortable : true,
					renderer:rendorCmpFlag
				}, {
					header : "�������",
					dataIndex : 'AuditDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�����־",
					dataIndex : 'PayedFlag',
					width : 100,
					align : 'left',
					sortable : true,
					renderer:rendorCmpFlag
				}, {
					header : "����",
					dataIndex : 'type',
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



		// ��ⵥ��ϸ
		var sm1 = new Ext.grid.CheckboxSelectionModel();
		// ����·��
		var DetailUrl =  DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryDetail';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"IncId", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc","Type","PayiId"];
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
		var DetailCm = new Ext.grid.ColumnModel([sm1, {
					header : "Ingri",
					dataIndex : 'Ingri',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true,
					hideable : false
				}, {
					header : "����",
					dataIndex : 'IncCode',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : '����',
					dataIndex : 'IncDesc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : 'IncId',
					dataIndex : 'IncId',
					width : 150,
					align : 'left',
					sortable : true,
					hideable : false
				}, {
					header : "��������",
					dataIndex : 'Manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'BatchNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "��Ч��",
					dataIndex : 'ExpDate',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : '��λ',
					dataIndex : 'IngrUom',
					width : 70,
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
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "�ۼ�",
					dataIndex : 'Sp',
					width : 80,
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
					width : 90,
					align : 'center',
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
					header : "�������",
					dataIndex : 'Margin',
					width : 80,
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
			labelwidth : 30,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px;',
			tbar : [SearchBT, '-', ClearBT, '-', CompleteBT,'-',CancleCompleteBT,'-',SaveBT,'-',UpdateBT],
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 220, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
               	//	"margin-bottom": "10px"
            	//},
            	items: [PhaLoc,payN0Field,ack1lag]
				
			},{ 				
				columnWidth: 0.2,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [Vendor,CreatUsr,Ack1Usr]
				
			},{ 				
				columnWidth: 0.2,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [StartDate,CreatDate,ack2lag]
				
			},{ 				
				columnWidth: 0.2,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [EndDate,CreatTim,Ack2Usr]
				
			},{ 				
				columnWidth: 0.15,
            	xtype: 'fieldset',
            	labelWidth: 60,	
            	defaults: {width: 140, border:false},    // Default config options for child items
            	defaultType: 'textfield',
            	autoHeight: true,
            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
            	border: false,
            	//style: {
                //	"margin-left": "10px", // when you add custom margin in IE 6...
                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
            	//},
            	items: [PoisonFlag]
				
			}]
			
		});

		
				
	
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var gUserId = session['LOGON.USERID'];	
	
	// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: 130, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: '��ⵥ',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '��ⵥ��ϸ',
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
});
//===========ģ����ҳ��=============================================