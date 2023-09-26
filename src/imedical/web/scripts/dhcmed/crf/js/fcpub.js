




var fcpubdata = {
    servletPath: "/servlet",
    path: "",
    root: "DHCWebForm",
    dotnetVersion: "",
    databaseTypeName: "sqlserver",
    dbStruDict: "FC_DBSTRU",
    cssFiles: [],
    skins: "base",
    toolbarStyle: "base",
    actionButtonDisplay: "",
    db2UserName: "",
    gridNoFieldName: "dj_sn",
    billOpenWinName: "rightmain",
    position: "absolute",
    toolbar: "newempty,opendj,opendjfile,billtype,djpreview,directrun,save,saveas,|,cut,copy,paste,undo,redo,|,align,focus,front,behind,form,|,userfunction,userfunction1,addhtml,execute,showlist,listconfig,setPosition,|,cbozoom,br,button,label,img,div,shape,|,tab,tree,a,spin,checkboxlist,radiolist,|,dataset,grid,htmltable,formattab,|,text,checkbox,radio,listbox,combobox,dropdownlist,textarea,|,dbimg,upload",
    formToolbar: "<option path=\"~/DHCForm/common/toolbarinput1.htm\">单表输入工具栏</option><option path=\"~/DHCForm/common/toolbarinput2.htm\">多表输入工具栏</option><option path=\"~/DHCForm/common/toolbarfind.htm\">查询工具栏</option><option path=\"~/DHCForm/common/toolbar.htm\">带工具栏</option>",
    sendHttpErrMsg: ":与后台连接出错:",
    area: null,
    treeObject:null,
    dsMain: "DsMain",
    pubSession: "null",
    autoAddField: "no",
    pubdataSrc: "",
    topicSrc: "",
    keyValue: "",
    obj: null,
    isEdit: false,
    enterStatus: "OK",
    arrValidObj: new Array(),
    controls: new Object(),
    popup: window.createPopup(),
    layoutLength: 10240,
    sourcePath : '../scripts/dhcmed/crf/',
    runQuery : 'DHCMed.CR.BO.RunQuery.cls',  //'dhcmed.crf.query.csp',
    runMethod : 'DHCMed.CR.BO.RunMethod.cls',
    previewDic : 'DHCMed.CR.BO.PreviewDic.cls'
};

(function () {
    var tmp12345 = GetUrlFirstPart();
    fcpubdata.servletPath = tmp12345 + fcpubdata.servletPath;
    
    fcpubdata.path = GetPath();
		
    var scripts = [fcpubdata.sourcePath + "css/skins/fcskins.js", fcpubdata.sourcePath + "js/fcvalid.js"];
    var heads = document.getElementsByTagName("head");
    if (heads.length > 0) {
        for (var i = 0; i < scripts.length; ++i) {
            var script = document.createElement("script");
            script.src = scripts[i];
            heads[0].appendChild(script);
        }
    }

})();

function GetPath() {
    var iPos = location.href.indexOf("://");
    var urlArr = location.href.substring(iPos + 3).split("/");
    var localstr = location.href.substring(0, iPos + 2);
    for (var i = 0; i < urlArr.length; i++) {
        if (urlArr[i] == fcpubdata.root) {
            return localstr;
        } else {
            localstr += "/" + urlArr[i];
        }   
    }
    return localstr;
}

function GetUrlFirstPart() {
    var tmp12345 = location.protocol+"//"+location.host;
    return tmp12345;
}








Type.registerNamespace("Eapi");
Type.registerNamespace("Eform");
Eapi.UserData = function () { }
Eapi.UserData.prototype =
{
    save: function (Main, Sub, strContent) {
        try {
            userData = parent.pubdata.oForm.oInput;
        } catch (e) { return; }
        userData.setAttribute(Main + userData.value, strContent);
        userData.save(Sub + userData.value);
    },
    load: function (Main, Sub) {
        try {
            userData = parent.pubdata.oForm.oInput;
        } catch (e) { return ""; }
        userData.load(Sub + userData.value);
        var sTmp = userData.getAttribute(Main + userData.value);
        if (sTmp == null) { sTmp = ""; }
        return sTmp;

    }
}
Eapi.UserData.registerClass("Eapi.UserData");

Eapi.Num = function () { }
Eapi.Num.prototype =
{
    toFloat: function (str1) {
        var s1 = new Eapi.Str().trim(str1);
        var f1 = parseFloat(s1);
        if (isNaN(f1)) { return 0; }
        return f1;
    },
    toInt: function (str1) {
        var s1 = new Eapi.Str().trim(str1);
        var f1 = parseInt(s1, 10);
        if (isNaN(f1)) { return 0; }
        return f1;
    },
    format: function (sValue, sPointNum) {
        var dblValue = parseFloat(sValue);
        if (isNaN(dblValue)) { return sValue; }
        var iPointNum = parseInt(sPointNum);
        if (isNaN(iPointNum)) { iPointNum = 0; }
        if (iPointNum > 9) { iPointNum = 9; }
        if (iPointNum < 0) { iPointNum = 0; }
        var dbl1 = Math.round(dblValue * Math.pow(10, iPointNum)) / Math.pow(10, iPointNum);
        var s1 = dbl1 + "";
        var num0 = 0;
        if (s1.indexOf(".") == -1) {
            num0 = iPointNum;
        }
        else {
            var num1 = s1.length - s1.indexOf(".") - 1;
            if (num1 < iPointNum) {
                num0 = iPointNum - num1;
            }
        }

        if (num0 > 0) {
            var s2 = "000000000000000";
            if (num0 == iPointNum) {
                s1 = s1 + "." + s2.substring(0, num0);
            } else {
                s1 = s1 + s2.substring(0, num0);
            }
        }
        return s1;
    }
}
Eapi.Num.registerClass("Eapi.Num");

Eapi.DateParse = function () { }
Eapi.DateParse.prototype =
{
    parse: function (strDate) {
        strDate = strDate.trim();
        var format = ["yyyy-MM-dd", "yyyy-M-d", "yyyy/MM/dd", "yyyy/M/d", "yyyy.MM.dd", "yyyy.M.d", "yyyyMMdd", "yyyyMd", "yyyy年MM月dd日", "yyyy年M月d日"];
        var timeFormat = ["HH:mm:ss", "H:m:s", "hh:mm:ss tt", "hh:mm:ss t", "h:m:s tt", "h:m:s t", "hh:mm:ss.f", "hh:mm:ss.ff", "hh:mm:ss.fff"];
        var ret = null, i = 0;
        for (i = 0; i < format.length; i++) {
            ret = Date.parseInvariant(strDate, format[i]);
            if (ret != null) return ret;
        }
        for (i = 0; i < format.length; i++) {
            for (var j = 0; j < timeFormat.length; j++) {
                ret = Date.parseInvariant(strDate, format[i] + " " + timeFormat[j]);
                if (ret != null) return ret;
            }
        }
    }
}
Eapi.DateParse.registerClass("Eapi.DateParse");


Eapi.Str = function () { }
Eapi.Str.prototype =
{
    trim: function (strMain) {
        if (strMain == null) { return ""; }
        strMain = strMain + "";
        return strMain.trim();
    },
    isTrue: function (svalue) {
        if (svalue == false || svalue == "false" || svalue == "False" || svalue == "no" || svalue == 0 || svalue == "0" || svalue == "off" || svalue == "否" || svalue == "假" || svalue == "")
            return false;
        else
            return true;
    },
    isSpace: function (strMain) {
        var strComp = strMain;
        try {
            if (strComp == "　" || strComp == "" || strComp == " " || strComp == null || strComp == "null" || strComp.length == 0 || typeof strMain == "undefined" || strMain == "undefined") {
                return true;
            }
            else {
                return false;
            }
        } catch (e) { return false; }
    },
    repStr: function (mainStr, findStr, replaceStr) {
        if (typeof (mainStr) == "undefined" || mainStr == null) { return ""; }

        var convertedString = mainStr.split(findStr);
        convertedString = convertedString.join(replaceStr);
        return convertedString;
    },
    repNewLine: function (sRun) {
        return RepStr(sRun, "\r\n", "&#13;&#10;");
    },
    unRepNewLine: function (sRun) {
        return RepStr(sRun, "&#13;&#10;", "\r\n");
    },
    repXml: function (sRun) {
        sRun = RepStr(sRun, "&", "&amp;");
        sRun = RepStr(sRun, ">", "&gt;");
        sRun = RepStr(sRun, "<", "&lt;");
        return sRun;
    },
    unRepXml: function (sSql) {
        sSql = RepStr(sSql, "&lt;", "<");
        sSql = RepStr(sSql, "&gt;", ">");
        sSql = RepStr(sSql, "&amp;", "&");
        return sSql;
    },
    bigMoney: function (value) {
        var intFen, i;
        var strArr, strCheck, strFen, strDW, strNum, strBig, strNow;

        if (new Eapi.Str().trim(value) == "") {
            return "零";
        }
        if (isNaN(value)) {
            strErr = "数据" + value + "非法！";
            alert(strErr);
            return "";
        }
        strCheck = value + ".";
        strArr = strCheck.split(".");
        strCheck = strArr[0];
        var len = strCheck.length;
        if (len > 12) {
            strErr = "数据" + value + "过大，无法处理！";
            alert(strErr);
            return "";
        }
        try {
            i = 0;
            strBig = "";
            var s00 = "00";
            var svalue = value + "";
            var ipos = svalue.indexOf(".");
            var iiLen = svalue.length;
            if (ipos < 0) {
                strFen = svalue + "00";
            } else if (ipos == iiLen - 2) {
                strFen = svalue.substring(0, iiLen - 2) + svalue.substring(iiLen - 1, iiLen) + "0";
            } else if (ipos == iiLen - 3) {
                strFen = svalue.substring(0, iiLen - 3) + svalue.substring(iiLen - 2, iiLen);
            } else {
                strFen = svalue.substring(0, ipos) + svalue.substring(ipos + 1, ipos + 3);
            }
            intFen = strFen.length;
            strArr = strFen.split("");
            while (intFen != 0) {
                i = i + 1;
                switch (i) {
                    case 1: strDW = "分"; break;
                    case 2: strDW = "角"; break;
                    case 3: strDW = "元"; break;
                    case 4: strDW = "拾"; break;
                    case 5: strDW = "佰"; break;
                    case 6: strDW = "仟"; break;
                    case 7: strDW = "万"; break;
                    case 8: strDW = "拾"; break;
                    case 9: strDW = "佰"; break;
                    case 10: strDW = "仟"; break;
                    case 11: strDW = "亿"; break;
                    case 12: strDW = "拾"; break;
                    case 13: strDW = "佰"; break;
                    case 14: strDW = "仟"; break;
                }
                switch (strArr[intFen - 1]) {
                    case "1": strNum = "壹"; break;
                    case "2": strNum = "贰"; break;
                    case "3": strNum = "叁"; break;
                    case "4": strNum = "肆"; break;
                    case "5": strNum = "伍"; break;
                    case "6": strNum = "陆"; break;
                    case "7": strNum = "柒"; break;
                    case "8": strNum = "捌"; break;
                    case "9": strNum = "玖"; break;
                    case "0": strNum = "零"; break;
                }

                strNow = strBig.split("");
                if ((i == 1) && (strArr[intFen - 1] == "0")) {
                    strBig = "整";
                }
                else if ((i == 2) && (strArr[intFen - 1] == "0")) {
                    if (strBig != "整")
                        strBig = "零" + strBig;
                }
                else if ((i == 3) && (strArr[intFen - 1] == "0")) {
                    strBig = "元" + strBig;
                }
                else if ((i < 7) && (i > 3) && (strArr[intFen - 1] == "0") && (strNow[0] != "零") && (strNow[0] != "元")) {
                    strBig = "零" + strBig;
                }
                else if ((i < 7) && (i > 3) && (strArr[intFen - 1] == "0") && (strNow[0] == "零"))
                { }
                else if ((i < 7) && (i > 3) && (strArr[intFen - 1] == "0") && (strNow[0] == "元"))
                { }
                else if ((i == 7) && (strArr[intFen - 1] == "0")) {
                    strBig = "万" + strBig;
                }
                else if ((i < 11) && (i > 7) && (strArr[intFen - 1] == "0") && (strNow[0] != "零") && (strNow[0] != "万")) {
                    strBig = "零" + strBig;
                }
                else if ((i < 11) && (i > 7) && (strArr[intFen - 1] == "0") && (strNow[0] == "万"))
                { }
                else if ((i < 11) && (i > 7) && (strArr[intFen - 1] == "0") && (strNow[0] == "零"))
                { }
                else if ((i < 11) && (i > 8) && (strArr[intFen - 1] != "0") && (strNow[0] == "万") && (strNow[2] == "仟")) {
                    strBig = strNum + strDW + "万零" + strBig.substring(1, strBig.length);
                }
                else if (i == 11) {
                    if ((strArr[intFen - 1] == "0") && (strNow[0] == "万") && (strNow[2] == "仟")) {
                        strBig = "亿" + "零" + strBig.substring(1, strBig.length);
                    }
                    else if ((strArr[intFen - 1] == "0") && (strNow[0] == "万") && (strNow[2] != "仟")) {
                        strBig = "亿" + strBig.substring(1, strBig.length);
                    }
                    else if ((strNow[0] == "万") && (strNow[2] == "仟")) {
                        strBig = strNum + strDW + "零" + strBig.substring(1, strBig.length);
                    }
                    else if ((strNow[0] == "万") && (strNow[2] != "仟")) {
                        strBig = strNum + strDW + strBig.substring(1, strBig.length);
                    }
                    else {
                        strBig = strNum + strDW + strBig;
                    }
                }
                else if ((i < 15) && (i > 11) && (strArr[intFen - 1] == "0") && (strNow[0] != "零") && (strNow[0] != "亿")) {
                    strBig = "零" + strBig;
                }
                else if ((i < 15) && (i > 11) && (strArr[intFen - 1] == "0") && (strNow[0] == "亿"))
                { }
                else if ((i < 15) && (i > 11) && (strArr[intFen - 1] == "0") && (strNow[0] == "零"))
                { }
                else if ((i < 15) && (i > 11) && (strArr[intFen - 1] != "0") && (strNow[0] == "零") && (strNow[1] == "亿") && (strNow[3] != "仟")) {
                    strBig = strNum + strDW + strBig.substring(1, strBig.length);
                }
                else if ((i < 15) && (i > 11) && (strArr[intFen - 1] != "0") && (strNow[0] == "零") && (strNow[1] == "亿") && (strNow[3] == "仟")) {
                    strBig = strNum + strDW + "亿零" + strBig.substring(2, strBig.length);
                } else {
                    strBig = strNum + strDW + strBig;
                }
                strFen = strFen.substring(0, intFen - 1);
                intFen = strFen.length;
                strArr = strFen.split("");
            }
            if (strBig == "整") { strBig = "零"; }
            return strBig;
        } catch (err) {
            return "";
        }
    },

    repOpenSql: function (sql, slikevalue) {

        if (isSpace(sql)) { return ""; }
        if (fcpubdata.databaseTypeName == "mysql") {
            sql = new Eapi.Str().trim(sql);
            if (sql.substring(0, 4).toUpperCase() == "EXEC") {
                alert("因mysql数据库不支持存储过程!故无法使用此功能!");
                return sql;
            }
        }

        sql = repStr(sql, "\r\n", " ");
        sql = repStr(sql, "{单引号}", "'");
        var arrTmp = sql.split(":{");
        if (arrTmp.length > 1) {
            var pos = 0;
            var retSql = new Sys.StringBuilder();
            retSql.append(arrTmp[0]);
            for (var k = 1; k < arrTmp.length; k++) {
                pos = arrTmp[k].indexOf("}:");
                if (pos >= 0) {
                    retSql.append(eval(arrTmp[k].substring(0, pos)));
                    retSql.append(arrTmp[k].substring(pos + 2, arrTmp[k].length));
                } else {
                    alert("sql语句中的 :{ 没有和 }: 相匹配!");
                    return sql;
                }
            }
            sql = retSql.toString();
        }

        var posStart = 0;
        var posEnd = 0;
        var ret = "";
        var re = new RegExp();
        re.compile("(:[a-zA-Z0-9_\.\$]*)([), =+%']|$|\s)", "gi");
        var sInput = sql;
        var nextpoint = 0;
        while ((arr = re.exec(sInput)) != null) {
            posEnd = arr.index;
            var s1 = RegExp.$1;
            var sRep = "";
            if (s1 == ":v_get") {
                sRep = slikevalue;
            } else {
                var arr2 = s1.split(".");
                if (arr2.length == 1) {
                    if (s1 == ":key_value") {
                        sRep = "'" + fcpubdata.keyValue + "'";
                    } else {
                        sRep = s1;
                    }
                } else {
                    var stmp1 = arr2[0].substring(1, arr2[0].length);
                    if (arr2.length == 3) stmp1 = stmp1 + "." + arr2[1];
                    var oDs = eval(stmp1);
                    if (oDs != null) {
                        if (oDs.Empty == "null") {
                            sRep = "''";
                        } else {
                            var stmpField = arr2[1];
                            if (arr2.length == 3) stmpField = arr2[2];
                            try {
                                sRep = "'" + oDs.Field(stmpField).Value + "'";
                            } catch (E) {
                                alert(stmp1 + "中不存在字段" + stmpField); sRep = "'" + "'";
                            }
                        }
                    }
                }
            }
            ret += sql.substring(posStart + nextpoint, posEnd + nextpoint);
            ret += sRep;
            posStart = arr.index + s1.length;
        }
        if (ret == "") {
            ret = sql;
        } else if (posStart <= sql.length) {
            ret += sql.substring(posStart, sql.length);
        }
        if (isSpace(ret)) { ret = ""; }
        return ret;
    },
    removeRoot: function (strX) {
        if (strX.length > 13) {
            strX = strX.substring(6, strX.length - 7);
            return strX;
        } else {
            return "";
        }
    },
    copyToPub: function (str) {
        window.clipboardData.setData("Text", str);
    },
    showHelp: function (htmlfile) {
        window.open(fcpubdata.path + "/eformhelp/" + htmlfile + ".htm", "_blank", "top=0,left=0,height=400,width=300,status=no,toolbar=yes,menubar=no,location=no,resizable=yes,scrollbars=yes")
    },
    showWait: function (displaystr) {
        var oPubPopup = fcpubdata.popup;
        var oPubPopupBody = oPubPopup.document.body;
        if (displaystr == "end") {
            oPubPopup.hide();
        } else {
            if (event != null) {
                if (event.srcElement != null) {
                    if (event.srcElement.tagName.toUpperCase() == "SELECT") return;
                }
            }
            var strHTML = "";
            strHTML += "<TABLE WIDTH=100% BORDER=0 CELLSPACING=0 CELLPADDING=0><TR><td width=0%></td>";
            strHTML += "<TD bgcolor=#ff9900><TABLE WIDTH=100% height=60 BORDER=0 CELLSPACING=2 CELLPADDING=0>";
            strHTML += "<TR><td bgcolor=#eeeeee align=center>" + displaystr + "</td></tr></table></td>";
            strHTML += "<td width=0%></td></tr></table>";

            oPubPopupBody.innerHTML = strHTML;
            var iwidth = 300;
            var iheight = 60;
            var ileft = (screen.availWidth - iwidth) / 2;
            var itop = (screen.availHeight - iheight) / 2;
            oPubPopup.show(ileft, itop, iwidth, iheight);
        }
    },
    setDisabled: function (obj, boolValue) {
        if (boolValue) {
            obj.disabled = true;
        } else {
            obj.disabled = false;
            obj.removeAttribute("disabled");
        }

    },
    comboToStr: function (lstSelField2) {
        var sb = new Sys.StringBuilder();
        var len = lstSelField2.options.length;
        for (var i = 0; i < len; i++) {
            var stmp = new Eapi.Str().trim(lstSelField2.options(i).value);
            if (stmp == "") stmp = new Eapi.Str().trim(lstSelField2.options(i).text);
            sb.append(stmp);
            sb.append(",");
        }
        var sV = sb.toString();
        sV = sV.substring(0, sV.length - 1);
        return sV;
    }

}
Eapi.Str.registerClass("Eapi.Str");

Eapi.RunAjax = function () { }
Eapi.RunAjax.prototype =
{
    sendHttp: SendHttp,
    sqlToField: function (sql) {
        var sXml = "<No>" + RepXml(sql) + "</No>";
        var retX = this.sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?SqlToField", sXml);
        return retX;
    },
    insertSqls: function (sSql) {
        var retX = this.sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?inserts", sSql);
        return retX;
    },
    insertSql: function (sSql) {
        if (fcpubdata.databaseTypeName == "mysql" && sSql.substring(0, 4).toUpperCase() == "EXEC") {
            alert("因mysql数据库不支持存储过程!故无法使用此功能!");
            return "";
        }
        var sXml = "<No>" + sSql + "</No>";
        var retX = this.sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?fc_insert", sXml);
        return retX;
    },
    selectSql: function (sSql, PageNo, PageSize) {
        if (fcpubdata.databaseTypeName == "mysql" && sSql.substring(0, 4).toUpperCase() == "EXEC") {
            alert("因mysql数据库不支持存储过程!故无法使用此功能!");
        }
        var sql1 = RepXml(sSql);
        var sXml = "<No>" + sql1 + "</No>" + "<No1>" + PageNo + "</No1>" + "<No2>" + PageSize + "</No2>";
        var retX = this.sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?fc_select", sXml);
        return retX;
    },
    getMaxNo: function (sTag, strMK) {
        return this.sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?getRecnum", "<no>" + sTag + "</no>");
    },
    getMaxIntNo: function (sTag) {
        return this.sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?getMaxIntNo", "<no>" + sTag + "</no>");
    }

}
Eapi.RunAjax.registerClass("Eapi.RunAjax");
Eapi.Dom = function () { }
Eapi.Dom.prototype =
{
    setDom: function (sXml) {
        var oXml = new ActiveXObject("Microsoft.XMLDOM");
        oXml.async = false;
        oXml.loadXML(sXml);
        return oXml;
    },
    setDomFile: function (sPath) {
        var oXml;
        try {
            oXml = new ActiveXObject("Msxml2.DOMDocument");
        } catch (e) {
        }
        if (typeof oXml == "undefined") oXml = new ActiveXObject("Microsoft.XMLDOM");
        oXml.async = false;
        oXml.load(sPath);
        return oXml;
    }

}
Eapi.Dom.registerClass("Eapi.Dom");
Eapi.Css = function () { }
Eapi.Css.prototype =
{
    getPart: function (csstext) {
        if (typeof csstext == "undefined") return "";
        var sRet = new Sys.StringBuilder();
        var arr = csstext.split(";");
        var l = arr.length;
        for (var i = 0; i < l; i++) {
            var arr1 = arr[i].split(":");
            if (arr1.length != 2) continue;
            var stitle = new Eapi.Str().trim(arr1[0]);
            var svalue = new Eapi.Str().trim(arr1[1]);
            if (stitle == "FONT-WEIGHT" || stitle == "FONT-SIZE" || stitle == "COLOR" || stitle == "FONT-STYLE" || stitle == "FONT-FAMILY" || stitle == "BACKGROUND-COLOR" || stitle == "TEXT-DECORATION") {
                sRet.append(stitle + ":" + svalue + ";");
            }
        }
        return sRet.toString();
    },
    clearPart: function (obj, attrNameJs, attrName) {
        if (typeof (obj) == "undefined" || typeof (attrName) == "undefined") return;
        eval("obj.style." + attrNameJs + "='';");
        var s1 = obj.style.cssText;
        attrName = attrName.toUpperCase();
        obj.style.cssText = RepStr(s1, attrName, "");
    },
    changePosition: function (csstext, propName, adjustValue) {
        var sRet = new Sys.StringBuilder();
        var arr = csstext.split(";");
        var l = arr.length;
        for (var i = 0; i < l; i++) {
            var arr1 = arr[i].split(":");
            if (arr1.length == 2) {
                var stitle = new Eapi.Str().trim(arr1[0]).toUpperCase();
                if (stitle == propName.toUpperCase()) {
                    var svalue = parseInt(new Eapi.Str().trim(arr1[1]));
                    if (isNaN(svalue)) svalue = 0;
                    sRet.append(arr1[0] + ":" + (svalue + adjustValue));
                } else {
                    sRet.append(arr[i]);
                }
            } else {
                sRet.append(arr[i]);
            }
            sRet.append(";");
        }
        return sRet.toString();
    }

}
Eapi.Css.registerClass("Eapi.Css");

Eapi.Upload = function () { }
Eapi.Upload.prototype =
{
    isHave: function () {
        try {
            var s1 = upload1.id;
            if (s1 != "upload1") { return false; }
        } catch (e) {
            return false;
        }
        return true;

    },
    uploadImg: function () {

        var oImg = event.srcElement;
        if (oImg.isContentEditable) return;
        var arr = window.showModalDialog(fcpubdata.path + "/DHCForm/common/uploadimgmain.htm", oImg, "scroll:no;status:no;dialogHeight:150px;dialogWidth:350px;dialogTop:180;dialogLeft:250px");
        if (typeof arr == "undefined") return;
        var ods = $id(fcpubdata.dsMain);
        if (ods != null) {
            ods.Field(oImg.field).Value = arr[2];
            ods.Field(oImg.field).valid = "变";
        }
    }

}
Eapi.Upload.registerClass("Eapi.Upload");

Eapi.GetPos = function () { }
Eapi.GetPos.prototype =
{
    getAbsLeft: function (e) {
        var l = e.offsetLeft;
        while (e = e.offsetParent) {
            if (e.style.position != "absolute") {
                l += e.offsetLeft;
            } else {
                l += e.style.pixelLeft;
            }
        }
        return l;
    },
    getAbsTop: function (e) {
        var t = e.offsetTop;
        while (e = e.offsetParent) {
            if (e.style.position != "absolute") {
                t += e.offsetTop;
            } else {
                t += e.style.pixelTop;
            }
        }
        return t;
    },
    getPosLeft: function (e) {
        var l = e.offsetLeft;
        while (e = e.parentNode) {
            l += e.offsetLeft;
        }
        return l;
    },
    getPosTop: function (e) {
        var t = e.offsetTop;
        while (e = e.parentNode) {
            t += e.offsetTop;
        }
        return t;
    }

}
Eapi.GetPos.registerClass("Eapi.GetPos");

Eapi.Session = function () { }
Eapi.Session.prototype =
{
    setSession: function (strQueryString, callback) {
        if (document.all("ifrSession") == null) {
            document.body.insertAdjacentHTML("BeforeEnd", "<IFRAME id=ifrSession name=ifrSession src='' width=0 height=0></IFRAME>");
        }
        document.all.ifrSession.src = location.protocol + "//" + location.host + fcpubdata.servletPath + "/setSession" + fcpubdata.dotnetVersion + "?" + strQueryString;
        document.all.ifrSession.onreadystatechange = function () {
            if (document.all.ifrSession.readyState != "complete") return;
            if (typeof callback == "function") {
                callback();
            }
        }
    },

    getSession: function (strQueryString, callback) {
        if (typeof callback == "function") {
            if (strQueryString.substring(strQueryString.length - 1, strQueryString.length) != "=") {
                strQueryString = strQueryString + "=";
            }
            if (document.all("ifrSession") == null) {
                document.body.insertAdjacentHTML("BeforeEnd", "<IFRAME id=ifrSession name=ifrSession src='' width=0 height=0></IFRAME>");
            }
            fcpubdata.pubSession = "null";
            document.all.ifrSession.src = location.protocol + "//" + location.host + fcpubdata.servletPath + "/getSession" + fcpubdata.dotnetVersion + "?" + strQueryString;
            document.all.ifrSession.onreadystatechange = function () {
                if (document.all.ifrSession.readyState != "complete") return;
                var arrRet = new Array();
                var arr = fcpubdata.pubSession.split("&");
                var ilen = arr.length;
                for (i = 0; i < ilen; i++) {
                    var arr1 = arr[i].split("=");
                    arrRet[arr1[0]] = arr1[1];
                }
                if (typeof callback == "function") {
                    callback(arrRet);
                }
            }
        } else {
            var arrRet = new Array();
            var arr = parent.fcpubdata.pubSession.split("&");
            var ilen = arr.length;
            for (i = 0; i < ilen; i++) {
                var arr1 = arr[i].split("=");
                arrRet[arr1[0]] = arr1[1];
            }
            return arrRet;
        }
    },
    getSessionOne: function (name) {
        return GetSession(name + "=")[name];
    }

}





var requests = new Array();

if (typeof (XMLHttpRequest) == 'undefined')
    var XMLHttpRequest = function () {
        var request = null;
        try {
            request = new ActiveXObject('Msxml2.XMLHTTP');
            request.setTimeouts(20000, 20000, 50000, 100000);
        }
        catch (e) {
            try {
                request = new ActiveXObject('Microsoft.XMLHTTP');
            }
            catch (ee)
{ }
        }
        return request;
    }

function ajax_stop() {
    for (var i = 0; i < requests.length; i++) {
        if (requests[i] != null) {
            requests[i].obj.abort();
        }
    }
}

function ajax_create_request(context) {
    for (var i = 0; i < requests.length; i++) {
        if (requests[i].readyState == 4) {
            requests[i].abort();
            requests[i].context = null;
            return requests[i];
        }
    }

    var pos = requests.length;
    requests[pos] = Object();
    requests[pos].obj = new XMLHttpRequest();
    requests[pos].context = context;
    return requests[pos];
}

function ajax_request(url, data, callback, context, noRoot) {
    var request = ajax_create_request(context);
    var async = typeof (callback) == 'function';

    if (async) request.obj.onreadystatechange = function () {
        if (request.obj.readyState == 4)
            callback(new ajax_response(request));
    }
    request.obj.open('POST', url, async);
    if (noRoot == "noRoot") {
        request.obj.send(data);
    } else {
        request.obj.send("<root>" + data + "</root>");
    }
    if (!async) {
        var o = new ajax_response(request);
        return o.value;
    }
}

function ajax_response(request) {
    this.request = request.obj;
    this.error = null;
    this.value = null;
    this.context = request.context;
    if (request.obj.status == 200) {
        try {
            this.value = object_from_json(request);
            if (this.value && this.value.error) {
                this.error = this.value.error;
                this.value = null;
            }
        }
        catch (e) {
            this.error = new ajax_error(e.name, e.description, e.number);
        }
    }
    else {
        this.error = new ajax_error('HTTP request failed with status: ' + request.obj.status, request.obj.status);
    }
    return this;
}

function enc(s) {
    return s.toString().replace(/\%/g, "%26").replace(/=/g, "%3D");
}

function object_from_json(request) {
    if (request.obj.responseXML != null && request.obj.responseXML.xml != null && request.obj.responseXML.xml != '')
        return request.obj.responseXML;
    return request.obj.responseText;
}

function ajax_error(name, description, number) {
    this.name = name;
    this.description = description;
    this.number = number;

    return this;
}

ajax_error.prototype.toString = function () {
    return this.name + " " + this.description;
}

function json_from_object(o) {
    if (o == null)
        return 'null';

    switch (typeof (o)) {
        case 'object':
            if (o.constructor == Array) {
                var s = '';
                for (var i = 0; i < o.length; ++i) {
                    s += json_from_object(o[i]);

                    if (i < o.length - 1)
                        s += ',';
                }

                return '[' + s + ']';
            }
            break;
        case 'string':
            return '"' + o.replace(/(["\\])/g, '\\$1') + '"';
        default:
            return String(o);
    }
} var ajaxVersion = '5.6.3.4';

function SendHttp(url, data, callback, context, noRoot) {
    return ajax_request(url, data, callback, context, noRoot);
}

function $id(elementID) {
    return document.getElementById(elementID);
}
///取客户端的当前日期,返回 2008-08-08 格式
function getdate() {
    var curDate = new Date();
    return curDate.format("yyyy-MM-dd");
}
/**
*函数兼容
*@date 2004-03-01
**/
function Trim(strMain) { return new Eapi.Str().trim(strMain); }
function SelectSql(sSql, PageNo, PageSize) { return fc_select(sSql, PageNo, PageSize); }
function InsertSql(sSql) { return fc_insert(sSql); }
function InsertSqls(sSql) { return inserts(sSql); }
function GetDate() { return getdate(); }
function RepStr(mainStr, findStr, replaceStr) { return repStr(mainStr, findStr, replaceStr); }
function IsSpace(strMain) { return isSpace(strMain); }
function RepXml(sSql) { return repXml(sSql); }
function unRepXml(sSql) { return UnRepXml(sSql); }
function Num(str1) { return num(str1); }
function IsTrue(svalue) { return isTrue(svalue); }



//新的兼容函数,2008-01-18

function SaveUserData(Main, Sub, strContent) { return new Eapi.UserData().save(Main, Sub, strContent); }
function LoadUserData(Main, Sub) { return new Eapi.UserData().load(Main, Sub); }
function num(str1) { return new Eapi.Num().toFloat(str1); }
function ToInt(str1) { return new Eapi.Num().toInt(str1); }
function ContDec(sValue, sPointNum) { return new Eapi.Num().format(sValue, sPointNum); }
function isTrue(svalue) { return new Eapi.Str().isTrue(svalue); }
function isSpace(strMain) { return new Eapi.Str().isSpace(strMain); }
function repStr(mainStr, findStr, replaceStr) { return new Eapi.Str().repStr(mainStr, findStr, replaceStr); }
function repNewLine(sRun) { return new Eapi.Str().repNewLine(sRun); }
function unRepNewLine(sRun) { return new Eapi.Str().unRepNewLine(sRun); }
function repXml(sRun) { return new Eapi.Str().repXml(sRun); }
function UnRepXml(sSql) { return new Eapi.Str().unRepXml(sSql); }
function ChangeToBig(value) { return new Eapi.Str().bigMoney(value); }
function SqlToField(sql) { return new Eapi.RunAjax().sqlToField(sql); }
function RepOpenSql(sql, slikevalue) { return new Eapi.Str().repOpenSql(sql, slikevalue); }
function inserts(sSql) { return new Eapi.RunAjax().insertSqls(sSql); }
function fc_insert(sSql) { return new Eapi.RunAjax().insertSql(sSql); }
function fc_select(sSql, PageNo, PageSize) { return new Eapi.RunAjax().selectSql(sSql, PageNo, PageSize); }
function CopyToPub(str) { return new Eapi.Str().copyToPub(str); }
function SetDom(sXml) { return new Eapi.Dom().setDom(sXml); }
function SetDomFile(sPath) { return new Eapi.Dom().setDomFile(sPath); }
function RemoveRoot(strX) { return new Eapi.Str().removeRoot(strX); }
function CssPart(csstext) { return new Eapi.Css().getPart(csstext); }
function ClearCssPart(obj, attrNameJs, attrName) { return new Eapi.Css().clearPart(obj, attrNameJs, attrName); }
function HaveUpload() { return new Eapi.Upload().isHave(); }
function getMaxNo(sTag, strMK) { return new Eapi.RunAjax().getMaxNo(sTag, strMK); }
function getMaxIntNo(sTag) { return new Eapi.RunAjax().getMaxIntNo(sTag); }
function getAbsLeft(e) { return new Eapi.GetPos().getAbsLeft(e); }
function getAbsTop(e) { return new Eapi.GetPos().getAbsTop(e); }
function getPosLeft(e) { return new Eapi.GetPos().getPosLeft(e); }
function getPosTop(e) { return new Eapi.GetPos().getPosTop(e); }
function uploadImg() { return new Eapi.Upload().uploadImg(); }
function SetSession(strQueryString, callback) { return new Eapi.Session().setSession(strQueryString, callback); }
function GetSession(strQueryString, callback) { return new Eapi.Session().getSession(strQueryString, callback); }
function GetSessionOne(name) { return new Eapi.Session().getSessionOne(name); }
function ShowHelp(htmlfile) { return new Eapi.Str().showHelp(htmlfile); }
function ComboToStr(lstSelField2) { return new Eapi.Str().comboToStr(lstSelField2); }

//全局的$函数
function $isTrue(svalue) { return new Eapi.Str().isTrue(svalue); }
function $isSpace(strMain) { return new Eapi.Str().isSpace(strMain); }
function $repStr(mainStr, findStr, replaceStr) { return new Eapi.Str().repStr(mainStr, findStr, replaceStr); }
function $toFloat(str1) { return new Eapi.Num().toFloat(str1); }
function $toInt(str1) { return new Eapi.Num().toInt(str1); }
