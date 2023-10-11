/**
 * ����:	 סԺҩ�� - �Զ���ӡ
 * ��д��:	 yunhaibao
 * ��д����: 2020-08-13
 */

var PHA_IP_AUTOPRINT = {
    Timer: null,
    Seconds: 30000, // ����������10s, һ�����30 ~ 60s
    Doing: false,
    NeedTerminate: false
};
$(function () {
    $('#panelAutoPrint').panel({
        title: PHA_COM.IsTabsMenu() !== true ? '�Զ���ӡ������' : '',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-print',
        fit: true,
        bodyCls: 'panel-body-gray'
    });

    $('#gifMachine').hide();
    $('#btnStart').on('click', function () {
        if (CheckDoing() === false) {
            return;
        }
        $('#gifMachine').show();
        AutoPrint();
        StartTimer();
    });
    $('#btnStop').on('click', function () {
        if (CheckDoing() === false) {
            return;
        }
        $('#gifMachine').hide();
        clearTimeout(PHA_IP_AUTOPRINT.Timer);
        PHA_IP_AUTOPRINT.Timer = null;
    });
    $('#btnRefresh').on('click', function () {
        if (CheckDoing() === false) {
            return;
        }
        $('#gifMachine').show();
        AutoPrint();
        StartTimer();
    });

    // lodop������
    //$('#btnStart').click();
});
function CheckDoing() {
    if (PHA_IP_AUTOPRINT.Doing === true) {
        PHA.Popover({
            msg: '������ȡ����, �� 1-2s ������',
            type: 'alert'
        });
        return false;
    }
    return true;
}
function StartTimer() {
    PHA_IP_AUTOPRINT.Timer = setTimeout(function () {
        if (PHA_IP_AUTOPRINT.NeedTerminate === true) {
            return;
        }
        PHA_IP_AUTOPRINT.Doing = true;
        AutoPrint();
        PHA_IP_AUTOPRINT.Doing = false;
        StartTimer();
    }, PHA_IP_AUTOPRINT.Seconds);
}
function AutoPrint() {
    var retArr = tkMakeServerCall('PHA.IP.Print.Auto', 'GetBoxDraw', session['LOGON.CTLOCID']);
    retArr = JSON.parse(retArr);
    if (Array.isArray(retArr) === false) {
        PHA_IP_AUTOPRINT.NeedTerminate = true;
        return;
    }
    var boxArr = retArr.box;
    var drawArr = retArr.draw;
    if (boxArr.length > 0) {
        PHA_IP_MOBPRINT.Box(boxArr);
    }
    //    if (boxArr.length>0){
    //    	PHA_IP_MOBPRINT.Draw(drawArr);
    //    }
}
