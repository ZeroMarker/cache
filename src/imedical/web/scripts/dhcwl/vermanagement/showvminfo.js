dhcwl.vermanagement.showvninfo = function(hisID){
   var serviceUrl="dhcwl/VerManagement/vmservice.csp";
   var outThis=this
   var columnModelhis = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'hisID',sortable:true, width: 30, sortable: true,menuDisabled : true},
        {header:'产品名称',dataIndex:'hisName',sortable:true, width: 80, sortable: true,menuDisabled : true},
        {header:'产品版本',dataIndex:'hisCode', width: 60, sortable: true,menuDisabled : true},
        {header:'产品作者',dataIndex:'hisTSName', width: 60, sortable: true,menuDisabled : true},
        {header:'发布日期',dataIndex:'hisUpDate', width: 80, sortable: true,menuDisabled : true},
		{header:'安装日期',dataIndex:'hisInstallDate', width: 80, sortable: true,menuDisabled : true},
		{header:'安装时间',dataIndex:'hisInstallTime', width: 80, sortable: true,menuDisabled : true},
		{header:'备注',dataIndex:'hisRemarks', width: 900, sortable: true,menuDisabled : true}
    ]);
	var storehis = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=hisdetail&ID='+hisID}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'hisID'},
            	{name: 'hisName'},
				{name: 'hisCode'},
            	{name: 'hisTSName'},
            	{name: 'hisUpDate'},
            	{name: 'hisInstallDate'},
				{name: 'hisInstallTime'},
				{name: 'hisRemarks'}
       		]
    	})
    });
    storehis.load()
	
	var vmhistoryGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:480,
        store: storehis,
        cm: columnModelhis
		});

	var wvinfoWin = new Ext.Window({
	    renderTo:Ext.getbody,
		title:'历史数据明细',
		id:'vmItem',
		layout : 'table',
		modal:true,                
		resizable:true,
		maxinizable:true,
		maximizable:true,
	    width:550,
		height:500,
		items:vmhistoryGrid
	});
	
	this.wvinfoWin = function(){
		wvinfoWin.show();
	}
	}