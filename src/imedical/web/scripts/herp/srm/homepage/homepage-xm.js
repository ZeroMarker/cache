/**
  *author:liuyang
  *Date:2011-12-13
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
   
    var indexpanel= new Ext.Panel({
		id :'indexpanel',
		region: 'center',
		layout: 'border',
		items: [MyTransactionPanel,MySRMPanel,SRMDynamicPanel,SRMNewsPanel] //�ҵ������ҵĿ��У����ж�̬
	});

	  
var indexmenu = new Ext.menu.Menu({
	id:'indexmenu',
	style:{overflow: 'visible'},
	items:indexpanel,
	checkHandler: onItemClickindexmenu
	
});
	
	
var menu = new Ext.menu.Menu({
    id: 'mainMenu',
    style: {
        overflow: 'visible'
    },
        // <-- submenu by nested config object
                    items: [
                        // stick any markup in a menu
                        {
                            text: '����Ͷ������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick1
                        }, {
                            text: '����Ͷ����������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick2
                        }, {
                            text: '���ĵǼ�',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick3
                        }, {
                            text: '���ı����뽱������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick1
                        }
                    ]
                
            
        
    })
    
    	var indexpanel = new Ext.Panel({
    		id:'indexpanel',
			region: 'center',
			layout: 'border',
			items: [MyTransactionPanel,MySRMPanel,SRMDynamicPanel,SRMNewsPanel] //�ҵ������ҵĿ��У����ж�̬
    	});
    	var bgpanel = new Ext.Panel({
	  		id:'bgpanel',
	  		region:'center',
	  		layout: 'border',
			items:[queryPanel,itemGrid] 
	  })
	      	var bgpanel2 = new Ext.Panel({
	  		id:'bgpanel2',
	 		region:'center',
	  		layout: 'fit',
	 		title:'��������',
	  		html:"xxxxx"
	  })
	  
    function onItemClickindexmenu(item){
     	Ext.getCmp('panel').add(indexpanel);//���mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(indexpanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClick1(item){
    	//debugger;
	    //Ext.getCmp('panel').removeAll();

     	 Ext.getCmp('panel').add(bgpanel);//���mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(bgpanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClick2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(bgpanel2);//���mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(bgpanel2); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClick3(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(new Ext.Panel({
	  		id:'bgpanel3',
	 		region:'center',
	  		layout: 'fit',
	 		title:'yyyyy',
	  		html:"yyyy"
	  }));//���mypanel masterPane.doLayout();
        Ext.getCmp('panel').doLayout()
    }
var panel = new Ext.Panel({
	id:'panel',
    region:'center',
    layout: 'card', 
    activeItem : 0,
    title: '���й���ϵͳ',
    items:[indexpanel],
    tbar: [{ text: "��ҳ", menu: indexmenu, iconCls: 'user',handler:onItemClickindexmenu},
    	   { text: "���Ĺ���", menu: menu, iconCls: 'user'},
    	   { text: "��Ŀ����", menu: menu,iconCls: 'user'}]
});
	var mainPanel = new Ext.Viewport({
  		layout: 'border',
  		items : panel,
  		renderTo: 'mainPanel'//renderTo:'mainPanel'�������븺������󶨵�һ��div���mainPanel����div��ID��
   });
	
  
});

/**

		 **/