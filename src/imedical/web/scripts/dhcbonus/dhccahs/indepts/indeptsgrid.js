var busdingUrl = 'dhc.ca.indeptsexe.csp';
var inDeptsProxy = new Ext.data.HttpProxy({url: busdingUrl + '?action=list'});
var inDeptSetsId=""
//接口核算部门数据源
var inDeptsDs = new Ext.data.Store({
	proxy: inDeptsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'rowid',
	'order',
	'deptDr',
	'deptCode',
	'deptName',
	'unitDr',
	'unitName',
	'unitTypeDr',
	'unitTypeName'
	]),
	// turn on remote sorting
	remoteSort: true
});

var menu = new Ext.menu.Menu({
	id: 'mainMenu',
	items: [
	{
		text: '添加接口核算部门',
		tooltip: '添加一个接口核算部门',
		iconCls: 'add',
		handler: function(){addInDeptsFun(inDeptsDs,inDeptsGrid,inDeptsPagingToolbar);}
	},
	{
		text: '修改接口核算部门',
		tooltip: '修改选定的接口核算部门',
		iconCls: 'remove',
		handler: function(){editInDeptsFun(inDeptsDs,inDeptsGrid,inDeptsPagingToolbar);}
	},
	{
		text:'删除接口核算部门',
		tooltip:'删除选定的接口核算部门',
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
					'确定要删除选定的核算部门?', 
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
		text:'核算部门维护',
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
	text: '添加接口核算部门',
	tooltip: '添加一个接口核算部门',
	iconCls: 'add',
	handler: function(){addInDeptsFun(inDeptsDs,inDeptsGrid,inDeptsPagingToolbar);}
});
var editInDeptFun  = new Ext.Toolbar.Button({
	text: '修改接口核算部门',
	tooltip: '修改选定的接口核算部门',
	iconCls: 'remove',
	handler: function(){editInDeptsFun(inDeptsDs,inDeptsGrid,inDeptsPagingToolbar);}
});
var delInDeptButton  = new Ext.Toolbar.Button({
	text:'删除接口核算部门',
	tooltip:'删除选定的接口核算部门',
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
	header: '顺序',
	dataIndex: 'order',
	width: 45,
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
	header: "核算部门代码",
	dataIndex: 'deptCode',
	width: 90,
	align: 'left',
	sortable: true
},
{
	header: "核算部门名称",
	dataIndex: 'deptName',
	width: 150,
	align: 'left',
	sortable: true
}
]);

var inDeptsCmTwo = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '顺序',
	dataIndex: 'order',
	width: 40,
	sortable: true
},
{
	header: "部门代码",
	dataIndex: 'deptCode',
	width: 45,
	align: 'left',
	sortable: true
},
{
	header: "部门名称",
	dataIndex: 'deptName',
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
	emptyText:'核算部门代码或名称搜索...',
	listeners: {
		specialkey: {fn:function(field, e) {
			var key = e.getKey();
			//右侧接口部门维护界面搜索框获得焦点   zjw20151231
			if(e.getKey() == e.TAB) {outDeptsSearchBox.focus(true,true);
			//outDeptsGrid.getValue() ;
			
			};
			//
			
		if(e.ENTER === key) {this.onTrigger2Click();
		/**/
		
		//默认搜索后选中第一行   zbp20151221
                inDeptsGrid.getSelectionModel().selectFirstRow();//选中第一行
                inDeptsGrid.getView().focusRow(1);//获取焦点
		
	}}}
		},
		grid: this,
		onTrigger1Click: function() {
			if(this.getValue()) {
				this.setValue('');
				inDeptsDs.proxy = new Ext.data.HttpProxy({url: encodeURI(busdingUrl + '?action=list&active=Y&inDeptSetsId='+inDeptSetsId)});
				inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize}});
			}
		},
		onTrigger2Click: function() {
			if(this.getValue()) {
				inDeptsDs.proxy = new Ext.data.HttpProxy({
				url: encodeURI(busdingUrl + '?action=list&active=y&searchField=' + inDeptsSearchField + '&searchValue=' + this.getValue()+'&inDeptSetsId='+inDeptSetsId)});
				inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize}});
			 inDeptsGrid.getSelectionModel().selectFirstRow();//选中第一行
                inDeptsGrid.getView().focusRow(1);//获取焦点
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
		title: '接口核算部门',
		region: 'west',
		width: 400,
		split: true,
		collapsible: true,
		containerScroll: true,
		xtype: 'grid',
		store: inDeptsDs,
		cm: inDeptsCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig: {forceFit:true},
		tbar: [tb,'-','搜索:',inDeptsSearchBox,'-',showButton],
		bbar: inDeptsPagingToolbar
	});

	//inDeptsDs.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize}});

	var inDeptsRowId = "";
	var inDeptsName = "";
	////--------
	// 键盘事件   zbp20151221--任意键切到对应外部科室
     inDeptsGrid.on('keypress',function(){
	   	var rowObj = this.getSelections();
	    inDeptsRowId=rowObj[0].get("rowid");	  
		 inDeptsName =rowObj[0].get("deptName");
	    outDeptsGrid.setTitle(inDeptsName+"-接口部门");
		delButton.setDisabled(false);
		addButton.setDisabled(false);
		editButton.setDisabled(false);
		outDeptsDs.proxy = new Ext.data.HttpProxy({url: encodeURI(outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&sort=rowid&dir=DESC')});
		outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
	    //右侧接口部门维护界面搜索框获得焦点
	    outDeptsSearchBox.focus();
	     
	     })
	////--------
	//默认选中首行 zbp20151221(默认加载后选中第一行)
 	inDeptsGrid.store.on("load",function(){  
        inDeptsGrid.getSelectionModel().selectRow(0,true); 
        
    }); 

	////--------


	inDeptsGrid.on('rowclick',function(grid,rowIndex,e){
		//单击接口核算部门后刷新接口核算部门单元
		var selectedRow = inDeptsDs.data.items[rowIndex];

		inDeptsRowId = selectedRow.data["rowid"];
		inDeptsName = selectedRow.data["deptName"];
		outDeptsGrid.setTitle(inDeptsName+"-接口部门");
		delButton.setDisabled(false);
		addButton.setDisabled(false);
		editButton.setDisabled(false);
		outDeptsDs.proxy = new Ext.data.HttpProxy({url: encodeURI(outDeptsUrl + '?action=listOutDept&inDeptId='+inDeptsRowId+'&sort=rowid&dir=DESC')});
		outDeptsDs.load({params:{start:0, limit:outDeptsPagingToolbar.pageSize}});
		//右侧接口部门维护界面搜索框获得焦点   zjw20151231
	    outDeptsSearchBox.focus();
	});

	inDeptsDs.on("beforeload",function(ds){
		outDeptsDs.removeAll();
		inDeptsRowId = "";
		outDeptsGrid.setTitle("接口核算部门");
	});
	showButton.on("check",function(ds){
		if(showButton.getValue())
			inDeptsGrid.reconfigure(inDeptsDs,inDeptsCmTwo);
		else
			inDeptsGrid.reconfigure(inDeptsDs,inDeptsCm);
	});
	