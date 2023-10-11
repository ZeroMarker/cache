/// 名称: 医护人员维护-Falsh图表部分	
/// 描述: 医护人员维护的子JS，Falsh图表部分	
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2012-11-20
	

Ext.chart.Chart.CHART_URL = '../scripts_lib/ext3.2.1/resources/charts.swf';

	var ACTION_CareProv_Chart = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetListForChart";
	var ACTION_CareProv_ChartDetail = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCareProv&pClassQuery=GetListForChartDetail";
    var store = new Ext.data.JsonStore({
        fields: ['season', 'total'],
        data: [{
            season: 'Summer',
            total: 150
        },{
            season: 'Fall',
            total: 245
        },{
            season: 'Winter',
            total: 117
        },{
            season: 'Spring',
            total: 184
        }]
    });
 
    var ChartStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_CareProv_Chart}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
		   [{ name: 'CTCPTDesc', mapping:'CTCPTDesc',type: 'string'},  //类型
			{ name: 'CareCount', mapping:'CareCount',type: 'string'}   //医护人员数量
			]),
		remoteSort: true
    });
    ChartStore.load({
    	params:{start:0, limit:100},
    	callback: function(records, options, success){
		}
	});
	
	  var ChartDetailStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:ACTION_CareProv_ChartDetail}),//调用的动作
        reader: new Ext.data.JsonReader({
            	totalProperty: 'total',
            	root: 'data',
            	successProperty :'success'
        	},
		   [{ name: 'CTCPTInternalType', mapping:'CTCPTInternalType',type: 'string',renderer:function(value){
		    	if(value=='DOCTOR'){
					return "医生";
		    	}else if(value=='NUESE'){
					return "护士";
		    	}else if(value=='Technician'){
					return "技师";
		    	}else if(value=='Pharmacist'){
					return "药师";
		    	}else {return "其它";}
		    	}},  //类型
			{ name: 'CareCount', mapping:'CareCount',type: 'string'}   //医护人员数量
			]),
		remoteSort: true
    });
    ChartDetailStore.load({
    	params:{start:0, limit:100},
    	callback: function(records, options, success){
		}
	});
	var PieChartPanel = new Ext.Panel({
        width: 800,
        height: 600,
        title: '职称分类图',
        layout:'form',
        items: {
            store: ChartStore,
            xtype: 'piechart',
            dataField: 'CareCount',
            categoryField: 'CTCPTDesc',
            //extra styles get applied to the chart defaults
            extraStyle:
            {
                legend:
                {
                    display: 'bottom',
                    padding: 5,
                    font:
                    {
                        family: 'Tahoma',
                        size: 13
                    }
                }
            }
        }
    });
    
    var PieChartDetailPanel = new Ext.Panel({
        width: 800,
        height: 600,
        title: '医护分类图',
        layout:'form',
        items: {
            store: ChartDetailStore,
            xtype: 'piechart',
            dataField: 'CareCount',
            categoryField: 'CTCPTInternalType',
            extraStyle:
            {
                legend:
                {
                    display: 'bottom',
                    padding: 5,
                    font:
                    {
                        family: 'Tahoma',
                        size: 13
                    }
                }
            }
        }
    });
       var ChartTabs = new Ext.TabPanel({
        width:700,
        activeTab: 0,
        frame:true,
        items:[
        	PieChartDetailPanel,
            PieChartPanel
            
        ]
    });
    function getChartWin(){
   		 var ChartWin = new Ext.Window({
			width:760,
            height:510,
            closeable:true,
			layout:'fit',
			plain:true,  
			modal:true,
			frame:true,
			autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: ChartTabs
		});
		
		return ChartWin;
	}