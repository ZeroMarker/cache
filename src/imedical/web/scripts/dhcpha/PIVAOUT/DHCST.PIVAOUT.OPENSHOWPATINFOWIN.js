


//��ɨ����洰��
 
OpenShowPatInfoWin = function(dodis) {
	
      Ext.QuickTips.init();

      ///����
      var PatCardNoField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatCardNoTxt", 
        fieldLabel:"����" ,
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
        
        
       ///�Ա�
      var PatSexField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatSexTxt", 
        fieldLabel:"�Ա�" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
       ///����
      var PatOldField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatOldTxt", 
        fieldLabel:"����" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
       ///�ѱ�
      var PatBillTypeField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatBillTypeTxt", 
        fieldLabel:"�ѱ�" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
        
       ///���
      var PatHeightField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatHeightTxt", 
        fieldLabel:"���" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
        ///����
      var PatWeightField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatWeightTxt", 
        fieldLabel:"����" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        

       
       ///���
       	  
	var PatDiagField=new Ext.form.TextArea({

	        width : 450,
	        height:120,       
	        id:"PatDiagArea", 
	        fieldLabel:"���" 
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
					columnWidth : .5,
					layout : "form",
					items : [ PatCardNoField   ]
					
				}, {
				        labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [  PatIDField   ]
			        
			       }]
	
	  	  },{
	  	
	  	               layout : "column",
			       items : [{
  	
				       	labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [ PatNameField   ]
					
				}, {
				        labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [  PatSexField   ]
			        
			        }]
	  	 },{
	  	
	  	               layout : "column",
			       items : [{
  	
				       	labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [ PatOldField   ]
					
				}, {
				        labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [  PatBillTypeField   ]
			        
			        }]
	  	 },{
	  	
	  	               layout : "column",
			       items : [{
  	
				       	labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [ PatHeightField   ]
					
				}, {
				        labelAlign : 'right',
					columnWidth : .5,
					layout : "form",
					items : [  PatWeightField   ]
			        
			        }]
	  	 },{
	  	
	  	               layout : "column",
			       items : [{
  	
				       	labelAlign : 'right',
					columnWidth : 1,
					layout : "form",
					items : [ PatDiagField   ]
					
				}]
	  	 }
	  	
	  	],
	  	listeners:{
                          "afterlayout":function(){   
                             
                                   
                              
                              }   
               }
	 }) ;
	  
       
   
       
        
     ///������Ϣ 
     var PatInfoWindow = new Ext.Window({
	    title: '������Ϣ',
	    width: 600,
	    height:400,
	    minWidth: 400,
	    minHeight: 300,
	    layout: 'border',
	    plain:true,
	    modal:true,
	    bodyStyle:'padding:5px;',
	    items:  [  PatInfoForm],	    
	    listeners: {
		  'show': function() {
		     
		  }
		}




 
     });
    
     PatInfoWindow.show();


     var infodata=tkMakeServerCall("web.DHCSTPIVAOUTCOMMON", "GetPatInfoData",dodis);
				     var tmparr=infodata.split("||");
				     var diag=tmparr[0];
				     Ext.getCmp("PatDiagArea").setValue(diag);
				     var info=tmparr[1];
				     var tmparr2=info.split("^");
				     var patno=tmparr2[0];
				     Ext.getCmp("PatIDTxt").setValue(patno);
				     var patname=tmparr2[1];
				     Ext.getCmp("PatNameTxt").setValue(patname);
				     var patcardno=tmparr2[7];
				     Ext.getCmp("PatCardNoTxt").setValue(patcardno);
				     var patsex=tmparr2[3];
				     Ext.getCmp("PatSexTxt").setValue(patsex);
				     var patold=tmparr2[2];
				     Ext.getCmp("PatOldTxt").setValue(patold);	
				     var patbilltype=tmparr2[11];
				     Ext.getCmp("PatBillTypeTxt").setValue(patbilltype);
				     var patH=tmparr2[12];
				     Ext.getCmp("PatHeightTxt").setValue(patH);
				     var patW=tmparr2[5];
				     Ext.getCmp("PatWeightTxt").setValue(patW);
	
	
	
	
	
	
	
	
	
	
}