var personSetsUrl = 'dhc.ca.personsetsexe.csp';
var personSetsProxy = new Ext.data.HttpProxy({url: personSetsUrl + '?action=list'});

//接口部门套数据源
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
		header: '序号',
		dataIndex: 'order',
		width: 60,
		align: 'left',
		sortable: true
    },
	{
		header: '代码',
		dataIndex: 'code',
		width: 60,
		align: 'left',
		sortable: true
    },
	{
        header: '名称',
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
	{
        header: '备注',
        dataIndex: 'remark',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "有效",
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
		text: '添加',
		tooltip: '添加新的接口部门套',        
		iconCls: 'add',
		handler: function(){addFun(personSetsDs,personSetsMain,personSetsPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的接口部门套',
		iconCls: 'remove',
		handler: function(){editFun(personSetsDs,personSetsMain,personSetsPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的接口部门套',
		iconCls: 'remove',
		disabled: true,
		handler: function(){delFun(personSetsDs,personSetsMain,personSetsPagingToolbar);}
});

var personSetsSearchField = 'name';

var personSetsFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '序号',value: 'order',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '是否有效',value: 'active',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				personSetsSearchField = item.value;
				personSetsFilterItem.setText(item.text + ':');
		}
};

var personSetsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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

var personSetsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: personSetsDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',personSetsFilterItem,'-',personSetsSearchBox]
});

var personSetsMain = new Ext.grid.GridPanel({//表格
		title: '接口部门套维护',
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