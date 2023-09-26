/**
 * ģ��:סԺҩ��
 * ��ģ��:סԺҩ��-��ҳ-��˵�-��ҩ����ά��
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
    InitHospCombo(); //����ҽԺ
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
    $('#btnDelete').on('click', btnDeleteHandler); //���ɾ��
    $('#btnUpdate').on('click', btnUpdateHandler); //����޸�
    $('#btnSave').on('click', btnSaveHandler);
    $('#btnCancel').on('click', function() {
        $('#phalocationwin').window('close');
    });
    $('#phalocgrid').datagrid('reload');
});

//��ʼ����ҩ�����б�
function InitPhaLocGrid() {
    //����columns
    var columns = [
        [
            { field: 'phaLocation', title: 'phaLocation', width: 100, hidden: true },
            { field: 'locRowId', title: 'locRowId', width: 100, hidden: true },
            { field: 'locDesc', title: '��ҩ����', width: 125 },
            {
                field: 'nurseAudit',
                title: '��ҩ���',
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
                title: 'ҩʦ���',
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
                title: 'ҽ������',
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
                title: '�����ҩ',
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
                title: 'ȫ�����',
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
                title: '��ҩ��',
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
            { field: 'dispNoPrefix', title: '��ҩ����</br>ǰ����׺', width: 55, hidden: 'true' },
            { field: 'dispStartDate', title: 'Ĭ�Ϸ�ҩ</br>��ʼ����', width: 55, align: 'center' },
            { field: 'dispStartTime', title: 'Ĭ�Ϸ�ҩ</br>��ʼʱ��', width: 55, align: 'center' },
            { field: 'dispEndDate', title: 'Ĭ�Ϸ�ҩ</br>��ֹ����', width: 55, align: 'center' },
            { field: 'dispEndTime', title: 'Ĭ�Ϸ�ҩ</br>��ֹʱ��', width: 55, align: 'center' },
            { field: 'cacuStartDate', title: 'Ĭ��ͳ��</br>��ʼ����', width: 55, align: 'center' },
            { field: 'cacuStartTime', title: 'Ĭ��ͳ��</br>��ʼʱ��', width: 55, align: 'center' },
            { field: 'cacuEndDate', title: 'Ĭ��ͳ��</br>��ֹ����', width: 55, align: 'center' },
            { field: 'cacuEndTime', title: 'Ĭ��ͳ��</br>��ֹʱ��', width: 55, align: 'center' },
            { field: 'resStartDate', title: 'Ĭ�ϳ��</br>��ʼ����', width: 55, align: 'center' },
            { field: 'resEndDate', title: 'Ĭ�ϳ��</br>��ֹ����', width: 55, align: 'center' }
        ]
    ];

    //����datagrid
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
        loadMsg: '���ڼ�����Ϣ...',
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
        //������Ϊ�ɱ༭
        type: 'combobox', //���ñ༭��ʽ
        options: {
            panelHeight: 'auto',
            valueField: 'value',
            textField: 'text',
            url: commonInPhaUrl + '?action=GetDispTypeDs&Type=gridcombobox&HospId=' + HospId,
            onSelect: function(option) {
                var phalocselect = $('#phalocgrid').datagrid('getSelected');
                if (phalocselect == null) {
                    $.messager.alert('��ʾ', '����ѡ�п���!', 'info');
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
                    $.messager.alert('��ʾ', 'ѡ�п����Ѵ��ڸ÷�ҩ���!', 'info');
                    return;
                }
                $('#locdisptypegrid').datagrid('reload');
            }
        }
    };
}
//��ʼ�����ҷ�ҩ����б�
function InitLocDispTypeGrid() {
    InitDispType();
    //����columns
    var columns = [
        [
            { field: 'RowId', title: 'RowId', width: 100, hidden: true },
            { field: 'DispTypeDR', title: 'DispTypeDR', width: 100, hidden: true },
            { field: 'DispTypeDesc', title: '��ҩ���', editor: dispTypeEditor, width: 250 },
            {
                field: 'DispTypeDefault',
                title: 'Ĭ�Ϲ�ѡ',
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
                title: '��ֹ������ҩ',
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

    //����datagrid
    $('#locdisptypegrid').datagrid({
        url: url + '?action=QueryPhaLocDispType',
        border: false,
        singleSelect: true,
        rownumbers: true,
        columns: columns,
        striped: true,
        fit: true,
        singleSelect: true,
        loadMsg: '���ڼ�����Ϣ...',
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
            //�޸�Ĭ��״̬
            if (field == 'DispTypeDefault') {
                var locdisptypedef = disptypeselect['DispTypeDefault'];
                if (locdisptypedef == 'Y') {
                    locdisptypedef = 'N';
                } else {
                    locdisptypedef = 'Y';
                }
                var locdesc = phalocselect['locDesc'];
                var msginfo =
                    '<p>��ҩ����:<font color=blue><b>' +
                    locdesc +
                    '</b></font></p>' +
                    '<p>��ҩ���:<font color=blue><b>' +
                    locdisptypedesc +
                    '</b></font></p>';
                $.messager.confirm('�Ƿ�ȷ���޸�Ĭ��״̬?', msginfo, function(r) {
                    if (r == true) {
                        var ret = tkMakeServerCall(
                            'web.DHCINPHA.PhaLocation',
                            'UpdateDefLocDispType',
                            locdisptypeid,
                            locdisptypedef
                        );
                        if (ret != 0) {
                            $.messager.alert('��ʾ', '�޸�ʧ��,�������:' + ret, 'warning');
                            return;
                        } else {
                            $('#locdisptypegrid').datagrid('reload');
                        }
                    } else {
                        return;
                    }
                });
            }
            //�޸Ľ�ֹ��ҩ����״̬
            else if (field == 'ImPermitReqFlag') {
                var impermit = disptypeselect['ImPermitReqFlag'];
                if (impermit == 'Y') {
                    impermit = 'N';
                } else {
                    impermit = 'Y';
                }
                var locdesc = phalocselect['locDesc'];
                var msginfo =
                    '<p>��ҩ����:<font color=blue><b>' +
                    locdesc +
                    '</b></font></p>' +
                    '<p>��ҩ���:<font color=blue><b>' +
                    locdisptypedesc +
                    '</b></font></p>';
                $.messager.confirm('�Ƿ�ȷ���޸Ľ�ֹ��ҩ����״̬?', msginfo, function(r) {
                    if (r == true) {
                        var ret = tkMakeServerCall(
                            'web.DHCINPHA.PhaLocation',
                            'UpdateImPermitReqFlag',
                            locdisptypeid,
                            impermit
                        );
                        if (ret != 0) {
                            $.messager.alert('��ʾ', '�޸�ʧ��,�������:' + ret, 'warning');
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
    //����columns
    var columns = [
        [
            { field: 'placId', title: 'placId', width: 100, hidden: true },
            { field: 'arcCatId', title: 'arcCatId', width: 100, hidden: true },
            {
                field: 'passAudit',
                title: 'ѡ��',
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
            { field: 'arcCatDesc', title: 'ҽ����������', width: 350 }
        ]
    ];

    //����datagrid
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
        loadMsg: '���ڼ�����Ϣ...',
        onDblClickCell: function(rowIndex, field, value) {
            if (field != 'passAudit') {
                return;
            }
            var phalocSelect = $('#phalocgrid').datagrid('getSelected') || '';
            if (phalocSelect == '') {
                $.messager.alert('��ʾ', '����ѡ����Ҫ���õ�סԺ��ҩ���Ҽ�¼', 'info');
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
                $.messager.alert('��ʾ', saveArr[1], 'error');
                return;
            } else {
                $('#locarccatgrid').datagrid('reload');
            }
        }
    });
}
///���ҷ�ҩ���ɾ��
function DeleteLocDispType() {
    var $target = $(event.target);
    var rowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
    var rowData = $('#locdisptypegrid').datagrid('getData').rows[rowIndex];
    var locdisptypeid = rowData.RowId;
    if (locdisptypeid == null || locdisptypeid == undefined) {
        $.messager.alert('��ʾ', '����ѡ����ɾ������!', 'info');
        return;
    }
    if (locdisptypeid == '') {
        $('#locdisptypegrid').datagrid('deleteRow', rowIndex);
        return;
    }
    var msginfo = '<p><font color=red><b>��ȷ���÷�ҩ�����δ��ҽ��,��������!</b></font></p>';
    $.messager.confirm('ȷ��ɾ����', msginfo, function(r) {
        if (r) {
            $.messager.confirm(
                '�ٴ�ȷ���Ƿ���Ҫɾ����',
                '<p><font color=red><b>��ҩ���ΪסԺ��ҩ��������!</b></font></p>',
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
                            $.messager.alert('��ʾ', 'ɾ��ʧ��!');
                        }
                    }
                }
            );
        }
    });
}
///���ӿ��ҷ�ҩ���
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
//ɾ������ά��
function btnDeleteHandler() {
    var phalocselect = $('#phalocgrid').datagrid('getSelected');
    if (phalocselect == null || phalocselect == undefined || phalocselect == '') {
        $.messager.alert('��ʾ', '����ѡ����Ҫɾ���Ŀ��Ҽ�¼', 'info');
        return;
    }
    var phaLocation = phalocselect['phaLocation'];
    var locDesc = phalocselect['locDesc'];
    var msginfo = '<p>��ҩ����:<font color=blue><b>' + locDesc + '</b></font></p>';
    $.messager.confirm('ȷ��ɾ����', msginfo, function(r) {
        if (r) {
            $.messager.confirm(
                '�ٴ�ȷ���Ƿ���Ҫɾ����',
                '<p><font color=red><b>��ҩ���������ϢΪסԺ��ҩ��������!</b></font></p>',
                function(r1) {
                    if (r1) {
                        var delret = tkMakeServerCall('web.DHCSTPHALOC', 'Delete', phaLocation);
                        if (delret > 0) {
                            $('#phalocgrid').datagrid('reload');
                        } else {
                            $.messager.alert('��ʾ', 'ɾ��ʧ��!');
                        }
                    }
                }
            );
        }
    });
}
//���淢ҩ��������
function btnSaveHandler() {
    var phaLocationRowId = $.trim($('#phaLocationRowId').val());
    var locRowId = $('#phaLoc').combobox('getValue');
    if ($.trim($('#phaLoc').combobox('getValue')) == '' || locRowId == undefined) {
        locRowId = '';
        $.messager.alert('��ʾ', '��ҩ���ұ���!', 'info');
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
            tmplocRowId = rows[i]['locRowId']; //��ȡָ����
            var locRowId = $('#phaLoc').combobox('getValue');
            if (locRowId == tmplocRowId) {
                $.messager.alert('��ʾ', '�÷�ҩ�����Ѵ���!', 'info');
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
            $.messager.alert('������ʾ', '����ʧ��,�������:+' + insret, 'warning');
            return;
        } else {
            $.messager.alert('��ʾ', '����ɹ�!');
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
            $.messager.alert('��ʾ', '�÷�ҩ�����Ѵ���!', 'info');
            return;
        } else if (updret < 0) {
            $.messager.alert('������ʾ', '����ʧ��,�������:+' + updret, 'warning');
            return;
        } else {
            $.messager.alert('��ʾ', '���³ɹ�!');
            $('#phalocgrid').datagrid('reload');
            return;
        }
    }
}
//�޸ķ�ҩ���
function btnUpdateHandler() {
    var phalocselect = $('#phalocgrid').datagrid('getSelected');
    if (phalocselect == null) {
        $.messager.alert('��ʾ', '����ѡ�����޸ĵ���!', 'info');
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
    var notbywardflag = phalocarr[0]; //����������ҩ,��û��
    var cydyflag = phalocarr[1]; //��û��
    var dispstartdate = phalocarr[2]; //��ҩ��ʼ����
    var dispenddate = phalocarr[3]; //��ҩ��ֹ����
    var dispstarttime = phalocarr[4]; //��ҩ��ʼʱ��
    var dispendtime = phalocarr[5]; //��ҩ��ֹʱ��
    var cacustartdate = phalocarr[6]; //ͳ�ƿ�ʼ����
    var cacuenddate = phalocarr[7]; //ͳ�ƽ�ֹ����
    var cacustarttime = phalocarr[8]; //ͳ�ƿ�ʼʱ��
    var cacuendtime = phalocarr[9]; //ͳ�ƽ�ֹʱ��
    var nurseauditflag = phalocarr[10]; //��ʿ���
    var reserveflag = phalocarr[11]; //�����־
    var locdr = phalocarr[12]; //����id
    var locdesc = phalocarr[13]; //��������
    var finaldate = phalocarr[14];
    var dispnoprefix = phalocarr[15]; //����ǰ׺
    var dispnocount = phalocarr[16]; //������ˮ
    var chkdispuser = phalocarr[17]; //�Ƿ�¼�뷢ҩ��
    var resstartdate = phalocarr[18]; //�����ʼ����
    var resenddate = phalocarr[19]; //�����ֹ����
    var resallflag = phalocarr[20]; //ȫ�������־
    var chkoperater = phalocarr[21]; //�Ƿ�¼���ҩ��
    var billflag = phalocarr[22]; //�Ƿ����Ƿ��
    var disptypelocalflag = phalocarr[23]; //������ҩ����Ƿ�Ĭ��ȡ��������(�޷�)
    var emyflag = phalocarr[24]; //�Ƿ���ʾ�Ӽ�
    var defaultflag = phalocarr[25]; //Ĭ��ѡ��ҩ��� ԭ����˼�ǣ�������ҩ�б���ʾ��Ժ��ҩ20141218��Ϊ����; zhouyg
    var lsflag = phalocarr[26]; // ������ҩ��������ť��ѡ��һ
    var reqwardflag = phalocarr[27]; //������ҩ���뵥ֻ����д�������ѷ�ҩƷ
    var dispdefault = phalocarr[28]; //������ҩĬ����ʾֵ(0-����,1-����,2-��+����)
    var prtret = phalocarr[30]; //��ֹͣǩʱ�Զ���ҩ
    var sendmachine = phalocarr[31]; //��ҩ��
    var ordauditflag = phalocarr[32]; //ҩʦ���
    var dealordflag = phalocarr[33]; //��ҩǰҽ������
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
        //����ѡ���¼�
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
            { field: 'DispTypeDesc', title: '��ҩ���', editor: dispTypeEditor, width: 250 },
            {
                field: 'DispTypeDefault',
                title: 'Ĭ��',
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
                title: '��ֹ������ҩ',
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
