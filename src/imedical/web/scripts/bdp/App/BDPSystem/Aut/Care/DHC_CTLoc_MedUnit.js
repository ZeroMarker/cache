//// Function: ҽ�Ƶ�Ԫ������Ȩ��Ȩҳ��
///	 Creator:  sunfengchao
///	 CreateDate: 2016-1-5
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/DataAutPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	var ComboPage=Ext.BDP.FunLib.PageSize.Combo;
	var ObjectType=Ext.BDP.FunLib.getParam('ObjectType')			 
	var ObjectReference=Ext.BDP.FunLib.getParam('ObjectReference') 
	var AutCode=Ext.BDP.FunLib.getParam('AutCode')    //��ȡ��Ȩҳ����  
	var Tree_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.Authorize.DHCCTLocMedUnit&pClassMethod=GetTreeJson";
	var myPanel = new Ext.BDP.Component.DataAutPanel({
	        region : "center",
	        dataUrl : Tree_ACTION_URL,  
	        ObjectType : ObjectType,
			ObjectReference : ObjectReference,
			AutCode :  AutCode,
	        pageSize : Ext.BDP.FunLib.PageSize.Aut, //��ҳ��С,Ĭ��Ϊ0,Ϊ0ʱ����ҳ
	        AutClass : "web.DHCBL.Authorize.DHCCTLocMedUnit", //������Ȩ����������
	        getAutMethod : "GetAutJson", //��ȡ��Ȩ���ݷ���
	        saveAutMethod : "SaveAuthorizeData"  //������Ȩ���ݷ���
	 });
	var viewport = new Ext.Viewport({
			layout:'border',
		    items:[myPanel]
	});
});

 
