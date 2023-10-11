/// 名称: 基础数据维护分级管理
/// 编写者: 高姗姗
/// 编写日期: 2015-9-8
Ext.onReady(function() { 
	
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var TREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPGradeManage&pClassMethod=GetTreeJson";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	var RootId = tkMakeServerCall("web.DHCBL.BDP.BDPGradeManage","GetRootId",session['LOGON.HOSPID']);
	var hospId = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.Locations.CHSSDictHospital"); //医疗机构隐藏菜单id
	var locId = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.Locations.CTLoc"); //科室病区菜单id
	var userId = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.System.SSUser"); //用户菜单id
	
	var treeLoader = new Ext.tree.TreeLoader({
			nodeParameter: "LastLevel",
			dataUrl: TREE_ACTION_URL
		});
	treeLoader.on("beforeload", function(treeLoader, node) {
		if(session['LOGON.HOSPID']!=""){
			treeLoader.baseParams.HospId = session['LOGON.HOSPID'];
		}
    }, this); 
	var treePanel = new Ext.tree.TreePanel({
		region:'center',
		id: 'TreePanel',
		expanded:false,
		border:true,
		root: new Ext.tree.AsyncTreeNode({
				id:RootId,
				draggable:false, //可拖拽的
				expanded:false  //根节点自动展开
			}),
		loader: treeLoader,
		autoScroll: true,
		containerScroll: true,
		rootVisible:false,
        listeners:{
        	"click":function(node,event) {	
        		var linkHospital="dhc.bdp.ext.sys.csp?BDPMENU="+hospId+"&communityid="+node.id; 
        		if ("undefined"!==typeof websys_getMWToken){
					linkHospital += "&MWToken="+websys_getMWToken()
				}
        		if (Ext.getCmp('tabHospital').body!=undefined){
					Ext.getCmp('tabHospital').body.update('<iframe name="iframHospital" src=" '+linkHospital+' " width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'); 
        		}
				var linkLoc="dhc.bdp.ext.sys.csp?BDPMENU="+locId+"&communityid="+node.id; 
				if ("undefined"!==typeof websys_getMWToken){
					linkLoc += "&MWToken="+websys_getMWToken()
				}
				if (Ext.getCmp('tabLoc').body!=undefined){
					Ext.getCmp('tabLoc').body.update('<iframe  name="iframLoc" src=" '+linkLoc+' " width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>');  
				}
				var linkUser="dhc.bdp.ext.sys.csp?BDPMENU="+userId+"&communityid="+node.id; 
				if ("undefined"!==typeof websys_getMWToken){
					linkUser += "&MWToken="+websys_getMWToken()
				}
				if (Ext.getCmp('tabUser').body!=undefined){
					Ext.getCmp('tabUser').body.update('<iframe  name="iframUser" src=" '+linkUser+' " width="100%" height="97%" frameborder="0" scrolling="auto"></iframe>');  
				}
			}
        }
	});
	var panelWest = new Ext.Panel({
		id:'panelWest',
		title: '分级管理',
		layout:'border',
		region:'west',
		width:250,
		split:true,
		items:[treePanel]
	});
	var urlHospital="dhc.bdp.ext.sys.csp?BDPMENU="+hospId+"&communityid="+RootId; 
	if ("undefined"!==typeof websys_getMWToken){
		urlHospital += "&MWToken="+websys_getMWToken()
	}
	var tabHospital = new Ext.Panel({
		id:'tabHospital',
		title:'医疗机构',
		region:'center',
		frame:true,
		bodyBorder: false, 
		autoScroll : true,
		html:'<iframe  src="'+urlHospital+'" width="100%" height="100%"></iframe>'
	})
	var urlLoc="dhc.bdp.ext.sys.csp?BDPMENU="+locId+"&communityid="+RootId; 
	if ("undefined"!==typeof websys_getMWToken){
		urlLoc += "&MWToken="+websys_getMWToken()
	}
	var tabLoc = new Ext.Panel({
		id:'tabLoc',
		title:'科室病区',
		region:'center',
		frame:true,
		bodyBorder: false, 
		autoScroll : true,
		html:'<iframe  src="'+urlLoc+'" width="100%" height="100%"></iframe>'
	})
	var urlUser="dhc.bdp.ext.sys.csp?BDPMENU="+userId+"&communityid="+RootId; 
	if ("undefined"!==typeof websys_getMWToken){
		urlUser += "&MWToken="+websys_getMWToken()
	}
	var tabUser = new Ext.Panel({
		id:'tabUser',
		title:'用户',
		region:'center',
		frame:true,
		bodyBorder: false, 
		autoScroll : true,
		html:'<iframe src="'+urlUser+'" width="100%" height="97%" srolling="auto"></iframe>'
	})
	var tabs = new Ext.TabPanel({
		id:'tabs',
		region : 'center',
		tabWidth:60,
		autoScroll:true,
		enableTabScroll:true,
		border:false,
		frame:true,
		activeTab:0,
		defaults:{autoScroll:true},
		items:[tabHospital,tabLoc,tabUser]
	});
	var panelEast = new Ext.Panel({
		id : 'panelEast',
		region : 'center',
		layout:'border',
		items:[tabs]
	});
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [panelWest,panelEast]
	});

});
