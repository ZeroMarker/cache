/*-------说明-------------
作者：赵立国
日期：2016-1-7
功能：处理会计核算未登录问题
-------------------------*/
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var userID = session['LOGON.USERID'];
//判断当前帐套是否存在
//此函数参数可不填，不填时在页面上方显示当前账套，如果填了grid的title就会变为原title加上当前账套
function IsExistAcctBook(Grid) {
	//获得会计核算帐套  zhaoliguo 2016-1-7
	// var frm = dhcsys_getmenuform(); //该方法在websys.js中
	var frm = dhcsys_getsidemenuform(); //调用侧菜单
	var currBookID = frm.AcctBookID.value;
	if (currBookID == "") {
		InitAcctBook();

	} else {
		if (typeof(arguments[0]) != "undefined") {
			var titles = arguments[0].title + "--您当前登录的账套为--" + frm.AcctBookName.value;
			arguments[0].setTitle(titles);

		} else {
			setTimeout("showmsg()", 1500);
		}

	}
	return currBookID;
}

function showmsg() {
	var frm = dhcsys_getsidemenuform(); //调用侧菜单
	var CurrBookName = frm.AcctBookName.value;
	//MsgTip.style="position:absolute;right:0;top:0;"
	//alert( MsgTip.style);
	MsgTip.msg('您当前登录的账套为:  ', CurrBookName, true, 8);

}

//获得当前帐套ID,当登录时，弹出登录界面
function GetAcctBookID() {

	var frm = dhcsys_getmenuform(); //该方法在websys.js中
	return frm.AcctBookID.value;
}
//初始化时添加会计核算账套
function InitAcctBook() {
	setTimeout("AddAcctBook()", 1000);
}

//添加会计核算帐套
function AddAcctBook() {

	var cField = new Ext.form.TextField({
			id : 'cField',
			fieldLabel : '用户名称',
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
								title : '错误',
								msg : '用户不能为空!',
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
			fieldLabel : '帐套名称',
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

	// ----------帐套名称------------------------------

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
			fieldLabel : '会计帐套',
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

	//初始化面板
	formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 70,
			labelAlign : 'right',
			items : [
				cField,
				acctbookField
			]
		});

	//面板加载 zlg1

	formPanel.on('afterlayout', function (panel, layout) {
		Ext.Ajax.request({
			url : '../csp/herp.acct.acctbookidexe.csp?action=getBookID&userID=' + userID,
			waitMsg : '更新中...',
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

	//初始化添加按钮
	addButton = new Ext.Toolbar.Button({
			text : '确 认',
			iconCls:'submit'
		});

	//定义添加按钮响应函数
	addHandler = function () {

		var code = cField.getValue();
		var bookid = acctbookField.getValue();
		var bookName = acctbookField.getRawValue();

		if (code == "") {
			Ext.Msg.show({
				title : '错误',
				msg : '用户不能为空',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});

			return;
		};
		if (bookid == "") {
			Ext.Msg.show({
				title : '错误',
				msg : '帐套不能为空',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
			});

			return;
		};

		//添加会计核算帐套全局变量 zhaoliguo 2016-1-7
		//var frm = dhcsys_getmenuform();
		//frm.AcctBookID=bookid
		var frm = dhcsys_getsidemenuform();
		frm.AcctBookID.value = bookid;
		frm.AcctBookName.value = bookName;
		//encodeURI zlg4
		Ext.Ajax.request({
			url : '../csp/herp.acct.acctbookidexe.csp?action=add&useid=' + code + '&bookid=' + bookid,
			waitMsg : '保存中...',
			failure : function (result, request) {
				Handler = function () {
					nField.focus();
				}

				Ext.Msg.show({
					title : '错误',
					msg : '请检查网络连接!',
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
						title : '注意',
						msg : '登录成功!',
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
						message = '输入的编码已经存在!';

					if (jsonData.info == 'RepName')
						message = '输入的名称已经存在!';

					Ext.Msg.show({
						title : '错误',
						msg : message,
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});

				}
			},
			scope : this
		});

	}

	//添加保存按钮的监听事件
	addButton.addListener('click', addHandler, false);

	//初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
			text : '取消'
		});

	//定义取消按钮的响应函数
	cancelHandler = function () {
		addwin.close();
	}

	//添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);

	//初始化窗口
	addwin = new Ext.Window({
			title : '账套选择',
			width : 320,
			height : 180,
			minWidth : 320,
			minHeight : 180,
			closable : false, //在右上角显示小叉叉的关闭按钮，默认为true
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

	//窗口显示
	addwin.show();
	//var frm = dhcsys_getsidemenuform(); //调用侧菜单
	//return frm.AcctBookID;

}

//添加会计核算帐套
function GetAcctBookInfo() {

	//var rowObj = scheme1Main.getSelections();
	var total = 0;
	var rowid = 0;
	//alert(33)
	var rtndata = "";
	Ext.Ajax.request({
		url : '../csp/herp.acct.acctbookidexe.csp?action=getBookID',
		// method: "GET",
		async : false, //ASYNC 是否异步( TRUE 异步 , FALSE 同步)
		failure : function (result, request) {
			Ext.Msg.show({
				title : '错误',
				msg : '请检查网络连接!',
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
				title : '提示',
				msg : '验证成功!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
				});
				 */

				alert("dddd=" + jsonData.info)
				rtndata = jsonData.info;

			} else {
				Ext.Msg.show({
					title : '错误',
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
			//给消息框右下角增加一个关闭按钮
			message += '<br><div style="text-align:right;font-size:12px;width:100%;">' +
			'<font color="blank"><u style="cursor:hand;" onclick="MsgTip.hide(this);">关闭</u></font></div>'

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