costItemFun = function(dataStore,grid,pagingTool,itemLevelSetsDr) {
	
	//============================================================面板控件=============================================================
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var itemSetDr="";
	var layerDr="";
	var active="";
	var myRowid="";
	var myType="in";
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
	}
	if(active !="Y")
	{
		Ext.Msg.show({title:'注意',msg:'不能为无效数据添加分摊方法!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	//20090612
	var tmpUId="";
	var findCommTabProxy = new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostItems&id='+myRowid+'&type='+myType});
	var tmpMonth="";
	var myAct="";
	
	var costItemStore = new Ext.data.SimpleStore({//成本分摊套成本分摊套据源
		fields: ['type','rowid'],
		data : [['包含成本项','in'],['不包含包含成本项','out']]
	});
	var costItem = new Ext.form.ComboBox({
		id: 'costItem',
		fieldLabel: '受众科室类型',
		width: 100,
		listWidth : 260,
		//hidden:true,
		allowBlank: false,
		store: costItemStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'成本科室类型...',
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
			window.setTitle("包含成本科室");
		}
		else{
			myType="out";
			formPanel.reconfigure(costItemTabDs,findCommTabCm);
			window.setTitle("不包含成本科室");
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
		text: '添加',
		tooltip: '添加成本分摊方法',        
		iconCls: 'add',
		handler: function(){addCostItemsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType,costItem,layerDr,itemLevelSetsDr);}
	});

	var editMethodsButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改成本分摊方法',
		iconCls: 'remove',
		handler: function(){editCostItemsFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var delMethodsButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除成本分摊方法',
		iconCls: 'remove',
		handler: function(){delCostItemFun(costItemTabDs,formPanel,findCommTabPagingToolbar,myRowid,myType);}
	});
	
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
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
		}
	]);
	Ext.Ajax.request({
				url: costDistSetsUrl+'?action=checkItems&id='+myRowid,
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						if(jsonData.info=="out"){
							myType="out";
							formPanel.reconfigure(costItemTabDs,findCommTabCm);
							costItem.disable();
							costItem.setValue("不包含成本项");
							
						}else if(jsonData.info=="in"){
							myType="in";
							formPanel.reconfigure(costItemTabDs,findCommTabCm);
							costItem.disable();
							costItem.setValue("包含成本项");
						}else{
							myType="in";
							formPanel.reconfigure(costItemTabDs,findCommTabCm);
							costItem.enable();
							costItem.setValue("包含成本项");
						}
						costItemTabDs.proxy=new Ext.data.HttpProxy({url: costDistSetsUrl + '?action=listCostItems&id='+myRowid+'&type='+myType});
						costItemTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,id:myRowid}});
					}
				},
				scope: this
			});
	
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
			tbar:['项目类型:',costItem],
			bbar: findCommTabPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '成本项目',
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
			
			window.show();
		};