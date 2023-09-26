// /����: ���������쵥ִ�������ѯ
// /����: ���������쵥ִ�������ѯ
// /��д�ߣ�wangjiabin
// /��д����: 2013-12-07
Ext.onReady(function() {
	
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	
	var url='dhcstm.indispreqaction.csp';
	//��������
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : '����...'
	});
	
	var uGroupListX=new Ext.data.Store({		 
		url:"dhcstm.sublocusergroupaction.csp?actiontype=getGrpListByUser",
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:"rows"	,
			idProperty:'RowId'
		},['RowId','Description'])
	});
	
	var UserGrp = new Ext.ux.ComboBox({
		fieldLabel:'רҵ��',	
		id:'UserGrp',
		anchor : '90%',
		store:uGroupListX,
		valueField:'RowId',
		displayField:'Description',
		triggerAction:'all',
		params:{subloc:'PhaLoc'},
		valueParams:{user:gUserId}
	});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 30)
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
	
	var NotDisp = new Ext.form.Checkbox({
		boxLabel : 'δ����',
		id : 'NotDisp',
		name : 'NotDisp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	var PartlyDisp = new Ext.form.Checkbox({
		boxLabel : '���ַ���',
		id : 'PartlyDisp',
		name : 'PartlyDisp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	var AllDisp = new Ext.form.Checkbox({
		boxLabel : 'ȫ������',
		id : 'AllDisp',
		name : 'AllDisp',
		anchor : '90%',
		width : 120,
		checked : true
	});
		
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ���쵥',
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("UserGrp").setValue("");
		Ext.getCmp("NotDisp").setValue(true);
		Ext.getCmp("PartlyDisp").setValue(true);
		Ext.getCmp("AllDisp").setValue(true);
		
		MasterGrid.store.removeAll();
		MasterStore.baseParams="";
		MasterGrid.getBottomToolbar().updateInfo();
		DetailGrid.store.removeAll();
		DetailStore.baseParams="";
		DetailGrid.getBottomToolbar().updateInfo();
	}

	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�����!");
			return;
		}		
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var NotDisp = (Ext.getCmp("NotDisp").getValue()==true?'0':'');
		var PartlyDisp = (Ext.getCmp("PartlyDisp").getValue()==true?'1':'');
		var AllDisp = (Ext.getCmp("AllDisp").getValue()==true?'2':'');
		var dispStatus=NotDisp+','+PartlyDisp+','+AllDisp;
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)
		var comp="Y";
		var userGrp=Ext.getCmp("UserGrp").getValue();
		var Status="OCR";	//��ʾ���ܾ������쵥
		//var userGrp="";
		var strPar=startDate+'^'+endDate+'^'+phaLoc+'^'+gUserId+'^'+comp+'^'+Status+'^'+userGrp+'^'+dispStatus;
		
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam('strPar',strPar);
		MasterStore.load({params:{start:0, limit:Page}});
	}
		
	function renderReqStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='δ����';			
		}else if(value==1){
			PoStatus='���ַ���';
		}else if(value==2){
			PoStatus='ȫ������';
		}
		return PoStatus;
	}
	
	var MasterProxy= new Ext.data.HttpProxy({url:url+'?actiontype=DispReqList',method:'GET'});
	var MasterStore = new Ext.data.Store({
		proxy:MasterProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsrq'},
			{name:'no'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'user'},
			{name:'userName'},
			{name:'reqUserName'},
			{name:'reqGrpDesc'},
			{name:'date'},
			{name:'time'},
			{name:'scg'},
			{name:'scgDesc'},
			{name:'status'},
			{name:'comp'},
			{name:'remark'},
			{name:'dispSchedule'}
		]),
		remoteSort: false,
		listeners:{
			load:function(ds){
				if (MasterStore.getCount()>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
	
	var MasterCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{	
			header: 'rowid',
			dataIndex: 'dsrq',
			width: 100,
			hidden:true,
			align: 'left'
		},{	
			header: '����',
			dataIndex: 'dispSchedule',
			width: 60,
			align: 'left',
			renderer:function(value){
				var status="";
				if(value==0){
					status="δ����";
				}else if(value==1){
					status="���ַ���";
				}else if(value==2){
					status="ȫ������";
				}
				return status;
			}
		},{
			header: '���쵥��',
			dataIndex: 'no',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header: "�Ƶ���",
			dataIndex: 'userName',
			width: 60,
			align: 'left',
			sortable: true
		},{
			header: "���쵥����",
			dataIndex: 'date',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "���쵥ʱ��",
			dataIndex: 'time',
			width: 80,
			align: 'left',
			sortable: true
		},{	
			header:'����',
			width:80,
			dataIndex:'scgDesc'		
		},{
			header:'������',
			width:60,
			dataIndex:'reqUserName'
		},{
			header:'רҵ��',
			dataIndex:'reqGrpDesc'
		},{
			header:'���',
			dataIndex:'comp',
			align:'center',
			width:60,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "״̬",
			dataIndex: 'status',
			width: 100,
			align: 'left',
			renderer:function(value){
				var status="";
				if(value=="C"){
					status="�Ѵ���";
				}else if(value=="O"){
					status="������";
				}else if(value=="X"){
					status="������";
				}else if(value=="R"){
					status="�Ѿܾ�";
				}
				return status;
			},
			sortable: true
		},{		 
			header:'��ע',
			dataIndex:'remark',
			width:130,
			align:'left'
		}
	]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var MasterGrid = new Ext.grid.GridPanel({
		region:'west',
		title: '���쵥',
		collapsible: true,
		split: true,
		width: 370,
		cm : MasterCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar,
		viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){ 
				var status=record.get("status");
				switch(status){
					case "R":
						return 'classRed';
						break;
				}
			}
		}
	});

	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var dsrq = MasterStore.getAt(rowIndex).get("dsrq");
		var Size = DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('dsrq',dsrq);
		DetailStore.setBaseParam('sort','');
		DetailStore.setBaseParam('dir','');
		DetailStore.removeAll();
		DetailStore.load({params:{start:0,limit:Size}});
	});
		
	var DetailProxy = new Ext.data.HttpProxy({url:url+'?actiontype=SelDispReqItm',method:'GET'});
	var DetailStore = new Ext.data.Store({
		proxy:DetailProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'rowid',mapping:'dsrqi'},
			{name:'inci'},
			{name:'code',mapping:'inciCode'},
			{name:'desc',mapping:'inciDesc'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'manf'},
			{name:'remark'},
			{name:'dispedQty'},
			"moveStatus"
		]),
		remoteSort: false
	});


	var DetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header: "����",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'qty',
			width: 80,
			align: 'right',
			sortable: true
		},{
			header: "��λ",
			dataIndex: 'uomDesc',
			width: 72,
			align: 'left',
			sortable: true
		},{
			header: "�ѷ�������",
			dataIndex: 'dispedQty',
			width: 80,
			align: 'right',
			sortable: true
		},{
			header:'��ע',
			dataIndex:'remark',
			align:'left',
			width:80,
			sortable:true
		},{
			header : '״̬',
			dataIndex : 'moveStatus',
			width : 60,
			aligh : 'left',
			renderer : function(value){
				var status="";
				if(value=="G"){
					status="δ����";
				}else if(value=="D"){
					status="�ѷ���";
				}else if(value=="X"){
					status="��ȡ��";
				}else if(value=="R"){
					status="�Ѿܾ�";
				}
				return status;
			}
		}
	]);
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:20,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});

	var DetailGrid = new Ext.grid.GridPanel({
		region: 'center',
		title: '���쵥��ϸ',
		id : 'DetailGrid',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:DetailPagingToolbar
	});
				
	var HisListTab = new Ext.ux.FormPanel({
		title:'���쵥���Ȳ�ѯ',
		tbar : [SearchBT, '-', ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults:{border:false,xtype:'fieldset'},
			items : [{
				columnWidth: 0.33,
				items: [PhaLoc,UserGrp]
			},{	
				columnWidth: 0.3,
				items: [StartDate,EndDate]
			},{
				columnWidth: 0.17,
				items: [NotDisp,PartlyDisp]
			},{
				columnWidth: 0.17,
				items: [AllDisp]
			}]
		}]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab,MasterGrid,DetailGrid],
		renderTo:'mainPanel'
	});
	
});