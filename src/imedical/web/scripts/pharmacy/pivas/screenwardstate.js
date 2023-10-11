/**
 * @description: 配液大屏
 * @author: yunhaibao
 * @since: 2018-03-26
 */
$g('周一');
$g('周二');
$g('周三');
$g('周四');
$g('周五');
$g('周六');
$g('周日');
var SessionLocId = session['LOGON.CTLOCID'];
var TimeRange = 10000;
var PageSize = 30;
var PageList = [];
PageList[0] = PageSize;
var NeedTerminate = false;
$(function () {
    InitPivasSettings();
    InitScreenContent();
    InitSwitchBat();
    InitGridWardState();
    TimeDisHandler();
    RefreshTime();
    $('.dhcpha-win-mask').remove();
    // PIVAS.FullScreen();
    $('.pivas-full').on('click', function (e) {
        $(e.target).closest('a').hasClass('js-pivas-full-exit') === true ? PIVAS.ExitFull() : PIVAS.FullScreen();
        $('.pivas-full').toggle();
    });
});
function TimeDisHandler() {
    if (NeedTerminate === true) {
        return;
    }
    setTimeout(function () {
        QueryWardState();
        TimeDisHandler();
    }, TimeRange);
}
function InitGridWardState() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.ScreenWardState',
            MethodName: 'ColumnsWardState',
            locId: SessionLocId
        },
        function (retJson) {
            for (var i = 0, length = retJson.length; i < length; i++) {
                var iData = retJson[i];
                iData.width = iData.width * 1;
            }
            var columnsArr = [retJson];
            var dataGridOption = {
                url: PIVAS.URL.COMMON + '?action=JsGetScreenWardState',
                fit: true,
                rownumbers: false,
                columns: columnsArr,
                pageNumber: 0,
                pageSize: PageSize,
                pageList: PageList,
                pagination: true,
                singleSelect: true,
                toolbar: '#gridWardStateBar',
                fitColumns: true,
                border: false,
                onLoadSuccess: function (retData) {},
                onLoadError: function (response) {
                    NeedTerminate = true;
                    if (response.statusText == 'abort') {
                        return;
                    }
                    var resText = response.responseText;
                    $.messager.alert('提示', resText, 'error');
                }
            };
            // $('#gridWardState').datagrid(dataGridOption)
            DHCPHA_HUI_COM.Grid.Init('gridWardState', dataGridOption);
            $('#gridWardState')
                .datagrid('getPager')
                .pagination({
                    onSelectPage: function (pageNumber, pageSize) {
                        /*覆盖此事件,触发选中页时不调数据库*/
                    }
                    // ,
                    // layout: ['links']
                });
        }
    );
}

function QueryWardState() {
    var pageOptions = $('#gridWardState').datagrid('getPager').data('pagination').options;
    var total = pageOptions.total;
    var pageSize = pageOptions.pageSize;
    var pageNumber = pageOptions.pageNumber;
    var pageInt = parseInt(total / pageSize);
    var pageRem = total % pageSize;
    var pages = 0;
    if (pageRem > 0) {
        pages = pageInt + 1;
    } else {
        pages = pageInt;
    }
    // 没记录时,最后一页时
    if (pages == 0 || pageNumber == pages) {
        pageNumber = 0;
    } else {
        pageNumber++;
    }
    var batNoStr = '';
    $("#swcBatNoList [id*='swcBatNo']").each(function () {
        var isOff = $('#' + this.id + ' div').hasClass('switch-off');
        if (isOff != true) {
            var swcVal = $('#' + this.id).attr('value');
            batNoStr = batNoStr == '' ? swcVal : batNoStr + ',' + swcVal;
        }
    });
    $('#gridWardState').datagrid('getPager').pagination('select', pageNumber);
    $('#gridWardState').datagrid('load', {
        params: SessionLocId + '^' + batNoStr
    });
}

function RefreshTime() {
    setInterval(function () {
        var curNow = new Date();
        var week;
        switch (curNow.getDay()) {
            case 1:
                week = $g('周一');
                break;
            case 2:
                week = $g('周二');
                break;
            case 3:
                week = $g('周三');
                break;
            case 4:
                week = $g('周四');
                break;
            case 5:
                week = $g('周五');
                break;
            case 6:
                week = $g('周六');
                break;
            default:
                week = $g('周日');
        }
        var years = curNow.getFullYear();
        var month = add_zero(curNow.getMonth() + 1);
        var days = add_zero(curNow.getDate());
        var hours = add_zero(curNow.getHours());
        var minutes = add_zero(curNow.getMinutes());
        var seconds = add_zero(curNow.getSeconds());
        //var ndate = years + "-" + month + "-" + days;
        var ndate = $.fn.datebox.defaults.formatter(new Date());
        $('#timeInfo').html(ndate + '　' + hours + ':' + minutes + ':' + seconds + '　' + week);
    }, 1000);
}

function add_zero(temp) {
    if (temp < 10) return '0' + temp;
    else return temp;
}

/// 初始化界面显示
function InitScreenContent() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'LogonData',
            locId: SessionLocId
        },
        function (jsonData) {
            $('#hospName').text(jsonData.HOSPDESC);
            $('#locName').text(jsonData.CTLOCDESC);
        }
    );
}

/// 初始化批次switch
function InitSwitchBat() {
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.Common',
            MethodName: 'PivasLocBatList',
            pivasLoc: SessionLocId
        },
        function (retData) {
            var retDataArr = retData.split('^');
            for (var i = 1; i <= retDataArr.length; i++) {
                var batNoArr = retDataArr[i - 1].split(',');
                var batId = batNoArr[0];
                var batDesc = batNoArr[1];
                var switchHtml = '<div id="swcBatNo' + batId + '" value=' + batDesc + '></div>';
                $('#swcBatNoList').append(switchHtml);
                $HUI.switchbox('#swcBatNo' + batId, {
                    onText: batDesc,
                    offText: batDesc,
                    // size: 'small',
                    animated: true,
                    // onClass:'primary',
                    offClass: 'gray',
                    checked: true
                });
            }
        }
    );
}

// 初始化默认条件
function InitPivasSettings() {
    var retJson = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'ScreenWardState'
        },
        false
    );
    if (retJson) {
        var pageSize = retJson.PageSize;
        if (pageSize != '') {
            PageSize = pageSize;
            PageList[0] = PageSize;
        }
    }
}
