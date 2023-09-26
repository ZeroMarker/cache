(function () {
    var scripts = [fcpubdata.path + "/DHCFormExt/js/usertb.js"];
    var heads = document.getElementsByTagName("head");
    if (heads.length > 0) {
        for (var i = 0; i < scripts.length; ++i) {
            var script = document.createElement("script");
            script.src = scripts[i];
            heads[0].appendChild(script);
        }
    }
})();

Eapi.RunForm = function () { }
Eapi.RunForm.prototype =
{
    setPara: SetPara,
    getPara: GetPara,
    setParaPub: SetParaPub,
    getParaPub: GetParaPub,
    loadMod: LoadMod,
    closeBill: CloseBill,
    setButtonImage: SetButtonImage,
    sqlPropTrans: SqlPropTrans,
    unSqlPropTrans: UnSqlPropTrans,
    getFirstGridDs: Getdssub1,
    toolbarFunc: $eform,
    dbSql: DbSql,
    dbSqlCombo: DbSqlCombo,
    checkFieldRepeat: CheckFieldRepeat,
    getKeyFieldValue: function () {
        var sRet = "";
        var oDsMain = $id(fcpubdata.dsMain);
        var sIdType = fcpubdata.area.idtype;
        if (sIdType != 5) {
            sRet = oDsMain.Field(fcpubdata.area.keyfield).Value;
        }
        return sRet;
    },
    getConts: function () {
        fcpubdata.controls = new Object();
        //不知道为什么会出错，这个地方屏蔽了。
        if (fcpubdata.area == null) {
            return false;
        }
        var sContXml = fcpubdata.area.contxml;
        var oConts = SetDom(sContXml);
        if (oConts.documentElement != null) {
            for (var kk = 0; kk < oConts.documentElement.childNodes.length; kk++) {
                var typeName = oConts.documentElement.childNodes(kk).nodeName;
                fcpubdata.controls[typeName] = new Array();
                for (var kkk = 0; kkk < oConts.documentElement.childNodes(kk).childNodes.length; kkk++) {
                    fcpubdata.controls[typeName][kkk] = $id(oConts.documentElement.childNodes(kk).childNodes(kkk).text);
                }
            }
        }
    },
    gridAddEmptyRow: GridAddEmptyRow
}
Eapi.RunForm.registerClass("Eapi.RunForm");




function SetPara(paraname, vValue) {
    SaveUserData("pub", paraname, vValue);
}
function GetPara(paraname) {
    return LoadUserData("pub", paraname);
}
function SetParaPub(vValue) {
    SaveUserData("pub", "pub", vValue);
}
function GetParaPub() {
    return LoadUserData("pub", "pub");
}

function LoadMod(sKey1, sclass, sXml) {
    if (arguments.length == 0 || isSpace(sKey1)) return;
    var sKey = new Eapi.Str().trim(sKey1);
    var blnRemove = false;
    if (sKey.length > 2) {
        if (sKey.substring(sKey.length - 2, sKey.length) == "()") {
            sKey = sKey.substring(0, sKey.length - 2);
            blnRemove = true;
        }
    }
    var curO, ogrid, o, i;
    if (sclass == "click") {
        curO = event.srcElement;
    }
    if (sclass == "gridclick") {
        curO = event.srcElement;
        var oXml = new ActiveXObject("Microsoft.XMLDOM");
        oXml.async = false;
        oXml.loadXML(sXml);
        ogrid = eval(oXml.documentElement.tagName);
        var curcol = ogrid.curTD.cellIndex;
        if (curcol > 0 && oXml.documentElement.childNodes.length > 0) {
            try {
                sKey = oXml.documentElement.childNodes(curcol - 1).text;
            } catch (e) { return; }
        } else {
            return;
        }
    }
    if (sclass == "grid") {
        ogrid = eval(sXml);
        var grid_ds = eval("window." + ogrid.dataset);
        try {
            curO = event.srcElement;
        } catch (e) { }
    }
    if (isSpace(sKey) == false) {
        if (blnRemove) sKey = sKey + "()";
        if (event.type == "change" || event.type == "blur") sKey = "try {" + sKey + "}catch (e) {alert(e.description);}";
        eval(sKey);
    }


}


function clickmenu(sKey) {
    LoadMod(sKey, "clickmenu");
}

function clickrightmenu(sKey, gridID) {
    LoadMod(sKey, "grid", gridID);
}


function bill_blonopen(sKey) {
    LoadMod(sKey, "clickmenu");
}
function bill_blonclose(sKey) {
    LoadMod(sKey, "clickmenu");
}


function bill_onclick(sKey) {
    LoadMod(sKey, "click");
}

function bill_ondblclick(sKey, ogrid) {
    LoadMod(sKey, "click");
}

function bill_onenter(sKey) {
    LoadMod(sKey, "click");
}

function bill_onexit(sKey) {
    LoadMod(sKey, "click");
}

function bill_onkeydown(sKey) {
    LoadMod(sKey, "click");
}

function RunTabindex() {
    var sXml = fcpubdata.area.billtaborder;
    if (sXml == "<root></root>") return;
    var ikeycode = event.keyCode;



    if (ikeycode == 9) {
        var bRunUp = false;
        if (ikeycode == 38) bRunUp = true;
        curID = event.srcElement.id;
        if (curID == "chk") curID = event.srcElement.parentNode.parentNode.id;
        if (isSpace(curID)) curID = event.srcElement.parentNode.id;
        if (curID == "fc_txtName") curID = event.srcElement.parentNode.id;
        if (curID == "Numedit") curID = event.srcElement.parentNode.id;
        if (event.srcElement.id == "txtMyGrid") curID = event.srcElement.parentNode.parentNode.id;
        if (event.srcElement.id == "t") curID = event.srcElement.parentNode.parentNode.id;
        if (event.srcElement.tagName.toUpperCase() == "TD") curID = event.srcElement.parentNode.parentNode.parentNode.parentNode.parentNode.id;

        sXml = fcpubdata.area.billtaborder;
        var oXml = new ActiveXObject("Microsoft.XMLDOM");
        oXml.async = false;
        oXml.loadXML(sXml);
        var b1 = false;
        for (var i = 0; i < oXml.documentElement.childNodes.length; i++) {
            if (oXml.documentElement.childNodes(i).text == curID) {
                b1 = true;
                break;
            }
        }
        if (b1 == false) {
            i = 0;
        }


        var iLoops = 1;
        while (iLoops < 20) {
            if (bRunUp) {
                if (i == 0)
                    i = oXml.documentElement.childNodes.length - 1;
                else
                    i = i - 1;
            } else {
                if (i == oXml.documentElement.childNodes.length - 1)
                    i = 0;
                else
                    i = i + 1;
            }

            var nextObj = eval(oXml.documentElement.childNodes(i).text);
            var stagname1 = nextObj.tagName.toUpperCase();
            if (nextObj.disabled || nextObj.style.display == "none") {
                iLoops++;
                continue;
            } else {
                if (stagname1 == "FIELDSET") {
                    if (nextObj.childNodes.length > 1) {
                        try { nextObj.childNodes(1).focus(); } catch (E) { }
                    }
                } else if (stagname1 == "FC_CODE") {
                    nextObj.txt.focus();
                } else if (stagname1 == "DIV") {
                    try { nextObj.txt.focus(); } catch (e) { }
                } else if (stagname1 == "WEBGRID") {
                    if (nextObj.visible == "是") {
                        if (nextObj.tab.rows.length >= nextObj.FixRows) {
                            nextObj.SetFocus(nextObj.FindFirstTD(nextObj.FixRows), "程序给焦点");
                        } else {
                            nextObj.SetFocus(null, "");
                            nextObj.curTD.focus();
                        }
                    } else {
                        iLoops++;
                        continue;
                    }
                } else {
                    try {
                        nextObj.focus();
                    } catch (E) { }
                }
            }
            iLoops = 21;
        }
        event.returnValue = false;
    }
}

function FirstFocus() {
    var sXml = fcpubdata.area.billtaborder;
    if (sXml == "<root></root>") return;
    var oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML(sXml);
    var ll = oXml.documentElement.childNodes.length;
    i = 0;
    while (i < 20 && i < ll) {
        var nextObj = eval(oXml.documentElement.childNodes(i).text);
        var stagname1 = nextObj.tagName.toUpperCase();
        if (nextObj.disabled || nextObj.style.display == "none") {
            i++;
            continue;
        } else {
            if (stagname1 == "FIELDSET") {
                if (nextObj.childNodes.length > 1) { 
                    try{nextObj.childNodes(1).focus();}catch(E){}
                }
            } else if (stagname1 == "WEBGRID") {
                if (nextObj.visible == "是") {
                    if (nextObj.tab.rows.length >= nextObj.FixRows) {
                        nextObj.SetFocus(nextObj.FindFirstTD(nextObj.FixRows), "程序给焦点");

                    } else {
                        nextObj.SetFocus(null, "");
                        nextObj.curTD.focus();
                    }
                } else {
                    i++;
                    continue;
                }
            } else {
                try {
                    nextObj.focus();
                } catch (E) { }
            }
        }
        i = 21;
    }
}


function pub_djhtm() {
    fcpubdata.keyValue = parent.sOpenDjNo;
    fcpubdata.obj = fcpubdata.keyValue;
    if (typeof fcpubdata.keyValue == "object") {
        fcpubdata.keyValue = "";
    }
    var skinJs = "<script src='../css/skins/fcskins.js'></" + "script>";
    if (typeof (parent.pubMainObj) != "undefined") {
        var sSkin = parent.pubMainObj.skins;
        if (IsSpace(sSkin) == false) {
            fcpubdata.skins = sSkin;
            fcpubdata.cssFiles[fcpubdata.cssFiles.length] = "/css/skins/" + sSkin + "/style/efskin.css";
        } else if (IsSpace(fcpubdata.skins) == false) {
            fcpubdata.cssFiles[fcpubdata.cssFiles.length] = "/css/skins/" + fcpubdata.skins + "/style/efskin.css";
        } else {
            skinJs = "";
        }
        var basePath = fcpubdata.path + "/DHCForm";
        for (var i = 0; i < fcpubdata.cssFiles.length; i++) {
            document.writeln("<link href='" + basePath + fcpubdata.cssFiles[i] + "' type=text/css rel=stylesheet>")
        }
    }
    window.attachEvent("onunload", function () {
        fcpubdata.obj = null;
        fcpubdata.controls = null;
        fcpubdata.popup = null;
        fcpubdata.arrValidObj = null;
        fcpubdata.area = null;
    });
}
function pub_window_onkeypress() {
    fcpubdata.isEdit = true;
}
function pub_window_onbeforeunload() {
    try {
        eval(fcpubdata.area.BLONclose);
    } catch (e) { }
    if (parent.piAction != 3 && fcpubdata.isEdit) {
        event.returnValue = "离开当前页面将导致当前输入的数据丢失! 按 [确定] 则不保存数据并关闭窗口。";
    }
    ajax_stop();
}
function pub_window_onresize() {

    var o = window.document.all.tags("webgrid");

    var winWidth = document.body.clientWidth;
    var winHeight = document.body.clientHeight;
    for (var ii = 0; ii < o.length; ii++) {
        if (o[ii].childNodes(0).style.position != "absolute") {
            winWidth = o[ii].parentNode.offsetWidth;
            winHeight = o[ii].parentNode.offsetHeight;
        }
        if (o[ii].autowidth == "是") {
            var tmpwidth = winWidth - parseInt(o[ii].left) - 18;
            if (tmpwidth < 0) tmpwidth = 0;
            o[ii].width = tmpwidth;
        }
        if (o[ii].autoheight == "是") {
            var tmpheight = winHeight - parseInt(o[ii].top) - 18;
            if (tmpheight < 0) tmpheight = 0;
            o[ii].height = tmpheight;

        }

    }
}

function pub_window_onload() {
    fcpubdata.area = document.getElementById("SKbillsheet");
    fcpubdata.dsMain = GetDsMain(false);
    var d = new Date();
    var t = d.getTime();

    if (typeof EformEnterStatus == "function") {
        fcpubdata.enterStatus = EformEnterStatus();
        if (IsSpace(fcpubdata.enterStatus)) {
            parent.close();
            window.document.write("无权打开此表单");
            return;
        }
    }
    eval(fcpubdata.area.BLONopenBefore);
    var obj = fcpubdata.area;
    if (IsSpace(window.parent.document.title)) window.parent.document.title = obj.caption;
    if (isSpace(obj.posheight) == false && (obj.type != "LR" && obj.type != "ST" && obj.type != "PR")) {
        window.dialogHeight = obj.posheight + "px";
        window.dialogWidth = obj.poswidth + "px";
    }
    var iAction = parent.piAction;
    if (typeof iAction == "undefined" || iAction == 0 || iAction == "0") {
        if (obj.entertype == "新增")
            parent.piAction = 1;
        if (obj.entertype == "修改")
            parent.piAction = 2;
        if (obj.entertype == "展现")
            parent.piAction = 3;
    } else {
        parent.piAction = iAction;
    }
    var i;
    var sbar = obj.toolbar;
    if (sbar != "不带工具栏" && IsSpace(fcpubdata.formToolbar) == false) {
        var oDom = SetDom("<root>" + fcpubdata.formToolbar + "</root>");
        var ll = oDom.documentElement.childNodes.length;
        for (i = 0; i < ll; i++) {
            var name = oDom.documentElement.childNodes(i).text;
            if (sbar == name) {
                var path = oDom.documentElement.childNodes(i).getAttribute("path");
                var sHeight = oDom.documentElement.childNodes(i).getAttribute("height");
                if (IsSpace(path) == false) {
                    if (IsSpace(sHeight)) sHeight = "31";
                    path = RepStr(path, "~", fcpubdata.path);
                    var spara = parent.location.search;
                    if (IsSpace(spara)) spara = "";
                    parent.toolbar.location.assign(path + spara);
                    parent.mainframeset.rows = sHeight + ",*,0";
                }
            }
        }
    }
    new Eapi.Str().showWait("正在打开表单......");
    new Eapi.RunForm().getConts();

    var bmpPath = fcpubdata.path + "/" + fcpubdata.root + "/css/skins/" + fcpubdata.skins + "/images/ef_run_downarrow.gif";
    var ii, s1, o, l;
    o = window.document.all.tags("button");
    l = o.length;
    for (ii = 0; ii < l; ii++) {
        if (o[ii].dropstyle == "是") {
            SetButtonImage(o[ii], bmpPath);
        }
    }
    var o = window.document.all.tags("select");
    var l = o.length;
    for (ii = 0; ii < l; ii++) {
        if (isSpace(o[ii].sqltrans) == false) {
            s1 = UnSqlPropTrans(o[ii].sqltrans);
            if (isSpace(s1) == false) {
                s1 = fillcombox(s1);
                obj = o[ii];
                if (isSpace(s1) == false) {
                    obj.outerHTML = SelectAddOption(obj, s1);
                }
            }
        }
    }





    var sContXml = fcpubdata.area.contxml;
    var _oContXml = SetDom(sContXml);
    if (_oContXml.documentElement != null) {
        var oNode = _oContXml.documentElement.selectSingleNode("tree");
        if (oNode != null) {
            l = oNode.childNodes.length;
            for (i = 0; i < l; i++) {
                try {
                    obj = $id(oNode.childNodes(i).text);
                } catch (E) {
                    continue;
                }
                TreeRefresh(obj);
            }
        }
    }


    if (IsSpace(fcpubdata.obj) == false) {
        if (isSpace(fcpubdata.area.keyfield) == false) {
            try {
                fcpubdata.keyValue = fcpubdata.obj.Field(fcpubdata.area.keyfield).Value;
            } catch (E) { }
        }
    }
    /*o = window.document.all.tags("dataset");
    for (ii = 0; ii < o.length; ii++) {
        o[ii].InitLinkObj();
    }*/

    if (parent.piAction == 1) {
        fcpubdata.keyValue = "";
        openemptybill();
    }

    if (parent.piAction == 2 || parent.piAction == 3)
        openselbill(fcpubdata.keyValue);

    GridAddEmptyRow();

    if (typeof upload1 != "undefined") {
        var tb = upload1.childNodes(0);
        var ohref = tb.rows(tb.rows.length - 1).cells(0).children[0];
        ohref.onclick = function href_onclick() { if (fcpubdata.isEdit) { fcpubdata.isEdit = false; } };
        for (i = 0; i < tb.rows.length - 1; i++) {
            tb.rows(i).cells(2).children[0].onclick = function () { if (fcpubdata.isEdit) { fcpubdata.isEdit = false; } };
        }
    }

    o = window.document.all.tags("div");
    l = o.length;
    for (i = 0; i < l; i++) {
        if (o[i].controltype == "checkboxlist") {
            DivCheckBoxInitLoad(o[i]);
        } else if (o[i].controltype == "radiolist") {
            DivRadioInitLoad(o[i]);
        } else if (o[i].controltype == "ebiao") {
            new Eapi.EformEbiao().run(o[i]);
        }
    }
    if (typeof (EformCheckRoleInfo) == "function")
        EformCheckRoleInfo();
    eval(fcpubdata.area.BLONopen);
    contTermStyle();
    if (fcpubdata.skins != "base") new Eform.Skins().init();

    var ds1;
    o = window.document.all.tags("div");
    l = o.length;
    for (i = 0; i < l; i++) {
        if (o[i].controltype != "checkbox") continue;
        for (var jj = 0; jj < o[i].childNodes.length; jj++) {
            o[i].childNodes(jj).attachEvent("onclick", radio_checkbox_click);
        }
    }

    o = window.document.all.tags("fieldset");
    l = o.length;
    for (i = 0; i < l; i++) {
        for (var jj = 1; jj < o[i].childNodes.length; jj++) {
            try {
                o[i].childNodes(jj).attachEvent("onclick", radio_checkbox_click);
            } catch (e) { }

        }
    }



    new Eapi.Str().showWait("end");
    pub_window_onresize();
    window.setTimeout("FirstFocus();", 30);
    d = new Date();
    t1 = d.getTime();
    function openemptybill() {
        var o = window.document.all.tags("dataset");
        for (var ii = 0; ii < o.length; ii++) {
            o[ii].PageSize = -1;
            sErr = o[ii].OpenEmpty();
            if (sErr != "") {
                alert(sErr);
                return;
            }
        }
    }
    function openselbill(djbh, gzid, noeditdjbh) {
		return;
        var sErr = "", ii, s1;
        var oo = window.document.all.tags("dataset");
        var l = oo.length;
        var o = new Array(l);
        if (l <= 0) return;

        for (ii = 0; ii < l; ii++) {
            o[ii] = oo[ii];
        }
        if (isSpace(o[0].opensortno) == false) {
            o.sort(cmpdataset);
        }
        for (ii = 0; ii < l; ii++) {
            if (isSpace(gzid)) {
                if (isSpace(o[ii].crossvalue)) {
                    s1 = o[ii].opensql;
                    if (typeof s1 == "undefined") s1 = "";
                    if (s1 == "") s1 = UnSqlPropTrans(o[ii].sqltrans);
                    if (s1.length > 1) {
                        if (s1.charCodeAt(s1.length - 1) == 10 && s1.charCodeAt(s1.length - 2) == 13) {
                            s1 = s1.substring(0, s1.length - 2);
                            o[ii].opensql = s1;
                        }
                    }
                    if (isSpace(s1) == false) {
                        sErr = o[ii].Open(s1);
                    } else {
                        o[ii].OpenEmpty();
                    }
                } else {
                    s1 = CrossTab(o[ii].crossvalue);
                    if (isSpace(s1) == false) {
                        o[ii].OpenXml(s1);
                        sErr = "";
                    }
                }
            } else {
                sErr = o[ii].Open("select * from " + o[ii].temptable + " where gzid='" + gzid + "'");
            }
            if (isSpace(sErr) == false) {
                alert(sErr);
                return;
            }

        }


        if (noeditdjbh != "不要修改单据编号") {
            if (IsSpace(djbh) == false)
                fcpubdata.keyValue = djbh;
        }

        function cmpdataset(a, b) {
            return parseInt(a.opensortno) - parseInt(b.opensortno);
        }
    }
    function GetDsMain(bUseSelect) {
        var sRet = fcpubdata.dsMain;
        var oContXml, s1;
        oContXml = SetDom(fcpubdata.area.contxml);
        if (oContXml.documentElement == null) return sRet;
        var oNode = oContXml.documentElement.selectSingleNode("grid");
        var oNodeDs = oContXml.documentElement.selectSingleNode("dataset");
        if (oNodeDs != null) {
            for (var i = 0; i < oNodeDs.childNodes.length; i++) {
                var bool = false;
                var s = oNodeDs.childNodes(i).text;
                if (oNode != null) {
                    for (var j = 0; j < oNode.childNodes.length; j++) {
                        s1 = oNode.childNodes(j).text;
                        var otmp = eval(s1);
                        if (s == otmp.dataset) {
                            bool = true;
                            break;
                        }
                    }
                }
                if (bool == false) {
                    s1 = oNodeDs.childNodes(i).text;
                    var oods = eval(s1);
                    if (oods.pubpara != "是") {
                        sRet = oods.id;
                        break;
                    }
                }
            }

        }
        return sRet;

    }
}
function contTermStyle() {

    var oXml, slen, str1, str2;
    var o = window.document.all.tags("button");
    var l = o.length;
    for (var ii = 0; ii < l; ii++) {
        if (IsSpace(o[ii].termStyle) == false) {
            oXml = SetDom(o[ii].termStyle);
            slen = oXml.documentElement.childNodes.length;
            for (var i = 0; i < slen; i++) {
                str1 = oXml.documentElement.childNodes(i).childNodes(4).text;
                str2 = oXml.documentElement.childNodes(i).childNodes(5).text;
                if (eval(str1) == true) {
                    str2 = RepStr(str2, "curObjID", o[ii].id);
                    eval(str2);
                }
            }
        }
    }
    var cont = window.document.all.tags("input");
    var sl = cont.length;
    for (var m = 0; m < sl; m++) {
        if (IsSpace(cont[m].termStyle) == false) {
            oXml = SetDom(cont[m].termStyle);
            slen = oXml.documentElement.childNodes.length;
            for (l = 0; l < slen; l++) {
                str1 = oXml.documentElement.childNodes(l).childNodes(4).text;
                str2 = oXml.documentElement.childNodes(l).childNodes(5).text;
                if (eval(str1) == true) {
                    str2 = RepStr(str2, "curObjID", cont[m].id);
                    eval(str2);
                }
            }
        }
    }
    var oCont = window.document.all.tags("label");
    var s = oCont.length;
    for (var j = 0; j < s; j++) {
        if (IsSpace(oCont[j].termStyle) == false) {
            oXml = SetDom(oCont[j].termStyle);
            slen = oXml.documentElement.childNodes.length;
            for (var n = 0; n < slen; n++) {
                str1 = oXml.documentElement.childNodes(n).childNodes(4).text;
                str2 = oXml.documentElement.childNodes(n).childNodes(5).text;
                if (eval(str1) == true) {
                    str2 = RepStr(str2, "curObjID", oCont[j].id);
                    eval(str2);
                }
            }
        }
    }
}


function CloseBill() {
    fcpubdata.isEdit = false;
    history.go(-2);

    parent.close();
    try {
        parent.parent.execScript('try{ CloseWin();}catch(e){} ');
    } catch (e) { }

}




function SetButtonImage(sbutton, spathgif) {
    var obutton = eval(sbutton);
    obutton.style.backgroundImage = "url(" + spathgif + ")";
    obutton.style.cursor = "hand";


}

function SqlPropTrans(sql) {
    var s = new Eapi.Str().trim(sql);
    if (IsSpace(s)) return "";
    s = escape(s);
    var sRet = "";
    var l = s.length;
    for (var i = 0; i < l; i++) {
        var c = 2 * (s.charCodeAt(i) + 7);
        sRet += String.fromCharCode(c);
    }
    sRet = escape(sRet);
    return sRet;
}
function UnSqlPropTrans(s1) {
    var s = new Eapi.Str().trim(s1);
    if (IsSpace(s)) return "";
    s = unescape(s);
    var sRet = "";
    var l = s.length;
    for (var i = 0; i < l; i++) {
        var c = (s.charCodeAt(i) / 2) - 7;
        sRet += String.fromCharCode(c);
    }
    sRet = unescape(sRet);
    return sRet;
}

function YearFirstDay() {
    var dDate = new Date();
    var s1 = "" + dDate.getYear();
    s1 += "-01-01";
    return s1;
}

function YearLastDay() {
    var dDate = new Date();
    var s1 = "" + dDate.getYear();
    s1 += "-12-31";
    return s1;
}

function getuser() {
    return "fc";
}
function getusername() {
    return "fc";
}

function Getdssub1() {
    var o = window.document.all.tags("webgrid");
    for (var ii = 0; ii < o.length; ii++) {
        if (IsSpace(o[ii].dataset) == false) {
            var ods = $id(o[ii].dataset);
            if (ods != null) return ods;
        }
    }

    var o = window.document.all.tags("dataset");
    for (var ii = 0; ii < o.length; ii++) {
        if (typeof (o[ii].isSubGrid) != "undefined") return o[ii];
    }
    return null;

}


function CheckDate(sdate) {
    return Valid.checkValue("Date", sdate);
}

function DbSql(oDs, sConn, sSql, PageNo, PageSize, callback, context) {



    var sFieldNameList = "";
    var oSour = SetDom(oDs.format);
    for (var i = 0; i < oSour.documentElement.childNodes.length; i++) {
        sFieldNameList += oSour.documentElement.childNodes(i).childNodes(0).text + ";";
    }
    sFieldNameList = sFieldNameList.substring(0, sFieldNameList.length - 1);
    var sXml = "<No>" + RepXml(sSql) + "</No>" + "<No1>" + PageNo + "</No1>" + "<No2>" + PageSize + "</No2>" + "<No3>" + sFieldNameList + "</No3>";
    var retX = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?key=DbSql&connectstring=" + escape(sConn), sXml, callback, context);
    retX = RepStr(retX, "<fields></fields>", oDs.format);
    oDs.OpenXmlData(retX);
    return retX;
}

function DbSqlCombo(oCombobox, sConn, sSql, callback, context) {

    var sXml = "<No>" + RepXml(sSql) + "</No>";
    var retX = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?key=DbSqlCombo&connectstring=" + escape(sConn), sXml, callback, context);
    if (IsSpace(retX) == false) {
        oCombobox.outerHTML = SelectAddOption(oCombobox, retX);
    }

}

function CheckFieldRepeat(ods, fieldName) {
    var l = ods.oDom.documentElement.childNodes.length - 1;
    var col = ods.FieldNameToNo(fieldName);
    var bRepeat = false;
    for (var i = 0; i < l; i++) {
        var value1 = ods.oDom.documentElement.childNodes(i).childNodes(col).text;
        for (var j = i + 1; j < l; j++) {
            if (value1 == ods.oDom.documentElement.childNodes(j).childNodes(col).text) {
                bRepeat = true;
                break;
            }
        }
        if (bRepeat) break;
    }
    if (bRepeat) {
        alert(ods.oDom.documentElement.childNodes(l).childNodes(1).childNodes(col).childNodes(2).text + " 的值重复!");
    }
    return bRepeat;
}

function GridAddEmptyRow(sDs) {

    var o = window.document.all.tags("webgrid");
    for (var ii = 0; ii < o.length; ii++) {
        if (IsSpace(o[ii].dataset)) continue;
        if (typeof sDs != "undefined" && sDs != o[ii].dataset) continue;
        var ods = $id(o[ii].dataset);
        if (ods == null) continue;
        var rowCount = o[ii].bodyrows;
        if (typeof rowCount == "undefined") rowCount = -1;
        var rowHeight = o[ii].bodyrowheight;
        if (typeof rowHeight == "undefined" || rowHeight == -1) rowHeight = 21;
        var offsetV = rowCount - ods.RecordCount;
        if (offsetV <= 0) continue;
        for (var jj = 0; jj < offsetV; jj++) {
            ods.Append("强行加一行");
            var oTr = o[ii].InsertRow();
            oTr.style.height = rowHeight + "px";
        }
        ods.dset_cont();
        o[ii].initGrid();
        o[ii].EndRowState = "edit";
    }
}
function radio_checkbox_click() {
    var objInput;
    var obj = event.srcElement;
    if (obj.parentNode.disabled) return;
    if (obj.tagName.toUpperCase() == "SPAN") {
        if (obj.className.indexOf("ef_input") < 0) {
            objInput = obj.previousSibling;
        } else {
            objInput = obj.nextSibling;
        }
    } else {
        objInput = obj;
    }
    if (objInput == null) return;
    if (objInput.type == "checkbox") {
        if (obj.tagName.toUpperCase() == "SPAN" && fcpubdata.skins == "base") objInput.checked = objInput.checked ? false : true;
        obj.parentNode.value = objInput.checked ? obj.parentNode.truevalue : obj.parentNode.falsevalue;
    } else {
        objInput.checked = true;
        obj.parentNode.value = objInput.value;
    }
    var sDs = objInput.parentNode.dataset;
    if (IsSpace(sDs) == false) {
        $id(sDs).cont1_onblur();
    }
}
function $urlParam(paramName) {

    if (IsSpace(paramName) == false)
        return parent.Request.QueryString(paramName).toString();
}

function $eform(sKey) {
    var oDsMain = $id(fcpubdata.dsMain);
    var oDsGrid = Getdssub1();
    switch (sKey) {
        case "第一页": oDsMain.FirstPage(); break;
        case "上一页": oDsMain.PrevPage(); break;
        case "下一页": oDsMain.NextPage(); break;
        case "最后页": oDsMain.LastPage(); break;

        case "新增": oDsMain.Append(); oDsMain.fset_cont1(); fcpubdata.keyValue = ''; break;
        case "删除": DelGridRow(oDsMain); oDsMain.PrevPage(); break;

        case "复制新增": oDsMain.AppendCopy(); oDsMain.fset_cont1(); fcpubdata.keyValue = ''; break;

        case "新增保存": fcpubdata.keyValue = ''; var sR = DjSave(); if (IsSpace(sR)) { alert('新增保存成功!'); oDsMain.Append(); } else { alert(sR); } break;
        case "修改保存": fcpubdata.keyValue = new Eapi.RunForm().getKeyFieldValue(); DjSaveShow(); break;
        case "表单保存好后提示": DjSaveShow(); break;
        case "表单保存": DjSave(); break;
        case "表单保存好后退出": DjSave('退出'); break;

        case "表格第一页": oDsGrid.FirstPage(); break;
        case "表格上一页": oDsGrid.PrevPage(); break;
        case "表格下一页": oDsGrid.NextPage(); break;
        case "表格最后页": oDsGrid.LastPage(); break;
        case "增加行": oDsGrid.Append(); break;
        case "删除行": oDsGrid.Delete(); break;
        case "删除行且删除记录": DelGridRow(oDsGrid); break;
        case "删除表格多选行": MultiDelGridRow(oDsGrid); break;
        case "表格保存": GridSave(oDsGrid); break;
        case "表格保存好后退出": GridSave(oDsGrid, '退出'); break;
        case "表格选中多行": GridMultiSel(); break;

        case "选择日期": SelectDate(); break;
        case "计算器": ShowCalc(); break;
        case "关闭窗口": CloseBill(); break;
        case "刷新条件格式": contTermStyle(); break;
        case "刷新权限控制": if (typeof (EformCheckRoleInfo) == "function") EformCheckRoleInfo(); break;
    }
}
