//自查管理
var DSDrowid="";
var projUrl = 'dhc.pa.Selfmanageexe.csp';
var itemGridUrl = '../csp/dhc.pa.Selfmanageexe.csp';
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,     //rowid^code^name^frequency^periodTypeName^shortcut^desc^isStop
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'code',
			'name',
			'frequency','periodTypeName','isStop','desc','shortcut'	
		]),
	    remoteSort: true
	    //与排序相关的参数还有remoteSort，这个参数是用来实现后台排序功能的。当设置为 remoteSort:true时，store会在向后台请求数据时自动加入sort和dir两个参数，分别对应排序的字段和排序的方式，由后台获取并处理这两个参数，在后台对所需数据进行排序操作。remoteSort:true也会导致每次执行sort()时都要去后台重新加载数据，而不能只对本地数据进行排序。
});
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 20,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');


//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
       // new Ext.grid.CheckboxSelectionModel ({singleSelect : false}),
		
        {

            id:'rowid',
            header: '用户ID',
            allowBlank: false,
            width:200,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{

            id:'code',
            header: '自查代码',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'code'
           
       },{

            id:'name',
            header: '自查名称',
            allowBlank: false,
           // width:200,
            editable:false,
            dataIndex: 'name'
       },{

            id:'periodTypeName',
            header: '考核频率',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'periodTypeName'
       } ,{

            id:'isStop',
            header: '停用',
            allowBlank: false,
            width:50,
            editable:false,
            dataIndex: 'isStop',
	        renderer : function(v){
				return (v=='Y'?'<span style="color:red;">是<span>':'否');
		} 
       },{

            id:'desc',
            header: '描述',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'desc'
       },{

            id:'shortcut',
            header: '缩写',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'shortcut'
       }      
]);

function trim(str){
	var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
var addButton = new Ext.Toolbar.Button({
					text : '添加',
					iconCls : 'add',
					handler : function() {
						 kpischemAddFun();
						 
				   }
  	});
var altButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler : function() {
						kpischemEditFun();
					}
				});
/*var altButton = new Ext.Toolbar.Button({
					text : '修改',
					iconCls : 'add',
					handler : function() {
						var rowObj = itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						var tmpRowid = "";
		
						if (len < 1) {
							Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
						return;
						}; 
						if(len >=2){
							Ext.Msg.show({
								title : '注意',
								msg : '请重新选择需要修改的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
						return;
						}else{					
							tmpRowid=rowObj[i].get("rowid");
							Alertfun(tmpRowid);
						}
					}
  	});*/
 
var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if (len < 1) {
			Ext.Msg.show({title : '注意',msg : '请选择需要删除的数据!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
			return;
		} else {
			Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
				if (btn == 'yes') {
					for(var i = 0; i < len; i++){   
		        	    var tmpRowid=rowObj[i].get("rowid");
						Ext.Ajax.request({
							url : '../csp/dhc.pa.Selfmanageexe.csp?action=del&rowid=' + tmpRowid,
							waitMsg : '删除中...',
							failure : function(result, request) {
								Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({title : '注意',msg : '操作成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
									itemGridDs.load({params : {start : 0,limit : itemGridPagingToolbar.pageSize}});
								} else {
									Ext.Msg.show({title : '错误',msg : '错误',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
								}
							},
							scope : this
						});
					}
				}
			});
		}
	}
});

var stopButton = new Ext.Toolbar.Button({
	text : '停用',

	iconCls : 'remove',
	handler : function(){
		stopFun(itemGrid,itemGridDs,itemGridPagingToolbar,"stop");
	}
});
var activeButton = new Ext.Toolbar.Button({
	text : '启用',
	iconCls : 'add',
	handler : function(){
		stopFun(itemGrid,itemGridDs,itemGridPagingToolbar,"active");
	}
});

var itemGrid = new Ext.grid.GridPanel({
		    layout:'fit',
		    //width:400,
		    height:Ext.getBody().getHeight()-30,
		    //autoHeight:true,//若只显示一条数据，则设置此项
		    readerModel:'local',
		    url: 'dhc.pa.Selfmanageexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,//表格的列模式，渲染表格时必须设置该配置项
			trackMouseOver: true,
			stripeRows: true,//表格是否隔行换色，默认为false 
			autoExpandColumn :'name',
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:true}), 
			loadMask: true,//是否在加载数据时显示遮罩效果，默认为false 
			tbar:[addButton,'-',altButton/*,'-',stopButton,'-',activeButton,delButton*/],
			bbar:itemGridPagingToolbar,
				listeners:{  
         			render:function(){  
       				var hd_checker = this.getEl().select('div.x-grid3-hd-checker');  
         				if (hd_checker.hasClass('x-grid3-hd-checker')) {     
                			hd_checker.removeClass('x-grid3-hd-checker'); // 去掉全选框   
            			}   
        			}  
			} 
			
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
})
 itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e){
 	var records = itemGrid.getSelectionModel().getSelections();
 	//if (columnIndex == 4){
 		var rowid  = records[0].get("rowid");
 		DSDrowid = rowid;
 		detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
				if(detailTreeRoot.value!="undefined"){
						var url="../csp/dhc.pa.Selfmanageexe.csp?action=listtree";
						detailTreeLoader.dataUrl=url+"&parent="+node.id+"&rowid="+DSDrowid;
				}
 		})
 		Ext.getCmp("detailReport").root.reload();
 	//}
 });
//================定义获取要操作节点的函数====================
//获取要操作的节点
var getNode = function(){
	return detailReport.getSelectionModel().getSelectedNode(); 
}
//============================================================

//================定义工具栏以及添加、修改、删除按钮==========
//添加按钮
var addButton=new Ext.Toolbar.Button({
	text:'添加自查明细',
	tooltip:'添加自查明细',
	iconCls: 'add',
	handler:function(){
		addFun(getNode(),DSDrowid);
	}
});
//修改按钮
var updateButton=new Ext.Toolbar.Button({
	text:'设置扣分系数',
	tooltip:'设置扣分系数',
	iconCls: 'add',
	handler:function(){
		updateFun(getNode());
	}
});
//删除按钮
var delButton=new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls: 'add',
	handler:function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var schemId=rowObj[0].get("rowid");
	
		delFun(getNode(),schemId);
	}
});

//工具栏
var menubar = [addButton,'-',updateButton,'-',delButton];
//============================================================

//================定义ColumnTree的相关信息====================
//树形结构导入器
var detailTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	clearOnLoad:true,
    uiProviders:{
    	'col': Ext.tree.ColumnNodeUI
    }
});
//加载前事件
detailTreeLoader.on('beforeload', function(detailTreeLoader,node){
	if(detailTreeRoot.value!="undefined"){
		var url="../csp/dhc.pa.Selfmanageexe.csp?action=listtree";
		detailTreeLoader.dataUrl=url+"&parent="+node.id+"&rowid="+DSDrowid;
	}
});
//树形结构的根
var detailTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'项目管理',
	value:'',
	expanded:false
});
//收缩展开按钮
/*var colButton = new Ext.Toolbar.Button({
	text:'全部收缩',
	tooltip:'点击全部展开或关闭',
	listeners:{click:{fn:detailReportControl}}
});
//收缩展开动作执行函数
function detailReportControl(){
	if(colButton.getText()=='全部展开'){
		colButton.setText('全部收缩');
		detailReport.expandAll();
	}else{
		colButton.setText('全部展开');
		detailReport.collapseAll();
	}
};*/

//树型结构定义
var detailReport = new Ext.tree.ColumnTree({
	id:'detailReport',
	title: '自查项目维护',
	height:Ext.getBody().getHeight()-30,
    rootVisible:true,
    autoScroll:true,
	columns:[
	
	{
    	header:'项目名称',
    	align: 'right',
    	width:150,
    	dataIndex:'name'
	},
	
	{
    	header:'项目代码',
    	width:100,
    	dataIndex:'code'
	},
	{
    	header:'顺序号',
    	align: 'right',
    	width:100,
    	dataIndex:'order'
	}
	,{
    	header:'项目类别',
    	align: 'right',
    	width:100,
    	dataIndex:'type'
	},{
    	header:'扣分系数',
    	align: 'right',
    	width:100,
    	dataIndex:'rate'
	}],
    loader:detailTreeLoader,
    root:detailTreeRoot
});
 //树的排序（降序）
     new Ext.tree.TreeSorter(detailReport, {   
              property:'code',
              folderSort: false,  
              dir:'asc'          
        }); 

