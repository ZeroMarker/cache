(function(){
	Ext.ns("dhcwl.complexrptsrmx.WLDetailLook");
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
    ///////////////////////////////////////////////////////////////////////////////
    var StDateField=new Ext.form.DateField ({
        xtype: 'datefield',
        //format : 'Y-m-d',
        fieldLabel: '开始日期',
        name: 'startDate',
        id: 'startDate',
        invalidText:'无效日期格式',
        anchor : '80%',
        value:'2013-07-01'
        //value:new Date().add(Date.DAY, -1)  //new Date
     })	
                
    var EndDateField=new Ext.form.DateField ({
        //format : 'Y-m-d',
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
                				//var mRptCode=condStr
                				//combineStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdimservice.csp?action=getCombineST&mRptCode='+mRptCode}),
                				//combineStore.load(); 

                			}
	             },this);	
			}
		}
	});
	
	var dataTypeCombo=new Ext.form.ComboBox({
		width : 140,
		editable:false,
		hidden:true,  //暂时隐藏
		xtype : 'combo',
		mode : 'local',
		triggerAction : 'all',
		fieldLabel : '',
		emptyText:'请选择数据生成方式',
		value:'',
		name : 'dataTypeCombo',
		id:  'MDocKPIDefType',
		displayField : 'isValid',
		valueField : 'isValidV',
		store : new Ext.data.JsonStore({
			fields : ['isValid', 'isValidV'],
			data : [{
				isValid : '',
				isValidV : ''
			},{
				isValid : '实时数据',
				isValidV : '0'
			}, {
				isValid : '后台执行',
				isValidV : '1'
			}]}),
		listeners :{
			'select':function(combox){
				dataTypeCombo.setValue(combox.getValue());
				var dataType=dataTypeCombo.getRawValue(); 
				var rptName=rptCombo.getRawValue();  
				// (""==dataType)||(""==dataType)
				return
			    /*if(0){
                	//
                }else{
                	paraValues='RptName='+condStr+'&Text='+text;
					Ext.Msg.confirm('信息', '是否修改为所选择状态？', function(btn){
                    	if (btn == 'yes') {
							dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptcfgservice.csp?action=UpdateRptDataType&RptName='+rptName
							,null,function(jsonData){
								if(jsonData.success==true && jsonData.tip=="ok"){
			     					Ext.Msg.alert("提示","更新数据生成状态成功！");
        							//Ext.Msg.alert("提示",jsonData.tip);
								}else{
									Ext.Msg.alert("提示",jsonData.tip);
								}		
							},this);
                    	}
                	});	
				}*/
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
		layoutConfig: {columns:14},
		items : [
		{
		    html:'',
		    width:20
		   //height:8:20
		},{
			html:'报表:',
		    width:40
		},{
			html:'',
		    width:10
		}, rptCombo,{
		    html:'',
		    width:20
		},{
			html:'数据生成方式：',
		    width:80,
		    hidden:true  //暂时隐藏
		},dataTypeCombo,{
		    html:'',
		    width:70
		},{
		    width:50,
		    frame:'true',
		    height:15,
		    text:'保存',
		    hidden:true,   //暂时隐藏
		    xtype:'button',
		    listeners:{
		    'click':function(){
		    	var rptName=rptCombo.getRawValue();  
            	var rptDataType=dataTypeCombo.getRawValue(); 
            	if(""==rptDataType){
                	alert("请选择数据生成方式!");
                	return;
                }
                if(rptDataType=='后台执行'||rptDataType=='1') rptDataType='1';
                else rptDataType=0;
                if(0==rptDataType){ alert("实时数据不需要保存!"); return;}
                //alert("rptDataType="+rptDataType)
                var condStr=Ext.get('CondStr').getValue(); 
                var startDate=Ext.getCmp("startDate").getRawValue();       
     			var endDate=Ext.getCmp("endDate").getRawValue();
                var paraValues='RptName='+rptName+'&StartDate='+startDate+'&EndDate='+endDate+ '&RptCond='+ condStr;
                
				dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptcfgservice.csp?action=CreatBackgndData&'+paraValues
				,null,function(jsonData){
					if(jsonData.success==true && jsonData.tip=="ok"){
			     		Ext.Msg.alert("提示","保存成功！");
        				rptStore.load()
        				//Ext.Msg.alert("提示",jsonData.tip);
					}else{
						Ext.Msg.alert("提示","保存失败！");
					}		
				},this);
                // 在确认后台执行任务时，请先选择生成数据的时间段，后台会自动运行，是否确认？
                /*Ext.Msg.confirm('信息', '在确认后台执行任务时，请先选择生成数据的时间段，后台会自动运行，是否确认？', function(btn){
                   if (btn == 'yes') {
                   }
                });	*/
			  }
		    }
		 },{
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
                var condStr=Ext.get('CondStr').getValue();
                if((""==rptName)&&(""==condStr)){
                	alert("请选择已存在报表或者点击'配置报表'按钮配置报表条件!");
                	return;
                }
                if(""!=condStr){
                	var queryFlag=0;
                	typeFlagCombo.setValue("");
			    	FindData(queryFlag)
			    	return
                } 
      			/*dhcwl.mkpi.Util.ajaxExc('dhcwl/complexrptsrmx/rptdefservice.csp?action=getRptCond&RptName='+rptName
                        ,null,function(jsonData){
	                        if(!jsonData){
                				Ext.Msg.show({title:'错误',msg:"处理响应数据失败！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
                				return;
                			}
                			if(jsonData.success==true){
                				var condStr=jsonData.tip;
                				QueryForm.getForm().findField('CondStr').setValue(condStr);       		
                				var queryFlag=0;
                				typeFlagCombo.setValue("");
			    				FindData(queryFlag)
                			}
	             },this);*/
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
 									typeFlagCombo.setValue("");
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
            					hidden:true,  //暂时隐藏
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
                var rptName=rptCombo.getRawValue(); 
                //var paraValues='CondStr='+condStr; 
                if(""==rptName) {
					Ext.MessageBox.prompt("请写一个报表名称","",
						function(btn, text){
							if (btn == 'ok'){
								if (!text) {
									Ext.MessageBox.alert("消息","<font color=blue>查询前请先写报表名称</font>");
									return;
								}
								//paraValues='CondStr='+condStr+'&Text='+text;
								paraValues='RptName='+rptName+'&CondStr='+condStr+'&Text='+text;
								dhcwl.mkpi.Util.ajaxExc("dhcwl/complexrptsrmx/rptcfgservice.csp"+'?action=SaveRptCfg&'+paraValues,null,function(jsonData){
									if(jsonData.success==true && jsonData.tip=="ok"){
        								Ext.Msg.alert("提示","保存成功！");
        								rptStore.load()
        								//Ext.Msg.alert("提示",jsonData.tip);
									}else{
										Ext.Msg.alert("提示",jsonData.tip);
										//Ext.Msg.alert("提示","操作失败！");
									}		
								},this);	
							}
						},
					this,true,"");
                }else{
                	paraValues='RptName='+rptName+'&CondStr='+condStr+'&Text=1';
					dhcwl.mkpi.Util.ajaxExc("dhcwl/complexrptsrmx/rptcfgservice.csp"+'?action=SaveRptCfg&'+paraValues,null,function(jsonData){
					if(jsonData.success==true && jsonData.tip=="ok"){
        					Ext.Msg.alert("提示","保存成功！");
        					rptStore.load()
        					//Ext.Msg.alert("提示",jsonData.tip);
						}else{
							Ext.Msg.alert("提示",jsonData.tip);
							//Ext.Msg.alert("提示","操作失败！");
						}		
					},this);
                }	
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
	

	
	////////////////////////////////////////////////////////////////////////
	//合并/////////////
	var QueryForm1 = new Ext.FormPanel({
		labelWidth : 60,
    	layout: 'column', //table
		region : 'north', //'border',		
		frame : true,
		title: "合并选择",
		height:200,
		width:600,
		columns: 3,
        rowumns: 2,
		//tbar:[FindButton],
		//layoutConfig: {columns:1},
		items : [{
					layout : "column",
					width:800,
					items : [{
								html:'',
								width:800,
								height:8
							},{
								html:'',
								width:70
							},{
								width : 730,
								height : 32,
								items : typeFlagCombo
							}, {
								html:'',
								width:90
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
									var stCode=typeFlagCombo.getValue();
									if(""==stCode) return
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
							      }
						        }
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
				colspan: 1,
				rowspan: 1,
				width : 680,
				height : 100,
				items : QueryForm
		},{
				colspan: 1,
				rowspan: 1,
				width : 480,
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
    

    
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    //margins:'3 3 3 0', 
	    activeTab: 0,
	    height:480,
	    items:[{
	        //title: '润乾展示',
	        id:'list',    
			frameName: 'list',
			//height:480,
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
	    } 
	    ]
    
	});
	
   /* var mcShowWin =new Ext.Panel({
    	title:'医院收入明细查询',
    	//layout:'auto', 
    	layout:'border',
        items: [{
        	region: 'north',
            height: 105,
            autoScroll:true,
            items:rowPanel
        },{
        	region:'center',
        	autoScroll:true,
        	items:QueryTabs
    	}] 
    	//listeners:{
    	//	"resize":function(win,width,height){
    	//		grid.setHeight(height-150);
    	//		grid.setWidth(width-15);
    	//	}
    	//} 
    }); */
    
	var mcShowWin =new Ext.Panel({
    	title:'医院收入明细查询',
    	layout: {
        	type: 'table', 
        	columns: 1,
        	rowumns: 3
    	},
        items: [{
        	width : 1160,
            height: 105,
            //autoScroll:true,
            items:rowPanel
        },{
        	width : 1160,
        	height: 60,
        	//autoScroll:true,
        	items:RptSelForm
    	},{
        	width : 1160,
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
    
    ///////////////////////////////////////////////////////////////////
    ///Tabs定义
    //润乾报表
    function FindData(queryFlag)
 	{
	 	var startDate=Ext.getCmp("startDate").getRawValue();       
     	var endDate=Ext.getCmp("endDate").getRawValue();
	 	var p = Ext.getCmp("TblTabPanel").getActiveTab();
	 	var iframe = p.el.dom.getElementsByTagName("iframe")[0];
	 	var stCode=typeFlagCombo.getValue(); 
	 	var condStr=Ext.get('CondStr').getValue();
	    var rptName=rptCombo.getRawValue(); 
	    var dynParams=""
	    var parDimAttValue=""
	    var rptName=""
	    //var detFlag=1
        if((""==rptName)&&(""==condStr)){
            alert("请选择已存在报表或者点击'配置报表'按钮配置报表条件!");
            return;
        }
        combineStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/complexrptsrmx/rptdimservice.csp?action=getCombineST&condStr='+condStr}),
        combineStore.load();
	 	//iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-医院收入明细查询统计报表.raq&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode + '&queryFlag='+ queryFlag+ '&rptCond='+ condStr+ '&rptName='+ rptName+ '&detFlag='+ detFlag;   
 	    iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-医院收入明细查询统计报表.raq&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode + '&queryFlag='+ queryFlag+ '&rptCond='+ condStr+ '&rptName='+ rptName; 
 		//iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-医院收入明细查询统计报表.raq&queryFlag='+ queryFlag + '&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode + '&rptCond='+ condStr
 		//+ '&dynParams='+ dynParams+ '&parDimAttValue='+ parDimAttValue + '&detFlag='+ detFlag;   
 		
 		
        //iframe.src = 'dhccpmrunqianreport.csp?reportName=test-201502.raq&startDate='+ startDate + '&endDate='+ endDate+ '&stCode='+ stCode + '&queryFlag='+ queryFlag+ '&tempRpt='+ condStr;   
 	}
    
    ///获取参数
	function GetStrParam()
 	{
	 	var sDate=Ext.getCmp("startDate").getRawValue();       
     	var eDate=Ext.getCmp("endDate").getRawValue();
	 	//var type=Ext.getCmp("FindTypeCombo").getValue();
	 	startDate=sDate 
	 	endDate=eDate
	 	//findtype=type
 	}
 	
 	/////////////////////////////////////////////////////////////
 	/////////////////////////////////////////////////////////////
 	/////////////////////////////////////////////////////////////
 	/*function CombineData()
 	{
	 	//GetStrParam1(); 
	 	var startDate=Ext.getCmp("startDate").getRawValue();       
     	var endDate=Ext.getCmp("endDate").getRawValue();
     	//var stCode=typeFlagCombo.getRawValue();
     	var stCode=typeFlagCombo.getValue();
	 	var p = Ext.getCmp("TblTabPanel").getActiveTab();
	 	var iframe = p.el.dom.getElementsByTagName("iframe")[0];
	 	var queryFlag=1
	 	iframe.src = 'dhccpmrunqianreport.csp?reportName=DTHealth-DHCWL-医院收入明细查询统计报表.raq&startDate='+ startDate + '&endDate='+ endDate + '&stCode='+ stCode;   
 	}*/
 	
 	/*function GetStrParam1()
 	{
	 	var sDate=Ext.getCmp("startDate").getRawValue();       
     	var eDate=Ext.getCmp("endDate").getRawValue();
	 	//var type=Ext.getCmp("FindTypeCombo").getValue();
     	var stCode=typeFlagCombo.getRawValue();	
	 	startDate=sDate 
	 	endDate=eDate
	 	//findtype=type
 	}*/
    
    this.getForm=function(){
    	return QueryForm;
    }
    
    this.getRptCombo=function(){
    	return rptCombo;
    }
    
}


)

/*dhcwl.leadermsg.ShowMcWin.prototype.refresh=function(){
	this.getStore().proxy.setUrl(encodeURI("dhcwlMsg/msg/getDocKpiDef.csp?action=mulSearch&onePage=1"));
	this.getStore().load();
    this.getMcGrid().show();
}*/
