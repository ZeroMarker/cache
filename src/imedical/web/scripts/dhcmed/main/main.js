/*
 * Ext JS Library 3.1.0
 * Copyright(c) 2009-2010 DHCC
 */

Ext.onReady(function(){

	Ext.QuickTips.init();
	var groupId =session['LOGON.GROUPID'];
	var westpanel = new Ext.Panel({
		id:'westpanel',
		region:"west",
		title:"",
		autoScroll:false,
		split:true,
		collapsible:true,   //自动收缩按钮 
		border:true,
		width:220,
		minSize: 100,
		maxSize: 300,
		//margins:'0 0 5 5',
		//cmargins:'0 5 5 5',
		//lines:false,
		layout:"accordion",
		//extraCls:"roomtypegridbbar",
		//iconCls:'icon-feed', 
		//添加动画效果
		layoutConfig: {animate: true},
		items:[]
	});
	
	var objMainService = ExtTool.StaticServerObject("DHCMed.SSService.Main");
	var sProducts = objMainService.GeProductsByGroup(groupId);
		
	var arryTmp = sProducts.split("<$C1>");
		for(var intRow = 0; intRow < arryTmp.length; intRow ++)
		{
			 var product = arryTmp[intRow];
			 if(product == "") continue;
			 /*
			 var arryField = product.split("<$C2>");
			 var pId = arryField[0];
			 var pName = arryField[1];
			 */
			 var arryField = product.split("^");
			 var pId = arryField[0];
			 var pName = arryField[1];
			 var IconClass = arryField[2]
			 var ProVersion = arryField[3];
			 var tree = new Ext.tree.TreePanel({
    						border:false,
    						animate:true,
    						enableDD:false,
    						containerScroll:true,
		                loader: new Ext.tree.TreeLoader({dataUrl:"dhcmed.main.loadmenus.csp?groupId="+groupId+"&parentId=0&proId="+pId}),
		                rootVisible:false,
		                lines:false,
		                autoScroll:true,
		                root: new Ext.tree.AsyncTreeNode({
		                          text: 'Project',
		                          expanded:true
		                }),
		                listeners:{
		                	"click":function(node,event){
		        				addtab(node);
		        			}
		                }
			});
       		
			var proPanel = new Ext.Panel({
	    			title:pName, //+" "+ProVersion,  //去掉版本显示 2018-11-19 zhufei
	    			autoScroll:true,
	    			collapsed:true,
	    			iconCls:IconClass,  //"icon-pro",
	    			//icon:"../Scripts/dhcmed/main/pro.gif",
	    			items:tree
	    		});
	    		westpanel.add(proPanel);
		}
		
    var addtab = function(node){
    	if (!node.isLeaf()) return;
    	var tabs=Ext.getCmp('main-tabs');
    	var tabId = "tab_"+node.id;
    	var obj = Ext.getCmp(tabId);
    	if (obj){}
    	else{
    	    var strURL=objMainService.GetMenuLinkUrl(node.id);
    	    if (strURL!="") strURL = strURL + "&menuId=" + node.id + "&LogonLocID=" + LogonLocID + "&LogonHospID=" + LogonHospID + "&2=2";
    	    obj=tabs.add({
    	    	id:tabId,
            	title:node.text,
            	tabTip:node.text,
            	html:"<iframe id='iframe_" + node.id + "' height='100%' width='100%' src='" + strURL + "'/>",
            	closable:true,
				listeners: {
					"activate": function(){
						if (strURL.indexOf('dhccpmrunqianreport')>-1){
							//frames['iframe_' + node.id].location.reload();	//update by liuyh 2017-07-28 不需要重新加载页面
						}
					}
				}
      		 })
    	}
    	obj.show();
    	//westpanel.collapse(true);    //add by wuqk 2012-05-17
    };
         
	var centertab =  new Ext.TabPanel({
		id:'main-tabs',
		activeTab:0,
		region:'center',
		enableTabScroll:true,
		resizeTabs: true,
		tabWidth:130,
		minTabWidth:120,
		//margins:'0 5 5 0',
		resizeTabs:true,
		//tabWidth:150
		items:[{
			title:"Home",
			//html:"Welcome"   dhcmed.ss.welcomepage.csp -> dhcmed.ss.portal.csp -> dhcma.ss.publichealth.csp
			//html : '<iframe id="searchTreeIframe_id" src="dhcmed.ss.portal.csp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'
			html : '<iframe id="searchTreeIframe_id" src="dhcma.ss.publichealth.csp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'   //新版主页
		}]
	});
    
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab]
    	});  
});
var add=function(tab){
  	//Ext.Msg.alert("",str);
  	//centertab.setTitle(str);
		var strURL="dhcmed.portletdefalut.csp?id="+tab.id;
		//var html='<iframe src="dhcmed.ss.portal.csp"'+strURL+' width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>';  	
  	var tabPage = Ext.getCmp("main-tabs").add({//动态添加tab页
  					id:"tab_"+tab.id,    
            title:tab.title,
            tabTip:tab.title,    
            html:"<iframe src='"+strURL+"' height='100%' width='100%'></iframe>",  //'test tabs',    
            closable:true//允许关闭    
        });  
    // tabPage.show();   
        Ext.getCmp("main-tabs").setActiveTab(tabPage);//设置当前tab页 
  	//Ext.getCmp("main-tabs").add({contentEl:'tab3', title:'Tab 3'});
  	//Ext.getCmp("main-tabs").setTitle(str+"MIX");
  	//Ext.Msg.alert("",Ext.getCmp("main-tabs").title);
  	
};