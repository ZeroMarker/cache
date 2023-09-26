try {
    document.writeln('<OBJECT classid="clsid:D3C5BDC4-CE65-48D8-8DE0-C3DB1DF84962" id="anysign" style="height:1px;width:1px"></OBJECT>');
    //document.writeln('</object>');
} catch (e) {
    alert(e.message);
}

var jParam = null;
var sigHnd = 0

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
                'Type': '',
                'Number': ''
            }
        };
        var _signerInfo = JSON.stringify(signerInfo);
        //0>GIF 1>JPG
        var _imgType = (imgType || 'GIF') === 'JPG' ? 1 : 0;
        var errMsg = '';
        var rv;
        //�����豸
        try {
            rv = anysign.connect_sign_device();
            if (rv == -1) {
                throw {
                    name: 'connect_sign_device',
                    message: '�����豸ʧ�ܣ�'
                }
            }
            //���öԻ�����ʾλ�ã�
            rv = anysign.set_dlg_pos(0, 0);
            if (rv != 0) {
                errMsg = this.getErrorMessage(rv);
                if ('' != errMsg)
                    throw {
                        name: 'set_dlg_pos',
                        message: errMsg
                    }
            }
            rv = anysign.set_script_type(_imgType);
            //ǩ��
            var evidenceValue = anysign.get_evidence_data(_signerInfo);
            if ('' == evidenceValue) {
                errMsg = this.getErrorMessage(anysign.getLastError());
                if ('' != errMsg)
                    throw {
                        name: 'get_evidence_data',
                        message: errMsg
                    }
            } else {
                //alert('��ȡ�ɹ���');
                return JSON.parse(evidenceValue);
            }
        } catch(e) {
            /*���������BJCA�ϰ汾�ķ���ʽǩ���ӿڣ�����ǩ����sign_end�����������
             *getSignDataValue�������ǩ������֮ǰǩ���ؼ���һֱ����Ĵ˴���Ӱ��
             *IE�ĵ���ģʽ�����µ����з�������ǩ�����壬��Ҫ�鿴�����еı�������Ҫ
             *��ϵ��дdebugger��Ҫʹ��alert��console.log
             */
            rv = anysign.create_sig_handle();
            if(rv > 0) {
                jParam = JSON.stringify(signerInfo);
                sigHnd = rv;
                rv = anysign.sign_begin(sigHnd);
                if(rv==61) { throw { message : '�û�ȡ��ǩ��,�����룺61' }; }
                var signScript = "";
                var fingerPrnt = "";
                if(rv==0) {
                    //1>gif 2>jpg
                    signScript = anysign.get_sign_script_by_handle(sigHnd, 1);
                    fingerPrnt = anysign.get_sign_fingerprint_by_handle(sigHnd, 2);
                }/* else {
                    signScript = "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";
                    fingerPrnt = "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";
                }*/
                var evidenceStr = "{" +
                    "\"Evidence\": [{" +
                        "\"Content\": \"" + signScript + "\"," +
                        "\"Type\": \"0\"" +
                    "},{" +
                        "\"Content\": \"" + fingerPrnt + "\"," +
                        "\"Type\": \"1\"" +
                    "},{" +
                        "\"Content\": \"\"," +
                        "\"Type\": \"2\"" +
                    "}]," +
                    "\"Hash\": \"Patient\"" +
                "}";
                try {
                    console.log(eval("("+evidenceStr+")"));
                } catch(e) {}
                return eval("("+evidenceStr+")");
            }
        }
    },
    getSignDataValue: function (evidenceHash, plainData) {
        var sign_value = "";
        if(sigHnd>0) {
            sign_value = anysign.sign_end(jParam, plainData, sigHnd);
            sigHnd = 0;
        } else {
            var errMsg = '';
            evidenceHash = evidenceHash || '';
            plainData = plainData || '';
            if ('' == evidenceHash) {
                throw {
                    name: 'evidenceHash',
                    message: '֤��hash����Ϊ�գ�'
                };
            }
            if ('' == plainData) {
                throw {
                    name: 'plainData',
                    message: 'ǩ��ԭ�Ĳ���Ϊ�գ�'
                };
            }
            plainData = anysign.Base64Encode(plainData, 'GBK');
            sign_value = anysign.get_sign_data_value(evidenceHash, plainData);
        }
        if ('' == sign_value) {
            errMsg = this.getErrorMessage(anysign.getLastError());
            if ('' != errMsg) {
                throw {
                    name: 'get_sign_data_value',
                    message: errMsg
                };
            }
        }
        //alert('ǩ���ɹ�');
        return sign_value;
    },
    getErrorMessage: function (ErrorCode) {
        var Message = '';

        switch (ErrorCode) {
        case 0:
            Message = '�ɹ�';
            break;
        case 1:
            Message = '���ݵ�jsonΪ��';
            break;
        case 2:
            Message = '�����json����ʧ��';
            break;
        case 3:
            Message = 'IDCard����ʧ��';
            break;
        case 4:
            Message = 'IDCard����object';
            break;
        case 5:
            Message = '֤�����Ͳ����ַ���';
            break;
        case 6:
            Message = '֤�����벻���ַ���';
            break;
        case 7:
            Message = 'ָ��ͼƬ����Ϊ��';
            break;
        case 8:
            Message = '��д�켣ͼƬΪ��';
            break;
        case 9:
            Message = 'DeviceIDΪ��';
            break;
        case 10:
            Message = '��ȡ��дͼƬʧ��';
            break;
        case 11:
            Message = '��ȡָ��ͼƬʧ��';
            break;
        case 12:
            Message = '���ܺ�BIO_FEATURE����Ϊ��';
            break;
        case 13:
            Message = '����BIO_FEATURE����ʧ��';
            break;
        case 14:
            Message = 'ǩ���˲����ַ���';
            break;
        case 15:
            Message = 'init_XTXʧ��';
            break;
        case 16:
            Message = '��ȡ��ǩ��ֵΪ��';
            break;
        case 17:
            Message = '��ȡǩ��ֵʧ��';
            break;
        case 18:
            Message = '����֤��ʧ��';
            break;
        case 19:
            Message = 'ʱ���Ϊ��';
            break;
        case 20:
            Message = '����ʱ���ʧ��';
            break;
        case 21:
            Message = '�򿪰�ȫǩ����ʧ��';
            break;
        case 22:
            Message = '�¼�֤��Ϊ��';
            break;
        case 23:
            Message = '֤����������Ϊ��';
            break;
        case 24:
            Message = 'Init AnySignClientʧ��';
            break;
        case 25:
            Message = '��д�켣����Ϊ��';
            break;
        case 26:
            Message = 'ǩ��������Ϊ��';
            break;
        case 27:
            Message = '�Գƽ���ʧ��';
            break;
        case 28:
            Message = '�Գƽ��ܷ�������Ϊ��';
            break;
        case 29:
            Message = '����BioFeatureʧ��';
            break;
        case 30:
            Message = '�����ǩ����Ϊ��';
            break;
        case 31:
            Message = '�����ԭ��Ϊ��';
            break;
        case 32:
            Message = '���������ǩ�������ݸ�ʽ����';
            break;
        case 33:
            Message = 'ǩ��ֵ��֤ʧ��';
            break;
        case 34:
            Message = '��ȡ֤����������ʧ��';
            break;
        case 35:
            Message = 'ʹ�ò�֧�ֵ�ͼƬ��ʽ';
            break;
        case 36:
            Message = '���ñʼ���Ⱥ���ɫʧ��';
            break;
        case 37:
            Message = '����signDeviceʧ��';
            break;
        case 38:
            Message = 'showdialogʧ��';
            break;
        case 39:
            Message = '��ȡ��дָ����Ϣʧ��';
            break;
        case 40:
            Message = '����adaptor����ʧ��';
            break;
        case 41:
            Message = '����֤������ʧ��';
            break;
        case 42:
            Message = '����֤������ʧ��';
            break;
        case 43:
            Message = '����ǩ��������ʧ��';
            break;
        case 44:
            Message = '����ԭ������ʧ��';
            break;
        case 45:
            Message = '����crypto����ʧ��';
            break;
        case 46:
            Message = '����֤�������ʽjsonʧ��';
            break;
        case 47:
            Message = '��ȡ֤������ʧ��';
            break;
        case 48:
            Message = 'ǩ������EventCertΪ��';
            break;
        case 49:
            Message = 'ǩ������TSValueΪ��';
            break;
        case 50:
            Message = '�����ǩ���㷨������Ч����';
            break;
        case 51:
            Message = '��ȡǩ����������ָ��ͼƬΪ��';
            break;
        case 52:
            Message = '��ȡǩ������д�켣ͼƬΪ��';
            break;
        case 53:
            Message = '����Biofeature��ϣʧ��';
            break;
        case 54:
            Message = 'Biofeatur��ϣֵΪ��';
            break;
        case 55:
            Message = '����bio_hashʧ��';
            break;
        case 56:
            Message = '��ȡ֤����BIO_HASHʧ��';
            break;
        case 57:
            Message = '����֤��BIO_HASH����Ϊ��';
            break;
        case 58:
            Message = '�Ƚ�֤��BIO_HASHʧ��';
            break;
        case 59:
            Message = 'û�м�⵽ǩ���豸';
            break;
        case 60:
            Message = 'ǩ���豸���ǰ�ȫǩ����,��ǰֻ֧�ְ�ȫǩ����';
            break;
        case 61:
            Message = '�û�ȡ��ǩ��';
            break;
        case 62:
            Message = '��ȡ֤��ǩ����ʧ��';
            break;
        case 63:
            Message = '��ȡ֤��ǩ����Ϊ��';
            break;
        case 64:
            Message = '֤�����Ͳ���ȷ';
            break;
        case 65:
            Message = '�������json����json object';
            break;
        case 66:
            Message = 'ǩ��ʱ������Ϊ��';
            break;
        case 67:
            Message = '����ǩ�����ʧ��';
            break;
        case 68:
            Message = '�����ǩ�����Ϊ��';
            break;
        case 69:
            Message = '����sign_begin�ӿ�ʧ��';
            break;
        case 70:
            Message = '������ļ���Ϊ��';
            break;
        case 71:
            Message = 'base64����ʧ��';
            break;
        case 72:
            Message = '������ļ�̫���޷�ǩ��������֤��';
            break;
        case 73:
            Message = 'δ����ǩ��������';
            break;
        case 74:
            Message = 'δ����ǩ����֤����Ϣ';
            break;
        case 75:
            Message = '�����ʱ���ǩ��ֵΪ��';
            break;
        case 76:
            Message = '�����ʱ���ԭ��Ϊ��';
            break;
        case 77:
            Message = '��ʽ��ʱ���ʱ��ʧ��';
            break;
        case 78:
            Message = '��֤ʱ���ǩ��ʧ��';
            break;
        case 79:
            Message = '��ȡ�ļ�����ʧ��';
            break;
        case 80:
            Message = '��֤֤����Ч��ʧ�ܣ����������ò���ȷҲ�ᵼ�´˴���';
            break;
        case 81:
            Message = '��ȡʱ���ԭ��Ϊ��';
            break;
        case 82:
            Message = '��ͼ��������ŷ�������';
            break;
        case 83:
            Message = '��ͼ����и�ʽת����������';
            break;
        case 84:
            Message = 'δ������չ��';
            break;
        case 85:
            Message = '��֧�ֵ���չ���ͺ�';
            break;
        case 86:
            Message = '����֤���еĹ�ϣֵʧ��';
            break;
        case 87:
            Message = '�Ƚ�֤���еĹ�ϣ����д�ʼ���ϣʧ��';
            break;
        case 88:
            Message = '����ǩ���Ի����Ȳ���ȷ';
            break;
        case 89:
            Message = '����UI�������ļ�����';
            break;
        case 90:
            Message = '��ȡ��Ƭʧ��';
            break;
        case 91:
            Message = '��ȡ��Ƶʧ��';
            break;
        case 92:
            Message = '������ͷʧ��';
            break;
        case 93:
            Message = '����ʧ��';
            break;
        case 94:
            Message = '����·��ȷ��ʧ��';
            break;
        case 95:
            Message = '¼��·��ʧ��';
            break;
        case 96:
            Message = '¼��洢·����ȡʧ��';
            break;
        case 97:
            Message = '����˷�ʧ��';
            break;
        case 98:
            Message = 'δ�ҵ�������xvid';
            break;
        case 99:
            Message = 'ǩ����δ��';
            break;
        case 100:
            Message = 'ǩ�����Ѿ���';
            break;
        case 101:
            Message = '����ǩ����ʧ��';
            break;
        case 102:
            Message = 'ǩ����������δ����';
            break;
        case 103:
            Message = 'ǩ�������������';
            break;
        case 104:
            Message = 'ǩ���屻�Ƴ�';
            break;
        case 105:
            Message = 'ȱ��֤����Ϣ';
            break;
        case 106:
            Message = '�ؼ����ھ��Ϊ��';
            break;
        case 107:
            Message = 'δ��⵽����оƬ(ǩ�ְ�560/370  ����ǩ����9011)';
            break;
        case 108:
            Message = '���õ����������Ϊ��';
            break;
        case 109:
            Message = '��֧�ֵ��޸ĵ�������';
            break;
        case 110:
            Message = '����ǩ��֤��hash��Ϣ����ȷ';
            break;
        default:
            Message = 'δ֪����';
            break;
        }
        Message += ',�����룺' + ErrorCode;
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
        return signValue.SigValue.Algorithm;
    },
    getBioFeature: function (signValue) {
        return signValue.SigValue.BioFeature;
    },
    getEventCert: function (signValue) {
        return signValue.SigValue.EventCert;
    },
    getSigValue: function (signValue) {
        return signValue.SigValue.SigValue;
    },
    getTSValue: function (signValue) {
        return signValue.SigValue.TSValue;
    },
    getVersion: function (signValue) {
        return signValue.SigValue.Version;
    },
    getUsrID: function (evidenceData) {
        return this.getSignHash(evidenceData) + (new Date()).getTime();
    }
};

var handSign = {
    sign: function (parEditor) {
        var isSigned = false;
        if (!handSignInterface && !handSignInterface.checkStatus()) {
            alert('��������дǩ���豸');
            return;
        }
        try {
            // ��ȡͼƬ
            var evidenceData = handSignInterface.getEvidenceData();
            if (typeof evidenceData === 'undefined') return;
            //evidenceData = $.parseJSON(evidenceData);
            var signLevel = 'Patient';
            var signUserId = handSignInterface.getUsrID(evidenceData);
            var userName = 'Patient';
            var actionType = 'Append';
            var description = '����';
            var img = handSignInterface.getSignScript(evidenceData);
            var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
            //fingerImage = "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"
            // ��ȡ�༭��hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage);
            
            if (signInfo.result == 'OK') {
                isSigned = true;
                // ǩ��
                var signValue = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo.Digest);
                if ('' == signValue) return;
                signValue = $.parseJSON(signValue);
                // ���̨����
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
                            throw { message : 'SaveSignInfo ʧ�ܣ�' + ret.Err };
                        } else {
                            if ('-1' == ret.Value) {
                                throw { message : 'SaveSignInfo ʧ�ܣ�' };
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
                throw { message : 'ǩ��ʧ��' };
            }
        } catch (err) {
            if (err.message === '�û�ȡ��ǩ��,�����룺61') {
                return;
            }
            else if (isSigned) {
                parEditor.unSignedDocument();
            }
            alert(err.message);
        }
    }
};
