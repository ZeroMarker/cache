/**
  *author:liuyang
  *Date:2011-12-13
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
    
	var abc=0,
	tipw=[];
	//加一个方法调用弹出
	
	tipw[abc] = new Ext.ux.TipsWindow(
	{
	title: "小贴士<a>电视发射塔</a>",
	autoHide: 5,
	count:abc+1,//设置弹出的是第几个
	//5秒自动关闭
	html: "这是提示"
	});
	tipw[abc].show();
	

    var indexpanel= new Ext.Panel({
		id :'indexpanel',
		region: 'center',
		layout: 'border',
		items: [MyTransactionPanel,MySRMPanel,SRMDynamicPanel] //我的事务，我的科研，科研动态
	});
/*
// ********************************************论文管理************************************************************** 	  
var indexmenu = new Ext.menu.Menu({
	id:'indexmenu',
	style:{overflow: 'visible'},
	items: indexpanel
	
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
                            text: '论文报销与奖励申请',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick3
                        }, {
                            text: '论文报销与奖励审核',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick4
                        }
                    ]
                
            
        
    })
  
      var SRMApplypaperPanel = new Ext.Panel({
	  		id:'SRMApplypaperPanel',
	  		region:'center',
	  		layout: 'border',
			items:[SRMApplypaperqueryPanel,SRMApplypaperitemGrid] 
	  })
	  var SRMAauditapplypaperPanel =  new Ext.Panel({
	  		id:'SRMAauditapplypaperPanel',
			layout: 'border',
			region:'center',
			items:[SRMAauditqueryPanel,SRMAaudititemGrid]                                 //娣诲姞Tabs
  	 });
  	 var EnPaperPubRegPanel = new Ext.Panel({
  	 		id:'EnPaperPubRegPanel',
  	 		layout:'border',
  	 		region:'center',
  	 		items:[EnPaperPubRegqueryPanel,EnPaperPubRegitemGrid] 
  	 });
  	 var EnPaperRewAudPanel = new Ext.Panel({
  	 		id:'EnPaperRewAudPanel',
  	 		layout:'border',
  	 		region:'center',
  	 		items:[EnPaperRewAudqueryPanel,EnPaperRewAuditemGrid] 
  	 });	  
    function onItemClickindexmenu(item){
     	Ext.getCmp('panel').add(indexpanel);//添加mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(indexpanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClick1(item){
    	//debugger;
	    //Ext.getCmp('panel').removeAll();

     	 Ext.getCmp('panel').add(SRMApplypaperPanel);//添加mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(SRMApplypaperPanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClick2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(SRMAauditapplypaperPanel);//添加mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(SRMAauditapplypaperPanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClick3(item){
	    Ext.getCmp('panel').add(EnPaperPubRegPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(EnPaperPubRegPanel);  
	  	Ext.getCmp('panel').doLayout()
    }
   function onItemClick4(item){
	    Ext.getCmp('panel').add(EnPaperRewAudPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(EnPaperRewAudPanel);  
	  	Ext.getCmp('panel').doLayout()
    }

//***************************************专注专利管理*********************************************************************************	
       var SRMmonographPanel = new Ext.Panel({
	  		id:'SRMmonographPanel',
	  		region:'center',
	  		layout: 'border',
			items:[srmmonographitemGrid,srmmonographqueryPanel]
	  })
	  var SRMmonographauditPanel =  new Ext.Panel({
	  		id:'SRMmonographauditPanel',
			layout: 'border',
			region:'center',
			items:[srmmonographauditqueryPanel,srmmonographaudititemGrid]                                 //娣诲姞Tabs
  	 });
  	 var SRMpatentPanel = new Ext.Panel({
  	 		id:'SRMpatentPanel',
  	 		layout:'border',
  	 		region:'center',
  	 		items:[srmpatentqueryPanel,srmpatentitemGrid] 
  	 });
  	 var SRMpatentauditPanel = new Ext.Panel({
  	 		id:'SRMpatentauditPanel',
  	 		layout:'border',
  	 		region:'center',
  	 		items:[SRMpatentauditqueryPanel,SRMpatentaudititemGrid]  
  	 });	
    var patentmenu = new Ext.menu.Menu({
    	id: 'patentmenu',
    	style: {
       		 overflow: 'visible'
    	},
                    items: [
                        {
                            text: '专著奖励申请',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickpatent1
                        }, {
                            text: '专著奖励审核',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickpatent2
                        }, {
                            text: '专利奖励申请',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickpatent3
                        }, {
                            text: '专利奖励审核',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickpatent4
                        }
                    ]
                       
    })
   function onItemClickpatent1(item){
    	//debugger;
	    //Ext.getCmp('panel').removeAll();

     	 Ext.getCmp('panel').add(SRMmonographPanel);//添加mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(SRMmonographPanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClickpatent2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(SRMmonographauditPanel);//添加mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(SRMmonographauditPanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClickpatent3(item){
	    Ext.getCmp('panel').add(SRMpatentPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(SRMpatentPanel);  
	  	Ext.getCmp('panel').doLayout()
    }
   function onItemClickpatent4(item){
	    Ext.getCmp('panel').add(SRMpatentauditPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(SRMpatentauditPanel);  
	  	Ext.getCmp('panel').doLayout()
    }

//***************************************项目管理*********************************************************************************	
    var projectmenu = new Ext.menu.Menu({
    	id: 'projectmenu',
    	style: {
       		 overflow: 'visible'
    	},
                    items: [
                        {
                            text: '横向项目管理',
							menu:{
								items:[
									{
									 text:'横向项目申请材料上报',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject1
									},
									{
									 text:'横向项目申请材料审核',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject2
									},
									{
									 text:'横向项目立项',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject3
									},
									{
									 text:'横向项目立项审核',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject4
									},
									{
									 text:'横向项目验收申请',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject5
									},
									{
									 text:'横向项目验收审核',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject6
									},
								]
							}
                        }, {
                            text: '纵向项目管理',
							menu:{
								items:[
									{
									 text:'纵向项目申请材料上报',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject7
									},
									{
									 text:'纵向项目申请材料审核',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject8
									},
									{
									 text:'纵向项目立项',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject9
									},
									{
									 text:'纵向项目立项审核',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject10
									},
									{
									 text:'纵向项目验收申请',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject11
									},
									{
									 text:'纵向项目验收审核',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject12
									},
								]
							}
                        }, {
                            text: '项目伦理审核',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject13
                        }, {
                            text: '项目中检申请',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject14
                        }, {
                            text: '项目中检审核',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject15
                        }
                    ]
                       
    })
   function onItemClickProject1(item){
    	//debugger;
	    //Ext.getCmp('panel').removeAll();

     	 Ext.getCmp('panel').add(SRMHonrizonalPrjApplyTabPanel);//添加mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(SRMHonrizonalPrjApplyTabPanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClickProject2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(SRMHonrizonalAuditTabPanel);//添加mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(SRMHonrizonalAuditTabPanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClickProject3(item){
	    Ext.getCmp('panel').add(HPSetupTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(HPSetupTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }
   function onItemClickProject4(item){
	    Ext.getCmp('panel').add(HPSetUpAuditTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(HPSetUpAuditTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }    

   function onItemClickProject5(item){
	    Ext.getCmp('panel').add(HPCheckTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(HPCheckTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 

   function onItemClickProject6(item){
	    Ext.getCmp('panel').add(AuditHPCheckApplyTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(AuditHPCheckApplyTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }   
//纵向项目立项申请材料上报
   function onItemClickProject7(item){
	    Ext.getCmp('panel').add(VerticalPrjTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalPrjTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }   
//纵向项目立项申请材料审核
   function onItemClickProject8(item){
	    Ext.getCmp('panel').add(VerticalAuditTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalAuditTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }   
//纵向项目立项申请
   function onItemClickProject9(item){
	    Ext.getCmp('panel').add(VerticalTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }  
//纵向项目立项审核
   function onItemClickProject10(item){
	    Ext.getCmp('panel').add(VerticalApprovalAuditTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalApprovalAuditTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }  
 //纵向课题验收申请
   function onItemClickProject11(item){
	    Ext.getCmp('panel').add(VCPrjTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VCPrjTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
//纵向项目验收审核
   function onItemClickProject12(item){
	    Ext.getCmp('panel').add(VCheckAuditPrjTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VCheckAuditPrjTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
    //项目伦理审核
    function onItemClickProject13(item){
	    Ext.getCmp('panel').add(uPanelm);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(uPanelm);  
	  	Ext.getCmp('panel').doLayout()
    }  
    //项目中检申请
    function onItemClickProject14(item){
	    Ext.getCmp('panel').add(PrjMidCheckTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(PrjMidCheckTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
     //项目中检审核
    function onItemClickProject15(item){
	    Ext.getCmp('panel').add(PrjMidCheckAuditTabPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(PrjMidCheckAuditTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
    
    
     var prjachievementmenu = new Ext.menu.Menu({
    	id: 'prjachievementmenu',
    	style: {
       		 overflow: 'visible'
    	},
                    items: [
                        {
                            text: '科研鉴定申请',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject16
                        }, {
                            text: '科研鉴定审核',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject17
                        }, {
                            text: '科研成果申请',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject18
                        }, {
                            text: '科研成果审核',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject19
                        }
                    ]
                       
    })
	
	var PrjAchievementApplyPanel = new Ext.Panel({
	    id:'PrjAchievementApplyPanel',
		region: 'center',
		layout: 'border',
		items: [PrjAchievementqueryPanel,PrjAchievementitemGrid]
	});
	var tbbPanel =  new Ext.Panel({
		id:'tbbPanel',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[bbqueryPanel,bbitemGrid]                                 //添加Tabs
  });
  var tccPanel =  new Ext.Panel({
		title:'科研鉴定审核',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[ccqueryPanel,ccitemGrid]                                 //添加Tabs
  });
   //科研鉴定申请
    function onItemClickProject16(item){
	    Ext.getCmp('panel').add(tbbPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(tbbPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
         //科研鉴定审核
    function onItemClickProject17(item){
	    Ext.getCmp('panel').add(tccPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(tccPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
         //科研成果申请
    function onItemClickProject18(item){
	    Ext.getCmp('panel').add(PrjAchievementApplyPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(PrjAchievementApplyPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
         //科研成果审核
    function onItemClickProject19(item){
	    Ext.getCmp('panel').add(PrjAchievementAuditPanel);//添加mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(PrjAchievementAuditPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
	var panel = new Ext.Panel({
		id:'panel',
    	region:'center',
    	layout: 'card', 
    	activeItem : 0,
    	title: '科研管理系统'+new Date(),
    	items:[indexpanel],
    	tbar: [{ text: "首页", menu: indexmenu, iconCls: 'indexhome',handler:onItemClickindexmenu},
    	  	 	{ text: "论文管理", menu: menu, iconCls: 'tabs'},
    	   		{ text: "专著专利管理", menu: patentmenu,iconCls: 'tabs'},
    	   		{ text: "项目管理", menu: projectmenu,iconCls: 'tabs'},
    	   		{ text: "科研成果管理", menu: prjachievementmenu,iconCls: 'tabs'}]
});
*/
var mainPanel = new Ext.Viewport({
  		layout: 'border',
  		//items : panel,
		items:indexpanel,
  		renderTo: 'mainPanel'//renderTo:'mainPanel'，这句代码负责把面板绑定到一个div层里，mainPanel就是div的ID。
 });  
});

/**

		 **/