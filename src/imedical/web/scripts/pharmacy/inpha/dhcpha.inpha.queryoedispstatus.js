/** 
 * 模块: 	 医嘱发药状态查询
 * 编写日期: 2019-01-28
 * 编写人:   pushuangcai
 */
$(function () {
    InitDict();
    InitGridOrdItem();
    $('#btnFind').bind("click", Query);
    $('#btnClear').bind("click", Clear);
    $('#txtPatno').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatno').val();
            if (patNo == "") {
                return;
            }
            var patNoLen = tkMakeServerCall("web.DHCSTPIVAS.Common", "PatRegNoLen"); // 没方法就写10,都是10
            var newpatno = NumZeroPadding(patNo, patNoLen);
            $(this).val(newpatno);
        }
    });
})
//加载控件
function InitDict() {
    // 药品
    var IncItmOpts = {
        QueryParams: {
            ClassName: "web.DHCSTPIVAS.Dictionary",
            QueryName: "IncItm",
            inputParams: ""
        },
        panelWidth: 750,
        columns: [
            [{
                    field: 'incRowId',
                    title: 'incItmRowId',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'incCode',
                    title: '药品代码',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'incDesc',
                    title: '药品名称',
                    width: 400,
                    sortable: true
                },
                {
                    field: 'incSpec',
                    title: '规格',
                    width: 100,
                    sortable: true
                }
            ]
        ],
        idField: 'incRowId',
        textField: 'incDesc'
    }
    DHCPHA_HUI_COM.ComboGrid.Init({
        Id: 'cmgIncItm'
    }, IncItmOpts);
}
//初始化医嘱明细列表
function InitGridOrdItem() {
    var columns = [
        [{
                field: 'OrdItem',
                title: '医嘱ID',
                align: 'left'
            },
            {
                field: "OrdExec",
                title: '执行记录ID',
                align: 'left'
            }, {
                field: 'ArcItmDesc',
                title: '医嘱名称',
                align: 'left'
            },
            {
                field: 'InciDesc',
                title: '药品名称',
                align: 'left'
            },
            {
                field: 'ExStDate',
                title: '计划执行时间',
                align: 'left'
            },
            {
                field: "PhaLoc",
                title: '药房',
                align: 'left'
            },
            {
                field: "Ward",
                title: '病区',
                align: 'left'
            },
            {
                field: "BillPoint",
                title: '计费点',
                align: 'left'
            },
            {
                field: "BillStatus",
                title: '计费状态',
                align: 'center'
            },
            {
                field: "ArrearsFlag",
                title: '是否欠费',
                align: 'center',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[3] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "NurseDealOrd",
                title: '护士医嘱处理',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[1] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "NurseAudit",
                title: '领药审核',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[0] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "PhAudit",
                title: '药师审核',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[2] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            }, {
                field: "DispRefuse",
                title: '拒绝发药',
                align: 'left',
                styler: function (val, row, index) {
                    if (val != "") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "ExecStatus",
                title: '执行状态',
                align: 'center',
                styler: function (val, row, index) {
                    if ((val.indexOf("停止") > -1) || ((val.indexOf("撤销") > -1)&&(val.indexOf("撤销执行") < 0)) || (val.indexOf("拒绝") > -1)) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "SkinTestFlag",
                title: '是否需皮试',
                align: 'center'
            },
            {
                field: "SkinTest",
                title: '皮试结果',
                align: 'center',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[6] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "DispStatus",
                title: '打包发药状态',
                align: 'center',
                styler: function (val, row, index) {
                    if (val.indexOf("已发") > -1) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "Priority",
                title: '医嘱优先级',
                align: 'center',
                styler: function (val, row, index) {
                    if ((val.indexOf("自备") >= 0) || (val.indexOf("嘱托") >= 0)) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "DeptLoc",
                title: '开单科室',
                align: 'center'
            },
            {
                field: "SpeLocFlag",
                title: '是否特殊科室',
                align: 'center'
            },
            {
                field: "InHospFlag",
                title: '当前在院状态',
                align: 'center'
            },
            {
                field: "OrdPreXDateTime",
                title: '预停时间',
                align: 'center',
                styler: function (val, row, index) {
	                if (val.split(" ")[0] == row.ExStDate.split(" ")[0]){
                    	return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "DispType",
                title: '发药类别',
                align: 'center'
            },
            {
                field: "DispNo",
                title: '发药单号',
                align: 'center'
            },
            {
                field: "DispDate",
                title: '发药时间',
                align: 'center'
            },
            {
                field: "OrdQty",
                title: '发药数量',
                align: 'left'
            },
            {
                field: "AvailQty",
                title: '可用库存',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[4] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            }, {
                field: "ArcMastEdDate",
                title: '医嘱项截止日期',
                align: 'center',
                styler: function (val, row, index) {
                    if (val.indexOf("截止") > -1) {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "PriceRule",
                title: '当前价格规则',
                align: 'center'
            },
            {
                field: "HasDspChl",
                title: '打包子表',
                align: 'left',
                styler: function (val, row, index) {
                    var warnStr = row.WarnFlagStr;
                    if (warnStr.split("#")[5] == "Y") {
                        return 'background-color:#ffb3b3;';
                    }
                }
            },
            {
                field: "WarnFlagStr",
                title: '需警示的标志串', // #1:领药审核,#2:医嘱处理,#3:药师审核,#4:欠费,#5:库存不足,#6:打包子表没数据,#7:皮试
                align: 'center',
                hidden:true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCINPHA.DispOrdItmStatus",
            QueryName: "CheckOrdDispStatus",
        },
        pagination: true,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: [],
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdItem", dataGridOption);
}
//查询方法
function Query() {
    var params = getQueryParams();
    $('#gridOrdItem').datagrid('query', {
        InputStr: params
    });
}
//清空
function Clear() {
    InitDict();
    $('#txtPatno').val("");
    $('#cmgIncItm').combo("clear");
    $('#txtOeori').val("");
    $('#dateStart').datebox("setValue", "");
    $('#txtOrdExe').val("");
    $('#gridOrdItem').datagrid('clear');
}
// 获取参数
function getQueryParams() {
    var ordExDate = $('#dateStart').datebox('getValue');
    var patNo = $('#txtPatno').val();
    var oeori = $('#txtOeori').val();
    var ordExeDr = $('#txtOrdExe').val();
    var incId = $("#cmgIncItm").combobox("getValue") || ""; //库存项
    return patNo + "^" + incId + "^" + oeori + "^" + ordExDate + "^" + ordExeDr;
}

//@description 数字补0
//@input: no,length
function NumZeroPadding(inputNum, numLength) {
    if (inputNum == "") {
        return inputNum;
    }
    var inputNumLen = inputNum.length;
    if ((inputNum<=0)||(inputNumLen > numLength)) {
        $.messager.alert('提示', "输入错误！");
        return;
    }
    for (var i = 1; i <= numLength - inputNumLen; i++) {
        inputNum = "0" + inputNum;
    }
    return inputNum;
}