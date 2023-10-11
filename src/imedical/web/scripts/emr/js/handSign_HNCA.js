var m_ID        = '';
var m_ImageHash = '';
var m_alg       = 1;//1表示SM2算法，0表示RSA算法
var m_servAddr  = 'http://testc.9611111.com/CTI_HandWriteServer/servlet/CTIHandWriteServlet';

try {
    //document.writeln('<object id="m_HncaWriteCtrl" classid="clsid:EBA69027-47ED-4C48-8157-CB563126C81C" size="0" width="0" />');
    document.writeln('<object id="m_HncaWriteCtrl" classid="clsid:9FCA06A7-A2EF-4DB4-B756-A3456DACCAA4" height="0"width="0"></object>');
    document.writeln('<object id="HncaCtrl" classid="clsid:990AC2E1-4439-436A-823A-F96855361CB3" height="0" width="0"></object>');
} catch(e) {
    alert('请检查河南CA手写签名程序是否安装');
}

var handSignInterface = {
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
        if(evidenceData == "" || src =="") {alert("用户信息或者原文数据为空!");return;}
        m_HncaWriteCtrl.SetServiceAddr(m_servAddr);
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
        } else alert("验签名成功!");
    },
    getLaseErr: function() {
        return m_HncaWriteCtrl.GetLastError();
    },
    getErrMsg: function(errID) {
        return m_HncaWriteCtrl.GetErrorMessage(errID)
    }
}

var handSign = {
    sign: function (parEditor) {
        var isSigned = false;
        if (!handSignInterface && !handSignInterface.checkStatus()) {
            alert('请配置手写签名设备');
            return;
        }
        try {
            // 获取图片
            var evidenceData = handSignInterface.getEvidenceData();
            //debugger;
            if (typeof evidenceData === 'undefined') return;
            //evidenceData = $.parseJSON(evidenceData);
            var signLevel = 'Patient';
            var signUserId = parEditor.userId || handSignInterface.getUsrID(evidenceData);
            var userName = 'Patient';
            var actionType = 'Append';
            var description = '患者';
            var img = handSignInterface.getSignScript(evidenceData);
            var headerImage = ''; //handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
            var path = parEditor.path || '';
            // 获取编辑器hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage, path);
            if (signInfo.result == 'OK') {
                isSigned = true;
                // 签名
                var signValue = handSignInterface.getSignDataValue(evidenceData, signInfo.Digest);
                debugger;
                if ('' == signValue)
                    return;
                signValue = $.parseJSON(signValue);
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    //Algorithm: handSignInterface.getAlgorithm(signValue),
                    //BioFeature: handSignInterface.getBioFeature(signValue),
                    //EventCert: handSignInterface.getEventCert(signValue),
                    Algorithm: '',
                    BioFeature: '',
                    EventCert: '',
                    SigValue: handSignInterface.getSigValue(signValue),
                    //SigValue:signValue,
                    //TSValue: handSignInterface.getTSValue(signValue),
                    TSValue:'',
                    //Version: handSignInterface.getVersion(signValue),
                    Version: '',
                    SignScript: img,
                    HeaderImage: headerImage,
                    Fingerprint: fingerImage,
                    PlainText: signInfo.Digest
                };
                $.ajax({
                    type: 'POST',
                    dataType: 'text',
                    url: '../EMRservice.Ajax.anySign.cls',
                    async: false,
                    cache: false,
                    data: argsData,
                    success: function (ret) {
                        ret = $.parseJSON(ret);
                        if (ret.Err || false) {
                            throw { message : 'SaveSignInfo 失败！' + ret.Err };
                        } else {
                            if ('-1' == ret.Value) {
                                throw {
                                    message : 'SaveSignInfo 失败！'
                                };
                            } else {
                                var signId = ret.Value;
                                parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
                            }
                        }
                    },
                    error: function (err) {
                        throw { message : 'SaveSignInfo error:' + err };
                    }
                });
            } else {
                throw { message : '签名失败' };
            }
        } catch (err) {
            //if (err.message === '用户取消签名,错误码：61') { return; }
            if (isSigned) { parEditor.unSignedDocument(); }
            alert(err.message);
        }
    }
};

var handSignIFtest = {
    sign: function () {
        if (!handSignInterface && !handSignInterface.checkStatus()) alert('请配置手写签名设备');
        try {
            // 获取图片
            var evidenceData = handSignInterface.getEvidenceData();
            //测试数据
            //var evidenceData='{ "BusinessNum": "handwritetest20181019007", "FPProperValueBase64": "", "FingerPic": "Qk02GQAAAAAAADYAAAAoAAAAKAAAACgAAAABACAAAAAAAAAZAAAAAAAAAAAAAAAAAAAAAAAA////AP///wD///8A////AP///wD///8A////AOjo/wD5+f8Ay8v/AN7e/wD///8Aj4//AOrq/wD///8A8PD/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A+/v/APz8/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wDFxf8A39//AO3t/wDExP8A3d3/AJyc/wD///8A3t7/AOfn/wC1tf8Aysr/AP///wDq6v8A////AP///wD///8A////AP///wD///8A////APr6/wD19f8A1tb/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8Atrb/AG1t/wDY2P8AlZX/AKmp/wC5uf8AgYH/AMjI/wDS0v8Axsb/AMLC/wD39/8A////APv7/wD///8A////APn5/wD///8A+vr/AP///wDy8v8A7Oz/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A/f3/AFZW/wCkpP8AuLj/AK2t/wDz8/8Av7//AKur/wBoaP8A2dn/AJmZ/wDS0v8AtbX/AM7O/wD7+/8A3Nz/APf3/wD///8A0dH/AL+//wD///8Aycn/AI2N/wD+/v8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AL6+/wBHR/8A09P/ALCw/wBjY/8AVFT/AIKC/wCxsf8AqKj/AGho/wDNzf8AxMT/AOTk/wD///8AvLz/AP///wC3t/8AxMT/AODg/wD///8A+vr/AHFx/wD5+f8Arq7/AO/v/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wCNjf8ARUX/AGVl/wANDf8AcnL/AP39/wD///8A0dH/AK+v/wCBgf8AsrL/AIyM/wDk5P8A////AEtL/wD///8Ao6P/AMbG/wDq6v8A////AN7e/wD///8AhYX/ANfX/wDy8v8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A1dX/AP///wD///8A39//AHBw/wDn5/8ATU3/AHl5/wBXV/8AsrL/AJ2d/wC1tf8Apqb/ANPT/wDh4f8A////AKen/wDc3P8A2Nj/ALGx/wD///8A1tb/AL6+/wCgoP8A////APn5/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AM/P/wBlZf8ACQn/AGxs/wCDg/8AdHT/AH9//wCrq/8AKir/AMTE/wCbm/8AKyv/AL6+/wCysv8AlJT/AI+P/wCvr/8Aqan/AP///wDR0f8A7Oz/AP///wD///8Aqqr/APT0/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AOvr/wDJyf8A7u7/AMrK/wDKyv8Ak5P/AJGR/wAkJP8Azc3/ALKy/wCEhP8Ah4f/ANTU/wCRkf8Avb3/ANzc/wDy8v8A39//AP///wChof8A5+f/AP///wDLy/8AtLT/AJ2d/wDS0v8A4OD/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A1dX/AKur/wB7e/8AjIz/AHp6/wB4eP8AS0v/AOrq/wA6Ov8AnZ3/AFdX/wD///8A3t7/AIuL/wBISP8Arq7/AO3t/wC/v/8AqKj/AOjo/wDHx/8A5ub/AImJ/wDq6v8Am5v/AOPj/wDu7v8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////ANjY/wBRUf8ARkb/AHZ2/wBJSf8AoKD/AJ6e/wBdXf8Ag4P/AGpq/wCAgP8Apqb/APDw/wCwsP8Ap6f/AMDA/wDa2v8AwMD/AG1t/wDi4v8Aysr/AMjI/wC5uf8Ay8v/AFZW/wDJyf8A7u7/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wDv7/8Aqan/AI6O/wC1tf8ANjb/ALS0/wBoaP8AQ0P/AKKi/wCPj/8AQED/AGRk/wDl5f8AlZX/AMvL/wB3d/8A1tb/AO7u/wDj4/8Alpb/ANjY/wDs7P8AlZX/AKKi/wCysv8Ara3/APb2/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AGlp/wBPT/8Am5v/AIyM/wCenv8Ag4P/AJmZ/wB1df8Aenr/ANzc/wCcnP8A6Oj/AIKC/wCHh/8AwcH/AICA/wCpqf8A9vb/APHx/wBcXP8A5eX/APX1/wDIyP8A7e3/AISE/wCCgv8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wBQUP8AT0//AAYG/wD8/P8Ae3v/AMXF/wD///8APDz/AGdn/wCMjP8Ab2//AK+v/wDT0/8AV1f/AJmZ/wDr6/8AoqL/AOTk/wD+/v8A7+//AK6u/wBtbf8AUlL/AOvr/wC1tf8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wDg4P8Ah4f/ALGx/wAdHf8A////ADIy/wD39/8AzMz/AF9f/wDR0f8AaGj/ALy8/wBzc/8Ap6f/AP///wB9ff8Aw8P/ALq6/wDy8v8Ax8f/AMvL/wBycv8A////AFBQ/wCrq/8A////APr6/wD6+v8A////AP///wD///8A////AP///wD6+v8A////AP///wD///8A////AP///wD///8A9/f/AP///wBfX/8Ap6f/AP///wBFRf8Avr7/AH9//wBFRf8Ar6//AHp6/wA8PP8AtbX/ABwc/wCxsf8Avr7/AH5+/wD29v8AzMz/AJ+f/wD///8A0tL/AHZ2/wCNjf8Aior/ALa2/wDw8P8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wA6Ov8APDz/AE5O/wCjo/8Ad3f/AHZ2/wAmJv8Aysr/AC4u/wB0dP8Ara3/AGdn/wBra/8Ap6f/AMXF/wDAwP8Aqan/APj4/wCzs/8Aurr/AHJy/wDKyv8AvLz/AIKC/wDBwf8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD7+/8AvLz/ALe3/wD4+P8Aurr/AEtL/wDHx/8AhIT/APDw/wD///8AsbH/AJ+f/wDCwv8A6ur/AOTk/wDb2/8A7+//AN/f/wCWlv8A5+f/AOzs/wC3t/8ANTX/AJOT/wCVlf8An5//APX1/wD7+/8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AM3N/wBubv8Avr7/ACAg/wDc3P8AoaH/AOHh/wBoaP8AKCj/ANDQ/wCWlv8AUlL/AF5e/wCamv8A1tb/ADQ0/wD///8Ap6f/ANHR/wDh4f8AsbH/AG9v/wCHh/8ASkr/ANbW/wDo6P8A////AP///wD///8A+vr/APr6/wD///8A////AP///wD///8A////AP///wD///8A////AP///wDa2v8AkJD/AElJ/wD///8A09P/ALGx/wCWlv8A////AJCQ/wD9/f8An5//AKGh/wBxcf8A+fn/AMnJ/wCHh/8Aycn/AMTE/wCJif8AYWH/AGRk/wBra/8Afn7/ALGx/wC3t/8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A/Pz/AP///wBycv8A////ADs7/wCHh/8Avb3/AFtb/wCfn/8AcnL/AKmp/wB4eP8AYGD/AJ6e/wCenv8Ajo7/ALOz/wC+vv8A1tb/AFJS/wCmpv8Aj4//AJqa/wCamv8A+/v/ANDQ/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AOrq/wAAAP8Ad3f/ALGx/wBfX/8AfX3/AMfH/wCRkf8AwMD/ALy8/wAZGf8ASkr/AFlZ/wB9ff8ATk7/AK6u/wDS0v8Abm7/AJGR/wCpqf8AkpL/ANbW/wDPz/8Ax8f/ANzc/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD8/P8A+Pj/AP///wAREf8A7e3/ANPT/wB0dP8Azc3/AHR0/wDp6f8AeXn/AMTE/wBjY/8A3d3/AHV1/wBpaf8AaWn/AF9f/wDS0v8ArKz/ANHR/wCOjv8AQED/AKio/wDp6f8A+Pj/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8Aw8P/AI6O/wAhIf8A6ur/AEhI/wBra/8AyMj/AGxs/wCKiv8AlZX/AKCg/wBYWP8AdHT/AAAA/wBGRv8Ajo7/ACsr/wCqqv8Ahob/ALGx/wCpqf8A////ACQk/wCNjf8A0tL/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wCoqP8Aenr/ABYW/wCcnP8Ara3/AHV1/wA6Ov8AkJD/AFhY/wBkZP8A9fX/AMXF/wDMzP8A////AO7u/wDLy/8Ay8v/AP///wDt7f8AWVn/AFRU/wA/P/8A1dX/AMTE/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AxcX/AGVl/wClpf8Ai4v/AAAA/wBdXf8A7Oz/AL6+/wD///8A4eH/AE5O/wCVlf8AV1f/AFJS/wBcXP8AhYX/AHp6/wCbm/8ADw//AJmZ/wA9Pf8A0tL/AK+v/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A9fX/AL29/wAAAP8AkJD/AE9P/wA3N/8AoKD/ACUl/wCnp/8AQED/AGpq/wBxcf8AgID/AGlp/wD5+f8AAAD/AL29/wAiIv8AwsL/AD4+/wBCQv8AaWn/AJqa/wDg4P8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AObm/wD///8Ap6f/ABIS/wBJSf8AwMD/AFJS/wA9Pf8Ah4f/AHl5/wC8vP8Ad3f/AI6O/wA3N/8A6en/AHV1/wCkpP8AHx//AKen/wBLS/8AWVn/AOXl/wC8vP8AcXH/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wA6Ov8AbW3/AJSU/wBdXf8Al5f/AGFh/wC2tv8AR0f/AL29/wCYmP8AnZ3/ALCw/wCEhP8Ab2//AHJy/wB+fv8AwMD/ALq6/wBtbf8Avr7/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wBPT/8A1tb/AFpa/wBCQv8AHR3/ACMj/wCoqP8AOzv/AHJy/wCVlf8AMDD/AI2N/wBtbf8AlZX/ALGx/wCNjf8AuLj/AHR0/wBMTP8AYGD/ADMz/wD///8A+/v/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A5+f/ANfX/wBVVf8AZ2f/AG1t/wD///8Avr7/APX1/wCAgP8AaGj/AElJ/wAvL/8Abm7/AI6O/wCbm/8Ahob/AIqK/wBra/8AqKj/AL+//wDLy/8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wBtbf8AfHz/AC0t/wBaWv8Avr7/AIiI/wDNzf8AV1f/AGtr/wC+vv8A9fX/ALW1/wCAgP8AiIj/AKCg/wCCgv8AcHD/AGdn/wDi4v8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8Azc3/ADY2/wClpf8Ak5P/AGZm/wAAAP8Anp7/AGtr/wAvL/8Al5f/AI2N/wBtbf8At7f/ACoq/wC0tP8AnZ3/AHFx/wCTk/8A4+P/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AtLT/ADEx/wBcXP8AeXn/ADQ0/wCNjf8Aysr/AIiI/wCsrP8AhIT/AHl5/wCLi/8Aubn/AKGh/wDW1v8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wA9Pf8Af3//AIOD/wCAgP8Aj4//ABMT/wCmpv8AjY3/AHV1/wC0tP8ATEz/AFRU/wCPj/8A/v7/AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AIqK/wApKf8Ag4P/AIWF/wC0tP8A8/P/AHx8/wBycv8AiYn/AJyc/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A0ND/AI+P/wDCwv8A////APz8/wD39/8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////APz8/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////APT0/wD///8A7u7/APb2/wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AA==", "HandWritePic": "Qk02MgAAAAAAADYAAAAoAAAAUAAAACgAAAABACAAAAAAAAAyAAAAAAAAAAAAAAAAAAAAAAAA////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////APr6+gCBgYEAVFRUAIiIiAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wBSUlIAAAAAAImJiQC/v78AgYGBAAAAAABQUFAA////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8ACQkJAHd3dwD///8A////AP///wD///8A////AJ6engAAAAAAnZ2dAP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AGFhYQBzc3MA////AP///wD///8A////AP///wD///8A////AP///wA4ODgAGhoaAP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AAAAAAP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wCvr68AAAAAAO7u7gD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AI+PjwBxcXEA////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wDs7OwAAAAAANPT0wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8APDw8AMzMzAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AAAAAAMXFxQD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wAlJSUA5+fnAP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AAAAAALS0tAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AC0tLQDFxcUA////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8AAAAAAIODgwD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A4ODgAPn5+QD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8APj4+APX19QD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wA=", "Type": "1" }'
            console.log(evidenceData);
            if (typeof evidenceData === 'undefined') return;
            //evidenceData = $.parseJSON(evidenceData);
            console.log(handSignInterface.getUsrID(evidenceData));
            console.log(handSignInterface.getSignScript(evidenceData));
            console.log(handSignInterface.getSignFingerprint(evidenceData));
            console.log(handSignInterface.getSignDataValue(evidenceData, 'test'));
            /*
            Algorithm: handSignInterface.getAlgorithm(signValue),
            BioFeature: handSignInterface.getBioFeature(signValue),
            EventCert: handSignInterface.getEventCert(signValue),
            SigValue: handSignInterface.getSigValue(signValue),
            TSValue: handSignInterface.getTSValue(signValue),
            Version: handSignInterface.getVersion(signValue),
             */
        } catch (err){debugger;}
    }
}