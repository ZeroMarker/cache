///需关注 新
///吕欣
///2014-07-10
var CurrentEpisodeID = "";

function onReady() {
	var selectionModel = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false
	});
	var abnormalOrderList = new Ext.grid.GridPanel({
		region: "center",
		layout: "fit",
		title: "-",
		id: "abnormalOrderList",
		loadMask: true,
		sm: selectionModel,
		cm: new Ext.grid.ColumnModel({
			columns: [
				selectionModel, {
					header: "未处理情况",
					dataIndex: "abnormalStat",
					width: 200
				}, {
					header: "医嘱名称",
					dataIndex: "arcimDesc",
					width: 300,
					renderer: function(value, metadata, record) {
						metadata.attr = 'style="white-space:normal;"';
						return value;
					}
				}, {
					header: "用药途径",
					dataIndex: "phcinDesc",
					width: 80
				}, {
					header: "医嘱状态",
					dataIndex: "orderStat",
					width: 60
				}, {
					header: "执行状态",
					dataIndex: "execStat",
					width: 60
				}, {
					header: "要求执行日期",
					dataIndex: "sttDate",
					width: 80
				}, {
					header: "要求执行时间",
					dataIndex: "sttTime",
					width: 80
				}, {
					header: "开医嘱科室",
					dataIndex: "createLoc",
					width: 100
				}, {
					header: "开医嘱日期",
					dataIndex: "createDate",
					width: 120
				}, {
					header: "医生",
					dataIndex: "ctcpDesc",
					width: 60
				}, {
					header: "接受科室",
					dataIndex: "ordDep",
					width: 110
				}, {
					header: "发药状态",
					dataIndex: "dispenStat",
					width: 80
				}, {
					header: "领药审核状态",
					dataIndex: "LYStat",
					width: 80
				}, {
					header: "标本号",
					dataIndex: "labNo",
					width: 80
				}, {
					header: "医嘱ID",
					dataIndex: "oeoreID",
					width: 80
				}, {
					header: "abnormalID",
					dataIndex: "abnormalID",
					width: 80
				}, {
					header: "需关注类型",
					dataIndex: "abnormalType",
					width: 80,
					renderer: function(value) {
						switch (value) {
							case "Disch":
								value = "出院需关注";
								break;
							case "Trans":
								value = "转科需关注";
								break;
							case "all":
								value = "全部需关注";
								break;
							default:
								value = ""
						}
						return value;
					}
				}
			]
		}),
		store: createStore({
			className: "Nur.DHCADTDischarge",
			methodName: "getAbnormalOrderJson",
			parameter1: session['EpisodeID'],
			parameter2: "Disch"
		}, ["abnormalStat", "arcimDesc", "phcinDesc", "orderStat", "execStat", "sttDate", "sttTime", "createLoc",
			"createDate", "ctcpDesc", "ordDep", "dispenStat", "LYStat", "labNo", "oeoreID", "abnormalID", "abnormalType"
		]),
		//viewConfig: {
		//forceFit: true
		// },
		tbar: [
			new Ext.form.Label({
				text: "需关注类型："
			}),
			new Ext.form.ComboBox({
				id: "abnormalType",
				store: [
					["all", "全部需关注"],
					["Disch", "出院需关注"],
					["Trans", "转科需关注"]
				],
				triggerAction: 'all',
				value: "all",
				editable: false,
				listeners: {
					"select": function(change, newValue, oldValue) {
						Ext.getCmp("abnormalOrderList").getStore().removeAll();
						var abnormalType = Ext.getCmp("abnormalType").getValue();
						var abnormalStat = Ext.getCmp("abNormalStatComb").getValue();
						loadData(Ext.getCmp("abnormalOrderList"), {
							className: "Nur.DHCADTDischarge",
							methodName: "getAbnormalOrderJson",
							parameter1: CurrentEpisodeID,
							parameter2: abnormalType,
							parameter3: abnormalStat
						});
					}
				}
			}),
			"-",
			new Ext.form.Label({
				text: "未处理情况："
			}),
			new Ext.form.ComboBox({
				id: "abNormalStatComb",
				valueField: "abNormalStat",
				displayField: "abNormalStat",
				minChars: 0,
				store: new Ext.data.JsonStore({
					url: "../csp/dhc.nurse.extjs.getdata.csp",
					root: "rowData",
					fields: ["ID", "abNormalStat"],
					baseParams: {
						className: "Nur.DHCADTDischSet",
						methodName: "getAbnormalStat"
					},
					listeners: {
						beforeload: function() {
							var store = Ext.getCmp("abNormalStatComb").getStore();
							store.removeAll();
							var abnormalType = Ext.getCmp("abnormalType").getValue();
							store.baseParams.parameter1 = abnormalType;
						}
					}
				}),
				listeners: {
					"select": function(change, newValue, oldValue) {
						Ext.getCmp("abnormalOrderList").getStore().removeAll();
						var abnormalType = Ext.getCmp("abnormalType").getValue();
						var abnormalStat = Ext.getCmp("abNormalStatComb").getValue();
						loadData(Ext.getCmp("abnormalOrderList"), {
							className: "Nur.DHCADTDischarge",
							methodName: "getAbnormalOrderJson",
							parameter1: CurrentEpisodeID,
							parameter2: abnormalType,
							parameter3: abnormalStat
						});
					},
					expand: function() {
						Ext.getCmp("abNormalStatComb").getStore().load()
					}
				}

			}),
			"-",
			new Ext.Button({
				id: "findButton",
				text: "查询",
				listeners: {
					click: function() {
						Ext.getCmp("abnormalOrderList").getStore().removeAll();
						var abnormalStat = Ext.getCmp("abNormalStatComb").getValue();
						loadData(Ext.getCmp("abnormalOrderList"), {
							className: "Nur.DHCADTDischarge",
							methodName: "getAbnormalOrderJson",
							parameter1: CurrentEpisodeID,
							parameter2: Ext.getCmp("abnormalType").getValue(),
							parameter3: abnormalStat
						});
					}
				}
			}),
			"-",
			new Ext.Button({
				text: "忽略选中的需关注项",
				handler: function() {
					var store = Ext.getCmp("abnormalOrderList").getStore();
					var selectionModel = Ext.getCmp("abnormalOrderList").getSelectionModel();
					var recordArray = selectionModel.getSelections();
					var oeoreIDabnormalStatStr = ""
					for (var index = 0; index < recordArray.length; index++) {
						var record = recordArray[index];
						var oeoreID = record.get("oeoreID");
						var ignoreStat = record.get("abnormalID");
						var abnormalType = record.get("abnormalType");
						if (oeoreIDabnormalStatStr == "") {
							oeoreIDabnormalStatStr = oeoreID + "@" + ignoreStat + "@" + abnormalType
						} else {
							oeoreIDabnormalStatStr = oeoreIDabnormalStatStr + "^" + oeoreID + "@" + ignoreStat + "@" + abnormalType
						}
					}
					if (oeoreIDabnormalStatStr == "") {
						Ext.MessageBox.alert("提示", "请至少选择一条记录！");
						return;
					}
					var window = createWindow();
					window.buttons[0].on("click", function() {
						var userID = passwordConfirm(window);
						if (userID != -1) {
							//忽略需关注
							var date = window.getComponent("date").getValue().format("Y-m-d");
							var time = window.getComponent("time").getValue();
							var ignoreReason = window.getComponent("ignoreReason").getValue();
							//var abnormalType = Ext.getCmp("abnormalType").getValue();  增加全部   暂不用这个
							//var oeoreIDabnormalStatStr =""
							if (!isTimeStr(time)) {
								Ext.MessageBox.alert("<时间格式>", "时间格式错误，请检查！格式(时:分)");
								return;
							}
							var ret = tkMakeServerCall("Nur.DHCADTDischarge", "ignorSelectedOrder", CurrentEpisodeID, userID, date, time, ignoreReason, oeoreIDabnormalStatStr);
							if (ret == 0) {
								Ext.MessageBox.alert("提示", "操作成功！");
							} else {
								Ext.MessageBox.alert("提示", (ret == "" ? "操作失败！" : ret));
							}

						}
						window.close();
						Ext.getCmp("findButton").fireEvent("click");
					});
					window.show();
				}
			}),
			"-",
			new Ext.Button({
				text: "已忽略医嘱列表",
				handler: function() {
					var win = createIgnorOrderListWindow();
					win.show();
				}
			})
		]
	});
	//abnormalOrderList.getStore().load();

	var patList = new Ext.grid.GridPanel({
		layout: "fit",
		id: "patList",
		cm: new Ext.grid.ColumnModel([{
			header: "床号",
			dataIndex: "bedCode",
			width: 170
		}, {
			header: "姓名",
			dataIndex: "patName",
			width: 200
		}, {
			header: "登记号",
			dataIndex: "patRegNo",
			width: 300
		}, {
			header: "EpisodeID",
			dataIndex: "EpisodeID",
			width: 300,
			hidden: true
		}, {
			header: "性别",
			dataIndex: "patSex",
			width: 300,
			hidden: true
		}, {
			header: "年龄",
			dataIndex: "patAge",
			width: 300,
			hidden: true
		}, {
			header: "住院号",
			dataIndex: "medCardNo",
			width: 300,
			hidden: true
		}, {
			header: "病人ID",
			dataIndex: "patientID",
			width: 300,
			hidden: true
		}]),
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function() {
					var record = Ext.getCmp("patList").getSelectionModel().getSelected();
					CurrentEpisodeID = record.get("EpisodeID");
					if (window.top == window.self) {
						var frm = window.opener.parent.parent.parent.document.forms['fEPRMENU'];
						for (var i = 0; i < frm.elements.length; i++) {
							frm.elements[i].value = "";
						}
					} else {
						var frm = dhcsys_getmenuform();
					}
					for (var i = 0; i < frm.elements.length; i++) {
						frm.elements[i].value = "";

					}
					if (frm) {
						for (var i = 0; i < frm.elements.length; i++) {
							frm.elements[i].value = "";
						}
						frm.EpisodeID.value = record.get("EpisodeID");
						frm.PatientID.value = record.get("patientID");
					}
					Ext.getCmp("abnormalOrderList").setTitle("姓名:" + record.get("patName") + "  性别:" + record.get("patSex") + "  年龄:" + record.get("patAge") + "  住院号:" + record.get("medCardNo"));
					loadData(Ext.getCmp("abnormalOrderList"), {
						className: "Nur.DHCADTDischarge",
						methodName: "getAbnormalOrderJson",
						parameter1: CurrentEpisodeID,
						parameter2: Ext.getCmp("abnormalType").getValue()
					})
				}
			}
		}),
		store: createStore({
			className: "Nur.DHCADTDischarge",
			methodName: "getWardPatList",
			parameter1: session['LOGON.WARDID'],
			parameter2: session['LOGON.CTLOCID']
		}, ["bedCode", "patName", "patRegNo", "EpisodeID", "patSex", "patAge", "medCardNo", "patientID"]),
		viewConfig: {
			forceFit: true
		},
		listeners: {
			"render": function() {
				/*
				加载数据 选中默认病人
				*/
				patList.getStore().load({
					callback: function(r, options, success) {
						if (success) {
							var patlistSelectionModel = Ext.getCmp("patList").getSelectionModel();
							var count = r.length;
							for (var i = 0; i < count; i++) {
								var Epi = r[i].get("EpisodeID");
								if (Epi == session['EpisodeID']) {
									patlistSelectionModel.selectRow(i);
									//Ext.getCmp("patList").doLayout();
									return;
								}
							}
						}
					}
				});
			}
		}
	});
	patList.getStore().load();
	var viewPore = new Ext.Viewport({
		layout: "border",
		items: [{
			region: "west",
			layout: "fit",
			id: "westPanel",
			width: 200,
			items: [patList]

		}, {
			region: "center",
			layout: "fit",
			id: "centerPanel",
			items: [abnormalOrderList]
		}]
	});


	var abnormalStat = Ext.getCmp("abNormalStatComb").getValue();

	loadData(Ext.getCmp("abnormalOrderList"), {
		className: "Nur.DHCADTDischarge",
		methodName: "getAbnormalOrderJson",
		parameter1: CurrentEpisodeID,
		parameter2: Ext.getCmp("abnormalType").getValue(),
		parameter3: abnormalStat
	});

	Ext.EventManager.onWindowResize(windowResize);
}


//**************************************************
/*
	自适应大小
*/
function windowResize() {

	}
	/*
		store
	*/
function loadData(obj, params) {
	obj.getStore().load({
		params: params
	})
}

function createStore(basePar, fields) {
		var store = new Ext.data.JsonStore({
			url: "../csp/dhc.nurse.extjs.getdata.csp",
			root: "rowData",
			fields: fields,
			baseParams: basePar
		});
		return store;
	}
	/*
		window
	*/
function createWindow() {
	if (Ext.getCmp("verifiWindow")) {
		Ext.getCmp("verifiWindow").close();
	}
	var window = new Ext.Window({
		bodyStyle: "padding:5px;",
		id: "verifiWindow",
		width: 260,
		height: 350,
		resizable: false,
		layout: "form",
		items: [{
			id: "ignoreReason",
			xtype: "textfield",
			width: 125,
			fieldLabel: "忽略原因",
			labelStyle: "font-size:18px"
		}, {
			id: "date",
			xtype: "datefield",
			fieldLabel: "日期",
			width: 125,
			labelStyle: "font-size:18px",
			value: new Date().format('Y-m-d')
		}, {
			id: "time",
			xtype: "textfield",
			fieldLabel: "时间",
			width: 125,
			allowBlank: false,
			value: new Date().format("H:m"),
			labelStyle: "font-size:18px"
		}, {
			id: "userName",
			xtype: "textfield",
			fieldLabel: "工号",
			width: 125,
			value: session['LOGON.USERCODE'],
			labelStyle: "font-size:18px",
			listeners: {
				'render': {
					fn: function(c) {
						c.getEl().on('keydown', function() {
							if (event.keyCode == 13) {
								window.getComponent("password").focus();
							}
						});
					}
				}
			}
		}, {
			id: "password",
			xtype: "textfield",
			fieldLabel: "密码",
			width: 125,
			inputType: 'password',
			labelStyle: "font-size:18px",
			listeners: {
				'render': {
					fn: function(c) {
						c.getEl().on('keydown', function() {
							if (event.keyCode == 13) {
								window.buttons[0].fireEvent("click");
							}
						});
					}
				}
			}
		}],
		buttons: [{
			id: "execButton",
			xtype: "button",
			text: "确定"
		}, {
			id: "cancelButton",
			xtype: "button",
			text: "取消",
			handler: function() {
				window.close()
			}
		}],
		listeners: {
			beforeclose: function() {
				this.destroy();
			}
		}
	})
	return window
}

function createIgnorOrderListWindow() {

	if (Ext.getCmp("ignorOrderListWin")) {
		Ext.getCmp("ignorOrderListWin").close();
	}
	if (Ext.getCmp("ignorOeordList")) {
		Ext.getCmp("ignorOeordList").destroy();
	}
	var ignorOeordList = new Ext.grid.GridPanel({
		id: "ignorOeordList",
		layout: "fit",
		tbar: [
			new Ext.Button({
				text: "撤销",
				handler: function() {
					var oeoreIDstr = "";
					var recordArray = Ext.getCmp("ignorOeordList").getSelectionModel().getSelections();
					for (var i = 0; i < recordArray.length; i++) {
						var oeoreID = recordArray[i].get("ignoreOeoreID");
						if (oeoreIDstr != "") {
							oeoreIDstr = oeoreIDstr + "^" + oeoreID
						} else {
							oeoreIDstr = oeoreID
						}
					}
					var userID = session['LOGON.USERID'];
					var retStr = tkMakeServerCall("Nur.DHCADTDischarge", "cancelIgnorOrder", oeoreIDstr, userID);
					if (retStr == 0) {
						Ext.MessageBox.alert("提示", "操作成功！");
					} else {
						Ext.MessageBox.alert("提示", retStr);
						return;
					}
					Ext.getCmp("ignorOrderListWin").close();
					Ext.getCmp("findButton").fireEvent("click");
				}
			})
		],
		cm: new Ext.grid.ColumnModel([{
				header: "需关注类型",
				dataIndex: "abnormalTypeDesc",
				width: 100
			}, {
				header: "未处理情况",
				dataIndex: "abnormalStat",
				width: 100
			}, {
				header: "医嘱名称",
				dataIndex: "arcimDesc",
				width: 300
			}, {
				header: "医嘱用法",
				dataIndex: "phcinDesc",
				width: 100
			}, {
				header: "开医嘱日期",
				dataIndex: "createDate",
				width: 100
			}, {
				header: "要求执行日期",
				dataIndex: "sttDate",
				width: 100
			}, {
				header: "要求执行时间",
				dataIndex: "sttTime",
				width: 100
			},

			{
				header: "忽略日期",
				dataIndex: "ignoreDate",
				width: 100
			}, {
				header: "忽略时间",
				dataIndex: "ignoreTime",
				width: 100
			}, {
				header: "忽略人",
				dataIndex: "ignoreUser",
				width: 100
			}, {
				header: "忽略原因",
				dataIndex: "ignoreReason",
				width: 100
			}, {
				header: "医嘱ID",
				dataIndex: "ignoreOeoreID",
				width: 100
			}
		]),
		sm: new Ext.grid.RowSelectionModel({}),
		store: createStore({
			className: "Nur.DHCADTDischarge",
			methodName: "getIgnorOrderListJson",
			parameter1: CurrentEpisodeID
		}, ["abnormalTypeDesc", "abnormalStat", "arcimDesc", "phcinDesc", "createDate", "sttDate", "sttTime", "ignoreDate", "ignoreTime", "ignoreUser", "ignoreReason", "ignoreOeoreID"])
	});
	ignorOeordList.getStore().load();
	var window = new Ext.Window({
		bodyStyle: "padding:5px;",
		id: "ignorOrderListWin",
		width: 900,
		height: 500,
		resizable: false,
		layout: "fit",
		items: [ignorOeordList]
	});

	return window
}

function passwordConfirm(window) {
		var ctLocId = session['LOGON.CTLOCID']
		var userName = window.getComponent("userName").getValue();
		var password = window.getComponent("password").getValue();
		if (userName == "" || password == "") {
			Ext.MessageBox.alert("<提示>", "用户名和密码不能为空！");
			return -1;
		}
		var confirmUserStr = tkMakeServerCall("Nur.NurseExcute", "passwordConfirm", userName, password, "", "", ctLocId);
		if (confirmUserStr.indexOf("0^") == -1) {
			Ext.MessageBox.alert("<提示>", confirmUserStr.replace("用户1", "该用户"))
			return -1;
		} else {
			userId = confirmUserStr.split("^")[1];
			return userId;
		}
	}
	/*
		验证时间格式 
	*/
function isTimeStr(s) {
	return (/^((2[0-3])|([0-1]\d)|(\d)|):((5[0-9])|([0-4]\d)|(\d))$/.test(s));
}
Ext.onReady(onReady);