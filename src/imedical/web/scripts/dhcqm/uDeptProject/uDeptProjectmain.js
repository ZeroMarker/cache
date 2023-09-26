var itemGridUrl = '../csp/dhc.qm.uDeptProjectexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'Rowid',
			'QMSchemCode',
			'QMSchemname',
			'QMSchemArcitem'
			
		]),
	    remoteSort: true
});

//添加复选框
//var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('Rowid', 'QMSchemname');






var tmpTitle='科室项目设置';

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
   
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
            id:'QMSchemCode',
            header: '项目编码',
            
            allowBlank: false,
            width:100,
           editable:false,
           
            dataIndex: 'QMSchemCode'
            
       }, {
            id:'QMSchemname',
            header: '项目名称',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'QMSchemname'
            
       }, {
            id:'QMSchemArcitem',
            header: '关联医嘱',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'QMSchemArcitem'
          
       }
			    
]);



var itemGrid = new Ext.grid.GridPanel({
			//title: '绩效单位记录',
	        region: 'west',
            width: 400,
	        minSize: 350,
	        maxSize: 450,
	        split: true,
	        collapsible: true,
	        containerScroll: true,
	        xtype: 'grid',
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			viewConfig: {forceFit:true},
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){
	//单击绩效单元后刷内部人员记录
	
	if (rowIndex !=='0')
	{ 
	var selectedRow = itemGridDs.data.items[rowIndex];
   
    RowId = selectedRow.data["Rowid"];
  
	personDs.proxy = new Ext.data.HttpProxy({url:personUrl+'?action=list2&Code='+RowId});
	personDs.load({params:{start:0, limit:personPagingToolbar.pageSize}});}
});   

itemGridDs.on("beforeload",function(ds){
	personDs.removeAll();
	RowId = "";

});
	


