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
        enableTabScroll: true, //��Tab��ǩ����ʱ,���ֹ�����
        tabPosition: 'top',
        //defaults:{autoScroll: true},
        
        items:[{
                title: 'ע������',
                listeners: {activate: handleActivate},
                html:"<iframe id='dataframeTAB' name='dataframe' height='100%' width='100%' src='" +RisListMemo+ "'/>"

            }]
       
          
    });
    
    if (UseKnowledge=="Y")
    {
	    tabs2.add({title: '����֢',
                listeners: {activate: handleActivate},
                html:"<iframe id='dataframeTAB1' name='dataframe1' height='100%' width='100%' src='" +ContraindicationMemo+ "'/>",
                closable : true})
                
        tabs2.add({title: '��Ӧ֢',
                listeners: {activate: handleActivate},
                html:"<iframe id='dataframeTAB2' name='dataframe2' height='100%' width='100%' src='" +IndicationMemo+ "'/>",
                closable : true})
	}
    
    
   
    function handleActivate(tab)
    {
        //alert(tab.title +linkRegister);
    }
    
    
     //��TabPanel�����������body����.     
     new Ext.Viewport({     
        layout: 'fit',    
        items: tabs2     
       });  

  
});