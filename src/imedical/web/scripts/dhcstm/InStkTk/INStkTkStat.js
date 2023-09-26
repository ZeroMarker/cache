// /����: �̵��������
// /����: �̵��������
// /��д�ߣ�zhangdongmei
// /��д����: 2013.02.04

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var url=DictUrl+'instktkaction.csp';
	var gGroupId=session["LOGON.GROUPID"];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width : 160,
		emptyText : '����...',
		groupId:gGroupId
	});
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// ��������
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��������',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 80,
				value : new Date()
			});
	
	//�����־
	var VarianceFlag=new Ext.form.RadioGroup({
		id:'VarianceFlag',
		columns:3,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:'����ӯ',name:'loss',id:'onlySurplus',inputValue:1},
			{boxLabel:'���̿�',name:'loss',id:'onlyLoss',inputValue:2},
			{boxLabel:'��������',name:'loss',id:'onlyBalance',inputValue:3},
			{boxLabel:'��������',name:'loss',id:'onlyNotBalance',inputValue:4},
			{boxLabel:'ȫ��',name:'loss',inputValue:0,id:'all',checked:true}
		]
	});
	
	// ��ѯ��ť
	var QueryBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
	});
	
	//��ѯ�̵㵥
	function Query(){
		var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "��ѡ���̵����!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return;
		}
		var CompFlag='Y';
		var TkComplete='Y';  //ʵ����ɱ�־
		var AdjComplete='';	//������ɱ�־
		var Page=GridPagingToolbar.pageSize;
		var StrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		MasterInfoStore.setBaseParam('Params',StrParams);
		MasterInfoStore.load({params:{start:0, limit:Page,sort:'instNo',dir:'asc'}});
	}

	//��ʾ����
	function ShowReport(){
		var panel=tabPanel.getActiveTab()
		var record=MasterInfoGrid.getSelectionModel().getSelected();
		if(record){
			var inst=record.get("inst");
			if(inst==null || inst==""){
				Msg.info("warning","��ѡ��ĳһ�̵㵥���л��ܣ�");
				return;
			}
			var varianceFlag=Ext.getCmp("VarianceFlag").getValue().getGroupValue();				//��������
			var sort="desc^ASC";
			if(panel.id=="Reportinstktkstatdetail"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat-detail.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatdetail");
				reportFrame.src=p_URL;
			}else if(panel.id=="Reportinstktkstatinc"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat-inc.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatinc");
				reportFrame.src=p_URL;
			}else if(panel.id=="Reportinstktkstatbarcode"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat_barcode.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatbarcode");
				reportFrame.src=p_URL;
			}else if(panel.id=="ReportinstktkstatIncsc"){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_instktkstat_Incsc.raq&qPar='+sort +'&Inst=' +inst +'&Others='+varianceFlag;
				var reportFrame=document.getElementById("frameReportinstktkstatIncsc");
				reportFrame.src=p_URL;
			}
		}
	}
	
	var MasterInfoStore=new Ext.data.JsonStore({
		url:url+"?actiontype=Query",
		autoDestroy: true,
		root : 'rows',
		totalProperty : "results",
		idProperty:"inst",
		fields:["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","HighValueFlag"],
		baseParam:{Params:''}
	});
	
	function renderCompFlag(value){
		if(value=='Y'){
			return '���';
		}else{
			return 'δ���'
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return '�ص��ע';
		}else{
			return '���ص��ע'
		}	
	}
	
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'inst',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "�̵㵥��",
				dataIndex : 'instNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�̵�����",
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�̵�ʱ��',
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�̵���',
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '������ɱ�־',
				dataIndex : 'adjComp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '�ص��ע��־',
				dataIndex : 'manFlag',
				width : 100,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "����",
				dataIndex : 'scgDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'scDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��ʼ��λ",
				dataIndex : 'frSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��ֹ��λ",
				dataIndex : 'toSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "�̵�ģʽ",
				dataIndex : 'HighValueFlag',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store : MasterInfoStore,
		pageSize : PageSize,
		displayInfo : true
	});
	var MasterInfoGrid = new Ext.grid.GridPanel({
		id : 'MasterInfoGrid',
		region:'center',
		layout:'fit',
		title : '�̵㵥��Ϣ',
		cm : MasterInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : MasterInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[GridPagingToolbar],
		listeners:{
			'rowclick' : function(grid,rowindex,e){
				ShowReport();
			}
		}
	});

	var myForm=new Ext.ux.FormPanel({
		title:'�̵��������',
		region:'north',
		tbar:[QueryBT],
		layout:'column',
		items:[{
			columnWidth:1,
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults : {border:false,xtype:'fieldset'},
			items:[{
				columnWidth:1,
				items:[PhaLoc,StartDate,EndDate]
			}]
		},{
			columnWidth:1,
			xtype : 'fieldset',
			title : '�����������',
			items:[VarianceFlag]
		}]
	})
	
	var tabPanel=new Ext.TabPanel({
		region:'center',
		activeTab:0,
		items:[{
			title:'������ϸ',
			id:'Reportinstktkstatdetail',
			html:'<iframe id="frameReportinstktkstatdetail" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'���ƻ���',
			id:'Reportinstktkstatinc',
			html:'<iframe id="frameReportinstktkstatinc" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'��ֵ����',
			id:'Reportinstktkstatbarcode',
			html:'<iframe id="frameReportinstktkstatbarcode" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		},{
			title:'���������',
			id:'ReportinstktkstatIncsc',
			html:'<iframe id="frameReportinstktkstatIncsc" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		}],
		listeners:{
			'tabchange':function(){
				ShowReport();
			}
		}
	})

	var panel=new Ext.Panel({
		region:"west",
		width:300,
		layout:'border',
		items : [myForm,MasterInfoGrid]
	});
	var myView=new Ext.ux.Viewport({
		layout:'border',
		items:[panel,tabPanel]
	});
});