(function() {
	Ext.ns("dhcwl.mripdaytask.OeordInfoDetailCfg");
})();
// /描述: 医嘱对应明细界面界面
// /编写者： 陈乙
// /编写日期: 2015-03-02


dhcwl.mripdaytask.OeordInfoDetailCfg = function(searchCondType,searchContValue,gridStore) {
	var serviceUrl="dhcwl/mripdaytask/mripdaytaskoeordinfo.csp";
	var columnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header:'ID',dataIndex:'ID', width: 60, sortable: true, menuDisabled : true
        },{header:'CODE',dataIndex:'ARCItmCode', width: 70, sortable: true , menuDisabled : true
        },{header:'描述',dataIndex:'ARCItmDesc', width: 230, sortable: true , menuDisabled : true
        }
    ]);  
	//定义科室的存储模型
    var arcItmStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/mripdaytask/mripdaytaskoeordinfo.csp?action=selectARCItms&start=0&pageSize=20'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name: 'ID'},
            	{name: 'ARCItmCode'},
            	{name: 'ARCItmDesc'}
       		]
       		 

    	})
    });
    arcItmStore.load({params:{cond1:searchCondType,cond2:searchContValue}});
	//定义指标的显示表格。
	var arcItmGrid = new Ext.grid.GridPanel({
		id:"arcItmGrid",
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        store: arcItmStore,
        cm: columnModel,
		viewConfig:{
			forceFit: true
		},
        //autoScroll: true,
        bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: arcItmStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到第 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
	        	'beforechange':function(pt,page){    
	        		arcItmStore.proxy.setUrl(encodeURI('dhcwl/mripdaytask/mripdaytaskoeordinfo.csp?action=selectARCItms&cond1='+searchCondType+'&cond2='+searchContValue));
	        	}
            }
        }),
        listeners :{
        	'rowdblclick':function(ele,event){
        		var selRec=arcItmGrid.getSelectionModel().getSelected();
				if (!selRec) {
					return;
				} 
				gridStore.add(selRec);
				Ext.getCmp('arcItemWin').close();
			}
		}
    });
    
	var arcItemWin = new Ext.Window({
		title:'请双击选择统计项',
		id:'arcItemWin',
		layout : 'table',
		closeAction:'close',
		//layoutConfig: {columns:2},
		width:450,
		height:515,
		modal:true,
		resizable:true,
		items:[{
			layout:'fit',
            autoScroll:true,
            width:435,
            height:480,
            items:arcItmGrid
            }
		]/*,
		listeners:{
			'close':function(){
				this.close();
			}
		}*/
	});
	this.showCodeCfgSubGroupItemWin = function(){
		arcItemWin.show();
	}
	
}
  
