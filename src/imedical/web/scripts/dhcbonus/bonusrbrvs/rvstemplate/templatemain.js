/*
* 工作量主模板
* 2016-05-05 guojing
*/

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}



var TemplateUrl = '../csp/dhc.bonus.rvstemplateexe.csp';
var TemplateProxy = new Ext.data.HttpProxy({url:TemplateUrl + '?action=templatelist&start=0&limit=10'});

var TemplateDs = new Ext.data.Store({
	proxy: TemplateProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        //'rvsTemplateMainID',
        'rowid',
		'templateCode',
		'templateName',
		'useMinuteRate',
		'workRiskRate',
		'techDifficultyRate',
		'workCostRate',
		'tempDesc',
		'createUser',
		'createDate'
		
	]),
    // turn on remote sorting
    //remoteSort: true     //排序
    pruneModifiedRecords:true
});
 
 var TemplateCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '模板编码',
        dataIndex: 'templateCode',
        width: 60,		  
        sortable: true
    },{
    	header: '模板名称',
        dataIndex: 'templateName',
        width: 100,
        sortable: true
    },{
	    header: '用时权重',
        dataIndex: 'useMinuteRate',
        width: 45,
        sortable: true
	},{
    	header: '风险权重',
        dataIndex: 'workRiskRate',
        width: 45,		  
        sortable: true
    },{
    	header: '难度权重',
        dataIndex: 'techDifficultyRate',
        width: 45,
        sortable: true
    },{
	    header: '消耗权重',
        dataIndex: 'workCostRate',
        width: 50,
        sortable: true
	},{
    	header: '说明',
        dataIndex: 'tempDesc',
        width: 190,		  
        sortable: true
    },{
    	header: '创建人员',
        dataIndex: 'createUser',
        width: 60,
        sortable: true
    },{
	    header: '创建日期',
        dataIndex: 'createDate',
        width: 100,
        sortable: true
	}
    
]);


//分页工具栏
var TemplatePagingToolbar = new Ext.PagingToolbar({
    store: TemplateDs,
	pageSize:10,
    displayInfo: true,
    displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg: "没有记录"
	
});

//添加
var addButton = new Ext.Toolbar.Button({
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function(){
		templateAddFun();
		
	}
});

//修改
var editButton = new Ext.Toolbar.Button({
	text: '修改',
	tooltip: '修改',
	iconCls: 'option',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		templateEditFun();
	}
});



var copyButton = new Ext.Toolbar.Button({
	text: '复制',
	tooltip: '复制',
	iconCls: 'option',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		
		templateCopytFun();
		
	}
});



//删除
var delButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = templateMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			
			Ext.MessageBox.confirm(
				'提示', 
				'确定要删除选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: TemplateUrl + '?action=templatedel&rowid='+tmpRowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									TemplateDs.load({params:{start:0, limit:TemplatePagingToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	}
});

var templateMain = new Ext.grid.EditorGridPanel({
	title:'工作量主模板',
	region:'north',
	//region:'center',
	height:230,
	//enableTabScroll : true,
	store: TemplateDs,
	cm: TemplateCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:[addButton,'-',editButton,'-',delButton,'-',copyButton],
	bbar:TemplatePagingToolbar
});

//默认加载所有的数据 
TemplateDs.load({
	params:{start:0, limit:TemplatePagingToolbar.pageSize},
	callback:function(record,options,success ){
		templateMain.fireEvent('rowclick',this,0);
		
	}
});

var tmpSelectedTemplate='';

templateMain.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = TemplateDs.data.items[rowIndex];

	//单击主模板，刷新详细信息
	//selectedRow.data['templateCode']  templateCode必须是grid已经定义的
	tmpSelectedTemplate=selectedRow.data['rowid'];
	DetailDs.proxy = new Ext.data.HttpProxy({url: DetailUrl + '?action=detaillist&template='+tmpSelectedTemplate});
	DetailDs.load({params:{start:0, limit:DetailPagingToolbar.pageSize}});
	
});	