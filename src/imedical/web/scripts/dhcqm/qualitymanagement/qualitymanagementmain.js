var itemGridUrl = '../csp/dhc.qm.qualityinfomanagementexe.csp';
var userid=session['LOGON.USERID'];

//配件数据源
//var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=listNew'});
var self=this;
//选中单元格的值
var selectedcell;
//选中单元格的列名称
var selectedcellfieldname;
//获取单元格列数
var columnnumber;

var columns = [];
var itemGridDs={};
var itemGridCm = new Ext.grid.ColumnModel(columns);


//itemGridPagingToolbar.doRefresh=dosearch();
var addButton = new Ext.Toolbar.Button({
					text : '添加',
					tooltip : '添加',
					iconCls : 'add',
					handler : function() {
						srmdeptuserAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler : function() {
						doedit();
					}
				});
var delButton = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '删除',
					iconCls : 'remove',
					handler : function() {
						
					}
				});
				
		
var pageBar = new Ext.PagingToolbar({
            store: itemGridDs,
			pageSize:limit,
            displayInfo: true,
            displayMsg: '当前显示第 {0} - {1} 条，总共 {2}条',
            emptyMsg: "没有数据"
        });		
				
	/* var editor = new Ext.ux.grid.RowEditor({
        saveText: 'Update'
    });	*/
var itemGrid = new Ext.grid.GridPanel({
			//title: '科室信息维护',
		    region: 'center',
		    loadMask: true,
		    layout:'fit',
			width:400,
		    readerModel:'local',
		   	url: 'dhc.qm.qualityinfomanagementexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			bbar : pageBar,
			columnLines:true//,//列分隔线
			
			
		
 
});
function getcellvalue(data,fieldName,columnIndex){

	selectedcell=data;
	selectedcellfieldname=fieldName;
	columnnumber=columnIndex;
};

var cellclick=function(grid, rowIndex, columnIndex, e) {
    var record = grid.getStore().getAt(rowIndex);  // Get the Record
    var fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
    var data = record.get(fieldName);
	//设置被选择的样式
	var selectObj = e.target;
	if(selectObj.nodeName=='DIV'){
		$("div[class^='x-grid3-cell-inner x-grid3-col-']").attr("style","white-space:normal;");
		$(selectObj).attr("style","border:2px solid #8CB2E5;white-space:normal;");
	}
    getcellvalue(data,fieldName,columnIndex);
	
};
itemGrid.addListener('cellclick',cellclick);

