var m_ID        = '';
var m_ImageHash = '';
var m_alg       = 1;//1表示SM2算法,0表示RSA算法


try {
    //document.writeln('<object id="m_HncaWriteCtrl" classid="clsid:EBA69027-47ED-4C48-8157-CB563126C81C" size="0" width="0" />');
    document.writeln('<object id="m_HncaWriteCtrl" classid="clsid:9FCA06A7-A2EF-4DB4-B756-A3456DACCAA4" height="0"width="0"></object>');
} catch(e) {
    alert('请检查河南CA手写签名程序是否安装');
}

var handSignInterface = {
    m_servAddr:'',
    checkStatus: function() {
        if(!m_HncaWriteCtrl) return false;
        return true;
    },
    getEvidenceData: function() {
        //var eData = m_HncaWriteCtrl.HWAndFP(certDN, srcData, m_alg)
        //return eData;
        var signDT = new Date();
        var signMSec = signDT.getTime()
        var BusinessInfo = {
            "BusinessNum":"hw"+signMSec,
            "Type":"1",
        };
        var BusinessStr  = JSON.stringify(BusinessInfo);
        var jsonStr = m_HncaWriteCtrl.GetEvidenceData(BusinessStr);
        //var jsonStr = m_HncaWriteCtrl.GetEvidenceData(""); //传空
        if(jsonStr !="") return jsonStr;
        else alert("获取采集信息失败:"+ m_HncaWriteCtrl.GetErrorMessage());
    },
    getSignScript:function(evidenceData) {
        //return m_HncaWriteCtrl.HandWrite(certDN, srcData, m_alg);
        res = m_HncaWriteCtrl.GetSignHandPrint(evidenceData);
        if(res != "") return res;
        else alert("获取信息失败:"+ m_HncaWriteCtrl.GetErrorMessage());
    },
    getSignPhoto:function(){
        return "";
    },
    getSignFingerprint: function(evidenceData) {
        //return m_HncaWriteCtrl.FingerPrint(certDN, srcData, m_alg);
        res = m_HncaWriteCtrl.GetSignFingerPrint(evidenceData);
        if(res != "") return res;
        else alert("获取信息失败:"+ m_HncaWriteCtrl.GetErrorMessage());
    },
    getUsrID:function(evidenceData) {
        res = m_HncaWriteCtrl.GetSignBusinessNumber(evidenceData);
        if(res != "") return res;
        else alert("获取信息失败:"+ m_HncaWriteCtrl.GetErrorMessage());
    },
    getSignDataValue:function(evidenceData,src) {
        if(evidenceData == "" || src =="") {alert("用户信息或原文数据为空");return;}
        m_HncaWriteCtrl.SetServiceAddr(this.m_servAddr);
        var signDataStr = m_HncaWriteCtrl.GetSignDataValue(evidenceData,src);
        if(signDataStr!="") return signDataStr;
        else alert("获取签名失败:"+ m_HncaWriteCtrl.GetErrorMessage());
    },
    getValFromKey: function(evidenceData, valType) {
        return m_HncaWriteCtrl.GetValueFromKey(strResult, valType);
    },
    getSigValue: function(sigVal) {
        //return m_HncaWriteCtrl.GetSignValue(signID);
        return sigVal.SignDataBase64;
    },
    getTimeStamp: function(sigVal) {
        return '';
        //return m_HncaWriteCtrl.GetTimeStamp(signID);
    },
    VerifySign: function() {
        var m_ScrString = document.getElementById("random").value; 
        var  strResult = m_HncaWriteCtrl.VerifySign(m_ScrString,m_ImageHash, m_ID,m_alg);
        if (strResult.substr(0,1) == "-" || strResult == "") {
            var errorID = m_HncaWriteCtrl.GetLastError();
            alert(m_HncaWriteCtrl.GetErrorMessage(errorID));
        } else alert("验签名成功");
    },
    getLaseErr: function() {
        return m_HncaWriteCtrl.GetLastError();
    },
    getErrMsg: function(errID) {
        return m_HncaWriteCtrl.GetErrorMessage(errID)
    },
    getSignerInfo: function (episodeID) {
        return "";
    }
}

/**
     *患者CA签名
     @method __PatientCASign
     @param { nurMPDataID } 模板业务数据流水ID
     @param { saveID } 当一个模板有多个保存按钮时，用nurMPDataID流水ID无法区别。
**/
function __PatientCASignData(dataPostObj, signInputs, nurMPDataID, saveID) {
    
    try {

        var argsDatas = [];
        var signData = JSON.stringify(dataPostObj);

        var signVerify = true;
        $.each(signInputs, function (i, n) {
            var singInput = signInputs[i];
            var signInfo = $("#" + singInput).data("casign");

            var signValue = handSignInterface.getSignDataValue(signInfo.Hash, signData);

            if ('' == signValue) {
                signVerify = false;
                return false;
            }

            if ((signInfo.SignScript === "") || (handSignInterface.getSigValue(signValue) === "")) {
                throw {
                    message: $g('患者CA签名图/签名证书/签名值为空，请检查！')
                };
                signVerify = false;
                return false;
            }

            var argsData = {
                NurMPDataID: nurMPDataID,
                SaveID: saveID,
                Algorithm: "",//handSignInterface.getAlgorithm(signValue),
                BioFeature: "",//handSignInterface.getBioFeature(signValue),
                EventCert: "",//handSignInterface.getEventCert(signValue),
                SigValue: handSignInterface.getSigValue(signValue),
                TSValue: "",//handSignInterface.getTSValue(signValue),
                Version: "",//handSignInterface.getVersion(signValue),
                SignScript: signInfo.SignScript,
                HeaderImage: "",//signInfo.headerImage,
                Fingerprint: signInfo.Fingerprint,
                PlainText: signData,
                SignData: JSON.stringify(signValue),
                SingInput: singInput
            };

            argsDatas.push(argsData);
                
        });

        if (signVerify == false)
            return;

				$.each(argsDatas, function (i, n) {
					var msg = tkMakeServerCall("NurMp.CA.DHCNurCASignVerify", "InsertNurPatRecBatchSign", 
            nurMPDataID,
            saveID,           
            n.Algorithm,
            n.BioFeature,
            n.EventCert,
            n.SigValue,
            n.TSValue,
            n.Version,
            n.SignScript,
            n.HeaderImage,
            n.Fingerprint,
            n.PlainText,
            n.SignData,
            n.SingInput
            );

	        var reMsg = JSON.parse(msg)
	        if (!MsgIsOK(reMsg)) {
	            throw {
	                message: reMsg.msg
	            };
	        }
				});
    } catch (err) {     
        alert($g("患者CA签名错误！") + err.message);
        return;
    } 
}