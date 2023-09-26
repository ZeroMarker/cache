/**
 * 模块:住院药房
 * 子模块:住院药房-首页-侧菜单-发药科室维护
 * createdate:2016-07-04
 * creator: yunhaibao
 */
var commonInPhaUrl = 'DHCST.INPHA.ACTION.csp';
var commonPhaUrl = 'DHCST.COMMONPHA.ACTION.csp';
var url = 'dhcpha.inpha.phalocation.action.csp';
var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
var HospId = session['LOGON.HOSPID'];
var gridChkIcon =
    '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>';
$(function() {
    InitHospCombo(); //加载医院
    var options = {
        url: commonPhaUrl + '?action=GetCtLocDs&HospId=' + HospId
    };
    $('#phaLoc').dhcphaEasyUICombo(options);
    InitPhaLocGrid();
    InitLocDispTypeGrid();
    InitLocArcCatGrid();
    $('#btnAdd').on('click', function() {
        $('#phaLocationRowId').val('');
        $('#phalocationwin').window('open');
        $('input[type=checkbox][name=chkcondition]').prop('checked', false);
        $('input[name=txtconditon]').val('');
		$('#phaLoc').combobox('clear');
		$('#phaLoc').combobox('options').url=commonPhaUrl + '?action=GetCtLocDs&HospId=' + HospId;
		$('#phaLoc').combobox('reload');
    });
    $('#btnDelete').on('click', btnDeleteHandler); //点击删除
    $('#btnUpdate').on('click', btnUpdateHandler); //点击修改
    $('#btnSave').on('click', btnSaveHandler);
    $('#btnCancel').on('click', function() {
        $('#phalocationwin').window('close');
    });
    $('#phalocgrid').datagrid('reload');
});

//初始化发药科室列表
function InitPhaLocGrid() {
    //定义columns
    var columns = [
        [
            { field: 'phaLocation', title: 'phaLocation', width: 100, hidden: true },
            { field: 'locRowId', title: 'locRowId', width: 100, hidden: true },
            { field: 'locDesc', title: '发药科室', width: 125 },
            {
                field: 'nurseAudit',
                title: '领药审核',
                width: 55,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            {
                field: 'pharmacyAudit',
                title: '药师审核',
                width: 55,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            {
                field: 'dealOrdFlag',
                title: '医嘱处理',
                width: 55,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            {
                field: 'reserveFlag',
                title: '冲减退药',
                width: 55,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            {
                field: 'allResFlag',
                title: '全部冲减',
                width: 55,
                align: 'center',
                hidden: true,
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            {
                field: 'machineFlag',
                title: '包药机',
                width: 55,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        //	return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            { field: 'dispNoPrefix', title: '发药单号</br>前　　缀', width: 55, hidden: 'true' },
            { field: 'dispStartDate', title: '默认发药</br>开始日期', width: 55, align: 'center' },
            { field: 'dispStartTime', title: '默认发药</br>开始时间', width: 55, align: 'center' },
            { field: 'dispEndDate', title: '默认发药</br>截止日期', width: 55, align: 'center' },
            { field: 'dispEndTime', title: '默认发药</br>截止时间', width: 55, align: 'center' },
            { field: 'cacuStartDate', title: '默认统计</br>开始日期', width: 55, align: 'center' },
            { field: 'cacuStartTime', title: '默认统计</br>开始时间', width: 55, align: 'center' },
            { field: 'cacuEndDate', title: '默认统计</br>截止日期', width: 55, align: 'center' },
            { field: 'cacuEndTime', title: '默认统计</br>截止时间', width: 55, align: 'center' },
            { field: 'resStartDate', title: '默认冲减</br>开始日期', width: 55, align: 'center' },
            { field: 'resEndDate', title: '默认冲减</br>截止日期', width: 55, align: 'center' }
        ]
    ];

    //定义datagrid
    $('#phalocgrid').datagrid({
        url: url + '?action=QueryPhaLocation',
        queryParams: {
            HospId: HospId
        },
        border: false,
        toolbar: '#btnbar1',
        singleSelect: true,
        rownumbers: true,
        columns: columns,
        singleSelect: true,
        striped: true,
        fit: true,
        fitColumns: true,
        loadMsg: '正在加载信息...',
        onSelect: function(rowIndex, rowData) {
            $('#locdisptypegrid').datagrid('options').queryParams.params = rowData.phaLocation;
            $('#locdisptypegrid').datagrid('reload');
            $('#locarccatgrid').datagrid('options').queryParams.PhaLocId = rowData.locRowId;
            $('#locarccatgrid').datagrid('options').queryParams.HospId = HospId;
            $('#locarccatgrid').datagrid('reload');
        },
        onLoadSuccess: function() {}
    });
}
function InitDispType() {
    dispTypeEditor = {
        //设置其为可编辑
        type: 'combobox', //设置编辑格式
        options: {
            panelHeight: 'auto',
            valueField: 'value',
            textField: 'text',
            url: commonInPhaUrl + '?action=GetDispTypeDs&Type=gridcombobox&HospId=' + HospId,
            onSelect: function(option) {
                var phalocselect = $('#phalocgrid').datagrid('getSelected');
                if (phalocselect == null) {
                    $.messager.alert('提示', '请先选中科室!', 'info');
                    return;
                }
                var phaLocation = phalocselect['phaLocation'];
                var dispType = option.value;
                var insret = tkMakeServerCall(
                    'web.DHCSTPHALOC',
                    'InsertItm',
                    phaLocation,
                    dispType,
                    '',
                    '',
                    '',
                    ''
                );
                if (insret == '-2') {
                    $.messager.alert('提示', '选中科室已存在该发药类别!', 'info');
                    return;
                }
                $('#locdisptypegrid').datagrid('reload');
            }
        }
    };
}
//初始化科室发药类别列表
function InitLocDispTypeGrid() {
    InitDispType();
    //定义columns
    var columns = [
        [
            { field: 'RowId', title: 'RowId', width: 100, hidden: true },
            { field: 'DispTypeDR', title: 'DispTypeDR', width: 100, hidden: true },
            { field: 'DispTypeDesc', title: '发药类别', editor: dispTypeEditor, width: 250 },
            {
                field: 'DispTypeDefault',
                title: '默认勾选',
                width: 75,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        ///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            {
                field: 'ImPermitReqFlag',
                title: '禁止申请退药',
                width: 100,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                    }
                }
            },
            {
                field: 'DispTypeDelete',
                title:
                    "<a style='padding-left:3px;' href='#' onclick='AddLocDispType()'><i class='fa fa-plus' aria-hidden='true' style='color:#17A05D;font-size:18px'></i></a>",
                width: 50,
                align: 'center',
                formatter: function(value, row, index) {
                    return (
                        "<a href='#' onclick='DeleteLocDispType(" +
                        index +
                        ")'><i class='fa fa-minus' aria-hidden='true' style='color:#DE5145;font-size:18px'></i></a>"
                    );
                }
            }
        ]
    ];

    //定义datagrid
    $('#locdisptypegrid').datagrid({
        url: url + '?action=QueryPhaLocDispType',
        border: false,
        singleSelect: true,
        rownumbers: true,
        columns: columns,
        striped: true,
        fit: true,
        singleSelect: true,
        loadMsg: '正在加载信息...',
        onClickRow: function(rowIndex, rowData) {},
        onDblClickCell: function(rowIndex, field, value) {
            if (field != 'DispTypeDefault' && field != 'ImPermitReqFlag') {
                return;
            }
            var disptypeselect = $('#locdisptypegrid').datagrid('getSelected');
            if (disptypeselect == null) {
                return;
            }
            var phalocselect = $('#phalocgrid').datagrid('getSelected');
            if (phalocselect == null) {
                return;
            }
            var locdisptypeid = disptypeselect['RowId'];
            if (locdisptypeid == '' || locdisptypeid == undefined) {
                return;
            }
            var locdisptypedesc = disptypeselect['DispTypeDesc'];
            //修改默认状态
            if (field == 'DispTypeDefault') {
                var locdisptypedef = disptypeselect['DispTypeDefault'];
                if (locdisptypedef == 'Y') {
                    locdisptypedef = 'N';
                } else {
                    locdisptypedef = 'Y';
                }
                var locdesc = phalocselect['locDesc'];
                var msginfo =
                    '<p>发药科室:<font color=blue><b>' +
                    locdesc +
                    '</b></font></p>' +
                    '<p>发药类别:<font color=blue><b>' +
                    locdisptypedesc +
                    '</b></font></p>';
                $.messager.confirm('是否确认修改默认状态?', msginfo, function(r) {
                    if (r == true) {
                        var ret = tkMakeServerCall(
                            'web.DHCINPHA.PhaLocation',
                            'UpdateDefLocDispType',
                            locdisptypeid,
                            locdisptypedef
                        );
                        if (ret != 0) {
                            $.messager.alert('提示', '修改失败,错误代码:' + ret, 'warning');
                            return;
                        } else {
                            $('#locdisptypegrid').datagrid('reload');
                        }
                    } else {
                        return;
                    }
                });
            }
            //修改禁止退药申请状态
            else if (field == 'ImPermitReqFlag') {
                var impermit = disptypeselect['ImPermitReqFlag'];
                if (impermit == 'Y') {
                    impermit = 'N';
                } else {
                    impermit = 'Y';
                }
                var locdesc = phalocselect['locDesc'];
                var msginfo =
                    '<p>发药科室:<font color=blue><b>' +
                    locdesc +
                    '</b></font></p>' +
                    '<p>发药类别:<font color=blue><b>' +
                    locdisptypedesc +
                    '</b></font></p>';
                $.messager.confirm('是否确认修改禁止退药申请状态?', msginfo, function(r) {
                    if (r == true) {
                        var ret = tkMakeServerCall(
                            'web.DHCINPHA.PhaLocation',
                            'UpdateImPermitReqFlag',
                            locdisptypeid,
                            impermit
                        );
                        if (ret != 0) {
                            $.messager.alert('提示', '修改失败,错误代码:' + ret, 'warning');
                            return;
                        } else {
                            $('#locdisptypegrid').datagrid('reload');
                        }
                    } else {
                        return;
                    }
                });
            }
        }
    });
}

function InitLocArcCatGrid() {
    //定义columns
    var columns = [
        [
            { field: 'placId', title: 'placId', width: 100, hidden: true },
            { field: 'arcCatId', title: 'arcCatId', width: 100, hidden: true },
            {
                field: 'passAudit',
                title: '选择',
                width: 50,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        ///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            { field: 'arcCatDesc', title: '医嘱子类名称', width: 350 }
        ]
    ];

    //定义datagrid
    $('#locarccatgrid').datagrid({
        url: 'websys.Broker.cls',
        queryParams: {
            ClassName: 'web.DHCINPHA.PhaLocation',
            QueryName: 'LocArcCatConfig',
            PhaLocId: '',
            HospId: HospId
        },
        border: false,
        singleSelect: true,
        columns: columns,
        fit: true,
        rownumbers: true,
        loadMsg: '正在加载信息...',
        onDblClickCell: function(rowIndex, field, value) {
            if (field != 'passAudit') {
                return;
            }
            var phalocSelect = $('#phalocgrid').datagrid('getSelected') || '';
            if (phalocSelect == '') {
                $.messager.alert('提示', '请先选中需要设置的住院发药科室记录', 'info');
                return;
            }
            var locId = phalocSelect.locRowId;
            var arcCatSelect = $('#locarccatgrid').datagrid('getData').rows[rowIndex];
            var arcCatId = arcCatSelect.arcCatId;
            var passAudit = arcCatSelect.passAudit || '';
            passAudit = passAudit == 'Y' ? 'N' : 'Y';
            var saveRet = tkMakeServerCall(
                'web.DHCINPHA.PhaLocation',
                'SavePHAIPLocArcCat',
                locId,
                arcCatId,
                passAudit
            );
            var saveArr = saveRet.split('^');
            if (saveArr[0] < 0) {
                $.messager.alert('提示', saveArr[1], 'error');
                return;
            } else {
                $('#locarccatgrid').datagrid('reload');
            }
        }
    });
}
///科室发药类别删除
function DeleteLocDispType() {
    var $target = $(event.target);
    var rowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
    var rowData = $('#locdisptypegrid').datagrid('getData').rows[rowIndex];
    var locdisptypeid = rowData.RowId;
    if (locdisptypeid == null || locdisptypeid == undefined) {
        $.messager.alert('提示', '请先选中需删除的行!', 'info');
        return;
    }
    if (locdisptypeid == '') {
        $('#locdisptypegrid').datagrid('deleteRow', rowIndex);
        return;
    }
    var msginfo = '<p><font color=red><b>请确保该发药类别尚未下医嘱,谨慎操作!</b></font></p>';
    $.messager.confirm('确认删除吗？', msginfo, function(r) {
        if (r) {
            $.messager.confirm(
                '再次确认是否需要删除？',
                '<p><font color=red><b>发药类别为住院发药核心数据!</b></font></p>',
                function(r1) {
                    if (r1) {
                        var delret = tkMakeServerCall(
                            'web.DHCSTPHALOC',
                            'DeleteItm',
                            locdisptypeid
                        );
                        if (delret > 0) {
                            $('#locdisptypegrid').datagrid('reload');
                        } else {
                            $.messager.alert('提示', '删除失败!');
                        }
                    }
                }
            );
        }
    });
}
///增加科室发药类别
function AddLocDispType() {
    var row = $('#locdisptypegrid').datagrid('getData').rows[0];
    if (row) {
        if (row.RowId == '') {
            return;
        }
    }
    $('#locdisptypegrid').datagrid('insertRow', {
        index: 0,
        row: {
            RowId: '',
            DispTypeDR: '',
            DispTypeDesc: '',
            DispTypeDefault: '',
            ImPermitReqFlag: ''
        }
    });
    $('#locdisptypegrid').datagrid('beginEdit', 0);
}
//删除科室维护
function btnDeleteHandler() {
    var phalocselect = $('#phalocgrid').datagrid('getSelected');
    if (phalocselect == null || phalocselect == undefined || phalocselect == '') {
        $.messager.alert('提示', '请先选择需要删除的科室记录', 'info');
        return;
    }
    var phaLocation = phalocselect['phaLocation'];
    var locDesc = phalocselect['locDesc'];
    var msginfo = '<p>发药科室:<font color=blue><b>' + locDesc + '</b></font></p>';
    $.messager.confirm('确认删除吗？', msginfo, function(r) {
        if (r) {
            $.messager.confirm(
                '再次确认是否需要删除？',
                '<p><font color=red><b>发药科室相关信息为住院发药核心数据!</b></font></p>',
                function(r1) {
                    if (r1) {
                        var delret = tkMakeServerCall('web.DHCSTPHALOC', 'Delete', phaLocation);
                        if (delret > 0) {
                            $('#phalocgrid').datagrid('reload');
                        } else {
                            $.messager.alert('提示', '删除失败!');
                        }
                    }
                }
            );
        }
    });
}
//保存发药科室配置
function btnSaveHandler() {
    var phaLocationRowId = $.trim($('#phaLocationRowId').val());
    var locRowId = $('#phaLoc').combobox('getValue');
    if ($.trim($('#phaLoc').combobox('getValue')) == '' || locRowId == undefined) {
        locRowId = '';
        $.messager.alert('提示', '发药科室必填!', 'info');
        return;
    }
    var dispstartdate = $('#dispStartDate').val();
    var dispstarttime = $('#dispStartTime').val();
    var dispenddate = $('#dispEndDate').val();
    var dispendtime = $('#dispEndTime').val();
    var cacustartdate = $('#cacuStartDate').val();
    var cacustarttime = $('#cacuStartTime').val();
    var cacuenddate = $('#cacuEndDate').val();
    var cacuendtime = $('#cacuEndTime').val();
    var dispnoprefix = $('#dispNoPrefix').val();
    var dispnocount = $('#dispNoCount').val();
    var resstartdate = $('#resStartDate').val();
    var resenddate = $('#resEndDate').val();
    var dispdefault = $('#ordDisplay').val();
    var nurseauditflag = 'N';
    if ($('#chkNurseAudit').is(':checked')) {
        nurseauditflag = 'Y';
    }
    var reserveflag = 'N';
    if ($('#chkReserve').is(':checked')) {
        reserveflag = 'Y';
    }
    var chkdispuser = 'N';
    if ($('#chkDispUser').is(':checked')) {
        chkdispuser = 'Y';
    }
    var resallflag = 'N';
    if ($('#chkAllRes').is(':checked')) {
        resallflag = 'Y';
    }
    var chkoperater = 'N';
    if ($('#chkCollUser').is(':checked')) {
        chkoperater = 'Y';
    }
    var billflag = 'N';
    if ($('#chkBill').is(':checked')) {
        billflag = 'Y';
    }
    var disptypelocalflag = 'N';
    if ($('#chkLocal').is(':checked')) {
        disptypelocalflag = 'Y';
    }
    var emyflag = 'N';
    if ($('#chkEMY').is(':checked')) {
        emyflag = 'Y';
    }
    var defaultflag = 'N';
    if ($('#chkDefDispType').is(':checked')) {
        defaultflag = 'Y';
    }
    var lsflag = 'N';
    if ($('#chkOrd').is(':checked')) {
        lsflag = 'Y';
    }
    var reqwardflag = 'N';
    if ($('#chkReqWard').is(':checked')) {
        reqwardflag = 'Y';
    }
    var preret = 'N';
    if ($('#chkPreRet').is(':checked')) {
        preret = 'Y';
    }
    var sendmachine = 'N';
    if ($('#chkMachine').is(':checked')) {
        sendmachine = 'Y';
    }
    var ordauditflag = 'N';
    if ($('#chkOrderAudit').is(':checked')) {
        ordauditflag = 'Y';
    }
    var dealordflag = 'N';
    if ($('#chkDealOrd').is(':checked')) {
        dealordflag = 'Y';
    }
    var datestr =
        dispstartdate +
        '^' +
        dispenddate +
        '^' +
        dispstarttime +
        '^' +
        dispendtime +
        '^' +
        cacustartdate +
        '^' +
        cacuenddate +
        '^' +
        cacustarttime +
        '^' +
        cacuendtime +
        '^' +
        resstartdate +
        '^' +
        resenddate;
    var wardrequiredflag = '';
    var cydyflag = '';
    var paramsstr =
        chkdispuser +
        '^' +
        resallflag +
        '^' +
        chkoperater +
        '^' +
        billflag +
        '^' +
        disptypelocalflag +
        '^' +
        emyflag +
        '^' +
        defaultflag +
        '^' +
        lsflag +
        '^' +
        reqwardflag +
        '^' +
        dispdefault +
        '^' +
        preret +
        '^' +
        sendmachine +
        '^' +
        ordauditflag +
        '^' +
        dealordflag;
    if (phaLocationRowId == '') {
        var rows = $('#phalocgrid').datagrid('getRows');
        for (var i = 0; i < rows.length; i++) {
            tmplocRowId = rows[i]['locRowId']; //获取指定列
            var locRowId = $('#phaLoc').combobox('getValue');
            if (locRowId == tmplocRowId) {
                $.messager.alert('提示', '该发药科室已存在!', 'info');
                $('#phaLoc').dhcphaEasyUICombo(options);
                return;
            }
        }
        var insret = tkMakeServerCall(
            'web.DHCSTPHALOC',
            'Insert',
            locRowId,
            wardrequiredflag,
            cydyflag,
            datestr,
            dispnoprefix,
            nurseauditflag,
            reserveflag,
            paramsstr
        );
        if (insret < 0) {
            $.messager.alert('错误提示', '保存失败,错误代码:+' + insret, 'warning');
            return;
        } else {
            $.messager.alert('提示', '保存成功!');
            $('#phaLocationRowId').val(phaLocationRowId);
            $('#phalocgrid').datagrid('reload');
            return;
        }
    } else {
        var updret = tkMakeServerCall(
            'web.DHCSTPHALOC',
            'Update',
            phaLocationRowId,
            locRowId,
            wardrequiredflag,
            cydyflag,
            datestr,
            dispnoprefix,
            nurseauditflag,
            reserveflag,
            paramsstr
        );
        if (updret == -2) {
            $.messager.alert('提示', '该发药科室已存在!', 'info');
            return;
        } else if (updret < 0) {
            $.messager.alert('错误提示', '更新失败,错误代码:+' + updret, 'warning');
            return;
        } else {
            $.messager.alert('提示', '更新成功!');
            $('#phalocgrid').datagrid('reload');
            return;
        }
    }
}
//修改发药类别
function btnUpdateHandler() {
    var phalocselect = $('#phalocgrid').datagrid('getSelected');
    if (phalocselect == null) {
        $.messager.alert('提示', '请先选中需修改的行!', 'info');
        return;
    }
    var phaLocation = phalocselect['phaLocation'];
    $('#phalocationwin').window('open');
    $('input[type=checkbox][name=chkcondition]').prop('checked', false);
    $('input[name=txtconditon]').val('');
    var phalocinfo = tkMakeServerCall('web.DHCSTPHALOC', 'GetPhaLoc', phaLocation);
    if (phalocinfo == '') {
        return;
    }
    var phalocarr = phalocinfo.split('^');
    var notbywardflag = phalocarr[0]; //不按病区发药,暂没用
    var cydyflag = phalocarr[1]; //暂没用
    var dispstartdate = phalocarr[2]; //发药开始日期
    var dispenddate = phalocarr[3]; //发药截止日期
    var dispstarttime = phalocarr[4]; //发药开始时间
    var dispendtime = phalocarr[5]; //发药截止时间
    var cacustartdate = phalocarr[6]; //统计开始日期
    var cacuenddate = phalocarr[7]; //统计截止日期
    var cacustarttime = phalocarr[8]; //统计开始时间
    var cacuendtime = phalocarr[9]; //统计截止时间
    var nurseauditflag = phalocarr[10]; //护士审核
    var reserveflag = phalocarr[11]; //冲减标志
    var locdr = phalocarr[12]; //科室id
    var locdesc = phalocarr[13]; //科室名称
    var finaldate = phalocarr[14];
    var dispnoprefix = phalocarr[15]; //单号前缀
    var dispnocount = phalocarr[16]; //单号流水
    var chkdispuser = phalocarr[17]; //是否录入发药人
    var resstartdate = phalocarr[18]; //冲减开始日期
    var resenddate = phalocarr[19]; //冲减截止日期
    var resallflag = phalocarr[20]; //全部冲减标志
    var chkoperater = phalocarr[21]; //是否录入摆药人
    var billflag = phalocarr[22]; //是否控制欠费
    var disptypelocalflag = phalocarr[23]; //病区发药类别是否默认取本地配置(限发)
    var emyflag = phalocarr[24]; //是否显示加急
    var defaultflag = phalocarr[25]; //默认选择发药类别 原来意思是：病区发药列表显示出院带药20141218改为此用途 zhouyg
    var lsflag = phalocarr[26]; // 病区发药长临嘱按钮必选其一
    var reqwardflag = phalocarr[27]; //病区退药申请单只能填写本病区已发药品
    var dispdefault = phalocarr[28]; //病区发药默认显示值(0-临嘱,1-长嘱,2-长+临嘱)
    var prtret = phalocarr[30]; //打停止签时自动退药
    var sendmachine = phalocarr[31]; //包药机
    var ordauditflag = phalocarr[32]; //药师审核
    var dealordflag = phalocarr[33]; //发药前医嘱处理
    $('#dispStartDate').val(dispstartdate);
    $('#dispStartTime').val(dispstarttime);
    $('#dispEndDate').val(dispenddate);
    $('#dispEndTime').val(dispendtime);
    $('#cacuStartDate').val(cacustartdate);
    $('#cacuStartTime').val(cacustarttime);
    $('#cacuEndDate').val(cacuenddate);
    $('#cacuEndTime').val(cacuendtime);
    $('#dispNoPrefix').val(dispnoprefix);
    $('#dispNoCount').val(dispnocount);
    $('#resStartDate').val(resstartdate);
    $('#resEndDate').val(resenddate);
    $('#ordDisplay').val(dispdefault);
    if (nurseauditflag == 'Y') {
        $('#chkNurseAudit').prop('checked', true);
    }
    if (reserveflag == 'Y') {
        $('#chkReserve').prop('checked', true);
    }
    if (chkdispuser == 'Y') {
        $('#chkDispUser').prop('checked', true);
    }
    if (resallflag == 'Y') {
        $('#chkAllRes').prop('checked', true);
    }
    if (chkoperater == 'Y') {
        $('#chkCollUser').prop('checked', true);
    }
    if (billflag == 'Y') {
        $('#chkBill').prop('checked', true);
    }
    if (disptypelocalflag == 'Y') {
        $('#chkLocal').prop('checked', true);
    }
    if (emyflag == 'Y') {
        $('#chkEMY').prop('checked', true);
    }
    if (defaultflag == 'Y') {
        $('#chkDefDispType').prop('checked', true);
    }
    if (lsflag == 'Y') {
        $('#chkOrd').prop('checked', true);
    }
    if (reqwardflag == 'Y') {
        $('#chkReqWard').prop('checked', true);
    }
    if (prtret == 'Y') {
        $('#chkPreRet').prop('checked', true);
    }
    if (sendmachine == 'Y') {
        $('#chkMachine').prop('checked', true);
    }
    if (ordauditflag == 'Y') {
        $('#chkOrderAudit').prop('checked', true);
    }
    if (dealordflag == 'Y') {
        $('#chkDealOrd').prop('checked', true);
    }
    $('#phaLoc').combobox('setValue', locdr);
    $('#phaLoc').combobox('setText', locdesc);
    $('#phaLocationRowId').val(phaLocation);
}

function InitHospCombo() {
    var genHospObj = DHCSTEASYUI.GenHospComp({tableName:'PHA-IP-LocConfig'});
    if (typeof genHospObj === 'object') {
        //增加选择事件
        $('#_HospList').combogrid('options').onSelect = function(index, record) {
            NewHospId = record.HOSPRowId;
            if (NewHospId != HospId) {
                HospId = NewHospId;
			
				$('#phaLoc').combobox('options').url=commonPhaUrl + '?action=GetCtLocDs&HospId=' + HospId;
				$('#phaLoc').combobox('reload');
                $('#phalocgrid').datagrid({
                    queryParams: {
                        HospId: HospId
                    }
                });
                $('#locdisptypegrid,#locarccatgrid').datagrid('loadData', []);
                ReInitLocDispTypeGrid();
                $('#locarccatgrid').datagrid('options').queryParams.PhaLocId = '';
                $('#locarccatgrid').datagrid('options').queryParams.HospId = HospId;
                $('#locarccatgrid').datagrid('reload');
            }
        };
    }
}

function ReInitLocDispTypeGrid() {
    dispTypeEditor.options.url =
        commonInPhaUrl + '?action=GetDispTypeDs&Type=gridcombobox&HospId=' + HospId;
    var columns = [
        [
            { field: 'RowId', title: 'RowId', width: 100, hidden: true },
            { field: 'DispTypeDR', title: 'DispTypeDR', width: 100, hidden: true },
            { field: 'DispTypeDesc', title: '发药类别', editor: dispTypeEditor, width: 250 },
            {
                field: 'DispTypeDefault',
                title: '默认',
                width: 50,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                        ///return '<img src="../scripts/dhcpha/img/cancel.png" border=0/>';
                    }
                }
            },
            {
                field: 'ImPermitReqFlag',
                title: '禁止申请退药',
                width: 90,
                align: 'center',
                formatter: function(value, row, index) {
                    if (value == 'Y') {
                        return gridChkIcon;
                    } else {
                    }
                }
            },
            {
                field: 'DispTypeDelete',
                title:
                    "<a style='padding-left:3px;' href='#' onclick='AddLocDispType()'><i class='fa fa-plus' aria-hidden='true' style='color:#17A05D;font-size:18px'></i></a>",
                width: 50,
                align: 'center',
                formatter: function(value, row, index) {
                    return (
                        "<a href='#' onclick='DeleteLocDispType(" +
                        index +
                        ")'><i class='fa fa-minus' aria-hidden='true' style='color:#DE5145;font-size:18px'></i></a>"
                    );
                }
            }
        ]
    ];
    $('#locdisptypegrid').datagrid('options').queryParams.params = '';
    $('#locdisptypegrid').datagrid({
        columns: columns
    });
}
