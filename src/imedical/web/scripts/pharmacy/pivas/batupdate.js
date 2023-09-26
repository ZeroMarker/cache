/** 
 * 模块: 	 静脉配液排批
 * 编写日期: 2018-03-05
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var ConfirmMsgInfoArr = [];
var GridCmbBatNo;
var NeedScroll="Y"; // 是否需要滚动到0行
$(function() {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdExe();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnSave').on("click", SaveData);
    $('#btnPack').on('click', function() {
        PackSelectDsp('P');
    });
    $('#btnUnPack').on('click', function() {
        PackSelectDsp('');
    });
    $('#btnUnSave').on('click', DelBatUpdate);
    $('#btnUpdBat').on('click', ConfirmUpdBatUpdate);
    $('#txtPatNo').on('keypress', function(event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //调用查询
        }
    });
    $("#btnSelectAll").on("click", function () {
		CheckRowsGlobal("", "Y", "Y");
	});
	$("#btnUnSelectAll").on("click", function () {
		CheckRowsGlobal("", "N", "Y");
	});
    InitPivasSettings();
	$(".dhcpha-win-mask").remove();
});

function InitDict() {
    // 配液大类
    PIVAS.ComboBox.Init({ Id: 'cmbPivaCat', Type: 'PivaCat' }, { width: 120 });
    // 科室组
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // 医嘱优先级
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { width: 120, });
    // 工作组
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { width: 120 });
    // 药品
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 311 });
    // 打包
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, {
        width: 120
    });
    // 排批状态
    PIVAS.ComboBox.Init({ Id: 'cmbUpdated', Type: 'BatUpdateStat' }, {
        editable: false,
        width: 120,
        onSelect: function() {
            Query();
        }
    });
    $("#cmbUpdated").combobox("setValue", "N");
    // 打签状态
    PIVAS.ComboBox.Init({ Id: 'cmbPrt', Type: 'PrtStat' }, {
        editable: false,
        width: 120,
        onSelect: function() {
            Query();
        }
    });
    $("#cmbPrt").combobox("setValue", "N");
    // 批次
    PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: SessionLoc, Check: true, Pack: false });
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: "gridOrdExe",
        Field: "batNo",
        BatUp: "batUp",
        MDspField: "mDsp"
    },function(){
	    NeedScroll="";
		$('#gridOrdExe').datagrid("reload"); 
	});
}

//初始化病区列表
function InitGridWard() {
    //定义columns
    var columns = [
        [
        	{ field: 'select', checkbox: true},
            { field: "wardId", title: 'wardId', hidden: true },
            { field: 'wardDesc', title: '病区', width: 200 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.BatUpdate",
            QueryName: "BatUpdateWard"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        queryOnSelect: false,
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        },
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
            $("#gridOrdExe").datagrid("clear");
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({ Id: 'gridAdm' }, options);
}

//初始化明细列表
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'gridCheck', checkbox: true },
            { field: 'warnInfo', title: '提醒', width: 75,
                styler: function(value, row, index) {
                    if (value != "") {
                        return "background-color:#ffba42;"
                    } 
                    return "";
                }
            
            },
            { field: 'pid', title: 'pid', width: 100, hidden: true },
            { field: 'ordRemark', title: '备注', width: 75 },
            { field: 'doseDateTime', title: '用药时间', width: 100 },
            { field: 'wardDesc', title: '病区', width: 125 },
            { field: 'bedNo', title: '床号', width: 75 },
            { field: 'patNo', title: '登记号', width: 100 },
            { field: 'patName', title: '姓名', width: 100 },
            {
                field: 'batNo',
                title: '批次',
                width: 75,
                editor: GridCmbBatNo,
                styler: function(value, row, index) {
	                var colorStyle='';
                    if (row.packFlag != "") {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    if (row.batUp == "Y") {	// 用户修改的,斜体
                        colorStyle += PIVAS.Grid.CSS.BatchUp;
                    }
                    if (row.canUpdate=="Y"){
	                	colorStyle+='text-decoration:underline;';
	                }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 35,
                halign: 'left',
                align: 'center',
                formatter: PIVAS.Grid.Formatter.OeoriSign,
                styler: function(value, row, index) {
                   	if (row.batUpdated=="Y"){
	                	return PIVAS.Grid.CSS.BatchUpdated;
	                }
                }
            },
            { field: 'incDesc', title: '药品', width: 250, styler: PIVAS.Grid.Styler.IncDesc},
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'dosage', title: '剂量', width: 75 },
            { field: 'qty', title: '数量', width: 50 },
            { field: 'freqDesc', title: '频次', width: 75 },
            { field: 'instrucDesc', title: '用法', width: 80 },
            { field: 'bUomDesc', title: '单位', width: 50 },
            { field: 'docName', title: '医生', width: 75, hidden:true},
            { field: "passResultDesc", title: '审核结果', width: 85 },
            { field: 'priDesc', title: '优先级', width: 75 },
            { field: 'workTypeDesc', title: '工作组', width: 75 },
            { field: "packFlag", title: '打包', width: 85, hidden: true },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: true },
            { field: 'batUp', title: '用户修改', width: 50, hidden: true },	// 特指排批前的修改
            { field: 'canUpdate', title: '是否可修改', width: 50, hidden: true },
            { field: 'batUpdated', title: '是否已排批', width: 50, hidden: true },
            { field: 'check', title: 'check', width: 50, hidden: true}

        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + '?action=JsGetBatUpdateDetail',
        fit: true,
        toolbar: '#gridOrdExeBar',
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        rowStyler: function(index, rowData) {
			return PIVAS.Grid.RowStyler.Person(index,rowData,"patNo");
        },
        onClickRow: function(rowIndex, rowData) {
	        if (rowData.canUpdate!="Y"){
	        	$(this).datagrid('unselectRow', rowIndex);
	        }
	        //console.log("onClickRow")
        },
        onClickCell: function(rowIndex, field, value) {
	        var rowData=$(this).datagrid("getRows")[rowIndex];
	        var canUpdate=rowData.canUpdate||"";
	        if (canUpdate!="Y"){
		    	return;
		    }
            if ((field == "batNo") && (value != "")) {
	            $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                })
                setTimeout(function(){
	                $("#gridOrdExe").datagrid("checkRow",rowIndex);
                },100)
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function(rowIndex, rowData) {
	        if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp
            });
            CheckRowsGlobal(rowData.mDsp, "Y");
            $(this).datagrid("options").checking = "";
        },
        onUncheck: function(rowIndex, rowData) {
	        if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: false,
                Value: rowData.mDsp
            });
            CheckRowsGlobal(rowData.mDsp, "N");
            $(this).datagrid("options").checking = "";
        },
		onCheckAll: function (rows) {
			if ($(this).datagrid("options").checking==true){
				return;
			}
			UnBindChk();
			CheckPage(rows, "Y");
		},
		onUncheckAll: function (rows) {
			if ($(this).datagrid("options").checking==true){
				return;
			}
			UnBindChk();
			CheckPage(rows, "N");
		},
        onLoadSuccess: function(data) {
	        $(this).datagrid("options").checking = true;
	        var row0Data = data.rows[0];
            if (row0Data) {
	            $(this).datagrid("checkAll");
                var pid = row0Data.pid;
                $('#gridOrdExe').datagrid("options").queryParams.pid = pid;
				var rows = $(this).datagrid("getRows");
				var rowsLen = rows.length;
				for (var index = (rowsLen - 1); index >= 0; index--) {
					var rowData = rows[index];
					var check = rowData.check;
					if (check!="Y"){
						$(this).datagrid("uncheckRow", index);
					}
				}
                CalcuSumBat(pid,$('#gridOrdExe').datagrid("options").queryParams.params);	// 计算合计
            }else {
				$(this).datagrid("uncheckAll");
			}
			if (NeedScroll=="Y"){
            	$(this).datagrid("scrollTo", 0); 
            	NeedScroll="Y";
            }  
            $(this).datagrid("options").checking = "";
            PIVAS.Grid.CellTip({ TipArr: ['ordRemark', 'incDesc'] });
            UnBindChk();

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
function UnBindChk(){
	var rows=$("#gridOrdExe").datagrid("getRows");
	$.each(rows, function (index, row) {
		var canUpdate = row.canUpdate;	
		if (canUpdate!="Y") {
			//$(".datagrid-row[datagrid-row-index=" + index + "] .datagrid-cell-check")
			// 通过移除样式,使selectoncheck等事件不起作用
			var $row=$("#gridOrdExe").prev().find(".datagrid-row[datagrid-row-index=" + index + "]");			
			$row.removeClass("datagrid-row-selected datagrid-row-checked")
			var $chk=$row.find("input:checkbox[name='gridCheck']")[0]
			$chk.disabled =true
			$chk.checked =false
		}
	});
}

///按登记号查询就诊列表
function GetPatAdmList() {
    var patNo = $('#txtPatNo').val();
	patNo=PIVAS.FmtPatNo(patNo);
    $('#txtPatNo').val(patNo);
    var params = patNo + '^' + session['LOGON.HOSPID'];
    $('#gridAdm').datagrid('query', {
        inputParams: params,
        rows:9999
    });
}

///查询
function Query() {
    ClearTmpGlobal();
    var params = QueryParams("Query");
    if (params == "") {
        return;
    }
    $('#gridWard').datagrid('query', {
        inputStr: params,
        rows:9999
    });
}

// 查询医嘱
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    if (params == "") {
        return;
    }   
    $('#gridOrdExe').datagrid("load",{
        page: 1,
        params: params,
        pid: ''
    });
}

// 获取查询参数
// flag==Query   flag==QueryDetail
function QueryParams(flag) {
    var startDate = $('#dateStart').datebox('getValue'); // 起始日期
    var endDate = $('#dateEnd').datebox('getValue'); // 截止日期
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // 科室组
    var wardIdStr = $("#cmbWard").combobox("getValue") || ''; // 病区	
    var pivaCat = $("#cmbPivaCat").combobox("getValue") || ''; // 配液大类
    var workType = $("#cmbWorkType").combobox("getValue") || ''; // 集中配置
    var priority = $("#cmbPriority").combobox("getValue") || ''; // 医嘱优先级
    var incId = $("#cmgIncItm").combobox("getValue") || ''; // 药品
    var packFlag = $("#cmbPack").combobox("getValues") || ''; // 打包类型
    var batNoStr = "";
    $("input[type=checkbox][name=batbox]").each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == "") {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + "," + this.value;
            }
        }
    });
    var admId = "";
    // 如果为查询明细,则wardId取选择的Id
    var tabTitle = $('#tabsOne').tabs('getSelected').panel('options').title;
    if (flag == "QueryDetail") {
        if (tabTitle == "病区列表") {
            var wardChecked = $('#gridWard').datagrid('getChecked');
            if (wardChecked == "") {
                return "";
            }
            for (var i = 0; i < wardChecked.length; i++) {
                if (wardIdStr == "") {
                    wardIdStr = wardChecked[i].wardId;
                } else {
                    wardIdStr = wardIdStr + "," + wardChecked[i].wardId;
                }
            }
        } else if (tabTitle == "按登记号") {
            var admSelected = $('#gridAdm').datagrid("getSelected");
            if (admSelected == null) {
                $.messager.alert('提示', '请选择就诊记录', 'warning');
                return "";
            }
            wardIdStr = "";
            admId = admSelected.admId;
        }
    }
    var updatedFlag = $("#cmbUpdated").combobox("getValue") || ''; // 排批状态
    var prtStat= $("#cmbPrt").combobox("getValue") || ''; // 打签状态
    var params = SessionLoc + "^" + wardIdStr + "^" + admId + "^" + startDate + "^" + endDate + "^" +
        locGrpId + "^" + pivaCat + "^" + workType + "^" + priority + "^" + incId + "^" +
        packFlag + "^" + batNoStr + "^" + updatedFlag+ "^"+prtStat;
    return params;
}
// 确认排批
function SaveData() {
    var rowsData = $("#gridOrdExe").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('提示', '明细无数据', 'warning');
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('提示', '获取不到PID', 'warning');
        return;
    }
    if ($("#cmbUpdated").combobox('getValue') == "Y") {
        $.messager.alert('提示', '医嘱明细数据为已排批数据', 'warning');
        return;
    }
    //var mDspIdStr=GetCheckMDspStr();
    $.messager.confirm('提示', "您确认排批吗?", function(r) {
        if (r) {
            PIVAS.Progress.Show({ type: 'save', interval: 1000 });
            $.m({
                ClassName: "web.DHCSTPIVAS.BatUpdate",
                MethodName: "SaveData",
                pid: pid,
                userId: SessionUser
            }, function(retData) {
                PIVAS.Progress.Close();
                var retArr = retData.split("^");
                if (retArr[0] == -1) {
                    $.messager.alert('提示', retArr[1], 'warning');
                    return;
                } else if (retArr[0] < -1) {
                    $.messager.alert('提示', retArr[1], 'error');
                    return;
                }
                QueryDetail();
            });
        }
    });
}

// 打包操作
function PackSelectDsp(packFlag) {
    $.messager.confirm('提示', "您确认" + ((packFlag == "P") ? "打包" : "取消打包") + "吗?", function(r) {
        if (r) {
            var mDspStr = GetMainDspStr();
            if (mDspStr == "") {
                $.messager.alert('提示', '请勾选需要' + ((packFlag == "P") ? "打包" : "取消打包") + '的记录', 'warning');
                return;
            }
            var retData = tkMakeServerCall("web.DHCSTPIVAS.DataHandler", "UpdateOeDspToPackMulti", mDspStr, packFlag)
            var retArr = retData.split("^");
            if (retArr[0] == -1) {
                $.messager.alert('提示', retArr[1], 'warning');
                return;
            } else if (retArr[0] < -1) {
                $.messager.alert('提示', retArr[1], 'error');
                return;
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: ((packFlag == "P") ? "打包" : "取消打包") + '成功',
                type: 'success'
            });
            NeedScroll="";
            $('#gridOrdExe').datagrid('reload');
        }
    })
}

// 取消排批
function DelBatUpdate() {
    if ($("#cmbUpdated").combobox('getValue') == 'N') {
        $.messager.alert('提示', '未排批数据无法取消', 'warning');
        return;
    }
    $.messager.confirm('提示', "您确认取消排批吗?", function(r) {
        if (r) {
            var mDspStr = GetMainDspStr();
            if (mDspStr == "") {
                $.messager.alert('提示', '请勾选需要取消排批的记录', 'warning');
                return;
            }
            var retData = tkMakeServerCall("web.DHCSTPIVAS.BatUpdate", "DeleteBatUpdateMulti", mDspStr, SessionUser)
            var retArr = retData.split("^");
            if (retArr[0] == -1) {
                if (retArr[2] >0) {
                	$.messager.alert('提示', "取消排批成功</br>但部分记录"+retArr[1], 'warning');
                	QueryDetail();
                }else{
	            	$.messager.alert('提示', retArr[1], 'warning');
	            }
                return;
            } else if (retArr[0] < -1) {
                if (retArr[2] >0) {
                	$.messager.alert('提示', "取消排批成功</br>但部分记录"+retArr[1], 'error');
                	QueryDetail();
                }else{
	            	$.messager.alert('提示', retArr[1], 'error');
	            }
                return;
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: "取消排批成功",
                type: 'success'
            });
            // 取消不常见,后台不做判断,直接重新查询,涉及重新计算容积
            QueryDetail();
        }
    })
}

// 确认-批量修改批次
function ConfirmUpdBatUpdate() {
    var mDspStr = GetMainDspStr();
    if (mDspStr == "") {
        $.messager.alert('提示', '请勾选需要修改批次的记录', 'warning');
        return;
    }
    // 看项目是否需要多层提示吧
    //$.messager.confirm('提示', "您确认批量修改批次吗?", function(r) {
    //    if (r) {
    PIVAS.UpdateBatNoWindow({ LocId: SessionLoc }, UpdBatUpdate);
    //    }
    //});
}
// 批量修改批次
function UpdBatUpdate(batNo) {
    var mDspStr = GetMainDspStr();
    var retData = tkMakeServerCall("web.DHCSTPIVAS.BatUpdate", "UpdateBatchMulti", mDspStr, batNo, SessionUser);
    var retArr = retData.split("^");
    if (retArr[0] == -1) {
        $.messager.alert('提示', retArr[1], 'warning');
    } else if (retArr[0] < -1) {
        $.messager.alert('提示', retArr[1], 'error');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "修改批次成功",
            type: 'success'
        });
    }
    NeedScroll="";
    $('#gridOrdExe').datagrid('reload');
}


// 获取选中记录的mdspId串
function GetMainDspStr() {
    var mDspArr = [];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var mDsp = checkedData.mDsp;
        if (mDspArr.indexOf(mDsp) < 0) {
            mDspArr.push(mDsp);
        }
    }
    return mDspArr.join("^");
}
// 清除本程序涉及的所有临时global
function ClearTmpGlobal() {
	var pid = $("#gridOrdExe").datagrid("options").queryParams.pid || "";
    tkMakeServerCall("web.DHCSTPIVAS.BatUpdate", "KillBatUpdate", pid);
    $(".pivas-toolbar-context").html("");
}
// 计算合计
function CalcuSumBat(pid,inputStr) {
    if ((pid == "")||(inputStr =="")) {
        return;
    }
    $.m({
        ClassName: "web.DHCSTPIVAS.BatUpdate",
        MethodName: "SumDetailBatch",
        pid: pid,
        inputStr:inputStr
    }, function(retData) {
        if (retData != "") {
            $(".pivas-toolbar-context").html(retData);
        }
    })
}



/// 初始化默认条件
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "BatUpdate"
    }, function(jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        PIVAS.VAR.PASS = jsonData.Pass;
    });
}

function CheckPage(rows, flag) {
	if (rows == "") {
		return;
	}
	var mDspArr = [];
	var mDsp= "";
	for (var i in rows) {
		mDsp = rows[i].mDsp;
		if (mDsp == "") {
			continue;
		}
		if (mDspArr.indexOf(mDsp) >= 0) {
			continue;
		}
		mDspArr.push(mDsp);
	}
	var mDspStr = mDspArr.join("^");
	if (mDspStr == "") {
		return;
	}
	CheckRowsGlobal(mDspStr, flag)
}

function CheckRowsGlobal(mDspIdStr, flag, all) {
	$.cm({
		ClassName: 'web.DHCSTPIVAS.BatUpdate',
		MethodName: 'CheckRows',
		MDspIdStr: mDspIdStr,
		Flag: flag,
		Pid: $("#gridOrdExe").datagrid("options").queryParams.pid || "",
		All: all || "",
		dataType: "text"
	}, false);
	if (all == "Y") {
		NeedScroll="";
		$("#gridOrdExe").datagrid("reload");
	}
}

function GetCheckMDspStr(allFlag) {
	var mDspIdStr = $.cm({
		ClassName: 'web.DHCSTPIVAS.BatUpdate',
		MethodName: 'GetSaveDspStr',
		Pid: $("#gridOrdExe").datagrid("options").queryParams.pid || "",
		dataType: "text"
	}, false);
	return mDspIdStr;
}
window.onbeforeunload = function() {
    ClearTmpGlobal();
};
