//var opl=ipdoc.lib.ns("dhcdoc.diag.entry");
//opl.view=(function(){
//使用闭包，对于后续门诊流程的控制需要单独写，此处暂时去掉闭包写法
//初始化诊断模板
var DiagTempDetailDataGrid;
var DiagHistoryDataGrid;
var DiagTempDetailParamObj;
var DiagHistoryParamObj;
var WScreenH = window.screen.height;
var DATE_FORMAT;
var PageLogicObj = {
	m_version: 8,
	EntrySelRowFlag: 0,
	FocusRowIndex: 0,
	AddToTemplId: ""
}
//入口函数
function InitDiagEntry() {
	DiagTempDetailParamObj = { "Arg1": "", "ClassName": "web.DHCDocDiagnosNew", "QueryName": "DiagTemplateDetailList" }
	DiagHistoryParamObj = {
		"Arg1": ServerObj.PatientID, "Arg2": "All", "Arg3": '',
		"ClassName": "web.DHCDocDiagnosEntryV8", "QueryName": "GetHistoryMRDiagnose"
	}
	if (ServerObj.SYSDateFormat == "4") {
		// DD/MM/YYYY
		DATE_FORMAT = new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
	} else if (ServerObj.SYSDateFormat == "3") {
		// YYYY-MM-DD
		DATE_FORMAT = new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
	}

	InittabDiagTempDetail();
	//InittabDiagHistory();
	InittabDiagHistoryTree();

	InitTempTabs("", "", "Init");
	SetDiagOtherInfo();
	InittabDiagnosEntry();
	//LoadtabDiagTempDetailData(); 
	LoadtabDiagHistoryData();
	OpenPALongICDWin();
	InitEvent();
	if (websys_isIE == true) {
		var script = document.createElement('script');
		script.type = 'text/javaScript';
		script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
		document.getElementsByTagName('head')[0].appendChild(script);
	}
}
window.onbeforeunload = DiagnosUnloadHandler;
function DiagnosUnloadHandler(e) {
	//未审核的诊断
	var GirdData = GetGirdData();
	if (GirdData != "") {
		if (dhcsys_confirm("有未保存的诊断，是否要保存")) {
			InsertMutiMRDiagnos();
		} else {
			return;
		}
	}
}
function LoadtabDiagTempDetailData() {
	$.q({
		ClassName: DiagTempDetailParamObj.ClassName,
		QueryName: DiagTempDetailParamObj.QueryName,
		MASTERDR: DiagTempDetailParamObj.Arg1,
		Pagerows: DiagTempDetailDataGrid.datagrid("options").pageSize, rows: 99999
	}, function (GridData) {
		//DiagTempDetailDataGrid.datagrid('loadData',GridData);
		DiagTempDetailDataGrid.datagrid({ loadFilter: pagerFilter }).datagrid('loadData', GridData);
	});
}
function LoadtabDiagHistoryData() {
	$HUI.combobox("#DiagHistoryDate", {
		valueField: 'id',
		textField: 'text',
		editable: false,
		onSelect: function (rec) {
			LoadFunc();
		}
	});
	$.m({
		ClassName: "web.DHCDocDiagnosEntryV8",
		MethodName: "GetHistoryMRDiagnoseDataJson",
		PatientID: ServerObj.PatientID
	}, function (val) {
		var GridData = eval('(' + val + ')');
		$HUI.combobox('#DiagHistoryDate', { data: GridData });
		var $AdmType_Radio = $("input[name='DiagAdmType_Radio']:checked");
		if ($AdmType_Radio.length > 0) {
			var OldSelId = $AdmType_Radio[0].id;
		} else {
			var OldSelId = ""
		}
		var NewSelId = "";
		if (ServerObj.PAAdmType == "I") {
			var o = $HUI.radio("#IPDiag");
			NewSelId = "IPDiag";
		} else {
			var o = $HUI.radio("#OPDiag");
			NewSelId = "OPDiag";
		}
		if (OldSelId == NewSelId) {
			LoadFunc();
		} else {
			setTimeout(function () {
				o.setValue(true)
			}, 0);
		}
	});

}
function LoadFunc() {
	$.m({
		ClassName: "web.DHCDocDiagnosEntryV8",
		MethodName: "GetHistoryMRDiagnoseJson",
		PatientID: ServerObj.PatientID,
		AdmType: $("input[name='DiagAdmType_Radio']:checked").val(),
		SearchYear: $('#DiagHistoryDate').combobox('getValue'),
		LoginCTLOC: session['LOGON.CTLOCID']
	}, function (val) {
		var GridData = eval('(' + val + ')');
		$HUI.tree('#tabDiagHistoryTree', { data: GridData });
	});
}
function SetDiagOtherInfo() {
	var DiagOtherInfoArr = ServerObj.DiagOtherInfo.split(String.fromCharCode(1));
	var FirstAdm = DiagOtherInfoArr[0];
	var ReAdmis = DiagOtherInfoArr[1];
	var OutReAdm = DiagOtherInfoArr[2];
	var TransAdm = DiagOtherInfoArr[3];
	var ILIFlag = DiagOtherInfoArr[4];
	var BPSystolic = DiagOtherInfoArr[5];
	var BPDiastolic = DiagOtherInfoArr[6];
	var Weight = DiagOtherInfoArr[7];
	var Height = DiagOtherInfoArr[10];
	if (FirstAdm == 1) {
		var o = $HUI.radio("#FirstAdm");
		o.setValue(true);
	}
	if (ReAdmis == 1) {
		var o = $HUI.radio("#ReAdmis");
		o.setValue(true);
	}
	if (OutReAdm == 1) {
		var o = $HUI.radio("#OutReAdm");
		o.setValue(true);
	}
	if (TransAdm == 1) {
		var o = $HUI.checkbox("#TransAdm");
		o.setValue(true);
	} else {
		var o = $HUI.checkbox("#TransAdm");
		o.setValue(false);
	}
	if (ILIFlag == 1) {
		var o = $HUI.checkbox("#ILI");
		o.setValue(true);
	} else {
		var o = $HUI.checkbox("#ILI");
		o.setValue(false);
	}
	$("#BPSystolic").val(BPSystolic);
	$("#BPDiastolic").val(BPDiastolic);
	$("#Weight").val(Weight);
	$("#Height").val(Height);
	var cbox = $HUI.combobox("#Special", {
		valueField: 'id',
		textField: 'text',
		editable: false,
		multiple: true,
		data: eval("(" + ServerObj.SpecialJson + ")"),
		onLoadSuccess: function () {
			var sbox = $HUI.combobox("#Special");
			var DiagOtherInfoArr = ServerObj.DiagOtherInfo.split(String.fromCharCode(1));
			for (i = 0; i < DiagOtherInfoArr[8].split("^").length; i++) {
				sbox.select(DiagOtherInfoArr[8].split("^")[i]);
			}
		}
	});
	var cbox = $HUI.combobox("#PhysiologicalCycle", {
		valueField: 'id',
		textField: 'text',
		editable: true,
		multiple: false,
		data: eval("(" + ServerObj.PhysiologicalCycleJson + ")"),
		onLoadSuccess: function () {
			var sbox = $HUI.combobox("#PhysiologicalCycle");
			var DiagOtherInfoArr = ServerObj.DiagOtherInfo.split(String.fromCharCode(1));
			for (i = 0; i < DiagOtherInfoArr[9].split("^").length; i++) {
				sbox.select(DiagOtherInfoArr[9].split("^")[i]);
			}
		}
	});
}
function InitTempTabs(type, tempid, isInit) {
	if (isInit == "Init") {
		$("#diagTempTypeKW").keywords({
			singleSelect: true,
			items: [
				{ text: $g('个人模板'), id: 'U', selected: true },
				{ text: $g('科室模板'), id: 'L' }
			],
			onClick: function (v) {
				InitTempTabs(v.id, PageLogicObj.AddToTemplId);
			}
		});
	}
	$("#BMore,#diagTempTabs").show();
	ClearNameTabs();
	var USERID = session['LOGON.USERID'];
	var LOCID = session['LOGON.CTLOCID'];
	if (type == "L") {
		USERID = "";
	} else {
		LOCID = "";
	}
	if (typeof tempid == "undefined") { tempid == ""; }
	if (typeof isInit == "undefined") { isInit == ""; }
	$.q({
		ClassName: "web.DHCDocDiagnosEntryV8",
		QueryName: "DiagTemplateList",
		USERID: USERID,
		LOCID: LOCID
	}, function (GridData) {
		if ((GridData["total"] == 0) && (isInit == "Init")) {
			$("#diagTempTypeKW").keywords("select", "L");
			return false;
		}
		var selIndex = "";
		var LasTabNameIndex = -1, showMoreBtnFlag = 0;
		var _$scroller = $("#diagTempTabs .tabs-scroller-left");
		for (var i = 0; i < GridData.total; i++) {
			var id = GridData.rows[i].DHCDIAMASRowid;
			var text = GridData.rows[i].DHCDIADESC;
			if (((tempid == "") && (i == 0)) || ((tempid != "") && (id == tempid))) {
				selIndex = i;
			}
			if ((_$scroller.is(':hidden')) && (showMoreBtnFlag == 0)) {
				$('#diagTempTabs').tabs('add', {
					selected: false,
					id: id,
					title: text
				})
				LasTabNameIndex = LasTabNameIndex + 1;
				if (!_$scroller.is(':hidden')) {
					AddMoreMenu();
				}
			} else {
				AddMoreMenu();
			}
		}
		if (showMoreBtnFlag == 0) {
			$("#BMore").hide();
		}
		if (selIndex === "") {
			DiagTempDetailParamObj.Arg1 = "";
			LoadtabDiagTempDetailData();
		} else {
			$('#diagTempTabs').tabs('select', selIndex);
		}
		PageLogicObj.AddToTemplId = "";
		function AddMoreMenu() {
			showMoreBtnFlag = 1;
			if (LasTabNameIndex > -1) {
				var closeTab = $('#diagTempTabs').tabs('getTab', LasTabNameIndex);
				var closeTabTitle = closeTab.panel("options").title;
				var closeTabid = closeTab.panel("options").id;
				$("#mmedit").menu('appendItem', {
					id: closeTabid,
					text: closeTabTitle
				});
				$('#diagTempTabs').tabs('close', LasTabNameIndex);
				LasTabNameIndex = -1;
			} else {
				$("#mmedit").menu('appendItem', {
					id: id,
					text: text
				});
			}
		}
	});
}
function menuHandler(item) {
	var tab = $('#diagTempTabs').tabs('getSelected');
	if (tab) {
		$('#diagTempTabs').tabs('unselect', $('#diagTempTabs').tabs('getTabIndex', tab));
	}
	$(".selmenudiv").removeClass("selmenudiv")
	$("#" + item['id']).addClass("selmenudiv");
	DiagTempDetailParamObj.Arg1 = item['id'];
	LoadtabDiagTempDetailData();
}
function ClearNameTabs() {
	$("#mmedit div").remove();
	var _$tab = $('#diagTempTabs');
	var tabs = _$tab.tabs('tabs');
	for (var i = tabs.length - 1; i >= 0; i--) {
		_$tab.tabs('close', i);
	}
}
//清空所有的Tab  
function closeAllTabs() {
	var arrTitle = new Array();
	var tabs = $("#diagTempTabs").tabs("tabs");//获得所有小Tab  
	var tCount = tabs.length;
	if (tCount > 0) {
		for (var i = 0; i < tCount; i++) {
			arrTitle.push(tabs[i].panel('options').title)
		}
		for (var i = 0; i < arrTitle.length; i++) {
			$("#diagTempTabs").tabs("close", arrTitle[i]);
		}
	}
}
function InitEvent() {
	jQuery('#tabDiagnosEntry').closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').bind("dblclick", headerDblClick)
	$('#Add_Diag_btn').click(Add_Diag_row);
	$('#Delete_Diag_btn').click(Delete_Diag_btn);
	$('#MoveUp_Diag_btn').click(BMoveUpclickhandler);
	$('#MoveDown_Diag_btn').click(BMoveDownclickhandler);
	$('#MoveLeft_Diag_btn').click(BMoveLeftclickhandler);
	$('#MoveRight_Diag_btn').click(BMoveRightclickhandler);
	$('#AddToTemplate_Diag_btn').click(AddToTemplateclickhandler);
	$('#Save_Diag_btn').click(InsertMutiMRDiagnos);
	$('#DiagTemplate').click(diagnosTempEditshow);
	$('#AddToEMR_Diag_btn').click(AddToEMRClickhandler);
	$('#Copy_Diag_btn').click(CopyDiagshow);
	$('#MouthDiaInput').click(MouthDiaInputshow);
	$('#Add_HistoryDiag').click(Add_HistoryDiag_btn);
	$('#LongDiagnos_Diag_btn').click(LongDiagnosOpen);
	$('#DiagnosDel_List_btn').click(DiagnosDelList);
	$('#AllDiag_List_btn').click(AllDiagnosList);
	$('#diagTempTabs').tabs({
		selected: '',
		onSelect: function (title, index) {
			var selTab = $('#diagTempTabs').tabs('getTab', index);
			var selTabid = selTab.panel("options").id;
			DiagTempDetailParamObj.Arg1 = selTabid;
			LoadtabDiagTempDetailData();
		}
	});
	$(document.body).bind("keydown", BodykeydownHandler)
}
function AddToEMRClickhandler() {
	DiagDataToEMR();
	window.close();
}
function diagnosTempEditshow() {
	var url = "diagnos.template.mainrenancev8.csp";
	websys_showModal({
		url: url,
		title: '诊断模板维护',
		width: '95%', height: '95%'
	})
}
function MouthDiaInputshow() {
	var url = "mouth.diagnos.csp";
	//websys_createWindow(url, true, "status=1,scrollbars=1,top=0,left=0,width=1200,height=700");
	var diastr = window.showModalDialog(url, "", "dialogHeight: " + (700) + "px; dialogWidth: " + (900) + "px");
	if (diastr == "") { return false; }
	if (!CheckIsDischarge()) return false;
	for (var k = 0; k < diastr.split("^").length; k++) {
		var id = diastr.split("^")[k].split("!")[0];
		var desc = diastr.split("^")[k].split("!")[1];
		if ((id == "") && (desc == "")) continue;
		if (id != "") {
			AddDiagItemtoList(id, "");
			DHCDocUseCount(id, "User.MRCICDDx");
		}
		else AddDiagItemtoList("", desc);
	}

}

function BodykeydownHandler(e) {
	if (window.event) {
		var keyCode = window.event.keyCode;
		var type = window.event.type;
		var SrcObj = window.event.srcElement;
	} else {
		var keyCode = e.which;
		var type = e.type;
		var SrcObj = e.target;
	}
	//回车事件或者
	if (keyCode == 13) {
		if (SrcObj && SrcObj.id == "BPDiastolic") {
			$("#Weight").focus();
			return false;
		} else if (SrcObj && SrcObj.id == "BPSystolic") {
			$("#BPDiastolic").focus();
			return false;
		} else if (SrcObj && SrcObj.id == "Weight") {
			$('#Special').next('span').find('input').focus();
			return false;
		} else if (SrcObj && SrcObj.id.indexOf("DiagnosICDDesc") >= 0) {
			return false;
		}
		return true;
	}
	/*window.onhelp = function() { return false };
	if (keyCode == 112) {
		Add_Diag_row();
		return false;
	}
	if (keyCode == 113) {
		Delete_Diag_btn();
		return false;
	}*/
	if (e) {
		var ctrlKeyFlag = e.ctrlKey;
	} else {
		var ctrlKeyFlag = window.event.ctrlKey;
	}
	if (ctrlKeyFlag) {
		if (event.keyCode == 83) { //保存诊断
			InsertMutiMRDiagnos();
			return false;
		}
	}
}
function InittabDiagnosEntry() {
	//var TableHeight=WScreenH-$("#DiagnosEntryArea").offset().top-400;
	var TableHeight = $("#DiagnosEntryArea")[0].clientHeight - 150
	$("#tabDiagnosEntry").jqGrid({
		width: $(".toolbar-div").width(), //640
		height: TableHeight,		//WScreenH-550,  //470
		//url:'opdoc.request.query.grid.csp',
		//postData:{"ClassName":"web.DHCDocDiagnosEntryV8","QueryName":"DiagnosList","ArgCnt":"1","Arg1":ServerObj.mradm},
		url: 'oeorder.oplistcustom.new.request.csp?action=GetDiagList',
		datatype: "json",
		postData: { USERID: session['LOGON.USERID'], MRADM: ServerObj.mradm },
		shrinkToFit: false,
		autoScroll: false,
		mtype: 'GET',
		emptyrecords: $g('没有数据'),
		viewrecords: true,
		loadtext: $g('数据加载中...'),
		multiselect: true,
		multiboxonly: true,
		rowNum: false,
		loadonce: false,
		viewrecords: true,
		rownumbers: false,
		loadui: 'enable',
		loadError: function (xhr, status, error) {
			alert("diagnosentry.js-err:" + status + "," + error);
		},
		colNames: ListConfigObj.colNames,
		colModel: ListConfigObj.colModel,
		jsonReader: {
			/*rows:"rows",
			records:"total",
			repeatitems: false,
			id: "Id"*/

			page: "page",
			total: "total",
			records: "records",
			root: "data",
			repeatitems: false,
			id: "Id"
		},
		prmNames: {
			page: "page",
			rows: "rows",
			sort: "sidx",
			order: "sord",
			search: "_search",
			nd: "nd",
			id: "id",
			oper: "oper",
			editoper: "edit",
			addoper: "add",
			deloper: "del",
			subgridid: "id",
			npage: null,
			totalrows: "totalrows"
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			EditRow(rowid)
		},
		beforeSelectRow: function (rowid, e) {
			if ($.isNumeric(rowid) == true) {
				PageLogicObj.FocusRowIndex = rowid;
			} else {
				PageLogicObj.FocusRowIndex = 0;
			}
			return true;//false 禁止选择行操作
		},
		gridComplete: function () {
			//加载完成后 增加 删除 都会调用
			$("#tabDiagnosEntry td").removeAttr("title");
		},
		loadComplete: function () {
			Add_Diag_row();
			/*if(('undefined' !== typeof CopyOeoriDataArr)&&(CopyOeoriDataArr.length>0)){
				AddCopyItemToList(CopyOeoriDataArr);
				CopyOeoriDataArr=undefined;
			}*/
			//改变已经保存诊断的颜色
			var rowids = $('#tabDiagnosEntry').getDataIDs();
			for (var i = 0; i < rowids.length; i++) {
				var ICDDiagnosDesc = GetCellData(rowids[i], "DiagnosICDDesc");
				var tmpICDDiagnosDesc = ICDDiagnosDesc.replace(/\&nbsp;/g, "")
				if (tmpICDDiagnosDesc != "") {
					$('#tabDiagnosEntry').setCell(rowids[i], "DiagnosICDDesc", ICDDiagnosDesc, "DiagSaved", "")
				}
				var DiagnosNotes = GetCellData(rowids[i], "DiagnosNotes");
				if (DiagnosNotes != "") {
					$('#tabDiagnosEntry').setCell(rowids[i], "DiagnosNotes", DiagnosNotes, "DiagSaved", "")
				}
				var DiagnosPrefix = GetCellData(rowids[i], "DiagnosPrefix");
				if (DiagnosPrefix != "") {
					$('#tabDiagnosEntry').setCell(rowids[i], "DiagnosPrefix", DiagnosPrefix, "DiagSaved", "")
				}
			}
			$("#tabDiagnosEntry td").removeAttr("title");
			//从病历浏览界面复制,只提醒一次
			if (ServerObj.CopyDiagnosStr != "") {
				AddCopyItemToList(ServerObj.CopyDiagnosStr);
				$.extend(ServerObj, { CopyDiagnosStr: "" });
				//修改url防止右键刷新重复复制
				if (typeof (history.pushState) === 'function') {
					overrrideUrl("copyOeoris", "");
				}
			}
		}
	})
}
function InittabDiagTempDetail() {
	$("#tabDiagTemplateDetail").parent().css("height", $(window).height() - 95);
	var DiagTempDetailColumns = [[
		{ field: 'NUM', title: '', hidden: true },
		{ field: 'DHCMRDiaICDICDDR', title: '', hidden: true },
		{
			field: 'DHCMRDiaICDICDDesc', width: 250, title: '描述',
			formatter: function (value, row, index) {
				if (row.DHCMRDiaICDICDNotes != "") {
					var valArr = value.split("*");
					var newVal = valArr[0] + "(" + row.DHCMRDiaICDICDNotes + ")";
					if (valArr.length > 1) {
						newVal = newVal + valArr[1];
					}
					return newVal;
				} else {
					return value;
				}
			}
		}
	]]
	DiagTempDetailDataGrid = $("#tabDiagTemplateDetail").datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: false,  //
		rownumbers: true,  //
		pageSize: 5000,
		pageList: [5000, 7000, 8000],
		idField: 'NUM',
		columns: DiagTempDetailColumns,
		onDblClickRow: function (rowIndex, rowData) {
			if (!CheckIsDischarge()) return false;
			var idStr = rowData.DHCMRDiaICDICDDR;
			var descStr = rowData.DHCMRDiaICDICDDesc;
			var MasterICDRowid = idStr.split("*")[0];
			if (MasterICDRowid != "") {
				if (!CheckDiagIsEnabled(MasterICDRowid)) return false;
				var DHCMRDiaICDICDNotes = rowData.DHCMRDiaICDICDNotes;
				AddDiagItemtoList(MasterICDRowid, DHCMRDiaICDICDNotes);
				DHCDocUseCount(MasterICDRowid, "User.MRCICDDx");
				var subICDRowidStr = idStr.split("*")[1]; //21882!#!测试证型备注   #前面是ID  #后面是描述
				var synIdStr = subICDRowidStr.split("#")[0];
				var synDescStr = subICDRowidStr.split("#")[1];
				for (var k = 0; k < synIdStr.split("!").length; k++) {
					var id = synIdStr.split("!")[k];
					var desc = synDescStr.split("!")[k];
					if ((id == "") && (desc == "")) continue;
					if (id != "") {
						if (!CheckDiagIsEnabled(id)) return false;
						AddDiagItemtoList(id, "");
						DHCDocUseCount(id, "User.MRCICDDx");
					} else {
						if (ServerObj.NotEntryNoICDDiag == "1") continue;
						AddDiagItemtoList("", desc);
					}
				}
			} else {
				if (ServerObj.NotEntryNoICDDiag == "1") {
					$.messager.alert("提示", "非ICD诊断不能录入!");
					return false;
				}
				//除非中医诊断是非ICD诊断
				var subICDRowidStr = idStr.split("*")[1];
				var synIdStr = subICDRowidStr.split("#")[0];
				var synDescStr = subICDRowidStr.split("#")[1];
				if ((subICDRowidStr != "") && ((synIdStr != "") || (synDescStr != ""))) {
					AddDiagItemtoList("", descStr.split("*")[0], "Y");
					for (var k = 0; k < synIdStr.split("!").length; k++) {
						var id = synIdStr.split("!")[k];
						var desc = synDescStr.split("!")[k];
						if ((id == "") && (desc == "")) continue;
						if (id != "") {
							if (!CheckDiagIsEnabled(id)) return false;
							AddDiagItemtoList(id, "");
							DHCDocUseCount(id, "User.MRCICDDx");
						} else {
							if (ServerObj.NotEntryNoICDDiag != "1") {
								AddDiagItemtoList("", desc);
								var CruRow = GetPreRowId();
								SetCellData(CruRow, "DiagnosCat", 2);
								SetCellData(CruRow, "DiagnosCatRowId", 2);
							}
						}
					}
				} else {
					AddDiagItemtoList("", descStr);
				}
			}
			if (ServerObj.DiagFromTempOrHisAutoSave == 1) {
				InsertMutiMRDiagnos();
			}
		}
	});
}
//初始化历史诊断树
function InittabDiagHistoryTree() {
	var DiagHistoryColumns = [[
		{ field: 'Index', title: '计数器', hidden: true },
		{ field: 'Title', title: '标题', width: 120 },
		{ field: 'Desc', title: '诊断名称', width: 250 },
		{ field: 'MRDIARowID', hidden: true }
	]];
	$HUI.tree('#tabDiagHistoryTree', {
		title: '',
		lines: true,
		idField: 'Index',
		border: false,
		columns: DiagHistoryColumns,
		checkbox: true,
		onDblClick: function (node) {
			if (!CheckIsDischarge()) return false;
			if ((node.attributes.DiagnosType == "") && (node.attributes.MRDIARowID == "")) return false;
			if (node.children != undefined) {
				var DiagnosTypeRowId = node.attributes.DiagnosType;
				var nodechildren = node.children;
				for (var i = 0; i < nodechildren.length; i++) {
					var val = tkMakeServerCall("web.DHCDocDiagnosEntryV8", "GetDataFromHistMRDiag", nodechildren[i].attributes.MRDIARowID);
					if (val != "") {
						for (m = 0; m < val.split(String.fromCharCode(1)).length; m++) {
							var oneVal = val.split(String.fromCharCode(1))[m];
							var id = oneVal.split(String.fromCharCode(2))[0];
							var desc = oneVal.split(String.fromCharCode(2))[1];
							var DiagnosCatRowId = oneVal.split(String.fromCharCode(2))[2];
							var DiagnosPrefix = oneVal.split(String.fromCharCode(2))[3];
							if ((id == "") && (ServerObj.NotEntryNoICDDiag == "1")) {
								if (m == 0) {
									$.messager.alert("提示", "非ICD诊断不能录入!");
									return false;
								} else {
									continue;
								}
							}
							if (id != "") {
								if (!CheckDiagIsEnabled(id)) {
									if (m == 0) return false;
									else continue;
								}
							}
							AddDiagItemtoList(id, desc, DiagnosTypeRowId, DiagnosPrefix);
							if (id == "") {
								var CruRow = GetPreRowId();
								SetCellData(CruRow, "DiagnosCat", DiagnosCatRowId);
								SetCellData(CruRow, "DiagnosCatRowId", DiagnosCatRowId);
							}
							DHCDocUseCount(id, "User.MRCICDDx");
						}
					}
				}
			} else {
				var val = $.m({
					ClassName: "web.DHCDocDiagnosEntryV8",
					MethodName: "GetDataFromHistMRDiag",
					MRDIADr: node.attributes.MRDIARowID
				}, false);
				//主诊断ICDRowid_$C(2)_主诊断备注_$C(1)_子诊断ICDRowid_$C(2)_子诊断备注
				if (val != "") {
					for (m = 0; m < val.split(String.fromCharCode(1)).length; m++) {
						var oneVal = val.split(String.fromCharCode(1))[m];
						var id = oneVal.split(String.fromCharCode(2))[0];
						var desc = oneVal.split(String.fromCharCode(2))[1];
						var DiagnosCatRowId = oneVal.split(String.fromCharCode(2))[2];
						var DiagnosPrefix = oneVal.split(String.fromCharCode(2))[3];
						if ((id == "") && (ServerObj.NotEntryNoICDDiag == "1")) {
							if (m == 0) {
								$.messager.alert("提示", "非ICD诊断不能录入!");
								return false;
							} else {
								continue;
							}
						}
						if (id != "") {
							if (!CheckDiagIsEnabled(id)) {
								if (m == 0) return false;
								else continue;
							}
						}
						AddDiagItemtoList(id, desc, "", DiagnosPrefix);
						if (id == "") {
							var CruRow = GetPreRowId();
							SetCellData(CruRow, "DiagnosCat", DiagnosCatRowId);
							SetCellData(CruRow, "DiagnosCatRowId", DiagnosCatRowId);
						}
						DHCDocUseCount(id, "User.MRCICDDx");
					}
				}
			}
			if (ServerObj.DiagFromTempOrHisAutoSave == 1) {
				InsertMutiMRDiagnos();
			}
		}
	});
}
//初始化历史诊断 
function InittabDiagHistory() {
	var DiagHistoryColumns = [[  //MRDesc
		{ field: 'Desc', title: '诊断描述' },
		{
			field: 'Count', title: '重复次数',
			formatter: function (value, rec) {
				var btn = '<a class="editcls" onclick="dhcdoc.diag.entry.view.HisMRDiagRepShow(\'' + rec.MRAdmList + '\')">' + value + '</a>';
				return btn;
			}
		},
		{ field: 'MRAdmList', hidden: true }
	]]
	DiagHistoryDataGrid = $("#tabDiagHistory").datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,  //
		rownumbers: true,  //
		pageSize: 20,
		pageList: [20, 100, 200],
		idField: 'MRAdmList',
		columns: DiagHistoryColumns,
		onDblClickRow: function (rowIndex, rowData) {
			$.m({
				ClassName: "web.DHCDocDiagnosEntryV8",
				MethodName: "GetDataFromHistMRDiag",
				MRDIADr: rowData.MRAdmList.split(",")[0]
			}, function (val) {
				//主诊断ICDRowid_$C(2)_主诊断备注_$C(1)_子诊断ICDRowid_$C(2)_子诊断备注
				if (val != "") {
					for (m = 0; m < val.split(String.fromCharCode(1)).length; m++) {
						var oneVal = val.split(String.fromCharCode(1))[m];
						var id = oneVal.split(String.fromCharCode(2))[0];
						var desc = oneVal.split(String.fromCharCode(2))[1];
						if ((id == "") && (ServerObj.NotEntryNoICDDiag == "1")) {
							if (m == 0) {
								$.messager.alert("提示", "非ICD诊断不能录入!");
								return false;
							} else {
								continue;
							}
						}
						AddDiagItemtoList(id, desc);
						DHCDocUseCount(id, "User.MRCICDDx");
					}
				}
			});
		}
	});
}
function Add_Diag_row() {
	var rowid = "";
	var records = $('#tabDiagnosEntry').getGridParam("records");
	if (records >= 1) {
		var prerowid = GetPreRowId();
		var MRCIDRowId = GetCellData(prerowid, "MRCIDRowId");
		var DiagnosNotes = GetCellData(prerowid, "DiagnosNotes");
		if (DiagnosNotes != "") DiagnosNotes = DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
		if ((MRCIDRowId == "" || MRCIDRowId == null) && (DiagnosNotes == "")) {
			SetFocusCell(prerowid, "DiagnosICDDesc");
			return prerowid;
		}
	}
	rowid = GetNewrowid();
	if (rowid == "" || rowid == 0) { return; }
	var DefaultData = GetDefaultData(rowid);
	DefaultData['id'] = rowid;
	$('#tabDiagnosEntry').addRowData(rowid, DefaultData);
	EditRowCommon(rowid, true);
	SetFocusCell(rowid, "DiagnosICDDesc");
	InitDiagnosICDDescLookUp(rowid);
	$($('#tabDiagnosEntry').find('tbody tr.jqgrow')[rowid - 1]).children().attr('title', '')
	return rowid;
}
function GetDefaultData(rowid) {
	var defDiagnosOnsetDate = ServerObj.CurrentDate, defDiagnosDate = ServerObj.CurrentDate;
	var defDiagnosLeavel = "1", defDiagnosCatRowId = "0";
	var defDiagnosTypeRowId = ServerObj.DedfaultDiagnosTypeID;
	var defDiagnosStatusRowId = "3";
	var defMainDiagFlag = "N";
	//中医科室默认中医诊断
	if ((ServerObj.ZYLocFlag == 1) || (ServerObj.CMDisFlag == 1)) {
		defDiagnosCatRowId = 1
	}

	if (rowid > 1) {
		for (var i = rowid - 1; i >= 1; i--) {
			var MRDIARowId = GetCellData(i, "MRDIARowId");
			var MRCIDRowId = GetCellData(i, "MRCIDRowId");
			if ((MRCIDRowId == "") || (MRCIDRowId == null)) continue;
			if (MRDIARowId != "") continue;
			var DiagnosCatRowId = GetCellData(i, "DiagnosCatRowId"); //分类
			var DiagnosTypeRowId = GetCellData(i, "DiagnosTypeRowId"); //诊断类型
			var MainDiagFlag = GetCellData(i, "MainDiagFlag");
			var DiagnosStatusRowId = GetCellData(i, "DiagnosStatusRowId");
			var DiagnosOnsetDate = GetCellData(i, "DiagnosOnsetDate"); //发病日期
			defDiagnosOnsetDate = DiagnosOnsetDate;
			defDiagnosTypeRowId = DiagnosTypeRowId;
			defDiagnosStatusRowId = DiagnosStatusRowId;
			if (DiagnosCatRowId == "2") {  //"0:西医;1:中医;2:证型"
				defDiagnosCatRowId = "2";
				break;
			} else if (DiagnosCatRowId == "1") {
				//不启用标准证型诊断,根据上一条的中医诊断判断是否有关联的证型,如果没有则本条不默认为证型
				if (ServerObj.UserICDSyndrome != "1") {
					//todo
				}
				defDiagnosCatRowId = "2";
				break;
			} else {
				defDiagnosCatRowId = "0";
				break;
			}
		}
	} else {
		defMainDiagFlag = "Y"
	}
	var defLongDiagnosFlagRowId = "";
	if (defDiagnosCatRowId == "2") {
		for (var k = parseInt(rowid) - 1; k >= 1; k--) {
			var tmpDiagnosCatRowId = GetCellData(k, "DiagnosCatRowId");
			if (DiagnosCatRowId == "1") {
				var defLongDiagnosFlagRowId = GetCellData(k, "LongDiagnosFlagRowId");
				break;
			}
		}
	}
	var DfaultData = {
		DiagnosOnsetDate: defDiagnosOnsetDate,
		DiagnosLeavel: defDiagnosLeavel,
		DiagnosDate: defDiagnosDate,
		DiagnosCatRowId: defDiagnosCatRowId,
		DiagnosCat: defDiagnosCatRowId,
		DiagnosTypeRowId: defDiagnosTypeRowId,
		DiagnosType: defDiagnosTypeRowId,
		DiagnosStatusRowId: defDiagnosStatusRowId,
		DiagnosStatus: defDiagnosStatusRowId,
		LongDiagnosFlag: defLongDiagnosFlagRowId,
		LongDiagnosFlagRowId: defLongDiagnosFlagRowId,
		MainDiagFlag: defMainDiagFlag
	};
	return DfaultData;
}
function EditRowCommon(rowid, EnableOrd) {
	if ($.isNumeric(rowid) == true) {
		$('#tabDiagnosEntry').editRow(rowid, false); //false ȥ???
		if ((typeof EnableOrd != "undefined") && (EnableOrd == false)) {
			return
		}
		//SetDiagICDDescList(rowid)
	}
}
function SetFocusCell(rowid, colname) {
	if ($.isNumeric(rowid) == true) {
		var obj = document.getElementById(rowid + "_" + colname);
		if (obj) {
			websys_setfocus(rowid + "_" + colname);
		}
		PageLogicObj.FocusRowIndex = rowid;
	} else {
		var obj = document.getElementById(colname);
		if (obj) {
			websys_setfocus(colname);
		}
	}
}
function DiagnosCatChange(e) {
	var rowId = "";
	var obj = websys_getSrcElement(e);
	var rowId = GetEventRow(e);
	var DiagnosCatRowId = GetCellData(rowId, "DiagnosCatRowId");
	if (obj.value == "2") { //如果修改分类为证型,则判断是否存在对应中医诊断,如果不存在,则不允许修改
		var Flag = 0;
		if (rowId == "1") {
			Flag = 1;
		} else {
			var preId = parseInt(rowId) - 1;
			if (CheckIsItem(preId)) Flag = 1;
			else {
				var upDiagnosCatRowId = GetCellData(preId, "DiagnosCatRowId");
				if (upDiagnosCatRowId == "0") {
					Flag = 1;
				}
			}
		}
		if (Flag == "1") {
			$.messager.alert("提示", "请先录入中医诊断!", "info", function () {
				SetFocusCell(rowId, "DiagnosICDDesc");
			});
			SetCellData(rowId, "DiagnosCatRowId", DiagnosCatRowId);
			SetCellData(rowId, "DiagnosCat", DiagnosCatRowId);
			return false;
		}
	}
	if (obj.value != DiagnosCatRowId) {
		SetCellData(rowId, "MRCIDCode", "")
		SetCellData(rowId, "DiagnosICDDesc", "");
		SetCellData(rowId, "MRCIDRowId", "");
		//$('#'+rowId+'_DiagnosICDDesc').val("");
		//$('#'+rowId+'_MRCIDRowId').val("");
		SetCellData(rowId, "DiagnosCatRowId", obj.value);
		SetCellData(rowId, "LongDiagnosFlagRowId", "");
		SetCellData(rowId, "LongDiagnosFlag", "");
		SetFocusCell(rowId, "DiagnosICDDesc")
	}
}
function DiagnosTypeChange(e) {
	var rowId = "";
	var obj = websys_getSrcElement(e);
	var rowId = GetEventRow(e);
	SetCellData(rowId, "DiagnosTypeRowId", obj.value);
	SetFocusCell(rowId, "DiagnosICDDesc")
}
function DiagnosBodyPartChange(e) {
	var rowId = "";
	var obj = websys_getSrcElement(e);
	var rowId = GetEventRow(e);
	SetCellData(rowId, "DiagnosBodyPartRowId", obj.value);
	SetFocusCell(rowId, "DiagnosBodyPart")
}
function DiagnosStatusChange(e) {
	var rowId = "";
	var obj = websys_getSrcElement(e);
	var rowId = GetEventRow(e);
	SetCellData(rowId, "DiagnosStatusRowId", obj.value);
	SetFocusCell(rowId, "DiagnosICDDesc")
}
function DiagnosICDDesc_keydown(e) {
	//元素回车事件未添加逻辑处理,查询控件功能统一使用InitDiagnosICDDescLookUp方法中lookup控件
	return false;
}
function Trim(str, is_global) {
	var result;
	result = str.replace(/(^\s+)|(\s+$)/g, "");
	if (is_global.toLowerCase() == "g") {
		result = result.replace(/\s/g, "");
	}
	return result;
}
function DiagItemLookupSelect(text, rowid) {
	PageLogicObj.EntrySelRowFlag = 1;
	/*if (typeof rowid == "undefined") {
		var rowid = "";
	}
	if (this.id.indexOf("_") > 0) {
		rowid = this.id.split("_")[0];
	}*/
	var Split_Value = text.split("^");
	var idesc = Split_Value[0];
	var icode = Split_Value[1];
	if (window.event) window.event.keyCode = 0;
	if (!CheckDiagIsEnabled(icode, function () { ClearRow(rowid); })) {
		return false;
	}
	/*var Str=MarchDiagnosis(icode);
	if (Str==1){
		var vaild = window.confirm("所加诊断在本次诊断中已经存在，请确认是否重复增加?");
		if(!vaild) {
			ClearRow(rowid);
			return false;
		}
	}*/
	SetCellData(rowid, "DiagnosICDDesc", idesc);
	SetCellData(rowid, "MRCIDRowId", icode);
	SetCellData(rowid, "MRCIDCode", Split_Value[2]);
	var DiagnosCatRowId = GetCellData(rowid, "DiagnosCatRowId");
	if (DiagnosCatRowId == "2") {
		for (var k = parseInt(rowid) - 1; k >= 1; k--) {
			var tmpDiagnosCatRowId = GetCellData(k, "DiagnosCatRowId");
			if (tmpDiagnosCatRowId == "1") {
				var defLongDiagnosFlagRowId = GetCellData(k, "LongDiagnosFlagRowId");
				SetCellData(rowid, "LongDiagnosFlagRowId", defLongDiagnosFlagRowId);
				SetCellData(rowid, "LongDiagnosFlag", defLongDiagnosFlagRowId);
				break;
			}
		}
	}
	Add_Diag_row();
}
function ClearRow(rowid) {
	SetCellData(rowid, "DiagnosICDDesc", "");
	SetCellData(rowid, "MRCIDRowId", "");
	SetFocusCell(rowid, "DiagnosICDDesc");
}
function DiagnosNotes_keydown(e) {
	var Row = GetEventRow(e);
	var key = websys_getKey(e);
	if (key == 13) {
		var MRCIDRowId = GetCellData(Row, "MRCIDRowId");
		var DiagnosNotes = GetCellData(Row, "DiagnosNotes");
		if (DiagnosNotes != "") DiagnosNotes = DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
		if ((MRCIDRowId == "" || MRCIDRowId == null) && (DiagnosNotes == "")) {
			SetFocusCell(Row, "DiagnosNotes");
			return false;
		} else {
			var ICDType = GetCellData(Row, "DiagnosCatRowId");
			if (ICDType == 1) {
				SetFocusCell(Row, "SyndromeDesc");
			} else {
				Add_Diag_row();
			}
		}
	}
}
function DiagnosPrefix_keydown(e) {
	var Row = GetEventRow(e);
	var key = websys_getKey(e);
	if (key == 13) {
		var MRCIDRowId = GetCellData(Row, "MRCIDRowId");
		var DiagnosNotes = GetCellData(Row, "DiagnosPrefix");
		if (DiagnosNotes != "") DiagnosNotes = DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
		if ((MRCIDRowId == "" || MRCIDRowId == null) && (DiagnosNotes == "")) {
			SetFocusCell(Row, "DiagnosNotes");
			return false;
		} else {
			var ICDType = GetCellData(Row, "DiagnosCatRowId");
			if (ICDType == 1) {
				SetFocusCell(Row, "SyndromeDesc");
			} else {
				Add_Diag_row();
			}
		}
	}
}
function InitDatePicker(cl) {
	var dateFormate = "dd/MM/yyyy", minDate = '%d/%M/%y'
	if (ServerObj.SYSDateFormat == 3) {
		dateFormate = "yyyy-MM-dd";
		minDate = '%y-%M-%d'
	}
	var CurrentObj = null;
	if (cl.currentTarget) { CurrentObj = cl.currentTarget; } else { CurrentObj = cl; }
	WdatePicker({
		el: CurrentObj.id,
		isShowClear: true,
		onpicked: function () { $(CurrentObj).change(); },
		readOnly: true,
		skin: 'ext',
		//maxDate: minDate, //%y-%M-%d
		value: ServerObj.CurrentDate,
		dateFmt: dateFormate
	});
}
function GetCellData(rowid, colname) {
	var CellData = "";
	if ($.isNumeric(rowid) == true) {
		var obj = document.getElementById(rowid + "_" + colname);
		//如果为select 取 text
		if (obj) {
			if (obj.type == "select-one") {
				CellData = $("#" + rowid + "_" + colname + " option:selected").text();
			} else if (obj.type == "checkbox") {
				if ($("#" + rowid + "_" + colname).attr("checked") == "checked") {
					CellData = "Y";
				} else {
					CellData = "N";
				}
			} else {
				CellData = $("#" + rowid + "_" + colname).val();
			}
		} else {
			CellData = $("#tabDiagnosEntry").getCell(rowid, colname);
		}
	} else {
		var obj = document.getElementById(colname);
		if (obj) {
			CellData = $("#" + colname).val();
		}
	}
	return CellData;
}
//单元格赋值  2014-03-24
function SetCellData(rowid, colname, data) {
	if ($.isNumeric(rowid) == true) {
		var obj = document.getElementById(rowid + "_" + colname);
		if (obj) {
			if (obj.type == "checkbox") {
				// data: true or  false
				var olddata = $("#" + rowid + "_" + colname).attr("checked");
				$("#" + rowid + "_" + colname).attr("checked", data);
			} else {
				var olddata = $("#" + rowid + "_" + colname).val();
				$("#" + rowid + "_" + colname).val(data);
			}
			//对于行上属性的数据修改,模拟onpropertychange事件的实现,在change事件中要同步调用
			//CellDataPropertyChange(rowid, colname, olddata, data);
		} else {
			//rowid,colname,nData,cssp,attrp, forceupd
			//forceupd:true 允许设空值
			$("#tabDiagnosEntry").setCell(rowid, colname, data, "", "", true);
		}
	} else {
		var obj = document.getElementById(colname);
		if (obj) {
			$("#" + colname).val(data);
		}
	}
}
function SetColumnList(rowid, ColumnName, str) {
	//ppppppp
	var Id = "";
	if ($.isNumeric(rowid) == true) {
		var Id = rowid + "_" + ColumnName;
	} else {
		var Id = ColumnName;
	}
	if (typeof str == "undefined") { return }
	var obj = document.getElementById(Id);
	if ((obj) && (obj.type == "select-one")) {
		ClearAllList(obj);
		//医嘱类型
		if (ColumnName == "DiagnosType") {
			var DefaultDiagnosTypeRowid = "";
			var DefaultDiagnosTypeDesc = "";
			var ArrData = str.split(";");
			for (var i = 0; i < ArrData.length; i++) {
				var ArrData1 = ArrData[i].split(":");
				if (((ArrData1[2] == "Y") && (DefaultDiagnosTypeRowid == "")) || (ArrData.length == 1)) {
					var DefaultDiagnosTypeRowid = ArrData1[0];
					var DefaultDiagnosTypeDesc = ArrData1[1];
				}
				obj.options[obj.length] = new Option(ArrData1[1], ArrData1[0]);
			}
			SetCellData(rowid, "DiagnosType", DefaultDiagnosTypeRowid);
			SetCellData(rowid, "DiagnosTypeRowid", DefaultDiagnosTypeRowid);
		}



	}
}
function ClearAllList(obj) {
	for (var i = obj.options.length - 1; i >= 0; i--) obj.options[i] = null;
}

function GetPreRowId(rowid) {
	var prerowid = "";
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	if ($.isNumeric(rowid) == true) {
		for (var i = rowids.length; i >= 0; i--) {
			if (rowids[i] == rowid) {
				if (i == 0) {
					prerowid = rowids[i];
				} else {
					prerowid = rowids[i - 1];
				}
				break;
			}
		}
	}
	if (prerowid == "") {
		if (rowids.length == 0) {
			prerowid = ""
		} else {
			prerowid = rowids[rowids.length - 1];
		}
	}
	return prerowid;
}
function GetNewrowid() {
	var rowid = "";
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	if (rowids.length > 0) {
		var prerowid = rowids[rowids.length - 1];
		if (prerowid.indexOf(".") != -1) {
			rowid = parseInt(prerowid.split(".")[0]) + 1;
		} else {
			rowid = parseInt(prerowid) + 1;
		}
	} else {
		rowid = 1;
	}
	return rowid;
}
function EditRow(rowid) {
	if (GetEditStatus(rowid) == true || $.isNumeric(rowid) == false) { return false; }
	var StyleConfigObj = {
		MRCIDRowId: false,
		MRDIARowId: false,
		DiagnosCat: false,
		DiagnosType: true,
		DiagnosLeavel: false,
		DiagnosICDDesc: false,
		MainDiagFlag: true,
		DiagnosNotes: true,
		MRCIDCode: false,
		DiagnosStatus: true,
		DiagnosOnsetDate: true,
		DiagnosPrefix: true
	};
	var DiagnosType = GetCellData(rowid, "DiagnosType");
	var DiagnosTypeRowId = GetCellData(rowid, "DiagnosTypeRowId");
	var MRDIARowId = GetCellData(rowid, "MRDIARowId");
	EditRowCommon(rowid, false);
	//从电子病历打开的界面控制住诊断类型不允许修改
	if ((ServerObj.SearchDiagnosTypeStr != "") && (MRDIARowId != "")) {
		StyleConfigObj.DiagnosType = false;
		SetColumnList(rowid, "DiagnosType", DiagnosTypeRowId + ":" + DiagnosType + ":Y");
	}
	ChangeRowStyle(rowid, StyleConfigObj);
	var DiagnosICDDesc = GetCellData(rowid, "DiagnosICDDesc");
	var Newstr = DiagnosICDDesc.replace(/\&nbsp;/g, " ")
	SetCellData(rowid, "DiagnosICDDesc", Newstr)
	SetFocusCell(rowid, "DiagnosNotes")
}
function ChangeRowStyle(rowid, StyleConfigObj) {
	if ($.isNumeric(rowid) == true) {

	}
	for (var key in StyleConfigObj) {
		var name = key;
		var value = StyleConfigObj[key];
		if (value == undefined) { continue; }
		if ($.isNumeric(rowid) == true) {
			if (value == false) {
				if ($("#" + rowid + "_" + name).hasClass("combogrid-f")) {
					//销毁产生的dom对象
					$("#" + rowid + "_" + name).combogrid('destroy');
				} else {
					$("#" + rowid + "_" + name).addClass("disable");
					$("#" + rowid + "_" + name).attr('disabled', true);
				}
				$("#" + rowid + "_" + name).addClass("text-dhcdoc-disabled");
			} else if (value == true) {
				if ($("#" + rowid + "_" + name).hasClass("combogrid-f")) {
					$("#" + rowid + "_" + name).combogrid("enable");
				} else {
					$("#" + rowid + "_" + name).removeClass("disable");
					$("#" + rowid + "_" + name).attr('disabled', false);
				}
				$("#" + rowid + "_" + name).removeClass("text-dhcdoc-disabled");
			}
		} else {
			if (value == false) {
				$("#" + name).attr('disabled', true);
			} else if (value == true) {
				$("#" + name).attr('disabled', false);
			}
		}
	}

}
function GetEventRow(e) {
	var rowid = "";
	var obj = websys_getSrcElement(e);
	if (obj && obj.id.indexOf("_") > 0) {
		rowid = obj.id.split("_")[0];
	}
	return rowid
}
function GetEditStatus(rowid) {
	var obj = document.getElementById(rowid + "_DiagnosNotes");
	if (obj) {
		return true;
	} else {
		return false;
	}
}
function headerDblClick() {
	if (ServerObj.lookupListComponetId != "") {
		$.m({
			ClassName: "web.SSGroup",
			MethodName: "GetAllowWebColumnManager",
			Id: session['LOGON.GROUPID']
		}, function (val) {
			if (val == 1) {
				websys_lu('../csp/websys.component.customiselayout.csp?ID=' + ServerObj.lookupListComponetId + '&CONTEXT=K' + ServerObj.ListColSetCls + '.' + ServerObj.ListColSetMth + '.' + ServerObj.XCONTEXT + "&GETCONFIG=1" + "&DHCICARE=2", false);
			}
		})
	}
}
function Delete_Diag_btn(e) {
	var IsExistVerifyFlag = false;
	var ids = $('#tabDiagnosEntry').jqGrid("getGridParam", "selarrrow");
	if (ids == null || ids.length == 0) {
		if (PageLogicObj.FocusRowIndex > 0) {
			//如果有焦点行,则直接删除焦点行
			if ($("#jqg_tabDiagnosEntry_" + PageLogicObj.FocusRowIndex).attr("checked") != true) {
				$("#tabDiagnosEntry").setSelection(PageLogicObj.FocusRowIndex, true);
			}
		}
		//$.messager.alert("警告","请选择需要删除的记录");  
		//return;  
	}
	var ids = $('#tabDiagnosEntry').jqGrid("getGridParam", "selarrrow");
	if (ids == null || ids.length == 0) {
		$.messager.alert("警告", "请选择需要删除的记录!");
		return;
	}
	if (ServerObj.PAAdmType == "I") {
		var ret = $.cm({
			ClassName: "web.DHCMRDiagnos",
			MethodName: "CheckDelete",
			dataType: "text",
			MRDiagnosRowid: ServerObj.mradm
		}, false);
		if (ret == "Discharged") {
			$.messager.alert("警告", "患者已出院,诊断不能删除!");
			return false;
		}
	}
	$.messager.confirm('提示', '是否确定删除?', function (r) {
		if (r) {
			var len = ids.length;
			var DeleteCount = 0;
			var DelArr = new Array();
			for (var i = 0; i < len; i++) {
				if (CheckIsItem(ids[i - DeleteCount]) == false) {
					var DiagnosCatRowId = GetCellData(ids[i - DeleteCount], "DiagnosCatRowId");
					if (DiagnosCatRowId == "1") { //如选中的是中医,则先找关联的子诊断并删除
						var AllIds = $('#tabDiagnosEntry').getDataIDs();
						for (var k = 0; k < AllIds.length; k++) {
							if (AllIds[k] <= ids[i - DeleteCount]) continue;
							var DiagnosCatRowId = GetCellData(AllIds[k], "DiagnosCatRowId");
							if (DiagnosCatRowId == false) continue;
							if (DiagnosCatRowId == "2") { //证型
								$('#tabDiagnosEntry').delRowData(AllIds[k]);
							} else {
								break;
							}
						}
					}
					$('#tabDiagnosEntry').delRowData(ids[i - DeleteCount]);
					DeleteCount = DeleteCount + 1;
				} else {
					if (ServerObj.DiagDelLimitFlag == 1) {
						var DiagnosDoctor = GetCellData(ids[i - DeleteCount], "DiagnosDoctor");
						if (DiagnosDoctor != session['LOGON.USERNAME']) {
							$.messager.alert("提示", "只允许删除本人所开诊断!");
							return false;
						}
					}
					IsExistVerifyFlag = true;
				}
			}
			if (IsExistVerifyFlag == true) {
				var MRDIARowIdArray = new Array();
				var len = ids.length;
				for (var i = 0; i < len; i++) {
					if (CheckIsItem(ids[i]) == true) {
						IsExistVerifyFlag = true;
						var MRDIARowId = GetCellData(ids[i], "MRDIARowId");
						var MRDIAMRDIADR = GetCellData(ids[i], "MRDIAMRDIADR");
						MRDIARowIdArray[MRDIARowIdArray.length] = MRDIARowId;
					}
				}
				if (MRDIARowIdArray.length > 0) {
					$.messager.confirm('提示', '是否删除已保存的诊断?', function (r) {
						if (r) {
							var DiagItemRowStr = MRDIARowIdArray.join("^");
							DeleteMRDiagnos(DiagItemRowStr);
						}
					})
				}
			}
			var records = $('#tabDiagnosEntry').getGridParam("records");
			if (records == 0) {
				Add_Diag_row();
			}

		}
	});
	return websys_cancel();
}
function DeleteMRDiagnos(DiagItemRowStr) {
	var ret = cspRunServerMethod(ServerObj.DeleteMRDiagnosMethod, DiagItemRowStr, session['LOGON.USERID'], session['LOGON.CTLOCID']);
	var retCode = ret.split("^")[0];
	if (retCode != '0') {
		if (ret == 'Discharged') {
			$.messager.alert("警告", "患者已出院,不能删除诊断!");
			return false;
		} else if (ret == 'Timeout') {
			$.messager.alert("警告", "不能删患者以前诊断!");
			return false;
		} else {
			$.messager.alert("警告", "删除失败!");
			return false;
		}
	} else {
		var delMRDiagnosStr = ret.split("^")[1];
		var rowids = $('#tabDiagnosEntry').getDataIDs();
		var DeleteCount = 0;
		var len = rowids.length;
		for (var i = (len - 1); i >= 0; i--) {
			var MRDIARowId = GetCellData(rowids[i], "MRDIARowId");
			if (("$" + delMRDiagnosStr + "$").indexOf("$" + MRDIARowId + "$") >= 0) {
				$('#tabDiagnosEntry').delRowData(rowids[i]);
				DeleteCount = DeleteCount + 1;
			}
		}
		//ReloadDiagEntryGrid();
		LoadtabDiagHistoryData();
		//调用电子病历接口
		SaveMRDiagnosToEMR();
		if (window.parent.opdoc) {
			window.parent.opdoc.patinfobar.view.InitPatInfo(ServerObj.EpisodeID)
		} else if (window.parent.refreshBar) {
			window.parent.refreshBar();
		}
	}
}
function CheckIsItem(rowid) {
	var id = parseInt(rowid);
	if ($.isNumeric(id) == true) {
		var MRDIARowId = GetCellData(id, "MRDIARowId");
		if (MRDIARowId != "") {
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}
function BMoveUpclickhandler() {
	if ($("#MoveUp_Diag_btn").hasClass('l-btn-disabled')) {
		return false;
	}
	DisableBtn("MoveUp_Diag_btn", true);
	var index = GetCheckedRow("U")
	if (index != "") {
		mysort(index, 'up');
		BSaveclickhandler();
		SaveMRDiagnosToEMR();
	}
	DisableBtn("MoveUp_Diag_btn", false);
}
function BMoveDownclickhandler() {
	if ($("#MoveDown_Diag_btn").hasClass('l-btn-disabled')) {
		return false;
	}
	DisableBtn("MoveDown_Diag_btn", true);
	var index = GetCheckedRow("D")
	if (index != "") {
		mysort(index, 'down');
		BSaveclickhandler();
		SaveMRDiagnosToEMR();
	}
	DisableBtn("MoveDown_Diag_btn", false);
}
function BMoveLeftclickhandler() {
	if ($("#MoveLeft_Diag_btn").hasClass('l-btn-disabled')) {
		return false;
	}
	DisableBtn("MoveLeft_Diag_btn", true);
	var index = GetCheckedRow("L");
	if (index != "") {
		HorizontalMove(index, -1);
		BSaveclickhandler();
	}
	DisableBtn("MoveLeft_Diag_btn", false);
}
function BMoveRightclickhandler() {
	if ($("#MoveRight_Diag_btn").hasClass('l-btn-disabled')) {
		return false;
	}
	DisableBtn("MoveRight_Diag_btn", true);
	var index = GetCheckedRow("R");
	if (index != "") {
		HorizontalMove(index, 1);
		BSaveclickhandler();
	}
	DisableBtn("MoveRight_Diag_btn", false);
}
function GetCheckedRow(type) {
	var ids = $('#tabDiagnosEntry').jqGrid("getGridParam", "selarrrow");
	if (ids == null || ids.length == 0) {
		$.messager.alert("提示", "请选择行!");
		return "";
	} else if (ids.length > 1) {
		$.messager.alert("提示", "请勾选一条记录!");
		return "";
	}
	if (CheckIsItem(ids[0]) == false) {
		$.messager.alert("提示", "请选择已保存的诊断记录!");
		return "";
	}
	if ((type == "U") || (type == "D")) {
		var MainMRDIADr = GetCellData(ids[0], "MRDIAMRDIADR");
		if (MainMRDIADr != "") {
			$.messager.alert("提示", "请选择对应的中医诊断移动!");
			$("#tabDiagnosEntry").setSelection(ids[0], false);
			return false
		}
	}
	return ids[0];
}
//判断行是否在编辑状态
function GetEditStatus(rowid) {
	var obj = document.getElementById(rowid + "_DiagnosICDDesc");
	if (obj) {
		return true;
	} else {
		return false;
	}
}
function HorizontalMove(index, Direction) {
	var DiagnosLeavel = GetCellData(index, "DiagnosLeavel");
	if (+DiagnosLeavel <= 1) DiagnosLeavel = 1;
	var DiagnosICDDesc = GetCellData(index, "DiagnosICDDesc");
	var SpaceHTML = "&nbsp;&nbsp;"//&nbsp;&nbsp;&nbsp;&nbsp;
	var DiagnosLeavel = parseInt(+DiagnosLeavel) + parseInt(Direction);
	if (+DiagnosLeavel == 0) DiagnosLeavel = 1;
	var EditStatus = GetEditStatus(index);
	if (Direction == 1) {
		SetCellData(index, "DiagnosICDDesc", SpaceHTML + DiagnosICDDesc)
	} else {
		if (EditStatus) {
			SetCellData(index, "DiagnosICDDesc", DiagnosICDDesc.replace(" ", ''));
		} else {
			SetCellData(index, "DiagnosICDDesc", DiagnosICDDesc.replace(SpaceHTML, ''));
		}
	}
	if (EditStatus) {
		var DiagnosICDDesc = GetCellData(index, "DiagnosICDDesc");
		SetCellData(index, "DiagnosICDDesc", DiagnosICDDesc.replace(SpaceHTML, ' '))
	}
	SetCellData(index, "DiagnosLeavel", DiagnosLeavel)
}
function mysort(index, type) {
	var rows = $('#tabDiagnosEntry').jqGrid("getGridParam", "records");
	if (("up" == type) || ("Top" == type)) {
		if (index != 1) {
			///存在关联医嘱的问题，上下移动时判断关联诊断
			var toupLinkDiaList = GetLinkDiaNum(index)
			if ("Top" == type) {
				var todownLinkDiaList = index //GetLinkDiaNum(0);
				var todownLinkDiaNum = index;
			} else {
				var todownLinkDiaList = GetLinkDiaNum(parseInt(index) - 1);
				var todownLinkDiaNum = todownLinkDiaList.split("^").length
			}
			var toupLinkDiaNum = toupLinkDiaList.split("^").length
			var StartIndex = parseInt(index) - parseInt(todownLinkDiaNum);
			var CopyRows = new Array(parseInt(toupLinkDiaNum) + parseInt(todownLinkDiaNum));
			var EditRowsArr = new Array();
			for (var i = 0; i < CopyRows.length; i++) {
				if (i < toupLinkDiaNum) {
					var id = parseInt(index) + i;
				} else {
					var id = parseInt(StartIndex) + i - parseInt(toupLinkDiaNum);
				}
				if (GetEditStatus(id) == true) {
					$("#tabDiagnosEntry").saveRow(id);
					EditRowsArr[i] = id;
				}
				CopyRows[i] = $("#tabDiagnosEntry").jqGrid("getRowData", id);

			}
			for (var i = 0; i < CopyRows.length; i++) {
				CopyRows[i].id = parseInt(StartIndex) + i;
				$("#tabDiagnosEntry").jqGrid("setRowData", parseInt(StartIndex) + i, CopyRows[i]);

				var DiagnosNotes = CopyRows[i].DiagnosNotes;
				if (DiagnosNotes != "") {
					//jqgrid 不支持removeclass
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosNotes", DiagnosNotes, { background: 'pink' }, "");
				} else {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosNotes", DiagnosNotes, { background: '#FFF' }, "");
				}
				var DiagnosICDDesc = CopyRows[i].DiagnosICDDesc;
				if (DiagnosICDDesc != "") {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosICDDesc", DiagnosICDDesc, { background: 'pink' }, "");
				} else {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosICDDesc", DiagnosICDDesc, { background: '#FFF' }, "");
				}
				var DiagnosPrefix = CopyRows[i].DiagnosPrefix;
				if (DiagnosPrefix != "") {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosPrefix", DiagnosPrefix, { background: 'pink' }, "");
				} else {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosPrefix", DiagnosPrefix, { background: '#FFF' }, "");
				}
				if (EditRowsArr[i]) {
					EditRow(parseInt(StartIndex) + i);
				}
			}
			$("#tabDiagnosEntry").setSelection(index, false);
			$("#tabDiagnosEntry").setSelection(StartIndex, true);
			//EditRow(StartIndex);		
		}
	} else if (("down" == type) || ("Bottom" == type)) {
		if (index != rows) {
			var LastRowData = $("#tabDiagnosEntry").jqGrid("getRowData", parseInt(index) + 1);
			if (($.isEmptyObject(LastRowData)) || (LastRowData.MRDIARowId == "")) return;
			///存在关联医嘱的问题，上下移动时判断关联诊断
			var todownLinkDiaList = GetLinkDiaNum(index)
			var todownLinkDiaNum = todownLinkDiaList.split("^").length;
			var LastdownNum = todownLinkDiaList.split("^")[parseInt(todownLinkDiaNum) - 1]
			var toDownRowData = $("#tabDiagnosEntry").jqGrid("getRowData", parseInt(LastdownNum) + 1);
			if (($.isEmptyObject(toDownRowData)) || (toDownRowData.MRDIARowId == "")) return;
			if ("Bottom" == type) {
				var toupLinkDiaList = rows - todownLinkDiaNum - index;
				var toupLinkDiaNum = rows - todownLinkDiaNum - index;
			} else {
				var toupLinkDiaList = GetLinkDiaNum(parseInt(index) + parseInt(todownLinkDiaNum));
				var toupLinkDiaNum = toupLinkDiaList.split("^").length;
			}
			var StartIndex = index
			var CopyRows = new Array(parseInt(toupLinkDiaNum) + parseInt(todownLinkDiaNum))
			var EditRowsArr = new Array();
			for (var i = 0; i < CopyRows.length; i++) {
				/*if(GetEditStatus(rowid)==true*/
				if (i < toupLinkDiaNum) {
					var id = parseInt(StartIndex) + parseInt(todownLinkDiaNum) + i;
				} else {
					var id = parseInt(StartIndex) + i - parseInt(toupLinkDiaNum);
				}
				if (GetEditStatus(id) == true) {
					$("#tabDiagnosEntry").saveRow(id);
					EditRowsArr[i] = id;
				}
				CopyRows[i] = $("#tabDiagnosEntry").jqGrid("getRowData", id);
			}
			for (var i = 0; i < CopyRows.length; i++) {
				CopyRows[i].id = parseInt(StartIndex) + i;
				$("#tabDiagnosEntry").jqGrid("setRowData", parseInt(StartIndex) + i, CopyRows[i]);
				var DiagnosNotes = CopyRows[i].DiagnosNotes;
				if (DiagnosNotes != "") {
					//jqgrid 不支持removeclass
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosNotes", DiagnosNotes, { background: 'pink' }, "");
				} else {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosNotes", DiagnosNotes, { background: '#FFF' }, "");
				}
				var DiagnosICDDesc = CopyRows[i].DiagnosICDDesc;
				if (DiagnosICDDesc != "") {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosICDDesc", DiagnosICDDesc, { background: 'pink' }, "");
				} else {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosICDDesc", DiagnosICDDesc, { background: '#FFF' }, "");
				}
				var DiagnosPrefix = CopyRows[i].DiagnosPrefix;
				if (DiagnosPrefix != "") {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosPrefix", DiagnosPrefix, { background: 'pink' }, "");
				} else {
					$('#tabDiagnosEntry').setCell(parseInt(StartIndex) + i, "DiagnosPrefix", DiagnosPrefix, { background: '#FFF' }, "");
				}
				if (EditRowsArr[i]) {
					EditRow(parseInt(StartIndex) + i);
				}
			}
			$("#tabDiagnosEntry").setSelection(index, false);
			$("#tabDiagnosEntry").setSelection(parseInt(StartIndex) + parseInt(toupLinkDiaNum), true);
			//EditRow(parseInt(StartIndex)+parseInt(toupLinkDiaNum));	
		}
	}
	/*if (typeof CopyRows=="object"){
		for (var i=0;i<CopyRows.length;i++) {
			///同步颜色的变化
			var DiagnosNotes=CopyRows[i].DiagnosNotes;
			if (DiagnosNotes!=""){
				//jqgrid 不支持removeclass
				$('#tabDiagnosEntry').setCell(parseInt(StartIndex)+i,"DiagnosNotes",DiagnosNotes,{background:'pink'},"");
			}else{
				$('#tabDiagnosEntry').setCell(parseInt(StartIndex)+i,"DiagnosNotes",DiagnosNotes,{background:'#FFF'},"");
			}
			var DiagnosICDDesc=CopyRows[i].DiagnosICDDesc;
			if (DiagnosICDDesc!=""){
				$('#tabDiagnosEntry').setCell(parseInt(StartIndex)+i,"DiagnosICDDesc",DiagnosICDDesc,{background:'pink'},"");
			}else{
				$('#tabDiagnosEntry').setCell(parseInt(StartIndex)+i,"DiagnosICDDesc",DiagnosICDDesc,{background:'#FFF'},"");
			}
		}
	}*/
}
function GetLinkDiaNum(index) {
	var RowList = ""
	var rows = $('#tabDiagnosEntry').jqGrid("getGridParam", "records");
	var MainMRDIADr = GetCellData(index, "MRDIAMRDIADR");
	var DiagnosValue = GetCellData(index, "MRDIARowId");
	for (var i = 1; i <= rows; i++) {
		var TmpRowID = GetCellData(i, "MRDIARowId");
		var TmpMain = GetCellData(i, "MRDIAMRDIADR");
		if (index == i) {
			//continue
		}
		if ((MainMRDIADr == "") && (DiagnosValue == TmpMain) ||
			((MainMRDIADr != "") && ((TmpMain != "") && (TmpMain == MainMRDIADr) || (MainMRDIADr == TmpRowID)) ||
				(DiagnosValue == TmpRowID))
		) {
			if (RowList == "") {
				RowList = i + ""
			} else {
				RowList = RowList + "^" + i
			}
		}
	}
	RowList = RowList
	return RowList
}
function BSaveclickhandler() {
	var rows = $('#tabDiagnosEntry').jqGrid("getGridParam", "records");
	for (var i = 1; i <= rows; i++) {
		if (CheckIsItem(i)) {
			var MRDIARowId = GetCellData(i, "MRDIARowId");
			var DiagnosLeavel = GetCellData(i, "DiagnosLeavel");
			var MRDiagnosSequence = i;
			var info = DiagnosLeavel + "^" + MRDiagnosSequence
			ret = cspRunServerMethod(ServerObj.UpdateMRDiagnosMethod, MRDIARowId, info)
		}
	}
}
function SaveToPriateTemp() {
	var sbox = $HUI.combobox("#combo_TemplateList");
	var TemplateId = sbox.getValue();
	if (TemplateId == "") {
		$.messager.alert("提示", "没有选择模板名称!");
		return false;
	}
	var paraDiagnosStr = "";
	var selSavedZYRowIdArr = new Array();
	var selZYRowIdArr = new Array();
	var rowCount = $('#tabDiagnosEntry').jqGrid("getGridParam", "records");
	var ids = $('#tabDiagnosEntry').jqGrid("getGridParam", "selarrrow");
	for (var i = 0; i < ids.length; i++) {
		var DiagnosCatRowId = GetCellData(ids[i], "DiagnosCatRowId");
		var MRDIARowId = GetCellData(ids[i], "MRDIARowId");
		var MRCIDRowId = GetCellData(ids[i], "MRCIDRowId");
		var DiagnosNotes = GetCellData(ids[i], "DiagnosNotes");
		if (DiagnosNotes != "") DiagnosNotes = DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "")
		if ((MRCIDRowId == "") && (DiagnosNotes == "")) continue;
		var oneDiagStr = "", findmasetrMRDIARowId = "", flag = 0;
		if (MRDIARowId != "") { //已保存过的诊断加入模板
			var DiagnosCat = GetCellData(ids[i], "DiagnosCat");
			if (DiagnosCat == "证型") { //找对应主诊断
				var DiagnosStr = "";
				for (var m = parseInt(ids[i]) - 1; m >= 1; m--) {
					var masetrMRDIARowId = GetCellData(m, "MRDIARowId");
					var masetrDiagnosCat = GetCellData(m, "DiagnosCat");
					if (masetrDiagnosCat == $g("中医")) {
						if (!selSavedZYRowIdArr[m]) {
							selSavedZYRowIdArr[m] = m;
							findmasetrMRDIARowId = masetrMRDIARowId;
							flag = 1;
						}
						break;
					}
				}
			} else if (DiagnosCat == $g("中医")) {
				if (selSavedZYRowIdArr[ids[i]]) continue;
				selSavedZYRowIdArr[ids[i]] = ids[i];
				findmasetrMRDIARowId = MRDIARowId;
				flag = 1;
			} else {
				if (selSavedZYRowIdArr[ids[i]]) continue;
				selSavedZYRowIdArr[ids[i]] = ids[i];
				var DiagnosCatRowId = 0;
				if (MRCIDRowId != "") oneDiagStr = MRCIDRowId + String.fromCharCode(1) + DiagnosCatRowId;
				else oneDiagStr = "$" + DiagnosNotes + String.fromCharCode(1) + DiagnosCatRowId;
			}
			if ((flag == 1) && (findmasetrMRDIARowId != "")) {
				//主诊断ICDRowid_$C(2)_主诊断备注_$C(1)_子诊断ICDRowid_$C(2)_子诊断备注
				var DiagnosStr = cspRunServerMethod(ServerObj.GetDataFromHistMRDiag, findmasetrMRDIARowId);
				if (DiagnosStr != "") {
					var DiagnosStrArr = DiagnosStr.split(String.fromCharCode(1));
					var id = DiagnosStrArr[0].split(String.fromCharCode(2))[0];
					var desc = DiagnosStrArr[0].split(String.fromCharCode(2))[1];
					var DiagnosCatRowId = 1;
					if (id != "") oneDiagStr = id + String.fromCharCode(1) + DiagnosCatRowId;
					else oneDiagStr = "$" + desc + String.fromCharCode(1) + DiagnosCatRowId;
					for (var k = 1; k < DiagnosStrArr.length; k++) {
						var id = DiagnosStrArr[k].split(String.fromCharCode(2))[0];
						var desc = DiagnosStrArr[k].split(String.fromCharCode(2))[1];
						if ((id == "") && (desc == "")) continue;
						if (id != "") oneDiagStr = oneDiagStr + "!" + id;
						else oneDiagStr = oneDiagStr + "!" + desc;
					}
				}
			}

		} else { //未保存诊断加入模板
			if (DiagnosCatRowId == "1") {
				if (selZYRowIdArr[ids[i]]) continue;
				selZYRowIdArr[ids[i]] = ids[i];
				var DiagnosCatRowId = 1;
				if (MRCIDRowId != "") oneDiagStr = MRCIDRowId + String.fromCharCode(1) + DiagnosCatRowId;
				else oneDiagStr = "$" + DiagnosNotes + String.fromCharCode(1) + DiagnosCatRowId;
				for (var k = parseInt(ids[i]) + 1; k <= rowCount; k++) {
					var tmpDiagnosCatRowId = GetCellData(k, "DiagnosCatRowId");
					if (tmpDiagnosCatRowId == "2") {
						var id = GetCellData(k, "MRCIDRowId");
						var desc = GetCellData(k, "DiagnosNotes");
						if (desc != "") desc = desc.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g, "")
						if ((id == "") && (desc == "")) continue;
						if (id != "") oneDiagStr = oneDiagStr + "!" + id;
						else oneDiagStr = oneDiagStr + "!" + desc;
					} else {
						break;
					}
				}
			} else if (DiagnosCatRowId == "2") {
				for (var k = parseInt(ids[i]) - 1; k >= 1; k--) {
					var tmpDiagnosCatRowId = GetCellData(k, "DiagnosCatRowId");
					if (DiagnosCatRowId == "1") {
						if (selZYRowIdArr[k]) break;
						selZYRowIdArr[k] = k;
						var id = GetCellData(k, "MRCIDRowId");
						var desc = GetCellData(k, "DiagnosNotes");
						if (desc != "") desc = desc.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g, "");
						var DiagnosCatRowId = 1;
						if (id != "") oneDiagStr = id + String.fromCharCode(1) + DiagnosCatRowId;
						else oneDiagStr = "$" + desc + String.fromCharCode(1) + DiagnosCatRowId;
						for (var m = parseInt(k) + 1; m <= rowCount; m++) {
							var tmpDiagnosCatRowId = GetCellData(m, "DiagnosCatRowId");
							if (tmpDiagnosCatRowId == "2") {
								var id = GetCellData(m, "MRCIDRowId");
								var desc = GetCellData(m, "DiagnosNotes");
								if (desc != "") desc = desc.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g, "")
								if ((id == "") && (desc == "")) continue;
								if (id != "") oneDiagStr = oneDiagStr + "!" + id;
								else oneDiagStr = oneDiagStr + "!" + desc;
							} else {
								break;
							}
						}
						break;
					} else {
						break;
					}
				}
			} else {
				if (selZYRowIdArr[ids[i]]) continue;
				selZYRowIdArr[ids[i]] = ids[i];
				var DiagnosCatRowId = 0;
				if (MRCIDRowId != "") oneDiagStr = MRCIDRowId + String.fromCharCode(1) + DiagnosCatRowId;
				else oneDiagStr = "$" + DiagnosNotes + String.fromCharCode(1) + DiagnosCatRowId;
			}
		}
		if (oneDiagStr != "") {
			if (paraDiagnosStr == "") paraDiagnosStr = oneDiagStr;
			else paraDiagnosStr = paraDiagnosStr + "^" + oneDiagStr;
		}
	}
	if (paraDiagnosStr == "") {
		$.messager.alert("提示", "没有需要添加到模板的数据!");
		return false;
	}
	$.m({
		ClassName: "web.DHCDocDiagnosNew",
		MethodName: "PrivateSaveNew",
		USERID: session['LOGON.USERID'],
		selValue: TemplateId,
		DiagnosStr: paraDiagnosStr,
		ListNum: 1
	}, function (RetStr) {
		var Ret = RetStr.split("^")[0]
		var Message = RetStr.split("^")[1]
		if ((Ret == 0) && (Message == "")) {
			var sbox = $HUI.combobox("#combo_TemplateCategroy");
			var type = sbox.getValue();
			var kwobj = $("#diagTempTypeKW").keywords("getSelected");
			var selTabId = kwobj.id;
			if (selTabId == type) {
				InitTempTabs(type, TemplateId); //保存成功后默认刷新选中的模板
			} else {
				PageLogicObj.AddToTemplId = TemplateId;
				if (type == "L") {
					$("#diagTempTypeKW").keywords("select", "L");
				} else {
					$("#diagTempTypeKW").keywords("select", "U");
				}
			}
			destroyDialog("AddTempDiag");
		} else if (Message != "") {
			$.messager.alert("提示", $g("保存失败!") + Message + $g("诊断在该模板中已存在!"));
			return false;
		} else {
			$.messager.alert("提示", $g("保存失败!") + Ret);
			return false;
		}
	});
}
function CopyDiagshow() {
	if (!CheckIsDischarge()) return false;
	var ExistSavedDiagFlag = 0;
	var ids = $('#tabDiagnosEntry').jqGrid("getGridParam", "selarrrow");
	for (var i = 0; i < ids.length; i++) {
		var MRDIARowId = GetCellData(ids[i], "MRDIARowId");
		if (MRDIARowId != "") {
			ExistSavedDiagFlag = 1;
			break;
		}
	}
	if (ExistSavedDiagFlag == "0") {
		$.messager.alert("提示", "请选择需要复制的已保存诊断");
		return;
	}
	destroyDialog("CopyDiag");
	var Content = initDiagDivHtml("CopyDiag");
	var iconCls = "icon-w-edit";
	DiagCreateModalDialog("CopyDiag", $g("复制诊断"), 380, 260, iconCls, $g("复制"), Content, "CopyDiag()");
	var cbox = $HUI.combobox("#combo_DiagType", {
		editable: false,
		multiple: false,
		mode: "local",
		method: "GET",
		selectOnNavigation: true,
		valueField: 'id',
		textField: 'text',
		data: eval("(" + ServerObj.DiagnosTypeJson + ")"),
		onLoadSuccess: function () {
			var sbox = $HUI.combobox("#combo_DiagType");
			sbox.select(ServerObj.DedfaultDiagnosTypeID);
		}
	});
}
function CopyDiag() {
	var idstr = "";
	var ids = $('#tabDiagnosEntry').jqGrid("getGridParam", "selarrrow");
	for (var i = 0; i < ids.length; i++) {
		var MRDIARowId = GetCellData(ids[i], "MRDIARowId");
		var MRDIAMRDIADR = GetCellData(ids[i], "MRDIAMRDIADR");
		if (MRDIARowId != "") {
			if (MRDIAMRDIADR != "") {
				if (idstr == "") idstr = MRDIAMRDIADR;
				else {
					if (("^" + idstr + "^").indexOf("^" + MRDIAMRDIADR + "^") == -1) {
						idstr = idstr + "^" + MRDIAMRDIADR;
					}
				}
			} else {
				if (idstr == "") idstr = MRDIARowId;
				else {
					if (("^" + idstr + "^").indexOf("^" + MRDIARowId + "^") == -1) {
						idstr = idstr + "^" + MRDIARowId;
					}
				}
			}

		}
	}
	/*
	ADiagnosIDStr As %String, ALocId As %String, AUserId As %String, CopyToDiagTypeId As %String, AdmPara
	*/
	//todo 复制多条诊断
	var sbox = $HUI.combobox("#combo_DiagType");
	var CopyToDiagTypeId = sbox.getValue();
	$.m({
		ClassName: "web.DHCDocDiagnosEntryV8",
		MethodName: "CopyMulDiag",
		ADiagnosIDStr: idstr,
		ALocId: session['LOGON.CTLOCID'],
		AUserId: session['LOGON.USERID'],
		CopyToDiagTypeId: CopyToDiagTypeId,
		AdmPara: GetAdmPara()
	}, function (val) {
		if (val.split("^")[0] == "0") {
			destroyDialog("CopyDiag");
			AfterInsertDiag(val);

		} else {
			$.messager.alert("提示", "诊断复制失败!");
			return;
		}
	});
}
function AfterInsertDiag(ret) {
	if (window.parent.opdoc) {
		window.parent.opdoc.patinfobar.view.InitPatInfo(ServerObj.EpisodeID);
	} else if (window.parent.refreshBar) {
		window.parent.refreshBar();
	}
	ReloadDiagEntryGrid();
	LoadtabDiagHistoryData();
	var MRDiagnosCount = 0;
	//BSaveclickhandler(); //调用
	for (var i = 1; i < ret.split('^').length; i++) {
		var MRDiagnosRowid = ret.split('^')[i].split(String.fromCharCode(1))[0];
		var MRCICDRowid = ret.split('^')[i].split(String.fromCharCode(1))[1];
		if (MRDiagnosRowid == "") continue;
		MRDiagnosCount = MRDiagnosCount + 1;
		CheckDisease(MRDiagnosRowid);
		//ShowCPW(MRCICDRowid,MRDiagnosRowid); 
		CheckFBDReport(MRDiagnosRowid);    //食源性疾病提示上报
		CheckCDReport(MRDiagnosRowid) // 慢病强制报卡
		//可能是旧版本遗留功能,新版未找到对应的组件页面,先注释
		/*if (MRCICDRowid!=""){
			var ClinicPathWayRowId = cspRunServerMethod(ServerObj.FindClinicPathWayByICDMethod,MRCICDRowid);
			if (ClinicPathWayRowId!="") {
				//var posn="height="+(screen.availHeight-400)+",width="+(screen.availWidth-200)+",top=200,left=100,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
				var path="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.CPW.Edit&CPWRowId="+ClinicPathWayRowId+"&EpisodeID="+ServerObj.EpisodeID;
				//websys_createWindow(path,false,posn);
				websys_showModal({
					url:path,
					width:screen.availWidth-200,height:screen.availHeight-400
				})
			}
		}*/
	}
	//入径检查接口住院、门诊通用
	if (MRDiagnosCount > 0) {
		ShowCPW(ServerObj.EpisodeID, ServerObj.PAAdmType);
	}
}
function AddToTemplateclickhandler() {
	var ids = $('#tabDiagnosEntry').jqGrid("getGridParam", "selarrrow");
	if (ids == null || ids.length == 0) {
		$.messager.alert("提示", "请选择需要添加到模板的诊断");
		return;
	}
	destroyDialog("AddTempDiag");
	var Content = initDiagDivHtml("AddDiagToTemp");
	var iconCls = "icon-w-ok";
	DiagCreateModalDialog("AddTempDiag", $g("添加到模板"), 380, 260, iconCls, $g("确定"), Content, "SaveToPriateTemp()");
	var cbox = $HUI.combobox("#combo_TemplateList", {
		editable: false,
		multiple: false,
		mode: "remote",
		method: "GET",
		selectOnNavigation: true,
		valueField: 'DHCDIAMASRowid',
		textField: 'DHCDIADESC'
	});
	//加入科室权限验证
	var dataTemplUse = [];
	dataTemplUse.push({ "id": "U", "text": $g("个人模板"), "selected": true });
	if (ServerObj.IsHaveMenuAuthDiagFav == 1) {
		dataTemplUse.push({ "id": "L", "text": $g("科室模板") })
	}
	var cbox = $HUI.combobox("#combo_TemplateCategroy", {
		valueField: 'id',
		textField: 'text',
		editable: false,
		multiple: false,
		data: dataTemplUse,
		onSelect: function (rec) {
			LoadDiagTemplateList(rec["id"], 0);
		}
		, onLoadSuccess: function () {
			LoadDiagTemplateList("U", 0);
		}
	});
	$("#BtnNewTemplate").click(function () {
		$("#Newtr").show();
		$("#TemplatName").focus();
	});
	$("#BtnAddTemplate").click(AddTemplateClickHandle);
}
function AddTemplateClickHandle() {
	var Name = $.trim($("#TemplatName").val());
	if (Name == "") {
		$.messager.alert("提示", "新增诊断模板名字不能为空!", "info", function () {
			$("#TemplatName").focus();
		});
		return false;
	}
	var sbox = $HUI.combobox("#combo_TemplateList");
	var data = sbox.getData();
	var INDEXNum = 1, RepeatFlag = 0;
	for (var i = 0; i < data.length; i++) {
		if ((Name == data[i].DHCDIADESC) && (data[i].DHCDIAMASRowid != "")) {
			RepeatFlag = 1;
			break;
		}
		INDEXNum = parseInt(INDEXNum) + 1;
	}
	if (RepeatFlag == 1) {
		$.messager.alert("提示", $g("您添加的模板【") + Name + $g("】,已存在,请直接选择保存"));
		return false;
	}
	var sbox = $HUI.combobox("#combo_TemplateCategroy");
	var type = sbox.getValue();
	if (type == "U") {
		$.m({
			ClassName: "web.DHCDocDiagnosEntryV8",
			MethodName: "AddPrivate",
			PrivateDesc: Name,
			USERID: session['LOGON.USERID']
		}, function (val) {
			LoadDiagTemplateList(type, 1); //刷新模板列表下拉框,并自动选中新增的模板名称
			$("#TemplatName").val("");
		});
	} else {
		$.m({
			ClassName: "web.DHCDocDiagnosEntryV8",
			MethodName: "AddLocTemplet",
			Name: Name,
			CTLocRowid: session['LOGON.CTLOCID']
		}, function (val) {
			LoadDiagTemplateList(type, 1); //刷新模板列表下拉框,并自动选中新增的模板名称
			$("#TemplatName").val("");
		});
	}
}
function LoadDiagTemplateList(type, flag) {
	var USERID = session['LOGON.USERID'];
	var LOCID = session['LOGON.CTLOCID'];
	if (type == "U") {
		LOCID = "";
	} else {
		USERID = "";
	}
	$.q({
		ClassName: "web.DHCDocDiagnosEntryV8",
		QueryName: "DiagTemplateList",
		USERID: USERID,
		LOCID: LOCID
	}, function (GridData) {
		$HUI.combobox('#combo_TemplateList', {
			data: GridData.rows
		});
		var sbox = $HUI.combobox("#combo_TemplateList");
		var data = sbox.getData();
		if (flag == 0) sbox.select(data[0].DHCDIAMASRowid);
		else sbox.select(data[data.length - 1].DHCDIAMASRowid);
	});
}
function DiagCreateModalDialog(id, _title, _width, _height, _icon, _btntext, _content, _event) {
	if (_btntext == "") {
		var buttons = [{
			text: $g('关闭'),
			iconCls: 'icon-w-close',
			handler: function () {
				destroyDialog(id);
			}
		}];
	} else {
		var buttons = [{
			text: $g(_btntext),
			iconCls: _icon,
			handler: function () {
				if (_event != "") eval(_event);
			}
		}, {
			text: $g('关闭'),
			iconCls: 'icon-w-close',
			handler: function () {
				destroyDialog(id);
			}
		}]
	}
	$("body").append("<div id='" + id + "' class='hisui-dialog'></div>");
	if (_width == null)
		_width = 800;
	if (_height == null)
		_height = 500;

	$("#" + id).dialog({
		title: _title,
		width: _width,
		height: _height,
		cache: false,
		iconCls: _icon,
		//href: _url,
		collapsible: false,
		minimizable: false,
		maximizable: false,
		resizable: false,
		modal: true,
		closed: false,
		closable: false,
		content: _content,
		buttons: buttons
	});
}
function initDiagDivHtml(type) {
	if (type == "AddDiagToTemp") {
		var html = "<div style='margin:5px;'><table class='search-table'>"

		html += "	 <tr>"

		html += "	 <td class='r-label'>"
		html += "	 " + $g("模板分类")
		html += "	 </td>"
		html += "	 <td>"
		html += "	 <input id='combo_TemplateCategroy' class='textbox'/>"
		html += "	 </td>"

		html += "	 </tr>"

		html += "	 <tr>"

		html += "	 <td class='r-label'>"
		html += "	 " + $g("模板名称")
		html += "	 </td>"
		html += "	 <td>"
		//html +="	 <input id='combo_TemplateList' editable='false' class='hisui-combobox'></input>"
		html += "	 <input id='combo_TemplateList' class='textbox'/>"
		html += "	 </td>"

		html += "	 <td class='r-label'>"
		html += "	 <a id='BtnNewTemplate' href=#' class='hisui-linkbutton' data-options=" + "iconCls:'icon-w-add'" + " >" + $g("新建") + "</a>"
		html += "	 </td>"
		html += "	 </tr>"

		html += "	 <tr id='Newtr' style='display:none;'>"

		html += "	 <td>"
		html += "	 "
		html += "	 </td>"

		html += "	 <td>"
		html += "	 <input id='TemplatName' class='textbox'>"
		html += "	 </td>"

		html += "	 <td class='r-label'>"
		html += "	 <a id='BtnAddTemplate' href=#' class='hisui-linkbutton' data-options=" + "iconCls:'icon-w-add'" + " >" + $g("增加") + "</a>"
		html += "	 </td>"

		html += "	 </tr>"

		html += "</div></table>"
	} else if (type = "CopyDiag") {
		var html = "<div style='margin:5px;'><table>"
		html += "	 <tr>"

		html += "	 <td class='r-label'>"
		html += "	 " + $g("诊断类型")
		html += "	 </td>"
		html += "	 <td>"
		html += "	 <input id='combo_DiagType' class='textbox'/>"
		html += "	 </td>"

		html += "	 </tr>"


		html += "</div></table>"
	}
	return html;
}
function destroyDialog(id) {
	$("body").remove("#" + id); //移除存在的Dialog
	$("#" + id).dialog('destroy');
}
function GetAdmPara() {
	var DiagnosValue = 1
	var Admway = "", ILI = "", ReAdmis = "", FirstAdm = "", OutReAdm = "", TransAdm = "";
	if (ServerObj.PAAdmType != "I") {
		var o = $HUI.radio("#ReAdmis")
		if (o.getValue() == true) { ReAdmis = "R"; Admway = "MZFZ"; } else { ReAdmis = ""; }
		var o = $HUI.radio("#FirstAdm")
		if (o.getValue() == true) { FirstAdm = "F"; Admway = "CZ" } else { FirstAdm = ""; }
		var o = $HUI.radio("#OutReAdm")
		if (o.getValue() == true) { OutReAdm = "R"; Admway = "CYFZ"; } else { OutReAdm = ""; }
		var o = $HUI.checkbox("#TransAdm")
		if (o.getValue() == true) { TransAdm = "Y"; Admway = "ZZ" } else { TransAdm = ""; }
		var o = $HUI.checkbox("#ILI")
		if (o.getValue() == true) { ILI = "Y" }
	}


	var BPSystolic = $("#BPSystolic").val();
	var BPDiastolic = $("#BPDiastolic").val();
	var Weight = $("#Weight").val();
	var o = $HUI.combobox("#Special");
	var Specialist = o.getValues().join("!");
	var Subject = ""
	var PhysiologicalCycle = $("#PhysiologicalCycle").combobox('getValue');
	if (PhysiologicalCycle == undefined) PhysiologicalCycle = "";
	var Height = $("#Height").val();
	var AdmPara = ReAdmis + "^" + Specialist + "^" + Subject + "^" + Weight + "^" + FirstAdm + "^" + OutReAdm + "^" + TransAdm + "^" + ILI + "^" + DiagnosValue + "^" + Admway + "^" + BPSystolic + "^" + BPDiastolic + "^" + PhysiologicalCycle + "^" + Height;
	return AdmPara;
}
function CheckBeforeInsertMRDiag(EpisodeID, callBackFun) {
	if (!CheckIsAdmissions(ServerObj.EpisodeID)) return false;
	if (!CheckAdmBlood()) return false;
	var SeriousDiseaseICDStr = "", DiagnosNotesStr = "", RepeatDiagStr = "";
	var IsExistMainDISDiag = 0, IsExistDISDiag = 0;
	var IsExistMainAdmitDiag = 0, IsExistAdmitDiag = 0;
	var DiagMRCIDRowIdArray = new Array();
	var DiagNotesArray = new Array();
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	for (var i = 0; i < rowids.length; i++) {
		var MRDIARowId = GetCellData(rowids[i], "MRDIARowId");
		var MRCIDRowId = GetCellData(rowids[i], "MRCIDRowId");
		var NotesRowId = GetCellData(rowids[i], "NotesRowId");
		var DiagnosICDDesc = GetCellData(rowids[i], "DiagnosICDDesc");
		if (DiagnosICDDesc == "") MRCIDRowId = "";
		var DiagnosNotes = GetCellData(rowids[i], "DiagnosNotes");
		if (DiagnosNotes != "") {
			DiagnosNotes = DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
		}
		if ((MRCIDRowId == "") && (DiagnosNotes == "")) {
			if (MRDIARowId != "") {
				$.messager.alert('提示', $g('第') + rowids[i] + $g("条诊断,修改后的诊断备注不能为空!"), "info", function () {
					SetFocusCell(rowids[i], "DiagnosNotes");
				});
				return false;
			} else {
				continue;
			}
		}
		var DiagnosDoctor = GetCellData(rowids[i], "DiagnosDoctor");
		var DiagnosOnsetDate = GetCellData(rowids[i], "DiagnosOnsetDate");
		if (DiagnosOnsetDate != "") {
			if (ServerObj.SYSDateFormat == "4") {
				var tmpDiagnosOnsetDate = DiagnosOnsetDate.split("/")[2] + "-" + DiagnosOnsetDate.split("/")[1] + "-" + DiagnosOnsetDate.split("/")[0]
				var DiagOnsetDate = new Date(tmpDiagnosOnsetDate.replace("-", "/").replace("-", "/"));
			} else {
				var DiagOnsetDate = new Date(DiagnosOnsetDate.replace("-", "/").replace("-", "/"));
			}
			var end = new Date();
			if (!DATE_FORMAT.test(DiagnosOnsetDate)) {
				$.messager.alert('提示', $g('第') + rowids[i] + $g("条诊断的发病日期格式不正确!"), "info", function () {
					SetFocusCell(rowids[i], "DiagnosOnsetDate");
				});
				return false;
			} else if (DiagOnsetDate > end) {
				$.messager.alert('提示', $g('第') + rowids[i] + $g("条诊断的发病日期不能大于今天!"), "info", function () {
					SetFocusCell(rowids[i], "DiagnosOnsetDate");
				});
				return false;
			}
		} else {
			$.messager.alert("提示", "发病日期不能为空", "info", function () {
				SetFocusCell(rowids[i], "DiagnosOnsetDate");
			});
			return false;
		}
		var DiagnosDate = GetCellData(rowids[i], "DiagnosDate");
		if (DiagnosDate != "") {
			if (ServerObj.SYSDateFormat == "4") {
				var tmpDiagnosDate = DiagnosDate.split("/")[2] + "-" + DiagnosDate.split("/")[1] + "-" + DiagnosDate.split("/")[0]
				var DiagDate = new Date(tmpDiagnosDate.replace("-", "/").replace("-", "/"));

				var AdmBedDate = ServerObj.AdmBedDate.split("/")[2] + "-" + ServerObj.AdmBedDate.split("/")[1] + "-" + ServerObj.AdmBedDate.split("/")[0];
				var AdmBedDate = new Date(AdmBedDate.replace("-", "/").replace("-", "/"));
			} else {
				var DiagDate = new Date(DiagnosDate.replace("-", "/").replace("-", "/"));
				var AdmBedDate = new Date(ServerObj.AdmBedDate.replace("-", "/").replace("-", "/"));
			}
			var end = new Date();
			if (!DATE_FORMAT.test(DiagnosDate)) {
				$.messager.alert('提示', $g('第') + rowids[i] + $g("条诊断的诊断日期格式不正确!"), "info", function () {
					SetFocusCell(rowids[i], "DiagnosDate");
				});
				return false;
			} else if (DiagDate > end) {
				$.messager.alert('提示', $g('第') + rowids[i] + $g("条诊断的诊断日期不能大于今天!"), "info", function () {
					SetFocusCell(rowids[i], "DiagnosDate");
				});
				return false;
			} else if (DiagDate < AdmBedDate) {
				if (((MRDIARowId != "") && (DiagnosDoctor == "")) || (ServerObj.PAAdmType != "I")) {
				} else {
					$.messager.alert('提示', $g('第') + rowids[i] + $g("条诊断的诊断日期不能早于分床日期: ") + ServerObj.AdmBedDate, "info", function () {
						SetFocusCell(rowids[i], "DiagnosDate");
					});
					return false;
				}
			} else {
				if ((DiagnosOnsetDate != "") && (DiagDate < DiagOnsetDate)) {
					$.messager.alert('提示', $g('第') + rowids[i] + $g("条诊断的诊断日期不能早于发病日期: ") + DiagnosOnsetDate, "info", function () {
						SetFocusCell(rowids[i], "DiagnosDate");
					});
					return false;
				}
			}
		}
		var DiagnosType = GetCellData(rowids[i], "DiagnosTypeRowId");
		var DiagnosTypeDesc = GetCellData(rowids[i], "DiagnosType");
		if ((MRDIARowId == "") && (DiagnosType == "")) {
			$.messager.alert("提示", "诊断类型不能为空", "info");
			return false;
		}
		var MainDiagFlag = GetCellData(rowids[i], "MainDiagFlag"); //
		if (DiagnosType == ServerObj.DISDiagnosTypeRowId) {
			IsExistDISDiag = 1;
			if (MainDiagFlag == $g("是")) {
				IsExistMainDISDiag = 1;
			}
		}

		if (DiagnosTypeDesc == $g("入院诊断")) {
			IsExistAdmitDiag = 1;
			if (MainDiagFlag == $g("是")) {
				IsExistMainAdmitDiag = 1;
			}
		}
		if (MRDIARowId == "") {
			if ((MRCIDRowId != "") && (MRCIDRowId != null)) {
				if (!CheckDiagIsEnabled(MRCIDRowId)) return false;
				var SeriousDisease = cspRunServerMethod(ServerObj.GetSeriousDiseaseByICDMethod, MRCIDRowId);
				if (SeriousDisease == "Y") {
					if (SeriousDiseaseICDStr == "") SeriousDiseaseICDStr = DiagnosICDDesc;
					else SeriousDiseaseICDStr = SeriousDiseaseICDStr + "," + DiagnosICDDesc;
				}
				var Str = MarchDiagnosis(MRCIDRowId);
				if (DiagMRCIDRowIdArray[MRCIDRowId]) Str = 1;
				var DiagnosICDDesc = $('#' + rowids[i] + '_DiagnosICDDesc').val();
				if (Str == 1) {
					if (RepeatDiagStr == "") RepeatDiagStr = DiagnosICDDesc;
					else RepeatDiagStr = RepeatDiagStr + "," + DiagnosICDDesc;
				}
				DiagMRCIDRowIdArray[MRCIDRowId] = 1;
			} else {
				if (ServerObj.NotEntryNoICDDiag == "1") {
					$.messager.alert('提示', '第' + rowids[i] + "条诊断【" + DiagnosNotes + "】是非ICD诊断,不能录入!", "info", function () {
						SetFocusCell(rowids[i], "DiagnosNotes");
					});
					return false;
				}
				if (DiagnosNotesStr == "") DiagnosNotesStr = DiagnosNotes;
				else DiagnosNotesStr = DiagnosNotesStr + "," + DiagnosNotes;
				var ret = cspRunServerMethod(ServerObj.GetMRDiagnoseList, ServerObj.mradm, '');
				if (ret != '') {
					var retarry = ret.split(String.fromCharCode(1));
					for (k = 0; k < retarry.length; k++) {
						var retItemArry = retarry[k].split('^');
						var id = retItemArry[1];
						var DiagnosICDCode = retItemArry[4];
						var DiagnosNote = retItemArry[6];
						if ((DiagnosICDCode == "") && (DiagnosNote != "") && (DiagnosNotes != "") && (ServerObj.mradm != id)) {
							var Str1 = $.trim(DiagnosNote);
							if (((Str1 == DiagnosNotes) && (Str1 != "") || (DiagNotesArray[DiagnosNotes])) && (DiagnosNotes != "")) {
								if (RepeatDiagStr == "") RepeatDiagStr = DiagnosNotes;
								else RepeatDiagStr = RepeatDiagStr + "," + DiagnosNotes;
							}
						}
					}
				} else {
					if (DiagNotesArray[DiagnosNotes]) {
						if (RepeatDiagStr == "") RepeatDiagStr = DiagnosNotes;
						else RepeatDiagStr = RepeatDiagStr + "," + DiagnosNotes;
					}
				}
				DiagNotesArray[DiagnosNotes] = 1;	//
			}
		}
		//
	}
	new Promise(function (resolve, rejected) {
		if ((IsExistDISDiag == 1) && (IsExistMainDISDiag == 0)) {
			$.messager.confirm('提示', "此次所开出院诊断列表中没有【主诊断】,请确认是否继续保存?", function (r) {
				if (r) {
					resolve();
				}
			});
			return;
		}
		resolve();
	}).then(function () {
		return new Promise(function (resolve, rejected) {
			if ((IsExistAdmitDiag == 1) && (IsExistMainAdmitDiag == 0)) {
				$.messager.confirm('提示', "此次所开入院诊断列表中没有【主诊断】,请确认是否继续保存?", function (r) {
					if (r) {
						resolve();
					}
				});
				return;
			}
			resolve();
		})
	}).then(function () {
		return new Promise(function (resolve, rejected) {
			if (DiagnosNotesStr != "") {
				$.messager.confirm('提示', "是否确定录入非标准ICD诊断?", function (r) {
					if (r) {
						resolve();
					}
				});
				return;
			}
			resolve();
		})
	}).then(function () {
		return new Promise(function (resolve, rejected) {
			if (RepeatDiagStr != "") {
				$.messager.confirm('提示', RepeatDiagStr + $g(",所加诊断在本次诊断中已经存在,请确认是否重复增加?"), function (r) {
					if (r) {
						resolve();
					}
				});
				return;
			}
			resolve();
		})
	}).then(function () {
		return new Promise(function (resolve, rejected) {
			if (SeriousDiseaseICDStr != "") {
				$.messager.alert("提示", SeriousDiseaseICDStr + $g("诊断为传染病诊断,请注意及时上报."), "info", function () {
					resolve();
				});
				return;
			}
			resolve();
		})
	}).then(function () {
		callBackFun();
	})
}
function MarchDiagnosis(DiagnosValue) {
	var Str = cspRunServerMethod(ServerObj.FlagMarchDiagnose, ServerObj.mradm, DiagnosValue);
	return Str;
}
function CheckIsAdmissions(EpisodeID) {
	if (ServerObj.EpisodeID == "") return false;
	var UserID = session['LOGON.USERID'];
	var ret = cspRunServerMethod(ServerObj.CheckIsAdmissionsMethod, ServerObj.EpisodeID, UserID)
	if (ret != "") {
		$.messager.alert("警告", "接诊失败," + ret, "error");
		return false;
	}
	return true;
}
function CheckAdmBlood() {
	var BPSystolic = $("#BPSystolic").val().replace(/(^\s*)|(\s*$)/g, '');
	var BPDiastolic = $("#BPDiastolic").val().replace(/(^\s*)|(\s*$)/g, '');
	if (ServerObj.NeedStolicMast == 1) {
		if ((BPSystolic == "") || (BPDiastolic == "")) {
			$.messager.alert("提示", "请录入完整的血压值", "", function () {
				$("#BPSystolic").focus();
				//$("#BPDiastolic").focus();
			});

			return false;
		}
	}
	var r = /^[0-9]*[1-9][0-9]*$/
	if ((BPSystolic != "") && (!r.test(BPSystolic))) {
		$.messager.alert("提示", "收缩压只能录入数字!", "", function () {
			$("#BPSystolic").focus();
		});
		return false;
	}
	if ((BPDiastolic != "") && (!r.test(BPDiastolic))) {
		$.messager.alert("提示", "舒张压只能录入数字!", "", function () {
			$("#BPDiastolic").focus();
		});
		return false;
	}
	return true;
}
function CheckAddDiag(EpisodeID) {
	var CheckAddret = cspRunServerMethod(ServerObj.CheckAdd, EpisodeID);
	if (CheckAddret != "") {
		if (CheckAddret == 'Discharged') {
			$.messager.alert("提示", "由于患者已出院,不能增加新诊断", "info");
			return false;
		} else if (CheckAddret == 'Cancel') {
			$.messager.alert("提示", "由于患者已经退院，不能增加新诊断", "info");
			return false;
		} else if (CheckAddret == "OPCancel") {
			$.messager.alert("提示", "由于患者已经退号，不能增加新诊断", "info");
			return false;
		}
	}
	return true;
}
//判断所录入诊断是否有效
function CheckDiagIsEnabled(MRCICDRowidStr, callback) {
	if (MRCICDRowidStr == "") return true;
	var MRCICDRowidStr = MRCICDRowidStr.replace(String.fromCharCode(2), "!")
	var reg = /(\*)|(\^)|(\:)|(\!)|(\-)|(\String.fromCharCode(2))/g;
	var MRCICDRowidStrArr = MRCICDRowidStr.replace(reg, "!").split("!")
	for (var i = 0; i < MRCICDRowidStrArr.length; i++) {
		var MRCICDRowid = MRCICDRowidStrArr[i];
		if (MRCICDRowid == "") {
			continue
		}
		var ret = tkMakeServerCall("web.DHCMRDiagnos", "CheckICDIsEnabled", MRCICDRowid, ServerObj.EpisodeID)
		if (ret != "") {
			setTimeout(function () {
				$.messager.alert("提示", ret, "info", function () {
					if (callback) {
						callback();
					}
				});
			});
			return false;
		}
	}
	return true;
}
/*function GetDiagDataOnAdd(){
	 var DiagItemStr=""
	 var MRCIDRowId=""
	 //var rows=$('#tabDiagnosEntry').jqGrid("getGridParam", "records");
	 var rowids = $('#tabDiagnosEntry').getDataIDs();
	 for (var i = 0; i < rowids.length; i++) {
		 var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
		 var MRDIARowId=GetCellData(rowids[i],"MRDIARowId");
		 var MRCIDRowId=GetCellData(rowids[i],"MRCIDRowId");
		 var DiagnosTypeRowId=GetCellData(rowids[i],"DiagnosTypeRowId");
		 var DiagnosOnsetDate=GetCellData(rowids[i],"DiagnosOnsetDate");
		 var DiagnosNotes=GetCellData(rowids[i],"DiagnosNotes");
		 if (DiagnosNotes!="") DiagnosNotes=DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g,"");
		 var DiagnosICDDesc=GetCellData(rowids[i],"DiagnosICDDesc");
		 if (DiagnosICDDesc=="") MRCIDRowId="";
		 var MainDiagFlag=GetCellData(rowids[i],"MainDiagFlag");
		 if (MainDiagFlag=="是") MainDiagFlag="Y";
		 else MainDiagFlag="N";
		 var DiagnosStatusRowId=GetCellData(rowids[i],"DiagnosStatusRowId");
		 var DiagnosCatRowId=GetCellData(rowids[i],"DiagnosCatRowId"); //分类
		 var DiagnosDate=GetCellData(rowids[i],"DiagnosDate");
		 var LongDiagnosFlagRowId=GetCellData(rowids[i],"LongDiagnosFlagRowId");
		 if (MRCIDRowId=="") LongDiagnosFlagRowId="";
		 if ((MRCIDRowId=="")&&(DiagnosNotes=="")){ continue ;}
		 //孕周诊断
		 if (MRCIDRowId==ServerObj.WeekGestationDia){
			var LMPMRCIDRowId="",LMPResult=""
			var LMPResultStr=tkMakeServerCall("web.DHCDocDiagnosEntryV8","GetPatLMPResultByLMP",ServerObj.PatientID)
			if (LMPResultStr!=""){
				var LMPResultArr=LMPResultStr.split(String.fromCharCode(2));
				var LMPDate=LMPResultArr[2];
				if (dhcsys_confirm("根据患者上次月经时间:"+LMPDate+"自动计算结果:"+LMPResultArr[1]+",是否按此结果保存?")){
					LMPMRCIDRowId=LMPResultArr[0];
					LMPResult=LMPResultArr[1];
					MRCIDRowId=LMPMRCIDRowId;
				}
			}
			if (LMPMRCIDRowId==""){
				  rtnStr=window.showModalDialog("diagnosentry.tools.lmpdate.hui.csp?PatientID="+ServerObj.PatientID,"","dialogHeight: "+(370)+"px; dialogWidth: "+(580)+"px");
				  //MRCIDRowId=window.open("diagnosentry.tools.lmpdate.csp","diagnosentry","status=1,center=1,resizable=1,scrollbars=1,width=800,height=680")
				  if ((typeof rtnStr=="undefined")||(rtnStr=="")){
					continue; 
				}else{
					rtnStrArr=rtnStr.split(String.fromCharCode(2));
					MRCIDRowId=rtnStrArr[0];
					var LMPResult=rtnStrArr[1];
				}
			}
			if (LMPResult!=""){
				if (DiagnosNotes=="") DiagnosNotes=LMPResult;
				else DiagnosNotes=DiagnosNotes+" "+LMPResult;
			}
		 }
		 
		 if (DiagnosCatRowId=="2") {continue;}
		 if ((DiagnosCatRowId=="1")&&(MRDIARowId=="")){ 
			 var SyndromeInfo=GetSyndromeListInfo(i);
		 }else{
			 var SyndromeInfo="";
		 }
		 if ((DiagnosNotes!="")&&(MRDIARowId=="")) DiagnosNotes=DiagnosNotes+"#"+(parseInt(DiagnosCatRowId)+1);
		 var SyndromeCICDStr="",SyndromeCDescStr=""
		 if (SyndromeInfo!=""){
			 SyndromeCICDStr=SyndromeInfo.split(String.fromCharCode(1))[0];
			 SyndromeCDescStr=SyndromeInfo.split(String.fromCharCode(1))[1];
		 }
		 var DiagnosBodyPartId=GetCellData(i,"DiagnosBodyPartRowId");
		 if(MRDIARowId!=""){ //已保存过的诊断修改
			 var OneDiagItemStr=MRDIARowId+"^"+DiagnosNotes+"^"+DiagnosTypeRowId+"^"+MainDiagFlag+"^"+DiagnosStatusRowId+"^"+DiagnosOnsetDate+"^"+DiagnosBodyPartId+"^"+DiagnosDate+"^"+LongDiagnosFlagRowId;
		 }else{
			 var OneDiagItemStr=""+"^"+DiagnosNotes+"^"+MRCIDRowId+"^"+DiagnosTypeRowId+"^"+MainDiagFlag
			 OneDiagItemStr=OneDiagItemStr+"^"+DiagnosStatusRowId+"^"+DiagnosOnsetDate+"^"+SyndromeCICDStr+"^"+SyndromeCDescStr+"^"+DiagnosBodyPartId;
			 OneDiagItemStr=OneDiagItemStr+"^"+DiagnosDate+"^"+LongDiagnosFlagRowId;
		 }
		 if (DiagItemStr==""){DiagItemStr=OneDiagItemStr}else{DiagItemStr=DiagItemStr+String.fromCharCode(1)+OneDiagItemStr}
	 }
	 return DiagItemStr;
 }*/
function GetSyndromeListInfo(index) {
	var SyndromeCICDStr = "";
	var SyndromeCDescStr = "";
	//var rowCount=$('#tabDiagnosEntry').jqGrid("getGridParam", "records");
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	index = parseInt(index)
	for (var k = index + 1; k < rowids.length; k++) {
		var SynDiagnosCatRowId = GetCellData(rowids[k], "DiagnosCatRowId");
		if (SynDiagnosCatRowId == "2") { //证型
			var SynMRCIDRowId = GetCellData(rowids[k], "MRCIDRowId");
			var SynMRCIDDesc = GetCellData(rowids[k], "DiagnosICDDesc");
			if (SynMRCIDDesc == "") SynMRCIDRowId = "";
			var SynDiagnosNotes = GetCellData(rowids[k], "DiagnosNotes");
			if (SynDiagnosNotes != "") SynDiagnosNotes = SynDiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
			if ((SynMRCIDRowId == "") && (SynDiagnosNotes == "")) continue;


			var SynDiagnosTypeRowId = GetCellData(rowids[k], "DiagnosTypeRowId");
			var SynMainDiagFlag = GetCellData(rowids[k], "MainDiagFlag");
			if (SynMainDiagFlag == "是") SynMainDiagFlag = "Y";
			else SynMainDiagFlag = "N";
			var SynDiagnosStatusRowId = GetCellData(rowids[k], "DiagnosStatusRowId");
			var SynDiagnosOnsetDate = GetCellData(rowids[k], "DiagnosOnsetDate");
			var SynDiagnosDiagnosDate = GetCellData(rowids[k], "DiagnosDate");


			if ((SynDiagnosNotes != "")) { //(SynMRCIDRowId=="")&&
				SynDiagnosNotes = SynDiagnosNotes + "#3";
			} else {
				SynDiagnosNotes = "";
			}
			var LongDiagnosFlagRowId = GetCellData(rowids[k], "LongDiagnosFlagRowId");
			var DiagnosPrefix = GetCellData(rowids[k], "DiagnosPrefix");
			if (DiagnosPrefix != "") DiagnosPrefix = DiagnosPrefix.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
			if (SynMRCIDRowId == "") LongDiagnosFlagRowId = "";
			SynMRCIDRowId = SynMRCIDRowId + String.fromCharCode(2) + SynDiagnosTypeRowId + String.fromCharCode(2) + SynMainDiagFlag;
			SynMRCIDRowId = SynMRCIDRowId + String.fromCharCode(2) + SynDiagnosStatusRowId + String.fromCharCode(2) + SynDiagnosOnsetDate + String.fromCharCode(2) + SynDiagnosDiagnosDate + String.fromCharCode(2) + LongDiagnosFlagRowId + String.fromCharCode(2) + DiagnosPrefix;
			if ((SyndromeCICDStr == "") && (SyndromeCDescStr == "")) {
				SyndromeCICDStr = SynMRCIDRowId;
				SyndromeCDescStr = SynDiagnosNotes;
			} else {
				SyndromeCICDStr = SyndromeCICDStr + "$" + SynMRCIDRowId;
				SyndromeCDescStr = SyndromeCDescStr + "$" + SynDiagnosNotes;
			}
		} else {
			break;
		}
	}
	return SyndromeCICDStr + String.fromCharCode(1) + SyndromeCDescStr;
}
//双击模板或历史记录添加到录入框
function AddDiagItemtoList(MRCICDRowId, MRCICDNotes, CMFlag, DiagnosPrefix) {
	var CruRow = GetPreRowId();
	if (CheckIsClear(CruRow) == true) {
		DeleteRow(CruRow);
	}
	/*if (MRCICDRowId!=""){
		var Str=MarchDiagnosis(MRCICDRowId);
		if (Str==1){
			var vaild = window.confirm("所加诊断在本次诊断中已经存在，请确认是否重复增加?");
			if(!vaild) {
				ClearRow(CruRow);
				return false;
			}
		}
	}*/
	Add_Diag_row();
	var CruRow = GetPreRowId();
	if (MRCICDRowId != "") {
		var ret = cspRunServerMethod(ServerObj.GetICDInfoByICDDrMethod, MRCICDRowId);
		var RetArr = ret.split("^");
		var DiagnosCatRowId = RetArr[2];
		//if (DiagnosCatRowId=="1"){
		SetCellData(CruRow, "DiagnosCat", RetArr[2]);
		SetCellData(CruRow, "DiagnosCatRowId", RetArr[2]);
		//}
		SetCellData(CruRow, "DiagnosICDDesc", RetArr[1]);
		SetCellData(CruRow, "MRCIDRowId", MRCICDRowId);
		SetCellData(CruRow, "MRCIDCode", RetArr[0]);
	} else {
		if (CMFlag == "Y") {
			SetCellData(CruRow, "DiagnosCat", 1);
			SetCellData(CruRow, "DiagnosCatRowId", 1);
		}
	}
	if (MRCICDNotes != "") {
		SetCellData(CruRow, "DiagnosNotes", MRCICDNotes);
	}
	if (DiagnosPrefix != "") {
		SetCellData(CruRow, "DiagnosPrefix", DiagnosPrefix);
	}
}
//检查行是否空白行
function CheckIsClear(rowid) {
	var MRCIDRowId = GetCellData(rowid, "MRCIDRowId");
	var DiagnosNotes = GetCellData(rowid, "DiagnosNotes");
	if (DiagnosNotes != "") DiagnosNotes = DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
	if ((MRCIDRowId != "") || (DiagnosNotes != "")) {
		return false;
	} else {
		return true;
	}
}
//删除一行
function DeleteRow(rowid) {
	$('#DiagnosEntry_DataGrid').delRowData(rowid);
}
function ReloadDiagEntryGrid(reloadFlag) {
	$("#tabDiagnosEntry").jqGrid("clearGridData");
	$("#tabDiagnosEntry").jqGrid('setGridParam', {
		url: "oeorder.oplistcustom.new.request.csp?action=GetDiagList",
		postData: { USERID: session['LOGON.USERID'], MRADM: ServerObj.mradm, DiagTypeCode: ServerObj.DiagnosTypeCodeStr }
	}).trigger("reloadGrid", [{ current: true }]);
}
function HisMRDiagRepShow() {
	destroyDialog("HisMRDiagRepDiag");
	var rowrecord = DiagHistoryDataGrid.datagrid('getSelected');
	var Desc = rowrecord.Desc;
	var Content = "<table id='tabHisMRDiagRep' cellpadding='5' style='margin:5px;border:none;'></table>";
	var iconCls = "";
	DiagCreateModalDialog("HisMRDiagRepDiag", Desc + " " + $g("重复记录"), 550, 350, iconCls, "", Content, "");
	var Columns = [[
		{ field: 'Rowid', hidden: true, title: '' },
		{ field: 'Desc', title: '诊断' },
		{ field: 'DoctDesc', title: '医生' },
		{ field: 'MRDate', title: '诊断日期' },
		{ field: 'MRtime', title: '诊断时间' },
		{ field: 'AdmDep', title: '就诊科室' }
	]]
	InPatExecFeeDataGrid = $("#tabHisMRDiagRep").datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: false,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 10,
		pageList: [10, 100, 200],
		idField: 'Rowid',
		columns: Columns
	});
	$.q({
		ClassName: "web.DHCDocDiagnosEntryV8",
		QueryName: "HisMRDiagRep",
		PatientID: ServerObj.PatientID,
		MRAdmList: rowrecord.MRAdmList,
		Pagerows: InPatExecFeeDataGrid.datagrid("options").pageSize, rows: 99999
	}, function (GridData) {
		InPatExecFeeDataGrid.datagrid({ loadFilter: pagerFilter }).datagrid('loadData', GridData);
	});
}
function CheckMainDiagCount() {
	var MainDiagCount = 0;
	var MainDiagCount = CheckSaveDiagCount(MainDiagCount);
	if (MainDiagCount > 1) {
		alert($g("出院主诊断不能超过两个"));
		return false;
	} {
		return true;
	}
}
function CheckSaveDiagCount(MainDiagCount) {
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	for (var i = 0; i < rowids.length; i++) {
		var rowid = rowids[i];
		var DiagnosTypeRowId = GetCellData(rowid, "DiagnosTypeRowId");
		var MainDiagFlag = GetCellData(rowid, "MainDiagFlag");
		//alert("DiagnosTypeRowId:"+DiagnosTypeRowId+"**"+"MainDiagFlag:"+MainDiagFlag);
		//var DiagnosICDDesc=GetCellData(rowid,"DiagnosICDDesc")
		if ((DiagnosTypeRowId == 4) && (MainDiagFlag == "是")) {
			MainDiagCount = MainDiagCount + 1;
		}
	}
	return MainDiagCount
}
//获取所有数据 如果行处于编辑状态 这样得到的行数据包含标签
function GetGirdData() {
	//保存数据
	//Save_Order_row();
	var DataArry = new Array();
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	for (var i = 0; i < rowids.length; i++) {
		//不取已经审核诊断 和空白行
		//if(CheckIsItem(rowids[i])==true){continue;}
		var MRDIARowId = GetCellData(rowids[i], "MRDIARowId");
		var MRCIDRowId = GetCellData(rowids[i], "MRCIDRowId");
		if (MRDIARowId != "" || MRCIDRowId == "") { continue; }
		var curRowData = $("#tabDiagnosEntry").getRowData(rowids[i]);
		DataArry[DataArry.length] = curRowData;
	}
	return DataArry;
}
function pagerFilter(data) {
	if (typeof data.length == 'number' && typeof data.splice == 'function') {	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh: false,
		onSelectPage: function (pageNum, pageSize) {
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh', {
				pageNumber: pageNum,
				pageSize: pageSize
			});
			dg.datagrid('loadData', data);
			dg.datagrid('scrollTo', 0); //滚动到指定的行        
		}
	});
	if (!data.originalRows) {
		data.originalRows = (data.rows);
	}
	var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}
function DiagDataToEMR() {
	///引用到病历
	var DiaDataList = new Array();
	var DiaObj = new Object();
	var DiagnosType = DiagnosICDDesc = DiagnosICDDesc = DiagnosNotes = MRCIDCode = DiagnosStatus = DiagnosDoctor = DiagnosDate = DiagnosTime = DiagnosDate = MRDIAMRDIADR = DiagnosCatFlag = DiagnosCat = SelRowFlag = "";
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	for (var i = 0; i < rowids.length; i++) {
		var ChildObjList = new Array();
		var ChildObj = new Object();
		var MRDIARowId = GetCellData(rowids[i], "MRDIARowId");
		if (MRDIARowId == "") continue;
		MRDIAMRDIADR = GetCellData(rowids[i], "MRDIAMRDIADR");
		//if (MRDIAMRDIADR!="") continue;
		DiagnosType = GetCellData(rowids[i], "DiagnosType");
		if (ServerObj.DiagnosTypeStr.indexOf(":" + DiagnosType) < 0) continue;
		DiagnosICDDesc = GetCellData(rowids[i], "DiagnosICDDesc");
		DiagnosICDDesc = DiagnosICDDesc.replace(/\&nbsp;/g, "")
		DiagnosNotes = GetCellData(rowids[i], "DiagnosNotes");
		MRCIDCode = GetCellData(rowids[i], "MRCIDCode");
		DiagnosStatus = GetCellData(rowids[i], "DiagnosStatus");
		DiagnosDoctor = GetCellData(rowids[i], "DiagnosDoctor");
		DiagnosDate = GetCellData(rowids[i], "DiagnosDate");
		DiagnosTime = DiagnosDate.split(" ")[1];
		DiagnosDate = DiagnosDate.split(" ")[0];
		DiagnosCat = GetCellData(rowids[i], "DiagnosCat");
		if (DiagnosCat == $g("西医")) { DiagnosCatFlag = 0 } else { DiagnosCatFlag = 1 }
		DiagnosLeavel = GetCellData(rowids[i], "DiagnosLeavel");
		SelRowFlag = 0;
		if ($("#jqg_tabDiagnosEntry_" + rowids[i]).prop("checked") == true) {
			SelRowFlag = 1;
		}
		DiaObj = { TypeDesc: DiagnosType, ICDDesc: DiagnosICDDesc, MemoDesc: DiagnosNotes, ICDCode: MRCIDCode, EvaluationDesc: DiagnosStatus, UserName: DiagnosDoctor, Date: DiagnosDate, Time: DiagnosTime, BillFlagDesc: DiagnosCat, BillFlag: DiagnosCatFlag, Level: DiagnosLeavel, SelRowFlag: SelRowFlag };
		DiaDataList.push(DiaObj);
	}
	var DiaDataList = diagnosesBtQuote(DiaDataList)
	window.returnValue = $.extend(window.returnValue, { "DiaDataList": DiaDataList });
}
///lxz 保存诊断到电子病历
function SaveMRDiagnosToEMR() {
	if (ServerObj.PAAdmType == "I") {
		return true;
	}
	var ret = tkMakeServerCall("EMRservice.BL.opInterface", "getDiagDataXH", ServerObj.EpisodeID, "@", "");
	try {
		if ((typeof (parent.invokeChartFun) === 'function') || ((window.dialogArguments) && (window.dialogArguments.parent) && (typeof (window.dialogArguments.parent.parent.invokeChartFun) === 'function'))) {
			if (typeof (parent.invokeChartFun) === 'function') {
				if (ServerObj.PAAdmType != "E") {
					parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "diag", ret, "", ServerObj.EpisodeID);
				} else {
					parent.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "diag", ret, "", ServerObj.EpisodeID);
				}
			} else {
				if (ServerObj.PAAdmType != "E") {
					window.dialogArguments.parent.parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "diag", ret, "", ServerObj.EpisodeID);
				} else {
					window.dialogArguments.parent.parent.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "diag", ret, "", ServerObj.EpisodeID);
				}
			}
		}
	} catch (e) {
		return false;
	}
}
//lxz  到达
function UpdateArriveStatus() {
	var LogonUserID = session['LOGON.USERID']
	if (cspRunServerMethod(ServerObj.SetArrivedStatus, ServerObj.EpisodeID, ServerObj.DocID, session['LOGON.CTLOCID'], session['LOGON.USERID']) != '1') { }
}
function InitPatDiagViewGlobal(EpisPatInfo) {
	try {
		var EpisPatObj = eval("(" + EpisPatInfo + ")");
		if ((";" + ServerObj.DiagnosTypeStr).indexOf((";" + EpisPatObj.DedfaultDiagnosTypeID + ":")) == -1) {
			EpisPatObj.DedfaultDiagnosTypeID = ServerObj.DiagnosTypeStr.split(":")[0];
			EpisPatObj.DedfaultDiagnosTypeCode = ServerObj.DiagnosTypeStr.split(";")[0].split(":")[1];
		}
		$.extend(ServerObj, EpisPatObj);
	} catch (e) {
		//此方法局部刷新和页面初始化时会调用,如果报错可能导致错误难排查,需加错误提示性信息
		$.messager.alert("提示信息", $g("调用InitPatDiagViewGlobal函数异常,错误信息：") + e.message);
		return false;
	}
}
function xhrRefresh(refreshArgs) {
	var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatDiagViewGlobal", refreshArgs.adm, "", "", "");
	InitPatDiagViewGlobal(EpisPatInfo);
	if (refreshArgs.copyOeoris) {
		var CopyDiagnosStr = "";
		var copyOeorisArr = refreshArgs.copyOeoris.split("^");
		for (var i = 0; i < copyOeorisArr.length; i++) {
			var dataItem = tkMakeServerCall("web.DHCDocDiagnosEntryV8", "CreateCopyItem", copyOeorisArr[i]);
			if (dataItem == "") continue
			if (CopyDiagnosStr == "") CopyDiagnosStr = dataItem;
			else CopyDiagnosStr = CopyDiagnosStr + String.fromCharCode(2) + dataItem;
		}
		$.extend(ServerObj, { CopyDiagnosStr: CopyDiagnosStr });
	}
	ReloadDiagEntryGrid();
	LoadtabDiagHistoryData();
	InitTempTabs("", "", "Init");
	SetDiagOtherInfo();
	$("#EpisodeID").val(refreshArgs.adm);
	$("#PatientID").val(refreshArgs.papmi);
	//修改url
	if (typeof (history.pushState) === 'function') {
		var Url = window.location.href;
		Url = rewriteUrl(Url, {
			EpisodeID: refreshArgs.adm,
			PatientID: refreshArgs.papmi,
			mradm: refreshArgs.mradm,
			EpisodeIDs: "",
			CopyDiagnosStr: "",
			copyTo: ""
		});
		history.pushState("", "", Url);
	}
	OpenPALongICDWin();
	//return websys_cancel();
}
function overrrideUrl(arg, argVal) {
	var url = window.location.href;
	var newUrl = changeURLArg(url, arg, argVal);
	history.replaceState({}, "", newUrl); //pushState
}
function changeURLArg(url, arg, arg_val) {
	var pattern = arg + '=([^&]*)';
	var replaceText = arg + '=' + arg_val;
	if (url.match(pattern)) {
		var tmp = '/(' + arg + '=)([^&]*)/gi';
		tmp = url.replace(eval(tmp), replaceText);
		return tmp;
	}
	return url;
}
function CheckIsDischarge() {
	if (ServerObj.PAAdmType == "I") {
		var ret = $.cm({
			ClassName: "web.DHCMRDiagnos",
			MethodName: "CheckDelete",
			dataType: "text",
			MRDiagnosRowid: ServerObj.mradm
		}, false);
		if (ret == "Discharged") {
			$.messager.alert("警告", "患者已出院,不能增加诊断");
			return false;
		}
	}
	if (!CheckAddDiag(ServerObj.EpisodeID)) return false;
	return true;
}
function Add_HistoryDiag_btn() {
	var HisDiagMRRowIdStr = "";
	var nodes = $('#tabDiagHistoryTree').tree('getChecked');
	if (nodes != "") {
		for (var i = 0; i < nodes.length; i++) {
			if ((nodes[i].attributes.DiagnosType == "") && (nodes[i].attributes.MRDIARowID == "")) continue;
			if (nodes[i].children != undefined) continue;
			var val = $.m({
				ClassName: "web.DHCDocDiagnosEntryV8",
				MethodName: "GetDataFromHistMRDiag",
				MRDIADr: nodes[i].attributes.MRDIARowID
			}, false);
			//主诊断ICDRowid_$C(2)_主诊断备注_$C(1)_子诊断ICDRowid_$C(2)_子诊断备注
			if (val != "") {
				if (HisDiagMRRowIdStr == "") HisDiagMRRowIdStr = val;
				else HisDiagMRRowIdStr = HisDiagMRRowIdStr + String.fromCharCode(1) + val;
			}
		}
	}
	if (HisDiagMRRowIdStr != "") {
		for (m = 0; m < HisDiagMRRowIdStr.split(String.fromCharCode(1)).length; m++) {
			var oneVal = HisDiagMRRowIdStr.split(String.fromCharCode(1))[m];
			var id = oneVal.split(String.fromCharCode(2))[0];
			var desc = oneVal.split(String.fromCharCode(2))[1];
			var DiagnosCatRowId = oneVal.split(String.fromCharCode(2))[2];
			var DiagnosPrefix = oneVal.split(String.fromCharCode(2))[3];
			if ((id == "") && (ServerObj.NotEntryNoICDDiag == "1")) {
				if (m == 0) {
					$.messager.alert("提示", "非ICD诊断不能录入!");
					return false;
				} else {
					continue;
				}
			}
			if (id != "") {
				if (!CheckDiagIsEnabled(id)) {
					if (m == 0) return false;
					else continue;
				}
			}
			AddDiagItemtoList(id, desc, "", DiagnosPrefix);
			if (id == "") {
				var CruRow = GetPreRowId();
				SetCellData(CruRow, "DiagnosCat", DiagnosCatRowId);
				SetCellData(CruRow, "DiagnosCatRowId", DiagnosCatRowId);
			}
			DHCDocUseCount(id, "User.MRCICDDx");
		}
		if (ServerObj.DiagFromTempOrHisAutoSave == 1) {
			InsertMutiMRDiagnos();
		}
	}
}
function InitDiagnosICDDescLookUp(rowid) {
	$("#" + rowid + "_DiagnosICDDesc").lookup({
		url: $URL,
		mode: 'remote',
		method: "Get",
		idField: 'HIDDEN',
		textField: 'desc',
		columns: [[
			{ field: 'desc', title: '诊断名称', width: 350, sortable: true },
			{ field: 'code', title: '编码', width: 120, sortable: true }
		]],
		pagination: true,
		panelWidth: 500,
		panelHeight: 300,
		isCombo: true,
		minQueryLen: 2,
		delay: '500',
		queryOnSameQueryString: true, //web.DHCMRDiagnos
		queryParams: { ClassName: 'web.DHCDocDiagnosEntryV8', QueryName: 'LookUpWithAlias' },
		onBeforeLoad: function (param) {
			var desc = param['q'];
			if (desc == "") return false;
			var ICDType = GetCellData(rowid, "DiagnosCatRowId");
			param = $.extend(param, {
				desc: desc, loc: '', ver1: "", EpisodeID: ServerObj.EpisodeID, ICDType: ICDType,
				UserId: '', LimitRows: "",
				UseDKBFlag: '0', LocID: session['LOGON.CTLOCID']
			});
		}, onSelect: function (ind, item) {
			var ItemArr = new Array();
			$.each(item, function (key, val) {
				ItemArr.push(val);
			});
			DiagItemLookupSelect(ItemArr.join("^"), rowid);
			DHCDocUseCount(rowid, "User.MRCICDDx");
		}
	});
}
function LongDiagnosFlagChange(e) {
	var rowId = "";
	var obj = websys_getSrcElement(e);
	var rowId = GetEventRow(e);
	var DiagnosICDDesc = GetCellData(rowId, "DiagnosICDDesc");
	var MRCIDRowId = GetCellData(rowId, "MRCIDRowId");
	if (rowId != "") {
		if ((MRCIDRowId == "") || (DiagnosICDDesc == "")) {
			$.messager.alert("提示", "非ICD诊断不能选择长效标识!", "info", function () {
				ClearLongDiagnosFlag(rowId);
			});
			return false;
		}
		var DiagnosCat = GetCellData(rowId, "DiagnosCat");
		var DiagnosCatRowId = GetCellData(rowId, "DiagnosCatRowId");
		if ((DiagnosCatRowId == "1") || (DiagnosCat == "中医")) { //"0:西医;1:中医;2:证型"
			ChangeLinkSynLongDiagnosFlag(rowId, obj.value);
		} else if ((DiagnosCatRowId == "2") || (DiagnosCat == "证型")) {
			var MainRowId = "";
			for (var k = parseInt(rowId) - 1; k >= 1; k--) {
				var tmpDiagnosCatRowId = GetCellData(k, "DiagnosCatRowId");
				if ((DiagnosCatRowId != "0") || (DiagnosCat != "西医")) {
					var DiagnosICDDesc = GetCellData(k, "DiagnosICDDesc");
					var MRCIDRowId = GetCellData(k, "MRCIDRowId");
					var DiagnosCat = GetCellData(k, "DiagnosCat");
					if ((MRCIDRowId != "") && (DiagnosICDDesc != "") && ((tmpDiagnosCatRowId == "1") || (DiagnosCat == "中医"))) {
						MainRowId = k;
						break;
					}
				}
			}
			if (MainRowId == "") {
				$.messager.alert("提示", "该证型对应的中医对应是非ICD诊断,不能设置长效诊断标识!", "info", function () {
					ClearLongDiagnosFlag(rowId);
				});
				return false;
			}
			ChangeLinkSynLongDiagnosFlag(MainRowId, obj.value);
		}
	}
	SetCellData(rowId, "LongDiagnosFlagRowId", obj.value);
	SetFocusCell(rowId, "DiagnosICDDesc");
}
function ChangeLinkSynLongDiagnosFlag(rowId, LongDiagnosFlagRowId) {
	var AllIds = $('#tabDiagnosEntry').getDataIDs();
	for (var k = parseInt(rowId) - 1; k < AllIds.length; k++) {
		var DiagnosCatRowId = GetCellData(AllIds[k], "DiagnosCatRowId");
		var DiagnosCat = GetCellData(AllIds[k], "DiagnosCat");
		if ((k == parseInt(rowId) - 1) || (DiagnosCatRowId == "2") || (DiagnosCat == "证型")) { //
			var DiagnosICDDesc = GetCellData(AllIds[k], "DiagnosICDDesc");
			var MRCIDRowId = GetCellData(AllIds[k], "MRCIDRowId");
			if ((MRCIDRowId != "") && (DiagnosICDDesc != "")) {
				if (DiagnosCatRowId == "") {
					EditRow(AllIds[k]);
				}
				SetCellData(AllIds[k], "LongDiagnosFlagRowId", LongDiagnosFlagRowId);
				SetCellData(AllIds[k], "LongDiagnosFlag", LongDiagnosFlagRowId);
			}
		} else {
			break;
		}
	}
}
function ClearLongDiagnosFlag(rowId) {
	SetCellData(rowId, "LongDiagnosFlagRowId", "");
	SetCellData(rowId, "LongDiagnosFlag", "");
}
function LongDiagnosOpen() {
	websys_showModal({
		url: "dhcdoc.palongicdlist.csp?PatientID=" + ServerObj.PatientID,
		title: '长效诊断列表',
		width: 800, height: 500,
		AddItemToList: AddItemToList
	});
}
function AddItemToList(str) {
	for (var i = 0; i < str.split(",").length; i++) {
		var id = str.split(",")[i];
		if (!CheckDiagIsEnabled(id)) return false;
		AddDiagItemtoList(id, "");
		DHCDocUseCount(id, "User.MRCICDDx");
	}
}
function AddCopyItemToList(str, Type) {
	for (var i = 0; i < str.split(String.fromCharCode(2)).length; i++) {
		var onestr = str.split(String.fromCharCode(2))[i];
		var ids = onestr.split(String.fromCharCode(1))[0];
		var descstr = onestr.split(String.fromCharCode(1))[1];
		var DiagnosPrefixStr = onestr.split(String.fromCharCode(1))[2];
		for (var j = 0; j < ids.split("!").length; j++) {
			var id = ids.split("!")[j];
			/*var desc=descstr.split(",")[j];
			var DiagnosPrefix=DiagnosPrefixStr.split(",")[j];*/
			var desc = descstr.split(String.fromCharCode(3))[j];
			var DiagnosPrefix = DiagnosPrefixStr.split(String.fromCharCode(3))[j];
			var CMFlag = "N";
			if ((j == 0) && (ids.split("!").length >= 2)) {
				CMFlag = "Y";
			}
			if ((id == desc) || (id.indexOf("Desc:") >= 0)) {
				if (ServerObj.NotEntryNoICDDiag == 1) {
					$.messager.alert("提示", desc + " 非ICD诊断不能录入!");
					if (j == 0) {
						return;
					} else {
						continue;
					}
				}
				AddDiagItemtoList("", desc, CMFlag, DiagnosPrefix);
				if (j >= 1) {
					var CruRow = GetPreRowId();
					SetCellData(CruRow, "DiagnosCat", 2);
					SetCellData(CruRow, "DiagnosCatRowId", 2);
				}
			} else {
				if (!CheckDiagIsEnabled(id)) continue;
				if (Type == "CopyFromAllDiag") desc = "";
				AddDiagItemtoList(id, desc, CMFlag, DiagnosPrefix);
				DHCDocUseCount(id, "User.MRCICDDx");
			}
		}

	}
}
//记录基础代码数据使用次数
function DHCDocUseCount(ValueId, TableName) {
	if (ValueId == "") return;
	var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
function OpenPALongICDWin() {
	if (ServerObj.PAAdmType != "I") {
		var MRDiagnoseCount = $.cm({
			ClassName: "web.DHCDocOrderEntry",
			MethodName: "GetMRDiagnoseCount",
			dataType: "text",
			MRADMID: ServerObj.mradm
		}, false);
		if (MRDiagnoseCount == 0) {
			var PALongICDCount = $.cm({
				ClassName: "web.DHCDocDiagnosEntryV8",
				MethodName: "GetPALongICDCount",
				dataType: "text",
				EpisodeID: ServerObj.EpisodeID
			}, false);
			if (PALongICDCount >= 1) {
				$.messager.confirm('提示', '是否引用本患者的长效诊断?', function (r) {
					if (r) {
						LongDiagnosOpen();
					}
				});
			}
		}
	}
}
function DiagnosDelList() {
	websys_showModal({
		url: "dhcdoc.deldiaglist.csp?mradm=" + ServerObj.mradm,
		title: '诊断删除日志',
		width: 900, height: 500
	});
}
function AllDiagnosList() {
	websys_showModal({
		url: "dhcdocpatalldiagnos.csp?PatientID=" + ServerObj.PatientID,
		title: '全部诊断列表',
		width: '95%', height: '95%',
		AddCopyItemToList: AddCopyItemToList
	});
}
function DisableBtn(id, disabled) {
	if (disabled) {
		$HUI.linkbutton("#" + id).disable();
	} else {
		$HUI.linkbutton("#" + id).enable();
	}
}
function InsertMutiMRDiagnos(MRCICDRowid, MRCDiagNote) {
	new Promise(function (resolve, rejected) {
		if (!CheckIsDischarge()) return false;
		resolve();
	}).then(function () {
		return new Promise(function (resolve, rejected) {
			CheckBeforeInsertMRDiag(ServerObj.EpisodeID, resolve)
		})
	}).then(function () {
		return new Promise(function (resolve, rejected) {
			GetDiagDataOnAdd(resolve);
		})
	}).then(function (DiagItemStr) {
		var AdmPara = GetAdmPara();
		var LogDepRowid = session['LOGON.CTLOCID'];
		var LogUserRowid = session['LOGON.USERID'];
		var ret = cspRunServerMethod(ServerObj.InsertMRDiagnosMethod, ServerObj.mradm, DiagItemStr, AdmPara, LogDepRowid, LogUserRowid);
		var SeccessFlag = ret.split('^')[0];
		if (SeccessFlag == '0') {
			AfterInsertDiag(ret);
			UpdateArriveStatus();
			SaveMRDiagnosToEMR();
		} else {
			var ErrorMsg = ret.split('^')[1];
			$.messager.alert("error", "插入诊断失败," + ErrorMsg, "error");
			return false;
		}
	})
}
function GetDiagDataOnAdd(callBackFun) {
	var DiagItemStr = "";
	var rowids = $('#tabDiagnosEntry').getDataIDs();
	new Promise(function (resolve, rejected) {
		(function (callBackFun) {
			function loop(i) {
				new Promise(function (resolve, rejected) {
					var MRCIDRowId = GetCellData(rowids[i], "MRCIDRowId");
					//孕周诊断
					if (MRCIDRowId == ServerObj.WeekGestationDia) {
						(function (callBackFun) {
							new Promise(function (resolve, rejected) {
								var LMPResultStr = tkMakeServerCall("web.DHCDocDiagnosEntryV8", "GetPatLMPResultByLMP", ServerObj.PatientID)
								if (LMPResultStr != "") {
									var LMPResultArr = LMPResultStr.split(String.fromCharCode(2));
									var LMPDate = LMPResultArr[2];
									$.messager.confirm('确认对话框', "根据患者上次月经时间:" + LMPDate + "自动计算结果:" + LMPResultArr[1] + ",是否按此结果保存?", function (r) {
										if (!r) {
											LMPResultStr = "";
										}
										resolve(LMPResultStr);
									})
								} else {
									resolve("");
								}
							}).then(function (data) {
								if (data == "") {
									websys_showModal({
										url: "diagnosentry.tools.lmpdate.hui.csp?PatientID=" + ServerObj.PatientID,
										title: '孕周诊断计算',
										width: 580, height: 370,
										CallBackFunc: function (rtnStr, RowIndex) {
											websys_showModal("close");
											if (typeof rtnStr == "undefined") {
												rtnStr = "";
											}
											callBackFun(rtnStr);
										}
									})
								} else {
									callBackFun(data);
								}
							})
						})(resolve);
					} else {
						resolve();
					}
				}).then(function (LMPResultStr) {
					if (typeof LMPResultStr == "undefined") LMPResultStr = "";
					var OrderItemRowid = GetCellData(rowids[i], "OrderItemRowid");
					var MRDIARowId = GetCellData(rowids[i], "MRDIARowId");
					var MRCIDRowId = GetCellData(rowids[i], "MRCIDRowId");
					var DiagnosTypeRowId = GetCellData(rowids[i], "DiagnosTypeRowId");
					var DiagnosOnsetDate = GetCellData(rowids[i], "DiagnosOnsetDate");
					var DiagnosNotes = GetCellData(rowids[i], "DiagnosNotes");
					if (DiagnosNotes != "") DiagnosNotes = DiagnosNotes.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
					var DiagnosICDDesc = GetCellData(rowids[i], "DiagnosICDDesc");
					if (DiagnosICDDesc == "") MRCIDRowId = "";
					var MainDiagFlag = GetCellData(rowids[i], "MainDiagFlag");
					if (MainDiagFlag == $g("是")) MainDiagFlag = "Y";
					else MainDiagFlag = "N";
					var DiagnosStatusRowId = GetCellData(rowids[i], "DiagnosStatusRowId");
					var DiagnosCatRowId = GetCellData(rowids[i], "DiagnosCatRowId"); //分类
					var DiagnosDate = GetCellData(rowids[i], "DiagnosDate");
					var LongDiagnosFlagRowId = GetCellData(rowids[i], "LongDiagnosFlagRowId");
					if (MRCIDRowId == "") LongDiagnosFlagRowId = "";
					var DiagnosPrefix = GetCellData(rowids[i], "DiagnosPrefix");
					if (DiagnosPrefix != "") DiagnosPrefix = DiagnosPrefix.replace(/[\\\@\#\$\^\&\*\{\}\:\"\<\>\?]/g, "");
					if (MRCIDRowId == ServerObj.WeekGestationDia) {
						if (LMPResultStr != "") {
							var LMPResultArr = LMPResultStr.split(String.fromCharCode(2));
							var LMPResult = LMPResultArr[1];
							MRCIDRowId = LMPResultArr[0];
							if (LMPResult != "") {
								if (DiagnosNotes == "") DiagnosNotes = LMPResult;
								else DiagnosNotes = DiagnosNotes + " " + LMPResult;
							}
						} else {
							MRCIDRowId = "";
							DiagnosNotes = "";
						}
					}
					if (((MRCIDRowId != "") || (DiagnosNotes != "")) && (DiagnosCatRowId != "2")) {
						if ((DiagnosCatRowId == "1") && (MRDIARowId == "")) {
							var SyndromeInfo = GetSyndromeListInfo(i);
						} else {
							var SyndromeInfo = "";
						}
						if ((DiagnosNotes != "") && (MRDIARowId == "")) DiagnosNotes = DiagnosNotes + "#" + (parseInt(DiagnosCatRowId) + 1);
						var SyndromeCICDStr = "", SyndromeCDescStr = ""
						if (SyndromeInfo != "") {
							SyndromeCICDStr = SyndromeInfo.split(String.fromCharCode(1))[0];
							SyndromeCDescStr = SyndromeInfo.split(String.fromCharCode(1))[1];
						}
						var DiagnosBodyPartId = GetCellData(i, "DiagnosBodyPartRowId");
						if (MRDIARowId != "") { //已保存过的诊断修改
							var OneDiagItemStr = MRDIARowId + "^" + DiagnosNotes + "^" + DiagnosTypeRowId + "^" + MainDiagFlag + "^" + DiagnosStatusRowId + "^" + DiagnosOnsetDate + "^" + DiagnosBodyPartId + "^" + DiagnosDate + "^" + LongDiagnosFlagRowId + "^" + DiagnosPrefix;
						} else {
							var OneDiagItemStr = "" + "^" + DiagnosNotes + "^" + MRCIDRowId + "^" + DiagnosTypeRowId + "^" + MainDiagFlag
							OneDiagItemStr = OneDiagItemStr + "^" + DiagnosStatusRowId + "^" + DiagnosOnsetDate + "^" + SyndromeCICDStr + "^" + SyndromeCDescStr + "^" + DiagnosBodyPartId;
							OneDiagItemStr = OneDiagItemStr + "^" + DiagnosDate + "^" + LongDiagnosFlagRowId + "^" + DiagnosPrefix;
						}
						if (DiagItemStr == "") { DiagItemStr = OneDiagItemStr } else { DiagItemStr = DiagItemStr + String.fromCharCode(1) + OneDiagItemStr }
					}
					i++;
					if (i < rowids.length) {
						loop(i);
					} else {
						callBackFun();
					}
				})
			}
			loop(0)
		})(resolve);
	}).then(function () {
		callBackFun(DiagItemStr)
	})
}
	/*return {
"InitDiagEntry":InitDiagEntry,
"DiagnosCatChange":DiagnosCatChange,
"DiagnosTypeChange":DiagnosTypeChange,
"DiagnosBodyPartChange":DiagnosBodyPartChange,
"DiagnosStatusChange":DiagnosStatusChange,
"DiagnosICDDesc_keydown":DiagnosICDDesc_keydown,
"DiagnosNotes_keydown":DiagnosNotes_keydown,
"InitDatePicker":InitDatePicker,
"HisMRDiagRepShow":HisMRDiagRepShow,
"UpdateArriveStatus":UpdateArriveStatus,
"SaveMRDiagnosToEMR":SaveMRDiagnosToEMR,
"DeleteMRDiagnos":DeleteMRDiagnos
}*/
//})();
