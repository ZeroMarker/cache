/**
 * dhcpha.inpha.printreturn.js
 * סԺҩ��
 * ͨ����ҩ����ӡ
 * 2016-05-17 yunhaibao
 */

var HospitalDesc = '';
HospitalDesc = tkMakeServerCall('web.DHCSTKUTIL', 'GetHospName', session['LOGON.HOSPID']);
var printPath = GetPrintPath();

/**
 * ��ҩ����ӡ���
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
 * ʹ��xmlģ���ӡ
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
        alert('�����ڡ��������á�->��סԺҩ����->��סԺ��ҩ����ά����ӡģ������ ');
        return;
    }
    if (reprint !== '') {
        prtData.para.title = prtData.para.title + '������';
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
        page: { rows: 25, x: 90, y: 270, fontname: '����', fontbold: 'false', fontsize: '14', format: '{1}/{2}' }
    });
    if (reprint !== '') {
        // ��ӡ��־�� ����������־
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
