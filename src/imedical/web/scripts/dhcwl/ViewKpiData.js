(function(){
	Ext.ns("dhcwl.mkpi");
})();
Ext.onReady(function(){
	//var win=new dhcwl.mkpi.ViewKpiData();
	//win.showWin();  //只将定义好的窗体显示出来。
});
dhcwl.mkpi.ViewKpiData=function(){
	//Ext.QuickTips.init();		//--modify  by wz.2014-4-28
	var selectedKpis=[];
	var outThis=this;
	var selectedKpis=[];kpiRule=[['','']],filterRuleArr=[['','']];
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
        width:450,
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
        emptyText:'选择或填写指标过滤规则...',
        selectOnFocus:true,
		valueField:'value',
		displayField:'text',
        width:450,
        tpl:'<tpl for=".">'+'<div class="x-combo-list-item" style="height:18px;">'+'{text}'+'</div>'+'</tpl>',
		stype:{
			"padding":"20px"
		}
    });
    var startDatePicker=new Ext.form.DateField({
		//format :'Y-m-d',
        name: 'startDate',
        width:130,
		value:dhcwl.mkpi.Util.yesterday(),
		format:GetWebsysDateFormat()
    });
	var endDatePicker=new Ext.form.DateField({
		//format :'Y-m-d',
        name: 'endDate',
        width:130,
		value:dhcwl.mkpi.Util.yesterday(),
		format:GetWebsysDateFormat()
    });
	var isSimCheck=new Ext.form.Checkbox({
        xtype:'checkbox',
        checked: false,
        boxLabel: '是否为同期数据？',
        name: 'isSim'
    });
	var isPerCheck=new Ext.form.Checkbox({
        xtype:'checkbox',
        checked: false,
        boxLabel: '是否为上期数据？',
        name: 'isPer'
    });
	var isSumCheck=new Ext.form.Checkbox({
        xtype:'checkbox',
        checked: false,
        boxLabel: '是否为汇总数据？',
        name: 'isSum'
    });
	var isSecProCheck=new Ext.form.Checkbox({
		xtype:'checkbox',
        checked: false,
        boxLabel: '是否为自动升区间数据？',
        name: 'isSum'
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
    	//text:'实时与历史对比',
    	text: '<span style="line-Height:1">实时与历史对比</span>',
    	icon: '../images/uiimages/search.png',
    	handler :function(){
    		var tempColumns=[
		        {header:'日期',dataIndex:'monDesc', width: 160,sortable:true,menuDisabled : true
		        },{header:'指标代码',dataIndex:'kpiCode', width: 160, sortable: true ,menuDisabled : true
		        },{header:'指标名称',dataIndex:'kpiDesc', width: 160, sortable: true ,menuDisabled : true
		        },{header:'维度原始值',dataIndex:'dimId', width: 160, sortable: true,menuDisabled : true
		        },{header:'维度名称',dataIndex:'dimDesc', width: 160, sortable: true,menuDisabled : true
		        },{header:'实时数据',dataIndex:'realValue', width: 80, sortable: true,renderer:renderNSValue,menuDisabled : true
		        },{header:'历史数据',dataIndex:'hisValue', width: 80, sortable: true,renderer:renderNSValue,menuDisabled : true
		        }
		    ];
		    kpiDataGrid.getColumnModel().setConfig(tempColumns,false);
    		var ruleValue=kpiRuleCombo.getValue();
			if(!startDatePicker.getValue()||!endDatePicker.getValue()){
				alert("请选择开始日期和截止日期！");
				return;
			}
			var sd = startDatePicker.getValue().format('Y-m-d'), ed = endDatePicker.getValue().format('Y-m-d');
			if(startDatePicker.getValue().getTime()>endDatePicker.getValue().getTime()){
				alert("开始日期不能大于结束日期！");
				return ;
			}
			var isReal=isRealCheck.checked;
			var filterRule=filterRuleCombo.getValue();
			isReal=isReal?1:0;
			var isSim=isSimCheck.checked;
			isSim=isSim?1:0;
			var isPer=isPerCheck.checked;
			isPer=isPer?1:0;
			var isSum=isSumCheck.checked;
			isSum=isSum?1:0;
			var isSecPro=isSecProCheck.checked;
			isSecPro=isSecPro?1:0;
			if ((isSecPro==1)){
				Ext.Msg.alert("提示","实时模式下不能选中区间自动升级模式！");
				return;
			}
			var paras="sDate="+sd+"&eDate="+ed+"&isSim="+isSim+"&isPer="+isPer+"&isSum="+isSum+"&isSecPro="+isSecPro+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&start=0&limit=100&action=NewREAHISQuery";
			paras+="&filterRule="+encodeURIComponent(filterRule||"");
			queryParams=paras;
			//queryParamsNoSE="sDate="+sd+"&eDate="+ed+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&action=REAHISQuery&filterRule="+encodeURIComponent(filterRule||"");
			queryParamsNoSE=queryParams
			//storeKpiData.proxy.setUrl((preUrl+"showkpidata.csp?"+ paras)); //encodeURI
			//storeKpiData.load(); //{params:{start:0,limit:30,onePage:1}});
			storeKpiData.baseParams={
				action:"NewREAHISQuery",
				kpiId:ruleValue,
				dateType:"",
				isReal:isReal,
				isSecPro:isSecPro,
				isSum:isSum,
				isPer:isPer,
				isSim:isSim,
				sDate:sd,
				eDate:ed,
				filterRule:filterRule
			};
			storeKpiData.load({
				params : {
					start : 0,
					limit : 100
				}
			});
    	}
    });
    var queryButton=new Ext.Button({
    	//text:'查询',
    	text: '<span style="line-Height:1">查询</span>',
    	icon: '../images/uiimages/search.png',
    	handler :function(){
    		kpiDataGrid.getColumnModel().setConfig(defaultColumns,false);
    		var ruleValue=kpiRuleCombo.getValue();
			if(!startDatePicker.getValue()||!endDatePicker.getValue()){
				alert("请选择开始日期和截止日期！");
				return;
			}
			var sd = startDatePicker.getValue().format('Y-m-d'), ed = endDatePicker.getValue().format('Y-m-d');
			if(startDatePicker.getValue().getTime()>endDatePicker.getValue().getTime()){
				alert("开始日期不能大于结束日期！");
				return ;
			}
			var isReal=isRealCheck.checked;
			isReal=isReal?1:0;
			var isSim=isSimCheck.checked;
			isSim=isSim?1:0;
			var isPer=isPerCheck.checked;
			isPer=isPer?1:0;
			var isSum=isSumCheck.checked;
			isSum=isSum?1:0;
			var isSecPro=isSecProCheck.checked;
			isSecPro=isSecPro?1:0;
			if ((isReal==1)&&(isSecPro==1)){
				Ext.Msg.alert("提示","实时模式和区间自动升级模式不能同时选中！");
				return;
			}
			var filterRule=filterRuleCombo.getValue();
			var paras="sDate="+sd+"&eDate="+ed+"&isSim="+isSim+"&isPer="+isPer+"&isSum="+isSum+"&isSecPro="+isSecPro+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&start=0&limit=100&action=NewPreview";
			paras+="&filterRule="+encodeURIComponent(filterRule||"");
			queryParams=paras;
			//filterRule=encodeURIComponent(filterRule||"");
			//filterRule=Ext.util.JSON.encode(filterRule);
			;params=(paras);
			//queryParamsNoSE="sDate="+sd+"&eDate="+ed+"&isReal="+isReal+"&dateType=&kpiId="+ruleValue+"&action=preview&filterRule="+encodeURIComponent(filterRule||"");
			queryParamsNoSE=queryParams;
			//storeKpiData.proxy.setUrl((preUrl+"showkpidata.csp?"+ paras));  //encodeURI(preUrl+"showkpidata.csp?"+ paras));
			//storeKpiData.load(); //{params:{start:0,limit:30,onePage:1}});
			//kpiDataGrid.show();
			storeKpiData.baseParams={
				action:"NewPreview",
				kpiId:ruleValue,
				dateType:"",
				isReal:isReal,
				isSecPro:isSecPro,
				isSum:isSum,
				isPer:isPer,
				isSim:isSim,
				sDate:sd,
				eDate:ed,
				filterRule:filterRule
			};
			storeKpiData.load({
				params : {
					start : 0,
					limit : 100
				}
			});
    	}
    });
    var setForm=new Ext.form.FormPanel({
    	id:'setFormId',
    	height:155,
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
                		//text:"取数规则生成器",
                		text: '<span style="line-Height:1">取数规则生成器</span>',
                		icon: '../images/uiimages/config.png',
                		listeners:{
                			"click":function(){
                				//var setRuleWin=new dhcwl.mkpi.showkpidata.SetKpiRule();
                				var setRuleWin=new dhcwl.mkpi.showkpidata.SetKpiRule2();
                				//setRuleWin.setSelectedKpiArr(selectedKpis);
                				setRuleWin.setSelectedKpiCode(kpiRuleCombo.getValue());	//modify by wz.2015-1-22
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
                				var setFilterWin = new dhcwl.mkpi.showkpidata.SetFilterRule();
								//将取数规则列表传给指标过滤规则界面
								var selectedKpiRule = kpiRuleCombo.getValue();
								if (!!selectedKpiRule == false){
									Ext.MessageBox.alert("消息","您需要选择或填写一个指标取数规则！");
									return;
								}
								setFilterWin.InitKpiTreePanel(selectedKpiRule,"");
								//setFilterWin.setSelectedKpiArr(selectedKpis);
								setFilterWin.show();
								setFilterWin.setParentWin(outThis);
                			}
                		}
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
        		fieldLabel: '查询方式',
        		 items : [
        		     isSimCheck,
        		     isPerCheck,
        		     isSumCheck,
        		     isSecProCheck
        		 ]
        	},{
        		xtype : 'compositefield',
                anchor: '-20',
                fieldLabel: '操作',
                items : [
                //isRealCheck,columnSetButton,realHisQueryButton,queryButton
                isRealCheck,
                realHisQueryButton,
                queryButton
        		]
        	}
        ]
    });
    var defaultColumns=[
        {header:'日期',dataIndex:'monDesc', width: 160,sortable:true,menuDisabled : true
        },{header:'指标代码',dataIndex:'kpiCode', width: 160, sortable: true ,menuDisabled : true
        },{header:'指标名称',dataIndex:'kpiDesc', width: 160, sortable: true ,menuDisabled : true
        },{header:'维度原始值',dataIndex:'dimId', width: 160, sortable: true,menuDisabled : true
		},{header:'维度名称',dataIndex:'dimDesc', width: 160, sortable: true,menuDisabled : true
        },{header:'值',dataIndex:'value', width: 80, sortable: true,menuDisabled : true
        }
    ];
    var columnModelKpiData = new Ext.grid.ColumnModel({});
    columnModelKpiData.setConfig(defaultColumns,false);
    var storeKpiData = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({
    		url:'dhcwl/kpi/showkpidata.csp?',
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
        }), 
        listeners :{
        	'loadexception':function(mes,paras,responseObj){
        		Ext.Msg.show({title:'错误',msg:responseObj.responseText,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	}
        }
    });
    var kpiDataGrid = new Ext.grid.GridPanel({
	  	height:245,
        store: storeKpiData,
        loadMask:true,
        cm: columnModelKpiData,
        bbar:new Ext.PagingToolbar({
            pageSize: 100,
            store: storeKpiData,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"/*,
            listeners :{
			'beforechange':function(pt,page){
				//alert(queryParamsNoSE);
				storeKpiData.proxy.setUrl((preUrl+"showkpidata.csp?"+ queryParamsNoSE));
			},
			'show':function(inthis){
				alert(storeKpiData.data.length+"   "+storeKpiData.getCount());
			},
			'afterrender':function(inthis){
				alert(storeKpiData.data.length+"   "+storeKpiData.getCount());
			}
			}*/
        })
    }); 
    
    var mainWin=new Ext.Window({
		id:'dhcwl.mkpi.ViewKpiData',
		//renderTo:Ext.getBody(),
		layout : 'border',
		width : 800,
		height : 440,
		autoScroll:true,
		plain : true,
		modal:true,
		title : '数据预览',
		items : [{
			height:155,
        	region:'north',
            items:setForm
    	},{
    		region:'center',
    		autoScroll:true,
    		items:kpiDataGrid
    	}],
    	listeners:{
    		/*"resize":function(win,width,height){
    			if(height!=400){
    				kpiDataGrid.setHeight(height-165);
    				kpiDataGrid.setWidth(width-20);
    			}
    		}*/
    	}
	});
	
    mainWin.on('afterrender',function( th ){
    	/*
    	var	arr=selectedKpis;
		var str="";
		for(var i=0;i<=arr.length-1;i++){
			if (str!="") str=str+",";
			str=str+arr[i].kpiCode;
		}
		if (str=="") return;
		dhcwl.mkpi.Util.ajaxExc(preUrl+'showkpidata.csp?action=getKpiCodes',{kpiIDs:str},
			function(jsonData){
							Ext.getBody().unmask();    
							if(jsonData.success==true && jsonData.tip=="ok"){
	                			kpiRuleCombo.setRawValue(jsonData.data);
	                			kpiRuleCombo.focus();

							}},this);
		Ext.getBody().mask("数据加载中，请稍等");    	
		*/			
	})	 	
	
	
	
	
	this.showWin=function(){
		
		mainWin.show();
	}
	this.setSelectedKpis=function(arr){
		selectedKpis=arr;
		/*
		var str="";
		for(var i=arr.length-1;i>0;i--){
			str=str+arr[i].kpiCode+",";
		}
		str=str+arr[0].kpiCode;
		kpiRuleCombo.setRawValue(str);
		kpiRuleCombo.setValue(str);
		*/
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