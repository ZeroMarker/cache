var rdeptsFun = function(grid) {
	var rowSelected = grid.getSelections();
	var len = rowSelected.length;
	var parRef=0;

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		    		header: '����˳��',
		        dataIndex: 'order',
		        width: 100,
		        align: 'left',
		        sortable: true
		    },
		    {
		        header: "��������",
		        dataIndex: 'deptName',
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
					addRdeptsFun(rdeptsMainDs,rdeptsMainPanel,rdeptsMainPagingToolbar,parRef);
				}
		});
		
		var mainEditButton  = new Ext.Toolbar.Button({
				text:'�޸�',        
				tooltip:'�޸�ѡ���Ĳ�����Ϣ',
				iconCls:'remove',        
				handler: function(){
					editRdeptsFun(rdeptsMainDs,rdeptsMainPanel,rdeptsMainPagingToolbar);
				}
		});
		
		var mainDelButton  = new Ext.Toolbar.Button({
				text: 'ɾ��',        
				tooltip: 'ɾ��ѡ���Ĳ���',
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
				text: '������',
				tooltip: '�ؼ����������',
				menu: {items: [
					new Ext.menu.CheckItem({ text: '����˳��',value: 'order',checked: false,group: 'rdeptsMainFilterGroup',checkHandler: onRdeptsMainItemCheck }),
					new Ext.menu.CheckItem({ text: '��������',value: 'deptName',checked: true,group: 'rdeptsMainFilterGroup',checkHandler: onRdeptsMainItemCheck })
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
		    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		    emptyMsg: "û������",
				buttons: [rdeptsMainFilterItem,'-',unitsSearchBox]
		});
		
		var rdeptsMainPanel = new Ext.grid.GridPanel({
				//title: '���ò��ű�',
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
			title: '���ò��ű�',
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
					text: 'ȡ��',
					handler: function(){window.close();}
				}]
		});
  	
		window.show();
  	rdeptsMainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list&parRef='+parRef});
		rdeptsMainDs.load({params:{start:0, limit:rdeptsMainPagingToolbar.pageSize}});
	}

}