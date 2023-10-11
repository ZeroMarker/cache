cancleauditFun = function (vercode, userdr) {

	var userdr = session['LOGON.USERID'];
	var projUrl = '../csp/herp.acct.acctbatchauditexe.csp'

		var ResultField = new Ext.form.TextField({
			id : 'ResultField',
			width : 500,
			anchor : '100%',
			fieldLabel : '��˽��',
			//allowBlank :true,
			//editable:true,
			disabled : true,
			//readOnly:true,
			selectOnFocus : 'true',
			emptyText : '��ͨ��'
		});

	//////////////// ���ı��� ////////////////////
	var textArea = new Ext.form.TextArea({
			id : 'textArea',
			width : 500,
			anchor : '100%',
			fieldLabel : '������',
			//allowBlank :false,
			selectOnFocus : 'true',
			emptyText : '����д����������(��ͨ�������ֲ�����8��)'
		});

	/////////////// ����˵�����ı��� /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
			title : '������',
			height : 110,
			labelSeparator : '��',
			items : textArea
		});
	var checkFieldSet = new Ext.form.FieldSet({
			title : '��˽��',
			height : 60,
			labelSeparator : '��',
			items : ResultField
		});

	var colItems = [{
			layout : 'column',
			border : false,
			defaults : {
				columnWidth : '1.0',
				bodyStyle : 'padding:5px 5px 0',
				border : false
			},
			items : [{
					xtype : 'fieldset',
					autoHeight : true,
					items : [
						checkFieldSet,
						viewFieldSet
					]
				}
			]
		}
	]

	var formPanel = new Ext.form.FormPanel({
			labelWidth : 80,
			frame : true,
			items : colItems
		});

	addButton = new Ext.Toolbar.Button({
			text : 'ȷ��'
		});

	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function () {

		var ChkResult = encodeURIComponent('��ͨ��');
		var view = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		var statusid = 0;
		var vercode = ""
			var vouchid = ""
			var vouchidDs = ""
			if (formPanel.form.isValid()) {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				for (var j = 0; j < len; j++) {
					if (rowObj[j].get("Auditor1") == userdr && rowObj[j].get("VouchState1") == "21") {
						vercode = rowObj[j].get("VouchNo")
							vouchid = rowObj[j].get("AcctVouchID")
					}
					if (vouchidDs.indexOf(vouchid) == -1) {
						vouchidDs += vouchid + ","
						Ext.Ajax.request({
							url : projUrl + '?action=veraudit' + '&userdr=' + userdr + '&vouchid=' + vouchid + '&vercode=' + vercode + '&ChkResult1=' + ChkResult + '&view1=' + view + '&statusid=' + statusid + '&state=' + '0' + '&bookID=' + bookID,
							waitMsg : '������...',
							failure : function (result, request) {
								Ext.Msg.show({
									title : '����',
									msg : '������������! ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
							},
							success : function (result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if ((jsonData.success == 'true')) {
									Ext.Msg.show({
										title : 'ע��',
										msg : '��������! ',
										icon : Ext.MessageBox.INFO,
										buttons : Ext.Msg.OK
									});
									//itemGrid.store.load({params:{start:0, limit:25,userdr:userdr}});
									var tbarnum = itemGrid.getBottomToolbar();
									tbarnum.doLoad(tbarnum.cursor);
								} else if (jsonData.info == 'RepName') {
									Ext.Msg.show({
										title : '����',
										msg : '�ϼ��Ѿ����,��ǰ����ȡ��! ',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
								}
							},
							scope : this
						});
					}
				}
			} else {
				Ext.Msg.show({
					title : '����',
					msg : '������ҳ���ϵĴ���! ',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			}

			addwin.close();
	}

	////// ��Ӽ����¼� ////////////////
	addButton.addListener('click', addHandler, false);

	cancelButton = new Ext.Toolbar.Button({
			text : 'ȡ��'
		});

	cancelHandler = function () {
		addwin.close();
	}

	cancelButton.addListener('click', cancelHandler, false);

	addwin = new Ext.Window({
			title : '��˽��+������',
			width : 500,
			height : 300,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [
				addButton,
				cancelButton
			]
		});
	addwin.show();

}

auditFun = function (vercode, userdr) {

	var userdr = session['LOGON.USERID'];
	var projUrl = 'herp.acct.acctbatchauditexe.csp'

		var CheckResultField = new Ext.form.ComboBox({
			fieldLabel : '��˽��',
			width : 500,
			anchor : '100%',
			store : new Ext.data.ArrayStore({
				fields : ['rowid', 'name'],
				data : [['1', 'ͨ��'], ['0', '��ͨ��']]
			}),
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			mode : 'local',
			value : 1,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : 'ѡ��...',
			selectOnFocus : 'true'
			//disabled:true
		});

	//////////////// ���ı��� ////////////////////
	var textArea = new Ext.form.TextArea({
			id : 'textArea',
			width : 500,
			anchor : '100%',
			fieldLabel : '������',
			//allowBlank :false,
			selectOnFocus : 'true',
			emptyText : '����д����������(ͨ�������ֲ�����8��)'
		});

	/////////////// ����˵�����ı��� /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
			title : '������',
			height : 110,
			labelSeparator : '��',
			items : textArea
		});
	var checkFieldSet = new Ext.form.FieldSet({
			title : '��˽��',
			height : 70,
			labelSeparator : '��',
			items : CheckResultField
		});

	var colItems = [{
			layout : 'column',
			border : false,
			defaults : {
				columnWidth : '1.0',
				bodyStyle : 'padding:5px 5px 0',
				border : false
			},
			items : [{
					xtype : 'fieldset',
					autoHeight : true,
					items : [
						checkFieldSet,
						viewFieldSet
					]
				}
			]
		}
	]

	var formPanel = new Ext.form.FormPanel({
			labelWidth : 80,
			frame : true,
			items : colItems
		});

	addButton = new Ext.Toolbar.Button({
			text : 'ȷ��'
		});

	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function () {

		var ChkResult = encodeURIComponent(CheckResultField.getRawValue());
		var view = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		var statusid = CheckResultField.getValue();

		if (ChkResult == "") {
			Ext.Msg.show({
				title : '����',
				msg : '��˽������Ϊ�� ',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
			return;
		};
		var vercode = ""
			var vouchid = ""
			var vouchidDs = ""
			if (formPanel.form.isValid()) {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				for (var j = 0; j < len; j++) {
					if (rowObj[j].get("VouchState1") != "0" && rowObj[j].get("VouchState1") != "31" && rowObj[j].get("Operator1") != userdr && rowObj[j].get("VouchState1") != "5" && rowObj[j].get("VouchState1") != "21" && rowObj[j].get("VouchState1") != "41") {
						vercode = rowObj[j].get("VouchNo")
							vouchid = rowObj[j].get("AcctVouchID")
					}
					if (vouchidDs.indexOf(vouchid) == -1) {
						vouchidDs += vouchid + ","
						Ext.Ajax.request({
							url : projUrl + '?action=veraudit' + '&userdr=' + userdr + '&vouchid=' + vouchid + '&vercode=' + vercode + '&ChkResult1=' + ChkResult + '&view1=' + view + '&statusid=' + statusid + '&state=' + '1' + '&bookID=' + bookID,
							waitMsg : '������...',
							failure : function (result, request) {
								Ext.Msg.show({
									title : '����',
									msg : '������������! ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
							},
							success : function (result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if ((jsonData.success == 'true')) {
									Ext.Msg.show({
										title : 'ע��',
										msg : '������! ',
										icon : Ext.MessageBox.INFO,
										buttons : Ext.Msg.OK
									});
									//itemGrid.store.load({params:{start:0, limit:25,userdr:userdr}});
									var tbarnum = itemGrid.getBottomToolbar();
									tbarnum.doLoad(tbarnum.cursor);
								} else if (jsonData.info == 'RepName') {
									Ext.Msg.show({
										title : '����',
										msg : '�ϼ��Ѿ����,��ǰ����ȡ��! ',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
								}
							},
							scope : this
						});
					}
				}
			} else {
				Ext.Msg.show({
					title : '����',
					msg : '������ҳ���ϵĴ���! ',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			}
			addwin.close();
	}

	////// ��Ӽ����¼� ////////////////
	addButton.addListener('click', addHandler, false);
	cancelButton = new Ext.Toolbar.Button({
			text : 'ȡ��'
		});
	cancelHandler = function () {
		addwin.close();
	}
	cancelButton.addListener('click', cancelHandler, false);
	addwin = new Ext.Window({
			title : '��˽��+������',
			width : 500,
			height : 300,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [
				addButton,
				cancelButton
			]
		});
	addwin.show();
}