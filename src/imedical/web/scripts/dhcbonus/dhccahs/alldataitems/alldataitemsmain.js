var AllDataItemsUrl = 'dhc.ca.alldataitemsexe.csp';
var AllDataItemsProxy = new Ext.data.HttpProxy({url: AllDataItemsUrl + '?action=list'});

//����������Դ
var AllDataItemsDs = new Ext.data.Store({
		proxy: AllDataItemsProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'order',
			'code',
			'name',
			'shortcut',
			'remark',
			'active',
			'unit'
		]),
    // turn on remote sorting
    remoteSort: true
});

AllDataItemsDs.setDefaultSort('Rowid', 'DESC');

var AllDataItemsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '���',
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
        header: '����',
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
        header: '��λ',
        dataIndex: 'unit',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '��ע',
        dataIndex: 'remark',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "��Ч",
        dataIndex: 'active',
        width: 60,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
    }
]);

var addDataTypesButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µ�������',        
		iconCls: 'add',
		handler: function(){addFun(AllDataItemsDs,AllDataItemsMain,AllDataItemsPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ����������',
		iconCls: 'remove',
		handler: function(){editFun(AllDataItemsDs,AllDataItemsMain,AllDataItemsPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ����������',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(AllDataItemsDs,AllDataItemsMain,AllDataItemsPagingToolbar);}
});

var AllDataItemsSearchField = 'name';

var AllDataItemsFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '���',value: 'order',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��λ',value: 'unit',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�Ƿ���Ч',value: 'active',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				AllDataItemsSearchField = item.value;
				AllDataItemsFilterItem.setText(item.text + ':');
		}
};

var AllDataItemsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							AllDataItemsDs.proxy = new Ext.data.HttpProxy({url: AllDataItemsUrl + '?action=list'});
							AllDataItemsDs.load({params:{start:0, limit:AllDataItemsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						AllDataItemsDs.proxy = new Ext.data.HttpProxy({
						url: AllDataItemsUrl + '?action=list&searchField=' + AllDataItemsSearchField + '&searchValue=' + this.getValue()});
	        	AllDataItemsDs.load({params:{start:0, limit:AllDataItemsPagingToolbar.pageSize}});
	    	}
		}
});

var AllDataItemsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: AllDataItemsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',AllDataItemsFilterItem,'-',AllDataItemsSearchBox]
});

var AllDataItemsMain = new Ext.grid.GridPanel({//���
		title: '������ά��',
		store: AllDataItemsDs,
		cm: AllDataItemsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addDataTypesButton,'-',editDataTypesButton,'-',delDataTypesButton],
		bbar: AllDataItemsPagingToolbar
});

AllDataItemsDs.load({params:{start:0, limit:AllDataItemsPagingToolbar.pageSize}});