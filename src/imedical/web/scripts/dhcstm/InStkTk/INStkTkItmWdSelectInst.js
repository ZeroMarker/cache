// /����: ʵ�̣�ѡȡҪʵ�̵��̵㵥
// /����: ʵ�̣�ѡȡҪʵ�̵��̵㵥
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.04
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParams='';
	var gGroupId=session["LOGON.GROUPID"];
	var url=DictUrl+'instktkaction.csp';
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				width : 140,
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
		var TkComplete='N';  //ʵ����ɱ�־
		var AdjComplete='N';	//������ɱ�־
		var Page=GridPagingToolbar.pageSize;
		gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('sort','instNo');
		MasterInfoStore.setBaseParam('dir','asc');
		MasterInfoStore.setBaseParam('Params',gStrParams);
		MasterInfoStore.removeAll();
		MasterInfoStore.load({params:{start:0, limit:Page}});
	}
	


	var SelectBT=new Ext.Toolbar.Button({
		text:'ѡȡ',
		tooltip:'���ѡȡ',
		iconCls:'page_add',
		width:70,
		height:30,
		handler:function(){
			SelectHandler();
		}
	});
	
	function SelectHandler(){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		if(selectRow==null){
			Msg.info("warning","��ѡ���̵㵥!");
			return;
		}
		var InstId=selectRow.get('inst');
		var inputType=selectRow.get('InputType');
		if(InstId!=null){
			SelectModel(inputType,select);
		}else{
			Msg.info('warning','��ѡ���̵㵥!')
			return;
		}
	}
	
	//����ʵ������
	function select(selectModel,instwWin){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		var InstId=selectRow.get('inst');
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==null || PhaLoc==""){
			Msg.info('warning','��ѡ�����!');
			return;
		}

		// ��ת����Ӧ��¼�����
		if(selectModel==1){
			window.location.href='dhcstm.instktkitmwd.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==2){
			window.location.href='dhcstm.instktkitmwd2.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==3){
			window.location.href='dhcstm.instktkinput.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==4){
			window.location.href='dhcstm.instktkitmtrack.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}
	}
	
	
	// ָ���в���
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","InputType"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "inst",
				fields : fields
			});
	// ���ݼ�
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : url,
				method : "POST"
			});
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
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
	function renderYesNo(value){
		if(value=='Y'){
			return '��';
		}else{
			return '��'
		}	
	}
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'inst',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
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
				dataIndex : 'comp',
				width : 50,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '�ص��ע��־',
				dataIndex : 'manFlag',
				width : 50,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "ʵ��Ĭ�ϵ�λ",
				dataIndex : 'freezeUom',
				width : 80,
				align : 'left',
				renderer:function(value){
					if(value==1){
						return '��ⵥλ';
					}else{
						return '������λ';
					}
				},
				sortable : true
			}, {
				header : "����������",
				dataIndex : 'includeNotUse',
				width : 50,
				align : 'center',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 50,
				align : 'center',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'scgDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'scDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��ʼ��λ",
				dataIndex : 'frSb',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��ֹ��λ",
				dataIndex : 'toSb',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "ʵ������",
				dataIndex : 'InputType',
				width : 100,
				align : 'left',
				sortable : true,
				renderer:function(value){
					if(value=='1'){
						return "������";
					}else if(value=='2'){
						return "��Ʒ��";
					}else if(value=='3'){
						return "����ֵ����";
					}else{
						return value;
					}
				}
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : MasterInfoStore,
					pageSize : PageSize,
					displayInfo : true
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

	// ˫���¼�
	MasterInfoGrid.on('rowdblclick', function(grid,rowindex,e) {
		SelectHandler();
	});
	
	
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			title:'ѡ���̵㵥',
			bodyStyle : 'padding:10px 0px 0px 0px;',
			style: 'padding:0 0 0 0;',
			tbar:[QueryBT,'-',SelectBT],
			items:[{
					xtype:'fieldset',
					//title:'��ѯ����',
					layout: 'column',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:5px 5px 5px 5px;',
					items : [{ 				
						columnWidth: 0.34,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 180, border:false},    // Default config options for child items
		            	//defaultType: 'textfield',
		            	autoHeight: true,
		            	boderStyle: 'padding:0 0 0 0;',
		            	style: 'padding:0 0 0 0;',
		            	border: false,
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
		               	//	"margin-bottom": "10px"
		            	//},
		            	items: [PhaLoc]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [StartDate]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [EndDate]
						
					}]
				}]  	
		});
	
		// 5.2.ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
		                		region:'north',
		                		height:130,
		                		layout:'fit',
		                		items:[form ]
		                	},{
		                		region:'center',
		                		layout:'fit',
		                		items:[MasterInfoGrid]
		                	}],
					renderTo : 'mainPanel'
		});
		
	//�Զ������̵㵥
	Query();
})