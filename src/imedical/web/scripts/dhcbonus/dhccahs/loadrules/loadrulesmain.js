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
    		header: '顺序',
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
        header: "名称",
        dataIndex: 'name',
        width: 200,
        align: 'left',
        sortable: true
    },
    	 	{
        header: "接口部门套",
        dataIndex: 'deptSetName',
        width: 200,
        align: 'left',
        sortable: true
    },
    {
        header: "接口项目套",
        dataIndex: 'itemSetName',
        width: 150,
        align: 'left',
        sortable: true
    },
    {
        header: "数据项类别",
        dataIndex: 'itemTypeName',
        width: 150,
        align: 'left',
        sortable: true
    }
]);

var mainAddButton = new Ext.Toolbar.Button({
		text: '添加',
    tooltip:'添加新角色信息',        
    iconCls:'add',
		handler: function(){
			addFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainEditButton  = new Ext.Toolbar.Button({
		text:'修改',        
		tooltip:'修改选定的角色信息',
		iconCls:'remove',        
		handler: function(){
			editFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainDelButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的角色',
		iconCls: 'remove',
		disabled: true,
		handler: function(){
			delFun(mainDs,mainPanel,mainPagingToolbar);
		}
});

var mainSearchField = 'name';

var mainFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '顺序',value: 'order',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
			//new Ext.menu.CheckItem({ text: '接口部门套',value: 'deptSetDr',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			//new Ext.menu.CheckItem({ text: '接口项目套',value: 'itemSetDr',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck }),
			//new Ext.menu.CheckItem({ text: '数据项类别',value: 'itemTypeDr',checked: false,group: 'MainFilterGroup',checkHandler: onMainItemCheck })
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
		title: '数据导入规则表',
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