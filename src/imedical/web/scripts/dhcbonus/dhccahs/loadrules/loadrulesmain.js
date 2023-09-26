var mainUrl = 'dhc.ca.loadrulesexe.csp';

var mainDs = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({url: mainUrl + '?action=list'}),
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowId',
            'order',
						'code',
						'name',
						'deptSetDr',
						'itemSetDr',
						'itemTypeDr',
						'deptSetName',
						'itemSetName',
						'itemTypeName'
		]),
    remoteSort: true
});

mainDs.setDefaultSort('order', 'Desc');

var mainCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '˳��',
        dataIndex: 'order',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
    		header: '����',
        dataIndex: 'code',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
        header: "����",
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
    	 	{
        header: "�ӿڲ�����",
        dataIndex: 'deptSetName',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "�ӿ���Ŀ��",
        dataIndex: 'itemSetName',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "���������",
        dataIndex: 'itemTypeName',
        width: 150,
        align: 'left',
        sortable: true
    }
]);

var mainAddButton = new Ext.Toolbar.Button({
		text: '���',
    tooltip:'����½�ɫ��Ϣ',        
    iconCls:'add',
		handler: function(){
			addFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainEditButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���Ľ�ɫ��Ϣ',
		iconCls:'remove',        
		handler: function(){
			editFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainDelButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���Ľ�ɫ',
		iconCls: 'remove',
		disabled: true,
		handler: function(){
			delFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainSearchField = 'name';

var mainFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '˳��',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
			//new Ext.menu.CheckItem({ text: '�ӿڲ�����',value: 'deptSetDr',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			//new Ext.menu.CheckItem({ text: '�ӿ���Ŀ��',value: 'itemSetDr',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			//new Ext.menu.CheckItem({ text: '���������',value: 'itemTypeDr',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
		]}
});

function onMainItemCheck(item, checked)
{
		if(checked) {
				mainSearchField = item.value;
				mainFilterItem.setText(item.text + ':');
		}
};

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
							mainDs.proxy = new Ext.data.HttpProxy({url: mainUrl + '?action=list'});
							mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						mainDs.proxy = new Ext.data.HttpProxy({
						url: mainUrl + '?action=list&searchField=' + mainSearchField + '&searchValue=' + this.getValue()});
	        	mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});
	    	}
		}
});

var mainPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
    store: mainDs,
    displayInfo: true,
    displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
    emptyMsg: "û������",
		buttons: [mainFilterItem,'-',unitsSearchBox]
});

var mainPanel = new Ext.grid.GridPanel({
		title: '���ݵ�������',
		store: mainDs,
		cm: mainCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [mainAddButton,'-',mainEditButton,'-',mainDelButton],
		bbar: mainPagingToolbar
});

mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});