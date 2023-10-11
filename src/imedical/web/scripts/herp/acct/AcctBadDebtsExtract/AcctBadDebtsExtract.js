Ext.onReady(function () {
	Ext.QuickTips.init();

	/**********�жϻ�����ȡ��ʽ**********/
	var userid = session['LOGON.USERID'];
	var AcctBookID = IsExistAcctBook();
	var ExtBadDebtsBalMetUrl = '../csp/herp.acct.acctbaddebtsextractexe.csp';

	Ext.Ajax.request({
		url : ExtBadDebtsBalMetUrl + '?action=GetBadDebtsRet&UserID=' + userid,
		method : 'GET',
		success : function (result, request) {
			var respText = Ext.util.JSON.decode(result.responseText);
			var retrieval = respText.info;
			// alert(retrieval);
			// retrieval=1
			if (retrieval == 1) {

			var upanel = new Ext.Panel({
				        iconCls:'dataabstract',
						title : '������ȡ-��',
						region : 'center',
						layout : 'auto',
						items : [yePanel,pzGrid]
					});

				var uviewport = new Ext.Viewport({
						layout : 'border',
						items : upanel,
						renderTo : 'uviewport'
					});
					
			} else if (retrieval == 2) {

				var upanel = new Ext.Panel({
					   iconCls:'dataabstract',
						title : '������ȡ-���䷨',
						region : 'center',
						layout : 'auto',
						items : [zlPanel,zlGrid,pzGrid]
					});

				var uviewport = new Ext.Viewport({
						layout : 'border',
						items : upanel,
						renderTo : 'uviewport'
					});
					
			} else {
				Ext.Msg.show({
					title : '����',
					msg : '���黵����ȡ��ʽ�����Ƿ���ȷ�� ',
					icon : Ext.MessageBox.ERROR,
					buttons : Ext.Msg.OK

				});
				return;

			}
		}

	});
});