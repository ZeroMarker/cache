/*-------˵��-------------
���ߣ�������
���ڣ�2016-1-7
���ܣ������ƺ���δ��¼����
-------------------------*/
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var userID = session['LOGON.USERID'];
//�жϵ�ǰ�����Ƿ����
//�˺��������ɲ������ʱ��ҳ���Ϸ���ʾ��ǰ���ף��������grid��title�ͻ��Ϊԭtitle���ϵ�ǰ����
function IsExistAcctBook(Grid) {
	//��û�ƺ�������  zhaoliguo 2016-1-7
	// var frm = dhcsys_getmenuform(); //�÷�����websys.js��
	var frm = dhcsys_getsidemenuform(); //���ò�˵�
	var currBookID = frm.AcctBookID.value;
	if (currBookID == "") {
		InitAcctBook();

	} else {
		if (typeof(arguments[0]) != "undefined") {
			var titles = arguments[0].title + "--����ǰ��¼������Ϊ--" + frm.AcctBookName.value;
			arguments[0].setTitle(titles);

		} else {
			setTimeout("showmsg()", 1500);
		}

	}
	return currBookID;
}

function showmsg() {
	var frm = dhcsys_getsidemenuform(); //���ò�˵�
	var CurrBookName = frm.AcctBookName.value;
	//MsgTip.style="position:absolute;right:0;top:0;"
	//alert( MsgTip.style);
	MsgTip.msg('����ǰ��¼������Ϊ:  ', CurrBookName, true, 8);

}

//��õ�ǰ����ID,����¼ʱ��������¼����
function GetAcctBookID() {

	var frm = dhcsys_getmenuform(); //�÷�����websys.js��
	return frm.AcctBookID.value;
}
//��ʼ��ʱ��ӻ�ƺ�������
function InitAcctBook() {
	setTimeout("AddAcctBook()", 1000);
}

//��ӻ�ƺ�������
function AddAcctBook() {

	var cField = new Ext.form.TextField({
			id : 'cField',
			fieldLabel : '�û�����',
			allowBlank : false,
			width : 180,
			listWidth : 180,
			readOnly : true,
			//valueNotFoundText:userName,
			//emptyText:userName,
			anchor : '90%',
			selectOnFocus : 'false',

			listeners : {
				specialKey : function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (cField.getValue() != "") {
							nField.focus();
						} else {
							Handler = function () {
								cField.focus();
							}

							Ext.Msg.show({
								title : '����',
								msg : '�û�����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR,
								fn : Handler
							});

						}
					}
				}
			}
		});

	var nField = new Ext.form.TextField({
			id : 'nField',
			fieldLabel : '��������',
			allowBlank : false,
			width : 180,
			listWidth : 180,
			emptyText : '',
			anchor : '90%',
			selectOnFocus : 'true',
			listeners : {
				specialKey : function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addButton.focus();
					}
				}
			}
		});

	// ----------��������------------------------------

	var acctbookDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : 'results',
				root : 'rows'
			}, ['rowid', 'name'])
		});

	acctbookDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/herp.acct.acctbookidexe.csp?action=getAcctBook&start=0&limit=25',
				method : 'POST'
			})
	});

	var acctbookField = new Ext.form.ComboBox({
			id : 'acctbookField',
			fieldLabel : '�������',
			width : 230,
			listWidth : 230,
			allowBlank : false,
			store : acctbookDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'acctbookField',
			minChars : 1,
			pageSize : 10,
			anchor : '90%',
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true,
			listeners : {
				specialKey : function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addButton.focus();
					}
				}
			}
		});

	//��ʼ�����
	formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 70,
			labelAlign : 'right',
			items : [
				cField,
				acctbookField
			]
		});

	//������ zlg1

	formPanel.on('afterlayout', function (panel, layout) {
		Ext.Ajax.request({
			url : '../csp/herp.acct.acctbookidexe.csp?action=getBookID&userID=' + userID,
			waitMsg : '������...',
			success : function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var CurBookInfo = jsonData.info;
					var CurBookID = CurBookInfo.split("^")[0];
					var CurBookCode = CurBookInfo.split("^")[1];
					var CurBookName = CurBookInfo.split("^")[2];

					cField.setValue(userCode);
					acctbookField.setValue(CurBookID);
					acctbookField.setRawValue(CurBookName);

				}
			},
			scope : this
		});
		// cField.setValue(userCode);
		//n1Field.setValue(rowObj[0].get("name"));
	});

	//��ʼ����Ӱ�ť
	addButton = new Ext.Toolbar.Button({
			text : 'ȷ ��',
			iconCls:'submit'
		});

	//������Ӱ�ť��Ӧ����
	addHandler = function () {

		var code = cField.getValue();
		var bookid = acctbookField.getValue();
		var bookName = acctbookField.getRawValue();

		if (code == "") {
			Ext.Msg.show({
				title : '����',
				msg : '�û�����Ϊ��',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});

			return;
		};
		if (bookid == "") {
			Ext.Msg.show({
				title : '����',
				msg : '���ײ���Ϊ��',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});

			return;
		};

		//��ӻ�ƺ�������ȫ�ֱ��� zhaoliguo 2016-1-7
		//var frm = dhcsys_getmenuform();
		//frm.AcctBookID=bookid
		var frm = dhcsys_getsidemenuform();
		frm.AcctBookID.value = bookid;
		frm.AcctBookName.value = bookName;
		//encodeURI zlg4
		Ext.Ajax.request({
			url : '../csp/herp.acct.acctbookidexe.csp?action=add&useid=' + code + '&bookid=' + bookid,
			waitMsg : '������...',
			failure : function (result, request) {
				Handler = function () {
					nField.focus();
				}

				Ext.Msg.show({
					title : '����',
					msg : '������������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR,
					fn : Handler
				});

			},
			success : function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Handler = function () {
						nField.focus();
					}

					Ext.Msg.show({
						title : 'ע��',
						msg : '��¼�ɹ�!',
						icon : Ext.MessageBox.INFO,
						buttons : Ext.Msg.OK,
						fn : Handler
					});

					//TargetTypeTabDs.load({params:{start:0, limit:TargetTypeTabPagingToolbar.pageSize}});
					addwin.close();
					location.reload(true);

				} else {
					var message = "";
					if (jsonData.info == 'RepCode')
						message = '����ı����Ѿ�����!';

					if (jsonData.info == 'RepName')
						message = '����������Ѿ�����!';

					Ext.Msg.show({
						title : '����',
						msg : message,
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});

				}
			},
			scope : this
		});

	}

	//��ӱ��水ť�ļ����¼�
	addButton.addListener('click', addHandler, false);

	//��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
			text : 'ȡ��'
		});

	//����ȡ����ť����Ӧ����
	cancelHandler = function () {
		addwin.close();
	}

	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);

	//��ʼ������
	addwin = new Ext.Window({
			title : '����ѡ��',
			width : 320,
			height : 180,
			minWidth : 320,
			minHeight : 180,
			closable : false, //�����Ͻ���ʾС���Ĺرհ�ť��Ĭ��Ϊtrue
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:20px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [
				addButton
			]
		});

	//������ʾ
	addwin.show();
	//var frm = dhcsys_getsidemenuform(); //���ò�˵�
	//return frm.AcctBookID;

}

//��ӻ�ƺ�������
function GetAcctBookInfo() {

	//var rowObj = scheme1Main.getSelections();
	var total = 0;
	var rowid = 0;
	//alert(33)
	var rtndata = "";
	Ext.Ajax.request({
		url : '../csp/herp.acct.acctbookidexe.csp?action=getBookID',
		// method: "GET",
		async : false, //ASYNC �Ƿ��첽( TRUE �첽 , FALSE ͬ��)
		failure : function (result, request) {
			Ext.Msg.show({
				title : '����',
				msg : '������������!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});
		},
		success : function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			//alert(jsonData.success );
			if (jsonData.success == 'true') {
				/*
				Ext.Msg.show({
				title : '��ʾ',
				msg : '��֤�ɹ�!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
				});
				 */

				alert("dddd=" + jsonData.info)
				rtndata = jsonData.info;

			} else {
				Ext.Msg.show({
					title : '����',
					msg : jsonData.info,
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			}
		},
		scope : this
	});

	return "last=" + rtndata;

}

MsgTip = function () {
	var msgCt;
	function createBox(t, s) {
		return ['<div class="msg">',
			'<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
			'<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc" style="font-size=12px;"><h3 style="background-color:transparent;">', t, s, '</h3></div></div></div>',
			'<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
			'</div>'].join('');
	}
	return {
		msg : function (title, message, autoHide, pauseTime) {
			if (!msgCt) {
				msgCt = Ext.DomHelper.insertFirst(document.body, {
						id : 'msg-div22',
						style : 'position:absolute;top:10px;width:300px;margin:0 0 0 430px;z-index:20000'
					}, true);

			}
			//position:absolute;top:10px;width:300px;margin:0 0 0 430px;z-index:20000
			msgCt.alignTo(document, 't-t');
			//����Ϣ�����½�����һ���رհ�ť
			message += '<br><div style="text-align:right;font-size:12px;width:100%;">' +
			'<font color="blank"><u style="cursor:hand;" onclick="MsgTip.hide(this);">�ر�</u></font></div>'

			var m = Ext.DomHelper.append(msgCt, {
					html : createBox(title, message)
				}, true);

			m.slideIn('t');
			if (!Ext.isEmpty(autoHide) && autoHide == true) {
				if (Ext.isEmpty(pauseTime)) {
					pauseTime = 8000;
				}

				m.pause(pauseTime).ghost("tr", {
					remove : true
				});
			}
		},
		hide : function (v) {
			//edit 20161101
			/* var msg = Ext.get(v.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement);
			msg.ghost("tr", {
				remove : true
			}); */
			msgCt.ghost("tr", {
				remove : true
			});

		}
	};
}();

/* Ext.AutoHide = function () {
	var msgCt;
	function createBox(t, s) {
		return ['<div class="msg">',
			'<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
			'<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc" style="font-size=12px;"><h3>', t, '</h3>', s, '</div></div></div>',
			'<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
			'</div>'].join('');
	}
	return {
		msg : function (title, format) {
			if (!msgCt) {
				msgCt = Ext.DomHelper.insertFirst(document.body, {
						id : 'msg-div22',
						style : 'position:absolute;top:10px;width:300px;margin:0 0 0 430px;z-index:20000;'
					}, true);

			}
			msgCt.alignTo(document, 't-t');
			var s = String.format.apply(String, Array.prototype.slice.call(arguments, 1));
			var m = Ext.DomHelper.append(msgCt, {
					html : createBox(title, s)
				}, true);

			m.slideIn('t').pause(1).ghost("t", {
				remove : true
			});
		},

		hide : function (v) {
			var msg = Ext.get(v.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement);

			msg.ghost("tr", {
				remove : true
			});
		}
	};
}
(); */