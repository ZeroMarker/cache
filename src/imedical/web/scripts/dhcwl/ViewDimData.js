(function(){
	Ext.ns("dhcwl.mkpi");
})();
Ext.onReady(function(){
});
//预览维度数据界面
dhcwl.mkpi.ViewDimData=function(){
	var selectedKpis=[];
	var outThis=this;
	var selectedKpis=[];kpiRule=[['','']],filterRuleArr=[['','']];
	var queryParams="",queryParamsNoSE;
	var preUrl="dhcwl/kpi/";
	var kpiRuleRecorde= Ext.data.Record.create([
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
        emptyText:'选择或填写维度取数规则...',
        selectOnFocus:true,
        valueField:'value',
        displayField:'text',
        triggerAction : 'all',
        width:250,
        tpl:'<tpl for=".">'+'<div class="x-combo-list-item" style="height:18px;">'+'{text}'+'</div>'+'</tpl>',
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

   var filterRuleRecord = Ext.data.Record.create([
		{name: 'text', type: 'string'},
		{name: 'value', type: 'string'}
   ]);
   //过滤规则选择器
   var filterRuleCombo= new Ext.form.ComboBox({
        store: new Ext.data.SimpleStore({
			fields:['value','text'],
			data:filterRuleArr
		}),
        typeAhead: true,
        autoScroll:false,
		forceSelection: false,
        mode:'local',
		triggerAction: 'all',
        emptyText:'选择或填写维度过滤规则...',
        selectOnFocus:true,
		valueField:'value',
		displayField:'text',
        width:250,
        tpl:'<tpl for=".">'+'<div class="x-combo-list-item" style="height:18px;">'+'{text}'+'</div>'+'</tpl>',
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
    function renderNSValue(value,cellmeta,record,rowIndex,columnIndex,store){
		var real=record.get("realValue"),his=record.get("hisValue");
		if(real!=his){
			return "<span style='color:red;'>"+value+"</span>";
		}
		return value;
	}
    var setForm=new Ext.form.FormPanel({
    	id:'setFormId',
    	height:95,
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
                		//text:"取数规则生成器",
                		text: '<span style="line-Height:1">取数规则生成器</span>',
                		icon: '../images/uiimages/config.png',
                		listeners:{
                			"click":function(){
                				var setRuleWin=new dhcwl.mkpi.showkpidata.SetDimRule();
                				setRuleWin.setSelectedKpiCode(kpiRuleCombo.getValue());	
                				setRuleWin.setParentWin(outThis);
                				setRuleWin.show();
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
                		//text:"过滤规则生成器",
                		text: '<span style="line-Height:1">过滤规则生成器</span>',
                		icon: '../images/uiimages/config.png',
						listeners:{
                			"click":function(){
                				var setFilterWin = new dhcwl.mkpi.showkpidata.SetDimFilterRule();
								//将取数规则列表传给指标过滤规则界面
								var selectedKpiRule = kpiRuleCombo.getValue();
								if (!!selectedKpiRule == false){
									Ext.MessageBox.alert("消息","您需要选择或填写一个指标取数规则！");
									return;
								}
								setFilterWin.InitKpiTreePanel(selectedKpiRule,"");
								setFilterWin.show();
								setFilterWin.setParentWin(outThis);
                			}
                		}
                	}
        		]
        	}
        ],buttons:[{
           	//text:'查询',
           	text: '<span style="line-Height:1">查询</span>',
           	icon: '../images/uiimages/search.png',
        	handler:function(){
        		var ruleValue=kpiRuleCombo.getValue();
        		var filterRule=filterRuleCombo.getValue();
        		var paras="dimId="+ruleValue+"&start=0&limit=100&action=dimView&filterRule="+encodeURIComponent(filterRule||"");
        		queryParamsNoSE="dimId="+ruleValue+"&action=dimView&filterRule="+encodeURIComponent(filterRule||"");
        		storeKpiData.proxy.setUrl((preUrl+"dimservice.csp?"+ paras)); 
    			storeKpiData.load();
    			kpiDataGrid.show();
        	}
            }]
    });
    var defaultColumns=[
        {header:'维度代码',dataIndex:'dimType', width: 200,sortable:false,menuDisabled : true
        },{header:'ID',dataIndex:'dimIDV', width: 60, sortable: false ,menuDisabled : true
        },{header:'维度值',dataIndex:'dimProV', width: 260, sortable: false ,menuDisabled : true
        }
    ];
    var columnModelKpiData = new Ext.grid.ColumnModel({});
    columnModelKpiData.setConfig(defaultColumns,false);
    var storeKpiData = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({
    		url:preUrl+'dimservice.csp',
    		timeout:600000	//超时最大时间为10分钟
    	}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'dimType'},
            	{name: 'dimIDV'},
            	{name: 'dimProV'}
       	 	]
        }),
        listeners :{
        	'loadexception':function(mes,paras,responseObj){
        		Ext.Msg.show({title:'错误',msg:responseObj.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	}
        }
    });
    var kpiDataGrid = new Ext.grid.GridPanel({
	  	height:305,
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
				storeKpiData.proxy.setUrl((preUrl+"dimservice.csp?"+ queryParamsNoSE));
			}
			}
        })
    }); 
    
    var mainWin=new Ext.Window({
		id:'dhcwl.mkpi.ViewKpiData',
		layout : 'border',
		width : 600,
		height : 440,
		autoScroll:true,
		plain : true,
		title : '数据预览',
		items : [{
			height:95,
        	region:'north',
            items:setForm
    	},{
    		region:'center',
    		autoScroll:true,
    		items:kpiDataGrid
    	}],
    	listeners:{
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
	this.setKpiFilter=function(name,filter){
		if(name=="") name=filter;
		filterRuleCombo.getStore().add(new filterRuleRecord({"value":filter,"text":name}));
		filterRuleCombo.setRawValue(name);
		filterRuleCombo.setValue(filter);
	}
	this.setFilterRuleArray=function(nickName,rule){
		filterRuleCombo.getStore().add(new filterRuleRecord({"value":rule,"text":nickName}));
		filterRuleCombo.setRawValue(nickName);
		filterRuleCombo.setValue(rule);
	}
}