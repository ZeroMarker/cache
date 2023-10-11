/**
 * 名称:     住院配液 - 物流交接
 * 编写人:	 yunhaibao
 * 编写日期: 2021-04-25
 * DISTYPE: 登录用户为护士则为物流接收
 */
var DISSTATUS = (session['LOGON.WARDID'] || '') !== '' ? 70 : 60;
$(function () {
    InitGridDistrib();
    InitGridRecord();
    $('#btnClean').click(function () {
        $.messager.confirm('温馨提示', '您确认清屏吗?', function (r) {
            if (r) {
                CleanHandler();
            }
        });
    });
    $('#btnOk').click(function () {
        CheckIn();
    });
    $('#conNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $('#conUser').val('');
            Query();
            $('#conUser').focus();
        }
    });
    $('#conUser').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            CheckIn();
        }
    });
    $('#gridRecord').parent().find('.datagrid-header').hide();
    $('#conNo').focus();
    $(document).keydown(function (event) {
        switch (event.keyCode) {
            case 115: // F4
                $('#conNo').val('').focus();
                event.preventDefault ? event.preventDefault() : (event.returnValue = false);
                break;
            case 117: // F6
                $('#conUser').val('').focus();
                event.preventDefault ? event.preventDefault() : (event.returnValue = false);
                break;
            default:
                break;
        }
    });
    $('#conLoginInfo').val(session['LOGON.USERCODE'] + ' / ' + PIVAS_SESSION.USERNAME + ' / ' + PIVAS_SESSION.GROUPDESC);
    setTimeout(function () {
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 }); // 10(split宽度) + 2(border宽度和)
        $('.js-pha-layout-fit').layout('resize');
        $('#gridDistribBar > table > tbody > tr:last-child > td:nth-child(2) > div').width($('#gridDistribBar > table > tbody > tr:nth-child(3) > td:nth-child(2)').width() - 2);
        $('.dhcpha-win-mask').hide();
    }, 100);
});

function InitGridDistrib() {
    var columns = [
        [
            {
                field: 'propDesc',
                title: '类型',
                width: 100,
                align: 'center'
            },
            {
                field: 'propVal',
                title: '值',
                width: 300
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        scrollbarSize: 0,
        pagination: false,
        columns: columns,
        fitColumns: true,
        toolbar: '#gridDistribBar',
        onLoadSuccess: function () {
            // $('#conUser').focus();
        }
    };

    DHCPHA_HUI_COM.Grid.Init('gridDistrib', dataGridOption);
}
function InitGridRecord() {
    var columns = [
        [
            {
                field: 'record',
                title: '值',
                width: 400
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        scrollbarSize: 0,
        pagination: true,
        pageList: [999],
        pageSize: 999,
        columns: columns,
        fitColumns: true,
        rownumbers: true
    };

    DHCPHA_HUI_COM.Grid.Init('gridRecord', dataGridOption);
}
function Query() {
    var pJson = {
        distribNo: $('#conNo').val(),
        loc: session['LOGON.CTLOCID']
    };
    $('#gridDistrib').datagrid('options').url = $URL;
    $('#gridDistrib').datagrid('query', {
        ClassName: 'web.DHCSTPIVAS.Distrib',
        QueryName: 'DistribData',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

function CheckIn() {
    var rows = $('#gridDistrib').datagrid('getRows');
    if (rows.length === 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '明细无数据',
            type: 'alert'
        });
        return;
    }
    var userCode = $('#conUser').val().trim();
    if (userCode === '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请扫描或录入工号,回车操作',
            type: 'alert'
        });
        return;
    }
    var pJson = {
        distribNo: rows[0].pogsNo,
        userCode: userCode,
        loc: session['LOGON.CTLOCID'],
        stat: DISSTATUS,
        user: session['LOGON.USERID']
    };

    var saveRet = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Distrib',
            MethodName: 'SaveHandler',
            dataStr: JSON.stringify(pJson),
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $got(saveInfo),
            type: 'alert'
        });
        return;
    }
    AddRecord(rows[0].pogsNo);
}

function AddRecord(distribNo) {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Distrib',
            MethodName: 'GetRowData',
            pJsonStr: JSON.stringify({ distribNo: distribNo })
        },
        function (data) {
            var htmlArr = [];
            htmlArr.push('<div class="pha-record-row">');
            htmlArr.push('  <div class="pha-record-title" >');
            htmlArr.push('      <div style="margin-left:5px;">' + data.noDesc + ': ' + data.no + '</div>');
            htmlArr.push('      <div>' + data.phbLogUserDesc + ': ' + data.phbLogUser + '</div>');
            htmlArr.push('      <div>' + data.phbDateTimeDesc + ': ' + data.phbDateTime + '</div>');
            htmlArr.push('      <div>' + data.phbPhUserNameDesc + ': ' + data.phbPhUserName + '</div>');
            if (data.phbWardUserName) {
                htmlArr.push('      <div>' + data.phbWardUserNameDesc + ': ' + data.phbWardUserName + '</div>');
                htmlArr.push('      <div>' + data.phbWardHandDateTimeDesc + ': ' + data.phbWardHandDateTime + '</div>');
            }
            htmlArr.push('      <div style="clear:both"></div>');
            htmlArr.push('  </div>');
            htmlArr.push('      <div style="clear:both"></div>');
            htmlArr.push('  <div style="margin-left:5px;">' + data.wardBatStrDesc + ': ' + data.wardBatStr + '</div>');
            htmlArr.push('</div>');
            var rowData = {
                record: htmlArr.join('')
            };
            $('#gridRecord').datagrid('appendRow', rowData);
            $('#gridDistrib').datagrid('clear');
            $('#conUser,#conNo').val('');
            $('#conNo').focus();
        }
    );
}

// 清屏程序
function CleanHandler() {
    $('#conUser').val('');
    $('#conNo').val('');
    $('#gridDistrib').datagrid('clear');
    $('#gridRecord').datagrid('clear');
    $('#conNo').focus();
}
