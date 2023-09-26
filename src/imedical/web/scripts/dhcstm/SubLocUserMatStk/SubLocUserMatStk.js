// /����: ������Ա���ʲ�ѯ
// /����: ������Ա���ʲ�ѯ
// /��д�ߣ�zhwh
// /��д����: 2012.08.09
var matStatUrl="dhcstm.sublocmatstataction.csp" 

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor:'90%',
		groupId:gGroupId,
		stkGrpId : "StkGrpType",
		childCombo:["UserGrp","receiveUser"]
	});
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});

	// ��������
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��������',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});	
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:userId,
		anchor:'90%',
		params:{locId:'PhaLoc'},
		childCombo:["DHCStkCatGroup"]
	});
	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		anchor : '90%',
		width : 120,
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});

	var InciDr = new Ext.form.TextField({
		fieldLabel : '����RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		width : 140,
		valueNotFoundText : ''
	});

	var ItmDesc = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'ItmDesc',
		name : 'ItmDesc',
		anchor : '90%',
		width : 160,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var StkGrp= Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(),StkGrp);
					//GetPhaOrderInfo(field.getValue(),'');
				}
			}
		}
	});

	var ToLoc = new Ext.ux.ComboBox({
		id:'ToLoc',
		fieldLabel:'���տ���',
		emptyText:'���տ���...',
		triggerAction : 'all',
		store : LeadLocStore,
		valueParams : {groupId : gGroupId},
		filterName : '',
		childCombo : ['receiveUser', 'UserGrp']
	});
//	SetLogInDept(ToLoc.getStore(),'ToLoc');
	
	var GrpList = new Ext.ux.ComboBox({
		fieldLabel:'רҵ��',	
		id:'UserGrp',
		anchor : '90%',
		store:UserGroupStore,
		valueField:'RowId',
		displayField:'Description',
		params : {SubLoc : 'ToLoc'}
	});
	
	var UserList = new Ext.ux.ComboBox({
		fieldLabel:'������',	
		id:'receiveUser',
		anchor : '90%',
		store:UStore,
		valueField:'RowId',
		displayField:'Description',
		filterName:'name',
		params : {locId : 'ToLoc'}
	});

	/**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "", "", "",
					getDrugList);
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
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		
		Ext.getCmp("ItmDesc").setValue(inciDesc);
		Ext.getCmp('InciDr').setValue(inciDr);
	}

	
	// ��ѯ��ť
	var searchBT = new Ext.Toolbar.Button({
		text : '��ѯ',
		tooltip : '�����ѯ���ʷ���(�˻�)���',
		iconCls : 'page_find',
		height:30,
		width:70,
		handler : function() {
			searchUserMatDisp();
		}
	});

	function searchUserMatDisp() {
		
		var StartDate = Ext.getCmp("StartDate").getValue();
		if(StartDate==null||StartDate.length <= 0) {
			Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
			return;
		}else{
			StartDate=StartDate.format(ARG_DATEFORMAT).toString();
		}
		var EndDate = Ext.getCmp("EndDate").getValue();
		if(EndDate==null||EndDate.length <= 0) {
			Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
			return;
		}else{
			EndDate=EndDate.format(ARG_DATEFORMAT).toString();
		}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		if(PhaLoc==null||PhaLoc.length <= 0) {
			Msg.info("warning", "���Ҳ���Ϊ�գ�");
			return;
		}
		
		var StkGrp= Ext.getCmp("StkGrpType").getValue();
		var StkCat= Ext.getCmp("DHCStkCatGroup").getValue();
		var ItmDesc=Ext.getCmp("ItmDesc").getValue();
		var ItmRowid="";
		if(ItmDesc!="" & ItmDesc.length>0){
			ItmRowid= Ext.getCmp("InciDr").getValue();
		}
		var User =Ext.getCmp('receiveUser').getValue();
		var LUG=Ext.getCmp('UserGrp').getValue();
		var IncludeRet = 1;
		var ToLoc = Ext.getCmp('ToLoc').getValue();
		var strPar=StartDate+"^"+EndDate+"^"+PhaLoc+"^"+LUG+"^"+User+"^"+StkGrp+"^"+ItmRowid+"^"+IncludeRet+"^"+ToLoc;
		
		UserMatStatInfoStore.setBaseParam('strPar',strPar);
		
		var size=StatuTabPagingToolbar2.pageSize;
		UserMatStatInfoStore.removeAll();
		UserMatStatInfoGrid.store.removeAll();
		UserMatStatInfoStore.load({
			params:{start:0,limit:size},
			callback : function(r,options, success){
				if(success==false){
					Msg.info("error", "��ѯ������鿴��־!");
				}
			}
		});
	}
	
	// ��հ�ť
	var clearBT = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '������',
		iconCls : 'page_clearscreen',
		height:30,
		width:70,
		handler : function() {
			clearData();
		}
	});

	function clearData() {
		SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	//	SetLogInDept(ToLoc.getStore(),'ToLoc');
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").setValue('');
		StkGrpType.store.load();
		Ext.getCmp("DHCStkCatGroup").setValue('');
		//Ext.getCmp("QueryFlag").setValue('');
		Ext.getCmp("ItmDesc").setValue('');
		Ext.getCmp("UserGrp").setValue('');
		Ext.getCmp("receiveUser").setValue('');
		Ext.getCmp("InciDr").setValue('');
		//MasterInfoGrid.store.removeAll();
		UserMatStatInfoGrid.store.removeAll();
		UserMatStatInfoGrid.store.baseParams="";
		UserMatStatInfoGrid.getBottomToolbar().updateInfo();
	}

	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '�رս���',
		iconCls : 'close',
		handler : function() {
			window.close();
		}
	});

	// ����·��
	var UserMatStatInfoUrl = matStatUrl+'?actiontype=LocUserMatStat&start=0&limit=20';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : UserMatStatInfoUrl,
		method : "POST"
	});
	
	// ָ���в���
	//ҵ������^����^��λ^�ۼ�^����^��������(������λ)^��������(����λ)^��������(������λ)
	//^��������(����λ)^�������(����)^�������(�ۼ�)^�����^������^ժҪ
	//^��ĩ���(����)^��ĩ���(�ۼ�)^��Ӧ��^����^������	
	var fields = ['trType','inciCode','inciDesc','Abbrev','spec','batInfo','manf','qty','uomDesc','receiver','rp','rpAmt','indsNo','dispDate','dispTime','dsrqNo','dsrqDate'];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "TrId",
		fields : fields
	});
	
	var UserMatStatInfoStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var nm = new Ext.grid.RowNumberer();
	var UserMatStatInfoCm = new Ext.grid.ColumnModel([nm, 
	{
		header:'����',
		dataIndex:'trType',
		width:50,
		renderer:function(v){
			if(v=="C"){
				return "����";
			}else if(v=="L"){
				return "�˻�";
			}else{
				return v;
			}
		}
	},{
		header : "����(�˻�)����",
		dataIndex : 'dispDate',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header:'������(רҵ��)',
		dataIndex:'receiver',
		width:100
	},{
		header : "���ʴ���",
		dataIndex : 'inciCode',
		width : 60,
		align : 'left',	
		hidden:true,
		sortable : true
	},{
		header : "��������",
		dataIndex : 'inciDesc',
		width : 160,
		align : 'left',	
		sortable : true
	},{
		header:"���",
		dataIndex:'Abbrev',
		width:100,
		align:'left',
		sortable:true
	},{
		header : "���",
		dataIndex : 'spec',
		width : 60,
		align : 'left',	
		sortable : true
	},  {
		header : '����~Ч��',
		dataIndex : 'batInfo',
		width : 150,
		align : 'left',
		sortable : true
	},  {
		header : "����",
		dataIndex : 'manf',
		width : 160,
		align : 'left',				
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'uomDesc',
		width : 60,
		align : 'left',
		sortable : true
	}, {
		header : "����(�˻�)����",
		dataIndex : 'qty',
		width : 100,
		align : 'right',	
		sortable : true
	},  {
		header : "����",
		dataIndex : 'rp',
		width : 80,
		align : 'right'
	}, {
		header : "���۽��",
		dataIndex : 'rpAmt',
		width : 120,
		align : 'right',
		sortable : true
	},/* {
		header : "�ۼ�",
		dataIndex : 'Sp',
		width : 80,
		align : 'right',
		sortable : true
	},{
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		width : 120,
		align : 'right',	
		sortable : true
	}, */{
		header : "����(�˻�)����",
		dataIndex : 'indsNo',
		width : 160,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'dsrqDate',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header:'���쵥��',
		dataIndex:'dsrqNo',
		width:160
	}]);
	UserMatStatInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
		store : UserMatStatInfoStore,
		pageSize : 20,
		displayInfo : true
	});
	var UserMatStatInfoGrid = new Ext.ux.GridPanel({
		region: 'center',
		title: '������ϸ',
		id : 'UserMatStatInfoGrid',
		title : '',
		height : 170,
		cm : UserMatStatInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : UserMatStatInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar : StatuTabPagingToolbar2,
		viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){
			var Month=record.get("trType");
				switch(Month){
					case "L":
					return 'classLightGoldenYellow';
					break;
				}
			}
		}
	});

	var HisListTab = new Ext.form.FormPanel({
		title:'������Ա�������ò�ѯ',
		region : 'west',
		width : 300,
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding:10px 1px 1px 1px;',
		tbar : [searchBT, '-', clearBT],		
		items:[{
				autoHeight : true,
				xtype: 'fieldset',
				title:'��ѡ����',
				items : [PhaLoc,StartDate,EndDate,StkGrpType,ItmDesc,ToLoc,GrpList,UserList]
			}]
	});

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',				
		items : [HisListTab, UserMatStatInfoGrid]
	});

});