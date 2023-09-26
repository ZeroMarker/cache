try {
    document.writeln('<OBJECT classid="clsid:19DE5A4B-0F24-41EE-A6C6-624653975386" id="netcaHWC" style="height:1px;width:1px"></OBJECT>');
    //document.writeln('</object>');
} catch (e) {
    alert(e.message);
}

var handSignInterface = {
    hostAddress: '',
    port: '',
    getAnySignLocation: function () {
        var that = this;
        $.ajax({
            type: 'GET',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: { Action: 'GetAnySignLocation'},
            success: function (ret) {
                ret = $.parseJSON(ret);
                if (ret.Err || false) {
                    throw {
                        message: 'getAnySignLocation 失败！' + ret.Err
                    };
                } else {
                    if (ret.Value==='') {
                        throw {
                            message: 'AnySignLocation 未设置！'
                    };
                    } else {
                        that.hostAddress = ret.Value.split(':')[0];
                        that.port = ret.Value.split(':')[1];
                    }
                }
            },
            error: function (err) {
                throw {
                    message: 'getAnySignLocation error:' + err
                };
            }
        });    
    },
    initCtrl: function () {
        //初始化ActiveX控件,注意配置ip&port todo
        //测试服务地址:'14.18.158.147','20943'
        //var hostAddress = '14.18.158.147';
        //var port = '20943';
        if (this.hostAddress === '') {
            this.getAnySignLocation();
        }
        netcaHWC.InitControl(this.hostAddress, this.port);
    },
    checkStatus: function () {
        if (!netcaHWC)
            return false;
        return true;
    },
    getErrorMessage: function (data) {
        if (data.respcode) {
            return data.respcode + ':' + data.respmsg;
        }
        return '';
    },
    getBioFeature: function (signValue) {
        return signValue.BioFeature;
    },
    getEvidenceId: function (signValue) {
        return signValue.EvidenceId;
    },
    getSignFingerprint: function (signValue) {
        return signValue.FingerPrint;
    },
    getSignScript: function (signValue) {
        return signValue.SignScript;
    },
    getSigValue: function (signValue) {
        return signValue.SigValue;
    },
    getUsrID: function (evidenceData) {
        return ''+(new Date()).getTime();
    },
    enableMouse: function () {
        netcaHWC.EnableMouse();
    },
    disableMouse: function () {
        netcaHWC.DisableMouse();
    },
    startFeatureCapture: function (sourceData, mlocalid, captureCallBack) {
        netcaHWC.StartFeatureCapture(sourceData, mlocalid, 5, captureCallBack);
    },
    bindingClickOKBtn: function (okCallBack) {
        netcaHWC.BindingClickOKBtn(okCallBack);
    },
    subStituteSource: function (plaintext) {
        //替代控件中的凭证原文
        netcaHWC.SubstituteSource(plaintext);
    },
    //以下为网证通提供的验签接口
    //都先调用inVerify才能使用
    initVerify: function (evidenceId, signB64Data) {
        //initVerify = function (evidenceId, signB64Data)
        var res = netcaHWC.InitEvidenceVerify(evidenceId, signB64Data, this.hostAddress, this.port);
        if (res == -1) {
            alert("初始化失败");
        }
    },
    fpFeatureCompare: function () {
        //指纹特征比对
        var res = netcaHWC.FingerprintFeatureCompare();
        if (res == -1) {
            alert("初始化失败");
        }
    },
    verifyEvidenceSign: function (evidenceId, signB64) {
        var res = netcaHWC.VerifyEvidenceSign(evidenceId, signB64);
        return res;
    },
    verifyFingerprintImg: function (fpImgSourceB64) {
        var res = netcaHWC.VerifyFingerprintImg(fpImgSourceB64);
        return res;
    },
    verifyHandWriteImg: function (hwSourceB64) {
        //var hwSourceB64 = document.getElementById("v_HWImageB64").value;
        var res = netcaHWC.VerifyHandWriteImg(hwSourceB64);
        return res;
    },
    verifySourceData: function (sourceData) {
        //var sourceData = document.getElementById("v_SourceData").value;
        var res = netcaHWC.VerifySourceData(sourceData);
        return res;
    }
};

var handSign = {
    sign: function (parEditor) {
        if (!handSignInterface && !handSignInterface.checkStatus()) {
            alert('请配置手写签名设备');
            return;
        }
        try {
            handSignInterface.initCtrl();
            //handSignInterface.enableMouse();
            var sequenceId = getSequenceId();
        }
        catch (err) {
            alert(err.message);
            return;
        }        
        
        function getSequenceId() {
            var sequenceId = '';
            $.ajax({
                type: 'GET',
                dataType: 'text',
                url: '../EMRservice.Ajax.anySign.cls',
                async: false,
                cache: false,
                data: { Action: 'GetSequenceId'},
                success: function (ret) {
                    ret = $.parseJSON(ret);
                    if (ret.Err || false) {
                        throw {
                            message: 'getSequenceId 失败！' + ret.Err
                        };
                    } else {
                        sequenceId = ret.Value;
                    }
                },
                error: function (err) {
                    throw {
                        message: 'getSequenceId error:' + err
                    };
                }
            });
            return sequenceId;            
        }
        
        // 向后台保存
        function commit(argsData) {
            var signId = '';
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
                            message: 'SaveSignInfo 失败！' + ret.Err
                        };
                    } else {
                        if ('-1' == ret.Value) {
                            throw {
                                message: 'SaveSignInfo 失败！'
                            };
                        } else {
                            signId = ret.Value;
                        }
                    }
                },
                error: function (err) {
                    throw {
                        message: 'SaveSignInfo error:' + err
                    };
                }
            });
            return signId;
        }
        
        function revokeSignedDoc(){
            if (isSigned) {
                parEditor.unSignedDocument();
                isSigned = false;
            }            
        }

        var isSigned = false;
        var signInfo;
        var signLevel = 'Patient';
        var signUserId = handSignInterface.getUsrID();
        var userName = 'Patient';
        var actionType = 'Append';
        var description = '患者';            
        //启动
        handSignInterface.startFeatureCapture('', sequenceId, function (data) {//debugger;
            if (!isSigned)
                return;
            var signValue = JSON.parse(data);
            var errMsg = handSignInterface.getErrorMessage(signValue);
            if (errMsg !== ''){
                alert(errMsg);
				revokeSignedDoc();
				return;
			}
            if (!signValue.SigValue || signValue.SigValue.Total < 1) {
                revokeSignedDoc();
            }
            signValue = signValue.SigValue[0];
            try {
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    BioFeature: handSignInterface.getBioFeature(signValue),
                    SigValue: handSignInterface.getSigValue(signValue),
                    SignScript: handSignInterface.getSignScript(signValue),
                    Fingerprint: handSignInterface.getSignFingerprint(signValue),
                    Version: sequenceId,
                    PlainText: signInfo.Digest
                };
                var signId = commit(argsData);
                parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);

            } catch (err) {
                revokeSignedDoc();
                alert(err.message);
            }
            finally {
                //handSignInterface.disableMouse();
            }
        });

        handSignInterface.bindingClickOKBtn(function (evidenceData) {
            revokeSignedDoc();
            if (typeof evidenceData === 'undefined')
                return;
            var signLevel = 'Patient';
            var signUserId = handSignInterface.getUsrID(evidenceData);
            var userName = 'Patient';
            var actionType = 'Append';
            var description = '患者';
            var img = evidenceData;
            // 获取编辑器hash
            signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description);

            if (signInfo.result == 'OK') {
                isSigned = true;
                // 网证通接口在这里更新原文(signInfo.Digest),真正生成签名值
                handSignInterface.subStituteSource(signInfo.Digest);
            } else {
                isSigned = false;
                /*throw {
                    message: '签名失败'
                };*/
				alert('签名失败');
            }
        });        
    }
};
