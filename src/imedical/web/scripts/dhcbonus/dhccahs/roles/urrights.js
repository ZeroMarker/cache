var rrightsFun = function(grid) {
	var rowSelected = grid.getSelections();
	var len = rowSelected.length;
	var parRef=0;

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		
		var mainUrl = 'dhc.ca.rrightsexe.csp';
		parRef = rowSelected[0].get("rowId");	
		var rrightsMainDs = new Ext.data.Store({
				proxy: '',
		    reader: new Ext.data.JsonReader({
		        root: 'rows',
		        totalProperty: 'results'
		        }, [
		            'rowId',
		            'order',
		            'name',
								'active'
				]),
		    remoteSort: true
		});
		
		rrightsMainDs.setDefaultSort('order', 'Asc');
		
		var mainCm = new Ext.grid.ColumnModel([
			 	new Ext.grid.RowNumberer(),
			 	{
		    		header: '权限顺序',
		        dataIndex: 'order',
		        width: 100,
		        align: 'left',
		        sortable: true
		    },
		    {
		        header: "权限名称",
		        dataIndex: 'name',
		        width: 200,
		        align: 'left',
		        sortable: true
		    },
				{
		        header: "有效",
		        dataIndex: 'active',
		        width: 50,
		        sortable: true,
		        renderer : function(v, p, record){
		        	p.css += ' x-grid3-check-col-td'; 
		        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		    	}
		    }
		]);
		
		var mainAddButton = new Ext.Toolbar.Button({
				text: '添加',
		    tooltip:'添加新部门信息',        
		    iconCls:'add',
				handler: function(){
					addRrightsFun(rrightsMainDs,rrightsMainPanel,rrightsMainPagingToolbar,parRef);
				}
		});
		
		var mainEditButton  = new Ext.Toolbar.Button({
				text:'修改',        
				tooltip:'修改选定的部门信息',
				iconCls:'remove',        
				handler: function(){
					editRrightsFun(rrightsMainDs,rrightsMainPanel,rrightsMainPagingToolbar);
				}
		});
		
		var mainDelButton  = new Ext.Toolbar.Button({
				text: '删除',        
				tooltip: '删除选定的部门',
				iconCls: 'remove',
				handler: function(){
					delRrightsFun(rrightsMainDs,rrightsMainPanel,rrightsMainPagingToolbar);
				}
		});
		
		var mainSearchField = 'name';
		
		function onMainItemCheck(item, checked)
		{
				if(checked) {
						mainSearchField = item.value;
						mainFilterItem.setText(item.text + ':');
				}
		};
		
		var mainFilterItem = new Ext.Toolbar.MenuButton({
				text: '过滤器',
				tooltip: '关键字所属类别',
				menu: {items: [
					new Ext.menu.CheckItem({ text: '权限顺序',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
					new Ext.menu.CheckItem({ text: '权限名称',value: 'name',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
					new Ext.menu.CheckItem({ text: '有效',value: 'active',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
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
									rrightsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
									rrightsMainDs.load({params:{start:0, limit:rrightsMainPagingToolbar.pageSize}});
						}
				},
				onTrigger2Click: function() {
						if(this.getValue()) {
								rrightsMainDs.proxy = new Ext.data.HttpProxy({
								url: mainUrl + '?action=list&parRef='+parRef+'&searchField=' + mainSearchField + '&searchValue=' + this.getValue()});
			        	rrightsMainDs.load({params:{start:0, limit:rrightsMainPagingToolbar.pageSize}});
			    	}
				}
		});
		
		var rrightsMainPagingToolbar = new Ext.PagingToolbar({
				pageSize: 25,
		    store: rrightsMainDs,
		    displayInfo: true,
		    displayMsg: '当前显示{0} - {1}，共计{2}',
		    emptyMsg: "没有数据",
				buttons: [mainFilterItem,'-',unitsSearchBox]
		});
		
		var rrightsMainPanel = new Ext.grid.GridPanel({
				store: rrightsMainDs,
				cm: mainCm,
				trackMouseOver: true,
				stripeRows: true,
				sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
				loadMask: true,
				//tbar: [mainAddButton,'-',mainEditButton,'-',mainDelButton],
				bbar: rrightsMainPagingToolbar
		});

		var window = new Ext.Window({
			title: '可用权限表',
			width: 800,
			height:600,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: rrightsMainPanel,
			buttons: [
				{
					text: '取消',
					handler: function(){window.close();}
				}]
		});
  	
		window.show();
  	rrightsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
		rrightsMainDs.load({params:{start:0, limit:rrightsMainPagingToolbar.pageSize}});
	}

}