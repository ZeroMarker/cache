var DataItemTypesUrl = 'dhc.ca.dataitemtypesexe.csp';
var DataItemTypesProxy = new Ext.data.HttpProxy({url: DataItemTypesUrl + '?action=list'});

//�����������Դ
var DataItemTypesDs = new Ext.data.Store({
		proxy: DataItemTypesProxy,
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

DataItemTypesDs.setDefaultSort('Rowid', 'DESC');

var DataItemTypesCm = new Ext.grid.ColumnModel([
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
		tooltip: '����µ��������',        
		iconCls: 'add',
		handler: function(){addFun(DataItemTypesDs,DataItemTypesMain,DataItemTypesPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ�����������',
		iconCls: 'remove',
		handler: function(){editFun(DataItemTypesDs,DataItemTypesMain,DataItemTypesPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ�����������',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(DataItemTypesDs,DataItemTypesMain,DataItemTypesPagingToolbar);}
});

var DataItemTypesSearchField = 'name';

var DataItemTypesFilterItem = new Ext.Toolbar.MenuButton({
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
				DataItemTypesSearchField = item.value;
				DataItemTypesFilterItem.setText(item.text + ':');
		}
};

var DataItemTypesSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							DataItemTypesDs.proxy = new Ext.data.HttpProxy({url: DataItemTypesUrl + '?action=list'});
							DataItemTypesDs.load({params:{start:0, limit:DataItemTypesPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						DataItemTypesDs.proxy = new Ext.data.HttpProxy({
						url: DataItemTypesUrl + '?action=list&searchField=' + DataItemTypesSearchField + '&searchValue=' + this.getValue()});
	        	DataItemTypesDs.load({params:{start:0, limit:DataItemTypesPagingToolbar.pageSize}});
	    	}
		}
});

var DataItemTypesPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: DataItemTypesDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',DataItemTypesFilterItem,'-',DataItemTypesSearchBox]
});

var DataItemTypesMain = new Ext.grid.GridPanel({//���
		title: '�������ά��',
		store: DataItemTypesDs,
		cm: DataItemTypesCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		//tbar: [addDataTypesButton,'-',editDataTypesButton,'-',delDataTypesButton],
		bbar: DataItemTypesPagingToolbar
});

DataItemTypesDs.load({params:{start:0, limit:DataItemTypesPagingToolbar.pageSize}});