/**
  *name:kpiindex 
  *author:limingzhong
  *Date:2010-7-24
 */
//================ȥ���ַ����ո�==============================
function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
//============================================================

//================���岿��ȫ�ֱ���============================
//��ӻ����޸ı�־
var type="";
//���ʽ(�ؼ�)
var expreField="";
//���ʽ����(�ؼ�)
var expreDescField="";
//���ʽ����(����)
var expreDesc="";
//���ڱ��ʽ�Ĵ洢
var globalStr3="";
//���ڱ��ʽ����ʾ
var globalStr="";
//���ڱ��ʽ���˸���
var globalStr2=""
//============================================================

//================�����ȡҪ�����ڵ�ĺ���====================
//��ȡҪ�����Ľڵ�
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
}
//============================================================

//================���幤�����Լ���ӡ��޸ġ�ɾ����ť==========
//��Ӱ�ť
var addButton=new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls: 'add',
	handler:function(){
		addFun(getNode());
	}
});
//�޸İ�ť
var updateButton=new Ext.Toolbar.Button({
	text:'�޸�',
	tooltip:'���ÿ۷�ϵ��',
	iconCls: 'add',
	handler:function(){
		updateFun(getNode());
	}
});
//ɾ����ť
var delButton=new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls: 'remove',
	handler:function(){
		delFun(getNode());
	}
});

//������
var menubar = [addButton,'-',updateButton,'-',delButton];
//============================================================

//================����ColumnTree�������Ϣ====================
//���νṹ������
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//����ǰ�¼�
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
	if(detailTreeRoot.value!="undefined"){
		var url="../csp/dhc.pa.selfmaintainexe.csp?action=list";
		detailTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//���νṹ�ĸ�
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'��Ŀ����',
	value:'',
	expanded:false
});
//����չ����ť
/*var colButton = new Ext.Toolbar.Button({
	text:'ȫ������',
	tooltip:'���ȫ��չ����ر�',
	listeners:{click:{fn:detailReportControl}}
});
//����չ������ִ�к���
function detailReportControl(){
	if(colButton.getText()=='ȫ��չ��'){
		colButton.setText('ȫ������');
		detailReport.expandAll();
	}else{
		colButton.setText('ȫ��չ��');
		detailReport.collapseAll();
	}
};*/

//���ͽṹ����
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	title: '�Բ���Ŀά��',
	height:590,
    rootVisible:true,
    autoScroll:true,
	columns:[
	
	{
    	header:'��Ŀ����',
    	align: 'right',
    	width:300,
    	dataIndex:'name'
	},
	
	{
    	header:'��Ŀ����',
    	width:80,
    	dataIndex:'code'
	},
	{
    	header:'��Ŀid',
    	align: 'right',
    	width:50,
    	dataIndex:'id'
	}
	,{
    	header:'��λ',
    	align: 'right',
    	width:80,
    	dataIndex:'unit'
	},{
    	header:'��Ŀ���',
    	align: 'right',
    	width:150,
    	dataIndex:'type'
	}],
    loader:detailTreeLoader,
    root:detailTreeRoot
});
 //�������򣨽���
     new Ext.tree.TreeSorter(detailReport, {   
              property:'code',
              folderSort: false,  
              dir:'asc'          
        }); 
//============================================================