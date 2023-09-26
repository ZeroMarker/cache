try {
    document.writeln('<OBJECT classid="clsid:D3C5BDC4-CE65-48D8-8DE0-C3DB1DF84962" id="anysign" style="height:1px;width:1px"></OBJECT>');
    //document.writeln('</object>');
} catch (e) {
    alert(e.message);
}

var handSignInterface = {
    checkStatus: function () {
        if (!anysign)
            return false;
        return true;
    },
    getEvidenceData: function (signerInfo, imgType) {

        signerInfo = signerInfo || {
            'Signer': 'Patient',
            'IDCard': {
                'Type': '1',
                'Number': '0'
            }
        };
        var _signerInfo = JSON.stringify(signerInfo);
        //0>GIF 1>JPG
        var _imgType = (imgType || 'GIF') === 'JPG' ? 1 : 0;

        var errMsg = '';
        var rv;
        //连接设备
        rv = anysign.connect_sign_device();
        if (rv == -1) {
            throw {
                name: 'connect_sign_device',
                message: '连接设备失败！'
            }
        }
        
        //设置对话框显示位置：
        this.setDlgPos();

        //设置对话框显示位置：
        rv = anysign.set_script_type(_imgType);

        //签名
        var evidenceValue = anysign.get_evidence_data(_signerInfo);
        if ('' == evidenceValue) {
            errMsg = this.getErrorMessage(anysign.getLastError());
            if ('' != errMsg)
                throw {
                    name: 'get_evidence_data',
                    message: errMsg
                }
        } else {
            //alert('获取成功！');
            return JSON.parse(evidenceValue);
        }
    },
    setDlgPos : function() {
        //获取扩展屏幕坐标
        var tStrPos = anysign.get_extend_screen_pos();
        if ('' === tStrPos) {
            //兼容大屏设备和wcom设备
            var rv = anysign.getLastError();
            alert("get_extend_screen_pos error : " + rv + this.getErrorMessage(rv));
            return;

            var width = screen.availWidth;
            var height = screen.availHeight;
            tStrPos = '{"bottom" : ' + height + ',"left" : 0,"right" : ' + width + ',"top" : 0}';
        }
        var tJsonPos = JSON.parse(tStrPos);

        var posX = (tJsonPos.right - tJsonPos.left - 1230) / 2 + tJsonPos.left;
        var posY = (tJsonPos.bottom - tJsonPos.top - 478) / 2 + tJsonPos.top;
        if (posX <= 0) { posX = 100; }
        if (posY <= 0) { posY = 100; }

        var rv = anysign.set_dlg_pos(posX, posY);
        if (rv !== 0) {
            errMsg = this.getErrorMessage(rv);
            if ('' !== errMsg)
                throw {
                    name: 'set_dlg_pos',
                    message: errMsg
                }
        }
    },
    getSignDataValue: function (evidenceHash, plainData) {

        var errMsg = '';
        evidenceHash = evidenceHash || '';
        plainData = plainData || '';
        if ('' == evidenceHash) {
            throw {
                name: 'evidenceHash',
                message: '证据hash不能为空！'
            };
        }
        if ('' == plainData) {
            throw {
                name: 'plainData',
                message: '签名原文不能为空！'
            };
        }
        plainData = anysign.Base64Encode(plainData, 'GBK');

        var sign_value = anysign.get_sign_data_value(evidenceHash, plainData);
        if ('' == sign_value) {
            errMsg = this.getErrorMessage(anysign.getLastError());
            if ('' != errMsg)
                throw {
                    name: 'get_sign_data_value',
                    message: errMsg
                };
        }
        //alert('签名成功');
        return sign_value;
    },
    getErrorMessage: function (ErrorCode) {
        var Message = '';

        switch (ErrorCode) {
        case 0:
            Message = '成功';
            break;
        case 1:
            Message = '数据的json为空';
            break;
        case 2:
            Message = '输入的json解析失败';
            break;
        case 3:
            Message = 'IDCard解析失败';
            break;
        case 4:
            Message = 'IDCard不是object';
            break;
        case 5:
            Message = '证件类型不是字符串';
            break;
        case 6:
            Message = '证件号码不是字符串';
            break;
        case 7:
            Message = '指纹图片数据为空';
            break;
        case 8:
            Message = '手写轨迹图片为空';
            break;
        case 9:
            Message = 'DeviceID为空';
            break;
        case 10:
            Message = '获取手写图片失败';
            break;
        case 11:
            Message = '获取指纹图片失败';
            break;
        case 12:
            Message = '加密后BIO_FEATURE数据为空';
            break;
        case 13:
            Message = '加密BIO_FEATURE数据失败';
            break;
        case 14:
            Message = '签名人不是字符串';
            break;
        case 15:
            Message = 'init_XTX失败';
            break;
        case 16:
            Message = '获取的签名值为空';
            break;
        case 17:
            Message = '获取签名值失败';
            break;
        case 18:
            Message = '申请证书失败';
            break;
        case 19:
            Message = '时间戳为空';
            break;
        case 20:
            Message = '请求时间戳失败';
            break;
        case 21:
            Message = '打开安全签名板失败';
            break;
        case 22:
            Message = '事件证书为空';
            break;
        case 23:
            Message = '证书请求数据为空';
            break;
        case 24:
            Message = 'Init AnySignClient失败';
            break;
        case 25:
            Message = '手写轨迹数据为空';
            break;
        case 26:
            Message = '签名包数据为空';
            break;
        case 27:
            Message = '对称解密失败';
            break;
        case 28:
            Message = '对称解密返回数据为空';
            break;
        case 29:
            Message = '解析BioFeature失败';
            break;
        case 30:
            Message = '输入的签名包为空';
            break;
        case 31:
            Message = '输入的原文为空';
            break;
        case 32:
            Message = '解析输入的签名包数据格式错误';
            break;
        case 33:
            Message = '签名值验证失败';
            break;
        case 34:
            Message = '获取证书内容数据失败';
            break;
        case 35:
            Message = '使用不支持的图片格式';
            break;
        case 36:
            Message = '设置笔迹宽度和颜色失败';
            break;
        case 37:
            Message = '设置signDevice失败';
            break;
        case 38:
            Message = 'showdialog失败';
            break;
        case 39:
            Message = '获取手写指纹信息失败';
            break;
        case 40:
            Message = '设置adaptor对象失败';
            break;
        case 41:
            Message = '设置证件类型失败';
            break;
        case 42:
            Message = '设置证件号码失败';
            break;
        case 43:
            Message = '设置签名人姓名失败';
            break;
        case 44:
            Message = '设置原文数据失败';
            break;
        case 45:
            Message = '设置crypto对象失败';
            break;
        case 46:
            Message = '构造证书请求格式json失败';
            break;
        case 47:
            Message = '获取证书请求失败';
            break;
        case 48:
            Message = '签名包中EventCert为空';
            break;
        case 49:
            Message = '签名包中TSValue为空';
            break;
        case 50:
            Message = '输入的签名算法不是有效参数';
            break;
        case 51:
            Message = '获取签名包数据中指纹图片为空';
            break;
        case 52:
            Message = '获取签名包手写轨迹图片为空';
            break;
        case 53:
            Message = '计算Biofeature哈希失败';
            break;
        case 54:
            Message = 'Biofeatur哈希值为空';
            break;
        case 55:
            Message = '设置bio_hash失败';
            break;
        case 56:
            Message = '获取证书中BIO_HASH失败';
            break;
        case 57:
            Message = '或者证书BIO_HASH内容为空';
            break;
        case 58:
            Message = '比较证书BIO_HASH失败';
            break;
        case 59:
            Message = '没有检测到签名设备';
            break;
        case 60:
            Message = '签名设备不是安全签名板,当前只支持安全签名板';
            break;
        case 61:
            Message = '用户取消签名';
            break;
        case 62:
            Message = '获取证书签名人失败';
            break;
        case 63:
            Message = '获取证书签名人为空';
            break;
        case 64:
            Message = '证件类型不正确';
            break;
        case 65:
            Message = '解析后的json不是json object';
            break;
        case 66:
            Message = '签名时间数据为空';
            break;
        case 67:
            Message = '创建签名句柄失败';
            break;
        case 68:
            Message = '输入的签名句柄为空';
            break;
        case 69:
            Message = '调用sign_begin接口失败';
            break;
        case 70:
            Message = '输入的文件名为空';
            break;
        case 71:
            Message = 'base64解码失败';
            break;
        case 72:
            Message = '输入的文件太大，无法签名或者验证。';
            break;
        case 73:
            Message = '未输入签名人姓名';
            break;
        case 74:
            Message = '未输入签名人证件信息';
            break;
        case 75:
            Message = '输入的时间戳签名值为空';
            break;
        case 76:
            Message = '输入的时间戳原文为空';
            break;
        case 77:
            Message = '格式化时间戳时间失败';
            break;
        case 78:
            Message = '验证时间戳签名失败';
            break;
        case 79:
            Message = '读取文件内容失败';
            break;
        case 80:
            Message = '验证证书有效性失败（三级根配置不正确也会导致此错误）';
            break;
        case 81:
            Message = '获取时间戳原文为空';
            break;
        case 82:
            Message = '对图像进行缩放发生错误';
            break;
        case 83:
            Message = '对图像进行格式转换发生错误';
            break;
        case 84:
            Message = '未连接扩展屏';
            break;
        case 85:
            Message = '不支持的扩展屏型号';
            break;
        case 86:
            Message = '解析证书中的哈希值失败';
            break;
        case 87:
            Message = '比较证书中的哈希与手写笔迹哈希失败';
            break;
        case 88:
            Message = '设置签名对话框宽度不正确';
            break;
        case 89:
            Message = '加载UI的配置文件错误';
            break;
        case 90:
            Message = '获取照片失败';
            break;
        case 91:
            Message = '获取视频失败';
            break;
        case 92:
            Message = '打开摄像头失败';
            break;
        case 93:
            Message = '拍照失败';
            break;
        case 94:
            Message = '拍照路径确认失败';
            break;
        case 95:
            Message = '录音路径失败';
            break;
        case 96:
            Message = '录像存储路径获取失败';
            break;
        case 97:
            Message = '打开麦克风失败';
            break;
        case 98:
            Message = '未找到编码器xvid';
            break;
        case 99:
            Message = '签名板未打开';
            break;
        case 100:
            Message = '签名板已经打开';
            break;
        case 101:
            Message = '访问签名板失败';
            break;
        case 102:
            Message = '签名板服务程序未启动';
            break;
        case 103:
            Message = '签名板服务程序错误';
            break;
        case 104:
            Message = '签名板被移除';
            break;
        case 105:
            Message = '缺少证据信息';
            break;
        case 106:
            Message = '控件窗口句柄为空';
            break;
        case 107:
            Message = '未检测到加密芯片(签字板560/370  汉王签名屏9011)';
            break;
        case 108:
            Message = '设置的配置项参数为空';
            break;
        case 109:
            Message = '不支持的修改的配置项';
            break;
        case 110:
            Message = '本次签名证据hash信息不正确';
            break;
        default:
            Message = '未知错误';
            break;
        }
        Message += ',错误码：' + ErrorCode;
        //alert(Message);
        return Message;
    },
    getSignScript: function (evidenceData) {
        for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
            if (evidenceData.Evidence[i].Type === '0')
                return evidenceData.Evidence[i].Content;
        }
        return '';
    },
    getSignFingerprint: function (evidenceData) {
        for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
            if (evidenceData.Evidence[i].Type === '1')
                return evidenceData.Evidence[i].Content;
        }
        return '';
    },
    getSignPhoto: function (evidenceData) {
        for (var i = 0, max = evidenceData.Evidence.length; i < max; i++) {
            if (evidenceData.Evidence[i].Type === '2')
                return evidenceData.Evidence[i].Content;
        }
        return '';
    },
    getSignHash: function (signValue) {
        return signValue.Hash;
    },
    getAlgorithm: function (signValue) {
		signValue = $.parseJSON(signValue);
        return signValue.SigValue[0].Algorithm;
    },
    getBioFeature: function (signValue) {
		signValue = $.parseJSON(signValue);
        return signValue.SigValue[0].BioFeature;
    },
    getEventCert: function (signValue) {
        //return signValue.SigValue.EventCert;
		return anysign.get_sign_cert(signValue);
    },
    getSigValue: function (signValue) {
		signValue = $.parseJSON(signValue);
        return signValue.SigValue[0].SigValue;
    },
    getTSValue: function (signValue) {
        //return signValue.SigValue.TSValue;
		return anysign.get_ts_value(signValue);
    },
    getVersion: function (signValue) {
        //return signValue.SigValue.Version;
		return anysign.get_version();
    },
    getUsrID: function (evidenceData) {
        return this.getSignHash(evidenceData) + (new Date()).getTime();
    }
};

var handSign = {
    sign: function (parEditor) {
        var isSigned = false;
        if (!handSignInterface && !handSignInterface.checkStatus()) {
            alert('请配置手写签名设备');
            return;
        }

        try {
            // 获取图片
            var signerInfo;
            if (typeof parEditor.episodeID !== 'undefined')
            {
	            signerInfo = {
		            'Signer': 'Patient',
		            'IDCard': {
		                'Type': '1',
		                'Number': parEditor.episodeID
		            }
		        };
	        }
            var evidenceData = handSignInterface.getEvidenceData(signerInfo);
            
            if (typeof evidenceData === 'undefined')
                return;
            //evidenceData = $.parseJSON(evidenceData);

            var signLevel = 'Patient';
            var signUserId = handSignInterface.getUsrID(evidenceData);
            var userName = 'Patient';
            var actionType = parEditor.actionType || 'Append';
            var description = '患者';
            var img = handSignInterface.getSignScript(evidenceData);
            var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
            // 获取编辑器hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage);

            if (signInfo.result == 'OK') {
                isSigned = true;
                // 签名
                var signValue = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo.Digest);
                if ('' == signValue)
                    return;
				
                //signValue = $.parseJSON(signValue);
				if ((img === "")||(handSignInterface.getEventCert(signValue) === "")||(handSignInterface.getSigValue(signValue) === ""))
				{
					throw {
						message : '签名图/签名证书/签名值为空，请检查！'
                    };
					return;
				}
				
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    Algorithm: handSignInterface.getAlgorithm(signValue),
                    BioFeature: handSignInterface.getBioFeature(signValue),
                    EventCert: handSignInterface.getEventCert(signValue),
                    SigValue: handSignInterface.getSigValue(signValue),
                    TSValue: handSignInterface.getTSValue(signValue),
                    Version: handSignInterface.getVersion(signValue),
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
            if (err.message === '用户取消签名,错误码：61') {
                return;
            }
            else if (isSigned) {
                parEditor.unSignedDocument();
            }
            alert(err.message);
        }
    }
};
