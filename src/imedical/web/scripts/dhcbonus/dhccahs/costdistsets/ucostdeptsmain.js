costDeptsFun = function(dataStore,grid,pagingTool,deptLevelSetsDr,order) {

	//============================================================���ؼ�=============================================================
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var deptSetDr="";
	var layerDr="";
	var active="";
	var myRowid="";
	var myType="";
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ɱ���̯����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		active=rowObj[0].get("active"); 
		deptSetDr= rowObj[0].get("deptSetDr"); 
		layerDr= rowObj[0].get("layerDr"); 
		myRowid = rowObj[0].get("rowid"); 
	}
	if(active !="Y")
	{
		Ext.Msg.show({title:'ע��',msg:'����Ϊ��Ч������ӷ�̯����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	//20090612
	var tmpUId="";
	var findCommTabProxy = new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
	var tmpMonth="";
	var myAct="";
	
	var costDeptsStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
		fields: ['type','rowid'],
		data : [['�����ɱ�����','inc'],['�������ɱ�����','outc']]
	});
	var costDepts = new Ext.form.ComboBox({
		id: 'costDepts',
		fieldLabel: '���ڿ�������',
		width: 100,
		listWidth : 260,
		hidden:true,
		allowBlank: false,
		store: costDeptsStore,
		valueField: 'rowid',
		displayField: 'type',
		name:'distFlag',
		triggerAction: 'all',
		emptyText:'�ɱ���������...',
		mode: 'local',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	costDepts.on('select', function(combo,record,index){
		if(combo.getValue()=="inc"){
			myType="inc";
			formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
			window.setTitle("�����ɱ�����");
		}
		else{
			myType="outc";
			formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
			window.setTitle("�������ɱ�����");
		}
		costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
		costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
		
	});
	

	var recDeptsStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
		fields: ['type','rowid'],
		data : [['�������ڿ���','inr'],['���������ڿ���','outr']]
	});
	var recDepts = new Ext.form.ComboBox({
		id: 'recDepts',
		fieldLabel: '���ڿ�������',
		width: 100,
		hidden:true,
		listWidth : 260,
		allowBlank: false,
		store: recDeptsStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'���ڿ�������...',
		mode: 'local',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	recDepts.on('select', function(combo,record,index) {
		if(combo.getValue()=="inr"){
			myType="inr";
			formPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
			window.setTitle("�������ڿ���");
		}
		else{
			myType="outr";
			formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
			window.setTitle("���������ڿ���");
		}
		costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
		costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
	});
	
	
	var costDeptsTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
		'rowid',
		'deptDr',
		'deptCode',
		'deptName',
		'rate'
		]),
		remoteSort: true
	});

	costDeptsTabDs.setDefaultSort('RowId', 'Desc');

	var distFlagStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
		fields: ['type','rowid'],
		data : [['�ɱ�����','cost'],['���ڿ���','rec']]
	});
	var distFlag = new Ext.form.ComboBox({
		id: 'distFlag',
		fieldLabel: '��������',
		width: 100,
		listWidth : 260,
		allowBlank: false,
		store: distFlagStore,
		valueField: 'rowid',
		displayField: 'type',
		name:'distFlag',
		triggerAction: 'all',
		emptyText:'��������...',
		mode: 'local',
		name:'Flag',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	distFlag.on('select', function(combo,record,index) {
		var comboValue=combo.getValue();
		if(comboValue=="cost"){
			costDepts.show();
			recDepts.setVisible(false);
			//costDepts
			Ext.Ajax.request({
				url: costDistSetsUrl+'?action=checkDepts&id='+myRowid,
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						if(jsonData.info=="outc"){
							myType="outc";
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							costDepts.disable();
							costDepts.setValue("�������ɱ�����");
							
						}else if(jsonData.info=="inc"){
							myType="inc";
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							costDepts.disable();
							costDepts.setValue("�����ɱ�����");
						}else{
							myType="inc";
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							costDepts.enable();
							costDepts.setValue("�����ɱ�����");
						}
						costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
						costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
					}
				},
				scope: this
			});
		}else{
			recDepts.setVisible(true);
			costDepts.setVisible(false);
			Ext.Ajax.request({
				url: costDistSetsUrl+'?action=checkRecDepts&id='+myRowid,
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						if(jsonData.info=="outr"){
							myType="outr";
							recDepts.disable();
							formPanel.reconfigure(costDeptsTabDs,findCommTabCm);
							recDepts.setValue("���������ڿ���");
							
						}else if(jsonData.info=="inr"){
							myType="inr";
							recDepts.disable();
							formPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
							recDepts.setValue("�������ڿ���");
						}else{
							myType="inr";
							recDepts.enable();
							formPanel.reconfigure(costDeptsTabDs,InRecDeptsCm);
							recDepts.setValue("�������ڿ���");
						}
						costDeptsTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostDepts&id='+myRowid+'&type='+myType});
						costDeptsTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
					}
				},
				scope: this
			});

		}
	});
	var addMethodsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '��ӳɱ���̯����',        
		iconCls: 'add',
		handler: function(){addCostDeptsFun(costDeptsTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,costDepts,recDepts,order,deptLevelSetsDr,layerDr);}
	});

	var editMethodsButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸ĳɱ���̯����',
		iconCls: 'remove',
		handler: function(){editCostDeptsFun(costDeptsTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,costDepts,recDepts,order,deptLevelSetsDr,layerDr);}
	});
	
	var delMethodsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ���ɱ���̯����',
		iconCls: 'remove',
		handler: function(){delCostDeptsFun(costDeptsTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '���Ŵ���',
			dataIndex: 'deptCode',
			width: 150,
			sortable: true
		},
		{
			header: '��������',
			dataIndex: 'deptName',
			width: 150,
			sortable: true
		}
	]);
		
	var InRecDeptsCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '���Ŵ���',
			dataIndex: 'deptCode',
			width: 150,
			sortable: true
		},
		{
			header: '��������',
			dataIndex: 'deptName',
			width: 150,
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'rate',
			width: 150,
			sortable: true
		}
	]);
	
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 15,
			store: costDeptsTabDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg: "û������",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				//B['layerDr']=layerDr;
				B['id']=myRowid;
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}

		});
	
		//==========================================================���==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: costDeptsTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['��������:',distFlag,'-',costDepts,recDepts],
			bbar: findCommTabPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '�ɱ�����',
			width: 680,
			height:500,
			minWidth: 680,
			minHeight:500,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				{
					text: 'ȡ��',
					handler: function(){window.close();}
				}]
			});
			
			window.show();
		};