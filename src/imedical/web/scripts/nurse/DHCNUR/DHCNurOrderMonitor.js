///执行时间监控
///彭俊福
///2014-10-16
var CurrentEpisodeID = "";

function onReady() {
	var selectionModel = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false
	});
	var abnormalOrderList = new Ext.grid.GridPanel({
		region: "center",
		layout: "fit",
		title: "执行时间监控列表",
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
					header: "接收科室",
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
				}
			]
		}),
		store: createStore({
			className: "Nur.DHCADTDischarge",
			methodName: "getAbnormalOrderJson",
			parameter1: session['EpisodeID'],
			parameter2: "Disch"
		}, ["abnormalStat", "arcimDesc", "phcinDesc", "orderStat", "execStat", "sttDate", "sttTime", "createLoc",
			"createDate", "ctcpDesc", "ordDep", "dispenStat", "LYStat", "labNo", "oeoreID", "abnormalID"
		])
	});
	abnormalOrderList.getStore().load();
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
					var frm = dhcsys_getmenuform();
					if (frm) {
						frm.EpisodeID.value = record.get("EpisodeID");
						frm.PatientID.value = record.get("patientID");
					}
					Ext.getCmp("abnormalOrderList").setTitle("姓名:" + record.get("patName") + "  性别:" + record.get("patSex") + "  年龄:" + record.get("patAge") + "  住院号:" + record.get("medCardNo"));
					loadData(Ext.getCmp("abnormalOrderList"), {
						className: "Nur.DHCADTDischarge",
						methodName: "getWrontTimeOrderJson",
						parameter1: CurrentEpisodeID
					})
				}
			}
		}),
		store: createStore({
			className: "Nur.DHCADTDischarge",
			methodName: "getWardOrderErrorTimePatList",
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
		},
		tbar: [
			"病区:",
			new Ext.form.ComboBox({
				store: new Ext.data.Store({
					proxy: new Ext.data.HttpProxy({
						url: "../csp/dhc.nurse.ext.common.getdata.csp"
					}),
					reader: new Ext.data.JsonReader(eval("(" + tkMakeServerCall("Nur.QueryBroker", "GenerateMetaData", 'web.DHCLCNUREXCUTE', 'GetWard') + ")")),
					baseParams: {
						className: 'web.DHCLCNUREXCUTE',
						methodName: 'GetWard',
						type: 'Query'
					}
				}),
				displayField: 'desc',
				valueField: 'rw',
				id: 'wardDr',
				value: '',
				hideTrigger: true,
				queryParam: 'code',
				forceSelection: true,
				triggerAction: 'all',
				minChars: 0,
				pageSize: 20,
				typeAhead: false,
				typeAheadDelay: 1000,
				loadingText: 'Searching...',
				listeners: {
					"select": function() {
						Ext.getCmp("patList").getStore().load();
					}
				}
			})

		]
	});
	if(HLBFlag==""){
		var wardDr=Ext.getCmp("wardDr")
		wardDr.disabled=true;
		var wardLocInfo = tkMakeServerCall("web.DHCLCNUREXCUTE", "GetUserWardId", session['LOGON.USERID'], session['LOGON.CTLOCID'], "").split("|");
		var wardInfo = wardLocInfo[0].split("^");
		wardDr.getStore().load({
			params: {
				start: 0,
				limit: 10,
				code: wardInfo[0]
			},
		callback: function() {
			Ext.getCmp("wardDr").setValue(wardInfo[1])
		}
	});
	}else{
	}
	
	patList.getStore().on("beforeload",function(){
		var value=Ext.getCmp("wardDr").getValue();
			if(value!=""){
				this.baseParams.parameter1=value;
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
		验证时间格式 
	*/
function isTimeStr(s) {
	return (/^((2[0-3])|([0-1]\d)|(\d)|):((5[0-9])|([0-4]\d)|(\d))$/.test(s));
}
Ext.onReady(onReady);