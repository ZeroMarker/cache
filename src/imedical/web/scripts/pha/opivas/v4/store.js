/**
 * ����:   ������Һ��ͪ-���ݼ�����
 * ��д��:  yunhaibao
 * ��д����: 2019-06-14
 */

var PHA_OPIVAS_STORE = {
    Url: $URL + "?ResultSetType=Array&",
    RowUrl: $URL + "?ResultSetType=Array&",
    // ���״̬
    PIVADISPackFlag: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVADISPackFlag"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASPackStat'
            
        }
    },
    // ����״̬
    PIVADISOpStatus: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVADISOpStatus"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASReqStat'
        }
    },
    // ����״̬
    PIVADISRecStatus: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVADISRecStatus"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASRecStat'
        }
    },
    // �������״̬
    OeAuditStatus: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=OeAuditStatus"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASAuditStat'
        }
    },
    // ��Һִ��״̬
    PIVAState: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVAState"
        }
    }
}
