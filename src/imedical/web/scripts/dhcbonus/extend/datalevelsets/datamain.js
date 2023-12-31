locLastFun = function(dataStore,grid,pagingTool) {
	//alert(repdr);
	if(repdr=="roo"){
		Ext.Msg.show({title:'错误',msg:'此节点不能添加数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(leaf)
	{
		Ext.Msg.show({title:'注意',msg:'此节点不能添加数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var tmpUId="";
	var deptLevelSetsLastTabProxy = new Ext.data.HttpProxy({url:'dhc.bonus.datalevelsetsexe.csp?action=listlast&id='+repdr});
	var tmpMonth="";

	var deptLevelSetsLastTabDs = new Ext.data.Store({
		proxy: deptLevelSetsLastTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'rowid',
			'recCost',
			'itemCode',
			'itemName',
			'itemDr',
			'itemTypeDr',
			'itemTypeName',
			'order',
			'itemTypeName',
			'remark'
		]),
		remoteSort: true
	});

	deptLevelSetsLastTabDs.setDefaultSort('rowid', 'Desc');



	var deptLevelSetsLastTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '数据代码',
			dataIndex: 'itemCode',
			width: 100,
			sortable: true
		},
		{
			header: '数据名称',
			dataIndex: 'itemName',
			width: 150,
			sortable: true
		},
		{
			header: "顺序",
			dataIndex: 'order',
			width: 80,
			sortable: true
		},
		{
			header: "数据类别",
			dataIndex: 'itemTypeName',
			width: 100,
			sortable: true
		},
		{
			header: "备注",
			dataIndex: 'remark',
			width: 100,
			sortable: true
		}
	]);


		
	var deptLevelSetsLastTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 15,
		store: deptLevelSetsLastTabDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['id']=repdr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}

	});
	var addLocButton  = new Ext.Toolbar.Button({
		text: '增加数据',
		tooltip: '增加数据',
		iconCls: 'add',
		handler: function(){AddLocFun(deptLevelSetsLastTabDs,formPanel,deptLevelSetsLastTabPagingToolbar);}
	});

	var editLocButton  = new Ext.Toolbar.Button({
		text: '修改数据',
		tooltip: '修改数据',
		iconCls: 'add',
		handler: function(){editLocFun(deptLevelSetsLastTabDs,formPanel,deptLevelSetsLastTabPagingToolbar);}
	});
	var delLocButton  = new Ext.Toolbar.Button({
		text:'删除数据',
		tooltip:'删除选定的数据',
		iconCls:'remove',
		//disabled:'true',
		handler: function(){
			var rowObj = formPanel.getSelections();
			var len = rowObj.length;
			var myId = "";
			if(len < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{	
				Ext.MessageBox.confirm('提示', 
				'确定要删除选定的行?', 
				function(btn) {
					if(btn == 'yes')
					{	
					myId = rowObj[0].get("rowid");
						Ext.Ajax.request({
						url:'dhc.bonus.datalevelsetsexe.csp?action=delloc&id='+myId,
						waitMsg:'删除中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								Ext.getCmp('detailReport').getNodeById(repdr).reload();
								deptLevelSetsLastTabDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize}});
							}
							else
								{
									var message="";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				})
			}
		}
	});
		
	var formPanel = new Ext.grid.GridPanel({
		//title: '通用数据',
		store: deptLevelSetsLastTabDs,
		cm: deptLevelSetsLastTabCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar:[addLocButton,'-',editLocButton,'-',delLocButton],
		bbar: deptLevelSetsLastTabPagingToolbar
	});

	
	var window = new Ext.Window({
		title: '数据',
		width: 600,
		height:400,
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
	deptLevelSetsLastTabDs.load({params:{start:0, limit:deptLevelSetsLastTabPagingToolbar.pageSize}});
};