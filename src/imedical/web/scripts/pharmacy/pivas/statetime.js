/**
 * ģ��:     ��Һ����ʱ��β�ѯ
 * ��д����: 2019-10-28
 * ��д��:   yunhaibao
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
                    msg: "����ǼǺŴ���",
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
        placeholder: "��ʼ...",
        onLoadSuccess: function () {
            $("#conPSStart").combobox("select", 60)
        },
        onSelect: function (data) {
            $("#gridPSTime").datagrid("setColumnTitle", {
                psStartDT: data.Description + "ʱ��"
            })
        }
    });

    PIVAS.ComboBox.Init({
        Id: 'conPSEnd',
        Type: 'PIVAState'
    }, {
        width: 154,
        editable: false,
        placeholder: "����...",
        onLoadSuccess: function () {
            $("#conPSEnd").combobox("select", 80)
        },
        onSelect: function (data) {
            $("#gridPSTime").datagrid("setColumnTitle", {
                psEndDT: data.Description + "ʱ��"
            })
        }
    });
    PIVAS.ComboBox.Init({
        Id: 'conRelation',
        Type: 'MoreOrLess'
    }, {
        width: 87,
        placeholder: "��ϵ..."
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
            title: '��ҩʱ��',
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
            title: '��ʼʱ��',
            width: 100
        }, {
            field: 'psTimeRange',
            title: '����ֵ',
            width: 90,
            hidden: true
        }, {
            field: 'ps60ExeRange',
            title: '����ֵexe60',
            width: 90,
            hidden: true
        },  {
            field: 'psEndDT',
            title: '����ʱ��',
            width: 100
        },{
            field: 'psTimeRangeSec',
            title: '���ʱ��',
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
            title: '����ʱ��',
            width: 100
        }, {
            field: 'exeDT',
            title: '��ʿִ��ʱ��',
            width: 100
        }, {
            field: 'ps60ExeRangeSec',
            title: '���ʱ��',
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
            title: '����',
            width: 150
        }, {
            field: 'patNo',
            title: '�ǼǺ�',
            width: 100
        }, {
            field: 'patName',
            title: '����',
            width: 100
        }, {
            field: 'drugs',
            title: 'ҩƷ',
            width: 600
        }, {
            field: 'barCode',
            title: '����',
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
            msg: "��������Ӧ�ڿ�ʼ����֮��",
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