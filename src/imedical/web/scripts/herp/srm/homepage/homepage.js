/**
  *author:liuyang
  *Date:2011-12-13
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
    
	var abc=0,
	tipw=[];
	//��һ���������õ���
	
	tipw[abc] = new Ext.ux.TipsWindow(
	{
	title: "С��ʿ<a>���ӷ�����</a>",
	autoHide: 5,
	count:abc+1,//���õ������ǵڼ���
	//5���Զ��ر�
	html: "������ʾ"
	});
	tipw[abc].show();
	

    var indexpanel= new Ext.Panel({
		id :'indexpanel',
		region: 'center',
		layout: 'border',
		items: [MyTransactionPanel,MySRMPanel,SRMDynamicPanel] //�ҵ������ҵĿ��У����ж�̬
	});
/*
// ********************************************���Ĺ���************************************************************** 	  
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
                            text: '���ı����뽱������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClick3
                        }, {
                            text: '���ı����뽱�����',
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
			items:[SRMAauditqueryPanel,SRMAaudititemGrid]                                 //添加Tabs
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
     	Ext.getCmp('panel').add(indexpanel);//���mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(indexpanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClick1(item){
    	//debugger;
	    //Ext.getCmp('panel').removeAll();

     	 Ext.getCmp('panel').add(SRMApplypaperPanel);//���mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(SRMApplypaperPanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClick2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(SRMAauditapplypaperPanel);//���mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(SRMAauditapplypaperPanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClick3(item){
	    Ext.getCmp('panel').add(EnPaperPubRegPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(EnPaperPubRegPanel);  
	  	Ext.getCmp('panel').doLayout()
    }
   function onItemClick4(item){
	    Ext.getCmp('panel').add(EnPaperRewAudPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(EnPaperRewAudPanel);  
	  	Ext.getCmp('panel').doLayout()
    }

//***************************************רער������*********************************************************************************	
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
			items:[srmmonographauditqueryPanel,srmmonographaudititemGrid]                                 //添加Tabs
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
                            text: 'ר����������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickpatent1
                        }, {
                            text: 'ר���������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickpatent2
                        }, {
                            text: 'ר����������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickpatent3
                        }, {
                            text: 'ר���������',
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

     	 Ext.getCmp('panel').add(SRMmonographPanel);//���mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(SRMmonographPanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClickpatent2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(SRMmonographauditPanel);//���mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(SRMmonographauditPanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClickpatent3(item){
	    Ext.getCmp('panel').add(SRMpatentPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(SRMpatentPanel);  
	  	Ext.getCmp('panel').doLayout()
    }
   function onItemClickpatent4(item){
	    Ext.getCmp('panel').add(SRMpatentauditPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(SRMpatentauditPanel);  
	  	Ext.getCmp('panel').doLayout()
    }

//***************************************��Ŀ����*********************************************************************************	
    var projectmenu = new Ext.menu.Menu({
    	id: 'projectmenu',
    	style: {
       		 overflow: 'visible'
    	},
                    items: [
                        {
                            text: '������Ŀ����',
							menu:{
								items:[
									{
									 text:'������Ŀ��������ϱ�',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject1
									},
									{
									 text:'������Ŀ����������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject2
									},
									{
									 text:'������Ŀ����',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject3
									},
									{
									 text:'������Ŀ�������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject4
									},
									{
									 text:'������Ŀ��������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject5
									},
									{
									 text:'������Ŀ�������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject6
									},
								]
							}
                        }, {
                            text: '������Ŀ����',
							menu:{
								items:[
									{
									 text:'������Ŀ��������ϱ�',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject7
									},
									{
									 text:'������Ŀ����������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject8
									},
									{
									 text:'������Ŀ����',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject9
									},
									{
									 text:'������Ŀ�������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject10
									},
									{
									 text:'������Ŀ��������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject11
									},
									{
									 text:'������Ŀ�������',
									 checked:false,
									 group:'theme',
									 checkHandler:onItemClickProject12
									},
								]
							}
                        }, {
                            text: '��Ŀ�������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject13
                        }, {
                            text: '��Ŀ�м�����',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject14
                        }, {
                            text: '��Ŀ�м����',
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

     	 Ext.getCmp('panel').add(SRMHonrizonalPrjApplyTabPanel);//���mypanel masterPane.doLayout();
	  	 Ext.getCmp('panel').layout.setActiveItem(SRMHonrizonalPrjApplyTabPanel);  
	  	 Ext.getCmp('panel').doLayout()
    }
    function onItemClickProject2(item){
	    //Ext.getCmp('panel').removeAll();
     	Ext.getCmp('panel').add(SRMHonrizonalAuditTabPanel);//���mypanel masterPane.doLayout();
        Ext.getCmp('panel').layout.setActiveItem(SRMHonrizonalAuditTabPanel); 
        Ext.getCmp('panel').doLayout()
    }
    function onItemClickProject3(item){
	    Ext.getCmp('panel').add(HPSetupTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(HPSetupTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }
   function onItemClickProject4(item){
	    Ext.getCmp('panel').add(HPSetUpAuditTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(HPSetUpAuditTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }    

   function onItemClickProject5(item){
	    Ext.getCmp('panel').add(HPCheckTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(HPCheckTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 

   function onItemClickProject6(item){
	    Ext.getCmp('panel').add(AuditHPCheckApplyTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(AuditHPCheckApplyTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }   
//������Ŀ������������ϱ�
   function onItemClickProject7(item){
	    Ext.getCmp('panel').add(VerticalPrjTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalPrjTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }   
//������Ŀ��������������
   function onItemClickProject8(item){
	    Ext.getCmp('panel').add(VerticalAuditTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalAuditTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }   
//������Ŀ��������
   function onItemClickProject9(item){
	    Ext.getCmp('panel').add(VerticalTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }  
//������Ŀ�������
   function onItemClickProject10(item){
	    Ext.getCmp('panel').add(VerticalApprovalAuditTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VerticalApprovalAuditTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    }  
 //���������������
   function onItemClickProject11(item){
	    Ext.getCmp('panel').add(VCPrjTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VCPrjTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
//������Ŀ�������
   function onItemClickProject12(item){
	    Ext.getCmp('panel').add(VCheckAuditPrjTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(VCheckAuditPrjTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
    //��Ŀ�������
    function onItemClickProject13(item){
	    Ext.getCmp('panel').add(uPanelm);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(uPanelm);  
	  	Ext.getCmp('panel').doLayout()
    }  
    //��Ŀ�м�����
    function onItemClickProject14(item){
	    Ext.getCmp('panel').add(PrjMidCheckTabPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(PrjMidCheckTabPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
     //��Ŀ�м����
    function onItemClickProject15(item){
	    Ext.getCmp('panel').add(PrjMidCheckAuditTabPanel);//���mypanel masterPane.doLayout();
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
                            text: '���м�������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject16
                        }, {
                            text: '���м������',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject17
                        }, {
                            text: '���гɹ�����',
                            checked: false,
                            group: 'theme',
                            //iconCls: 'user',
                            checkHandler: onItemClickProject18
                        }, {
                            text: '���гɹ����',
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
		items:[bbqueryPanel,bbitemGrid]                                 //���Tabs
  });
  var tccPanel =  new Ext.Panel({
		title:'���м������',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[ccqueryPanel,ccitemGrid]                                 //���Tabs
  });
   //���м�������
    function onItemClickProject16(item){
	    Ext.getCmp('panel').add(tbbPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(tbbPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
         //���м������
    function onItemClickProject17(item){
	    Ext.getCmp('panel').add(tccPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(tccPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
         //���гɹ�����
    function onItemClickProject18(item){
	    Ext.getCmp('panel').add(PrjAchievementApplyPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(PrjAchievementApplyPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
         //���гɹ����
    function onItemClickProject19(item){
	    Ext.getCmp('panel').add(PrjAchievementAuditPanel);//���mypanel masterPane.doLayout();
	  	Ext.getCmp('panel').layout.setActiveItem(PrjAchievementAuditPanel);  
	  	Ext.getCmp('panel').doLayout()
    } 
	var panel = new Ext.Panel({
		id:'panel',
    	region:'center',
    	layout: 'card', 
    	activeItem : 0,
    	title: '���й���ϵͳ'+new Date(),
    	items:[indexpanel],
    	tbar: [{ text: "��ҳ", menu: indexmenu, iconCls: 'indexhome',handler:onItemClickindexmenu},
    	  	 	{ text: "���Ĺ���", menu: menu, iconCls: 'tabs'},
    	   		{ text: "ר��ר������", menu: patentmenu,iconCls: 'tabs'},
    	   		{ text: "��Ŀ����", menu: projectmenu,iconCls: 'tabs'},
    	   		{ text: "���гɹ�����", menu: prjachievementmenu,iconCls: 'tabs'}]
});
*/
var mainPanel = new Ext.Viewport({
  		layout: 'border',
  		//items : panel,
		items:indexpanel,
  		renderTo: 'mainPanel'//renderTo:'mainPanel'�������븺������󶨵�һ��div���mainPanel����div��ID��
 });  
});

/**

		 **/