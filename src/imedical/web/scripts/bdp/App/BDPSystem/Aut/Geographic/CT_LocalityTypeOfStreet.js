document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	var ComboPage=Ext.BDP.FunLib.PageSize.Combo;
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			 
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference')   
	 
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.CTLocalityType&pClassMethod=GetTreeJson";
	var myPanel = new Ext.BDP.Component.DataAutPanel({
		        region : "center",
		        dataUrl : Tree_ACTION_URL,  
		        ObjectType : ObjectType,
				ObjectReference : ObjectReference,
		        pageSize : Ext.BDP.FunLib.PageSize.Aut, //��ҳ��С,Ĭ��Ϊ0,Ϊ0ʱ����ҳ
		        AutClass : "web.DHCBL.Authorize.CTLocalityType", //������Ȩ����������
		        getAutMethod : "GetAutJson", //��ȡ��Ȩ���ݷ���
		        saveAutMethod : "SaveAuthorizeData"  //������Ȩ���ݷ���
	 });
	
	var viewport = new Ext.Viewport({
			   	layout:'border',
		    	items:[myPanel]
	});
});

 
