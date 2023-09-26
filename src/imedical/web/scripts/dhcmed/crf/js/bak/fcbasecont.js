



Eapi.BaseCont = function () { }
Eapi.BaseCont.prototype =
{
    setRadioValue: SetRadioValue,
    setCheckBoxValue: SetCheckBoxValue,
    sqlToOption: fillcombox,
    selectAddOption: SelectAddOption,
    addOption: function (obj, sHtml) {
        var ss = obj.outerHTML;
        obj.outerHTML = ss.substring(0, ss.length - 9) + sHtml + "</select>";
    },
    setDisabled: function (arrObjs, boolValue) {
        for (var i = 0; i < arrObjs.length; i++) {
            var obj = $id(arrObjs[i]);
            if (boolValue) {
                obj.disabled = true;
            } else {
                obj.disabled = false;
                obj.removeAttribute("disabled");
            }
        }
    },
    sqlCombo: SqlCombo,
    setComboText: SetComboText,
    radioListInit: DivRadioInitLoad,
    checkboxListInit: DivCheckBoxInitLoad,
    getRadioListValue: GetDivRadioValue,
    getCheckBoxListValue: GetDivCheckBoxValue,
    setRadioListValue: SetDivRadioValue,
    setCheckBoxListValue: SetDivCheckBoxValue,
    sqlToRadio: SqlToRadio
}
if (Type.parse("Eapi.BaseCont") == null) Eapi.BaseCont.registerClass("Eapi.BaseCont");


function SetRadioValue(r1, sValue) {

    r1.value = sValue;
    for (var i = 1; i < r1.childNodes.length; i++) {
        if (typeof r1.childNodes(i).tagName != "undefined") {
            if (r1.childNodes(i).tagName.toUpperCase() == "INPUT") {
                if (r1.childNodes(i).value == r1.value) {
                    r1.childNodes(i).checked = true;
                    if (r1.childNodes(i).className == "ef_out") {
                        var radioEl = document.getElementsByName(r1.childNodes(i).name);
                        for (var i = radioEl.length; i > 0; i--) {
                            if (radioEl[i - 1].type && radioEl[i - 1].type == "radio") {
                                radioEl[i - 1].previousSibling.className = radioEl[i - 1].previousSibling.className.replace(/ef_input_radio_[^_]+_(out|over)/, "ef_input_radio_" + (radioEl[i - 1].checked ? "" : "no") + "check_$1");
                            }
                        }
                    }
                    break;
                }
            }

            if (r1.childNodes(i).tagName.toUpperCase() == "TABLE") {
                var oTable = r1.childNodes(i);
                for (var j = 0; j < oTable.rows.length; j++) {
                    for (var k = 0; k < oTable.rows(j).cells.length; k++) {
                        var oRadio = oTable.rows(j).cells(k).childNodes(0);
                        if (oRadio.value == sValue) {
                            oRadio.checked = true;
                            return;
                        }
                    }
                }
            }
        }
    }

}

function SetCheckBoxValue(obj, sValue) {
    var oInput = obj.children[0];
    var oSpan = null;
    if (obj.children[0].tagName == "SPAN") {
        oInput = obj.children[1];
        oSpan = obj.children[0];
    }
    if (obj.truevalue == sValue) {
        oInput.checked = true;
        if (oSpan != null) {
            oSpan.className = oSpan.className.replace("_nocheck_", "_check_");
        }
    } else {
        oInput.checked = false;
        if (oSpan != null) {
            oSpan.className = oSpan.className.replace("_check_", "_nocheck_");
        }
    }
    obj.value = sValue;
}


function fillcombox(sSql, callback, context) {
    if (typeof sSql == "undefined" || sSql == "undefined") { return ""; }
    sSql = RepOpenSql(sSql);
    var sXml = "<No>" + RepXml(sSql) + "</No>";
    var retX = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?fillcombox", sXml, callback, context);
    return retX;
}

function SelectAddOption(obj, sHtml) {
    var ss = obj.outerHTML;
    return ss.substring(0, ss.length - 9) + sHtml + "</select>";
}

function sqlcombox(obj, sql) {
    if (typeof obj != "object") obj = eval(obj);
    if (isSpace(sql) == false) obj.sql = sql;
    if (isSpace(obj.sql) == false) {
        var s1 = fillcombox(obj.sql);
        if (isSpace(s1) == false) {
            obj.outerHTML = SelectAddOption(obj, s1);
        }
    }
}
function SqlCombo(obj, sql) { sqlcombox(obj, sql); }


function SetComboText(obj, sText) {
    l = obj.options.length;
    for (var i = 0; i < l; i++) {
        if (obj.options(i).text == sText) {
            obj.selectedIndex = i;
            return
        }
    }
}


function DivRadioInitLoad(obj) {
    if (isSpace(obj.sqltrans)) return;
    var strsql = UnSqlPropTrans(obj.sqltrans);
    strsql = RepOpenSql(strsql);
    var strReturn = SelectSql(strsql, 1, 100);
    var sfont = obj.style.fontSize;
    var sfontstyle = obj.style.fontStyle;
    var sfontweight = obj.style.fontWeight;
    var sColor = obj.style.color;
    var oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML(strReturn);
    var sLen = oXml.documentElement.childNodes.length;

    if (sLen > 0) {
        var strX = new Sys.StringBuilder();
        strX.append("<table border=0 width='100%' style='font-size:" + sfont + "; font-Style:" + sfontstyle + "; font-Weight:" + sfontweight + "; color:" + sColor + "'><tr>");
        var j = 0;
        var s = obj.rows - 1;
        for (var i = 0; i < sLen - 1; i++) {
            sdwid = oXml.documentElement.childNodes(i).childNodes(0).text;
            sdwname = oXml.documentElement.childNodes(i).childNodes(1).text;
            strX.append("<td><input type='radio' name='radio" + obj.id + "' value='" + sdwid + "' text='" + sdwname + "'>" + sdwname + "</td>");
            j = j + 1;
            if (j > s) {
                strX.append("</tr><tr>");
                j = 0;
            }
        }
        strX.append("</tr></table>");
    }
    obj.innerHTML = strX.toString();

}



function DivCheckBoxInitLoad(obj) {
    if (isSpace(obj.sqltrans)) return;
    var strsql = UnSqlPropTrans(obj.sqltrans);
    strsql = RepOpenSql(strsql);
    var strReturn = SelectSql(strsql, 1, 100);
    var sfontsize = obj.style.fontSize;
    var sfontstyle = obj.style.fontStyle;
    var sfontweight = obj.style.fontWeight;
    var sColor = obj.style.color;
    var oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML(strReturn);
    var sLen = oXml.documentElement.childNodes.length;

    if (sLen > 0) {
        var strX = new Sys.StringBuilder();
        strX.append("<table border=0 width='100%' style='font-size:" + sfontsize + "; font-style:" + sfontstyle + " ; font-weight:" + sfontweight + "; color:" + sColor + "'><tr>");
        var j = 0;
        var s = obj.rows - 1;
        for (var i = 0; i < sLen - 1; i++) {
            sdwid = oXml.documentElement.childNodes(i).childNodes(0).text;
            sdwname = oXml.documentElement.childNodes(i).childNodes(1).text;
            strX.append("<td><input type='checkbox' value='" + sdwid + "' text='" + sdwname + "'>" + sdwname + "</td>");
            j = j + 1;
            if (j > s) {
                strX.append("</tr><tr>");
                j = 0;
            }
        }
        strX.append("</tr></table>");
    }
    obj.innerHTML = strX.toString();
}


function GetDivRadioValue(obj, isText) {
    var t = obj.children[0];
    for (var i = 0; i < t.rows.length; i++) {
        for (var j = 0; j < t.rows(i).cells.length; j++) {
            if (t.rows(i).cells(j).childNodes(0).checked) {
                if (typeof isText == "undefined" || isText == '')
                    return t.rows(i).cells(j).childNodes(0).value;
                else
                    return t.rows(i).cells(j).childNodes(0).text;
            }
        }
    }
    return "";
}


function GetDivCheckBoxValue(obj, isText) {
    var strX = "";
    var t = obj.children[0];
    for (var i = 0; i < t.rows.length; i++) {
        for (var j = 0; j < t.rows(i).cells.length; j++) {
            if (t.rows(i).cells(j).childNodes(0).checked) {
                if (typeof isText == "undefined" || isText == '')
                    strX = strX + t.rows(i).cells(j).childNodes(0).value + ",";
                else
                    strX = strX + t.rows(i).cells(j).childNodes(0).text + ",";
            }
        }
    }
    var ll = strX.length;
    strX = strX.substring(0, ll - 1);
    return strX;

}


function SetDivRadioValue(obj, vValue, isText) {
    var strX = "";
    var t = obj.children[0];
    for (var i = 0; i < t.rows.length; i++) {
        for (var j = 0; j < t.rows(i).cells.length; j++) {
            var s = t.rows(i).cells(j).childNodes(0).text;
            if (typeof isText == "undefined" || isText == "") s = t.rows(i).cells(j).childNodes(0).value;
            if (s == vValue) {
                t.rows(i).cells(j).childNodes(0).checked = true;
            }
        }
    }
}

function SetDivCheckBoxValue(obj, strX, isText) {
    if (typeof strX == "undefined" || strX == "") return;
    var arr = strX.split(",");
    var t = obj.children[0];
    for (var i = 0; i < t.rows.length; i++) {
        for (var j = 0; j < t.rows(i).cells.length; j++) {
            for (var k = 0; k < arr.length; k++) {
                var s = t.rows(i).cells(j).childNodes(0).text;
                if (typeof isText == "undefined" || isText == "") s = t.rows(i).cells(j).childNodes(0).value;
                if (s == arr[k]) {
                    t.rows(i).cells(j).childNodes(0).checked = true;
                    break;
                }
            }
        }
    }
}

function SqlToRadio(obj, cols, strsql) {
    var strReturn = SelectSql(strsql, 1, -1);
    var oXml = SetDom(strReturn);
    if (oXml.documentElement == null) {
        alert(strReturn);
        return;
    }
    var sLen = oXml.documentElement.childNodes.length;
    if (sLen < 0) return;
    var RGid = obj.id;
    var strX = new Sys.StringBuilder();
    strX.append("<table border=0 width='100%' ><tr>");
    var j = 0;
    for (var i = 0; i < sLen - 1; i++) {
        sdwid = oXml.documentElement.childNodes(i).childNodes(0).text;
        sdwname = oXml.documentElement.childNodes(i).childNodes(1).text;
        strX.append("<td><input type=radio name='RG" + RGid + "' value='" + sdwid + "' text='" + sdwname + "' onclick='" + RGid + ".value=RG" + RGid + "[" + i + "].value;'>" + "<span onclick=RG" + RGid + "[" + i + "].checked=true;" + obj.id + ".value=RG" + RGid + "[" + i + "].value;RG" + RGid + "[" + i + "].focus();>" + sdwname + "</span></td>");
        j = j + 1;
        if (j >= cols && cols > 0) {
            strX.append("</tr><tr>");
            j = 0;
        }
    }
    strX.append("</tr></table>");
    obj.innerHTML += strX.toString();
}
