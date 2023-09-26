(function(){
	Ext.ns("dhcwl.BDQ.DataQryCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.QryViewCfgFrame=function(){
	var rptDimSelector=null;
	//var serviceUrl="dhcwl/BaseDataQuery/qryviewcfgframe.csp";
		var serviceUrl="dhcwl/basedataquery/dataqrycfg.csp";
	var outThis=this;

	var detailDataObj=new dhcwl.BDQ.DetailDataQryCfg(outThis);
	var detailDataPanel=detailDataObj.getDetailDataQryCfgPanel();
	var summaryDataObj=new dhcwl.BDQ.SummaryDataQryCfg(outThis);
	var summaryDataPanel=summaryDataObj.getSummaryDataQryCfgPanel();
	
	
	
	var ViewCfgTabPanel = new Ext.TabPanel({
		//title:'服务与设置',
		
		activeTab: 0,
		tabPosition :'bottom',
		items: [detailDataPanel
		,summaryDataPanel]
	});	
	/*
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'名称',dataIndex:'Name',sortable:true, width: 160, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'Descript', width: 160, sortable: true,menuDisabled : true
        }
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getPreviewData&start=0&limit=50'}),
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

    var preDetailViewGrid = new Ext.grid.GridPanel({
        //height:480,
			title:'dtl',
        store: store,
        cm: columnModel,
		bbar: new Ext.PagingToolbar({
		pageSize:50,
		store:store,
		displayInfo:true,
		displayMsg:'{0}~{1}条,共 {2} 条',
		emptyMsg:'sorry,data not found!'
		})
    });

    var preSummaryViewGrid = new Ext.grid.PivotGrid({
        //height:480,
        store: store,
		title:'sum',
		bbar: new Ext.PagingToolbar({
		pageSize:50,
		store:store,
		displayInfo:true,
		displayMsg:'{0}~{1}条,共 {2} 条',
		emptyMsg:'sorry,data not found!'
		})
    });	
    //store.load({params:{start:0,limit:21}});		
		*/
    var QryViewCfgPanel =new Ext.Panel({
		title:'配置查询条件',
		closable:true,
		layout:'border',	
		items:[{
			region:'center',
			//height:400,
			items:ViewCfgTabPanel,
			layout:'fit'
		}]	
    });


	this.getPreDetailViewGrid=function() {
		return preDetailViewGrid;
	}
	
	this.getPreSumViewGrid=function() {
		return preSummaryViewGrid;
	}	

    this.getQryViewCfgPanel=function(){
    	return QryViewCfgPanel;
    }   

	this.getPreviewPanel=function() {
		var p= Ext.getCmp('previewPanel');
		return p;
	}
	
    
}

