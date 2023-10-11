/**
 * dhcpha.inpha.printreturn.js
 * 住院药房
 * 通用退药单打印
 * 2016-05-17 yunhaibao
 */

var HospitalDesc = '';
HospitalDesc = tkMakeServerCall('web.DHCSTKUTIL', 'GetHospName', session['LOGON.HOSPID']);
var printPath = GetPrintPath();

/**
 * 退药单打印入口
 * @creator: huxiaotian
 * @createDate: 2019-11-24
 */
function PrintReturnCom(pharet, reprint, prnType) {
    if (pharet == '') {
        return;
    }
    var pharetArr = pharet.toString().split('^');
    for (var i = 0, length = pharetArr.length; i < length; i++) {
        var phar = pharetArr[i];
        if (!phar) {
            continue;
        }
        PrintReturn(phar, prnType, reprint);
    }
}
/**
 * 使用xml模板打印
 * @creator: huxiaotian
 * @createDate: 2019-11-24
 */
function PrintReturn(pharet, prnType, reprint) {
    reprint = reprint || '';
    prnType = prnType || '';
    var template = '';
    if (prnType !== '' && prnType !== 'default') {
        if (prnType == 'detail') template = 'PHAIPReturn';
        else if (prnType == 'total') template = 'PHAIPReturnTotal';
    }
    var prtDataStr = tkMakeServerCall('PHA.IP.Print.Return', 'GetData', pharet, template);
    var prtData = JSON.parse(prtDataStr);

    if (prtData.template === '') {
        alert('请先在【参数设置】->【住院药房】->【住院退药】中维护打印模板名称 ');
        return;
    }
    if (reprint !== '') {
        prtData.para.title = prtData.para.title + '（补）';
    }
    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: prtData.template,
        data: {
            Para: prtData.para,
            List: prtData.list
        },
        listColAlign: { retQty: 'right', sp: 'right', spAmt: 'right' },
        preview: false,
        aptListFields: ['label17', 'userName', 'label19', 'acceptUser', 'label21', 'spAmtSum', 'label23', 'sysDT'],
        listBorder: { style: 4, startX: 1, endX: 190 },
        page: { rows: 25, x: 90, y: 270, fontname: '宋体', fontbold: 'false', fontsize: '14', format: '{1}/{2}' }
    });
    if (reprint !== '') {
        // 打印日志， 补打增加日志
        if (typeof App_MenuCsp) {
            PHA_LOG.Operate({
                operate: 'P',
                logInput: JSON.stringify(prtData.para),
                // logInput: logParams,
                type: 'User.DHCPhaReturn',
                pointer: pharet,
                origData: '',
                remarks: App_MenuName
            });
        }
    }
}

function PrintReturnBeforeExec() {}
function PrintReturnTotal() {}
function GetReturnMainData() {}
function GetReturnDetailData(pid, pidi) {
    var returndetaildata = tkMakeServerCall('web.DHCSTPHARETURN', 'ListRet', '', '', pid, pidi);
    return returndetaildata;
}
function KillTmpAfterPrint(pid) {
    tkMakeServerCall('web.DHCSTPHARETURN', 'killRetTmpAfterPrint', pid);
}
function GetPrintPath() {
    var prnpath = tkMakeServerCall('web.DHCSTCOMWEB', 'GetPrintPath');
    if (prnpath.substring(prnpath.length, prnpath.length - 1) != '\\') {
        prnpath = prnpath + '\\';
    }
    return prnpath;
}
