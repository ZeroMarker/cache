///qqa
///2019-06-07
///CAǩ�����ù���js


/// ����ǩ������ if (!isTakeDigSign()) return;	
/// ����ǩ�����
function isTakeDigSign(){
	if(CAInit==1) IsCAWin = GetUserList();
    var caIsPass = 0;
    if (CAInit == 1){
        if (IsCAWin == "") {
            $.messager.alert("����", "���Ȳ���KEY");
            return false;
        }
        //�жϵ�ǰkey�Ƿ��ǵ�½ʱ���key
        var resultObj = dhcsys_getcacert();
        var result = resultObj.ContainerName;
        if ((result == "") || (result == "undefined") || (result == null)) {
            return false;
        }
        ContainerName = result;   ///��ȫ�ֱ�����
        caIsPass = 1;
    }
    return true;
}

/// CA����ǩ����֤����:(ҽ��ID,��¼�û�ID,��A,��S)
function InsDigitalSign(mOrditmData,LgUserID,XmlType){
	
    try {
        //1.����ǩ����֤
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var mOrditmArr = mOrditmData.split("^");
		for (var i=0; i < mOrditmArr.length; i++){
			/// ҽ����Ϣ��
			var itmsXml = GetOrdItemXml(mOrditmArr[i], XmlType);
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
                var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
                var itmXmlHash = HashData(itmXml);
                /// ǩ����Hashֵ
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// ǩ����
                var SignedData = SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + mOrditmArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + mOrditmArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

        //��ȡ�ͻ���֤��
        var varCert = GetSignCert(ContainerName);   ///�������������Ӳ����ṩ
        var varCertCode = GetUniqueID(varCert);
        
        //3.����ǩ����Ϣ��¼
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData);
            if (ret != "0") $.messager.alert("����", "����ǩ��û�ɹ�");
        } else {
            $.messager.alert("����", "����ǩ������");
        }
    }catch(e){
	    $.messager.alert("����", e.message);
    }
}


/// ����ǩ��
function InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData){
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertBatchSignRecord",{"CurrOrderItemStr":itmValData, "UserID":LgUserID, "OperationType":XmlType, "OrdItemsHashVal":itmHashData,
	    "MainSignCertCode":varCertCode, "MainSignValue":itmSignData, "ExpStr":""},function(jsonString){
		
		retFlag = jsonString;
	},'',false)
	return retFlag;
}