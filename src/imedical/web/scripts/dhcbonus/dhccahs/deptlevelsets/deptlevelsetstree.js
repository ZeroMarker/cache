
//树形结构导入器
var locTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	uiProviders:{
		'col': Ext.tree.ColumnNodeUI
	}
});
//加载前事件
locTreeLoader.on('beforeload', function(locTreeLoader,node){
	var url="dhc.ca.deptlevelsetsexe.csp?action=list";
	locTreeLoader.dataUrl=url+"&id="+node.id;
		
});
//树形结构的根
var locTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
	text:'分层套',
	value:'0',
	expanded:true
});

var addLocButton  = new Ext.Toolbar.Button({
	text: '维护分层的核算部门',
	tooltip: '增加部门',
	iconCls: 'add',
	handler: function(){locLastFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);}
});

var findLocButton  = new Ext.Toolbar.Button({
	text: '查看未分配的核算部门',
	tooltip: '查看未分配的部门',
	iconCls: 'add',
	handler: function(){CommFindFun();}
});

var delLocButton  = new Ext.Toolbar.Button({
	text:'删除部门',
	tooltip:'删除选定的部门',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		if(!leaf)
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
					Ext.Ajax.request({
					url:encodeURI('dhc.ca.deptlevelsetsexe.csp?action=delloc&id='+repdr),
					waitMsg:'删除中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
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

var copyButton  = new Ext.Toolbar.Button({
	text:'复制分层套',
	tooltip:'复制选中的分层套',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		if(leaf!=false)
		{
			Ext.Msg.show({title:'注意',msg:'您选择的不是节点,不能进行复制!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else
		{	
			Ext.MessageBox.confirm('提示', 
			'确定要复制选定的分层套?', 
			function(btn) {
				if(btn == 'yes')
				{	
					Ext.Ajax.request({
					url:'dhc.ca.deptlevelsetsexe.csp?action=copy&id='+repdr,
					waitMsg:'复制中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'复制成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById("roo").reload();
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

var detailReport = new Ext.tree.TreePanel({
	id:'detailReport',
	width:450,
	region: 'west',
	split: true,
	autoScroll:true,
	collapsible: true,
	containerScroll: true,
	rootVisible: true,
    title: '部门分层',
	tbar: [addLocButton,'-',findLocButton],
	columns:[{
		//width:250,
		dataIndex:'name'
	}],
    loader:locTreeLoader,
    root:locTreeRoot,
	listeners:{
		beforeexpandnode:{fn:alt},
		click:{fn:nodeClicked}
	}
});

function nodeClicked(node)
{
	repdr=node.id;	
	leaf=node.leaf;
	deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize,id:repdr}});		
}
function alt(node)
{
	repdr=node.id;	
	leaf=node.leaf;
	deptLevelSetsDs.load({params:{start:deptLevelSetsPagingToolbar.cursor, limit:deptLevelSetsPagingToolbar.pageSize,id:node.id}});	
}
locTreeRoot.expand();
