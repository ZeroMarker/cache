/**
 * 模块:     退药申请
 * 编写日期: 2018-07-02
 * 编写人:   yunhaibao
 * 其他:     退药申请主表依然是按人保存
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
var DefPhaLocInfo = tkMakeServerCall('web.DHCSTKUTIL', 'GetDefaultPhaLoc', SessionLoc);
var Loaded = ''; // 首次加载为空,控制默认药房
var DefPhaLocArr = DefPhaLocInfo.split('^');
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
                // 修改病人姓名
                Query();
            }
        }
    });
    $('#btnDirReq').on('click', RequestQuery);
    $('#btnDefaultLoc').on('click', SetDefaultLoc);
    $('#btnFind').on('click', Query);
    if (LoadAdmId != '') {
        var patInfo = tkMakeServerCall('web.DHCINPHA.Request', 'PatInfo', LoadAdmId);
        $('#txtPatNo').val(patInfo.split('^')[0] || '');
        $('#txtPatName').val(patInfo.split('^')[1] || '');
    }
    $('#btnSave').on('click', Save);
    setTimeout(Query, 500);
});

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
            }
        }
    );
}

function InitGridDict() {
    var retReaData = $.cm(
        {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
			hospId:HospId,
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
// 已发药信息
function InitGridDisped() {
    var columns = [
        [
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
                width: 200
            },
            {
                field: 'canRetQty',
                title: '可退数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '<span style="color:red">*</span>申请数量', // 配液中心与草药不可编辑
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
                title: '<span style="color:red">*</span>申请退药原因',
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
                width: 100,
                align: 'left'
            },
            {
                field: 'reqHistory',
                title: '历次记录',
                width: 100,
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
                width: 70
            },
            {
                field: 'patLevel',
                title: '病人级别',
                width: 70
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
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        fit: true,
        border: false,
        singleSelect: true,
        columns: columns,
        pageSize: 1000,
        pageList: [1000],
        pagination: false,
        toolbar: '#gridDispedBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'reqReasonId'
            });
            if (rowData.canRetFlag == 'N') {
                $(this).datagrid('cancelEdit', rowIndex);
                $(this).datagrid('options').editIndex = undefined;
                return;
            }
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
        onSelect: function (rowIndex, rowData) {},
        onUnselect: function (rowIndex, rowData) {
			// 此处不要触发unselectAll,会出现无限递归
            // $(this).datagrid('unselectAll');
        },
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridDisped', dataGridOption);
}

// 查询
function Query() {
    var admId = LoadAdmId;
    var patNo = $('#txtPatNo').val();
    var recLocId = $('#cmbPhaLoc').combobox('getValue');
    var params = patNo + '^' + admId + '^' + recLocId + '^' + SessionLoc;
    $('#gridDisped').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'QueryDisped',
            inputStr: params
        }
    });
}

function RequestQuery() {
    var lnk = 'dhcpha.inpha.hisui.queryretrequest.csp?EpisodeID=' + LoadAdmId;
    websys_createWindow(lnk, '退药申请查询', 'height=85%,width=85%,menubar=no,status=no,toolbar=no,resizable=yes');
}

//清屏
function ClearClick() {}
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
            $.messager.alert('提示', '生成成功' + '</br>' + saveRetArr[1], 'info');
            Query();
        } else {
            $.messager.alert('提示', saveRetArr[2], 'warning');
        }
    }
}
// 获取有效记录
function GetSaveParams() {
    $('#gridDisped').datagrid('endEditing');
    var gridChanges = $('#gridDisped').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert('提示', '没有需要保存的数据', 'warning');
        return '';
    }
    var mDspArr = [];
    var reasonObj = {};
    var paramsStr = '';
    var lastRecLocId = '';
    var gridRows = $('#gridDisped').datagrid('getRows');
    var rowsLen = gridRows.length;
    for (var i = 0; i < rowsLen; i++) {
        var rowData = gridRows[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        var mDspIdS = 'M' + mDspId;
        var reqReasonId = rowData.reqReasonId || '';
        if (needGrpRet == 'Y') {
            if (reqReasonId == '') {
                if (mDspArr.indexOf(mDspIdS) >= 0) {
                    reqReasonId = reasonObj[mDspIdS];
                }
            }
            if (mDspArr.indexOf(mDspId) < 0 && reqReasonId != '') {
                mDspArr.push(mDspIdS);
                reasonObj[mDspIdS] = reqReasonId;
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
        $.messager.alert('提示', '无可用申请数据', 'warning');
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
    var confirmText = '确认将 ' + PhaLocDesc + ' 设置成默认科室吗?';
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
