/**
 * ����:	 סԺҩ�� - סԺ��������¼
 * ��д��:	 yunhaibao
 * ��д����: 2020-10-13
 */
var PHA_IP_DISPSCAN = {
    NoLen: 0
};
$(function () {
    InitDict();
    InitNoPre();
    InitGridPhac();
    InitGridPhacInci();
    $('#conPhacNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var fullNo = GetFullPhacNo($('#conPhacNo').val());
            $('#conPhacNo').val(fullNo);
            Query();
            $('#conPhacNo').val('');
        }
    });
    $('#btnOk').on('click', CheckIn);
    $('#btnClean').on('click', Clean);
    InitKeyDownHandler();
    CheckPermision();
});
function InitKeyDownHandler() {
    $(document).keydown(function (event) {
        if (event.keyCode == 115) {
            //F4
            Clean();
            event.preventDefault ? event.preventDefault() : (event.returnValue = false);
        }

        if (event.keyCode == 113) {
            //F2
            event.preventDefault ? event.preventDefault() : (event.returnValue = false);
            CheckIn();
        }
        if (event.keyCode == 117) {
            //F6
            event.preventDefault ? event.preventDefault() : (event.returnValue = false);
            $('#conPhacNo').val('').focus();
        }
    });
}

function InitDict() {
    PHA.ComboBox('conOperateUser', {
        url: PHA_STORE.SSUser(session['LOGON.CTLOCID']).url
    });
    PHA.ComboBox('conCollectUser', {
        url: PHA_STORE.SSUser(session['LOGON.CTLOCID']).url
    });
}
function InitNoPre() {
    $.cm(
        {
            ClassName: 'PHA.IP.DispScan.Query',
            MethodName: 'GetPhacNoData',
            loc: session['LOGON.CTLOCID']
        },
        function (data) {
            PHA_IP_DISPSCAN.NoLen = data.length;
            $('#conNoPre').val(data.pre);
        }
    );
}
function InitGridPhac() {
    var columns = [
        [
            {
                field: 'propDesc',
                title: '����',
                width: 30,
                align: 'center'
            },
            {
                field: 'propVal',
                title: 'ֵ',
                width: 70
            },
            { field: 'phac', title: 'phac', width: 30, align: 'center', hidden: true },
            { field: 'loc', title: 'loc', width: 30, align: 'center', hidden: true }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: true,
        toolbar: [],
        onLoadSuccess: function () {}
    };

    PHA.Grid('gridPhac', dataGridOption);
}
function InitGridPhacInci() {
    var columns = [
        [
            {
                field: 'phac',
                title: 'phac',
                width: 100,
                hidden: true
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 300
            },
            {
                field: 'spec',
                title: '���',
                width: 150
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 200
            },
            {
                field: 'qty',
                title: 'Ӧ������',
                align: 'right',
                width: 100
            },
            {
                field: 'resQty',
                title: '�������',
                align: 'right',
                width: 100
            },
            {
                field: 'realQty',
                title: 'ʵ������',

                align: 'right',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: true,
        pageList: [500, 1000],
        pageNumber: 1,
        pageSize: 500,
        columns: columns,
        fitColumns: false,
        toolbar: [],
        onLoadSuccess: function () {
            // �����ݸ���ʾ
            // $('#conBoxNo').val('');
            // $('#conUser').focus();
        }
    };

    PHA.Grid('gridPhacInci', dataGridOption);
}

function Query() {
    var phacNo = $('#conPhacNo').val().trim();
    var pJson = {
        phacNo: phacNo
    };
    $('#gridPhac').datagrid('options').url = $URL;
    $('#gridPhac').datagrid('query', {
        ClassName: 'PHA.IP.DispScan.Query',
        QueryName: 'PHACollected',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
    $('#gridPhacInci').datagrid('options').url = $URL;
    $('#gridPhacInci').datagrid('query', {
        ClassName: 'PHA.IP.DispScan.Query',
        QueryName: 'PHACollectedInci',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

function CheckIn() {
    var warnMsg = '';
    var rows = $('#gridPhac').datagrid('getRows');
    if (rows.length === 0) {
        warnMsg = '���Ȳ�ѯ����ҩ��';
    }
    var operateUser = $('#conOperateUser').combobox('getValue') || '';
    var collectUser = $('#conCollectUser').combobox('getValue') || '';
    if (operateUser === '' && collectUser === '') {
        warnMsg = '��ѡ����ҩ�ˡ��򡾷�ҩ�ˡ�';
    }
    if (warnMsg !== '') {
        PHA.Popover({
            msg: warnMsg,
            type: 'alert'
        });
        return;
    }
    if (rows[0].loc !== session['LOGON.CTLOCID']) {
        PHA.Popover({
            msg: '�÷�ҩ����Ϊ������¼�Ŀ��ҵĵ���, �޷�ȷ��',
            type: 'alert'
        });
        return;
    }
    var phac = rows[0].phac;
    var ret = $.cm(
        {
            ClassName: 'PHA.IP.DispScan.Save',
            MethodName: 'SaveHandler',
            phac: phac,
            operateUser: operateUser,
            collectUser: collectUser,
            logonStr: PHA_COM.Session.ALL,
            dataType: 'text'
        },
        false
    );
    var retArr = ret.split('^');
    if (retArr[0] < 0) {
        PHA.Popover({
            msg: retArr[1],
            type: 'alert'
        });
    } else {
        $('#gridPhac, #gridPhacInci').datagrid('clear');
        PHA.Popover({
            msg: 'ȷ�ϳɹ�',
            type: 'success'
        });      
    }
    $('#conPhacNo').focus();
}

function GetFullPhacNo(no) {
    if (PHA_IP_DISPSCAN.NoLen === 0) {
        return no;
    }

    var pre = $('#conNoPre').val();
    if (no.indexOf(pre) >= 0) {
        return no;
    }
    if (no.length > pre.length) {
        return no;
    }
    var noLen = no.length;
    var needLen = PHA_IP_DISPSCAN.NoLen - noLen;
    for (var i = 1; i <= needLen; i++) {
        no = '0' + no;
    }
    return pre + no;
}

function Clean() {
    InitNoPre();
    $('#conOperateUser, #conCollectUser').combobox('clear');
    $('#conPhacNo').val('');
    $('#gridPhac, #gridPhacInci').datagrid('clear');
}

function CheckPermision(){
  	$.cm(
        {
            ClassName: 'PHA.IP.DispScan.Save',
            MethodName: 'CheckPermision',
            logonStr: PHA_COM.Session.ALL,
            dataType: 'text'
        },
        function(ret){
		    if (ret.split('^')[0] < 0) {
		        PHA.Alert('Ȩ����֤', '��û��Ȩ�޲�����¼', 'info');
		    }
	    }
    );	
}