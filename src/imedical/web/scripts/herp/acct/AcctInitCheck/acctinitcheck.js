// 会计辅助账初始化
var userdr = session['LOGON.USERID']; //登录人ID
var projUrl = 'herp.acct.acctinitcheckexe.csp'; //cspUrl
var acctbookid = IsExistAcctBook();//获得账套

//获得当前系统登录用户的信息说明
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];

// 显示会计辅助核算类别
var CheckTypeNameDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'name', 'sname'])
	});
CheckTypeNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetAcctCheckType&str=' + encodeURIComponent(Ext.getCmp('CheckTypeName').getRawValue()),
			method: 'POST'
		});
});
var CheckTypeName = new Ext.form.ComboBox({
		id: 'CheckTypeName',
		fieldLabel: '会计辅助核算类型',
		width: 220,
		listWidth: 255,
		store: CheckTypeNameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择核算类型...',
		minChars: 1,
		pageSize: 10,
		// columnWidth: .1,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		listeners: {
			//查询联动 *辅助核算类别 与 会计科目*
			select: function (combo, record, index) {
				SubjNameDs.removeAll();
				SubjName.setValue('');
				SubjNameDs.proxy = new Ext.data.HttpProxy({
						url: projUrl + '?action=GetSubjName&str=' + encodeURIComponent(Ext.getCmp('SubjName').getRawValue()) + '&CheckTypeID=' + combo.value + '&acctbookid=' + acctbookid,
						method: 'POST'
					})
					SubjNameDs.load({
						params: {
							start: 0,
							limit: 10
						}
					});
			}
		}
	});

//显示会计科目
var SubjNameDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		},
			['SubjCode', 'SubjNameAll', 'SubjCodeNameAll'])
	});

SubjNameDs.on('beforeload', function (ds, o) {
	var CheckTypeID = CheckTypeName.getValue(); //联动判断辅助类型不能为空
	if (!CheckTypeID) {
		Ext.Msg.show({
			title: '注意',
			msg: ' 请先选择辅助核算类别 ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}

});

var SubjName = new Ext.form.ComboBox({
		id: 'SubjName',
		fieldLabel: '会计科目',
		width: 260,
		listWidth: 280,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'SubjCode',
		displayField: 'SubjCodeNameAll',
		triggerAction: 'all',
		emptyText: '请选择会计科目',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	});

//获取币种名称
var CurrNameFieldDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});

CurrNameFieldDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetCurrName&str=' + encodeURIComponent(Ext.getCmp('CurrNameField').getRawValue()),
			method: 'POST'
		});
});

var CurrNameField = new Ext.form.ComboBox({
		id: 'CurrNameField',
		fieldLabel: '币种名称',
		width: 150,
		listWidth: 220,
		allowBlank: true,
		store: CurrNameFieldDs,
		valueField: 'code',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择币种类型',
		name: 'CurrNameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//查询按钮响应函数
var QueryButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		width: 60,
		handler: function () {
			var CheckTypeID = CheckTypeName.getValue(); //获取辅助核算类型
			if (CheckTypeID != "") {
				//动态标题栏的显示(由ID获得CheckSName简称)
				Ext.Ajax.request({
					url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetCheckSName&CheckTypeID=' + CheckTypeID,
					waitMsg: '保存中...',
					failure: function (result, request) {
						Ext.Msg.show({
							title: '错误',
							msg: '请检查网络连接!',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							var bcodes = jsonData.info;
							var CheckSName = bcodes;
							//itemGrid.getColumnModel().setColumnHeader(3,CheckSName+"编码"); //动态标题栏 简称+编码
							// itemGrid.getColumnModel().setColumnHeader(4,CheckSName+"名称");    //简称+名称
							itemGrid.getColumnModel().setColumnHeader(3, '<div style="text-align:center">' + CheckSName + '编码</div>');
							itemGrid.getColumnModel().setColumnHeader(4, '<div style="text-align:center">' + CheckSName + '名称</div>');
						} else {
							var message = "";
							Ext.Msg.show({
								title: '错误',
								msg: message,
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						}
					},
					scope: this
				});
				//查询条件为空,全部显示
			} else if (CheckTypeID == "") {
				itemGrid.getColumnModel().setColumnHeader(3, '<div style="text-align:center">编码</div>');
				itemGrid.getColumnModel().setColumnHeader(4, '<div style="text-align:center">名称</div>');
			};

			//根据科目取IsFc、IsNum 判断是否显示列
			var SubjCode = SubjName.getValue();
			if (SubjCode != "") {
				Ext.Ajax.request({
					url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetNumOrFc&SubjCode=' + SubjCode + '&acctbookid=' + acctbookid,
					waitMsg: '保存中...',
					failure: function (result, request) {
						Ext.Msg.show({
							title: '错误',
							msg: '请检查网络连接!',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							var bcodes = jsonData.info;
							var arr = bcodes.split("^");
							var IsNum = arr[0];
							//数量账
							if (IsNum == 1) {
								itemGrid.getColumnModel().setHidden(9, false);
								itemGrid.getColumnModel().setHidden(13, false);
								itemGrid.getColumnModel().setHidden(14, false);
								itemGrid.getColumnModel().setHidden(18, false);
							}
							var IsFc = arr[1];
							//非外币隐藏
							if (IsFc == 1) {
								itemGrid.getColumnModel().setHidden(10, false);
								itemGrid.getColumnModel().setHidden(15, false);
								itemGrid.getColumnModel().setHidden(16, false);
								itemGrid.getColumnModel().setHidden(19, false);
							} 
						} else {
							var message = "";
							Ext.Msg.show({
								title: '错误',
								msg: message,
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						}
					},
					scope: this
				});

			};
			itemGrid.load({
				params: {
					sortField: '',
					sortDir: '',
					start: 0,
					limit: 25,
					SubjCode: SubjCode,
					CheckTypeID: CheckTypeID,
					userdr: userdr,
					acctbookid: acctbookid
				}
			});
		}
	});

//增加按钮
var AddButton = new Ext.Toolbar.Button({
		text: '增加',
		iconCls: 'add',
		width: 55,
		handler: function () {
			addfun();
		}
	});
//单行修改
var UpdateButton = new Ext.Toolbar.Button({
		text: '修改',
		width: 55,
		iconCls: 'edit',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections(); //拾取选取行
			var len = rowObj.length;
			if (len < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: '  请选择需要修改的数据！  ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			} else if (len > 1) {
				Ext.Msg.show({
					title: '注意',
					msg: '  请逐一选择记录进行修改！  ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			} else if (len == 1) {
				for (var i = 0; i < len; i++) {
					var state = rowObj[i].get("IsFinishInit");
					if (state != "1") {
						editfun();
					} else {
						Ext.Msg.show({
							title: '警告',
							msg: '  数据已完成初始化，不可修改！ ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.WARNING
						});
					}
				}
			}
		}

	});

//删除
var DeleteButton = new Ext.Toolbar.Button({
		text: '删除',
		iconCls: 'remove',
		width: 55,
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: ' 请选择需要删除的数据！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			} else if (len > 0) {
				for (var i = 0; i < len; i++) {
					var state = rowObj[i].get("IsFinishInit");
					if (state != "1") {
						delfun();
					} else {
						Ext.Msg.show({
							title: '警告',
							msg: '  数据已完成初始化,不可删除！ ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.WARNING
						});
					}
				}
			}
		}
	});
/* 
var SubmitButton = new Ext.Toolbar.Button({
		text: '提交',
		iconCls: 'submit',
		width: 55,
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: ' 请选择需要提交的数据！ ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			} else if (len > 0) {
				for (var i = 0; i < len; i++) {
					var state = rowObj[i].get("InitPutState");
					if (state == "已提交") {
						Ext.Msg.show({
							title: '注意',
							msg: ' 数据已提交不能重复提交！ ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.WARNING
						});
						return;
					} else if (state == "未提交") {
						submitfun();
					}
				}
			}
		}
	});
 */
// 导入
var importButton = new Ext.Toolbar.Button({
            text : '导入',
            tooltip : '导入数据(Excel格式)',
            iconCls : 'in',
            handler : function() {
                doimport();
               
            }
        });
        

// ['会计辅助核算类型:', CheckTypeName, '-', '会计科目:', SubjName, '-', QueryButton]
var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //标签对齐方式
			labelSeparator: ' ', //分隔符
			border: false,
			bodyStyle: 'padding:5px;'
		},
		// width: 1200,
		layout: 'column',
		items: [{
				labelWidth: 120,
				xtype: 'fieldset',
				width: 380,
				items: CheckTypeName
			}, {
				xtype: 'fieldset',
				labelWidth: 70,
				width: 380,
				items: SubjName
			}, {
				xtype: 'fieldset',
				labelWidth: 80,
				width: 380,
				items:QueryButton
			}]

	});
var itemGrid = new dhc.herp.Grid({
		// title: '辅助帐初始化列表',
		// iconCls: 'list',
		width: 400,
		region: 'center',
		url: projUrl,
		//atLoad: true,
		edit: false,
		tbar: [AddButton, '-', DeleteButton, '-', UpdateButton, '-', /* SubmitButton,'-', */importButton],
		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				header: 'ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'CheckItemCode',
				header: '<div style="text-align:center">编码</div>',
				width: 135,
				align: 'left',
				allowBlank: true,
				dataIndex: 'CheckItemCode'
			}, {
				id: 'CheckItemName',
				header: '<div style="text-align:center">名称</div>',
				width: 180,
				align: 'left',
				allowBlank: false,
				dataIndex: 'CheckItemName'
			}, {
				id: 'SubjCodeName',
				header: '<div style="text-align:center">会计科目</div>',
				width: 260,
				align: 'left',
				dataIndex: 'SubjCodeName',
				renderer: function formatQtip(data,metadata){
					var title = "";
					var tip = data;
					metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
					return data;
				}
			}, {
				id: 'Direction',
				header: '借/贷',
				hidden: false,
				width: 80,
				align: 'center',
				dataIndex: 'Direction'
			},  {
				id: 'CheckTypeID',
				header: '<div style="text-align:center">辅助核算类型ID</div>',
				width: 120,
				align: 'left',
				hidden: true,
				dataIndex: 'CheckTypeID'
			},{
				id: 'CheckTypeName',
				header: '<div style="text-align:center">辅助核算类型</div>',
				width: 120,
				align: 'left',
				dataIndex: 'CheckTypeName'
			}, {
				id: 'BeginSum',
				header: '<div style="text-align:center">年初余额</div>',
				hidden: false,
				width: 120,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'BeginSum'
			}, {
				id: 'BeginNum',
				header: '<div style="text-align:center">年初数量</div>',
				width: 100,
				align: 'right',
				allowBlank: true,
				hidden: true,
				dataIndex: 'BeginNum'
			}, {
				id: 'BeginSumF',
				header: '<div style="text-align:center">年初外币金额</div>',
				width: 120,
				align: 'right',
				hidden: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'BeginSumF'
			}, {
				id: 'TotalDebitSum',
				header: '<div style="text-align:center">累计借方金额</div>',
				hidden: false,
				width: 120,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalDebitSum'
			}, {
				id: 'TotalCreditSum',
				header: '<div style="text-align:center">累计贷方金额</div>',
				hidden: false,
				width: 120,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalCreditSum'
			}, {
				id: 'TotalDebitNum',
				header: '<div style="text-align:center">累计借方数量</div>',
				width: 100,
				align: 'right',
				hidden: true,
				allowBlank: true,
				dataIndex: 'TotalDebitNum'
			}, {
				id: 'TotalCreditNum',
				header: '<div style="text-align:center">累计贷方数量</div>',
				width: 100,
				align: 'right',
				hidden: true,
				allowBlank: true,
				dataIndex: 'TotalCreditNum'
			}, {
				id: 'TotalDebitSumF',
				header: '<div style="text-align:center">累计借方外币金额</div>',
				width: 120,
				hidden: true,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalDebitSumF'
			}, {
				id: 'TotalCreditSumF',
				header: '<div style="text-align:center">累计贷方外币金额</div>',
				width: 120,
				hidden: true,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalCreditSumF'
			}, {
				id: 'EndSum',
				header: '<div style="text-align:center">期初余额</div>',
				editable: false,
				hidden: false,
				width: 120,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'EndSum'
			}, {
				id: 'EndNum',
				header: '<div style="text-align:center">期初数量</div>',
				width: 100,
				align: 'right',
				hidden: true,
				allowBlank: true,
				dataIndex: 'EndNum'
			}, {
				id: 'EndSumF',
				header: '<div style="text-align:center">期初外币金额</div>',
				width: 120,
				hidden: true,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'EndSumF'
			}, {
				id: 'IsNum',
				header: '<div style="text-align:center">数量帐</div>',
				width: 120,
				hidden: true,
				align: 'right',
				dataIndex: 'IsNum'
			}, {
				id: 'IsFc',
				header: '<div style="text-align:center">外币帐</div>',
				width: 120,
				hidden: true,
				align: 'right',
				dataIndex: 'IsFc'
			}, {
				id: 'IsFinishInit',
				header: '<div style="text-align:center">是否初始化</div>',
				width: 120,
				hidden: true,
				align: 'right',
				dataIndex: 'IsFinishInit'
			}
		]
	});

itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnPrintHide(); //隐藏打印按钮
itemGrid.btnAddHide(); //隐藏按钮
itemGrid.btnSaveHide(); //隐藏按钮
itemGrid.btnDeleteHide();

itemGrid.load({
	params: {
		start: 0,
		limit: 25,
		userdr: userdr,
		acctbookid: acctbookid
	}
});

