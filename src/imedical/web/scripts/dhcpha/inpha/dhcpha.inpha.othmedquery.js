

Ext.onReady(function() {

	Ext.QuickTips.init();// ������Ϣ��ʾ

	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
    var Request = new Object();
    Request = GetRequest();
    var adm = Request['EpisodeID'];
        
    var ret=tkMakeServerCall("web.DHCSTCNTSIPMONITOR", "GetAdmOthMedInfo",adm)
	  
	var PhAdviceField=new Ext.form.TextArea({
	        //autoScroll:true,
	        width : 450,
	        height:120,       
	        id:"PhAdviceArea", 
	        fieldLabel:"��ע" 
        }) 
        
        Ext.getCmp('PhAdviceArea').setValue(ret);

              	  
        var Panel = new Ext.Panel({
         region:'center',
         width:400,
         height : 250,    
         frame : true,
         title:'��Ժǰ��ҩ��¼',
         items:[{
         
         
                           	layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .99,
										layout : "form",
										items : [  PhAdviceField   ]
								}]
								   							   
					},{
         
                               layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .99,
										layout : "form",
										items : [     ]
								}]
					
					},{
         
                               layout : "column",
							items : [{
							                        labelAlign : 'right',
										columnWidth : .99,
										layout : "form",
										items : [     ]
								}]
					
					}
					
                              
                       ]
      
           
       })
       


        ///view

	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [Panel ]

			});





   

});
