
var userCode = session['LOGON.USERCODE'];
var userDr="";
Ext.onReady(function(){
	Ext.Ajax.timeout=1000000000;
	Ext.QuickTips.init();                             
		Ext.Ajax.request({
			url: encodeURI('dhc.ca.unitpersonsexe.csp?action=checkUser&code='+userCode),
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				userDr = Ext.util.JSON.decode( result.responseText );
				if(userDr==0){
					Ext.Msg.show({title:'����',msg:'�����½�û���Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				else{
					var vouchDatasPanel = new Ext.TabPanel({
						activeTab: 0,
						//region:'center',
						items:[paramDatasMain]                                 //���Tabs
					});
					var tabPanel = new Ext.Panel({
						layout : 'fit',
						collapsible: false,
						plain: true,
						region:'center',
						items : vouchDatasPanel                 //���Tab���
					});
					var mainPanel = new Ext.Viewport({
						layout: 'border',
						items : tabPanel,
						renderTo: 'mainPanel'
					});
				}
			},
			scope: this
		});
});