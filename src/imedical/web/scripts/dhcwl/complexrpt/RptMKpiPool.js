(function(){
	Ext.ns("dhcwl.complexrpt.RptMKpiPool");
})();
Ext.onReady(function() {
	var preUrl="dhcwl/complexrpt/";
	
	//关联报表右键菜单
	var quickMenu=new Ext.menu.Menu({
		//autoWidth:true,
		boxMinWidth:150,
		ignoreParentClicks:true,
    	items:[
    		{
    			text:'关联指标明细',
    			handler:function(cmp,event){
		    		var sm = linkRptPanel.getSelectionModel();
		        		if(!sm){
		                	alert("请选择一行！");
		                	return;
		                }
		        	var record = sm.getSelected();
		            	if(!record){
		               		alert("请选择一行！");
		                	return;
		                }
		           	//var mRptCode=record.get('rptCode');
		           	//var mRptName=record.get('rptName');
					var rptWinCfg=new dhcwl.complexrpt.TestRow();
					rptWinCfg.showRptCfgWin().show();
    			}
    		}
    	]
     });
     
     /// 关联报表模型定义
	var columnModelLinkRpt = new Ext.grid.ColumnModel([
        {header:'报表编码',dataIndex:'rptCode', width: 150, sortable: false 
        },{header:'报表名称',dataIndex:'rptName', width: 300, sortable: false //不允许排序
        }
    ]);
    
	var selRowKpiCode="";
    var storeLinkRpt = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:preUrl+'getrptpooldata.csp?action=getLinkRpt&RptCode='}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'rptCode'},
            	{name: 'rptName'}
       		]
    	})
    });
    var linkRptRecorde= Ext.data.Record.create([
        {name: 'rptCode', type: 'string'},
        {name: 'rptName', type: 'string'}
	]);
     
/// 指标池模型定义
	var columnModelPool = new Ext.grid.ColumnModel([
        {header:'指标编码',dataIndex:'rKpiCode', width: 90, sortable: false 
        },{header:'统计内容',dataIndex:'rKpiCont', width: 120, sortable: false //不允许排序
        },{header:'统计模式',dataIndex:'rKpiMode', width: 120, sortable: false
        },{header:'指标维度串',dataIndex:'rKpiDimStr', width: 400, sortable: false
        }
    ]);

    var storePool = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:preUrl+'getrptpooldata.csp?action=singleSearche'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'rKpiCode'},
            	{name: 'rKpiCont'},
            	{name: 'rKpiMode'},
            	{name: 'rKpiDimStr'}
       		]
    	})
    });
    var poolRecorde= Ext.data.Record.create([
        {name: 'rKpiCode', type: 'string'},
        {name: 'rKpiCont', type: 'string'},
        {name: 'rKpiMode', type: 'string'},
        {name: 'rKpiDimStr', type: 'string'}
	]);
	
	
	/// 指标池GridPanel
	var rKpiCode=""
	var choicedSearcheCond="",searcheValue="";
    var mkpiListPanel = new Ext.grid.GridPanel({
    	title:'指标池',
        id:"mkpiListPanel",
        width:700,
        height:550,
        resizeAble:true,
        //margins:'3 3 3 0',
        //autoHeight:true,
        enableColumnResize :true,
        store: storePool,
        cm: columnModelPool,
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        autoScroll: true,
        bbar:new Ext.PagingToolbar({
            pageSize: 30,
            store: storePool,
            displayInfo: true,
            displayMsg: '第{0}条到{1}条记录,共{2}条',
            emptyMsg: "没有记录",
            listeners :{
            	//翻页时根据搜索条件加载数据
	        	'beforechange':function(pt,page){
	        		storePool.proxy.setUrl(encodeURI("dhcwl/complexrpt/getrptpooldata.csp?action=singleSearche&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue))
	        	}
            }
        }),
        listeners:{
        	"rowclick":function(pGrid,pIndex,pEvent){
        		var sm=mkpiListPanel.getSelectionModel();
        		if(!sm) return;
        		var record = sm.getSelected();
        		if(!record) return;
                rKpiCode=record.get("rKpiCode");
                storeLinkRpt.proxy.setUrl(encodeURI(preUrl+'getrptpooldata.csp?action=getLinkRpt&RptCode='+rKpiCode+"&start=0&&limit=30"));
	            storeLinkRpt.load();
	            linkRptPanel.show();

        	}
        },
        tbar: new Ext.Toolbar(
        {
        	layout: 'hbox',
    		xtype : 'compositefield',
        	items : ['搜索：',{
	        	id:'poolSearcheCont',
	        	width: 120,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'name',
	        	valueField:'value',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : '指标编码',   value: 'kpiCode'},
	            		{name : '统计内容编码',   value: 'statText'},
	                	{name : '统计模式编码',  value: 'statMode'},
	                	{name : '指标维度编码',   value: 'dimCode'}
	             	]}),
	            listeners:{
	        		'select':function(combo){
	        			choicedSearcheCond=combo.getValue();
	        		}
	        	}
	  		},{
				xtype: 'textfield',
				width:200,
	            flex : 1,
	            id:'poolSearcheContValue',
	            enableKeyEvents: true,
	            allowBlank: true,
	            listeners :{
	            	'keypress':function(ele,event){
	            		searcheValue=Ext.get("poolSearcheContValue").getValue();
	            		if ((event.getKey() == event.ENTER)){
	            			storePool.proxy.setUrl(encodeURI(preUrl+"getrptpooldata.csp?action=singleSearche&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=30"));
	            			storePool.load();
	            			mkpiListPanel.show();
	            		}
	            	}
	            }
	        }
        ]}
 		)
    });
    storePool.load({params:{start:0,limit:30}});
	
	/// 关联报表GridPanel
    var linkRptPanel = new Ext.grid.GridPanel({
    	title:'关联报表',
        id:"selLinkRptPanel",
        width:450,
        height:550,
        resizeAble:true,
        cm: columnModelLinkRpt,
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        store: storeLinkRpt,    //new Ext.data.ArrayStore({}),
        enableColumnResize :true,
        bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: storeLinkRpt,
            displayInfo: true,
            displayMsg: '第{0}条到{1}条记录,共{2}条',
            emptyMsg: "没有记录",
            listeners :{
            	//翻页时根据搜索条件加载数据
	        	'beforechange':function(pt,page){
	        		storeLinkRpt.proxy.setUrl(encodeURI(preUrl+"getrptpooldata.csp?action=getLinkRpt&RptCode="+rKpiCode+"&start=0&&limit=30"))
	        	}
            }
        })
    });
    
    var rptDefShowWin =new Ext.Panel({
    	title:'指标池与关联报表',
    	//cmargins:'3 3 3 3',
    	//margins:'3 0 3 3',
    	layout:'table',
        items: [{
            items:mkpiListPanel
        },{
            items:linkRptPanel
    	}]
    });
    
    this.mainWin=new Ext.Viewport({
    	id:'maintainKpiPool',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        //layout: 'fit',
        items: [rptDefShowWin]
    });
    
    
      this.getKpiPoolShowWin=function(){
    	return rptDefShowWin;
    }
    
})