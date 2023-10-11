/**
 * 模块:     配液中心综合查询
 * 编写日期: 2018-03-28
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardDesc]';
var SameRowsHanlder = PIVAS.Grid.SameRows('gridGenerally', PersonSameFields);
var linkOrderCheck = '';
var GridCmbBatNo;
var SessionInfo = SessionLoc + '^' + SessionUser + '^' + session['LOGON.GROUPID'] + '^' + session['LOGON.HOSPID'];
$(function () {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridGenerally();
    $('#btnFind').on('click', Query);
    $('#btnPrtLabel').on('click', PrintLabel);
    $('#btnPrtTable').on('click', function () {
        if ($('#gridGenerally').datagrid('getChecked').length === 0) {
            $.messager.popover({
                msg: '请勾选需要打印的记录',
                type: 'alert'
            });
            return;
        }
        $.messager.confirm('提示', '您确认打印清单吗?', function (r) {
            if (r) {
                PrintTable();
            }
        });
    });
    $('#btnRetYes').on('click', function () {
        SaveRetFlag('Y');
    });
    $('#btnRetNo').on('click', function () {
        SaveRetFlag('N');
    });
    $('#btnPrtStopLabel').on('click', PrintStopLabel);
    // 登记号回车事件
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patNo = $.trim($('#txtPatNo').val());
            if (patNo != '') {
                patNo = PIVAS.FmtPatNo(patNo);
                $('#txtPatNo').val(patNo);
                Query();
            }
        }
    });
    // 条码号回车事件
    $('#txtBarCode').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var barCode = $.trim($('#txtBarCode').val());
            if (barCode != '') {
                Query();
            }
        }
    });
    // 流程单号
    $('#txtPrtNo').searchbox({
        searcher: function (value, name) {
            if (event.keyCode == 13) {
                Query();
                return;
            }
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            PIVAS.PogsNoWindow({
                TargetId: 'txtPrtNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $('#txtPrtNo').next().find('input:first').attr('placeholder', $g(' 流程单号...'));
    InitPivasSettings();
    setTimeout(function () {
        getLodop();
    }, 2000);
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    // 配液中心
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaLoc',
            Type: 'PivaLoc'
        },
        {
            placeholder: $g('配液中心') + '...',
            editable: false,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('setValue', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function (data) {
                var locId = data.RowId;
                $('#DivBatNo').html('');
                PIVAS.BatchNoCheckList({
                    Id: 'DivBatNo',
                    LocId: locId,
                    Check: true,
                    Pack: false
                });
            }
        }
    );
    // 医嘱优先级
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPriority',
            Type: 'Priority'
        },
        {
            placeholder: $g('医嘱优先级') + '...'
        }
    );
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
    // 科室组
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLocGrp',
            Type: 'LocGrp'
        },
        {
            placeholder: $g('科室组') + '...'
        }
    );
    // 配伍审核
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPassResult',
            Type: 'PassResult'
        },
        {
            placeholder: $g('配伍审核') + '...',
            editable: false
        }
    );
    // 执行记录状态
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbOeoreStat',
            Type: 'OrdStatusDetail'
        },
        {
            placeholder: $g('执行记录状态') + '...'
        }
    );
    // 用法
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbInstruc',
            Type: 'Instruc'
        },
        {
            placeholder: $g('用法') + '...'
        }
    );
    // 频次
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbFreq',
            Type: 'Freq'
        },
        {
            placeholder: $g('频次') + '...'
        }
    );
    // 配液状态
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaStat',
            Type: 'PIVAState'
        },
        {
            placeholder: $g('配液状态') + '...'
        }
    );
    // 是否已打印停止签
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPrintStop',
            Type: 'YesOrNo',
            data: {
                data: [
                    {
                        RowId: 'Y',
                        Description: $g('已打印停止签')
                    },
                    {
                        RowId: 'N',
                        Description: $g('未打印停止签')
                    }
                ]
            }
        },
        {
            placeholder: $g('停止签打印') + '...',
            panelHeight: 'auto'
        }
    );
    // 药品
    PIVAS.ComboGrid.Init(
        {
            Id: 'cmgIncItm',
            Type: 'IncItm'
        },
        {
            placeholder: $g('药品') + '...'
        }
    ); // width: 315
    // 批次
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbBatNo',
            Type: 'Batch'
        },
        {
            multiple: true
        }
    );
    // 是否拒绝配液
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaRefuse',
            Type: 'YesOrNo',
            data: {
                data: [
                    {
                        RowId: 'Y',
                        Description: $g('已配液拒绝')
                    },
                    {
                        RowId: 'N',
                        Description: $g('未配液拒绝')
                    }
                ]
            }
        },
        {
            placeholder: $g('配液拒绝') + '...',
            panelHeight: 'auto'
        }
    );
    PIVAS.BatchNoCheckList({
        Id: 'DivBatNo',
        LocId: SessionLoc,
        Check: true,
        Pack: false
    });
    // 工作组
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWorkType',
            Type: 'PIVAWorkType'
        },
        {
            placeholder: $g('工作组') + '...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPack',
            Type: 'PackType'
        },
        {
            placeholder: $g('打包类型') + '...'
        }
    );
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: 'gridGenerally',
        Field: 'batNo',
        BatUp: 'batUp',
        MDspField: 'mDsp'
    });
}

function InitGridGenerally() {
    var columns = [
        [
            {
                field: 'gridGenerallySelect',
                checkbox: true
            },
            {
                field: 'warnInfo',
                title: '提醒',
                width: 125,
                formatter: function (value, row, index) {
                    var retArr = [];
                    if (row.oeoreStatDesc.indexOf('停止') >= 0) {
                        retArr.push('<div class="pivas-grid-div">' + '执行记录' + row.oeoreStatDesc + '</div>');
                    }
                    if (row.passResultDesc.indexOf('拒绝') >= 0) {
                        retArr.push('<div class="pivas-grid-div">' + '配伍审核拒绝' + '</div>');
                    }
                    if (row.refUser !== '') {
                        retArr.push('<div class="pivas-grid-div">' + '配液拒绝' + '</div>');
                    }
                    if (row.cPrtUser !== '') {
                        retArr.push('<div class="pivas-grid-div">' + '已打停止签' + '</div>');
                    }
                    if (row.nurSeeDesc.indexOf('拒绝') >= 0) {
                        retArr.push('<div class="pivas-grid-div">' + '护士拒绝' + '</div>');
                    }
                    if (retArr.length > 0) {
                        return '<div style="margin-top:-8px;color:#ff584c;font-weight: bold">' + retArr.join('') + '</div>';
                    }
                    return '';
                }
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 125
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 75
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 70
            },
            {
                field: 'doseDateTime',
                title: '用药时间',
                width: 135
            },
            {
                field: 'batNo',
                title: '批次',
                width: 75,
                editor: GridCmbBatNo,
                styler: function (value, row, index) {
                    var colorStyle = 'text-decoration:underline;';
                    if (row.packFlag != '') {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'drugsArr',
                title: '药品信息',
                width: 300,
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
                field: 'freqDesc',
                title: '频次',
                width: 75
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 100
            },
            {
                field: 'priDesc',
                title: '医嘱优先级',
                width: 90
            },
            {
                field: 'psName',
                title: '配液状态',
                width: 80,
                styler: PIVAS.Grid.Styler.PivaState
            },
            {
                field: 'linkFeeAmt',
                title: '配置费',
                align: 'right',
                width: 70,
                formatter: function (value, row, index) {
                    var pog = row.pog;
                    return '<a class="pha-grid-a" onclick="PIVAS.OrdLinkWindow({Params:\'' + pog + '\'} )">' + value + '</a>';
                }
            },
            {
                field: 'barCode',
                title: '条码',
                width: 125,
                formatter: function (value, row, index) {
                    var field = 'barCode';
                    return '<a class="pha-grid-a" onclick="PIVASTIMELINE.Init({Params:\'' + value + "',Field:'" + field + "',ClickField:'" + field + '\'} )">' + value + '</a>';
                }
            },
            {
                field: 'pNo',
                title: '打印序号',
                align: 'right',
                width: 75
            },
            {
                field: 'passResultInfo',
                title: '配伍审核信息',
                width: 155,
                formatter: function (value, row, index) {
                    var retArr = [];
                    retArr.push('<div>' + row.phaOrdDateTime + '</div>');
                    retArr.push('<div class="pivas-grid-div">');
                    retArr.push('   <div style="float:left">' + row.phaOrdUser + '</div>');
                    retArr.push('   <div style="float:right;font-weight:bold">' + row.passResultDesc + '</div>');
                    retArr.push('</div>');
                    return retArr.join('');
                }
            },
            {
                field: 'printInfo',
                title: '打签信息',
                width: 155,
                formatter: function (value, row, index) {
                    return '<div>' + row.printDateTime + '</div>' + '<div class="pivas-grid-div">' + row.printUser + '</div>';
                }
            },
            {
                field: 'cPrtInfo',
                title: '停止签打印信息',
                width: 155,
                formatter: function (value, row, index) {
                    return '<div>' + row.cPrtDateTime + '</div>' + '<div class="pivas-grid-div">' + row.cPrtUser + '</div>';
                }
            },
            {
                field: 'refInfo',
                title: '配液拒绝信息',
                width: 155,
                formatter: function (value, row, index) {
                    var retHtmlArr = [];
                    if (row.refReasonDesc !== '') {
                        retHtmlArr.push('<div class="pivas-grid-tip">');
                        retHtmlArr.push('  <div>');
                        retHtmlArr.push('      <div>' + row.refDateTime + '</div>');
                        retHtmlArr.push('  </div>');
                        retHtmlArr.push('  <div style="padding-top:8px;overflow: hidden; white-space: nowrap;">');
                        retHtmlArr.push('      <div>' + row.refUser + ' / ' + row.refReasonDesc + '</div>');
                        retHtmlArr.push('      <div style="clear:both"></div>');
                        retHtmlArr.push('  </div>');
                        retHtmlArr.push('</div>');
                    }
                    return retHtmlArr.join('');
                }
            },
            {
                field: 'nurSeeInfo',
                title: '医嘱处理信息',
                width: 155,
                formatter: function (value, row, index) {
                    var retArr = [];
                    var nurSeeDateTime = row.nurSeeDateTime;
                    if (nurSeeDateTime === '') {
                        nurSeeDateTime = '　';
                    }
                    retArr.push('<div>' + nurSeeDateTime + '</div>');
                    retArr.push('<div class="pivas-grid-div">');
                    retArr.push('   <div style="float:left">' + row.nurSeeUser + '</div>');
                    retArr.push('   <div style="float:right;font-weight:bold">' + row.nurSeeDesc + '</div>');
                    retArr.push('</div>');
                    return retArr.join('');
                }
            },
            {
                field: 'xDateTime',
                title: '停止时间',
                width: 155
            },
            {
                field: 'oeoriStatDesc',
                title: '医嘱状态',
                width: 80
            },
            {
                field: 'oeoreStatDesc',
                title: '执行记录状态',
                width: 100
            },

            {
                field: 'pog',
                title: 'pog',
                width: 70,
                hidden: false
            },
            {
                field: 'durationDesc',
                title: '疗程',
                width: 50,
                hidden: true
            },
            {
                field: 'packFlag',
                title: '打包',
                width: 50,
                hidden: true
            },
            {
                field: 'mDsp',
                title: 'mDsp',
                width: 50,
                hidden: true
            },
            {
                field: 'sameFlag',
                title: 'sameFlag',
                width: 70,
                hidden: true,
                styler: function (value, row, index) {
                    if (value === 'Y') {
                        return {
                            class: 'pivas-person-toggle'
                        };
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: '',
        nowrap: false,
        toolbar: '#gridGenerallyBar',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageNumber: 1,
        pageSize: 100,
        pageList: [100, 300, 500, 1000],
        onLoadSuccess: function () {
            var $grid = $(this);
            SameRowsHanlder.Hide();
            $grid.datagrid('loaded');
            $(this).datagrid('options').checking = '';
        },
        rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
        onClickRow: function (rowIndex, rowData) {
            SameRowsHanlder.ShowRow(rowIndex);
        },
        onBeforeSelect: function (rowIndex, rowData) {
            $(this).datagrid('unselectAll');
        },
        onClickCell: function (rowIndex, field, value) {
            if (field !== 'barCode') {
                if ($('#TimeLineWin')) {
                    $('#TimeLineWin').window('close');
                }
            }
            if (field == 'batNo' && value != '') {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = '';
        },
        onUnselect: function (rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id);
        },
        loadFilter: PIVAS.Grid.LoadFilter
    };
    PIVAS.Grid.Init('gridGenerally', dataGridOption);
}

///查询
function Query() {
    var $grid = $('#gridGenerally');
    var pJson = GetParams();
    PIVAS.Grid.PageHandler($grid);
    var rowsData = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Generally',
            QueryName: 'PogData',
            pJsonStr: JSON.stringify(pJson),
            rows: 99999,
            page: 1
        },
        false
    );
    $grid.datagrid('loading');
    setTimeout(function () {
        $grid.datagrid('loadData', rowsData);
    }, 100);
}

///获取入参
function GetParams() {
    var pJson = {};
    pJson.loc = $('#cmbPivaLoc').combobox('getValue') || ''; // 配液中心
    pJson.ordStartDate = $('#dateOrdStart').datebox('getValue'); // 起始日期
    pJson.ordEndDate = $('#dateOrdEnd').datebox('getValue'); // 截止日期
    pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || ''; // 科室组
    pJson.wardStr = $('#cmbWard').combobox('getValue') || ''; // 病区
    pJson.priority = $('#cmbPriority').combobox('getValue') || ''; // 医嘱优先级
    pJson.passResult = $('#cmbPassResult').combobox('getValue') || ''; // 医嘱审核状态
    pJson.psNumber = $('#cmbPivaStat').combobox('getValue') || ''; // 配液状态
    pJson.oeoreStat = $('#cmbOeoreStat').combobox('getValue') || ''; // 医嘱状态
    pJson.patNo = $.trim($('#txtPatNo').val()); // 登记号
    pJson.pogsNo = $('#txtPrtNo').searchbox('getValue'); // 打签单号
    var pNoArr = $('#txtPrtPNo').val().split('-');
    pJson.pNoStart = pNoArr[0] || ''; //$('#txtPrtPNoStart').val().trim(); // 打签序号
    pJson.pNoEnd = pNoArr[1] || ''; // $('#txtPrtPNoEnd').val().trim(); // 打签序号
    var batNoArr = [];
    $('input[type=checkbox][name=batbox]').each(function () {
        if ($('#' + this.id).is(':checked')) {
            batNoArr.push($('#' + this.id).attr('text'));
        }
    });
    pJson.batNoStr = batNoArr.join(',');

    pJson.prtStoped = $('#cmbPrintStop').combobox('getValue') || ''; // 是否已打印停止标签
    pJson.barCode = $.trim($('#txtBarCode').val()); // 条码号
    pJson.instruc = $('#cmbInstruc').combobox('getValue') || ''; // 用法
    pJson.freq = $('#cmbFreq').combobox('getValue') || ''; // 频次
    pJson.prtStartDate = $('#datePrtStart').datebox('getValue'); // 打签起始日期
    pJson.prtEndDate = $('#datePrtEnd').datebox('getValue'); // 打签截止日期
    pJson.inci = $('#cmgIncItm').combobox('getValue') || ''; // 药品
    pJson.pivaCat = ''; //$("#cmbPivaCat").combobox("getValue");   // 配液分类-yunhaibao20180328暂不用
    pJson.prtStartTime = $('#timePrtStart').timespinner('getValue'); // 打签开始时间
    pJson.prtEndTime = $('#timePrtEnd').timespinner('getValue'); // 打签结束时间
    pJson.refuseFlag = $('#cmbPivaRefuse').combobox('getValue') || ''; // 配液拒绝
    pJson.ordStartTime = $('#timeOrdStart').timespinner('getValue'); // 用药开始时间
    pJson.ordEndTime = $('#timeOrdEnd').timespinner('getValue'); // 用药结束时间
    pJson.workType = $('#cmbWorkType').combobox('getValue') || ''; // 工作组
    pJson.packFlag = $('#cmbPack').combobox('getValue') || ''; // 打包类型
    return pJson;
}

// 打印标签
function PrintLabel() {
    var gridChecked = $('#gridGenerally').datagrid('getChecked');
    if (gridChecked == '') {
        $.messager.popover({
            msg: '请先选择记录',
            type: 'alert'
        });
        return;
    }
    var pogArr = GetCheckedPogArr(1);
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        $.messager.popover({
            msg: '温馨提示 : 已停止的执行记录无法重打标签',
            type: 'alert'
        });
        return;
    }
    PIVASPRINT.LabelsJsonByPogStr({
        pogStr: pogArr.join('^')
    });
}
// 打印停止签
function PrintStopLabel() {
    $.messager.confirm('选择提示', '您确认打印停止签吗?', function (r) {
        if (r) {
            var pogArr = GetCheckedPogArr(2);
            var pogLen = pogArr.length;
            if (pogLen == 0) {
                return;
            }
            // 插入停止签记录表
            var pCPRet = tkMakeServerCall('web.DHCSTPIVAS.StopPrint', 'SaveCPrint', pogArr.join('^'), SessionUser);
            var pCPRetArr = pCPRet.split('^');
            var pCPId = pCPRetArr[0];
            if (pCPId < 0) {
                $.messager.alert('提示', pCPRetArr[1], 'warning');
                return;
            }
            PIVASPRINT.LabelsJsonByPogStr({
                pogStr: pogArr.join('^')
            });
            var count = 0;
            var printNum = PIVASPRINT.PrintNum;
            for (var pogI = 0; pogI < pogLen; pogI++) {
                var pogId = pogArr[pogI];
                var pogRowIndex =
                    $("td[field='pog']")
                        .children()
                        .filter(':contains(' + pogId + ')')
                        .closest('tr')
                        .attr('datagrid-row-index') || '';
                if (pogRowIndex != '') {
                    var updData = $.cm(
                        {
                            ClassName: 'web.DHCSTPIVAS.StopPrint',
                            MethodName: 'GetCPrtJsonByPog',
                            PogId: pogId
                        },
                        false
                    );
                    $('#gridGenerally')
                        .datagrid('updateRow', {
                            index: pogRowIndex,
                            row: updData
                        })
                        .datagrid('checkRow', pogRowIndex);
                }
            }
        }
    });
}

// 获取选中记录的pog
// pFlag:1-获取所有,2-获取停止
function GetCheckedPogArr(pFlag) {
    var pogArr = [];
    var gridChecked = $('#gridGenerally').datagrid('getChecked');

    if (gridChecked == '') {
        $.messager.alert('提示', '请先选择记录', 'warning');
        return pogArr;
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var pog = gridChecked[cI].pog;
        if (pog == '') {
            continue;
        }
        var oeoreStatDesc = gridChecked[cI].oeoreStatDesc;
        var oeoreStatIndex = oeoreStatDesc.indexOf('停止');
        var passResult = gridChecked[cI].passResultDesc;
        var passResultIndex = passResult.indexOf('打包');
        if (pFlag == 2) {
            // 获取停止的
            if (oeoreStatIndex < 0) {
                continue;
            }
            if (passResultIndex < 0) {
                //continue;
            }
        } else if (pFlag == 1) {
            // 获取正常的
            if (oeoreStatIndex >= 0) {
                continue;
            }
        }
        if (pogArr.indexOf(pog) < 0) {
            pogArr.push(pog);
        }
    }
    return pogArr;
}
// 置可退或不可退药
function SaveRetFlag(Flag) {
    var msgArr = [];
    msgArr.push('<div>' + $g('您确认置为' + (Flag == 'Y' ? '可退药' : '不可退药') + '吗?') + '</div>');
    msgArr.push('<div style="color:#8c8c8c">');
    msgArr.push('<div style="padding-top:15px">' + $g('帮助信息') + '</div>');
    var packReqNeedAudit = tkMakeServerCall('web.DHCSTPIVAS.Settings', 'GetAppParamProp', '', SessionLoc, '', 'PackReqAudit');
    if (packReqNeedAudit !== 'Y') {
        msgArr.push('<div style="padding-top:10px">1. ' + $g('您无法处理已「退药申请」的记录') + '</div>');
        msgArr.push('<div style="padding-top:10px">2. ' + $g('您不需要处理「打包」的记录') + '</div>');
    } else {
        msgArr.push('<div style="padding-top:10px">' + $g('您无法处理已「退药申请」的记录') + '</div>');
    }
    msgArr.push('</div">');
    $.messager.confirm('提示', msgArr.join(''), function (r) {
        if (r) {
            var pogIdArr = GetCheckedPogArr('');
            var pogIdStr = pogIdArr.join('^');
            if (pogIdStr == '') {
                return;
            }
            var saveRet = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'SaveRetFlag', pogIdStr, Flag, SessionUser, SessionInfo);
            var saveArr = saveRet.split('^');
            if (saveArr[0] < 0) {
                $.messager.alert('提示', $got(saveArr[1]), 'warning');
            } else {
                if (saveArr[1] || '' !== '') {
                    $.messager.alert('提示', $got(saveArr[1]), 'info');
                } else {
                    $.messager.popover({
                        msg: '成功',
                        type: 'success'
                    });
                    Query();
                }
            }
        }
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
            appCode: 'Generally',
            morePropStr: 'ReqNeedAudit'
        },
        function (jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
            var packReqNeedAudit = tkMakeServerCall('web.DHCSTPIVAS.Settings', 'GetAppParamProp', '', SessionLoc, '', 'PackReqAudit');
            if (jsonData.ReqNeedAudit == 'Y' || packReqNeedAudit == 'Y') {
                $('#tdReqNeedAudit').css('display', 'inline-block');
            }
            PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
        }
    );
}

function PrintTable() {
    var title = session['LOGON.CTLOCDESC'] + '配液综合查询打印清单';
    var prtArr = $('#gridGenerally').datagrid('getChecked');
    if (prtArr.length === 0) {
        $.messager.popover({
            msg: '请勾选需要打印的记录',
            type: 'alert'
        });
        return;
    }
    var WBLODOP = getLodop();
    WBLODOP.PRINT_INIT('配液综合查询打印清单');

    var htmlArr = [];
    htmlArr.push('<style>');
    htmlArr.push('div{font-size:14px;white-space: nowrap;}');
    htmlArr.push('</style>');

    htmlArr.push('<table  border=0 style="width:190mm;border-collapse:collapse;table-layout:fixed;">');
    htmlArr.push('<tr style="visibility:hidden;">');
    htmlArr.push(' <td style="width:190mm;height:0px;"></td>');
    htmlArr.push('</tr">');
    htmlArr.push('<tr>');
    htmlArr.push('    <td style="font-weight:bold;width:190mm;border:0">');
    htmlArr.push('        <div style="height:20px;line-height: 20px;;text-align:center;padding-top:5mm;">');
    htmlArr.push('            <span style="font-size:16px">' + title + ' </span>');
    htmlArr.push('        </div>');
    htmlArr.push('        <div>');
    htmlArr.push('         <div style="padding:2mm;float:left;">');
    htmlArr.push('            <span>用药日期：' + $('#dateOrdStart').datebox('getValue') + ' 至 ' + $('#dateOrdEnd').datebox('getValue') + ' </span>');
    htmlArr.push('         </div>');
    htmlArr.push('         <div style="float:right;;padding:2mm;">');
    htmlArr.push('            <span>打印时间：' + PIVAS.GetDate() + ' </span>' + '<span>　打印人：' + PIVAS.GetTime() + ' </span>');
    htmlArr.push('         </div>');
    htmlArr.push('        </div>');
    htmlArr.push('    </td>');
    htmlArr.push('</tr>');
    for (var i = 0, len = prtArr.length; i < len; i++) {
        var rowData = prtArr[i];
        var doseDateTime = rowData.doseDateTime;
        var pNo = rowData.pNo.trim();
        var wardDesc = rowData.wardDesc;
        var bedNoName = rowData.bedNo + '　' + rowData.patName + '　' + rowData.patNo;
        var batNo = rowData.batNo;
        var freqDesc = rowData.freqDesc;
        var mBarCode = rowData.barCode;
        var batNo = rowData.batNo;
        if (batNo.indexOf('批') < 0) {
            batNo += '批';
        }
        if (rowData.packFlag === 'P') {
            batNo += '　打包';
        }
        htmlArr.push('<tr>');
        htmlArr.push('    <td style="font-weight:bold;width:190mm;border:0;border-top:1px solid #000;">');
        htmlArr.push('        <div style="height:20px;line-height: 20px;padding-top:2mm;">');
        htmlArr.push('             <div style="float:left;width:10mm;font-weight:bold;">' + pNo + '</div>');
        htmlArr.push('             <div style="float:left;width:40mm;">' + wardDesc + '</div>');
        htmlArr.push('             <div style="float:left;"> ' + bedNoName + '</div>');
        htmlArr.push('             <div style="float:right;;padding-right:5mm;;"> ' + mBarCode + '</div>');
        htmlArr.push('             <div style="float:right;padding-right:5mm;">' + batNo + '</div>');
        htmlArr.push('             <div style="float:right;padding-right:5mm;"> ' + doseDateTime + '　' + freqDesc + '</div>');
        htmlArr.push('        </div>');
        htmlArr.push('    </td>');
        htmlArr.push('</tr>');
        var drugsArr = JSON.parse(rowData.drugsArr);
        for (var j = 0, jLen = drugsArr.length; j < jLen; j++) {
            var drugRow = drugsArr[j];
            var borderLine = j === 0 ? 'border-top:1px dashed #000;' : '';
            htmlArr.push('<tr>');
            htmlArr.push('    <td style=";width:190mm;border:0;">');
            htmlArr.push('        <div style="height:20px;line-height: 20px;padding-top:2mm;margin-left:10mm;' + borderLine + ';">');
            htmlArr.push('             <div style="float:left;width:100mm;">' + drugRow.inciDesc + '</div>');
            htmlArr.push('             <div style="float:left;width:50mm;">' + drugRow.dosage + '</div>');
            htmlArr.push('             <div style="float:left;width:30mm;">' + drugRow.qtyUom + '</div>');
            htmlArr.push('        </div>');
            htmlArr.push('    </td>');
            htmlArr.push('</tr>');
        }
    }
    htmlArr.push('<tr>');
    htmlArr.push('    <td style="border-top:1px solid #000;">');
    htmlArr.push('    </td>');
    htmlArr.push('</tr>');

    htmlArr.push('</table>');
    var htmlStr = htmlArr.join('');

    WBLODOP.ADD_PRINT_TABLE('2mm', '2mm', '100%', '100%', htmlStr);
    WBLODOP.SET_PRINT_PAGESIZE(3, '200mm', '10mm', '');
    //WBLODOP.PREVIEW();
    WBLODOP.PRINT();
    if (typeof App_MenuCsp !== 'undefined') {
        PHA_LOG.Operate({
            operate: 'P',
            logInput: JSON.stringify({ title: title }),
            // logInput: logParams,
            type: 'page',
            pointer: App_MenuCsp,
            origData: '',
            remarks: App_MenuName
        });
    }
}