/**
 * 模块:     配液流程单据打印记录
 * 编写日期: 2018-04-20
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PrtWardBatPS = '';
$(function () {
    InitDict();
    InitGridOrdExe();
    InitGridPrint();
    InitPivasSettings();
    $('#btnFind').bind('click', Query);
    $('#btnPrint').bind('click', PrintSelect);
    $('#btnPrintAll').bind('click', PrintAll);
    $('#btnPrintArrange').bind('click', PrintArrange);
    $('#btnPrintWardBat').bind('click', PrintWinHandler);
    $('#btnPrtSelectDivOk').on('click', PrintHandler);
    $('#btnClear').bind('click', Clear);
    $('#txtPatNo').bind('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = $('#txtPatNo').val();
            if (patNo == '') {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
            Query();
        }
    });
    setTimeout(function () {
        getLodop();
    }, 2000);
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    // 日期
    PIVAS.Date.Init({
        Id: 'datePrtStart',
        LocId: '',
        Type: 'Start',
        QueryType: 'Query'
    });
    PIVAS.Date.Init({
        Id: 'datePrtEnd',
        LocId: '',
        Type: 'End',
        QueryType: 'Query'
    });

    // 病区
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWard',
            Type: 'Ward'
        },
        {
            placeholder: $g('病区') + '...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWorkType',
            Type: 'PIVAWorkType',
            StrParams: SessionLoc
        },
        {
            placeholder: $g('工作组') + '...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaStat',
            Type: 'PIVAState'
        },
        {
            editable: false,
            placeholder: $g('配液状态') + '...'
        }
    );
    // 流程单号
    $('#txtPogsNo').searchbox({
        searcher: function (value, name) {
            var pivaLocId = session['LOGON.CTLOCID'];
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            PIVAS.PogsNoWindow({
                TargetId: 'txtPogsNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $('#txtPogsNo')
        .next()
        .find('input:first')
        .attr('placeholder', $g('流程单号') + '...');
}

// 停止签医嘱明细列表
function InitGridOrdExe() {
    var columns = [
        [
            {
                field: 'gridOrdExeChk',
                checkbox: true
            },
            {
                field: 'pNo',
                title: '序号',
                width: 40
            },
            {
                field: 'batNo',
                title: '批次',
                width: 50,
                styler: function (value, row, index) {
                    var colorStyle = '';
                    if (row.packFlag != '') {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'pivaCatDesc',
                title: '配液大类',
                width: 125
            },
            {
                field: 'patInfo',
                title: '病人信息',
                width: 230,
                formatter: function (value, rowData, index) {
                    var retHtmlArr = [];
                    retHtmlArr.push('<div class="pha-scan-ward">' + rowData.wardDesc + '</div>');
                    retHtmlArr.push('<div style="padding-top:8px">');
                    retHtmlArr.push('   <div style="float:left;width:125px">' + rowData.patBedNo + ' / ' + rowData.patName + '</div>');
                    retHtmlArr.push('   <div style="float:right">' + rowData.patNo + '</div>');
                    retHtmlArr.push('</div>');
                    return retHtmlArr.join('');
                }
            },
            {
                field: 'useInfo',
                title: '用法信息',
                width: 170,
                formatter: function (value, rowData, index) {
                    var retHtmlArr = [];

                    retHtmlArr.push('<div>');
                    retHtmlArr.push('   <div style="float:left;width:80px">' + rowData.doseDateTime + '</div>');
                    retHtmlArr.push('   <div style="float:right">' + rowData.freqDesc + '</div>');
                    retHtmlArr.push('   <div style="clear:both"></div>');
                    retHtmlArr.push('</div>');
                    retHtmlArr.push('<div style="padding-top:8px">');
                    retHtmlArr.push('   <div style="float:left;width:80px">' + rowData.instrDesc + '</div>');
                    retHtmlArr.push('   <div style="float:right">' + rowData.priDesc + '</div>');
                    retHtmlArr.push('   <div style="clear:both"></div>');
                    retHtmlArr.push('</div>');
                    return retHtmlArr.join('');
                }
            },
            {
                field: 'drugsArr',
                title: '药品信息',
                width: 350,
                formatter: PIVAS.Grid.Formatter.InciGroup
            },
            {
                field: 'dosage',
                title: '剂量',
                width: 75,
                align: 'right',
                formatter: PIVAS.Grid.Formatter.DosageGroup
            },
            {
                field: 'qtyUom',
                title: '数量',
                width: 50,
                align: 'right',
                formatter: PIVAS.Grid.Formatter.QtyUomGroup
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
            ClassName: 'web.DHCSTPIVAS.PrintRecord',
            QueryName: 'PrintDetail'
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        nowrap: false,
        pageSize: 9999,
        pageList: [9999],
        toolbar: [],
        pagination: true,
        onLoadSuccess: function () {},
        onClickRow: function (rowIndex, rowData) {}
    };
    PIVAS.Grid.Init('gridOrdExe', dataGridOption);
}
// 签明细列表
function InitGridPrint() {
    var columns = [
        [
            {
                field: 'psNumber',
                title: '流程标识',
                width: 100,
                hidden: true
            },
            {
                field: 'psName',
                title: '配液状态',
                width: 75,
                align: 'center',
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
                align: 'center'
            },
            {
                field: 'doseDateRange',
                title: '用药日期范围',
                width: 200,
                align: 'center'
            }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.PrintRecord',
            QueryName: 'PogsNoList'
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        toolbar: [],
        onLoadSuccess: function () {
            $('#gridOrdExe').datagrid('clear').datagrid('unselectAll');
        },
        onClickRow: function (rowIndex, rowData) {
            var params = QueryParams();
            var pogsNo = rowData.pogsNo;
            $('#gridOrdExe')
                .datagrid('query', {
                    pogsNo: pogsNo,
                    inputStr: params
                })
                .datagrid('unselectAll');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridPrint', dataGridOption);
}
//查询
function Query() {
    var params = QueryParams();
    $('#gridPrint').datagrid('query', {
        inputStr: params,
        rows: 99999
    });
}

function QueryParams() {
    var prtStDate = $('#datePrtStart').datebox('getValue'); //起始日期
    var prtEdDate = $('#datePrtEnd').datebox('getValue'); //截止日期
    var prtStTime = $('#timePrtStart').timespinner('getValue');
    var prtEdTime = $('#timePrtEnd').timespinner('getValue');
    var locId = SessionLoc;
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $('#txtPatNo').val().trim();
    var pNo = $('#txtPNo').val().trim();
    var workTypeId = $('#cmbWorkType').combobox('getValue');
    var psNumber = $('#cmbPivaStat').combobox('getValue');
    var pogsNo = $('#txtPogsNo').searchbox('getValue');
    var params = [locId, wardId, prtStDate, prtEdDate, prtStTime, prtEdTime, patNo, pNo, workTypeId, psNumber, pogsNo];
    return params.join('^');
}

function GetCheckedPogArr() {
    var pogArr = [];
    var gridChecked = $('#gridOrdExe').datagrid('getChecked');
    if (gridChecked == '') {
        $.messager.alert($g('提示'), $g('请先选择记录'), 'warning');
        return pogArr;
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var pogId = gridChecked[cI].pogId;
        if (pogId == '') {
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
        pogStr: pogArr.join('^')
    });
}
/// 打印所有
function PrintAll() {
    var gridSelect = $('#gridPrint').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选择需要补打的单据记录'),
            type: 'alert'
        });
        return;
    }
    var pogsNo = gridSelect.pogsNo;
    PIVASPRINT.LabelsJsonByPogsNo({
        pogsNo: pogsNo,
        sortWay: ''
    });
}
/// 清屏
function Clear() {
    $('#cmbPivaStat').combobox('clear');
    $('#cmbWorkType').combobox('clear');
    $('#cmbWard').combobox('clear');
    PIVAS.Date.Init({
        Id: 'datePrtStart',
        LocId: '',
        Type: 'Start',
        QueryType: 'Query'
    });
    PIVAS.Date.Init({
        Id: 'datePrtEnd',
        LocId: '',
        Type: 'End',
        QueryType: 'Query'
    });
    $('#timePrtStart').timespinner('setValue', '');
    $('#timePrtEnd').timespinner('setValue', '');
    $('#txtPatNo').val('');
    $('#txtPNo').val('');
    $('#txtPogsNo').searchbox('clear');
    $('#gridPrint').datagrid('clear');
    $('#gridOrdExe').datagrid('clear');
}

function PrintArrange() {
    var gridSelect = $('#gridPrint').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选择需要补打的单据记录'),
            type: 'alert'
        });
        return;
    }
    var geneNo = gridSelect.pogsNo;
    if (geneNo == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('没有单号,不能进行补打'),
            type: 'alert'
        });
        return;
    }
    PIVASPRINT.Arrange(geneNo, '', '');
}
function PrintHandler() {
    var gridSelect = $('#gridPrint').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选择需要补打的单据记录'),
            type: 'alert'
        });
        return;
    }
    var prtWay = $("input[name='prtPOGSWay']:checked").val() || '';
    if (prtWay === '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选择对应的打印方式'),
            type: 'alert'
        });
        return;
    }
    var geneNo = gridSelect.pogsNo;
    PrintWardBat(geneNo, prtWay);
}
//function PrintWithGene(geneNo, prtWay, geneWay) {
//    var geneNo = $('#gridPrint').datagrid('getSelected').pogsNo;
//    var pJson = [geneNo];
//    var ret = $.cm(
//        {
//            ClassName: 'web.DHCSTPIVAS.Execute',
//            MethodName: 'ReGenePogsNo',
//            pJsonStr: JSON.stringify(pJson),
//            geneWay: geneWay,
//            dataType: 'text'
//        },
//        false
//    );
//    var retArr = ret.split('^');
//    if (retArr[0] < 0) {
//        $.messager.alert($g('提示'), retArr[1], 'warning');
//        return;
//    }
//    $('#gridPrint').datagrid('reload');
//    var pogsNoStr = retArr[1];
//    PrintWardBat(pogsNoStr, prtWay);
//}
function PrintWardBat(pogsNoStr, prtWay) {
    $('#prtSelectDiv').window('close');
    var printType = '';
    if (prtWay == 1) {
        printType = 'Inci';
    } else if (prtWay == 0) {
        printType = 'Total';
    }
    PIVASPRINT.WardBat.Handler({
        pogsNoArr: pogsNoStr.split(','),
        loc: SessionLoc,
        rePrint: 'Y',
        printType: printType
    });
}

// 初始化默认条件
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'LabelRecord'
        },
        function (jsonData) {
            PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
        }
    );
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Execute'
        },
        function (jsonData) {
            // $('[name=genePOGSNo][value=' + jsonData.GeneWay + ']').radio('setValue', true);
            $('[name=prtPOGSWay][value=' + jsonData.PrtWay + ']').radio('setValue', true);
            PrtWardBatPS = 85; //jsonData.PrtWardBatPS;
        }
    );
}

function PrintWinHandler() {
    var msg = '';
    var gridSelect = $('#gridPrint').datagrid('getSelected');
    if (gridSelect == null) {
        msg = $g('请选择需要补打的单据记录');
    } else if (PrtWardBatPS === '') {
        //msg = $g('请先在【参数设置】中维护交接单所在流程标识号');
    } else if (PrtWardBatPS !== gridSelect.psNumber) {
        //msg = $g('请选择处于交接流程的单据打印');
    }
    if (msg !== '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: msg,
            type: 'alert'
        });
        return;
    }
    $('[name=genePOGSNo]').radio('setValue', false);
    $('#prtSelectDiv').window('open');
    // $('#prtSelectDiv').find('.dialog-button').css('padding-top', '0px');
}
