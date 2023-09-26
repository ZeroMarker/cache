/*
 * Ext JS Library 3.1.0
 * Copyright(c) 2009-2010 DHCC
 */

Ext.onReady(function(){

	Ext.QuickTips.init();
	
	
	var objRootNode = new Ext.tree.TreeNode({
		text: '综合检测',
		draggable: false,
		id: 'root',
		leaf : false
	});
	objRootNode.appendChild(new Ext.tree.TreeNode({
		text : '新病例列表',
		draggable: false,
		leaf : false
	}));
	objRootNode.childNodes[0].appendChild(new Ext.tree.TreeNode({
		id : 'QryAutoworkCtlsummary',
		text : '疑似病例列表',
		leaf : true,
		href : './dhcmed.cc.qryautoworkctlsummary.csp?SubjectID=' + document.getElementById("SubjectID").value,
		hrefTarget : 'controlFrame'		
	}));
	objRootNode.childNodes[0].appendChild(new Ext.tree.TreeNode({
		id : 'FeedbackManage',
		text : '反馈管理',
		leaf : true,
		href : './dhcmed.cc.qryfeedback.csp?SubjectID=' + document.getElementById("SubjectID").value,
		hrefTarget : 'controlFrame'
	}));
	objRootNode.appendChild(new Ext.tree.TreeNode({
		text : '综合监测',
		leaf : true,
		href : './dhcmed.cc.integratedcontrol.control.csp?SubjectID=' + document.getElementById("SubjectID").value,
		hrefTarget : 'controlFrame'	
	}));
	objRootNode.appendChild(new Ext.tree.TreeNode({
		text : '综合监测统计',
		leaf : true,
		href : './dhcmed.cc.integratedcontrolsta.csp',
		hrefTarget : 'controlFrame'		
	}));
	objRootNode.appendChild(new Ext.tree.TreeNode({
		text : '感染趋势分析',
		leaf : true,
		href : './dhcmed.cc.inftendencychart.csp',
		hrefTarget : 'controlFrame'		
	}));

	
	var tree = new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		root : objRootNode
	});

	
	var westpanel = new Ext.Panel({
		id:'westpanel',
    		region:"west",
    		title:"",
    		autoScroll:true,
    		split:true,
    		collapsible:true,   //自动收缩按钮 
    		border:true,
    		width:220,
    		minSize: 220,
			maxSize: 300,
    		layout:"accordion",
     		//添加动画效果
    		layoutConfig: {animate: true},
			layout : 'fit',
    		items:[tree]
	});

	var centertab =  new Ext.Panel({
        id:'main-tabs',
        region:'center',
        enableTabScroll:true,
		html : '<iframe id="controlFrame" name="controlFrame" src="../scripts/dhcmed/img/logon_bg2.jpg" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'
	});
              
	var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[westpanel,centertab]
    	});
	tree.expandAll();
		tree.on("click", 
		function(){
			westpanel.collapse(false);
		}
	)
});