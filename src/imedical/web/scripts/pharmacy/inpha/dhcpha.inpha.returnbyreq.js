/*
 *ģ��:סԺҩ��
 *��ģ��:סԺҩ��-���뵥��ҩ
 *createdate:2016-08-30
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.VAR.RequestStatus = 'P';
DHCPHA_CONSTANT.VAR.requestIDStr = '';
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //ҩ������
    InitPhaWard(); //����
    InitGridReq();
    InitGridReqDetail();
    InitGridReqTotal();
    /* ��ʼ����� end*/
    /* ��Ԫ���¼� start*/
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patno = $.trim($('#txt-patno').val());
            if (patno != '') {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                var patoptions = {
                    id: '#dhcpha-patinfo',
                    gettype: 'patno',
                    input: newpatno
                };
                AppendPatientBasicInfo(patoptions);
            }
        }
    });
    //�������лس��¼�
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    /* ��Ԫ���¼� end*/

    /* �󶨰�ť�¼� start*/
    $('#chk-specloc').on('ifChanged', InitPhaWard);
    $('#btn-find').on('click', QueryRequest);
    $('#btn-return').on('click', DoReturn);
    $('#btn-clear').on('click', ClearCondition);
    /* �󶨰�ť�¼� end*/
    $('#grid-reqdetail').setGridWidth('');
    ResizeReturnByReq();
});

//��ʼ���뵥table
function InitGridReq() {
    var columns = [
        {
            header: '���뵥��',
            index: 'TReqNo',
            name: 'TReqNo',
            width: 230
        },
        {
            header: '��������',
            index: 'TReqDate',
            name: 'TReqDate',
            width: 90
        },
        {
            header: '����/�������',
            index: 'TWard',
            name: 'TWard',
            width: 100
        },
        {
            header: '������',
            index: 'TReqOper',
            name: 'TReqOper',
            width: 90
        }
    ];
    var jqOptions = {
        datatype: 'local',
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryReqListForReturn&style=jqGrid', //��ѯ��̨
        height: DhcphaJqGridHeight(1, 2) - 10,
        multiselect: true,
        pager: '#jqGridPager1', //��ҳ�ؼ���id
        emptyrecords: '',
        recordtext: '',
        onSelectRow: function (id, status) {
            var chkRowRet = CheckReqRowData(id);
            if (chkRowRet == false) {
                $('#grid-reqlist').jqGrid('setSelection', id, false);
                return;
            }
            QueryReqDetail();
        },
        onSelectAll: function (aRowids, status) {
            QueryReqDetail();
        }
    };
    $('#grid-reqlist').dhcphaJqGrid(jqOptions);
}

//��ʼҩƷ��ϸtable
function InitGridReqDetail() {
    var columns = [
        {
            name: 'TRegNo',
            index: 'TRegNo',
            header: '�ǼǺ�',
            width: 100
        },
        {
            name: 'TBedNo',
            index: 'TBedNo',
            header: '����',
            width: 80
        },
        {
            name: 'TName',
            index: 'TName',
            header: '����',
            width: 80
        },
        {
            name: 'TDesc',
            header: '����',
            width: 250,
            align: 'left'
        },
        {
            name: 'TUom',
            index: 'TDesc',
            header: '��λ',
            width: 75
        },
        {
            name: 'TRetQty',
            header: '��ҩ����',
            width: 80,
            align: 'right',
            editable: true,
            cellattr: addTextCellAttr
        },
        {
            name: 'TQty',
            header: '��������',
            width: 80
        },
        {
            name: 'TReturnqty',
            index: 'TQty',
            header: '��������',
            width: 80
        },
        {
            name: 'TSurqty',
            index: 'TSurqty',
            header: 'δ������',
            width: 80
        },
        {
            name: 'TReqDate',
            index: 'TReqDate',
            header: '��������',
            width: 90
        },
        {
            name: 'TReqTime',
            index: 'TReqTime',
            header: '����ʱ��',
            width: 75
        },
        {
            name: 'TStatus',
            index: 'TStatus',
            header: '״̬',
            width: 80,
            formatter: function (cellvalue, options, rowObject) {
                var status = rowObject.TReqStatus;
                var refundStatus = rowObject.TRefundStatus;
                var statusDiv = "<div style='background:white;color:black;padding-left:8px;border-bottom:1px dashed #cccccc;'>" + status + '</div>';
                if (status == '��ҩ���') {
                    statusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                } else if (status == '������ҩ') {
                    statusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;border-bottom:1px dashed #cccccc;">' + status + '</div>';
                }
                var refundStatusDiv = "<div style='background:white;color:black;padding-left:8px;'>" + refundStatus + '</div>';
                if (refundStatus == '�˷����') {
                    refundStatusDiv = '<div style="background:#e3f7ff;color:#1278b8;padding-left:8px;">' + refundStatus + '</div>';
                } else if (refundStatus == '�����˷�') {
                    refundStatusDiv = '<div style="background:#fff3dd;color:#ff7e00;padding-left:8px;">' + refundStatus + '</div>';
                }
                return '<div style="margin:0px -8px;font-weight:bold;">' + statusDiv + refundStatusDiv + '</div>';
            }
        },
        {
            name: 'TReqStatus',
            index: 'TReqStatus',
            header: '��ҩ״̬',
            width: 80,
            hidden: true
        },
        {
            name: 'TRefundStatus',
            index: 'TRefundStatus',
            header: '�˷�״̬',
            width: 80,
            hidden: true
        },
        {
            name: 'TRetReason',
            index: 'TRetReason',
            header: '��ҩԭ��',
            width: 80
        },
        {
            name: 'TPrescNo',
            index: 'TPrescNo',
            header: '������',
            width: 80
        },
        {
            name: 'TOECPRCode',
            index: 'TOECPRCode',
            header: 'ҽ�����ȼ�����',
            width: 90,
            hidden: true
        },
        {
            name: 'TEncryptLevel',
            index: 'TEncryptLevel',
            header: '�����ܼ�',
            width: 80
        },
        {
            name: 'TPatLevel',
            index: 'TPatLevel',
            header: '���˼���',
            width: 80
        },
        {
            name: 'Tpid',
            index: 'Tpid',
            header: 'Tpid',
            width: 60,
            hidden: true
        },
        {
            name: 'Tretrqrowid',
            index: 'Tretrqrowid',
            header: 'Tretrqrowid',
            width: 60,
            hidden: true
        },
        {
            name: 'TDEPTDR',
            index: 'TDEPTDR',
            header: 'TDEPTDR',
            width: 60,
            hidden: true
        },
        {
            name: 'TDodis',
            index: 'TDodis',
            header: 'TDodis',
            width: 60,
            hidden: true
        },
        {
            name: 'TBEDDR',
            index: 'TBEDDR',
            header: 'TBEDDR',
            width: 60,
            hidden: true
        },
        {
            name: 'TADMDR',
            index: 'TADMDR',
            header: 'TADMDR',
            width: 60,
            hidden: true
        },
        {
            name: 'TADMLOCDR',
            index: 'TADMLOCDR',
            header: 'TADMLOCDR',
            width: 60,
            hidden: true
        },
        {
            name: 'TRECLOCDR',
            index: 'TRECLOCDR',
            header: 'TRECLOCDR',
            width: 60,
            hidden: true
        },
        {
            name: 'TRetPartFlag',
            index: 'TRetPartFlag',
            header: 'TRetPartFlag',
            width: 60,
            hidden: true
        },
        {
            name: 'TCode',
            index: 'TCode',
            header: 'TCode',
            width: 60,
            hidden: true
        },
        {
            name: 'TCyFlag',
            index: 'TCyFlag',
            header: '��ҩ������־',
            width: 60,
            hidden: true
        },
        {
            name: 'TPivas',
            index: 'TPivas',
            header: '��Һ��־',
            width: 60,
            hidden: false
        },
        {
            name: 'TMDodis',
            index: 'TMDodis',
            header: '�����Id',
            width: 60,
            hidden: false
        }
    ];
    var jqOptions = {
        datatype: 'local',
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryReqDetail&style=jqGrid', //��ѯ��̨
        height: DhcphaJqGridHeight(2, 2) * 0.5,
        multiselect: true,
        shrinkToFit: false,
        rowNum: 9999,
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                QueryRequest();
                $('#grid-reqtotal').clearJqGrid();
            } else {
                var ids = $('#grid-reqdetail').getDataIDs();
                for (var k = 0; k < ids.length; k++) {
                    var curRowData = $('#grid-reqdetail').jqGrid('getRowData', ids[k]);
                    if (curRowData.TCyFlag == 'Y') {
                        $(this).jqGrid('setSelection', k + 1);
                    }
                }
                QueryReqTotal();
            }
            LastEditSel = '';
        },
        onSelectRow: function (id, status) {
            var iddata = $('#grid-reqdetail').jqGrid('getRowData', id);
            var prescyflag = iddata.TCyFlag;
            var pivasFlag = iddata.TPivas;
            if (prescyflag == 'Y') {
                var prescNo = iddata.TPrescNo;
                var rowIds = $('#grid-reqdetail').jqGrid('getDataIDs');
                for (var k = 0; k < rowIds.length; k++) {
                    var curRowData = $('#grid-reqdetail').jqGrid('getRowData', rowIds[k]);
                    var tmpPrescNo = curRowData['TPrescNo'];
                    var curChk = $('#' + rowIds[k] + '').find(':checkbox');
                    if (prescNo == tmpPrescNo && id != k + 1) {
                        $('#grid-reqdetail').jqGrid('setSelection', k + 1, false);
                    }
                }
                return;
            }
            if (pivasFlag == 'Y') {
                var mDodis = iddata.TMDodis;
                var rowIds = $('#grid-reqdetail').jqGrid('getDataIDs');
                for (var k = 0; k < rowIds.length; k++) {
                    var curRowData = $('#grid-reqdetail').jqGrid('getRowData', rowIds[k]);
                    var tmpMDodis = curRowData['TMDodis'];
                    var curChk = $('#' + rowIds[k] + '').find(':checkbox');
                    if (mDodis == tmpMDodis && id != k + 1) {
                        $('#grid-reqdetail').jqGrid('setSelection', k + 1, false);
                    }
                }
                return;
            }
            if (JqGridCanEdit == false && LastEditSel != '' && LastEditSel != id) {
                $('#grid-reqdetail').jqGrid('setSelection', LastEditSel);
                return;
            }
            if (LastEditSel != '' && LastEditSel != id) {
                $(this).jqGrid('saveRow', LastEditSel);
            }
            $(this).jqGrid('editRow', id, {
                oneditfunc: function () {
                    $editinput = $(event.target).find('input');
                    $editinput.focus();
                    $editinput.select();
                    $editinput.unbind().on('keyup', function (e) {
                        $editinput.val(ParseToNum($editinput.val()));
                    });
                    $('#' + id + '_TRetQty').on('focusout || mouseout', function () {
                        var iddata = $('#grid-reqdetail').jqGrid('getRowData', id);
                        var retpartflag = iddata.TRetPartFlag;
                        var reqstatus = iddata.TReqStatus;
                        var refundstatus = iddata.TRefundStatus;
                        var surqty = iddata.TSurqty;
                        if (retpartflag == '0') {
                            dhcphaMsgBox.message('��' + id + '�д��ڸ���ҽ����Ŀ,�������޸���ҩ����!');
                            $('#grid-reqdetail').jqGrid('restoreRow', id);
                            JqGridCanEdit = true; // restore ��,ӦΪ������༭״̬
                            return false;
                        }
                        if (parseFloat(this.value * 1000) > parseFloat(surqty * 1000)) {
                            dhcphaMsgBox.message('��' + id + '����ҩ��������δ������!');
                            $('#grid-reqdetail').jqGrid('restoreRow', id);
                            JqGridCanEdit = true;
                            return false;
                        }
                        if (this.value.toString().indexOf('.') >= 0) {
                            // ��С���Ĵ���,��������С������дС��
                            if (surqty.toString().indexOf('.') < 0) {
                                dhcphaMsgBox.message('��' + id + '����ҩ��������ΪС��!');
                                $('#grid-reqdetail').jqGrid('restoreRow', id);
                                JqGridCanEdit = true;
                                return false;
                            }
                        }
                        /*
                        if (reqstatus=="������ҩ"&&refundstatus=="�˷����"){
                        	dhcphaMsgBox.message("��"+id+"���Ѿ���ǰ�˷�,�������޸���ҩ����!")
                        	$("#grid-reqdetail").jqGrid('restoreRow',id);
                        	JqGridCanEdit=false
                        	return false;
                        }
                        */
                        //$("#grid-reqdetail").jqGrid('saveRow', id);
                        JqGridCanEdit = true;
                        return true;
                    });
                }
            });
            LastEditSel = id;
        }
    };
    $('#grid-reqdetail').dhcphaJqGrid(jqOptions);
    PhaGridFocusOut('grid-reqdetail');
}
//��ʼ��Ʒ����table
function InitGridReqTotal() {
    var columns = [
        {
            name: 'Tdesc',
            index: 'Tdesc',
            header: 'ҩƷ����',
            width: 250,
            align: 'left'
        },
        {
            name: 'Tuom',
            index: 'Tuom',
            header: '��λ',
            width: 75
        },
        {
            name: 'Treqqty',
            index: 'Treqqty',
            header: '��������',
            width: 80
        },
        {
            name: 'Treturnedqty',
            index: 'Treturnedqty',
            header: '��������',
            width: 80
        },
        {
            name: 'TSurqty',
            index: 'TSurqty',
            header: 'δ������',
            width: 80
        },
        {
            name: 'Tform',
            index: 'Tform',
            header: '����',
            width: 100
        },
        {
            name: 'Tmanf',
            index: 'Tmanf',
            header: '����',
            width: 150
        },
        {
            name: 'Tprice',
            index: 'Tprice',
            header: '����',
            width: 100,
            align: 'right'
        },
        {
            name: 'Tamount',
            index: 'Tamount',
            header: '���',
            width: 100,
            align: 'right'
        }
    ];
    var jqOptions = {
        datatype: 'local',
        rowNum: 9999,
        colModel: columns, //��
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryReqTotal&style=jqGrid', //��ѯ��̨
        height: DhcphaJqGridHeight(2, 2) * 0.5 - 3,
        multiselect: false
    };
    $('#grid-reqtotal').dhcphaJqGrid(jqOptions);
}

function InitPhaLoc() {
    var selectoption = {
        allowClear: false,
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
    $('#sel-phaloc').append(select2option);
    $('#sel-phaloc').on('select2:select', function (event) {
        InitPhaWard();
    });
}

function InitPhaWard() {
    if ($('#chk-specloc').is(':checked')) {
        var selectloc = $('#sel-phaloc').val();
        var params = selectloc + '^' + '1';
        var selectoption = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetWardListByDocFlag&style=select2&params=' + params,
            placeholder: '�������...'
        };
    } else {
        var selectoption = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetWardListByDocFlag&style=select2',
            placeholder: '����...'
        };
    }
    $('#sel-phaward').val('');
    $('#sel-phaward').dhcphaSelect(selectoption);
}
//��ѯ���뵥�б�
function QueryRequest() {
    var params = GetRequestParams();
    $('#grid-reqlist')
        .setGridParam({
            datatype: 'json',
            postData: {
                params: params
            }
        })
        .trigger('reloadGrid');
    $('#grid-reqdetail').clearJqGrid();
    $('#grid-reqtotal').clearJqGrid();
}

//��ȡ����
function GetRequestParams() {
    var phaloc = $('#sel-phaloc').val();
    var phaward = $('#sel-phaward').val();
    if (phaward == null) {
        phaward = '';
    }
    var daterange = $('#date-start').val() + '^' + $('#date-end').val();
    var speclocflag = '';
    if ($('#chk-specloc').is(':checked')) {
        speclocflag = 1;
    }
    var patno = $('#txt-patno').val();
    var advrefundflag = '';
    if ($('#chk-advrefund').is(':checked')) {
        advrefundflag = 'Y';
    }
    var params = daterange + '^' + phaloc + '^' + phaward + '^' + patno + '^' + speclocflag + '^' + DHCPHA_CONSTANT.VAR.RequestStatus + '^' + advrefundflag;
    return params;
}
//��ѯ���뵥ҩƷ��ϸ
function QueryReqDetail() {
    var params = '';
    var selectids = $('#grid-reqlist').jqGrid('getGridParam', 'selarrrow');
    $.each(selectids, function () {
        var rowdata = $('#grid-reqlist').jqGrid('getRowData', this);
        var reqno = rowdata.TReqNo;
        if (params == '') {
            params = reqno;
        } else {
            params = params + '^' + reqno;
        }
    });
    $('#grid-reqdetail')
        .setGridParam({
            datatype: 'json',
            postData: {
                params: params
            }
        })
        .trigger('reloadGrid');
    JqGridCanEdit = true;
}
//��ѯ���뵥��Ʒ����
function QueryReqTotal() {
    var firstrowdata = $('#grid-reqdetail').jqGrid('getRowData', 1); //��ȡ��һ������
    var params = firstrowdata.Tpid;
    $('#grid-reqtotal')
        .setGridParam({
            datatype: 'json',
            postData: {
                params: params
            }
        })
        .trigger('reloadGrid');
}
//ִ����ҩ
function DoReturn() {
    if (DhcphaGridIsEmpty('#grid-reqdetail') == true) {
        return;
    }
    var selectids = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
    if (selectids == '' || selectids == null) {
        dhcphaMsgBox.alert('����ѡ����Ҫ��ҩ�ļ�¼');
        return;
    }
    dhcphaMsgBox.confirm('�Ƿ�ȷ����ҩ?', ConfirmReturn);
}

function ConfirmReturn(result) {
    if (result == true) {
        ExecuteReturn();
    } else {
        return;
    }
}

function ExecuteReturn() {
    var selectids = $('#grid-reqdetail').jqGrid('getGridParam', 'selarrrow');
    var canpass = 0;
    (canpassi = 0), (returnstr = '');
    $.each(selectids, function () {
        var rowdata = $('#grid-reqdetail').jqGrid('getRowData', this);
        if (CheckOneRowData(this) == false) {
            canpass = 1;
            return false;
        }
        var retqty = $.trim(rowdata['TRetQty']);
        var surqty = $.trim(rowdata['TSurQty']);
        var reqitmrowid = $.trim(rowdata['Tretrqrowid']); //�����ӱ�id
        if (retqty == '') {
            dhcphaMsgBox.alert('��' + this + '������������Ϊ��!');
            canpass = 1;
            return false;
        }
        if (retqty == 0) {
            dhcphaMsgBox.alert('��' + this + '������������Ϊ0!');
            canpass = 1;
            return false;
        }
        var tmpreturndata = reqitmrowid + '^' + retqty;
        if (returnstr == '') {
            returnstr = tmpreturndata;
        } else {
            returnstr = returnstr + ',' + tmpreturndata;
        }
    });
    if (canpass != 0) {
        return;
    }
    if (returnstr == '') {
        dhcphaMsgBox.alert('�빴ѡ��Ҫ��ҩ������!');
        return;
    }
    var firstrowdata = $('#grid-reqdetail').jqGrid('getRowData', 1);
    var reclocdr = firstrowdata['TRECLOCDR'];
    if (reclocdr == '') {
        dhcphaMsgBox.alert('ҽ�����տ���Ϊ��!');
        return;
    }
    var executeret = tkMakeServerCall('web.DHCSTPHARETURN', 'ExecReturnByReq', '', '', reclocdr, DHCPHA_CONSTANT.SESSION.GUSER_ROWID, 'RT', returnstr);
    var retarr = executeret.split(',');
    var retID = '';
    if (retarr[0] == 'failure') {
        if (retarr[1] == -3) {
            dhcphaMsgBox.alert('��������ҩ:��ҩ����������ҩ����,��δ��ҩ');
        } else if (retarr[1] == -2) {
            dhcphaMsgBox.alert('���������¼�Ѿ���ҩ��ܾ���ҩ!');
        } else if (retarr[1] == -4) {
            dhcphaMsgBox.alert('���������ս���,��������ҩ,����ϵ���㴦');
        } else if (retarr[1] == -5) {
            dhcphaMsgBox.alert('������ҩ��ϸʧ��,�������:' + retarr[1], 'error');
        } else if (retarr[1] == -6) {
            dhcphaMsgBox.alert('�������뵥״̬ʧ��,�������:' + retarr[1], 'error');
        } else if (retarr[1] == -7) {
            dhcphaMsgBox.alert('�����ҩ��ʧ��,�������:' + retarr[1]);
        } else if (retarr[1] == -10) {
            dhcphaMsgBox.alert('�и����շ���Ŀִ�м�¼����������ҩ');
        } else if (retarr[1] == -11) {
            dhcphaMsgBox.alert('��������ҩ:�Ѿ���;����,������ҩ!');
        } else if (retarr[1] != 0) {
            dhcphaMsgBox.alert('��ҩʧ��,�������:' + retarr[1], 'info');
        }
        return;
    } else {
        retID = retarr[1];
        QueryReqDetail();
        DHCPHA_CONSTANT.VAR.requestIDStr = retID;
        dhcphaMsgBox.confirm('��ҩ�ɹ�!�Ƿ��ӡ?', ConfirmReturnPrint);
    }
}

function ConfirmReturnPrint(result) {
    if (result == true) {
        PrintReturnCom(DHCPHA_CONSTANT.VAR.requestIDStr, '');
    }
    DHCPHA_CONSTANT.VAR.requestIDStr = '';
}
//��֤�������ݺϷ�
function CheckOneRowData(rowid) {
    var selecteddata = $('#grid-reqdetail').jqGrid('getRowData', rowid);
    var retpartflag = selecteddata['TRetPartFlag'];
    var retqty = selecteddata['TRetQty'];
    var surqty = selecteddata['TSurqty'];
    var incicode = selecteddata['TCode'];
    var diffqty = parseFloat(retqty) - parseFloat(surqty);
    if (retpartflag == '0') {
        dhcphaMsgBox.alert('��' + rowid + '�м�¼�и����շ���Ŀ���������޸���ҩ����!');
        return false;
    } else if (retqty < 0) {
        dhcphaMsgBox.alert('��' + rowid + '����ҩ����������Ϊ����!');
        return false;
    } else if (parseFloat(diffqty) > 0) {
        dhcphaMsgBox.alert('��' + rowid + '����ҩ�������ܴ���δ������!');
        return false;
    } else if (isNaN(retqty)) {
        dhcphaMsgBox.alert('��' + rowid + '����ҩ����ӦΪ����!');
        return false;
    }
    var refrefuseflag = tkMakeServerCall('web.DHCST.ARCALIAS', 'GetRefReasonByCode', incicode);
    if (refrefuseflag != '') {
        if (refrefuseflag.split('^')[3] != '') {
            dhcphaMsgBox.alert('��' + rowid + '��ҩƷ' + refrefuseflag.split('^')[1] + ',��ҩƷ����������ĿǰΪ������ҩ״̬,��������!</br>������ҩԭ��:' + refrefuseflag.split('^')[3]);
            return false;
        }
    }
    return true;
}

//��֤����¼�Ƿ�Ϸ�
function CheckReqRowData(rowId) {
    var selectIds = $('#grid-reqlist').jqGrid('getGridParam', 'selarrrow');
    if (selectIds != '') {
        var idData = $('#grid-reqlist').jqGrid('getRowData', rowId);
        var idWard = idData.TWard;
        for (var i = 0; i < selectIds.length; i++) {
            var selectId = selectIds[i];
            var rowData = $('#grid-reqlist').jqGrid('getRowData', selectId);
            var rowWard = rowData.TWard;
            if (idWard != rowWard) {
                dhcphaMsgBox.alert('��ѡ����ͬ����������ҩ!', 'warning');
                return false;
            }
        }
    }
    return true;
}

function ClearCondition() {
    InitPhaLoc();
    $('#txt-patno').val('');
    if ($('#patInfo')) {
        $('#patInfo').remove();
    }
    $('#sel-phaward').empty();
    $('#chk-specloc').iCheck('uncheck');
    $('#chk-advrefund').iCheck('uncheck');
    $('#date-start').data('daterangepicker').setStartDate(new Date());
    $('#date-start').data('daterangepicker').setEndDate(new Date());
    $('#date-end').data('daterangepicker').setStartDate(new Date());
    $('#date-end').data('daterangepicker').setEndDate(new Date());
    $('#grid-reqlist').clearJqGrid();
    $('#grid-reqdetail').clearJqGrid();
    $('#grid-reqtotal').clearJqGrid();
    JqGridCanEdit = true;
}

function PhaGridFocusOut(gridid) {
    $('#' + gridid).on('mouseleave', function (e) {
        if (e.relatedTarget) {
            var $related = $('#' + gridid).find(e.relatedTarget);
            if ($related.length <= 0 && LastEditSel != '') {
                $('#' + gridid).jqGrid('saveRow', LastEditSel);
            }
        }
    });
}

window.onresize = ResizeReturnByReq;
function ResizeReturnByReq() {
    var wardtitleheight = $('#gview_grid-reqlist .ui-jqgrid-hbox').height();
    var wardheight = DhcphaJqGridHeight(1, 1) - wardtitleheight; //+32
    var reqdetailheight = DhcphaJqGridHeight(2, 2) / 2; //+ 17
    $('#grid-reqlist').setGridHeight(wardheight).setGridWidth('');
    $('#grid-reqdetail').setGridHeight(reqdetailheight).setGridWidth('');
    $('#grid-reqtotal').setGridHeight(reqdetailheight).setGridWidth('');
}
