// 医生专长授权
// 不分级菜单
// 2013-10-11 by caihaozhe
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel.js"> </script>');

Ext.onReady(function() {
	
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')  //选中的类别ID，全局变量
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			//选中的类别类型，全局变量
	
    Ext.QuickTips.init();
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.CTSpec&pClassMethod=GetTreeJson";
	var pagesize = 10;
	
	var myTree = new Ext.BDP.Component.DataAutPanel({
        region:"center",
		dataUrl:Tree_ACTION_URL,
        ObjectType : ObjectType, 
		ObjectReference : ObjectReference, 
        pageSize:Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
        disToolbar : true, //是否显示搜索工具条
        isCascade : true,   //级联
        AutClass : "web.DHCBL.Authorize.CTSpec", //获取授权数据类名称
        getAutMethod : "GetAutJson",					//获取授权数据方法
        saveAutMethod : 'SaveAuthorizeData' //保存授权数据方法
        ///////////////////////////////////////////////////////////////
    });
	
	//myTree.loadAuthorizeTree(ObjectType,ObjectReference);
    
    var viewport = new Ext.Viewport({
        	layout:'border',
        	items:[myTree]
    	}); 
});