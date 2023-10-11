/**
 * 合理用药前端接口
 * @author yunhaibao
 * @since 2023-02-27
 */

var PHA_PASS = {
    MK: {},
    PDSS: {
        /**
         * 表格调用pdss获取分析结果, 表格内如何处理, 回调内自行处理
         * @param {object} options
         * @param {string} options.gridId 表格ID
         * @param {string} options.mOeoriField 医嘱ID所在列
         * @param {string} options.prescNoField 处方号所在列
         * @param {function} callback
         */
        Analysis: function (options, callback) {
            var gridId = options.gridId;
            var $grid = $('#' + gridId);
            var mOeoriField = options.mOeoriField || '';
            var prescNoField = options.prescNoField || '';
            var rowsData = $grid.datagrid('getRows');
            if (rowsData.length == 0) {
                return;
            }
            var mGroupValExistArr = [];
            var userSessionInfo = session['LOGON.USERID'] + '^' + session['LOGON.CTLOCID'] + '^' + session['LOGON.GROUPID'];
            var sessionInfo = session['LOGON.GROUPID'] + '^' + session['LOGON.HOSPID'] + '^' + session['LOGON.CTLOCID'] + '^' + session['LOGON.USERID'];
            var retRows = [];
            var i = 0;
            for (var i = 0; i < rowsData.length; i++) {
                var rowData = rowsData[i];
                var mOeori = rowData[mOeoriField] || '';
                var prescNo = rowData[prescNoField] || '';
                var groupVal = '';
                if (mOeoriField !== '') {
                    groupVal = mOeori;
                }
                if (prescNoField !== '') {
                    groupVal = prescNo;
                }
                if (groupVal === '') {
                    continue;
                }
                if (mGroupValExistArr.indexOf(groupVal) >= 0) {
                    continue;
                }
                mGroupValExistArr.push(groupVal);

                var pdssData = tkMakeServerCall('PHA.FACE.TPS.PDSS', 'GetPdssObj', mOeori, prescNo, sessionInfo);
                // var pdssData = tkMakeServerCall('PHA.FACE.DHCPASS', 'GetPassJson', mOeori, prescNo, 'CheckRule',sessionInfo);
                if (pdssData == '') {
                    continue;
                }
                var pdssObj = JSON.parse(pdssData);
                pdssObj.Action = 'CheckRule';
                pdssObj.UseType = 'Pha';
                pdssObj.CheckFlag = 'Y';
                var pdss = new PDSS({});
                pdss.refresh(pdssObj, null, 4); /// 审查 第一个参数：JSON对象，第二个参数:回调函数，第三个参数：0弹灯 1只弹框、2不弹框 3灯和框，其他都不弹
                // console.log(pdss);
                var passFlag = pdss.passFlag; // 1 通过, 其他不通过
                var manageLevelCode = pdss.manLev;
                var manageLevelDesc = pdss.manLevel;
                var msgId = pdss.MsgID || '';
                var tipsType = 'normal';
                if (manageLevelDesc === '禁止') {
                    tipsType = 'forbid';
                } else if (manageLevelDesc === '提醒' || manageLevelDesc === '警示' || manageLevelDesc === '提示') {
                    tipsType = 'warn';
                }
                var retRowData = {
                    passFlag: passFlag, // 是否禁止通过
                    manageLevelCode: manageLevelCode, // 管理级别代码
                    manageLevelDesc: manageLevelDesc, // 管理级别描述
                    msgId: msgId,
                    tipsType: tipsType
                };
                retRows.push({
                    index: i,
                    row: retRowData
                });
            }
            callback(retRows);
        },
        ShowMsg: function (options) {
            var msgId = options.msgId || '';
            if (msgId === '') {
                return;
            }
            var pdssObj = {};
            pdssObj.MsgID = msgId;
            pdssObj.UserType = 'Pha';
            pdssObj.CheckFlag = 'N';
            var pdss = new PDSS({});
            pdss.refresh(pdssObj, null, 1);
        }
    }
};
