/**
 * ����:	 סԺҩ������-���ݼ�����
 * ��д��:	 yunhaibao
 * ��д����: 2020-05-06
 */

var PHAIP_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
    // ��ҩ����
    PHAIPReqType: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=PHAIPReqType'
        };
    },
    // ����״̬
    InPhReqStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=InPhReqStatus'
        };
    },
    // ������״̬
    BoxStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=BoxStatus'
        };
    },
    // ��ҩ���
    StkDrugGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=StkDrugGroup'
        };
    }
};
