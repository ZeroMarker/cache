/**
 * @Description: 移动药房 - 物流箱查询
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.boxfind.csp
 * @Js:          pha/mob/v2/boxfind.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
PHA_COM.VAR = {
    CONFIG: null,
    statusColor: {}
};

$(function () {
    // 初始化
    InitDict();
    InitGridBox();
    InitGridBoxItm();
    PHA_COM.ResizePanel({
        layoutId: 'layout-main',
        region: 'south',
        height: 0.4
    });

    $('#btnFind').on('click', QueryBox);
    $('#btnClear').on('click', Clear);
    $('#btnPrint').on('click', Print);

    if (typeof isPharmacy == 'string' && isPharmacy == 'N') {
        $('#btnPrint').hide();
    }
    InitConfig();
})

// 初始化表单
function InitDict() {
    // 出发科室
    PHA.ComboBox("fromLocId", {
        placeholder: '出发科室...',
        url: PHA_STORE.CTLoc().url + '&TypeStr=' + 'D',
        onLoadSuccess: function (data) {
            /* var rows = data.length;
            for (var i = 0; i < rows; i++) {
                var iData = data[i];
                if (iData.RowId == session['LOGON.CTLOCID']) {
                    $(this).combobox('setValue', iData.RowId);
                }
            } */
        }
    });

    // 到达科室
    PHA.ComboBox("toLocId", {
        placeholder: '到达科室...',
        url: PHA_STORE.CTLoc().url
    });

    // 物流箱状态
    PHA.ComboBox("boxStatus", {
        placeholder: '物流状态...',
        url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.BoxFind.Query&QueryName=BoxStatus',
        onSelect: function (record) {
            QueryBox();
        }
    });

    // 日期默认
    if ($('#startDate').datebox('getValue') == "") {
        $('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
        $('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
    }
    if ($('#endDate').datebox('getValue') == "") {
        $('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
        $('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
    }
}

// 初始化表格
function InitGridBox() {
    var columns = [[{
                field: 'boxId',
                title: 'boxId',
                width: 80,
                hidden: true
            }, {
                field: 'status',
                title: '状态码',
                width: 80,
                hidden: true
            }, {
                field: 'statusDesc',
                title: '状态',
                width: 110,
                align: 'center',
                styler: function (value, rowData, rowIndex) {
                    if (PHA_COM.VAR.statusColor[value]) {
                        return 'background-color:' + PHA_COM.VAR.statusColor[value] + "; color:white;";
                    }
                }
            }, {
                field: 'boxNo',
                title: '装箱单号',
                width: 130
            }, {
                field: 'boxPath',
                title: '物流路径',
                width: 200,
                formatter: function (value, rowData, rowIndex) {
                    return rowData.fromLocDesc + "<b> → </b>" + rowData.toLocDesc;
                }
            },  {
                field: 'inciCnt',
                title: '品种数',
                width: 50
            },{
                field: 'boxNum',
                title: '箱数',
                width: 50
            },{
                field: 'createInfo',
                title: '装箱',
                width: 160,
                formatter: function (value, rowData, rowIndex) {
                    var valArr = value.split('^');
                    if (valArr.length > 1) {
                        return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
                    }
                    return "";
                }
            }, {
                field: 'formHandInfo',
                title: '交接',
                width: 160,
                formatter: function (value, rowData, rowIndex) {
                    var valArr = value.split('^');
                    if (valArr.length > 1) {
                        return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
                    }
                    return "";
                }
            }, {
                field: 'toHandInfo',
                title: '接收',
                width: 160,
                formatter: function (value, rowData, rowIndex) {
                    var valArr = value.split('^');
                    if (valArr.length > 1) {
                        return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
                    }
                    return "";
                }
            }, {
                field: 'toCheckInfo',
                title: '核对',
                width: 160,
                formatter: function (value, rowData, rowIndex) {
                    var valArr = value.split('^');
                    if (valArr.length > 1) {
                        return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
                    }
                    return "";
                }
            }, {
                field: 'noUseFlag',
                title: '作废',
                width: 75,
                align: 'center',
                formatter: YesNoFormatter
            }, {
                field: 'printFlag',
                title: '打印标志',
                width: 75,
                align: 'center',
                formatter: YesNoFormatter
            }, {
                field: 'remarks',
                title: '备注信息',
                width: 160
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.MOB.BoxFind.Query',
            QueryName: 'PHBox',
        },
        pageSize: 500,
        columns: columns,
        pagination: true,
        toolbar: '#gridBoxBar',
        onSelect: function (rowIndex, rowData) {
            QueryBoxItm();
        },
        onLoadSuccess: function (data) {
            if (!data.total || data.total <= 0) {
                $('#gridBoxItm').datagrid('clear');
            }
        }
    };
    PHA.Grid("gridBox", dataGridOption);
}

// 初始化表格 - 明细
function InitGridBoxItm() {
    // 草药明细列
    var columns = [[{
            field: 'boxItmId',
            title: 'boxItmId',
            width: 80,
            hidden: true
        }, {
            field: 'phdwo',
            title: 'phdwo',
            width: 80,
            hidden: true
        }, {
            field: 'prescNo',
            title: '处方号',
            width: 140,
            align: 'left',
            formatter: function (value, rowData, rowIndex) {
                return "<a style='border:0px;cursor:pointer;text-decoration:underline' onclick=OpenStepWin(" + rowIndex + ") >" + value + "</a>";
            },
            cyCol: true
        }, {
            field: 'arcimCode',
            title: '药品代码',
            width: 120,
            xyCol: true,
            hidden: true
        }, {
            field: 'arcimDesc',
            title: '药品名称',
            width: 200,
            xyCol: true,
            hidden: true
        }, {
            field: 'patNo',
            title: '登记号',
            width: 110,
            align: 'center'
        }, {
            field: 'patName',
            title: '患者姓名',
            width: 90
        }, {
            field: 'patAge',
            title: '年龄',
            width: 90
        }, {
            field: 'patSex',
            title: '性别',
            width: 60,
            align: 'center'
        }, {
            field: 'bedNo',
            title: '床号',
            width: 90
        }, {
            field: 'recLocDesc',
            title: '发药科室',
            width: 120
        }, {
            field: 'careProDesc',
            title: '医生',
            width: 90,
            cyCol: true
        }, {
            field: 'cookPackQty',
            title: '每付袋数',
            width: 80,
            hidden: true,
            cyCol: true
        }, {
            field: 'cookPackML',
            title: '一次用量',
            width: 80,
            cyCol: true
        }, {
            field: 'freqDesc',
            title: '用药频次',
            width: 160
        }, {
            field: 'duratDesc',
            title: '用药疗程',
            width: 90
        }, {
            field: 'instDesc',
            title: '用法',
            width: 80
        }, {
            field: 'ordQty',
            title: '用量',
            width: 80,
            hidden: true
        }, {
            field: 'doseQtyUom',
            title: '用量',
            width: 80,
            hidden: true,
            xyCol: true
        }, {
            field: 'phCookMode',
            title: '煎药方式',
            width: 80,
            align: 'center',
            cyCol: true
        }, {
            field: 'packQty',
            title: '总付数',
            width: 100,
            cyCol: true
        }, {
            field: 'dispPackQty',
            title: '发放付数',
            width: 100,
            cyCol: true
        }, {
            field: 'Notes',
            title: '处方备注',
            width: 100,
            cyCol: true
        }, {
            field: 'Emergency',
            title: '是否加急',
            width: 80,
            align: 'center',
            formatter: YesNoFormatter,
            cyCol: true
        }
    ]];
    
    var dataGridOption = {
        url: '',
        gridSave: false,
        queryParams: {},
        pageSize: 500,
        columns: columns,
        pagination: true,
        toolbar: []
    };
    PHA.Grid("gridBoxItm", dataGridOption);
}

// 查询
function QueryBox() {
    var formDataArr = PHA.DomData("#gridBoxBar", {
        doType: 'query',
        retType: 'Json'
    });
    if (formDataArr.length == 0) {
        return;
    }
    var formData = formDataArr[0];
    var pJsonStr = JSON.stringify(formData);

    $('#gridBox').datagrid('query', {
        pJsonStr: pJsonStr
    });
}

// 查询
function QueryBoxItm() {
    var selRow = $('#gridBox').datagrid('getSelected');
    if (selRow == null) {
        return;
    }
    var pJsonStr = JSON.stringify(selRow);
    
    $('#gridBoxItm').datagrid('options').url = $URL;
    if (selRow.isPhbHasItm == '1') {
        showHideCols('cy')
        $('#gridBoxItm').datagrid('query', {
            ClassName: 'PHA.MOB.BoxFind.Query',
            QueryName: 'PHBoxItm',
            pJsonStr: pJsonStr
        });
    } else {
        showHideCols('xy')
        $('#gridBoxItm').datagrid('query', {
            ClassName: 'PHA.MOB.BoxFind.Query',
            QueryName: 'PHBoxItmXY',
            pJsonStr: pJsonStr
        });
    }
}

// 显示或隐藏列(根据中药西药显示不同的列)
function showHideCols(showType){
    var dgOpts = $('#gridBoxItm').datagrid('options');
    var mColumns = dgOpts.columns[0];
    if (showType == 'cy') {
        for (var i = 0; i < mColumns.length; i++) {
            if (mColumns[i].xyCol) {
                $('#gridBoxItm').datagrid('hideColumn', mColumns[i].field)
            }
            if (mColumns[i].cyCol) {
                $('#gridBoxItm').datagrid('showColumn', mColumns[i].field)
            }
        }
    }
    if (showType == 'xy') {
        for (var i = 0; i < mColumns.length; i++) {
            if (mColumns[i].cyCol) {
                $('#gridBoxItm').datagrid('hideColumn', mColumns[i].field)
            }
            if (mColumns[i].xyCol) {
                $('#gridBoxItm').datagrid('showColumn', mColumns[i].field)
            }
        }
    }
}

// 清屏
function Clear() {
    PHA.DomData("#gridBoxBar", {
        doType: 'clear'
    });
    $('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
    $('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
    $('#fromLocId').combobox('setValue', '');
    $('#toLocId').combobox('setValue', '');
    $('#gridBox').datagrid('clear');
    $('#gridBoxItm').datagrid('clear');
}

// 打印
function Print() {
    var selRow = $('#gridBox').datagrid('getSelected');
    if (selRow == null) {
        $.messager.popover({
            msg: "请先选择一个物流箱!",
            type: "alert",
            timeout: 1000
        });
        return;
    }
    var boxId = selRow.boxId || "";
    if (boxId == "") {
        $.messager.popover({
            msg: "物流箱ID为空!",
            type: "alert",
            timeout: 1000
        });
        return;
    }
    PHA_MOB_PRINT.PrintBoxLable(boxId);

    // 更新打印状态
    var updRet = tkMakeServerCall('PHA.MOB.BoxFind.Save', 'UpdatePrintFlag', boxId);
    var updRetArr = updRet.split('^');
    if (updRetArr[0] == 0) {
        var rowIndex = GetGridRowIndex('gridBox', selRow);
        $('#gridBox').datagrid('updateRow', {
            index: rowIndex,
            row: {
                printFlag: 'Y'
            }
        });
        $('#gridBox').datagrid('refreshRow', rowIndex);
    }
}

// 根据行数据获取行号
function GetGridRowIndex(_id, _rowData) {
    var rowIndex = $('#' + _id).datagrid('getRowIndex', _rowData);
    return rowIndex;
}

// 处方追踪弹窗
function OpenStepWin(rowIndex) {
    var rowsData = $('#gridBoxItm').datagrid('getRows');
    if (rowsData == null) {
        $.messager.popover({
            msg: "处方列表没有数据!",
            type: "alert",
            timeout: 1000
        });
        return;
    }
    var rowData = rowsData[rowIndex];
    var prescNo = rowData.prescNo || "";
    if (prescNo == "") {
        $.messager.popover({
            msg: "请先选择处方!",
            type: "alert",
            timeout: 1000
        });
        return;
    }

    // 窗口
    var winWidth = parseInt($(document.body).width() * 0.97);
    var winId = "presc_win_step";
    var winContentId = "presc_win_step" + "_content";
    if ($('#' + winId).length == 0) {
        $("<div id='" + winId + "'></div>").appendTo("body");
        $('#' + winId).dialog({
            width: winWidth,
            height: 160,
            modal: true,
            title: "处方状态追踪",
            iconCls: 'icon-w-find',
            content: "<div id='" + winContentId + "' style='height:90px;margin:10px;'></div>",
            closable: true,
            onClose: function () {}
        });
    }

    // 步骤
    $("#" + winContentId).children().remove();
    var stepJsonStr = tkMakeServerCall('PHA.MOB.BoxFind.Query', 'GetStepWinInfo', prescNo);
    var stepJsonData = eval('(' + stepJsonStr + ')');
    var steps = stepJsonData.items.length;
    var stepWidth = (winWidth - 40) / steps;
    $("#" + winContentId).hstep({
        titlePostion: 'top',
        showNumber: false,
        stepWidth: stepWidth,
        currentInd: stepJsonData.currentInd,
        items: stepJsonData.items,
        onSelect: function (ind, item) {}
    });

    // 打开窗口
    $('#' + winId).dialog('open');
    $('#' + winId).dialog('setTitle', '处方状态追踪');
    
    // 处理翻译问题
    var prescNoId = winId + '_presc';
    if ($('#' + prescNoId).length == 0) {
        $('#' + winId).prev().children().eq(0).append('<label id="' + prescNoId + '"></label>');
    }
    $('#' + prescNoId).text(' - ' + prescNo)
}

function YesNoFormatter(value, row, index) {
    if (value == "Y") {
        return PHA_COM.Fmt.Grid.Yes.Chinese;
    } else {
        return PHA_COM.Fmt.Grid.No.Chinese;
    }
}

// 配置
function InitConfig() {
    // 获取颜色列表
    var retColorStr = tkMakeServerCall("PHA.MOB.BoxFind.Query", "GetStatusColor");
    PHA_COM.VAR.statusColor = eval('(' + retColorStr + ')');

    // 获取通用配置
    $.cm({
        ClassName: "PHA.MOB.COM.PC",
        MethodName: "GetConfig",
        InputStr: PHA_COM.Session.ALL
    }, function (retJson) {
        // 传递给全局
        PHA_COM.VAR.CONFIG = retJson;
    }, function (error) {
        console.dir(error);
        alert(error.responseText);
    });
}
