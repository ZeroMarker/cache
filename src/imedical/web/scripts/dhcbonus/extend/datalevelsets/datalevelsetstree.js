
//���νṹ������
var locTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	uiProviders:{
		'col': Ext.tree.ColumnNodeUI
	}
});
//����ǰ�¼�
locTreeLoader.on('beforeload', function(locTreeLoader,node){
	var url="dhc.bonus.datalevelsetsexe.csp?action=list";
	locTreeLoader.dataUrl=url+"&id="+node.id;
		
});
//���νṹ�ĸ�
var locTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
	text:'���ݶ���',
	value:'0',
	expanded:true
});

var addLocButton  = new Ext.Toolbar.Button({
	text: '�༭����',
	tooltip: '�༭����',
	iconCls: 'add',
	handler: function(){locLastFun(deptLevelSetsDs,deptLevelSetsGrid,deptLevelSetsPagingToolbar);}
});

var findLocButton  = new Ext.Toolbar.Button({
	text: '�鿴δ���������',
	tooltip: '�鿴δ���������',
	iconCls: 'add',
	handler: function(){CommFindFun();}
});

var delLocButton  = new Ext.Toolbar.Button({
	text:'ɾ������',
	tooltip:'ɾ��ѡ��������',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		if(!leaf)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ������ݲ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else
		{	
			Ext.MessageBox.confirm('��ʾ', 
			'ȷ��Ҫɾ��ѡ������?', 
			function(btn) {
				if(btn == 'yes')
				{	
					Ext.Ajax.request({
					url:'dhc.bonus.datalevelsetsexe.csp?action=delloc&id='+repdr,
					waitMsg:'ɾ����...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById(jsonData.info).reload();
							deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize}});
						}
						else
							{
								var message="";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
	text:'���Ʒֲ���',
	tooltip:'����ѡ�еķֲ���',
	iconCls:'remove',
	//disabled:'true',
	handler: function(){
		if(leaf!=false)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ��Ĳ��ǽڵ�,���ܽ��и���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else
		{	
			Ext.MessageBox.confirm('��ʾ', 
			'ȷ��Ҫ����ѡ���ķֲ���?', 
			function(btn) {
				if(btn == 'yes')
				{	
					Ext.Ajax.request({
					url:'dhc.bonus.datalevelsetsexe.csp?action=copy&id='+repdr,
					waitMsg:'������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'���Ƴɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById("roo").reload();
							deptLevelSetsDs.load({params:{start:0, limit:deptLevelSetsPagingToolbar.pageSize}});
						}
						else
							{
								var message="";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
  //title: '���ݷֲ�',
	tbar: [addLocButton],
	columns:[{
		//width:250, ,'-',findLocButton,'-',copyButton
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
