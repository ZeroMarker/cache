// ����: ��λ�����������������
// ����: ���뵥λ����������ά�������Ԫ��
// ��д�ߣ���ӮӮ
// ��д����:2009-10-15
/*
var userCode = session['LOGON.USERCODE'];
	//var userCode = "u2";
	var userActive = "N";
	var userId = "";
	var userLocId = "";
	var roleId = "";
	var roleActive = "N";
	var roleLocId = "";

	GetUserRightFunc = function(userCode,Func) {
		Ext.Ajax.request({
			url: '../csp/dhccaright.csp?action=user&usercode='+userCode,
			waitMsg:'��ȴ�...',
			failure: function(result, request) {
			Ext.Msg.show({title:'ʧ��',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request, editmonth) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				var userTmp = jsonData.info;
				var tmp = userTmp.split("^");

				if(tmp[0]=="No")
				{
					Ext.Msg.show({title:'����',msg:'�����ڵ��û�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				else if(tmp[0]=="NoActive")
				{
					Ext.Msg.show({title:'����',msg:'�û���Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				else if(tmp[0]=="Active")
					{
						userActive = "Y";
						userId = tmp[1];
						userLocId = tmp[2];
						roleId = tmp[3];
					}
				else
					{
						Ext.Msg.show({title:'����',msg:'����δ֪����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
			},
			scope: this,
			callback: Func
		});
	};

	GetRoleRightFunc = function(roleId,Func) {
		Ext.Ajax.request({
		url: '../csp/dhccaright.csp?action=role&roleid='+roleId,
		waitMsg:'��ȴ�...',
		failure: function(result, request) {
			Ext.Msg.show({title:'ʧ��',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request, editmonth) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var roleTmp = jsonData.info;
			var tmp = roleTmp.split("^");

			if(tmp[0]=="No")
			{
				Ext.Msg.show({title:'����',msg:'�����ڵĽ�ɫ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
			else if(tmp[0]=="NoActive")
			{
				Ext.Msg.show({title:'����',msg:'��ɫ��Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
			else if(tmp[0]=="Active")
			{
				roleActive = "Y";
				roleLocId = tmp[1];
			}
			else
			{
				Ext.Msg.show({title:'����',msg:'����δ֪����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
		},
		scope: this,
		callback: Func
		});
	};

	OnReadyMain = function()
	{

		var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[main]                                 //���Tabs
  });

			var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
	}

	Ext.onReady(function(){
		Ext.QuickTips.init();

		GetRoleFunc = function() {
			if(roleActive=="Y")
			{
				OnReadyMain();
			}
		};

		GetRightFunc = function() {
			if(userActive=="Y")
			{
				GetRoleRightFunc(roleId,GetRoleFunc);
			}
		};

		GetUserRightFunc(userCode,GetRightFunc);
	});
*/

var userCode = session['LOGON.USERCODE'];
var userId="";
Ext.onReady(function(){
	Ext.QuickTips.init();                             
		Ext.Ajax.request({
			url: 'dhc.ca.measdevdeptsexe.csp?action=checkUser&code='+userCode,
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
						items:[main]                                 //���Tabs
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