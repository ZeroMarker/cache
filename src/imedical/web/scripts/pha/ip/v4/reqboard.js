/*
 * ����ҩ�����б�
 * pha.ip.v4.reqboard.csp
 * pha/ip/v4/reqboard.js
 */

function LoadConfig() {
    return {
        Params: $.cm(
            {
                ClassName: 'PHA.IP.ReqBoard.Query',
                MethodName: 'GetAppParams',
                loc: session['LOGON.CTLOCID']
            },
            false
        ),
        PHAIPReqType: $.cm(
            {
                ClassName: 'PHA.IP.ReqBoard.Query',
                QueryName: 'PHAIPReqType',
                pLoc: session['LOGON.CTLOCID']
            },
            false
        ),
        Dialog: {
            width: $(window).width() * 0.91,
            height: $(window).height() * 0.91
        },
        NeedTerminate: true
    };
}
var PHA_IP_REQBOARD = LoadConfig();

$(function () {
    InitPageNav();
    InitWardPage();
    InitGridPhReqItm();
    InitDialogStyle();
    InitGridPhReq();

    $('.pha-mob-ward').on('click', function (e) {
        $('.pha-mob-ward').removeClass('pha-ward-select');
        $(e.target).closest('.pha-mob-ward').addClass('pha-ward-select');
        var wardLocTarget = $(e.target).closest('.pha-mob-ward');
        ShowDiagPhReq();
    });
    var startDate = PHA_UTIL.GetDate('t-' + PHA_IP_REQBOARD.Params.wardReqDays);
    var endDate = PHA_UTIL.GetDate('t');
    $('#conStartDate').datebox('setValue', startDate);
    $('#conEndDate').datebox('setValue', endDate);
    $('#btnFindPhReq').on('click', QueryPhReq);
    $('#btnConnectPhReq').on('click', ConnectPhReq);
    $('#btnConnectPhReqSend').on('click', ConnectPhReqSend);
    if ($('#btnPrintAll').length > 0) {
        $('#btnPrintAll').on('click', PrintAll);
    }

    // $('#conStartPrev').on('click',function(){
    // ����ǰ��ѡ��
    // });

    // ��ʱˢ��
    var intervalSeconds = PHA_IP_REQBOARD.Params.refreshTime;
    setInterval(function () {
        if (PHA_IP_REQBOARD.NeedTerminate === true) {
            return;
        }
        var diagShow = $('#diagPhReq').parent().css('display');
        if (diagShow === 'none') {
            Query();
        }

        PHA_IP_REQBOARD = LoadConfig();
        var startDate = PHA_UTIL.GetDate('t-' + PHA_IP_REQBOARD.Params.wardReqDays);
        var endDate = PHA_UTIL.GetDate('t');
        $('#conStartDate').datebox('setValue', startDate);
        $('#conEndDate').datebox('setValue', endDate);
    }, intervalSeconds);
    Query();
    RefreshTime();
});

function RefreshTime() {
    setInterval(function () {
        var curNow = new Date();
        var week;
        switch (curNow.getDay()) {
            case 1:
                week = $g('����һ');
                break;
            case 2:
                week = $g('���ڶ�');
                break;
            case 3:
                week = $g('������');
                break;
            case 4:
                week = $g('������');
                break;
            case 5:
                week = $g('������');
                break;
            case 6:
                week = $g('������');
                break;
            default:
                week = $g('������');
        }
        var years = curNow.getFullYear();
        var month = PadZero(curNow.getMonth() + 1);
        var days = PadZero(curNow.getDate());
        var hours = PadZero(curNow.getHours());
        var minutes = PadZero(curNow.getMinutes());
        var seconds = PadZero(curNow.getSeconds());
        var ndate = $.fn.datebox.defaults.formatter(new Date());
        $('#clockTime').html(hours + ':' + minutes + ':' + seconds + '   ' + week);
        $('#clockDate').html(ndate);
    }, 1000);

    function PadZero(num) {
        if (num < 10) {
            return '0' + num;
        }
        return num;
    }
}

// ���ݶ�λ����
function MakeWardBody(wardJson) {
    var colNum = PHA_IP_REQBOARD.Params.wardSeatTblCol; // ���ָ�ռ����
    if (parseInt(colNum) > 2) {
        var tdRate = 1 / parseInt(colNum);
        var tdCss = '#tblWard td {';
        tdCss += '    text-align: center;';
        tdCss += '    width: ' + tdRate * 100 + '%;';
        tdCss += '}';
        $('style').append(tdCss);
    }
    var prtJson = PHA_IP_REQBOARD.PHAIPReqType;
    var cellCnt = prtJson.total;
    var prtRows = prtJson.rows;
    // ����table����
    var tblHtml = '';
    var cellTR = '';
    var cnt = 0;
    for (var i = 0; i < cellCnt; i++) {
        cnt++;
        var rem = cnt % colNum; // ����0�͸û�����
        var prtDesc = prtRows[i].prtDesc;
        var prtID = 'prt-' + prtRows[i].prt;
        var cellTD = '';
        cellTD += '<td>';
        cellTD += '    <div class="pha-ward-cell">';
        cellTD += '        <div id=' + prtID + '>' + '<span style="visibility:hidden">' + $g('��') + '<span>' + '</div>';
        cellTD += '    </div>';
        cellTD += '</td>';
        cellTR += cellTD;
        if (rem === 0 || cnt === cellCnt) {
            tblHtml += '<tr>' + cellTR + '</tr>';
            cellTR = '';
        }
    }

    var wardBodyHtml = '';
    wardBodyHtml += '<div class="pha-mob-ward" id="wardLoc-' + wardJson.wardLoc + '">';
    wardBodyHtml += '    <div class="ward-title" style="overflow:hidden;height:25px;text-align:center;">';
    wardBodyHtml += '       ' + wardJson.wardLocDesc;
    wardBodyHtml += '    </div>';
    wardBodyHtml += '    <table cellspacing=0 cellpadding=0>';
    wardBodyHtml += tblHtml;
    wardBodyHtml += '    </table>';
    wardBodyHtml += '</div>';

    return wardBodyHtml;
}

// �����г�ʼ��λ��
function InitWardPage() {
    var pJson = {
        loc: session['LOGON.CTLOCID']
    };
    var wardMapJson = $.cm(
        {
            ClassName: 'PHA.IP.ReqBoard.Query',
            QueryName: 'WardLocBoard',
            pJsonStr: JSON.stringify(pJson),
            page: 1,
            rows: 999
        },
        false
    );
    if (wardMapJson.total === 0) {
        PHA.Popover({
            msg: '��δ��������ҩ����,��������',
            type: 'alert'
        });
        return;
    }
    var colNum = PHA_IP_REQBOARD.Params.wardSeatCol;
    var wardRows = wardMapJson.rows;
    var cnt = 0;
    var len = wardRows.length;
    var wardHtml = '<table>';
    var wardTR = '';
    for (var i = 0; i < len; i++) {
        cnt++;
        var rem = cnt % colNum;
        var wardTD = MakeWardBody(wardRows[i]);
        wardTD = '<td style="width:10%">' + wardTD + '</td>';
        wardTR += wardTD;
        if (rem === 0 || cnt === len) {
            wardHtml += '<tr>' + wardTR + '</tr>';
            wardTR = '';
        }
    }
    wardHtml += '</table>';
    $('#tblWard').append(wardHtml);
}

function Query() {
    var pJson = {
        loc: session['LOGON.CTLOCID']
    };
    $.cm(
        {
            ClassName: 'PHA.IP.ReqBoard.Query',
            MethodName: 'GetWardInPhReqRows',
            pJsonStr: JSON.stringify(pJson)
        },
        function (data) {
            if (typeof data.msg !== 'undefined') {
                PHA_IP_REQBOARD.NeedTerminate = true;
            }
            // Ч��ɶ������ν,������ݲ��ÿ�����,��Ȼ�����Ż�
            $('.ward-title').removeClass('ward-title-notify');
            $('.pha-ward-cell div').html('<span style="visibility:hidden">��<span>');
            data.forEach(function (wardJson) {
                var wardLoc = wardJson.wardLoc;
                var prt = wardJson.prt;
                var prtDesc = wardJson.prtDesc;
                var prtCnt = wardJson.prtCnt;
                var prtColor = $('.pha-mob-tag-' + prt).css('background-color');
                if (prtColor === 'rgba(0, 0, 0, 0)') {
                    prtColor = 'rgb(0, 0, 0)';
                }
                var prtDescHtml = '<div style="color:' + prtColor + '">' + prtCnt + '</div>';
                $('#wardLoc-' + wardLoc + ' #prt-' + prt).html(prtDescHtml);
                if (wardJson.notify === 'Y') {
                    $('#wardLoc-' + wardLoc + ' .ward-title').addClass('ward-title-notify');
                }
            });
        },
        function (data) {
            PHA_IP_REQBOARD.NeedTerminate = true;
        }
    );
}

function InitPageNav() {
    var prtJson = PHA_IP_REQBOARD.PHAIPReqType;
    var cellCnt = prtJson.total;
    var prtRows = prtJson.rows;
    var navHtml = '';
    if (PHA_IP_REQBOARD.Params.isShowPrintAll == 'Y') {
        navHtml +=
            '<div class="pha-mob-tag"><label id="btnPrintAll" style="color:white;margin-right:10px;background:#096EB3;border-radius:2px;cursor:pointer;font-size:22px;padding:3px 10px 4px 10px;">' +
            $g('һ����ӡ') +
            '[P]</label></div>';
    }
    for (var i = 0; i < prtRows.length; i++) {
        var prtRowData = prtRows[i];
        var prt = prtRowData.prt;
        var divHtml = '<div class="pha-mob-tag pha-mob-tag-' + prt + '" style="color:white;background:' + prtRowData.prtColor + '">' + prtRowData.prtDesc + '</div>';
        navHtml += divHtml;
    }
    navHtml += '<div class="pha-mob-tag" style="color:white;background:#46C6BD;margin-left:10px">' + $g('֪ͨ��ҩ') + '</div>';
    $('#navNotifyBar').html(navHtml);
}

// ������ʼ��������
function InitGridPhReq() {
    var colOperate = {
        field: 'phrOperate',
        title: '�鿴',
        width: 40,
        align: 'center',
        formatter: function (value, rowData, rowIndex) {
            if (rowData.prtDesc || '' != '') {
                return '<img title="' + $g('�鿴��ϸ') + '" onclick="ShowDiagPhReqItm()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/search.png" style="border:0px;cursor:pointer">';
            }
        }
    };
    var columns = [
        [
            {
                field: 'phr',
                title: 'phr',
                width: 100,
                hidden: true
            },
            {
                field: 'itmChk',
                checkbox: true
            },
            {
                field: 'phrNo',
                title: '����',
                width: 150,
                sortable: false
            },
            {
                field: 'itmCount',
                title: '��ϸ��',
                align: 'center',
                width: 50
            },
            {
                field: 'prtDesc',
                title: '����',
                width: 50,
                hidden: true
            },
            {
                field: 'connectNo',
                title: '�̻�����',
                width: 50,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        checking: false,
        pagination: false,
        columns: columns,
        fitColumns: true,
        border: true,
        singleSelect: false,
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        title: '',
        showFooter: true
    };

    // ��������
    var prtJson = PHA_IP_REQBOARD.PHAIPReqType;
    var cellCnt = prtJson.total;
    var prtRows = prtJson.rows;

    // ������,ע��߾�10px
    var colNum = PHA_IP_REQBOARD.Params.wardSeatTblCol; // ���ָ�ռ����
    var minusHeight = prtRows.length > 4 ? 30 : 0;
    var phreqOpts = $('#diagPhReq').dialog('options');
    var phreqWidth = parseInt(phreqOpts.width);
    var phreqHeight = parseInt(phreqOpts.height) - 140 - minusHeight;
    var oneWidth = parseInt((phreqWidth - 50) / 4); // ��һ���ĸ���ʾ,���˺���
    var containerWidth = parseInt((oneWidth + 10) * cellCnt + 10) - 1;
    var gridHtml = '';
    prtRows.forEach(function (prtRowData) {
        var prt = prtRowData.prt;
        var gridID = 'gridPhReq-' + prt;
        var divHtml = '<div class="pha-ward-fix" style="width:' + oneWidth + 'px;height:' + phreqHeight + 'px;"><table id="' + gridID + '"></table></div>';
        gridHtml += divHtml;
    });
    $('#containerPhReq').css('width', containerWidth);
    $('#containerPhReq').append(gridHtml);
    var gridOpts = JSON.stringify(dataGridOption);
    prtRows.forEach(function (prtRowData) {
        var prt = prtRowData.prt;
        var gridID = 'gridPhReq-' + prt;
        var dataOptions = JSON.parse(gridOpts);
        var prtColor = $('.pha-mob-tag-' + prt).css('background-color');
        if (prtColor === 'rgba(0, 0, 0, 0)') {
            prtColor = 'rgb(0, 0, 0)';
        }
        dataOptions.title = '<div style="color:' + prtColor + ';font-weight:bold">' + prtRowData.prtDesc + '</div>';
        dataOptions.columns[0].push(colOperate);
        dataOptions.onLoadSuccess = function (data) {
            // �Զ�ѡ��δ������
            $('#' + gridID).datagrid('clearChecked');
            var rowsData = data.rows;
            for (var i = 0; i < rowsData.length; i++) {
                var iData = rowsData[i];
                var iConnectNo = iData.connectNo || '';
                if (iConnectNo == '') {
                    $('#' + gridID).datagrid('checkRow', i);
                }
            }
        };
        dataOptions.loadFilter = function (data) {
            data.footer = [
                {
                    phrNo: '<div>' + $g('��¼��') + '<span style="padding-left:10px">' + data.total + '</span></div>'
                }
            ];
            return data;
        };
        PHA.Grid(gridID, dataOptions);
    });
}

function InitGridPhReqItm() {
    var columns = [
        [
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 300
            },
            {
                field: 'qtyUom',
                title: '��������',
                width: 75
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'bedNo',
                title: '����',
                width: 100
            },
            {
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 150,
                hidden: true
            },
            {
                field: 'phrDateTime',
                title: '����ʱ��',
                width: 170
            },
            {
                field: 'prescNo',
                title: '������',
                width: 125
            }
        ]
    ];
    var dataGridOption = {
        pagination: false,
        columns: columns,
        fitColumns: false,
        border: true,
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        toolbar: '',
        onClickRow: function (rowIndex, rowData) {}
    };
    PHA.Grid('gridPhReqItm', dataGridOption);
}
function InitDialogStyle() {
    $('#diagPhReq').dialog({
        width: PHA_IP_REQBOARD.Dialog.width,
        height: PHA_IP_REQBOARD.Dialog.height,
        title: '�������쵥'
    });
}
function ShowDiagPhReqItm() {
    var $target = $(event.target);
    var phr = $target.closest('tr[datagrid-row-index]').find('[field="phr"]').text();
    $('#diagPhReqItm')
        .dialog({
            width: $(window).width() * 0.75,
            height: $(window).height() * 0.75,
            title: '���쵥��ϸ'
        })
        .dialog('open');

    var $grid = $('#gridPhReqItm');
    var pJson = {
        phr: phr
    };
    $grid.datagrid('options').url = $URL;
    $grid.datagrid('query', {
        ClassName: 'PHA.IP.ReqBoard.Query',
        QueryName: 'InPhReqItm',
        rows: 9999,
        pJsonStr: JSON.stringify(pJson)
    });
}
function ShowDiagPhReq() {
    QueryPhReq();
    var wardLocSel = $('.pha-ward-select');
    var wardLocDesc = wardLocSel.find('.ward-title').text();
    $('#diagPhReq')
        .dialog({
            title: '�������쵥 - ' + wardLocDesc
        })
        .dialog('open');
}

function QueryPhReq() {
    var startDate = $('#conStartDate').datebox('getValue');
    var endDate = $('#conEndDate').datebox('getValue');
    var wardLocSel = $('.pha-ward-select');
    var wardLocID = wardLocSel.attr('id');
    $('[id^=gridPhReq-]').each(function (index, data) {
        var gridID = data.id;
        var $grid = $('#' + gridID);
        var pJson = {
            prt: gridID.split('-')[1],
            startDate: startDate,
            endDate: endDate,
            loc: session['LOGON.CTLOCID'],
            wardLoc: wardLocID.split('-')[1]
        };

        $grid.datagrid('options').url = $URL;
        $grid.datagrid('query', {
            ClassName: 'PHA.IP.ReqBoard.Query',
            QueryName: 'InPhReq',
            rows: 9999,
            pJsonStr: JSON.stringify(pJson)
        });
    });
}

function ConnectPhReqSend() {
    ConnectPhReq('', '1');
}

// �������쵥
function ConnectPhReq(gPrt, gPrtType) {
    var isPrintChecked = true; // ��ҽԺҪ��
    var phrStrArr = [];
    $('[id^=gridPhReq-]').each(function (index, data) {
        var gridID = data.id;
        var $grid = $('#' + gridID);
        var prt = gridID.split('-')[1];
        if (typeof gPrt == 'string' && gPrt != '' && gPrt != prt) {
            return true;
        }
        if (isPrintChecked) {
            // ֻ��ӡ��ѡ��
            var gridChecked = $grid.datagrid('getChecked');
            if (gridChecked == '' || gridChecked == null) {
                return;
            }
            var phrArr = [];
            for (var i = 0; i < gridChecked.length; i++) {
                var phr = gridChecked[i].phr;
                var prtType = gridChecked[i].prtType;
                if (typeof prtType == 'string' && prtType != '' && prtType != gPrtType) {
                    continue;
                }
                phrArr.push(phr);
            }
        } else {
            // ��ӡ�����б��
            var gridRows = $grid.datagrid('getRows');
            if (gridRows == '' || gridRows == null) {
                return;
            }
            var phrArr = [];
            for (var i = 0; i < gridRows.length; i++) {
                var phr = gridRows[i].phr;
                var prtType = gridRows[i].prtType;
                if (typeof prtType == 'string' && prtType != '' && prtType != gPrtType) {
                    continue;
                }
                phrArr.push(phr);
            }
        }

        var phrStr = phrArr.join('^');
        if (phrArr != '') {
            phrStrArr.push(phrStr);
        }
    });

    var phrStrArrStr = JSON.stringify(phrStrArr);
    if (phrStrArrStr === '[]') {
        PHA.Popover({
            msg: '����ѡ����Ҫ���������쵥',
            type: 'alert'
        });
        return;
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.ReqBoard.Save',
            pMethodName: 'UpdateMultiHandler',
            pJsonStr: phrStrArrStr
        },
        false
    );
    if (retJson.success === 'N') {
        var msg = PHAIP_COM.DataApi.Msg(retJson);
        PHA.Alert('��ʾ', msg, 'warning');
    } else {
        if (retJson.data != '') {
            // ��ӡtodo
            if (PHA_IP_REQBOARD.Params.isPrintReqCon == 'Y') {
                var connectNoStr = retJson.data || '';
                var connectNoArr = connectNoStr.split('^');
                PHA_IP_MOBPRINT.Connect(connectNoArr);
            } else {
                PHA.Alert('�����ɹ�', retJson.data, 'warning');
            }
        }
        QueryPhReq();
    }
}

// һ����ӡ
function PrintAll() {
    if (!confirm($g('�Ƿ�ȷ�ϴ�ӡÿ��������[��ҩ]�̻�����'))) {
        return;
    }
    Query();

    var startDate = $('#conStartDate').datebox('getValue');
    var endDate = $('#conEndDate').datebox('getValue');
    var pJsonStr = JSON.stringify({
        loc: session['LOGON.CTLOCID'],
        prt: '1',
        startDate: startDate,
        endDate: endDate
    });
    var connectNoStr = tkMakeServerCall('PHA.IP.ReqBoard.Query', 'GetConnectMulti', pJsonStr);

    if (connectNoStr.split('^')[0] < 0) {
        PHA.Alert('��ʾ', connectNoStr, 'warning');
    }
    var connectNoArr = JSON.parse(connectNoStr);
    PHA_IP_MOBPRINT.Connect(connectNoArr);
}

function FullScreen() {
    window.top.document.getElementsByName('TRAK_main')[0].setAttribute('allowfullscreen', true);
    window.frameElement.setAttribute('allowfullscreen', true);
    var element = document.querySelector('body');
    ['requestFullscreen', 'mozRequestFullScreen', 'webkitRequestFullscreen', 'msRequestFullscreen'].every(function (value) {
        if (element[value]) {
            element[value]();
            return false;
        }
        return true;
    });
}
