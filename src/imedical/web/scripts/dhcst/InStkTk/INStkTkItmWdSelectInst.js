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
				fieldLabel : $g('����'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				width : 140,
				emptyText : $g('����...'),
				groupId:gGroupId
			});
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('��ʼ����'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// ��������
	var EndDate = new Ext.ux.DateField({
				fieldLabel : $g('��������'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 80,
				value : new Date()
			});
	
	// ��ѯ��ť
	var QueryBT = new Ext.Toolbar.Button({
				text :$g( '��ѯ'),
				tooltip : $g('�����ѯ'),
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});

	
	//��ѯ�̵㵥
	function Query(){
	
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
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
		text:$g('ѡȡ'),
		tooltip:$g('���ѡȡ'),
		iconCls:'page_goto',
		width:70,
		height:30,
		handler:function(){
			SelectHandler();
		}
	});
	
	function SelectHandler(){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		if(selectRow==null){
			Msg.info("warning",$g("��ѡ���̵㵥!"));
			return;
		}
		var InstId=selectRow.get('inst');
		var inputType=selectRow.get('InputType');
		if(InstId!=null){
			SelectModel(inputType,select);
		}else{
			Msg.info('warning',$g('��ѡ���̵㵥!'))
			return;
		}
	}
	
	//����ʵ������
	function select(selectModel,instwWin){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		var InstId=selectRow.get('inst');
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==null || PhaLoc==""){
			Msg.info('warning',$g('��ѡ�����!'));
			return;
		}

		// ��ת����Ӧ��¼�����
		if(selectModel==1){
			window.location.href='dhcst.instktkitmwd.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==2){
			window.location.href='dhcst.instktkitmwd2.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==3){
			window.location.href='dhcst.instktkinput.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}
		else if(selectModel==4){
			window.location.href='dhcst.instktkitmwd4.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}
		else if(selectModel==5||selectModel==6){
			// pda��¼�뷽ʽ�������̵�������̵�¼�뷽ʽ�ֶ�
			var ret=tkMakeServerCall("web.DHCST.INStkTk","UpdateInInStkInputType",InstId,selectModel)
			if(ret==0)
			{
				Msg.info("success", $g("�����ƶ����̵㷽ʽ�ɹ�"));
	            Query();
			}
			else if(ret==-1)
			{
				 Msg.info('error',$g("��ѡ��һ���̵㵥��"));
				 return;
			}
			else if(ret==-2)
			{
				 Msg.info('error',$g("��ѡ��һ���ƶ����̵�¼�뷽ʽ��"));
				 return;
			}
			else if(ret==-3)
			{
				 Msg.info('error',$g("���̵㵥�ѱ�����̵�¼�뷽ʽ��"));
				 Query();
			}
			else 
			{
				 Msg.info('error',$g("�����̵�¼�뷽ʽʧ��"));
				 return;
			}
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
	function renderYesNo(value){
		if(value=='Y'){
			return $g('��');
		}else{
			return $g('��')
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
				width : 120,
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
				dataIndex : 'comp',
				width : 50,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : $g('����ҩ��־'),
				dataIndex : 'manFlag',
				width : 50,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : $g("ʵ��Ĭ�ϵ�λ"),
				dataIndex : 'freezeUom',
				width : 80,
				align : 'left',
				renderer:function(value){
					if(value==1){
						return $g('��ⵥλ');
					}else{
						return $g('������λ');
					}
				},
				sortable : true
			}, {
				header : $g("����������"),
				dataIndex : 'includeNotUse',
				width : 50,
				align : 'center',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 50,
				align : 'center',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'scgDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("������"),
				dataIndex : 'scDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("��ʼ��λ"),
				dataIndex : 'frSb',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("��ֹ��λ"),
				dataIndex : 'toSb',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : $g("ʵ������"),
				dataIndex : 'InputType',
				width : 100,
				align : 'right',
				sortable : true,
				renderer:function(value){
					if(value==1){
						return $g("������");
					}else if(value==2){
						return $g("��Ʒ��");
					}else if(value==5){
						return $g("<font color=blue>�ƶ���:</font>��Ʒ��");
					}else if(value==6){
						return $g("<font color=blue>�ƶ���:</font>������");
					}else{
						return "";
					}					
				}
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
					beforePageText :$g( "��ǰҳ"),
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

	// ˫���¼�
	MasterInfoGrid.on('rowdblclick', function(grid,rowindex,e) {
		SelectHandler();
	});
	
	
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			title:$g('ѡ���̵㵥'),
			autoScroll : false,
			bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar:[QueryBT,'-',SelectBT],
			items:[{
					xtype:'fieldset',
					//title:'��ѯ����',
					layout: 'column',
					style: 'padding:10px 0px 5px 0px;',
					items : [{ 				
						columnWidth: 0.34,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [PhaLoc]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [StartDate]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [EndDate]
						
					}]
				}]  	
		});
	
		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [{
		                		region:'north',
		                		height:140,
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