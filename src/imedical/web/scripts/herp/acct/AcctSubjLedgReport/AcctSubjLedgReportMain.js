//// �˲���ѯ-��Ŀ����-���ʽ


var bookID = IsExistAcctBook();
var userdr = session['LOGON.USERID']; //��¼��ID

var buttQuery = new Ext.Button({
		text: "��ѯ",
		width: 70,
		iconCls: 'find',
		handler: function () {
			Query();
		}

	});
var formPanel = new Ext.form.FormPanel({
		id: 'formPanel',
		frame: true,
		//autoScroll : true,
		//layout : 'fit',
		items: [buttQuery]
	});
var reportPanel = new Ext.Panel({
		autoScroll: true,
		layout: 'fit',
		html: '<iframe id="frameReport" height="100%" width="100%" frameborder="0" scrolling="auto" src="../scripts/herp/acct/images/logon_bg.jpg" />'

	});
