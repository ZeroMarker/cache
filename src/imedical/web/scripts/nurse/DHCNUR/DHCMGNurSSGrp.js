/**
 * { //title : "面板", region : "north", height : 0//, //html : "
 * <h1>网站后台管理系统!</h1>" },
 */
Ext.onReady(function() {
	var top = new Ext.BoxComponent({
		// el属性就是外面所对应的DIV
		el : "top",
		height : 80
	});
	var north = new Ext.Panel({
		border : false,
		region : "north",
		height : 80,
		// 把上面定义的BoxComponent作为Panel的内容
		items : [top]
	});
	var itmmould = cspRunServerMethod(getmouldext,session['LOGON.GROUPID']);
	//alert(itmmould);
	var west_item = new Ext.Panel({
		// 自动收缩按钮
		collapsible : true,
		border : false,
		width : 130,
		layout : "accordion",
		extraCls : "roomtypegridbbar",
		listeners : {
//			'collapse' : function(node, e) {
//				// alert(node.width);
//				Csizech();
//				// todo 收缩的操作
//			},
//			'expand' : function(node, e) {
//				// debugger;
//				Esizech(node.width - 32);
//				// alert(e);
//				// todo 展开的操作
//			}
		},
		// 添加动画效果
		layoutConfig : {
			animate : true
		},
		region : "west",
		title : '护理管理',
		items : eval(itmmould)
	});
        /*
         * {
							title : "面板",
							region : "north",
							height : 0,
							html : " <h1>网站后台管理系统!</h1>"
				},*/
	var hlurl='../csp/dhcnursemanagehome.csp';
	new Ext.Viewport({
		enableTabScroll : true,
		layout : "border",
		items : [ west_item, {
				xtype : "tabpanel",
				enableTabScroll : true,
				//minTabWidth : 120,
				//resizeTabs : true,
				id : "NurTabpanel",
				region : "center",
				activeTab:0,
				items : [{
					title:'Home' ,
				html:'<iframe id="iframetabDHCNurseHome" scrolling="auto" frameborder="0" width="100%" height="100%" src='+ hlurl + '> </iframe>'
				}]
		}]
	});
	var mould = cspRunServerMethod(getmould,session['LOGON.GROUPID']);
	var mouldarr = mould.split('^')
	for (i = 0; i < mouldarr.length; i++) {
		itm = mouldarr[i].split('|');
		if (mouldarr[i] == "")
			continue;
		var root = new Ext.tree.AsyncTreeNode({});
		var tree1 = new Ext.tree.TreePanel({
			renderTo : itm[0],
			root : root,// 定位到根节点
			autoScroll : true,
			height : 285,
			width : 130,
			containerScroll : true,
			animate : true,// 开启动画效果
			enableDD : true,// 不允许子节点拖动
			border : true,// 没有边框
			rootVisible : true,// 设为false将隐藏根节点，很多情况下，我们选择隐藏根节点增加美观性
			loader : new Ext.tree.TreeLoader({
				dataUrl : "../web.DHCMgNurMenu.cls?mouldid="+ itm[1] + "&SSGRP="+session['LOGON.GROUPID']
			})
		});
		tree1.expandAll();
		tree1.on('click', function(node, event) {
			// if (!node.isLeaf()){return;}
			nodeclick(node, event);
		});
	}
});
function nodeclick(node, e) {
	if(node.parentNode==null){
		return;
	}
	var wardid = node.parentNode.id;
	var nodetype = node.id
	// debugger;
	// alert(node.id)
	// alert(node.leaf);
	// frames['centerTab'].src="dhcmgnurwardinfo.csp";
	if (node.leaf == true) {
		var nurtab = Ext.getCmp("NurTabpanel");
		var oItem = {};
		var link = cspRunServerMethod(getLink, node.id);
		var hlurl = link+"&menucode="+nodetype;
		//alert(hlurl)
		if (hlurl.indexOf("?") != -1) {
		} else {
		}
		/*
		 * if (node.id.indexOf(".csp")!=-1) { var hlurl=node.id; }else{ var
		 * hlurl = "DHCNurEmrComm.csp?EpisodeID=" + EpisodeID + "&EmrCode=" +
		 * node.id; }
		 */
		oItem.id = "tab" + node.id;
		oItem.title = node.text;
		oItem.closable = true;
		var frameid = "iframe" + oItem.id;
		oItem.html = '<iframe id="'
				+ frameid
				+ '" scrolling="auto" frameborder="0" width="100%" height="100%" src="'
				+ hlurl + '"> </iframe>'
		nurtab.add(oItem);
		nurtab.setActiveTab("tab" + node.id);
		// frames['centerTab'].location.href="DHCNurEmrComm.csp?EpisodeID="+EpisodeID+"&EmrCode="+node.id;
	}
}
function Csizech() {
	var nurtab = Ext.getCmp("NurTabpanel");
	var curtab = nurtab.getActiveTab();//
	var frameid = "iframe" + curtab.id
	// debugger;
	var win = Ext.get(frameid).dom.contentWindow;
	win.SizeChange(0);
	// alert(win);
	// var parr="DHCNUR6^"+EpisodeID+"^CaseMeasureXml";
	// var ret=southTab.Save();

}
function Esizech(panelwidth) // 扩展
{
	var nurtab = Ext.getCmp("NurTabpanel");
	var curtab = nurtab.getActiveTab();//
	var frameid = "iframe" + curtab.id
	// debugger;
	var win = Ext.get(frameid).dom.contentWindow;
	win.SizeChange(-(panelwidth));
	// alert(win);
	// var parr="DHCNUR6^"+EpisodeID+"^CaseMeasureXml";
	// var ret=southTab.Save();

}