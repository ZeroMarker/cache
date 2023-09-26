/*
 * Ext JS Library 3.1.0
 * Copyright(c) 2009-2010 DHCC
 */


Ext.onReady(function(){
	   
	   
	   
	    var tabs2 = new Ext.TabPanel({
        renderTo:"Tab1",
        activeTab:Index,
        height:270,
        plain:true,
        deferredRender: true,
        enableTabScroll: true, //当Tab标签过多时,出现滚动条
        tabPosition: 'top',
        //defaults:{autoScroll: true},
        
        items:[{
                title: '预约',
                listeners: {activate: handleActivate},
                html:"<iframe id='dataframeTAB' name='dataframe' height='100%' width='100%' src='" + linkBookedItem + "'/>"

            },{
                title: '登记',
                 listeners: {activate: handleActivate},
                html:"<iframe id='dataframeTAB1' name='dataframe1' height='100%' width='100%' src='" + linkRegister + "'/>"

            }
            /*,{
                title: '预约登记',
                 listeners: {activate: handleActivate},
                html:"<iframe id='dataframeTAB2' name='dataframe2' height='100%' width='100%' src='" + linkBookedRegister + "'/>"

            }*/,{
                title: '预约列表',
                 listeners: {activate: handleActivate},
                html:"<iframe id='dataframeTAB3' name='dataframe3' height='100%' width='100%' src='" + ListBookItem + "'/>"

            }]
       
          
    });
    
    
   
    function handleActivate(tab)
    {
        //alert(tab.title +linkRegister);
    }
    
    
     //把TabPanel组件充满整个body容器.     
     new Ext.Viewport({     
        layout: 'fit',     
        items: tabs2     
       });  

  
});