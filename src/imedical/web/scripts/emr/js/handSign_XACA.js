if (window.ActiveXObject || "ActiveXObject" in window) {
    try {
        document.write("<object id=\"SecCtrlIE\" classid=\"clsid:17F8D3CF-857C-4D7C-9355-7A2398930B6A\" hidden=\"true\" width=\"0\" height=\"0\" codebase=\"downfile\\npSecCtrl.cab#version=1,3,2,0\"></object>");
        document.write("<object border=1 id=\"ShowIE\" classid=\"CLSID:824C2889-BD30-4650-8E80-C5C7459B777C\"  width=\"0\" height=\"0\"></object>");
    } catch (e) {
    }
} else {
    var baseUrl = "http://localhost:9002/WebServerPrinter/Client/signPostData.do"
    var baseUrl2 = "http://localhost:10240/WebServerPrinter/Client/signPostData.do"
    
    var SecCtrlGoogle = {
        //创建时间戳 KS_TSACreate
        KS_TSACreate: function(str_type, str_Data) {
            var result;
            var interface_type="YL003";
            $.ajax({
                type :"POST",
                url : baseUrl,
                async : false,
                cache: false,
                data:JSON.stringify({"interface_type":interface_type, "str_type":Number(str_type),"str_Data":str_Data}),
                success : function(data) {
                    var mes = JSON.parse( data );
                    result=mes.str_TSAData;
                }
            });
            return result;
        },
        //验证时间戳 KS_TSAVerify
        KS_TSAVerify: function(str_type, str_TSAData, str_Data) {
            var result;
            var interface_type="YL004";
            $.ajax({
                type :"POST",
                url : baseUrl,
                async : false,
                cache: false,
                data:JSON.stringify({"interface_type":interface_type, "str_type":Number(str_type),"str_TSAData":str_TSAData, "str_Data":str_Data}),
                success : function(data) {
                    var mes = JSON.parse( data );
                    result=mes.error_code;
                }
            });
            return result;
        },
        //解析时间戳 KS_TSAParse
        KS_TSAParse: function(str_type, str_TSAData) {
            var result;
            var interface_type="YL005";
            $.ajax({
                type :"POST",
                url : baseUrl,
                async : false,
                cache: false,
                data:JSON.stringify({"interface_type":interface_type, "str_type":Number(str_type),"str_TSAData":str_TSAData}),
                success : function(data) {
                    var mes = JSON.parse( data );
                    result=mes.str_JsonData;
                }
            });
            return result;
        },
        KS_GetLastErrorMsg: function() {
            var result = "";
            var formDataJson = {
                "interface_type": "40"
            }
            var formData = JSON.stringify(formDataJson);
            $.ajax({
                type :"POST",
                url : baseUrl,
                dataType: "json",
                async : false,
                cache: false,
                data:formData,
                success : function(data) {
                    result = data.str_errormsg;
                }
            });	
            return result;
        }
    }
    
    var ShowGoogle = {    
        UP_StartPopUp: function(str_JsonInData) {
	        //var str_JsonInData = "{\"title\":\"郑州DIYI医院\",\"desc\":\"患者姓名无明显诱因出现全身乏\",\"timer\":5,\"penWidth\":16}"
            var result;
            var interface_type="UP001";
            $.ajax({
                type :"POST",
                url : baseUrl2,
                async : false,
                cache: false,
                data:JSON.stringify({"interface_type":interface_type,"str_JsonInData":str_JsonInData}),
                success : function(data) {
                    var mes = JSON.parse(data);
                    result=mes.error_code;
                }
            });
            return result;
        },
        UP_Finsh: function(str_JsonInData) {
            var result;
            var interface_type="UP002";
            $.ajax({
                type :"POST",
                url : baseUrl2,
                async : false,
                cache: false,
                data:JSON.stringify({"interface_type":interface_type,"str_JsonInData":str_JsonInData}),
                success : function(data) {
                    var mes = JSON.parse(data);
                    result=mes.str_jsonData;
                }
            });
            return result;
        },
        UP_HashData: function(str_indata,str_alg) {
            var result;
            var interface_type="UP004";
            $.ajax({
                type :"POST",
                url : baseUrl2,
                async : false,
                cache: false,
                data:JSON.stringify({"interface_type":interface_type,"str_indata":str_indata,"str_alg":Number(str_alg)}),
                success : function(data) {
                    var mes = JSON.parse(data);
                    result=mes.str_hashData;
                }
            });
            return result;
        }
    }
}

if(window.ActiveXObject || "ActiveXObject" in window) {
    var SecCtrl = SecCtrlIE;
    var Show = ShowIE; 
} else {
    var SecCtrl = SecCtrlGoogle;
    var Show = ShowGoogle;
}

var handSignInterface = {
    //创建时间戳
    TSACreate: function(str_type, str_Data) {
        var result = "";
        result = SecCtrl.KS_TSACreate(str_type, str_Data);
        if (result == "")
        {
            alert(SecCtrl.KS_GetLastErrorMsg());
        }
        return result;
    },
    TSAVerify: function (str_type, str_TSAData, str_Data) {
        var result = "";
        result = SecCtrl.KS_TSAVerify(str_type, str_TSAData, str_Data);
        if (result != 0){
            alert(SecCtrl.KS_GetLastErrorMsg());
        }
        return result;
    },
    TSAParse: function(str_type, str_TSAData) {
        var result = "";
        result = SecCtrl.KS_TSAParse(str_type, str_TSAData);
        if (result == ""){
            alert(SecCtrl.KS_GetLastErrorMsg());
        }
        return result;
    },
    //校验手写签名数据并进行时间戳签名
    getSignDataValue: function(evidenceData, toSignData) {
        var result = "";
        
        var mes = JSON.parse(evidenceData);
        var plaint = mes.FingerIdPoints+mes.FingerImage+mes.MergeImage+mes.SignImage+"hnxaca-96596";
        var hash = Show.UP_HashData(plaint,6);     //0. AUTO(自动选择，当RSA时为SHA1, SM2时为SM3) 1. SHA1 2. SHA256 3. SHA512 4. MD5 5. MD4 6. SM3
        //校验之前的手写签名数据是否正常
        var int = this.TSAVerify(2,mes.SignData,hash);
        if (0!=int){
            alert("数据验证失败，请联系管理员");
            return result;
        }
        
        //对实际的病历原文摘要做签署
        var infoSign = this.TSACreate(2,toSignData);
        mes.Algorithm = "SM2";
        mes.Version = "1.5.2.0"
        mes.InfoSign = infoSign;
        
        result =  JSON.stringify(mes);
        return result;
    },
    //手写板采集患者手签
    getEvidenceData: function(title,desc){
        try {
            title = title || "";
            desc = desc || "";
            var penWidth = 10;    //笔迹粗细  1-16，默认3
            var timer = 10;       //采集指纹时间，单位秒    到达指定时间后采集停止
            //var str_JsonInData = "{\"title\":\"郑州DIYI医院\",\"desc\":\"患者姓名无明显诱因出现全身乏\",\"timer\":5,\"penWidth\":16}"
            
            var t = {
                "title":title,
                "desc":desc,
                "penWidth":penWidth,
                "timer":timer
            };
            
            var t1 = "";
            t1 = Show.UP_StartPopUp(JSON.stringify(t));
            if (0!=t1){
                alert("调用手写板接口错误，错误码："+t1);
                return "";
            }
            
            var t2 = "";
            t2 = Show.UP_Finsh("");

            if ((typeof t2 === 'undefined')||(t2 == ""))
				return "";
				
            var mes = JSON.parse(t2);
            if ((mes.FingerIdPoints == "")||(mes.SignImage == "")||(mes.FingerImage == ""))
            	return "";
            
            var mes = JSON.parse(t2);
            var plaint = mes.FingerIdPoints+mes.FingerImage+mes.MergeImage+mes.SignImage+"hnxaca-96596";
            
            //对采集到的指纹笔迹等数据做摘要、签署
            var hash = Show.UP_HashData(plaint,6);
            var signData = this.TSACreate(2,hash);

            mes.SignData = signData;
            var result = JSON.stringify(mes);
            return result;
        } catch(e) {
            alert("调用接口异常:"+e);
            return "";
        }
    },
    checkStatus: function () {
        if ((!SecCtrl)||(!Show))
            return false;
        return true;
    },
    getSignScript: function (evidenceData) {
        if (typeof(evidenceData) == "object") {
            return evidenceData.SignImage;
        } else {
            return JSON.parse(evidenceData).SignImage;
        }
    },
    getSignFingerprint: function (evidenceData) {
        if (typeof(evidenceData) == "object") {
            return evidenceData.FingerImage;
        } else {
            return JSON.parse(evidenceData).FingerImage;
        }
    },
    getSignPhoto: function (evidenceData) {
        return "";
    },
    getSignHash: function (signValue) {
        return "";
    },
    getSignTime: function (evidenceData) {
        return (new Date()).getTime();
    },
    getAlgorithm: function (signValue) {
        if (typeof(signValue) == "object") {
            return signValue.Algorithm;
        } else {
            return JSON.parse(signValue).Algorithm;
        }
    },
    getBioFeature: function (signValue) {
        if (typeof(signValue) == "object") {
            return signValue.FingerIdPoints;
        } else {
            return JSON.parse(signValue).FingerIdPoints;
        }
    },
    getEventCert: function (signValue) {
        return "";
    },
    getSigValue: function (signValue) {
        if (typeof(signValue) == "object") {
            return signValue.InfoSign;
        } else {
            return JSON.parse(signValue).InfoSign;
        }
    },
    getTSValue: function (signValue) {
        if (typeof(signValue) == "object") {
            return signValue.InfoSign;
        } else {
            return JSON.parse(signValue).InfoSign;
        }
    },
    getVersion: function (signValue) {
        if (typeof(signValue) == "object") {
            return signValue.Version;
        } else {
            return JSON.parse(signValue).Version;
        }
    }
};


var handSign = {
    sign: function (parEditor) {
        var isSigned = false;
        if (!handSignInterface || !handSignInterface.checkStatus()) {
            alert('请配置手写签名设备');
            return;
        }

        try {
            // 获取图片
            var title = "";
            var desc = "";
            var evidenceData = handSignInterface.getEvidenceData(title,desc);
           
            if ((typeof evidenceData === 'undefined')||(evidenceData == ""))
                return;

            var signLevel = 'Patient';
            var signUserId = parEditor.userId || '';
            var userName = 'Patient';
            var actionType = parEditor.actionType || 'Append';
            var description = '患者';
            var img = handSignInterface.getSignScript(evidenceData);
            var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
            var evidenceHash = handSignInterface.getSignHash(evidenceData);
            var path = parEditor.path || '';
            // 获取编辑器hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage, path);

            if (signInfo.result == 'OK') {
                isSigned = true;
                // 签名
                var signValue = handSignInterface.getSignDataValue(evidenceData, signInfo.Digest);
                if ('' == signValue)
                {
                    throw {
                        message : '获取签名值为空！'
                    };
                    return;
                }
                
                var signValueObj = $.parseJSON(signValue);
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    Algorithm: handSignInterface.getAlgorithm(signValueObj),
                    BioFeature: handSignInterface.getBioFeature(signValueObj),
                    EventCert: handSignInterface.getEventCert(signValueObj),
                    SigValue: handSignInterface.getSigValue(signValueObj),
                    TSValue: handSignInterface.getTSValue(signValueObj),
                    Version: handSignInterface.getVersion(signValueObj),
                    SignScript: img,
                    HeaderImage: headerImage,
                    Fingerprint: fingerImage,
                    PlainText: signInfo.Digest,
                    SignData: signValue
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
                            throw {
                                message : 'SaveSignInfo 失败！' + ret.Err
                            };
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
                        throw {
                            message : 'SaveSignInfo error:' + err
                        };                        
                    }
                });

            } else {
                throw {
                    message : '签名失败'
                };
            }
        } catch (err) {
            if (isSigned) {
                parEditor.unSignedDocument();
            }
            alert(err.message);
        }
    }
};