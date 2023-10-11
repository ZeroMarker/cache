document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	var ComboPage=Ext.BDP.FunLib.PageSize.Combo;
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			 
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')   
	 
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.CTLocalityTypeOfCommunity&pClassMethod=GetTreeJson";
	var myPanel = new Ext.BDP.Component.DataAutPanel({
		        region : "center",
		        dataUrl : Tree_ACTION_URL,  
		        ObjectType : ObjectType,
				ObjectReference : ObjectReference,
		        pageSize : Ext.BDP.FunLib.PageSize.Aut,  
		        AutClass : "web.DHCBL.Authorize.CTLocalityTypeOfCommunity",  
		        getAutMethod : "GetAutJson", //获取授权数据方法
		        saveAutMethod : "SaveAuthorizeData"  //保存授权数据方法
	 });
	
	var viewport = new Ext.Viewport({
			   	layout:'border',
		    	items:[myPanel]
	});
});

 
