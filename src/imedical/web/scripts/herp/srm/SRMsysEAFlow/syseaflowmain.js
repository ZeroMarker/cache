/////////////////////////////////////////////////

//var itemGridUrl = '../csp/herp.srm.syseaflowexe.csp';
var itemGridUrl = 'herp.srm.syseaflowexe.csp';

//列出所有数据的调用方法
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});

//配件数据源
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'TypeID',
			'Type',
			'SysModuleID',
			'SysModuleName',
			'EAFMDr',
			'EAFMName'
		]),
	    remoteSort: true
});

Ext.ns("dhc.herp");
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
				width : 40
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
		
//根据页面数据个数pageSize确定页数，PagingToolbar设置每页条数的控件
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
itemGridDs.setDefaultSort('rowid');

	
//ColumnModel表格列模式
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            //id:'rowid',  //id可不写，其他列也是如此
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            //sortable:true,
            dataIndex: 'rowid'   //传到...exe.csp中的$Get(%request.Data("rowid",1))
                                 // 需与后台中的jsonTitle="rowid^SysModuleID^EAFMDr"一致
       },{
            id:'TypeID ',
            header: '类型ID', //如何把该字体变大 ????
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            //sortable:true,
            dataIndex: 'TypeID'
       }, 
       {
            id:'Type',
            header: '类型', //如何把该字体变大 ????
            allowBlank: false,
            width:80,
            editable:false,
            //sortable:true,
            dataIndex: 'Type'
       },  {
            id:'SysModuleID',
            header: '系统模块名称', //如何把该字体变大 ????
            allowBlank: false,
            width:200,
            editable:false,
            hidden:true,
            //sortable:true,
            dataIndex: 'SysModuleID'
       }, 
       {
            id:'SysModuleName',
            header: '系统模块名称', //如何把该字体变大 ????
            allowBlank: false,
            width:180,
            editable:false,
            //sortable:true,
            dataIndex: 'SysModuleName'
       }, {
            id:'EAFMDr',
            header: '审批流名称',
            allowBlank: false,
            width:180,
            editable:false,
            //sortable:true,
            hidden:true,
            dataIndex: 'EAFMDr'
       }, {
            id:'EAFMName',
            header: '审批流名称',
            allowBlank: false,
            width:180,
            editable:false,
            //sortable:true, 
            dataIndex: 'EAFMName'
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '新增',
					//tooltip : '增加',  //鼠标放在按钮上时页面自动显示的内容
					iconCls : 'edit_add',   //按钮的图标
					handler : function() {
						syseaflowAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls : 'pencil',
					handler : function() {
						syseaflowEditFun();
					}
				});
				
var delButton = new Ext.Toolbar.Button({
			        text : '删除',
					//tooltip : '删除',
					iconCls : 'edit_remove',
					handler : function() {
					syseaflowdelFun()
					}
				});

//标题网格
var itemGrid = new Ext.grid.GridPanel({
			title: '业务审批流信息维护',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.syseaflowexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,  //实现鼠标在行经过时的轨迹效果
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
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
