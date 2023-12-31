//出院与转科设置 新
//吕欣
//2014-07-10
var clWidth;
var clHeight;
var preWidth;

function onReady() {
	clWidth = document.body.clientWidth;
	clHeight = document.body.clientHeight;
	var AbnormalStatGrid = new Ext.grid.EditorGridPanel({
		id: "AbnormalStatGrid",
		cm: new Ext.grid.ColumnModel([{
			header: "ID",
			width: 30,
			dataIndex: "ID",
			sortable: true
		}, {
			header: "未处理情况",
			width: 50,
			dataIndex: "abNormalStat",
			sortable: true,
			editor: new Ext.form.TextField({})
		}, {
			header: "是否提示",
			width: 50,
			dataIndex: "ifAlert",
			sortable: true,
			editor: new Ext.form.ComboBox({
				store: ["Y", "N"],
				triggerAction: 'all'
			})
		}, {
			header: "提示顺序",
			width: 50,
			dataIndex: "alertSeq",
			sortable: true,
			editor: new Ext.form.TextField({})
		}, {
			header: "函数名",
			width: 90,
			dataIndex: "methodName",
			sortable: true,
			editor: new Ext.form.TextField({})
		}, {
			header: "押金留观是否提示",
			width: 150,
			dataIndex: "ifAlertStayMode",
			sortable: true,
			editor: new Ext.form.ComboBox({
				store: ["Y", "N"],
				triggerAction: 'all'
			})
		}]),
		sm: new Ext.grid.CheckboxSelectionModel({
			listeners: {
				rowselect: function() {
					loadSets(Ext.getCmp("setType").getValue());
				},
				rowdeselect: function() {
					if (Ext.getCmp("AbnormalStatGrid").getSelectionModel().getSelections().length == 0) {
						loadSets(Ext.getCmp("setType").getValue());
					}
				}
			}
		}),
		store: createStore({}, ["ID", "abNormalStat", "ifAlert", {name:"alertSeq",type:'int'}, "methodName","ifAlertStayMode"]),
		viewConfig: {
			forceFit: true
		}
	});
	
	var len = AbnormalStatGrid.getColumnModel().getColumnCount();
		for(var i = 0 ;i < len;i++){
			if(AbnormalStatGrid.getColumnModel().getDataIndex(i) == 'ID'){
				AbnormalStatGrid.getColumnModel().setHidden(i,true);
			}
		}
	AbnormalStatGrid.addListener('rowcontextmenu', rightClickFn);


	/*
		viewPortclWidth
	*/
	var viewPort = new Ext.Viewport({
		layout: "border",
		id: "viewPort",
		items: [{
			region: "east",
			id: "eastRegion",
			items: [],
			tbar: ["列表项双击删除","->", new Ext.Button({
				text: "保存",
				icon:'../images/uiimages/filesave.png',
				handler: saveSet
			})],
			layout: "fit",
			split: true,
			width: clWidth * 3.5 / 4.5,
			padding: "5,5,5,5"

		}, {
			region: "center",
			xtype: "panel",
			id: "centerPanel",
			layout: "fit",
			split: true,
			items: [AbnormalStatGrid],
			tbar: [{
					xtype: "combo",
					id: "setType",
					minChars: 0,
					triggerAction: 'all',
					store: [
						["Disch", "出院设置"],
						["Trans", "转科设置"],
						["all", "通用设置"]
					],
					listeners: {
						"select": function(change, newValue, oldValue) {
							Ext.getCmp("AbnormalStatGrid").getStore().removeAll();
							var disPlayType = Ext.getCmp("setType").getValue();
							initRightPanel(disPlayType);
							Ext.getCmp("AbnormalStatGrid").getSelectionModel().clearSelections();
							loadSets(disPlayType);
							loadData(Ext.getCmp("AbnormalStatGrid"), {
								className: "Nur.DHCADTDischSet",
								methodName: "getAbnormalStat",
								parameter1: disPlayType
							})

						}
					}
				}, {
					xtype: "button",
					text: "增加",
					icon:'../images/uiimages/edit_add.png',
					handler: addAbnormalStat
				},

				{
					xtype: "button",
					text: "删除",
					icon:'../images/uiimages/edit_remove.png',
					handler: deleteAbnormalStat
				},

				"->", {
					xtype: "button",
					text: "保存",
					icon:'../images/uiimages/filesave.png',
					handler: saveAbnormalStatSet
				}, {
					xtype: "button",
					text: "刷新",
					icon:'../images/uiimages/update.png',
					handler: refresh
				}

			]
		}]
	})
	Ext.getCmp("setType").setValue("Disch");
	initRightPanel("Disch");
	// loadData(Ext.getCmp("AbnormalStatGrid"), {
	// 	className: "Nur.DHCADTDischSet",
	// 	methodName: "getAbnormalStat",
	// 	parameter1: "Disch"
	// })
	// loadSets("Disch");
	Ext.getCmp("centerPanel").on("resize", windowResize);
	Ext.EventManager.onWindowResize(windowResize);
	preWidth = document.body.clientWidth;
}

function rightClickFn(grid, rowindex, e) {
	e.preventDefault();
	var rightClick;
	if (!Ext.getCmp("rightClickCont")) {
		rightClick = new Ext.menu.Menu({
			id: 'rightClickCont',
			items: [{
				id: 'rMenu1',
				//handler: rMenu2Fn, 
				text: '编辑时间',
				handler: function() {
					showEditWindow();
				}
			}]
		});
	} else {
		rightClick = Ext.getCmp("rightClickCont");
	}
	var gsm = grid.getSelectionModel();
	var row = gsm.getSelections();
	var text = row[0].get('abNormalStat');
	if (text.indexOf("执行时间错误") > -1) {
		rightClick.showAt(e.getXY());
	}

}

function showEditWindow() {
	var win;
	if (!Ext.getCmp("editWindow")) {
		var store = new Ext.data.ArrayStore({
			fields: [{
				name: 'desc'
			}, {
				name: 'code'
			}]
		});

		var data = eval("(" + tkMakeServerCall("Nur.DHCADTDischarge", "getOrderPri") + ")")
		store.loadData(data);
		var grid = new Ext.grid.GridPanel({
			width: 150,
			height: 250,
			x: 10,
			y: 10,
			cm: new Ext.grid.ColumnModel([{
				header: "医嘱优先级",
				width: 145,
				dataIndex: "desc"
			}]),
			store: store
		});
		var code = "";
		grid.addListener("rowclick", function(grid, index, event) {
			var excuteRange = Ext.getCmp("excuteRange");
			var row = grid.getStore().getAt(index);
			var type = Ext.getCmp("setType").getValue();
			code = row.get("code");
			var value = tkMakeServerCall("Nur.DHCADTDischarge", "getPriTimeRange", type, code);

			excuteRange.setValue(value);
		});
		win = new Ext.Window({
			id: "editWindow",
			layout: 'absolute',
			width: 400,
			height: 350,
			closeAction: 'hide',
			items: [
				grid, {
					text: "要求执行时间之后多少分钟之内执行正确",
					x: 180,
					width: 160,
					y: 10,
					xtype: "label"
				}, {
					x: 180,
					id: "excuteRange",
					y: 50,
					xtype: "textfield"
				}
			],
			buttons: [{
				text: '保存',
				icon:'../images/uiimages/filesave.png',
				handler: function() {
					if (code != "") {
						var value = Ext.getCmp("excuteRange").getValue();
						var ret = tkMakeServerCall("Nur.DHCADTDischarge", "savePriTimeRange", Ext.getCmp("setType").getValue(), code, value);
					}
				}
			}],
			listeners: {
				"hide": function() {
					//alert("ceshi");
					win.close();
				}
			}
		});
	} else {
		win = Ext.getCmp("editWindow")
	}
	win.show();
}
/*
	自适应大小
*/
function windowResize() {
	clWidth = document.body.clientWidth;
	if (preWidth == clWidth) {
		//Ext.getCmp("eastRegion").setWidth(parseInt(clWidth*3/4))
	} else {
		Ext.getCmp("eastRegion").setWidth(parseInt(clWidth * 3.5 / 5));
		preWidth = clWidth;
	}

	Ext.getCmp("viewPort").doLayout();
	Ext.getCmp("centerPanel").doLayout();
	//initRightPanel(Ext.getCmp("setType").getValue());
}

function createComboBox(id, width, className, method, linkListViewID, queryPar, limit) {
	var comboBox = new Ext.form.ComboBox({
		id: id,
		width: width,
		displayField: "value",
		valueField: "ID",
		store: createStore({
			className: className,
			methodName: method,
			start: 0,
			limit: limit
		}, ["ID", "value"]),
		triggerAction: 'all',
		minChars: 0,
		pageSize: limit,
		queryParam: queryPar,
		listeners: {
			select: function() {
				var ID = Ext.getCmp(id).getValue();
				var value = Ext.get(id).dom.value
				var store = Ext.getCmp(linkListViewID).getStore();
				if (!ifExistRecord(store, ID)) {
					var record = new Ext.data.Record({
						ID: ID,
						value: value
					})
					store.insert(store.getCount(), record);
				}
				Ext.get(id).dom.value = "";
			},
			focus: {
				fn: function (e) {
					e.expand();
					this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
					debugger;
					combo.store.filterBy(function (record, id) {
						console.log(record);
						debugger;						
						var text = getPinyin(record.get('value'));
						return regExp.test(text) | regExp.test(record.data[me.displayField]); 
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
			}		
		}
	})
	return comboBox;

}

function createListView(id, width, height, header) {
	var listView = new Ext.ListView({
		id: id,
		width: width,
		height: height,
		store: new Ext.data.JsonStore(),
		multiSelect: true,
		reserveScrollOffset: true,
		hideHeaders: false,
		columns: [{
			header: 'ID',
			dataIndex: 'ID',
			hidden: true,
			width: .3
		}, {
			header: header,
			dataIndex: 'value',
			width: .7
		}],
		listeners: {
			dblclick: function(view, index, html, e) {
				Ext.getCmp(id).getStore().removeAt(index)
			}				
		}
	})
	return listView

}
/*
	根据设置类型  初始化右面的窗口
*/
function initRightPanel(disPlayType) {
	Ext.getCmp("eastRegion").removeAll(true);
	var checkBoxAreaHeight = 25;
	var regionWidth = Ext.getCmp("eastRegion").getWidth();
	var regionHeight = Ext.getCmp("eastRegion").getHeight();
	var panelHeight = ((regionHeight - checkBoxAreaHeight - Ext.getCmp("eastRegion").getTopToolbar().getHeight()) - 25) / 2;
	var listViewHeight = panelHeight - 55;
	//20 padding
	var eastPanel = new Ext.Panel({
		layout: "form",
		layoutConfig: {
			align: "top",
			defaultMargins: {
				top: 0,
				right: 0,
				bottom: 0,
				left: 0
			},
			pack: "start"
		},
		items: [

		],
		padding: "1,1,1,1"
	});
	if (disPlayType == "Disch") {
		tableCellWidth = (regionWidth - 25) / 5;
		eastPanel.add({
			xtype: "panel",
			layout: "hbox",
			border: false,
			defaults: {
				margins: '2 5 0 5'
			},
			height: checkBoxAreaHeight,
			items: [
			{
				xtype: "label",
				text: "提示仍能出院",
				textAlign:'right'
			}, 
			{
				xtype: "checkbox",
				id: "ifCanDisch"
			},
			{
				xtype: "label",
				text: "出院带药需在最终结算前取药"
			},  
			{
				xtype: "checkbox",
				id: "ifTakeDisDrug"
			}, 
			{
				xtype: "label",
				text: "提示非新长嘱未执行"
			},
			{
				xtype: "checkbox",
				id: "ifAlertLonOld"
			}, 
			{
				xtype: "label",
				text: "取医生出院时间"
			},
			 {
				xtype: "checkbox",
				id: "ifGetDischgDateTimeByDoc"
			}, 
			{
				xtype: "label",
				text: "入院时间取分床"
			},
			 {
				xtype: "checkbox",
				id: "ifGetAdmDateTimeByBed"
			}
			]
		}, {
			xtype: "panel",
			layout: "table",
			padding: "5,5,5,5",
			border: false,
			layoutConfig: {
				columns: 6
			},
			defaults: {
				bodyStyle: "padding:5,5,5,5"
			},
			items: [{
				xtype: "panel",
				title: "出院医生需开医嘱",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("dischargeNeedArcim", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcim", "dischargeNeedArcimListview", "arcimDesc", 10),
					createListView("dischargeNeedArcimListview", tableCellWidth - 12, listViewHeight, "医嘱项")
				]
			},{
				xtype: "panel",
				title: "死亡出院医生需开医嘱",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("deathDischargeNeedArcim", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcim", "deathDischargeNeedArcimListview", "arcimDesc", 10),
					createListView("deathDischargeNeedArcimListview", tableCellWidth - 12, listViewHeight, "医嘱项")
				]
			},{
				xtype: "panel",
				title: "出院前医生必须开的诊断类型",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("diagBeforeDisch", tableCellWidth - 10, "Nur.DHCADTDischSet", "getDiagType", "diagBeforeDischListview", "", 10),
					createListView("diagBeforeDischListview", tableCellWidth - 12, listViewHeight, "诊断类型")
				]
			}, {
				xtype: "panel",
				title: "出院前医生必须停止的医嘱",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("stopOrdBeforeDisch", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcim", "stopOrdBeforeDischListview", "arcimDesc", 10),
					createListView("stopOrdBeforeDischListview", tableCellWidth - 12, listViewHeight, "医嘱项")
				]
			}, {
				xtype: "panel",
				title: "出院前医生必须开的医嘱子类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("arcItmChartBeforeDisch", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcItmChart", "arcItmChartBeforeDischListview", "arcicDesc", 10),
					createListView("arcItmChartBeforeDischListview", tableCellWidth - 12, listViewHeight, "医嘱子类")
				],
				colspan: 2
			}, {
				xtype: "panel",
				title: "不提示的科室",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertLoc", tableCellWidth - 10, "Nur.DHCADTDischSet", "getLoc", "notAlertLocListview", "locDesc", 10),
					createListView("notAlertLocListview", tableCellWidth - 12, listViewHeight, "科室名称")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱大类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertOrdCat", tableCellWidth - 10, "Nur.DHCADTDischSet", "getOrdCat", "notAlertOrdCatListview", "ordCat", 10),
					createListView("notAlertOrdCatListview", tableCellWidth - 12, listViewHeight, "医嘱大类")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱子类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertArcItmCat", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcItmChart", "notAlertArcItmCatListview", "arcicDesc", 10),
					createListView("notAlertArcItmCatListview", tableCellWidth - 12, listViewHeight, "医嘱子类")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertArcim", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcim", "notAlertArcimListview", "arcimDesc", 10),
					createListView("notAlertArcimListview", tableCellWidth - 12, listViewHeight, "医嘱项")
				]
			},
			{
				xtype: "panel",
				title: '<font size="2">明日出院提前录入体温配置</font>',
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("tomorrowDischArcim", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcim", "tomorrowDischListview", "arcimDesc", 10),
					createListView("tomorrowDischListview", tableCellWidth - 12, listViewHeight, "医嘱项")				
				]
			}]
		});
		//Ext.getCmp("mustDiagType").getStore().load();
		//Ext.getCmp("mustStopOrd").getStore().load();
	} else if (disPlayType == "Trans") {
		tableCellWidth = (regionWidth - 25) / 3;
		eastPanel.add({
			xtype: "panel",
			layout: "hbox",
			border: false,
			defaults: {
				margins: '2 5 0 5'
			},
			height: checkBoxAreaHeight,
			items: [/**{
				xtype: "label",
				text: "转科是否停当日长期医嘱: "
			}, {
				xtype: "checkbox",
				id: "ifStopLongOrd"
			}, */{
				xtype: "label",
				text: "有提示仍能转科: "
			}, {
				xtype: "checkbox",
				id: "ifCanDisch"
			}, {
				xtype: "label",
				text: "转科是否需要科室与病区关联: ",
				hidden:true				
			}, {
				xtype: "checkbox",
				id: "ifNeedLocWardRelation",
				hidden:true
			}]
		}, {
			xtype: "panel",
			layout: "table",
			padding: "5,5,5,5",
			border: false,
			layoutConfig: {
				columns: 3
			},
			defaults: {
				bodyStyle: "padding:5,5,5,5"
			},
			items: [{
				xtype: "panel",
				title: "转科前必须开的医嘱子类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("arcimBeforeTrans", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcItmChart", "arcimBeforeTransListview", "arcicDesc", 10),
					createListView("arcimBeforeTransListview", tableCellWidth - 12, listViewHeight, "医嘱子类")
				]
			}, {
				xtype: "panel",
				title: "不提示的科室",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertLoc", tableCellWidth - 10, "Nur.DHCADTDischSet", "getLoc", "notAlertLocListview", "locDesc", 10),
					createListView("notAlertLocListview", tableCellWidth - 12, listViewHeight, "科室名称")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱大类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertOrdCat", tableCellWidth - 10, "Nur.DHCADTDischSet", "getOrdCat", "notAlertOrdCatListview", "ordCat", 10),
					createListView("notAlertOrdCatListview", tableCellWidth - 12, listViewHeight, "医嘱大类")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱子类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertArcItmCat", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcItmChart", "notAlertArcItmCatListview", "arcicDesc", 10),
					createListView("notAlertArcItmCatListview", tableCellWidth - 12, listViewHeight, "医嘱子类")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertArcim", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcim", "notAlertArcimListview", "arcimDesc", 10),
					createListView("notAlertArcimListview", tableCellWidth - 12, listViewHeight, "医嘱项")
				]
			}]
		});
	} else if (disPlayType == "all") {
		tableCellWidth = (regionWidth - 25) / 2;
		eastPanel.add({
			xtype: "panel",
			layout: "table",
			padding: "5,5,5,5",
			border: false,
			layoutConfig: {
				columns: 2
			},
			defaults: {
				bodyStyle: "padding:5,5,5,5"
			},
			items: [{
				xtype: "panel",
				title: "不提示的科室",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertLoc", tableCellWidth - 10, "Nur.DHCADTDischSet", "getLoc", "notAlertLocListview", "locDesc", 10),
					createListView("notAlertLocListview", tableCellWidth - 12, listViewHeight, "科室名称")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱大类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertOrdCat", tableCellWidth - 10, "Nur.DHCADTDischSet", "getOrdCat", "notAlertOrdCatListview", "ordCat", 10),
					createListView("notAlertOrdCatListview", tableCellWidth - 12, listViewHeight, "医嘱大类")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱子类",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertArcItmCat", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcItmChart", "notAlertArcItmCatListview", "arcicDesc", 10),
					createListView("notAlertArcItmCatListview", tableCellWidth - 12, listViewHeight, "医嘱子类")
				]
			}, {
				xtype: "panel",
				title: "不提示的医嘱",
				layout: "fit",
				width: tableCellWidth,
				height: panelHeight,
				items: [
					createComboBox("notAlertArcim", tableCellWidth - 10, "Nur.DHCADTDischSet", "getArcim", "notAlertArcimListview", "arcimDesc", 10),
					createListView("notAlertArcimListview", tableCellWidth - 12, listViewHeight, "医嘱项")
				]
			}]
		});
	};

	Ext.getCmp("eastRegion").add(eastPanel);
	Ext.getCmp("eastRegion").doLayout();
	eastPanel.doLayout();

}

//***********************************************************************************************//

/*
	初始化设置
*/
function loadSets(setType) {
	var setType = Ext.getCmp("setType").getValue();
	var AbnormalStatGrid = Ext.getCmp("AbnormalStatGrid");
	var SelectionModel = AbnormalStatGrid.getSelectionModel();
	var rowArray = SelectionModel.getSelections();
	if (rowArray.length > 0) {
		var abnormalID = rowArray[0].get("ID")
	} else {
		var abnormalID = "";
	}
	var retJson = Ext.decode("(" + tkMakeServerCall("Nur.DHCADTDischSet", "getLoadSets", abnormalID, setType) + ")")
	addListValue(Ext.getCmp("notAlertLocListview"), retJson.notAlertLoc);
	addListValue(Ext.getCmp("notAlertOrdCatListview"), retJson.notAlertOrdCat);
	addListValue(Ext.getCmp("notAlertArcItmCatListview"), retJson.notAlertArcItmCat);
	addListValue(Ext.getCmp("notAlertArcimListview"), retJson.notAlertArcim);
	addListValue(Ext.getCmp("diagBeforeDischListview"), retJson.diagBeforeDisch);
	addListValue(Ext.getCmp("stopOrdBeforeDischListview"), retJson.stopOrdBeforeDisch);
	addListValue(Ext.getCmp("arcItmChartBeforeDischListview"), retJson.arcItmChartBeforeDisch);
	addListValue(Ext.getCmp("arcimBeforeTransListview"), retJson.arcimBeforeTrans);
	addListValue(Ext.getCmp("dischargeNeedArcimListview"), retJson.dischargeNeedArcim);
	addListValue(Ext.getCmp("deathDischargeNeedArcimListview"), retJson.deathDischargeNeedArcim);
	addListValue(Ext.getCmp("tomorrowDischListview"), retJson.tomorrowDischArcim);

	addCheckBoxValue(Ext.getCmp("ifCanDisch"), retJson.ifCanDisch);
	addCheckBoxValue(Ext.getCmp("ifTakeDisDrug"), retJson.ifTakeDisDrug);
	addCheckBoxValue(Ext.getCmp("ifAlertLonOld"), retJson.ifAlertLonOld);
	addCheckBoxValue(Ext.getCmp("ifGetDischgDateTimeByDoc"), retJson.ifGetDischgDateTimeByDoc);
	addCheckBoxValue(Ext.getCmp("ifGetAdmDateTimeByBed"), retJson.ifGetAdmDateTimeByBed);
	//addCheckBoxValue(Ext.getCmp("ifStopLongOrd"), retJson.ifStopLongOrd);
	addCheckBoxValue(Ext.getCmp("ifNeedLocWardRelation"), retJson.ifNeedLocWardRelation);
}
/*
	刷新指定的 listView
*/
function refreshListView() {}
/*
	设置checkBox的值
*/
function addCheckBoxValue(checkBox, value) {
	if (!checkBox) return;
	if (value == "N" || value == "") {
		checkBox.setValue(false);
	} else {
		checkBox.setValue(true);
	}
}
/*
	设置listview的值
*/
function addListValue(ListView, valueStr) {
	if (!ListView) return;
	
	ListView.getStore().removeAll();
	var valDet = valueStr.split("^")
	for (var i = 0; i < valDet.length; i++) {
		var value = valDet[i];
		var ID = value.split("@")[0];
		var value = value.split("@")[1];
		var store = ListView.getStore();
		if (!ifExistRecord(store, ID)) {
			var record = new Ext.data.Record({
				ID: ID,
				value: value
			})
			store.insert(store.getCount(), record);
		}
	}
}
/*
	获取listview里面的ID串
*/
function getIDStr(ListView) {
	if (!ListView) {
		return "";
	}
	var IDStr = ""
	var store = ListView.getStore();
	var count = store.getCount();
	for (var index = 0; index < count; index++) {
		var ID = store.getAt(index).get("ID");
		if (ID == "") {
			continue;
		} else {
			if (IDStr == "") {
				IDStr = ID;
			} else {
				IDStr = IDStr + "^" + ID;
			}
		}
	}
	return IDStr;
}
/*
	判断listbox里面是否已存在该ID
*/
function ifExistRecord(store, ID) {
	var count = store.getCount();
	for (var i = 0; i < count; i++) {
		if (store.getAt(i).get("ID") == ID) {
			return true;
		}
	}
	return false;
}
/*
	新增
*/
function addAbnormalStat() {
	var store = Ext.getCmp("AbnormalStatGrid").getStore();
	var count = store.getCount();
	var record = new Ext.data.Record({
		ID: '',
		abNormalStat: '',
		ifAlert: 'Y',
		alertSeq: '',
		methodName: ""
	});
	store.insert(count, record)
}
/*
	删除
*/
function deleteAbnormalStat() {

	var AbnormalStatGrid = Ext.getCmp("AbnormalStatGrid");
	var SelectionModel = AbnormalStatGrid.getSelectionModel();
	var rowArray = SelectionModel.getSelections();
	if (rowArray.length == 0) {
		Ext.MessageBox.show({
			title: "标题",
			msg: "请选择要删除的选项"
		})
		return;
	}
	Ext.MessageBox.confirm("确认", "是否确定删除所选项？", function(btId) {
		if (btId == "yes") {
			var setType = Ext.getCmp("setType").getValue();

			var AbnormalStatIdStr = "";
			for (var i = 0; i < rowArray.length; i++) {
				var rowRecord = rowArray[i];
				var AbnormalStatID = rowRecord.get("ID")
				if (AbnormalStatIdStr == "") {
					AbnormalStatIdStr = AbnormalStatID;
				} else {
					AbnormalStatIdStr = AbnormalStatIdStr + "^" + AbnormalStatID;
				}
			}
			if (AbnormalStatIdStr != "") {
				var retStr = tkMakeServerCall("Nur.DHCADTDischSet", "deleteAbnormalStat", AbnormalStatIdStr, setType);
				if (retStr == "0") {
					Ext.MessageBox.alert("<提示>", "操作成功！");
				} else {
					Ext.MessageBox.alert("<提示>", retStr);
				}
			}
			refresh();
		}
	})

}
/*
	保存设置
*/
function saveSet() {
	var setType = Ext.getCmp("setType").getValue();
	var AbnormalStatGrid = Ext.getCmp("AbnormalStatGrid");
	var SelectionModel = AbnormalStatGrid.getSelectionModel();
	var rowArray = SelectionModel.getSelections();
	if (rowArray.length > 1) {
		Ext.MessageBox.alert("<提示>", "请单选一条未处理情况！");
		return;
	}
	if (rowArray.length > 0) {
		var abnormalID = rowArray[0].get("ID")
	} else {
		var abnormalID = "";
	}
	//ListView	
	var notAlertLoc = getIDStr(Ext.getCmp("notAlertLocListview")); //1
	var notAlertOrdCat = getIDStr(Ext.getCmp("notAlertOrdCatListview")); //2
	var notAlertArcItmCat = getIDStr(Ext.getCmp("notAlertArcItmCatListview")); //3
	var notAlertArcim = getIDStr(Ext.getCmp("notAlertArcimListview")); //4

	var diagBeforeDisch = getIDStr(Ext.getCmp("diagBeforeDischListview")); //5
	var stopOrdBeforeDisch = getIDStr(Ext.getCmp("stopOrdBeforeDischListview")); //6
	var arcItmChartBeforeDisch = getIDStr(Ext.getCmp("arcItmChartBeforeDischListview")); //7
	var arcimBeforeTrans = getIDStr(Ext.getCmp("arcimBeforeTransListview")); //8

	var dischargeNeedArcim = getIDStr(Ext.getCmp("dischargeNeedArcimListview")); //9

	var deathDischargeNeedArcim = getIDStr(Ext.getCmp("deathDischargeNeedArcimListview")); //10
	
	var tomorrowDischArcims = getIDStr(Ext.getCmp("tomorrowDischListview")); 
	//CheckBox
	var ifCanDisch = (Ext.getCmp("ifCanDisch") ? (Ext.getCmp("ifCanDisch").getValue() == true ? "Y" : "N") : "") //11
	var ifTakeDisDrug = (Ext.getCmp("ifTakeDisDrug") ? (Ext.getCmp("ifTakeDisDrug").getValue() == true ? "Y" : "N") : "") //12
	var ifAlertLonOld = (Ext.getCmp("ifAlertLonOld") ? (Ext.getCmp("ifAlertLonOld").getValue() == true ? "Y" : "N") : "") //13
	var ifGetDischgDateTimeByDoc = (Ext.getCmp("ifGetDischgDateTimeByDoc") ? (Ext.getCmp("ifGetDischgDateTimeByDoc").getValue() == true ? "Y" : "N") : "") //13
	var ifGetAdmDateTimeByBed = (Ext.getCmp("ifGetAdmDateTimeByBed") ? (Ext.getCmp("ifGetAdmDateTimeByBed").getValue() == true ? "Y" : "N") : "") //14
	//var ifStopLongOrd = (Ext.getCmp("ifStopLongOrd") ? (Ext.getCmp("ifStopLongOrd").getValue() == true ? "Y" : "N") : "") //15
	var ifNeedLocWardRelation = (Ext.getCmp("ifNeedLocWardRelation") ? (Ext.getCmp("ifNeedLocWardRelation").getValue() == true ? "Y" : "N") : "") //16

	var saveStr = notAlertLoc + "#" +
		notAlertOrdCat + "#" +
		notAlertArcItmCat + "#" +
		notAlertArcim + "#" +
		diagBeforeDisch + "#" +
		stopOrdBeforeDisch + "#" +
		arcItmChartBeforeDisch + "#" +
		arcimBeforeTrans + "#" +
		dischargeNeedArcim + "#" +
		deathDischargeNeedArcim + "#" +
		ifCanDisch + "#" +
		ifTakeDisDrug + "#" +
		ifAlertLonOld + "#" +
		"" + "#" +
		ifNeedLocWardRelation + "#" +
		ifGetDischgDateTimeByDoc+ "#" +
		ifGetAdmDateTimeByBed+"#"+
		tomorrowDischArcims;
	var retStr = tkMakeServerCall("Nur.DHCADTDischSet", "saveSets", saveStr, abnormalID, setType);
	if (retStr == 0) {
		Ext.MessageBox.alert("<提示>", " 保存成功！");
	} else {
		Ext.MessageBox.alert("<提示>", retStr);
	}

}
/*
	刷新
*/
function refresh() {
	var setType = Ext.getCmp("setType").getValue();
	initRightPanel(setType);
	loadData(Ext.getCmp("AbnormalStatGrid"), {
		className: "Nur.DHCADTDischSet",
		methodName: "getAbnormalStat",
		parameter1: setType
	})
	Ext.getCmp("AbnormalStatGrid").getSelectionModel().clearSelections();
	loadSets(setType);
}
/*
	保存AbnormalStat
*/
function saveAbnormalStatSet() {
	var saveStr = ""
	var setType = Ext.getCmp("setType").getValue();
	var store = Ext.getCmp("AbnormalStatGrid").getStore();
	var columnModel = Ext.getCmp("AbnormalStatGrid").getColumnModel()
	var count = store.getCount();
	//getAt()
	for (var index = 0; index < count; index++) {
		var rowRecord = store.getAt(index);
		var modefiedFlag = false;
		var dataStr = "";
		for (var key in rowRecord.data) {
			if (rowRecord.isModified(key) == true) {
				modefiedFlag = true;
			}
			var cellVal = rowRecord.get(key);

			dataStr = dataStr + "^" + cellVal;
		}

		dataStr = dataStr.substring(1, dataStr.length)
		if (modefiedFlag) {
			if (!rowRecord.get("alertSeq")) {
				Ext.MessageBox.alert("<提示>", "提示顺序不能为空!");
				return;
			}
			if (existAlertSeq(rowRecord)) {

				Ext.MessageBox.alert("<提示>", "提示顺序有重复，请核对！!");
				return;
			}
			if (rowRecord.get("abNormalStat") == "") {
				Ext.MessageBox.alert("<提示>", "未处理情况不能为空!");
				return;
			}
			if (saveStr == "") {
				saveStr = dataStr;
			} else {
				saveStr = saveStr + "|" + dataStr
			}
		}
	}
	if (saveStr != "") {
		var retStr = tkMakeServerCall("Nur.DHCADTDischSet", "saveAbnormalStat", saveStr, setType);
		if (retStr == 0) {
			Ext.MessageBox.alert("<提示>", " 保存成功！");
		} else {
			Ext.MessageBox.alert("<提示>", retStr);
		}
	}
	refresh();
}

function existAlertSeq(rec) {
	//alertSeq
	var alsq = rec.get("alertSeq");
	var store = Ext.getCmp("AbnormalStatGrid").getStore();
	var count = store.getCount();
	for (var i = 0; i < count; i++) {
		var recore = store.getAt(i);
		if (recore == rec) continue;
		var alertSeq = recore.get("alertSeq");
		if (alertSeq == alsq) return true;
	}
	return false;
}
//***********************************************************************************************//

/*
Store
*/

function loadData(obj, params) {
	obj.getStore().load({
		params: params
	})
}

function createStore(basePar, fields) {
	var store = new Ext.data.JsonStore({
		url: "../csp/dhc.nurse.extjs.getdata.CSP",
		root: "rowData",
		fields: fields,
		baseParams: basePar
	});
	return store;
}
Ext.onReady(function() {
	onReady();
	loadData(Ext.getCmp("AbnormalStatGrid"), {
			className: "Nur.DHCADTDischSet",
			methodName: "getAbnormalStat",
			parameter1: "Disch"
		})
	setTimeout("loadSets('Disch');", 500 )
})