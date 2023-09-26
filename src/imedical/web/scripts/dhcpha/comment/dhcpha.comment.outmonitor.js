///处方点评主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20
///

var unitsUrl = 'dhcpha.comment.outmonitor.save.csp';
var waitMask;
var InputStr;
var RightMenuRow;  //右键菜单所在行




Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  Ext.Ajax.timeout = 900000;
  //StartDaTongDll();
  
  PatInfo =  {
	adm: 0,
        patientID:0,
        episodeID:0,
        admType:"I",
        prescno:0,
        orditem:0,
        zcyflag:0
  };
  
       //重新load Tab,并加载数据
  var HrefRefresh = function (){
         
         
        var adm=PatInfo.adm; 
        var prescno=PatInfo.prescno ;
        var zcyflag=PatInfo.zcyflag;
    
	        
		var p = Ext.getCmp("ToolsTabPanel").getActiveTab();	
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		
		if (p.id=="framepaallergy"){
		  iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framerisquery"){
		 iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framelabquery"){
		  iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="frameprbrowser"){
		  iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
		}	
		
	
		
		//明细
		if (p.id=="frameordquery"){
		
			 if (adm==0) return;
                         FindOrdDetailData(prescno);

		}
		

		//本次医嘱
		if (p.id=="frameadmordquery"){
		  iframe.src=p.src + '?EpisodeID=' + adm ;
		}
		
		//处方预览
		if (p.id=="prescriptioninfo"){			
		
			  if (zcyflag==0)
			  {
			  	iframe.src='dhcpha.comment.prescriptioninfo.csp' + '?PrescNo=' + prescno +'&EpisodeID='+ adm ;				
						
			  }else{
			  	
			  	iframe.src='dhcpha.comment.cyprescriptioninfo.csp' + '?PrescNo=' + prescno +'&EpisodeID='+ adm ;
			  }
		  
		  
		}	
		

		
   }
   
  
  	   //刷新
   var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '查询',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindWardList();
                              
                              }   
             }
             
             
   })
  
   
   	   //读卡
   var  ReadCardButton = new Ext.Button({
             width : 70,
             id:"ReadCardBtn",
             text: '读卡',
             icon:"../scripts/dhcpha/img/menuopera.gif",
             listeners:{
                          "click":function(){   
                             
                                 BtnReadCardHandler();
                              
                              }   
             }
             
             
   })


  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: '通过',
             icon:"../scripts/dhcpha/img/update.png",
             listeners:{
                          "click":function(){   
                             
                              CommontOk();
                              
                              }   
             }
             
             
             })
             
  var BadButton = new Ext.Button({
             width : 65,
             id:"BadButton",
             text: '拒绝',
             icon:"../scripts/dhcpha/img/cancel.png",
             listeners:{
                        "click":function(){
                            EditReason();
                        }
             }
             
             })
             
         

       
             
   var ListLogButton = new Ext.Button({
             width : 65,
             id:"ListLogBtn",
             text: '查看日志',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              ListLogBtnClick();
                              
                              }   
             }
             
             
    })
    
    
    var DaTongAnalyseButton = new Ext.Button({
             width : 65,
             id:"DaTongAnalyseBtn",
             text: '处方分析',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              DaTongPrescAnalyse();
                              
                              }   
             }
             
             
    })
    
     var DaTongYDTSButton = new Ext.Button({
             width : 65,
             id:"DaTongYDTSBtn",
             text: '要点提示',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              DaTongYDTSBtnClick();
                              
                              }   
             }
             
             
    })
        
    
   //已审核
   var OnlyAdtChkbox=new Ext.form.Checkbox({
        
		boxLabel : '仅已审',
		id : 'OnlyAdtChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    
    CardTypeStore = eval("(" + CardTypeArray + ')');
    
    var CardTypeComBo = new Ext.form.ComboBox({
			fieldLabel:'卡类型',
			width : 120,
			typeAhead : true,
			height : 100,
			//renderTo:'LocListDiv',
			triggerAction : 'all',
			store : new Ext.data.ArrayStore({
				autoDestroy : true,
				fields : ['desc', 'value'],
				data : CardTypeStore
				
			}),
			mode : 'local',
			valueField : 'value',
			displayField : 'desc',
			listeners : {
				//change: LocChangeHandler
			}
		});
		
 
    //查找病人列表控件
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, ['result',
	            'druguse',
	            'patid',
	            'patname',
	            'patsex',
	            'patage',
	            'path',
	            'patw',
	            'billtype',
	            'prescno',
		    'patloc',
		    'diag',
		    'adm',
		    'orditem',
		    'zcyflag'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	  var sm = new Ext.grid.CheckboxSelectionModel(); 
	  var nm = new Ext.grid.RowNumberer();
	  var patlistcm = new Ext.grid.ColumnModel([nm,sm,
	  
	        {header:'结果',dataIndex:'result',width: 60,menuDisabled :'false'},
                {header:'合理用药',dataIndex:'druguse',width: 60,menuDisabled :'false'},
	        {header:'登记号',dataIndex:'patid',width: 90,menuDisabled :'false'},
	        {header:'姓名',dataIndex:'patname',width: 60,menuDisabled :'false'},
	        {header:'性别',dataIndex:'patsex',width: 60,menuDisabled :'false'},
	        {header:'年龄',dataIndex:'patage',width: 60,menuDisabled :'false'},
	        {header:'身高',dataIndex:'path',width: 60,menuDisabled :'false'},
	        {header:'体重',dataIndex:'patw',width: 60,menuDisabled :'false'},
	        {header:'费别',dataIndex:'billtype',width: 90,menuDisabled :'false'},
	        {header:'处方号',dataIndex:'prescno',width: 120,menuDisabled :'false'},
	        {header:'就诊科室',dataIndex:'patloc',width: 90,menuDisabled :'false'},
	        {header:'诊断',dataIndex:'diag',width: 400,menuDisabled :'false'},
	        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'},
	        {header:'orditem',dataIndex:'orditem',width: 90,hidden:'true'},
	        {header:'zcyflag',dataIndex:'zcyflag',width: 90,hidden:'true'}
	       
	       ]);
	    
	 var patlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:patlistst,
				pageSize:200,
				//显示右下角信息
				displayInfo:true,
				displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
			        prevText:"上一页",
				nextText:"下一页",
				refreshText:"刷新",
				lastText:"最后页",
				firstText:"第一页",
				beforePageText:"当前页",
				afterPageText:"共{0}页",
	    		        emptyMsg: "没有数据"
		});
	  
	  var patlistgrid = new Ext.grid.GridPanel({
	        id:'patlisttbl',
		region:'center',
                margins:'3 3 3 3', 
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patlistst,
	        cm: patlistcm,
	        sm : sm,
	        bbar: patlistgridPagingToolbar,
	        trackMouseOver:'true'
	    });
	    
	///就诊列表grid 单击行事件

	    patlistgrid.on('rowclick',function(grid,rowIndex,e){
	
	        var selectedRow = patlistst.data.items[rowIndex];
		var adm = selectedRow.data["adm"];
	        var prescno = selectedRow.data["prescno"];
	        var zcyflag = selectedRow.data["zcyflag"];
	        
	        ClearWindow();
	        PatInfo.adm=adm;
	        PatInfo.prescno =prescno;
	        PatInfo.zcyflag=zcyflag;

	        HrefRefresh(); 
	
			
			
	    });  
	    
	    
	    patlistgrid.on('cellclick',PatListGridCellClick)
	    
    
         ///医嘱明细数据table
    

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[

        {header:'药品名称',dataIndex:'incidesc',width:150},
        {header:'数量',dataIndex:'qty',width:40},
        {header:'单位',dataIndex:'uomdesc',width:60},
        {header:'剂量',dataIndex:'dosage',width:60},
        {header:'频次',dataIndex:'freq',width:40},
        {header:'规格',dataIndex:'spec',width:80},
        {header:'用法',dataIndex:'instruc',width:80},
        {header:'用药疗程',dataIndex:'dura',width:60},
        {header:'实用疗程',dataIndex:'realdura',width:60},
        {header:'剂型',dataIndex:'form',width:80},
        {header:'基本药物',dataIndex:'basflag',width:50},
        {header:'医生',dataIndex:'doctor',width:60},
        {header:'医嘱开单日期',dataIndex:'orddate',width:120},
        {header:'医嘱备注',dataIndex:'remark',width:60},
        {header:'厂家',dataIndex:'manf',width:150},
        {header:'rowid',dataIndex:'orditm',hidden:true}
        
        
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            
            'incidesc',
            'qty',
		    'uomdesc',
		    'dosage',
		    'freq',
		    'spec',
		    'instruc',
		    'dura',
		    'realdura',
		    'form',
		    'basflag',
		    'doctor',
		    'orddate',
		    'remark',
		    'manf',
		    'orditm'
	    
		]),
		
		

    remoteSort: true
});

     
 var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({	
			store:orddetailgridds,
			pageSize:200,
			//显示右下角信息
			displayInfo:true,
			displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
		        prevText:"上一页",
			nextText:"下一页",
			refreshText:"刷新",
			lastText:"最后页",
			firstText:"第一页",
			beforePageText:"当前页",
			afterPageText:"共{0}页",
    		        emptyMsg: "没有数据"
	});
 
 
 var orddetailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'3 3 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
        
        
        trackMouseOver:'true'
        

        
    });
	
	
	 //药房审方窗口控件

	
	var adtwinds = new Ext.data.Store({
		autoLoad: true,
		//proxy:"",
		url:unitsUrl+'?action=GetAdtWinDs&CTlocDr='+session['LOGON.CTLOCID'],
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['windesc','rowId'])
				
	});
	
	 
	 
	 var adtwinSelecter = new Ext.form.ComboBox({
				  id:'adtwinSelect',
				  fieldLabel:'审方窗口',
				  width : 120,
				  store: adtwinds,
				  valueField:'rowId',
				  displayField:'windesc',
				  listWidth:250,
				  emptyText:'选择审方窗口...',
		                  //allowBlank: false,
				  name:'adtwinSelect',
				  mode: 'local'
				  
				  		  
				  
	});
	
	
      
    	 //药房科室控件

	
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		//proxy:"",
		url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+session['LOGON.GROUPID'],
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
				
	});
	
	 
	 
	 var PhaLocSelecter = new Ext.form.ComboBox({
				  id:'PhaLocSelecter',
				  fieldLabel:'药房科室',
				  width : 120,
				  store: phlocInfo,
				  valueField:'rowId',
				  displayField:'phlocdesc',
				  listWidth:250,
				  emptyText:'选择药房科室...',
		                  allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	
 //初始化药房科室
 //phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	phlocInfo.on('load', function() {   
    	PhaLocSelecter.setValue(session['LOGON.CTLOCID'].toString());   
    }); 
 
 	PhaLocSelecter.on(
	'select',
	function(){		
		adtwinds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetAdtWinDs&CTlocDr='+Ext.getCmp("PhaLocSelecter").getValue(), method:'GET'});
	        adtwinds.load();
		}
  	);
 
 //开始日期
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                value:new Date
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 120,
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:new Date
            })
    
  
     
        
        
     //病人登记号查询工具

	
	var patientField=new Ext.form.TextField({
  
        width:120, 
        id:"patientTxt", 
        fieldLabel:"登记号" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                FindWardList();
                            }
                        }
                    }
        })
        

   
     var DatePanel = new Ext.Panel({
         frame : true,
         bbar:[RefreshButton,'-',ReadCardButton,"-",OkButton,"-",BadButton,'-',ListLogButton,DaTongAnalyseButton,DaTongYDTSButton ],
         labelWidth:80,
         region:'center',
          items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [ PhaLocSelecter   ]
							 }, {
							    labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  stdatef   ]
							    
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  enddatef ]
								
						        } ]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .3,
										layout : "form",
										items : [  patientField  ]
									 },{
						        
						        labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  CardTypeComBo ]
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  OnlyAdtChkbox ]
								
						        }
						        
						        ]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .3,
										layout : "form",
										items : [ adtwinSelecter   ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .3,
										layout : "form",
										items : [    ]
									 }]
					  }
					
					
					]

      
   })
    
    ////
    
     var toolform = new Ext.TabPanel({
        id:'ToolsTabPanel',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame : false,
	    activeTab: 0,
        items:[{
        title: '门诊处方审核',	
		id:'frameordquery',
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
         	  flex: 2,
         	  layout:'border',
         	  items:[DatePanel]  
         	 },{           
         	  flex: 4,
         	  layout:'border',
         	  items:[patlistgrid]  
         	 },{           
         	  flex: 3,
         	  layout:'border',
         	  items:[orddetailgrid]  
         	 }]
		
		
	    },{
	    			title: '处方预览',	
					frameName: 'prescriptioninfo',
					html: '<iframe id="prescription" width=100% height=100% src= ></iframe>',		
					id:'prescriptioninfo'
					
	    },{
	        		title: '过敏记录',	
					frameName: 'framepaallergy',
					html: '<iframe id="paallergyFrame" width=100% height=100% src=dhcpha.comment.paallergy.csp></iframe>',		
					src: 'dhcpha.comment.paallergy.csp',
					id:'framepaallergy'
	
	    },{
	          		title: '检查记录',
	          		frameName: 'framerisquery',
	          		html: '<iframe id="framerisquery" width=100% height=100% src=dhcpha.comment.risquery.csp></iframe>',		
		  			src: 'dhcpha.comment.risquery.csp',
		  			id:'framerisquery'
	       
	
	    },{
	          		title: '检验记录',
	          		frameName: 'framelabquery',
	          		html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
		  			src: 'dhcpha.comment.labquery.csp',
		  			id:'framelabquery'
	       
	
	    },{
	          		title: '病历浏览',
	          		frameName: 'frameprbrowser',
	          		html: '<iframe id="frmeprbrowser" width=100% height=100% src=epr.newfw.episodelistuvpanel.csp></iframe>',		
		  			src: 'epr.newfw.episodelistuvpanel.csp',
		  			id:'frameprbrowser'
	       
	
	    },{
	          		title: '本次医嘱',
	          		frameName: 'frameadmordquery',
	          		html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',		
		  			src: 'dhcpha.comment.queryorditemds.csp',
		  			id:'frameadmordquery'
	       
	
	    }],
	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                                          HrefRefresh() ;
                                    }  ,
			      'render' : function(){   
					           //oneTbar.render(this.tbar); //add one tbar   
					           //BtnTbar.render(this.tbar); 
					    
					          }
                                
                      } 
	    
	    
	  
	    
	    
	});
	


      var port = new Ext.Viewport({

				layout : 'border',
				items : [toolform]

			});



			
	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  以下是Events区域        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////


	///清屏
	
	function ClearWindow()
	{
	
			orddetailgridds.removeAll();
			
			
			
	}
	
	
      //返回左边列表选择条件
  function GetListInput()
  {
  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
        edate=Ext.getCmp("enddt").getRawValue().toString();
        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
        patid=Ext.getCmp('patientTxt').getValue();
        onlyadt=Ext.getCmp('OnlyAdtChk').getValue();
        adtwin=Ext.getCmp('adtwinSelect').getValue();

  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid+"^"+onlyadt+"^"+adtwin ;
  	    
  	    return listinputstr
  }
		
	
   ///补0病人登记号
  function GetWholePatID(RegNo)
	{    
	     if (RegNo=="") {
	        return RegNo;
	     }
	     
	     var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
	   	            
	     var plen=RegNo.length;
	 	 if (plen>patLen){
	 		Ext.Msg.show({title:'错误',msg:'输入登记号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	return;
	 	 }
	 	 
 		 for (i=1;i<=patLen-plen;i++)
	  	 {
		 	 RegNo="0"+RegNo;  
	     }
	    
	 	 Ext.getCmp('patientTxt').setValue(RegNo);
	 	
	 	 return RegNo;
	
	}
	
	//取卡类型
	function GetCardTypeRowId() 
	{
		var CardTypeRowId = "";
		var CardTypeValue = CardTypeComBo.getValue();
		
		if (CardTypeValue != "") {
			var CardTypeArr = CardTypeValue.split("^");
			CardTypeRowId = CardTypeArr[0];
		}
		return CardTypeRowId;
    }

	//读卡
   function BtnReadCardHandler()
   {
		var CardTypeRowId = GetCardTypeRowId();
		var myoptval = CardTypeComBo.getValue();
		var myrtn;
		//if(CardTypeComBo.getRawValue()=="就诊卡"){
		//myrtn=DHCACC_GetAccInfo("","")
		//}
		//else{
		myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
		//}
		
		if (myrtn==-200){ //卡无效
				Ext.Msg.show({title:'错误',msg:'卡无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
		}
	
		var myary = myrtn.split("^");
		var rtn = myary[0];
		
		switch (rtn) {
		case "0":
			//卡有效
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
			Ext.getCmp('patientTxt').setValue(PatientNo);
		    FindWardList();
			break;
		case "-200":
			//卡无效
			Ext.Msg.show({title:'错误',msg:'卡无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			break;
		case "-201":
			//现金
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
	        Ext.getCmp('patientTxt').setValue(PatientNo);
		    FindWardList();
			break;
		 default:
	 
	}
	
  }
  

    //获到病区列表
   function FindWardList()
   {
      
         ClearWindow();
         var RegNo=Ext.getCmp('patientTxt').getValue();
         var RegNo=GetWholePatID(RegNo);
      	 InputStr=GetListInput();
         patlistst.removeAll() ;
		 waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据请稍候..." }); 
	     waitMask.show();
	                
		 patlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetAdmPrescList&input='+InputStr  });		
						patlistst.load({
						params:{start:0, limit:patlistgridPagingToolbar.pageSize},
						callback: function(r, options, success){
		 
				        waitMask.hide();
				        if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		     		                     }else{
		     		                     	//DaTongPrescAnalyse();
                                                    if(r.length>0){ //判断是否有数据

                                                           Ext.getCmp("patlisttbl").getSelectionModel().selectRow(0);//选中第一行
                                                           orddetailgrid.getView().focusRow(0);//获取焦点
	                                                   var currow = patlistgrid.getSelectionModel().getSelected();
                                                           var prescno=currow.get("prescno") ;
							   var adm = currow.get("adm") ;
							   var zcyflag = currow.get("zcyflag") ;

						           PatInfo.adm=adm;
						           PatInfo.prescno =prescno;
	                                                   PatInfo.zcyflag=zcyflag;
	                                                   
                                                           FindOrdDetailData(prescno); 
                                                        }

		     		                     }
		      }
		     
		
		   });

	 
   }

/// 查看医嘱明细

function FindOrdDetailData(prescno)  
{
                //waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据请稍候..." }); 
                //waitMask.show();
                var onlyadt=Ext.getCmp('OnlyAdtChk').getValue();
                var input=onlyadt;
                orddetailgridds.removeAll();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindOrdDetailData&PrescNo='+prescno+"&Input="+input });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
		 
				         
				         //waitMask.hide() ;
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }

				         
				
				});
		
				
		
} 




///合格

function CommontOk()
{

     
     var orditm = "";
     var ret="Y";
     var reasondr="";
     var advicetxt="";
     var factxt="";
     var phnote="";
     var User=session['LOGON.USERID'] ;
     var grpdr=session['LOGON.GROUPID'] ;
	 
	 
	 
	 var rows = Ext.getCmp("patlisttbl").getSelectionModel().getSelections(); 
	 var totalnum=rows.length;
	 
	 if (totalnum==0){
	    return;
	 }

	 for(var i=0;i<totalnum;i++){
		      
		        var row = rows[i];
		        var orditem=row.get("orditem") ;
		        var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditem;
		   
		        SaveCommontResult(reasondr,input)
	 }
		
		
	 
	 

     
     
     
 
}



///不合格

function EditReason()
{
       
       var totalnum =orddetailgrid.getStore().getCount() ;
	   if (totalnum==0){
		    return;
		 }
        
       var orditm=orddetailgridds.getAt(0).get("orditm") ;
       
       var waycode = "8";
       
    
       var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+orditm+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
        
 
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
        
        retarr=retstr.split("@");

        var ret="N";
		var reasondr=retarr[0];
		var advicetxt=retarr[2];
		var factxt=retarr[1];
		var phnote=retarr[3];
		var User=session['LOGON.USERID'] ;
		var grpdr=session['LOGON.GROUPID'] ;
		
		
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm;
		
		if (reasondr.indexOf("$$$")=="-1")
		{
			//reasondr=reasondr+"$$$"+orditm ;
		}
		
		
		SaveCommontResult(reasondr,input) 
       

}


///保存点评结果

function SaveCommontResult(reasondr,input)
{
        //var currow = ordgrid.getSelectionModel().getSelected();
        //var curdetail=orddetailgrid.getSelectionModel().getSelected();
   
        //var User=session['LOGON.USERID'] ;

        //alert(currow);
        //alert(orditm)
        //alert(reasondr)
        //alert(advicetxt)
        //alert(factxt)
        //
        
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据请稍候..." ,removeMask: true}); 
        waitMask.show();
            
  		Ext.Ajax.request({

	        url:unitsUrl+'?action=SaveOPAuditResult&Input='+input+'&ReasonDr='+reasondr ,
			failure: function(result, request) {
				waitMask.hide() ;
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
			success: function(result, request) {
	            waitMask.hide() ;
				var jsonData = Ext.util.JSON.decode( result.responseText );
				  		
				//alert(jsonData.retvalue)
				//alert(jsonData.retinfo)	
				
				if (jsonData.retvalue==0){
	
	                               ReloadAfterSave();
				  
				}else{
				    msgtxt=jsonData.retinfo;

				    Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}			  	 
	  		
	  		

		},
		
			scope: this
		});

    
}

  function ReloadAfterSave()
  {
  	FindWardList();
  }

	///初始化默认科室
  
  function setDefaultLoc()
   { 

     var locdr=session['LOGON.CTLOCID'].toString();
     PhaLocSelecter.setValue(locdr) ;
    
   }  



 ///查看日志	
 function ListLogBtnClick()
 {

       
     	var rows = Ext.getCmp("patlisttbl").getSelectionModel().getSelections(); 
	var totalnum=rows.length;
	 
	if (totalnum==0){
	    return;
	 }
       
       var currow = patlistgrid.getSelectionModel().getSelected();
       var orditem=currow.get("orditem") ;
       
       FindItmLog(orditem);
 }

  ///大通药典提示
  function DaTongYDTSBtnClick()
  {		  
       	 var rows = Ext.getCmp("patlisttbl").getSelectionModel().getSelections(); 
		 var totalnum=rows.length;
		 
		 if (totalnum==0){
		    return;
		 }
		  var currow = orddetailgrid.getSelectionModel().getSelected();
		  var orditm =currow.get("orditm") ;

		  dtywzxUI(3,0,"");
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);

		  myrtn=dtywzxUI(12,0,myPrescXML);
  
  }
  
  //大通处方分析
  function DaTongPrescAnalyse()
  {	

	 var totalnum =patlistgrid.getStore().getCount() ;
	 if (totalnum==0){
	    return;
	 }

	 for(var i=0;i<totalnum;i++){
		      
	 	        dtywzxUI(3,0,"");
		        var record = patlistgrid.getStore().getAt(i); 
		        var orditem =record.data.orditem ;
		        var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
		        myrtn=dtywzxUI(28676,1,myPrescXML);
		        if (myrtn==0) {var imgname="greenlight.gif";}
				if (myrtn==1) {var imgname="yellowlight.gif";}
			    if (myrtn==2) {var imgname="blacklight.gif";}
			    
                var str="<img id='DrugUseImg"+i +"'"+" src='../scripts/dhcpha/img/"+imgname+"'>";
			    patlistgrid.getView().getCell(i,2).innerHTML=str
	 }
	 
  	
  }
  

	//列点击事件
	function PatListGridCellClick(grid, rowIndex, columnIndex, e)
	{
              
		if (columnIndex==2){
               
		  dtywzxUI(3,0,"");
		  var record = patlistgrid.getStore().getAt(rowIndex); 
		  var orditem =record.data.orditem ;
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
		  myrtn=dtywzxUI(28676,1,myPrescXML);

		  
		  
		}
	}
	
    //初始化
	function StartDaTongDll()
	{
		
		dtywzxUI(0,0,"");
	}
	
	function dtywzxUI(nCode,lParam,sXML){
	   var result;
	   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
	   return result;
	}




});