var usersUrl = 'dhc.ca.usersexe.csp';
var usersProxy = new Ext.data.HttpProxy({url: usersUrl + '?action=list'});

//用户数据源
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
		header: '序号',
		dataIndex: 'order',
		width: 60,
		align: 'left',
		sortable: true
    },
	{
		header: '登陆名',
		dataIndex: 'loginName',
		width: 150,
		align: 'left',
		sortable: true
    },
	{
        header: '密码',
        dataIndex: 'fPassword',
        width: 150,
        align: 'left',
        sortable: true
    },
	{
        header: '人员名称',
        dataIndex: 'unitPersonName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '单位名称',
        dataIndex: 'unitName',
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
		tooltip: '添加新的用户',        
		iconCls: 'add',
		handler: function(){addFun(usersDs,usersMain,usersPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的用户',
		iconCls: 'remove',
		handler: function(){editFun(usersDs,usersMain,usersPagingToolbar);}
});

var uRolesTypesButton  = new Ext.Toolbar.Button({
		text: '用户角色',        
		tooltip: '操作选定的用户角色',
		iconCls: 'remove',
		handler: function(){uRolesFun(usersDs,usersMain,usersPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的用户',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(usersDs,usersMain,usersPagingToolbar);}
});

var usersSearchField = 'loginName';

var usersFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '序号',value: 'order',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '登录名',value: 'loginName',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '人员名称',value: 'unitPsersonName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '单位名称',value: 'unitName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '是否有效',value: 'active',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				usersSearchField = item.value;
				usersFilterItem.setText(item.text + ':');
		}
};

var usersSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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

var usersPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: usersDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: ['-',usersFilterItem,'-',usersSearchBox]
});

var usersMain = new Ext.grid.GridPanel({//表格
		title: '用户维护',
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