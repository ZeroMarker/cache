var mainUrl = 'dhc.ca.rolesexe.csp';

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
						'shortcut',
						'deptDr',
						'deptName',
						'page',
						'remark',
						'active'
		]),
    remoteSort: true
});

mainDs.setDefaultSort('order', 'Desc');

var mainCm = new Ext.grid.ColumnModel([
	 	new Ext.grid.RowNumberer(),
	 	{
    		header: '��ɫ˳��',
        dataIndex: 'order',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
    		header: '��ɫ����',
        dataIndex: 'code',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
        header: "��ɫ����",
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
    	 	{
        header: "��ɫ����",
        dataIndex: 'deptName',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "��ɫҳ��",
        dataIndex: 'page',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "��ע",
        dataIndex: 'remark',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "��Ч",
        dataIndex: 'active',
        width: 40,
        sortable: true,
        renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
    }
]);

var mainAddButton = new Ext.Toolbar.Button({
		text: '���',
    tooltip:'����½�ɫ��Ϣ',        
    iconCls:'add',
		handler: function(){
			addMainFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainEditButton  = new Ext.Toolbar.Button({
		text:'�޸�',        
		tooltip:'�޸�ѡ���Ľ�ɫ��Ϣ',
		iconCls:'remove',        
		handler: function(){
			editMainFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainDelButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ���Ľ�ɫ',
		iconCls: 'remove',
		disabled: true,
		handler: function(){
			delMainFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var rdeptsButton  = new Ext.Toolbar.Button({
		text: '�鿴���ò���',        
		tooltip: '�鿴���ò���',
		iconCls: 'add',
		handler: function(){rdeptsFun(mainPanel);}
});

var ritemsButton  = new Ext.Toolbar.Button({
		text: '�鿴������Ŀ',        
		tooltip: '�鿴������Ŀ',
		iconCls: 'add',
		handler: function(){ritemsFun(mainPanel);}
});

var rrightsButton  = new Ext.Toolbar.Button({
		text: '�鿴����Ȩ��',        
		tooltip: '�鿴����Ȩ��',
		iconCls: 'add',
		handler: function(){rrightsFun(mainPanel);}
});

var mainSearchField = 'name';

var mainFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '��ɫ˳��',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '��ɫ����',value: 'code',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '��ɫ����',value: 'name',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '��ɫҳ��',value: 'page',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '��Ч',value: 'active',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
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
		title: '��ɫ��',
		store: mainDs,
		cm: mainCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		//tbar: [mainAddButton,'-',mainEditButton,'-',mainDelButton,'-',rdeptsButton,'-',ritemsButton,'-',rrightsButton],
		tbar: [mainAddButton,'-',mainEditButton,'-',mainDelButton,'-',rdeptsButton],
		bbar: mainPagingToolbar
});

mainDs.load({params:{start:0, limit:mainPagingToolbar.pageSize}});