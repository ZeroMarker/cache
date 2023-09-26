///工作量统计界面JS
///Creator:LiangQiang
///CreatDate:2013-06-20
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
				  width : 160,
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
             text: '统计',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 StatWorkNum();
                              
                              }   
             }
             
             
   })
  

 
    
         ///数据table


  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[

        {header:'药师姓名',dataIndex:'username',width:100},
        {header:'配伍审核',dataIndex:'adtnum',width:100},
        {header:'打印瓶签',dataIndex:'prtnum',width:100},
        {header:'配液减库',dataIndex:'opstknum',width:100},
        {header:'配液复核',dataIndex:'checkednum',width:100}

          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'username',
            'adtnum',
            'prtnum',
            'opstknum',
            'checkednum'
	    
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
        bbar:orddetailgridcmPagingToolbar,
        //tbar:[OnlyReadBarChkbox,"-",BarcodeField,'-','扫码计数:',BarcodeNumField],
        trackMouseOver:'true'
        

        
    });
	

 
 //开始日期
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 100,
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                value:GetPIVAStDate(),
                listeners: {
                	select: function(m, d){ 
		            //var newdate=d.format('j/m/Y')+" 00:00"
		            //m.setValue(newdate);
		
		                }
		           }
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 100,
                format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:GetPIVAEndDate(),
	        listeners: {
                	select: function(m, d){ 
		            //var newdate=d.format('j/m/Y')+" 23:59"
		            //m.setValue(newdate);
		
		                }
		           }
            })

        
        
   
     var DatePanel = new Ext.Panel({
     	 title:'工作量统计',
         frame : true,
         margins:'1 0 0 0', 
         bbar:[RefreshButton],
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
								columnWidth : .2,
								layout : "form",
								items : [ enddatef  ]
								
						        } ]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [    ]
									 },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [   ]
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  ]
								
						        }]
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
         	  items:[orddetailgrid]  
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

	
	  	var listinputstr=sdate+"^"+edate+"^"+phlocdr ;
	  	    
	  	return listinputstr
	  	
	  	
	  	
	  }		

	//统计工作量		
	function StatWorkNum()
	{
			var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate=="") {Ext.Msg.show({title:'注意',msg:'开始日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'注意',msg:'结束日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'注意',msg:'科室不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		
		        var input=GetListInput();
		        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据,请稍候..." }); 
	                waitMask.show();  
	                orddetailgridds.removeAll();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=PIVAOUTSTATWORK&Input='+input });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
				         
				         waitMask.hide();
				         if (success==false){
				                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }

				         
				
				});
		   
	}		
			




});