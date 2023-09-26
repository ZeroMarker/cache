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
		title:"病案管理系统 V3.1.0",
		autoScroll:false,
		split:true,
		collapsible:true,   //自动收缩按钮
		border:true,
		width:200,
		minSize: 100,
		maxSize: 300,
		//margins:'0 0 5 5',
		//cmargins:'0 5 5 5',
		//lines:false,
		layout:"fit",
		//extraCls:"roomtypegridbbar",
		//iconCls:'icon-feed',
		//添加动画效果
		//layoutConfig: {animate: true},
		items:[]
	});
	
	var objMainService = ExtTool.StaticServerObject("DHCWMR.MainService.MainSrv");
	
	var pId = '1';
	var pName = '病案管理系统';
	var IconClass = 'icon-pro';
	var ProVersion = 'V3.1.0';
	var tree = new Ext.tree.TreePanel({
		border:false,
		animate:true,
		enableDD:false,
		containerScroll:true,
		loader: new Ext.tree.TreeLoader({dataUrl:"dhcwmr.main.loadmenus.csp?groupId="+groupId+"&parentId=0&proId="+pId}),
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
		//title:pName+" "+ProVersion,
		autoScroll:true,
		//collapsed:false,
		//iconCls:IconClass,  //"icon-pro",
		//icon:"../Scripts/dhcmed/main/pro.gif",
		items:tree
	});
	westpanel.add(proPanel);
	
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
							frames['iframe_' + node.id].location.reload();
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
			//html:"Welcome"   dhcmed.ss.welcomepage.csp -> dhcmed.ss.portal.csp
			//html : '<iframe id="searchTreeIframe_id" src="dhcmed.ss.portal.csp" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'
			html : '<img id="imgHome" src="../images/trakcare/logo_backgr_1.gif" width="100%" height="114px" />'
		}]
	});
	
	var viewport = new Ext.Viewport({
		layout:'border',
		items:[westpanel,centertab]
	});
});
