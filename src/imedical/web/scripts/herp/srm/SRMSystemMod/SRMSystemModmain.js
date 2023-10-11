

//配置数据源
var itemGridUrl = '../csp/herp.srm.SRMSystemModexe.csp';
var itemGridProxy = new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,//定义一个url的访问请求
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'code',
			'name'
		]),
	    remoteSort: true
});

//设置的分页-右下角
dhc.herp.PageSizePlugin = function() {
	dhc.herp.PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40//右下角页面显示数据条数框的宽度
			});
};


Ext.extend(dhc.herp.PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});

//定义分页刷新
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 20,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		plugins : new dhc.herp.PageSizePlugin(),
		emptyMsg: "没有数据"//,

});

//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

//数据显示列表cm—定义输出数据列表
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
            id:'code',
            header: '系统模块号',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'code'
       }, {
            id:'name',
            header: '系统模块名称',
            allowBlank: false,
            width:120,
            editable:false,
            dataIndex: 'name'
       }
			    
]);


	
	



//工具条按钮tbar---定义功能按钮
var addButton = new Ext.Toolbar.Button({
					text : '新增',
					//tooltip : '增加',
					iconCls : 'edit_add',
					handler : function() {
						SRMSystemModAddFun();
					}
				});

var itemGrid = new Ext.grid.GridPanel({
		    region: 'center',
		    title: '系统模块信息维护',
			iconCls: 'list',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.SRMSystemModexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,/*数据来源store*/
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton],/*这里添加的是按钮-工具条按钮tbar*/
			bbar:itemGridPagingToolbar/*这里添加的是下面分页和刷新的-分页刷新bbar*/
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
