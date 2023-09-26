var rdeptsFun = function(grid) {
	var rowSelected = grid.getSelections();
	var len = rowSelected.length;
	var parRef=0;

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var mainUrl = 'dhc.ca.rdeptsexe.csp';
		parRef = rowSelected[0].get("rowId");
		var rdeptsMainDs = new Ext.data.Store({
				proxy: '',
		    reader: new Ext.data.JsonReader({
		        root: 'rows',
		        totalProperty: 'results'
		        }, [
		            'rowId',
		            'order',
								'deptDr',
								'deptName'
				]),
		    remoteSort: true
		});
		
		rdeptsMainDs.setDefaultSort('order', 'Asc');
		
		var mainCm = new Ext.grid.ColumnModel([
			 	new Ext.grid.RowNumberer(),
			 	{
		    		header: '部门顺序',
		        dataIndex: 'order',
		        width: 100,
		        align: 'left',
		        sortable: true
		    },
		    {
		        header: "部门名称",
		        dataIndex: 'deptName',
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
					addRdeptsFun(rdeptsMainDs,rdeptsMainPanel,rdeptsMainPagingToolbar,parRef);
				}
		});
		
		var mainEditButton  = new Ext.Toolbar.Button({
				text:'修改',        
				tooltip:'修改选定的部门信息',
				iconCls:'remove',        
				handler: function(){
					editRdeptsFun(rdeptsMainDs,rdeptsMainPanel,rdeptsMainPagingToolbar);
				}
		});
		
		var mainDelButton  = new Ext.Toolbar.Button({
				text: '删除',        
				tooltip: '删除选定的部门',
				iconCls: 'remove',
				handler: function(){
					delRdeptsFun(rdeptsMainDs,rdeptsMainPanel,rdeptsMainPagingToolbar);
				}
		});
		
		var rdeptsMainSearchField = 'deptName';
		
		function onRdeptsMainItemCheck(item, checked)
		{
				if(checked) {
						rdeptsMainSearchField = item.value;
						rdeptsMainFilterItem.setText(item.text + ':');
				}
		};
		
		var rdeptsMainFilterItem = new Ext.Toolbar.MenuButton({
				text: '过滤器',
				tooltip: '关键字所属类别',
				menu: {items: [
					new Ext.menu.CheckItem({ text: '部门顺序',value: 'order',checked: false,group: 'rdeptsMainFilterGroup',checkHandler: onRdeptsMainItemCheck }),
					new Ext.menu.CheckItem({ text: '部门名称',value: 'deptName',checked: true,group: 'rdeptsMainFilterGroup',checkHandler: onRdeptsMainItemCheck })
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
									rdeptsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
									rdeptsMainDs.load({params:{start:0, limit:rdeptsMainPagingToolbar.pageSize}});
						}
				},
				onTrigger2Click: function() {
						if(this.getValue()) {
								rdeptsMainDs.proxy = new Ext.data.HttpProxy({
								url: mainUrl + '?action=list&parRef='+parRef+'&searchField=' + rdeptsMainSearchField + '&searchValue=' + this.getValue()});
			        	rdeptsMainDs.load({params:{start:0, limit:rdeptsMainPagingToolbar.pageSize}});
			    	}
				}
		});
		
		var rdeptsMainPagingToolbar = new Ext.PagingToolbar({
				pageSize: 25,
		    store: rdeptsMainDs,
		    displayInfo: true,
		    displayMsg: '当前显示{0} - {1}，共计{2}',
		    emptyMsg: "没有数据",
				buttons: [rdeptsMainFilterItem,'-',unitsSearchBox]
		});
		
		var rdeptsMainPanel = new Ext.grid.GridPanel({
				//title: '可用部门表',
				store: rdeptsMainDs,
				cm: mainCm,
				trackMouseOver: true,
				stripeRows: true,
				sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
				loadMask: true,
				//tbar: [mainAddButton,'-',mainEditButton,'-',mainDelButton],
				bbar: rdeptsMainPagingToolbar
		});

		var window = new Ext.Window({
			title: '可用部门表',
			width: 800,
			height:600,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: rdeptsMainPanel,
			buttons: [
				{
					text: '取消',
					handler: function(){window.close();}
				}]
		});
  	
		window.show();
  	rdeptsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
		rdeptsMainDs.load({params:{start:0, limit:rdeptsMainPagingToolbar.pageSize}});
	}

}