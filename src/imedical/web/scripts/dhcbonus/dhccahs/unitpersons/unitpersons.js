// ����: ��λ��Ա��������
// ����: ���뵥λ��Ա�����Ԫ��
// ��д�ߣ�����
// ��д����:2009-9-25
//--------------------------------------------------------------
var userCode = session['LOGON.USERCODE'];
var userId="";
Ext.onReady(function(){
	Ext.QuickTips.init();                             
		Ext.Ajax.request({
			url: encodeURI('dhc.ca.unitpersonsexe.csp?action=checkUser&code='+userCode),
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				userId = Ext.util.JSON.decode( result.responseText );
				if(userId==0){
					Ext.Msg.show({title:'����',msg:'�����½�û���Ϣ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				else{
					var tabPanel = new Ext.TabPanel({
						activeTab: 0,
						region:'center',
						items:[UnitPersonsMain]                                 //���Tabs
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