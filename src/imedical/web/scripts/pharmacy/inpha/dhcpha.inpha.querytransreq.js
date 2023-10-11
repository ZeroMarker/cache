/**
 * ģ��:     סԺ����ҩ����
 * ��д����: 2018-06-20
 * ��д��:   yunhaibao
 */
$g('δ���');
$g('����Һ����');
$g('�����鲹��');
$g('��������');
$g('δ���');
$g('�ѽ���');
$g('�ѳ���');
$g('���ֽ���');
$g('������˲�ͨ��');
$g('�ܾ�����');
$g('����ɵȴ�����');
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    InitDict();
    InitGridTransReq();
    InitGridTransReqItm();
    $('#btnFind').on('click', Query);

    $('#btnEdit').on('click', function () {
        EditReq();
    });
    $('#btnAddByDSY').on('click', function () {
        NewReq();
    });
    $('#btnAddByJSDM').on('click', function () {
        NewReqByConsume('JSDM');
    });
    $('#btnAddByBASE').on('click', function () {
        NewReqByConsume('BASE');
    });
    //window.resizeTo(screen.availWidth, (screen.availHeight));
});

function InitDict() {
    DHCPHA_HUI_COM.ComboBox.Init(
        { Id: 'cmbReqLoc', Type: 'CtLoc' },
        {
            onLoadSuccess: function () {
                $('#cmbReqLoc').combobox('setValue', SessionLoc);
                $('#cmbReqLoc').combobox('readonly');
            },
            width: 200
        }
    );
    DHCPHA_HUI_COM.ComboBox.Init(
        { Id: 'cmbProLoc', Type: 'CtLoc' },
        {
            width: 200,
            onBeforeLoad: function (param) {
                param.inputStr = 'D';
                param.filterText = param.q;
                param.hosp = session['LOGON.HOSPID'];
            }
        }
    );
    $('#dateStart').datebox('setValue', DHCPHA_TOOLS.Today());
    $('#dateEnd').datebox('setValue', DHCPHA_TOOLS.Today());
}
// ���뵥�б�
function InitGridTransReq() {
    var columns = [
        [
            { field: 'reqId', title: 'reqId', width: 200, halign: 'center', hidden: true },
            {
                field: 'reqStat',
                title: '״̬',
                width: 120,
                styler: function (value, row, index) {
                    value = value.replace('����', '');
                    if (value == 'δ���') {
                        return 'background-color:white;color:black;font-weight:normal;';
                    } else if (value == '����ɵȴ�����') {
                        return 'background-color:#e2ffde;color:#3c763d;font-weight:normal;';
                    } else if (value == '�ѳ���') {
                        return 'background-color:#e3f7ff;color:#1278b8;font-weight:normal;';
                    } else if (value == '�ѽ���') {
                        return 'background-color:#fff3dd;color:#ff7e00;font-weight:normal;';
                    } else if (value == '������˲�ͨ��') {
                        return 'background-color:#ffe3e3;color:#ff3d2c;font-weight:normal;';
                    }
                    return '';
                }
            },
            { field: 'proLocDesc', title: '��������', width: 150 },
            { field: 'reqNo', title: '���󵥺�', width: 150 },
            { field: 'reqUserName', title: '������', width: 75 },
            { field: 'reqDateTime', title: '����ʱ��', width: 150 },
            { field: 'reqTypeDesc', title: '��������', width: 100 },
            { field: 'fromDateTime', title: '��ʼʱ��', width: 150 },
            { field: 'toDateTime', title: '����ʱ��', width: 150 },
            { field: 'printFlag', title: '�Ѵ�ӡ', width: 60 },
            { field: 'printDateTime', title: '��ӡʱ��', width: 150 },
            { field: 'collUserName', title: '���������', width: 90 },
            { field: 'collDateTime', title: '�������ʱ��', width: 150 },
            { field: 'dispUserName', title: '���ղ�����', width: 90 },
            { field: 'dispDateTime', title: '���ղ���ʱ��', width: 150 },
            { field: 'reqLocDesc', title: '�������', width: 150 },
            { field: 'reqType', title: '��������Id', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: [],
        onSelect: function (rowIndex, rowData) {
            if (rowData) {
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if (rowData) {
                QueryDetail();
            }
        },
        onLoadSuccess: function () {
            // $("#gridTransReqItm").datagrid("clear");
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridTransReq', dataGridOption);
}
// ���뵥��ϸ�б�
function InitGridTransReqItm() {
    var columns = [
        [
            { field: 'reqItmId', title: 'reqItmId', width: 200, hidden: true },
            { field: 'incCode', title: 'ҩƷ����', width: 100 },
            { field: 'incDesc', title: 'ҩƷ����', width: 300 },
            { field: 'reqQty', title: '����', width: 75, align: 'right' },
            { field: 'reqUomDesc', title: '��λ', width: 100 }
        ]
    ];
    var dataGridOption = {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: [],
        onSelect: function (rowIndex, rowData) {},
        onUnselect: function (rowIndex, rowData) {},
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridTransReqItm', dataGridOption);
}
// ��ȡ����
function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var reqLocId = $('#cmbReqLoc').combobox('getValue');
    var proLocId = $('#cmbProLoc').combobox('getValue');
    return stDate + '^' + edDate + '^' + reqLocId + '^' + proLocId;
}
// ��ѯ
function Query() {
    var params = QueryParams();

    $('#gridTransReq').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.WardBaseDrug',
            QueryName: 'QueryTransReq',
            inputStr: params
        }
    });
}

// ��ѯ��ϸ
function QueryDetail() {
    var gridSelect = $('#gridTransReq').datagrid('getSelected');
    var reqId = gridSelect.reqId;
    $('#gridTransReqItm').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.WardBaseDrug',
            QueryName: 'QueryTransReqItm',
            inputStr: reqId
        }
    });
}

/// ���󵥱༭
function EditReq() {
    // �ж��Ƿ�Ϊ���״̬
    var ifFinish = '';
    if (ifFinish == 'Y') {
        $.messager.alert('��ʾ', '�������Ѿ����,�޷��༭', 'warning');
        return;
    }
    var gridSelect = $('#gridTransReq').datagrid('getSelected');
    if ((gridSelect == null) | (gridSelect == '')) {
        $.messager.alert('��ʾ', '����ѡ����Ҫ�༭������', 'warning');
        return;
    }
    var reqType = gridSelect.reqType || '';
    if (reqType == '2') {
        $.messager.alert('��ʾ', '�����鲹�����󵥲�����༭', 'warning');
        return;
    }
    var reqId = gridSelect.reqId;

    var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&Rowid=' + reqId;
    var lnk = 'dhcpha.inpha.hisui.createtransreq.csp?reqId=' + reqId;
    var editType = '';
    if (reqType == 3) {
        // ����Һ����
        var editType = 'ADD';
    }
    websys_createWindow(lnk, '���󵥱༭', 'width=95%,height=75%');
    //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-40)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=100,left=3") ;
}

// �µ�
function NewReq() {
    var lnk = 'dhcpha.inpha.hisui.createtransreq.csp?reqId=' + '' + '&reqType=3';
    websys_createWindow(lnk, '����', 'width=95%,height=75%');
    //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-40)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=100,left=3") ;
}

// ��������
function NewReqByConsume(type) {
    var reqType = '';
    if (type == 'JSDM') {
        reqType = 2;
    } else if ((type = 'BASE')) {
        reqType = 1;
    }
    if (reqType == '') {
        $.messager.alert('��ʾ', '�������޷��������Ĳ���', 'warning');
        return;
    }
    var lnk = 'dhcpha.inpha.hisui.createtransreqbyconsume.csp?reqType=' + reqType;
    websys_createWindow(lnk, '����', 'width=95%,height=75%');
    //window.open(lnk, "_blank", "width=1100,height=650,menubar=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
    //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-40)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=100,left=3") ;
}
