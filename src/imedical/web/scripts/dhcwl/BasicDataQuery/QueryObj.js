(function(){
	Ext.ns("dhcwl.BDQ.QueryObj");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.QueryObj=function(){
	var rptDimSelector=null;
	var serviceUrl="dhcwl/basedataquery/queryobj.csp";
	var outThis=this;

	var quickMenu=new Ext.menu.Menu({
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'新建查询对象',
    			handler:function(){
    				var CreateQueryObj=new dhcwl.BDQ.CreateQueryObj(outThis);
					CreateQueryObj.ShowQryNameCfgWin();
     			}
    		},{
    			text:'修改查询对象',
    			handler:function(){
					var selRec=BDQGrid.getSelectionModel().getSelected();
					if (!selRec) {
						Ext.Msg.alert("错误","请先选择查询对象！");
						return;
					}
					var BaseObjName=selRec.get("Name");
    				var ModifyQueryObj=new dhcwl.BDQ.ModifyQueryObj(BaseObjName);
    				ModifyQueryObj.showWin();

     			}			
			}]
	});
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'名称',dataIndex:'Name',sortable:true, width: 160, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'Descript', width: 160, sortable: true,menuDisabled : true
        }
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getBDQObj'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'Name'},
            	{name: 'Descript'},
       		]
    	})
    });

    var BDQGrid = new Ext.grid.GridPanel({
        //height:480,
		
        store: store,
        cm: columnModel,
		listeners:{
        	'contextmenu':function(event){
        		event.preventDefault();
        		quickMenu.showAt(event.getXY());
        	}
        }
    });

    store.load({params:{start:0,limit:21}});

    var BDQPanel =new Ext.Panel({
		title:'定义查询对象',
		closable:true,
    	layout:'border',
        items: [{
        	region:'center',
        	//autoScroll:true,
			layout:'fit',
            items:BDQGrid
    	}]
    });


    
    function refresh(){
		BDQGrid.getStore().reload();
	    BDQGrid.show();      	
    }
    this.refresh=function(){
    	refresh();
    }
    
    this.getBDQPanel=function(){
    	return BDQPanel;
    }   

    
}

