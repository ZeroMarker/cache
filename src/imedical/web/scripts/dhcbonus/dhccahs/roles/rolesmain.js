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
    		header: '角色顺序',
        dataIndex: 'order',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
    		header: '角色代码',
        dataIndex: 'code',
        width: 60,
        align: 'left',
        sortable: true
    },
	 	{
        header: "角色名称",
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
    	 	{
        header: "角色部门",
        dataIndex: 'deptName',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "角色页面",
        dataIndex: 'page',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "备注",
        dataIndex: 'remark',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "有效",
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
		text: '添加',
    tooltip:'添加新角色信息',        
    iconCls:'add',
		handler: function(){
			addMainFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainEditButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的角色信息',
		iconCls:'remove',        
		handler: function(){
			editMainFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainDelButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的角色',
		iconCls: 'remove',
		disabled: true,
		handler: function(){
			delMainFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var rdeptsButton  = new Ext.Toolbar.Button({
		text: '查看可用部门',        
		tooltip: '查看可用部门',
		iconCls: 'add',
		handler: function(){rdeptsFun(mainPanel);}
});

var ritemsButton  = new Ext.Toolbar.Button({
		text: '查看可用项目',        
		tooltip: '查看可用项目',
		iconCls: 'add',
		handler: function(){ritemsFun(mainPanel);}
});

var rrightsButton  = new Ext.Toolbar.Button({
		text: '查看可用权限',        
		tooltip: '查看可用权限',
		iconCls: 'add',
		handler: function(){rrightsFun(mainPanel);}
});

var mainSearchField = 'name';

var mainFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '角色顺序',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '角色代码',value: 'code',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '角色名称',value: 'name',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '角色页面',value: 'page',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '有效',value: 'active',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
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
    displayMsg: '当前显示{0} - {1}，共计{2}',
    emptyMsg: "没有数据",
		buttons: [mainFilterItem,'-',unitsSearchBox]
});

var mainPanel = new Ext.grid.GridPanel({
		title: '角色表',
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