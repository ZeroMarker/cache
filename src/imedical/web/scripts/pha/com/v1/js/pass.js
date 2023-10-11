/**
 * ������ҩǰ�˽ӿ�
 * @author yunhaibao
 * @since 2023-02-27
 */

var PHA_PASS = {
    MK: {},
    PDSS: {
        /**
         * ������pdss��ȡ�������, �������δ���, �ص������д���
         * @param {object} options
         * @param {string} options.gridId ���ID
         * @param {string} options.mOeoriField ҽ��ID������
         * @param {string} options.prescNoField ������������
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
                pdss.refresh(pdssObj, null, 4); /// ��� ��һ��������JSON���󣬵ڶ�������:�ص�������������������0���� 1ֻ����2������ 3�ƺͿ�����������
                // console.log(pdss);
                var passFlag = pdss.passFlag; // 1 ͨ��, ������ͨ��
                var manageLevelCode = pdss.manLev;
                var manageLevelDesc = pdss.manLevel;
                var msgId = pdss.MsgID || '';
                var tipsType = 'normal';
                if (manageLevelDesc === '��ֹ') {
                    tipsType = 'forbid';
                } else if (manageLevelDesc === '����' || manageLevelDesc === '��ʾ' || manageLevelDesc === '��ʾ') {
                    tipsType = 'warn';
                }
                var retRowData = {
                    passFlag: passFlag, // �Ƿ��ֹͨ��
                    manageLevelCode: manageLevelCode, // ���������
                    manageLevelDesc: manageLevelDesc, // ����������
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
