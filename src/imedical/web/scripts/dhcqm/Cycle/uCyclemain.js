var itemGridUrl = '../csp/dhc.qm.uCycleexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'Rowid',
			'Cyclecode',
			'Cyclename',
			'Cycleactive'
			
		]),
	    remoteSort: true
});

//添加复选框
var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('Rowid', 'Cyclename');
//查询机构等级编码

var uCodedField = new Ext.form.TextField({
	id: 'uCodedField',
	fieldLabel: '年度代码',
	width:100,
	listWidth : 245,
	
	triggerAction: 'all',
	emptyText:'',
	name: 'uCodedField',
	minChars: 1,
	pageSize: 10,
	editable:false
});
//查询机构等级名称

var uNamedField = new Ext.form.TextField({
	id: 'uNamedField',
	fieldLabel: '年度名称',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'uNamedField',
	minChars: 1,
	pageSize: 10,
	editable:true
});




var tmpTitle='年度';

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
    sm,
        new Ext.grid.RowNumberer(), 
        {

            id:'Rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Rowid',
            hidden:'true'
           
       }, {
            id:'Cyclecode',
            header: '年度代码',
            
            allowBlank: false,
            width:100,
           editable:false,
           
            dataIndex: 'Cyclecode'
            
       }, {
            id:'Cyclename',
            header: '年度名称',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Cyclename'
            
       }, {
            id:'Cycleactive',
            header: '是否有效',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Cycleactive'
          
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '添加',
					tooltip : '添加',
					iconCls : 'add',
					handler : function() {
						sysorgaffiaddFun();
					}
				});
var editButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler : function() {
						SRMSystemModEditFun();
					}
				});

var delButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'remove',
			handler : function() {
				var records = itemGrid.getSelectionModel().getSelections();
				var len = records.length;
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
					
					//tmpRowid = records[0].get("Rowid");
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							for(var i = 0; i < len; i++){
							Ext.Ajax.request({												      
								url : itemGridUrl + '?action=del&rowId=' + records[i].get("Rowid"),
					       
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
//查询功能
var SearchButton = new Ext.Toolbar.Button({
    text: '查询', 
    tooltip:'查询',        
    iconCls:'find',
	handler:function(){	

	    var Code= uCodedField.getValue();
                        var Name = uNamedField.getValue();
       
	itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,Cyclecode:Code,Cyclename:Name}}));
	
	}
});
var itemGrid = new Ext.grid.GridPanel({
			//title: '系统模块定义',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.qm.uCycle.csp',
		    //atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			tbar:['年度code','-',uCodedField,'-','年度名称','-',uNamedField,'-',SearchButton,'-',addButton,'-',delButton,'-',editButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});




