/**
 * 名称:	 住院药房 - 住院工作量补录
 * 编写人:	 yunhaibao
 * 编写日期: 2020-10-13
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
                title: '类型',
                width: 30,
                align: 'center'
            },
            {
                field: 'propVal',
                title: '值',
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
                title: '药品名称',
                width: 300
            },
            {
                field: 'spec',
                title: '规格',
                width: 150
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 200
            },
            {
                field: 'qty',
                title: '应发数量',
                align: 'right',
                width: 100
            },
            {
                field: 'resQty',
                title: '冲减数量',
                align: 'right',
                width: 100
            },
            {
                field: 'realQty',
                title: '实发数量',

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
            // 有数据给提示
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
        warnMsg = '请先查询出发药单';
    }
    var operateUser = $('#conOperateUser').combobox('getValue') || '';
    var collectUser = $('#conCollectUser').combobox('getValue') || '';
    if (operateUser === '' && collectUser === '') {
        warnMsg = '请选择【配药人】或【发药人】';
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
            msg: '该发药单不为您所登录的科室的单据, 无法确认',
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
            msg: '确认成功',
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
		        PHA.Alert('权限验证', '您没有权限操作补录', 'info');
		    }
	    }
    );	
}