(function(){
	Ext.ns("dhcwl.complexrptsrmx.WLDetailLookSub");
})();

Ext.onReady(function() {
	 var serviceUrl="dhcwl/complexrptsrmx/getdockpidef.csp";
     var serviceUrls="dhcwl/complexrptsrmx/savedockpidef.csp";
     var kpiObj=null;  
     Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
     Ext.Ajax.timeout = 900000;	
     var mRptCode="",mRptName=""
     this.mRptCode="" , this.mRptName=""
     var outThis=this;
    
   
 	
     //this.stCode=stCode
    ///////////////////////////////////////////////////////////////////////////////
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

    
   var combineStore =new Ext.data.Store({         
			proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdimservice.csp?action=getCombineST'}),
			reader:new Ext.data.ArrayReader({},[{name:'statItemCode'},{name:'statItemDesc'}])
		})
   
	
    var typeFlagCombo=new Ext.form.ComboBox({
		width : 300,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择合并内容',
		//fieldLabel : '日期区间类型',
		name : 'typeFlagCombo',
		displayField : 'statItemDesc',
		valueField : 'statItemCode',         
		store : combineStore,
		listeners :{
			'select':function(combox){
				typeFlagCombo.setValue(combox.getRawValue());
			}
		}
	});
   
 
	
	var rptStore =new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdefservice.csp?action=getRptCombo'}),
		reader:new Ext.data.ArrayReader({},[{name:'rptCode'},{name:'rptName'}])
	})
	
	var rptCombo=new Ext.form.ComboBox({
		width : 300,
		editable:false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		emptyText:'请选择报表',
		//fieldLabel : '',
		name : 'rptCombo',
		displayField : 'rptName',
		valueField : 'rptCode',
		store : rptStore,/*new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdefservice.csp?action=getRptCombo'}),
			//proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'}),
			reader:new Ext.data.ArrayReader({},[{name:'rptCode'},{name:'rptName'}])
		}),*/
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
                			if(jsonData.success==true){
                				var condStr=jsonData.tip;
                				QueryForm.getForm().findField('CondStr').setValue(condStr);       		
                			}
	             },this);	
			}
		}
	});
	
	var RptSelForm = new Ext.FormPanel({
		labelWidth : 60,
    	layout: 'table', 
		//region : 'north', //'border',		
		frame : true,
		title: "报表选择",
		height:200,
		//width:1160,
		//tbar:[FindButton], rowumns
		layoutConfig: {columns:12},
		items : [
		{
		    html:'',
		    width:20
		   //height:8:20
		},{
			html:'请选择报表:',
		    width:60
		},{
			html:'',
		    width:20
		}, rptCombo,{
		    html:'',
		    width:50
		},{
			html:'',
		    width:20
		},{
		    width:50,
		    frame:'true',
		    height:15,
		    text:'查询',
		    xtype:'button',
		    listeners:{
		    'click':function(){
                var rptName=rptCombo.getRawValue(); 
                var condStr=Ext.get('CondStr').getValue();
                if((""==rptName)&&(""==condStr)){
                	alert("请选择已存在报表或者点击'配置报表'按钮配置报表条件!");
                	return;
                }
                if(""!=condStr){
                	var queryFlag=0;
			    	FindData(queryFlag)
			    	return
                } 
      			dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptdefservice.csp?action=getRptCond&RptName='+rptName
                        ,null,function(jsonData){
	                        if(!jsonData){
                				Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                				return;
                			}
                			if(jsonData.success==true){
                				var condStr=jsonData.tip;
                				QueryForm.getForm().findField('CondStr').setValue(condStr);       		
                				var queryFlag=0;
			    				FindData(queryFlag)
                			}
	             },this);	
			  }
		    }
		  },{
			html:'',
			width:50
		 },{
		    width:50,
		    frame:'true',
		    height:15,
		    text:'删除',
		    hidden:true,  //暂时隐藏
		    xtype:'button',
		    listeners:{
		    'click':function(){
			    var rptName=rptCombo.getRawValue(); 
			    if(""==rptName){
                	alert("没有选择报表,不能删除!");
                	return;
                }
			    Ext.Msg.confirm('信息', '删除报表时，会删除报表及其所有的配置，确定要删除？', function(btn){
                    if (btn == 'yes') {
						dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptcfgservice.csp?action=DeleteRpt&RptName='+rptName
						,null,function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
			     				Ext.Msg.alert("提示","删除成功！");
        						rptStore.load()
        						rptCombo.setValue("");
        						//Ext.Msg.alert("提示",jsonData.tip);
							}else{
								Ext.Msg.alert("提示",jsonData.tip);
							}		
						},this);
                    }
                });	
			  }
		    }
		 },{
			html:'',
			width:50
		 },{
		    width:50,
		    frame:'true',
		    height:15,
		    text:'保存',
		    hidden:true,  //暂时隐藏
		    xtype:'button',
		    listeners:{
		    'click':function(){
            	var condStr=Ext.get('CondStr').getValue();
            	if(""==condStr){
                	alert("报表还没有配置条件,不能保存!");
                	return;
                }
                var paraValues='CondStr='+condStr; 
				Ext.MessageBox.prompt("请写一个报表名称","",
						function(btn, text){
							if (btn == 'ok'){
								if (!text) {
									Ext.MessageBox.alert("消息","<font color=blue>查询前请先写报表名称</font>");
									return;
								}
								paraValues='CondStr='+condStr+'&Text='+text;
								dhcwl.mkpi.Util.ajaxExc("dhcwl/complexrptsrmx/rptcfgservice.csp"+'?action=SaveRptCfg&'+paraValues,null,function(jsonData){
									if(jsonData.success==true && jsonData.tip=="ok"){
        								Ext.Msg.alert("提示","保存成功！");
        								//Ext.Msg.alert("提示",jsonData.tip);
									}else{
										Ext.Msg.alert("提示",jsonData.tip);
										//Ext.Msg.alert("提示","操作失败！");
									}		
								},this);	
							}
						},
					this,true,"");
			  }
		    }
		 }  
		 
		]
	});	        
	

    var QueryForm = new Ext.FormPanel({
    	hidden:true,
		labelWidth : 60,
    	//layout: 'table',
		region : 'north', //'border',
		//title:'EXT内嵌润乾测试实例',
		frame : true,
		title:"查询区域",
		height:105,
		width:800,
		//tbar:[FindButton],
		items : [{
					layout : "column",
					width:1000,
					items : [{
								labelAlign : 'right',
								columnWidth : .26,
								layout : "form",
								items : [   StDateField  ]
							}, {
								labelAlign : 'right',
								columnWidth : .26,
								layout : "form",
								items : [   EndDateField  ]
							},{
								html:'',
								width:20
							},{
								width:50,
								frame:'true',
								height:20,
								text:'查询',
								hidden:true, //暂时隐藏
								xtype:'button',
								listeners:{
								'click':function(){
									//Ext.getCmp('textZone').setValue("");
									var queryFlag=0
									FindData(queryFlag);   
							      }
						        }
								//[FindButton]
						     },
						     {
            					name: 'CondStr',
            					id: 'CondStr',
            					xtype:'textfield',
            					//anchor:'25%',
            					width:50,
            					disabled:false
        					}
					  ]		   
			     }
			  ],
		 tbar:new Ext.Toolbar([{
            text: '  配置报表  ',
            handler: function(){
                //var mRptCode="Rpt1";
		  		//var mRptName="报表1";
		  		var mRptCode="99999";
		  		var mRptName="99999";
		  		var condStr=Ext.get('CondStr').getValue();
		  		if (condStr!="") {
                	var rptWinCfg=new dhcwl.complexrptsrmx.TestRow(condStr,condStr);
		  		}
		  		else{
		  			var rptWinCfg=new dhcwl.complexrptsrmx.TestRow(mRptCode,mRptName);
		  		}
				rptWinCfg.showRptCfgWin(outThis) ;// .show();
				//rptStore.load()
            }
        },'-',{
        	cls:'align:right',
        	text   : '保存报表',
            handler: function() {
            	var condStr=Ext.get('CondStr').getValue();
            	if(""==condStr){
                	alert("报表还没有配置条件,不能保存!");
                	return;
                }
                var paraValues='CondStr='+condStr; 
				Ext.MessageBox.prompt("请写一个报表名称","",
						function(btn, text){
							if (btn == 'ok'){
								if (!text) {
									Ext.MessageBox.alert("消息","<font color=blue>查询前请先写报表名称</font>");
									return;
								}
								paraValues='CondStr='+condStr+'&Text='+text;
								dhcwl.mkpi.Util.ajaxExc("dhcwl/complexrptsrmx/rptcfgservice.csp"+'?action=SaveRptCfg&'+paraValues,null,function(jsonData){
									if(jsonData.success==true && jsonData.tip=="ok"){
        								Ext.Msg.alert("提示","保存成功！");
        								//Ext.Msg.alert("提示",jsonData.tip);
									}else{
										Ext.Msg.alert("提示",jsonData.tip);
										//Ext.Msg.alert("提示","操作失败！");
									}		
								},this);	
							}
						},
					this,true,"");
           	}
         } ,'-', {
            text: '删除报表',
            handler: function(){            
			    var rptName=rptCombo.getRawValue(); 
			    if(""==rptName){
                	alert("没有选择报表,不能删除!");
                	return;
                }
			    Ext.Msg.confirm('信息', '删除报表时，会删除报表及其所有的配置，确定要删除？', function(btn){
                    if (btn == 'yes') {
						dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptcfgservice.csp?action=DeleteRpt&RptName='+rptName
						,null,function(jsonData){
							if(jsonData.success==true && jsonData.tip=="ok"){
			     				Ext.Msg.alert("提示","删除成功！");
        						rptStore.load()
        						rptCombo.setValue("");
        						//Ext.Msg.alert("提示",jsonData.tip);
							}else{
								Ext.Msg.alert("提示",jsonData.tip);
							}		
						},this);
                    }
                });	
            }
        }
        //
      ])
      
	});	
	

	var QueryForm1 = new Ext.FormPanel({
		labelWidth : 60,
    	layout: 'column', //table
		region : 'north', //'border',		
		frame : true,
		title: "合并选择",
		height:200,
		//width:600,
		columns: 3,
        rowumns: 2,
		//tbar:[FindButton],
		//layoutConfig: {columns:1},
		items : [{
					layout : "column",
					width:2000,
					items : [{
								html:'',
								width:2000,
								height:1
							},{
								html:'',
								width:500
							},{
								width : 1500,
								height : 32,
								items : typeFlagCombo
							}, {
								html:'',
								width:520
							},{
								width:50,
								frame:'true',
								height:15,
								text:'合并',
								xtype:'button',
								listeners:{
								'click':function(){
									//Ext.getCmp('textZone').setValue("");
									//CombineData(); 
									var queryFlag=1
									FindData(queryFlag)
							      }
						        }
							},{
								html:'',
								width:50
							},{
								width:50,
								frame:'true',
								height:15,
								text:'还原',
								xtype:'button',
								listeners:{
								'click':function(){
									//Ext.getCmp('textZone').setValue("");
									var queryFlag=2
									FindData(queryFlag); 
							      }
						        }
						     },{
								html:'',
								width:50
							 },{
								width:50,
								frame:'true',
								height:15,
								text:'清空',
								xtype:'button',
								listeners:{
								'click':function(){
									//Ext.getCmp('typeFlagCombo').setValue("");
									//FindData(); 
									typeFlagCombo.setValue("");
									//var queryFlag=0
									//FindData(queryFlag); 
							      }
						        }
						     },{
						     	//layout : "form",
								//items : [   StDateField  ]
						     },{
						     	//items : [   EndDateField  ]
						     }
						     
					      ]		   
			     }
			  ]
	});	
	
	

	

 var rowPanel = new Ext.Panel({
		layout: {
        	type: 'table', 
        	columns: 2,
        	rowumns: 1
    	},
		items : [{
			    hidden:true,
				colspan: 1,
				rowspan: 1,
				width : 680,
				height : 100,
				items : QueryForm
		},{
				colspan: 1,
				rowspan: 1,
				width : 2000,
				height : 100,
				items : QueryForm1
		}]
  	});
  	

      //复选框
      var selectedKpiIds=[];
      var csm=new Ext.grid.CheckboxSelectionModel({
	      listeners :{
		      rowselect: function(sm, row, rec) {
			      var rd=rec;   //sm.getSelected();
			      var ID=rec.get("ID");
			      consForm.getForm().loadRecord(rec);
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
    
           //定义指标的存储模型
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=mulSearch'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'ID'},
            	{name: 'MDocKPIDefCode'},
            	{name: 'MDocKPIDefDesc'},
            	{name: 'MDocKPIDefType'},
            	{name: 'MDocKPIUpdateDate'}/*,
            	{name: 'consReMark'}*/
       		]
    	})
    });
    


    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    //margins:'3 3 3 0', 
	    activeTab: 0,
	    height:580,
	    items:[{
	        //title: '润乾展示',
	        id:'list',    
			frameName: 'list',
			//height:480,
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
	    } 
	    ]
    
	});
	

    
	var mcShowWin =new Ext.Panel({
    	title:'医院收入明细查询',
    	layout: {
        	type: 'table', 
        	columns: 1,
        	rowumns: 3
    	},
        items: [{
        	width : 3000,
            height: 105,
            //autoScroll:true,
            items:rowPanel
        },/*{
        	width : 1160,
        	height: 60,
        	//autoScroll:true,
        	items:RptSelForm
    	},*/{
        	width : 1360,
        	//autoScroll:true,
        	items:QueryTabs
    	}]/*, 
    	listeners:{
    		"resize":function(win,width,height){
    			mcShowWin.setHeight(height-150);
    			mcShowWin.setWidth(width-15);
    		}
    	} */
    }); 
    
    
    
    // RptSelForm
    
    /*store.load({params:{start:0,limit:20,onePage:1}});

	this.getStore=function(){
    	return store;
    }*/
    this.getColumnModel=function(){
    	return columnModel;
    }
    this.getMcShowWin=function(){
    	//kpiGrid.setHeight(kpiShowWin.getHeight()-158);
    	return mcShowWin;
    }
    this.getConsForm=function(){
    	return consForm;
    }
    this.getMcGrid=function(){
    	return grid;
    }
    /*this.getRecord=function(){
    	return record;
    }*/
    
    this.mainWin=new Ext.Viewport({
    	id:'maintainMsgsMain',
        //renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit', //'fit',
        //width:1000,
        //heitht:800,
        items: [mcShowWin]
        //items: [QueryForm,QueryTabs]
    });
    
     this.getDocKpiDefPanel=function(){
    	return mcShowWin;
    }
    

    this.getForm=function(){
    	return QueryForm;
    }
    
    this.getRptCombo=function(){
    	return rptCombo;
    }
    
   InnitMainPagePar(2); //加载弹出页参数(InnitMainPagePar). 2:弹出页从从已经查询结果中进行过滤
    
   function InnitMainPagePar(queryFlag)
 	{
 		var haText = document.getElementById("hrefParamsDiv").innerText 
 		//alert("haText="+haText);
 		/*var parDimAttValue=haText.split(",")[0].split(":")[1]
 		var stCode=haText.split(":")[1].split(",")[1]
        var startDate=haText.split(":")[2].split(",")[1]
        var endDate=haText.split(":")[3].split(",")[1]
        var rptCond=haText.split(":")[4].split(",")[1]*/
 		var detFlag=haText.split("^")[0].split(":")[1]
 		
        var endDate=haText.split("^")[1].split(":")[1]
 		var parDimAttValue=haText.split("^")[2].split(":")[1]
        var rptCond=haText.split("^")[3].split(":")[1]
        var stCode=haText.split("^")[4].split(":")[1]
        var startDate=haText.split("^")[5].split(":")[1]
        
        /*alert("startDate="+startDate);
        alert("endDate="+endDate);
        alert("rptCond="+rptCond);
        alert("detFlag="+detFlag);*/
        
        this.rptCond=rptCond
        this.parDimAttValue=parDimAttValue
        this.stCode=stCode
   		//var queryFlag=0
   		
	 	var p = Ext.getCmp("TblTabPanel").getActiveTab();
	 	var iframe = p.el.dom.getElementsByTagName("iframe")[0];
	    var str=endDate+"^"+parDimAttValue+"^"+rptCond+"^"+stCode+"^"+startDate
	    //alert("str="+str)
        combineStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdimservice.csp?action=getCombineST&condStr='+rptCond}),
        combineStore.load();
        //var stCode=""
	 	//iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-医院收入明细查询统计报表-明细.raq&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode + '&queryFlag='+ queryFlag+ '&rptCond='+ rptCond; 
 		iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-WorkLoadDetail.raq&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode +
 		'&queryFlag='+ queryFlag+ '&rptCond='+ rptCond+ '&parDimAttValue='+ parDimAttValue+ '&detFlag='+ detFlag; 
 	}
 	
 	function FindData(queryFlag)
 	{
	 	var startDate=Ext.getCmp("startDate").getRawValue();       
     	var endDate=Ext.getCmp("endDate").getRawValue();
	 	var p = Ext.getCmp("TblTabPanel").getActiveTab();
	 	var iframe = p.el.dom.getElementsByTagName("iframe")[0];
	 	var stCode=typeFlagCombo.getValue(); 
	 	//var condStr=Ext.get('CondStr').getValue();
	 	var condStr=this.rptCond
	    /*var rptName=rptCombo.getRawValue(); 
        if((""==rptName)&&(""==condStr)){
            alert("请选择已存在报表或者点击'配置报表'按钮配置报表条件!");
            return;
        }*/
	 	if(2==queryFlag) {stCode=this.stCode;
	 	var detFlag=2; }
	 	//alert("stCode="+stCode+"@"+"queryFlag="+queryFlag+"@"+"parDimAttValue="+this.parDimAttValue)
        //combineStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdimservice.csp?action=getCombineST&condStr='+condStr}),
        //combineStore.load();
	 	
	 	iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-WorkLoadDetail.raq&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode + '&queryFlag='+ queryFlag
	 	+ '&rptCond='+ condStr + '&parDimAttValue='+ this.parDimAttValue+ '&detFlag='+ detFlag;   
 		//iframe.src = 'dhccpmrunqianreport.csp?reportName=test-201502.raq&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode + '&queryFlag='+ queryFlag+ '&tempRpt='+ condStr;   
 	}
 	
 	
 	
}


)

/*dhcwl.leadermsg.ShowMcWin.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI("dhcwlMsg/msg/getDocKpiDef.csp?action=mulSearch&onePage=1"));
	this.getStore().load();
    this.getMcGrid().show();
}*/
