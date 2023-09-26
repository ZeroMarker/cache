(function(){
	Ext.ns("dhcwl.mkpi");
})();
Ext.onReady(function(){
	//var win=new dhcwl.mkpi.ViewKpiData();
	//win.showWin();  //只将定义好的窗体显示出来。
});
dhcwl.mkpi.ViewKpiData=function(){
	Ext.QuickTips.init();
	var selectedKpis=[];
	var outThis=this;
	var selectedKpis=[];kpiRule=[['','']],filterRule=[];
	var queryParams="",queryParamsNoSE;
	var preUrl="dhcwl/kpi/";
	var kpiRuleRecorde= Ext.data.Record.create([
    //start
        {name: 'text', type: 'string'},
        {name: 'value', type: 'string'}
	]);
	var kpiRuleCombo= new Ext.form.ComboBox({
        store: new Ext.data.SimpleStore({
        	fields:['value','text'],
        	data:kpiRule
        }),
        typeAhead: true,
        autoScroll:false,
        forceSelection: false,
        mode:'local',
        emptyText:'选择或填写指标取数规则...',
        selectOnFocus:true,
        valueField:'value',
        displayField:'text',
        triggerAction : 'all',
        width:500,
		stype:{
			"padding":"20px"
		},
		listeners:{
			"change":function(field,newValue,oldValue){
				if(newValue!=oldValue){
					
				}
			}
		}
    });
    var filterRuleCombo= new Ext.form.ComboBox({
        store: filterRule,
        typeAhead: true,
        //forceSelection: true,
        triggerAction: 'all',
        emptyText:'选择或填写过滤规则...',
        selectOnFocus:true,
        width:500,
		stype:{
			"padding":"20px"
		}
    });
    var startDatePicker=new Ext.form.DateField({
		format :'Y-m-d',
        name: 'startDate',
        width:130,
		value:dhcwl.mkpi.Util.yesterday()
    });
	var endDatePicker=new Ext.form.DateField({
		format :'Y-m-d',
        name: 'endDate',
        width:130,
		value:dhcwl.mkpi.Util.yesterday()
    });
	var isRealCheck=new Ext.form.Checkbox({
        xtype:'checkbox',
        checked: false,
        boxLabel: '是否为实时数据？',
        name: 'isReal'
    });
    var columnSetButton=new Ext.Button({
    	text:'显示列设置'
    });
    /*var textFile={
    	xtype:"textfield"
    };
    new Ext.form.TextField({});*/
    function renderNSValue(value,cellmeta,record,rowIndex,columnIndex,store){
		var real=record.get("realValue"),his=record.get("hisValue");
		if(real!=his){
			return "<span style='color:red;'>"+value+"</span>";
		}
		return value;
	}
    var realHisQueryButton=new Ext.Button({
    	text:'实时与历史对比',
    	handler :function(){
    		var tempColumns=[
		        {header:'日期',dataIndex:'monDesc', width: 160,sortable:true
		        },{header:'指标代码',dataIndex:'kpiCode', width: 160, sortable: true 
		        },{header:'指标名称',dataIndex:'kpiDesc', width: 160, sortable: true 
		        },{header:'维度原始值',dataIndex:'dimId', width: 160, sortable: true
		        },{header:'维度名称',dataIndex:'dimDesc', width: 160, sortable: true
		        },{header:'实时数据',dataIndex:'realValue', width: 80, sortable: true,renderer:renderNSValue
		        },{header:'历史数据',dataIndex:'hisValue', width: 80, sortable: true,renderer:renderNSValue
		        }
		    ];
		    kpiDataGrid.getColumnModel().setConfig(tempColumns,false);
    		var ruleValue=kpiRuleCombo.getValue();
			var sd = startDatePicker.getValue().format('Y-m-d'), ed = endDatePicker.getValue().format('Y-m-d');
			var isReal=isRealCheck.checked;
			var filterRule=filterRuleCombo.getValue();
			isReal=isReal?1:0;
			var paras="sDate="+sd+"&eDate="+ed+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&start=0&limit=100&action=REAHISQuery";
			paras+="&filterRule="+encodeURIComponent(filterRule||"");
			queryParams=paras;
			queryParamsNoSE="sDate="+sd+"&eDate="+ed+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&action=REAHISQuery&filterRule="+encodeURIComponent(filterRule||"");
			storeKpiData.proxy.setUrl((preUrl+"showkpidata.csp?"+ paras)); //encodeURI
			storeKpiData.load(); //{params:{start:0,limit:30,onePage:1}});
			kpiDataGrid.show();
    	}
    });
    var queryButton=new Ext.Button({
    	text:'查询',
    	handler :function(){
    		kpiDataGrid.getColumnModel().setConfig(defaultColumns,false);
    		var ruleValue=kpiRuleCombo.getValue();
			var sd = startDatePicker.getValue().format('Y-m-d'), ed = endDatePicker.getValue().format('Y-m-d');
			var isReal=isRealCheck.checked;
			isReal=isReal?1:0;
			var filterRule=filterRuleCombo.getValue();
			var paras="sDate="+sd+"&eDate="+ed+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&start=0&limit=100&action=preview";
			paras+="&filterRule="+encodeURIComponent(filterRule||"");
			queryParams=paras;
			;params=(paras);
			queryParamsNoSE="sDate="+sd+"&eDate="+ed+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&action=preview&filterRule="+encodeURIComponent(filterRule||"");
			storeKpiData.proxy.setUrl((preUrl+"showkpidata.csp?"+ paras));  //encodeURI(preUrl+"showkpidata.csp?"+ paras));
			storeKpiData.load(); //{params:{start:0,limit:30,onePage:1}});
			kpiDataGrid.show();
    	}
    });
    var setForm=new Ext.form.FormPanel({
    	id:'setFormId',
    	height:125,
        //width   : 600,
        bodyStyle: 'padding: 5px',
        defaults: {
            anchor: '0'
        },
        items:[
        	{
                xtype : 'compositefield',
                anchor: '-20',
                fieldLabel: '取数规则',
                items : [
                	kpiRuleCombo,
                	{
                		id:'kpiRuleButton',
                		xtype:"button",
                		text:"取数规则生成器",
                		listeners:{
                			"click":function(){
                				var setRuleWin=new dhcwl.mkpi.showkpidata.SetKpiRule();
                				setRuleWin.setSelectedKpiArr(selectedKpis);
                				setRuleWin.show();
                				setRuleWin.setParentWin(outThis);
                			}
                		}
                	}
        		]
        	},{
                xtype : 'compositefield',
                anchor: '-20',
                fieldLabel: '过滤规则',
                items : [
                	filterRuleCombo,
                	{
                		id:'filterButton',
                		xtype:"button",
                		text:"过滤规则生成器"
                	}
        		]
        	},{
        		xtype : 'compositefield',
                anchor: '-20',
                fieldLabel: '日期范围',
                items : [
                	startDatePicker,
                	endDatePicker/*,
                	textFile*/
        		]
        	},{
        		xtype : 'compositefield',
                anchor: '-20',
                fieldLabel: '操作',
                items : [
                isRealCheck,columnSetButton,realHisQueryButton,queryButton
        		]
        	}
        ]
    });
    var defaultColumns=[
        {header:'日期',dataIndex:'monDesc', width: 160,sortable:true
        },{header:'指标代码',dataIndex:'kpiCode', width: 160, sortable: true 
        },{header:'指标名称',dataIndex:'kpiDesc', width: 160, sortable: true 
        },{header:'维度原始值',dataIndex:'dimId', width: 160, sortable: true
		},{header:'维度名称',dataIndex:'dimDesc', width: 160, sortable: true
        },{header:'值',dataIndex:'value', width: 80, sortable: true
        }
    ];
    var columnModelKpiData = new Ext.grid.ColumnModel({});
    columnModelKpiData.setConfig(defaultColumns,false);
    var storeKpiData = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({
    		url:preUrl+'showkpidata.csp',
    		timeout:600000	//超时最大时间为10分钟
    	}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'monDesc'},
            	{name: 'kpiCode'},
            	{name: 'kpiDesc'},
            	{name: 'dimId'},
            	{name: 'dimDesc'},
            	{name: 'value',type: 'float'},
            	{name: 'realValue',type: 'float'},
            	{name: 'hisValue',type: 'float'}
       	 	]
        })
    });
    var kpiDataGrid = new Ext.grid.GridPanel({
	  	height:235,
        store: storeKpiData,
        loadMask:true,
        cm: columnModelKpiData,
        bbar:new Ext.PagingToolbar({
            pageSize: 100,
            store: storeKpiData,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
			'beforechange':function(pt,page){
				//alert(queryParamsNoSE);
				storeKpiData.proxy.setUrl((preUrl+"showkpidata.csp?"+ queryParamsNoSE));
			}
			}
        })
    });
    var mainWin=new Ext.Window({
		id:'dhcwl.mkpi.ViewKpiData',
		//renderTo:Ext.getBody(),
		layout : 'border',
		width : 800,
		height : 400,
		autoScroll:true,
		plain : true,
		title : '数据预览',
		items : [{
			height:125,
        	region:'north',
            items:setForm
    	},{
    		region:'center',
    		autoScroll:true,
    		items:kpiDataGrid
    	}],
    	listeners:{
    		"resize":function(win,width,height){
    			if(height!=400){
    				kpiDataGrid.setHeight(height-165);
    				kpiDataGrid.setWidth(width-20);
    			}
    		}
    	}
	});
	this.showWin=function(){
		mainWin.show();
	}
	this.setSelectedKpis=function(arr){
		selectedKpis=arr;
	}
	this.setKpiRule=function(name,rule){
		if(name=="") name=rule;
		kpiRuleCombo.getStore().add(new kpiRuleRecorde({"value":rule,"text":name}));
		kpiRuleCombo.setRawValue(name);
		kpiRuleCombo.setValue(rule);
	}
}