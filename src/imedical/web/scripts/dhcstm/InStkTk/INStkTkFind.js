// /����: ��ѯ����
// /����: ��ѯ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.29

function InStkTkSearch(Fn) {
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session["LOGON.USERID"];
	var gStrParamS='';
	var gLocId=session["LOGON.CTLOCID"];
	var PhaLocS = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PhaLocS',
				name : 'PhaLocS',
				anchor : '95%',
				groupId:gGroupId,
				width : 140
			});
	
	// ��ʼ����
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDateS',
				name : 'StartDateS',
				anchor : '90%',
				
				width : 120,
				value : new Date()
			});

	// ��������
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDateS',
				name : 'EndDateS',
				anchor : '90%',
				
				width : 120,
				value : new Date()
			});
	var CompleteS=new Ext.form.Checkbox({
		fieldLabel:'�������',
		id:'CompleteS',
		name:'CompleteS',
		width : 100,
		height : 10,
		checked:false
	});

	var InfoFormS = new Ext.form.FormPanel({
				frame : true,
				labelAlign : 'right',
				id : "InfoFormS",
				items:[{
					xtype:'fieldset',
					title:'��ѯ����',
					layout: 'column',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:0 0 0 0;',
					defaults : {border : false, style: 'padding:0 0 0 0;'},
					items : [{
						columnWidth: 0.34,
						xtype: 'fieldset',
						labelWidth: 60,
						items: [PhaLocS]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						labelWidth: 60,
						items: [StartDateS]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						labelWidth: 60,
						items: [EndDateS,CompleteS]
					}]
				}]
			});

	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '��������̵㵥��Ϣ',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchData();
				}
			});

	function searchData() {
		var StartDate = Ext.getCmp("StartDateS").getValue()
		if(Ext.isEmpty(StartDate)){
			Msg.info('warning', '��ѡ����ʼ����!');
			return false;
		}else{
			StartDate = StartDate.format(ARG_DATEFORMAT).toString();
		}
		var EndDate = Ext.getCmp("EndDateS").getValue()
		if(Ext.isEmpty(EndDate)){
			Msg.info('warning', '��ѡ���ֹ����!');
			return false;
		}else{
			EndDate = EndDate.format(ARG_DATEFORMAT).toString();
		}
		var PhaLoc = Ext.getCmp("PhaLocS").getValue();
		if(PhaLoc==""){
			Msg.info("warning", "��ѡ���̵����!");
			return;
		}
		var CompFlag='N';
		var IncludeComp=Ext.getCmp("CompleteS").getValue();
		if(IncludeComp==true){
			CompFlag='';
		}
		var TkComplete='N';  //ʵ����ɱ�־
		var AdjComplete='N';	//������ɱ�־
		var Page=GridPagingToolbar.pageSize;
		gStrParamS=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete+'^'+gUserId;
		MasterInfoStore.removeAll();
		MasterInfoStore.setBaseParam('sort', 'instNo');
		MasterInfoStore.setBaseParam('dir', 'asc');
		MasterInfoStore.setBaseParam('Params', gStrParamS);
		MasterInfoStore.load({params:{start:0, limit:Page}});
	}

	// ѡȡ��ť
	var returnBT = new Ext.Toolbar.Button({
				text : 'ѡȡ',
				tooltip : '���ѡȡ',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					returnData();
				}
			});

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
		Ext.getCmp("PhaLocS").setValue(gLocId);
		Ext.getCmp("StartDateS").setValue(new Date());
		Ext.getCmp("EndDateS").setValue(new Date());
		Ext.getCmp("Complete").setValue(false);
		Ext.getCmp("CompleteS").setValue("");
		MasterInfoGrid.store.removeAll();
		//DetailInfoGrid.store.removeAll();
	}

	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});

	// ����·��
	var MasterInfoUrl = DictUrl	+ 'instktkaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});

	// ָ���в���
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","printflag",
			"MinRp","MaxRp","RandomNum"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "inst",
				fields : fields
			});
	// ���ݼ�
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
			},{
				header : '�Ƿ��ӡ',
				dataIndex : 'printflag',
				width : 70,
				align : 'left',
				renderer:renderYesNo,
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
				width : 80,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '�ص��ע��־',
				dataIndex : 'manFlag',
				width : 80,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "���̵�λ",
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
				width : 80,
				align : 'center',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 80,
				align : 'center',
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
				header : "��ͽ���",
				dataIndex : 'MinRp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "��߽���",
				dataIndex : 'MaxRp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "�����",
				dataIndex : 'RandomNum',
				width : 60,
				align : 'right',
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
	MasterInfoGrid.on('rowdblclick', function() {
				returnData();
			});

	
	var window = new Ext.Window({
				title : '�̵㵥',
				width : 900,
				height : 600,
				modal : true,
				layout : 'border',
				items : [
					{
						region: 'north',
						height: 100, // give north and south regions a height
						layout: 'fit', // specify layout manager for items
						items:InfoFormS
					}, {
						region: 'center',
						layout: 'fit', // specify layout manager for items
						items: MasterInfoGrid
					}
				],
				tbar : [searchBT, '-', returnBT, '-', clearBT, '-', closeBT],
				listeners : {
					show : function(){
						searchBT.handler();
					},
					close : function(panel) {
						var selectRows = MasterInfoGrid.getSelectionModel().getSelections();
						if (selectRows.length > 0) {
							var RowId = selectRows[0].get("inst");
							Fn(RowId);
						}
					}
				}
			});
	window.show();

	function returnData() {
		var selectRows = MasterInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning","��ѡ��Ҫ���ص��̵㵥��Ϣ��");
		} else {
			window.close();
		}
	}
}