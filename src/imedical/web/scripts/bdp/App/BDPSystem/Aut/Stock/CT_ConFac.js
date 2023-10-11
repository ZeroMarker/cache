﻿
 	/// 名称:库存-4 单位转换 数据授权
	/// 编写者:基础数据平台 - 陈莹 
	/// 编写日期:2013-10-16
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel.js"> </script>');

Ext.onReady(function() {
	
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			//选中的类别类型，全局变量
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')  //选中的类别ID，全局变量
	var AutCode=Ext.BDP.FunLib.getParam('AutCode')    //获取授权页代码
    Ext.QuickTips.init();
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.CTConFac&pClassMethod=GetTreeJson";
	
	var myTree = new Ext.BDP.Component.DataAutPanel({
		        region : "center",
		        dataUrl : Tree_ACTION_URL, //页面初始化时加载数据
		        ObjectType : ObjectType,
				ObjectReference : ObjectReference,
		        pageSize:Ext.BDP.FunLib.PageSize.Aut,
		        AutClass : "web.DHCBL.Authorize.CTConFac", //获取授权数据类名称
		        getAutMethod : "GetAutJson", //获取授权数据方法
		        AutCode : AutCode,
		        saveAutMethod : 'SaveAuthorizeData' //保存授权数据方法
		    });
	
	//myTree.loadAuthorizeTree(ObjectType,ObjectReference); //重新加载数据
	
	var viewport = new Ext.Viewport({
		    	layout:'border',
		    	items:[myTree]
			});
});