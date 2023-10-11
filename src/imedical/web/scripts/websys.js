var websys_unicode_trans = {
    sessionTimeOutReLogon: "\u4f1a\u8bdd\u5df2\u8d85\u671f\uff0c\u8bf7\u9000\u51fa\u91cd\u65b0\u767b\u5f55\u3002",
    pageNotOperateReLogon: "\u754c\u9762\u957f\u65f6\u95f4\u672a\u64cd\u4f5c\uff0c\u8bf7\u9000\u51fa\u91cd\u65b0\u767b\u5f55",
    command: "\u547d\u4ee4",
    disableByUser: "\u5df2\u7ecf\u88ab\u7528\u6237\u7981\u6b62\uff01",
    yes: "\u662f",
    notConnectInternet: "\u6ca1\u6709\u8fde\u63a5\u5230Internet",
    dialog: "\u5bf9\u8bdd\u6846",
    notContent: "\u65e0\u5185\u5bb9",
    selectImportFile: "\u8bf7\u9009\u62e9\u9700\u8981\u5bfc\u5165\u7684\u6587\u4ef6",
    waitingSign: "\u7b49\u5f85\u7b7e\u540d",
    certAuth: "\u8bc1\u4e66\u8ba4\u8bc1"
};

toUnicode = function(e) {
    return escape(e).replace(/%u/gi, "\\u");
};

var isIECore = "";

isIECore = !!(window.ActiveXObject || "ActiveXObject" in window);

var websys_isIE = !1, msg = new Array(), ieVersion = 6;

if ("Microsoft Internet Explorer" == window.navigator.appName) {
    var userAgent = window.navigator.userAgent, userAgentArr = userAgent.split(";"), msieArr = userAgentArr[1].split("MSIE ");
    1 < msieArr.length && (ieVersion = parseFloat(msieArr[1])), websys_isIE = !0;
}

(window.ActiveXObject || "ActiveXObject" in window) && (websys_isIE = !0);

var websys_topz = 201, websys_url = "", websys_webedit, websys_isInUpdate = !1, websys_brokerTime = 200;

function cspRunServerMethod(e) {
    return "" == e ? null : null == cspFindXMLHttp(!1) ? (err = "Unable to locate XMLHttpObject.", 
    "function" == typeof cspRunServerMethodError ? cspRunServerMethodError(err) : (alert(err), 
    null)) : cspIntHttpServerMethod(e, cspRunServerMethod.arguments, !1);
}

function cspRunServerMethodById(e) {
    if ("" == e) return nul;
    var t = document.getElementById(e);
    return t ? cspRunServerMethod(t.value) : void 0;
}

function cspRunServerMethodError(e, t) {
    if (-1 < e.indexOf("You are logged out") && (e = websys_unicode_trans.sessionTimeOutReLogon + "\n" + e), 
    1 < arguments.length) return -1 < t.serverText.indexOf("#864:") ? void (confirm("864:" + websys_unicode_trans.pageNotOperateReLogon + "?") && window.location.reload()) : 5919 == t.serverCode ? void (confirm("5919:" + websys_unicode_trans.pageNotOperateReLogon + "?") && window.location.reload()) : void alert(e + " : " + t.serverText);
    confirm(e + " refresh?") && (window.location.href = window.location.href);
}

function websys_putontop() {
    return websys_topz += 1;
}

function websys_lu(e, t, n) {
    if (t) "" == n && (n = "top=100,left=680,width=300,height=380"), websys_createWindow(e, 1 == t ? 0 : t, n + ",titlebar=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes"); else {
        "" == n && (n = "width=300,height=380"), 0 < e.indexOf(".DOC") && (n = "top=0,left=0,width=" + screen.availWidth + ",height=" + screen.availHeight);
        var s = new Date();
        websys_createWindow(e, "a" + s.getHours() + s.getMinutes() + s.getSeconds() + s.getMilliseconds(), n + ",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
    }
    return !1;
}

function websys_locked() {
    for (var e = 0, t = 0; t < document.forms.length; t++) if (document.forms[t].elements.TLOCKED && "1" == document.forms[t].elements.TLOCKED.value) {
        e = 1;
        break;
    }
    return e;
}

function websys_help(e, t) {
    if (void 0 !== t) websys_getKey(t); else websys_getKey();
}

function websys_printme() {
    "complete" != document.readyState ? self.setTimeout(websys_printme, 1e3) : (self.focus(), 
    self.print());
}

function websys_cancelUpArrow(e) {
    var t;
    try {
        t = websys_getKey(e);
    } catch (e) {
        t = websys_getKey();
    }
    try {
        if (e.shiftKey && 54 == t) return e.preventDefault ? e.preventDefault() : e.returnValue = !1, 
        websys_cancel(), !1;
    } catch (e) {}
    return !0;
}

function websys_cancelBackspace(e) {
    var t;
    try {
        t = websys_getKey(e);
    } catch (e) {
        t = websys_getKey();
    }
    String.fromCharCode(t);
    try {
        if (websys_getAlt(e) && 37 == t) return websys_cancel(), !1;
        if (8 == t) {
            var n = websys_getSrcElement(e);
            if ("on" == document.designMode) return !0;
            if ("true" == n.getAttribute("contenteditable")) return !0;
            var s = n.tagName.toUpperCase(), r = "";
            if ("INPUT" == s && (r = n.type.toUpperCase()), "INPUT" == s && "CHECKBOX" == r) return websys_cancel(), 
            !1;
            if ("INPUT" == s && "RADIO" == r) return websys_cancel(), !1;
            if ("INPUT" == s && n.readOnly) return websys_cancel(), !1;
            if ("INPUT" !== s && "TEXTAREA" !== s) return websys_cancel(), !1;
        }
    } catch (e) {}
    return !0;
}

function websys_sckey(e) {
    var t;
    try {
        t = websys_getKey(e);
    } catch (e) {
        t = websys_getKey();
    }
    var n = String.fromCharCode(t);
    if (!websys_cancelBackspace(e)) return !1;
    if (!websys_cancelUpArrow(e)) return !1;
    if ((n = (n = String.fromCharCode(t)).toUpperCase(), 111 < t && t < 123) && (n = "F" + (t - 111), 
    (r = websys_getMenuWin() || window).websys_sckeys[n])) return r.websys_sckeys[n](), 
    websys_cancel();
    if (websys_getAlt(e) && 18 != t || 33 == t || 34 == t) try {
        var s = websys_getSrcElement(e);
        if (s.onchange) for (i in s.onchange(), tsc) if (tsc[i] == n) {
            window.setTimeout("websys_setfocus('" + i + "');", websys_brokerTime + 1);
            break;
        }
        websys_sckeys[n](), websys_cancel();
    } catch (e) {
        try {
            var r;
            (r = websys_getMenuWin() || window).websys_sckeys[n] && r.websys_sckeys[n]();
        } catch (e) {}
    }
}

function websys_sckeypress(e) {
    if (window.event) {
        var t;
        try {
            t = websys_getKey(e);
        } catch (e) {
            t = websys_getKey();
        }
        if ("^" == String.fromCharCode(t)) return window.event.cancelBubble, !1;
    }
}

var websys_sckeys = new Array();

function websys_dev() {
    try {
        websys_webedit = null, websys_webedit = new self.ActiveXObject("trakWebedit3.trakweb");
        var e = session["LOGON.USERID"] + "^" + session["LOGON.CTLOCID"];
        websys_webedit.ShowManager(e), websys_webedit = null;
    } catch (e) {
        alert(unescape(t.XLAYOUTERR));
    }
}

function websys_layout(t, n, s) {
    var r = session["LOGON.USERID"] + "^" + session["LOGON.CTLOCID"] + "^^" + session["LOGON.GROUPID"];
    "" == s && (s = session.CONTEXT);
    try {
        websys_webedit = null, (websys_webedit = new ActiveXObject("trakWebedit3.trakweb")).ShowLayout(r, t, s, n), 
        websys_webedit = null;
    } catch (e) {
        trakWebEdit3.ShowLayout(r, t, s, n);
    }
}

function websys_getMainWindow(e) {
    return e ? e.websys_getTop().frames.length && e.websys_getTop().frames.TRAK_main ? e.websys_getTop() : websys_getMainWindow(e.opener) : null;
}

function websys_component(e, t) {
    var n = document.getElementById(t);
    return n && ("none" == n.style.display ? (n.style.display = "", e.src = "../images/websys/minus.gif") : (n.style.display = "none", 
    e.src = "../images/websys/plus.gif")), websys_cancel();
}

function websys_getSrcElement(e) {
    return window.event ? window.event.srcElement : e.target;
}

function websys_getParentElement(e) {
    return e.parentElement ? e.parentElement : e.parentNode;
}

function websys_getChildElements(e) {
    return document.all ? e.all : e.getElementsByTagName("*");
}

function websys_getType(e) {
    return window.event ? window.event.type : e.type;
}

function websys_getKey(e) {
    return e && e.isLookup ? 117 : window.event ? window.event.keyCode : e.which;
}

function websys_getButton(e) {
    return void 0 !== e && void 0 !== e.button ? 0 == e.button ? "L" : 1 == e.button ? "M" : 2 == e.button ? "R" : e.button : window.event ? 1 == window.event.button ? "L" : 4 == window.event.button ? "M" : 2 == window.event.button ? "R" : window.event.button : 1 == e.which ? "L" : 2 == e.which ? "M" : 0 == e.which ? "R" : e.which;
}

function websys_getAlt(e) {
    return window.event ? window.event.altKey : e.altKey;
}

function websys_getOffsets(e) {
    if (window.event) return {
        offsetX: event.offsetX,
        offsetY: event.offsetY
    };
    var t = e.target;
    void 0 === t.offsetLeft && (t = t.parentNode);
    var n = websys_getPageCoords(t);
    return {
        offsetX: window.pageXOffset + e.clientX - n.x,
        offsetY: window.pageYOffset + e.clientY - n.y
    };
}

function websys_getPageCoords(e) {
    for (var t = {
        x: 0,
        y: 0
    }; e; ) t.x += e.offsetLeft, t.y += e.offsetTop, e = e.offsetParent;
    return t;
}

function websys_cancel(e) {
    return (e = e || window.event) && (e.preventDefault ? e.preventDefault() : e.returnValue = !1, 
    e.cancelBubble = !0), !1;
}

function websys_returnEvent() {
    return !1;
}

function websys_show(e) {
    var t = document.getElementById("tbMenu" + e), n = document.getElementById("tbMenuItem" + e);
    return t.className = "tbMenuHighlight", n && (n.className = "tbMenuItem", n.style.left = n.parentNode.parentNode.offsetLeft), 
    websys_cancel();
}

function websys_hide(e) {
    var t = document.getElementById("tbMenu" + e), n = document.getElementById("tbMenuItem" + e);
    return t.className = "tbMenu", n && (n.className = "tbMenuItemHide"), websys_cancel();
}

function websys_setTitleBar(e) {
    "" == e && (e = "TrakHealth MedTrak"), websys_getTop().document.title = e;
}

function websys_isDirty(e) {
    for (var t = e.elements.length, n = 0; n < t; n++) {
        var s = e.elements[n];
        if ("text" == s.type || "TEXTAREA" == s.tagName) {
            if ("UserCode" != s.name && s.value != s.defaultValue) return !0;
        } else if ("checkbox" == s.type || "radio" == s.type) {
            if (s.checked != s.defaultChecked) return !0;
        } else if ("SELECT" == s.tagName) for (var r = s.options, o = r.length, i = 0; i < o; i++) {
            var a = r[i];
            if (a.selected != a.defaultSelected) return !0;
        }
    }
    return !1;
}

function websys_isDirtyPage(e) {
    for (var t = document.forms.length, n = 0; n < t; n++) if (websys_isDirty(document.forms[n])) return !0;
    return !1;
}

function websys_isDirtyPagePrompt() {
    !websys_isInUpdate && websys_isDirtyPage() && (window.event.returnValue = t.XUNSAVED);
}

function websys_canfocus(e) {
    return "INPUT" != e.tagName && "A" != e.tagName && "TEXTAREA" != e.tagName && "SELECT" != e.tagName || "hidden" == e.type || e.disabled || e.readOnly ? 0 : 1;
}

function websys_firstfocus() {
    for (var e = 0, t = 0; e < document.forms.length && !t; e++) for (var n = websys_getChildElements(document.forms[e]), s = 0; s < n.length; s++) if (websys_canfocus(n[s])) {
        websys_setfocus(n[s].id), t = 1;
        break;
    }
}

function websys_nextfocus(e) {
    for (var t = e + 1; t < document.all.length; t++) if (websys_canfocus(document.all(t))) {
        websys_setfocus(document.all(t).id);
        break;
    }
}

function websys_nextfocusElement(e) {
    if (e.sourceIndex) websys_nextfocus(e.sourceIndex); else for (;e = websys_FindNextSourceElement(e, 1); ) if (websys_canfocus(e)) {
        websys_setfocus(e.id);
        break;
    }
}

function websys_FindNextSourceElement(e, t) {
    return e == document.body ? null : t && e.childNodes.length ? 1 == e.childNodes[0].nodeType ? e.childNodes[0] : websys_FindNextSourceElement(e.childNodes[0], 0) : e.nextSibling ? 1 == e.nextSibling.nodeType ? e.nextSibling : websys_FindNextSourceElement(e.nextSibling, 0) : e.parentNode.nextSibling ? 1 == e.parentNode.nextSibling.nodeType ? e.parentNode.nextSibling : websys_FindNextSourceElement(e.parentNode.nextSibling, 0) : websys_FindNextSourceElement(e.parentNode, 0);
}

function websys_nexttab(e, t) {
    var n = "", s = 9999;
    if (e = parseInt(e, 10), t) var r = websys_getChildElements(t); else r = document.all;
    for (var o = 0; o < r.length && !(websys_canfocus(r[o]) && r[o].tabIndex > e && r[o].tabIndex < s && (s = r[o].tabIndex, 
    n = r[o].name, s == 1 + e)); o++) ;
    "" != n && websys_setfocus(n);
}

function websys_firsterrorfocus() {
    for (var e = "", t = 9999, n = websys_getChildElements(document), s = 0; s < n.length; s++) "clsInvalid" == n[s].className && websys_canfocus(n[s]) && -1 < n[s].tabIndex && n[s].tabIndex < t && (t = n[s].tabIndex, 
    e = n[s].name);
    "" != e && websys_setfocus(e);
}

function websys_setfocus(e) {
    setTimeout("websys_setfocus2('" + e + "')", 50);
}

function websys_setfocus2(e) {
    var t = document.getElementById(e);
    if (t) try {
        t.focus(), t.select();
    } catch (e) {}
}

function websys_escape(e) {
    for (-1 < e.indexOf("%") && (e = e.split("%").join("%25")); -1 < e.indexOf("?"); ) e = e.replace("?", "%3F");
    for (;-1 < e.indexOf("="); ) e = e.replace("=", "%3D");
    for (;-1 < e.indexOf(" "); ) e = e.replace(" ", "%20");
    for (;-1 < e.indexOf('"'); ) e = e.replace('"', "%22");
    for (;-1 < e.indexOf("&"); ) e = e.replace("&", "%26");
    for (;-1 < e.indexOf("#"); ) e = e.replace("#", "%23");
    for (;-1 < e.indexOf(String.fromCharCode(13, 10)); ) e = e.replace(String.fromCharCode(13, 10), "%0D%0A");
    for (-1 < e.indexOf("+") && (e = e.split("+").join("%2B")); -1 < e.indexOf(String.fromCharCode(1)); ) e = e.replace(String.fromCharCode(1), "%01");
    for (;-1 < e.indexOf(String.fromCharCode(2)); ) e = e.replace(String.fromCharCode(2), "%02");
    return e;
}

function websys_reSize() {
    for (var h = 0, w = 0, f = websys_getChildElements(this.document.body), i = 0; i < f.length; i++) "DIV" == f[i].tagName && (f[i].offsetHeight > h && (h = f[i].offsetHeight), 
    f[i].offsetWidth > w && (w = f[i].offsetWidth));
    h > eval(window.screen.Height - window.screenTop) && (h = eval(window.screen.Height - window.screenTop) - 40), 
    w > eval(window.screen.Width - window.screenLeft) && (w = eval(window.screen.Width - window.screenLeft) - 40), 
    this.resizeTo(w + 30, h + 45), window.focus();
}

function websys_reSizeT(e) {
    for (var w = 0, h = 0, f = websys_getChildElements(this.document.body), i = 0; i < f.length; i++) "TABLE" == f[i].tagName && f[i].offsetWidth > w && (w = f[i].offsetWidth);
    w > eval(window.screen.Width - window.screenLeft) && (w = eval(window.screen.Width - window.screenLeft) - 40), 
    w < 282 && (w = 282), h > eval(window.screen.Height - window.screenTop) && (h = eval(window.screen.Height - window.screenTop) - 40), 
    h = document.body.offsetHeight, h < 380 && (h = 380), this.resizeTo(w + 30, h), 
    this.resizeBy(0, 27);
}

function websys_move(e, t, n, s) {
    if (!(window.websys_getTop().frames.eprmenu || window.websys_getTop().frames.TRAK_menu || window.websys_getTop().frames.TRAK_main)) {
        var r = null;
        e < 0 && (e = 0), t < 0 && (t = 0), n < 200 && (n = 200), s < 200 && (s = 200), 
        (r = window.opener ? window : window.websys_getTop()).moveTo(e, t), r.resizeTo(n, s);
    }
}

function websys_getPositionX(e) {
    return window.event ? window.event.x : e.clientX;
}

function websys_getPositionY(e) {
    return window.event ? window.event.y : e.clientY;
}

1 == websys_isIE ? (document.onkeydown = websys_sckey, document.onkeypress = websys_sckeypress) : document.addEventListener("keydown", websys_sckey);

var websys_windows = new Array();

function websys_createWindow(e, t, n) {
    e = websys_writeMWToken(e);
    var s = n;
    void 0 !== n && (-1 == (n = n.toUpperCase()).indexOf("STATUS=") && (n = "status," + n, 
    s = "status," + s), -1 == n.indexOf("SCROLLBARS=") && (n = "scrollbars," + n, s = "scrollbars," + s), 
    -1 == n.indexOf("RESIZABLE=") && (n = "resizable," + n, s = "resizable," + s));
    var r = window;
    6 < ieVersion && "object" == typeof window.dialogArguments && window.dialogArguments && window.dialogArguments.hasOwnProperty("window") && ((r = window.dialogArguments.window).dialogWindow = window), 
    s = s || "", n = (n = n || "").toLowerCase();
    for (var o = {}, i = s.split(","), a = 0; a < i.length; a++) {
        var c = i[a];
        if ("" != c) {
            var l = c.split("=");
            1 == l.length ? o[l[0]] = "yes" : "true" == l[1].toLowerCase() || "false" == l[1].toLowerCase() ? o[l[0]] = "true" == l[1].toLowerCase() : o[l[0]] = l[1] || "";
        }
    }
    if (-1 < n.indexOf("hisui=true") && void 0 !== websys_showModal) o.iconcls ? o.iconCls = o.iconcls : o.iconCls = "icon-w-paper", 
    websys_showModal && websys_showModal($.extend(o, {
        url: e
    })); else if (-1 < n.indexOf("addtab=1") && void 0 !== websys_addTab) websys_addTab && websys_addTab($.extend(o, {
        url: e
    })); else {
        if (o = calcPosition(o, window, "open"), -1 < navigator.userAgent.indexOf("Chrome/")) {
            var d = navigator.userAgent.match(/Chrome\/(\d+)/i);
            1 < d.length && 49 == d[1] && (o.top -= 68);
        }
        for (var u in n = "", o) "" == n ? n = u + "=" + o[u] : n += "," + u + "=" + o[u];
        if ("undefined" != typeof cefbound && parseInt(e.toLowerCase().lastIndexOf(".pdf")) + 4 == e.length && (e = 0 == e.indexOf("http") ? "../scripts_lib/pdfjs-2.0.943/web/viewer.html?file=" + encodeURIComponent(e) : "../scripts_lib/pdfjs-2.0.943/web/viewer.html?file=../../" + encodeURIComponent(e)), 
        "_blank" == t && -1 < e.indexOf("TMENU=") && (t = "TMENUWIN" + e.split("TMENU=")[1].split("&")[0]), 
        1 == o.singlescreendisable) {
            if (window.DisableSecondScreen) return null;
            if ("undefined" == typeof MWScreens) return null;
            if (void 0 === MWScreens.screens) return null;
            if (1 < o.screenindex && MWScreens.screens.length <= o.screenindex) return null;
            o.screenindex;
        }
        if (0 < o.screenindex) if (1 < MWScreens.screens.length) if (MWScreens.screens.length > o.screenindex) {
            var f = "ScreenF11";
            "undefined" != typeof cefbound && (f = "ScreenMax");
            var w = MWScreens.screens[o.screenindex].Bounds.X;
            websys_windows[t] = r.open(e, t, n + ",left=" + w + "1");
            var p = 3 == o.screenindex ? "\u4e09" : 2 == o.screenindex ? "\u4e8c" : "\u4e00";
            setTimeout(function() {
                CMgr.moveWindow("\u7b2c" + p + "\u526f\u5c4f", w + 1, 0, MWScreens.screens[o.screenindex].WorkingArea.Width, MWScreens.screens[o.screenindex].WorkingArea.Height, f), 
                websys_popover("\u6269\u5c55\u4fe1\u606f\u5df2\u663e\u793a\u5230\u7b2c" + p + "\u526f\u5c4f");
            }, 500);
        } else websys_windows[t] = r.open(e, t, n); else websys_windows[t] = r.open(rewriteUrl(e, {
            SoftSplitScreen: 1
        }), "TRAK_east", n); else websys_windows[t] = r.open(e, t, n);
    }
    return websys_windows[t];
}

function websys_closeWindows() {
    for (w in websys_windows) try {
        websys_windows[w].closed || (websys_windows[w].isclosing = 1, websys_windows[w].close());
    } catch (e) {}
}

function websys_onunload() {
    websys_closeWindows();
}

function websys_print(printoptions, url, params, target, javascript) {
    var tablename = "";
    try {
        var eSrc = websys_getSrcElement();
        if (eSrc) var tbl = getTableName(eSrc);
        tbl && (tablename = tbl.id);
    } catch (e) {}
    if (1 == printoptions) {
        var CONTEXT = "", objCONTEXT = document.getElementById("CONTEXT");
        objCONTEXT && (CONTEXT = objCONTEXT.value), url = escape(url);
        var turl = "websys.default.csp?WEBSYS.TCOMPONENT=websys.PrintOptions.Edit&printoptions=" + printoptions + "&url=" + url + "&params=" + params + "&CONTEXT=" + CONTEXT;
        turl += "&target=" + target + "&javascript=" + javascript + "&tablename=" + tablename, 
        websys_createWindow(turl, 1, "width=260,height=180,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
    } else {
        var jobdone = 0;
        if ("" != javascript) {
            javascript = "" != tablename ? javascript + "('" + tablename + "','" + url + "','" + target + "')" : javascript + "('" + url + "','" + target + "')";
            try {
                jobdone = 1, eval(javascript);
            } catch (e) {}
            0 == jobdone && window.opener && (javascript = "window.opener." + javascript, eval(javascript));
        } else websys_createWindow(url, target);
    }
}

function websys_$(e) {
    if (1 < arguments.length) {
        for (var t = 0, n = [], s = arguments.length; t < s; t++) n.push($(arguments[t]));
        return n;
    }
    if ("string" == typeof e) return document.getElementById(e);
}

function websys_$V(e) {
    return websys_$(e).value;
}

function $V(e) {
    return websys_$(e).value;
}

function addHand(e, t, n) {
    if (e.addEventListener) -1 != t.indexOf("on") && (t = t.substr(2)), e.addEventListener(t, n, !1); else if (e.attachEvent) e.attachEvent(t, n); else {
        var s = e[t];
        e[t] = function() {
            var e = s.apply(this, arguments), t = n.apply(this, arguments);
            return null == e ? t : null == t ? e : t && e;
        };
    }
}

window.onunload = websys_onunload;

var resizeListContainer = function() {
    var e = document.getElementsByClassName("i-tbListContainer");
    e && e.length && 0 < e.length && (e[0].style.height = 500, e[0].style.width = 1e3);
}, quickK = {
    f7: function() {
        window.location.href = window.location.href;
    },
    f8: "",
    f9: "",
    addMethod: function() {
        "function" == typeof this.f7 && addHand(document.body, "onkeydown", function() {
            118 == event.keyCode && quickK.f7();
        }), "function" == typeof this.f8 && addHand(document.body, "onkeydown", function() {
            119 == event.keyCode && quickK.f8();
        }), "function" == typeof this.f9 && addHand(document.body, "onkeydown", function() {
            120 == event.keyCode && quickK.f9();
        });
    }
};

function dhcsys_getsidemenuform() {
    var e = null;
    try {
        var t = window;
        if (t && (e = t.document.forms.fEPRMENU)) return t;
        if ((t = websys_getTop().frames.TRAK_menu) && (e = t.document.forms.fEPRMENU)) return e;
        if ((t = opener) && (e = t.document.forms.fEPRMENU)) return e;
        if ((t = parent.frames[0]) && (e = t.document.forms.fEPRMENU)) return e;
        if (websys_getTop() && (e = websys_getTop().document.forms.fEPRMENU)) return e;
    } catch (e) {}
    return e;
}

function websys_getMenuWin() {
    var e = null;
    try {
        if ((e = window) && (frm = e.document.forms.fEPRMENU, frm)) return e;
        if ((e = websys_getTop().frames.eprmenu) && (frm = e.document.forms.fEPRMENU, frm)) return e;
        try {
            if ((e = parent.frames[0]) && (frm = e.document.forms.fEPRMENU, frm)) return e;
        } catch (e) {}
        if (websys_getTop() && (frm = websys_getTop().document.forms.fEPRMENU, frm)) return websys_getTop();
        if ((e = opener) && (frm = e.document.forms.fEPRMENU, frm)) return e;
        if ((e = websys_getTop().opener) && (frm = e.document.forms.fEPRMENU, frm)) return e;
        if ((e = websys_getTop().opener) && (frm = e.websys_getTop().document.forms.fEPRMENU, 
        frm)) return e.websys_getTop();
        if ((e = (e = websys_getTop().opener) && websys_getTop().opener.websys_getTop().opener) && (frm = e.websys_getTop().document.forms.fEPRMENU, 
        frm)) return e.websys_getTop();
        if ((e = dialogArguments) && (frm = e.websys_getTop().document.forms.fEPRMENU, frm)) return e.websys_getTop();
        if ((e = dialogArguments.opener) && (frm = e.websys_getTop().document.forms.fEPRMENU, 
        frm)) return e.websys_getTop();
        if ((e = dialogArguments.window) && (frm = e.websys_getTop().document.forms.fEPRMENU, 
        frm)) return e.websys_getTop();
        if ((e = dialogArguments.window.opener) && (frm = e.websys_getTop().document.forms.fEPRMENU, 
        frm)) return e.websys_getTop();
    } catch (e) {}
    return null;
}

function getSysPatInParent(e) {
    try {
        for (var t = parent; t; ) {
            if (t && e(t)) return t;
            if (t == t.parent) return null;
            t = t.parent;
        }
    } catch (e) {}
    return null;
}

function dhcsys_hasSysPat(e) {
    return !(!e || "N" !== e.switchSysPat);
}

function dhcsys_getmenuform(e) {
    try {
        var t = null;
        if ("Auto" === (e = e || {
            findType: "Auto"
        }).findType) {
            if (dhcsys_hasSysPat(t = window)) return t.fEPRMENU;
            if (t = getSysPatInParent(dhcsys_hasSysPat)) return t.fEPRMENU;
            if (dhcsys_hasSysPat(t = websys_getTop())) return t.fEPRMENU;
            try {
                if (dhcsys_hasSysPat(t = websys_getTop().opener)) return t.fEPRMENU;
            } catch (e) {}
            try {
                if (dhcsys_hasSysPat(t = websys_getTop().opener.websys_getTop().opener)) return t.fEPRMENU;
            } catch (e) {}
            try {
                if (dhcsys_hasSysPat(t = dialogArguments.opener)) return t.fEPRMENU;
            } catch (e) {}
            try {
                if (dhcsys_hasSysPat(t = dialogArguments.window.opener)) return t.fEPRMENU;
            } catch (e) {}
        }
        var n = websys_getMenuWin();
        return n ? n.document.forms.fEPRMENU : window.fEPRMENU;
    } catch (e) {
        return window.fEPRMENU;
    }
    return null;
}

function dhcsys_alert(e, t, n, s) {
    if (websys_isIE) {
        var r = t || 300, o = n || 120;
        dhcsys_createMask(), window.showModalDialog("../csp/alert.html", {
            msg: e,
            fontSize: s
        }, "dialogWidth:" + parseFloat(r) + "px;dialogHeight:" + parseFloat(o) + "px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;"), 
        dhcsys_closeMask();
    } else alert(e);
}

function dhcsys_confirm(e, t, n, s, r, o) {
    if (window.showModalDialog) {
        1 == arguments.length && (t = "YES"), r = r || 300, o = o || 120, dhcsys_createMask();
        var i = window.showModalDialog("../csp/confirm.html", {
            msg: e,
            YesOrNo: t,
            fontSize: n,
            btnValue: s,
            width: r,
            height: o
        }, "dialogWidth=" + r + "px;dialogHeight=" + o + "px;center=yes;toolbar=no;menubar=no;resizable=no;location=no;status=no;help=no;");
        return dhcsys_closeMask(), i;
    }
    return window.confirm(e);
}

function dhcsys_confirm3(e, t, n, s, r, o) {
    if (window.showModalDialog) {
        1 == arguments.length && (t = "YES"), r = r || 300, o = o || 120, dhcsys_createMask();
        var i = window.showModalDialog("../csp/confirm3.html", {
            msg: e,
            YesOrNo: t,
            fontSize: n,
            btnValue: s,
            width: r,
            height: o
        }, "dialogWidth=" + r + "px;dialogHeight=" + o + "px;center=yes;toolbar=no;menubar=no;resizable=no;location=no;status=no;help=no;");
        return dhcsys_closeMask(), i;
    }
    return window.confirm(e);
}

function websys_EventLog(e, t, n, s) {
    return tkMakeServerCall("web.DHCEventLog", "EventLog", e, t, n, s);
}

function rewriteUrl(e, t) {
    var n, s, r = -1 == (e = e || "").indexOf("?");
    for (var o in r && (e += "?"), t) t.hasOwnProperty(o) && (s = !1, r || (n = new RegExp(o + "=(.*?)(?=$|&)", "g"), 
    e = e.replace(n, function(e) {
        return s = !0, o + "=" + t[o];
    })), s || (e += "&" + o + "=" + t[o]));
    return e;
}

function websys_rewriteUrl(e, t) {
    rewriteUrl(e, t);
}

function websys_getTextContent(e) {
    return websys_isIE ? e.innerText : e.textContent;
}

function removeClass(e, t) {
    if (e.className) {
        for (var n = e.className.split(" "), s = 0; s < n.length; s++) n[s] == t && n.splice(s, 1);
        e.className = n.join(" ");
    }
    return e;
}

function addClass(e, t) {
    if (e && e.className) {
        for (var n = e.className.split(" "), s = 0; s < n.length; s++) if (n[s] == t) return e;
        n.push(t), e.className = n.join(" ");
    } else e.className = t;
    return e;
}

function websys_removeClass(e, t) {
    removeClass(e, t);
}

function websys_addClass(e, t) {
    addClass(e, t);
}

function emptyFun(e) {
    return !1;
}

function websys_disable(e) {
    0 < arguments.length && ("string" == typeof e && (e = document.getElementById(e)), 
    "A" == e.tagName && (e.onclick = emptyFun), e.setAttribute("disabled", "disabled"), 
    addClass(e, "i-disabled"));
}

function websys_enable(e, t) {
    0 < arguments.length && ("string" == typeof e && (e = document.getElementById(e)), 
    e.removeAttribute("disabled"), "A" == e.tagName && 1 < arguments.length && (e.onclick = t), 
    removeClass(e, "i-disabled"));
}

function exec(e) {
    if (websys_isIE) {
        window.oldOnError = window.onerror, window._command = e, window.onerror = function(e) {
            return -1 < e.indexOf("utomation") && (alert(websys_unicode_trans.command + window._command + websys_unicode_trans.disableByUser), 
            !0);
        };
        var t = new ActiveXObject("WScript.Shell");
        t && t.Run(e), window.onerror = window.oldOnError;
    } else CmdShell && (CmdShell.clear(), CmdShell.notReturn = 1, CmdShell.Run(e));
}

function currentUserExec(e) {
    if (websys_isIE) exec(e); else {
        var t = "var wsh=new ActiveXObject('WScript.Shell');if (wsh){wsh.Run('" + e + "');wsh=null;}";
        CmdShell && (CmdShell.clear(), CmdShell.notReturn = 1, CmdShell.CurrentUserEvalJs(t));
    }
}

function websys_exec(e) {
    exec(e);
}

function websys_FileExists(e) {
    var t = !1;
    if (websys_isIE) new ActiveXObject("Scripting.FileSystemObject").FileExists(e) && (t = !0); else if (CmdShell) {
        var n = 'var fso,s=false;\nfso = new ActiveXObject("Scripting.FileSystemObject");\nif (fso.FileExists("' + e + '")){\ns = true;\n}else{\ns=false;\n};\nreturn s;';
        CmdShell.clear(), CmdShell.notReturn = 0;
        var s = CmdShell.EvalJs(n);
        200 == s.status && "true" == s.rtn.toLowerCase() && (t = !0);
    }
    return t;
}

function getOffsetTop(e) {
    for (var t = 0, n = e; null != n && n != document.body; ) t += parseInt(n.offsetTop), 
    n = n.offsetParent;
    return t;
}

function resizeWidth() {
    document.getElementByClass("tblListFlexHeader");
}

function GetServerIP() {
    return tkMakeServerCall("ext.util.String", "ServerIP");
}

function dhcsys_getComputerName() {
    var t;
    if ("" != (t = new RegEdit().regRead("HKEY_CURRENT_USER\\Volatile Environment\\ViewClient_Machine_Name")) && null != t) return t;
    try {
        var e = new ActiveXObject("WScript.Network");
        t = e.ComputerName, e = null;
    } catch (e) {
        t = "";
    }
    return t;
}

function RegEdit() {
    this.shell = new ActiveXObject("WScript.Shell"), this.regRead = regRead, this.regWrite = regWrite, 
    this.regDelete = regDelete;
}

function regRead(e) {
    var t = null;
    try {
        t = this.shell.regRead(e);
    } catch (e) {}
    return t;
}

function regWrite(e, t, n) {
    null == n && (n = "REG_SZ"), this.shell.regWrite(e, t, n);
}

function regDelete(e) {
    this.shell.regDelete(e);
}

function websys_printout(e, t) {
    websys_createWindow("dhctt.xmlprint.csp?xmlName=" + e + "&" + t, "TRAK_hidden", "width=330,height=160,top=1200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

function websys_printview(e, t, n) {
    void 0 === n && (n = "width=630,height=560,top=100,left=100,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes"), 
    websys_createWindow("dhctt.xmlpreview.csp?xmlName=" + e + "&" + t, "preview", n + ",toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

function canAccessIframe(e) {
    try {
        e.name;
    } catch (e) {
        return !1;
    }
    return !0;
}

function dhcsys_getFrameObjByName(e, s) {
    var r = [];
    try {
        if (!canAccessIframe(e)) return null;
        if (void 0 === e.frames) return null;
        !function e(t) {
            if (canAccessIframe(t)) {
                if (t.name == s && r.push(t), 0 < r.length) return r[0];
                for (var n = 0; n < t.frames.length; n++) e(t.frames[n]);
            }
        }(e);
    } catch (e) {}
    return 0 < r.length ? r[0] : null;
}

String.prototype.toDate = function() {
    var e = this.split(/\D/);
    if (1 == e.length && (e[0] = this.substring(0, 4), e[1] = this.substring(4, 6), 
    e[2] = this.substring(6, 8)), 3 != e.length) return "";
    1 == e[1].length && (e[1] = "0" + e[1]), 1 == e[2].length && (e[2] = "0" + e[2]);
    var t = e.join("-");
    if (!t.match(/^\d{4}\-\d\d?\-\d\d?$/)) return "";
    var n = t.replace(/\-0/g, "-").split("-");
    n = new Array(parseInt(n[0]), parseInt(n[1]) - 1, parseInt(n[2]));
    var s = new Date(n[0], n[1], n[2]);
    return s.getFullYear() == n[0] && s.getMonth() == n[1] && s.getDate() == n[2] ? t : "";
};

var websys_SetValByCol = function(e, t) {
    if ("" != t) {
        var n = document.getElementById(t);
        if (n) if ("" != e) {
            var s, r = document.getElementById(e);
            r && ("LABEL" == r.tagName && (s = r.innerText), "INPUT" == r.tagName && (s = r.value), 
            "CHECKBOX" == n.type.toUpperCase() ? "Y" == s || s == websys_unicode_trans.yes ? n.checked = !0 : n.checked = !1 : n.value = s);
        } else "CHECKBOX" == n.type.toUpperCase() ? n.checked = !1 : n.value = "";
    }
}, websys_getVal = function(e) {
    if ("" == e) return "";
    var t = document.getElementById(e);
    if (t) {
        if ("CHECKBOX" == t.type.toUpperCase()) return t.checked ? "Y" : "N";
        if ("LABEL" == t.tagName && (val = t.innerText), "INPUT" == t.tagName && (val = t.value), 
        "SELECT" == t.tagName) {
            var n = t.selectedIndex;
            val = myselect.options[n].value;
        }
        return val;
    }
};

function websys_trim(e) {
    return e.replace(/(^\s*)|(\s*$)/g, "");
}

function websys_trimLeft(e) {
    return e.replace(/(^\s*)/g, "");
}

function websys_trimRight(e) {
    return e.replace(/(\s*$)/g, "");
}

function GetLocalIPAddr() {
    var t = null;
    try {
        if (0 == (t = new ActiveXObject("rcbdyctl.Setting").GetIPAddress).length) return websys_unicode_trans.notConnectInternet;
        null;
    } catch (e) {
        return t;
    }
    return t;
}

function calcPosition(e, t, n) {
    (t = t || websys_getTop()).devicePixelRatio;
    var s = 0, r = 0;
    try {
        s = t.document.documentElement.clientHeight, r = t.document.documentElement.clientWidth;
    } catch (e) {
        t = window;
    }
    if (t == websys_getTop() && (s = (t.outerHeight || t.screen.availHeight) - 122, 
    r = (t.outerWidth || t.screen.availWidth) - 22), -1 < t.location.href.indexOf("CASTypeCode=MWHOSAuth2") && (s = t.document.documentElement.clientHeight, 
    r = t.document.documentElement.clientWidth), "open" == n && (s = window.screen.availHeight, 
    r = window.screen.availWidth), 0 == s && (s = t.document.documentElement.offsetHeight), 
    0 == r && (r = t.document.documentElement.offsetWidth), void 0 === e.width && (e.width = "80%"), 
    void 0 === e.height && (e.height = "80%"), "number" == typeof e.width && e.width < 0 && (e.width = "80%"), 
    "number" == typeof e.height && e.height < 0 && (e.height = "80%"), void 0 === e.top && (e.top = ""), 
    void 0 === e.left && (e.left = ""), "string" == typeof e.top && "" != e.top && (-1 < e.top.indexOf("%") && (e.top = .01 * parseFloat(e.top) * s), 
    e.top = parseInt(e.top)), "string" == typeof e.left && "" != e.left && (-1 < e.left.indexOf("%") && (e.left = .01 * parseFloat(e.left) * r), 
    e.left = parseInt(e.left)), "string" == typeof e.width && (-1 < e.width.indexOf("%") && (e.width = .01 * parseFloat(e.width) * r), 
    e.width = parseInt(e.width)), "string" == typeof e.height && (-1 < e.height.indexOf("%") && (e.height = .01 * parseFloat(e.height) * s), 
    e.height = parseInt(e.height)), "open" == n && -1 < navigator.userAgent.indexOf("Chrome/")) {
        var o = navigator.userAgent.match(/Chrome\/(\d+)/i);
        1 < o.length && (49 == o[1] && (e.height -= 122), 90 < o[1] && 45 < window.outerHeight - window.innerHeight && (e.height -= 78), 
        90 < o[1] && (window.outerHeight, window.innerHeight));
    }
    return "" == e.left && (e.left = (r - e.width) / 2), "" == e.top && (e.top = (s - e.height) / 2), 
    e.left < 0 && (e.left = 0), e.top < 0 && (e.top = 0), e;
}

function websys_base64ToBlob(e) {
    for (var t = e.replace(/[\r\n]/g, "").split(","), n = t[0].match(/:(.*?);/)[1], s = atob(t[1]), r = s.length, o = new Uint8Array(r); r--; ) o[r] = s.charCodeAt(r);
    return new Blob([ o ], {
        type: n
    });
}

function websys_base64ToURL(e) {
    return URL.createObjectURL(websys_base64ToBlob(e));
}

function websys_showModal(e) {
    var t = !0;
    try {
        (websys_getTop() && websys_getTop().frames.eprmenu || websys_getTop() && websys_getTop().frames.TRAK_menu) && (t = !1);
    } catch (e) {
        t = !1;
    }
    if ("string" == typeof e) {
        var n = "", s = window;
        try {
            if (websys_getTop().websys_showModal) s = websys_getTop(); else if (window.$) 0 < (i = s.$('div[data-type="websysmodel"]').length) ? s = window : parent.window.$ && 0 < (i = parent.window.$('div[data-type="websysmodel"]').length) && (s = parent.window);
        } catch (e) {}
        if (t || (s = window), s.$) {
            if (0 == (i = s.$('div[data-type="websysmodel"]').length)) (r = dhcsys_getFrameObjByName(s, "TRAK_main")) && 0 < (i = r.$('div[data-type="websysmodel"]').length) && (s = r);
            n = s.$("#WinModalEasyUI" + (i - 1));
        }
        return n && 0 < n.length ? (e = "hide" == e ? "minimize" : e, n.window.apply(n, arguments)) : void 0;
    }
    var r = websys_getTop();
    if (!websys_getTop().DisableSecondScreen && void 0 !== websys_getTop().eastPanelWidth && 0 < websys_getTop().eastPanelWidth && (e.targetName = e.targetName || "TRAK_main"), 
    void 0 !== e.targetName && "top" != e.targetName && (r = dhcsys_getFrameObjByName(r, e.targetName)), 
    t && r && r != window && r.$ && r.$.fn && r.$.fn.window && r.websys_showModal) r.websys_showModal(e); else {
        var o = "", i = $('div[data-type="websysmodel"]').length;
        if (e.onClose) {
            var a = e.onClose;
            e.onClose = function() {
                a.call(this), $(this).window("destroy");
            };
        } else e.onClose = function() {
            $(this).window("destroy");
        };
        var c = {
            frameId: "modalfrm" + i,
            modal: !0,
            isTopZindex: !0,
            resizable: !0,
            closable: !0,
            width: "80%",
            height: "80%",
            top: "",
            left: "",
            collapsible: !1,
            minimizable: !1,
            maximizable: !1,
            title: websys_unicode_trans.dialog,
            showbefore: null,
            showafter: null,
            content: websys_unicode_trans.notContent
        };
        "string" == typeof (e = $.extend({}, c, e)).url && "" != e.url && (e.url = websys_writeMWToken(e.url)), 
        e.pdfBase64 && (-1 == e.pdfBase64.indexOf("data:application/pdf;base64,") && (e.pdfBase64 = "data:application/pdf;base64," + e.pdfBase64), 
        e.url = "../scripts_lib/pdfjs-2.0.943/web/viewer.html?file=" + encodeURIComponent(websys_base64ToURL(e.pdfBase64))), 
        e.url && ("undefined" != typeof cefbound && parseInt(e.url.toLowerCase().lastIndexOf(".pdf")) + 4 == e.url.length && (0 == e.url.indexOf("http") ? e.url = "../scripts_lib/pdfjs-2.0.943/web/viewer.html?file=" + encodeURIComponent(e.url) : e.url = "../scripts_lib/pdfjs-2.0.943/web/viewer.html?file=../../" + encodeURIComponent(e.url)), 
        e.content = '<iframe id="' + e.frameId + '" src="' + e.url + '" width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>'), 
        $.browser || ($.browser = {}, $.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase()), 
        $.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase()), $.browser.opera = /opera/.test(navigator.userAgent.toLowerCase()), 
        $.browser.msie = /msie/.test(navigator.userAgent.toLowerCase())), e = calcPosition(e, window), 
        "" == o && (o = $('<div id="WinModalEasyUI' + i + '"  style="padding:0px;overflow:hidden;"  data-type="websysmodel"></div>').appendTo("body")), 
        o.window(e).window("open").window("move", {
            top: e.top,
            left: e.left
        });
    }
}

function websys_addTab(e) {
    var t = !0;
    websys_getTop() && websys_getTop().frames.eprmenu && (t = !1), websys_getTop() != window && websys_getTop().websys_addTab && t && websys_getTop().websys_addTab(e);
    var n = window.frames.TRAK_main;
    n && (n && n.addTab ? n.addTab(e) : n.location = "websys.hisui.csp?MutilTabMenu=1");
}

function toUTF8Array(e) {
    for (var t = e.split(""), n = [], s = 0; s < t.length; s++) {
        var r = t[s], o = encodeURI(r);
        if (r == o) n.push(r.charCodeAt(0)); else for (var i = o.split("%"), a = 1; a < i.length; a++) n.push(parseInt(i[a], 16));
    }
    return n;
}

function simpleEncrypt(e, t) {
    t = t || "IMedical";
    for (var n = [], s = toUTF8Array(e), r = s.length, o = r / t.length, i = ""; 0 < o--; ) i += t;
    for (var a = "", c = 0, l = 0; l < r; l++) c = (a = s[l] ^ i.charAt(l).charCodeAt(0)).toString(16).toUpperCase(), 
    a <= 15 && (c = "0" + c), n.push(c);
    return n.join("");
}

function dhcsys_createMask(e) {
    (e = e || {
        fontSize: "16px",
        msg: "load...",
        top: "20%",
        left: "45%",
        opacity: 40,
        isLoad: !0
    }).opacity = e.opacity || 40, e.fontSize = e.fontSize || "16px", e.msg = e.msg || "load...", 
    e.top = e.top || "30%", e.left = e.left || "45%";
    var t = document.createElement("DIV");
    t.id = "_auto_dhcsys_mask", t.style.backgroundColor = "#000000", t.style.opacity = e.opacity / 100, 
    t.style.filter = "alpha(opacity=" + e.opacity + ")", t.style.left = 0, t.style.top = 0, 
    t.style.width = "100%", t.style.height = "100%", t.style.display = "block", t.style.position = "absolute", 
    t.style.zIndex = 1e3, document.body.appendChild(t);
    var n = '<h1 style="top:' + e.top + ";left:" + e.left + ';position:absolute">';
    return e.isLoad && (n += '<image src="../skin/default/images/loading.gif"/>'), n += '<font color="#ffffff" size="' + e.fontSize + '">' + e.msg + '</font></h1><iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;top:0px;left:0px;width:100%;height:100%;"/>', 
    t.innerHTML = n, t;
}

function dhcsys_closeMask() {
    var e = document.getElementById("_auto_dhcsys_mask");
    e && document.body.removeChild(e);
}

function isAccessMP(e, t) {
    return tkMakeServerCall("BSP.Lic.SRV.Interface", "IsAccessByMP", e, t);
}

function getClientIP() {
    if (CmdShell && CmdShell.GetConfig) {
        CmdShell.notReturn = 0;
        var rtnObj = CmdShell.GetConfig();
        "string" == typeof rtnObj && eval("rtnObj = " + rtnObj);
        var rtn = rtnObj.rtn;
        return eval("var obj = " + rtn), unescape(obj.IP) + "^" + unescape(obj.HostName) + "^" + unescape(obj.Mac);
    }
    return "";
}

var parseJsonByPara = function(e, t) {
    for (var n = {}, s = e.split("&"), r = "", o = 0; o < s.length; o++) n[(r = s[o].split("="))[0]] = r[1];
    return 1 < arguments.length ? n[t] : n;
}, websys_ReadExcel = function(excelName, options) {
    var async = options && options.async ? options.async : 0, isText = !(!options || !options.isText) && options.isText, strArr = [];
    strArr.push("Function vbs_Test"), strArr.push('Set xlApp = CreateObject("Excel.Application")'), 
    "" == excelName ? (strArr.push('fName=xlApp.GetSaveAsFilename ("","Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls",,"' + websys_unicode_trans.selectImportFile + '")'), 
    strArr.push("If fName=False Then"), strArr.push("\txlApp.Quit"), strArr.push("\tSet xlApp=Nothing"), 
    strArr.push("\tvbs_Test=0"), strArr.push("\tExit Function"), strArr.push("End If"), 
    strArr.push("Set xlBook = xlApp.Workbooks.Open(fName)")) : strArr.push('Set xlBook = xlApp.Workbooks.Open("' + excelName + '")'), 
    strArr.push("Set xlSheet = xlBook.ActiveSheet"), strArr.push('rtn = "["'), strArr.push("rc=xlSheet.UsedRange.Rows.Count"), 
    strArr.push("cc=xlSheet.UsedRange.Columns.Count"), !1 === isText && strArr.push("arr = xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(rc,cc)).Value2"), 
    strArr.push("For ri = 1 To rc"), strArr.push('\trowstr = "["'), strArr.push("\tFor ci = 1 To cc"), 
    isText ? strArr.push("\t\tcellVal = xlSheet.Cells(ri,ci).Text") : strArr.push("\t\tcellVal = arr(ri,ci)"), 
    strArr.push('  cellVal = Replace(cellVal,Chr(13),"\\u000D")'), strArr.push('  cellVal = Replace(cellVal,Chr(10),"\\u000A")'), 
    strArr.push('\t\tcolstr="""" & Replace(cellVal,"""","\\""") & """"'), strArr.push('   \tIf rowstr <> "[" Then'), 
    strArr.push('       \trowstr = rowstr & ","'), strArr.push("    \tEnd If"), strArr.push("       rowstr = rowstr & colstr"), 
    strArr.push("\tNext"), strArr.push('\trowstr = rowstr & "]"'), strArr.push('\tIf rtn = "[" Then'), 
    strArr.push("   \trtn = rtn & rowstr"), strArr.push("\tElse"), strArr.push('   \trtn = rtn & "," & rowstr'), 
    strArr.push("\tEnd If"), strArr.push("Next"), strArr.push('rtn = rtn & "]"'), strArr.push("xlBook.Close(False)"), 
    strArr.push("xlApp.Quit"), strArr.push("Set xlSheet= Nothing"), strArr.push("Set xlBook= Nothing"), 
    strArr.push("Set xlApp=Nothing"), strArr.push("vbs_Test=rtn"), strArr.push("End Function\n");
    var rtn = "", exec = strArr.join("\n"), o;
    if (isIECore) {
        var IECmdShell = new ActiveXObject("MSScriptControl.ScriptControl");
        IECmdShell.Language = "VBScript", IECmdShell.Timeout = 6e5, IECmdShell.AddCode(exec);
        try {
            rtn = IECmdShell.Run("vbs_Test"), eval("var o=(" + rtn + ")");
        } catch (e) {
            o = [], alert(e.message);
        }
    } else CmdShell.notReturn = async, rtn = CmdShell.EvalJs(exec, "VBScript"), 200 == rtn.status ? eval("var o=(" + rtn.rtn + ")") : (o = [], 
    alert(rtn.msg));
    return o || [];
}, XSS = {
    JsEncode: function(e) {
        var c = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f");
        function t(e) {
            var t = !0, n = e.charAt(0), s = e.charCodeAt(0);
            switch (n) {
              case "\n":
                return "\\n";

              case "\r":
                return "\\r";

              case "'":
                return "\\'";

              case '"':
                return '\\"';

              case "&":
                return "\\&";

              case "\\":
                return "\\\\";

              case "\t":
                return "\\t";

              case "\b":
                return "\\b";

              case "\f":
                return "\\f";

              case "/":
                return "\\x2F";

              case "<":
                return "\\x3C";

              case ">":
                return "\\x3E";

              default:
                t = !1;
            }
            if (!t) {
                if (47 < s && s < 58) return e;
                if (64 < s && s < 91) return e;
                if (96 < s && s < 123) return e;
                if (127 < s) {
                    var r = s, o = r % 16, i = (r = Math.floor(r / 16)) % 16, a = (r = Math.floor(r / 16)) % 16;
                    return r = Math.floor(r / 16), "\\u" + c[r % 16] + c[a] + c[i] + c[o];
                }
                return function(e) {
                    return "\\x" + e.charCodeAt(0).toString(16);
                }(e);
            }
        }
        var n = e, s = "", r = 0;
        for (r = 0; r < n.length; r++) s += t(n.charAt(r));
        return s;
    },
    HtmlEncode: function(e) {
        for (var a = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"), t = e, n = "", s = 0; s < t.length; s++) {
            n += r(t.charAt(s));
        }
        return n;
        function r(e) {
            var t = !0, n = e.charCodeAt(0);
            switch (n) {
              case 10:
                return "<br/>";

              case 32:
                return "&nbsp;";

              case 34:
                return "&quot;";

              case 38:
                return "&amp;";

              case 39:
                return "&#x27;";

              case 47:
                return "&#x2F;";

              case 60:
                return "&lt;";

              case 62:
                return "&gt;";

              case 198:
                return "&AElig;";

              case 193:
                return "&Aacute;";

              case 194:
                return "&Acirc;";

              case 192:
                return "&Agrave;";

              case 197:
                return "&Aring;";

              case 195:
                return "&Atilde;";

              case 196:
                return "&Auml;";

              case 199:
                return "&Ccedil;";

              case 208:
                return "&ETH;";

              case 201:
                return "&Eacute;";

              case 202:
                return "&Ecirc;";

              case 200:
                return "&Egrave;";

              case 203:
                return "&Euml;";

              case 205:
                return "&Iacute;";

              case 206:
                return "&Icirc;";

              case 204:
                return "&Igrave;";

              case 207:
                return "&Iuml;";

              case 209:
                return "&Ntilde;";

              case 211:
                return "&Oacute;";

              case 212:
                return "&Ocirc;";

              case 210:
                return "&Ograve;";

              case 216:
                return "&Oslash;";

              case 213:
                return "&Otilde;";

              case 214:
                return "&Ouml;";

              case 222:
                return "&THORN;";

              case 218:
                return "&Uacute;";

              case 219:
                return "&Ucirc;";

              case 217:
                return "&Ugrave;";

              case 220:
                return "&Uuml;";

              case 221:
                return "&Yacute;";

              case 225:
                return "&aacute;";

              case 226:
                return "&acirc;";

              case 230:
                return "&aelig;";

              case 224:
                return "&agrave;";

              case 229:
                return "&aring;";

              case 227:
                return "&atilde;";

              case 228:
                return "&auml;";

              case 231:
                return "&ccedil;";

              case 233:
                return "&eacute;";

              case 234:
                return "&ecirc;";

              case 232:
                return "&egrave;";

              case 240:
                return "&eth;";

              case 235:
                return "&euml;";

              case 237:
                return "&iacute;";

              case 238:
                return "&icirc;";

              case 236:
                return "&igrave;";

              case 239:
                return "&iuml;";

              case 241:
                return "&ntilde;";

              case 243:
                return "&oacute;";

              case 244:
                return "&ocirc;";

              case 242:
                return "&ograve;";

              case 248:
                return "&oslash;";

              case 245:
                return "&otilde;";

              case 246:
                return "&ouml;";

              case 223:
                return "&szlig;";

              case 254:
                return "&thorn;";

              case 250:
                return "&uacute;";

              case 251:
                return "&ucirc;";

              case 249:
                return "&ugrave;";

              case 252:
                return "&uuml;";

              case 253:
                return "&yacute;";

              case 255:
                return "&yuml;";

              case 162:
                return "&cent;";

              case "\r":
                break;

              default:
                t = !1;
            }
            if (!t) {
                if (127 < n) {
                    var s = n, r = s % 16, o = (s = Math.floor(s / 16)) % 16, i = (s = Math.floor(s / 16)) % 16;
                    return s = Math.floor(s / 16), "&#x" + a[s % 16] + a[i] + a[o] + a[r] + ";";
                }
                return e;
            }
        }
    }
};

function websys_openMenu(e) {
    var t = websys_getMenuWin();
    t && t.clickHeaderMenu && t.clickHeaderMenu({
        code: e
    });
}

var websys_getTop_ResultCache = null;

function websys_getTop() {
    if (websys_getTop_ResultCache) return websys_getTop_ResultCache;
    var t = null, e = location.origin;
    try {
        top._someVariable;
        e === top.location.origin && (t = top);
    } catch (e) {}
    if (null === t) for (var n = window, s = 0; null === t; ) {
        if (s++, n.parent && n.parent !== n) try {
            n.parent._someVariable;
            e === n.parent.location.origin ? n = n.parent : t = n;
        } catch (e) {
            t = n;
        } else t = n;
        if (20 < s) break;
    }
    return null === t && (t = window), websys_getTop_ResultCache = t;
}

function websys_popover(e) {
    websys_getTop().$.messager.popover({
        msg: e,
        type: "info",
        timeout: 2e3,
        showType: "slide"
    });
}

function websys_url2Json(e) {
    if ("string" != typeof e) return e;
    var t = {};
    if (-1 < e.indexOf("=")) {
        -1 < e.indexOf("?") && (e = e.slice(e.indexOf("?") + 1));
        for (var n = e.split("&"), s = 0; s < n.length; s++) {
            var r = n[s].slice(0, n[s].indexOf("=")), o = n[s].slice(n[s].indexOf("=") + 1);
            "" != r && (t[r] = o);
        }
    }
    return t;
}

function dhcsys_calogon(e, t) {
    var n = {};
    if (t = t || "", 1 == tkMakeServerCall("websys.CAInterface", "IsCaLogon", e, t)) {
        var s = "", r = dhcsys_getContainerNameAndPin();
        if (-1 < r.indexOf("^") && (s = r.split("^")[0]), "" == s && (s = (s = window.showModalDialog("../csp/dhc.logon.ca.csp", {
            window: window
        }, "dialogWidth:300px;dialogHeight:250px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;")).split("^")[0]), 
        "" == s || "undefined" == s || null == s) return {
            IsSucc: !1,
            ContainerName: ""
        };
        n = {
            ContainerName: s,
            IsSucc: !0
        };
    } else n = {
        IsSucc: !0,
        ContainerName: ""
    };
    return n;
}

function dhcsys_getContainerNameAndPin() {
    return tkMakeServerCall("websys.CAInterface", "GetContainerNameAndPin");
}

function IsCaLogon(e, t, n, s, r) {
    return tkMakeServerCall("websys.CAInterface", "IsCaLogon", e, t, n, s, r);
}

function dhcsys_showcaLogon(e, t, n, s, r, o) {
    dhcsys_createMask({
        msg: websys_unicode_trans.waitingSign + "..."
    }), void 0 === t && (t = 1), void 0 === e && (e = "UKEY"), void 0 === n && (n = "0"), 
    void 0 === s && (s = "");
    var i = "dhc.logon.ca.csp?locDesc=" + s + "&singleLogon=" + t + "&logonType=" + e + "&autoSure=" + n;
    void 0 !== session["LOGON.HOSPID"] && (i += "&LOGON.HOSPID=" + session["LOGON.HOSPID"]), 
    void 0 !== o && (void 0 !== o.SignUserCode && (i += "&SignUserCode=" + o.SignUserCode), 
    void 0 !== o.signUserType && (i += "&signUserType=" + o.signUserType), void 0 !== o.notLoadCAJs && (i += "&notLoadCAJs=" + o.notLoadCAJs), 
    void 0 !== o.venderCode && (i += "&venderCode=" + o.venderCode)), websys_getMWToken && (i += "&MWToken=" + websys_getMWToken());
    var a = null;
    return !window.showModalDialog || r ? (websys_getTop().websys_showModal({
        title: websys_unicode_trans.certAuth,
        iconCls: "icon-w-key",
        width: 800,
        height: 650,
        closable: !0,
        isTopZindex: !0,
        url: i + "&notModal=1",
        onBeforeClose: function() {
            if (dhcsys_closeMask(), r) {
                var e = {
                    IsSucc: !1,
                    ContainerName: "",
                    IsCA: !0,
                    CALogonType: "",
                    CAUserCertCode: "",
                    CACertNo: "",
                    CAToken: "",
                    UserID: "",
                    UserName: ""
                };
                if (dhcsys_getContainerNameAndPin) {
                    var t = dhcsys_getContainerNameAndPin();
                    if ("" == t || null == t) e = {
                        IsSucc: !1,
                        ContainerName: "",
                        IsCA: !0,
                        CALogonType: "",
                        CAUserCertCode: "",
                        CACertNo: "",
                        CAToken: "",
                        UserID: "",
                        UserName: ""
                    }; else {
                        var n = t.split("^");
                        e = {
                            IsSucc: !1,
                            ContainerName: "",
                            IsCA: !0,
                            CALogonType: "",
                            CAUserCertCode: "",
                            CACertNo: "",
                            CAToken: "",
                            UserID: "",
                            UserName: ""
                        }, "" !== n[0] && (e.IsSucc = !0, e.ContainerName = n[0] || "", e.CALogonType = n[2] || "", 
                        e.CAUserCertCode = n[3] || "", e.CACertNo = n[4] || "", e.CAToken = n[5] || "", 
                        e.UserID = n[6] || "", e.UserName = n[7] || "", e.IsCAReLogon = !0);
                        try {
                            if (e.IsSucc && e.ContainerName) {
                                var s = ("undefined" == typeof websys_getMenuWin_origin ? websys_getMenuWin : websys_getMenuWin_origin)() || window;
                                e.ca_key = s.ca_key || "", e.varCert = s.GetSignCert(e.ContainerName);
                            }
                        } catch (e) {
                            "undefined" != typeof console && console.log(e);
                        }
                    }
                }
                r(e);
            }
        },
        dataRow: {}
    }), "") : (a = window.showModalDialog(i, {
        window: window
    }, "dialogWidth:800px;dialogHeight:650px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;"), 
    dhcsys_closeMask(), a);
}

function dhcsys_calogonshow(e, t, n, s, r, o) {
    var i = {}, a = "", c = "", l = "";
    if ("object" == typeof o && (void 0 !== o.groupDesc && (c = o.groupDesc), void 0 !== o.hospDesc && (l = o.hospDesc)), 
    1 == IsCaLogon(e, t, c, "", l)) {
        if (void 0 === s && (s = 1), void 0 === (i = dhcsys_showcaLogon(n = n || "UKEY", s, 0, e, r, o))) return {
            IsSucc: !1,
            IsCA: !0,
            ContainerName: ""
        };
        if ("string" == typeof i) i = {
            IsCA: !0,
            ContainerName: a = i.split("^")[0],
            varCert: ""
        }; else "object" == typeof i && (a = i.ContainerName);
        if ("" == a || "undefined" == a || null == a) return {
            IsSucc: !1,
            IsCA: !0,
            ContainerName: ""
        };
        i.IsSucc = !0;
    } else i = {
        IsSucc: !0,
        IsCA: !1,
        ContainerName: "",
        varCert: ""
    };
    return i;
}

function isValidCA(e, t, n, s) {
    if (-1 < "BJCA^HeBCA^AHCA^FAKE^GDCA".indexOf(s)) {
        var r = !0;
        try {
            r = e.SOF_IsLogin(t);
        } catch (e) {
            try {
                r = SOF_IsLogin(t);
            } catch (e) {
                return !1;
            }
        }
        return r;
    }
    if (-1 < s.indexOf("SHCA")) {
        var o = "";
        try {
            o = e.GetUserList();
        } catch (e) {
            try {
                o = GetUserList();
            } catch (e) {
                return !1;
            }
        }
        for (var i = o.split("&&&"), a = 0; a < i.length; a++) if (1 < i[a].split("||").length && i[a].split("||")[1] == t) return "undefined" != typeof firstGetUserList && firstGetUserList && (e.Login("", t, n[1], !0), 
        firstGetUserList = !1), !0;
        return !1;
    }
    o = "";
    try {
        o = e.GetUserList();
    } catch (e) {
        try {
            o = GetUserList();
        } catch (e) {
            return !1;
        }
    }
    for (i = o.split("&&&"), a = 0; a < i.length; a++) if (1 < i[a].split("||").length && i[a].split("||")[1] == t) return !0;
    return !1;
}

function dhcsys_getcacert(options, logonType, singleLogon, forceOpen) {
    var win = ("undefined" == typeof websys_getMenuWin_origin ? websys_getMenuWin() : websys_getMenuWin_origin()) || window;
    "undefined" == typeof tkMakeServerCall && (tkMakeServerCall = win.tkMakeServerCall), 
    "undefined" == typeof session && (session = {});
    var modelCfgJson = "", modelCfgJsonObj = {};
    options = options || {};
    var callback = void 0;
    if (window.showModalDialog || (callback = function(e) {
        alert("Tip :  When calling the dhcsys_getcacert({callback:mycallback}) function, please pass in the callback method on the first input parameter"), 
        alert(JSON.stringify(e));
    }), "function" == typeof options && (callback = options), "object" == typeof options && options.callback && (callback = options.callback), 
    void 0 !== options.modelCode && (modelCfgJson = tkMakeServerCall("CF.BSP.CA.DTO.SignModel", "GetCfgJson", options.modelCode, session["LOGON.HOSPID"] || win.session["LOGON.HOSPID"] || ""), 
    "" != modelCfgJson && (eval("modelCfgJsonObj=" + modelCfgJson), modelCfgJsonObj && void 0 !== modelCfgJsonObj.active && 0 == modelCfgJsonObj.active))) return "function" == typeof callback && callback({
        IsSucc: !0,
        varCert: "",
        ContainerName: "",
        IsCA: !1
    }), {
        IsSucc: !0,
        varCert: "",
        ContainerName: "",
        IsCA: !1
    };
    var defaultOpt = {
        isHeaderMenuOpen: !0,
        notLoadCAJs: 0,
        forceOpenSure: 0,
        caInSelfWindow: 0,
        forceOpenUkeySure: 0,
        singleLogon: singleLogon || 1,
        forceOpen: forceOpen || 0,
        signUserType: "",
        SignUserCode: session["LOGON.USERCODE"] || win.session["LOGON.USERCODE"] || "",
        hospDesc: session["LOGON.HOSPDESC"] || win.session["LOGON.HOSPDESC"] || "",
        loc: session["LOGON.CTLOCID"] || win.session["LOGON.CTLOCID"] || "",
        groupDesc: session["LOGON.GROUPDESC"] || win.session["LOGON.GROUPDESC"] || ""
    }, optionsNews = $.extend({}, defaultOpt, modelCfgJsonObj, options), forceOpenUkeySure = optionsNews.forceOpenUkeySure, caInSelfWindow = optionsNews.caInSelfWindow, groupDesc = optionsNews.groupDesc, CTLoc = optionsNews.loc, hospDesc = optionsNews.hospDesc, userName = optionsNews.SignUserCode, isHeaderMenuOpen = optionsNews.isHeaderMenuOpen, notLoadCAJs = optionsNews.notLoadCAJs, forceOpenSure = optionsNews.forceOpenSure, failRtn = {
        IsSucc: !1,
        varCert: "",
        ContainerName: "",
        IsCA: !1
    };
    if ("" === CTLoc || !userName) return failRtn.msg = "Loc/User Is Null ", "function" == typeof callback && callback(failRtn), 
    failRtn;
    var obj = {}, varCert = "", ContainerName = "", arr = [], rtn = {}, flag = IsCaLogon(CTLoc, userName, groupDesc, options.modelCode, hospDesc);
    if (0 == flag) return rtn = {
        IsSucc: !0,
        varCert: "",
        ContainerName: "",
        IsCA: !1,
        msg: "NotMustCA"
    }, "function" == typeof callback && callback(rtn), rtn;
    if (1 == caInSelfWindow && (win = window), isHeaderMenuOpen && win != self && win.dhcsys_getcacert) return win.dhcsys_getcacert(optionsNews, logonType, singleLogon, optionsNews.forceOpen);
    if (void 0 !== logonType && "" != logonType || (logonType = "", "object" == typeof modelCfgJsonObj && modelCfgJsonObj.defLogonType && (logonType = modelCfgJsonObj.defLogonType), 
    win.LastCALogonType ? (logonType = win.LastCALogonType, "UKEY" == logonType && 1 == forceOpenSure && (forceOpenUkeySure = 1), 
    void 0 === singleLogon && (singleLogon = 1)) : void 0 === singleLogon && (singleLogon = 0)), 
    void 0 === singleLogon && (singleLogon = 1), "0" == optionsNews.forceOpen && (ContainerName = dhcsys_getContainerNameAndPin(), 
    -1 < ContainerName.indexOf("^") && (arr = ContainerName.split("^"), ContainerName = arr[0], 
    logonType = arr[2] || "", "" != userName && 7 < arr.length && userName.toLowerCase() != arr[7].toLowerCase() && (ContainerName = ""))), 
    ContainerName) {
        rtn = {
            IsCA: !0,
            IsSucc: !0,
            ContainerName: ContainerName,
            UserName: arr[7] || "",
            UserID: arr[6] || "",
            CALogonType: arr[2] || "",
            CAUserCertCode: arr[3] || "",
            CACertNo: arr[4] || "",
            CAToken: arr[5] || "",
            ca_key: win.ca_key || ""
        };
        var validJsonStr = tkMakeServerCall("websys.CAInterface", "GetCACertIsValidInfo", logonType, CTLoc);
        if ("" != validJsonStr) {
            var jsonObj = {};
            if (eval("jsonObj=" + validJsonStr), "" != jsonObj.VenderCode && (1 == notLoadCAJs ? jsonObj.retCode = 0 : "UKEY" == logonType && (isValidCA(win, ContainerName, arr, jsonObj.VenderCode) ? jsonObj.retCode = 0 : jsonObj.retCode = -1)), 
            win.ca_key || 1 == notLoadCAJs || (jsonObj.retCode = -1), 0 == jsonObj.retCode) {
                try {
                    rtn.varCert = win.GetSignCert(ContainerName);
                } catch (e) {
                    "undefined" != typeof console && console.log(e);
                }
                if (0 == forceOpenUkeySure && "function" == typeof callback && callback(rtn), 0 == forceOpenUkeySure) return rtn;
            }
        }
    }
    if (1 == forceOpenUkeySure && (logonType = "UKEYSURELIST", singleLogon = 1), obj = dhcsys_calogonshow(CTLoc, userName, logonType, singleLogon, callback, options), 
    obj.IsSucc && obj.ContainerName) {
        obj.ca_key = win.ca_key || "";
        try {
            obj.varCert = win.GetSignCert(obj.ContainerName);
        } catch (e) {
            "undefined" != typeof console && console.log(e);
        }
    }
    return obj;
}

function websys_getSessionObj() {
    return websys_getTop().session || window.session || {};
}

function websys_getSessionStr() {
    var e = "", t = websys_getSessionObj();
    if (t && t["LOGON.USERID"]) {
        e = t["LOGON.USERID"], e += "^" + t["LOGON.GROUPID"], e += "^" + t["LOGON.CTLOCID"], 
        e += "^" + t["LOGON.HOSPID"] || "", e += "^" + t["LOGON.WARDID"] || "", e += "^" + t["LOGON.LANGID"], 
        e += "^" + t["LOGON.SSUSERLOGINID"], e += "^";
        var n = function(e) {
            for (var t, n, s = e + "=", r = s.length, o = document.cookie.length, i = 0; i < o; ) {
                var a = i + r;
                if (document.cookie.substring(i, a) == s) return t = a, n = void 0, -1 == (n = document.cookie.indexOf(";", t)) && (n = document.cookie.length), 
                unescape(document.cookie.substring(t, n));
                if (0 == (i = document.cookie.indexOf(" ", i) + 1)) break;
            }
        }("sessionid"), s = "";
        "function" == typeof websys_getMWToken && (s = websys_getMWToken()), "" != s && (n = s), 
        e += "^" + n;
    }
    return e;
}

function GetSessionStr() {
    return websys_getSessionStr();
}

var CHATAPPID = "301678660937588736", CHATAPPServer = "https://ai.imedway.cn", CHATAPPUrl = "/chat-server-mediway2021/socket.io", IMChatClientSocket = void 0, IMChatClientRoom = {};

function websys_CreateChatClient() {
    var t = new ChatClient(CHATAPPServer, {
        source: "web",
        chatType: "chat",
        isAuth: !1,
        debug: !0,
        server: {
            path: CHATAPPUrl
        },
        auth: {
            username: session["LOGON.USERCODE"],
            authType: session["LOGON.SSUSERLOGINID"],
            appId: CHATAPPID,
            userInfo: {
                username: session["LOGON.USERNAME"],
                usercode: session["LOGON.USERCODE"],
                userId: session["LOGON.USERID"],
                userAvatar: "",
                userType: "ec",
                metadata: "code"
            }
        }
    });
    t.on("logout", function(e) {
        $.messager.confirm("\u65ad\u7ebf", "\u591a\u7aef\u4f1a\u8bdd\u65ad\u5f00,\u662f\u5426\u786e\u5b9a\u91cd\u8fde?", function(e) {
            e && (websys_CreateChatClient(), websys_popover("\u91cd\u8fde\u4e2d"));
        });
    }), t.on("connected", function(e) {
        console.log("\u8ba4\u8bc1\u6210\u529f", e), IMChatClientSocket = t;
    }), t.on("unauthorized", function(e) {
        console.log("\u8ba4\u8bc1\u5931\u8d25", e);
    }), t.on("disconnect", function(e) {
        console.log("\u8fde\u63a5\u65ad\u5f00", e);
    }), t.on("reconnect_attempt", function(e) {
        console.log("\u5c1d\u8bd5\u91cd\u8fde" + e + "\u6b21");
    }), t.on("reconnect_attempt", function(e) {
        console.log("\u6b63\u5728\u5c1d\u8bd5\u91cd\u8fde" + e + "\u6b21");
    }), t.on("reconnect", function(e) {
        console.log("\u91cd\u8fde\u6210\u529f", e);
    }), t.on("connect_error", function(e) {
        console.log("\u8fde\u63a5\u5931\u8d25", e);
    }), t.on("error", function(e) {
        console.log("\u53d1\u751f\u5f02\u5e38", e);
    });
}

function websys_leaveChatClient() {
    "object" == typeof IMChatClientSocket && IMChatClientSocket.leaveAll();
}

function websys_leaveChatRoom(e, t) {
    var n = websys_getMenuWin();
    n == window ? "object" == typeof IMChatClientSocket && (IMChatClientSocket.leave({
        appId: CHATAPPID,
        username: session["LOGON.USERNAME"],
        roomid: e + t,
        source: "web",
        messageType: "system",
        content: session["LOGON.USERNAME"] + "\u79bb\u5f00" + e + t,
        extend: {
            bizCode: e,
            opt: {
                bizId: t
            },
            content: "leave",
            type: "cross-device"
        }
    }), delete IMChatClientRoom[e + t]) : n.websys_leaveChatRoom(e, t);
}

function websys_joinRoomByChat(e, t, n) {
    if (n = n || IMChatClientSocket, void 0 !== e) {
        if (t = t || {}, "object" == typeof n) {
            if (void 0 === t.bizId) return void console.log("opt.bizId\u4e0d\u80fd\u4e3a\u7a7a");
            if (void 0 !== IMChatClientRoom[e + t.bizId]) return void console.log("\u52a0\u5165\u8fc7\u623f\u95f4");
            console.log("join room " + e + t.bizId), n.join({
                appId: CHATAPPID,
                username: session["LOGON.USERCODE"],
                roomid: e + t.bizId,
                source: "web",
                messageType: "system",
                content: t.content,
                extend: {
                    bizCode: e,
                    opt: {
                        bizId: t.bizId,
                        content: t.content
                    },
                    type: "cross-device"
                }
            }, function(e) {
                if (e.success) {
                    var t = e.data.extend.bizCode + e.data.extend.opt.bizId;
                    s = t, n.on("chat", function(e) {
                        if ("join" == e.eventType) e && e.extend.opt.content && websys_popover(e.extend.opt.content); else if ("leave" == e.eventType) e.extend && "object" == typeof e.extend.opt && e.extend.opt.content && websys_popover(e.extend.opt.content); else if (e.extend && "object" == typeof e.extend.opt && "websysOpen" == e.extend.opt.action) {
                            var t = e.extend.opt, n = t.url;
                            void 0 !== n && "" != n && (delete t.url, websys_createWindow(n = rewriteUrl(n, t), e.extend.bizCode + t.bizId + "Win", "top=0,left=0,width=100%,height=100%"));
                        }
                        _triggerEvent(s, e);
                    }), IMChatClientRoom[t] = 1;
                } else console.log("join fail," + e.msg, e.data);
                var s;
            });
        }
    } else console.log("code\u4e0d\u80fd\u4e3a\u7a7a");
}

function websys_emitByChat(e, t, n) {
    if (n = n || IMChatClientSocket, void 0 !== e) {
        if (t = t || {}, "object" == typeof n) {
            if (void 0 === t.bizId) return void console.log("opt.bizId\u4e0d\u80fd\u4e3a\u7a7a");
            void 0 === IMChatClientRoom[e + t.bizId] && websys_joinRoomByChat(e, t, n), n.emitChat(5e3, {
                chatType: "room",
                content: t.content || "DefaultMessageContent",
                messageType: "txt",
                fromUser: session["LOGON.USERNAME"],
                toUser: e + t.bizId,
                appId: CHATAPPID,
                extend: {
                    bizCode: e,
                    opt: t,
                    type: "cross-device",
                    emitchat: "5000"
                }
            }, function(e) {
                console.log("chat message success");
            }, function(e) {
                console.log("chat message error");
            });
        }
    } else console.log("code\u4e0d\u80fd\u4e3a\u7a7a");
}

function _triggerEvent(e, t) {
    var n = !1;
    for (var s in t && t.appId == CHATAPPID && (n = !0), n && window && window.MWSecondScreenEvent && "function" == typeof window.MWSecondScreenEvent[e] && window.MWSecondScreenEvent[e].call(window, t), 
    MWSecondScreenWindows) if (0 == s.indexOf("SCR") && MWSecondScreenWindows && MWSecondScreenWindows[s]) {
        var r = MWSecondScreenWindows[s];
        r.MWSecondScreenEvent[e] && r.MWSecondScreenEvent[e].call(r, t);
    }
    websys_getTop() && websys_getTop().opener && websys_getTop().opener.MWSecondScreenEvent[e] && websys_getTop().opener.MWSecondScreenEvent[e].call(websys_getTop().opener, t), 
    MWSecondScreenEvent[e] && MWSecondScreenEvent[e].call(window, t);
}

var MWSecondScreenWindows = {}, MWSecondScreenEvent = [], MWSecondScreenFrmUrl = [ "epr.frames.secondscreen.csp", "epr.frames.thirdscreen.csp" ];

function websys_emit(e, t) {
    if ("" == (e = e || "")) return null;
    t = websys_url2Json(t);
    var n = websys_getAppScreenIndex();
    void 0 === t.eventSourceScreenIndex && (t.eventSourceScreenIndex = n);
    var s = void 0 !== window.websys_getMenuWin_origin ? websys_getMenuWin_origin() : websys_getMenuWin();
    if (s != window) return s.websys_emit(e, t);
    if ("undefined" != typeof OpenEventJson && OpenEventJson[e]) {
        var r = OpenEventJson[e];
        if (0 == r.OEActive) return "";
        if ("" != r.OEPageUrl) {
            if (1 == t.eventSourceScreenIndex && 1 == r.OEScreenIndex) return "";
            var o = "screenindex=" + (r.OEScreenIndex || 1);
            "OSS" == r.OEPageShowType && (o += ",singlescreendisable=1");
            var i = rewriteUrl(r.OEPageUrl, t);
            if (window.DisableSecondScreen && "SS" == r.OEPageShowType) websys_createWindow(i, "ScreenPage" + e); else if (0 < r.OEScreenIndex) {
                if (DisableSecondScreen) return !1;
                var a = "SCR" + r.OEScreenIndex;
                if (MWSecondScreenWindows[a] && MWSecondScreenWindows[a].openPageInSecondSreenMain) MWSecondScreenWindows[a].openPageInSecondSreenMain(websys_writeMWToken(r.OEPageUrl), t); else {
                    var c = rewriteUrl(MWSecondScreenFrmUrl[r.OEScreenIndex - 1], t);
                    -1 == c.indexOf("?") && (c += "?"), websys_createWindow(c + "&MainUrl=" + r.OEPageUrl, "ScreenPage" + r.OEScreenIndex, o);
                }
                "object" == typeof MWScreens && MWScreens.screens && 1 < MWScreens.screens.length && websys_popover("\u6269\u5c55\u4fe1\u606f\u5df2\u663e\u793a\u5230\u526f\u5c4f");
            } else websys_createWindow(i, "ScreenPage" + e);
        } else "cross-device" == t.type ? websys_emitByChat(e, t) : _triggerEvent(e, t);
    }
}

function websys_on(e, t) {
    var n = void 0 !== window.websys_getMenuWin_origin ? websys_getMenuWin_origin() : websys_getMenuWin();
    if (n) {
        if (n != window) return n.websys_on(e, t);
        if ("string" == typeof e && "function" == typeof t) return void (MWSecondScreenEvent[e] = t);
        if ("object" == typeof e) for (var s in e) MWSecondScreenEvent[s] = e[s];
    }
}

function websys_getMWScreens() {
    var e = void 0 !== window.websys_getMenuWin_origin ? websys_getMenuWin_origin() : websys_getMenuWin();
    if (e) return e == window ? MWScreens : e.websys_getMWScreens();
}

function websys_getMWToken() {
    var e = "";
    if (window.document.getElementById("MWToken") && "" != (e = window.document.getElementById("MWToken").value)) return e;
    var t = websys_getTop() || window;
    return -1 < t.location.search.indexOf("MWToken=") && "" != (e = t.location.search.split("MWToken=")[1].split("&")[0].split("#")[0]) || -1 < (t = websys_getMenuWin() || window).location.search.indexOf("MWToken=") && (e = t.location.search.split("MWToken=")[1].split("&")[0].split("#")[0]), 
    e;
}

function websys_writeMWToken(e) {
    var t = websys_getMWToken();
    return t && (e = rewriteUrl(e, {
        MWToken: t
    })), e;
}

function websys_getAppScreenIndexByName(e) {
    return "SecondSreen_main" == e ? 1 : "ThirdSreen_main" == e ? 2 : 0;
}

function websys_getAppScreenIndex() {
    var e = window, t = 0, n = 20;
    try {
        for (;e != e.parent; ) {
            if (0 < (t = websys_getAppScreenIndexByName(e.name))) return t;
            if (e = e.parent, --n < 0) break;
        }
    } catch (e) {
        return t;
    }
    return t;
}

function cspIntHttpServerMethod(e, t, n) {
    if ("" == e) return "";
    for (var s = {
        EncryItemName: e
    }, r = 1; r < t.length; r++) s["P_" + parseInt(r)] = t[r];
    var o = $m(s, !1);
    if (void 0 === o) return o;
    if ("" == o) return o;
    var i = o.split("\r\n"), a = !1, c = "";
    i.length;
    if (1 < i.length && (1 < t.length && "function" == typeof window[t[1]] && -1 < o.indexOf(t[1] + "(") && (a = !0), 
    3 < t.length && "function" == typeof window[t[3]] && -1 < o.indexOf(t[3] + "(") && (a = !0)), 
    a) {
        o = i.splice(i.length - 1)[0], c = i.join("\r\n");
        try {
            new Function("CSPPage", c)(self);
        } catch (e) {
            var l = "A JavaScript exception was caught during execution of HyperEvent:\n";
            l += e.name + ": " + e.message + "\n", l += "--------------------------------------\nResult: " + result + "\n", 
            l += "--------------------------------------\nJavaScript code:\n", l += c, alert(l);
        }
    }
    return o;
}