"undefined" == typeof XML && (XML = function () {}), XML.ObjTree = function () {
        return this
    }, XML.ObjTree.VERSION = "0.23", XML.ObjTree.prototype.xmlDecl = '<?xml version="1.0" encoding="gb2312" ?>\n', XML.ObjTree
    .prototype.attr_prefix = "-", XML.ObjTree.prototype.parseXML = function (t) {
        var e;
        if (window.DOMParser) {
            var a = new DOMParser,
                d = a.parseFromString(t, "application/xml");
            if (!d) return;
            e = d.documentElement
        } else window.ActiveXObject && ((a = new ActiveXObject("Microsoft.XMLDOM")).async = !1, a.loadXML(t), e = a.documentElement);
        if (e) return this.parseDOM(e)
    }, XML.ObjTree.prototype.parseHTTP = function (t, e, a) {
        var d, o = {};
        for (var n in e) o[n] = e[n];
        if (o.method || ("undefined" == typeof o.postBody && "undefined" == typeof o.postbody && "undefined" == typeof o
                .parameters ? o.method = "get" : o.method = "post"), a) {
            o.asynchronous = !0;
            var r = this,
                l = a,
                i = o.onComplete;
            o.onComplete = function (t) {
                var e;
                t && t.responseXML && t.responseXML.documentElement && (e = r.parseDOM(t.responseXML.documentElement)),
                    l(e, t), i && i(t)
            }
        } else o.asynchronous = !1;
        if ("undefined" != typeof HTTP && HTTP.Request) o.uri = t, (s = new HTTP.Request(o)) && (d = s.transport);
        else if ("undefined" != typeof Ajax && Ajax.Request) {
            var s;
            (s = new Ajax.Request(t, o)) && (d = s.transport)
        }
        return a ? d : d && d.responseXML && d.responseXML.documentElement ? this.parseDOM(d.responseXML.documentElement) :
            void 0
    }, XML.ObjTree.prototype.parseDOM = function (t) {
        if (t) {
            if (this.__force_array = {}, this.force_array)
                for (var e = 0; e < this.force_array.length; e++) this.__force_array[this.force_array[e]] = 1;
            var a = this.parseElement(t);
            if (this.__force_array[t.nodeName] && (a = [a]), 11 != t.nodeType) {
                var d = {};
                d[t.nodeName] = a, a = d
            }
            return a
        }
    }, XML.ObjTree.prototype.parseElement = function (t) {
        if (7 != t.nodeType) {
            if (3 == t.nodeType || 4 == t.nodeType) {
                if (null == t.nodeValue.match(/[^\x00-\x20]/)) return;
                return t.nodeValue
            }
            var e, a = {};
            if (t.attributes && t.attributes.length) {
                e = {};
                for (var d = 0; d < t.attributes.length; d++) {
                    if ("string" == typeof (r = t.attributes[d].nodeName))(l = t.attributes[d].nodeValue) && (
                        "undefined" == typeof a[r = this.attr_prefix + r] && (a[r] = 0), a[r]++, this.addNode(e, r,
                            a[r], l))
                }
            }
            if (t.childNodes && t.childNodes.length) {
                var o = !0;
                e && (o = !1);
                for (d = 0; d < t.childNodes.length && o; d++) {
                    var n = t.childNodes[d].nodeType;
                    3 != n && 4 != n && (o = !1)
                }
                if (o) {
                    e = e || "";
                    for (d = 0; d < t.childNodes.length; d++) e += t.childNodes[d].nodeValue
                } else {
                    e = e || {};
                    for (d = 0; d < t.childNodes.length; d++) {
                        var r, l;
                        if ("string" == typeof (r = t.childNodes[d].nodeName))(l = this.parseElement(t.childNodes[d])) &&
                            ("undefined" == typeof a[r] && (a[r] = 0), a[r]++, this.addNode(e, r, a[r], l))
                    }
                }
            }
            return e
        }
    }, XML.ObjTree.prototype.addNode = function (t, e, a, d) {
        this.__force_array[e] ? (1 == a && (t[e] = []), t[e][t[e].length] = d) : 1 == a ? t[e] = d : 2 == a ? t[e] = [t[
            e], d] : t[e][t[e].length] = d
    }, XML.ObjTree.prototype.writeXML = function (t) {
        var e = this.hash_to_xml(null, t);
        return this.xmlDecl + e
    }, XML.ObjTree.prototype.hash_to_xml = function (t, e) {
        var a = [],
            d = [];
        for (var o in e)
            if (e.hasOwnProperty(o)) {
                var n = e[o];
                o.charAt(0) != this.attr_prefix ? void 0 === n || null == n ? a[a.length] = "<" + o + " />" : "object" ==
                    typeof n && n.constructor == Array ? a[a.length] = this.array_to_xml(o, n) : a[a.length] = "object" ==
                    typeof n ? this.hash_to_xml(o, n) : this.scalar_to_xml(o, n) : d[d.length] = " " + o.substring(1) +
                    '="' + this.xml_escape(n) + '"'
            } var r = d.join(""),
            l = a.join("");
        return void 0 === t || null == t || (l = 0 < a.length ? l.match(/\n/) ? "<" + t + r + ">\n" + l + "</" + t +
            ">\n" : "<" + t + r + ">" + l + "</" + t + ">\n" : "<" + t + r + " />\n"), l
    }, XML.ObjTree.prototype.array_to_xml = function (t, e) {
        for (var a = [], d = 0; d < e.length; d++) {
            var o = e[d];
            void 0 === o || null == o ? a[a.length] = "<" + t + " />" : "object" == typeof o && o.constructor == Array ?
                a[a.length] = this.array_to_xml(t, o) : a[a.length] = "object" == typeof o ? this.hash_to_xml(t, o) :
                this.scalar_to_xml(t, o)
        }
        return a.join("")
    }, XML.ObjTree.prototype.scalar_to_xml = function (t, e) {
        return "#text" == t ? this.xml_escape(e) : "<" + t + ">" + this.xml_escape(e) + "</" + t + ">\n"
    }, XML.ObjTree.prototype.xml_escape = function (t) {
        return (t + "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;")
    }, XML.ObjTree.prototype.getComboValue = function (t, a, e) {
	    var comboDataArr = $("#"+t).combobox("getData");
	    var ComboIndex = $.hisui.indexOfArray(comboDataArr,a,e);
        return (ComboIndex >= 0) ? comboDataArr[ComboIndex].value : "";
    }, "undefined" == typeof xmldesigner && (xmldesigner = {}), xmldesigner.label = {},
    function (i) {
        var s = xmldesigner.label;
        s.data = [];
        var t = "x-label",
            e = "labelTpl";
        function a(t) {
            var e = xmldesigner.label.type;
            t == s.data.length && (s.data[t] = {
                id: e + t,
                name: e + t,
                ind: t,
                type: e,
                x: 10,//此处单位是pt
                y: 10,
                defaultvalue: e + t,
                fontsize: 10,
                fontname: "宋体",
                text: e + t,
                fontbold: "Normal",
                height: "",
                width: "",
                angle: 0,
                binditem:"",
                SPCSID:""
            });
            var a = s.data[t],
                d = "";
            a["-name"] ? (a.name = a["-name"], a.defaultvalue = a["-defaultvalue"], a.x = ptToPx(a["-xcol"]), a.y =
                    ptToPx(a["-yrow"]), a.fontname = a["-fontname"] || "宋体", a.fontsize = a["-fontsize"],
                    a.height = isNaN(ptToPx(a["-height"])) ? "" : ptToPx(a["-height"]), a
                    .width = isNaN(a["-width"]) ? "" : ptToPx(a["-width"]), "C39P36DmTt" == a.fontname && (a.fontsize =
                        a.fontsize), a.angle = a["-angle"] || 0, d = (a["-fontbold"] == "Bold")?"Bold":"Normal",
                        a.binditem = a["-binditem"] || "",a.SPCSID = a["-SPCSID"] || "",
                        deleteProps(a, ["-width", "-height", "-name", "-defaultvalue",
                        "-xcol", "-yrow", "-fontsize", "-fontname", "-fontbold", "-angle","-binditem","-SPCSID","-isqrcode"])) : (d = a.fontbold,a.x = ptToPx(a.x),a.y = ptToPx(a.y),a.height = isNaN(ptToPx(a.height)) ? "" : ptToPx(a.height),
                		a.width = isNaN(ptToPx(a.width)) ? "" : ptToPx(a.width)),
                         "Normal" != d ? (a.fontweight = "bold", a.fontbold = "Bold") : (a.fontweight = "normal", a.fontbold = "Normal"), a.id = e + t, a.type = e, a.ind = t, a.text =
                a.defaultvalue || "[" + a.name + "]";
            var o = i("#" + a.id);
            0 < o.length ? (o.attr("name", a.name).css("left", a.x).css("top", a.y), o.css("font-size", a.fontsize +
                    "pt").css("font-family", a.fontname).css("font-weight", a.fontweight),
                o.css("width", a.width).css("height", a.height).css("transform", "rotate(-" + a.angle + "deg)"),
                o.text(a.text)) : i.tmpl(xmldesigner.label.tplName, a).appendTo(
                "#dbLayout")
        }
        i.template(e,
                "<div id='${id}' name='${name}' data-ind='${ind}' data-type='${type}' style='{{if width}}width:${width}px;{{/if}}{{if height}}height:${height}px;{{/if}}z-index:108;left:${x}px;top:${y}px;font-size:${fontsize}pt;font-weight:${fontweight};font-family:${fontname};transform-origin:0 0;transform:rotate(-${angle}deg);' class='ctrldrag x-label ${selectedCls}'>${text}</div>"
            ), xmldesigner.label.cls = t, xmldesigner.label.tplName = e, xmldesigner.label.type = "label", xmldesigner.label
            .method = {
                init: function d() {
                    s.data = []
                },
                drawNew: function o() {
                    a(s.data.length)
                },
                drawByInd: a,
                showAttrsByInd: function n(t) {
                    i("#t-fontsize").prop("disabled", !1);
					i("#t-barcodetype,#t-isshowtext,#t-qrcodeversion,#t-fontname,#t-fontbold").combobox("enable");
                    var e = s.data[t];
                    for (var a in e) {
	                    i("#tr-" + a).show();
	                    if (i("#t-" + a).hasClass("combobox-f")){
		                    var opts = i("#t-" + a).combobox("options");
		                    if (opts.multiple) {
			                    i("#t-" + a).combobox("setValues",e[a]?e[a].split(","):[]);
			                }else{
			                    var ComboDataArr=i("#t-" + a).combobox("getData");
			                    var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"text",e[a]);
			                    if  (ComboIndex < 0){
				                    var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"value",e[a]);
				                }
			                    if (ComboIndex >=0 ){
				                    i("#t-" + a).combobox("setValue",ComboDataArr[ComboIndex]["value"]);
				                }else{
					                i("#t-" + a).combobox("setValue","");
					            }
			                }
		                }else{
			                if ((a=="x")||(a=="y")||(a=="width")||(a=="height")){
				                i("#t-" + a).val(e[a] !=="" ? pxToPt(e[a]) : "");
				            }else{
			                	i("#t-" + a).val(e[a]);
			                }
			            }
	                }
	                i("#tr-SPCSID,#tr-ind").hide();
                },
                dragMove: function r(t, e) {
                    var a = t.clientX,
                        d = t.clientY,
                        o = a - e.currentX,
                        n = d - e.currentY;
                    e.target.style.left = parseFloat(e.left) + o + "px", e.target.style.top = parseFloat(e.top) + n +
                        "px"
                },
                dragEnd: function l(t, e, a) {
                    s.data[e].x = parseFloat(t.style.left), s.data[e].y = parseFloat(t.style.top), s.method.showAttrsByInd(e)
                },
                drawByAttrTable: function c(t) {
                    s.data[t].x = parseFloat(i("#t-x").val()), s.data[t].y = parseFloat(i("#t-y").val()), s.data[t]
                        .name = i("#t-name").val();
                    var e = parseFloat(i("#t-width").val()),
                        a = parseFloat(i("#t-height").val());
                    s.data[t].width = isNaN(e) ? "" : e, s.data[t].height = isNaN(a) ? "" : a, s.data[t].fontsize =
                        i("#t-fontsize").val(), s.data[t].fontbold = i("#t-fontbold").combobox("getValue"), s.data[t].fontname = i(
                            "#t-fontname").combobox("getText"), s.data[t].defaultvalue =
                        i("#t-defaultvalue").val(), s.data[t].angle = i("#t-angle").val() || 0, s.data[t].binditem = i("#t-binditem").combobox("getValues").join(","), s.data[t].SPCSID = 
                        i("#t-SPCSID").val() ,s.method.drawByInd(t)
                },
                genXmlJson: function p() {
                    for (var t, e, a = [], d = 0; d < s.data.length; d++)
                        if (e = (t = s.data[d]).fontsize, "C39P36DmTt" == t.fontname && (e = ptToPx(t.fontsize)),
                            "undefined" != typeof t.delFlag && 1 == t.delFlag);
                        else {
                            var o = {
                                    "-name": t.name,
                                    "-xcol": pxToPt(t.x),
                                    "-yrow": pxToPt(t.y),
                                    "-defaultvalue": t.defaultvalue || "",
                                    "-printvalue": t.printvalue || "",
                                    "-fontbold": t.fontbold,
                                    "-fontname": t.fontname,
                                    "-fontsize": e,
                                    "-binditem": t.binditem,
                                    "-SPCSID": t.SPCSID,
                                    "-height": t.height,
                                    "-width": t.width,
                                    "-angle": t.angle
                                },
                                n = isNaN(pxToPt(t.width)) ? "" : pxToPt(t.width),
                                r = isNaN(pxToPt(t.height)) ? "" : pxToPt(t.height);
                            0 < n && (o["-width"] = n), 0 < r && (o["-height"] = r), 0 < t.angle && (o["-angle"] =
                                t.angle), a.push(o)
                        } return a
                },
                genItemJson: function pp(){
	                for (var t, e, a = [], d = 0; d < s.data.length; d++)
                    if (e = (t = s.data[d]).fontsize, "C39P36DmTt" == t.fontname && (e = ptToPx(t.fontsize)),
                        "undefined" != typeof t.delFlag && 1 == t.delFlag);
                    else {
                        var o = {
	                        	"SPCSXMLItemType": "TxtData",
                                "SPCSDesc": t.name,
                                "SPCSX": pxToPt(t.x),
                                "SPCSY": pxToPt(t.y),
                                "SPCSContent": t.defaultvalue || "",
                                "SPCSBold": (t.fontbold == "Bold" ? "Bold" : "Normal"),
                                "SPCSFont": (t.fontname != "" ? (new XML.ObjTree).getComboValue("t-fontname","text",t.fontname) : "Song"),
                                "SPCSFontSize": e,
                                "SPCSDataBindItem": t.binditem || "",
                                "ID": t.SPCSID || "",
                                "SPCSWidth": t.height,
                                "SPCSHeight": t.width,
                                "SPCSAngle": t.angle || 0
                            },
                            n = isNaN(pxToPt(t.width)) ? "" : pxToPt(t.width),
                            r = isNaN(pxToPt(t.height)) ? "" : pxToPt(t.height);
                        0 < n && (o["SPCSWidth"] = n), 0 < r && (o["SPCSHeight"] = r), 0 < t.angle && (o["-angle"] =
                            t.angle), a.push(o)
                    } 
                    return a
	            },
                delItem: function h(t) {
                    s.data[t].delFlag = !0, i("#" + xmldesigner.label.type + t).remove(), SPCSID = s.data[t].SPCSID, delSheetPrtContentSet(SPCSID)
                },
                getItemOffset: function f(t) {
                    var e = t.attr("data-ind");
                    return {
                        x: s.data[e].x,
                        y: s.data[e].y,
                        w: t.width(),
                        h: t.height()
                    }
                },
                alignItem: function g(t, e, a, d) {
                    var o = s.data[t],
                        n = s.type,
                        r = i("#" + n + t).height(),
                        l = i("#" + n + t).width();
                    switch (e) {
                        case "x":
                            o.x = a;
                            break;
                        case "y":
                            o.y = a;
                            break;
                        case "b":
                            o.y = a - r;
                            break;
                        case "r":
                            o.x = a - l;
                            break;
                        case "ha":
                            o.y = a - r / 2;
                            break;
                        case "va":
                            o.x = a - l / 2
                        case "h":
                            o.height = a;
                            break;
                        case "w":
                            o.width = a;
                            break;
                        case "s":
                            o.height = a, o.width = d;
                    }
                    s.data[t].x=pxToPt(o.x);
                    s.data[t].y=pxToPt(o.y);
                    s.data[t].width=isNaN(pxToPt(o.width)) ? "" : pxToPt(o.width);
                    s.data[t].height=isNaN(pxToPt(o.height)) ? "" : pxToPt(o.height);
                    s.method.drawByInd(t)
                },
                move: function y(t, e, a) {
                    var d = s.data[e];
                    d && ("left" == t ? d.x = d.x - a : "right" == t ? d.x = d.x + a : "top" == t ? d.y = d.y - a :
                        "bottom" == t && (d.y = d.y + a)), 
                        s.data[e].x=pxToPt(d.x),
	                    s.data[e].y=pxToPt(d.y),
	                    s.data[e].width=isNaN(pxToPt(d.width)) ? "" : pxToPt(d.width),
	                    s.data[e].height=isNaN(pxToPt(d.height)) ? "" : pxToPt(d.height),
                        s.method.drawByInd(e)
                }
            }
    }(jQuery), "undefined" == typeof xmldesigner && (xmldesigner = {}), xmldesigner.line = {},
    function (i) {
        var c = xmldesigner.line;
        c.data = [];
        var t = "x-line",
            e = "lineTpl";
        i.template(e,
                "<div id='st${id}' data-ind='${ind}' data-type='${type}' style='left:${stx}px;top:${sty}px;z-index:107;' class='ctrldrag x-line st-point'></div><div id='mid${id}' data-ind='${ind}' data-type='${type}' style='left:${midx}px;top:${midy}px;z-index:107;' class='ctrldrag x-line mid-point'></div><div id='end${id}' data-ind='${ind}' data-type='${type}' style='left:${endx}px;top:${endy}px;z-index:107;' class='ctrldrag x-line end-point'></div>"
            ), xmldesigner.line.cls = t, xmldesigner.line.type = "line", xmldesigner.line.tplName = e, xmldesigner.line
            .method = {
                init: function a() {
                    c.data = []
                },
                drawNew: function d() {
                    var t = xmldesigner.line.type,
                        e = c.data.length;
                    c.data[e] = {
                        id: t + e,
                        ind: e,
                        name: t + e,
                        type: t,
                        stx: 10,
                        sty: 10,
                        endx: 100, //此处单位是px
                        endy: 10,
                        SPCSID:""
                    }, c.method.draw()
                },
                drawByInd: function () {},
                draw: function r() {
                    for (var t, e = xmldesigner.line.type, a = {}, d = [], o = 0; o < selectCompSet.length; o++)
                        selectCompSet[o].attr("data-type") == e && d.push(selectCompSet[o].attr("data-ind"));
                    mycontext && mycontext.clearRect(0, 0, mycanvas.width, mycanvas.height);
                    for (var n = 0; n < c.data.length; n++) a = c.data[n], mycontext && mycontext.beginPath(),
                        "boolean" == typeof a.delFlag && 1 == a.delFlag || ((t = a).midx = (parseFloat(t.stx) +
                                parseFloat(t.endx)) / 2, t.midy = (parseFloat(t.sty) + parseFloat(t.endy)) / 2,
                            document.getElementById("end" + e + n) ? (document.getElementById("st" + e + n).style.top =
                                a.sty + "px", document.getElementById("st" + e + n).style.left = a.stx + "px",
                                document.getElementById("end" + e + n).style.top = a.endy + "px", document.getElementById(
                                    "end" + e + n).style.left = a.endx + "px", document.getElementById("mid" + e +
                                    n).style.top = a.midy + "px", document.getElementById("mid" + e + n).style.left =
                                a.midx + "px") : i.tmpl(
                                xmldesigner.line.tplName, a).appendTo("#dbLayout"), -1 < d.indexOf("" + n) ? (
                                mycontext && (mycontext.strokeStyle = "green"), document.getElementById("st" + e +
                                    n).style.visibility = "visible", document.getElementById("midline" + n).style.visibility =
                                "visible", document.getElementById("end" + e + n).style.visibility = "visible") : (
                                mycontext && (mycontext.strokeStyle = "black"), document.getElementById("end" + e +
                                    n) && (document.getElementById("st" + e + n).style.visibility = "hidden",
                                    document.getElementById("midline" + n).style.visibility = "hidden", document.getElementById(
                                        "end" + e + n).style.visibility = "hidden")), mycontext && (mycontext.moveTo(a.stx, a.sty), mycontext.lineTo(
                                    a.endx, a.endy), mycontext.stroke()))
                },
                showAttrsByInd: function o(t) {
                    i("#t-fontsize").prop("disabled", !1);
					i("#t-barcodetype,#t-isshowtext,#t-qrcodeversion,#t-fontname,#t-fontbold").combobox("enable");
                    var e = c.data[t];
                    for (var a in e) {
	                    if ("y" != a){
		                    i("#tr-" + a).show();
		                    if ((a =="stx")||(a =="sty")||(a =="endx")||(a =="endy")){
			                    i("#t-" + a).val(e[a] !=="" ? pxToPt(e[a]) : "");
			                }else{
		                    	i("#t-" + a).val(e[a]);
		                    }
		                }
	                }
	                i("#tr-SPCSID,#tr-ind").hide();
                },
                dragMove: function l(t, e) {
                    var a = t.clientX,
                        d = t.clientY,
                        o = a - e.currentX,
                        n = d - e.currentY;
                    e.target.style.left = parseFloat(e.left) + o + "px", e.target.style.top = parseFloat(e.top) + n +
                        "px"
                },
                dragEnd: function s(t, e, a) {
                    var d = a.clientX,
                        o = a.clientY,
                        n = d - dragParams.currentX,
                        r = o - dragParams.currentY,
                        l = i(t);
                    l.hasClass("mid-point") ? (c.data[e].stx += n, c.data[e].sty += r, c.data[e].endx += n, c.data[
                            e].endy += r) : l.hasClass("st-point") ? (c.data[e].stx += n, c.data[e].sty += r) : l.hasClass(
                            "end-point") && (c.data[e].endx += n, c.data[e].endy += r), c.method.draw(),
                        xmldesigner.line.method.showAttrsByInd(e)
                },
                drawByAttrTable: function n(t) {
                    c.data[t].stx = ptToPx(i("#t-stx").val()), c.data[t].sty = ptToPx(i("#t-sty").val()), 
                    c.data[t].endx = ptToPx(i("#t-endx").val()), c.data[t].endy = ptToPx(i("#t-endy").val()),
                    c.data[t].SPCSID = i("#t-SPCSID").val(), c.method.draw()
                },
                genXmlJson: function p() {
                    for (var t, e = [], a = 0; a < c.data.length; a++)
                        if ("boolean" == typeof (t = c.data[a]).delFlag && 1 == t.delFlag);
                        else {
                            var d = {
                                "-BeginX": pxToPt(t.stx),
                                "-BeginY": pxToPt(t.sty),
                                "-EndX": pxToPt(t.endx),
                                "-EndY": pxToPt(t.endy),
                                "-SPCSID": t.SPCSID || ""
                            };
                            e.push(d)
                        } return e
                },
                genItemJson: function pp() {
	                for (var t, e = [], a = 0; a < c.data.length; a++)
                    if ("boolean" == typeof (t = c.data[a]).delFlag && 1 == t.delFlag);
                    else {
                        var d = {
	                        "SPCSXMLItemType": "PLData",
	                        "SPCSDesc": t.name,
                            "SPCSStartX": pxToPt(t.stx),
                            "SPCSStartY": pxToPt(t.sty),
                            "SPCSEndX": pxToPt(t.endx),
                            "SPCSEndY": pxToPt(t.endy),
                            "ID": t.SPCSID || ""
                        };
                        e.push(d)
                    } return e
	            },
                item2Json: function f(t, e) {
                    var a = xmldesigner.line.type,
                        d = {
                            id: a + e,
                            ind: e,
                            name: a + e,
                            type: a,
                            stx: ptToPx(t[e]["-BeginX"]),
                            sty: ptToPx(t[e]["-BeginY"]),
                            endx: ptToPx(t[e]["-EndX"]),
                            endy: ptToPx(t[e]["-EndY"]),
                            SPCSID: t[e]["-SPCSID"]
                        };
                    return d
                },
                delItem: function g(t) {
                    var e = xmldesigner.line.type;
                    c.data[t].delFlag = !0, i("#st" + e + t).remove(), i("#end" + e + t).remove(), i("#mid" + e + t)
                        .remove(), SPCSID = c.data[t].SPCSID, delSheetPrtContentSet(SPCSID)
                },
                getItemOffset: function y(t) {
                    var e = t.attr("data-ind"),
                        a = c.data[e];
                    return {
                        x: a.stx,
                        y: a.sty,
                        w: a.endx - a.stx,
                        h: a.endy - a.sty
                    }
                },
                alignItem: function m(t, e, a, d) {
                    var o = c.data[t];
                    switch (h = o.endy - o.sty, w = o.endx - o.stx, e) {
                        case "x":
                            o.endx -= o.stx - a, o.stx = a;
                            break;
                        case "y":
                            o.endy -= o.sty - a, o.sty = a;
                            break;
                        case "b":
                            o.sty = a - h, o.endy = a;
                            break;
                        case "r":
                            o.stx = a - w, o.endx = a;
                            break;
                        case "ha":
                            o.sty = a - h / 2, o.endy = a + h / 2;
                            break;
                        case "va":
                            o.stx = a - w / 2, o.endx = a + w / 2;
                            break;
                        case "h":
                            o.endy = a + o.sty;
                            break;
                        case "w":
                            o.endx = a + o.stx;
                            break;
                        case "s":
                            o.endy = a + o.sty, o.endx = d + o.stx
                    }
                },
                getLineByPoint: function x(t, e) {
                    for (var a = 0; a < c.data.length; a++) {
                        var d = c.data[a];
                        if (o = t, n = e, r = d.stx, l = d.sty, i = d.endx, s = d.endy, Math.sqrt(Math.pow(o - r, 2) +
                                Math.pow(n - l, 2)) + Math.sqrt(Math.pow(i - o, 2) + Math.pow(s - n, 2)) - Math.sqrt(
                                Math.pow(i - r, 2) + Math.pow(s - l, 2)) < .3) return a
                    }
                    var o, n, r, l, i, s;
                    return -1
                },
                move: function u(t, e, a) {
                    var d = c.data[e];
                    d && ("left" == t ? (d.stx = d.stx - a, d.endx = d.endx - a) : "right" == t ? (d.stx = d.stx +
                            a, d.endx = d.endx + a) : "top" == t ? (d.sty = d.sty - a, d.endy = d.endy - a) :
                        "bottom" == t && (d.sty = d.sty + a, d.endy = d.endy + a))
                }
            }
    }(jQuery), "undefined" == typeof xmldesigner && (xmldesigner = {}), xmldesigner.img = {},
    function (i) {
        var s = xmldesigner.img;
        s.data = [];
        var r = location.href.split("/web/")[0] + "/web/",
            l = "scripts/dhctt/xmldesigner/img/defaultimg.jpg";
        function t(t) {
            i("#t-fontsize").prop("disabled", !1);
			i("#t-barcodetype,#t-isshowtext,#t-qrcodeversion,#t-fontname,#t-fontbold").combobox("enable");
            var e = xmldesigner.img.type,
                a = !1;
            if (t == s.data.length) {
                var d = r + l;
                s.data[t] = {
                    id: e + t,
                    name: e + t,
                    ind: t,
                    type: e,
                    x: 10,
                    y: 10,
                    height: 130, //此处单位是px
                    width: 130,
                    src: d,
                    defaultvalue: r + l,
                    SPCSID:""
                }, a = !0
            }
            var o = s.data[t];
            a || (o.src = o.defaultvalue), o.id = e + t, o.type = e, o.ind = t;
            //o.x=ptToPx(o.x),o.y=ptToPx(o.y),o.height=ptToPx(o.height),o.width=ptToPx(o.width);
            var n = i("#" + o.id);
            0 < n.length ? (n.attr("name", o.name).css("left", o.x).css("top", o.y).attr("src", o.src).css("height", o.height)
                .css("width", o.width)) : i.tmpl(xmldesigner.img.tplName,
                o).appendTo("#dbLayout")
        }
        i.template("imgTpl",
                "<img id='${id}' name='${name}' data-ind='${ind}' data-type='${type}' style='z-index:103;left:${x}px;top:${y}px;width:${width}px;height:${height}px;' src='${src}' class='ctrldrag x-img ${selectedCls}'/>"
            ), xmldesigner.img.cls = "x-img", xmldesigner.img.tplName = "imgTpl", xmldesigner.img.type = "img",
            xmldesigner.img.method = {
                init: function e() {
                    s.data = []
                },
                item2Json: function n(t, e) {
                    var a = xmldesigner.img.type,
                        d = t[e];
                    if (d["-defaultvalue"] || (d["-defaultvalue"] = ""), d["-printvalue"] || (d["-printvalue"] = ""),
                        d["-xcol"] || (d["-xcol"] = 1), d["-yrow"] || (d["-yrow"] = 1), d["-name"] || (d["-name"] =
                            "undefinedNameImg"), d["-src"]) src = d["-src"];
                    else {
                        var o = d["-defaultvalue"];
                        1 == o.split("web\\").length ? src = r + l : src = r + o.split("web\\")[1].split("\\").join(
                            "/")
                    }
                    return {
                        id: a + e,
                        ind: e,
                        name: a + e,
                        type: a,
                        src: src,
                        name: d["-name"],
                        height: d["-height"] ? ptToPx(d["-height"]) : 130,
                        width: d["-width"] ? ptToPx(d["-width"]) : 130,
                        x: ptToPx(d["-xcol"]),
                        y: ptToPx(d["-yrow"]),
                        defaultvalue: d["-defaultvalue"],
                        SPCSID: d["-SPCSID"]||""
                    }
                },
                drawNew: function a() {
                    t(s.data.length)
                },
                drawByInd: t,
                showAttrsByInd: function d(t) {
                    var e = s.data[t];
                    for (var a in e) {
	                    i("#tr-" + a).show();
	                    if ((a =="x")||(a =="y")||(a =="height")||(a =="width")){
		                    i("#t-" + a).val(e[a] !=="" ? pxToPt(e[a]) : "");
		                }else{
	                    	i("#t-" + a).val(e[a]);
	                    }
	                }
	                i("#tr-SPCSID,#tr-ind").hide();
                },
                dragMove: function c(t, e) {
                    var a = t.clientX,
                        d = t.clientY,
                        o = a - e.currentX,
                        n = d - e.currentY;
                    e.target.style.left = parseFloat(e.left) + o + "px", e.target.style.top = parseFloat(e.top) + n +
                        "px"
                },
                dragEnd: function o(t, e, a) {
                    s.data[e].x = parseFloat(t.style.left), s.data[e].y = parseFloat(t.style.top), xmldesigner.img.method.showAttrsByInd(e)
                },
                drawByAttrTable: function p(t) {
                    s.data[t].x = ptToPx(parseFloat(i("#t-x").val())), s.data[t].y = ptToPx(parseFloat(i("#t-y").val())), s.data[t]
                        .height = ptToPx(i("#t-height").val()), s.data[t].width = ptToPx(i("#t-width").val()), s.data[t].name = i(
                            "#t-name").val(), s.data[t].defaultvalue = i("#t-defaultvalue").val(), s.data[t].src =
                        i("#t-src").val(), s.data[t].SPCSID = i("#t-SPCSID").val(), s.method.drawByInd(t)
                },
                genXmlJson: function h() {
                    for (var t, e = [], a = 0; a < s.data.length; a++) "boolean" == typeof (t = s.data[a]).delFlag &&
                        1 == t.delFlag || e.push({
                            "-name": t.name,
                            "-xcol": pxToPt(t.x),
                            "-yrow": pxToPt(t.y),
                            "-height": pxToPt(t.height),
                            "-width": pxToPt(t.width),
                            "-defaultvalue": t.defaultvalue || "",
                            "-printvalue": t.printvalue || "",
                            "-SPCSID": t.SPCSID || "",
                            "-src": t.src || ""
                        });
                    return e
                },
                genItemJson: function hh() {
	                for (var t, e = [], a = 0; a < s.data.length; a++) "boolean" == typeof (t = s.data[a]).delFlag &&
                        1 == t.delFlag || e.push({
	                        "SPCSXMLItemType": "PICData",
                            "SPCSDesc": t.name,
                            "SPCSX": pxToPt(t.x),
                            "SPCSY": pxToPt(t.y),
                            "SPCSHeight": pxToPt(t.height),
                            "SPCSWidth": pxToPt(t.width),
                            "SPCSImgSrc": t.src || "",
                            "SPCSContent": t.defaultvalue || "",
                            "ID": t.SPCSID || "",
                            "SPCSImgSrc": t.src || ""
                        });
                    return e
	            },
                delItem: function f(t) {
                    s.data[t].delFlag = !0, i("#" + xmldesigner.img.type + t).remove(), SPCSID = s.data[t].SPCSID, delSheetPrtContentSet(SPCSID)
                },
                getItemOffset: function g(t) {
                    var e = t.attr("data-ind");
                    return {
                        x: s.data[e].x,
                        y: s.data[e].y,
                        w: t.width(),
                        h: t.height()
                    }
                },
                alignItem: function y(t, e, a, d) {
                    var o = s.data[t],
                        n = s.type,
                        r = i("#" + n + t).height(),
                        l = i("#" + n + t).width();
                    switch (e) {
                        case "x":
                            o.x = a;
                            break;
                        case "y":
                            o.y = a;
                            break;
                        case "b":
                            o.y = a - r;
                            break;
                        case "r":
                            o.x = a - l;
                            break;
                        case "ha":
                            o.y = a - r / 2;
                            break;
                        case "va":
                            o.x = a - l / 2
                    }
                    
                    s.method.drawByInd(t)
                },
                move: function m(t, e, a) {
                    var d = s.data[e];
                    d && ("left" == t ? d.x = d.x - a : "right" == t ? d.x = d.x + a : "top" == t ? d.y = d.y - a :
                        "bottom" == t && (d.y = d.y + a)), 
                        //s.data[e].x=pxToPt(d.x),
	                    //s.data[e].y=pxToPt(d.y),
	                    //s.data[e].width=isNaN(pxToPt(d.width)) ? "" : pxToPt(d.width),
	                    //s.data[e].height=isNaN(pxToPt(d.height)) ? "" : pxToPt(d.height),
                        s.method.drawByInd(e)
                }
            }
    }(jQuery), "undefined" == typeof xmldesigner && (xmldesigner = {}), xmldesigner.list = {},
    function (l) {
        var i = xmldesigner.list;
        i.data = [];
        var t = "listTpl";
        function e(t) {
            var e = xmldesigner.list.type;
            t == i.data.length && (i.data[t] = {
                id: e + t,
                name: e + t,
                ind: t,
                type: e,
                width: ptToPx(invoiceData.width) -4,
                height: 15, //此处单位是px
                YStep: 15,
                XStep: 0,
                x: 0,
                y: 0,
                CurrentRow: 1,
                PageRows: 100,
                SPCSID:""
            });
            e = xmldesigner.list.type;
            var a = i.data[t],
                d = l("#" + e + t);
            //a.width=ptToPx(a.width),a.height=ptToPx(a.height),a.x=ptToPx(a.x),a.y=ptToPx(a.y),a.YStep=ptToPx(a.YStep),a.XStep=ptToPx(a.XStep);
            if (0 < d.length) {
                if (d.width(i.data[t].width).height(a.height).css("top", a.y), l("." + xmldesigner.listItem.cls).css(
                        "top", a.y), xmldesigner.listItem.data)
                    for (var o = 0; o < xmldesigner.listItem.data.length; o++) xmldesigner.listItem.data[o].y = i.data[t].y
            } else l.tmpl(xmldesigner.list.tplName, a).appendTo("#dbLayout")
        }
        l.template(t,
                "<div id='${id}' name='${name}' data-ind='${ind}' data-type='${type}' style='z-index:105;left:${x}px;top:${y}px;width:${width}px;height:${height}px;' class='ctrldrag x-list ${selectedCls}'></div>"
            ), xmldesigner.list.cls = "x-list", xmldesigner.list.type = "list", xmldesigner.list.tplName = t,
            xmldesigner.list.method = {
                init: function a() {
                    i.data = []
                },
                item2Json: function d(t, e) {
                    var a = xmldesigner.list.type;
                    return "undefined" != t["-YStep"] && "undefined" != typeof t["-YStep"] || (t["-YStep"] = 10),
		            "undefined" != t["-CurrentRow"] && "undefined" != typeof t["-CurrentRow"] || (t["-CurrentRow"] = 1),
		            "undefined" != t["-PageRows"] && "undefined" != typeof t["-PageRows"] || (t["-PageRows"] = 20),
		            "undefined" != t["-RePrtHeadFlag"] && "undefined" != typeof t["-RePrtHeadFlag"] || (t["-RePrtHeadFlag"] = "N"),
            		{
                        id: a + e,
                        name: a + e,
                        ind: e,
                        type: a,
                        width: ptToPx(invoiceData.width) - 4,
                        x: "0",
                        y: ptToPx(t["-yrow"]) || 0,
                        height: ptToPx(t["-YStep"]) || 10,
                        YStep: ptToPx(t["-YStep"]),
                        XStep: 0,
                        CurrentRow: t["-CurrentRow"],
                        PageRows: t["-PageRows"],
                        SPCSID: t["-SPCSID"]
                     }
                },
                drawNew: function o() {
	                for (var a=0;a < xmldesigner.list.data.length;a++){
		                var delFlag = xmldesigner.list.data[a].delFlag;
		                if (delFlag) continue;
		                l.messager.alert("提示", "已有列表, 请增加列项.");
		                return;
		            }
		            e(i.data.length)
                    //0 < l("#" + xmldesigner.list.type + "0").length ? l.messager.alert("提示", "已有列表, 请增加列项.") : e(i.data.length)
                },
                drawByInd: e,
                showAttrsByInd: function n(t) {
                    var e = i.data[t];
                    for (var a in e) {
	                    if ("height" != a && "width" != a && "name" != a && "x" != a){
		                    l("#tr-" + a).show();
		                    if ((a =="YStep")||(a =="y")){
			                    l("#t-" + a).val(e[a] !=="" ? pxToPt(e[a]) : 0);
			                }else if((a=="PageRows")||(a=="CurrentRow")){
				                l("#t-" + a).numberbox("setValue",e[a]);
				            }else{
		                    	l("#t-" + a).val(e[a]);
		                    }
		                }
                    }
                    l("#tr-SPCSID,#tr-ind").hide();
                },
                dragMove: function r(t, e) {
                    var a = t.clientY - e.currentY;
                    l("." + xmldesigner.listItem.cls).css("top", parseFloat(e.top) + a + "px"), e.target.style.top =
                        parseFloat(e.top) + a + "px"
                },
                dragEnd: function s(t, e, a) {
                    i.data[e].x = parseFloat(t.style.left), i.data[e].y = parseFloat(t.style.top), xmldesigner.list.method.showAttrsByInd(e);
                    var d = xmldesigner.listItem.data;
                    if (xmldesigner.listItem.data)
                        for (var o = 0; o < d.length; o++) d[o].y = i.data[e].y
                },
                drawByAttrTable: function c(t) {
                    i.data[t].y = ptToPx(l("#t-y").val()), i.data[t].PageRows = l("#t-PageRows").numberbox("getValue"), 
                    i.data[t].CurrentRow = l("#t-CurrentRow").val(), i.data[t].YStep = ptToPx(l("#t-YStep").val()), 
                    i.data[t].height = ptToPx(l("#t-YStep").val()), l("#t-height").val(i.data[t].height), 
                    i.data[t].SPCSID = l("#t-SPCSID").val();
                    i.method.drawByInd(t)
                },
                genXmlJson: function p() {
                    for (var t, e = [], a = 0; a < i.data.length; a++) "undefined" != typeof (t = i.data[a]).delFlag &&
                        1 == t.delFlag || e.push({
                            "-PrintType": "List",
                            "-YStep": pxToPt(t.height) || 10,
                            "-XStep": 0,
                            "-CurrentRow": t.CurrentRow || 1,
                            "-PageRows": t.PageRows || 10,
                            "-SPCSID": t.SPCSID || "",
                            "-yrow": pxToPt(t.y) || 0,
                            Listdatapara: []
                        });
                    return e
                },
                genItemJson: function pp() {
	                for (var t, e = [], a = 0; a < i.data.length; a++) "undefined" != typeof (t = i.data[a]).delFlag &&
                        1 == t.delFlag || e.push({
                            "SPCSXMLItemType": "ListData",
                            "SPCSY": pxToPt(t.y) || 0,
                            "SPCSX": 0,
                            "SPCSListYStep": pxToPt(t.height) || 10,
                            "SPCSListCurrentRow": t.CurrentRow || 1,
                            "SPCSListPageRows": t.PageRows || 10,
                            "ID": t.SPCSID || "",
                            "SPCSX": pxToPt(t.x),
                            Listdatapara: []
                        });
                    return e
	            },
                delItem: function h(t) {
                    i.data[t].delFlag = !0, l("#" + xmldesigner.list.type + t).remove(), l("." + xmldesigner.listItem
                        .cls).remove(), SPCSID = i.data[t].SPCSID, delSheetPrtContentSet(SPCSID)
                    for (var a = 0; a < xmldesigner.listItem.data.length; a++){
	                    xmldesigner["listItem"].method.delItem(a)
	                }
                },
                getItemOffset: function f(t) {
                    var e = t.attr("data-ind");
                    return {
                        x: i.data[e].x,
                        y: i.data[e].y,
                        w: t.width(),
                        h: t.height()
                    }
                },
                alignItem: function g(t, e, a, d) {
                    var o = i.data[t],
                        n = i.type,
                        r = l("#" + n + t).height();
                    switch (l("#" + n + t).width(), e) {
                        case "x":
                            break;
                        case "y":
                            o.y = a;
                            break;
                        case "b":
                            o.y = a - r;
                            break;
                        case "r":
                            break;
                        case "ha":
                            o.y = a - r / 2
                    }
                    i.method.drawByInd(t)
                },
                move: function y(t, e, a) {
                    var d = i.data[e];
                    d && ("top" == t ? d.y = d.y - a : "bottom" == t && (d.y = d.y + a)), i.method.drawByInd(e)
                }
            }
    }(jQuery), "undefined" == typeof xmldesigner && (xmldesigner = {}), xmldesigner.listItem = {},
    function (l) {
        var i = xmldesigner.listItem;
        i.data = [];
        var t = "x-listItem",
            e = "listItemTpl";
        function a(t) {
            var e = xmldesigner.listItem.type;
            var listFlag="N";
            for (var k=0;k < xmldesigner.list.data.length;k++){
                var delFlag = xmldesigner.list.data[k].delFlag;
                if (delFlag) continue;
                listFlag="Y";
                break;
            }
            if (listFlag =="N") return $.messager.alert("提示","请先画出列表, 再画列表项!"), !1;
            if (t == i.data.length) {
                var a = 100;
                0 < i.data.length && (a += i.data[t - 1].x), i.data[t] = {
                    id: e + t,
                    name: e + t,
                    ind: t,
                    type: e,
                    x: pxToPt(a), //此处单位是pt
                    y: pxToPt(xmldesigner.list.data[xmldesigner.list.data.length - 1].y), 
                    fontsize: 10,
                    fontname: "宋体",
                    text: e + t,
                    fontbold: "Normal",
                    coltype: "text",
                    width: "",
                    height: "",
                    barcodetype: "",
                    isshowtext: "",
                    qrcodeversion: "",
                    binditem:"",
                    SPCSID:"",
                    defaultvalue: e + t
                }
            }
            var d = i.data[t],
                o = "";
            d["-name"] ? (d.name = d["-name"], d.defaultvalue = d["-defaultvalue"], d.x = ptToPx(d["-xcol"]), d.y =
                    ptToPx(d["-yrow"]), d.coltype = d["-coltype"] || "text", d.width = d["-width"] ? ptToPx(d["-width"]) :
                    "", d.height = d["-height"] ? ptToPx(d["-height"]) : "", d.barcodetype = d["-barcodetype"] || "", d
                    .isshowtext = d["-isshowtext"] || "", d.qrcodeversion = d["-qrcodeversion"] || "", d.fontsize = d[
                        "-fontsize"], d.fontname = d["-fontname"] || "宋体", o = d["-fontbold"],d.binditem = d["-binditem"] || "", 
                        d.SPCSID = d["-SPCSID"] || "", deleteProps(d, ["-name", "-defaultvalue", "-xcol", "-yrow",
                        "-fontsize", "-fontname", "-fontbold", "-coltype", "-width", "-height",
                        "-barcodetype", "-isshowtext", "-qrcodeversion","-binditem","-SPCSID","-isqrcode"])) : (o = d.fontbold,d.x = ptToPx(d.x),d.y = ptToPx(d.y),d.height = isNaN(ptToPx(d.height)) ? "" : ptToPx(d.height),
                		d.width = isNaN(ptToPx(d.width)) ? "" : ptToPx(d.width),d.SPCSID = d["-SPCSID"] ? d["-SPCSID"] : (d["SPCSID"]?d["SPCSID"]:"")), "Normal" != o ? (d.fontweight =
                    "bold", d.fontbold = "Bold") : (d.fontweight = "normal", d.fontbold = "Normal"), d.id = e + t, d.type =
                e, d.ind = t, d.text = d.defaultvalue || "|" + d.name;
            var n = l("#" + d.id);
            0 < n.length ? (n.data("coltype", d.coltype).css("width", d.width).css("height", d.height), n.attr("name",
                d.name), n.css("left", d.x).css("top", d.y).css("font-size", d.fontsize + "pt").css(
                "font-family", d.fontname).css("font-weight", d.fontweight), n.text(
                d.text)) : l.tmpl(xmldesigner.listItem.tplName, d).appendTo("#dbLayout")
        }
        function d(t) {
            for (var e in i.data[t]) {
	            if (l("#t-" + e).hasClass("combobox-f")){
		            l("#t-" + e).combobox("enable");
		        }else{
	            	l("#t-" + e).prop("disabled", !1);
	            }
	        }
            i.data[t].coltype = l("#t-coltype").combobox("getValue"),
            "img" == i.data[t].coltype 
            ? (l("#t-barcodetype,#t-isshowtext,#t-qrcodeversion,#t-fontname,#t-fontbold").combobox("disable"),l("#t-fontsize").prop("disabled", !0)) 
            : "barcode" == i.data[t].coltype 
            ? (l("#t-qrcodeversion,#t-fontname,#t-fontbold").combobox("disable"),l("#t-fontsize").prop("disabled", !0)) : "qrcode" == i.data[t]
                .coltype ? (l("#t-barcodetype,#t-isshowtext,#t-fontname,#t-fontbold").combobox("disable"),l("#t-fontsize").prop("disabled", !0)) :
                l("#t-barcodetype,#t-isshowtext,#t-qrcodeversion").combobox("disable"), "" != l("#t-width").val() && (
                    i.data[t].width = parseFloat(l("#t-width").val())), "" != l("#t-height").val() && (i.data[t].height =
                    parseFloat(l("#t-height").val())), "" != l("#t-barcodetype").combobox("getValue") && (i.data[t].barcodetype = l(
                    "#t-barcodetype").combobox("getValue")), "" != l("#t-isshowtext").combobox("getValue") && (i.data[t].isshowtext = l(
                    "#t-isshowtext").combobox("getValue")), "" != l("#t-qrcodeversion").combobox("getValue") && (i.data[t].qrcodeversion = l(
                    "#t-qrcodeversion").combobox("getValue")), i.data[t].x = parseFloat(l("#t-x").val()), i.data[t].y = parseFloat(l(
                    "#t-y").val() || 0), i.data[t].name = l("#t-name").val(), i.data[t].fontsize = l("#t-fontsize").val(), i
                .data[t].fontbold = l("#t-fontbold").combobox("getValue"),
                i.data[t].fontname = l("#t-fontname").combobox("getText"), i.data[t].defaultvalue =
                l("#t-defaultvalue").val(), i.data[t].binditem = l("#t-binditem").combobox("getValues").join(","), 
                i.data[t].SPCSID = l("#t-SPCSID").val(),i.method.drawByInd(t)
        }
        l.template(e,
                "<div id='${id}' name='${name}' data-ind='${ind}' data-type='${type}' data-coltype='${coltype}' style='z-index:106;left:${x}px;top:${y}px;font-size:${fontsize}pt;font-weight:${fontweight};font-family:${fontname};{{if width}}width:${width}px;{{/if}}{{if height}}height:${height}px;{{/if}}' class='ctrldrag x-listItem ${selectedCls}'>${text}</div>"
            ), xmldesigner.listItem.cls = t, xmldesigner.listItem.type = "listItem", xmldesigner.listItem.tplName = e,
            xmldesigner.listItem.method = {
                init: function o() {
                    i.data = []
                },
                drawNew: function n() {
                    a(i.data.length)
                },
                drawByInd: a,
                showAttrsByInd: function r(t) {
                    var e = i.data[t];
                    for (var a in e) {
	                    l("#tr-" + a).show();
	                    if (l("#t-" + a).hasClass("combobox-f")){
		                    l("#t-" + a).combobox("enable");
		                    var opts = l("#t-" + a).combobox("options");
							if (opts.multiple) {
								l("#t-" + a).combobox("setValues",e[a]?e[a].split(","):[]);
							}else{
								if (a == "coltype"){
									l("#t-" + a).combobox("setValue",e[a]);
								}else{
									var ComboDataArr=l("#t-" + a).combobox("getData");
									var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"text",e[a]);
									if  (ComboIndex < 0){
										var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"value",e[a]);
									}
									if (ComboIndex >=0 ){
										l("#t-" + a).combobox("setValue",ComboDataArr[ComboIndex]["value"]);
									}else{
										l("#t-" + a).combobox("setValue","");
									}
								}
							}
		                }else{
							l("#t-" + a).prop("disabled", !1);
							if ((a=="x")||(a=="y")||(a=="width")||(a=="height")){
				                l("#t-" + a).val(e[a] !=="" ? pxToPt(e[a]) : "");
				            }else{
	                    		l("#t-" + a).val(e[a]);
	                    	}
						}
	                }
                    l("#tr-SPCSID,#tr-ind").hide();
                    d(t)
                },
                dragMove: function s(t, e) {
                    var a = t.clientX,
                        d = t.clientY,
                        o = a - e.currentX,
                        n = d - e.currentY;
                    e.target.style.left = parseFloat(e.left) + o + "px", e.target.style.top = parseFloat(e.top) + n +
                        "px"
                },
                dragEnd: function c(t, e, a) {
                    i.data[e].x = parseFloat(t.style.left), i.data[e].y = parseFloat(t.style.top), i.method.showAttrsByInd(e)
                },
                drawByAttrTable: d,
                genXmlJson: function p() {
                    for (var t, e = [], a = 0; a < i.data.length; a++)
                        if ("undefined" != typeof (t = i.data[a]).delFlag && 1 == t.delFlag);
                        else {
                            var d = {
                                "-name": t.name,
                                "-xcol": pxToPt(t.x),
                                "-yrow": pxToPt(t.y),
                                "-defaultvalue": t.defaultvalue || "",
                                "-printvalue": t.printvalue || "",
                                "-fontbold": t.fontbold,
                                "-fontname": t.fontname,
                                "-fontsize": t.fontsize,
                                "-coltype": t.coltype || "text",
                                "-binditem": t.binditem,
                                "-SPCSID": t.SPCSID || "",
                                "-width": t.width ? pxToPt(t.width):"",
                                "-height": t.height ? pxToPt(t.height):""
                            };
                            "" != t.width && (d["-width"] = pxToPt(t.width)), "" != t.height && (d["-height"] =
                                    pxToPt(t.height)), "" != t.barcodetype && (d["-barcodetype"] = t.barcodetype),
                                "" != t.isshowtext && (d["-isshowtext"] = t.isshowtext), "" != t.qrcodeversion && (
                                    d["-qrcodeversion"] = t.qrcodeversion), "text" == t.coltype ? deleteProps(d, ["coltype",
                                    "-barcodetype", "-isshowtext", "-qrcodeversion"]) : "img" == t.coltype ?
                                deleteProps(d, ["-barcodetype", "-isshowtext", "-qrcodeversion"]) :
                                "barcode" == t.coltype ? deleteProps(d, ["-qrcodeversion"]) : "qrcode" == t.coltype &&
                                deleteProps(d, ["-barcodetype", "-isshowtext"]), e.push(d)
                        } return e
                },
                genItemJson: function pp() {
	                for (var t, e = [], a = 0; a < i.data.length; a++)
                        if ("undefined" != typeof (t = i.data[a]).delFlag && 1 == t.delFlag);
                        else {
                            var d = {
	                            "SPCSXMLItemType": "Listdatapara",
                                "SPCSDesc": t.name,
                                "SPCSX": pxToPt(t.x),
                                "SPCSY": pxToPt(t.y),
                                "SPCSContent": t.defaultvalue || "",
                                "SPCSBold": (t.fontbold == "Bold" ? "Bold" : "Normal"),
                                "SPCSFont": (t.fontname != "" ? (new XML.ObjTree).getComboValue("t-fontname","text",t.fontname) : "Song"),
                                "SPCSFontSize": t.fontsize,
                                "SPCSXMLListItemColType": t.coltype || "text",
                                "SPCSDataBindItem": t.binditem,
                                "ID": t.SPCSID || "",
                                "SPCSWidth": t.width ,
                                "SPCSHeight": t.height
                            };
                            "" != t.width && (d["SPCSWidth"] = pxToPt(t.width)), 
                            "" != t.height && (d["SPCSHeight"] =pxToPt(t.height)), 
                            "" != t.barcodetype && (d["SPCSBarCodeType"] = t.barcodetype),
                            "" != t.isshowtext && (d["SPCSBarCodeShowText"] = t.isshowtext),
                            "" != t.qrcodeversion && (d["SPCSQRCodeVersion"] = t.qrcodeversion),
                            "text" == t.coltype ? deleteProps(d, ["SPCSXMLListItemColType","SPCSBarCodeType", "SPCSBarCodeShowText", "SPCSQRCodeVersion"]) : "img" == t.coltype ?
                             deleteProps(d, ["SPCSBarCodeType", "SPCSBarCodeShowText", "SPCSQRCodeVersion"]) :
                             "barcode" == t.coltype ? deleteProps(d, ["SPCSBarCodeShowText"]) : "qrcode" == t.coltype &&
                             deleteProps(d, ["SPCSBarCodeType", "SPCSBarCodeShowText"]), e.push(d)
                        } return e
	            },
                delItem: function h(t) {
                    i.data[t].delFlag = !0, l("#" + xmldesigner.listItem.type + t).remove(), SPCSID = i.data[t].SPCSID, delSheetPrtContentSet(SPCSID)
                },
                getItemOffset: function f(t) {
                    var e = t.attr("data-ind");
                    return {
                        x: i.data[e].x,
                        y: i.data[e].y,
                        w: t.width(),
                        h: t.height()
                    }
                },
                alignItem: function g(t, e, a, d) {
                    var o = i.data[t],
                        n = i.type,
                        r = (l("#" + n + t).height(), l("#" + n + t).width());
                    switch (e) {
                        case "x":
                            o.x = a;
                            break;
                        case "y":
                        case "b":
                            break;
                        case "r":
                            o.x = a - r;
                            break;
                        case "ha":
                            break;
                        case "va":
                            o.x = a - r / 2
                    }
                    i.method.drawByInd(t)
                },
                move: function y(t, e, a) {
                    var d = i.data[e];
                    d && ("left" == t ? d.x = d.x - a : "right" == t ? d.x = d.x + a : "top" == t ? d.y = d.y - a :
                        "bottom" == t && (d.y = d.y + a)), i.method.drawByInd(e)
                }
            }
    }(jQuery), "undefined" == typeof xmldesigner && (xmldesigner = {}), xmldesigner.qrcode = {},
    function (i) {
        var s = xmldesigner.qrcode;
        s.data = [];
        var t = "x-qrcode",
            e = "qrcodeTpl";
        function a(t) {
            var e = xmldesigner.qrcode.type;
            t == s.data.length && (s.data[t] = {
                name: e + t,
                width: pxToPt(100),
                height: pxToPt(100), //此处单位是pt
                x: pxToPt(10),
                y: pxToPt(10),
                defaultvalue: e + t,
                id: e + t,
                ind: t,
                type: e,
                qrcodeversion: "",
                binditem:"",
                SPCSID:""
            });
            var a = s.data[t];
            if (!a["-name"]){
	            a.x = ptToPx(a.x),a.y = ptToPx(a.y),a.height = isNaN(ptToPx(a.height)) ? "" : ptToPx(a.height),
                a.width = isNaN(ptToPx(a.width)) ? "" : ptToPx(a.width)
	        }
            a["-name"] && (a.name = a["-name"], a.defaultvalue = a["-defaultvalue"], a.qrcodeversion = a[
                    "-qrcodeversion"], a.x = ptToPx(a["-xcol"]), a.y = ptToPx(a["-yrow"]), a.width = ptToPx(a[
                    "-width"]), a.height = ptToPx(a["-height"]),a.binditem = a["-binditem"] || "",a.SPCSID = a["-SPCSID"] || "",
                    deleteProps(a, ["-name", "-defaultvalue", "-xcol", "-yrow",
                    "-fontsize", "-fontname", "-fontbold", "-width", "-height", "-qrcodeversion","-binditem","-SPCSID","-isqrcode"])),
                    a.id = e + t, a.type = e, a.ind = t;
            var d = i("#" + a.id);
            0 < d.length ? (d.attr("name", a.name).css("left", a.x).css("top", a.y), d.css("width", a.width).css(
                    "height", a.height)) :
                i.tmpl(xmldesigner.qrcode.tplName, a).appendTo("#dbLayout")
        }
        i.template(e,
                "<img id='${id}' name='${name}' data-ind='${ind}' data-type='${type}' data-qrcodeversion='${qrcodeversion}' style='z-index:104;left:${x}px;top:${y}px;width:${width}px;height:${height}px;' src='../scripts/dhctt/xmldesigner/img/qr.png' class='ctrldrag x-qrcode ${selectedCls}'/>"
            ), xmldesigner.qrcode.cls = t, xmldesigner.qrcode.tplName = e, xmldesigner.qrcode.type = "qrcode",
            xmldesigner.qrcode.method = {
                init: function d() {
                    s.data = []
                },
                drawNew: function o() {
                    a(s.data.length)
                },
                drawByInd: a,
                showAttrsByInd: function n(t) {
                    i("#t-fontsize").prop("disabled", !1);
					i("#t-barcodetype,#t-isshowtext,#t-qrcodeversion,#t-fontname,#t-fontbold").combobox("enable");
                    var e = s.data[t];
                    for (var a in e) {
						i("#tr-" + a).show();
						if (i("#t-" + a).hasClass("combobox-f")){
							var opts = i("#t-" + a).combobox("options");
							if (opts.multiple) {
								i("#t-" + a).combobox("setValues",e[a]?e[a].split(","):[]);
							}else{
								var ComboDataArr=i("#t-" + a).combobox("getData");
								var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"text",e[a]);
								if  (ComboIndex < 0){
									var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"value",e[a]);
								}
								if (ComboIndex >=0 ){
									i("#t-" + a).combobox("setValue",ComboDataArr[ComboIndex]["value"]);
								}else{
									i("#t-" + a).combobox("setValue","");
								}
							}
						}else{
							if ((a=="x")||(a=="y")||(a=="width")||(a=="height")){
				                i("#t-" + a).val(e[a] !=="" ? pxToPt(e[a]) : "");
				            }else{
								i("#t-" + a).val(e[a]);
							}
						}
					}
					i("#tr-SPCSID,#tr-ind").hide();
                },
                dragMove: function r(t, e) {
                    var a = t.clientX,
                        d = t.clientY,
                        o = a - e.currentX,
                        n = d - e.currentY;
                    e.target.style.left = parseFloat(e.left) + o + "px", e.target.style.top = parseFloat(e.top) + n +
                        "px"
                },
                dragEnd: function l(t, e, a) {
                    s.data[e].x = parseFloat(t.style.left), s.data[e].y = parseFloat(t.style.top), xmldesigner.qrcode.method.showAttrsByInd(e)
                },
                drawByAttrTable: function c(t) {
                    s.data[t].x = parseFloat(i("#t-x").val()), s.data[t].y = parseFloat(i("#t-y").val()), s.data[t]
                        .name = i("#t-name").val(), s.data[t].defaultvalue = i("#t-defaultvalue").val(), s.data[t].width =
                        i("#t-width").val(), s.data[t].height = i("#t-height").val(), s.data[t].qrcodeversion = i(
                            "#t-qrcodeversion").combobox("getValue"),
                            s.data[t].binditem = i("#t-binditem").combobox("getValues").join(","),
                            s.data[t].SPCSID = i("#t-SPCSID").val(), s.method.drawByInd(t)
                },
                genXmlJson: function p() {
                    for (var t, e = [], a = 0; a < s.data.length; a++)
                        if ("undefined" != typeof (t = s.data[a]).delFlag && 1 == t.delFlag);
                        else {
                            var d = {
                                "-name": t.name,
                                "-xcol": pxToPt(t.x),
                                "-yrow": pxToPt(t.y),
                                "-width": pxToPt(t.width),
                                "-height": pxToPt(t.height),
                                "-defaultvalue": t.defaultvalue || "",
                                "-printvalue": t.printvalue || "",
                                "-fontname": "宋体",
                                "-fontsize": "9",
                                "-fontbold": "Normal",
                                "-isqrcode": "true",
                                "-qrcodeversion": t.qrcodeversion || "",
                                "-binditem": t.binditem,
                                "-SPCSID": t.SPCSID || ""
                            };
                            e.push(d)
                        } return e
                },
                genItemJson: function pp() {
	                for (var t, e = [], a = 0; a < s.data.length; a++)
                        if ("undefined" != typeof (t = s.data[a]).delFlag && 1 == t.delFlag);
                        else {
                            var d = {
	                            "SPCSXMLItemType": "TxtData",
                                "SPCSDesc": t.name,
                                "SPCSX": pxToPt(t.x),
                                "SPCSY": pxToPt(t.y),
                                "SPCSWidth": pxToPt(t.width),
                                "SPCSHeight": pxToPt(t.height),
                                "SPCSContent": t.defaultvalue || "",
                                "SPCSFont": (new XML.ObjTree).getComboValue("t-fontname","text","宋体"),
                                "SPCSFontSize": "9",
                                "SPCSBold": "Normal",
                                "SPCSQRCodeVersion": t.qrcodeversion || "Auto",
                                "SPCSDataBindItem": t.binditem,
                                "ID": t.SPCSID || ""
                            };
                            e.push(d)
                        } return e
	            },
                delItem: function h(t) {
                    s.data[t].delFlag = !0, i("#" + xmldesigner.qrcode.type + t).remove(), SPCSID = s.data[t].SPCSID, delSheetPrtContentSet(SPCSID)
                },
                getItemOffset: function f(t) {
                    var e = t.attr("data-ind");
                    return {
                        x: s.data[e].x,
                        y: s.data[e].y,
                        w: t.width(),
                        h: t.height()
                    }
                },
                alignItem: function g(t, e, a, d) {
                    var o = s.data[t],
                        n = s.type,
                        r = i("#" + n + t).height(),
                        l = i("#" + n + t).width();
                    switch (e) {
                        case "x":
                            o.x = a;
                            break;
                        case "y":
                            o.y = a;
                            break;
                        case "b":
                            o.y = a - r;
                            break;
                        case "r":
                            o.x = a - l;
                            break;
                        case "ha":
                            o.y = a - r / 2;
                            break;
                        case "va":
                            o.x = a - l / 2
                    }
                    s.method.drawByInd(t)
                },
                move: function y(t, e, a) {
                    var d = s.data[e];
                    d && ("left" == t ? d.x = d.x - a : "right" == t ? d.x = d.x + a : "top" == t ? d.y = d.y - a :
                        "bottom" == t && (d.y = d.y + a)),
                        s.data[e].x=pxToPt(d.x),
	                    s.data[e].y=pxToPt(d.y),
	                    s.data[e].width=isNaN(pxToPt(d.width)) ? "" : pxToPt(d.width),
	                    s.data[e].height=isNaN(pxToPt(d.height)) ? "" : pxToPt(d.height),
                        s.method.drawByInd(e)
                }
            }
    }(jQuery), "undefined" == typeof xmldesigner && (xmldesigner = {}), xmldesigner.barcode = {},
    function (i) {
        var s = xmldesigner.barcode;
        s.data = [];
        var t = "x-barcode",
            e = "barcodeTpl";
        function a(t) {
            var e = xmldesigner.barcode.type;
            t == s.data.length && (s.data[t] = {
                name: e + t,
                width: pxToPt(100),
                height: pxToPt(50), //此处单位pt
                x: pxToPt(10),
                y: (10),
                defaultvalue: e + t,
                id: e + t,
                ind: t,
                type: e,
                barcodetype: "128A",
                angle: 0,
                isshowtext: "",
                binditem:"",
                SPCSID:""
            });
            var a = s.data[t];
            if (!a["-name"]){
	            a.x = ptToPx(a.x),a.y = ptToPx(a.y),a.height = isNaN(ptToPx(a.height)) ? "" : ptToPx(a.height),
                a.width = isNaN(ptToPx(a.width)) ? "" : ptToPx(a.width)
	        }
            a["-name"] && (a.name = a["-name"], a.defaultvalue = a["-defaultvalue"], a.x = ptToPx(a["-xcol"]), a.y =
                    ptToPx(a["-yrow"]), a.width = ptToPx(a["-width"]), a.height = ptToPx(a["-height"]), a.barcodetype =
                    a["-barcodetype"], a.angle = a["-angle"] || 0, a.isshowtext = a["-isshowtext"] || "", 
                    a.binditem = a["-binditem"] || "",a.SPCSID = a["-SPCSID"] || "",
                    deleteProps(a, ["-name","-defaultvalue", "-xcol", "-yrow", "-fontsize", "-fontname", "-fontbold",
                        "-width", "-height", "-barcodetype", "-angle", "-isshowtext","-binditem","-SPCSID"])), a.id = e + t,
                a.type = e, a.ind = t;
            var d = i("#" + a.id);
            0 < d.length ? (d.attr("name", a.name).css("left", a.x).css("top", a.y), d.css("width", a.width).css(
                "height", a.height).css("transform", "rotate(-" + a.angle + "deg)"), 
                d.attr("src", src = "../scripts/dhctt/xmldesigner/img/barcode" + a.isshowtext +
                ".png")) : i.tmpl(xmldesigner.barcode.tplName, a).appendTo(
                "#dbLayout")
        }
        i.template(e,
                "<img id='${id}' name='${name}' data-ind='${ind}' data-type='${type}' data-isshowtext='${isshowtext}' data-barcodetype='${barcodetype}' style='z-index:104;left:${x}px;top:${y}px;width:${width}px;height:${height}px;transform-origin:0 0;transform:rotate(-${angle}deg);' src='../scripts/dhctt/xmldesigner/img/barcode${isshowtext}.png' class='ctrldrag x-barcode ${selectedCls}'/>"
            ), xmldesigner.barcode.cls = t, xmldesigner.barcode.tplName = e, xmldesigner.barcode.type = "barcode",
            xmldesigner.barcode.method = {
                init: function d() {
                    s.data = []
                },
                drawNew: function o() {
                    a(s.data.length)
                },
                drawByInd: a,
                showAttrsByInd: function n(t) {
                    i("#t-fontsize").prop("disabled", !1);
					i("#t-barcodetype,#t-isshowtext,#t-qrcodeversion,#t-fontname,#t-fontbold").combobox("enable");
                    var e = s.data[t];
                    for (var a in e) {
						i("#tr-" + a).show();
						if (i("#t-" + a).hasClass("combobox-f")){
							var opts = i("#t-" + a).combobox("options");
							if (opts.multiple) {
								i("#t-" + a).combobox("setValues",e[a]?e[a].split(","):[]);
							}else{
								var ComboDataArr=i("#t-" + a).combobox("getData");
								var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"text",e[a]);
								if  (ComboIndex < 0){
									var ComboIndex=$.hisui.indexOfArray(ComboDataArr,"value",e[a]);
								}
								if (ComboIndex >=0 ){
									i("#t-" + a).combobox("setValue",ComboDataArr[ComboIndex]["value"]);
								}else{
									i("#t-" + a).combobox("setValue","");
								}
							}
						}else{
							if ((a=="x")||(a=="y")||(a=="width")||(a=="height")){
				                i("#t-" + a).val(e[a] !=="" ? pxToPt(e[a]) : "");
				            }else{
								i("#t-" + a).val(e[a]);
							}
						}
					}
					i("#tr-SPCSID,#tr-ind").hide();
                },
                dragMove: function r(t, e) {
                    var a = t.clientX,
                        d = t.clientY,
                        o = a - e.currentX,
                        n = d - e.currentY;
                    e.target.style.left = parseFloat(e.left) + o + "px", e.target.style.top = parseFloat(e.top) + n +
                        "px"
                },
                dragEnd: function l(t, e, a) {
                    s.data[e].x = parseFloat(t.style.left), s.data[e].y = parseFloat(t.style.top), xmldesigner.barcode.method.showAttrsByInd(e)
                },
                drawByAttrTable: function c(t) {
                    s.data[t].x = parseFloat(i("#t-x").val()), s.data[t].y = parseFloat(i("#t-y").val()), s.data[t]
                        .name = i("#t-name").val(), s.data[t].defaultvalue = i("#t-defaultvalue").val(), s.data[t].width =
                        i("#t-width").val(), s.data[t].height = i("#t-height").val(), s.data[t].barcodetype = i(
                            "#t-barcodetype").combobox("getValue"), s.data[t].angle = i("#t-angle").val() || 0, s.data[t].isshowtext =
                        i("#t-isshowtext").combobox("getValue"),
                        s.data[t].binditem = i("#t-binditem").combobox("getValues").join(","),
                        s.data[t].SPCSID = i("#t-SPCSID").val(), s.method.drawByInd(t)
                },
                genXmlJson: function p() {
                    for (var t, e = [], a = 0; a < s.data.length; a++)
                        if ("undefined" != typeof (t = s.data[a]).delFlag && 1 == t.delFlag);
                        else {
                            var d = {
                                "-name": t.name,
                                "-xcol": pxToPt(t.x),
                                "-yrow": pxToPt(t.y),
                                "-width": pxToPt(t.width),
                                "-height": pxToPt(t.height),
                                "-defaultvalue": t.defaultvalue || "",
                                "-printvalue": t.printvalue || "",
                                "-fontname": "",
                                "-fontsize": "9",
                                "-fontbold": "Normal",
                                "-barcodetype": t.barcodetype,
                                "-binditem": t.binditem,
                                "-SPCSID": t.SPCSID || ""
                            };
                            0 < t.angle && (d["-angle"] = t.angle), "N" == t.isshowtext && (d["-isshowtext"] = t.isshowtext), e.push(d)
                        } return e
                },
                genItemJson: function pp() {
	                for (var t, e = [], a = 0; a < s.data.length; a++)
                        if ("undefined" != typeof (t = s.data[a]).delFlag && 1 == t.delFlag);
                        else {
                            var d = {
	                            "SPCSXMLItemType": "TxtData",
                                "SPCSDesc": t.name,
                                "SPCSX": pxToPt(t.x),
                                "SPCSY": pxToPt(t.y),
                                "SPCSWidth": pxToPt(t.width),
                                "SPCSHeight": pxToPt(t.height),
                                "SPCSContent": t.defaultvalue || "",
                                "SPCSFont": "",
                                "SPCSFontSize": "9",
                                "SPCSBold": "Normal",
                                "SPCSBarCodeType": t.barcodetype,
                                "SPCSDataBindItem": t.binditem,
                                "ID": t.SPCSID || "",
                                "SPCSBarCodeShowText": t.isshowtext || "N",
                                "SPCSAngle": t.angle || 0,
                            };
                            0 < t.angle && (d["-angle"] = t.angle), "N" == t.isshowtext && (d["-isshowtext"] = t.isshowtext), e.push(d)
                        } return e
	            },
                delItem: function h(t) {
                    s.data[t].delFlag = !0, i("#" + xmldesigner.barcode.type + t).remove(), SPCSID = s.data[t].SPCSID, delSheetPrtContentSet(SPCSID)
                },
                getItemOffset: function f(t) {
                    var e = t.attr("data-ind");
                    return {
                        x: s.data[e].x,
                        y: s.data[e].y,
                        w: t.width(),
                        h: t.height()
                    }
                },
                alignItem: function g(t, e, a, d) {
                    var o = s.data[t],
                        n = s.type,
                        r = i("#" + n + t).height(),
                        l = i("#" + n + t).width();
                    switch (e) {
                        case "x":
                            o.x = a;
                            break;
                        case "y":
                            o.y = a;
                            break;
                        case "b":
                            o.y = a - r;
                            break;
                        case "r":
                            o.x = a - l;
                            break;
                        case "ha":
                            o.y = a - r / 2;
                            break;
                        case "va":
                            o.x = a - l / 2
                    }
                    s.method.drawByInd(t)
                },
                move: function y(t, e, a) {
                    var d = s.data[e];
                    d && ("left" == t ? d.x = d.x - a : "right" == t ? d.x = d.x + a : "top" == t ? d.y = d.y - a :
                        "bottom" == t && (d.y = d.y + a)), 
                        s.data[e].x=pxToPt(d.x),
	                    s.data[e].y=pxToPt(d.y),
	                    s.data[e].width=isNaN(pxToPt(d.width)) ? "" : pxToPt(d.width),
	                    s.data[e].height=isNaN(pxToPt(d.height)) ? "" : pxToPt(d.height),
                        s.method.drawByInd(e)
                }
            }
}(jQuery);