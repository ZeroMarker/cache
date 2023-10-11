/**
 * 模块:     退药申请
 * 编写日期: 2018-07-02
 * 编写人:   yunhaibao
 * 其他:     退药申请主表依然是按人保存
 *           2023-02-20, 患者列表调用护理的统一插件, 需查看HISV8.5.2护士站患者列表改造说明(护理病历除外)
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
var DefPhaLocInfo = tkMakeServerCall('web.DHCSTKUTIL', 'GetDefaultPhaLoc', SessionLoc);
var Loaded = ''; // 首次加载为空,控制默认药房
var DefPhaLocArr = DefPhaLocInfo.split('^');
var WinReason = '';
var AutoQueryTimes = 0;
DefPhaLocId = DefPhaLocArr[0] || '';
DefPhaLocDesc = DefPhaLocArr[1] || '';
var GridCmbRetReason;
$(function () {
    InitExtend();
    InitDict();
    InitGridDict();
    InitGridDisped();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patNo = $.trim($('#txtPatNo').val());
            if (patNo != '') {
                var newPatNo = DHCPHA_TOOLS.PadZero(patNo, PatNoLen);
                $(this).val(newPatNo);
                // 按登记号查询以登记号为准
                ClearPatientTree();
                // 修改病人姓名
                Query();
            }
        }
    });
    $('#btnDirReq').on('click', RequestQuery);
    $('#btnDefaultLoc').on('click', SetDefaultLoc);
    $('#btnFind').on('click', Query);
    $('#btnSave').on('click', SaveHandler);
    $('#btnSetReason').on('click', AddReasonForSelect);
    $('.dhcpha-win-mask').fadeOut();
});

function LoadPatInfo() {
    var patInfo = tkMakeServerCall('web.DHCINPHA.Request', 'PatInfo', LoadAdmId);
    $('#txtPatNo').val(patInfo.split('^')[0] || '');
    $('#txtPatName').val(patInfo.split('^')[1] || '');
}

function InitDict() {
    // 科室
    DHCPHA_HUI_COM.ComboBox.Init(
        {
            Id: 'cmbPhaLoc',
            Type: 'PhaLoc'
        },
        {
            defaultFilter: 4,
            mode: 'local',
            onLoadSuccess: function () {
                if (Loaded == '') {
                    $('#cmbPhaLoc').combobox('setValue', DefPhaLocId);
                    Loaded = 1;
                }
            },
            onSelect: function () {
                Query();
            }
        }
    );

    // 申请退药原因
    DHCPHA_HUI_COM.ComboBox.Init(
        {
            Id: 'cmbReason',
            Type: 'ReqRetReason'
        },
        {
            defaultFilter: 4,
            mode: 'local',
            width: 277,
            onLoadSuccess: function () {},
            onSelect: function () {
                //AddReasonForSelect();
            },
            onShowPanel: function () {
                $(this).combobox('clear');
            }
        }
    );
}

function InitGridDict() {
    var retReaData = $.cm(
        {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
            hospId: HospId,
            ResultSetType: 'array'
        },
        false
    );
    GridCmbRetReason = DHCPHA_HUI_COM.GridComboBox.Init(
        {
            data: {
                data: retReaData
            }
        },
        {
            editable: true,
            mode: 'local'
        }
    );
}

/**
 * 患者列表, 勾选或者取消勾选时
 */
function patientTreeCheckChangeHandle() {
    LoadAdmId = EpisodeIDStr;
    $('#txtPatNo').val('');
    $('#txtPatName').val('');
    Query();
}
function patientTreeLoadSuccessCallBack() {
    if (AutoQueryTimes > 1) {
        return;
    }
    AutoQueryTimes++;
    Query();
}
function ClearPatientTree() {
    if ($('#patientTree').tree('getSelected') !== null) {
        $('#patientTree').tree('select', $('#patientTree').tree('getSelected'));
        EpisodeIDStr = '';
    }
}
function GetPatientTreeSelectedAdm() {
    if ($('#patientTree').tree('getSelected') === null) {
        return '';
    }
    return EpisodeIDStr;
}
// 已发药信息
function InitGridDisped() {
    var columns = [
        [
            {
                field: 'gridRequestSelect',
                checkbox: true
            },
            {
                field: 'recLocId',
                title: '发药科室Id',
                width: 120,
                hidden: true
            },
            {
                field: 'recLocDesc',
                title: '发药科室',
                width: 120
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 35,
                align: 'center',
                formatter: DHCPHA_HUI_COM.Grid.Formatter.OeoriSign
            },
            {
                field: 'incCode',
                title: '药品代码',
                width: 100,
                hidden: true
            },
            {
                field: 'incDesc',
                title: '药品名称',
                width: 250
            },
            {
                field: 'canRetQty',
                title: '可退数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '<span style="color:red">*</span>' + $g('申请数量'), // 配液中心与草药不可编辑
                width: 80,
                align: 'right',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                        validType: 'CheckNumber'
                    }
                }
            },
            {
                field: 'reqReasonId',
                title: '申请退药原因',
                width: 160,
                editor: GridCmbRetReason,
                descField: 'reqReasonDesc',
                formatter: function (value, row, index) {
                    return row.reqReasonDesc;
                }
            },
            {
                field: 'reqReasonDesc',
                title: '退药原因描述',
                width: 160,
                hidden: true
            },
            {
                field: 'dspQty',
                title: '发药数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 60
            },
            {
                field: 'doseDateTime',
                title: '用药时间',
                width: 150,
                align: 'left'
            },
            {
                field: 'reqHistory',
                title: '历次记录',
                width: 120,
                align: 'left'
            },
            {
                field: 'docLocDesc',
                title: '开单科室',
                width: 140
            },
            {
                field: 'encryptLevel',
                title: '病人密级',
                width: 70,
                hidden: true
            },
            {
                field: 'patLevel',
                title: '病人级别',
                width: 70,
                hidden: true
            },
            {
                field: 'dspId',
                title: '打包表Id',
                width: 60,
                hidden: true
            },
            {
                field: 'wardLocId',
                title: '病区科室Id',
                width: 120,
                hidden: true
            },
            {
                field: 'phacLbRowId',
                title: '发药孙表Id',
                width: 60,
                hidden: true
            },
            {
                field: 'dspSubRowId',
                title: '打包子表Id',
                width: 60,
                hidden: true
            },
            {
                field: 'inclb',
                title: '科室批次库存项Id',
                width: 60,
                hidden: true
            },
            {
                field: 'cantretreason',
                title: '不可退药原因',
                width: 100,
                align: 'left'
            },
            {
                field: 'cyFlag',
                title: '草药处方标志',
                width: 60,
                hidden: true
            },
            {
                field: 'prescNo',
                title: '处方号',
                width: 125,
                hidden: false
            },
            {
                field: 'needGrpRet',
                title: '成组退药',
                width: 60,
                hidden: true
            },
            {
                field: 'canRetFlag',
                title: '是否可申请',
                width: 60,
                hidden: true
            }, // 草药与配液
            {
                field: 'mDspId',
                title: '主打包Id',
                width: 60,
                hidden: true
            },
            {
                field: 'firstRow',
                title: '第一条',
                width: 60,
                hidden: true
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
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        fit: true,
        border: false,
        singleSelect: true,
        checkOnSelect: false,
        selectOnCheck: false,
        columns: columns,
        pageSize: 1000,
        pageList: [1000],
        pagination: false,
        toolbar: '#gridDispedBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData.canRetFlag == 'N') {
                $(this).datagrid('cancelEdit', rowIndex);
                $(this).datagrid('options').editIndex = undefined;
                return;
            }
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'reqReasonId'
            });
            // 成组退,不能修改数量,第一条记录可选择原因
            if (rowData.needGrpRet == 'Y') {
                var $ed = $(this).datagrid('getEditor', {
                    index: rowIndex,
                    field: 'reqQty'
                });
                if ($ed.target) {
                    $ed.target.attr('disabled', true);
                }
                if (rowData.firstRow != 'Y') {
                    $(this).datagrid('cancelEdit', rowIndex);
                    $(this).datagrid('options').editIndex = undefined;
                }
            }
        },
        onSelect: function (rowIndex, rowData) {
            var $grid = $(this);
            if ($grid.datagrid('options').checking == true) {
                return;
            }
            $grid.datagrid('options').checking = true;
            $('#gridDisped').prev().find('.datagrid-row').removeClass('datagrid-row-selected');
            $grid.datagrid('selectRow', rowIndex);
            $grid.datagrid('options').checking = '';
        },
        onUnselect: function (rowIndex, rowData) {
            // 此处不要触发unselectAll,会出现无限递归
            $(this).datagrid('unselectAll');
        },
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridDisped',
                Field: 'mDspId',
                Check: true,
                Value: rowData.mDspId
            });
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridDisped',
                Field: 'mDspId',
                Check: false,
                Value: rowData.mDspId
            });
            $(this).datagrid('options').checking = '';
        },
        onLoadSuccess: function () {
            var $grid = $(this);
            $grid.datagrid('options').checking = '';
            $grid.datagrid('uncheckAll');
            $grid.datagrid('scrollTo', 0);
            UnBindChk();
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridDisped', dataGridOption);
}
function UnBindChk() {
    var hasDisable = false;
    var rows = $('#gridDisped').datagrid('getRows');
    $.each(rows, function (index, row) {
        var canRetFlag = row.canRetFlag;
        if (canRetFlag != 'Y') {
            //$(".datagrid-row[datagrid-row-index=" + index + "] .datagrid-cell-check")
            // 通过移除样式,使selectoncheck等事件不起作用
            var $row = $('#gridDisped')
                .prev()
                .find('.datagrid-row[datagrid-row-index=' + index + ']');
            $row.removeClass('datagrid-row-selected datagrid-row-checked');
            var $chk = $row.find("input:checkbox[name='gridRequestSelect']")[0];
            $chk.disabled = true;
            $chk.checked = false;
            hasDisable = true;
            //$chk.style = 'display:none';
        }
    });
    $('#gridDisped').datagrid('getPanel').find('.datagrid-header-row input:checkbox')[0].disabled = hasDisable;
}
// 查询
function Query() {
    var admId = EpisodeIDStr;
    var patNo = $('#txtPatNo').val();
    if (admId === '' && patNo === '') {
        $.messager.popover({
            msg: '请先选择患者列表或录入登记号再查询',
            type: 'info'
        });
        return;
    }
    var recLocId = $('#cmbPhaLoc').combobox('getValue');
    var params = patNo + '^' + admId + '^' + recLocId + '^' + SessionLoc;
    $('#gridDisped').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'QueryDisped',
            inputStr: params,
            rows: 99999
        }
    });
}

function RequestQuery() {
    var lnk = 'dhcpha.inpha.hisui.queryretrequest.csp?EpisodeID=' + LoadAdmId;
    var winRadio = 85;
    var winWidth = $('body').width() * 0.85;
    if (winWidth < 1280) {
        var winRadio = 100;
    }
    websys_createWindow(lnk, '退药申请查询', 'height=' + winRadio + '%,width=' + winRadio + '%,menubar=no,status=no,toolbar=no,resizable=yes');
}

//清屏
function ClearClick() {}

function SaveHandler() {
    WinReason = '';
    $('#gridDisped').datagrid('endEditing');
    if ($('#gridDisped').datagrid('options').editIndex >= 0) {
        $.messager.popover({
            msg: '请检查退药数量是否正确',
            type: 'alert'
        });
        return;
    }
    if (CheckNeedReason() === true) {
        ReqReasonWindow(Save);
    } else {
        Save();
    }
}
// 保存
function Save() {
    var paramsStr = GetSaveParams();
    if (paramsStr == '') {
        return;
    }
    var saveRet = tkMakeServerCall('web.DHCINPHA.Request', 'SaveMulti', paramsStr, SessionUser, SessionLoc);
    var saveRetArr = saveRet.split('^');
    if (saveRetArr[0] != '') {
        $.messager.alert('提示', saveRetArr[1], 'warning');
        return;
    } else {
        if (saveRetArr[1] != '') {
            $.messager.alert('提示', $g('生成成功') + '</br>' + saveRetArr[1], 'info');
            Query();
        } else {
            $.messager.alert('提示', saveRetArr[2], 'warning');
        }
    }
}
// 获取有效记录
function GetSaveParams() {
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    if (gridChkedLen == 0) {
        $.messager.popover({
            msg: '请先勾选需要申请的记录',
            type: 'alert'
        });
        return '';
    }

    var mDspArr = [];
    var reasonObj = {};
    var paramsStr = '';
    var lastRecLocId = '';

    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        var reqReasonId = rowData.reqReasonId || '';

        // 成组退
        if (needGrpRet == 'Y') {
            var mDspIdS = 'M' + mDspId;
            if (mDspArr.indexOf(mDspIdS) >= 0) {
                reqReasonId = reasonObj[mDspIdS];
            }
            if (reqReasonId === '') {
                reqReasonId = WinReason;
            }
            if (mDspArr.indexOf(mDspIdS) < 0 && reqReasonId != '') {
                mDspArr.push(mDspIdS);
                reasonObj[mDspIdS] = reqReasonId;
            }
        } else {
            if (reqReasonId === '') {
                reqReasonId = WinReason;
            }
        }
        if (reqReasonId == '') {
            continue;
        }
        var reqQty = rowData.reqQty || '';
        if (reqQty == '' || reqQty == 0) {
            continue;
        }
        var dspQty = rowData.dspQty || '';
        var prescNo = rowData.prescNo;
        var recLocId = rowData.recLocId || '';
        var phacLbRowId = rowData.phacLbRowId || '';
        var cantretreason = rowData.cantretreason || '';
        var dspId = rowData.dspId || '';
        if (cantretreason != '') {
            $.messager.alert('提示', '第' + (i + 1) + '行药品维护了不可退药原因,不能退药申请', 'warning');
            return '';
        }
        var chkRet = tkMakeServerCall('web.DHCINPHA.Request', 'CheckBeforeSave', phacLbRowId, reqQty);
        if (chkRet.split('^')[0] < 0) {
            $.messager.alert('提示', rowData.incDesc + ':' + chkRet.split('^')[1], 'warning');
            return '';
        }
        if (lastRecLocId != '' && lastRecLocId != recLocId) {
            $.messager.alert('提示', '请选择相同发药科室生成退药申请', 'warning');
            return '';
        }
        lastRecLocId = recLocId;
        var iParams = dspId + '^' + reqQty + '^' + reqReasonId + '^' + phacLbRowId;
        paramsStr = paramsStr == '' ? iParams : paramsStr + ',' + iParams;
    }
    if (paramsStr == '') {
        $.messager.popover({
            msg: '无可用申请数据',
            type: 'alert'
        });
        return '';
    }
    return paramsStr;
}

// 设置默认科室关联
function SetDefaultLoc() {
    var PhaLoc = $('#cmbPhaLoc').combobox('getValue') || '';
    var PhaLocDesc = $('#cmbPhaLoc').combobox('getText') || '';
    if (PhaLoc == '') {
        //$.messager.alert("提示", "请先选择发药科室", "warning");
        //return;
    }
    if (SessionLoc == '') {
        return;
    }
    var confirmText = $g('确认将') + PhaLocDesc + $g('设置成默认科室吗') + '?';
    if (PhaLoc == '') {
        confirmText = '确认默认科室设置为空吗?';
    }
    $.messager.confirm('确认提示', confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall('web.DHCSTRETREQUEST', 'SetDefaultPhaLoc', PhaLoc, SessionLoc);
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert('提示', '设置成功', 'info');
                return;
            }
        }
    });
}

// 本界面使用扩展
function InitExtend() {
    $.extend($.fn.validatebox.defaults.rules, {
        // 是否正数
        CheckNumber: {
            validator: function (value, param) {
                var regTxt = /^[0-9]+\.?[0-9]{0,20}$/; // 20位,不然不满整支申请不过去
                if (regTxt.test(value) == false) {
                    return false;
                } else {
                    // 不能用getSelected
                    var curRow = $("[class='datagrid-editable-input validatebox-text']").parents('.datagrid-row').attr('datagrid-row-index') || '';
                    if (curRow == '') {
                        return true;
                    }
                    var rowData = $('#gridDisped').datagrid('getRows')[curRow];
                    var cyFlag = rowData.cyFlag;
                    var canRetQty = rowData.canRetQty;
                    if (cyFlag == 'Y' && 1 * value != 1 * canRetQty) {
                        return false;
                    }
                    if (1 * value > 1 * canRetQty) {
                        return false;
                    }
                    // 判断能否录入小数
                    var dspQty = rowData.dspQty;
                    if (value.toString().indexOf('.') >= 0) {
                        if (dspQty.toString().indexOf('.') < 0) {
                            $.messager.popover({
                                msg: '不能申请小数',
                                type: 'alert'
                            });
                            return false;
                        }
                    }
                    return true;
                }
            },
            message: '数量不能大于可退数量,且当可退数量为小数时,可申请小数'
        }
    });
}
function ReqReasonWindow(callBack) {
    WinReason = '';
    var winDivId = 'ReqReasonWindowDiv';
    var winDiv = '<div id="' + winDivId + '" style="padding:10px"><div id="gridReqReason"></div></div>';
    $('body').append(winDiv);
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
            hospId: HospId
        },
        border: false,
        fitColumns: true,
        singleSelect: true,
        nowrap: false,
        striped: false,
        pagination: false,
        rownumbers: false,
        columns: [
            [
                {
                    field: 'RowId',
                    title: 'RowId',
                    width: 80,
                    hidden: true
                },
                {
                    field: 'Description',
                    title: '申请原因',
                    width: 300,
                    align: 'left'
                }
            ]
        ],
        onClickRow: function (index, rowData) {
            WinReason = rowData.RowId;
            callBack();
            $('#ReqReasonWindowDiv').window('close');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridReqReason', dataGridOption);
    $('#ReqReasonWindowDiv').window({
        title: '选择退药申请原因',
        collapsible: false,
        iconCls: 'icon-w-list',
        border: false,
        closed: true,
        modal: true,
        width: 600,
        height: 400,
        maximizable: false,
        onClose: function () {
            $('#ReqReasonWindowDiv').window('destroy');
        }
    });
    $('#ReqReasonWindowDiv .datagrid-header').css('display', 'none');
    $("#ReqReasonWindowDiv [class='panel datagrid']").css('border', '#cccccc solid 1px');
    $('#ReqReasonWindowDiv').window('open');
}

function CheckNeedReason() {
    var ret = false;
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    var mDspArr = [];
    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        var reqReasonId = rowData.reqReasonId || '';
        if (needGrpRet === 'Y' && mDspArr.indexOf(mDspId) >= 0) {
            continue;
        }
        if (reqReasonId === '') {
            return true;
        }
        mDspArr.push(mDspId);
    }
    return ret;
}

/* 给勾选的数据赋值申请退药原因 */
function AddReasonForSelect() {
    var ret = false;
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    if (gridChkedLen == 0) {
        $.messager.popover({
            msg: '请先勾选记录',
            type: 'info'
        });
        return;
    }
    var selReasonId = $('#cmbReason').combobox('getValue');
    var selReasonDesc = $('#cmbReason').combobox('getText');
    var mDspArr = [];
    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        if (needGrpRet === 'Y' && mDspArr.indexOf(mDspId) >= 0) {
            continue;
        }
        var rowIndex = $('#gridDisped').datagrid('getRowIndex', rowData);
        /* 给记录赋申请退药原因 */
        $('#gridDisped').datagrid('updateRow', {
            index: rowIndex,
            row: {
                reqReasonDesc: selReasonDesc,
                reqReasonId: selReasonId
            }
        });
        mDspArr.push(mDspId);
    }
    return ret;
}
