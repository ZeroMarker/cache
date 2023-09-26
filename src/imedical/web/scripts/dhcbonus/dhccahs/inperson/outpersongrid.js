var outDeptsUrl = 'dhc.ca.inpersonexe.csp';
var outDeptsProxy;

//接口人员数据源
var outDeptsDs = new Ext.data.Store({
	proxy: outDeptsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'rowid',
	'order',
	'remark',
	'inPersonDr',
	'inPersonCode',
	'inPersonName',
	'outPersonCode',
	'outPersonName'
	]),
	// turn on remote sorting
	remoteSort: true
});

outDeptsDs.setDefaultSort('RowId', 'Desc');
var outDeptsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '序号',
	dataIndex: 'order',
	width: 25,
	sortable: true
},
{
	header: '代码',
	dataIndex: 'outPersonCode',
	width: 40,
	sortable: true
},
{
	header: "名称",
	dataIndex: 'outPersonName',
	width: 120,
	align: 'left',
	sortable: true
},
{
	header: "备注",
	dataIndex: 'remark',
	width: 150,
	align: 'left',
	sortable: true
}
]);
var addButton = new Ext.Toolbar.Button({
	text: '添加接口人员',
	tooltip: '添加一个接口人员',
	iconCls: 'add',
	handler: function(){addFun(outDeptsDs,outDeptsGrid,outDeptsPagingToolbar,inDeptsRowId);}
});



var editButton  = new Ext.Toolbar.Button({
	text: '修改接口人员',
	tooltip: '修改选定的接口人员',
	iconCls: 'remove',
	handler: function(){editFun(outDeptsDs,outDeptsGrid,outDeptsPagingToolbar,inDeptsRowId);}
});
var listButton  = new Ext.Toolbar.Button({
	text: '查看所有接口人员',
	tooltip: '查看所有接口人员',
	iconCls: 'remove',
	handler: function(){
		addButton.setDisabled(true);
		editButton.setDisabled(true);
		delButton.setDisabled(true);
		outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDeptTwo&inDeptSetsId='+inDeptSetsId+'&sort=rowid&dir=DESC'});
		outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
	}
});
var delButton  = new Ext.Toolbar.Button({
	text:'删除接口人员',
	tooltip:'删除选定的接口人员',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		var rowObj = outDeptsGrid.getSelections();
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
					url: busdingUrl + '?action=delOutDept&id='+myId,
					waitMsg:'删除中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&sort=rowid&dir=DESC'});
							outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
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
var outDeptsSearchField = 'name';

var outDeptsFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '序号',value: 'order',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '代码',value: 'code',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '名称',value: 'name',checked: true,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		//new Ext.menu.CheckItem({ text: '病人类型',value: 'patType',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '备注',value: 'remark',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck })
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		outDeptsSearchField = item.value;
		outDeptsFilterItem.setText(item.text + ':');
	}
};

var outDeptsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
				outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDept&inDeptId=' + inDeptsRowId});
				outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				outDeptsDs.proxy = new Ext.data.HttpProxy({
				url: outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&searchField=' + outDeptsSearchField + '&searchValue=' + this.getValue()});
				outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
			}
		}
	});
	var outDeptsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize: 25,
		store: outDeptsDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
		buttons: [outDeptsFilterItem,'-',outDeptsSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['inDeptId']=inDeptsRowId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	var outDeptsGrid = new Ext.grid.GridPanel({//表格
		title: '接口人员',
		region: 'center',
		xtype: 'grid',
		store: outDeptsDs,
		cm: outDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',delButton,'-',listButton],
		bbar: outDeptsPagingToolbar
	});