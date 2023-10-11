var PatientPDASignHelper = (function () {
    var global_hs_dlg = "";
    var global_hs_parEditor = "";
    var defaultTip = "请选择签署方式";
    function initHandSignDlg() {
        if ($('#global_hs_dlg').length === 0) {
            var dialogHtml = '<div id="global_hs_dlg" class="hisui-dialog" title="患者签名" style="display:none;overflow:hidden;background-color:#EFF9FF;width:430px;height:500px;">';
            dialogHtml += '<div id="handSign_tip" style="width:400px;height:50px;text-align:center;margin-top:15px;font-size:14px;background-color:#EFF9FF;">请稍候...</div>';
            dialogHtml += '<div id="handSign_choice" style="width:400px;height:50px;text-align:center;margin-left:15px;margin-top:5px"></div>';
            dialogHtml += '<img id="handSign_qr" src="" style="display:inline-block;width:280px;height:280px;border:darkgray;border-style:dashed;margin-left:75px"/>';
            dialogHtml += '</div>';
            $('body').append(dialogHtml);
            global_hs_dlg = $('#global_hs_dlg');
        }
        $('#handSign_tip').html(defaultTip);
        $('#handSign_qr').attr('src', '');
    }

    function showHandSignDlg(onConfirm, onCancel, tip) {

        tip = tip || defaultTip;
        global_hs_dlg.show().dialog({
            isTopZindex: true,
            closable: false,
            modal: true,
            buttons: [{
                id: 'wechatSign',
                text: '微信签署',
                handler: function () {
                    doSignPDF("WeChat");
                }
            }, {
                id: 'padSign',
                text: 'Pad签署',
                handler: function () {
                    doSignPDF("Pad");
                }
            }, {
                id: 'confirmSign',
                text: '确定',
                handler: function () {
                    doRefresh();
                    closeHandSignDlg();
                }
            }]
        });

    }

    function doSignPDF(signType) {

        var parEditor = global_hs_parEditor;

        var tosignKeyWord = parEditor.signKeyWord;
        if (tosignKeyWord == "") {
            showTip("签名关键字不能为空！");
            return;
        }

        var instanceID = parEditor.instanceID;
        var pdfBase64 = createToSignPDFBase64(instanceID);
        if (pdfBase64 == "") {
            showTip("生成待签名PDF失败！");
            return;
        }
        try {
            var reMsg = pushToSignPDF(parEditor.episodeID, parEditor.instanceID, parEditor.userID, pdfBase64, tosignKeyWord, signType);
            if (MsgIsOK(reMsg)) {
                showTip("推送待签名PDF成功...");
                if (signType == "WeChat") {
                    showToSignQR(window.EpisodeID, instanceID);
                    showTip("推送待签名PDF成功，请微信扫码签名");
                } else {
                    showTip("推送待签名PDF成功，请使用Pad签名");
                }
            }
            else {
                showTip("推送待签名PDF失败，原因：" + reMsg.data);
            }
        } catch (e) {
            showTip("推送待签名PDF失败：\r\n" + e.message);
        }
    }

    function pushToSignPDF(episodeID, instanceID, uerid, pdfBase64, tosignKeyWord, signType) {
        
        var reMsg = '';
  
        reMsg = $cm({
            ClassName: "NurMp.CA.DHCNurPatSignRecVerify",
            MethodName: "PushToSignPDF",
            APDFBase64: pdfBase64,
            AKeyWord: tosignKeyWord,
            AInstanceID: instanceID,
            AEpisodeID: episodeID,
            AUserID: uerid,
            ASignType: signType
        }, false, function (rtn) {
            console.log("推送患者签名调用失败!");
        });

        return reMsg;
    }

    function showToSignQR(episodeID, instanceID) {
        var patPushSignID = getPatPushSignID(episodeID,instanceID);
        if (patPushSignID == "") return;

        var qrCode = getQRCode(episodeID, patPushSignID);
        if (qrCode == "") return;

        showQRCode(qrCode);
    }

    function getPatPushSignID(episodeID, instanceID) {

        var patPushSignID = "";

        var reMsg = $cm({
            ClassName: "NurMp.CA.DHCNurPatSignRecVerify",
            MethodName: "GetSignPatPushSignID",
            AEpisodeID: episodeID,
            AInstanceDataID:instanceID
        }, false, function (rtn) {
            console.log("获取患者推送签名记录ID调用失败!");
        });

        if (MsgIsOK(reMsg)) {
            patPushSignID = reMsg.data;
        }
        else {
            $.messager.alert(" ", $g("获取患者推送签名记录ID调用失败!\n错误原因：") + reMsg.msg, "error");
        }

        return patPushSignID;
    }

    function getQRCode(userID, patPushSignID) {

        var qrCode = "";
        
        var reMsg = $cm({
            ClassName: "NurMp.CA.DHCNurPatSignRecVerify",
            MethodName: "GetPatPushSignQRCode",
            UserId: userID,
            PatPushSignID:patPushSignID
        }, false, function (rtn) {
            console.log("获取患者签署二维码调用失败!");
        });

        if (MsgIsOK(reMsg)) {
            qrCode = reMsg.data;
        }
        else {
            $.messager.alert(" ", $g("获取患者签署二维码调用失败!\n错误原因：") + reMsg.msg, "error");
        }

        return qrCode;
    }

    function showQRCode(qrCode) {
        var qrcodeimg = document.getElementById("handSign_qr");
        var imgdata = "data:image/jpeg;base64," + qrCode;
        qrcodeimg.src = imgdata;
    }

    /// 患者端CA签名: 患者重签
    function invalidPatSignedPDF() {
        var InstanceId = GetCurNurMPDataID();
        $.messager.confirm("提示", $g("确定患者重签吗？"), function (r) {
            if (r) {
                var reMsg = $cm({
                    ClassName: "NurMp.CA.DHCNurPatSignRecVerify",
                    MethodName: "CancelPushSign",
                    AInstanceDataID: InstanceId,
                    ACancelReason: ""
                }, false, function (rtn) {
                    console.log("取消待签名PDF文档调用失败!");
                });

                if (MsgIsOK(reMsg)) {
                    $.messager.alert("提示", $g("作废成功！\n请再次发起签名操作") + reMsg.msg, "success", function () {
                        doRefresh();
                    });
                }
                else {
                    $.messager.alert(" ", $g("取消待签名PDF文档调用失败!\n错误原因：") + reMsg.msg, "error");
                    return;
                }
            }
        });
    }

    /// 生成待签名PDF
    function createToSignPDFBase64(insId) {
        if ((typeof (ca_pdfcreator) == 'undefined') || (ca_pdfcreator == '')) {
            alert("虚拟打印机对象ca_pdfcreator不存在！");
            return "";
        }
        return ca_pdfcreator.genPDFBase64("", "", function () {
            PrintALLPDF();
        });
    }

    //用打印插件生成图片
    function PrintALLPDF() {
        var hisURI = window.WebIp;
        var isShowPreView = "0"; //1，弹出预览，0，不弹出预览
        var PrintALLCallBackFun = function (ret) { }
        var printTemplateEmrCode = tkMakeServerCall("NurMp.Print.Comm", "GetPrnCode", window.TemplateGUID);
        if (printTemplateEmrCode == "") {
            $.messager.alert($g("提示"), $g("未关联打印模板"), "info");
            return;
        }
        try {
            var sessionJson = GetLogAuxiliaryInfo();
            PrintProvider.PrintALL(hisURI, printTemplateEmrCode, window.EpisodeID, global_hs_parEditor.instanceID, window.CADisplayPic, PrintALLCallBackFun, "", "1", sessionJson, isShowPreView);

        } catch (ex) {
            $.messager.alert($g("提示"), $g("打印插件PrintALL无法使用") + ex.Description, "info");
        }
    }

    function getPatSignStatus(episodeID, instanceID) {
        var status = "";

        var reMsg = $cm({
            ClassName: "NurMp.CA.DHCNurPatSignRecVerify",
            MethodName: "GetSignStatus",
            EpisodeID: episodeID,
            InstanceID:instanceID
        }, false, function (rtn) {
            console.log("获取患者签名状态调用失败!");
        });

        if (MsgIsOK(reMsg)) {
            status = reMsg.data;
        }
        else {
            $.messager.alert(" ", $g("获取患者签名状态调用失败!\n错误原因：") + reMsg.msg, "error");
        }
        return status;
    }

    function getPatSignPDFBase64(episodeID, instanceID) {
        var base64 = "";

        base64 = $m({
            ClassName: "NurMp.CA.DHCNurPatSignRecVerify",
            MethodName: "GetSignBase64Web",
            EpisodeID: episodeID,
            InstanceID: instanceID
        }, false, function (rtn) {
            console.log("获取患者签名PDFBase64调用失败!");
        });

        return base64;
    }


    function closeHandSignDlg() {
        $('#global_hs_dlg').dialog('close');
        $('#global_hs_dlg').remove();
        global_hs_dlg = "";
    }

    function showTip(tip) {
	    $.messager.popover({msg: $g(tip),type:'alert'});
	    //$.messager.alert("提示", $g(tip), "info");
        //$('#handSign_tip').html(tip);
    }

    function doHandSign(Args) {
        
        if (!Args.instanceID) {
            $.messager.alert("提示", $g("请先保存后再进行患者签名!"), "info");
            return;
        }

        global_hs_parEditor = Args;

        if (Args.signLogonType == "PDFPad"){
            doSignPDF("Pad");
            doRefresh();
        }
        else{
            initHandSignDlg();

            var status = getPatSignStatus(Args.episodeID, Args.instanceID);
            if (status == "TOSIGN") {
                $.messager.alert(" ", $g("已推送患者待签文档, 请完成患者签署, 或点击[患者重签]后, 再次发起签名操作!") + reMsg.msg, "info");
                return;
            }
            else if (status == "FINISH") {
                $.messager.alert(" ", $g("该文档已签名,请刷新，或者点击[患者重签]后,再次发起签名操作!") + reMsg.msg, "info");
                return;
            }

            showHandSignDlg("", "", "请选择签署方式...");
        }       
    }

    function browseSignPDF() {
        var InstanceId = GetCurNurMPDataID();
        if (IsIE()) {
            var signedPDFId = getPatPushSignID(window.EpisodeID, InstanceId);
            var url = window.WebIp + "/csp/nur.signpdf.viewer.csp?&yourBusinessID=" + signedPDFId;
            url = GetMWToken(url);
            var pdfFrame = "<iframe id='pdfFrame' style='width:100%;height:100%;' frameborder='0' marginheight='0' marginwidth='0' src=" + url + "></iframe>";
            $("body").append(pdfFrame);
            PdfFrame_SelfAdaption(); //自适应宽高
        }
        else {
            var base64 = getPatSignPDFBase64(window.EpisodeID, InstanceId);
            if (base64 === "" || base64 === undefined || base64 === "undefined" || base64 === null || base64 === "null")
            {
                $.messager.alert("提示", $g("患者签名PDFBase64为空!"), "error");
                return;
            }
            window._PatSignPDFBase64 = "data:application/pdf;base64," + base64;
            var url = window.WebIp + "/scripts_lib/pdfjs-2.0.943/web/viewer.html";
            var pdfFrame = "<iframe id='pdfFrame' style='width:100%;height:100%;' frameborder='0' marginheight='0' marginwidth='0' src=" + url + "></iframe>";
            $("body").append(pdfFrame);
            PdfFrame_SelfAdaption(); //自适应宽高
        }
        
    }

    //患者签PDF预览界面扩展
    function PdfFrame_SelfAdaption() {
        var iframe = GetCurrentPageFrameContainer();
        if (!iframe)
            return false;

        var usedWidth = $("#patSignBtns").width();
        var usedHeight = $("#patSignBtns").height();
        usedHeight = $("#patSignBtns").outerHeight(true);
        var scrollBarWidth = getScrollBarWidth();

        var frameHeight = $(window.parent.document).find(iframe).height();
        var frameWidth = $(window.parent.document).find(iframe).width();
        var scrollBarWidth = getScrollBarWidth();

        if (frameWidth) {
            var adaptionWidth = frameWidth - scrollBarWidth;
            $("#pdfFrame").width(adaptionWidth);
        }

        if (frameHeight) {
            var adaptionHeight = frameHeight - usedHeight - scrollBarWidth;
            $("#pdfFrame").height(adaptionHeight-6);
        }
    }

    function addOptButton(type) {
        var patOptButtonDiv = "<div id='patSignBtns' style='padding: 5px 5px 5px 5px;'><div>";
        if ($("#patSignBtns").length == 0) {
            $("body").prepend(patOptButtonDiv);
        }
        if (type == "Cancel") {
            $("#patSignBtns").append("<a href='#' id='invalidPatSignPDF'class='hisui-linkbutton hover-dark' style='margin-left:10px'>" + "患者重签" + "</a>");
            $('#invalidPatSignPDF').linkbutton({ stopAllEventOnDisabled: true });
            $('#invalidPatSignPDF').on('click', invalidPatSignedPDF);
        }
            
        if (type == "QRCode") {
            $("#patSignBtns").append("<a href='#' id='patPushSignQR'class='hisui-linkbutton hover-dark' style='margin-left:10px'>" + "患签二维码" + "</a>");
            $('#patPushSignQR').linkbutton({ stopAllEventOnDisabled: true });
            $('#patPushSignQR').on('click', showPatPushSignQR);
        }
            
        if (type == "UpdateResult") {
            $("#patSignBtns").append("<a href='#' id='patPushSignResult' class='hisui-linkbutton hover-dark' style='margin-left:10px'>" + "同步患签结果" + "</a>");
            $('#patPushSignResult').linkbutton({ stopAllEventOnDisabled: true });
            $('#patPushSignResult').on('click', fetchPatPushSignResult);
        }
    }

    function fetchPatPushSignResult() {
        doRefresh();
        $.messager.popover({ msg: "刷新成功！", type: 'info' });
    }

    function showPatPushSignQR() {
        var InstanceId = GetCurNurMPDataID();
        $("<div id='reSetTableTitleDialog' class='hisui-dialog' style='background-color:#EFF9FF;'></div>").dialog({
            title: '患签二维码',
            modal: true,
            width: 430,
            height: 390,
            content: "<div style='margin-top:10px;text-align:center;'><img id='handSign_qr' src='' style='display:inline-block;width:280px;height:280px;border:darkgray;border-style:dashed;'/></div>",
            buttons: [{
                text: '确定',
                handler: function () {
                    $('#reSetTableTitleDialog').dialog('destroy');
                }
            }, {
                text: '取消',
                handler: function () {
                    $('#reSetTableTitleDialog').dialog('destroy');
                }
            }],
            onClose: function () {
                $(this).dialog('destroy');
            },
            onOpen: function () {
                showToSignQR(window.EpisodeID, InstanceId);
            }
        });
    }

    function doRefresh() {
        var InstanceId = GetCurNurMPDataID();            
        var _hideSave = function () {
            var butSave = $("a[buttonType='savebutton']");
            if (butSave.length > 0) {
                butSave.hide();
            }
        }
        if (!!InstanceId) {
            $('#patSignBtns').remove(); //先移除添加的按钮
            var status = getPatSignStatus(window.EpisodeID, InstanceId);
            if (status == "FINISH") {
                $("body > div").hide();
                addOptButton("Cancel");
                browseSignPDF()
            }
            else if (status == "TOSIGN") {
                if (window.CAPatientPDFShowLogonType.indexOf("PDFWeChat") != -1)
                    addOptButton("QRCode");
                addOptButton("UpdateResult");
                addOptButton("Cancel");
                _hideSave();
            }
            else {
                $("#pdfFrame").empty();
                $("body > div").show();
            }
        }
    }

    return {
        sign: function (Args) {
            doHandSign(Args);
        },
        refresh: function () {
            doRefresh();
        }
    }
})();