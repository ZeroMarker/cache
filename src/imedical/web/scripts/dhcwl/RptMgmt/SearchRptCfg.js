(function(){
	Ext.ns("dhcwl.RptMgmt.SearchRptCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.SearchRptCfg=function(pObj){
	var serviceUrl="dhcwl/rptmgmt/showmain.csp";
	var outThis=this;
	var actParam=new Object();

	
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getSavedMgmt'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'ID'},
				{name:'AdvUser'},
				{name:'AuxiliaryMenuName'},
				{name:'CSPName'},
				{name:'CreateDate'},
				{name:'Demo'},
				{name:'DepMaintainer'},
				{name:'Filter'},
				{name:'HisTableName'},
				{name:'KPIName'},
				{name:'MenuName'},
				{name:'ProMaintainer'},
				{name:'ProgramLogic'},
				{name:'QueryName'},
				{name:'RaqName'},
				{name:'RowColShow'},
				{name:'Spec'},
				{name:'UPdateDate'},
				{name:'UsedByDep'}
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
				{header:'当前页面(标题)名称',dataIndex:'AuxiliaryMenuName', width: 150},
				{header:'菜单表达式',dataIndex:'RaqName', width: 150},
				{header:'CSP名称',dataIndex:'CSPName', width: 150}	
					
			]
	});
	
	

    var searchRptGrid = new Ext.grid.GridPanel({
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
				//value:'raq',
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
	searchRptGrid.getStore().load({params:{start:0,limit:50}});

	searchRptGrid.on('rowdblclick' ,function(grid,  rowIndex, e ) {
		var selRec=grid.getStore().getAt(rowIndex);
		if (!!outThis.OnRptCfgCallback) outThis.OnRptCfgCallback(selRec);
		searchRptWin.close();
	});
	var searchRptWin=new Ext.Window({
		modal :true,
        width:700,
		height:600,
		title:'已配置的raq数据',
		layout:'fit',	
		items: searchRptGrid,
		buttons: [
		{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWins
		}]		
		
    });
	
	

	function CloseWins() {
		doCallBack();
		searchRptWin.close();
	};
	
	function doCallBack() {
		if (searchRptGrid.getSelectionModel().getCount() >0) {
			
			var selRec=searchRptGrid.getSelectionModel().getSelected();
			if (!!outThis.OnRptCfgCallback) outThis.OnRptCfgCallback(selRec);
		}		
		
	};
	
	function OnSearch() {
		//1、得到页面查询值
		var menuNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=searchRptGrid.getTopToolbar().items.itemAt(menuNameInx).getValue();
		var raqNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=searchRptGrid.getTopToolbar().items.itemAt(raqNameInx).getValue();
		var cSPNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=searchRptGrid.getTopToolbar().items.itemAt(cSPNameInx).getValue();
		
		//2、设置查询参数
		searchRptGrid.getStore().setBaseParam("MenuName",MenuName);	
		searchRptGrid.getStore().setBaseParam("RaqName",RaqName);	
		searchRptGrid.getStore().setBaseParam("CSPName",CSPName);	
		searchRptGrid.getStore().reload({params:{start:0,limit:50}});
	}
	
	function OnReset() {
		var menuNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","MenuName");
		var MenuName=searchRptGrid.getTopToolbar().items.itemAt(menuNameInx).setValue("");
		var raqNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","RaqName");
		var RaqName=searchRptGrid.getTopToolbar().items.itemAt(raqNameInx).setValue("");
		var cSPNameInx=searchRptGrid.getTopToolbar().items.findIndex("name","CSPName");
		var CSPName=searchRptGrid.getTopToolbar().items.itemAt(cSPNameInx).setValue("");
		
		//2、设置查询参数
		searchRptGrid.getStore().setBaseParam("MenuName","");	
		searchRptGrid.getStore().setBaseParam("RaqName","");	
		searchRptGrid.getStore().setBaseParam("CSPName","");		
		
	}
	
    this.show=function(){
    	searchRptWin.show();
    }  


}

