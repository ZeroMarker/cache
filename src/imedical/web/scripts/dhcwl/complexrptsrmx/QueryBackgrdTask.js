(function(){
	Ext.ns("dhcwl.complexrptsrmx.QueryBackgrdTask");
})();

Ext.onReady(function() {  
	 //var serviceUrl="dhcwl/docappcfg/getdockpidef.csp";
	 var serviceUrl="dhcwl/complexrptsrmx/rptquerybacktask.csp";
     //var serviceUrls="dhcwl/docappcfg/savedockpidef.csp";
     var kpiObj=null;  
      //复选框
      var selectedKpiIds=[];
      var csm=new Ext.grid.CheckboxSelectionModel({
	      listeners :{
		      rowselect: function(sm, row, rec) {
			      var rd=rec;   //sm.getSelected();
			      var ID=rec.get("ID");
			      //consForm.getForm().loadRecord(rec);
			  },
            'rowdeselect':function(sm, row, rec){
				var consId=rec.get("consId"),len=selectedKpiIds.length;
				for(var i=0;i<len;i++){
					if(selectedKpiIds[i]==consId){
						for(var j=i;j<len;j++){
							selectedKpiIds[j]=selectedKpiIds[j+1]
						}
						selectedKpiIds.length=len-1;
						break;
					}
				}
			}
		}
	});      
            //定义列
	var columnModel = new Ext.grid.ColumnModel([
		//new Ext.grid.RowNumberer(),csm,
        {header:'ID',dataIndex:'ID',sortable:true, width: 50, sortable: true
        },{header:'报表代码',dataIndex:'RptCode', width: 100, sortable: true 
        },{header:'报表名称',dataIndex:'RptName', width: 100, sortable: true 
        },{header:'报表描述',dataIndex:'RptDesc', width: 100, sortable: true, hidden:true
        },{header:'报表分类',dataIndex:'RptFL', width: 130, sortable: true,hidden:true
        },{header:'数据生成方式',dataIndex:'RptDataType', width: 130, sortable: true
        },{header:'执行状态',dataIndex:'RptExecState', width: 130, sortable: true
        },{header:'报表进程号',dataIndex:'RptPID', width: 130, sortable: true
        },{header:'创建日期',dataIndex:'RptUpdateDate', width: 130, sortable: true
        },{header:'备注',dataIndex:'RptRemark', width: 130, sortable: true,hidden:true
        }
    ]);
           //定义指标的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'ID'},
            	{name: 'RptCode'},
            	{name: 'RptName'},
            	{name: 'RptDesc'},
            	{name: 'RptFL'},
            	{name: 'RptDataType'},
            	{name: 'RptExecState'},
            	{name: 'RptPID'},
            	{name: 'RptUpdateDate'},
            	{name: 'RptRemark'}
       		]
    	})
    });
    //start
    var record= Ext.data.Record.create([
        {name: 'ID', type: 'int'},
        {name: 'RptCode', type: 'string'},
        {name: 'RptName', type: 'string'},
        {name: 'RptDesc',type: 'string'},
        {name: 'RptFL',type: 'string'},
        {name: 'RptDataType', type: 'string'},
        {name: 'RptExecState',type: 'string'},
        {name: 'RptPID',type: 'string'},
        {name: 'RptUpdateDate',type: 'string'},
        {name: 'RptRemark',type: 'string'}
	]);
	

	//end
    //分页控件
    var pageTool=new Ext.PagingToolbar({
        pageSize: 20,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录",
        listeners :{
			'change':function(pt,page){
				var id="",j=0,found=false,storeLen=selectedKpiIds.length;
				for(var i=store.getCount()-1;i>-1;i--){
					id=store.getAt(i).get("ID");
					found=false;
					for(j=storeLen-1;j>-1;j--){
						if(selectedKpiIds[j]==id) found=true;
					}
					if(found){
						//csm.selectRow(i,true,false);
					}
				}
			}
		}
    });
            
       
     //列表
     var grid = new Ext.grid.GridPanel({
         stripeRows:true,
         loadMask:true,
         height: 460,
         store: store,
	     id:"consTables",
         sm: csm,
         resizeAble:true, 
         enableColumnResize :true,
         bbar: pageTool,  //底部工具栏
		 cm: columnModel,
         listeners:{
        	'contextmenu':function(event){
        	 event.preventDefault();
        	 var sm = this.getSelectionModel();
        	 var record = sm.getSelected();
        	 if(record){
                 var record = sm.getSelected();
        	 }  
          }
        }          
     });
     
     
     var rptStateCombo=new Ext.form.ComboBox({
		width : 130,
		editable:false,
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '',
		value:'',
		name : 'rptStateCombo',
		id:  'MDocKPIDefType',
		displayField : 'isValid',
		valueField : 'isValidV',
		store : new Ext.data.JsonStore({
			fields : ['isValid', 'isValidV'],
			data : [{
				isValid : '',
				isValidV : ''
			},{
				isValid : '未完成',
				isValidV : '0'
			}, {
				isValid : '完成',
				isValidV : '1'
			}]}),
		listeners :{
			'select':function(combox){
				rptStateCombo.setValue(combox.getValue());
			}
		}
	});
	
	var rptStore =new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdefservice.csp?action=getBackgrdRpt'}),
		reader:new Ext.data.ArrayReader({},[{name:'rptCode'},{name:'rptName'}])
	})
	
		var rptCombo=new Ext.form.ComboBox({
		width : 200,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择报表',
		//fieldLabel : '',
		name : 'rptCombo',
		displayField : 'rptName',
		valueField : 'rptCode',
		store : rptStore,
		listeners :{
			'select':function(combox){
				rptCombo.setValue(combox.getRawValue());
				var rptName=rptCombo.getRawValue(); 
      			dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptdefservice.csp?action=getRptCond&RptName='+rptName
                        ,null,function(jsonData){
	                        if(!jsonData){
                				Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                				return;
                			}
                			/*if(jsonData.success==true){
                				var condStr=jsonData.tip;
                				QueryForm.getForm().findField('CondStr').setValue(condStr);       		
                			}*/
	             },this);	
			}
		}
	});
	
        //表单
        var queryForm=new Ext.FormPanel({
        //id: 'kpi-list',
        frame: true,
    	height: 58,
        //autoScroll:true,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
        style: {
        	//"margin-left": "10px", // when you add custom margin in IE 6...
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        layout: 'table',
        defaultConfig:{width:130},
        layoutConfig: {columns:14},
        items:[{
            html: '报表：'
        },rptCombo,{
		    html:'',
		    width:70
		},{
            html: '执行状态：'
        },rptStateCombo,{
		    html:'',
		    width:70
		},{
		    width:50,
		    frame:'true',
		    height:15,
		    text:'查询',
		    xtype:'button',
		    listeners:{
		    'click':function(){
                var rptName=rptCombo.getRawValue(); 
                var excState=rptStateCombo.getRawValue();
                if(excState=='完成'||excState=='1') excState=1;
                else if (excState=='未完成'||excState=='0') excState=0;
                paraValues='RptName='+rptName+'&RptExecState='+excState; 
                store.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSearch&'+paraValues+'&onePage=1'));
                //alert(paraValues);
            	store.load();
    			grid.show();
			  }
		    }
		  }]
  
	});
            
   var mcShowWin1 =new Ext.Panel({
    	title:'查询收入明细后台执行任务',
    	//layout:'auto', 
    	layout:'border',
        items: [{
        	region: 'north',
            height: 60,
            autoScroll:true,
            items:queryForm
        },{
        	region:'center',
        	autoScroll:true,
            items:grid
    	}]/*,
    	listeners:{
    		"resize":function(win,width,height){
    			grid.setHeight(height-150);
    			grid.setWidth(width-15);
    		}
    	}*/
    });
    
        var StDateField=new Ext.form.DateField ({
        xtype: 'datefield',
        format : 'Y-m-d',
        fieldLabel: '开始日期',
        name: 'startDate',
        id: 'startDate',
        invalidText:'无效日期格式',
        anchor : '80%',
        value:'2013-07-01'
        //value:new Date().add(Date.DAY, -1)  //new Date
     })	
                
    var EndDateField=new Ext.form.DateField ({
        format : 'Y-m-d',
        fieldLabel: '截止日期',
	    name: 'endDate',
	    id: 'endDate',
	    anchor : '80%',
	    //value:new Date().add(Date.DAY, -1)  //new Date
	    value:'2013-07-01'
     })
     
    var CreateData = new Ext.FormPanel({
		labelWidth : 60,
    	layout: 'table', 
		//region : 'north', //'border',		
		frame : true,
		title: "生成数据",
		height:70,
		//width:1160,
		//tbar:[FindButton], rowumns
		layoutConfig: {columns:14},
		items : [
		{
		    html:'',
		    width:20
		},{
			labelAlign : 'right',
			//columnWidth : .26,
			width:220,
			layout : "form",
			items : [   StDateField  ]
		},{
			labelAlign : 'right',
			//columnWidth : .26,
			width:220,
			layout : "form",
			items : [   EndDateField  ]
		},{
		    html:'',
		    width:35
		},{
		    width:50,
		    frame:'true',
		    height:15,
		    text:'生成数据',
		    hidden:false,  
		    xtype:'button',
		    listeners:{
		    'click':function(){
                /*var startDate=Ext.getCmp("startDate").getRawValue();       
     			var endDate=Ext.getCmp("endDate").getRawValue();
                var paraValues='RptName='+rptName+'&StartDate='+startDate+'&EndDate='+endDate;
				dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptcfgservice.csp?action=CreatTaskData&'+paraValues
				,null,function(jsonData){
					if(jsonData.success==true && jsonData.tip=="ok"){
			     		//Ext.Msg.alert("提示","保存成功！");
        				//rptStore.load()
        						//Ext.Msg.alert("提示",jsonData.tip);
					}else{
						//Ext.Msg.alert("提示","保存失败！");
					}		
				},this);*/
		    	var sm = grid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
                	alert("请选择要后台生成数据的进程");
                	return;
                }
                var rptName=record.get("RptName");                
		    	var startDate=Ext.getCmp("startDate").getRawValue();       
     			var endDate=Ext.getCmp("endDate").getRawValue();
     			var paraValues='RptName='+rptName+'&StartDate='+startDate+'&EndDate='+endDate;
                //var paraValues='RptName='+rptName;
		    	Ext.Msg.confirm('信息', '生成数据前，请先选择生成数据的时间段，确定要现在生成吗？', function(btn){
                    if (btn == 'yes') {
						dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptcfgservice.csp?action=CreatTaskData&'+paraValues
						,null,function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
			     				//Ext.Msg.alert("提示","数据生成成功！");
        						//Ext.Msg.alert("提示",jsonData.tip);
								store.load();
    							grid.show();
							}else{
								//Ext.Msg.alert("提示",jsonData.tip);
							}		
						},this);
                    }
                });	
                //store.load();
    			//grid.show();
                // 生成数据
                //alert("111")
                /*var paraValues='RptName='+rptName+'&StartDate='+startDate+'&EndDate='+endDate;
                dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptcfgservice.csp?action=CreatTaskData&'+paraValues
					,null,function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
							//store.load();
    						//grid.show();
						}else{
						}		
					},this);*/
			  }
		    }
		 }
		]
	});	        
	
     var mcShowWin =new Ext.Panel({
    	title:'查询收入明细后台执行任务',
    	//layout:'auto', 
    	layout:'table',
    	//rowumns: 1,
    	layoutConfig: {columns:1},
        items: [{
        	//region: 'north',
            height: 60,
            width:1300,
            //autoScroll:true,
            items:queryForm
        },{
        	//region: 'north',
            //height: 60,
            width:1300,
            //autoScroll:true,
            items:CreateData
        },{
        	//region:'center',
        	//autoScroll:true,
        	//width:800,
            items:grid
    	}]
    });
    
    store.load({params:{start:0,limit:20,onePage:1}});

	this.getStore=function(){
    	return store;
    }
    this.getColumnModel=function(){
    	return columnModel;
    }
    this.getMcShowWin=function(){
    	//kpiGrid.setHeight(kpiShowWin.getHeight()-158);
    	return mcShowWin;
    }
    this.getConsForm=function(){
    	return queryForm;
    }
    this.getMcGrid=function(){
    	return grid;
    }
    this.getRecord=function(){
    	return record;
    }
    
    this.mainWin=new Ext.Viewport({
    	id:'maintainMsgsMain',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        //width:1000,
        //heitht:800,
        items: [mcShowWin]
    });
    
     this.getDocKpiDefPanel=function(){
    	return mcShowWin;
    }
}

)

/*dhcwl.leadermsg.ShowMcWin.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI("dhcwlMsg/msg/getDocKpiDef.csp?action=mulSearch&onePage=1"));
	this.getStore().load();
    this.getMcGrid().show();
}*/
