"use strict";
try {
    document.writeln('<OBJECT classid="clsid:18201fef-1ac1-4900-8862-5ec6154bb307" id="UCAPI" style="height:1px;width:1px;display:none"></OBJECT>');
} catch (e) {
    alert(e.message);
}

var objScriptCtrl = null;
var objFPrintCrtl = null;
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
        }, {
            "Content": "",
            "ImageType": "png",
            "Type": "2"
        }
    ],
    "Feature": ""
};
var application = {
    "userName": "",
    "userIdCardNum": "",
    //申请信息
    "dn": "",
    //"dn": "C\u003dCN,ST\u003d湖北,L\u003d武汉,OU\u003d4202@1@4444,CN\u003d湖北CA",
    "applyPlatform": "imedical_EMR",
    //病历内容摘要
   	"applySubject": "",
    "authUserId": "4EC2BDA919224D899C00DDD31F7D9252",
    //项目信息
    "projectId": "87F88E98A089446A9659BDDD9D0CB601"
};
if (!Array.prototype.forEach) {
    Array.prototype.forEach = function forEach(callback, thisArg) {
        var T, k;
        if (this == null) {
            throw new TypeError("this is null or not defined");
        }
        var O = Object(this);
        var len = O.length >>> 0;
        if (typeof callback !== "function") {
            throw new TypeError(callback + " is not a function");
        }
        if (arguments.length > 1) {
            T = thisArg;
        }
        k = 0;
        while (k < len) {
            var kValue;
            if (k in O) {
                kValue = O[k];
                callback.call(T, kValue, k, O);
            }
            k++;
        }
    };
}
var utility = /** @class */ (function () {
    function utility() {
    }
    utility.isNull = function (str) {
        var jRet = false;
        switch (str) {
            case "":
                jRet = true;
                break;
            case null:
                jRet = true;
                break;
            default:
                jRet = false;
        }
        return jRet;
    };
    // 校验只要是数字（包含正负整数，0以及正负浮点数）就返回true
    utility.isNumber = function (val) {
        var regPos = /^\d+(\.\d+)?$/; //非负浮点数
        var regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
        if (regPos.test(val) || regNeg.test(val))
            return true;
        else
            return false;
    };
    //
    utility.htmltplc = function (htmptpl) {
        var htmptplStr = htmptpl.toString();
        return function (scope) {
            return htmptplStr.match(/\/\*\/([\s\S]*?)\/\*\//)[1].replace(/\$\{\w+?\}/g, function (prop) {
                var value = scope;
                prop = prop.replace('${', '').replace('}', '');
                //console.log(prop)
                prop.split('.').forEach(function (section) {
                    value = value[section];
                });
                return value.toString();
            });
        };
    };
    ;
    return utility;
}());
//
var warpAXObject = /** @class */ (function () {
    function warpAXObject() {
        this.fpVendor = 1;
    }
    warpAXObject.refCtrl = function () {
        //var _a;
        //console.log("refCtrl")
        try {
            document.writeln('<object id="pentools" classid="CLSID:085F7C06-59A1-4DDE-9A71-BAEB3616311C" width="1px" height="1px"></object>');
            document.writeln('<object id="aratekcom" classid="CLSID:42EBEC4C-57B2-49FB-A5FC-BB85A9D9E9E8"></object>');
            //$("head").append('<object id="pentools" classid="CLSID:085F7C06-59A1-4DDE-9A71-BAEB3616311C" width="1px" height="1px"></object>');
            //$("head").append('<object id="aratekcom" classid="CLSID:42EBEC4C-57B2-49FB-A5FC-BB85A9D9E9E8"></object>');
            //$("body").append('<object id="pentools" classid="CLSID:085F7C06-59A1-4DDE-9A71-BAEB3616311C"></object>');
            //$("body").append('<object id="aratekcom" classid="CLSID:42EBEC4C-57B2-49FB-A5FC-BB85A9D9E9E8"></object>');
            document.writeln('<script language="javascript" for="pentools" event="PressOK(imgbase64)">warpAXObject.confirmEvent(imgbase64)</script>');
            document.writeln('<script language="javascript" for="pentools" event="PressCancel()">warpAXObject.cancelEvent()</script>');
            document.writeln('<script language="javascript" for="aratekcom" event="OnFingerPrintCaptrueComplete(imgb64,tempb64)">warpAXObject.fpCapComplete(imgb64,tempb64)</script>');
            //FPImageBase64.value = imgb64;
            //FPFeatureBase64.value = tempb64;
            //infoArea.innerHTML="采集指纹完毕！\r\n"+infoArea.innerHTML;
            document.writeln('<script language="javascript" for="aratekcom" event="OnFingerPrintVerifyComplete(sc)"></script>');
            //infoArea.innerHTML="验证指纹完毕，分数为"+sc+"！\r\n"+infoArea.innerHTML;
            objScriptCtrl = document.getElementById('pentools').object //(_a = document.getElementById('pentools')) === null || _a === void 0 ? void 0 : _a.object;
            objScriptCtrl.SetButtonState(1);
            objScriptCtrl.SetClientWidth(400);
            objScriptCtrl.SetClientHeight(250);
            //objScriptCtrl.ShowHideWindow(0);
            objFPrintCrtl = document.getElementById('aratekcom');
        }
        catch (e) {
            //alert(e.message);
        }
    };
    warpAXObject.prototype.initCtrl = function () {
        //console.log("initCtrl");
        //let obj = pentools.object;
        //objScriptCtrl.SetButtonState(1);
        /*try {
            if (objScriptCtrl.attachEvent) {
                objScriptCtrl.attachEvent('ConfirmEvent', this.getSignScript);
                objScriptCtrl.attachEvent('CancelEvent', this.cancelEvent);
            } else {
                objScriptCtrl.addEventListener('ConfirmEvent', this.getSignScript, false);
                objScriptCtrl.addEventListener('CancelEvent', this.cancelEvent, false);
            }
        } catch(e) {
            alert("添加事件失败"+e.message);
        }*/
    };
    warpAXObject.confirmEvent = function (imgB64) {
        //alert(objScriptCtrl.GetImageBase64(200,100));
        //alert("确认");
        if ($("#getHandSign").text() == '采集笔迹') {
            warpAXObject.sCloseDev();
            $("#getHandSign").linkbutton({ text: '重新书写' });
        }
        $("#handscript").attr('src', 'data:image/png;base64,' + imgB64);
        warpAXObject.fOpenDev(0);
        //$("#fingerprint").attr('src', 'data:image/png;base64,'+objScriptCtrl.GetImageBase64(160,200));
    };
    warpAXObject.cancelEvent = function () {
        warpAXObject.sCloseDev();
		warpAXObject.clearSign();
		$('#handSign').dialog('close');
    };
    warpAXObject.fpCapComplete = function (fpimgb64, tempb64) {
        $("#fingerprint").attr('src', 'data:image/png;base64,' + fpimgb64);
        $("#fpFeature").val(tempb64);
        warpAXObject.fCloseDev();
    };
    warpAXObject.prototype.checkStatus = function () {
        return true;
    };
    /*
        public ajaxSubmit(signJson: string): boolean {
            return false;
        }
    */
    warpAXObject.prototype.getEvidenceData = function () {
        //evidence.Evidence[0].Content = $("#handscript")[0].src.split(",")[1];
        evidence.Evidence[0].Content = $("#handscript")[0].href.split(",")[1];
        evidence.Evidence[0].ImageType = "png";
        evidence.Evidence[0].Type = "0";
        //evidence.Evidence[1].Content = $("#fingerprint")[0].src.split(",")[1];
        evidence.Evidence[1].Content = $("#fingerprint")[0].href.split(",")[1];
        evidence.Evidence[1].ImageType = "jpg";
        evidence.Evidence[1].Type = "1";
        evidence.Feature = $("#fpFeature").val();
        return evidence;
    };
    warpAXObject.prototype.getSignScript = function (evidenceData) {
        //return $('#handscript').val();
        return evidence.Evidence[0].Content;
    };
    warpAXObject.prototype.getSignPhoto = function (evidenceData) {
        return '';
    };
    warpAXObject.prototype.getSignFingerprint = function (evidenceData) {
        //return $('#fingerprint').val();
        return evidence.Evidence[1].Content;
    };
    warpAXObject.prototype.getAlgorithm = function () {
        return '';
    };
    warpAXObject.prototype.getVersion = function (signValue) {
        return '';
    };
    warpAXObject.prototype.getBioFeature = function () {
        return evidence.Feature;
    };
    warpAXObject.prototype.getEventCert = function (digest, evidence, episodeID, insID) {
        var certObj = "";
        application.userName = b64_sha1(evidence.Evidence[0].Content);
        application.userIdCardNum = b64_sha1(evidence.Evidence[1].Content);
        application.applySubject = digest;
        application.dn = "C\u003dCN,ST\u003d湖北,L\u003dimedical,OU\u003d"+insID+",CN\u003d"+episodeID,
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.CAHandsign.HBCA.GenEventCert.cls',
            async: false,
            cache: false,
            data: {
                action: 'genCert',
                application: JSON.stringify(application)
            },
            success: function (ret) {
                var genRet = JSON.parse(ret);
                if (genRet.errorMsg == '成功') {
                    certObj = ret;
                }
                else {
                    certObj = "";
                    alert('事件证书签发失败:' + genRet.errorMsg);
                }
            },
            error: function (err) {
                throw { message: '事件证书签发失败:' + err };
            }
        });
        return certObj;
    };
    warpAXObject.prototype.getNotation = function (evidenceData) {
        return "";
    };
    warpAXObject.prototype.getEvidenceId = function (evidenceData) {
        return "";
    };
    warpAXObject.prototype.getSignDataValue = function (pfxBase64, plainData) {
	    var signCert = UCAPI.CreatePfxBase64(pfxBase64,"11111111");
		var signedData = signCert.PKCS7String(plainData,0);
        return signedData;
    };
    warpAXObject.prototype.getSigValue = function (signValue) {
        var sig = "";
        return sig;
    };
    warpAXObject.prototype.getTSValue = function (signValue) {
	    return "";
    };
    warpAXObject.prototype.getUsrID = function (evidenceData) {
        return '' + (new Date()).getTime();
    };
    warpAXObject.prototype.getErrorMessage = function (errCode) {
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
    };
    warpAXObject.sOpenDev = function () {
        objScriptCtrl.SetButtonState(1);
        objScriptCtrl.SetClientWidth(800);
        objScriptCtrl.SetPenWeight(12);
        objScriptCtrl.SetClientHeight(480);
        objScriptCtrl.ShowHideWindow(1);
    };
    warpAXObject.sCloseDev = function () {
        objScriptCtrl.ShowHideWindow(0);
    };
    warpAXObject.clearSign = function () {
        $("#handscript").attr('src', 'data:image/png;base64, ' + initB64_1);
        $("#fingerprint").attr('src', 'data:image/png;base64, ' + initB64_2);
        $("#fpFeature").val('0');
    };
    warpAXObject.prototype.setPenMode = function (penMode) {
    };
    warpAXObject.fOpenDev = function (vendor) {
        var _vendor = vendor || 0;
        var ret = objFPrintCrtl.BeginCaptureAndWaitForInput(_vendor, 0, 1, 0);
        $('#capInfo').text('采集指纹中，请长按指纹仪...');
    };
    warpAXObject.fCloseDev = function () {
        $('#capInfo').text('采集指纹完毕');
    };
    warpAXObject.fClearFPData = function () {
    };
    warpAXObject.fReadFPData = function (imgb64, tempb64) {
        //FPImageBase64.value = imgb64;
        //FPFeatureBase64.value = tempb64;
        $("#fingerprint").attr('src', 'data:image/png;base64,' + imgb64);
        $("#fpFeature").val(tempb64);
    };
    return warpAXObject;
}());
// 编辑器API
var docAPI = /** @class */ (function () {
    function docAPI() {
        this.isSigned = false;
        this.parEditor = null;
    }
    docAPI.prototype.emrEditorIF = function () {
        try {
            var _warpObj = new warpAXObject();
            // 获取图片
            var evidenceData = _warpObj.getEvidenceData();
            if (typeof evidenceData === 'undefined')
                return;
            //evidenceData = $.parseJSON(evidenceData);
            var signLevel_1 = 'Patient';
            var signUserId_1 = this.parEditor.userId || 'Patient'; //handSignIF.getUsrID(evidenceData);
            var userName = 'Patient';
            var actionType_1 = this.parEditor.actionType; //'Append';
            var description = '患者';
            var img = _warpObj.getSignScript(evidenceData);
            var headerImage = _warpObj.getSignPhoto(evidenceData);
            var fingerImage = _warpObj.getSignFingerprint(evidenceData);
            var path = this.parEditor.path || '';
            // 获取编辑器hash
            var signInfo_1 = this.parEditor.signDocument(this.parEditor.instanceId, 'Graph', signLevel_1, signUserId_1, userName, img, actionType_1, description, headerImage, fingerImage, path);
            if (signInfo_1.result == 'OK') {
                this.isSigned = true;
                var eCert = _warpObj.getEventCert(signInfo_1.Digest, evidenceData, this.parEditor.episodeID,this.parEditor.instanceId);
                if (eCert == "") {
                    throw { message: '调用CA接口获取时间证书失败' };
                }
                eCert = JSON.parse(eCert);
                // 签名
                var signValue = _warpObj.getSignDataValue(eCert.pfxB64, signInfo_1.Digest);
                if ('' == signValue)
                    throw { message: '调用CA接口签名失败' };
				var _argEditor = this.parEditor;
				
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: this.parEditor.instanceId,
                    Algorithm: _warpObj.getAlgorithm(),
                    BioFeature: _warpObj.getBioFeature(),
                    EventCert: JSON.stringify(eCert),
                    SigValue: signValue,
                    TSValue: _warpObj.getTSValue(),
                    Version: _warpObj.getVersion(),
                    SignScript: img,
                    HeaderImage: headerImage,
                    Fingerprint: fingerImage,
                    PlainText: signInfo_1.Digest,
                    SignData: JSON.stringify(evidenceData)
                };
                $.ajax({
                    type: 'POST',
                    dataType: 'text',
                    url: '../EMRservice.Ajax.anySign.cls',
                    async: false,
                    cache: false,
                    data: argsData,
                    success: function (ret) {
                        //ret = $.parseJSON(ret);
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
                                _argEditor.saveSignedDocument(_argEditor.instanceId, signUserId_1, signLevel_1, signId, signInfo_1.Digest, 'AnySign', signInfo_1.Path, actionType_1);
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
            else if (this.isSigned) {
                this.parEditor.unSignedDocument();
            }
            alert(err.message);
        }
    };
    return docAPI;
}());
//
var clsHandSign = /** @class */ (function () {
    function clsHandSign() {
    }
    clsHandSign.prototype.showDialog = function (dlgId, onConfirm, onCancel) {
        //console.log("hi");
        var dlg = $("#" + dlgId);
        dlg.show().dialog({
            isTopZindex: true,
            closable: false,
            modal: true,
            /*onClose: function(){
                //移除存在的Dialog
                $("body").remove("#HSign_DLG");
                HSign_DLG.dialog('destroy');
            },*/
            buttons: [{
                    id: 'getHandSign',
                    text: '采集笔迹',
                    handler: function () {
                        if ($("#getHandSign").text() == '重新书写') {
                            warpAXObject.sOpenDev();
                            $("#getHandSign").linkbutton({ text: '采集笔迹' });
                            return;
                        }
                        if ($("#getHandSign").text() == '采集笔迹') {
                            warpAXObject.sCloseDev();
                            $('#capInfo').text('请采集指纹...');
                            $("#getHandSign").linkbutton({ text: '重新书写' });
                            return;
                        }
                    }
                }, {
                    id: 'getFPrnt',
                    text: '指纹采集',
                    handler: function () {
                        //handSignIF.fOpenDevice();
                        warpAXObject.fOpenDev(0);
                    }
                } /*, {
                    id: 'deb',
                    text: 'deb',
                    handler: function () {
                        $("#handscript").attr('src', 'data:image/png;base64,'+objScriptCtrl.GetImageBase64(180,60));
                        $("#fpFeature").val(objScriptCtrl.GetImageBase64(180,60));
                    }
                }*/,
                {
                    id: 'confirmSign',
                    text: '确定',
                    handler: function () {
                        $("#handscript").attr('src', 'data:image/png;base64,' + objScriptCtrl.GetImageBase64(400, 200));
                        //$("#fpFeature").val(objScriptCtrl.GetImageBase64(180,60));
                        if ('function' === typeof onConfirm) {
                            onConfirm();
                        }
                        warpAXObject.sCloseDev();
                        warpAXObject.clearSign();
                        dlg.dialog('close');
                    }
                }, {
                    text: '结束',
                    handler: function () {
                        if ('function' === typeof onCancel) {
                            onCancel();
                        }
                        //alert($("#fpFeature").val());
                        warpAXObject.sCloseDev();
                        warpAXObject.clearSign();
                        dlg.dialog('close');
                    }
                } /*, {
                    text: '关闭',
                    handler: function () {
                        alert($("#fpFeature").val());
                        warpAXObject.sCloseDev();
                        warpAXObject.clearSign();
                        dlg.dialog('close');
                    }
                }*/
            ]
        });
        $('#capInfo').text('患者签名采集中...');
    };
    ;
    clsHandSign.prototype.sign = function (parEditor) {
        var _docAPI = new docAPI();
        _docAPI.parEditor = parEditor;
        this.showDialog(uiStruct.dlgid, function () {
            _docAPI.emrEditorIF();
        }, function () { });
        warpAXObject.sOpenDev();
    };
    return clsHandSign;
}());

warpAXObject.refCtrl();
var handSign = new clsHandSign();
var uiStruct = {
    dlgid: 'handSign',
    title: '患者数字签名',
    width: 450,
    height: 320,
    content: '<span id="hsCntr" style="display:inline-block;width:210px;height:200px;margin-left:20px;">' +
        '<img id="handscript" src="data:image/png;base64, ' + initB64_1 + '"' +
        'style="display:inline-block;width:210px;height:110px;/*background:lightpink;*/border:darkgray;border-style:dashed;margin-bottom:40px;"/>' +
        '<span id="capInfo" style="display:inline-block;height:10px;margin-bottom:10px;">患者签名采集中...</span>' +
        '</span>' +
        '<span id="fpCntr" style="display:inline-block;width:160px;height:200px;margin-top:25px;margin-left:15px;">' +
        //'<img id="fingerprint" src="data:image/png;base64,  ' + initB64_2 + '"'+
        //    'style="display:inline-block;width:160px;height:200px;/*background:yellow;*/border:darkgray;border-style:dashed;margin-top:25px;margin-left:15px;"/>'+
        '<img id="fingerprint" src="data:image/png;base64,  ' + initB64_2 + '"' +
        'style="display:inline-block;width:160px;height:200px;border:darkgray;border-style:dashed;"/>' +
        '<span id="fpFeature" value="0"></span>' +
        '</span>'
};
var dlgtpl = utility.htmltplc(function () {
    { /*/
        <div id="${dlgid}" class="hisui-dialog" title="${title}" style="display:none;overflow: hidden;width:${width}px;height:${height}px;top:50px;">
            <!--div style="display:inline-block;width:640px;padding-right:10px;"></div>
            <div style="display:inline-block;width:300px;"></div-->
            ${content}
        </div>
    /*/
    }
});
//document.body.innerHTML += toHtml1;
$(function () {
    $('body').append(dlgtpl(uiStruct));
    var _warpObj = new warpAXObject();
    _warpObj.initCtrl();
    //console.log($);
});
/*
 * A JavaScript implementation of the Secure Hash Algorithm, SHA-1, as defined
 * in FIPS PUB 180-1
 * Version 2.1-BETA Copyright Paul Johnston 2000 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for details.
 */
/*
 * Configurable variables. You may need to tweak these to be compatible with
 * the server-side, but the defaults work in most cases.
 */
var hexcase = 0; /* hex output format. 0 - lowercase; 1 - uppercase             */
var b64pad = ""; /* base-64 pad character. "=" for strict RFC compliance     */
var chrsz = 8; /* bits per input character. 8 - ASCII; 16 - Unicode         */
/*
 * These are the functions you'll usually want to call
 * They take string arguments and return either hex or base-64 encoded strings
 */
function hex_sha1(s) {
    return binb2hex(core_sha1(str2binb(s), s.length * chrsz));
}
function b64_sha1(s) {
    return binb2b64(core_sha1(str2binb(s), s.length * chrsz));
}
function str_sha1(s) {
    return binb2str(core_sha1(str2binb(s), s.length * chrsz));
}
function hex_hmac_sha1(key, data) {
    return binb2hex(core_hmac_sha1(key, data));
}
function b64_hmac_sha1(key, data) {
    return binb2b64(core_hmac_sha1(key, data));
}
function str_hmac_sha1(key, data) {
    return binb2str(core_hmac_sha1(key, data));
}
/*
 * Perform a simple self-test to see if the VM is working
 */
function sha1_vm_test() {
    return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
}
/*
 * Calculate the SHA-1 of an array of big-endian words, and a bit length
 */
function core_sha1(x, len) {
    /* append padding */
    x[len >> 5] |= 0x80 << (24 - len % 32);
    x[((len + 64 >> 9) << 4) + 15] = len;
    var w = Array(80);
    var a = 1732584193;
    var b = -271733879;
    var c = -1732584194;
    var d = 271733878;
    var e = -1009589776;
    for (var i = 0; i < x.length; i += 16) {
        var olda = a;
        var oldb = b;
        var oldc = c;
        var oldd = d;
        var olde = e;
        for (var j = 0; j < 80; j++) {
            if (j < 16)
                w[j] = x[i + j];
            else
                w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
            var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), safe_add(safe_add(e, w[j]), sha1_kt(j)));
            e = d;
            d = c;
            c = rol(b, 30);
            b = a;
            a = t;
        }
        a = safe_add(a, olda);
        b = safe_add(b, oldb);
        c = safe_add(c, oldc);
        d = safe_add(d, oldd);
        e = safe_add(e, olde);
    }
    return Array(a, b, c, d, e);
}
/*
 * Perform the appropriate triplet combination function for the current
 * iteration
 */
function sha1_ft(t, b, c, d) {
    if (t < 20)
        return (b & c) | ((~b) & d);
    if (t < 40)
        return b ^ c ^ d;
    if (t < 60)
        return (b & c) | (b & d) | (c & d);
    return b ^ c ^ d;
}
/*
 * Determine the appropriate additive constant for the current iteration
 */
function sha1_kt(t) {
    return (t < 20) ? 1518500249 : (t < 40) ? 1859775393 : (t < 60) ? -1894007588 : -899497514;
}
/*
 * Calculate the HMAC-SHA1 of a key and some data
 */
function core_hmac_sha1(key, data) {
    var bkey = str2binb(key);
    if (bkey.length > 16)
        bkey = core_sha1(bkey, key.length * chrsz);
    var ipad = Array(16), opad = Array(16);
    for (var i = 0; i < 16; i++) {
        ipad[i] = bkey[i] ^ 0x36363636;
        opad[i] = bkey[i] ^ 0x5C5C5C5C;
    }
    var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * chrsz);
    return core_sha1(opad.concat(hash), 512 + 160);
}
/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */
function safe_add(x, y) {
    var lsw = (x & 0xFFFF) + (y & 0xFFFF);
    var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
    return (msw << 16) | (lsw & 0xFFFF);
}
/*
 * Bitwise rotate a 32-bit number to the left.
 */
function rol(num, cnt) {
    return (num << cnt) | (num >>> (32 - cnt));
}
/*
 * Convert an 8-bit or 16-bit string to an array of big-endian words
 * In 8-bit function, characters >255 have their hi-byte silently ignored.
 */
function str2binb(str) {
    var bin = Array();
    var mask = (1 << chrsz) - 1;
    for (var i = 0; i < str.length * chrsz; i += chrsz)
        bin[i >> 5] |= (str.charCodeAt(i / chrsz) & mask) << (24 - i % 32);
    return bin;
}
/*
 * Convert an array of big-endian words to a string
 */
function binb2str(bin) {
    var str = "";
    var mask = (1 << chrsz) - 1;
    for (var i = 0; i < bin.length * 32; i += chrsz)
        str += String.fromCharCode((bin[i >> 5] >>> (24 - i % 32)) & mask);
    return str;
}
/*
 * Convert an array of big-endian words to a hex string.
 */
function binb2hex(binarray) {
    var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
    var str = "";
    for (var i = 0; i < binarray.length * 4; i++) {
        str += hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8 + 4)) & 0xF) + hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8)) & 0xF);
    }
    return str;
}
/*
 * Convert an array of big-endian words to a base-64 string
 */
function binb2b64(binarray) {
    var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var str = "";
    for (var i = 0; i < binarray.length * 4; i += 3) {
        var triplet = (((binarray[i >> 2] >> 8 * (3 - i % 4)) & 0xFF) << 16) | (((binarray[i + 1 >> 2] >> 8 * (3 - (i + 1) % 4)) & 0xFF) << 8) | ((binarray[i + 2 >> 2] >> 8 * (3 - (i + 2) % 4)) & 0xFF);
        for (var j = 0; j < 4; j++) {
            if (i * 8 + j * 6 > binarray.length * 32)
                str += b64pad;
            else
                str += tab.charAt((triplet >> 6 * (3 - j)) & 0x3F);
        }
    }
    return str;
}
