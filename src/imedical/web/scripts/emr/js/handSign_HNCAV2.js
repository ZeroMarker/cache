try {
    HncaHandWriteCtrl = document.createElement("object");
    HncaHandWriteCtrl.setAttribute("width",1);
    HncaHandWriteCtrl.setAttribute("height",1);
    HncaHandWriteCtrl.setAttribute("id","HncaHandWriteCtrl");
    HncaHandWriteCtrl.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
    HncaHandWriteCtrl.setAttribute("classid","clsid:9FCA06A7-A2EF-4DB4-B756-A3456DACCAA4");
    document.documentElement.appendChild(HncaHandWriteCtrl);
    
	HncaCtrl = document.createElement("object");
    HncaCtrl.setAttribute("width",1);
    HncaCtrl.setAttribute("height",1);
    HncaCtrl.setAttribute("id","HncaCtrl");
    HncaCtrl.setAttribute("style","position:absolute;left:0px;top:-1000px;width:1px;height:1px;");
    HncaCtrl.setAttribute("classid","clsid:990AC2E1-4439-436A-823A-F96855361CB3");
    document.documentElement.appendChild(HncaCtrl);
} catch (e) {
    alert(e.message);
}

var win; 
var HSign_DLG;
var url = "http://130.0.6.12:8080/CTI_HandWriteServer/servlet/CTIHandWriteServlet";
var initB64_1 = 'iVBORw0KGgoAAAANSUhEUgAAANIAAABuCAYAAABSkU1MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAFASURBVHhe7dMhAQAgEAAx+id7iaAPhODkxCJsnT0X+CMSBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIkFAJAiIBAGRICASBESCgEgQEAkCIsG3uQ9K330ha9r2zQAAAABJRU5ErkJggg==';
var initB64_2 = 'iVBORw0KGgoAAAANSUhEUgAAAKAAAADGCAYAAABVYotqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAISSURBVHhe7dIhAcAwEMDAX/0LGxyYn5bUQ8gdiYE8//fugci6hYQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZCUAUkZkJQBSRmQlAFJGZDQzAFdxAT3GhjiSgAAAABJRU5ErkJggg==';
var evidence = {
    "Evidence": [{
            "Content": "",
            "ImageType": "png",
            "Type": "0"
        }, {
            "Content": "",
            "ImageType": "png",
            "Type": "1"
        }
    ],
    "Feature": ""
};

//回调函数，emr.third.hncahandsign.csp回传笔迹图、指纹图使用
function onclick7(imageValue,signBase64,fingerBase64,fingerIdVaule) {
    $("#handscript").attr('src', 'data:image/png;base64, ' + signBase64);
    $("#fingerprint").attr('src', 'data:image/png;base64, ' + fingerBase64);
    $("#fpFeature").val(fingerIdVaule);
    evidence.Evidence[0].Content = signBase64;
    evidence.Evidence[0].ImageType = "png";
    evidence.Evidence[0].Type = "0";
    evidence.Evidence[1].Content = fingerBase64;
    evidence.Evidence[1].ImageType = "jpg";
    evidence.Evidence[1].Type = "1";
    evidence.Feature = fingerIdVaule;
}

var handSignInterface = {
    openWindow : function () {
        // 若副屏打开先关闭再打开
        if(win && win.open && !win.closed){
            win.ReleaseOcx();
            win.close();
        }
        evidence.Evidence[0].Content = "";
	    evidence.Evidence[1].Content = "";
	    evidence.Feature = "";
        win = window.open("emr.third.hncahandsign.csp","sign_",'left='+(screen.width+10)+',top=0, fullscreen=yes, alwaysRaised=yes,depended=yes, toolbar=no,menubar=no, scrollbars=no, resizable=yes, location=no, status=no,z-look=yes');
    },
    closeWindow : function () {
        if(win && win.open && !win.closed){
            win.ReleaseOcx();
            win.close();
        }
    },
    clearSign : function () {
        $("#handscript").attr('src', 'data:image/png;base64, ' + initB64_1);
        $("#fingerprint").attr('src', 'data:image/png;base64, ' + initB64_2);
        $("#fpFeature").val('');
    },
    cancelEvent : function () {
        handSignInterface.closeWindow();
		handSignInterface.clearSign();
		HSign_DLG.dialog('close');
    },
    checkStatus : function () {
        return true;
    },
    getEvidenceData : function () {
        evidence.Evidence[0].Content = $("#handscript")[0].href.split(",")[1];
        evidence.Evidence[0].ImageType = "png";
        evidence.Evidence[0].Type = "0";
        //evidence.Evidence[1].Content = $("#fingerprint")[0].src.split(",")[1];
        evidence.Evidence[1].Content = $("#fingerprint")[0].href.split(",")[1];
        evidence.Evidence[1].ImageType = "jpg";
        evidence.Evidence[1].Type = "1";
        evidence.Feature = $("#fpFeature").val();
        return evidence;
    },
    isGetSignAndFinger : function () {
        if ((evidence.Evidence[0].Content == "")||(evidence.Evidence[1].Content == ""))
        {
            alert("未获取到实际签名笔迹或指纹图。")
            return false;
        }
        return true;
    },
    getSignScript : function () {
        return evidence.Evidence[0].Content;
    },
    getSignPhoto : function () {
        return '';
    },
    getSignFingerprint : function (evidenceData) {
        return evidence.Evidence[1].Content;
    },
    getAlgorithm : function () {
        return '';
    },
    getVersion : function (signValue) {
        return '';
    },
    getBioFeature : function () {
        return evidence.Feature;
    },
    getEvidenceDataEx : function (image,fingerImage,bioFeature) {
        HncaHandWriteCtrl.SetServiceAddr(url);
        // 获取证据数据
        var result = HncaHandWriteCtrl.GetEvidenceDataEx("", image,fingerImage,bioFeature);
        return result;
    },
    getSignDataValue : function (evidenceDataEx, plainData) {
        var textSign  = HncaHandWriteCtrl.GetSignDataValue(evidenceDataEx, plainData);
        var testSignVal = HncaHandWriteCtrl.GetSignValue(textSign);
	    var res = HncaCtrl.SM2VerifyAttachSign(testSignVal)
		if (res == 0){
            return testSignVal;
        } else {
            alert("验证签名结果失败!");
            return "";
        }
    },
    getTSValue : function (signValue) {
	    return "";
    },
    getErrorMessage : function (errCode) {
        var errInfo = "";
        switch (errCode) {
            case 0:
                errInfo = '操作正常';
                break;
            case 1:
                errInfo = '输入json为空';
                break;
            default:
                errInfo = "未知错误" + errCode;
                break;
        }
        return errInfo;
    },
    
};

// 编辑器
var isSigned  = false;
var parEditor = null;
function emrEditorIF() {
    try {
        // 获取图片
        var isGetSignAndFinger = handSignInterface.isGetSignAndFinger();
        if (!isGetSignAndFinger)
            return;

        var signLevel = 'Patient';
        var signUserId = parEditor.userId || 'Patient';
        var userName = 'Patient';
        var actionType = parEditor.actionType || 'Append';
        var description = '患者';
        var img = handSignInterface.getSignScript();
        var headerImage = handSignInterface.getSignPhoto();
        var fingerImage = handSignInterface.getSignFingerprint();
        var bioFeature = handSignInterface.getBioFeature();
        var path = parEditor.path || '';
        // 获取编辑器hash
        var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage, path);
        if (signInfo.result == 'OK') {
            isSigned = true;
            //证书数据
            var SignData = handSignInterface.getEvidenceDataEx(img,fingerImage,bioFeature);
            if (SignData == "") {
                throw { message: '调用CA接口获取证据数据失败' };
            }
            // 签名
            var signValue = handSignInterface.getSignDataValue(SignData, signInfo.Digest);
            if ('' == signValue)
                throw { message: '调用CA接口签名失败' };
            
            // 向后台保存
            var argsData = {
                Action: 'SaveSignInfo',
                InsID: parEditor.instanceId,
                Algorithm: handSignInterface.getAlgorithm(),
                BioFeature: bioFeature,
                EventCert: "",
                SigValue: signValue,
                TSValue: handSignInterface.getTSValue(),
                Version: handSignInterface.getVersion(),
                SignScript: img,
                HeaderImage: headerImage,
                Fingerprint: fingerImage,
                PlainText: signInfo.Digest,
                SignData: SignData
            };
            $.ajax({
                type: 'POST',
                dataType: 'text',
                url: '../EMRservice.Ajax.anySign.cls',
                async: false,
                cache: false,
                data: argsData,
                success: function (ret) {
                    ret = JSON.parse(ret);
                    if (ret.Err || false) {
                        throw { message: 'SaveSignInfo 失败！' + ret.Err };
                    }
                    else {
                        if ('-1' == ret.Value) {
                            throw { message: 'SaveSignInfo 失败！' };
                        }
                        else {
                            var signId = ret.Value;
                            parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
                        }
                    }
                },
                error: function (err) {
                    throw { message: 'SaveSignInfo error:' + err };
                }
            });
        }
        else {
            throw { message: '签名失败' };
        }
    }
    catch (err) {
        if (err.message === '用户取消签名,错误码：61') {
            return;
        }
        else if (isSigned) {
            parEditor.unSignedDocument();
        }
        alert(err.message);
    }
}

// 入口
var handSign = null;
$(function () {
    function HandSign() {
        if ($('#HSign_DLG').length === 0) {
            var dialogHtml = '<div id="HSign_DLG" class="hisui-dialog" title="数字签名" style="display:none;width:480px;height:350px">';
            dialogHtml += '<span id="hsCntr" style="display:inline-block;width:210px;height:200px;margin-left:20px;">';
            dialogHtml += '<img id="handscript" src="data:image/png;base64, ' + initB64_1 + '"';
            dialogHtml += 'style="display:inline-block;width:210px;height:110px;/*background:lightpink;*/border:darkgray;border-style:dashed;margin-bottom:40px;"/>';
            dialogHtml += '<span id="capInfo" style="display:inline-block;height:10px;margin-bottom:10px;">患者签名采集中...</span>';
            dialogHtml += '</span>';
            dialogHtml += '<span id="fpCntr" style="display:inline-block;width:160px;height:200px;margin-top:25px;margin-left:25px;">';
            dialogHtml += '<img id="fingerprint" src="data:image/png;base64,  ' + initB64_2 + '"';
            dialogHtml += 'style="display:inline-block;width:160px;height:200px;border:darkgray;border-style:dashed;"/>';
            dialogHtml += '<span id="fpFeature" value=""></span>';
            dialogHtml += '</span>';
            dialogHtml += '</div>';
            $('body').append(dialogHtml);
            HSign_DLG = $('#HSign_DLG');
            HSign_DLG.show().dialog({
                isTopZindex: true,
                closable: true,
                modal: true
            });
            HSign_DLG.dialog('close');
        }       
        
        function showHSDlg(onConfirm, onCancel) {
            HSign_DLG.show().dialog({
                isTopZindex: true,
                closable: false,
                modal: true,
                buttons: [{
                        id: 'getHandSign',
                        text: '开始签名',
                        handler: function () {
                                handSignInterface.openWindow();
                                $('#capInfo').text('患者签名采集中...');
                                return;
                        }
                    },{
                        id: 'confirmSign',
                        text: '确定',
                        handler: function () {
                            if ('function' === typeof onConfirm) {
                                onConfirm();
                            }
                            handSignInterface.cancelEvent();
                        }
                    }, {
                        text: '结束',
                        handler: function () {
                            if ('function' === typeof onCancel) {
                                onCancel();
                            }
                        }
                    }
                ]
            });
            $('#capInfo').text('点击【开始签名】按钮开始采集患者签名');
        }
        
        
        // 入口
        this.sign = function (ParEditor) {
            parEditor = ParEditor;
            showHSDlg(function() {
                emrEditorIF();
            },function() {
                //handSignInterface.closeWindow();
                handSignInterface.cancelEvent();
            });
        }     
    }
    handSign = new HandSign();
});
