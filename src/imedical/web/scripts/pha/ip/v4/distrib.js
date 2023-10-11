/**
 * 住院药房 - 药品交接|物流交接|发药单交接
 * @author  yunhaibao
 * @date    2023-03-10
 */
$g('扫描时间');
$g('扫描人员');
var PHA_IP_DISTRIB = {
    WardFlag: session['LOGON.WARDID'] || '' !== '' ? 'Y' : 'N',
    DistribType: 'Send' // 病区接收为Recieve
};
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
            Query();
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
                // $('#conNo').val('').focus();
                $('#btnOk').click();
                event.preventDefault ? event.preventDefault() : (event.returnValue = false);
                break;
            case 117: // F6
                $('#btnClean').click();
                // $('#conUser').val('').focus();
                event.preventDefault ? event.preventDefault() : (event.returnValue = false);
                break;
            default:
                break;
        }
    });

    function InitGridDistrib() {
        var columns = [
            [
                {
                    field: 'propDesc',
                    title: '类型',
                    width: 100,
                    align: 'center',
                    formatter: function (value) {
                        return $g(value);
                    }
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
            exportXls: false,
            onLoadSuccess: function () {
                $('#gridDistrib').datagrid('loaded');
                if ($('#conUser').val() === '') {
                    $('#conUser').focus();
                }
            }
        };

        PHA.Grid('gridDistrib', dataGridOption);
    }
    function InitGridRecord() {
        var columns = [
            [
                {
                    field: 'record',
                    title: '值',
                    width: $('body > div.hisui-layout.layout > div.panel.layout-panel.layout-panel-center > div > div > div.panel.layout-panel.layout-panel-center').width()
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            toolbar: null,
            // scrollbarSize: 0,
            exportXls: false,
            pagination: true,
            pageList: [999],
            pageSize: 999,
            columns: columns,
            fitColumns: false,
            rownumbers: true
        };

        PHA.Grid('gridRecord', dataGridOption);
    }
    function Query() {
        var pJson = {
            no: $('#conNo').val(),
            loc: session['LOGON.CTLOCID']
        };

        $.cm(
            {
                ClassName: 'PHA.IP.Distrib.Api',
                MethodName: 'GetNoData',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                $('#gridDistrib').datagrid('loadData', retData);
                if (retData.length === 0) {
                    PHA.Popover({
                        msg: '单号错误, 不存在' + $('#conNo').val(),
                        type: 'alert'
                    });
                    $('#conNo').select().focus();
                }
            }
        );
    }

    function CheckIn() {
        var rows = $('#gridDistrib').datagrid('getRows');
        if (rows.length === 0) {
            PHA.Popover({
                msg: '请先扫描单据单号',
                type: 'info'
            });
            return;
        }
        var sendUserCode = $('#conUser').val().trim();
        if (sendUserCode === '') {
            PHA.Popover({
                msg: '请扫描或录入物流人员工号',
                type: 'info'
            });
            return;
        }
        var pJson = {
            no: rows[0].propVal,
            sendUserCode: sendUserCode,
            loc: session['LOGON.CTLOCID'],
            distribType: PHA_IP_DISTRIB.DistribType,
            user: session['LOGON.USERID']
        };

        $.cm(
            {
                ClassName: 'PHA.IP.Distrib.Api',
                MethodName: 'HandleDistrib',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                if (retData.code === 0) {
                    AddRecord();
                    PHA.Popover({
                        msg: '记录成功',
                        type: 'success'
                    });
                } else {
                    PHA.Popover({
                        msg: retData.msg,
                        type: 'alert'
                    });
                }
            }
        );
    }

    function AddRecord() {
        var htmlArr = [];
        htmlArr.push('<div class="pha-record-row">');
        var rows = $('#gridDistrib').datagrid('getRows');
        if (rows.length === 0) {
            return;
        }
        for (var i = 0, length = rows.length; i < length; i++) {
            var rowData = rows[i];
            htmlArr.push('<div>');
            htmlArr.push('  <span>' + $g(rowData.propDesc) + ':</span>');
            htmlArr.push('  <span class="pha-record-val">' + rowData.propVal + '</span>');
            htmlArr.push('</div>');
        }
        htmlArr.push('<div>');
        htmlArr.push('  <span>' + $g('扫描时间') + ': </span>');
        htmlArr.push('  <span class="pha-record-val">' + PHA_UTIL.GetDate() + ' ' + PHA_UTIL.GetTime() + '</span>');
        htmlArr.push('</div>');
        htmlArr.push('<div>');
        htmlArr.push('  <span>' + $g('扫描人员') + ': </span>');
        htmlArr.push('  <span class="pha-record-val">' + $('#conUser').val() + '</span>');
        htmlArr.push('</div>');

        htmlArr.push('<div style="clear:both;"></div>');
        htmlArr.push('</div>');
        $('#gridRecord').datagrid('appendRow', {
            record: htmlArr.join('')
        });
        $('#gridDistrib').datagrid('clear');
        $('#conNo').val('').focus();
    }

    // 清屏程序
    function CleanHandler() {
        $('#conUser').val('');
        $('#conNo').val('');
        $('#gridDistrib').datagrid('clear');
        $('#gridRecord').datagrid('clear');
        $('#conNo').focus();
    }
    setTimeout(function () {
        $('#conLoginInfo').val(session['LOGON.USERCODE'] + ' / ' + session['LOGON.USERNAME'] + ' / ' + session['LOGON.GROUPDESC']);
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 }); // 10(split宽度) + 2(border宽度和)
        $('.js-pha-layout-fit').layout('resize');
        $('#gridDistribBar > table > tbody > tr:last-child > td:nth-child(2) > div').width($('#gridDistribBar > table > tbody > tr:nth-child(3) > td:nth-child(2)').width() - 2);
        $('.dhcpha-win-mask').hide();
    }, 100);
});
