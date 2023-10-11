/**
 * 名称:   门诊配液西酮-数据集集合
 * 编写人:  yunhaibao
 * 编写日期: 2019-06-14
 */

var PHA_OPIVAS_STORE = {
    Url: $URL + "?ResultSetType=Array&",
    RowUrl: $URL + "?ResultSetType=Array&",
    // 打包状态
    PIVADISPackFlag: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVADISPackFlag"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASPackStat'
            
        }
    },
    // 申请状态
    PIVADISOpStatus: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVADISOpStatus"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASReqStat'
        }
    },
    // 接收状态
    PIVADISRecStatus: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVADISRecStatus"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASRecStat'
        }
    },
    // 配伍审核状态
    OeAuditStatus: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=OeAuditStatus"
            //,
            //url:this.Url + 'ClassName=PHA.STORE.Drug&QueryName=StkComDictionaryAsCode&ScdType=OPIVASAuditStat'
        }
    },
    // 配液执行状态
    PIVAState: function () {
        return {
            url: this.Url + "ClassName=PHA.OPIVAS.COM.Store&QueryName=PIVAState"
        }
    }
}
