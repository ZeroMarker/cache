Ext.onReady(function() {

	Ext.QuickTips.init();// 浮动信息提示

	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
    var Request = new Object();
    Request = GetRequest();
    var adm = Request['EpisodeID'];
        
    var ret=tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetIcdsByAdm",adm)
	  
	var IcdField=new Ext.form.TextArea({
	        //autoScroll:true,
	        width : 450,
	        height:120,       
	        id:"IcdArea", 
	        fieldLabel:"诊断" 
        }) 
        
    Ext.getCmp('IcdArea').setValue(ret);
              	  
    var Panel = new Ext.Panel({
         region:'center',
         width:400,
         height : 250,    
         frame : true,
         title:'病人诊断记录',
         items:[{
         
               layout : "column",
			   items : [{
					labelAlign : 'right',
					columnWidth : .99,
					layout : "form",
					items : [  IcdField   ]
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
		   }]
      
        
     })
       

    ///view
	var por = new Ext.Viewport({

		layout : 'border', // 使用border布局
		items : [Panel ]

	});
  

});
