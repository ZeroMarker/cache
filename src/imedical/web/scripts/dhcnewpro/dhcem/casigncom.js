///qqa
///2019-06-07
///CA签名调用公共js


/// 数字签名调用 if (!isTakeDigSign()) return;	
/// 数字签名检查
function isTakeDigSign(){
	if(CAInit==1) IsCAWin = GetUserList();
    var caIsPass = 0;
    if (CAInit == 1){
        if (IsCAWin == "") {
            $.messager.alert("警告", "请先插入KEY");
            return false;
        }
        //判断当前key是否是登陆时候的key
        var resultObj = dhcsys_getcacert();
        var result = resultObj.ContainerName;
        if ((result == "") || (result == "undefined") || (result == null)) {
            return false;
        }
        ContainerName = result;   ///拿全局变量存
        caIsPass = 1;
    }
    return true;
}

/// CA数字签名认证函数:(医嘱ID,登录用户ID,开A,撤S)
function InsDigitalSign(mOrditmData,LgUserID,XmlType){
	
    try {
        //1.批量签名认证
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var mOrditmArr = mOrditmData.split("^");
		for (var i=0; i < mOrditmArr.length; i++){
			/// 医嘱信息串
			var itmsXml = GetOrdItemXml(mOrditmArr[i], XmlType);
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
                var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
                var itmXmlHash = HashData(itmXml);
                /// 签名串Hash值
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// 签名串
                var SignedData = SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + mOrditmArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + mOrditmArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

        //获取客户端证书
        var varCert = GetSignCert(ContainerName);   ///这两个函数电子病历提供
        var varCertCode = GetUniqueID(varCert);
        
        //3.保存签名信息记录
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData);
            if (ret != "0") $.messager.alert("警告", "数字签名没成功");
        } else {
            $.messager.alert("警告", "数字签名错误");
        }
    }catch(e){
	    $.messager.alert("警告", e.message);
    }
}


/// 保存签名
function InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData){
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertBatchSignRecord",{"CurrOrderItemStr":itmValData, "UserID":LgUserID, "OperationType":XmlType, "OrdItemsHashVal":itmHashData,
	    "MainSignCertCode":varCertCode, "MainSignValue":itmSignData, "ExpStr":""},function(jsonString){
		
		retFlag = jsonString;
	},'',false)
	return retFlag;
}