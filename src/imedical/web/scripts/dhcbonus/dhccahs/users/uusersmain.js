var usersUrl = 'dhc.ca.usersexe.csp';
var usersProxy = new Ext.data.HttpProxy({url: usersUrl + '?action=list'});

//�û�����Դ
var usersDs = new Ext.data.Store({
		proxy: usersProxy,
		reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'order',
			'loginName',
			'password',
			'unitPersonDr',
			'unitPersonName',
			'remark',
			'active',
			'unitTypeDr',
			'unitTypeName',
			'unitDr',
			'unitName',
			'fPassword'
		]),
    // turn on remote sorting
    remoteSort: true
});

usersDs.setDefaultSort('order', 'asc');

var usersCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '���',
		dataIndex: 'order',
		width: 60,
		align: 'left',
		sortable: true
    },
	{
		header: '��½��',
		dataIndex: 'loginName',
		width: 150,
		align: 'left',
		sortable: true
    },
	{
        header: '����',
        dataIndex: 'fPassword',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: '��Ա����',
        dataIndex: 'unitPersonName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '��λ����',
        dataIndex: 'unitName',
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
		tooltip: '����µ��û�',        
		iconCls: 'add',
		handler: function(){addFun(usersDs,usersMain,usersPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ�����û�',
		iconCls: 'remove',
		handler: function(){editFun(usersDs,usersMain,usersPagingToolbar);}
});

var uRolesTypesButton  = new Ext.Toolbar.Button({
		text: '�û���ɫ',        
		tooltip: '����ѡ�����û���ɫ',
		iconCls: 'remove',
		handler: function(){uRolesFun(usersDs,usersMain,usersPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ�����û�',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(usersDs,usersMain,usersPagingToolbar);}
});

var usersSearchField = 'loginName';

var usersFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '���',value: 'order',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��¼��',value: 'loginName',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ա����',value: 'unitPsersonName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��λ����',value: 'unitName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�Ƿ���Ч',value: 'active',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				usersSearchField = item.value;
				usersFilterItem.setText(item.text + ':');
		}
};

var usersSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
							usersDs.proxy = new Ext.data.HttpProxy({url: usersUrl + '?action=list'});
							usersDs.load({params:{start:0, limit:usersPagingToolbar.pageSize}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
						usersDs.proxy = new Ext.data.HttpProxy({
						url: usersUrl + '?action=list&searchField=' + usersSearchField + '&searchValue=' + this.getValue()});
	        	usersDs.load({params:{start:0, limit:usersPagingToolbar.pageSize}});
	    	}
		}
});

var usersPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: usersDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',usersFilterItem,'-',usersSearchBox]
});

var usersMain = new Ext.grid.GridPanel({//���
		title: '�û�ά��',
		store: usersDs,
		cm: usersCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar: [uRolesTypesButton],
		bbar: usersPagingToolbar
});

usersDs.load({params:{start:0, limit:usersPagingToolbar.pageSize}});