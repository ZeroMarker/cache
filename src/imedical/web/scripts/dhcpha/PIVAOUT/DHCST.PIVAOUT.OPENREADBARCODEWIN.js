


//��ʾɨ����洰��
OpenShowReadBarcodeWin = function(statuscode) {
	
	
      Ext.QuickTips.init();
     
      
      ///����
      var BCodeField=new Ext.form.TextField({
  
        width : 180, 
        id:"BCodeTxt", 
        fieldLabel:"����" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                ExeBarcode();
                            }
                        }
                    }
        })
      
       ///״̬
      var StatusField=new Ext.form.TextField({
  
        width : 180, 
        id:"StatusTxt", 
        fieldLabel:"״̬" ,
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
        fieldLabel:"�ǼǺ�" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
       ///����
      var PatNameField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatNameTxt", 
        fieldLabel:"����" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
             ///ҽ������
      var OrdDateField=new Ext.form.TextField({
  
        width : 120, 
        id:"OrdDateTxt", 
        fieldLabel:"ҽ������" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
             ///������
      var PrescNoField=new Ext.form.TextField({
  
        width : 120, 
        id:"PrescNoTxt", 
        fieldLabel:"������" ,
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


        {header:'ҩƷ����',dataIndex:'incidesc',width:250},
        {header:'����',dataIndex:'qty',width:50},
        {header:'��λ',dataIndex:'uom',width:50}
        
        
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
      	         
     ///״̬���洰�� 
     var ShowStatusWindow = new Ext.Window({
	    title: 'ɨ��',
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
     
     
     ///ִ��
     function ExeBarcode(){
     	
     	
     	var barcode=Ext.getCmp('BCodeTxt').getValue();
     	if (barcode==""){
	     	Ext.Msg.show({title:'����',msg:'���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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