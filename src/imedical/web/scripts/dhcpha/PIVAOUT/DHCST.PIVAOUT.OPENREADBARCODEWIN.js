


//显示扫码界面窗口
OpenShowReadBarcodeWin = function(statuscode) {
	
	
      Ext.QuickTips.init();
     
      
      ///条码
      var BCodeField=new Ext.form.TextField({
  
        width : 180, 
        id:"BCodeTxt", 
        fieldLabel:"条码" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                ExeBarcode();
                            }
                        }
                    }
        })
      
       ///状态
      var StatusField=new Ext.form.TextField({
  
        width : 180, 
        id:"StatusTxt", 
        fieldLabel:"状态" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {

                                  
                            }
                        }
                    }
        })
      
       ///ID
      var PatIDField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatIDTxt", 
        fieldLabel:"登记号" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
       ///姓名
      var PatNameField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatNameTxt", 
        fieldLabel:"姓名" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
             ///医嘱日期
      var OrdDateField=new Ext.form.TextField({
  
        width : 120, 
        id:"OrdDateTxt", 
        fieldLabel:"医嘱日期" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
             ///处方号
      var PrescNoField=new Ext.form.TextField({
  
        width : 120, 
        id:"PrescNoTxt", 
        fieldLabel:"处方号" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
        
      ///Form
      var PatInfoForm=new Ext.Panel( {
	
	  //lableWidth:80,
	  region : 'center',
	  frame :true,
	  items : [{
	  	               layout : "column",
			       items : [{
  	
				       	labelAlign : 'right',
					columnWidth : 1,
					layout : "form",
					items : [  StatusField  ]
					
				}, {
				        labelAlign : 'right',
					columnWidth : .1,
					layout : "form",
					items : [     ]
			        
			       }]
	
	  	  },{
	  	
	  	               layout : "column",
			       items : [{
  	
				       	labelAlign : 'right',
					columnWidth : 1,
					layout : "form",
					items : [ BCodeField  ]
					
				}, {
				        labelAlign : 'right',
					columnWidth : .1,
					layout : "form",
					items : [    ]
			        
			        }]
	  	 },{
	  	
	  	               layout : "column",
			       items : [{
  	
				       	labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [    ]
					
				}, {
				        labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [     ]
			        
			        }]
	  	 }
	  	
	  	],
	  	listeners:{
                          "afterlayout":function(){   
                             
                                   
                              
                              }   
               }
	 }) ;
     
     
     var detailgridcm = new Ext.grid.ColumnModel({
  
     columns:[


        {header:'药品名称',dataIndex:'incidesc',width:250},
        {header:'数量',dataIndex:'qty',width:50},
        {header:'单位',dataIndex:'uom',width:50}
        
        
          ]   
            
    
    });
 
 
    var detailgridds = new Ext.data.Store({
    	//autoLoad: true,
	    //url:unitsUrl+'?action=QueryPogStatusDs&pogid='+pogid+"&dodis="+dodis,
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'incidesc',
            'qty',
            'uom'
	    
		]),
		
		

    remoteSort: true
});



 
 var detailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'3 3 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: detailgridds,
        cm: detailgridcm,
        enableColumnMove : false,
        trackMouseOver:'true'
        

        
    });
    
    
    
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
         	  items:[PatInfoForm]  
         	 },{           
         	  flex: 8,
         	  layout:'border',
         	  items:[detailgrid]  
         	 }]
		

	    
	});
      	         
     ///状态界面窗口 
     var ShowStatusWindow = new Ext.Window({
	    title: '扫码',
	    width: 500,
	    height:200,
	    minWidth: 400,
	    minHeight: 300,
	    layout: 'border',
	    plain:true,
	    modal:true,
	    bodyStyle:'padding:5px;',
	    items:  [PatInfoForm  ],

        listeners: {
   
                        
                        "show" : function () {
                        	Ext.getCmp('BCodeTxt').focus('',100); 
                        }
                    }


 
     });
    
     ShowStatusWindow.show();
     
     
     ///执行
     function ExeBarcode(){
     	
     	
     	var barcode=Ext.getCmp('BCodeTxt').getValue();
     	if (barcode==""){
	     	Ext.Msg.show({title:'错误',msg:'条码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	return;
	 	 	
     	}
     	var user=session['LOGON.USERID'] ;
     	var ret = tkMakeServerCall("web.DHCSTPIVAOUTRECSURE", "ExeBarcode",barcode,statuscode,user);
     	Ext.getCmp('StatusTxt').setValue(ret);
     	Ext.getDom("StatusTxt").style.fontSize=18+'px' ;
        Ext.getDom("StatusTxt").style.color="#FF0000" ;
        Ext.getCmp('BCodeTxt').setValue("");
     	
     	
     }


    
}