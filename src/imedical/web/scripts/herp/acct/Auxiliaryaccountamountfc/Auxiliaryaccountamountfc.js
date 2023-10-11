/// 描述：辅助核算账-辅助账总账--外币式
/// 编写者：王珊
/// 编写日期：

var userdr = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var bookID = IsExistAcctBook();
Ext.onReady(function () {
	Ext.QuickTips.init();

	var buttQuery = new Ext.Button({
			text: "查询",
			iconCls: 'find',
			width: 70,
			handler: function () {
				Query();
			}

		});
	formPanel = new Ext.form.FormPanel({
			id: 'formPanel',
			frame: true,
			//autoScroll : true,
			//layout : 'fit',
			items: [buttQuery]
		});
	var reportPanel = new Ext.Panel({
			autoScroll: true,
			layout: 'fit',
			//autoScroll:false,
			html: '<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'

		});

	//============================查看=========================================//
	var viewPanel = new Ext.Viewport({
			layout: 'border',
			renderTo: 'mainPanel',
			items: [{
					region: 'north',
					//title:'辅助账总账-外币式',
					height: 45,
					// split:true,
					// collapsible:true,
					layout: 'fit',
					items: formPanel
				}, {
					region: 'center',
					layout: 'fit',
					items: reportPanel
				}
			]

		});
});
