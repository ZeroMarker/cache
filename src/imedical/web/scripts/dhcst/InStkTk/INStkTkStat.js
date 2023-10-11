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
		fieldLabel : '<font color=blue>'+$g('����')+'</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width : 160,
		emptyText : '����...',
		groupId:gGroupId
	});
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '<font color=blue>'+$g('��ʼ����')+'</font>',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// ��������
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '<font color=blue>'+$g('��������')+'</font>',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 80,
				value : new Date()
			});
	var StartTime=new Ext.form.TextField({
		fieldLabel : $g('��ʼʱ��'),
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
		width : 120
	});	

	var EndTime=new Ext.form.TextField({
		fieldLabel : $g('��ֹʱ��'),
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
		width : 120
	});
	//�����־
	var VarianceFlag=new Ext.form.RadioGroup({
		id:'VarianceFlag',
		columns:4,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:$g('����ӯ'),name:'loss',id:'onlySurplus',inputValue:1,width:'100px'},
			{boxLabel:$g('���̿�'),name:'loss',id:'onlyLoss',inputValue:2},
			{boxLabel:$g('��������'),name:'loss',id:'onlyBalance',inputValue:3},
			{boxLabel:$g('��������'),name:'loss',id:'onlyNotBalance',inputValue:4},
			{boxLabel:$g('ȫ��'),name:'loss',inputValue:0,id:'all',checked:true}
		]
	});
	
	// ��ѯ��ť
	var QueryBT = new Ext.Toolbar.Button({
				text :$g( '��ѯ'),
				tooltip :$g( '�����ѯ'),
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
	});
	
	//��ѯ�̵㵥
	function Query(){
		var StartDate=Ext.getCmp("StartDate").getValue()
		var EndDate=Ext.getCmp("EndDate").getValue()
		if(StartDate==""||EndDate=="")
		{
			Msg.info("warning", $g("��ʼ���ںͽ�ֹ���ڲ��ܿգ�"));
			return;
		}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
	    if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", $g("��ʼʱ����ڽ�ֹʱ�䣡"));
				return;
		}
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", $g("��ѡ���̵����!"));
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", $g("��ѡ��ʼ���ںͽ�ֹ����!"));
			return;
		}
		var CompFlag='Y';
		var TkComplete='Y';  //ʵ����ɱ�־
		var AdjComplete='';	//������ɱ�־
		var Page=GridPagingToolbar.pageSize;
		var StrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete+"^"+startTime+"^"+endTime;
		MasterInfoStore.setBaseParam('Params',StrParams);
		MasterInfoStore.load({params:{start:0, limit:Page,sort:'instNo',dir:'asc'}});
	}
	
			//�������
	var CollectBT = new Ext.Toolbar.Button({
		text : $g('�������'),
		tooltip : $g('����������'),
		iconCls : 'page_gear',
		width : 70,	
		height:30,
		handler : function() {
			ShowReport();
		}
	});
	
	function ShowReport()
	{
		var record=MasterInfoGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning",$g("��ѡ��ĳһ�̵㵥���л��ܣ�"));
			return;
		}
		var inst=record.get("inst");
		if(inst==null || inst==""){
			Msg.info("warning",$g("��ѡ��ĳһ�̵㵥���л��ܣ�"));
			return;
		}
		var varianceFlag=Ext.getCmp("VarianceFlag").getValue().getGroupValue();				//��������
		
		var StatFlag=Ext.getCmp("OptReport").getValue().getGroupValue();
		var sort="desc^ASC";
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
		//��ϸ
		if(StatFlag==1){
			var p_URL = 'dhccpmrunqianreport.csp?reportName=instktkstat-detail.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag+'&StartTime='+startTime+'&EndTime='+endTime;
			var NewWin=(window.open(p_URL,$g("�̵�������ϸ"),"top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1,resizable=yes"));
		} 
		//���ƻ���
		else if(StatFlag==2){		
			var p_URL = 'dhccpmrunqianreport.csp?reportName=instktkstat-inc.raq&qPar='+
				sort +'&Inst=' +inst +'&Others='+varianceFlag+'&StartTime='+startTime+'&EndTime='+endTime;
			var NewWin=(window.open(p_URL,$g("�̵��������"),"top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1,resizable=yes"));
		}
	}
	
	var MasterInfoStore=new Ext.data.JsonStore({
		url:url+"?actiontype=Query",
		autoDestroy: true,
		root : 'rows',
		totalProperty : "results",
		idProperty:"inst",
		fields:["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"],
		baseParam:{Params:''}
	});
	
	function renderCompFlag(value){
		if(value=='Y'){
			return $g('���');
		}else{
			return $g('δ���')
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return $g('����ҩ');
		}else{
			return $g('�ǹ���ҩ')
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
				header : $g("�̵㵥��"),
				dataIndex : 'instNo',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g("�̵�����"),
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('�̵�ʱ��'),
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('�̵���'),
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g('������ɱ�־'),
				dataIndex : 'adjComp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : $g('����ҩ��־'),
				dataIndex : 'manFlag',
				width : 100,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'scgDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("������"),
				dataIndex : 'scDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("��ʼ��λ"),
				dataIndex : 'frSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("��ֹ��λ"),
				dataIndex : 'toSb',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store : MasterInfoStore,
		pageSize : PageSize,
		displayInfo : true,
		displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
		emptyMsg : "No results to display",
		prevText : $g("��һҳ"),
		nextText : $g("��һҳ"),
		refreshText : $g("ˢ��"),
		lastText : $g("���ҳ"),
		firstText : $g("��һҳ"),
		beforePageText : $g("��ǰҳ"),
		afterPageText : $g("��{0}ҳ"),
		emptyMsg : $g("û������")
	});
	var MasterInfoGrid = new Ext.grid.GridPanel({
		id : 'MasterInfoGrid',
		title : '',
		height : 170,
		cm : MasterInfoCm,
		sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
		store : MasterInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:[GridPagingToolbar]
	});
	
	var myForm=new Ext.FormPanel({
		title:$g('�̵��������'),
		frame:true,
		labelWidth:60,
		labelAlign : 'right',
		tbar:[QueryBT,'-',CollectBT],
		layout:'column',
		items:[{
			columnWidth:0.6,
			xtype:'fieldset',
			title:$g('��ѯ����'),
			//bodyStyle:'padding:7px',
			layout:'column',
			defaults:{border:false},
			items:[{
				xtype:'fieldset',
				columnWidth:0.4,
				items:[PhaLoc]
			},{
				xtype:'fieldset',
				columnWidth:0.3,
				defaults:{width:140},
				items:[StartDate,StartTime]
			},{
				xtype:'fieldset',
				columnWidth:0.3,
				defaults:{width:140},
				items:[EndDate,EndTime]
			}]
		},{
			xtype:'fieldset',
			title:$g('���汨������'),
			columnWidth:0.35,
			bodyStyle:'padding:7px',
			layout:'column',
			defaults:{border:false},
			items:[VarianceFlag]			
		}]
	})
	
	var myView=new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:175,
			layout:'fit',
			items:[myForm]
		},{
			region:'center',
			layout:'fit',
			items:MasterInfoGrid
		},{
			region:'south',
			height:100,
			frame:true,
			
			items:[{
				title:$g('��������'),		
				style:'padding:0px 0px 0px 10px',
				xtype:'fieldset',
				items:[{
					xtype:'radiogroup',
					column:2,
					id:'OptReport',
					items:[
						{boxLabel:$g('������ϸ'),name:'OptStat',inputValue:1,checked:true},
						{boxLabel:$g('���ƻ���'),name:'OptStat',inputValue:2}
					]
				}]
				
			}]
		}]
	});
});