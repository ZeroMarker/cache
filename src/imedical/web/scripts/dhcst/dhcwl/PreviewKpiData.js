dhcwl.mkpi.PreviewKpiData=function(){
	var kpiList = [];
	var columnModelKpiData = new Ext.grid.ColumnModel([
        {header:'日期',dataIndex:'monDesc', width: 160,sortable:true
        },{header:'指标代码',dataIndex:'kpiCode', width: 160, sortable: true 
        },{header:'指标名称',dataIndex:'kpiDesc', width: 160, sortable: true 
        },{header:'维度名称',dataIndex:'dimDesc', width: 160, sortable: true
        },{header:'值',dataIndex:'value', width: 80, sortable: true
        }]
    );
    //var pvproxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/showkpidata.csp'});//'showKpiData.CSP?kpiId=1&dateType=freeDateChoice&isReal=1&section=D&isIgnoreTaskExc=0&action=preview&sDate=2012-04-01&eDate=2012-04-30'});
    var storeKpiData = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/showkpidata.csp'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'monDesc'},
            	{name: 'kpiCode'},
            	{name: 'kpiDesc'},
            	{name: 'dimDesc'},
            	{name: 'value',type: 'float'}
       	 	]
        })
    });
    var queryParams=null;
    var kpiDataGrid = new Ext.grid.GridPanel({
	  	height:300,
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
			'change':function(pt,page){
				storeKpiData.proxy.setUrl(encodeURI("dhcwl/kpi/showkpidata.csp?"+ queryParams));
			}
			}
        })
    });
    //storeKpiData.load({params:{start:0,limit:100}});
    var parentFiledGrid=new Ext.grid.GridPanel({
    	width:200,
    	autoHeight:true,
    	title:'任务区间类型',
    	store:new Ext.data.Store({
        	proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=sectionList'}),
        	reader: new Ext.data.JsonReader({
            	totalProperty: 'reslut',
            	root: 'root',
        		fields:[
            		{name: 'SecCode'},
            		{name: 'SecName'}
       			]
    		})
    	}),
    	columns:[{
    		header:'区间编码',dataIndex:'SecCode'
    	},{
    		header:'区间名称',dataIndex:'SecName'
    	}],
    	viewConfig:{forceFit:true}
    });
    var parentFiledSelectMenu=new Ext.menu.Menu({
    	boxMinWidth:200,
		ignoreParentClicks:true,
    	items:[parentFiledGrid]
    });
    parentFiledGrid.getStore().proxy.setUrl(encodeURI('dhcwl/kpi/kpiservice.csp?action=sectionList'));
    parentFiledGrid.getStore().load();
    parentFiledGrid.show();
    var parentFiled=new Ext.form.TriggerField({
    	fieldLabel:'任务区间类型',
    	name:'taskSection',
    	disabled:true,
    	onSelect:function(record){
    		
    	},
    	onTriggerClick:function(){
    		
    		if(this.menu==null){
    			this.menu=parentFiledSelectMenu;
    		}
    		this.menu.show(this.el,"tl-bl?");
    	}
    });
    parentFiledGrid.on("rowclick",function(grid,rowIndex,e){
    	parentFiledSelectMenu.hide();
    	var sm=grid.getSelectionModel();
        var record = sm.getSelected();
        var v=record.get("SecCode");
    	parentFiled.setValue(v);
    });
    var dateType="";
	var dateTypeCombo = new Ext.form.ComboBox({
		width : 150,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		forceSelection : true,
		editable : false,
		fieldLabel : '日期区间类型',
		name : 'modle',
		displayField : 'name',
		valueField : 'value',
		store : new Ext.data.JsonStore({
			fields : ['name', 'value'],
			data : [{
						name : '今天',
						value : 'torday'
					}, {
						name : '昨天',
						value : 'yesterday'
					}, {
						name : '上周',
						value : 'lastWeek'
					}, {
						name : '上月',
						value : 'lastMonth'
					}, {
						name : '去年',
						value : 'lastYear'
					}, {
						name : '本周',
						value : 'currentWeek'
					}, {
						name : '本月',
						value : 'currentMonth'
					}, {
						name : '本年',
						value : 'currentYear'
					}, {
						name : '按月区间统计',
						value : 'byMonth'
					}, {
						name : '按季区间统计',
						value : 'byQua'
					}, {
						name : '按年区间统计',
						value : 'byYear'
					}, {
						name : '按任意区间统计',
						value : 'freeDateChoice'
					}

			]
		}),
		listeners:{
	        'select':function(combo){
	        	//alert("combo="+combo.getValue()+"  "+combo.getRawValue())
	        	dateType=combo.getValue();//ele.getValue();
	        }
	    }
	});
    var conditionForm = new Ext.FormPanel({
		labelWidth : 125,
		frame : true,
		bodyStyle : 'padding:5px 5px 0',
		width : 800,
		defaults : {
			width : 175
		},
		items : [{
					fieldLabel : '开始日期',
					xtype : 'datefield',
					format : 'Y-m-d',
					name : 'startDate'
				}, {
					fieldLabel : '截止日期',
					name : 'endDate',
					xtype : 'datefield',
					format : 'Y-m-d'
				},dateTypeCombo,parentFiled, {
					xtype : 'radiogroup',
					fieldLabel : '数据类型',
					id : 'isReal',
					autoHeight : true,
					columns : 2,
					items : [{
								boxLabel : '历史数据',
								name : 'isRealtimeData',
								inputValue : 'H',
								checked : true
							}, {
								boxLabel : '实时数据',
								name : 'isRealtimeData',
								inputValue : 'R'
							}]
				}, {
					xtype : 'radiogroup',
					fieldLabel : '指标日期计算依据',
					id : 'isIgnoreTask',
					autoHeight : true,
					columns : 2,
					items : [ {
								boxLabel : '依据开始截止区间',
								name : 'isIgnoreTaskExc',
								inputValue : 'N',
								checked : true
							},{
								boxLabel : '依据区间任务',
								name : 'isIgnoreTaskExc',
								inputValue : 'Y'
							}]
				}, {
					buttons : [{
						text : '确定预览',
						handler : function() {
							if(kpiList.length==0){
								Ext.Msg.show({
											title : '提示！',
											msg : "还没有选择要预览的指标，请选选择预览指标!",
											icon : Ext.MessageBox.INFO,
											buttons : Ext.Msg.OK
										});
								return;
							}
							storeKpiData.clearData();
							storeKpiData.reload();
							storeKpiData.proxy.setUrl(encodeURI(""));
							storeKpiData.load();
							var vl = conditionForm.getForm().getValues(false);
							var sd = vl.startDate, ed = vl.endDate, isReal = vl.isRealtimeData, isIgnoreTaskExc = vl.isIgnoreTaskExc;
							//var dateType =dateTypeCombo.getValue();
							if (isReal == 'R') {
								isReal = 1;
							} else {
								isReal = 0;
								if(!dateType) 
									dateType="freeDateChoice";
							}
							var isIgnoreTaskExc = isIgnoreTaskExc == 'Y'
									? 1
									: 0;
							var previewKpis=kpiList.join(",");
							var selectSection=Ext.get('taskSection').getValue();
							if(!selectSection) selectSection="";
							var paras = 'kpiId=' + previewKpis + '&dateType='
									+ dateType + '&isReal=' + isReal
									+ '&section=' + selectSection;
							paras += "&isIgnoreTaskExc=" + isIgnoreTaskExc
									+ "&action=preview";
							paras += '&sDate=' + sd + '&eDate=' + ed;
							queryParams=paras;
							paras+="&start=0&limit=100"
							// paras+="&sDate=2012-04-01&eDate=2012-04-30";
							 //alert(paras);
							/*pvproxy
									.setUrl("dhcwl/kpi/showkpidata.cs[?"
											+ paras);
											*/
							//alert(paras);
							storeKpiData.proxy.setUrl(encodeURI("dhcwl/kpi/showkpidata.csp?"+ paras));
							storeKpiData.load(); //{params:{start:0,limit:30,onePage:1}});
							kpiDataGrid.show();
						}

					}, {
						text : '关闭',
						handler : function() {
							winKpiData.close();
						}
					}]
				}]
	});
	var mainPreviewPanel =new Ext.Panel({
    	layout:'border',
    	closeabled:true,
        items: [{
        	region: 'north',
            height: 260,
            items:conditionForm
        },{
        	region:'center',
        	autoScroll:true,
            items:kpiDataGrid
        }]
      });
	var winKpiData= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 1000,
		height : 600,
		autoScroll:true,
		plain : true,
		title : '指标数据预览',
		id : 'dhcwl_mkpi_previewKpiData',
		//closeAction:'hide',
		closable : true,
		//closeAction:'hide',
		items : mainPreviewPanel,
		listeners:{
			'close':function(){
				kpiList=[];
				dhcwl.mkpi.PreviewKpiData.create();
				winKpiData.destroy();
				winKpiData.close();
				if(dhcwl_mkpi_previewKpiData){
					dhcwl_mkpi_previewKpiData=null;
				}
			}
		}
	});
	this.showList=function(){
		if(kpiList.length>0){
			Ext.Msg.show({
				title : '提示！',
				msg : kpiList.join(","),
				icon : Ext.MessageBox.INFO,
				buttons : Ext.Msg.OK
			});
		}else{
			Ext.Msg.show({
				title : '提示！',
				msg : '预览列表为空',
				icon : Ext.MessageBox.INFO,
				buttons : Ext.Msg.OK
			});
		}
	}
	this.previewKpiData=function(){
    	winKpiData.show();
	}
	this.clearList=function(){
		kpiList=[];
	}
	this.getKpiListLength=function(){
		return kpiList.length;
	}
	this.add=function(kpiCode){
		if(!kpiCode) return;
		for(var i=kpiList.length-1;i>-1;i--){
			if(kpiList[i]==kpiCode)
				return;
		}
		kpiList.push(kpiCode);
	}
}
dhcwl.mkpi.PreviewKpiData.create=function(){
	dhcwl_mkpi_previewKpiData=new dhcwl.mkpi.PreviewKpiData();
	//return dhcwl_mkpi_previewKpiData;
}