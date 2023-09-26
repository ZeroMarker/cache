var personSetsUrl = 'dhc.ca.personsetsexe.csp';
var personSetsProxy = new Ext.data.HttpProxy({url: personSetsUrl + '?action=list'});

//�ӿڲ���������Դ
var personSetsDs = new Ext.data.Store({
		proxy: personSetsProxy,
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
			'active'
		]),
    // turn on remote sorting
    remoteSort: true
});

personSetsDs.setDefaultSort('order', 'asc');

var personSetsCm = new Ext.grid.ColumnModel([
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
		tooltip: '����µĽӿڲ�����',        
		iconCls: 'add',
		handler: function(){addFun(personSetsDs,personSetsMain,personSetsPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ���Ľӿڲ�����',
		iconCls: 'remove',
		handler: function(){editFun(personSetsDs,personSetsMain,personSetsPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���Ľӿڲ�����',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(personSetsDs,personSetsMain,personSetsPagingToolbar);}
});

var personSetsSearchField = 'name';

var personSetsFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '���',value: 'order',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'code',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '����',value: 'name',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�Ƿ���Ч',value: 'active',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				personSetsSearchField = item.value;
				personSetsFilterItem.setText(item.text + ':');
		}
};

var personSetsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							personSetsDs.proxy = new Ext.data.HttpProxy({url: personSetsUrl + '?action=list'});
							personSetsDs.load({params:{start:0, limit:personSetsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						personSetsDs.proxy = new Ext.data.HttpProxy({
						url: personSetsUrl + '?action=list&searchField=' + personSetsSearchField + '&searchValue=' + this.getValue()});
	        	personSetsDs.load({params:{start:0, limit:personSetsPagingToolbar.pageSize}});
	    	}
		}
});

var personSetsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: personSetsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',personSetsFilterItem,'-',personSetsSearchBox]
});

var personSetsMain = new Ext.grid.GridPanel({//���
		title: '�ӿڲ�����ά��',
		store: personSetsDs,
		cm: personSetsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addDataTypesButton,'-',editDataTypesButton,'-',delDataTypesButton],
		bbar: personSetsPagingToolbar
});

personSetsDs.load({params:{start:0, limit:personSetsPagingToolbar.pageSize}});