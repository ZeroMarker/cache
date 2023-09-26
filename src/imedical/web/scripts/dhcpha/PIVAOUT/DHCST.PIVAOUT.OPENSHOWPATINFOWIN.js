


//打开扫码界面窗口
 
OpenShowPatInfoWin = function(dodis) {
	
      Ext.QuickTips.init();

      ///卡号
      var PatCardNoField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatCardNoTxt", 
        fieldLabel:"卡号" ,
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
        
        
       ///性别
      var PatSexField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatSexTxt", 
        fieldLabel:"性别" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
       ///年龄
      var PatOldField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatOldTxt", 
        fieldLabel:"年龄" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
       ///费别
      var PatBillTypeField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatBillTypeTxt", 
        fieldLabel:"费别" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
        
       ///身高
      var PatHeightField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatHeightTxt", 
        fieldLabel:"身高" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        
        
        ///体重
      var PatWeightField=new Ext.form.TextField({
  
        width : 120, 
        id:"PatWeightTxt", 
        fieldLabel:"体重" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                
                            }
                        }
                    }
        })
        

       
       ///诊断
       	  
	var PatDiagField=new Ext.form.TextArea({

	        width : 450,
	        height:120,       
	        id:"PatDiagArea", 
	        fieldLabel:"诊断" 
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
	  
       
   
       
        
     ///基本信息 
     var PatInfoWindow = new Ext.Window({
	    title: '基本信息',
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