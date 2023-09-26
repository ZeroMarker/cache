(function(){
	Ext.ns("dhcwl.RptMgmt.SearchMenuCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.SearchMenuCfg=function(pObj){
	var serviceUrl="dhcwl/rptmgmt/searchmenucfg.csp";
	var outThis=this;
	var actParam=new Object();

	
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getMenuCfg'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'MenuName'},
				{name:'RaqName'},
				{name:'CSPName'}
			]
    	})
    });
	
		
	var columnModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 100,
                sortable: true
            },
            columns: [
				new Ext.grid.RowNumberer(),
				{header:'菜单名称',dataIndex:'MenuName', width: 150},
				{header:'菜单表达式',dataIndex:'RaqName', width: 150},
				{header:'CSP名称',dataIndex:'CSPName', width: 150}	
			]
	});
	
	

    var searchMenuGrid = new Ext.grid.GridPanel({
        store: store,
        cm: columnModel,
        viewConfig: {
            forceFit:true
        }, 		
        tbar:new Ext.Toolbar({
        	layout: 'hbox',
        	items : [		
			'菜单名称:',
			{
				name:'MenuName',
				//width: 100,	
				xtype:'textfield'	
			},
			"-",
			"Raq名称:",
			{
				name:'RaqName',
				value:'raq',
				xtype:'textfield'
			},			
			"-",
			"CSP名称:",
			{
				name:'CSPName',
				xtype:'textfield'
			},{
				text: '<span style="line-Height:1">查询</span>',
				icon   : '../images/uiimages/search.png',	
				xtype:'button',
				handler:OnSearch
			},	
			"-",
			{
				text: '<span style="line-Height:1">清空</span>',					
				icon   : '../images/uiimages/clearscreen.png',
				xtype:'button',
				handler:OnReset			
			}				
				
			]
		}),			
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:store,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
    });	
	searchMenuGrid.getStore().setBaseParam("RaqName",'raq');	
	searchMenuGrid.getStore().load({params:{start:0,limit:50}});
	/*
	searchMenuGrid.getStore().on('load',function(store, records, options ){
		alert(searchMenuGrid.getBottomToolbar().cursor);
	});
	*/
	searchMenuGrid.on('rowdblclick' ,function(grid,  rowIndex, e ) {
		var selRec=grid.getStore().getAt(rowIndex);
		var outParam=new Object();
		outParam.MenuName=selRec.get('MenuName');
		outParam.RaqName=selRec.get('RaqName');
		outParam.CSPName=selRec.get('CSPName');
		if (!!outThis.OnMenuCfgCallback) outThis.OnMenuCfgCallback(outParam);
		searchMenuWin.close();
	});
	var searchMenuWin=new Ext.Window({
        width:700,
		height:600,
		title:'HIS菜单数据',
		layout:'fit',	
		items: searchMenuGrid,
		buttons: [
		{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWins
		}]		
		
    });
	
	

	function CloseWins() {
		doCallBack();
		searchMenuWin.close();
	};
	
	function doCallBack() {
		if (searchMenuGrid.getSelectionModel().getCount() >0) {
			
			var selRec=searchMenuGrid.getSelectionModel().getSelected();
			var outParam=new Object();
			outParam.MenuName=selRec.get('MenuName');
			outParam.RaqName=selRec.get('RaqName');
			outParam.CSPName=selRec.get('CSPName');
			if (!!outThis.OnMenuCfgCallback) outThis.OnMenuCfgCallback(outParam);
		}		
		
	};
	
	function OnSearch() {
		//1、得到页面查询值
		var menuNameInx=searchMenuGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=searchMenuGrid.getTopToolbar().items.itemAt(menuNameInx).getValue();
		var raqNameInx=searchMenuGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=searchMenuGrid.getTopToolbar().items.itemAt(raqNameInx).getValue();
		var cSPNameInx=searchMenuGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=searchMenuGrid.getTopToolbar().items.itemAt(cSPNameInx).getValue();
		
		//2、设置查询参数
		searchMenuGrid.getStore().setBaseParam("MenuName",MenuName);	
		searchMenuGrid.getStore().setBaseParam("RaqName",RaqName);	
		searchMenuGrid.getStore().setBaseParam("CSPName",CSPName);	
		searchMenuGrid.getStore().reload({params:{start:0,limit:50}});
	}
	
	function OnReset() {
		var menuNameInx=searchMenuGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=searchMenuGrid.getTopToolbar().items.itemAt(menuNameInx).setValue("");
		var raqNameInx=searchMenuGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=searchMenuGrid.getTopToolbar().items.itemAt(raqNameInx).setValue("");
		var cSPNameInx=searchMenuGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=searchMenuGrid.getTopToolbar().items.itemAt(cSPNameInx).setValue("");
		
		//2、设置查询参数
		searchMenuGrid.getStore().setBaseParam("MenuName","");	
		searchMenuGrid.getStore().setBaseParam("RaqName","");	
		searchMenuGrid.getStore().setBaseParam("CSPName","");		
		
	}
	
    this.getSearchMenuWin=function(){
    	return searchMenuWin;
    }  


}

