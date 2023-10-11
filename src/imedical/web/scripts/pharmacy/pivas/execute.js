/**
 * 模块: 	 配液状态执行
 * 编写日期: 2018-03-16
 * 编写人:   yunhaibao
 */
var PIVAS_EXECUTE_NS = function () {
    var SessionLoc = session['LOGON.CTLOCID'];
    var SessionUser = session['LOGON.USERID'];
    var SessionWard = session['LOGON.WARDID'] || '';
    var DispPsArr = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetDispPsStr', SessionLoc, 'I').split('^');
    var PrtWardBatPS = ''; // 打印交接单流程标识
    var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardDesc]';
    var SameRowsHanlder = PIVAS.Grid.SameRows('gridOrdExe', PersonSameFields);
    if (SessionWard != '') {
        PIVAStateNumber = '90';
        $('#btnExecutePrt,#btnRefuse').hide();
    }
    PIVAS.Grid.Pagination();

    InitDict();
    InitGridOrdExe();
    $('#btnFind').on('click', Query);
    $('#btnRefresh').on('click', QueryOrdExe);
    $('#btnExecute').on('click', function () {
        SaveHandler(ExecuteHandler);
    });
    $('#btnExecutePrt').on('click', function () {
        SaveHandler(ExecutePrtHandler);
    });
    $('#btnPrtSelectDivOk').on('click', PrintHandler);
    $('#btnRefuse').on('click', RefusePog);

    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = this.value;
            patNo = PIVAS.FmtPatNo(patNo);
            $(this).val(patNo);
            Query();
        }
    });

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
    $('#btnSelectAll').on('click', function () {
        PIVAS.CheckAll($('#gridOrdExe'));
    });
    $('#btnUnSelectAll').on('click', function () {
        PIVAS.UnCheckAll($('#gridOrdExe'));
    });
    InitPivasSettings();
    PIVAS.Session.More(session['LOGON.CTLOCID']);

    $('.dhcpha-win-mask').remove();

    // ======================================================== //

    function InitDict() {
        var locNotify = PIVAS.Notify();
        // 配液中心
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPivaLoc',
                Type: 'PivaLoc'
            },
            {
                editable: false,
                onLoadSuccess: function () {
                    var datas = $('#cmbPivaLoc').combobox('getData');
                    if (datas.length == 1) {
                        $('#cmbPivaLoc').combobox('select', datas[0].RowId);
                    } else {
                        for (var i = 0; i < datas.length; i++) {
                            if (datas[i].RowId == SessionLoc) {
                                $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                                break;
                            }
                        }
                    }
                },
                onSelect: function (data) {
                    locNotify.trigger();
                }
            }
        );
        // 配液大类
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPivaCat',
                Type: 'PivaCat'
            },
            {}
        );
        // 科室组
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbLocGrp',
                Type: 'LocGrp'
            },
            {}
        );
        // 病区
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbWard',
                Type: 'Ward'
            },
            {
                readonly: SessionWard != '' ? true : false,
                onLoadSuccess: function () {
                    if (SessionWard != '') {
                        $('#cmbWard').combobox('setValue', SessionWard);
                    }
                }
            }
        );
        // 医嘱优先级
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPriority',
                Type: 'Priority'
            },
            {}
        );
        // 工作组
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbWorkType',
                Type: 'PIVAWorkType'
            },
            {
                onBeforeLoad: function (param) {
                    param.inputStr = $('#cmbPivaLoc').combobox('getValue');
                    param.filterText = param.q;
                }
            }
        );
        locNotify.listen(function () {
            $('#cmbWorkType').combobox('reload');
        });

        // 药品
        PIVAS.ComboGrid.Init(
            {
                Id: 'cmgIncItm',
                Type: 'IncItm'
            },
            {}
        );
        // 打包
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPack',
                Type: 'PackType'
            },
            {}
        );

        // 配液状态
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbPivaStat',
                Type: 'PIVAState'
            },
            {
                editable: false,
                readonly: PIVAStateNumber != '' ? true : false,
                onLoadSuccess: function () {
                    if (PIVAStateNumber != '') {
                        var datas = $(this).combobox('getData');
                        for (var i = 0; i < datas.length; i++) {
                            if (datas[i].RowId == PIVAStateNumber) {
                                $(this).combobox('setValue', datas[i].RowId);
                                break;
                            }
                        }
                    } else {
                        $(this).combobox('showPanel');
                    }
                },
                onSelect: function (data) {
                    ChangeDOMByPS();
                    Query();
                },
                onBeforeLoad: function (param) {
                    var noPs = '3,10';
                    if (SessionWard == '') {
                        noPs += ',90';
                    }
                    param.inputStr = $('#cmbPivaLoc').combobox('getValue') + '^' + noPs + '^' + 'execute';
                    param.filterText = param.q;
                }
            }
        );
        locNotify.listen(function () {
            $('#cmbPivaStat').combobox('reload');
        });
        locNotify.listen(function () {
            var locId = $('#cmbPivaLoc').combobox('getValue');
            // $('#DivBatNo').html('　　' + $g('批次'));
            PIVAS.BatchNoCheckList({
                Id: 'DivBatNo',
                LocId: locId,
                Check: true,
                Pack: false
            });
            InitGridWardBat(locId);
        });
    }

    //初始化明细列表
    function InitGridOrdExe() {
        var columns = [
            [
                {
                    field: 'ordExeSelect',
                    checkbox: true
                },
                {
                    field: 'warnInfo', // todo 修改显示方式换行
                    title: '提醒',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'wardDesc',
                    title: '病区',
                    width: 150,
                    hidden: false
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
                    width: 100
                },
                {
                    field: 'doseDateTime',
                    title: '用药日期',
                    width: 100
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
                    field: 'ordRemark',
                    title: '备注',
                    width: 75,
                    formatter: PIVAS.Grid.Formatter.OrdRemarkGroup
                },
                {
                    field: 'freqDesc',
                    title: '频次',
                    width: 75
                },
                {
                    field: 'instrucDesc',
                    title: '用法',
                    width: 80
                },

                {
                    field: 'priDesc',
                    title: '优先级',
                    width: 75
                },
                {
                    field: 'workTypeDesc',
                    title: '工作组',
                    width: 75
                },
                {
                    field: 'pivaCatDesc',
                    title: '配液大类',
                    width: 100
                },

                {
                    field: 'packFlag',
                    title: '打包',
                    width: 85,
                    hidden: true
                },

                {
                    field: 'barCode',
                    title: '条码',
                    width: 125
                },
                {
                    field: 'psDesc',
                    title: '当前状态',
                    width: 75
                },
                {
                    field: 'passResultDesc',
                    title: '审核结果',
                    width: 85
                },
                {
                    field: 'mDsp',
                    title: 'mDsp',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'pog',
                    title: 'pog',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'check',
                    title: 'check',
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
            url: '',
            fit: true,
            toolbar: '#gridOrdExeBar',
            rownumbers: false,
            columns: columns,
            pageSize: 300,
            pageList: [300, 500, 1000],
            pagination: true,
            singleSelect: false,
            selectOnCheck: false,
            checkOnSelect: false,
            pageNumber: 1,
            nowrap: false,
            rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
            onLoadSuccess: function (data) {
                var $grid = $(this);
                $grid.datagrid('options').checking = true;
                var row0Data = data.rows[0];
                if (row0Data) {
                    $grid.datagrid('checkAll');
                    var rows = $grid.datagrid('getRows');
                    var rowsLen = rows.length;
                    for (var index = rowsLen - 1; index >= 0; index--) {
                        var rowData = rows[index];
                        var check = rowData.check;
                        if (check != 'Y') {
                            $grid.datagrid('uncheckRow', index);
                        }
                    }
                } else {
                    $grid.datagrid('uncheckAll');
                }
                $grid.datagrid('scrollTo', 0);
                $grid.datagrid('options').checking = '';
                SameRowsHanlder.Hide();
                $grid.datagrid('loaded');
            },
            onClickRow: function (rowIndex, rowData) {
                SameRowsHanlder.ShowRow(rowIndex);
            },
            onBeforeSelect: function (rowIndex, rowData) {
                $(this).datagrid('unselectAll');
            },
            onCheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                SameRowsHanlder.UpdateRow(rowIndex, { check: 'Y' });
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                SameRowsHanlder.UpdateRow(rowIndex, { check: 'N' });
            },
            onCheckAll: PIVAS.Grid.onCheckAll,
            onUncheckAll: PIVAS.Grid.onUncheckAll,
            loadFilter: PIVAS.Grid.LoadFilter
        };
        PIVAS.Grid.Init('gridOrdExe', dataGridOption);
    }

    /// 初始化病区批次汇总
    function InitGridWardBat(locId) {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                MethodName: 'GetWardBatColumns',
                loc: locId
            },
            function (retJson) {
                var columnsArr = [
                    {
                        field: 'wardSelect',
                        checkbox: true
                    }
                ];
                for (var i = 0; i < retJson.length; i++) {
                    var retJsonI = retJson[i];
                    if (retJsonI.field.indexOf('batNo') >= 0) {
                        retJsonI.styler = function (value, row, index) {
                            if (parseInt(value) > 0) {
                                return 'font-weight:bold;';
                            }
                        };
                    }
                    columnsArr.push(retJsonI);
                }
                var columns = [columnsArr];
                var dataGridOption = {
                    url: '',
                    border: false,
                    fit: true,
                    toolbar: [],
                    rownumbers: false,
                    columns: columns,
                    pagination: false,
                    singleSelect: false,
                    showFooter: true,
                    queryOnSelect: false,
                    onSelect: SelectQuery,
                    onUnselect: SelectQuery,
                    onClickCell: function (rowIndex, field, value) {
                        if (field !== 'wardSelect') {
                            $(this).datagrid('options').queryOnSelect = true;
                        }
                    },
                    onLoadSuccess: function (data) {
                        $(this).datagrid('loaded');
                        $(this).datagrid('uncheckAll');
                        $('#gridOrdExe').datagrid('clear');
                    }
                };
                PIVAS.Grid.Init('gridWardBat', dataGridOption);
                function SelectQuery(rowIndex, rowData) {
                    var $grid = $('#gridWardBat');
                    if ($grid.datagrid('options').queryOnSelect == true) {
                        $grid.datagrid('options').queryOnSelect = false;
                        QueryOrdExe();
                    }
                }
            }
        );
    }

    function Query() {
        var $grid = $('#gridWardBat');
        $grid.datagrid('clear');

        var pJson = Get.QueryParams();
        if (pJson.psNumber === '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请先选择预执行的配液状态'),
                type: 'alert'
            });
            return;
        }
        PIVAS.Grid.PageHandler($grid);
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                MethodName: 'GetWardData',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1
            },
            false
        );
        $grid.datagrid('loading');
        setTimeout(function () {
            $grid.datagrid('loadData', rowsData);
        }, 100);
    }
    // 查询医嘱明细
    function QueryOrdExe() {
        var $grid = $('#gridOrdExe');
        $grid.datagrid('clear');

        var pJson = Get.QueryParams();
        var wardArr = Get.WardChecked();
        if (wardArr.length === 0) {
            return;
        }
        pJson.wardStr = wardArr.join(',');

        PIVAS.Grid.PageHandler($grid);
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                QueryName: 'OrdExeData',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1
            },
            false
        );
        $grid.datagrid('loading');
        setTimeout(function () {
            $grid.datagrid('loadData', rowsData);
        }, 100);
    }

    var Get = {
        QueryParams: function () {
            var pJson = {};
            pJson.loc = $('#cmbPivaLoc').combobox('getValue') || '';
            pJson.wardStr = $('#cmbWard').combobox('getValue') || '';
            pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || '';
            pJson.prtStartDate = $('#datePrtStart').datebox('getValue');
            pJson.prtEndDate = $('#datePrtEnd').datebox('getValue');
            pJson.ordStartDate = $('#dateOrdStart').datebox('getValue');
            pJson.ordEndDate = $('#dateOrdEnd').datebox('getValue');
            pJson.psNumber = $('#cmbPivaStat').combobox('getValue');
            pJson.pivaCat = $('#cmbPivaCat').combobox('getValue') || '';
            pJson.workType = $('#cmbWorkType').combobox('getValue') || '';
            pJson.priority = $('#cmbPriority').combobox('getValue') || '';
            pJson.inci = $('#cmgIncItm').combobox('getValue') || '';
            pJson.packFlag = $('#cmbPack').combobox('getValues').join(',');
            pJson.patNo = $('#txtPatNo').val().trim();
            pJson.batNoStr = this.BatNoChecked().join(',');
            pJson.pogsNo = $('#txtPrtNo').searchbox('getValue');
            return pJson;
        },
        WardChecked: function () {
            var retArr = [];
            var gridChecked = $('#gridWardBat').datagrid('getChecked');
            for (var i = 0; i < gridChecked.length; i++) {
                retArr.push(gridChecked[i].ward);
            }
            return retArr;
        },
        BatNoChecked: function () {
            var batNoArr = [];
            $('input[type=checkbox][name=batbox]').each(function () {
                if ($('#' + this.id).is(':checked')) {
                    batNoArr.push($('#' + this.id).attr('text'));
                }
            });
            return batNoArr;
        },
        PogChecked: function () {
            var retArr = [];
            var origRows = $('#gridOrdExe').datagrid('getData').originalRows;
            if (typeof origRows === 'undefined') {
                return retArr;
            }
            var len = origRows.length;
            for (var i = 0; i < len; i++) {
                var rowData = origRows[i];
                if (rowData.check === 'Y') {
                    retArr.push(origRows[i].pog);
                }
            }
            return retArr;
        }
    };

    function Execute(grpWay, printFlag) {
        grpWay = grpWay || '';
        printFlag = printFlag || '';
        var pogArr = Get.PogChecked();
        var psNumber = $('#cmbPivaStat').combobox('getValue');
        PIVAS.Progress.Show({
            type: 'save',
            interval: 1000
        });
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                MethodName: 'SaveData',
                pogJsonStr: JSON.stringify(pogArr),
                user: SessionUser,
                psNumber: psNumber,
                grpWay: grpWay,
                dataType: 'text'
            },
            function (retData) {
                PIVAS.Progress.Close();
                if (retData.indexOf('msg') >= 0) {
                    $.messager.alert($g('提示'), JSON.parse(retData).msg, 'error');
                    return;
                }
                var retArr = retData.split('^');
                if (retArr[0] == -1) {
                    $.messager.alert($g('提示'), retArr[1], 'warning');
                } else if (retArr[0] < -1) {
                    $.messager.alert($g('提示'), retArr[1], 'error');
                } else {
                    if (printFlag !== '') {
                        var pogsNoStr = retArr[1];
                        PrintWardBat(pogsNoStr, printFlag);
                    }
                }
                QueryOrdExe();
            }
        );
    }

    function RefusePog() {
        var pogArr = Get.PogChecked();
        if (pogArr.length == 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请勾选需要配液拒绝的记录'),
                type: 'alert'
            });
            return;
        }
        $.messager.confirm($g('提示'), $g('您确认配液拒绝吗?'), function (r) {
            if (r) {
                PIVAS.RefuseReasonWindow(
                    {
                        pogArr: pogArr,
                        user: SessionUser
                    },
                    QueryOrdExe
                );
            }
        });
    }

    // 根据单号执行并打印交接单
    function ExePrtWardBat(grpWay) {
        var geneNo = $('#txtGeneNo').val();
        if (geneNo == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('未查询到扫描记录,无法打印'),
                type: 'alert'
            });
            return;
        }
        PIVAS.Progress.Show({
            type: 'save',
            interval: 1000
        });
        $.m(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                MethodName: 'SaveDataByPOGSNo',
                pogsNo: geneNo,
                userId: SessionUser,
                psNumber: PrtWardBatPS
            },
            function (retData) {
                PIVAS.Progress.Close();
                if (retData.indexOf('msg') >= 0) {
                    $.messager.alert($g('提示'), JSON.parse(retData).msg, 'error');
                    return;
                }
                var retArr = retData.split('^');
                if (retArr[0] == -1) {
                    $.messager.alert($g('提示'), retArr[1], 'warning');
                } else if (retArr[0] < -1) {
                    $.messager.alert($g('提示'), retArr[1], 'error');
                } else {
                    PrintWardBat(retArr[1]);
                }
            }
        );
    }

    // 初始化默认条件
    function InitPivasSettings() {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Settings',
                MethodName: 'GetAppProp',
                userId: session['LOGON.USERID'],
                locId: session['LOGON.CTLOCID'],
                appCode: 'Execute'
            },
            function (jsonData) {
                $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
                $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
                $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
                $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
                //$('[name=genePOGSNo][value=' + jsonData.GeneWay + ']').radio('setValue', true);
                $('[name=prtPOGSWay][value=' + jsonData.PrtWay + ']').radio('setValue', true);
                PrtWardBatPS = 85;
                PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
            }
        );
    }

    function ChangeDOMByPS() {
        var psNumber = $('#cmbPivaStat').combobox('getValue') || '';
        var psName = $('#cmbPivaStat').combobox('getText') || '';
        if (PrtWardBatPS != '' && PrtWardBatPS == psNumber) {
            $('#btnExecutePrt').show();
            $('#btnExecute').hide();
        } else {
            $('#btnExecutePrt').hide();
            $('#btnExecute').show();
        }
        $('#btnExecute .l-btn-text').text($g('执行') + psName);
        $('#btnExecute').linkbutton('options').text = $g('执行') + psName;
    }
    function SaveHandler(callFunc) {
        if (Get.PogChecked().length === 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请先勾选预执行的记录'),
                type: 'alert'
            });
            return;
        }
        var psNumber = $('#cmbPivaStat').combobox('getValue');
        if (psNumber == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请选择执行状态'),
                type: 'alert'
            });
            return;
        }
        if (DispPsArr.indexOf(psNumber) >= 0) {
            PIVAS.CACert('PHAPIVASExecute', callFunc);
        } else {
            callFunc();
        }
    }
    function PrintHandler() {
        var geneWay = 1; //$("input[name='genePOGSNo']:checked").val() || '';
        var prtWay = $("input[name='prtPOGSWay']:checked").val() || '';
        if (geneWay === '' || prtWay === '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请先选择对应方式'),
                type: 'alert'
            });
            return;
        }
        Execute(geneWay, prtWay);
    }
    function ExecuteHandler() {
        $.messager.confirm($g('提示'), $g('您确认' + $('#btnExecute').linkbutton('options').text + '吗?'), function (r) {
            if (r) {
                Execute(1, '');
            }
        });
    }
    function ExecutePrtHandler() {
        $('#prtSelectDiv').window('open');
    }
    function PrintWardBat(pogsNoStr, prtWay) {
        var printType = '';
        if (prtWay == 1) {
            printType = 'Inci';
        } else if (prtWay == 0) {
            printType = 'Total';
        }
        PIVASPRINT.WardBat.Handler({
            pogsNoArr: pogsNoStr.split('!!'),
            loc: $('#cmbPivaLoc').combobox('getValue'),
            rePrint: '',
            printType: printType
        });
        $('#prtSelectDiv').window('close');
    }
};
$(PIVAS_EXECUTE_NS);
