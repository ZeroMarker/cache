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



///����������ɨ����޸�
///��Σ��ο�����ƽ̨ca�ĵ������������ͬ����,logonType,singleLogon,forceOpen
///ȫ�ֱ�����IsCA��true/false,ca_key��object
function isTakeDigSignNew(ParamObj){
	var _thisCallBack=ParamObj.callback||function(){};
	
	ParamObj.callback=function(resultObj){
		if (!resultObj.IsSucc){
			$.messager.alert("����", "֤���¼ʧ��!");
			return;
		}
		
		//�Ƿ�CA֤���¼��true:��CA֤���¼��false:��ǰ����CA֤���½
		IsCA=resultObj.IsCA; 
		if (!IsCA){
			_thisCallBack();
			return;
		}
		//alert(resultObj.ContainerName)
	    if ((resultObj.ContainerName||"")=="") {
		    $.messager.alert("����", "δ����CA,ʹ��HISϵͳǩ��!");
	        return;
	    }
	    //ContainerName = resultObj.ContainerName;   ///��ȫ�ֱ�����
	    //CACertNo=resultObj.CACertNo;
	    //ca_key=resultObj.ca_key
	    CAObj=resultObj; ///�������󷵻�
	    _thisCallBack();
	}
	
	var _thisDefParamObj=$.extend({},ParamObj)
    //�жϵ�ǰkey�Ƿ��ǵ�½ʱ���key
    dhcsys_getcacert(_thisDefParamObj); 
	
    return;
}

/// CA����ǩ����֤����:(ҽ��ID,��¼�û�ID,��A,��S)
function InsDigitalSignOld(mOrditmData,LgUserID,XmlType){
	
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

/// CA����ǩ����֤����:ɨ���¼������
/// Datas:ǩ��������
/// LgUserID:�û�ID
/// XmlType:���ո���ģ���ʶ(��A,��S)
/// CA����ǩ����֤����:(ҽ��ID,��¼�û�ID,��A,��S)
function InsDigitalSignBak(Datas,LgUserID,XmlType){
	
    try {
        //1.����ǩ����֤
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var DatasArr = Datas.split("^");
		for (var i=0; i < DatasArr.length; i++){
			/// ҽ����Ϣ��:
			var itmsXml = GetOrdItemXml(DatasArr[i], XmlType);
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
                var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
                var itmXmlHash = ca_key.HashData(itmXml);
                /// ǩ����Hashֵ
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// ǩ����
                var SignedData = ca_key.SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + DatasArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + DatasArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

		var ContainerName = ca_Obj.ContainerName; //֤��������
		var CALogonType = ca_Obj.CALogonType; //��¼��ʽ����
		var varCert = ca_Obj.varCert; //����֤��
		var varCertCode = ca_Obj.CAUserCertCode; //�û�Ψһ��ʶ
		var varCertNo = ca_Obj.CACertNo; //֤��Ψһ��ʶ

        //��ȡ�ͻ���֤��
        if(varCertCode==""){
        	varCert = ca_key.GetSignCert(ContainerName);   ///�������������Ӳ����ṩ
        	varCertCode = ca_key.GetUniqueID(varCert);
        }
        //if((CACertNo||"")!=""){varCert=CACertNo};
        
        //3.����ǩ����Ϣ��¼
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCert);
            if (ret != "0") $.messager.alert("����", "����ǩ��û�ɹ�");
        } else {
            $.messager.alert("����", "����ǩ������");
        }
    }catch(e){
	    $.messager.alert("����", e.message);
    }
}

/// CA����ǩ����֤����:���ɨ���¼������
/// Datas:ǩ��������
/// LgUserID:�û�ID
/// XmlType:���ո���ģ���ʶ(��ʿִ��F/ִ��,C/����ִ��)
///		(MDT F/ǩ��,C/����ǩ��)
/// ModuleMark:ģ���ʶ��
///		(OrdCaByDocΪҽ����ҽ��վ)
///		(EXEΪ��ʿִ��)
///		(MDTΪMDT����)
/// OtherParams:��Ҫǰ̨���ݵ���̨�Ĳ���
function InsDigitalSignNew(Datas,LgUserID,XmlType,ModuleMark,OtherParams){
	if ((CAObj.ContainerName == "") || (!CAObj.IsSucc)) return false;

	//��ȡ�ͻ���֤��
	var ContainerName = CAObj.ContainerName; //֤��������
	var CALogonType = CAObj.CALogonType; //��¼��ʽ����
	var varCert = CAObj.varCert; //����֤��
	var varCertCode = CAObj.CAUserCertCode; //�û�Ψһ��ʶ
	var varCertNo = CAObj.CACertNo; //֤��Ψһ��ʶ
	var ca_key=CAObj.ca_key;
    try {
        //1.����ǩ����֤
		var itmValData = ""; var itmHashData = ""; var itmSignData = "";
		var DatasArr = Datas.split("^");
		for (var i=0; i < DatasArr.length; i++){
			/// ��Ϣ��:�����Լ���ModuleMarkȥ��̨�������XML���Ļ�ȡ
			var itmsXml = "";
			if(ModuleMark=="OrdCaByDoc"){ ///��ҽ��վ����
				itmsXml = GetOrdItemXml(DatasArr[i], XmlType);	
			}else{
				itmsXml =GetDataXml(DatasArr[i],ModuleMark,XmlType,OtherParams);
			}
			var itmXmlArr = itmsXml.split(String.fromCharCode(2));
			for (var j = 0; j < itmXmlArr.length; j++) {
				if (itmXmlArr[j] == "") continue;
				var itmXml = itmXmlArr[j];
                var itmOpType = XmlType;
                var itmXmlHash = ca_key.HashData(itmXml);
                /// ǩ����Hashֵ
                if (itmHashData == "") itmHashData = itmXmlHash;
                else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
                /// ǩ����
                var SignedData = ca_key.SignedOrdData(itmXmlHash, ContainerName);
                if (itmSignData == "") itmSignData = SignedData;
                else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
                
                if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + DatasArr[i];
                else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + DatasArr[i];
			}
		}
		
        if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
        if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";

       
        //3.����ǩ����Ϣ��¼
        if ((itmValData != "") && (itmHashData != "") && (varCert != "") && (itmSignData != "")) {
            var ret = "";
           	if(ModuleMark=="OrdCaByDoc"){
	           	ret = InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCertNo ,ContainerName);
            }else{
            	ret = InsBatchSignNew(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData,varCertNo,ContainerName,ModuleMark);
            }
            if (ret != "0") $.messager.alert("����", "����ǩ��û�ɹ�");
        } else {
            $.messager.alert("����", "����ǩ������");
        }
    }catch(e){
	    $.messager.alert("����", e.message);
    }
}

/// ����ǩ��
function InsBatchSign(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCertNo, expStr){ 
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertSignBatchSignRecord",
		{
			"CurrOrderItemStr":itmValData,
			"UserID":LgUserID,
			"OperationType":XmlType,
			"OrdItemsHashVal":itmHashData,
	    	"MainSignCertCode":varCertCode,
	    	"MainSignValue":itmSignData,
	    	"ExpStr":expStr,
	    	"MainSignCertNo":varCertNo
		},function(jsonString){	
			retFlag = jsonString;
		},'',false)
	return retFlag;
}

/// ����ǩ��
function InsBatchSignOld(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData){
	
	var retFlag = "";
	runClassMethod("web.DHCDocSignVerify","InsertBatchSignRecord",{"CurrOrderItemStr":itmValData, "UserID":LgUserID, "OperationType":XmlType, "OrdItemsHashVal":itmHashData,
	    "MainSignCertCode":varCertCode, "MainSignValue":itmSignData, "ExpStr":""},function(jsonString){
		
		retFlag = jsonString;
	},'',false)
	return retFlag;
}

/// ȡҽ����Ϣ��
function GetOrdItemXml(Oeori, XmlType){
	
	var OrdItemXml = "";
	runClassMethod("web.DHCDocSignVerify","GetOEORIItemXML",{"newOrdIdDR":Oeori, "OperationType":XmlType},function(jsonString){
		OrdItemXml = jsonString;
	},'',false)
	return OrdItemXml;
}

/// ���CA�Ľ��󣺻�ȡHashֵ��XML����,Ҫ�����Լ���ͬ��ģ�����XML���ݻ�ȡ
function GetDataXml(DataRowId,ModuleMark,XmlType,OtherParams){
	var RetXml = "";
	runClassMethod("web.DHCEMSignVerify","GetItemXML",{"DataRowId":DataRowId, "ModuleMark":ModuleMark, "OperationType":XmlType,"OtherParams":OtherParams},function(jsonString){
		RetXml = jsonString;
	},'',false)
	return RetXml;
}

/// ����ǩ��
function InsBatchSignNew(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData ,varCertNo, expStr, ModuleMark){
	
	var retFlag = "";
	runClassMethod("web.DHCEMSignVerify","InsertSignBatchSignRecord",
		{
			"CurrDataStr":itmValData, 
			"UserID":LgUserID, 
			"OperationType":XmlType, 
			"ItemsHashVal":itmHashData,
	    	"MainSignCertCode":varCertCode, 
	    	"MainSignValue":itmSignData, 
	    	"ExpStr":expStr,
	    	"MainSignCertNo":varCertNo,
	    	"ModuleMark":ModuleMark
	    },function(jsonString){
			retFlag = jsonString;
		}
	,'',false)
	return retFlag;
}
