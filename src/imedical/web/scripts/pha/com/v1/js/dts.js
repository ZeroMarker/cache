/**
 * DTS ������
 * @author yunhaibao
 * @date   2023-03-21
 * @example ĳһ����Ĳ���, ����
 */
var PHA_DTS = (function () {
    /**
     * ����ĳһ������Ĳ�����¼
     * @param {object} pLogObj
     * @param {string} pLogObj.bizCode      ҵ�����, ��DTSϵͳ�е�ҵ�����
     * @param {string} pLogObj.bizMainId    ҵ����ID, �综��ID|����ID
     * @param {string} [pLogObj.bizId]      ҵ��ID, ��ҽ��ID|����ID
     * @param {string} [pLogObj.bizJson]    ҵ��Json, һЩ��ע��Ϣ��, ����ϸ������
     * @param {string} [pLogObj.userCode]   �û�����, ��ѡ, Ĭ�ϵ�ǰ,
     * @todo Ϊ�۸�, usercodeӦ���ں�̨��ֵ
     * @example PHA_DTS.Add({bizCode:'987414993',bizMainId:'123',bizId:'',bizJson:{},userCode:''})
     */

    function Add(pLogObj) {
        var bizDate = PHA_UTIL.GetDate();
        var bizTime = PHA_UTIL.GetTime();
        var logObj = {
            BizCode: pLogObj.bizCode,
            BizMainId: pLogObj.bizMainId,
            BizId: pLogObj.bizId,
            BizJson: pLogObj.bizJson,
            UserCode: pLogObj.userCode || session['LOGON.USERCODE'],
            BizDate: bizDate,
            BizTime: bizTime
        };
        if (typeof $.data(document.body, 'DTSLog') === 'undefined') {
            $.data(document.body, 'DTSLog', []);
        }
        $.data(document.body, 'DTSLog').push(logObj);
        return true;
    }
    /**
     * ͳһ����������ύ��̨
     */
    function Save() {
        var logJson = $.data(document.body, 'DTSLog');
        var ret = $.cm(
            {
                ClassName: 'PHA.COM.DTS',
                MethodName: 'HandleSave4Web',
                pLogJson: JSON.stringify(logJson)
            },
            false
        );
        console.log(ret);
        Clear();
        return true;
    }
    /**
     * ����������
     */
    function Clear() {
        $.data(document.body, 'DTSLog', []);
        return true;
    }
    return {
        Add: Add,
        Save: Save,
        Clear: Clear
    };
})();
