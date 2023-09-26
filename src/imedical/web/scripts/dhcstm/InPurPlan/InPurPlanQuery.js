// /����: �ɹ��ƻ���ִ�������ѯ
// /����: �ɹ��ƻ���ִ�������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.03

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];	
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
		params : {LocId : 'PhaLoc', ScgId : 'StkGrpType'}
	});

	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '�ɹ�����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '�ɹ�����...',
		groupId:session['LOGON.GROUPID'],
		stkGrpId : 'StkGrpType',
		childCombo : 'Vendor'
	});
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		value : new Date().add(Date.DAY, - 7)
	});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
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

	var StkGrpType = new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		anchor : '90%',
		StkType : App_StkTypeCode,
		LocId : gLocId,
		UserId : gUserId,
		childCombo : 'DHCStkCatGroup'
	});
		
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId : 'StkGrpType'}
	});
		
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
		var PurNo = Ext.getCmp("PurNo").getValue();
		var inciDesc = Ext.getCmp("InciDesc").getValue()
		if (inciDesc == "" || inciDesc == null){
			gIncId="";
		}
		if(gIncId!=""&gIncId!=null){
			inciDesc="";
		}
		var comp = 'Y';
		var AuditLevel=3;
		var Scg = Ext.getCmp('StkGrpType').getValue();
		var Incsc = Ext.getCmp('DHCStkCatGroup').getValue();
		//����id^��ʼ����^��ֹ����^�ƻ�����^����id^��Ӧ��id^����id^��ɱ�־^��˱�־^����֧�����^��˼���
		var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+PurNo+'^^'+VenId+'^'+gIncId+'^'+comp+'^^'
			+"^"+AuditLevel+"^"+inciDesc+'^'+gUserId+'^'+Scg+'^'+Incsc+'^'+gGroupId;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam("strParam",ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options,success){
				if(!success){
					Msg.info("error","��ѯ����,��鿴��־!");
				}else if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		});
	}
     // ��ӡ�ɹ���ť
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '��ӡ',
		tooltip : '�����ӡ�ɹ���',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
		var PlanRec = MasterGrid.getSelectionModel().getSelected();
		if(Ext.isEmpty(PlanRec)){
			Msg.info("warning", "ѡ����Ҫ��ӡ�ĵ���!");
			return;
		}
		var purId = PlanRec.get('RowId');
		PrintInPur(purId);
		}
	});
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

	function clearData() {
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("PurNo").setValue("");
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, -7));
		Ext.getCmp("EndDate").setValue(new Date());
		if(INPURPlanInfoPanel.rendered){
			document.getElementById("frameINPURPlanInfo").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
		if(LocInfoPanel.rendered){
			document.getElementById("frameLocInfo").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
		if(VenInfoPanel.rendered){
			document.getElementById("frameVenInfo").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
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
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "�Ƿ������ɶ���",
			dataIndex : 'PoFlag',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��ɱ�־",
			dataIndex : 'CmpFlag',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : "������־",
			dataIndex : 'AuditFlag',
			width : 60,
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
			dataIndex:'DHCPlanStatusDesc',
			width:80,
			align:'left',
			sortable:true
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
		title: '�ɹ���',
		region: 'west',
		width:300,
		collapsible: true,
		split:true,
		cm : MasterCm,
		sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[GridPagingToolbar]
	});

	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		DetailPanel.fireEvent('tabchange',DetailPanel,DetailPanel.getActiveTab());
	});

	// ����·��
	var DetailUrl =  DictUrl + 'inpurplanaction.csp?actiontype=queryItem';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	// ָ���в���
	var fields = ["RowId", "IncId", "IncCode","IncDesc","Spec", "Manf", "Qty", "Uom","Rp",
			 "RpAmt", "Vendor", "Carrier","ReqLoc","RecQty","LeftQty", "SpecDesc"];
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
			align : 'right',
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
			align : 'right',
			sortable : true
		}, {
			header : "�깺����",
			dataIndex : 'ReqLoc',
			width : 80,
			align : 'right',
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
		id : 'DetailGrid',
		title : '',
		height : 200,
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true
	});

	var HisListTab = new Ext.ux.FormPanel({
		title:'�ɹ���ִ�������ѯ',
		tbar : [SearchBT, '-', ClearBT, '-', PrintBT],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			style : 'padding:5px 0px 0px 5px;',
			layout: 'column',
			defaults: {columnWidth: 0.25,xtype: 'fieldset',border:false},
			items:[{
					items: [PhaLoc,Vendor]
				},{
					items: [StartDate,EndDate]
				},{
					items: [StkGrpType,DHCStkCatGroup]
				},{
					items: [PurNo,InciDesc]
			}]
		}]
	});

	var DetailGridPanel = new Ext.Panel({
		title : '�ɹ�����ϸ',
		id : 'DetailGridPanel',
		layout:'fit',
		items : DetailGrid
	});

	var INPURPlanInfoPanel = new Ext.Panel({
		title : '������ϸ',
		id : 'INPURPlanInfoPanel',
		layout:'fit',
		html:'<iframe id="frameINPURPlanInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});

	var LocInfoPanel = new Ext.Panel({
		title : '����������ϸ',
		id : 'LocInfoPanel',
		layout:'fit',
		html:'<iframe id="frameLocInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	var VenInfoPanel = new Ext.Panel({
		title : '��Ӧ����ϸ',
		id : 'VenInfoPanel',
		layout:'fit',
		html:'<iframe id="frameVenInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});

	var DetailPanel = new Ext.TabPanel({
		region: 'center',
		activeTab : 0,
		deferredRender : true,
		items : [DetailGridPanel,INPURPlanInfoPanel,LocInfoPanel,VenInfoPanel],
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
				}else if(panel.id == 'VenInfoPanel'){
					var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPURPLAN_ReqVenInfo.raq'
						+"&Parref=" + PurId;
					var reportFrame=document.getElementById("frameVenInfo");
					reportFrame.src=p_URL;
				}
			}
		}
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab,MasterGrid,DetailPanel],
		renderTo : 'mainPanel'
	});
})