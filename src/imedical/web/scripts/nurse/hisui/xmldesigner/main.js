var invoiceData, mycontext, xmlEditInited = !1,
    XmlViewContentModifyFlag = !1,
    isOpenXmlFlag = !1,
    basesrc = location.href.split("/web/")[0] + "/web/",
    defaultImgPath = "scripts/xmldesigner/img/defaultimg.jpg",
    mycanvas = document.getElementById("lineLayout");
mycanvas.getContext && (mycontext = mycanvas.getContext("2d"));
var _attrCellTpl =
    '<tr id="tr-${id}" class="trCtrlAttr"><td class ="tdCtrlAttrLeft">${desc}</td><td class ="tdCtrlAttrRight"><input id="t-${id}" type="text" class ="numberStyle" maxlength="3"/></td></tr>',
    dragParams = {
        target: null,
        mouseDownFlag: !1,
        top: 0,
        left: 0,
        currentX: 0,
        currentY: 0
    },
    selectCompSet = [];
dragParams.left = $("#dbLayout").css("left"), dragParams.top = $("#dbLayout").css("top");
var getCss = function (e, t) {
    return e.currentStyle ? e.currentStyle[t] : document.defaultView.getComputedStyle(e, !1)[t]
};
function subFloat(e, t) {
    var a = Math.pow(10, t);
    return Math.round(e * a) / a
}
function pxToPt(e) {
    return subFloat(parseFloat(e, 10) / 3.78, 2)
}
function ptToPx(e) {
    return subFloat(3.78 * parseFloat(e, 10), 0)
}
function windowToCanvas(e, t) {
    var a = mycanvas.getBoundingClientRect();
    return {
        x: Math.round(e - a.left),
        y: Math.round(t - a.top)
    }
}
var resizeLayout = function (e, t) {
        $("#dbLayout").css("height", t).css("width", e);
        $("#dbLayout").attr("height", t).attr("width", e)
        //$("#lineLayout").css("width", e).css("height", t);
        $("#lineLayout").attr("width", e).attr("height", t);
        xmldesigner.line.method.draw()
    },
    xmlChangeCallback = function () {
        xmlTextAreaKeyDown()
    },
    xmlEditInitCallback = function () {
        xmlEditInited = !0
    },
    showXmlView = function () {
        $("#lo").layout("collapse", "west"), $("#lo").layout("collapse", "east");
        var e = getCurrXml();
        if (0 == $("#frame_xmlTextArea").length) {
            var t = $("#centerdesignebar").parent().parent().layout("panel", "center").panel("options");
            $("#xmlTextArea").css("width", t.width - 22).css("height", t.height - 13).show(), editAreaLoader.init({
                id: "xmlTextArea",
                start_highlight: !0,
                allow_resize: "both",
                allow_toggle: !1,
                word_wrap: !0,
                language: "zh",
                toolbar: "go_to_line",
                syntax: "xml",
                change_callback: "xmlChangeCallback",
                EA_init_callback: "xmlEditInitCallback"
            })
        } else $("#frame_xmlTextArea").show();
        editAreaLoader.setValue("xmlTextArea", e), $("#dbLayout").hide()
    },
    showDesView = function () {
        $("#frame_xmlTextArea").hide(), $("#dbLayout").show(), $("#lo").layout("expand", "east"), $("#lo").layout(
            "expand", "west");
        var e = editAreaLoader.getValue("xmlTextArea");
        drawByXml(e)
    },
    xmlTextAreaKeyDown = function () {
        //$("#SaveMenu").hasClass("imggray") && enableMenuItem("SaveMenu", "save")
        $("#SaveMenu").hasClass('l-btn-disabled') && enableMenuItem("SaveMenu", "save")
    },
    drawLayout = function () { //1mm=3.78px
        var e = invoiceData.height,
            t = invoiceData.width;
        "Z" == invoiceData.LandscapeOrientation && (e = 20), resizeLayout(ptToPx(t), ptToPx(e))
    },
    recordBoxLeftAndTop = function (e) {
        "auto" != getCss(e, "left") && (dragParams.left = getCss(e, "left")), "auto" != getCss(e, "top") && (dragParams
            .top = getCss(e, "top"))
    },
    setDragParams = function (e) {
        dragParams.mouseDownFlag = !0, dragParams.target = e.target, dragParams.currentX = e.clientX, dragParams.currentY =
            e.clientY, recordBoxLeftAndTop(dragParams.target)
    },
    disableMenuItem = function (e, t) {
        /*$("#" + e).addClass("imggray"), $("#" + e).removeClass("pic").removeClass("pic_" + t).addClass("graypic").addClass(
            "gray_" + t)*/
        $("#" + e).linkbutton('disable');
    },
    enableMenuItem = function (e, t) {
        /*$("#" + e).removeClass("imggray"), $("#" + e).removeClass("graypic").removeClass("gray_" + t).addClass("pic_" +
            t).addClass("pic")*/
        $("#" + e).linkbutton('enable');
    },
    setCtrlAttr = function (e) {
        var t = $("#t-type").val(),
            a = $("#t-ind").val();
        enableMenuItem("SaveMenu", "save"), "layout" == t && ("t-LandscapeOrientation" != (("undefined" == typeof e.target) ? e.attr("id") : e.target.id) || validPrtPaperSet(), 
        "t-PrtDevice" == (("undefined" == typeof e.target) ? e.attr("id") : e.target.id) && validPrtPaperSet(), invoiceData.LandscapeOrientation = $("#t-LandscapeOrientation").combobox("getValue"),
        invoiceData.height = $("#t-height").val(),
        invoiceData.width = $("#t-width").val(), invoiceData.PrtDevice =$("#t-PrtDevice").val(),
        invoiceData.PaperHeight = $("#t-PaperHeight").val(), invoiceData.PaperWidth =$("#t-PaperWidth").val(),
        invoiceData.HorizontalAmount = $("#t-HorizontalAmount").numberbox("getValue"), invoiceData.VerticalAmount =$("#t-VerticalAmount").numberbox("getValue"),
        invoiceData.PrintPreview =$("#t-PrintPreview").switchbox("getValue")?"Y":"N",
        invoiceData.XMLPrintMode=$("#t-XMLPrintMode").combobox("getValue"),
        invoiceData.ForbidRepeatPrint =$("#t-ForbidRepeatPrint").switchbox("getValue")?"Y":"N",
        invoiceData.PrintPresetQuantity =$("#t-PrintPresetQuantity").switchbox("getValue")?"Y":"N",
        invoiceData.PrtPage = $("#t-PrtPage").val(), drawLayout()), "undefined" != typeof xmldesigner[t] &&
        xmldesigner[t].method && xmldesigner[t].method.drawByAttrTable && xmldesigner[t].method.drawByAttrTable(a)
    },
    resetAttrTable = function (e) {
        var t = e.attr("data-ind"),
            a = e.attr("data-type");
        if (-1 < t) {
            if ("lineLayout" == e.attr("id"))
                for (var r in invoiceData) {
	                if (- 1 < r.indexOf("-")) {
		                $("#tr" + r).show();
		                if (r=="ForbidRepeatPrint"){
				            var rows = $("#tabPrtSheet").datagrid("getSelections");
							var SPSXMLDataType=rows[0].SPSXMLDataType;
							if (SPSXMLDataType != "Pat") {
								$("#tr-" + r).hide();
							}
				        }
				        if (r=="PrintPresetQuantity"){
				            var rows = $("#tabPrtSheet").datagrid("getSelections");
							var SPSXMLDataType=rows[0].SPSXMLDataType;
							if (SPSXMLDataType == "Pat") {
								$("#tr-" + r).hide();
							}
				        }
		                if ((r =="HorizontalAmount")||(r =="VerticalAmount")){
				            $("#t" + r).numberbox("setValue",invoiceData[r]);
				        }else if(r =="LandscapeOrientation"){
					        $("#t" + r).combobox("setValue",invoiceData[r]);
					    }else if(r =="PrintPreview"){
					        $("#t" + r).switchbox("setValue",invoiceData[r]=="Y"?true:false);
					    }else if(r =="XMLPrintMode"){
					        $("#t" + r).combobox("setValue",invoiceData[r]);
					    }else if(r =="ForbidRepeatPrint"){
					        $("#t" + r).switchbox("setValue",invoiceData[r]=="Y"?true:false);
					    }else if(r =="PrintPresetQuantity"){
					        $("#t" + r).switchbox("setValue",invoiceData[r]=="Y"?true:false);
					    }else{
					        $("#t" + r).val(invoiceData[r]);
					    }
		            }else{
			            $("#tr-" + r).show();
			            if (r=="ForbidRepeatPrint"){
				            var rows = $("#tabPrtSheet").datagrid("getSelections");
							var SPSXMLDataType=rows[0].SPSXMLDataType;
							if (SPSXMLDataType != "Pat") {
								$("#tr-" + r).hide();
							}
				        }
				        if (r=="PrintPresetQuantity"){
				            var rows = $("#tabPrtSheet").datagrid("getSelections");
							var SPSXMLDataType=rows[0].SPSXMLDataType;
							if (SPSXMLDataType == "Pat") {
								$("#tr-" + r).hide();
							}
				        }
			            if ((r =="HorizontalAmount")||(r =="VerticalAmount")||(r =="PaperHeight")||(r =="PaperWidth")){
				            $("#t-" + r).numberbox("setValue",invoiceData[r]);
				        }else if(r =="LandscapeOrientation"){
					        $("#t-" + r).combobox("setValue",invoiceData[r]);
					    }else if(r =="PrintPreview"){
					        $("#t-" + r).switchbox("setValue",invoiceData[r]=="Y"?true:false);
					    }else if(r =="XMLPrintMode"){
					        $("#t-" + r).combobox("setValue",invoiceData[r]);
					    }else if(r =="ForbidRepeatPrint"){
					        $("#t-" + r).switchbox("setValue",invoiceData[r]=="Y"?true:false);
					    }else if(r =="PrintPresetQuantity"){
					        $("#t-" + r).switchbox("setValue",invoiceData[r]=="Y"?true:false);
					    }else{
					        $("#t-" + r).val(invoiceData[r]);
					    }
			        }
	                /*- 1 < r.indexOf("-") ? ($("#tr" + r).show(), $("#t" + r).val(invoiceData[r])) :
                    ($("#tr-" + r).show(),$("#t-" + r).val(invoiceData[r]));*/
                    $("#tr-ind").hide();
               }
            "layout" == a && validPrtPaperSet(), "undefined" != typeof xmldesigner[a] && xmldesigner[a].method.showAttrsByInd &&
                xmldesigner[a].method.showAttrsByInd(t), xmldesigner.line.method.draw()
        }
    },
    selectItem = function (e, t) {
        if ($("#t-height").attr("disabled", !1), $("#t-width").attr("disabled", !1), $("#t-PrtPage").attr("disabled", !
                1), $("#tr-height .tdCtrlAttrLeft a").text("高度"), $(".trCtrlAttr").hide(), e) 
        {
            if (enableMenuItem("DelMenu", "del"), e = $(e), t.ctrlKey) {
                var a = selectCompSet.indexOf(e); - 1 < a ? (e.removeClass("x-selected"), selectCompSet.splice(a, 1)) :
                    (e.addClass("x-selected"), selectCompSet.push(e))
            } else {
	            clearSelectItem(), e.addClass("x-selected"), selectCompSet.push(e);
	        }
            resetAttrTable(e)
        } else {
	        clearSelectItem(), disableMenuItem("DelMenu", "del"), validPrtPaperSet();
	    }
    },
    clearSelectItem = function () {
        for (var e = !1, t = selectCompSet.length - 1; - 1 < t; t--) $(selectCompSet[t]).removeClass("x-selected"),
            "line" == $(selectCompSet[t]).attr("data-type") && (e = !0), selectCompSet.pop();
        e && xmldesigner.line.method.draw()
    },
    drawByXml = function (e) {
        invoiceData = {}, 
        disableMenuItem("SaveMenu", "save"), 
        xmldesigner.label.method.init(), 
        xmldesigner.line.method.init(),
        xmldesigner.list.method.init(), 
        xmldesigner.listItem.method.init(), 
        xmldesigner.qrcode.method.init(),
        xmldesigner.barcode.method.init(), 
        xmldesigner.img.method.init(), 
        dragParams = {
                target: null,
                mouseDownFlag: !1,
                top: 0,
                left: 0,
                currentX: 0,
                currentY: 0
        },
        selectItem(""),
        selectCompSet = [],
        $("#lineLayout").siblings().remove(), 
        xmlEditInited && editAreaLoader.setValue("xmlTextArea", e);
        var t = e;
        if ("" != t) {
            var a = new XML.ObjTree,
                r = $.trim(t),
                i = a.parseXML(r);
            if (i.html) $.messager.alert("提示","XML格式错误!");
            else {
                (invoiceData = i.appsetting.invoice)["-LandscapeOrientation"] = invoiceData["-LandscapeOrientation"] ||
                    "", invoiceData.LandscapeOrientation = invoiceData["-LandscapeOrientation"] || "", invoiceData.ind =
                    0, invoiceData.type = "layout", invoiceData.height = invoiceData["-height"] || "", invoiceData.width =
                    invoiceData["-width"] || "",invoiceData.PrtDevice = invoiceData["-PrtDevice"] || "", 
                    invoiceData.HorizontalAmount = invoiceData["-HorizontalAmount"] || "",invoiceData.VerticalAmount = invoiceData["-VerticalAmount"] || "",                    
                    invoiceData.PaperHeight = invoiceData["-PaperHeight"] || "",invoiceData.PaperWidth = invoiceData["-PaperWidth"] || "",
                    invoiceData.PrintPreview = invoiceData["-PrintPreview"] || "N",
                    invoiceData.XMLPrintMode = invoiceData["-XMLPrintMode"] || "0",
                    invoiceData.ForbidRepeatPrint = invoiceData["-ForbidRepeatPrint"] || "N",
                    invoiceData.PrintPresetQuantity = invoiceData["-PrintPresetQuantity"] || "N",
                    invoiceData.PrtPage = invoiceData["-PrtPage"] || "",
                    drawLayout();
                var n = "";
                if ("object" == typeof i.appsetting.invoice.TxtData && (handlerRePrtHeadFlag2Sub(invoiceData, "TxtData",
                        "txtdatapara"), "object" == typeof (n = i.appsetting.invoice.TxtData.txtdatapara))) {
                    $.isArray(n) || (n = [n]);
                    for (var l = 0; l < n.length; l++) "undefined" != typeof n[l]["-isqrcode"] && "true" == n[l][
                        "-isqrcode"] ? (xmldesigner.qrcode.data.push(n[l]), xmldesigner.qrcode.method.drawByInd(
                        xmldesigner.qrcode.data.length - 1)) : "undefined" != typeof n[l]["-barcodetype"] ? (
                        xmldesigner.barcode.data.push(n[l]), xmldesigner.barcode.method.drawByInd(xmldesigner.barcode
                            .data.length - 1)) : (xmldesigner.label.data.push(n[l]), xmldesigner.label.method.drawByInd(
                        xmldesigner.label.data.length - 1));
                    delete i.appsetting.invoice.TxtData.txtdatapara
                }
                if ("object" == typeof i.appsetting.invoice.PLData && (handlerRePrtHeadFlag2Sub(invoiceData, "PLData",
                        "PLine"), "object" == typeof (n = i.appsetting.invoice.PLData.PLine))) {
                    $.isArray(n) || (n = [n]);
                    for (l = 0; l < n.length; l++) {
                        var o = xmldesigner.line.method.item2Json(n, l);
                        xmldesigner.line.data.push(o)
                    }
                    xmldesigner.line.method.draw(), delete i.appsetting.invoice.PLData.PLine
                }
                if ("object" == typeof i.appsetting.invoice.ListData) {
                    n = i.appsetting.invoice.ListData;
                    o = xmldesigner.list.method.item2Json(n, 0);
                    if (xmldesigner.list.data.push(o), xmldesigner.list.method.drawByInd(xmldesigner.list.data.length -
                            1), "object" == typeof (n = i.appsetting.invoice.ListData.Listdatapara)) {
                        $.isArray(n) || (n = [n]);
                        for (l = 0; l < n.length; l++) xmldesigner.listItem.data.push(n[l]), xmldesigner.listItem.method
                            .drawByInd(l), 0 == l && (xmldesigner.list.data[xmldesigner.list.data.length - 1].y = n[l].y,
                                xmldesigner.list.method.drawByInd(xmldesigner.list.data.length - 1));
                        delete i.appsetting.invoice.ListData.Listdatapara
                    }
                }
                if ("object" == typeof i.appsetting.invoice.PICData && (handlerRePrtHeadFlag2Sub(invoiceData, "PICData",
                        "PICdatapara"), n = i.appsetting.invoice.PICData.PICdatapara)) {
                    $.isArray(n) || (n = [n]);
                    for (l = 0; l < n.length; l++) {
                        o = xmldesigner.img.method.item2Json(n, l);
                        xmldesigner.img.data.push(o), xmldesigner.img.method.drawByInd(l)
                    }
                    delete i.appsetting.invoice.PICData.PICdatapara
                }
            }
            return !0
        }
    };
function handlerRePrtHeadFlag2Sub(t, a, e) {
    if ($.isArray(t[a])) {
        t.All = {}, t.All["-RePrtHeadFlag"] = t[a][0]["-RePrtHeadFlag"] || "N", t.All[e] = [];
        for (var r = 0; r < t[a].length; r++) {
            var i = t[a][r][e];
            "object" == typeof i && ($.isArray(i) ? i.forEach(function (e) {
                e["-RePrtHeadFlag"] = t[a][r]["-RePrtHeadFlag"] || "N"
            }) : (i["-RePrtHeadFlag"] = t[a][r]["-RePrtHeadFlag"] || "N", i = [i]), t.All[e] = t.All[e].concat(
                i))
        }
        t[a] = t.All, delete t.All
    }
}
function handlerRePrtHeadFlag2Parent(a, r, e) {
    if (0 < a[r][e].length) {
        var i = {
            Y: [],
            N: []
        };
        a[r][e].forEach(function (e) {
            var t = e["-RePrtHeadFlag"] || a[r]["-RePrtHeadFlag"];
            delete e["-RePrtHeadFlag"], i[t].push(e)
        }), delete a[r], 0 < i.Y.length && 0 < i.N.length ? (a[r] = [], a[r].push({
            "-RePrtHeadFlag": "Y"
        }), a[r][0][e] = i.Y, a[r].push({
            "-RePrtHeadFlag": "N"
        }), a[r][1][e] = i.N) : 0 < i.Y.length ? (a[r] = {
            "-RePrtHeadFlag": "Y"
        }, a[r][e] = i.Y) : (a[r] = {
            "-RePrtHeadFlag": "N"
        }, a[r][e] = i.N)
    }
}
var validPrtPaperSet = function () {
       "Z" == $("#t-LandscapeOrientation").combobox("getValue") ? $("#tr-height .tdCtrlAttrLeft a").text("底边空白高度(cm)") : $("#tr-height .tdCtrlAttrLeft a").text("高度")
    },
    loadXmlTpl = function (e) {
	    drawByXml(e), validPrtPaperSet()
    },
    deleteProps = function (e, t) {
        for (var a = 0; a < t.length; a++) delete e[t[a]]
    },
    delCtrl = function () {
        if ($("#DelMenu").hasClass('l-btn-disabled')); //.hasClass("imggray")
        else {
            for (var e = 0, t = "", a = !1, r = (selectCompSet.length-1); r >= 0; r--) t = selectCompSet[r].attr("data-type"),
                e = selectCompSet[r].attr("data-ind"), "line" == t && (a = !0), "undefined" != typeof xmldesigner[t] &&
                xmldesigner[t].method.delItem && xmldesigner[t].method.delItem(e), selectCompSet.splice(r, 1);
            a && xmldesigner.line.method.draw();
            selectItem("");
        }
    };
function getCurrXml(Type) {
    if (void 0 === invoiceData) return "";
    if ("none" != $("#dbLayout").css("display")) {
        if (Type == "SAVE") {	        
        	var e = $.extend(!0, {}, invoiceData, {
	            "SPSXMLPrintDirection": invoiceData.LandscapeOrientation,
	            "SPSPrintDeviceName": invoiceData.PrtDevice || "",
	            "SPSPrintPaperName": invoiceData.PrtPage || "", //纸张名称
	            "SPSPrintTemplWidth": invoiceData.width,
	            "SPSPrintTemplHeight": invoiceData.height,
	            "SPSPrintPaperHeight":invoiceData.PaperHeight,
	            "SPSPrintPaperWidth":invoiceData.PaperWidth,
	            "SPSHorizontalAmount":invoiceData.HorizontalAmount,
	            "SPSVerticalAmount":invoiceData.VerticalAmount,
	            "SPSPrintPreview":invoiceData.PrintPreview,
	            "SPSXMLPrintMode":invoiceData.XMLPrintMode,
	            "SPSForbidRepeatPrint":invoiceData.ForbidRepeatPrint,
	            "SPSPrintPresetQuantity":invoiceData.PrintPresetQuantity
	        });
	        deleteProps(e, ["ind", "type", "-LandscapeOrientation","LandscapeOrientation","-PaperHeight","PaperHeight","-PaperWidth","PaperWidth","-height","height", "-width","width","HorizontalAmount","VerticalAmount","PrtDevice","PrtPage","PrintPreview","ForbidRepeatPrint","PrintPresetQuantity"]);
	        e.TxtData || (e.TxtData = {"-RePrtHeadFlag": invoiceData.TxtData && invoiceData.TxtData["-RePrtHeadFlag"] || "N"}),
	        e.PLData || (e.PLData = { "-RePrtHeadFlag": invoiceData.PLData && invoiceData.PLData["-RePrtHeadFlag"] || "Y"}),
	        e.PICData || (e.PICData = {"-RePrtHeadFlag": invoiceData.PICData && invoiceData.PICData["-RePrtHeadFlag"] || "N"})
        
	        e.TxtData.txtdatapara = xmldesigner.label.method.genItemJson(), 
	        Array.prototype.push.apply(e.TxtData.txtdatapara,xmldesigner.qrcode.method.genItemJson()), 
	        Array.prototype.push.apply(e.TxtData.txtdatapara, xmldesigner.barcode.method.genItemJson()),
	        handlerRePrtHeadFlag2Parent(e, "TxtData", "txtdatapara"),
	        e.PLData.PLine =xmldesigner.line.method.genItemJson(), handlerRePrtHeadFlag2Parent(e, "PLData", "PLine");
	        var t = xmldesigner.list.method.genItemJson();
	        0 < t.length && (e.ListData = t[0], e.ListData.Listdatapara = xmldesigner.listItem.method.genItemJson()),
	            e.PICData.PICdatapara = xmldesigner.img.method.genItemJson(), handlerRePrtHeadFlag2Parent(e, "PICData","PICdatapara") 
	        /*return (new XML.ObjTree).writeXML({
	                appsetting: {
	                    invoice: e
	                }
	            })*/
	        return {appsetting: {invoice: e}}
	    }else{
		    var e = $.extend(!0, {}, invoiceData, {
	            "-LandscapeOrientation": invoiceData.LandscapeOrientation,
	            "-PrtDevice": invoiceData.PrtDevice || "",
	            "-PrtPage": invoiceData.PrtPage || "", //纸张名称
	            "-width": invoiceData.width,
	            "-height": invoiceData.height,
	            "-PaperHeight":invoiceData.PaperHeight,
	            "-PaperWidth":invoiceData.PaperWidth,
	            "-HorizontalAmount":invoiceData.HorizontalAmount,
	            "-VerticalAmount":invoiceData.VerticalAmount,
	            "-PrintPreview":invoiceData.PrintPreview,
	            "-XMLPrintMode":invoiceData.XMLPrintMode,
	            "-ForbidRepeatPrint":invoiceData.ForbidRepeatPrint,
	            "-PrintPresetQuantity":invoiceData.PrintPresetQuantity
	        });
	        "" == invoiceData.LandscapeOrientation && deleteProps(e, ["-LandscapeOrientation"]),
	        deleteProps(e, ["ind", "type", "LandscapeOrientation","PrtDevice","PrtPage", "width", "height","PaperHeight","PaperWidth","HorizontalAmount","VerticalAmount","PrintPreview","XMLPrintMode","ForbidRepeatPrint","PrintPresetQuantity"]),
	        e.TxtData || (e.TxtData = {"-RePrtHeadFlag": invoiceData.TxtData && invoiceData.TxtData["-RePrtHeadFlag"] || "N"}),
	        e.PLData || (e.PLData = { "-RePrtHeadFlag": invoiceData.PLData && invoiceData.PLData["-RePrtHeadFlag"] || "Y"}),
	        e.PICData || (e.PICData = {"-RePrtHeadFlag": invoiceData.PICData && invoiceData.PICData["-RePrtHeadFlag"] || "N"})
        
	        e.TxtData.txtdatapara = xmldesigner.label.method.genXmlJson(), 
	        Array.prototype.push.apply(e.TxtData.txtdatapara,xmldesigner.qrcode.method.genXmlJson()), 
	        Array.prototype.push.apply(e.TxtData.txtdatapara, xmldesigner.barcode.method.genXmlJson()),
	        handlerRePrtHeadFlag2Parent(e, "TxtData", "txtdatapara"),
	        e.PLData.PLine =xmldesigner.line.method.genXmlJson(), handlerRePrtHeadFlag2Parent(e, "PLData", "PLine");
	        var t = xmldesigner.list.method.genXmlJson();
	        return 0 < t.length && (e.ListData = t[0], e.ListData.Listdatapara = xmldesigner.listItem.method.genXmlJson()),
	            e.PICData.PICdatapara = xmldesigner.img.method.genXmlJson(), handlerRePrtHeadFlag2Parent(e, "PICData",
	                "PICdatapara"), (new XML.ObjTree).writeXML({
	                appsetting: {
	                    invoice: e
	                }
	            })
       }
    }
    var a = editAreaLoader.getValue("xmlTextArea"),
        r = !1;
    return a.replace(/xcol="(.+?)"/gi, function (e, t, a) {
        if (/[^0-9.]/.test(t)) return $.messager.alert("格式错误", e + "内容不合法"), r = !0, e
    }), r ? "" : (a.replace(/yrow="(.+?)"/gi, function (e, t, a) {
        if (/[^0-9.]/.test(t)) return $.messager.alert("格式错误", e + "内容不合法"), r = !0, e
    }), r ? "" : (a.replace(/width="(.+?)"/gi, function (e, t, a) {
        if (/[^0-9.]/.test(t)) return $.messager.alert("格式错误", e + "内容不合法"), r = !0, e
    }), r ? "" : (a.replace(/height="(.+?)"/gi, function (e, t, a) {
        if (/[^0-9.]/.test(t)) return $.messager.alert("格式错误", e + "内容不合法"), r = !0, e
    }), r ? "" : a)))
}
var SaveXml = function () {
        if ($("#SaveMenu").hasClass('l-btn-disabled')); //.hasClass("imggray")
        else {
            if ("" == $("#currentXmlTplName").html()) return !1;
            var e = getCurrXml("SAVE");
            /*var t = e;
            var a = new XML.ObjTree,
                r = $.trim(t),
                i = a.parseXML(r);*/
            SaveConfig(e);
        }
    },
    moveAllItem = function (r, i) {
        i = parseInt(i);
        $.each("label,line,img,barcode,qrcode".split(","), function (e, t) {
            for (var a = 0; a < xmldesigner[t].data.length; a++) xmldesigner[t].method.move(r, a, i)
        }), xmldesigner.line.method.draw()
    },
    moveItem = function (e, t) {
        for (var a, r, i, n = !1, l = 0; l < selectCompSet.length; l++) r = (a = selectCompSet[l]).attr("data-ind"),
            "line" == (i = a.attr("data-type")) && (n = !0), xmldesigner[i].method.move(e, r, t);
        n && xmldesigner.line.method.draw()
    },
    alignSelectItem = function (e, t, a, r) {
        xmldesigner.line.data, xmldesigner.label.data;
        for (var i, n, l, o = !1, d = 1; d < selectCompSet.length; d++) n = (i = selectCompSet[d]).attr("data-ind"),
            "line" == (l = i.attr("data-type")) && (o = !0), xmldesigner[l].method.alignItem(n, t, a, r);
        o && xmldesigner.line.method.draw()
    },
    AlignCtrl = function (e) {
        var t, a, r, i, n, l, o, d, s = selectCompSet[0],
            m = s.attr("data-type"),
            c = xmldesigner[m].method.getItemOffset(s);
        switch (t = c.x, a = c.y, r = c.w, n = a + (i = c.h), l = t + r, o = a + i / 2, d = t + r / 2, e) {
            case "LEFTALIGN":
                alignSelectItem(m, "x", t);
                break;
            case "TOPALIGN":
                alignSelectItem(m, "y", a);
                break;
            case "BOTTOMALIGN":
                alignSelectItem(m, "b", n);
                break;
            case "RIGHTALIGN":
                alignSelectItem(m, "r", l);
                break;
            case "H-ALIGN":
                alignSelectItem(m, "ha", o);
                break;
            case "V-ALIGN":
                alignSelectItem(m, "va", d);
                break;
            case "H-EQUAL":
                alignSelectItem(m, "h", i);
                break;
            case "W-EQUAL":
                alignSelectItem(m, "w", r);
                break;
            case "S-EQUAL":
                alignSelectItem(m, "s", i, r)
        }
    },
    excuteCmd = function (e) {
        var t = e.toUpperCase();
        switch (t) {
            case "SAVE":
                SaveXml();
                break;
            case "CUT":
                0 < this.options.selectCtrls.length && excuteSaveUnDo.apply(this), copyCtrl(), document.execCommand(
                    "Delete"), this.options.selectCtrls = new Array;
                break;
            case "COPY":
                copyCtrl();
                break;
            case "PASTE":
                pastCtrl();
                break;
            case "DELETE":
                delCtrl();
                break;
            case "UNDO":
                this.UnDo();
                break;
            case "REDO":
                this.ReDo();
                break;
            case "TOFRONT":
                adjustCtrlPosition(!0);
                break;
            case "TOBACK":
                adjustCtrlPosition(!1);
                break;
            case "SELECTEDMOVE":
                $('<div id="allItemMove" style="padding:10px;"></div>').appendTo(document.body).window({
                    title: "整体元素位置移动",
                    resizable: !1,
                    width: 250,
                    height: 280,
                    modal:true,
                    maximizable: !1,
                    minimizable: !1,
                    collapsible: !1,
                    content: '<div style="margin:20px auto;text-align: center;"><label>一次移动长度(mm)：</label><input id="moveStepNpt" value="10" style="width:25px;"/></div>\t\t\t\t\t\t\t<table style="margin:30px auto;"><tr><td></td><td><a href="javascript:moveAllItem(\'top\',document.getElementById(\'moveStepNpt\').value);" class="easyui-linkbutton">上</a></td><td></td></tr>\t\t\t\t\t\t\t<tr><td><a href="javascript:moveAllItem(\'left\',document.getElementById(\'moveStepNpt\').value);" class="easyui-linkbutton">左</a></td><td></td>\t\t\t\t\t\t\t<td><a href="javascript:moveAllItem(\'right\',document.getElementById(\'moveStepNpt\').value);" class="easyui-linkbutton">右</a></td>\t\t\t\t\t\t\t<tr><td></td><td><a href="javascript:moveAllItem(\'bottom\',document.getElementById(\'moveStepNpt\').value);" class="easyui-linkbutton">下</a></td><td></td></tr>'
                }).show().window("move", {
                    right: 300
                });
                break;
            default:
                AlignCtrl(t)
        }
    },
    init = function () {
        var e = $("#centerdesignebar").height();
        $("#lo").css("height", document.body.clientHeight), $("#lo").layout("resize");
        $(document).width();
        $("#dbLayout").css("width", $("#centerdesignebar").width() -2).css("height", e-2)
        $("#dbLayout").attr("width", $("#centerdesignebar").width() -2).attr("height", e-2)
        $("#lineLayout").attr("width", $("#dbLayout").width()).attr("height", $("#dbLayout").height())
        //$("#lineLayout").css("width", $("#dbLayout").width()).css("height", $("#dbLayout").height()), 
        $(".toolbar").on("mousedown",
            function (e) {
	            var sheetRowId=GetSelPrtSheetTypeRowId();
	            if (!sheetRowId){
		            $.messager.popover({msg: '请先选择左侧单据！',type: 'success'});
					return false;
		        }
                var t = $(e.target);
                if (t.hasClass("CtrlItem") || t.parent().hasClass("CtrlItem")) {
                    enableMenuItem("SaveMenu", "save"), enableMenuItem("SaveAsMenu", "saveas");
                    var a = "";
                    t.hasClass("CtrlItem") && (a = t.attr("ctrltype")), t.parent().hasClass("CtrlItem") && (a = t.parent()
                        .attr("ctrltype")), "object" == typeof xmldesigner[a] && "object" == typeof xmldesigner[a].method && xmldesigner[a].method.drawNew()
                }
            });
            $("#centerdesignebar").on("mousedown", function (e) {
            var t = $(e.target);
            t.attr("data-type");
            if (t.hasClass("ctrldrag")) enableMenuItem("SaveMenu", "save"), enableMenuItem("SaveAsMenu",
                "saveas"), e = e || window.event, t.hasClass("ctrldrag") && (e.target.onselectstart =
                function () {
                    return !1
                }, setDragParams(e)), selectItem(e.target, e);
            else {
                var a = xmldesigner.line.method.getLineByPoint(e.offsetX, e.offsetY); - 1 < a ? selectItem(
                    document.getElementById("midline" + a), e) : "lineLayout" == e.target.id ? (
                    enableMenuItem("SaveMenu", "save"), enableMenuItem("SaveAsMenu", "saveas"), e = e ||
                    window.event, selectItem(e.target, e)) : selectItem("")
            }
        }), $("#dbLayout").delegate(".ctrldrag", "mousemove", function (e) {
            e.preventDefault();
            e = e || window.event;
            var t = $(dragParams.target);
            if (dragParams.mouseDownFlag) {
                var a = t.attr("data-type");
                xmldesigner[a].method.dragMove(e, dragParams)
            } else;
        }), $("#lo").on("mouseup", function (e) { //$("body").on("mouseup", function (e) {
            e.preventDefault();
            var t = $(e.target);
            //if (t.attr("cmd") && excuteCmd(t.attr("cmd")), t.hasClass("pic") && excuteCmd(t.parent().attr("cmd")),
            if (t.parents("td").attr("cmd") && excuteCmd(t.parents("td").attr("cmd")), t.hasClass("pic") && excuteCmd(tt.parents("td").attr("cmd")),
                dragParams.mouseDownFlag && dragParams.target) {
                var a = $(dragParams.target),
                    r = a.attr("data-ind"),
                    i = a.attr("data-type");
                xmldesigner[i].method.dragEnd(dragParams.target, r, e)
            }
            dragParams.mouseDownFlag = !1, dragParams.target = null
        }), $(".centerlayout").on("keydown", function (e) {
            var t = $(dragParams.target),
                a = (t.attr("data-ind"), t.attr("data-type"), e.ctrlKey ? 10 : 1);
            if (-1 < [37, 38, 39, 40].indexOf(e.keyCode)) {
                if (e.stopPropagation(), 37 == e.keyCode) return moveItem("left", a), !1;
                if (38 == e.keyCode) return moveItem("top", a), !1;
                if (39 == e.keyCode) return moveItem("right", a), !1;
                if (40 == e.keyCode) return moveItem("bottom", a), !1
            }
        }), $("#lo").on("keydown", function (e) {//$("body").on("keydown", function (e) {
            if (46 == e.keyCode || 17 == e.keyCode || e.ctrlKey && 83 == e.keyCode) {
                if (e.ctrlKey && 83 == e.keyCode) return excuteCmd("Save"), !1;
                if (46 == e.keyCode) return "INPUT" == e.target.tagName.toUpperCase() || (excuteCmd("DELETE"),
                    !1)
            }
            e.returnValue = !1
        }), $("#tbCtrlAttr").delegate(".numberStyle,.txtStyle", "keydown", function (e) {
            13 == (e.keyCode ? e.keyCode : e.which) && setCtrlAttr(e)
        }), $("#tbCtrlAttr").delegate(".numberStyle,.txtStyle", "focusout", function (e) {
            setCtrlAttr(e)
        }), $("#tbCtrlAttr").delegate("#t-defaultvalue", "dblclick", function (e) {
            1 == selectCompSet.length && $(selectCompSet[0]).attr("data-type")
        })
};
$(init);
function selectHandler(){
	setCtrlAttr($(this));
}
function PrintPreviewSwitchChange(){
	setCtrlAttr($(this));
}
function printSwitchChange(){
	setCtrlAttr($(this));
}
function CreatXmlDoc(obj){
	this.tagName=obj.tagName;
    this.properties = obj.properties;
    this.children=obj.children;
}
function loadXMLDoc(dname) {
    try {//Internet Explorer
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    } catch(e) {
        try {//Firefox, Mozilla, Opera, etc.
            xmlDoc = document.implementation.createDocument("", "", null);
        } catch(e) {
            alert(e.message)
        }
    }
    return xmlDoc;
}
CreatXmlDoc.prototype.render=function(){
    xmlDoc = loadXMLDoc();
    var xe1 = xmlDoc.createElement(this.tagName);
    for(var p in this.properties){
        xe1.setAttribute(p, this.properties[p]);
    }
    var children=this.children || [];
    children.forEach(function(child){
        var childEl=(child instanceof CreatXmlDoc)
        ? child.render()
        :xmlDoc.createTextNode(child)
    	xe1.appendChild(childEl);
    })
    return xe1;
}// 封装调用函数
// 将json转成xml文档，再转成字符串
var xmlToString = function(XMLStr) {
	if (websys_isIE){
		SetupSerial = XMLStr.xml;
	}else{
    	SetupSerial=(new XMLSerializer()).serializeToString(XMLStr);
    }
    var reg = new RegExp(' xmlns="http://www.w3.org/1999/xhtml"',"g");
    // 替换转义字符
    var reg1 = new RegExp('<',"g"); // <
    var reg2 = new RegExp('>',"g"); // >
    var reg3 = new RegExp('&',"g"); // &
    var reg4 = new RegExp('&apos;',"g"); // '
    var reg5 = new RegExp('"',"g"); // "
    SetupSerial=SetupSerial.replace(reg,"").replace(reg1, "<").replace(reg2, ">").replace(reg3, "&").replace(reg4, "'").replace(reg5, '"');
    return SetupSerial;
}
function defaultXML(){
	var e = $("#centerdesignebar").height();
	var t = $("#centerdesignebar").width();
	return '<?xml version="1.0" encoding="gb2312" ?>'+
		'<appsetting>'+
		'<invoice height="'+Math.trunc((pxToPt(e)-2))+'" width="'+Math.trunc((pxToPt(t)-2))+'" PrtPaperSet="HAND" PrtDevice="" PrtPage="" PaperDesc="">'+
		'<ListData PrintType="List" YStep="4.5" XStep="0" CurrentRow="1" PageRows="30" RePrtHeadFlag="Y" BackSlashWidth="0"></ListData>'+
		'<PLData RePrtHeadFlag="Y"></PLData>'+
		'<PICData RePrtHeadFlag="N"></PICData>'+
		'<TxtData RePrtHeadFlag="N"></TxtData>'+
		'</invoice>'+
		'</appsetting>';
}