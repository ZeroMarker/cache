distParamsFun = function(dataStore,grid,pagingTool,itemLevelSetsDr) {
	
	//============================================================面板控件=============================================================
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
		Ext.Msg.show({title:'注意',msg:'请选择成本分摊方法后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		Ext.Msg.show({title:'注意',msg:'不能为无效数据添加分摊方法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		text: '添加',
		tooltip: '添加成本分摊方法',        
		iconCls: 'add',
		handler: function(){addDistParamsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,layerDr,itemLevelSetsDr,ioFlag);}
	});

	var editMethodsButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改成本分摊方法',
		iconCls: 'remove',
		handler: function(){editCostItemsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,ioFlag);}
	});
	
	var delMethodsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除成本分摊方法',
		iconCls: 'remove',
		handler: function(){delDistParamsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '参数类型',
			dataIndex: 'paramType',
			width: 150,
			sortable: true
		},
		{
			header: '项目代码',
			dataIndex: 'itemCode',
			width: 150,
			sortable: true
		},
		{
			header: '项目名称',
			dataIndex: 'itemName',
			width: 150,
			sortable: true
		},
		{
			header: '权重',
			dataIndex: 'right',
			width: 150,
			sortable: true
		}
	]);
	
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 15,
			store: costItemTabDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据",
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
	
		//==========================================================面板==========================================================
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
			title: '分摊参数设置',
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
					text: '取消',
					handler: function(){window.close();}
				}]
			});
			costItemTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
			window.show();
		};