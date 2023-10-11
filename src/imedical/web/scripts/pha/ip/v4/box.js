/**
 * 名称:	 住院移动药房-物流箱交接
 * 编写人:	 yunhaibao
 * 编写日期: 2020-03-14
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
                title: '物流箱ID',
                width: 100,
                hidden: true
            },
            {
                field: 'no',
                title: '物流箱号',
                width: 200
            },
            {
                field: 'num',
                title: '物流箱数',
                width: 75
            },
            {
                field: 'phUserName',
                title: '药房交接人',
                width: 100
            },
            {
                field: 'phDateTime',
                title: '药房交接时间',
                width: 155
            },
            {
                field: 'logisticsUserName',
                title: '物流人员',
                width: 100
            },
            {
                field: 'wardUserName',
                title: '病区交接人',
                width: 100
            },
            {
                field: 'wardDateTime',
                title: '病区交接时间',
                width: 155
            },
            {
                field: 'wardChkUserName',
                title: '病区核对人',
                width: 100
            },
            {
                field: 'wardChkDateTime',
                title: '病区核对时间',
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
            msg: '明细无数据',
            type: 'alert'
        });
        return;
    }
    var userCode = $('#conUser').val().trim();
    if (userCode === '') {
        PHA.Popover({
            msg: '请扫描或录入工号,回车操作',
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
            msg: '签收成功',
            type: 'success'
        });
        $('#conUser').val('');
        $('#conBoxNo').val('').focus();
    }
}
