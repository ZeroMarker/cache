/**
 * 名称:	 草药房-数据集集合
 * 编写人:	 MaYuqiang
 * 编写日期: 2020-11-11
 */

var PHA_HERB_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
	// 煎药方式
    CookType: function (cookTypeDesc, gLocId) {
        return {
            url: this.Url + 'ClassName=PHA.HERB.Com.Store&QueryName=CookType&typeDesc=' + cookTypeDesc + '&gLocId=' + gLocId 
        };
    },
    // 流程数据集
    Process: function (gLocId, typeDesc, HospId, admType, clientType) {
        return {
            url: this.Url + 'ClassName=PHA.HERB.Com.Store&QueryName=ExeProStore&gLocId=' + gLocId + '&HospId=' + HospId + '&typeDesc=' + typeDesc+ '&admType=' + admType+ '&clientType=' + clientType 
        };
    },
    // 草药处方剂型
    HMPreForm: function (gLocId) {
        return {
            url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetHMPreForm&gLocId=" + gLocId
        }
    },
    // 煎药费用项目
    CookFeeItem: function (gLocId) {
	    return {
		    url: this.Url + "ClassName=PHA.DEC.Com.Store&MethodName=GetCookFeeItem&LocId=" + gLocId
	    }
    },
    // 草药取药方式
    PrescTakeMode: function (prescForm,gLocId) {
	    return {
		    url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetTakeMode&prescForm=" + prescForm + "&gLocId=" + gLocId
	    }
    },
    // 获取有当前登录药房配药权限人员数据集
    PYUserStore: function (gLocId, gUserId) {
	    return {
		    url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetPYUserStore&gLocId=" + gLocId + "&gUserId=" + gUserId
	    }
    },
    // 获取有当前登录药房发药窗口数据集
    WindowStore: function (gLocId) {
	    return {
		    url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetWindowStore&gLocId=" + gLocId
	    }
    },
    RetReasonStore: function (admType, HospId) {
	    return {
		    url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetRetReason&admType=" + admType + '&hospId=' + HospId
	    }
    },
    // 医生科室
    DocLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&TypeStr=E,EM,O,OP,IP,D&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // 用户权限科室
    UserLoc: function (locType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=UserLoc&UserId='+PHA_COM.Session.USERID + '&LocType=' + locType + '&HospId=' + PHA_COM.Session.HOSPID
        };
    }
	
};
