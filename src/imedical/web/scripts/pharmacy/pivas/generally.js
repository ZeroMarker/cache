/**
 * 模块:     配液中心综合查询
 * 编写日期: 2018-03-28
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
var linkOrderCheck = '';
var GridCmbBatNo;
$(function() {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridGenerally();
    $('#btnFind').on('click', Query);
    $('#btnPrtLabel').on('click', PrintLabel);
    $('#btnRetYes').on('click', function() {
        SaveRetFlag('Y');
    });
    $('#btnRetNo').on('click', function() {
        SaveRetFlag('N');
    });
    $('#btnPrtStopLabel').on('click', PrintStopLabel);
    // 登记号回车事件
    $('#txtPatNo').on('keypress', function(event) {
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
    $('#txtBarCode').on('keypress', function(event) {
        if (window.event.keyCode == '13') {
            var barCode = $.trim($('#txtBarCode').val());
            if (barCode != '') {
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
    $('#txtPrtNo')
        .next()
        .find('input:first')
        .attr('placeholder', ' 流程单号...');
    InitPivasSettings();
    setTimeout(function() {
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
            placeholder: '配液中心...',
            editable: false,
            onLoadSuccess: function() {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('setValue', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function(data) {
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
            placeholder: '医嘱优先级...'
        }
    );
    // 病区
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWard',
            Type: 'Ward'
        },
        {
            placeholder: '病区...'
        }
    );
    // 科室组
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLocGrp',
            Type: 'LocGrp'
        },
        {
            placeholder: '科室组...'
        }
    );
    // 配伍审核
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPassResult',
            Type: 'PassResult'
        },
        {
            placeholder: '配伍审核...',
            editable: false
        }
    );
    // 执行记录状态
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbOeoreStat',
            Type: 'OrdStatus'
        },
        {
            placeholder: '执行记录状态...'
        }
    );
    // 用法
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbInstruc',
            Type: 'Instruc'
        },
        {
            placeholder: '用法...'
        }
    );
    // 频次
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbFreq',
            Type: 'Freq'
        },
        {
            placeholder: '频次...'
        }
    );
    // 配液状态
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaStat',
            Type: 'PIVAState'
        },
        {
            placeholder: '配液状态...'
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
                        Description: '已打印停止签'
                    },
                    {
                        RowId: 'N',
                        Description: '未打印停止签'
                    }
                ]
            }
        },
        {
            placeholder: '停止签打印...'
        }
    );
    // 药品
    PIVAS.ComboGrid.Init(
        {
            Id: 'cmgIncItm',
            Type: 'IncItm'
        },
        {
            placeholder: '药品...'
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
                        Description: '已配液拒绝'
                    },
                    {
                        RowId: 'N',
                        Description: '未配液拒绝'
                    }
                ]
            }
        },
        {
            placeholder: '配液拒绝...'
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
            placeholder: '工作组...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPack',
            Type: 'PackType'
        },
        {
            placeholder: '打包类型...'
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
                width: 75,
                styler: function(value, row, index) {
                    if (value.indexOf('停止') >= 0) {
                        return 'color:white;background-color:#ffba42;';
                    } else if (value.indexOf('配液拒绝') >= 0) {
                        return 'color:white;background-color:#F4868E;';
                    } else if (value.indexOf('审核拒绝') >= 0) {
                        return 'color:white;background-color:#C33A30;';
                    }
                    return '';
                }
            },
            {
                field: 'doseDateTime',
                title: '用药时间',
                width: 135
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
                field: 'batNo',
                title: '批次',
                width: 75,
                editor: GridCmbBatNo,
                styler: function(value, row, index) {
                    var colorStyle = 'text-decoration:underline;';
                    if (row.packFlag != '') {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                halign: 'left',
                align: 'center',
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: '药品名称',
                width: 250,
				styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'dosage',
                title: '剂量',
                width: 75
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
                field: 'oeoreStat',
                title: '医嘱状态',
                width: 70,
                hidden: true
            },
            {
                field: 'qty',
                title: '数量',
                width: 50,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 60
            },
            {
                field: 'xDateTime',
                title: '停止时间',
                width: 155
            },
            {
                field: 'pivaStat',
                title: '配液状态',
                width: 80,
                styler: PIVAS.Grid.Styler.PivaState
            },
            {
                field: 'passResult',
                title: '审核结果',
                width: 70
            },
            {
                field: 'incSpec',
                title: '规格',
                width: 70
            },
            {
                field: 'barCode',
                title: '条码',
                width: 125
            },
            {
                field: 'pNo',
                title: '打印序号',
                width: 70,
                hidden: true
            },
            {
                field: 'printUser',
                title: '打签人',
                width: 90
            },
            {
                field: 'printDateTime',
                title: '打签时间',
                width: 155
            },
            {
                field: 'refUser',
                title: '拒绝人',
                width: 90
            },
            {
                field: 'refDateTime',
                title: '拒绝时间',
                width: 155
            },
            {
                field: 'cPrtDateTime',
                title: '停止签打印时间',
                width: 155,
                formatter: function(value, row, index) {
                    if (value == 'U') {
                        var cPrtDt = tkMakeServerCall('web.DHCSTPIVAS.StopPrint', 'GetCPrtTimeByPog', row.pogId);
                        return cPrtDt;
                    } else {
                        return value;
                    }
                }
            },
            {
                field: 'pogId',
                title: 'pogId',
                width: 70,
                hidden: false
            },
            {
                field: 'colColor',
                title: 'colColor',
                width: 75,
                hidden: true
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
            }
        ]
    ];
    var dataGridOption = {
        exportXls: true,
        url: '',
        toolbar: '#gridGenerallyBar',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        onLoadSuccess: function() {
            PIVAS.Grid.CellTip({
                TipArr: ['ordRemark', 'incDesc', 'wardDesc']
            });
            $(this).datagrid('options').checking = '';
            // $(".datagrid-btable td[field=oeoriSign]>div").css(PIVAS.Grid.CSS.OeoriSign);
        },
        rowStyler: function(index, rowData) {
            return PIVAS.Grid.RowStyler.Person(index, rowData, 'patNo');
        },
        onClickRow: function(rowIndex, rowData) {},
        onClickCell: function(rowIndex, field, value) {
            if (field == 'oeoriSign') {
                var barCode = $(this).datagrid('getRows')[rowIndex].barCode;
                PIVASTIMELINE.Init({
                    Params: barCode,
                    Field: 'oeoriSign',
                    ClickField: field
                });
            }
            if (field == 'pivaStat') {
                PIVAS.OrdLinkWindow({
                    Params: $(this).datagrid('getRows')[rowIndex].pogId
                });
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
        onCheck: function(rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'barCode',
                Check: true,
                Value: rowData.barCode
            });
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function(rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'barCode',
                Check: false,
                Value: rowData.barCode
            });
            $(this).datagrid('options').checking = '';
        },
        onSelect: function(rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
            $(this).datagrid('options').checking = '';
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id)
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridGenerally', dataGridOption);
}

///查询
function Query() {
    var params = GetParams();
    $('#gridGenerally').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGenerallyQuery',
        queryParams: {
            params: params
        }
    });
}

///获取入参
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || ''; // 配液中心
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); // 起始日期
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); // 截止日期
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // 科室组
    var wardId = $('#cmbWard').combobox('getValue') || ''; // 病区
    var priority = $('#cmbPriority').combobox('getValue') || ''; // 医嘱优先级
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; // 医嘱审核状态
    var pivaStat = $('#cmbPivaStat').combobox('getValue') || ''; // 配液状态
    var oeoreStat = $('#cmbOeoreStat').combobox('getValue') || ''; // 医嘱状态
    var patNo = $.trim($('#txtPatNo').val()); // 登记号
    var prtNo = $('#txtPrtNo').searchbox('getValue'); // 打签单号
    var prtPNo = $('#txtPrtPNo')
        .val()
        .trim(); // 打签序号
    var batNoStr = ''; // 批号
    $('input[type=checkbox][name=batbox]').each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == '') {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + ',' + this.value;
            }
        }
    });
    var printStop = $('#cmbPrintStop').combobox('getValue') || ''; // 是否已打印停止标签
    var barCode = $.trim($('#txtBarCode').val()); // 条码号
    var instruc = $('#cmbInstruc').combobox('getValue') || ''; // 用法
    var freq = $('#cmbFreq').combobox('getValue') || ''; // 频次
    var datePrtStart = $('#datePrtStart').datebox('getValue'); // 打签起始日期
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); // 打签截止日期
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // 药品
    var pivaCat = ''; //$("#cmbPivaCat").combobox("getValue"); 	// 配液分类-yunhaibao20180328暂不用
    var timePrtStart = $('#timePrtStart').timespinner('getValue'); // 打签开始时间
    var timePrtEnd = $('#timePrtEnd').timespinner('getValue'); // 打签结束时间
    var pivaRefuse = $('#cmbPivaRefuse').combobox('getValue') || ''; // 配液拒绝
    var timeOrdStart = $('#timeOrdStart').timespinner('getValue'); // 用药开始时间
    var timeOrdEnd = $('#timeOrdEnd').timespinner('getValue'); // 用药结束时间
    var workTypeId = $('#cmbWorkType').combobox('getValue') || ''; // 工作组
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // 打包类型
    paramsArr[0] = pivaLocId;
    paramsArr[1] = dateOrdStart;
    paramsArr[2] = dateOrdEnd;
    paramsArr[3] = wardId;
    paramsArr[4] = locGrpId;
    paramsArr[5] = priority;
    paramsArr[6] = passResult;
    paramsArr[7] = pivaStat;
    paramsArr[8] = oeoreStat;
    paramsArr[9] = batNoStr;
    paramsArr[10] = printStop;
    paramsArr[11] = barCode;
    paramsArr[12] = instruc;
    paramsArr[13] = freq;
    paramsArr[14] = incId;
    paramsArr[15] = datePrtStart;
    paramsArr[16] = datePrtEnd;
    paramsArr[17] = pivaCat;
    paramsArr[18] = timePrtStart;
    paramsArr[19] = timePrtEnd;
    paramsArr[20] = prtNo;
    paramsArr[21] = pivaRefuse;
    paramsArr[22] = patNo;
    paramsArr[23] = prtPNo;
    paramsArr[24] = timeOrdStart;
    paramsArr[25] = timeOrdEnd;
    paramsArr[26] = workTypeId;
    paramsArr[27] = packFlag;
    return paramsArr.join('^');
}

// 打印标签
function PrintLabel() {
    var pogArr = GetCheckedPogArr(1);
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        $.messager.popover({
            msg: '温馨提示 : 已停止医嘱无法重打标签',
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
    $.messager.confirm('选择提示', '您确认打印停止签吗?', function(r) {
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
                    $("td[field='pogId']")
                        .children()
                        .filter(':contains(' + pogId + ')')
                        .closest('tr')
                        .attr('datagrid-row-index') || '';
                if (pogRowIndex != '') {
                    $('#gridGenerally')
                        .datagrid('updateRow', {
                            index: pogRowIndex,
                            row: {
                                cPrtDateTime: 'U'
                            }
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
        var pogId = gridChecked[cI].pogId;
        if (pogId == '') {
            continue;
        }
        var oeoreStat = gridChecked[cI].oeoreStat;
        var oeoreStatIndex = oeoreStat.indexOf('停止');
        var passResult = gridChecked[cI].passResult;
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
        if (pogArr.indexOf(pogId) < 0) {
            pogArr.push(pogId);
        }
    }
    return pogArr;
}
// 置可退或不可退药
function SaveRetFlag(Flag) {
    $.messager.confirm('提示', '您确认置为' + (Flag == 'Y' ? '可退药' : '不可退药') + '吗?', function(r) {
        if (r) {
            var pogIdArr = GetCheckedPogArr('');
            var pogIdStr = pogIdArr.join('^');
            if (pogIdStr == '') {
                return;
            }
            var saveRet = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'SaveRetFlag', pogIdStr, Flag, SessionUser);
            var saveArr = saveRet.split('^');
            if (saveArr[0] < 0) {
                $.messager.alert('提示', saveArr[1], 'warning');
            } else {
                $.messager.popover({
                    msg: '成功',
                    type: 'success'
                });
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
        function(jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
            if (jsonData.ReqNeedAudit == 'Y') {
                $('#tdReqNeedAudit').css('display', 'block');
            }
        }
    );
}
// 备份用,遮罩,IE不需要这种遮罩,暂不考虑,2019-04-11
function PrintLabelLodop() {
    PIVASLODOP = getLodop();
    var taskNum = 0;
    PIVASLODOP.On_Return = function(TaskID, Value) {
        var taskCnt = PIVASPRINT.TaskCnt;
        taskNum++;
        if (taskNum == 1) {
            //$.messager.progress("close");
            $.messager.progress({
                title: '发  送  打  印  任  务  中...',
                text: '<b>{value}%</b>',
                interval: 100000
            });
        }
        $('body>div.messager-window')
            .find('div.messager-p-msg')
            .text(taskNum + ' / ' + taskCnt);
        $.messager.progress('bar').progressbar('setValue', parseInt((taskNum / taskCnt) * 100));
        if (taskNum == taskCnt) {
            $.messager.progress('close');
        }
    };
    PIVASPRINT.LabelsJsonByPogsNo({
        pogsNo: 'S10P20190219001',
        sortWay: '15^1'
    });
}
