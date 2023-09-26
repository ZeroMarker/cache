var ritemsFun = function(grid) {
	var rowSelected = grid.getSelections();
	var len = rowSelected.length;
	var parRef=0;

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		    		header: '��Ŀ˳��',
		        dataIndex: 'order',
		        width: 100,
		        align: 'left',
		        sortable: true
		    },
		    {
		        header: "��Ŀ����",
		        dataIndex: 'itemCode',
		        width: 200,
		        align: 'left',
		        sortable: true
		    },
		    {
		        header: "��Ŀ����",
		        dataIndex: 'itemName',
		        width: 200,
		        align: 'left',
		        sortable: true
		    }
		]);
		
		var mainAddButton = new Ext.Toolbar.Button({
				text: '���',
		    tooltip:'����²�����Ϣ',        
		    iconCls:'add',
				handler: function(){
						addRitemsFun(ritemsMainDs,ritemsMainPanel,ritemsMainPagingToolbar,parRef);
				}
		});
		
		var mainEditButton  = new Ext.Toolbar.Button({
				text:'�޸�',        
				tooltip:'�޸�ѡ���Ĳ�����Ϣ',
				iconCls:'remove',        
				handler: function(){
						editRitemsFun(ritemsMainDs,ritemsMainPanel,ritemsMainPagingToolbar);
				}
		});
		
		var mainDelButton  = new Ext.Toolbar.Button({
				text: 'ɾ��',        
				tooltip: 'ɾ��ѡ���Ĳ���',
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
				text: '������',
				tooltip: '�ؼ����������',
				menu: {items: [
					new Ext.menu.CheckItem({ text: '��Ŀ˳��',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
					new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemCode',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
					new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemName',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
				]}
		});
		

		
		var unitsSearchBox = new Ext.form.TwinTriggerField({
				width: 180,
				trigger1Class: 'x-form-clear-trigger',
				trigger2Class: 'x-form-search-trigger',
				emptyText:'����...',
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
		    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		    emptyMsg: "û������",
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
			title: '������Ŀ��',
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
					text: 'ȡ��',
					handler: function(){window.close();}
				}]
		});
  	
		window.show();
  	ritemsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
		ritemsMainDs.load({params:{start:0, limit:ritemsMainPagingToolbar.pageSize}});
	}

}