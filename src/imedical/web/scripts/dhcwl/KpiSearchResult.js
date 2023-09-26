(function(){
	Ext.ns("dhcwl.mkpi.KpiSearchResult");
})();

dhcwl.mkpi.KpiSearchResult=function(){
    var editor = new Ext.ux.grid.RowEditor({
        saveText: '保存',
        cancelText: '取消',
        clicksToEdit:2
    });			//调用 RowEditor.js中的initComponent

	var sm = new Ext.grid.CheckboxSelectionModel();	
	
	//var actTreeCode="";		//保存报表节点的父节点。
    var rec = Ext.data.Record.create([
    {
        name: 'type',
        type: 'string'
    },{
        name: 'RowID',
        type: 'string'
    }, {
        name: 'Code',
        type: 'string'
    }, {
        name: 'Name',
        type: 'string'
    },{
        name: 'Desc',
        type: 'string'
    },{
        name: 'Path',
        type: 'string'
    },{ name: 'TreeCode',
        type: 'string'
    },{
        name: 'RptCode',
        type: 'string'
    },{
        name: 'DatasetCode',
        type: 'string'
    }]);

    var columns =  [
	new Ext.grid.RowNumberer(),
	 sm,
    {
    	header: "类型", 
    	width: 40, 
    	sortable: true, 
    	dataIndex: 'type',
    	id: 'type', 
    	editor: {
                xtype: 'textfield',
                disabled: true,
                allowBlank: true
             }
    },{
    	header: "编码", 
    	width: 100, 
    	sortable: true, 
    	dataIndex: 'Code',
    	id: 'Code', 
    	editor: {
                xtype: 'textfield',
                allowBlank: true
             }
    },{
    	header: "描述", 
    	width: 100, 
    	sortable: true, 
    	dataIndex: 'Desc',
    	id: 'Desc', 
    	editor: {
                xtype: 'textfield',
                allowBlank: true
             }
   	},{header: "位置", 
   		width: 150, 
   		sortable: true, 
   		dataIndex: 'Path',
   		id: 'path'
	}];
	
	
	var Proxy=new Ext.data.HttpProxy({url:"dhcwl/kpi/kpisearchresult.csp?action=getNode"});
    var store = new Ext.data.GroupingStore({
        //id:"rptCfgStore",
        reader: new Ext.data.JsonReader({
             	totalProperty: 'totalNum',
            	root: 'root',       	
        		fields: rec}),
            	/*
            	fields:[
           		{name: 'RptCfg_RowID'},
            	{name: 'RptCfg_Code'},
            	{name: 'RptCfg_Desc'},
            	{name: 'RptCfg_URL'}      	
            	]}),
            	*/
        proxy: Proxy      
     });


    var grid = new Ext.grid.GridPanel({
    	//id:"rptCfgGridPanel",
        store: store,
        //hidden :true,
        height: 560,
        autoExpandColumn: 'Desc',
        plugins: [editor],
        view: new Ext.grid.GroupingView({
            markDirty: false
        }),
        /*
        bbar:new Ext.PagingToolbar({
            pageSize: 10,
            store: store,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),     
        */   
        sm: sm,
       	viewConfig: {
			forceFit: true
		},
        columns: columns
    });

		
		

    
 	this.getSearchResultPanel=function(){
		return grid;
	}   
	
  		
  		
}