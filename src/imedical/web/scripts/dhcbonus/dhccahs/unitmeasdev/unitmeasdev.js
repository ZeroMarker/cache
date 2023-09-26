// 名称: 单位计量表计码表界面启动
// 描述: 引入单位计量表计码表维护界面各元素
// 编写者：王赢赢
// 编写日期:2009-10-15
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
			waitMsg:'请等待...',
			failure: function(result, request) {
			Ext.Msg.show({title:'失败',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request, editmonth) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				var userTmp = jsonData.info;
				var tmp = userTmp.split("^");

				if(tmp[0]=="No")
				{
					Ext.Msg.show({title:'错误',msg:'不存在的用户!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
				else if(tmp[0]=="NoActive")
				{
					Ext.Msg.show({title:'错误',msg:'用户无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
						Ext.Msg.show({title:'错误',msg:'发生未知错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
			},
			scope: this,
			callback: Func
		});
	};

	GetRoleRightFunc = function(roleId,Func) {
		Ext.Ajax.request({
		url: '../csp/dhccaright.csp?action=role&roleid='+roleId,
		waitMsg:'请等待...',
		failure: function(result, request) {
			Ext.Msg.show({title:'失败',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request, editmonth) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var roleTmp = jsonData.info;
			var tmp = roleTmp.split("^");

			if(tmp[0]=="No")
			{
				Ext.Msg.show({title:'错误',msg:'不存在的角色!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
			else if(tmp[0]=="NoActive")
			{
				Ext.Msg.show({title:'错误',msg:'角色无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
			else if(tmp[0]=="Active")
			{
				roleActive = "Y";
				roleLocId = tmp[1];
			}
			else
			{
				Ext.Msg.show({title:'错误',msg:'发生未知错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
  	items:[main]                                 //添加Tabs
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
			waitMsg:'保存中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				userId = Ext.util.JSON.decode( result.responseText );
				if(userId==0){
					Ext.Msg.show({title:'错误',msg:'请检查登陆用户信息!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				else{
					var tabPanel = new Ext.TabPanel({
						activeTab: 0,
						region:'center',
						items:[main]                                 //添加Tabs
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