////自查汇总统计

var projUrl = 'dhc.qm.checkuserexe.csp';
var itemGridUrl = '../csp/dhc.qm.checkuserexe.csp';
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'CheckDr',
			'name',
			'active'
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

var codefield = new Ext.form.TextField({
	id: 'codefield',
	fieldLabel: '编码',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'codefield',
	minChars: 1,
	pageSize: 10,
	editable:true	
});
var namefield = new Ext.form.TextField({
	id: 'namefield',
	fieldLabel: '姓名',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'namefield',
	minChars: 1,
	pageSize: 10,
	editable:true	
});

var querypanel = new Ext.FormPanel({
			height:50,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
			items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						xtype:'displayfield',
						value:'姓名:',
						columnWidth:.05
					},
					namefield,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						columnWidth:0.05,
						xtype:'button',
						text: '查询',
						handler:function(b){
							query();
						},
						iconCls:'find'
					}	
		     	]
			}]
});
 var query=function(){	
		var name = namefield.getValue();
		itemGridDs.proxy = new Ext.data.HttpProxy({   	
								url : 'dhc.qm.checkuserexe.csp?action=list&name='+encodeURIComponent(name),							
								method : 'GET'
								});		
		itemGridDs.load({
						params : {
							start : 0,
							limit : itemGridPagingToolbar.pageSize,
							dir:'',
							sort:''
						}
		});				
	};
var addButton = new Ext.Toolbar.Button({
					text : '添加',
					iconCls:'add',
					handler : function() {
						 addfun();
				   }
  });
var updateButton = new Ext.Toolbar.Button({
					text : '修改',
					iconCls:'update',
					handler : function() {
						 updatefun();
				   }
  });
var delButton = new Ext.Toolbar.Button({
					text : '删除',
					iconCls : 'delete',//指定css样式
					//icon : '../scripts/herp/srm/common/icons/delete.gif',指定路径
					handler : function() {
						 delfun();
				   }
 });
	//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        //new Ext.grid.CheckboxSelectionModel ({singleSelect : false}),
        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {

            id:'name',
            header: '名称',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'name'
       }, {

            id:'active',
            header: '是否有效',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'active'
       }
]);

var itemGrid = new Ext.grid.GridPanel({
		    region: 'center',
		    layout:'fit',
		    //width:400,
		    height:575,
		    //autoHeight:true,//若只显示一条数据，则设置此项
		    readerModel:'local',
		    url: 'dhc.qm.checkuserexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.CheckboxSelectionModel ({singleSelect : true}), 
			loadMask: true,
			tbar:[addButton,'-',updateButton,'-',delButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
})