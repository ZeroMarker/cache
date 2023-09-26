/**
 * 名称:	 煎药室公共-数据集集合
 * 编写人:	 hulihua
 * 编写日期: 2019-06-12
 */

var logonHospId = session['LOGON.HOSPID'] ;
var PHA_DEC_STORE = {
	Url: $URL + "?ResultSetType=Array&",
	// 煎药室
	DecLoc: function () {
		return {
			url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=DecLoc&HospId="+gHospID+"&UserId=" + gUserID
		}
	},
	// 院区
	CTHospital: function () {
		return {
			url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=CTHospital"
		}
	},
	/*
     * 药房
     * @param {String} type OP-门诊,IP-住院,空-所有
     */
    Pharmacy: function (type) {
        type = type || "";
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=Pharmacy&Type=" + type + "&HospId=" + gHospID
        }
    },   
    /*
     * 煎药状态
     * @param {String} declocId-煎药室ID
     */
    DecState: function (declocId, dectype, storeWay) {
        declocId = declocId || "";
        dectype = dectype || "";
        storeWay = storeWay || "";
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=DecState&DecLocId=" + declocId + "&DecType=" + dectype + "&StoreWay=" + storeWay
        }
    },
   	/*
     * 煎药设备
     * @param {String} declocId-煎药室ID
     */
    DecEqui: function (declocId) {
        declocId = declocId || "";
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=DecEqui&DecLocId=" + declocId
        }
    },
    
    // 医生科室
    DocLoc: function () {
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=CTLoc&TypeStr=E&HospId=" + gHospID
        }
    },
    
   	/*
     * 处方剂型
     * @param {String} 
     */
    PrescForm: function () {
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=GetPreForm&hospId=" + logonHospId
        }
    },
    /*
     * 卡类型
     */
    CardType: function () {
	    return {
		    url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=ReadCardTypeDefineListBroker"+"&JSFunName=GetCardTypeToJson"
	    }
    },
    /*
     * 药费用项目
     */
    CookFeeItem: function () {
	    return {
		    url: this.Url + "ClassName=PHA.DEC.Com.Store&MethodName=GetCookFeeItem&LocId=" + gLocId
	    }
    }
}

