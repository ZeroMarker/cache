// 名称: 单位人员界面启动
// 描述: 引入单位人员界面各元素
// 编写者：杨旭
// 编写日期:2009-9-25
//--------------------------------------------------------------
var userCode = session['LOGON.USERCODE'];
var userId="";
Ext.onReady(function(){
	Ext.QuickTips.init();                             
		Ext.Ajax.request({
			url: encodeURI('dhc.ca.unitpersonsexe.csp?action=checkUser&code='+userCode),
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
						items:[UnitPersonsMain]                                 //添加Tabs
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