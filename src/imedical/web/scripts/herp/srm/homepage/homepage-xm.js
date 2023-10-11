/**
  *author:liuyang
  *Date:2011-12-13
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
   
    var indexpanel= new Ext.Panel({
		id :'indexpanel',
		region: 'center',
		layout: 'border',
		items: [MyTransactionPanel,MySRMPanel,SRMDynamicPanel,SRMNewsPanel] //我的事务，我的科研，科研动态
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
                            text: '论文投稿申请',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick1
                        }, {
                            text: '论文投稿申请审批',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick2
                        }, {
                            text: '论文登记',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick3
                        }, {
                            text: '论文报销与奖励申请',
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
			items: [MyTransactionPanel,MySRMPanel,SRMDynamicPanel,SRMNewsPanel] //我的事务，我的科研，科研动态
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
	 		title:'论文申请',
	  		html:"xxxxx"
	  })
	  
    function onItemClickindexmenu(item){
     	Ext.getCmp('panel').add(indexpanel);//添加mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(indexpanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClick1(item){
    	//debugger;
	    //Ext.getCmp('panel').removeAll();

     	 Ext.getCmp('panel').add(bgpanel);//添加mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(bgpanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClick2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(bgpanel2);//添加mypanel masterPane.doLayout();
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
	  }));//添加mypanel masterPane.doLayout();
        Ext.getCmp('panel').doLayout()
    }
var panel = new Ext.Panel({
	id:'panel',
    region:'center',
    layout: 'card', 
    activeItem : 0,
    title: '科研管理系统',
    items:[indexpanel],
    tbar: [{ text: "首页", menu: indexmenu, iconCls: 'user',handler:onItemClickindexmenu},
    	   { text: "论文管理", menu: menu, iconCls: 'user'},
    	   { text: "项目管理", menu: menu,iconCls: 'user'}]
});
	var mainPanel = new Ext.Viewport({
  		layout: 'border',
  		items : panel,
  		renderTo: 'mainPanel'//renderTo:'mainPanel'，这句代码负责把面板绑定到一个div层里，mainPanel就是div的ID。
   });
	
  
});

/**

		 **/