/**
 * ����:	 סԺ�ƶ�ҩ��-�����佻��
 * ��д��:	 yunhaibao
 * ��д����: 2020-03-14
 */
var PHA_IP_BOX = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N'
};
$(function () {
    InitGridBox();
    $('#conBoxNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $('#conUser').val('');
            Query();
        }
    });
    $('#conUser').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            CheckIn();
        }
    });
});

function InitGridBox() {
    var columns = [
        [
            {
                field: 'phb',
                title: '������ID',
                width: 100,
                hidden: true
            },
            {
                field: 'no',
                title: '�������',
                width: 200
            },
            {
                field: 'num',
                title: '��������',
                width: 75
            },
            {
                field: 'phUserName',
                title: 'ҩ��������',
                width: 100
            },
            {
                field: 'phDateTime',
                title: 'ҩ������ʱ��',
                width: 155
            },
            {
                field: 'logisticsUserName',
                title: '������Ա',
                width: 100
            },
            {
                field: 'wardUserName',
                title: '����������',
                width: 100
            },
            {
                field: 'wardDateTime',
                title: '��������ʱ��',
                width: 155
            },
            {
                field: 'wardChkUserName',
                title: '�����˶���',
                width: 100
            },
            {
                field: 'wardChkDateTime',
                title: '�����˶�ʱ��',
                width: 155
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridBoxBar',
        onLoadSuccess: function () {
            $('#conBoxNo').val('');
            $('#conUser').focus();
        }
    };

    PHA.Grid('gridBox', dataGridOption);
}

function Query() {
    var boxNo = $('#conBoxNo').val().trim();

    var ret = $.cm(
        {
            ClassName: 'PHA.IP.Box.Query',
            MethodName: 'CheckScan',
            boxNo: boxNo,
            loc: session['LOGON.CTLOCID'],
            wardFlag: PHA_IP_BOX.WardFlag,
            dataType: 'text'
        },
        false
    );
    if (ret.split('^')[0] < 0) {
        PHA.Popover({
            msg: ret.split('^')[1],
            type: 'alert'
        });
        $('#conBoxNo').val('').focus();
        //return;
    }

    $('#gridBox').datagrid('options').url = $URL;
    $('#gridBox').datagrid('query', {
        ClassName: 'PHA.IP.Box.Query',
        QueryName: 'PHBox',
        boxNo: boxNo,
        rows: 999
    });
}

function CheckIn() {
    var rows = $('#gridBox').datagrid('getRows');
    if (rows.length === 0) {
        PHA.Popover({
            msg: '��ϸ������',
            type: 'alert'
        });
        return;
    }
    var userCode = $('#conUser').val().trim();
    if (userCode === '') {
        PHA.Popover({
            msg: '��ɨ���¼�빤��,�س�����',
            type: 'alert'
        });
        return;
    }
    var phb = rows[0].phb;
    var pJson = {
        phb: phb,
        userCode: userCode
    };
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.Box.Save',
            pMethodName: 'UpdateHandler',
            pJsonStr: JSON.stringify([pJson])
        },
        false
    );
    if (retJson.success === 'N') {
        // var msg = PHAIP_COM.DataApi.Msg(retJson);
        var msg = retJson.message;
        PHA.Popover({
            msg: msg,
            type: 'alert'
        });
    } else {
        PHA.Popover({
            msg: 'ǩ�ճɹ�',
            type: 'success'
        });
        $('#conUser').val('');
        $('#conBoxNo').val('').focus();
    }
}
