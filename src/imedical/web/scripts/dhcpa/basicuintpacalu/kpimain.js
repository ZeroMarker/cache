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
var globalStr2="";
//============================================================

//================�����ȡҪ�����ڵ�ĺ���====================
//��ȡҪ�����Ľڵ�
var getNode = function(){
    //alert("node="+kpiGrid.getSelectionModel().getSelectedNode());
	return kpiGrid.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================����ColumnTree�������Ϣ====================
//���νṹ������
var kpiTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//����ǰ�¼�
kpiTreeLoader.on('beforeload', function(kpiTreeLoader,node){

	if(kpiTreeRoot.value!="undefined" && "undefined" != typeof schemmainrowid){
	     //alert(node.id);
		//var url='dhc.pa.schemexe.csp?action=findkpi&schem='+initemrowid;
		var url='dhc.pa.basicuintpacaluexe.csp?action=kpilist&schem='+schemmainrowid;
		kpiTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//���νṹ�ĸ�
var kpiTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'ָ��ѡ��',
	value:'',
	expanded:false
});
//����չ����ť
var colButton = new Ext.Toolbar.Button({
	text:'ȫ������',
	tooltip:'���ȫ��չ����ر�',
	listeners:{click:{fn:kpiGridControl}}
});
//����չ������ִ�к���
function kpiGridControl(){
	if(colButton.getText()=='ȫ��չ��'){
		colButton.setText('ȫ������');
		kpiGrid.expandAll();
	}else{
		colButton.setText('ȫ��չ��');
		kpiGrid.collapseAll();
	}
}
//���ͽṹ����
var kpiGrid = new Ext.tree.ColumnTree({
    region:'west',
	id:'kpiGrid',
	width:400,
    rootVisible:true,
    autoScroll:true,
    title: 'ָ�����',
	columns:[{
    	header:'ָ������',
    	align: 'right',
    	width:280,
    	dataIndex:'name'
	}],
    loader:kpiTreeLoader,
    root:kpiTreeRoot,
	listeners:{click:{fn:nodeClicked}}
});
//============================================================


//����ڵ��¼�
function nodeClicked(node){
	
	if(node.attributes.isEnd=="Y"){
	    var isEnd = node.attributes.isEnd;
		var kpidr = node.attributes.id;
		
		var rowObj = itemGrid.getSelectionModel().getSelections();
		//console.log(rowObj[0]);
	    var schemmainrowid = rowObj[0].get("schemrowid");
	    
        var period = rowObj[0].get("checkperiod");
		if(schemmainrowid==""){
			Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		if((kpidr=="")||(kpidr=="null")){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��ָ��!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		jxunitGrid.load({params:{schemrowid:schemmainrowid,kpidr:kpidr,period:period,start:0,limit:25}});
		
	}else{
		Ext.Msg.show({title:'ע��',msg:'��Ҷ�ӽڵ�,���ܲ鿴!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
}