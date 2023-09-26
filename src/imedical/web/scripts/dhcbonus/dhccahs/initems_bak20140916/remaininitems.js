var remainFun = function(dataStore,grid,pagingTool,inItemSetId) {
	Ext.QuickTips.init();

	var itemTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','order','active'])
	});
	var itemType = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '数据类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		autoWidth:true,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择数据类别...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	itemTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listitemtype&searchValue='+Ext.getCmp('itemType').getRawValue(),method:'GET'});
	});
	
itemType.on("select",function(cmb,rec,id ){
		//alert("asdf");
		itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitems&itemtype='+itemType.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize}});
	});

	var itemsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','typeName','itemCode','itemDr','itemName'])
	});

	itemsDs.setDefaultSort('rowid', 'Desc');
	
	var unitMeasDevCm = new Ext.grid.ColumnModel([
		 	new Ext.grid.RowNumberer(),
	
		 	{
	    		header: '数据代码',
	        dataIndex: 'itemCode',
	        width: 60,
	        align: 'left',
	        sortable: true
	    },
	    {
	        header: "数据名称",
	        dataIndex: 'itemName',
	        width: 200,
	        align: 'left',
	        sortable: true
	    },
	        {
	        header: "数据类别",
	        dataIndex: 'typeName',
	        width: 80,
	        align: 'left',
	        sortable: true
	    }
	]);

		var unitMeasDevPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 25,
			store: itemsDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据"

		});
	
	var formPanel = new Ext.grid.GridPanel({
			store: itemsDs,
			cm: unitMeasDevCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[itemType],
			bbar: unitMeasDevPagingToolbar
		});
		
		var window = new Ext.Window({
			title: '查看剩余核算项目',
			width: 500,
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
			
};