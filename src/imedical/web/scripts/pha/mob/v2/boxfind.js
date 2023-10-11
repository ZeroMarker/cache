/**
 * @Description: �ƶ�ҩ�� - �������ѯ
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
    // ��ʼ��
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

// ��ʼ����
function InitDict() {
    // ��������
    PHA.ComboBox("fromLocId", {
        placeholder: '��������...',
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

    // �������
    PHA.ComboBox("toLocId", {
        placeholder: '�������...',
        url: PHA_STORE.CTLoc().url
    });

    // ������״̬
    PHA.ComboBox("boxStatus", {
        placeholder: '����״̬...',
        url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.BoxFind.Query&QueryName=BoxStatus',
        onSelect: function (record) {
            QueryBox();
        }
    });

    // ����Ĭ��
    if ($('#startDate').datebox('getValue') == "") {
        $('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
        $('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
    }
    if ($('#endDate').datebox('getValue') == "") {
        $('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
        $('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
    }
}

// ��ʼ�����
function InitGridBox() {
    var columns = [[{
                field: 'boxId',
                title: 'boxId',
                width: 80,
                hidden: true
            }, {
                field: 'status',
                title: '״̬��',
                width: 80,
                hidden: true
            }, {
                field: 'statusDesc',
                title: '״̬',
                width: 110,
                align: 'center',
                styler: function (value, rowData, rowIndex) {
                    if (PHA_COM.VAR.statusColor[value]) {
                        return 'background-color:' + PHA_COM.VAR.statusColor[value] + "; color:white;";
                    }
                }
            }, {
                field: 'boxNo',
                title: 'װ�䵥��',
                width: 130
            }, {
                field: 'boxPath',
                title: '����·��',
                width: 200,
                formatter: function (value, rowData, rowIndex) {
                    return rowData.fromLocDesc + "<b> �� </b>" + rowData.toLocDesc;
                }
            },  {
                field: 'inciCnt',
                title: 'Ʒ����',
                width: 50
            },{
                field: 'boxNum',
                title: '����',
                width: 50
            },{
                field: 'createInfo',
                title: 'װ��',
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
                title: '����',
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
                title: '����',
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
                title: '�˶�',
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
                title: '����',
                width: 75,
                align: 'center',
                formatter: YesNoFormatter
            }, {
                field: 'printFlag',
                title: '��ӡ��־',
                width: 75,
                align: 'center',
                formatter: YesNoFormatter
            }, {
                field: 'remarks',
                title: '��ע��Ϣ',
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

// ��ʼ����� - ��ϸ
function InitGridBoxItm() {
    // ��ҩ��ϸ��
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
            title: '������',
            width: 140,
            align: 'left',
            formatter: function (value, rowData, rowIndex) {
                return "<a style='border:0px;cursor:pointer;text-decoration:underline' onclick=OpenStepWin(" + rowIndex + ") >" + value + "</a>";
            },
            cyCol: true
        }, {
            field: 'arcimCode',
            title: 'ҩƷ����',
            width: 120,
            xyCol: true,
            hidden: true
        }, {
            field: 'arcimDesc',
            title: 'ҩƷ����',
            width: 200,
            xyCol: true,
            hidden: true
        }, {
            field: 'patNo',
            title: '�ǼǺ�',
            width: 110,
            align: 'center'
        }, {
            field: 'patName',
            title: '��������',
            width: 90
        }, {
            field: 'patAge',
            title: '����',
            width: 90
        }, {
            field: 'patSex',
            title: '�Ա�',
            width: 60,
            align: 'center'
        }, {
            field: 'bedNo',
            title: '����',
            width: 90
        }, {
            field: 'recLocDesc',
            title: '��ҩ����',
            width: 120
        }, {
            field: 'careProDesc',
            title: 'ҽ��',
            width: 90,
            cyCol: true
        }, {
            field: 'cookPackQty',
            title: 'ÿ������',
            width: 80,
            hidden: true,
            cyCol: true
        }, {
            field: 'cookPackML',
            title: 'һ������',
            width: 80,
            cyCol: true
        }, {
            field: 'freqDesc',
            title: '��ҩƵ��',
            width: 160
        }, {
            field: 'duratDesc',
            title: '��ҩ�Ƴ�',
            width: 90
        }, {
            field: 'instDesc',
            title: '�÷�',
            width: 80
        }, {
            field: 'ordQty',
            title: '����',
            width: 80,
            hidden: true
        }, {
            field: 'doseQtyUom',
            title: '����',
            width: 80,
            hidden: true,
            xyCol: true
        }, {
            field: 'phCookMode',
            title: '��ҩ��ʽ',
            width: 80,
            align: 'center',
            cyCol: true
        }, {
            field: 'packQty',
            title: '�ܸ���',
            width: 100,
            cyCol: true
        }, {
            field: 'dispPackQty',
            title: '���Ÿ���',
            width: 100,
            cyCol: true
        }, {
            field: 'Notes',
            title: '������ע',
            width: 100,
            cyCol: true
        }, {
            field: 'Emergency',
            title: '�Ƿ�Ӽ�',
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

// ��ѯ
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

// ��ѯ
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

// ��ʾ��������(������ҩ��ҩ��ʾ��ͬ����)
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

// ����
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

// ��ӡ
function Print() {
    var selRow = $('#gridBox').datagrid('getSelected');
    if (selRow == null) {
        $.messager.popover({
            msg: "����ѡ��һ��������!",
            type: "alert",
            timeout: 1000
        });
        return;
    }
    var boxId = selRow.boxId || "";
    if (boxId == "") {
        $.messager.popover({
            msg: "������IDΪ��!",
            type: "alert",
            timeout: 1000
        });
        return;
    }
    PHA_MOB_PRINT.PrintBoxLable(boxId);

    // ���´�ӡ״̬
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

// ���������ݻ�ȡ�к�
function GetGridRowIndex(_id, _rowData) {
    var rowIndex = $('#' + _id).datagrid('getRowIndex', _rowData);
    return rowIndex;
}

// ����׷�ٵ���
function OpenStepWin(rowIndex) {
    var rowsData = $('#gridBoxItm').datagrid('getRows');
    if (rowsData == null) {
        $.messager.popover({
            msg: "�����б�û������!",
            type: "alert",
            timeout: 1000
        });
        return;
    }
    var rowData = rowsData[rowIndex];
    var prescNo = rowData.prescNo || "";
    if (prescNo == "") {
        $.messager.popover({
            msg: "����ѡ�񴦷�!",
            type: "alert",
            timeout: 1000
        });
        return;
    }

    // ����
    var winWidth = parseInt($(document.body).width() * 0.97);
    var winId = "presc_win_step";
    var winContentId = "presc_win_step" + "_content";
    if ($('#' + winId).length == 0) {
        $("<div id='" + winId + "'></div>").appendTo("body");
        $('#' + winId).dialog({
            width: winWidth,
            height: 160,
            modal: true,
            title: "����״̬׷��",
            iconCls: 'icon-w-find',
            content: "<div id='" + winContentId + "' style='height:90px;margin:10px;'></div>",
            closable: true,
            onClose: function () {}
        });
    }

    // ����
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

    // �򿪴���
    $('#' + winId).dialog('open');
    $('#' + winId).dialog('setTitle', '����״̬׷��');
    
    // ����������
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

// ����
function InitConfig() {
    // ��ȡ��ɫ�б�
    var retColorStr = tkMakeServerCall("PHA.MOB.BoxFind.Query", "GetStatusColor");
    PHA_COM.VAR.statusColor = eval('(' + retColorStr + ')');

    // ��ȡͨ������
    $.cm({
        ClassName: "PHA.MOB.COM.PC",
        MethodName: "GetConfig",
        InputStr: PHA_COM.Session.ALL
    }, function (retJson) {
        // ���ݸ�ȫ��
        PHA_COM.VAR.CONFIG = retJson;
    }, function (error) {
        console.dir(error);
        alert(error.responseText);
    });
}
