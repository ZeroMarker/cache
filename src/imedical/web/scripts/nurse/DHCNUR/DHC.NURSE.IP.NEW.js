/// Creator:      pengjunfu
/// CreatDate:    2014.04.03
/// Description:  执行界面


Ext.onReady(function() {
	var url = "../csp/dhc.nurse.extjs.getdata.csp";
	var getOrderUrl = "../csp/dhcnuripexeclistnew.csp";
	var CreateStore = function(className, methodName) {
		var store = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url: url
			}),
			reader: new Ext.data.JsonReader(eval("(" + tkMakeServerCall("Nur.ExtCore", "Generate", className, methodName) + ")")),
			baseParams: {
				className: className,
				methodName: methodName
			}
		});

		// paramsArray=paramsArray+","
		return store;
	}
	var CreateComboBox = function(id, displayField, valueField, fieldLabel, value, width, className, methodName) {
		var combox = new Ext.form.ComboBox({
			store: CreateStore(className, methodName),
			displayField: displayField,
			valueField: valueField,
			fieldLabel: fieldLabel,
			id: id,
			value: value,
			width: width,
			// hideTrigger: true,
			queryParam: "parameter1",
			forceSelection: true,
			triggerAction: 'all',
			minChars: 0,
			pageSize: 10,
			typeAhead: false,
			typeAheadDelay: 1000,
			loadingText: 'Searching...'
		})
		combox.on("expand", function(comboBox) {
			comboBox.list.setWidth(250);
			comboBox.innerList.setWidth(250);
		}, this, {
			single: true
		})
		return combox;
	};
	var locCombo = CreateComboBox('ctlocDr', 'ctlocDesc', 'ctlocId', '科室', "", 90, 'Nur.NurseExcute', 'getLoc');
	var wardCombo = CreateComboBox('wardDr', 'desc', 'rw', '病区', "", 90, 'Nur.NurseExcute', 'GetWard');
	var arcimCombo = CreateComboBox('arcimDr', 'ArcimDesc', 'ArcimDR', '医嘱项', "", 150, 'Nur.NurseExcute', 'FindMasterItem');

	var treeLoader = new Ext.tree.TreeLoader({
		dataUrl: url
	});
	treeLoader.on("beforeload", function(treeLoader) {
		treeLoader.baseParams.className = "Nur.NurseExcute";
		treeLoader.baseParams.methodName = "GetPatientTree";
		var wardId = wardCombo.getValue();
		if (wardId == "") {
			wardId = session['LOGON.WARDID']
		}
		treeLoader.baseParams.parameter1 = wardId;
		treeLoader.baseParams.parameter2 = EpisodeID;
		treeLoader.baseParams.parameter3 = Ext.getCmp("ckbGroup").getValue()
		treeLoader.baseParams.parameter4 = session['LOGON.CTLOCID'];
		treeLoader.baseParams.parameter5 = Ext.getCmp("startDate").getRawValue();
		treeLoader.baseParams.parameter6 = Ext.getCmp("endDate").getRawValue();
	});
	var treeRoot = new Ext.tree.AsyncTreeNode({
		checked: false,
		text: "全病区",
		iconCls: 'all'
	});
	var patientTree = new Ext.tree.TreePanel({
		root: treeRoot,
		// animate : true,
		// frame:true,
		tbar: [
			"专业组排序:", {
				xtype: 'checkbox',
				id: 'ckbGroup'
			}
		],
		autoScroll: true,
		id: 'patientTree',
		rootVisible: true,
		height: 100,
		width: 200,
		region: "west",
		// collapsible:true,
		containerScroll: true,
		autoScroll: true,
		loader: treeLoader
	});
	var startDateField = {
		xtype: 'datefield',
		id: 'startDate',
		format: 'Y-m-d'
	};
	var startTimeField = {
		xtype: 'timefield',
		id: 'startTime',
		width: 80,
		format: 'G:i'
		// format : 'Y-m-d'
	};
	var endDateField = {
		// layout:'form',
		xtype: 'datefield',
		id: 'endDate',
		format: 'Y-m-d'

		// value : session['today']
	};
	var endTimeField = {
		// layout:'form',
		xtype: 'timefield',
		width: 80,
		id: 'endTime',
		format: 'G:i'
		// format : 'Y-m-d'
		// value : session['today']
	};

	var searchPanel1 = {
		defaults: {
			margins: '0 5 0 5'
		},
		layout: 'hbox',
		layoutConfig: {
			padding: '2',
			align: "middle"
		},
		items: [{
				xtype: "label",
				text: "开始时间:"
			},
			startDateField,
			startTimeField, {
				xtype: "label",
				text: "结束时间:"
			},
			endDateField,
			endTimeField, {
				xtype: "label",
				text: "科室:"
			},
			locCombo, {
				xtype: "label",
				text: "病区:"
			},
			wardCombo, {
				xtype: "label",
				text: "医嘱项:"
			},
			arcimCombo
		]
	};
	var searchPanel2 = {
		defaults: {
			margins: '0 5 0 5'
		},
		layout: 'hbox',
		layoutConfig: {
			padding: '2',
			align: "middle"
		},
		items: [{
			xtype: 'label',
			text: '医生医嘱:'
		}, {
			xtype: 'checkbox',
			id: 'docTyp',
			checked: true
		}, {
			xtype: 'label',
			text: '已执行/已处理:'
		}, {
			xtype: 'checkbox',
			id: 'ckbExecute',
			text: '已执行:'
		}, {
			xtype: 'label',
			text: '新医嘱:'
		}, {
			xtype: 'checkbox',
			id: 'ckbNew'
		}, {
			xtype: 'label',
			text: '未执行:'
		}, {
			xtype: 'checkbox',
			id: 'ckbUnExec'
		}, {
			xtype: 'label',
			text: '长期医嘱:'
		}, {
			xtype: 'checkbox',
			id: 'ckbLong'
		}, {
			xtype: 'label',
			text: '临时医嘱:'
		}, {
			xtype: 'checkbox',
			id: 'ckbTemp'
		}, {
			xtype: 'label',
			text: 'PRN医嘱:'
		}, {
			xtype: 'checkbox',
			id: 'ckbPrnOrd'
		}, {
			xtype: 'button',
			id: 'btnSearch',
			text: '查询',
			width: 100,
			handler: function() {
				InitializeSearchData();
			}
		}]
	};
	var sm = new Nurse.grid.CheckboxSelectionModel();

	var expander = new Ext.grid.RowExpander({
		tpl: new Ext.Template(
			'<div class="detailData" style="padding-left:19px">',
			'</div>'
		),
		expandOnEnter:false
	});

	var orderGrid = new Nurse.grid.GridPanel({
		id: "orderGrid",
		plugins: expander,
		sm: sm,
		tbar: {},
		stripeRows: true,
		loadMask: true
	});
	var scrollerMenu = new Ext.ux.TabScrollerMenu({
		maxText  : 15,
		pageSize : 15
	});
	var tabs = new Ext.TabPanel({
		id: "tabVarTyp",
		enableTabScroll: true,
		autoWidth: true,
		plugins:[scrollerMenu],
		scrollIncrement: 500
	});
	var InitializeForm = function() {


		var searchPanel = new Ext.FormPanel({
			items: [
				searchPanel1,
				searchPanel2
			]
		});
		var viewPort = new Ext.Viewport({
			layout: 'border',
			defaults: {
				frame: true
			},
			items: [{
					region: 'north',
					height: 80,
					items: searchPanel
				},
				patientTree, {
					region: 'center',
					layout: 'fit',
					title: getDsposeStatColor(),
					items: tabs
				}
			]
		});
	}

	var getDsposeStatColor = function() {
		var str = "<table>" + "<tr>" + "<TD noWrap><label id='cColorLongNew'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: #ffc0c0'>新开长期医嘱</label></TD>" + "<TD noWrap><label id='cColorTemp'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: yellow'>新开临时医嘱</label></TD>" + "<TD noWrap><label id='cColorImmediate'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: green'>新开即刻医嘱</label></TD>" + "<TD noWrap><label id='cColorPreDiscon'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: #a0a0a0'>预停医嘱</label></TD>" + "<TD noWrap><label id='cColorDiscontinue'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: deepskyblue'>停止需处理</label></TD>" + "<TD noWrap><label id='cColorExecDiscon'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: #8080c0'>停止已处理</label></TD>" + "<TD noWrap><label id='cColorLongUnnew'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: #ffd0ff'>非新长嘱</label></TD>" + "<TD noWrap><label id='cColorSkinTest'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: red'>皮试医嘱</label></TD>" + "<TD noWrap><label id='cColorExec'  style='BORDER-RIGHT: silver 1px solid; BORDER-TOP: silver 1px solid; BORDER-LEFT: silver 1px solid; WIDTH: 85px; BORDER-BOTTOM: silver 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: #dfdfff'>已执行医嘱</label></TD>" + "</tr>" + " </table>"
		return str;
	}

var setTabSearchDateTime =function() {
		var tab = Ext.getCmp("tabVarTyp").getActiveTab();
		var varStr = tab.id.split("@");
		var quertDateTime=tkMakeServerCall("Nur.NurseExcute","getVarTypeSettingDateTime",varStr[0],varStr[1])
		var quertDateTimeArr=quertDateTime.split("^");
		Ext.getCmp("startDate").setValue(quertDateTimeArr[0])
		Ext.getCmp("startTime").setValue(quertDateTimeArr[1])
		Ext.getCmp("endDate").setValue(quertDateTimeArr[2])
		Ext.getCmp("endTime").setValue(quertDateTimeArr[3])
	}

	var InitializeValue = function() {

		// alert(tkMakeServerCall("web.DHCLCNUREXCUTE",
		// "GetUserWardId",session['LOGON.USERID'], session['LOGON.CTLOCID'],""))
		// 初始化日期初始值
		Ext.getCmp("startDate").setValue(session['today']);
		Ext.getCmp("endDate").setValue(session['today']);
		Ext.getCmp("startTime").setValue("0");
		//20121223Ext.getCmp("endTime").setValue("12:00");
		Ext.getCmp("endTime").setValue("23:59");

		// 初始化病区科室初始值
		var wardLocInfo = tkMakeServerCall("web.DHCLCNUREXCUTE", "GetUserWardId", session['LOGON.USERID'], session['LOGON.CTLOCID'], "").split("|");
		var wardInfo = wardLocInfo[0].split("^");
		var locInfo = wardLocInfo[1].split("^");
		locCombo.getStore().load({
			params: {
				start: 0,
				limit: 10,
				parameter1: locInfo[0]
			},
			callback: function(record, options, sussce) {
				if (record.length != 0) {
					locCombo.setValue(locInfo[1]).fireEvent("select", locCombo, locCombo.getStore().getAt(0))
				}

			}
		});
		var wardComboLoad = function(ctlocId) {
			wardCombo.getStore().load({
				params: {
					start: 0,
					limit: 10,
					parameter1: ctlocId
				},
				callback: function(record, options, sussce) {
					if (record.length != 0) {
						wardCombo.setValue(record[0].get("rw")).fireEvent("select", wardCombo, wardCombo.getStore().getAt(0))
					}

				}
			});
		};
		//选择科室刷新病区
		locCombo.on("select", function(combox, record, index) {
			wardComboLoad(record.get("ctlocId"));
		});
		wardCombo.getStore().on("beforeload", function(store, options) {
			options.params.start = 0;
			options.params.limit = 10;
			options.params.parameter1 = locCombo.getValue();
		});

		//选择病区刷新病人列表
		wardCombo.on("select", function(combox, record, index) {

			treeLoader.load(patientTree.getRootNode(), function() {
				patientTree.expandAll();
			});

		});

		// 初始化执行单据页签
		var str = tkMakeServerCall("web.DHCCLNURSET", "GetUserGroupAccess", session['LOGON.GROUPID'], session['LOGON.USERID'],"newSheet");
		var arrayList = str.split("!");

		var tabList = arrayList[0].split("^");
		var tabs = Ext.getCmp("tabVarTyp");
		var defaultTabId = "";
		for (var i = 0; i < tabList.length; i++) {
			(function(info) {
				var infoDetail = info.split("|");
				tabs.add({
					title: infoDetail[1],
					layout: "fit",
					id: infoDetail[0]
				});
				if (i == 0) {
					defaultTabId = infoDetail[0];
				}
			})(tabList[i]);
		}

		// 执行单据页签点击事件
		tabs.on("tabchange", function() {
			setTabSearchDateTime()
			InitializeSearchData();
		});
		//
		// 病人列表数的点击事件
		patientTree.on("click", function(node) {
			if ((!arguments[1]) != true) {
				node.getUI().toggleCheck();
			}
			var childNodeArray = node.childNodes;
			if (childNodeArray.length == 0) {
				return;
			}
			for (var i = 0; i < childNodeArray.length; i++) {
				childNodeArray[i].getUI().toggleCheck(node.getUI().isChecked());
				arguments.callee(childNodeArray[i], false)
			}
		});
		patientTree.on("checkchange", function(node) {
			var childNodeArray = node.childNodes;
			if (childNodeArray.length == 0) {
				return;
			}
			for (var i = 0; i < childNodeArray.length; i++) {
				childNodeArray[i].getUI().toggleCheck(node.getUI()
					.isChecked());
				arguments.callee(childNodeArray[i], false)
			}

		});
		// 病人列表双击事件
		patientTree.on("dblclick", function(node) {
			node.getUI().toggleCheck(true)
			Search_Click()
		});
		patientTree.on("load", function() {
			if (arrayList[1] != "") {
				tabs.activate(arrayList[1])
			} else {
				if (defaultTabId != "") {
					tabs.activate(defaultTabId);
				}

			};

		})

		// 专业组排序
		Ext.getCmp("ckbGroup").on("check", function() {
			var loader = patientTree.getLoader();
			loader.load(patientTree.getRootNode(), function() {
				patientTree.expandAll();
			})
		})
		// 长期临时事件
		var long = Ext.getCmp("ckbLong");
		var temp = Ext.getCmp("ckbTemp");
		long.on("check", function() {

			if (long.getValue()) {
				temp.setValue("false");
			}
		});
		temp.on("check", function() {
			if (temp.getValue()) {
				long.setValue("false");
			}
		});
		// 未执行已执行事件 合理性还没清楚？
		var Execute = Ext.getCmp("ckbExecute");
		var UnExec = Ext.getCmp("ckbUnExec");
		Execute.on("check", function() {

			if (Execute.getValue()) {
				UnExec.setValue("false");
			}
		});
		UnExec.on("check", function() {
			if (UnExec.getValue()) {
				Execute.setValue("false");
			}
		});

		var sm = Ext.getCmp("orderGrid").getSelectionModel();

		sm.on("rowdeselect", function(selectionModel, index, record) {
			if (record.json["execs"]) {
				for (var i = 0; i < record.json["execs"].length; i++) {
					record.json["execs"][i]["check"] = "0";
				};
				///检验标本号相同的同时打钩
				var labNo=record.store.data.items[index].json["labNo"];
				if (record.json["execs"]) {
				 var selectedNum = this.getCount();//取得选 中的记录数 			 
                    var pageCont = this.grid.store.getCount();//取得当前一页共多少条记录  
				for (var selectnum=0;selectnum<pageCont;selectnum++)
				{
				var labNo1=record.store.data.items[selectnum].json["labNo"];
				if ((labNo==labNo1)&&(labNo!=""))
				{
				if (this.isSelected(selectnum))
				{
				this.deselectRow(selectnum);
				}
				}
				}
				}
				//***********	
			}
			if (record.json["subGrid"] && record.json["subGrid"] != "") {
				record.json["subGrid"].getView().refresh();
			}
		});

		sm.on("rowselect", function(selectionModel, index, record) {
			if (record.json["execs"]) {
				for (var i = 0; i < record.json["execs"].length; i++) {
					record.json["execs"][i]["check"] = "1";
				};
				///检验标本号相同的同时打钩
				var labNo=record.store.data.items[index].json["labNo"];
				if (record.json["execs"]) {
				 var selectedNum = this.getCount();//取得选 中的记录数  
                    var pageCont = this.grid.store.getCount();//取得当前一页共多少条记录  
				//var isSelected = this.isSelected(selectedNum);
				for (var selectnum=0;selectnum<pageCont;selectnum++)
				{
				var labNo1=record.store.data.items[selectnum].json["labNo"];
				if ((labNo==labNo1)&&(labNo!=""))
				{
				this.selectRow(selectnum, true || e.shiftKey);
				}
				}
				}
				//***********
			}
			if (record.json["subGrid"] && record.json["subGrid"] != "") {
				record.json["subGrid"].getView().refresh();
			}
		});
		//子表格展开事件
		expander.on("expand", function(expander, r, body, i) {

			var store = new Ext.data.JsonStore({
				fields: ["prtFlag","sttDate", "sttTime","disposeStatDesc","execStatDesc","dspStat","execCtcpDesc","execDateTime","oeoreId"],
				data: r.json.execs
			});

			var subSm = new Ext.grid.CheckboxSelectionModel();

			subSm.on("rowdeselect", function(selectionModel, index, record) {
				record.json.check = 0;
			});

			subSm.on("rowselect", function(selectionModel, index, record) {
				record.json.check = 1;
			});


			var cm = new Ext.grid.ColumnModel([
				subSm, {
					header: "打印标记",
					dataIndex: 'prtFlag',
                    sortable: 'false',
					width: 90
				},{
					header: "要求执行日期",
					dataIndex: 'sttDate',
					width: 90
				}, {
					header: "要求执行时间",
					dataIndex: 'sttTime',
					width: 90
				},{
					header: "处置状态",
					dataIndex: 'disposeStatDesc',
					width: 90
				},{
					header: "执行状态",
					dataIndex: 'execStatDesc',
					width: 90
				},{
					header: "发药状态",
					dataIndex: 'dspStat',
					width: 90
				}, {
					header: "操作人",
					dataIndex: 'execCtcpDesc',
					width: 70
				},{
					header: "操作时间",
					dataIndex: 'execDateTime',
					width: 150
				},{
					header: "oeoreId",
					dataIndex: 'oeoreId',
					width: 90
				}
			]);
			var grid = new Nurse.grid.ExecGridPanel({
				store: store,
				cm: cm,
				//hideHeaders: true,
				sm: subSm,
				viewConfig: {
					rowSelector: 'div.x-subgrid3-row'
				},
				renderTo: Ext.DomQuery.select("div.detailData", body)[0],
				autoWidth: true,
				autoHeight: true,
				listeners: {
					"viewready": function(grid) {
						grid.getView().on("refresh", function() {
							var records = [];
							this.grid.getStore().each(function(record) {
								if (record.json.check == 1) {
									records[records.length] = record;

								};
							});
							this.grid.getSelectionModel().selectRecords(records);
						})
						grid.getView().refresh();

						//Ext.get(Ext.query("div.x-grid3-header-inner",Ext.getDom(grid))[0]).setHeight(0);
					}
				}
			});
			r.json["subGrid"] = grid;

		});
		expander.on("collapse", function(expander, r, body, i) {
			var grid = r.json["subGrid"];
			grid.destroy();
			r.json["subGrid"] = "";
		});
	};

	//重新点击事件不用按ctrl也能多选
	Ext.grid.RowSelectionModel.prototype.handleMouseDown = function(g, rowIndex, e) {
		if (e.button !== 0 || this.isLocked()) {
			return;
		}
		var view = this.grid.getView();
		if (e.shiftKey && !this.singleSelect && this.last !== false) {
			var last = this.last;
			this.selectRange(last, rowIndex, true);
			this.last = last; // reset the last
			view.focusRow(rowIndex);
		} else {
			var isSelected = this.isSelected(rowIndex);
			if (true && isSelected) {
				this.deselectRow(rowIndex);
			} else if (!isSelected || this.getCount() > 1) {
				this.selectRow(rowIndex, true || e.shiftKey);
				view.focusRow(rowIndex);
			}
		}
	};


	var InitializeSearchData = function() {

		var tab = Ext.getCmp("tabVarTyp").getActiveTab();
		var varStr = tab.id.split("@");
		var pats = Ext.getCmp("patientTree").getChecked("id");
		var patsAdm;
		if (pats.length == 0) {
			patsAdm = EpisodeID
		} else {
			patsAdm = pats.join("^")
		}
		var orderGridStore = new Ext.data.JsonStore({
			url: getOrderUrl,
			root: "data",
			id: "orderGridStore",
			fields: Ext.decode(tkMakeServerCall("Nur.NurseExcute", "getJsonField", varStr[0], varStr[1]))
		});

		var cms = Ext.decode(tkMakeServerCall("Nur.NurseExcute", "getColumnModel", varStr[0], varStr[1]));
		var cmArray = new Array();
		cmArray.push(sm);
		//需处理医嘱不需要弹出执行grid
		if (varStr[1] != "DefaultSee") {
			cmArray.push(expander);
		}

		//每一列的重新渲染
		for (var i = 0; i < cms.length; i++) {
			if (cms[i]["dataIndex"] == "placerNo") {
				cms[i]["renderer"] = function(v, p, r, rowIndex, i, ds) {
					return "<input type='text' value='" + v + "'onkeydown='setPlacerNo(\""+rowIndex+"\")'>";
				}
			}
			if (cms[i]["dataIndex"] == "arcimDesc") {
				cms[i]["renderer"] = function(v, p, r, rowIndex, i, ds) {
					var info=""
					if(r.json["notifyClinician"]=="Y"){
						//检验加急
						info="<font size=5 color='red'>(急)</font>";
					}
					if(r.json["skinTestInfo"]!=""){
						//皮试
						var color="";
						if(r.json["skinTestInfo"].indexOf("+")>-1){
							color="red";
						}else if(r.json["skinTestInfo"].indexOf("-")>-1){
							color="green";
						}
						info="<font size=5 color='"+color+"'>"+r.json["skinTestInfo"]+"</font>";
						
					}
					if(r.json["tubeColor"]!=""){

						//v="<font color='"+r.json["tubeColor"]+"'>"+v+"</font>";
						p.css=r.json["tubeColor"]
					}
					return v+info;
					
				}
			}
			cmArray.push(cms[i]);

		};
		var cm = new Ext.grid.ColumnModel({
			columns: cmArray
		});
		orderGrid.reconfigure(orderGridStore, cm);
		tab.add(orderGrid);
		tab.doLayout();
		var topBar = orderGrid.getTopToolbar();
		topBar.removeAll();
		var button = eval("(" + tkMakeServerCall("Nur.NurseExcute", "getButtons", varStr[0], varStr[1]) + ")");
		for (var i = 0; i < button.length; i++) {
			(function(button, queryType) {
				topBar.add({
					text: button["name"],
					handler: function() {
						var singleVerify = button["singleVerify"];
						var doubleVerify = button["doubleVerify"];
						var operationType = button["operationType"];

						session['startDate'] = Ext.getCmp("startDate").getRawValue();
						session['startTime'] = Ext.getCmp("startTime").getRawValue();
						session['endDate'] = Ext.getCmp("endDate").getRawValue();
						session['endTime'] = Ext.getCmp("endTime").getRawValue();

						if (clearOperationObject) {
							clearOperationObject();
							
						}
						if ((singleVerify == "Y") || (doubleVerify == "Y")) {
							verify(Func[button["handle"]], queryType, operationType, singleVerify)
						} else {
                                                        var operationTypeCode=tkMakeServerCall("Nur.NurseOperationType", "getTypeCode",operationType);
						if (operationTypeCode=="Print")
						{
						var object = createConfirmObject();
					    object.userId1 = session['LOGON.USERID'];
                        Func[button["handle"]](queryType, operationType, object);
						}
						else
						{
						    verify(Func[button["handle"]], queryType, operationType, singleVerify,"true")
							}
						}
						

					}
				});
			})(button[i], varStr[1])
		}

		topBar.doLayout();
		orderGridStore.load({
			params: {
				patsAdm: patsAdm,
				hospitalRowId: varStr[0],
				varType: varStr[1],
				ctlocId: Ext.getCmp("ctlocDr").getValue(),
				wardId: Ext.getCmp("wardDr").getValue(),
				startDate: Ext.getCmp("startDate").getRawValue(),
				endDate: Ext.getCmp("endDate").getRawValue(),
				startTime: Ext.getCmp("startTime").getRawValue(),
				endTime: Ext.getCmp("endTime").getRawValue(),
				doctorOrder: Ext.getCmp("docTyp").getValue(),
				arcimDr: Ext.getCmp("arcimDr").getValue(),
				excuteOrder: Ext.getCmp("ckbExecute").getValue(),
				longOrder: Ext.getCmp("ckbLong").getValue(),
				tempOrder: Ext.getCmp("ckbTemp").getValue(),
				newOrder: Ext.getCmp("ckbNew").getValue(),
				unExecOrder: Ext.getCmp("ckbUnExec").getValue(),
				prnOrder: Ext.getCmp("ckbPrnOrd").getValue()
			},
			callback: function(records, options, success) {
				if (success === true) {
					session['startDate'] = Ext.getCmp("startDate").getRawValue();
					session['endDate'] = Ext.getCmp("endDate").getRawValue();
					session['startTime'] = Ext.getCmp("startTime").getRawValue();
					session['endTime'] = Ext.getCmp("endTime").getRawValue();
				}

				// for (i = 0; i < orderGridStore.getCount(); i++) {
				// 	var record=orderGridStore.getAt(i);
				//     			var mainRowIdx=record.json.mainOrderIndex;
				//     			var orderNum=record.json.orderNum;
				//     			if(mainRowIdx==i){
				//     				expander.toggleRow(mainRowIdx+orderNum-1,mainRowIdx);
				//     			}

				// }
			}
		});

	}



	InitializeForm();
	InitializeValue()

});