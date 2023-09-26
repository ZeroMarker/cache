(function(){
	Ext.ns("dhcwl.complexrpt.ViewRptData");
})();
dhcwl.complexrpt.ViewRptData=function(rptCode){
	this.rptCode=rptCode;
	var outThis=this;
	var queryParams="";
	var preUrl="dhcwl/complexrpt/";

    var startDatePicker=new Ext.form.DateField({
		//format :'Y-m-d',
        name: 'startDate',
        //editable:true,
        width:100,
		value:dhcwl.complexrpt.Util.yesterday()
    });
	var endDatePicker=new Ext.form.DateField({
		//format :'Y-m-d',
        name: 'endDate',
        //editable:true,
        width:100,
		value:dhcwl.complexrpt.Util.yesterday()
    });
	var isRealCheck=new Ext.form.Checkbox({
        xtype:'checkbox',
        checked: false,
        boxLabel: '是否为实时数据？',
        name: 'isReal'
    });
	
    var againParams="";
    var queryButton=new Ext.Button({
    	text: '<span style="line-Height:1">查询</span>',
    	icon   : '../images/uiimages/search.png',
    	handler :function(){
    		rptDataGrid.getColumnModel().setConfig(defaultColumns,false);
			if(!startDatePicker.getValue()||!endDatePicker.getValue()){
				alert("请选择开始日期和截止日期！");
				return;
			}
			var sd = startDatePicker.getValue().format('Y-m-d'), ed = endDatePicker.getValue().format('Y-m-d');
			if(startDatePicker.getValue().getTime()>endDatePicker.getValue().getTime()){
				alert("开始日期不能大于结束日期！");
				return ;
			}
			//var isReal=isRealCheck.checked;

			var queryParams="&StartDate="+sd+"&EndDate="+ed+"&RptCode="+outThis.rptCode;
			againParams=queryParams
			storeRptData.proxy.setUrl((preUrl+"rptmkpidata.csp?action=getRptKpiData"+ queryParams));
			storeRptData.load(); //{params:{start:0,limit:30,onePage:1}});
			rptDataGrid.show();
    	}
    });
    var setForm1=new Ext.form.FormPanel({
    	id:'setFormId',
    	height:50,
        //width   : 600,
        bodyStyle: 'padding: 5px',
        defaults: {
            anchor: '0'
        },
        items:[
        	{
        		xtype : 'compositefield',
                //anchor: '-20',
                fieldLabel: '日期范围',
                items : [
                	startDatePicker,
                	endDatePicker,
 					queryButton
        		]
        	}
        ]
    });
    
       var setForm=new Ext.form.FormPanel({
    	id:'setFormId',
    	height:70,
    	frame: true,
        //width   : 600,
    	labelAlign: 'left',
    	layout: 'table',
        bodyStyle: 'padding: 5px',
        items:[{
        	html: '开始时间：'
        },startDatePicker,{
        	html: '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp结束时间：'
        },endDatePicker,{
        	html: '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp'
        },
        queryButton
        ]
    });
    
    var defaultColumns=[
        {header:'日期',dataIndex:'monDesc', width: 120,sortable:true,menuDisabled : true
        },{header:'报表名称',dataIndex:'rptName', width: 160, sortable: true ,menuDisabled : true
        },{header:'指标ID',dataIndex:'kpiId', width: 60, sortable: true ,menuDisabled : true
        },{header:'维度值',dataIndex:'dimId', width: 120, sortable: true ,menuDisabled : true
		},{header:'行描述',dataIndex:'rowDesc', width: 160, sortable: true,menuDisabled : true
		},{header:'列描述',dataIndex:'colDesc', width: 160, sortable: true,menuDisabled : true
        },{header:'值',dataIndex:'value', width: 80, sortable: true,menuDisabled : true
        }
    ];
    var columnModelRptData = new Ext.grid.ColumnModel({});
    columnModelRptData.setConfig(defaultColumns,false);
    
    var storeRptData = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({
    		url:preUrl+'rptmkpidata.csp?action=getRptKpiData&StartDate=&EndDate=&RptCode=',
    		timeout:600000	//超时最大时间为10分钟
    	}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'monDesc'},
            	{name: 'rptName'},
            	{name: 'kpiId'},
            	{name: 'dimId'},
            	{name: 'rowDesc'},
            	{name: 'colDesc'},
            	{name: 'value',type: 'float'}
       	 	]
        }),
        listeners :{
        	'loadexception':function(mes,paras,responseObj){
        		Ext.Msg.show({title:'错误',msg:responseObj.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	}
        }
    });
    
    var rptDataGrid = new Ext.grid.GridPanel({
	  	height:313,
        store: storeRptData,
        loadMask:true,
        cm: columnModelRptData,
        bbar:new Ext.PagingToolbar({
            pageSize: 100,
            store: storeRptData,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
				'beforechange':function(pt,page){
				storeRptData.proxy.setUrl((preUrl+"rptmkpidata.csp?action=getRptKpiData"+ againParams));
				}
			}
        })
    }); 
    
    var mainWin=new Ext.Window({
		id:'dhcwl.complexrpt.ViewRptData',
		//renderTo:Ext.getBody(),
		layout : 'border',
		width : 900,
		height : 400,
		autoScroll:true,
		plain : true,
		title : '数据预览',
		items : [{
			height:70,
        	region:'north',
            items:setForm
    	},{
    		region:'center',
    		autoScroll:true,
    		items:rptDataGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			if(height!=400){
    				rptDataGrid.setHeight(height-165);
    				rptDataGrid.setWidth(width-20);
    			}
    		}
    	}
	});
	
	this.showWin=function(){
		mainWin.show();
	}
}