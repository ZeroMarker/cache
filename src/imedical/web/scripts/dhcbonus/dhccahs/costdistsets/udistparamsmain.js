distParamsFun = function(dataStore,grid,pagingTool,itemLevelSetsDr) {
	
	//============================================================���ؼ�=============================================================
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var itemSetDr="";
	var layerDr="";
	var active="";
	var myRowid="";
	var myType="in";
	var ioFlag="N";
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
		ioFlag = rowObj[0].get("ioFlag"); 
	}
	if(active !="Y")
	{
		Ext.Msg.show({title:'ע��',msg:'����Ϊ��Ч������ӷ�̯����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	//20090612
	var tmpUId="";
	var findCommTabProxy = new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listDistParams&id='+myRowid+'&type='+myType});
	var tmpMonth="";
	var myAct="";
		
	var costItemTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
		'rowid',
		'paramType',
		'itemDr',
		'itemCode',
		'itemName',
		'right'
		]),
		remoteSort: true
	});

	costItemTabDs.setDefaultSort('RowId', 'Desc');

	var addMethodsButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '��ӳɱ���̯����',        
		iconCls: 'add',
		handler: function(){addDistParamsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,layerDr,itemLevelSetsDr,ioFlag);}
	});

	var editMethodsButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸ĳɱ���̯����',
		iconCls: 'remove',
		handler: function(){editCostItemsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,ioFlag);}
	});
	
	var delMethodsButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ���ɱ���̯����',
		iconCls: 'remove',
		handler: function(){delDistParamsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '��������',
			dataIndex: 'paramType',
			width: 150,
			sortable: true
		},
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
		},
		{
			header: 'Ȩ��',
			dataIndex: 'right',
			width: 150,
			sortable: true
		}
	]);
	
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
			bbar: findCommTabPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '��̯��������',
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
			costItemTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
			window.show();
		};