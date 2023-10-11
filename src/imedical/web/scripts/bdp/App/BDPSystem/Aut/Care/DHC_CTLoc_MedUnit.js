//// Function: 医疗单元基础授权授权页面
///	 Creator:  sunfengchao
///	 CreateDate: 2016-1-5
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	var ComboPage=Ext.BDP.FunLib.PageSize.Combo;
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			 
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference') 
	var AutCode=Ext.BDP.FunLib.getParam('AutCode')    //获取授权页代码  
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.DHCCTLocMedUnit&pClassMethod=GetTreeJson";
	var myPanel = new Ext.BDP.Component.DataAutPanel({
	        region : "center",
	        dataUrl : Tree_ACTION_URL,  
	        ObjectType : ObjectType,
			ObjectReference : ObjectReference,
			AutCode :  AutCode,
	        pageSize : Ext.BDP.FunLib.PageSize.Aut, //分页大小,默认为0,为0时不分页
	        AutClass : "web.DHCBL.Authorize.DHCCTLocMedUnit", //保存授权数据类名称
	        getAutMethod : "GetAutJson", //获取授权数据方法
	        saveAutMethod : "SaveAuthorizeData"  //保存授权数据方法
	 });
	var viewport = new Ext.Viewport({
			layout:'border',
		    items:[myPanel]
	});
});

 
