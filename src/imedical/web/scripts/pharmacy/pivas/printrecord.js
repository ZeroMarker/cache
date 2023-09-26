/**
 * 模块:     配液流程单据打印记录
 * 编写日期: 2018-04-20
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    InitDict();
    InitGridOrdExe();
    InitGridPrint();
    $('#btnFind').bind("click", Query);
    $('#btnPrint').bind("click", PrintSelect);
    $('#btnPrintAll').bind("click", PrintAll);
    $('#btnPrintArrange').bind("click", PrintArrange);
    $('#btnPrintWardBat').bind("click", PrintWardBat);
    $('#btnClear').bind("click", Clear);
    $('#txtPatNo').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
			Query();
        }
    });
    setTimeout(function(){
        getLodop();
    }, 2000);
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    // 日期
    PIVAS.Date.Init({
        Id: 'datePrtStart',
        LocId: "",
        Type: 'Start',
        QueryType: 'Query'
    });
    PIVAS.Date.Init({
        Id: 'datePrtEnd',
        LocId: "",
        Type: 'End',
        QueryType: 'Query'
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbPivasLoc',
        Type: 'PivaLoc'
    }, {
        editable: false,
        onLoadSuccess: function () {
            var datas = $("#cmbPivasLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivasLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        },
        onSelect: function (data) {
            var locId = data.RowId;
            PIVAS.ComboBox.Init({
                Id: 'cmbWorkType',
                Type: 'PIVAWorkType',
                StrParams: locId
            }, {
                "placeholder": "配液状态..."
            });
            PIVAS.ComboBox.Init({
                Id: 'cmbPivaStat',
                Type: 'PIVAState'
            }, {
                editable: false
            });
        }
    });
    // 病区
    PIVAS.ComboBox.Init({
        Id: 'cmbWard',
        Type: 'Ward'
    }, {
        placeholder: "病区..."
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbWorkType',
        Type: 'PIVAWorkType'
    }, {
        "placeholder": "工作组..."
    });
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaStat',
        Type: 'PIVAState'
    }, {
        editable: false,
        "placeholder": "配液状态..."
    });
}

// 停止签医嘱明细列表
function InitGridOrdExe() {
    var columns = [
        [{
                field: 'gridOrdExeChk',
                checkbox: true
            },
            {
                field: 'pNo',
                title: '序号',
                width: 40
            },
            {
                field: "doseDateTime",
                title: '用药时间',
                width: 100
            },
            {
                field: "patInfo",
                title: '病人信息',
                width: 200
            },
            {
                field: "batNo",
                title: '批次',
                width: 50
            },
            {
                field: 'incDescStr',
                title: '药品信息',
                width: 300
            },
            {
                field: 'freqDesc',
                title: '频次',
                width: 75
            },
            {
                field: 'instrDesc',
                title: '用法',
                width: 75
            },
            {
                field: 'priDesc',
                title: '医嘱优先级',
                width: 80
            },
            {
                field: 'pogId',
                title: 'pogId',
                width: 80,
                hidden: true
            },
            {
                field: 'pid',
                title: 'pid',
                width: 40,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PrintDetail"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        pageSize: 100,
        pageList: [100, 300, 500],
        toolbar:[],
        pagination: true,
        onLoadSuccess: function () {},
        onClickRow: function (rowIndex, rowData) {},
        onBeforeLoad: function (param) {
            ClearTmpGlobal();
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
// 签明细列表
function InitGridPrint() {
    var columns = [
        [{
                field: 'psName',
                title: '配液状态',
                width: 75,
                align:'center',
                styler: PIVAS.Grid.Styler.PivaState
            },
            {
                field: 'pogsNo',
                title: '流程单号',
                width: 170
            },
            {
                field: 'pogsUserName',
                title: '操作人',
                width: 90
            },
            {
                field: 'pogsDateTime',
                title: '操作时间',
                width: 155,
                align:'center'
            },
            {
                field: 'doseDateRange',
                title: '用药日期范围',
                width: 200,
                align:'center'
            }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PogsNoList"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        toolbar:[],
        onLoadSuccess: function () {
            ClearTmpGlobal();
            $("#gridOrdExe").datagrid("clear").datagrid("unselectAll");
        },
        onClickRow: function (rowIndex, rowData) {
            var params = QueryParams();
            var pogsNo = rowData.pogsNo;
            $('#gridOrdExe').datagrid('query', {
                pogsNo: pogsNo,
                inputStr: params
            }).datagrid("unselectAll");
            
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPrint", dataGridOption);
}
//查询
function Query() {
    var params = QueryParams();
    $('#gridPrint').datagrid('query', {
        inputStr: params,
        rows:99999
    });
}

function QueryParams() {
    var prtStDate = $('#datePrtStart').datebox('getValue'); //起始日期
    var prtEdDate = $('#datePrtEnd').datebox('getValue'); //截止日期
    var prtStTime = $('#timePrtStart').timespinner('getValue');
    var prtEdTime = $('#timePrtEnd').timespinner('getValue');
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $("#txtPatNo").val().trim();
    var pNo = $("#txtPNo").val().trim();
    var workTypeId = $("#cmbWorkType").combobox("getValue");
    var psNumber = $("#cmbPivaStat").combobox("getValue");
    var params = locId + "^" + wardId + "^" + prtStDate + "^" + prtEdDate + "^" + prtStTime + "^" +
        prtEdTime + "^" + patNo + "^" + pNo + "^" + workTypeId + "^" + psNumber;
    return params;
}


function GetCheckedPogArr() {
    var pogArr = [];
    var gridChecked = $('#gridOrdExe').datagrid('getChecked');
    if (gridChecked == "") {
        $.messager.alert("提示", "请先选择记录", "warning");
        return pogArr;
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var pogId = gridChecked[cI].pogId;
        if (pogId == "") {
            continue;
        }
        if (pogArr.indexOf(pogId) < 0) {
            pogArr.push(pogId);
        }
    }
    return pogArr;
}

/// 打印勾选
function PrintSelect() {
    var pogArr = GetCheckedPogArr();
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        return;
    }
    PIVASPRINT.LabelsJsonByPogStr({
        pogStr: pogArr.join("^")
    });
}
/// 打印所有
function PrintAll() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        $.messager.alert("提示", "请先查询出标签明细", "warning");
        return;
    }
    var pid = gridRows[0].pid;
    $.cm({
        ClassName: "web.DHCSTPIVAS.PrintRecord",
        MethodName: "JsonLabels",
        pid: pid
    }, function (retJson) {
        var retLen = retJson.length;
        if (retLen > 0) {
			PIVASLABEL.Print(retJson, '补');
//            PIVASPRINT.RePrint = "";
//            PIVASLODOP = getLodop();
//            // 计算一共多少个打印任务
//            var taskCnt = retLen / (PIVASPRINT.PrintNum);
//            taskCnt = Math.ceil(taskCnt);
//            PIVASPRINT.TaskCnt = taskCnt;
//            PIVASPRINT.LabelsJsonPrint(retLen, 0);

        }
    })

}
/// 清屏
function Clear() {
    ClearTmpGlobal();
    //window.location.reload();
    $("#cmbPivasLoc").combobox("select",SessionLoc);
    $("#cmbPivaStat").combobox("clear");
    $("#cmbWorkType").combobox("clear");
    $("#cmbWard").combobox("clear");
    PIVAS.Date.Init({
        Id: 'datePrtStart',
        LocId: "",
        Type: 'Start',
        QueryType: 'Query'
    });
    PIVAS.Date.Init({
        Id: 'datePrtEnd',
        LocId: "",
        Type: 'End',
        QueryType: 'Query'
    });
    $("#timePrtStart") .timespinner("setValue",""); 
    $("#timePrtEnd") .timespinner("setValue","");
    $("#txtPatNo").val("");
    $("#txtPNo").val("");
    $("#gridPrint").datagrid("clear");
    $("#gridOrdExe").datagrid("clear");
    
}
/// 清除临时global
function ClearTmpGlobal() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        return;
    }
    var pid = gridRows[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.PrintRecord", "KillPrintData", pid);
}
window.onbeforeunload = function () {
    ClearTmpGlobal();
}
function PrintArrange(){
	var gridSelect=$("#gridPrint").datagrid("getSelected");
	if(gridSelect==null){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先选择需要补打的单据记录",
            type: 'alert'
        });
		return;
	}
	var geneNo=gridSelect.pogsNo;
	if (geneNo==""){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "没有单号,不能进行补打",
            type: 'alert'
        });
		return;	
	}
	PIVASPRINT.Arrange(geneNo,"","");
}
function PrintWardBat(){
	var gridSelect=$("#gridPrint").datagrid("getSelected");
	if(gridSelect==null){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先选择需要补打的单据记录",
            type: 'alert'
        });
		return;
	}
	var geneNo=gridSelect.pogsNo;
	var doseDateRange=gridSelect.doseDateRange;
	var doseDateRangeArr=doseDateRange.split(" 至 ")
    var paramsArr = PIVASPRINT.DefaultParams.WardBat();
    paramsArr[0] = $("#cmbPivasLoc").combobox("getValue");
    paramsArr[20] = geneNo;
    var raqObj = {
        raqName: "DHCST_PIVAS_病区交接单.raq",
        raqParams: {
            startDate: doseDateRangeArr[0],
            endDate: doseDateRangeArr[1],
            userName: session['LOGON.USERNAME'],
            pivaLoc: $("#cmbPivasLoc").combobox("getValue"),
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: $("#cmbPivasLoc").combobox("getText"),
            pogsNo: geneNo,
            inputStr: paramsArr.join("^"),
            pid: ""
        },
        isPreview: 1
    }
    PIVASPRINT.RaqPrint(raqObj);
}
