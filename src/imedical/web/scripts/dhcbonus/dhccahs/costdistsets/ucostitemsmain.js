costItemFun = function(dataStore,grid,pagingTool,itemLevelSetsDr) {
	
	//============================================================���ؼ�=============================================================
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var itemSetDr="";
	var layerDr="";
	var active="";
	var myRowid="";
	var myType="in";
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ��ɱ���̯����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		active=rowObj[0].get("active"); 
		itemSetDr= rowObj[0].get("itemSetDr"); 
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
	var findCommTabProxy = new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostItems&id='+myRowid+'&type='+myType});
	var tmpMonth="";
	var myAct="";
	
	var costItemStore = new Ext.data.SimpleStore({//�ɱ���̯�׳ɱ���̯�׾�Դ
		fields: ['type','rowid'],
		data : [['�����ɱ���','in'],['�����������ɱ���','out']]
	});
	var costItem = new Ext.form.ComboBox({
		id: 'costItem',
		fieldLabel: '���ڿ�������',
		width: 100,
		listWidth : 260,
		//hidden:true,
		allowBlank: false,
		store: costItemStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'�ɱ���������...',
		mode: 'local',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	costItem.on('select', function(combo,record,index){
		if(combo.getValue()=="in"){
			myType="in";
			formPanel.reconfigure(costItemTabDs,findCommTabCm);
			window.setTitle("�����ɱ�����");
		}
		else{
			myType="out";
			formPanel.reconfigure(costItemTabDs,findCommTabCm);
			window.setTitle("�������ɱ�����");
		}
		costItemTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostItems&id='+myRowid+'&type='+myType});
		costItemTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
		
	});	
	
	var costItemTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
		'rowid',
		'itemDr',
		'itemCode',
		'itemName',
		'rate'
		]),
		remoteSort: true
	});

	costItemTabDs.setDefaultSort('RowId', 'Desc');

	var addMethodsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '��ӳɱ���̯����',        
		iconCls: 'add',
		handler: function(){addCostItemsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,costItem,layerDr,itemLevelSetsDr);}
	});

	var editMethodsButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸ĳɱ���̯����',
		iconCls: 'remove',
		handler: function(){editCostItemsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var delMethodsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ���ɱ���̯����',
		iconCls: 'remove',
		handler: function(){delCostItemFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '��Ŀ����',
			dataIndex: 'itemCode',
			width: 150,
			sortable: true
		},
		{
			header: '��Ŀ����',
			dataIndex: 'itemName',
			width: 150,
			sortable: true
		}
	]);
	Ext.Ajax.request({
				url: costDistSetsUrl+'?action=checkItems&id='+myRowid,
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						if(jsonData.info=="out"){
							myType="out";
							formPanel.reconfigure(costItemTabDs,findCommTabCm);
							costItem.disable();
							costItem.setValue("�������ɱ���");
							
						}else if(jsonData.info=="in"){
							myType="in";
							formPanel.reconfigure(costItemTabDs,findCommTabCm);
							costItem.disable();
							costItem.setValue("�����ɱ���");
						}else{
							myType="in";
							formPanel.reconfigure(costItemTabDs,findCommTabCm);
							costItem.enable();
							costItem.setValue("�����ɱ���");
						}
						costItemTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostItems&id='+myRowid+'&type='+myType});
						costItemTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
					}
				},
				scope: this
			});
	
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 15,
			store: costItemTabDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg: "û������",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B['layerDr']=layerDr;
				B['id']=myRowid;
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}

		});
	
		//==========================================================���==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: costItemTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['��Ŀ����:',costItem],
			bbar: findCommTabPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '�ɱ���Ŀ',
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