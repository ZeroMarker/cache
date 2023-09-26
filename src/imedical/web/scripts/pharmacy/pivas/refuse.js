/**
 * 模块:     配液拒绝
 * 编写日期: 2018-03-23
 * 编写人:   dinghongying
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
$(function() {
    InitDict();
    InitGridOrdExe();
    $('#btnFind').bind("click", Query);
    $('#btnRefuse').bind("click", Refuse);
    $('#btnCancel').bind("click", CancelRefuse);
    $('#txtPatNo').on('keypress', function(event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                patNo=PIVAS.FmtPatNo(patNo);
                $("#txtPatNo").val(patNo);
                Query();
            }
        }
    });
    // 流程单号
    $('#txtPrtNo').searchbox({
        searcher: function(value, name) {
            if (event.keyCode == 13) {
	            Query();
                return;
            };
            var pivaLocId = $('#cmbPivaLoc').combobox("getValue");
            var psNumber = ""; //$('#cmbPivaStat').combobox("getValue");
            PIVAS.PogsNoWindow({
                TargetId: 'txtPrtNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    //日期
    PIVAS.Date.Init({ Id: 'datePrtStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'datePrtEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateOrdStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateOrdEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    //配液中心
    PIVAS.ComboBox.Init({ Id: 'cmbPivaLoc', Type: 'PivaLoc' }, {
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        }
    });
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // 药品名称
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 254 });
    // 医嘱优先级
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, {});
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // 科室组
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // 配伍审核
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, {});
    $('#cmbPassResult').combobox("setValue", "");
    // 批次
    PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: SessionLoc, Check: true, Pack: false });
    // 集中配制
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, {});
    // 配液拒绝
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaRefuse',
        Type: 'YesOrNo',
        data: {
            data: [{ "RowId": "Y", "Description": "已配液拒绝" }, { "RowId": "N", "Description": "未配液拒绝" }]
        }
    }, {});
}

// 医嘱明细列表
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'ordExeSelect', checkbox: true },
            {
                field: 'warnInfo',
                title: '提醒',
                width: 75,
                styler: function(value, row, index) {
                    var colorStyle = "";
                    if (value.indexOf("配液拒绝") >= 0) {
                        colorStyle = "background:#F4868E;color:white;"
                    }
                    return colorStyle;
                }
            },
            { field: 'pid', title: 'pid', width: 50, hidden: true },
            { field: 'wardDesc', title: '病区', width: 150, hidden: false },
            { field: 'doseDateTime', title: '用药时间', width: 100,align:'center' },
            { field: 'bedNo', title: '床号', width: 75 },
            { field: 'patNo', title: '登记号', width: 100 },
            { field: 'patName', title: '姓名', width: 100 },
            {
                field: 'batNo',
                title: '批次',
                width: 50,
                styler: function(value, row, index) {
                    var colorStyle = '';
                    if (row.packFlag != "") {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                align:'center' ,
                width: 35,
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: '药品', width: 250, styler: PIVAS.Grid.Styler.IncDesc },
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'dosage', title: '剂量', width: 75 },
            { field: 'qty', title: '数量', width: 50 },
            { field: 'freqDesc', title: '频次', width: 75 },
            { field: 'instrucDesc', title: '用法', width: 80 },
            { field: 'bUomDesc', title: '单位', width: 50 },
            { field: 'docName', title: '医生', width: 75, hidden:true },
            { field: "passResultDesc", title: '审核结果', width: 85 },
            { field: 'priDesc', title: '优先级', width: 75 },
            { field: "packFlag", title: '打包', width: 85, hidden: true },
            { field: 'ordRemark', title: '备注', width: 75 },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: true },
            { field: 'colColor', title: 'colColor', width: 50, hidden: true },
            { field: "pogId", title: 'pogId', width: 70, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: "",
        fitColumns: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 300],
        toolbar: "#gridOrdExeBar",
        onLoadSuccess: function() {
            PIVAS.Grid.CellTip({
                TipArr: ['warnInfo'],
                ClassName: 'web.DHCSTPIVAS.Refuse',
                MethodName: 'RefuseInfo',
                TdField: 'pogId'
            });
        },
        rowStyler: function(index, rowData) {
			return PIVAS.Grid.RowStyler.Person(index, rowData, "patNo");
        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: false,
                Value: rowData.pogId
            });
        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id);
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}

/// 查询
function Query() {
    var params = QueryParams();
    $('#gridOrdExe').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGetRefuseDetail&params=' + params,
    });

}
/// 拒绝
function Refuse() {
    $.messager.confirm('提示', "您确认拒绝配液吗?", function(r) {
        if (r) {
            var pogIdStr = GetPogIdStr("R");
            if (pogIdStr == "") {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "请勾选需要配液拒绝的医嘱数据",
                    type: 'alert'
                });
                return;
            }
            PIVAS.RefuseReasonWindow({ pogIdStr: pogIdStr, userId: SessionUser }, Query)
        }
    })
}
/// 取消拒绝
function CancelRefuse() {
    $.messager.confirm('提示', "您确认取消拒绝吗?", function(r) {
        if (r) {
            var pogIdStr = GetPogIdStr("C");
            if (pogIdStr == "") {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "请勾选需要取消配液拒绝的医嘱数据",
                    type: 'alert'
                });
                return;
            }
            $.m({
                ClassName: "web.DHCSTPIVAS.Refuse",
                MethodName: "SaveData",
                pogIdStr: pogIdStr,
                userId: SessionUser,
                reasonId: "",
                exeType: "C"
            }, function(retData) {
                var retArr = retData.split("^");
                if (retArr[0] == -1) {
                    $.messager.alert('提示', retArr[1], 'warning');
                } else if (retArr[0] < -1) {
                    $.messager.alert('提示', retArr[1], 'error');
                }
                Query();
            });
        }
    })
}

// 获取选中的医嘱明细Pog串
function GetPogIdStr(ActionType) {
    var pogIdArr = [];
    var pogIdValidArr=[];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var pogId = checkedData.pogId;
        if (pogIdValidArr.indexOf(pogId) >=0) {
            continue;
        }
        if ((ActionType=="R")&&(checkedData.warnInfo=="配液拒绝")){
	        pogIdValidArr.push(pogId);
	    	continue;
	    }
        if ((ActionType=="C")&&(checkedData.warnInfo=="")){
	        pogIdValidArr.push(pogId);
	    	continue;
	    }
        if (pogIdArr.indexOf(pogId) < 0) {
            pogIdArr.push(pogId);
        }
    }
    return pogIdArr.join("^");
}
/// 获取入参
function QueryParams() {
    var paramsArr = [];
    var locId = $('#cmbPivaLoc').combobox('getValue') || ''; //  1-静配中心
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); //  2-用药起始日期
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); //  3-用药结束日期
    var datePrtStart = $('#datePrtStart').datebox('getValue'); //  4-打签起始日期
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); //  5-打签结束日期
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; //  6-科室组
    var wardId = $('#cmbWard').combobox('getValue') || ''; //  7-病区
    var priority = $('#cmbPriority').combobox('getValue') || ''; //  8-医嘱优先级
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; //  9-配伍审核
    var patNo = $('#txtPatNo').val().trim(); // 10-登记号
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // 11-药品
    var workType = $('#cmbWorkType').combobox('getValue') || ''; // 12-工作组
    var prtNo = $('#txtPrtNo').searchbox('getValue'); // 13-流程单据号
    var batNoStr = "" // 14-批次
    $("input[type=checkbox][name=batbox]").each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == "") {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + "," + this.value;
            }
        }
    });
    var pivaRefuse = $('#cmbPivaRefuse').combobox('getValue') || ''; // 15-配液拒绝
    var oeoreState = ""; // 16-执行记录状态
    paramsArr[0] = locId;
    paramsArr[1] = dateOrdStart;
    paramsArr[2] = dateOrdEnd;
    paramsArr[3] = datePrtStart;
    paramsArr[4] = datePrtEnd;
    paramsArr[5] = locGrpId;
    paramsArr[6] = wardId;
    paramsArr[7] = priority;
    paramsArr[8] = passResult;
    paramsArr[9] = patNo;
    paramsArr[10] = incId;
    paramsArr[11] = workType;
    paramsArr[12] = prtNo;
    paramsArr[13] = batNoStr;
    paramsArr[14] = pivaRefuse;
    paramsArr[15] = oeoreState;
    return paramsArr.join("^");
}