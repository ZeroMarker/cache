/**
 * ����:   ҩ�⹫�� - ���ݼ�����
 * ��д��:  Huxt
 * ��д����: 2022-03-31
 * scripts/pha/in/v3/com/js/store.js
 */
var PHA_IN_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    Hosp: session['LOGON.HOSPID'],
    Loc: session['LOGON.CTLOCID'],
    User: session['LOGON.USERID'],
    // �ɹ���Ա
    LocPurPlanUser: function (locId) {
        locId = locId || this.Loc;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Org&QueryName=LocPurPlanUser&hospId=' + this.Hosp + '&locId=' + locId
        };
    },
    // ��/�������(qType:O-����,I-���)
    OperateType: function (qType) {
        qType = qType || 'O';
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=OperateType&hospId=' + this.Hosp + '&qType=' + qType
        };
    },
    // �˻�ԭ��
    ReasonForReturn: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForReturn&hospId=' + this.Hosp
        };
    },
    // ������ԭ��
    ReasonForAdj: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForAdj&hospId=' + this.Hosp
        };
    },
    // ����ԭ��
    ReasonForAdjPrice: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForAdjPrice&hospId=' + this.Hosp
        };
    },
    // ����ԭ��
    ReasonForScrap: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReasonForScrap&hospId=' + this.Hosp
        };
    },
    // ʵ�̴���
    StkTkWindow: function (locId) {
        locId = locId || this.Loc;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=StkTkWindow&hospId=' + this.Hosp + '&locId=' + locId
        };
    },
	/* ҵ������
     * param : busiCode     ҵ�����
     *       : rangeFlag    ʹ�÷�Χ ( 
     *              CREATE      : ����ѯ SAVE��COMP
     *              COPY        : ����ѯ SAVE ������״̬
     *              AUDIT       : ����ѯ����ȥ SAVE��COMP��CANCEL֮���ٳ�ȥ �������� ������
     *              ALL || ""   : ��ѯ����--����ѯ����ʹ��)
     *         )
     *       : appointCode  ָ��ҵ����� 
     */
    BusiProcess: function (busiCode, rangeFlag, appointCode) {
        hospId = this.Hosp;
        userId = this.User;
        appointCode = appointCode || "";
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiPro&hospId=' + hospId + '&busiCode=' + busiCode + '&rangeFlag=' + rangeFlag + '&userId=' + userId + '&appointCode=' + appointCode
        };
    },
    /* ����ִ��״̬
     * param : rangeFlag    ʹ�÷�Χ ( 
     *              CREATE      : ����ѯ SAVE��COMP
     *              TRANS       : ���� SAVE
     *              ALL || ""   : ��ѯ����--����ѯ����ʹ��)
     *         )
     */
    ReqStauts: function (rangeFlag) {
        rangeFlag = rangeFlag || "";
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReqStauts&rangeFlag=' + rangeFlag
        };
    },
    /* �������� */
    ReqType: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=ReqType'
        };
    },
    /* ҵ������
     * param : cancelFlag   ����������ʽ ( 
     *              WITH           : ��������
     *              ONLY           : ��ȡ��ҵ������
     *              WITHOUT || ""  : ����ѯ��ȡ��ҵ������
     *         )
     */
    BusiType: function (cancelFlag) {
        cancelFlag = cancelFlag || "";
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiType&cancelFlag=' + cancelFlag
        };
    },
    /* С������
     */
    DecimalRule : function (hospId) {
	    hospId = hospId || this.Hosp;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=DecimalRule&hospId=' + hospId
        };
    },
    /* ��������
     */
    MarkType : function (hospId) {
	    hospId = hospId || this.Hosp;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=MarkType&hospId=' + hospId
        };
    },
    /* (ҵ�񵥾�����ά��ʱ)ҵ������ */
    BusiForNoType : function (hospId) {
	    hospId = hospId || this.Hosp;
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiForNoType&hospId=' + hospId
        };
    },
    BusiStatusResult: function () {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=BusiStatusResult'
        };
    } ,
    // ��λ��
    StkBinTree: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&MethodName=StkBinTree' + (Loc ? '&LocId=' + Loc : '')
        };
    },
    // ��λ������
    StkBinComb: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=StkBinComb' + (Loc ? '&LocId=' + Loc : '')
        };
    },
    // ��λ������(�����ܺ�)
    StkBinRacks: function (Loc) {
        return {
            url: this.Url + 'ClassName=PHA.IN.Store.Other&QueryName=StkBinRacks' + (Loc ? '&LocId=' + Loc : '')
        };
    },  
}