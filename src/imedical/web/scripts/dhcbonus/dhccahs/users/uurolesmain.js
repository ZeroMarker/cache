var rolesUrl = 'dhc.ca.usersexe.csp';
var rolesProxy;
uRolesFun = function(dataStore,grid,pagingTool,parRef) {

	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var usersRowId = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		usersRowId = rowObj[0].get("rowid");
	}
	

	//��ɫ����Դ
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
		header: '���',
		dataIndex: 'order',
		width: 60,
		sortable: true
	},
	{
		header: "��ɫ����",
		dataIndex: 'roleCode',
		width: 120,
		align: 'left',
		sortable: true
	},
	{
		header: "��ɫ����",
		dataIndex: 'roleName',
		width: 120,
		align: 'left',
		sortable: true
	}
	]);
	var roleAddButton = new Ext.Toolbar.Button({
		text: '��ӽ�ɫ',
		tooltip: '���һ����ɫ',
		iconCls: 'add',
		handler: function(){rolesAddFun(rolesDs,rolesGrid,rolesPagingToolbar,usersRowId);}
	});
	var roleEditButton  = new Ext.Toolbar.Button({
		text: '�޸Ľ�ɫ',
		tooltip: '�޸�ѡ���Ľ�ɫ',
		iconCls: 'remove',
		handler: function(){rolesEditFun(rolesDs,rolesGrid,rolesPagingToolbar,usersRowId);}
	});
	var roleDelButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ�����û�',
		iconCls: 'remove',
		handler: function(){rolesDelFun(rolesDs,rolesGrid,rolesPagingToolbar);}
	});
	var rolesSearchField = 'roleName';

	var rolesFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
			new Ext.menu.CheckItem({ text: '���',value: 'order',checked: false,group: 'rolesFilter',checkHandler: onBusItemItemCheck }),
			new Ext.menu.CheckItem({ text: '��ɫ����',value: 'roleName',checked: true,group: 'rolesFilter',checkHandler: onBusItemItemCheck })
		]}
	});
	function onBusItemItemCheck(item, checked)
	{
		if(checked) {
			rolesSearchField = item.value;
			rolesFilterItem.setText(item.text + ':');
		}
	};

var rolesSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
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
	var rolesPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: rolesDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: [rolesFilterItem,'-',rolesSearchBox]
	});
	var rolesGrid = new Ext.grid.GridPanel({//���
		title: '��ɫ',
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
			title: '�޸Ľ�ɫ',
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
					text: '�ر�',
					handler: function(){window.close();}
				}]
			});
		window.show();
		rolesDs.proxy = new Ext.data.HttpProxy({url: rolesUrl + '?action=uRoleList&userDr='+usersRowId+'&sort=RowId&dir=DESC'});
		rolesDs.load({params:{start:0, limit:rolesPagingToolbar.pageSize}});
}