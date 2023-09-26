///////////////////////////////////////////////////

var tmpData="";

var itemGridUrl = '../csp/dhc.pa.kpiSchemexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'code',
			'name',
			'shortcut',
			'frequency',
			'desc'
		]),
	    remoteSort: true
});



var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid','code');

var tmpTitle='自查定义设置';	
	
//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        new Ext.grid.CheckboxSelectionModel({singelSelect:false}),
        {

            id:'rowid',
            header: '自查项目ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{

            id:'code',
            header: '编号',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'code'
       }, {
            id:'name',
            header: '名称',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'name'
            						
       }, {
            id:'shortcut',
            header: '缩写',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'shortcut'			
            
       }, {
            id:'frequency',
            header: '报告频率',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'frequency'
           
       }, {
            id:'desc',
            header: '概述',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'desc'
            
       }
			    
]);


var addButton = new Ext.Toolbar.Button({
					text : '添加',
					tooltip : '添加',
					iconCls : 'add',
					handler : function() {
						kpischemAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler : function() {
						kpischemEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				//var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
				return;
				} else {
					
					
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							for(var i = 0; i < len; i++){   
				        	 var tmpRowid=rowObj[i].get("rowid");
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGridDs.load({
													params : {
														start : 0,
														limit : itemGridPagingToolbar.pageSize
													}
												});
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
						}
					})
				}
			
		}
});

var itemGrid = new Ext.grid.GridPanel({
			
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.pa.kpiSchemexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.CheckboxSelectionModel(),
			loadMask: true,
			tbar:[addButton,'-',editButton,'-',delButton],
			bbar:itemGridPagingToolbar
			

});

itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
  
