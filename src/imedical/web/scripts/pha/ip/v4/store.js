/**
 * 名称:	 住院药房公共-数据集集合
 * 编写人:	 yunhaibao
 * 编写日期: 2020-05-06
 */

var PHAIP_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
    // 领药类型
    PHAIPReqType: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=PHAIPReqType'
        };
    },
    // 请领状态
    InPhReqStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=InPhReqStatus'
        };
    },
    // 物流箱状态
    BoxStatus: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=BoxStatus'
        };
    },
    // 发药类别
    StkDrugGroup: function () {
        return {
            url: this.Url + 'ClassName=PHA.IP.COM.Store&QueryName=StkDrugGroup'
        };
    }
};
