var appList_execObj = (function() {
	var CureExecDataGrid;
	var Page_appList_execObj = {
		AppStatusDemo: $g("已预约"),
		MainSreenFlag: websys_getAppScreenIndex()
	}

	function InitExecEvent() {
		$HUI.checkbox("#OnlyNoExcute", {
			onCheckChange: function(e, value) {
				setTimeout("appList_execObj.CureExecDataGridLoad();", 10)
			}
		})
	}

	function InitExecDate() {
		$("#Exec_StartDate,#Exec_EndDate").datebox({
			onChange: function(newValue, oldValue) {
				if (typeof CureExecDataGrid === 'object') {
					if ((newValue != oldValue)) { //&&(DATE_FORMAT.test(newValue))
						CureExecDataGridLoad()
					}
				}
			}
		});
		$("#Exec_StartDate").datebox('setValue', ServerObj.ExecStartDate);
		$("#Exec_EndDate").datebox('setValue', ServerObj.ExecEndDate);
	}

	function InitCureExecDataGrid() {
		var hiddenCol = (ServerObj.PageVersion == "WV2");
		CureExecDataGrid = $('#tabCureExecList').datagrid({
			fit: true,
			width: 'auto',
			border: false,
			striped: true,
			singleSelect: false,
			checkOnSelect: true,
			fitColumns: false,
			autoRowHeight: false,
			nowrap: false,
			collapsible: false,
			//url : '',
			loadMsg: '加载中..',
			pagination: true,
			rownumbers: true,
			idField: "OEORERowID",
			pageSize: 10,
			pageList: [10, 25, 50],
			frozenColumns: [
				[{
						field: 'RowCheck',
						checkbox: true
					},
					{
						field: 'DCARowId',
						title: '',
						width: 1,
						hidden: true
					},
					{
						field: 'DCRRowId',
						title: '',
						width: 1,
						hidden: true
					},
					{
						field: 'DCAApplyNo',
						title: '申请单号',
						width: 110,
						align: 'left',
						hidden: hiddenCol
					},
					{
						field: 'ApplyDate',
						title: '申请日期',
						width: 130,
						align: 'left',
						hidden: hiddenCol
					},
					{
						field: 'PapmiNo',
						title: '登记号',
						width: 100,
						hidden: hiddenCol
					},
					{
						field: 'PatientName',
						title: '姓名',
						width: 80,
						hidden: hiddenCol
					},
					{
						field: 'OEOREType',
						title: '医嘱类型',
						width: 100,
						hidden: true
					},
					{
						field: 'OEORETransType',
						title: '医嘱类型',
						width: 100,
						align: 'left'
					},
					{
						field: 'ArcimDesc',
						title: '治疗项目',
						width: 280,
						align: 'left'
					}
				]
			],
			columns: [
				[{
						field: 'OEOREExStDate',
						title: '要求执行时间',
						width: 130,
						align: 'left'
					},
					{
						field: 'OEOREQty',
						title: '执行数量',
						width: 80,
						align: 'left'
					},
					{
						field: 'OEOREStatus',
						title: '执行状态',
						width: 120,
						align: 'left',
						formatter: function(value, row, index) {
							if (row.OEOREStatusCode == "F") {
								return "<span class='fillspan-fullnum'>" + value + "</span>";
							} else if (row.OEOREStatusCode == "C") {
								return "<span class='fillspan-nonenum'>" + value + "</span>";
							} else if (row.OEOREStatusCode == "D") {
								return "<span class='fillspan-xapp'>" + value + "</span>";
							} else {
								return value;
							}
						}
					},
					{
						field: 'OEOREUpUser',
						title: '执行人',
						width: 100,
						align: 'left'
					},
					{
						field: 'DCRIsPicture',
						title: '是否有图片',
						width: 80,
						formatter: function(value, row, index) {
							if (value == "Y") {
								return '<a href="###" id= "' + row["DCRRowId"] + '"' + ' onmouseover=workList_RecordListObj.ShowCurePopover(this);' + ' onclick=appList_execObj.ShowCureRecordPic(\'' + row.DCRRowId + '\');>' + $g("查看图片") + "</a>"
							} else {
								return "";
							}
						},
						styler: function(value, row) {
							return "color:blue;text-decoration: underline;"
						}
					},
					{
						field: 'Trance',
						title: '过程追踪',
						width: 100,
						sortable: false,
						align: 'center',
						formatter: function(value, rowData, rowIndex) {
							retStr = "<a href='#' title='" + $g("治疗过程追踪") + "'  onclick='com_openwin.ShowReportTrace(" + "\"" + rowData.DCRRowId + "\"," + "\"\"" + ",\"" + rowData.OEORERowID + "\")'><span class='icon-track' title='" + $g("治疗过程追踪") + "')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
							return retStr;
						}
					},
					{
						field: 'OEOREExDate',
						title: '操作时间',
						width: 130,
						align: 'left'
					},
					{
						field: 'OEORETransType',
						title: '医嘱类型',
						width: 100,
						align: 'left'
					},
					{
						field: 'OEOREAppointFlag',
						title: '是否已预约',
						width: 100,
						align: 'left',
						hidden: hiddenCol,
						formatter: function(value, row, index) {
							if (value == Page_appList_execObj.AppStatusDemo) {
								return "<span class='fillspan-no'>" + value + "</span>";
							} else {
								return value;
							}
						}
					},
					{
						field: 'OEOREStatusCode',
						title: 'OEOREStatusCode',
						width: 50,
						hidden: true
					},
					{
						field: 'NoFinishTimes',
						title: 'NoFinishTimes',
						width: 50,
						hidden: true
					},
					{
						field: 'ISPRNOrder',
						title: 'ISPRNOrder',
						width: 50,
						hidden: true
					},
					{
						field: 'AllowExecMsg',
						title: 'AllowExecMsg',
						width: 50,
						hidden: true
					},
					{
						field: 'DCRMapID',
						title: 'DCRMapID',
						width: 50,
						hidden: true
					},
					{
						field: 'OEORERowID',
						title: 'ID',
						width: 50,
						hidden: true
					}
				]
			],
			rowStyler: function(index, row) {
				if (ServerObj.CureAppVersion == "V1") {
					if (row.OEOREAppointFlag == Page_appList_execObj.AppStatusDemo) {
						return 'background-color:#D3D3D3;';
					}
				}
			},
			onLoadSuccess: function(data) {
				//if (ServerObj.CureAppVersion == "V1") {
					var RowObj = $(this).parent().find("div .datagrid-cell-check")
						.children("input[type=\"checkbox\"]");
					for (var i = 0; i < data.rows.length; i++) {
						var dataObj = data.rows[i];
						if ((ServerObj.CureAppVersion == "V1" && dataObj.OEOREAppointFlag == Page_appList_execObj.AppStatusDemo) ||
							(dataObj.OEOREStatusCode == "D")) {
							RowObj.eq(i).attr("style", "display:none");
						}
					}
				//}
			},
			onClickRow: function(rowIndex, rowData) {
				var RowObj = $(this).parent().find("div .datagrid-cell-check")
					.children("input[type=\"checkbox\"]");
				RowObj.each(function(index, el) {
					if (el.style.display == "none") {
						$('#tabCureExecList').datagrid('unselectRow', index);
					}
				})
			},
			onSelect: function(rowIndex, rowData) {
				if (Page_appList_execObj.MainSreenFlag == 0) {
					//打开副屏
					var AppNo = rowData.DCAApplyNo;
					var DCRRowId = rowData.DCRRowId;
					var Obj = $.cm({
						ClassName: "DHCDoc.DHCDocCure.Apply",
						MethodName: "GetApplyInfoByAppNo",
						AppNo: AppNo
					}, false);
					if (DCRRowId != "") {
						var LinkPage = (ServerObj.DHCDocCureRecordLinkPage.split("&")[0]) || "doccure.curerecord.hui.csp";
						var frameurl = LinkPage + "?DCAARowIdStr=&OperateType=ZLYS&DCRRowId=" + DCRRowId + "&OEORERowIDS=&source=E";
						frameurl = frameurl.replace(/&/g, "!@")
						websys_emit("onOpenDHCDoc", {
							title: "治疗记录",
							frameurl: frameurl
						})
						return;
					} else {
						websys_emit("onOpenCureInterface", Obj);
						return;
					}
				}
			}
		});
	}

	function CureExecDataGridLoad() {
		if (typeof(PageAppListAllObj) != "undefined") {
			//改为页签形式，id由PageAppListAllObj获取
			var DCARowIdStr = PageAppListAllObj._SELECT_DCAROWID;
		} else if (typeof(PageWorkListAllObj) != "undefined") {
			//治疗工作平台治疗评估
			var DCARowIdStr = PageWorkListAllObj._WORK_SELECT_DCAROWID;
		}
		if (DCARowIdStr == "") {
			//return;	
		}
		var CheckOnlyNoExcute = "";
		var OnlyNoExcute = $("#OnlyNoExcute").prop("checked");
		if (OnlyNoExcute) {
			CheckOnlyNoExcute = "ON"
		};
		var StartDate = $('#Exec_StartDate').datebox('getValue');
		var EndDate = $('#Exec_EndDate').datebox('getValue');
		var SessionStr = com_Util.GetSessionStr();
		$.cm({
			ClassName: "DHCDoc.DHCDocCure.ExecApply",
			QueryName: "FindCureExecList",
			'DCARowId': DCARowIdStr,
			'OnlyNoExcute': CheckOnlyNoExcute,
			'StartDate': StartDate,
			'EndDate': EndDate,
			SessionStr: SessionStr,
			Pagerows: CureExecDataGrid.datagrid("options").pageSize,
			rows: 99999
		}, function(GridData) {
			CureExecDataGrid.datagrid({
				loadFilter: pagerFilter
			}).datagrid('loadData', GridData);
			CureExecDataGrid.datagrid("clearChecked").datagrid("clearSelections");
		})
	}

	function UpdateExec(Type) {
		var rows = CureExecDataGrid.datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.alert("提示", "请选择一条记录!", "warning");
			return;
		}
		if (Type == "C") {
			var msg = "是否确认撤销执行";
		} else if (Type == "S") {
			var msg = "是否确认停止执行";
		} else {
			//var msg="是否确认执行"	;
			OpenCureRecordDiag();
			return;
		}
		var rowData = CureExecDataGrid.datagrid("getRows");
		var UserID = session['LOGON.USERID'];
		var DCARowId = "";
		var DCARowIdStr = "";
		var ErrFlag = 0;
		var QuitArray = new Array();
		var AllowArray = new Array();
		var PromiseColArr = new Array();
		for (var i = 0; i < rows.length; i++) {
			var PatientName = rows[i].PatientName;
			var ArcimDesc = rows[i].ArcimDesc;
			var DCARowIds = rows[i].DCARowId;
			var OEOREQty = rows[i].OEOREQty;
			var OEORERowID = rows[i].OEORERowID;
			var OEOREType = rows[i].OEOREType;
			var OEOREAppointFlag = rows[i].OEOREAppointFlag;
			if ((ServerObj.CureAppVersion == "V1") && (OEOREAppointFlag == Page_appList_execObj.AppStatusDemo)) {
				continue;
			}
			var colPromis = new Promise(function(resolve, rejected) {
				CheckUpdateExec(rows[i], resolve)
			}).then(function(rowObj) {
				if (!$.isEmptyObject(rowObj)) {
					var DCARowIds = rowObj.DCARowId;
					var OEOREQty = rowObj.OEOREQty;
					var OEORERowID = rowObj.OEORERowID;
					var DCRRowId = rowObj.DCRRowId;
					AllowArray.push(DCARowIds + "^" + OEOREQty + "^" + OEORERowID + "^" + DCRRowId);
				}
				return AllowArray;
			})
			PromiseColArr.push(colPromis);
		}
		Promise.all(PromiseColArr)
			.then(function(AllowArrayObj) {
				if (AllowArray.length <= 0) {
					$.messager.alert('提示', "无可操作的执行记录,请确认!", "warning");
					return;
				}
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						var UpdateObj = {}
						new Promise(function(resolve, rejected) {
							//电子签名
							CASignObj.CASignLogin(resolve, "CancelCureRecord", false)
						}).then(function(CAObj) {
							return new Promise(function(resolve, rejected) {
								if (CAObj == false) {
									return websys_cancel();
								} else {
									$.extend(UpdateObj, CAObj);
									resolve(true);
								}
							})
						}).then(function() {
							var DCRRowIdAry = [];
							for (var i = 0; i < AllowArray.length; i++) {
								var AllowArr = AllowArray[i].split("^");
								var DCARowIds = AllowArr[0];
								var OEOREQty = AllowArr[1];
								var OEORERowID = AllowArr[2];
								var DCRRowId = AllowArr[3];
								var RtnStr = $.cm({
									ClassName: "DHCDoc.DHCDocCure.ExecApply",
									MethodName: "ExecCureApply",
									dataType: "text",
									DCARowId: DCARowIds,
									UserID: session['LOGON.USERID'],
									EexcNum: OEOREQty,
									Type: Type,
									Resource: "",
									OEOREDRStr: OEORERowID,
									LocDeptDr: session['LOGON.CTLOCID']
								}, false);
								if (RtnStr == "0") {
									//$.messager.show({title:"提示",msg:"更新成功"});	
									//CureExecDataGridLoad();
									DCRRowIdAry.push(DCRRowId);
								} else {
									ErrFlag = 1;
									if (RtnStr.indexOf(" ") > 0) {
										var RtnAry = RtnStr.split(" ");
										var NewRtnAry = RtnAry.slice(1);
										RtnStr = NewRtnAry.join(" ");
									}
									var index = CureExecDataGrid.datagrid("getRowIndex", OEORERowID);
									var msg = rowData[index].PatientName + "," + rowData[index].ArcimDesc + "," + RtnStr
									$.messager.alert('提示', msg, "error");
								}
							}
							if (ErrFlag == 0) {
								$.messager.popover({
									msg: '操作完成.',
									type: 'success',
									timeout: 1000
								});
							}
							if (UpdateObj.caIsPass == 1) CASignObj.SaveCASign(UpdateObj.CAObj, DCRRowIdAry.join("^"), "CancelCureRecord");
							AfterSaveCureRecord();
						})
					}
				});
			})

		function CheckUpdateExec(rowObj, callBack) {
			new Promise(function(resolve, rejected) {
				var DCARowIds = rowObj.DCARowId;
				var OEOREType = rowObj.OEOREType;
				if ((!QuitArray[DCARowIds]) && (Type == "S") && (OEOREType.indexOf("住院") < 0)) {
					$.messager.alert("提示", PatientName + "," + ArcimDesc + "," + $g("非住院临时医嘱无需停止执行,已自动过滤."), "info", function() {
						callBack({});
					});
					return;
				}
				resolve(true);
			}).then(function(rtn) {
				return new Promise(function(resolve, rejected) {
					var DCARowIds = rowObj.DCARowId;
					var OEORERowID = rowObj.OEORERowID;
					var RtnStr = $.cm({
						ClassName: "DHCDoc.DHCDocCure.ExecApply",
						MethodName: "CheckBeforeUpdateExec",
						dataType: "text",
						DCARowId: DCARowIds,
						UserID: session['LOGON.USERID'],
						OEORERowID: OEORERowID,
						ExecType: Type
					}, false);
					if (RtnStr != "") {
						QuitArray[DCARowIds] = DCARowIds;
						$.messager.alert('提示', PatientName + "," + ArcimDesc + "," + $g(RtnStr), "error", function() {
							resolve(false);
						});
						return;
					} else {
						resolve(true);
					}
				})
			}).then(function(rtn) {
				if (rtn) {
					callBack(rowObj);
				} else {
					callBack({});
				}
			})

		}
	}

	function OpenCureRecordDiag() {
		var OEORERowIDS = "";
		var TmpAry = new Array();
		var rows = CureExecDataGrid.datagrid("getSelections");
		var length = rows.length;
		for (var i = 0; i < rows.length; i++) {
			var PatientName = rows[i].PatientName;
			var ArcimDesc = rows[i].ArcimDesc;
			var DCARowIds = rows[i].DCARowId;
			var OEOREQty = rows[i].OEOREQty;
			var OEORERowID = rows[i].OEORERowID;
			var DCRRowId = rows[i].DCRRowId;
			var NoFinishTimes = rows[i].NoFinishTimes;
			var ISPRNOrder = rows[i].ISPRNOrder;
			var AllowExecMsg = rows[i].AllowExecMsg;
			var OEOREStatusCode = rows[i].OEOREStatusCode;
			var OEOREExStDate = rows[i].OEOREExStDate;
			var OEOREType = rows[i].OEOREType;
			var InfoMsg = PatientName + "【" + ArcimDesc + "】:"
			if (AllowExecMsg != "") {
				var WarnMsg = PatientName + "【" + ArcimDesc + "," + $g("要求执行时间") + OEOREExStDate + "】:" + $g(AllowExecMsg)
				$.messager.alert("提示", WarnMsg, 'warning');
				return false;
			}
			if (ISPRNOrder != "1" && OEOREType.indexOf("住院") < 0) {
				if (typeof(TmpAry[DCARowIds]) == 'undefined') {
					TmpAry[DCARowIds] = {
						OEOREQty: parseFloat(OEOREQty),
						NoFinishTimes: NoFinishTimes,
						InfoMsg: InfoMsg
					}
				} else {
					var tOEOREQty = parseFloat(TmpAry[DCARowIds].OEOREQty) + parseFloat(OEOREQty);
					$.extend(TmpAry[DCARowIds], {
						OEOREQty: parseFloat(tOEOREQty)
					})
				}
			}
			if (OEORERowIDS == "") {
				OEORERowIDS = OEORERowID;
			} else {
				OEORERowIDS = OEORERowIDS + "^" + OEORERowID;
			}
		}
		for (key in TmpAry) {
			var tmpObj = TmpAry[key];
			var OEOREQty = tmpObj.OEOREQty;
			var NoFinishTimes = tmpObj.NoFinishTimes;
			var InfoMsg = tmpObj.InfoMsg;
			if (parseFloat(OEOREQty) > parseFloat(NoFinishTimes)) {
				$.messager.alert("提示", InfoMsg + $g("超过医嘱可执行的最大数量,可能存在部分退费数量未审核退费完成。"), 'warning');
				return false;
			}
		}
		var QueId = "";
		if (typeof PageWorkListAllObj != "undefined") {
			QueId = PageWorkListAllObj._WORK_SELECT_QUEID;
			if (typeof QueId == "undefined") {
				QueId = ""
			}
		}
		var argObj = {
			DHCDocCureRecordLinkPage: ServerObj.DHCDocCureRecordLinkPage,
			OEORERowID: OEORERowIDS,
			QueId: QueId,
			Source: "E",
			callback: function() {
				AfterSaveCureRecord();
			}
		}
		com_openwin.ShowCureRecordDiag(argObj);
	}

	function AfterSaveCureRecord() {
		CureExecDataGridLoad();
		if (ServerObj.LayoutConfig == "1") {
			if (window.frames.parent.CureApplyDataGrid) {
				window.frames.parent.RefreshDataGrid();
			} else {
				RefreshDataGrid("");
			}
		}
		if (typeof(Main_SetPatArrive) == "function") {
			Main_SetPatArrive();
		}
	}

	// 批量执行
	function GenAddCureRecord() {
		return
	}
	/// 浏览执行
	function DetailExecView() {
		var rows = CureExecDataGrid.datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.alert("提示", "请选择一条执行记录查看!", 'warning');
			return;
		} else if (rows.length > 1) {
			$.messager.alert("提示", "您选择了多个执行记录！", 'warning')
			return;
		}
		var DCRRowId = ""
		var rowIndex = CureExecDataGrid.datagrid("getRowIndex", rows[0]);
		var selected = CureExecDataGrid.datagrid('getRows');
		var DCRRowId = selected[rowIndex].DCRRowId;
		var DCRMapID = selected[rowIndex].DCRMapID;
		if (DCRRowId == "") {
			$.messager.alert('提示', '该执行记录未执行,请先执行后浏览!', 'warning');
			return false;
		}
		var argObj = {
			DHCDocCureRecordLinkPage: ServerObj.DHCDocCureRecordLinkPage,
			DCRRowId: DCRRowId,
			DCATempId: DCRMapID,
			Source: "E"
		}
		com_openwin.ShowCureRecordDiag(argObj);
	}

	/**
	 *治疗记录图片上传，调用record.worklist.curerecordlist.js方法
	 **/
	function UploadPic() {
		var rows = CureExecDataGrid.datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.alert("提示", "请选择一条治疗记录", 'warning');
			return "";
		} else if (rows.length > 1) {
			$.messager.alert("提示", "您选择了多个治疗记录！", 'warning')
			return "";
		}
		var DCRRowId = "";
		var selIDAry = new Array();
		for (var i = 0; i < rows.length; i++) {
			var Rowid = rows[i].DCRRowId;
			if (Rowid != "") {
				selIDAry.push(Rowid)
			}
		}
		if (selIDAry.length > 0) {
			DCRRowId = selIDAry.join("^");
		}
		if (DCRRowId == "") {
			$.messager.alert("提示", "仅允许操作已治疗的记录,请确认.", 'warning')
			return "";
		}
		workList_RecordListObj.UploadPic(DCRRowId, CureExecDataGridLoad);
	}
	/**
	 *治疗记录图片浏览，调用record.worklist.curerecordlist.js方法
	 **/
	function ShowCureRecordPic(DCRRowId) {
		if (DCRRowId == "" || typeof DCRRowId == "undefined") {
			var DCRRowId = GetSelectDCRRowId()
			if (DCRRowId == "") {
				return false;
			}
		}
		workList_RecordListObj.ShowCureRecordPic(DCRRowId, CureExecDataGridLoad);
	}

	return {
		"InitExecDate": InitExecDate,
		"InitExecEvent": InitExecEvent,
		"InitCureExecDataGrid": InitCureExecDataGrid,
		"CureExecDataGridLoad": CureExecDataGridLoad,
		"DetailExecView": DetailExecView,
		"UpdateExec": UpdateExec,
		"GenAddCureRecord": GenAddCureRecord,
		"UploadPic": UploadPic,
		"ShowCureRecordPic": ShowCureRecordPic
	}
})()
