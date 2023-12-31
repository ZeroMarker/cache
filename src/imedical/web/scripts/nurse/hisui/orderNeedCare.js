//默认显示全部需关注
//var defaultTypeCode = "A";	
//用户主动触发的选中或者取消选中行index
window.onresize=function(){window.location.reload()}
var selectOrUnSelectIndex = "";
//分割的size
var chunkSize = 50;
var defaultPageSize = 25;
var defaultPageList = [25, 50, 100, 200, 500];
var ctcpType = $m({
	ClassName: "Nur.HISUI.NeedCareOrder",
	MethodName: "getCTCPType",
	userID: session['LOGON.USERID']
}, false);
var defaultTypeCode;
$(function() {
	if (EpisodeID !== "") {
		//急诊留观要根据当前选中病人获取病区和科室ID
		var currentPatientWardInfo = $m({
			ClassName: "Nur.HISUI.NeedCareOrder",
			MethodName: "getEMPatientCurrentWardInfo",
			EpisodeID: EpisodeID
		}, false)
		if (currentPatientWardInfo !== "") {
			session["LOGON.WARDID"] = currentPatientWardInfo.split("^")[0];
			session['LOGON.CTLOCID'] = currentPatientWardInfo.split("^")[1];
		}
		if (!defaultTypeCode){
			// 默认显示类型
			defaultTypeCode=$m({
				ClassName: "Nur.HISUI.NeedCareOrder",
				MethodName: "GetPatientEvent",
				EpisodeID: EpisodeID
			},false);
		}
	}
	initUI();
	// 初始化医嘱弹窗
	initEditWindow();
	if (HISUIStyleCode=="lite"){
		$(".layout-panel-west").css("border-right-color","#f5f5f5");
		$(".layout-panel-east").css("border-left-color","#f5f5f5");
		$(".layout-panel-north").css("border-top-color","#f5f5f5");
		$(".patientbar,.execDiv,.orderDiv").css("background","#f5f5f5");
		$("#execPanle").css("border-bottom-style","solid");
	}
})
	function initUI() {
		//initPatientTree();
		initOrderGrid();
		initExecGrid();
		initOrderGridSearchCondition();
		if (EpisodeID !== "") {
			//setPatientInfo(EpisodeID)
			InitPatInfoBanner(EpisodeID);
		}
	}

	function initPatientTree() {
		$('#wardPatientSearchBox').searchbox({
			searcher: function(value) {
				var wardID = session["LOGON.WARDID"];
				var locID = session['LOGON.CTLOCID'];
				$('#wardPatientTree').datagrid('reload', {
					className: "Nur.DHCADTDischarge",
					methodName: 'getWardPatListArray',
					parameter1: wardID,
					parameter2: locID,
					parameter3: value,
					parameter4: "",
					parameter5: ""
				});
			},
			prompt: $g('请输入姓名、登记号、床号')
		});
		$HUI.radio("input[name='wardPatientCondition']", {
			onChecked: function(e, value) {
				$HUI.datagrid('#wardPatientTree').clearSelections();
				$HUI.datagrid('#wardPatientTree').clearChecked();
				$HUI.datagrid('#wardPatientTree').load();
			}
		});
		var columns = [{
			field: "BedCode",
			title: $g("床号"),
			width: 45
		}, {
			field: "RegNo",
			title: $g("登记号"),
			width: 100
		}, {
			field: "PatName",
			title: $g("姓名"),
			width: 70
		}];
		$HUI.datagrid('#wardPatientTree', {
			autoSizeColumn: false,
			fit: true,
			singleSelect: true,
			url: $NURURL + '?className=Nur.DHCADTDischarge&methodName=getWardPatListArray',
			fitColumns: false,
			headerCls: 'panel-header-gray',
			columns: [columns],
			idField: 'EpisodeID',
			onBeforeLoad: function(param) {
				param.parameter1 = session['LOGON.WARDID'];
				param.parameter2 = session['LOGON.CTLOCID'];
				param.parameter3 = $HUI.searchbox('#wardPatientSearchBox').getValue() ? $HUI.searchbox('#wardPatientSearchBox').getValue() : '';
				param.parameter4 = "";
				param.parameter5 = $("input[name='wardPatientCondition']:checked").val();
			},
			onClickRow: function(index, data) {
				selectPatient(data['EpisodeID']);
			}
		});
		$HUI.datagrid('#transOutPatientTree', {
			autoSizeColumn: false,
			fit: true,
			singleSelect: true,
			url: $NURURL + '?className=Nur.DHCADTDischarge&methodName=getWardPatListArray',
			fitColumns: false,
			headerCls: 'panel-header-gray',
			columns: [columns],
			idField: 'EpisodeID',
			onBeforeLoad: function(param) {
				param.parameter1 = session['LOGON.WARDID'];
				param.parameter2 = session['LOGON.CTLOCID'];
				param.parameter3 = "";
				param.parameter4 = "Y";
			},
			onClickRow: function(index, data) {
				selectPatient(data['EpisodeID']);
			}
		});
		//修改table高度
		function setWardPatientTreeHieght() {
			var gridHeight = (document.body.scrollHeight - 165);
			$(".wardPatientDiv").find(".panel.datagrid").find(".datagrid-wrap").css("height", gridHeight + "px").find(".datagrid-view").css("height", gridHeight + "px").find(".datagrid-body").css("height", (gridHeight - 35) + "px");
			$('#wardPatientDiv').datagrid('resize', {
				height: gridHeight,
				width: 218
			});
		}

		function setTransOutPatientTreeHieght() {
			var gridHeight = (document.body.scrollHeight - 95);
			$(".transOutPatientDiv").find(".panel.datagrid").find(".datagrid-wrap").css("height", gridHeight + "px").find(".datagrid-view").css("height", gridHeight + "px").find(".datagrid-body").css("height", (gridHeight - 35) + "px");
			$('#transOutPatientTree').datagrid('resize', {
				height: gridHeight,
				width: 218
			});
		}
		setWardPatientTreeHieght();
		$HUI.accordion('.patientTree', {
			onSelect: function(title, index) {
				if (index === 0) {
					setTimeout(setWardPatientTreeHieght, 100);
				} else {
					setTimeout(setTransOutPatientTreeHieght, 100);
				}
			},
		})
	}

	function initOrderGridSearchCondition() {

		var dishTypes = $cm({
			ClassName: "Nur.HISUI.NeedCareOrderSet",
			QueryName: "getNeedCareSet",
			CareType: "D",
			PersonType: ctcpType,
			HospID:session['LOGON.HOSPID'],
			CTLocID:session['LOGON.CTLOCID'],
			FilterShow:"Y"
		}, false).rows;
		dishTypes.unshift({
			rowId: 0,
			condition: $g("全部")
		})
		var transTypes = $cm({
			ClassName: "Nur.HISUI.NeedCareOrderSet",
			QueryName: "getNeedCareSet",
			CareType: "T",
			PersonType: ctcpType,
			HospID:session['LOGON.HOSPID'],
			CTLocID:session['LOGON.CTLOCID'],
			FilterShow:"Y"
		}, false).rows;
		var allTypes = dishTypes.concat(transTypes);
		transTypes.unshift({
			rowId: 0,
			condition: $g("全部")
		});
		var transWardTypes = $cm({
			ClassName: "Nur.HISUI.NeedCareOrderSet",
			QueryName: "getNeedCareSet",
			CareType: "W",
			PersonType: ctcpType,
			HospID:session['LOGON.HOSPID'],
			CTLocID:session['LOGON.CTLOCID'],
			FilterShow:"Y"
		}, false).rows;
		allTypes = allTypes.concat(transWardTypes);
		transWardTypes.unshift({
			rowId: 0,
			condition: $g("全部")
		});
		//初始化需处理combox
		//var types = defaultTypeCode === "A" ? allTypes : (defaultTypeCode === "D" ? dishTypes : transTypes);
		var types = allTypes;
		if (defaultTypeCode === "D"){
			types = dishTypes;
		}else if(defaultTypeCode === "T"){
			types = transTypes;
		}else if(defaultTypeCode === "W"){
			types = transWardTypes;
		}
		$HUI.combobox('#orderNeedCareType', {
			valueField: 'rowId',
			textField: 'condition',
			data: types,
			value: "0",
			onSelect: function(record) {},
			formatter: function(row) {
				var text = row["condition"]
				if (row["careType"]) {
					text = $g(row["condition"]) + "(" + $g(row["careTypeDesc"]) + ")";
				}
				return text;
			},
			filter: filter
		});
		//初始化类型combox
		$HUI.combobox('#type', {
			valueField: 'code',
			textField: 'desc',
			value: defaultTypeCode,
			data: [{
				code: "A",
				desc: $g("全部")
			}, {
				code: "D",
				desc: $g("出院")
			}, {
				code: "T",
				desc: $g("转科")
			}, {
				code: "W",
				desc: $g("转病区")
			}],
			onSelect: function(record) {
				if (record["code"] === "D") {
					$HUI.combobox('#orderNeedCareType').loadData(dishTypes);
					$HUI.combobox('#orderNeedCareType').setValue(0)

				} else if (record["code"] === "T") {
					$HUI.combobox('#orderNeedCareType').loadData(transTypes);
					$HUI.combobox('#orderNeedCareType').setValue(0)
				} else if (record["code"] === "W") {
					$HUI.combobox('#orderNeedCareType').loadData(transWardTypes);
					$HUI.combobox('#orderNeedCareType').setValue(0)
				} else {
					$HUI.combobox('#orderNeedCareType').loadData(allTypes);
					$HUI.combobox('#orderNeedCareType').setValue(0)
				}
			},
			filter: filter
		});
		$HUI.combobox('#orderLoc', {
			valueField: 'code',
			textField: 'desc',
			value: "A",
			data: [{
				code: "A",
				desc: $g("全部")
			}, {
				code: "O",
				desc: $g("本科室")
			}, {
				code: "OT",
				desc: $g("其他科室")
			}],
			onSelect: function(record) {
				searchOrder();
			},
			filter: filter
		});
		$HUI.radio("input[name='orderType']", {
			onChecked: function(e, value) {
				searchOrder();
			}
		});
		$("#searchBtn").unbind("click").click(searchOrder)
	}

	function initOrderGrid() {
		var columns = [{
			field: "selection",
			title: $g("选择"),
			width: 40,
			checkbox: true
		}, {
			field: "sttDateTime",
			title: $g("开始日期"),
			width: 160
		}, {
			field: "arcimDesc",
			title: $g("医嘱"),
			width: 360,
			formatter: function(value, row, index) {
				if (row["condition"] == "") {
					return value;
				}
				var conditionHtmlArray = [];
				var controls = row["control"].split("^");
				row["condition"].split("^").forEach(function(condition, index) {
					conditionHtmlArray[index] = "<span style='color:" + (controls[index] === "Y" ? "red" : "#589DDA") + "'>" +
						$g(condition) +
						"</span>";
				});
				var conditionHtml = conditionHtmlArray.join(" ");
				if (value.length > 19) {
					return "<a href='#' title='" +
						value +
						"' class='hisui-tooltip' style='color:black' data-options='position:\"top\"'>" +
						"(" +
						$g(conditionHtml) +
						")&nbsp" +
						value +
						"</a>"
				} else {
					return "(" + conditionHtml + ")&nbsp" + value;
				}
			}
		}, {
			field: "createLoc",
			title: $g("开单科室"),
			width: 100
		}, {
			field: "reclocDesc",
			title: $g("接受科室"),
			width: 100
		}, {
			field: "ctcpDesc",
			title: $g("开医嘱人"),
			width: 80
		}, {
			field: "oecprDesc",
			title: $g("优先级"),
			width: 100
		}, {
			field: "orderStateDesc",
			title: $g("医嘱状态"),
			width: 50
		}, {
			field: "labNo",
			title: $g("标本号"),
			width: 100
		}, {
			field: "ID",
			title: $g("医嘱ID"),
			width: 70
		}];
		var toolBars = [];
		if (ctcpType === "NURSE") {
			toolBars.push({
				iconCls: 'icon-wrench-blue',
				text: $g('处理'),
				handler: function() {
					handleOrder();
				}
			})
			toolBars.push({
				iconCls: 'icon-arrow-right-top',
				text: $g('执行'),
				handler: function() {
					excuteOrder();
				}
			})
			toolBars.push({
					iconCls: 'icon-checkin',
					text: $g('领药审核'),
					handler: function() {
						durgAudit();
					}
				})
			toolBars.push({
				iconCls: 'icon-cancel-order',
				text: $g('撤销处理'),
				handler: function() {
					cancelSeeOrder();
				}
			})
				// , {
				// 	iconCls: 'icon-stop-order',
				// 	text: '停止',
				// 	handler: function() {
				// 		saveHearingScreening();
				// 	}
				// } , {
				// 	iconCls: 'icon-ignore',
				// 	text: '忽略',
				// 	handler: function() {
				// 		saveHearingScreening();
				// 	}
				// }, {
				// 	iconCls: 'icon-re-ignore',
				// 	text: '撤销忽略',
				// 	handler: function() {
				// 		saveHearingScreening();
				// 	}
				// }
		} else {
			toolBars.push({
				iconCls: 'icon-cancel-order',
				text: $g('撤销医嘱'),
				handler: function() {
					//调用医生站接口
					ipdoc.patord.view.cancelOrderHandler()
						//cancelOrder();
				}
			});
			toolBars.push({
				iconCls: 'icon-stop-order',
				text: $g('停止医嘱'),
				handler: function() {
					//调用医生站接口
					ipdoc.patord.view.stopOrderHandler()
						//cancelOrder();
				}
			})

		};
		//初始化汇总表格
		InPatOrdDataGrid = $("#orderGrid").datagrid({ //$HUI.datagrid('#orderGrid', {
			autoSizeColumn: false,
			fit: true,
			url: $NURURL + '?className=Nur.HISUI.NeedCareOrder&methodName=getAbnormalOrdList',
			fitColumns: false,
			headerCls: 'panel-header-gray',
			columns: [columns],
			idField: 'ID',
			showFooter: false,
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			pageSize: defaultPageSize,
			pageList: defaultPageList,
			toolbar: toolBars,
			border:false,
			onCheck: function(index, data) {
				if (selectOrUnSelectIndex !== "") {
					return;
				}
				selectOrUnSelectIndex = index;
				var currentSeqNo = data["seqNo"];
				var currentLabNo = data["labNo"];
				var rows = $("#orderGrid").datagrid("getRows");
				for (var i = index - 1; i >= 0; i--) {
					if (currentSeqNo === rows[i]["seqNo"]||(currentLabNo!=""&&currentLabNo==rows[i]["labNo"])) {
						$("#orderGrid").datagrid("selectRow", i);
					}
				};

				for (var i = index + 1; i < rows.length; i++) {
					if (currentSeqNo === rows[i]["seqNo"]||(currentLabNo!=""&&currentLabNo==rows[i]["labNo"])) {
						$("#orderGrid").datagrid("selectRow", i);
					}
				};
				selectOrUnSelectIndex = "";
			},
			onUncheck: function(index, data) {
				if (selectOrUnSelectIndex !== "") {
					return;
				}
				selectOrUnSelectIndex = index;
				var currentSeqNo = data["seqNo"];
				var currentLabNo = data["labNo"];
				var rows = $("#orderGrid").datagrid("getRows");
				for (var i = index - 1; i >= 0; i--) {
					if (currentSeqNo === rows[i]["seqNo"]||(currentLabNo!=""&&currentLabNo==rows[i]["labNo"])) {
						$("#orderGrid").datagrid("unselectRow", i);
					}
				};

				for (var i = index + 1; i < rows.length; i++) {
					if (currentSeqNo === rows[i]["seqNo"]||(currentLabNo!=""&&currentLabNo==rows[i]["labNo"])) {
						$("#orderGrid").datagrid("unselectRow", i);
					}
				};
				selectOrUnSelectIndex = "";
			},
			onBeforeLoad: function(param) {

				param.parameter1 = EpisodeID;
				param.parameter2 = ctcpType;
				param.parameter3 = $HUI.combobox('#type').getValue() ? $HUI.combobox('#type').getValue() : defaultTypeCode;
				param.parameter4 = $HUI.combobox('#orderNeedCareType').getValue() ? $HUI.combobox('#orderNeedCareType').getValue() : '';
				param.parameter5 = $("input[name='orderType']:checked").val();
				param.parameter6 = param.page;
				param.parameter7 = param.rows;
				param.parameter8 = $HUI.combobox('#orderLoc').getValue() ? $HUI.combobox('#orderLoc').getValue() : 'A';
			},
			onLoadSuccess: function() {
				$HUI.datagrid('#orderGrid').clearSelections();
				$HUI.datagrid('#orderGrid').clearChecked();
				$(".hisui-tooltip").tooltip();
			},
			onDblClickRow: function(index, data) {
				$("#orderGrid").datagrid("clearChecked");
				selectOrUnSelectIndex=index;
				$("#orderGrid").datagrid("checkRow", index);
	        	selectOrUnSelectIndex="";
				var abnormalType = $HUI.combobox('#type').getValue() ? $HUI.combobox('#type').getValue() : 'A';
				var abnormalID = $HUI.combobox('#orderNeedCareType').getValue() ? $HUI.combobox('#orderNeedCareType').getValue() : '';
				initExecGridSearchCondition(data, abnormalID);
				execGridLoad(data, ctcpType, abnormalType);
			}
		});
		var toolBar=$(InPatOrdDataGrid).parents(".datagrid-wrap.panel-body.panel-body-noheader").children(".datagrid-toolbar");
		toolBar.append("<span style='color:red;position: absolute;top: 8px;right: 10px;'>"+$g("红色为控制项目")+"</span>");
		toolBar.append("<span style='color:#589DDA;position: absolute;top: 8px;right: 110px;'>"+$g("蓝色为提示项目,")+"</span>");

	}

	function initExecGridSearchCondition(data, abnormalID) {
		var orderNeedCareTypes = $HUI.combobox('#orderNeedCareType').getData();
		var conditionString = "^" + data.condition + "^";
		var execTypes = [];
		orderNeedCareTypes.forEach(function(item, index) {
			if ((conditionString.indexOf("^" + item.condition+ "^") > -1) || (index === 0)) {
				var careTypeDesc=item.careTypeDesc?("("+$g(item.careTypeDesc)+")"):"";
				item.desc=$g(item.condition) + careTypeDesc ;
				execTypes.push(item);
			}
		});
		$HUI.combobox('#execType', {
			valueField: 'rowId',
			textField: 'desc',
			value: abnormalID,
			data: execTypes,
			onSelect: function(record) {},
			filter: filter
		});
		$HUI.panel("#execPanle").setTitle(data["arcimDesc"]);
		$("#execSearchBtn").unbind("click").click(searchExecOrder)
	}

	function clearOrderExecGridSearchCondition() {
		$HUI.combobox('#execType').clear();
		$HUI.combobox('#execType').loadData([]);
		$HUI.panel("#execPanle").setTitle($g("执行记录"));
	}

	function initExecGrid() {
		var columns = [{
			field: "selection",
			title: $g("选择"),
			width: 40,
			checkbox: true
		}, {
			field: "sttDateTime",
			title: $g("要求执行时间"),
			width: 120
		}, {
			field: "condition",
			title: $g("需处理情况"),
			width: 200,
			formatter: function(value, row, index) {
				var conditionHtmlArray = [];
				var controls = row["control"].split("^");
				row["condition"].split("^").forEach(function(condition, index) {
					conditionHtmlArray[index] = "<span style='color:" + (controls[index] === "Y" ? "red" : "#589DDA") + "'>" +
						$g(condition) +
						"</span>";
				});
				var conditionHtml = conditionHtmlArray.join(" ");
				return "(" + conditionHtml + ")&nbsp";
			}
		}, {
			field: "num",
			title: $g("计费数量"),
			width: 80,
			formatter: function(value, row, index) {
				return '<a style="cursor:pointer;text-decoration:underline" onclick="ipdoc.patord.view.execFeeDataShow(\'' + row.OrderExecId + '\')">' + value + '</a>';
			}
		}, {
			field: "execDateTime",
			title: $g("执行时间"),
			width: 120
		}, {
			field: "ordStatDesc",
			title: $g("执行状态"),
			width: 70
		}, {
			field: "execCtcpDesc",
			title: $g("执行人"),
			width: 100
		}, {
			field: "examPartInfo",
			title: $g("检查部位"),
			width: 80
		}];
		var toolBars = [];
		if (ctcpType === "NURSE") {
			toolBars.push({
				iconCls: 'icon-arrow-right-top',
				text: $g('执行'),
				handler: function() {
					excuteOrderExec();
				}
			})
			toolBars.push({
				iconCls: 'icon-checkin',
				text: $g('领药审核'),
				handler: function() {
					drugDetailsAudit();
				}
			})
			/*
			//停止执行在发布时隐藏
			toolBars.push({
				iconCls: 'icon-stop-order',
				text: $g('停止执行'),
				handler: function() {
					var orderExecIDArray = [];
					var notOwnLocOrderArray = [];
					var rowsData = $HUI.datagrid('#execGrid').getSelections();
					for (var i = 0; i < rowsData.length; i++) {
						var rowData = rowsData[i];
						var condition = rowData["condition"];
						if (rowData["ownLocOrderFlag"] == 0) {
							notOwnLocOrderArray.push(rowData);
							continue;
						}
						var orderExecID = rowData['ID'];
						orderExecIDArray.push(orderExecID);
					}
					if (orderExecIDArray.length === 0) {
						if (notOwnLocOrderArray.length != 0) {
							$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
						}
						return;
					}
					ipdoc.patord.view.stopExecOrderHandler();
				}
			})*/
			toolBars.push({
					iconCls: 'icon-stop-order',
					text: $g('撤销执行并停止'),
					handler: function() {
						var orderExecIDArray = [];
						var notOwnLocOrderArray = [];
						var rowsData = $HUI.datagrid('#execGrid').getSelections();
						for (var i = 0; i < rowsData.length; i++) {
							var rowData = rowsData[i];
							var condition = rowData["condition"];
							if (rowData["ownLocOrderFlag"] == 0) {
								notOwnLocOrderArray.push(rowData);
								continue;
							}
							var orderExecID = rowData['ID'];
							orderExecIDArray.push(orderExecID);
						}
						if (orderExecIDArray.length === 0) {
							if (notOwnLocOrderArray.length != 0) {
								$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
							}
							return;
						}
						ipdoc.patord.view.cancelAndstopExecOrderHandler();
					}
				})
			toolBars.push({
				iconCls: 'icon-back',
				text: $g('撤销执行'),
				handler: function() {
					cancelExecuteOrderExec();
				}
			})
				// , {
				// 	iconCls: 'icon-stop-order',
				// 	text: '停止',
				// 	handler: function() {
				// 		saveHearingScreening();
				// 	}
				// } , {
				// 	iconCls: 'icon-ignore',
				// 	text: '忽略',
				// 	handler: function() {
				// 		saveHearingScreening();
				// 	}
				// }, {
				// 	iconCls: 'icon-re-ignore',
				// 	text: '撤销忽略',
				// 	handler: function() {
				// 		saveHearingScreening();
				// 	}
				// }
		} else {
			toolBars="";
		}
		InPatOrdExecDataGrid = $("#execGrid").datagrid({ //{$HUI.datagrid('#execGrid', {
			autoSizeColumn: false,
			fit: true,
			url: $NURURL + '?className=Nur.HISUI.NeedCareOrder&methodName=getAbnormalOrdExecList',
			fitColumns: false,
			headerCls: 'panel-header-gray',
			columns: [columns],
			idField: 'ID',
			showFooter: false,
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			pageSize: defaultPageSize,
			pageList: defaultPageList,
			toolbar: toolBars,
			border:false,
			onBeforeLoad: function(param) {
				$HUI.datagrid('#execGrid').clearSelections();
				$HUI.datagrid('#execGrid').clearChecked();
				param.parameter4 = $HUI.combobox('#execType').getValue() ? $HUI.combobox('#execType').getValue() : '';
				param.parameter5 = param.page;
				param.parameter6 = param.rows;
			},
			onLoadSuccess: function() {
				$HUI.datagrid('#execGrid').clearSelections();
				$HUI.datagrid('#execGrid').clearChecked();
			}
		});
	}

	function execGridLoad(order, ctcpType, abnormalType, abnormalID) {
		$HUI.datagrid('#execGrid').clearSelections();
		$HUI.datagrid('#execGrid').clearChecked();
		$HUI.datagrid('#execGrid').load({
			parameter1: order["ID"],
			parameter2: ctcpType,
			parameter3: abnormalType,
		});
	}

	function searchExecOrder() {
		$HUI.datagrid('#execGrid').clearSelections();
		$HUI.datagrid('#execGrid').clearChecked();
		$HUI.datagrid('#execGrid').load();
	}
	function patientTreeCheckChangeHandle(){
		selectPatient(EpisodeIDStr);	
	}
	function selectPatient(EpisodeID) {
		if (!EpisodeID || (typeof EpisodeID === "object")) {
			EpisodeID = window.EpisodeID;
		}
		window.EpisodeID = EpisodeID;
		//setPatientInfo(EpisodeID);
		InitPatInfoBanner(EpisodeID);
		//重置医嘱查询条件
		initOrderGridSearchCondition();
		//清空医嘱表格,重新查询
		$HUI.datagrid('#orderGrid').clearSelections();
		$HUI.datagrid('#execGrid').clearChecked();
		$HUI.datagrid('#orderGrid').load();
		//重置执行记录查询条件
		clearOrderExecGridSearchCondition();
		//清空医嘱执行记录表格
		$HUI.datagrid('#execGrid').clearSelections();
		$HUI.datagrid('#execGrid').clearChecked();
		$HUI.datagrid('#execGrid').loadData([]);
	}

	function searchOrder() {
		//清空医嘱表格,重新查询
		$HUI.datagrid('#orderGrid').clearSelections();
		$HUI.datagrid('#orderGrid').clearChecked();
		$HUI.datagrid('#orderGrid').load();
		//重置执行记录查询条件
		clearOrderExecGridSearchCondition();
		//清空医嘱执行记录表格
		$HUI.datagrid('#execGrid').clearSelections();
		$HUI.datagrid('#execGrid').clearChecked();
		$HUI.datagrid('#execGrid').loadData([]);
	}
	var patientListPage="";
	function setPatientInfo(EpisodeID) {
		$.m({
			ClassName: "web.DHCDoc.OP.AjaxInterface",
			MethodName: "GetOPInfoBar",
			CONTEXT: "",
			EpisodeID: EpisodeID
		}, function(html) {
			if (html != "") {
				$(".patientbar").data("patinfo",html);
				if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
				else{$(".PatInfoItem").html(reservedToHtml(html))}
				$(".PatInfoItem").find("img").eq(0).css("top",0);
				//$(".PatInfoItem").html(reservedToHtml(html));
			} else {
				$(".PatInfoItem").html($g("获取病人信息失败。请检查【患者信息展示】配置。"));
			}
		});

		
	}
	function reservedToHtml(str) {
		var replacements = {
			"&lt;": "<",
			"&#60;": "<",
			"&gt;": ">",
			"&#62;": ">",
			"&quot;": "\"",
			"&#34;": "\"",
			"&apos;": "'",
			"&#39;": "'",
			"&amp;": "&",
			"&#38;": "&"
		};
		return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function(v) {
			return replacements[v];
		});
	}
	function filter(q, row) {
		var opts = $(this).combobox('options');
		var text = row[opts.textField];
		var pyjp = getPinyin(text).toLowerCase();
		if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
			return true;
		}
		return false;
	}

	//分割数组
	function splitChunk(chunks, size, argus) {
		if (argus.length !== 0) {
			chunks.push(argus.splice(0, size));
			return splitChunk(chunks, size, argus);
		}
		return chunks;
	}

	//处理医嘱
	//只给护士用
	function handleOrder() {
		var orderIDArray = [];
		var notOwnLocOrderArray = [];
		var rowsData = $HUI.datagrid('#orderGrid').getSelections();
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var condition = rowData["condition"];
			if (rowData["ownLocOrderFlag"] == 0) {
				notOwnLocOrderArray.push(rowData);
				continue;
			}
			if (condition.indexOf("处理") < 0) {
				continue;
			}
			var orderID = rowData['ID'];
			orderIDArray.push(orderID);
		}
		if (orderIDArray.length === 0) {
			if (notOwnLocOrderArray.length === 0) {
				$.messager.alert("提示", "请选择需要处理的医嘱!", 'info');
			} else {
				$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
			}

			return;
		}
		// 调用医嘱弹窗
		var orderIDObj = {};
		orderIDObj.seeOrderList = orderIDArray;
		var queryOrder = searchOrder;
		handleOrderCom("seeOrder", "处理医嘱", "W", "",orderIDObj, queryOrder, "NUR");
		
//		var chunks = splitChunk([], chunkSize, orderIDArray);
//		//oeoriIdStr As %String, userId As %String, type As %String, note As %String = "", date As %String = "", time As %String = "", logonLoc As %String = ""
//		var errorArray = [];
//		chunks.forEach(function(chunk) {
//			var result = $cm({
//				ClassName: "Nur.CommonInterface.OrderHandle",
//				MethodName: "SeeOrderChunks",
//				oeoriIdStr: chunk.join("^"),
//				userId: session['LOGON.USERID'],
//				type: "F"
//			}, false);
//			if (result.errList) {
//				result.errList.forEach(function(errObject) {
//					errorArray.push(errObject.errInfo)
//				});
//			}
//		});
//		if (errorArray.length === 0) {
//			$.messager.alert("提示", "处理成功!", 'info');
//			searchOrder();
//		} else {
//			$.messager.alert("提示", errorArray[0], 'info');
//			searchOrder();
//		}

	}
	function cancelSeeOrder() {
			var orderIDArray = [];
			var notOwnLocOrderArray = [];
			var rowsData = $HUI.datagrid('#orderGrid').getSelections();
			for (var i = 0; i < rowsData.length; i++) {
				var rowData = rowsData[i];
				var condition = rowData["condition"];
				if (rowData["ownLocOrderFlag"] == 0) {
					notOwnLocOrderArray.push(rowData);
					continue;
				}
				if (condition.indexOf("未处理") > -1) {
					continue;
				}
				var orderID = rowData['ID'];
				orderIDArray.push(orderID);
			}
			if (orderIDArray.length === 0) {
				if (notOwnLocOrderArray.length === 0) {
					$.messager.alert("提示", "请选择需要撤销处理的医嘱!", 'info');
				} else {
					$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
				}

				return;
			}
			// 调用医嘱弹窗
			var orderIDObj = {};
			orderIDObj.cancelSeeOrderList = orderIDArray;
			var queryOrder = searchOrder;
			handleOrderCom("cancelSeeOrder", "撤销处理医嘱", "W", "",orderIDObj, queryOrder, "NUR");
	}
	//执行医嘱,后台自动把未执行的执行记录执行掉
	//护士用
	function excuteOrder() {
		var orderIDArray = [];
		var notOwnLocOrderArray = [];
		var childOrderArray = [];
		var rowsData = $HUI.datagrid('#orderGrid').getSelections();
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var condition = rowData["condition"];
			var disposeStatCode = rowData["disposeStatCode"];
			var preNotAlreadyDeal = rowData["preNotAlreadyDeal"];
			if (rowData["ownLocOrderFlag"] == 0) {
				notOwnLocOrderArray.push(rowData);
				continue;
			}
			if (condition.indexOf("执行") < 0) {
				continue;
			}
			if (condition.indexOf("未处理") > -1 && disposeStatCode!="PreStopOrder") {
				continue;
			}
			if (condition.indexOf("未处理") > -1 && disposeStatCode=="PreStopOrder" && disposeStatCode==1) {
				continue;
			}
			if (rowData["seqNo"] !== rowData['ID']) {
				childOrderArray.push(rowData);
				continue;
			}
			var orderID = rowData['ID'];
			orderIDArray.push(orderID);
		}
		if (orderIDArray.length === 0) {
			if (notOwnLocOrderArray.length != 0) {
				$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
			} else if (childOrderArray.length != 0) {
				$.messager.alert("提示", "不能单独执行子医嘱!", 'info');
			} else {
				$.messager.alert("提示", "请选择需要执行且已经处理过的医嘱!", 'info');
			}
			return;
		}
		// 调用医嘱弹窗
		var queryOrder = searchOrder;
		var orderIDObj = $cm({
			ClassName: "Nur.NIS.Service.Base.OrderHandle",
			MethodName: "GetNeedToExecOeoreID",
			OrderIDStr:orderIDArray.join("^"),
			CtcpType:ctcpType,
			AbnormalType:$HUI.combobox('#type').getValue() ? $HUI.combobox('#type').getValue() : 'A'
		},false);
		var windowModel = "S";
		if ((orderIDObj.doubleExecList.length === orderIDObj.execOrderList.concat(orderIDObj.execDisOrderList).length)&&(orderIDObj.doubleExecList.length)) {
			windowModel="D";
		}
		var alertMsgArr=orderIDObj.NotAllowExecOrderMsgs.concat(orderIDObj.needSkinResultOrderMsgs);
		if (alertMsgArr.length){
			$.messager.alert("提示", alertMsgArr.join("<\br>"), 'info',function(){
				if (orderIDObj.execDisOrderList.length==0 && orderIDObj.execOrderList.length==0) return false;
				handleOrderCom("excuteOrder", "执行医嘱", windowModel, "",orderIDObj, queryOrder, "NUR");
			});
			
		}else{
			handleOrderCom("excuteOrder", "执行医嘱", windowModel, "",orderIDObj, queryOrder, "NUR");
		}
		
		
//		var chunks = splitChunk([], chunkSize, orderIDArray);
//		//oeoriIdStr As %String, userId As %String, type As %String, note As %String = "", date As %String = "", time As %String = "", logonLoc As %String = ""
//		var errorArray = [];
//		chunks.forEach(function(chunk) {
//			var result = $cm({
//				ClassName: "Nur.HISUI.NeedCareOrder",
//				MethodName: "excuteOrder",
//				OrderIDString: chunk.join("^"),
//				userID: session['LOGON.USERID'],
//				locID: session['LOGON.CTLOCID']
//			}, false);
//			if (result.errList) {
//				result.errList.forEach(function(errObject) {
//					errorArray.push(errObject.errInfo)
//				});
//			}
//		});
//		if (errorArray.length === 0) {
//			$.messager.alert("提示", "执行成功!", 'info');
//			searchOrder();
//		} else {
//			$.messager.alert("提示", errorArray[0], 'info');
//			searchOrder();
//		}

	}

	//药品审核,后台自动把未审核的执行记录审核掉
	//护士用
	function durgAudit() {
		function handleRetInfo(ret) {
			var success = $g('操作成功!');
			var fail = $g('操作失败!');
			var retInfo = ret.split('^');
			retInfo[0] = retInfo[0].replace(/\r\n/g, '');
			if (!retInfo[1]) {
				if (retInfo[0] == '0') {
					retInfo[1] = success;
				}
			}
			var msgInfo = retInfo[1] ? retInfo[1] : fail;
			if (isNaN(retInfo[0])) {
				msgInfo = $g('执行操作过程中发生了以下错误：\n') + ret;
			}
			$.messager.alert('提示', msgInfo, 'info');
			return (retInfo[0] == '0');
		}
		var orderIDArray = [];
		var notOwnLocOrderArray = [];
		var rowsData = $HUI.datagrid('#orderGrid').getSelections();
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var condition = rowData["condition"];
			if (rowData["ownLocOrderFlag"] == 0) {
				notOwnLocOrderArray.push(rowData);
				continue;
			}
			if (condition.indexOf("未领药审核") < 0) {
				continue;
			}
			var orderID = rowData['ID'];
			orderIDArray.push(orderID);
		}
		if (orderIDArray.length === 0) {
			if (notOwnLocOrderArray.length === 0) {
				$.messager.alert("提示", "请选择未领药审核的医嘱!", 'info');
			} else {
				$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
			}

			return;
		}
		//var chunks = splitChunk([], chunkSize, orderIDArray);
		//oeoriIdStr As %String, userId As %String, type As %String, note As %String = "", date As %String = "", time As %String = "", logonLoc As %String = ""
		var errorArray = [];

		var result = $m({
			ClassName: "Nur.HISUI.NeedCareOrder",
			MethodName: "durgAudit",
			OrderIDString: orderIDArray.join("^"),
			userID: session['LOGON.USERID'],
			locID: session['LOGON.CTLOCID']
		}, false);

		if (handleRetInfo(result + "")) {
			searchOrder();
		}
	}

	//撤销检查检验等临时医嘱
	//医生用
	function cancelOrder() {
		var orderExecIDArray = [];
		var rowsData = $HUI.datagrid('#orderGrid').getSelections();
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var condition = rowData["condition"];
			if ((condition.indexOf("检查") < 0) && (condition.indexOf("检验") < 0) && (condition.indexOf("会诊未执行") < 0)) {
				continue;
			}
			var orderID = rowData['ID'];
			orderExecIDArray.push(orderID);
		}
		if (orderExecIDArray.length === 0) {
			$.messager.alert("提示", "请选择需要可以撤销的医嘱!", 'info');
			return;
		}
		var chunks = splitChunk([], chunkSize, orderExecIDArray);
		var errorArray = [];
		chunks.forEach(function(chunk) {
			//UpdateOrdGroupChunks(setSkinTest, oeoreIdStr, execStatusCode, userId, userDeptId, queryTypeCode, execDate, execTime, changeReasonDr, groupID = "")
			var result = $m({
				ClassName: "Nur.HISUI.NeedCareOrder",
				MethodName: "cancelOrder",
				OrderIDString: chunk.join("^"),
				userID: session['LOGON.USERID'],
				locID: session['LOGON.CTLOCID']
			}, false);
			if ((result != "0")) {
				errorArray.push(result)
			}
		});
		if ((errorArray.length === 0)) {
			$.messager.alert("提示", "撤销成功!", 'info');
			searchOrder();
		} else if (errorArray.length !== 0) {
			$.messager.alert("提示", errorArray.join(" "), 'info');
			searchOrder();
		}
	}

	//执行执行记录
	//护士用
	function excuteOrderExec() {
			var orderExecIDArray = [];
			var notOwnLocOrderArray = [];
			var childOrderArray = [];
			var rowsData = $HUI.datagrid('#execGrid').getSelections();
			var orderExecIDArray = [];
			var notOwnLocOrderArray = [];
			var childOrderArray = [];
			var rowsData = $HUI.datagrid('#execGrid').getSelections();
			for (var i = 0; i < rowsData.length; i++) {
				var rowData = rowsData[i];
				var condition = rowData["condition"];
				if (rowData["ownLocOrderFlag"] == 0) {
					notOwnLocOrderArray.push(rowData);
					continue;
				}
				if (condition.indexOf("执行") < 0) {
					continue;
				}
				if (rowData["seqNo"] !== "") {
					childOrderArray.push(rowData);
					continue;
				}
				var orderExecID = rowData['ID'];
				orderExecIDArray.push(orderExecID);
			}
			if (orderExecIDArray.length === 0) {
				if (notOwnLocOrderArray.length != 0) {
					$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
				} else if (childOrderArray.length != 0) {
					$.messager.alert("提示", "不能单独执行子医嘱!", 'info');
				} else {
					$.messager.alert("提示", "请选择需要执行的医嘱!", 'info');
				}
				return;
			}
			var currentOrderID = orderExecID.split("||")[0] + "||" + orderExecID.split("||")[1];
			var orderGridRowsData = $HUI.datagrid('#orderGrid').getSelections();
			for (var i = 0; i < orderGridRowsData.length; i++) {
				var orderGridRowData = orderGridRowsData[i];
				var condition = orderGridRowData["condition"];
				var disposeStatCode = orderGridRowData["disposeStatCode"];
				var preNotAlreadyDeal = orderGridRowData["preNotAlreadyDeal"];
				var orderID = orderGridRowData["ID"];
				if ((condition.indexOf("未处理") > -1) &&(disposeStatCode!="PreStopOrder") && (currentOrderID === orderID)) {
					$.messager.alert("提示", "请先处理医嘱再执行!", 'info');
					return;
				}
				if ((condition.indexOf("未处理") > -1) &&(disposeStatCode=="PreStopOrder") && (preNotAlreadyDeal==1) && (currentOrderID === orderID)) {
					$.messager.alert("提示", "请先处理医嘱再执行!", 'info');
					return;
				}
			}
			// 调用医嘱弹窗
			var queryOrder = searchExecOrder;
			var orderIDObj = $cm({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "GetExecID",
				oeoreIDStr:orderExecIDArray.join("^"),
				CtcpType:ctcpType,
				AbnormalType:$HUI.combobox('#type').getValue() ? $HUI.combobox('#type').getValue() : 'A'
			},false);
			var windowModel = "S";
			if ((orderIDObj.doubleExecList.length === orderIDObj.execOrderList.concat(orderIDObj.execDisOrderList).length)&&(orderIDObj.doubleExecList.length)) {
				windowModel="D";
			}
			var alertMsgArr=orderIDObj.NotAllowExecOrderMsgs.concat(orderIDObj.needSkinResultOrderMsgs);
			if (alertMsgArr.length){
				$.messager.alert("提示", alertMsgArr.join("<\br>"), 'info',function(){
					if (orderIDObj.execDisOrderList.length==0 && orderIDObj.execOrderList.length==0) return false;
					handleOrderCom("excuteOrder", "执行医嘱", windowModel, "",orderIDObj, queryOrder, "NUR");
				});
			}else{
				handleOrderCom("excuteOrder", "执行医嘱", windowModel, "",orderIDObj, queryOrder, "NUR");
			}
//			var chunks = splitChunk([], chunkSize, orderExecIDArray);
//			var errorArray = [];
//			chunks.forEach(function(chunk) {
//				//UpdateOrdGroupChunks(setSkinTest, oeoreIdStr, execStatusCode, userId, userDeptId, queryTypeCode, execDate, execTime, changeReasonDr, groupID = "")
//				var result = $cm({
//					ClassName: "Nur.CommonInterface.OrderHandle",
//					MethodName: "UpdateOrdGroupChunks",
//					setSkinTest: "",
//					oeoreIdStr: chunk.join("^"),
//					execStatusCode: "F",
//					userId: session['LOGON.USERID'],
//					userDeptId: session['LOGON.CTLOCID'],
//					queryTypeCode: "",
//					execDate: "",
//					execTime: "",
//					changeReasonDr: "",
//					groupID: ""
//				}, false);
//				if (result.errList) {
//					result.errList.forEach(function(errObject) {
//						errorArray.push(errObject.errInfo)
//					});
//				}
//			});
//			if (errorArray.length === 0) {
//				$.messager.alert("提示", "执行成功!", 'info');
//				searchExecOrder();
//			} else {
//				$.messager.alert("提示", errorArray[0], 'info');
//				searchExecOrder();
//			}
		}
	// 撤销执行医嘱
	function cancelExecuteOrderExec() {
			var orderExecIDArray = [];
			var notOwnLocOrderArray = [];
			var childOrderArray = [];
			var rowsData = $HUI.datagrid('#execGrid').getSelections();
			for (var i = 0; i < rowsData.length; i++) {
				var rowData = rowsData[i];
				var condition = rowData["condition"];
				if (rowData["ownLocOrderFlag"] == 0) {
					notOwnLocOrderArray.push(rowData);
					continue;
				}
				if (condition.indexOf("未执行")> -1) {
					continue;
				}
				if (rowData["seqNo"] !== "") {
					childOrderArray.push(rowData);
					continue;
				}
				var orderExecID = rowData['ID'];
				orderExecIDArray.push(orderExecID);
			}
			if (orderExecIDArray.length === 0) {
				if (notOwnLocOrderArray.length != 0) {
					$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
				} else if (childOrderArray.length != 0) {
					$.messager.alert("提示", "不能单独执行子医嘱!", 'info');
				} else {
					$.messager.alert("提示", "请选择需要撤销执行的医嘱!", 'info');
				}

				return;
			}
			/*var currentOrderID = orderExecID.split("||")[0] + "||" + orderExecID.split("||")[1];
			var orderGridRowsData = $HUI.datagrid('#orderGrid').getSelections();
			for (var i = 0; i < orderGridRowsData.length; i++) {
				var orderGridRowData = orderGridRowsData[i];
				var condition = orderGridRowData["condition"];
				var orderID = orderGridRowData["ID"];
				if ((condition.indexOf("未执行") > -1) && (currentOrderID === orderID)) {
					$.messager.alert("提示", "请先执行医嘱再撤销!", 'info');
					return;
				}
			}*/
			// 调用医嘱弹窗
			var queryOrder = searchExecOrder;
			var orderIDObj = {};
			orderIDObj.cancelExecOrderList = orderExecIDArray;
			
			handleOrderCom("cancelOrder", "撤销执行医嘱", "W", "",orderIDObj, queryOrder, "NUR");
	}
		//明细审核
	function drugDetailsAudit() {
		function handleRetInfo(ret) {
			var success = $g('操作成功!');
			var fail = $g('操作失败!');
			var retInfo = ret.split('^');
			retInfo[0] = retInfo[0].replace(/\r\n/g, '');
			if (!retInfo[1]) {
				if (retInfo[0] == '0') {
					retInfo[1] = success;
				}
			}
			var msgInfo = retInfo[1] ? retInfo[1] : fail;
			if (isNaN(retInfo[0])) {
				msgInfo = '执行操作过程中发生了以下错误：\n' + ret;
			}
			$.messager.alert('提示', msgInfo, 'info');
			return (retInfo[0] == '0');
		}
		var orderIDArray = [];
		var notOwnLocOrderArray = [];
		var rowsData = $HUI.datagrid('#execGrid').getSelections();
		for (var i = 0; i < rowsData.length; i++) {
			var rowData = rowsData[i];
			var condition = rowData["condition"];
			if (rowData["ownLocOrderFlag"] == 0) {
				notOwnLocOrderArray.push(rowData);
				continue;
			}
			if (condition.indexOf("未领药审核") < 0) {
				continue;
			}
			var orderID = rowData['ID'];
			orderIDArray.push(orderID);
		}
		if (orderIDArray.length === 0) {
			if (notOwnLocOrderArray.length === 0) {
				$.messager.alert("提示", "请选择未领药的医嘱!", 'info');
			} else {
				$.messager.alert("提示", "请选择本科室的医嘱!", 'info');
			}

			return;
		}
		//var chunks = splitChunk([], chunkSize, orderIDArray);
		//oeoriIdStr As %String, userId As %String, type As %String, note As %String = "", date As %String = "", time As %String = "", logonLoc As %String = ""
		var errorArray = [];

		var result = $m({
			ClassName: "Nur.HISUI.NeedCareOrder",
			MethodName: "durgAudit",
			OrderIDString: orderIDArray.join("^"),
			userID: session['LOGON.USERID'],
			locID: session['LOGON.CTLOCID']
		}, false);

		if (handleRetInfo(result + "")) {
			searchExecOrder();
		}
	}
