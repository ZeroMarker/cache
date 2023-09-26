/**
 * ����:	 ��ҩ�ҹ���-���ݼ�����
 * ��д��:	 hulihua
 * ��д����: 2019-06-12
 */

var logonHospId = session['LOGON.HOSPID'] ;
var PHA_DEC_STORE = {
	Url: $URL + "?ResultSetType=Array&",
	// ��ҩ��
	DecLoc: function () {
		return {
			url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=DecLoc&HospId="+gHospID+"&UserId=" + gUserID
		}
	},
	// Ժ��
	CTHospital: function () {
		return {
			url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=CTHospital"
		}
	},
	/*
     * ҩ��
     * @param {String} type OP-����,IP-סԺ,��-����
     */
    Pharmacy: function (type) {
        type = type || "";
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=Pharmacy&Type=" + type + "&HospId=" + gHospID
        }
    },   
    /*
     * ��ҩ״̬
     * @param {String} declocId-��ҩ��ID
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
     * ��ҩ�豸
     * @param {String} declocId-��ҩ��ID
     */
    DecEqui: function (declocId) {
        declocId = declocId || "";
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=DecEqui&DecLocId=" + declocId
        }
    },
    
    // ҽ������
    DocLoc: function () {
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=CTLoc&TypeStr=E&HospId=" + gHospID
        }
    },
    
   	/*
     * ��������
     * @param {String} 
     */
    PrescForm: function () {
        return {
            url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=GetPreForm&hospId=" + logonHospId
        }
    },
    /*
     * ������
     */
    CardType: function () {
	    return {
		    url: this.Url + "ClassName=PHA.DEC.Com.Store&QueryName=ReadCardTypeDefineListBroker"+"&JSFunName=GetCardTypeToJson"
	    }
    },
    /*
     * ҩ������Ŀ
     */
    CookFeeItem: function () {
	    return {
		    url: this.Url + "ClassName=PHA.DEC.Com.Store&MethodName=GetCookFeeItem&LocId=" + gLocId
	    }
    }
}

