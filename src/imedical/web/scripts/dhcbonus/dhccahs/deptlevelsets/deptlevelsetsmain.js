var locDr;
var owenr;
var repdr;
var leaf;
var deptLevelSetsUrl = 'dhc.ca.deptlevelsetsexe.csp';
var deptLevelSetsProxy=new Ext.data.HttpProxy({url: deptLevelSetsUrl + '?action=listsub'});
//部门分层数据源
var deptLevelSetsDs = new Ext.data.Store({
	proxy: deptLevelSetsProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
	'id',
	'code',
	'name',
	'desc',
	'remark',
	'leaf',
	'end',
	'active',
	'parent',
	'uiProvider',
	'order',
	'repFlag',
	'recCost',
	'hospDr',
	'hospName',
	'locDr'
	]),
	// turn on remote sorting
	remoteSort: true
});

deptLevelSetsDs.setDefaultSort('id', 'Desc');
var deptLevelSetsCm = new Ext.grid.ColumnModel([
new Ext.grid.RowNumberer(),
{
	header: '分层代码',
	dataIndex: 'code',
	width: 30,
	sortable: true
},
{
	header: "分层名称",
	dataIndex: 'name',
	width: 60,
	sortable: true
},
{
	header: "顺序",
	dataIndex: 'order',
	width: 20,
	sortable: true
},
{
	header: "备注",
	dataIndex: 'remark',
	width: 60,
	sortable: true
},
{
	header: "末端标志",
	dataIndex: 'end',
	width: 30,
	sortable: true,
	renderer : function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
},
{
	header: "有效标志",
	dataIndex: 'active',
	width: 40,
	sortable: true,
	renderer : function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
},
{
	header: "报表输出标志",
	dataIndex: 'repFlag',
	width: 80,
	sortable: true,
	renderer : function(v, p, record){
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
	}
}
]);
var addButton = new Ext.Toolbar.Button({
	text: '添加分层',
	tooltip: '添加一条新数据',
	iconCls: 'add',
	handler: function(){
		Ext.Ajax.request({
			url: encodeURI(deptLevelSetsUrl + '?action=check&id='+repdr),
			waitMsg:'增加中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'||repdr=="roo") {
					AddFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);
				}
				else
					{
						var message="此节点为末端节点,不能进行此操作!";
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
			scope: this
		}); 
		
	}
});

var editButton  = new Ext.Toolbar.Button({
	text: '修改分层',
	tooltip: '修改选定的数据',
	iconCls: 'remove',
	handler: function(){
		var tmpRow=deptLevelSetsGrid.getSelections();
		var tmpLength = tmpRow.length;
		if(tmpLength < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		var recCost=tmpRow[0].get("recCost");
		if(recCost==""){
			EditFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);
		}else{
			editLocFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);
		}
		
	}
});

var addLocButton  = new Ext.Toolbar.Button({
	text: '增加部门',
	tooltip: '增加部门',
	iconCls: 'add',
	handler: function(){locLastFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);}
});

var delLocButton  = new Ext.Toolbar.Button({
	text:'删除部门',
	tooltip:'删除选定的部门',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		var rowObj = deptLevelSetsGrid.getSelections();
		var len = rowObj.length;
		var myId = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		var end = rowObj[0].get("end");
		if(end != "")
		{
			Ext.Msg.show({title:'注意',msg:'您选择的数据不是部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else
		{	
			Ext.MessageBox.confirm('提示', 
			'确定要删除选定的行?', 
			function(btn) {
				if(btn == 'yes')
				{	
				myId = rowObj[0].get("id");
					Ext.Ajax.request({
					url:encodeURI('dhc.ca.deptlevelsetsexe.csp?action=delloc&id='+myId),
					waitMsg:'删除中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById(repdr).reload();
							deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize}});
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
			})
		}
	}
});

var deptLevelSetsSearchField = 'Name';

var deptLevelSetsFilterItem = new Ext.Toolbar.MenuButton({
	text: '过滤器',
	tooltip: '关键字所属类别',
	menu: {items: [
		new Ext.menu.CheckItem({ text: '名称',value: 'Name',checked: true,group: 'deptLevelSetsFilter',checkHandler: onBusItemItemCheck })
		
	]}
});
function onBusItemItemCheck(item, checked)
{
	if(checked) {
		deptLevelSetsSearchField = item.value;
		deptLevelSetsFilterItem.setText(item.text + ':');
	}
};

var deptLevelSetsSearchBox = new Ext.form.TwinTriggerField({//查找按钮
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
			deptLevelSetsDs.proxy = new Ext.data.HttpProxy({url: encodeURI(deptLevelSetsUrl + '?action=listsub&repdr=' + repdr)});
			deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize,repdr:repdr}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			deptLevelSetsDs.proxy = new Ext.data.HttpProxy({
			url: encodeURI(deptLevelSetsUrl + '?action=listsub&repdr=' + repdr+'&searchfield=' + deptLevelSetsSearchField + '&searchvalue=' + this.getValue())});
			deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize,repdr:repdr}});
		}
	}
});
var deptLevelSetsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
	pageSize: 25,
	store: deptLevelSetsDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据",
	//buttons: [deptLevelSetsFilterItem,'-',deptLevelSetsSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['id']=repdr;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}


});
var deptLevelSetsGrid = new Ext.grid.GridPanel({//表格
	//title: '部门分层',
	//width:500,
	region: 'center',
	xtype: 'grid',
	store: deptLevelSetsDs,
	cm: deptLevelSetsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: [addButton,'-',editButton,'-'],
	bbar: deptLevelSetsPagingToolbar
});