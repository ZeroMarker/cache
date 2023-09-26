var InDeptSetsUrl = 'dhc.ca.indeptsetsexe.csp';
var InDeptSetsProxy = new Ext.data.HttpProxy({url: InDeptSetsUrl + '?action=list'});

//�ӿڲ���������Դ
var InDeptSetsDs = new Ext.data.Store({
		proxy: InDeptSetsProxy,
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

InDeptSetsDs.setDefaultSort('order', 'asc');

var InDeptSetsCm = new Ext.grid.ColumnModel([
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
		handler: function(){addFun(InDeptSetsDs,InDeptSetsMain,InDeptSetsPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ���Ľӿڲ�����',
		iconCls: 'remove',
		handler: function(){editFun(InDeptSetsDs,InDeptSetsMain,InDeptSetsPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���Ľӿڲ�����',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(InDeptSetsDs,InDeptSetsMain,InDeptSetsPagingToolbar);}
});

var InDeptSetsSearchField = 'name';

var InDeptSetsFilterItem = new Ext.Toolbar.MenuButton({
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
				InDeptSetsSearchField = item.value;
				InDeptSetsFilterItem.setText(item.text + ':');
		}
};

var InDeptSetsSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							InDeptSetsDs.proxy = new Ext.data.HttpProxy({url: InDeptSetsUrl + '?action=list'});
							InDeptSetsDs.load({params:{start:0, limit:InDeptSetsPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						InDeptSetsDs.proxy = new Ext.data.HttpProxy({
						url: InDeptSetsUrl + '?action=list&searchField=' + InDeptSetsSearchField + '&searchValue=' + this.getValue()});
	        	InDeptSetsDs.load({params:{start:0, limit:InDeptSetsPagingToolbar.pageSize}});
	    	}
		}
});

var InDeptSetsPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: InDeptSetsDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',InDeptSetsFilterItem,'-',InDeptSetsSearchBox]
});

var InDeptSetsMain = new Ext.grid.GridPanel({//���
		title: '�ӿڲ�����ά��',
		store: InDeptSetsDs,
		cm: InDeptSetsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [addDataTypesButton,'-',editDataTypesButton,'-',delDataTypesButton],
		bbar: InDeptSetsPagingToolbar
});

InDeptSetsDs.load({params:{start:0, limit:InDeptSetsPagingToolbar.pageSize}});