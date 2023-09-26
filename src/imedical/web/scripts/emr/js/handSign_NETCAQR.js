/*var IMG_B64_BMP      = 0;
var IMG_B64_JPG      = 1;
var IMG_B64_PNG      = 2;
var IMG_B64_GIF      = 3;
var PEN_MODE_BRUSH   = 0;
var PEN_MODE_PEN     = 1;
var PEN_MODE_MARKPEN = 2;

var SIGN_CTRL = '';
var FPRT_CTRL = '';
var handSign_dlg = '';
var HSign_CLT = '';

var oIMG_B64 = "";
var isSignedm  = false;
var parEditor = null;
var genName = "";*/
var PCYC_PTR = 0;
// ActiveX控件输出区域
try {
    if ((window.ActiveXObject)||("ActiveXObject" in window)) {
        document.writeln("<OBJECT classid=\"CLSID:B26A83D0-A7D3-44c2-8514-041343B32E13\" height=1 id=pdfCreator style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
        document.writeln("</OBJECT>");
    }
} catch (e) { alert("请检查客户端安装是否正确!"); }
// 虚拟打印机{PDF生成}插件对象
var pdfCreatorIF = {
    checkStatus: function() {
        if (!pdfCreator) return false;
        return true;
    },
    genPDF: function(genPara) {
        var pdfName    = genPara["docName"];
        var outPath    = ""; //genPara[];
        var invocation = genPara["prntPDF"];
        var emrEditor  = ""; //genPara[];
        
        var defPrinter = "";
        try {
            pdfCreator.SetPDFName(pdfName);
            if (outPath!="") {
                pdfCreator.SetOutPath(outPath);
            } else {
                pdfCreator.SetOutPath("");
            }
        } catch(e) { alert(e.message); }
        var fName = pdfCreator.GetOutPath() + pdfCreator.GetPDFName() + ".pdf";
        defPrinter = pdfCreator.GetDefaultPrinter();
        //if (!emrEditor) return;
        pdfCreator.SwitchDefaultPrinter("PDFCreator");
        var ret = "";
        pdfCreator.monPDFPrntSt(20000); //启动spool监视
        //PDF打印或生成调用的方法
        if ('function' === typeof invocation) {
            invocation();
        } else {
	        emrEditor.execute(JSON.stringify({"action":"SET_PATIENT_INFO","args":{"EscapePrntLog":"Y"}}));
            emrEditor.execute(JSON.stringify({"action":"PRINT_DOCUMENT","args":{"actionType":"PrintDirectly"}}));
            emrEditor.execute(JSON.stringify({"action":"SET_PATIENT_INFO","args":{"EscapePrntLog":"N"}}));
        }
        ret = pdfCreator.chkPDFPrntEd(20000); //根据spool监视判定打印是否成功
        ret = eval("("+ret+")")
        if(ret.monRet.success==true) {
            pdfCreator.SwitchDefaultPrinter(defPrinter);
            return fName;
        } else {
            alert(ret.monRet.message); 
            return "";
        }
    },
    uploadPDF: function(pdfName, pdfFull) {
        var uRet = pdfCreator.FtpUpload(pdfName, pdfFull, "10.8.150.221", "21", "his", "5", "200", "");
        return uRet;
    }
}
// 数据式手写签名插件对象
var hsPluginIF = {
    initCtrl: function() {
    },
    checkStatus: function () {
        return true;
    },
    getEvidenceData: function (signerInfo, imgType) {
        var evidenceValue = '';
        return JSON.parse(evidenceValue);
        /*
        var patInfo = parEditor.patInfo;
        var pdfName = "4VIEW-" + parEditor.instanceId.replace("||","@") + "-" + genTS();
        var pdfPath = "";
        var viewNme = genPDF(pdfName, pdfPath, parEditor.emrEditor)
        if(viewNme=="") return;
        pdfb64 = pdfCreator.Bin2B64(viewNme);
        var tmpVP = pdfCreator.B642Bin2TMP(pdfb64, pdfName+".pdf");
        var pJson = pdfCreator.ConvertPDF(tmpVP + "\\" + pdfName +".pdf", "Y,1191,1684");
        //var viewRet = pdfCreator.ViewPDF(tmpVP + "\\" + viewNme+".pdf");
        var tmpVG = ""
        try {
            pJson = eval('('+ pJson +')');
            for(i=0; i<pJson.total; i++) {
                //alert(pJson.pages[i].b64);
                if((typeof(pJson.pages[i].scaled)!="undefined")&&(pJson.pages[i].scaled!="")) {
                    pdfCreator.B642Bin(pJson.pages[i].scaled, tmpVP  + "\\img\\" + pdfName + i +".gif");
                    tmpVG += tmpVP  + "\\img\\" + pdfName + i +".gif;";
                } else {
                    pdfCreator.B642Bin(pJson.pages[i].b64, tmpVP + "\\img\\" + pdfName + i +".gif");
                    tmpVG += tmpVP  + "\\img\\" + pdfName + i +".gif;"
                }
            }
        } catch(e) { alert("Convert failed") }
        //debugger;
        pdfCreator.DelPDF(tmpVP + "\\" + pdfName +".pdf");
        */
    },
    getSignScript: function (evidenceData) {
        return '';
    },
    getSignFingerprint: function (evidenceData) {
        return '';
    },
    getSignPhoto: function (evidenceData) {
        return '';
    },
    getSignDataValue: function (evidenceHash, plainData) {
        var sign_value = ''
        return sign_value;
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
    getErrorMessage: function (ErrorCode) {
        var Message = '';
        switch (ErrorCode) {
            case 0:
                Message = '成功';
                break;
            case 1:
                Message = '未知错误';
                break;
            default:
                Message = '未知错误';
                break;
        }
        Message += ',错误码：' + ErrorCode;
        return Message;
    }
}
/* PDF手写签名插件对象
** 分为两种:
**     需干涉过程型
**     非过程侵入型
*/
var hsPDFPlgIF = {
    startCAProcess: function() {
        var patInfo = parEditor.patInfo;
        var pdfName = patInfo.patientID +
            "-" + patInfo.episodeID +
            "-" + parEditor.instanceId.replace("||","@") + "-" + genTS();
        var pdfPath = "";
        genName = genPDF(pdfName, pdfPath, parEditor.emrEditor)
        if(genName=="") return;
        pdfb64 = pdfCreator.Bin2B64(genName);
    },
    signFinCallBack: function(){
    }
}
// 手写签名操作接口对象
var handSignIF = {
    sucRedirect: function(pPdfB64) {
        //startpBar(70);
        //向后台保存
        var argsData = {
            Action: 'SaveSignInfo',
            BioFeature:pPdfB64,
            PlainText: ''
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
                ret = eval("("+ret+")")
                if (ret.Err || false) {
                    throw { message : 'SaveSignInfo 失败！' + ret.Err };
                } else {
                    if ('-1' == ret.Value) {
                        throw { message : 'SaveSignInfo 失败！' };
                    } else {
                        var signId = ret.Value;
                    }
                }
            },
            error: function (err) {
                throw { message : 'SaveSignInfo error:' + err };
            }
        });
        pdfCreator.DelPDF(genName);
        genName = "";
    },
    BakEndSign: function() {
        try {
            // 获取图片
            var signLevel = 'Patient';
            var signUserId = 'Patient'; //handSignIF.getUsrID(evidenceData);
            var userName = 'Patient';
            var actionType = 'Append';
            var description = '患者';
            //debugger;
            var img = pdfCreator.imgShrink(oIMG_B64.signPicture, 80, 60, "GIF", true);
            var headerImage = "";
            var fingerImage = "";
            // 获取编辑器hash
            var signInfo = parEditor.signDocument(parEditor.instanceId, 'Graph', signLevel, signUserId, userName, img, actionType, description, headerImage, fingerImage);
            if (signInfo.result == 'OK') {
                //isSigned = true;
                // 向后台保存
                var argsData = {
                    Action: 'SaveSignInfo',
                    InsID: parEditor.instanceId,
                    Algorithm: "",
                    BioFeature: "",
                    EventCert: "",
                    SigValue: "",
                    TSValue: "",
                    Version: "",
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
                                throw { message : 'SaveSignInfo 失败！' };
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
                parEditor.unSignedDocument();
                throw { message : '签名失败' };
            }
        } catch (err) {
            alert(err.message);
        }
    }
}
// 病历编辑器接口对象
var emrEditorIF = {
    parEditor: null,
    init: function(insEditor) {
        this.parEditor = insEditor;
    },
    checkStatus: function () {
        
    },
    printDocument: function () {
        this.parEditor.cmdSyncExecute({"action":"SET_PATIENT_INFO","args":{"EscapePrntLog":"Y"}});
        this.parEditor.cmdSyncExecute({"action":"PRINT_DOCUMENT", "args":{"actionType":"PrintDirectly"}});
        this.parEditor.cmdSyncExecute({"action":"SET_PATIENT_INFO","args":{"EscapePrntLog":"N"}});
    },
    signDocument: function() {
        
    },
    saveSignedDocument: function() {
        
    },
    unSignedDocument: function() {
        
    },
    genDocumentName: function() {
        var patInfo = this.parEditor.signProps;
        var pdfName = patInfo.patientID +
            "-" + patInfo.episodeID +
            "-" + parEditor.instanceId.replace("||","@") + "-" + utilityIF.genTS();
        //var pdfPath = "";
        return pdfName;
    }
}
// 公用实用函数接口对象
var utilityIF = {
    isNull: function(str) {
        if ("" === str) {
            return true;
        } else if (null === str) {
            return true;
        } else if ("undefined" === typeof str) {
            return true;
        }
        return false;
    },
    isNumber: function(val) {//校验只要是数字（包含正负整数，0以及正负浮点数）就返回true
        var regPos = /^\d+(\.\d+)?$/; //非负浮点数
        var regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
        if (regPos.test(val) || regNeg.test(val)) return true;
        else return false;
    },
    unStdB64: function(imgb64) {
        var eInd = imgb64.indexOf("=");
        if(eInd<0) return imgb64;
        if(eInd < (imgb64.length-1)) return imgb64.substring(0,imgb64.length-2);
        return imgb64.substring(0,imgb64.length-1);
    },
    genTS: function(){
        var dt = new Date();
        var fYear = dt.getFullYear()
        var month = dt.getMonth()+1
        month = "00" + month;
        month = month.substring(month.length-2);
        var dat   = dt.getDate()
        dat = "00" + dat;
        dat = dat.substring(dat.length-2);
        var hours = dt.getHours()
        hours = "00" + hours;
        hours = hours.substring(hours.length-2);
        var min   = dt.getMinutes()
        min = "00" + min;
        min = min.substring(min.length-2);
        var sec   = dt.getSeconds()
        sec = "00" + sec;
        sec = sec.substring(sec.length-2);
        var msec  = dt.getMilliseconds()
        msec = "00" + msec;
        msec = msec.substring(msec.length-3);
        
        return fYear+month+dat+hours+min+sec+msec;
    },
    genUsrID: function (evidenceData) {
        return (new Date()).getTime();
    },
    QRShow: function(qrContent) {
        $('#qrcode').qrcode({
            render:"div",
            size: 400,
            quiet: 0,
            ecLevel:'L',
            text: qrContent,
            background:"#E6E6E6",
            foreground:"#000000",
        });
    },
    protFix: function() {
        var prefix = ""
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: {
                Action: 'protFix',
            },
            success: function (ret) {
                prefix = ret;
            },
            error: function (err) {
                prefix = "";
            }
        });
        return prefix;
    }
}
// 入口-顶层GUI也写在此处
$(function () {
    function HandSign() {
        if ($('#handSign_dlg').length === 0) {
            var dialogHtml = '<div id="handSign_dlg" class="hisui-dialog" title="患者签名" style="display:none;overflow:hidden;width:430px;height:500px">';
            dialogHtml += '<div id="qrcode" style="width:400px;height:400px;margin-left:15px;margin-top:15px">请稍候...</div>';
            dialogHtml += '</div>';
            $('body').append(dialogHtml);
            handSign_dlg = $('#handSign_dlg');
        }
        //
        function showHSDlg(onConfirm, onCancel) {
            handSign_dlg.show().dialog({
                isTopZindex: true,
                closable: false,
                modal: true,
                buttons: [{
                    id: 'confirmSign',
                    text: '确定',
                    handler: function () {
                        if ('function' === typeof onConfirm) {}
                        $('#qrcode').html("请稍候...");
                        handSign_dlg.dialog('close');
                    }
                },{
                    text: '取消',
                    handler: function () {
                        if ('function' === typeof onCancel) {
                            onCancel();
                        }
                        $('#qrcode').html("请稍候...");
                        handSign_dlg.dialog('close');
                    }
                }]
            });
            
            emrEditorIF.init(parEditor);
            var pdfGenPara = {
                docName: emrEditorIF.genDocumentName(),
                prntPDF: emrEditorIF.printDocument
            };
            var pdfNameArr = pdfGenPara.docName.split("-");
            var pdfName = pdfNameArr[0]+"-"+pdfNameArr[1]+"-"+pdfNameArr[2];
            var pdfSrc = pdfCreatorIF.genPDF(pdfGenPara);
            var keyWrd = parEditor.signProps.signKWord;
            debugger;
            if(pdfSrc!="") {
                $('#qrcode').html("");
                var uri = utilityIF.protFix()+pdfCreatorIF.uploadPDF(pdfName, pdfSrc);
                var qrCnnt = {
                    "version": "3.0",
                    "need_push_back": true,
                    "push_back_mode": "webservice",
                    "transit_id": pdfNameArr[0]+"-"+pdfNameArr[1]+"-"+utilityIF.genTS(),
                    "signer_name": pdfNameArr[0],
                    "description": "",
                    "tack_picture": "true",
                    "capture_video": "true",
                    "evid_host": "http://192.168.200.209",
                    "evid_port": 80,
                    "tsp_url": "http://tsa.cnca.net/NETCATimeStampServer/TSAServer.jsp",
                    "docs": [{
                        "title": "",
                        "description": "",
                        "url": uri,
                        "localappid": pdfName,
                        //"sign_key_word": [ "签名日期", "医生签名", "患者签名" ]
                        "sign_key_word": keyWrd
                    }]
                }
                utilityIF.QRShow(JSON.stringify(qrCnnt));
            }
        }
        // 入口
        this.sign = function (ParEditor) {
            parEditor = ParEditor;
            showHSDlg();
        }
    }
    handSign = new HandSign();
});