/////////////////////////////////////////////////

var itemGridUrl = 'dhc.bonus.uBonusEmpReportexe.csp';

//列出所有数据的调用方法
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});

//配件数据源
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'RowId',
			'BonusEmployeeID',
			'EmployeeName',
			'BonusReportID',
			'ReportName',
			'UpdateDate'
		]),
	    remoteSort: true
});

//根据页面数据个数pageSize确定页数，PagingToolbar设置每页条数的控件
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('RowId');

	
//ColumnModel表格列模式
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'RowId', 
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            sortable:true,
            dataIndex: 'RowId'   
                                 
       }, {
            id:'BonusEmployeeID',
            header: '人员名称', 
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            sortable:true,
            dataIndex: 'BonusEmployeeID'
       }, {
            id:'EmployeeName',
            header: '人员名称', 
            allowBlank: false,
            width:100,
            editable:false,
            sortable:true,
            dataIndex: 'EmployeeName'
       }, {
            id:'BonusReportID',
            header: '报表名称', 
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            sortable:true,
            dataIndex: 'BonusReportID'
       },{
            id:'ReportName',
            header: '报表名称', 
            allowBlank: false,
            width:160,
            editable:false,
            sortable:true,
            dataIndex: 'ReportName'
       }, {
            id:'UpdateDate',
            header: '修改时间',
            allowBlank: false,
            width:130,
            editable:false,
            sortable:true,
            dataIndex: 'UpdateDate'
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '添加',
					tooltip : '添加',  //鼠标放在按钮上时页面自动显示的内容
					iconCls : 'add',   //按钮的图标
					handler : function() {
						BonusEmpReportAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler : function() {
						BonusEmpReportEditFun();
					}
				});
				
var delButton = new Ext.Toolbar.Button({
			        text : '删除',
					tooltip : '删除',
					iconCls : 'remove',
					handler : function() {
					BonusEmpReportDelFun()
					}
				});

//标题网格
var itemGrid = new Ext.grid.GridPanel({
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.bonus.uBonusEmpReportexe.csp',
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
