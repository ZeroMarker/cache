var outDeptsUrl = 'dhc.ca.indeptsexe.csp';
var outDeptsProxy;

//接口部门数据源
var outDeptsDs = new Ext.data.Store({
	proxy: outDeptsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'parRef',
	'rowid',
	'order',
	'code',
	'name',
	'patType',
	'remark'
	]),
	// turn on remote sorting
	remoteSort: true
});

outDeptsDs.setDefaultSort('RowId', 'Desc');
var outDeptsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '内部部门id',
	dataIndex: 'parRef',
	width: 25,
	hidden: true
},
{
	header: '顺序',
	dataIndex: 'order',
	width: 50,
	sortable: true
},
{
	header: '部门代码',
	dataIndex: 'code',
	width: 120,
	sortable: true
},
{
	header: "部门名称",
	dataIndex: 'name',
	width: 120,
	align: 'left',
	sortable: true
},
{
	header: "病人类型",
	dataIndex: 'patType',
	width: 60,
	align: 'left',
	sortable: true
},
{
	header: "备注",
	dataIndex: 'remark',
	width: 120,
	align: 'left',
	sortable: true
}
]);
var addButton = new Ext.Toolbar.Button({
	text: '添加接口部门',
	tooltip: '添加一个接口部门',
	iconCls: 'add',
	handler: function(){addFun(outDeptsDs,outDeptsGrid,outDeptsPagingToolbar,inDeptsRowId);}
});



var editButton  = new Ext.Toolbar.Button({
	text: '修改接口部门',
	tooltip: '修改选定的接口部门',
	iconCls: 'remove',
	handler: function(){editFun(outDeptsDs,outDeptsGrid,outDeptsPagingToolbar,inDeptsRowId);}
});
var listButton  = new Ext.Toolbar.Button({
	text: '查看所有接口部门',
	tooltip: '查看所有接口部门',
	iconCls: 'remove',
	handler: function(){
		addButton.setDisabled(true);
		editButton.setDisabled(true);
		delButton.setDisabled(true);
		deptChangeButton.setDisabled(true);
		outDeptsDs.proxy = new Ext.data.HttpProxy({url: outDeptsUrl + '?action=listOutDeptTwo&inDeptSetsId='+inDeptSetsId+'&sort=rowid&dir=DESC'});
		outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
	}
});
var delButton  = new Ext.Toolbar.Button({
	text:'删除接口部门',
	tooltip:'删除选定的接口部门',
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
		
var deptChangeButton=new Ext.Toolbar.Button({
	text:'移动接口部门',
	tooltip:'移动选定的接口部门',
	iconCls:'remove',
	handler: function(){
	 var rowObj = outDeptsGrid.getSelections();
		var len = rowObj.length;
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要转换的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var parRef= rowObj[0].get("parRef");
			var rowId = rowObj[0].get("rowid");
			var code = rowObj[0].get("code");
			var name = rowObj[0].get("name");
			var patType = rowObj[0].get("patType");
			var remark = rowObj[0].get("remark");
		  outdeptschange(parRef,rowId,code,name,patType,remark); 
		}
	}
});

var outDeptsSearchField = 'name';

var outDeptsFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '顺序',value: 'order',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '部门代码',value: 'code',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '部门名称',value: 'name',checked: true,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
		new Ext.menu.CheckItem({ text: '病人类型',value: 'patType',checked: false,group: 'outDeptsFilter',checkHandler: onBusItemItemCheck }),
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
	id:'search',
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'搜索...',
	listeners: {
			specialkey: {fn:function(field, e) {
			var key = e.getKey();
			
		if(e.ENTER === key) {this.onTrigger2Click();}
		if(key==38){
			    inDeptsGrid.getSelectionModel().selectPrevious();//选中上一行
                inDeptsGrid.getView().focusRow(1);//获取焦点
                }
         if(key==40){
			inDeptsGrid.getSelectionModel().selectNext();//选中下一行
                inDeptsGrid.getView().focusRow(1);//获取焦点
                }}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');
				outDeptsDs.proxy = new Ext.data.HttpProxy({url: encodeURI(outDeptsUrl + '?action=listOutDept&inDeptId=' + inDeptsRowId)});
				outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				outDeptsDs.proxy = new Ext.data.HttpProxy({
				url: encodeURI(outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&searchField=' + outDeptsSearchField + '&searchValue=' + this.getValue())});
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
		title: '接口部门',
		region: 'center',
		xtype: 'grid',
		store: outDeptsDs,
		cm: outDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [addButton,'-',editButton,'-',delButton,'-',deptChangeButton],
		bbar: outDeptsPagingToolbar
	});