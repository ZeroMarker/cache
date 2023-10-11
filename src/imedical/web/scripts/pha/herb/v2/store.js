/**
 * ����:	 ��ҩ��-���ݼ�����
 * ��д��:	 MaYuqiang
 * ��д����: 2020-11-11
 */

var PHA_HERB_STORE = {
    Url: $URL + '?ResultSetType=Array&',
    RowUrl: $URL + '?ResultSetType=Array&',
	// ��ҩ��ʽ
    CookType: function (cookTypeDesc, gLocId) {
        return {
            url: this.Url + 'ClassName=PHA.HERB.Com.Store&QueryName=CookType&typeDesc=' + cookTypeDesc + '&gLocId=' + gLocId 
        };
    },
    // �������ݼ�
    Process: function (gLocId, typeDesc, HospId, admType, clientType) {
        return {
            url: this.Url + 'ClassName=PHA.HERB.Com.Store&QueryName=ExeProStore&gLocId=' + gLocId + '&HospId=' + HospId + '&typeDesc=' + typeDesc+ '&admType=' + admType+ '&clientType=' + clientType 
        };
    },
    // ��ҩ��������
    HMPreForm: function (gLocId) {
        return {
            url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetHMPreForm&gLocId=" + gLocId
        }
    },
    // ��ҩ������Ŀ
    CookFeeItem: function (gLocId) {
	    return {
		    url: this.Url + "ClassName=PHA.DEC.Com.Store&MethodName=GetCookFeeItem&LocId=" + gLocId
	    }
    },
    // ��ҩȡҩ��ʽ
    PrescTakeMode: function (prescForm,gLocId) {
	    return {
		    url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetTakeMode&prescForm=" + prescForm + "&gLocId=" + gLocId
	    }
    },
    // ��ȡ�е�ǰ��¼ҩ����ҩȨ����Ա���ݼ�
    PYUserStore: function (gLocId, gUserId) {
	    return {
		    url: this.Url + "ClassName=PHA.HERB.Com.Store&QueryName=GetPYUserStore&gLocId=" + gLocId + "&gUserId=" + gUserId
	    }
    },
    // ��ȡ�е�ǰ��¼ҩ����ҩ�������ݼ�
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
    // ҽ������
    DocLoc: function () {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=CTLoc&TypeStr=E,EM,O,OP,IP,D&HospId=' + PHA_COM.Session.HOSPID
        };
    },
    // �û�Ȩ�޿���
    UserLoc: function (locType) {
        return {
            url: this.Url + 'ClassName=PHA.STORE.Org&QueryName=UserLoc&UserId='+PHA_COM.Session.USERID + '&LocType=' + locType + '&HospId=' + PHA_COM.Session.HOSPID
        };
    }
	
};
