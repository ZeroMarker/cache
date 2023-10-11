/**
 * DTS 埋点相关
 * @author yunhaibao
 * @date   2023-03-21
 * @example 某一步骤的操作, 调用
 */
var PHA_DTS = (function () {
    /**
     * 用于某一个步骤的操作记录
     * @param {object} pLogObj
     * @param {string} pLogObj.bizCode      业务编码, 在DTS系统中的业务编码
     * @param {string} pLogObj.bizMainId    业务主ID, 如患者ID|就诊ID
     * @param {string} [pLogObj.bizId]      业务ID, 如医嘱ID|处方ID
     * @param {string} [pLogObj.bizJson]    业务Json, 一些备注信息等, 可再细化内容
     * @param {string} [pLogObj.userCode]   用户工号, 可选, 默认当前,
     * @todo 为篡改, usercode应该在后台给值
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
     * 统一将所有埋点提交后台
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
     * 清除所有埋点
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
