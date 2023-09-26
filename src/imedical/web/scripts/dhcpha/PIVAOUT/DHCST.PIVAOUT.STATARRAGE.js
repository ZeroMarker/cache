///处方点评主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;


Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示
  Ext.Ajax.timeout = 900000;



  	 //药房科室控件
	
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
				
	});
	
	phlocInfo.on(
		'beforeload',
		function(ds, o){
		    var grpdr=session['LOGON.GROUPID'] ;
			ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
		
		}
	);
	

 
	 
	 var PhaLocSelecter = new Ext.form.ComboBox({
				  id:'PhaLocSelecter',
				  fieldLabel:'药房科室',
				  store: phlocInfo,
				  valueField:'rowId',
				  displayField:'phlocdesc',
				  width : 120,
				  listWidth:250,
				  emptyText:'选择药房科室...',
		          allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	

	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	
	
  	   //刷新
    var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '查询',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 QueryArrageData();
                              
                              }   
             }
             
             
   })
  



  var PrtButton = new Ext.Button({
             width : 65,
             id:"PrtButton",
             text: '打印',
             icon:"../scripts/dhcpha/img/printer.png",
             listeners:{
                          "click":function(){   
                             
                              //CommontOk();
                              
                              }   
             }
             
             
             })

    
 
    //查找排药列表控件
	
    var ordlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'inciname',
	            'qty',
	            'uom',
	            'stkbin'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	
	  var ordlistcm = new Ext.grid.ColumnModel([
	  
	        {header:'药品名称',dataIndex:'inciname',width: 360,menuDisabled :'false'},
	        {header:'数量',dataIndex:'qty',width: 80,menuDisabled :'false'},
	        {header:'单位',dataIndex:'uom',width: 80,menuDisabled :'false'},
	        {header:'货位',dataIndex:'stkbin',width: 120,menuDisabled :'false'}
	        
	       
	       ]);
	    
	 var ordlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:ordlistst,
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
	  
	  var ordlistgrid = new Ext.grid.GridPanel({
	        id:'ordlisttbl',
		region:'center',
                margins:'3 3 3 3', 
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: ordlistst,
	        cm: ordlistcm,
	        bbar: ordlistgridPagingToolbar,
	        trackMouseOver:'true'
	    });
	    
   

    
 
 
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
                                QueryArrageData();
                            }
                        }
                    }
        })
        
        ///瓶签单号
      var PrintNoField=new Ext.form.TextField({
  
        width : 120, 
        id:"PrintNoTxt", 
        fieldLabel:"瓶签单号" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
       ///查询瓶签单号 
      var  FindPrintNoButton = new Ext.Button({
             width : 3,
             id:" FindPrintNoBtn",
             text: '...',
             listeners:{
                          "click":function(){   
                             
                               //PrintnoClick();
                              
                              }   
               }
      })
   
     var DatePanel = new Ext.Panel({
     	 title:'配液排药汇总',
         frame : true,
         margins:'1 0 0 0', 
         bbar:[RefreshButton,PrtButton],
         labelWidth:80,
         region:'center',
          items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [ PhaLocSelecter   ]
							 }, {
							        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  stdatef   ]
							    
								
						        },{
						            
						                labelAlign : 'right',
								columnWidth : .183,
								layout : "form",
								items : [  PrintNoField  ]
									
								
						        },{
						            
						                labelAlign : 'right',
								columnWidth : .1,
								layout : "form",
								items : [  FindPrintNoButton  ]
									
								
						        }]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [  patientField  ]
									 },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  enddatef ]
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [   ]
								
						        }
						        
						        ]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [    ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [    ]
									 }]
					  }
					
					
					]

      
   })
    
    ////
    
     var centerform = new Ext.Panel({
        id:'centerform',
	    region: 'center',
	    margins:'1 0 0 0', 
	    frame : false,
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
         	  flex: 8,
         	  layout:'border',
         	  items:[ordlistgrid]  
         	 }]
		

	    
	});
	


      var port = new Ext.Viewport({

				layout : 'border',
				items : [centerform]

			});

			
	///////////////////////Event//////////////////
			
			
		
			
			
			
	 //设置默认科室
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
                PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
        }

	}
			
			
		 //返回左边列表选择条件
	  function GetListInput()
	  {
	  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
	        edate=Ext.getCmp("enddt").getRawValue().toString();
	        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
	        patid=Ext.getCmp('patientTxt').getValue();

	  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid ;
	  	    
	  	    return listinputstr
	  }		

			
	function QueryArrageData()
	{
		        var RegNo=Ext.getCmp('patientTxt').getValue();
                var RegNo=GetWholePatID(RegNo);
		        var input=GetListInput();
		        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据,请稍候..." }); 
	            waitMask.show();  
                ordlistst.removeAll();
				ordlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryArrageData&RegNo='+RegNo+"&Input="+input });		
				ordlistst.load({
				params:{start:0, limit:ordlistgridPagingToolbar.pageSize},
				callback: function(r, options, success){
				         
				         waitMask.hide();
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }

				         
				
				});
		   
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
			


			
	});