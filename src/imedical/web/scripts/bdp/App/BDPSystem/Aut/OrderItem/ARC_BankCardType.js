/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于银行卡类型的数据授权维护。
 * @Created on 2013-10-18
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel.js"> </script>');
Ext.onReady(function() {
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			//选中的类别类型，全局变量
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')  //选中的类别ID，全局变量
    Ext.QuickTips.init();
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.ARCBankCardType&pClassMethod=GetTreeJson";
	
	var myTree = new Ext.BDP.Component.DataAutPanel({
		        region : "center",
		        dataUrl : Tree_ACTION_URL, //页面初始化时加载数据
		        ObjectType : ObjectType,
				ObjectReference : ObjectReference,
		        pageSize : Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
		        AutClass : "web.DHCBL.Authorize.ARCBankCardType", //获取授权数据类名称
		        getAutMethod : "GetAutJson",					//获取授权数据方法
		        saveAutMethod : 'SaveAuthorizeData' //保存授权数据方法
		    });
    var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[myTree]
    	}); 
});