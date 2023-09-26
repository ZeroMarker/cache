// /����: ������ѯ
// /����: ������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.08
Ext.onReady(function() {
	
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	//��������
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : '��������...'
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
	
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : 'δ���',
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : '�������',
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : 'ȫ�����',
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	
	// ��Ӧ��
	var apcVendorField=new Ext.ux.VendorComboBox({
		id : 'apcVendorField',
		name : 'apcVendorField',
		anchor:'90%'
	});
		
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
	});


	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
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
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		Ext.getCmp("AllImp").setValue(true);
		
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var Status=notimp+','+partlyimp+','+allimp;
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+phaLoc+'^Y^Y^'+Status;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
				    
	    MasterStore.on('load',function(){
			if (MasterStore.getCount()>0){
				MasterGrid.getSelectionModel().selectFirstRow();
				MasterGrid.getView().focusRow(0);
			}
		})
	
		//DetailGrid.store.removeAll();
		//DetailGrid.getView().refresh();
	}
	// ��ʾ������ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
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
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","VendorTel"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
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
				dataIndex : 'PoId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "������",
				dataIndex : 'PoNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ�̵绰",
				dataIndex : 'VendorTel',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'PoStatus',
				width : 90,
				align : 'left',
				sortable : true,
				renderer:renderPoStatus
			}, {
				header : "��������",
				dataIndex : 'PoDate',
				width : 80,
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
				height : 360,
				region:'west',
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
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		var Size=DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('Parref',PoId);
		DetailStore.removeAll();
		DetailStore.load({params:{start:0,limit:Size}});
	});
		
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'inpoaction.csp?actiontype=QueryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	//PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
	});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "������ϸid",
		dataIndex : 'PoItmId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "ҩƷRowId",
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
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'PurUom',
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
		header : "��������",
		dataIndex : 'PurQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'ImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "δ��������",
		dataIndex : 'NotImpQty',
		width : 80,
		align : 'right',
		renderer:notimpqtyrender,
		sortable : true
	}]);
function notimpqtyrender(val){
		if(val<0){
			return 0;
		}else{
		return val;}
	}
	var DetailGrid = new Ext.grid.GridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '',
		height : 360,
		region:'center',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:[DetailPagingToolbar]
	});
				
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-',  ClearBT],
		autoHeight:true,
		layout: 'fit',    // Specifies that the items will now be arranged in columns
		items : [{
			xtype : 'fieldset',
			title : '��ѯ��Ϣ',
			layout : 'column',
			autoHeight:true,
			style : DHCSTFormStyle.FrmPaddingV,
			items : [{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	defaults: {width: 140, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	//autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	items: [PhaLoc,apcVendorField]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	defaults: {width: 140, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	//autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	//style: {
	            //	"margin-left": "10px", // when you add custom margin in IE 6...
	            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	        	//},
        		items: [StartDate,EndDate]
			},{ 				
				columnWidth: 0.1,
	        	xtype: 'fieldset',
	        	defaults: {width: 80, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	//autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	//style: {
	            //	"margin-left": "10px", // when you add custom margin in IE 6...
	            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	        	//},
	        	items: [NotImp,PartlyImp]
			},{ 				
				columnWidth: 0.15,
	        	xtype: 'fieldset',
	        	defaults: {width: 80, border:false},    // Default config options for child items
	        	defaultType: 'textfield',
	        	autoHeight: true,
	        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
	        	border: false,
	        	//style: {
	            //	"margin-left": "10px", // when you add custom margin in IE 6...
	            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
	        	//},
	        	items: [AllImp]
			}]
		}]
	});
	
	var poPanel = new Ext.Panel({
		title:'����',
		activeTab:0,
		height:410,
		collapsible:true,
        split:true,
		region:'west',
		width:550,
        minSize:0,
        maxSize:550,
		items:[MasterGrid]                                 
	});
				
	var poItemPanel = new Ext.Panel({
		title:'������ϸ',
		activeTab:0,
		height:410,
		deferredRender:true,
		region:'center',
		width:1125,
		items:[DetailGrid]                                 
	});

	// ҳ�沼��
	
	
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[{
			title:'�������������ѯ',
			region:'north',
			height:DHCSTFormStyle.FrmHeight(2),
			layout:'fit',
			items:HisListTab
		},{
			region:'west',
			title: '����',
		    collapsible: true,
		    split: true,
		    width: 450, // give east and west regions a width
		    minSize: 175,
		    maxSize: 450,
		    margins: '0 5 0 0',
		    layout: 'fit', // specify layout manager for items
			items:MasterGrid
		},{
			region: 'center',
		    title: '������ϸ',
		    layout: 'fit', // specify layout manager for items
			items:DetailGrid
		}],
		renderTo:'mainPanel'
	});

	
});