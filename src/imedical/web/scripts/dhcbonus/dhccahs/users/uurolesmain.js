var rolesUrl = 'dhc.ca.usersexe.csp';
var rolesProxy;
uRolesFun = function(dataStore,grid,pagingTool,parRef) {

	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var usersRowId = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		usersRowId = rowObj[0].get("rowid");
	}
	

	//角色数据源
	var rolesDs = new Ext.data.Store({
		proxy: rolesProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
		'rowid',
		'order',
		'roleDr',
		'roleCode',
		'roleName'
		]),
		// turn on remote sorting
		remoteSort: true
	});

	rolesDs.setDefaultSort('rowid', 'Desc');
	var rolesCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '序号',
		dataIndex: 'order',
		width: 60,
		sortable: true
	},
	{
		header: "角色代码",
		dataIndex: 'roleCode',
		width: 120,
		align: 'left',
		sortable: true
	},
	{
		header: "角色名称",
		dataIndex: 'roleName',
		width: 120,
		align: 'left',
		sortable: true
	}
	]);
	var roleAddButton = new Ext.Toolbar.Button({
		text: '添加角色',
		tooltip: '添加一个角色',
		iconCls: 'add',
		handler: function(){rolesAddFun(rolesDs,rolesGrid,rolesPagingToolbar,usersRowId);}
	});
	var roleEditButton  = new Ext.Toolbar.Button({
		text: '修改角色',
		tooltip: '修改选定的角色',
		iconCls: 'remove',
		handler: function(){rolesEditFun(rolesDs,rolesGrid,rolesPagingToolbar,usersRowId);}
	});
	var roleDelButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的用户',
		iconCls: 'remove',
		handler: function(){rolesDelFun(rolesDs,rolesGrid,rolesPagingToolbar);}
	});
	var rolesSearchField = 'roleName';

	var rolesFilterItem = new Ext.Toolbar.MenuButton({
		text: '过滤器',
		tooltip: '关键字所属类别',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '序号',value: 'order',checked: false,group: 'rolesFilter',checkHandler: onBusItemItemCheck }),
			new Ext.menu.CheckItem({ text: '角色名称',value: 'roleName',checked: true,group: 'rolesFilter',checkHandler: onBusItemItemCheck })
		]}
	});
	function onBusItemItemCheck(item, checked)
	{
		if(checked) {
			rolesSearchField = item.value;
			rolesFilterItem.setText(item.text + ':');
		}
	};

var rolesSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				rolesDs.proxy = new Ext.data.HttpProxy({url: rolesUrl + '?action=uRoleList&userDr=' + usersRowId});
				rolesDs.load({params:{start:0, limit:rolesPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				rolesDs.proxy = new Ext.data.HttpProxy({
				url: rolesUrl + '?action=uRoleList&userDr='+usersRowId+'&searchField=' + rolesSearchField + '&searchValue=' + this.getValue()});
				rolesDs.load({params:{start:0, limit:rolesPagingToolbar.pageSize}});
			}
		}
	});
	var rolesPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: rolesDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: [rolesFilterItem,'-',rolesSearchBox]
	});
	var rolesGrid = new Ext.grid.GridPanel({//表格
		title: '角色',
		region: 'center',
		xtype: 'grid',
		store: rolesDs,
		cm: rolesCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		//tbar: [roleAddButton,'-',roleEditButton,'-',roleDelButton],
		bbar: rolesPagingToolbar
	});
	var window = new Ext.Window({
			title: '修改角色',
			width:600,
			height:400,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: rolesGrid,
			buttons: [
				{
					text: '关闭',
					handler: function(){window.close();}
				}]
			});
		window.show();
		rolesDs.proxy = new Ext.data.HttpProxy({url: rolesUrl + '?action=uRoleList&userDr='+usersRowId+'&sort=RowId&dir=DESC'});
		rolesDs.load({params:{start:0, limit:rolesPagingToolbar.pageSize}});
}