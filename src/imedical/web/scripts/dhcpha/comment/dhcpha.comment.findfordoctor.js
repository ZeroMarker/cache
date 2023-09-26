///查询for Doctor
///Creator:LiangQiang
///CreatDate:2013-08-21
///

var unitsUrl = 'dhcpha.comment.main.save.csp';
var waitMask;
var InputStr;

Ext.onReady(function() {

  Ext.QuickTips.init();// 浮动信息提示

  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
  	   //刷新
   var  FindButton = new Ext.Button({
             width : 70,
             id:"FindBtn",
             text: '查询',
             iconCls:"page_find",
             listeners:{
                          "click":function(){   
                             
                                 FindClick();
                              
                              }   
             }
             
             
   })
  
       //开始日期
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                
                //format:'j/m/Y' ,
                fieldLabel: '开始日期',
                name: 'startdt',
                id: 'startdt',
                //invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
                value:new Date
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 120,
                //format:'j/m/Y' ,
                fieldLabel: '截止日期',
	        name: 'enddt',
	        id: 'enddt',
	        //invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
	        value:new Date
            })
            
    
    
   var DocAdviceField=new Ext.form.TextArea({
	        //autoScroll:true,
	        width : 450,
	        height:120,       
	        id:"DocAdviceArea", 
	        fieldLabel:"说明" 
        }) 
        
                
   	   //提交
   var  OkButton = new Ext.Button({
             width : 70,
             id:"OkBtn",
             text: '申诉',
             icon:"../scripts/dhcpha/img/accept.png",
             listeners:{
                          "click":function(){   
                             
                                 OkClick();
                              
                              }   
             }
             
             
   })
   
     //接受按钮 add by myq 20170613
   var  AcceptButton = new Ext.Button({
             width : 70,
             id:"AcceptBtn",
             text: '接受',
             icon:"../scripts/dhcpha/img/accept.png",
             listeners:{
                          "click":function(){   
                             
                                 AcceptClick();
                              
                              }   
             }
             
             
   })

		
	//查找病人列表控件
	
    var ordlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'orddate',
	            'inciDesc',
	            'qty',
	            'uomdesc',
	            'dosage',
	            'doseuom',
	            'instru',
	            'freq',
	            'duration',
	            'spec',
	            'priorty',
	            'doctor',
	            'remark',
	            'oeori'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});

	  var ordlistcm = new Ext.grid.ColumnModel([
	  
	        {header:'医嘱日期',dataIndex:'orddate',width: 100,menuDisabled :'false'},
	        {header:'医嘱名称',dataIndex:'inciDesc',width: 160,menuDisabled :'false'},
	        {header:'数量',dataIndex:'qty',width: 60,menuDisabled :'false'},
	        {header:'单位',dataIndex:'uomdesc',width: 60,menuDisabled :'false'},
	        {header:'剂量',dataIndex:'dosage',width: 60,menuDisabled :'false'},
	        {header:'剂量单位',dataIndex:'doseuom',width: 60,menuDisabled :'false'},
	        {header:'用法',dataIndex:'instru',width: 60,menuDisabled :'false'},
	        {header:'频率',dataIndex:'freq',width: 60,menuDisabled :'false'},
	        {header:'疗程',dataIndex:'duration',width: 60,menuDisabled :'false'},
	        {header:'规格',dataIndex:'spec',width: 60,menuDisabled :'false'},
	        {header:'优先级',dataIndex:'priorty',width: 60,menuDisabled :'false'},
	        {header:'医生',dataIndex:'doctor',width: 60,menuDisabled :'false'},
	        {header:'备注',dataIndex:'remark',width: 60,menuDisabled :'false'},
	        {header:'oeori',dataIndex:'oeori',width: 60,menuDisabled :'false',hidden:true}
	        
	       
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
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: ordlistst,
	        cm: ordlistcm,
	        bbar: ordlistgridPagingToolbar,
	        tbar:[FindButton],
	        trackMouseOver:'true'
	    });
	
	    
		///就诊列表grid 单击行事件

	    ordlistgrid.on('rowclick',function(grid,rowIndex,e){
	
	           var selectedRow = ordlistst.data.items[rowIndex];
		       var oeori = selectedRow.data["oeori"];
               detailgridds.removeAll();
               Ext.getCmp("DocAdviceArea").setValue('');
			   FindDetailData(oeori);
			   
	    }); 
	    

  var detailgridcm = new Ext.grid.ColumnModel([

       
        {header:'组号',dataIndex:'comgrpno',width:40},
        {header:'点评原因',dataIndex:'comreason',width:250},
        {header:'点评日期',dataIndex:'comdate',width:80},
        {header:'点评时间',dataIndex:'comtime',width:60},
        {header:'点评人',dataIndex:'comuser',width:60},
        {header:'点评结果',dataIndex:'comresult',width:60},       
        {header:'不合格警示值',dataIndex:'comfactor',width:80,hidden:true},
        {header:'药师建议',dataIndex:'comadvice',width:150},
        {header:'医生反馈',dataIndex:'comdocadvice',width:60,hidden:true},
        {header:'药师备注',dataIndex:'comphnote',width:60},
        {header:'医生备注',dataIndex:'comdocnote',width:450},
        {header:'有效',dataIndex:'comactive',width:60},
        {header:'rowid',dataIndex:'comlogrowid',width:40,hidden:true}
        
    
        

    
       ]);
 
 
    var detailgridds = new Ext.data.Store({
		    proxy: "",
		  //proxy: unitsUrl + '?action=GetDataForDoctor' ,
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [

            'comgrpno',
            'comreason',
            'comdate',
				    'comtime',
				    'comuser',
				    'comresult',
				    'comfactor',
				    'comadvice',
				    'comdocadvice',
				    'comphnote',
				    'comdocnote',
				    'comactive',
				    'comlogrowid'
	    
		]),
		
		

    remoteSort: true
});

     
 var  detailgridPagingToolbar = new Ext.PagingToolbar({	
			store:detailgridds,
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
 
 
 var detailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'0 0 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: detailgridds,
        cm: detailgridcm,
        enableColumnMove : false,
        tbar:[AcceptButton,"-",OkButton,"-",'<font color="red">请在下方填写申诉原因之后点击"申诉"按钮进行申诉！</font>'],
        bbar: detailgridPagingToolbar,
        clicksToEdit: 1,
        //plugins: PackFlagChkColumn,
        trackMouseOver:'true',
		listeners : {
		     'afteredit' : function(e) {
		      //alert(e.record.data.packflag)
		      //alert(e.getTarget())
		     	//alert(e.field)
		     	

		     }
		}


        

        
    });
	

	

   
     var datePanel = new Ext.Panel({
         frame : true,
         labelWidth:80,
         buttonAlign:'center',
         items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [ stdatef   ]
							 },{
					            labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [ enddatef   ]
							 } ]
	   
								   
					}]

      
   })
    

         
     var westPanel = new Ext.Panel({  
         title: '不合理处方医生查询',
         region:'west',
         collapsible: true,
         margins:'0 3 0 0',
         width:850,
         frame : true,
         layout:{  
	        type:'vbox', 
	        align: 'stretch',  
	        pack: 'start'  
         },
	 items: [{         
	 	  flex: 1,
	 	  layout:'fit',
	 	  items:[datePanel]  
	 	 },{   
	 	  flex: 12 ,
	 	  layout:'fit',
	 	  items:[ordlistgrid]    
	       }]  
     });   
   
    ////
    
     var centerPanel = new Ext.Panel({
        id:'centerform',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame : false,
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
         	  flex: 3,
         	  layout:'border',
         	  items:[detailgrid]  
         	 },{   
	 	  flex: 2 ,
	 	  layout:'fit',
	 	  tbar:['<font color="red">申诉原因录入框</font>'],
	 	  items:[DocAdviceField]    
	       }]

	    
	});
	
  

      var port = new Ext.Viewport({

				layout : 'border',
				items : [westPanel,centerPanel]

			});
			
  ///////  Event      ///////////////////////

 

/// 根据处方号查看医嘱明细

function FindClick()  
{
	  
    var sdate=Ext.getCmp("startdt").getRawValue().toString();
	  var edate=Ext.getCmp("enddt").getRawValue().toString();
    var user=session['LOGON.USERID'] ;   
    var input=sdate+"^"+edate+"^"+user ;  
    ordlistst.removeAll();
    detailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetLogForDoctor' });
    detailgridds.load({params:{start:0,limit:0,input:''}})
    detailgridds.removeAll();
    
    
	Ext.getCmp("DocAdviceArea").setValue('');
		ordlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetDataForDoctor&input='+input });		
		ordlistst.load({
		params:{start:0, limit:ordlistgridPagingToolbar.pageSize},
		callback: function(r, options, success){
 
		         
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		                      
		          }
		       
		         
		
		});
		
				
		
}


function FindDetailData(oeori)
{   
    var input=oeori ;  
    detailgridds.removeAll();
    
		detailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetLogForDoctor&input='+input });		
		detailgridds.load({
		params:{start:0, limit:detailgridPagingToolbar.pageSize},
		callback: function(r, options, success){
 
		         
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		                      
		          }
		       
		         
		
		});
		
}

function OkClick()
{
	
	   var row = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections();
	    

     if (!(row)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中要申诉的点评不合理原因记录!");
           return;
     }
     if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中要申诉的点评不合理原因记录!");
           return;
     }
     
     var comlogrowid = row[0].data.comlogrowid;
     if (comlogrowid==""){
     	     Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中要申诉的点评不合理原因记录!");
           return;
     }

	 var comactive = row[0].data.comactive;
     if (comactive!="Y"){
     	   Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "请选择有效的原因记录!");
           return;
     }
     
     
    var docnote=Ext.getCmp("DocAdviceArea").getValue();  //备注
	  
	  if (docnote==""){
	  	Ext.Msg.show({title:'提示',msg:'请在下方填写申诉原因!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	  	return;
	  }
	  
	  
	  var input=comlogrowid+"^"+docnote;
	//alert("input:"+input)
  	Ext.Ajax.request({

	  url:unitsUrl+'?action=SaveDocAdvice&input='+encodeURI(input) ,
	
		waitMsg:'处理中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
			  		
			//alert(jsonData.retvalue)
			//alert(jsonData.retinfo)	
			
			if (jsonData.retvalue==0){


			  Ext.Msg.show({title:'提示',msg:'已提交',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  detailgridds.reload() ;
			  if(top && top.HideExecMsgWin) {
				top.HideExecMsgWin();
			  } 
			}else{
			
			  msgtxt=jsonData.retinfo;

			  Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}			  	 
	  		
	  		

		},
		
			scope: this
		});
		
}

function AcceptClick()
{
	
	   var row = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections();
	    

     if (!(row)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中要接受的点评不合理原因记录!");
           return;
     }
     if (row==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中要接受的点评不合理原因记录!");
           return;
     }
     
     var comlogrowid = row[0].data.comlogrowid;
     if (comlogrowid==""){
     	     Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "未选中要接受的点评不合理原因记录!");
           return;
     }

	 var comactive = row[0].data.comactive;
     if (comactive!="Y"){
     	   Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("提示", "请选择有效的原因记录!");
           return;
     }
     
     
    var docnote="Accept";  //备注
	  
	  
	  var input=comlogrowid+"^"+docnote;

  	Ext.Ajax.request({

	  url:unitsUrl+'?action=SaveDocAdvice&input='+encodeURI(input) ,
	
		waitMsg:'处理中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
			  		
			//alert(jsonData.retvalue)
			//alert(jsonData.retinfo)	
			
			if (jsonData.retvalue==0){


			  Ext.Msg.show({title:'提示',msg:'已提交',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			  detailgridds.reload() ;
			  if(top && top.HideExecMsgWin) {
				top.HideExecMsgWin();
			  } 
			  
			}else{
			
			  msgtxt=jsonData.retinfo;

			  Ext.Msg.show({title:'提示',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			}			  	 
	  		
	  		

		},
		
			scope: this
		});
		
}

	FindClick();
});