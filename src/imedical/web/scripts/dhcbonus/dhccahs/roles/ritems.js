var ritemsFun = function(grid) {
	var rowSelected = grid.getSelections();
	var len = rowSelected.length;
	var parRef=0;

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		
		var mainUrl = 'dhc.ca.ritemsexe.csp';
		parRef = rowSelected[0].get("rowId");		
		var ritemsMainDs = new Ext.data.Store({
				proxy: '',
		    reader: new Ext.data.JsonReader({
		        root: 'rows',
		        totalProperty: 'results'
		        }, [
		            'rowId',
		            'order',
								'itemDr',
								'itemCode',
								'itemName'
				]),
		    remoteSort: true
		});
		
		ritemsMainDs.setDefaultSort('order', 'Asc');
		
		var mainCm = new Ext.grid.ColumnModel([
			 	new Ext.grid.RowNumberer(),
			 	{
		    		header: '项目顺序',
		        dataIndex: 'order',
		        width: 100,
		        align: 'left',
		        sortable: true
		    },
		    {
		        header: "项目代码",
		        dataIndex: 'itemCode',
		        width: 200,
		        align: 'left',
		        sortable: true
		    },
		    {
		        header: "项目名称",
		        dataIndex: 'itemName',
		        width: 200,
		        align: 'left',
		        sortable: true
		    }
		]);
		
		var mainAddButton = new Ext.Toolbar.Button({
				text: '添加',
		    tooltip:'添加新部门信息',        
		    iconCls:'add',
				handler: function(){
						addRitemsFun(ritemsMainDs,ritemsMainPanel,ritemsMainPagingToolbar,parRef);
				}
		});
		
		var mainEditButton  = new Ext.Toolbar.Button({
				text:'修改',        
				tooltip:'修改选定的部门信息',
				iconCls:'remove',        
				handler: function(){
						editRitemsFun(ritemsMainDs,ritemsMainPanel,ritemsMainPagingToolbar);
				}
		});
		
		var mainDelButton  = new Ext.Toolbar.Button({
				text: '删除',        
				tooltip: '删除选定的部门',
				iconCls: 'remove',
				handler: function(){
						delRitemsFun(ritemsMainDs,ritemsMainPanel,ritemsMainPagingToolbar);
				}
		});
		
		var ritemsMainSearchField = 'itemName';
		
		function onMainItemCheck(item, checked)
		{
				if(checked) {
						ritemsMainSearchField = item.value;
						mainFilterItem.setText(item.text + ':');
				}
		};
		
		var mainFilterItem = new Ext.Toolbar.MenuButton({
				text: '过滤器',
				tooltip: '关键字所属类别',
				menu: {items: [
					new Ext.menu.CheckItem({ text: '项目顺序',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
					new Ext.menu.CheckItem({ text: '项目代码',value: 'itemCode',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
					new Ext.menu.CheckItem({ text: '项目名称',value: 'itemName',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
				]}
		});
		

		
		var unitsSearchBox = new Ext.form.TwinTriggerField({
				width: 180,
				trigger1Class: 'x-form-clear-trigger',
				trigger2Class: 'x-form-search-trigger',
				emptyText:'搜索...',
				listeners: {
						specialkey: {fn:function(field, e) {
						var key = e.getKey();
			      	  if(e.ENTER === key) {this.onTrigger2Click();}}}
			    	},
				grid: this,
				onTrigger1Click: function() {
						if(this.getValue()) {
									this.setValue('');
									ritemsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
									ritemsMainDs.load({params:{start:0, limit:ritemsMainPagingToolbar.pageSize}});
						}
				},
				onTrigger2Click: function() {
						if(this.getValue()) {
								ritemsMainDs.proxy = new Ext.data.HttpProxy({
								url: mainUrl + '?action=list&parRef='+parRef+'&searchField=' + ritemsMainSearchField + '&searchValue=' + this.getValue()});
			        	ritemsMainDs.load({params:{start:0, limit:ritemsMainPagingToolbar.pageSize}});
			    	}
				}
		});
		
		var ritemsMainPagingToolbar = new Ext.PagingToolbar({
				pageSize: 25,
		    store: ritemsMainDs,
		    displayInfo: true,
		    displayMsg: '当前显示{0} - {1}，共计{2}',
		    emptyMsg: "没有数据",
				buttons: [mainFilterItem,'-',unitsSearchBox]
		});
		
		var ritemsMainPanel = new Ext.grid.GridPanel({
				store: ritemsMainDs,
				cm: mainCm,
				trackMouseOver: true,
				stripeRows: true,
				sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
				loadMask: true,
				tbar: [mainAddButton,'-',mainEditButton,'-',mainDelButton],
				bbar: ritemsMainPagingToolbar
		});

		var window = new Ext.Window({
			title: '可用项目表',
			width: 800,
			height:600,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: ritemsMainPanel,
			buttons: [
				{
					text: '取消',
					handler: function(){window.close();}
				}]
		});
  	
		window.show();
  	ritemsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
		ritemsMainDs.load({params:{start:0, limit:ritemsMainPagingToolbar.pageSize}});
	}

}