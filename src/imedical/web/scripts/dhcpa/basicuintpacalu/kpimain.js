//================定义部分全局变量============================
//添加或者修改标志
var type="";
//表达式(控件)
var expreField="";
//表达式描述(控件)
var expreDescField="";
//表达式描述(变量)
var expreDesc="";
//用于表达式的存储
var globalStr3="";
//用于表达式的显示
var globalStr="";
//用于表达式的退格处理
var globalStr2="";
//============================================================

//================定义获取要操作节点的函数====================
//获取要操作的节点
var getNode = function(){
    //alert("node="+kpiGrid.getSelectionModel().getSelectedNode());
	return kpiGrid.getSelectionModel().getSelectedNode(); 
};
//============================================================

//================定义ColumnTree的相关信息====================
//树形结构导入器
var kpiTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//加载前事件
kpiTreeLoader.on('beforeload', function(kpiTreeLoader,node){

	if(kpiTreeRoot.value!="undefined" && "undefined" != typeof schemmainrowid){
	     //alert(node.id);
		//var url='dhc.pa.schemexe.csp?action=findkpi&schem='+initemrowid;
		var url='dhc.pa.basicuintpacaluexe.csp?action=kpilist&schem='+schemmainrowid;
		kpiTreeLoader.dataUrl=url+"&parent="+node.id;
	}
});
//树形结构的根
var kpiTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'指标选择',
	value:'',
	expanded:false
});
//收缩展开按钮
var colButton = new Ext.Toolbar.Button({
	text:'全部收缩',
	tooltip:'点击全部展开或关闭',
	listeners:{click:{fn:kpiGridControl}}
});
//收缩展开动作执行函数
function kpiGridControl(){
	if(colButton.getText()=='全部展开'){
		colButton.setText('全部收缩');
		kpiGrid.expandAll();
	}else{
		colButton.setText('全部展开');
		kpiGrid.collapseAll();
	}
}
//树型结构定义
var kpiGrid = new Ext.tree.ColumnTree({
    region:'west',
	id:'kpiGrid',
	width:400,
    rootVisible:true,
    autoScroll:true,
    title: '指标管理',
	columns:[{
    	header:'指标名称',
    	align: 'right',
    	width:280,
    	dataIndex:'name'
	}],
    loader:kpiTreeLoader,
    root:kpiTreeRoot,
	listeners:{click:{fn:nodeClicked}}
});
//============================================================


//点击节点事件
function nodeClicked(node){
	
	if(node.attributes.isEnd=="Y"){
	    var isEnd = node.attributes.isEnd;
		var kpidr = node.attributes.id;
		
		var rowObj = itemGrid.getSelectionModel().getSelections();
		//console.log(rowObj[0]);
	    var schemmainrowid = rowObj[0].get("schemrowid");
	    
        var period = rowObj[0].get("checkperiod");
		if(schemmainrowid==""){
			Ext.Msg.show({title:'注意',msg:'请选择方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		if((kpidr=="")||(kpidr=="null")){
			Ext.Msg.show({title:'注意',msg:'请选择指标!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}
		jxunitGrid.load({params:{schemrowid:schemmainrowid,kpidr:kpidr,period:period,start:0,limit:25}});
		
	}else{
		Ext.Msg.show({title:'注意',msg:'非叶子节点,不能查看!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}
}