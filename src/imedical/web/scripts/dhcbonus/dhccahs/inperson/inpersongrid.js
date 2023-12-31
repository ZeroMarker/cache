var busdingUrl = 'dhc.ca.inpersonexe.csp';
var inDeptsProxy = new Ext.data.HttpProxy({url: busdingUrl + '?action=list'});
var inDeptSetsId=""
//接口核算人员数据源
var inDeptsDs = new Ext.data.Store({
	proxy: inDeptsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'rowid',
	'order',
	'personDr',
	'personCode',
	'personName',
	'personSetsDr',
	'personSetsCode',
	'personSetsName'
	]),
	// turn on remote sorting
	remoteSort: true
});

var menu = new Ext.menu.Menu({
	id: 'mainMenu',
	items: [
	{
		text: '添加接口核算人员',
		tooltip: '添加一个接口核算人员',
		iconCls: 'add',
		handler: function(){addInDeptsFun(inDeptsDs,inDeptsGrid,inDeptsPagingToolbar);}
	},
	{
		text:'删除接口核算人员',
		tooltip:'删除选定的接口核算人员',
		iconCls:'remove',
		//disabled:'true',
		handler: function(){
			var rowObj = inDeptsGrid.getSelections();
			var len = rowObj.length;
			var myId = "";
			if(len < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{	
				Ext.MessageBox.confirm('提示', 
					'确定要删除选定的行?', 
					function(btn) {
						 if(btn == 'yes')
						 {	
							 myId = rowObj[0].get("rowid");
						Ext.Ajax.request({
							url: busdingUrl + '?action=delInDept&id='+myId,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize,inDeptSetsId:inDeptSetsId}});
									window.close();
								}
								else
									{
										var message="";
										Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							});   	
						}
					} 
				)	
			}
		}
	}]
});
var tb = new Ext.Toolbar(
[
	{
		text:'核算人员维护',
		iconCls: 'add',
		menu: menu  
	}
]
 );
var showButton = new Ext.form.Checkbox({
	boxLabel: '单位',
	fieldLabel: '单位',
	checked: false
});

/**
var addInDeptButton = new Ext.Toolbar.Button({
	text: '添加接口核算人员',
	tooltip: '添加一个接口核算人员',
	iconCls: 'add',
	handler: function(){addInDeptsFun(inDeptsDs,inDeptsGrid,inDeptsPagingToolbar);}
});
var editInDeptFun  = new Ext.Toolbar.Button({
	text: '修改接口核算人员',
	tooltip: '修改选定的接口核算人员',
	iconCls: 'remove',
	handler: function(){editInDeptsFun(inDeptsDs,inDeptsGrid,inDeptsPagingToolbar);}
});
var delInDeptButton  = new Ext.Toolbar.Button({
	text:'删除接口核算人员',
	tooltip:'删除选定的接口核算人员',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		var rowObj = inDeptsGrid.getSelections();
		var len = rowObj.length;
		var myId = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else
			{	
		Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				     myId = rowObj[0].get("rowid");
				Ext.Ajax.request({
					url: busdingUrl + '?action=delInDept&id='+myId,
					waitMsg:'删除中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize,inDeptSetsId:inDeptSetsId}});
							window.close();
						}
						else
							{
								var message="";
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});   	
			    }
		    } 
		)
				//--------------------------------------------------------------------------------------
				
				}
			}
		});
*/
inDeptsDs.setDefaultSort('RowId', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '序号',
	dataIndex: 'order',
	width: 25,
	sortable: true
},
{
	header: "单位",
	dataIndex: 'unitName',
	width: 100,
	align: 'left',
	sortable: true
},
{
	header: "人员代码",
	dataIndex: 'personCode',
	width: 60,
	align: 'left',
	sortable: true
},
{
	header: "人员名称",
	dataIndex: 'personName',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var inDeptsCmTwo = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '序号',
	dataIndex: 'order',
	width: 25,
	sortable: true
},
{
	header: "人员代码",
	dataIndex: 'personCode',
	width: 45,
	align: 'left',
	sortable: true
},
{
	header: "人员名称",
	dataIndex: 'personName',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var inDeptsSearchField = 'name';

var busdingFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '代码',value: 'Code',checked: false,group: 'busdingFilter',checkHandler: onBusdingItemCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'Name',checked: true,group: 'busdingFilter',checkHandler: onBusdingItemCheck })
	]}
});

function onBusdingItemCheck(item, checked)
{
	if(checked) {
		inDeptsSearchField = item.value;
		busdingFilterItem.setText(item.text + ':');
	}
};

var inDeptsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				inDeptsDs.proxy = new Ext.data.HttpProxy({url: busdingUrl + '?action=list&active=Y&inDeptSetsId='+inDeptSetsId});
				inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				inDeptsDs.proxy = new Ext.data.HttpProxy({
				url: busdingUrl + '?action=list&activey&searchField=' + inDeptsSearchField + '&searchValue=' + this.getValue()+'&inDeptSetsId='+inDeptSetsId});
				inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize}});
			}
		}
	});

	var inDeptsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: inDeptsDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['inDeptSetsId']=inDeptSetsId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});

	var inDeptsGrid = new Ext.grid.GridPanel({//表格
		title: '接口核算人员',
		region: 'west',
		width: 400,
		split: true,
		collapsible: true,
		containerScroll: true,
		xtype: 'grid',
		store: inDeptsDs,
		cm: inDeptsCmTwo,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [tb,'-','搜索:',inDeptsSearchBox],
		bbar: inDeptsPagingToolbar
	});

	//inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize}});

	var inDeptsRowId = "";
	var inDeptsName = "";

	inDeptsGrid.on('rowclick',function(grid,rowIndex,e){
		//单击接口核算人员后刷新接口核算人员单元
		var selectedRow = inDeptsDs.data.items[rowIndex];

		inDeptsRowId = selectedRow.data["rowid"];
		inDeptsName = selectedRow.data["personName"];
		outDeptsGrid.setTitle(inDeptsName+"-接口人员");
		delButton.setDisabled(false);
		addButton.setDisabled(false);
		editButton.setDisabled(false);
		outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&sort=rowid&dir=DESC'});
		outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
	});

	inDeptsDs.on("beforeload",function(ds){
		outDeptsDs.removeAll();
		inDeptsRowId = "";
		outDeptsGrid.setTitle("接口核算人员");
	});
	showButton.on("check",function(ds){
		if(showButton.getValue())
			inDeptsGrid.reconfigure(inDeptsDs,inDeptsCmTwo);
		else
			inDeptsGrid.reconfigure(inDeptsDs,inDeptsCm);
	});
	