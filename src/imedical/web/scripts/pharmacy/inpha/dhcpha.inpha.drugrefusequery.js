/**
 * ģ��:סԺҩ��
 * ��ģ��:סԺҩ��ҩ��-�ܷ�ҩƷ��ѯ
 * createdate:2016-12-13
 * creator:xueshuaiyi
 */
var SessionWard = session['LOGON.WARDID'] || '';
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    //�������лس��¼�
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    InitPhaLoc();
    InitWard();
    InitDocLoc();
    InitRefuseList();
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patno = $.trim($('#txt-patno').val());
            if (patno != '') {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                if (newpatno != '') {
                    Query();
                }
            }
        }
    });
    /* �󶨰�ť�¼� start*/
    $('#btn-find').on('click', Query);
    $('#btn-cancelrefuse').on('click', BCancelRefuseHandler);
    /* �󶨰�ť�¼� end*/
    if (FromIconProfile == 1) {
        window.resizeTo(window.screen.availWidth * 0.85, window.screen.availHeight * 0.75);
        setTimeout(function () {
            var iTop = (window.screen.availHeight - $(window).height()) / 2;
            var iLeft = (window.screen.availWidth - $(window).width()) / 2;
            window.moveTo(iTop, iLeft);
            setTimeout(function () {
                ResizeRefuseQuery();
                Query();
            }, 500);
        }, 500);
    } else {
        ResizeRefuseQuery();
    }
});
window.onload = function () {
    if (EpisodeID != '') {
        var patinfo = tkMakeServerCall('web.DHCSTPharmacyCommon', 'GetPatInfoByAdm', EpisodeID);
        patinfo = JSON.parse(patinfo);
        patinfo = patinfo[0];
        $('#txt-patno').val(patinfo.PatNo);
        $('#txt-name').val(patinfo.PatName);
        $('#btn-cancelrefuse').css('display', 'none');
    }
    //Query();
};
//��ʼ������
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: true,
        placeholder: 'ҩ��...'
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == 'D') {
        var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
        $('#sel-phaloc').append(select2option);
    }
}
//��ʼ������
function InitWard() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetWardLocDs&style=select2',
        allowClear: true,
        width: 200,
        placeholder: '����...'
    };
    $('#sel-ward').dhcphaSelect(selectoption);
    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == 'W') {
        if (SessionWard != '') {
            var select2option = '<option value=' + "'" + SessionWard + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
            $('#sel-ward').append(select2option);
        }
    }
}
// ��ʼ��ҽ������
function InitDocLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetCtLocDs&style=select2&custtype=DocLoc',
        allowClear: true,
        placeholder: 'ҽ������...'
    };
    $('#sel-docloc').dhcphaSelect(selectoption);
    $('#sel-docloc').on('select2:select', function (event) {
        //alert(event)
    });
}
//��ʼ���ܷ�ҩ�б�
function InitRefuseList() {
    //����columns
    var columns = [
        [
            {
                field: 'TSelect',
                checkbox: true,
                title: ''
            },
            {
                field: 'TRegNo',
                title: '�ǼǺ�',
                width: 100,
                sortable: true
            },
            {
                field: 'TPaName',
                title: '��������',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TRecLocDesc',
                title: '��ҩ����',
                width: 120,
                align: 'left',
                sortable: true
            },
            {
                field: 'TWard',
                title: '����/ҽ������',
                width: 120,
                align: 'left',
                sortable: true
            },
            {
                field: 'TBed',
                title: '����',
                width: 80,
                align: 'left',
                sortable: true
            },
            {
                field: 'TCode',
                title: '����',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TDesc',
                title: '����',
                width: 180,
                align: 'left',
                sortable: true
            },
            {
                field: 'TQty',
                title: '����',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'TUom',
                title: '��λ',
                width: 80,
                align: 'center',
                sortable: true
            },
            {
                field: 'TUser',
                title: '�ܾ���',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TDate',
                title: '�ܾ�����',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TTime',
                title: '�ܾ�ʱ��',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TPriDesc',
                title: 'ҽ������',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TOrdStatus',
                title: 'ҽ����ǰ״̬',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TRefuseReason',
                title: '�ܾ�ԭ��',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TPrescno',
                title: '������',
                width: 110,
                align: 'left',
                sortable: true
            },
            {
                field: 'Toeori',
                title: 'ҽ��ID',
                width: 100,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TSttDate',
                title: 'ҽ����ʼ����',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TSttTime',
                title: 'ҽ����ʼʱ��',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TDateDosing',
                title: '��ҩ����',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TTimeDosing',
                title: '��ҩʱ��',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TEncryptLevel',
                title: '�����ܼ�',
                width: 100,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TPatLevel',
                title: '���˼���',
                width: 100,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TGeneric',
                title: 'ͨ����',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TBarcode',
                title: '���',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TForm',
                title: '����',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TManf',
                title: '����',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TPrice',
                title: '����',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TAmt',
                title: '���',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TOrdStatusCode',
                title: 'TOrdStatusCode',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'Toedis',
                title: 'Toedis',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TRecLocId',
                title: 'TRecLocId',
                width: 180,
                align: 'left',
                sortable: true,
                hidden: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        singleSelect: false,
        datatype: 'local'
    };
    //����datagrid
    $('#grid-disprefuse').dhcphaEasyUIGrid(dataGridOption);
}
///�ܷ�ҩƷ��ѯ
function Query() {
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = '';
    }
    if (SessionWard == '' && phaloc == '') {
        dhcphaMsgBox.alert('����ѡ��ҩ��');
        return;
    }
    var ward = $('#sel-ward').val() || '';

    var docLoc = $('#sel-docloc').val() || '';
    var patNo = $('#txt-patno').val();
    var patName = $('#txt-name').val();
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + ward + tmpSplit + patNo + tmpSplit + patName + tmpSplit + '' + tmpSplit + '' + tmpSplit + docLoc;
    $('#grid-disprefuse').datagrid({
        datatype: 'json',
        queryParams: {
            ClassName: 'web.DHCSTDRUGREFUSE',
            QueryName: 'DrugRefuse',
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });
}
//ȡ���ܷ�ҩ
function BCancelRefuseHandler() {
    var gridChecked = $('#grid-disprefuse').datagrid('getChecked');
    if (gridChecked == '') {
        dhcphaMsgBox.alert('����ѡ���¼');
        return;
    }
    dhcphaMsgBox.confirm('�Ƿ�ȡ���ܾ���ҩ?', function (retValue) {
        if (retValue == true) {
            var cLen = gridChecked.length;
            for (var cI = 0; cI < cLen; cI++) {
                var ordStatusCode = gridChecked[cI].TOrdStatusCode;
                if (ordStatusCode) {
                    var dspId = gridChecked[cI].Toedis;
                    if (dspId != '') {
                        if (deleteRefuse(dspId) == false) {
                            return;
                        }
                    }
                }
            }
            Query();
        }
    });
}

function deleteRefuse(oedis) {
    var cancelRet = tkMakeServerCall('web.DHCSTDRUGREFUSE', 'DeleteRefuse', '', '', oedis, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    if (cancelRet == '-2') {
        dhcphaMsgBox.alert('�ü�¼�Ѿ�����ִ�л�ִֹͣ�У�����ȡ���ܾ���');
        return false;
    } else if (cancelRet == '-3') {
        dhcphaMsgBox.alert('���޷������ܾ�,����ϵ�ܾ���ҩ��ҩ��!');
        return false;
    } else if (cancelRet < 0) {
        dhcphaMsgBox.alert('ȡ���ܾ�ʧ��!');
        return false;
    } else {
    }
    return true;
}
window.onresize = ResizeRefuseQuery;

function ResizeRefuseQuery() {
    $('#grid-disprefuse').closest('.panel-body').height(GridCanUseHeight(1));
    $('#grid-disprefuse').datagrid('resize');
}
