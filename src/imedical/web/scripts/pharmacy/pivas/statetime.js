/**
 * 模块:     配液流程时间段查询
 * 编写日期: 2019-10-28
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];

$(function () {
    $("#conDateStart").datebox("setValue", "t");
    $("#conDateEnd").datebox("setValue", "t");
    $('#conPatNo').on('keypress', function (event) {
        if (event.keyCode == "13") {
            var patNo = this.value;
            if (patNo == "") {
                return;
            }
            var patLen = PIVAS.PatNoLength();
            var plen = patNo.length;
            if (plen > patLen) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "输入登记号错误",
                    type: 'alert'
                });
                return;
            }
            for (i = 1; i <= patLen - plen; i++) {
                patNo = "0" + patNo;
            }
            $(this).val(patNo);

        }
    });
    $("#btnFind").on("click", Query);
    InitDict();
    InitGridPSTime();
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    PIVAS.ComboBox.Init({
        Id: 'conPSStart',
        Type: 'PIVAState'
    }, {
        width: 154,
        editable: false,
        placeholder: "开始...",
        onLoadSuccess: function () {
            $("#conPSStart").combobox("select", 60)
        },
        onSelect: function (data) {
            $("#gridPSTime").datagrid("setColumnTitle", {
                psStartDT: data.Description + "时间"
            })
        }
    });

    PIVAS.ComboBox.Init({
        Id: 'conPSEnd',
        Type: 'PIVAState'
    }, {
        width: 154,
        editable: false,
        placeholder: "结束...",
        onLoadSuccess: function () {
            $("#conPSEnd").combobox("select", 80)
        },
        onSelect: function (data) {
            $("#gridPSTime").datagrid("setColumnTitle", {
                psEndDT: data.Description + "时间"
            })
        }
    });
    PIVAS.ComboBox.Init({
        Id: 'conRelation',
        Type: 'MoreOrLess'
    }, {
        width: 87,
        placeholder: "关系..."
    });
    PIVAS.ComboBox.Init({
        Id: 'conWard',
        Type: 'Ward'
    }, {
        width: 240
    });
    PIVAS.ComboGrid.Init({
        Id: 'conInci',
        Type: 'IncItm'
    }, {
        width: 240
    });
}

function InitGridPSTime() {
    var columns = [
        [{
            field: 'doseDT',
            title: '用药时间',
            width: 100
        }, {
            field: 'fieldDel',
            title: '',
            width: 5,
            hidden: false,
            styler: function (value, row, index) {
                return "background:#F4F7F6;";
            }
        }, {
            field: 'psStartDT',
            title: '开始时间',
            width: 100
        }, {
            field: 'psTimeRange',
            title: '描述值',
            width: 90,
            hidden: true
        }, {
            field: 'ps60ExeRange',
            title: '描述值exe60',
            width: 90,
            hidden: true
        },  {
            field: 'psEndDT',
            title: '结束时间',
            width: 100
        },{
            field: 'psTimeRangeSec',
            title: '间隔时长',
            width: 110,
            sortable: true,
            halign: "center",
            align: "right",
            styler: function (value, row, index) {
                return "font-weight:bold;";
            },
            formatter: function (value, row, index) {
                return row.psTimeRange;
            }

        }, {
            field: 'fieldDel',
            title: '',
            width: 5,
            hidden: false
        }, {
            field: 'ps60DT',
            title: '配置时间',
            width: 100
        }, {
            field: 'exeDT',
            title: '护士执行时间',
            width: 100
        }, {
            field: 'ps60ExeRangeSec',
            title: '间隔时长',
            width: 110,
            sortable: true,
            halign: "center",
            align: "right",
            styler: function (value, row, index) {
                return "font-weight:bold;";
            },
            formatter: function (value, row, index) {
                return row.ps60ExeRange;
            }
        }, {
            field: 'fieldDel',
            title: '',
            width: 5,
            hidden: false
        }, {
            field: 'wardDesc',
            title: '病区',
            width: 150
        }, {
            field: 'patNo',
            title: '登记号',
            width: 100
        }, {
            field: 'patName',
            title: '姓名',
            width: 100
        }, {
            field: 'drugs',
            title: '药品',
            width: 600
        }, {
            field: 'barCode',
            title: '条码',
            width: 100
        }]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.StateTime",
            QueryName: "QueryStateTime"
        },
        fit: true,
        // striped:true,
        // toolbar: '#gridOrdExeBar',
        rownumbers: false,
        columns: columns,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        onLoadSuccess: function () {
            $("tr [field=fieldDel]").css("border-bottom", "none")
            $(".datagrid-row:last").find("[field=fieldDel]").css("border-bottom", "1px solid #cccccc");
            $(this).datagrid("scrollTo", 0); 

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPSTime", dataGridOption);
}

function Query() {
    var psStart=$("#conPSStart").combobox("getValue");
    var psEnd=$("#conPSEnd").combobox("getValue") ;
    if (parseInt(psEnd)<parseInt(psStart)){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "结束流程应在开始流程之后",
            type: 'alert'
        });
        return "";
    }
    var inputStr = "";
    inputStr += SessionLoc + "^";
    inputStr += $("#conDateStart").datebox("getValue") + "^";
    inputStr += $("#conDateEnd").datebox("getValue") + "^";
    inputStr += $("#conWard").combobox("getValue") + "^";
    inputStr += $("#conPatNo").val() + "^";
    inputStr += ($("#conInci").combogrid("getValue") || "") + "^";
    inputStr += psStart + "^";
    inputStr += psEnd+ "^";
    inputStr += $("#conRelation").combobox("getValue") + "^";
    inputStr += $("#conTimeHLen").numberbox("getValue") + "^";
    inputStr += $("#conTimeMLen").numberbox("getValue");
    $("#gridPSTime").datagrid("query", {
        InputStr: inputStr
    })
}