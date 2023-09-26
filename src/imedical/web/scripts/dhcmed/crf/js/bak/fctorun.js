



Eform.ToRun = function () { }
Eform.ToRun.prototype =
{
    designStrRunStr: DesignStr_RunStr,
    designStrRunStrBefore: DesignStr_RunStr_Before,
    transAttr: TransAttr,
    openControlNo: OpenControlNo,
    quotXml: quot_xml,
    quot42: quot_42,
    transSql: TransSql,
    hideListBoxSave: HideListBoxSave,
    designStrRunStrAfter: DesignStr_RunStr_After
}
if (Type.parse("Eform.ToRun") == null) Eform.ToRun.registerClass("Eform.ToRun");


function DesignStr_RunStr(sDesign) {
    var pstrUserFunction = "";
    var pstrAddHtml = "";
    var pstrSplitAddHtml = "<p id=splitaddhtml />";
    var sHtm = "";
    var sRet = sDesign;
    var bRunDjFile = false;
    var iEnd = sRet.indexOf("</scr" + "ipt>");
    if (iEnd == -1) {
        pstrUserFunction = "";
        sHtm = sRet;
    } else {
        var sHtm = sRet.substring(iEnd + 9, sRet.length);
        if (isSpace(sHtm)) {
            return "";
        }
        pstrUserFunction = sRet.substring(8, iEnd);
        pstrUserFunction = unRepNewLine(unRepXml(pstrUserFunction));
    }
    var ipos = sHtm.indexOf(pstrSplitAddHtml);
    if (ipos == -1) {
        pstrAddHtml = "";
    } else {
        pstrAddHtml = sHtm.substring(ipos + pstrSplitAddHtml.length, sHtm.length);
        sHtm = sHtm.substring(0, ipos);
    }
    if (sHtm == "") return "";
    document.write("<div id=bigmain>" + sHtm + "</div>");
    fcpubdata.area = $id("SKbillsheet");
    if (oContXml == null) {
        oContXml = SetDom(fcpubdata.area.contxml);
    }

    DesignStr_RunStr_Before(fcpubdata.area);
    fcpubdata.area.removeAttribute("contentEditable");
    fcpubdata.area.removeAttribute("unselectable");
    var sRun = fcpubdata.area.outerHTML;

    sRun = DesignStr_RunStr_After(sRun);

    sRun = "<scr" + "ipt>" + pstrUserFunction + "</scr" + "ipt>" + sRun + pstrAddHtml;
    bigmain.outerHTML = "";
    document.write(sRun);
    return sRun;


}




function DesignStr_RunStr_Before(SKbillsheet) {
    var o = window.document.all.tags("a");
    var l = o.length;
    for (var i = 0; i < l; i++) {
        if (isSpace(o[i].href1) == false) {
            o[i].href = o[i].href1;
        } else {
            var s = o[i].href.toLowerCase();
            var s1 = location.protocol + "//" + location.host + fcpubdata.path;
            s1 = s1.toLowerCase();
            if (s.indexOf(s1) == 0) {
                o[i].href = "../.." + s.substring(s1.length, s.length);
            }
        }
    }

    //这个地方不知道为什么要替换路径，估计是设计时的页面和运行时的页面的目录结构不同造成的
    //但是在前面的图片中，使用的是动态路径，而不是相对路径，这里似乎不需要做什么工作。
    //做了之后会导致图片看不见，先屏蔽掉，日后如果发现不对，再修改过来。  sbin amend 2010-09-20
    //    changesrc("dataset", "../images/ef_designer_dataset.gif");
    //    changesrc("grid", "../images/ef_designer_webgrid.gif");
    //    changesrc("chart", "../images/ef_designer_graph.gif");
    //    changesrc("spin", "../images/ef_designer_numedit.gif");
    //    changesrc("dropdownlist", "../images/ef_designer_fccode.gif");
    //    changesrc("tree", "../images/ef_designer_tree.gif");

//    var o = window.document.all.tags("img");
//    var l = o.length;
//    for (var i = 0; i < l; i++) {
//        var s = o[i].src.toLowerCase();
//        var s1 = location.protocol + "//" + location.host + fcpubdata.path;
//        s1 = s1.toLowerCase();
//        if (s.indexOf(s1) == 0) {
//            o[i].src = "../.." + s.substring(s1.length, s.length);
//        }
//    }

    var o = window.document.all.tags("line");
    var l = o.length;
    for (var i = 0; i < l; i++) {
        o[i].onresize = "";
    }

    function changesrc(comType, srcPath) {
        var oNode = oContXml.documentElement.selectSingleNode(comType);
        if (oNode != null) {
            var l = oNode.childNodes.length;
            for (var i = 0; i < l; i++) {
                var obj = eval(oNode.childNodes(i).text);
                obj.src = srcPath;
            }
        }
    }

}


function TransAttr(obj) {
    if (typeof obj.CustomAttr != "undefined") {
        var sAttr = obj.CustomAttr;
        var re = /\r\n/g;
        sAttr = sAttr.replace(re, " ");
        var sindex = obj.outerHTML.indexOf("CustomAttr=");
        var sBebore = obj.outerHTML.substring(0, sindex);
        var sEnd = obj.outerHTML.substring(sindex, obj.outerHTML.length);
        obj.outerHTML = sBebore + " " + sAttr + " " + sEnd;
        obj = $id(obj.id);
        obj.removeAttribute("CustomAttr");


    }
    //全部放开
    $(obj).attr("onmouseover", "bill_onmouseover()");
    $(obj).attr("onmouseout", "bill_onmouseout()");
    return obj;
}

/*
* 函数作用： 将设计时的控件转化为运行时的控件的后期过程
* 参   数： sRun 设计时的字符串（这个时候已经去掉了contentEditable和unselectable属性）
*          arr  记录当前的控件书目的数组
* 返 回 值： 运行时的html字符串
*/
function DesignStr_RunStr_After(sRun, arr) {
    var isUseMask = false;
    var sAttachEnd = "";
    var basePath = fcpubdata.path + "/" + fcpubdata.root; //为了兼容MVC，使用动态路径，而不使用以前的相对路径 sbin amend 2010-12-28

    if (typeof arr == "undefined") {
        var ArrNum = new Array();
        ArrNum = OpenControlNo(fcpubdata.area.controlno, ArrNum);
    } else {
        var ArrNum = arr;
    }

    var arrtmp = new Array();
    var oNode = oContXml.documentElement.selectSingleNode("dataset");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            var obj = eval(oNode.childNodes(i).text);
            var s1 = imgdataset_dataset(obj);
            arrtmp[i] = s1;
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("grid");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            var obj = eval(oNode.childNodes(i).text);
            var s1 = imgwebgrid_webgrid(obj);
            obj.outerHTML = s1;
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("dataset");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            var obj = eval(oNode.childNodes(i).text);
            obj.outerHTML = arrtmp[i];
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("spin");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (e) {
                continue;
            }
            var sHtml = new Sys.StringBuilder();
            var tmpvalue = "";
            if (IsSpace(obj.value) == false) tmpvalue = obj.value;
            sHtml.append("<div Class='xpSpin'  id=\"" + obj.id + "\" controltype=\"spin\" field=\"" + obj.field + "\" dataset=\"" + obj.dataset + "\"  Min=\"" + obj.Min + "\" value=\"" + tmpvalue + "\" align=\"" + obj.style.textalign);
            if (obj.parentNode.id == "fcpagesub" || obj.parentNode.controltype == "div") {
                sHtml.append(" ParentPos='相对' ");
            }

            sHtml.append("\" style='align:" + obj.style.textalign + "; position:" + obj.style.position + "; left:" + obj.style.left + "; top:" + obj.style.top + "; width:" + obj.style.width + "; height:" + obj.style.height + ";' NextNum=\"" + obj.NextNum + "\" Max=\"" + obj.Max + "\" fontsize=\"" + obj.style.fontSize + "\" fontstyle=\"" + obj.style.fontStyle + "\" fontfamily=\"" + obj.style.fontFamily + "\" backgroundcolor=\"" + obj.style.backgroundColor + "\" color=\"" + obj.style.color + "\" fontweight=\"" + obj.style.fontWeight + "\" enabled=\"" + obj.enabled + "\" display=\"" + obj.style.display + "\" left=\"" + obj.style.left + "\"  top=\"" + obj.style.top + "\" width=\"" + obj.style.width + "\" height=\"" + obj.style.height + "\" ");
            TransAttr1(obj, sHtml);
            sHtml.append(" ></div>");
            obj.outerHTML = sHtml.toString();
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("combobox");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
            var s2 = obj.sql;
            var s3 = SqlPropTrans(s2);
            obj.sql = "";
            obj.sqltrans = s3;
        }
    }
    
    var oNode = oContXml.documentElement.selectSingleNode("button");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("dictionary");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("text");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("listbox");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
            var s2 = obj.sql;
            var s3 = SqlPropTrans(s2);
            obj.sql = "";
            obj.sqltrans = s3;
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("checkboxlist");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
            var s2 = obj.sql;
            var s3 = SqlPropTrans(s2);
            obj.sql = "";
            obj.sqltrans = s3;
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("checkbox");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("a");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("textarea");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            if (obj.induce == "是") isUseMask = true;
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("radio");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("img");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("dbimg");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("div");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("radiolist");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            obj = TransAttr(obj);
            var s2 = obj.sql;
            var s3 = SqlPropTrans(s2);
            obj.sql = "";
            obj.sqltrans = s3;
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("dropdownlist");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            var str = new Sys.StringBuilder();
            str.append("<fc:fc_code id=\"" + obj.id + "\" controltype=\"dropdownlist\" addrow=\"" + obj.addrow + "\"  multiselect=\"" + obj.multiselect + "\"  blninput=\"" + obj.blninput + "\"  enabled=" + obj.disabled + " blnempty=\"" + obj.blnempty + "\"  sqltrans=\"" + SqlPropTrans(obj.sql1) + "\" sql2=\"" + obj.sql2 + "\"   format=\"" + obj.format + "\" visible=\"" + obj.visible + "\" xml=\"" + obj.xml);
            str.append("\" dataset=\"" + obj.dataset + "\" align=\"" + obj.style.textalign + "\" position=\"" + obj.style.position + "\"   field=\"" + obj.field);
            str.append("\" left=\"" + obj.style.pixelLeft + "\"  top=\"" + obj.style.pixelTop + "\" width=\"" + obj.style.pixelWidth + "\" height=\"" + obj.style.pixelHeight + "\" style=\"" + new Eapi.Css().getPart(obj.style.cssText) + "\" ");
            if (obj.parentNode.id == "fcpagesub") {
                str.append(" ParentPos='相对' ");
            }
            var s1 = "";
            if (IsSpace(obj.fc_onclick) == false) {
                s1 = " onclickadd='" + quot_42(obj.fc_onclick) + "'";
            }
            str.append(s1);

            var s2 = "";
            if (IsSpace(obj.onkeydown) == false) {
                s2 = " onkeydown='" + quot_42(obj.onkeydown) + "'";
            }
            str.append(s2);

            var s3 = "";
            if (IsSpace(obj.onclickopen) == false) {
                s3 = " onclickopen='" + quot_42(obj.onclickopen) + "'";
            }
            str.append(s3);

            var s4 = "";
            if (IsSpace(obj.oninterchange) == false) {
                s4 = " oninterchange='" + quot_42(obj.oninterchange) + "'";
            }
            str.append(s4);

            var s5 = "";
            if (IsSpace(obj.onchange) == false) {
                s5 = " onchange='" + quot_42(obj.onchange) + "'";
            }
            str.append(s5);

            var s6 = "";
            if (IsSpace(obj.onselchange) == false) {
                s6 = " onselchange='" + quot_42(obj.onselchange) + "'";
            }
            str.append(s6);

            TransAttr1(obj, str);
            str.append(">");
            str.append("</fc:fc_code>");
            obj.outerHTML = str.toString();
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("tree");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            var sStr = new Sys.StringBuilder();
            sStr.append('<div id="' + obj.id + '" controltype="tree" ');
            sStr.append('sourcetype=' + obj.sourcetype + ' opentb="' + obj.opentb + '" clicknode="' + escape(obj.clicknode) + '" ');
            sStr.append('roottext="' + obj.roottext + '" ');
            sStr.append('xml="' + escape(obj.xml) + '" ');
            sStr.append('ischecked="' + obj.ischecked + '" ');
            sStr.append('xmlpath="' + escape(obj.xmlpath) + '" ');
            sStr.append('isAll="' + obj.isAll + '" ');
            if (IsSpace(obj.sql) == false) {
                sStr.append('sql="' + SqlPropTrans(obj.sql) + '" ');
            }

            if (IsSpace(obj.sql2) == false) {
                sStr.append('sql2="' + SqlPropTrans(obj.sql2) + '" ');
            }
            if (obj.disabled == true) {
                sStr.append('disabled  ');
            }
            TransAttr1(obj, sStr);
            sStr.append('style="OVERFLOW: auto;BORDER-STYLE:' + obj.style.borderStyle + ';position:' + obj.style.position + ';');
            sStr.append('border-width:' + obj.style.borderWidth + ';');
            sStr.append(' background-color:#ffffff; width:' + obj.style.width + '; height:' + obj.style.height + '; left:' + obj.style.left + '; top:' + obj.style.top + '; display:' + obj.style.display + '" ></div>');
            sAttachEnd += '<script language="JavaScript">'
            sAttachEnd += 'var ' + obj.id + ';'
            sAttachEnd += 'window.attachEvent( "onunload", function(){' + obj.id + '=null;})';
            sAttachEnd += '</' + 'script>';
            obj.outerHTML = sStr.toString();
        }
    }

    var oNode = oContXml.documentElement.selectSingleNode("ebiao");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            try {
                var obj = eval(oNode.childNodes(i).text);
            } catch (E) {
                continue;
            }
            var arrDs = new Array();
            var sbConts = new Sys.StringBuilder();
            for (var j = 0; j < oContXml.documentElement.childNodes.length; j++) {
                var sNodeName = oContXml.documentElement.childNodes(j).nodeName;
                if (sNodeName == "ebiao" || sNodeName == "tab") continue;
                for (var k = 0; k < oContXml.documentElement.childNodes(j).childNodes.length; k++) {
                    var oSubCont = $get(oContXml.documentElement.childNodes(j).childNodes(k).text, obj);
                    if (oSubCont == null) continue;
                    var oTd = oSubCont.parentNode;
                    oTd.e_in_id = oSubCont.id;
                    if (IsSpace(oSubCont.dataset) == false) {
                        if (Array.indexOf(arrDs, oSubCont.dataset) == -1) arrDs[arrDs.length] = oSubCont.dataset;
                        oTd.e_in_dataset_id = oSubCont.dataset;
                        var oCurDs = $id(oSubCont.dataset);
                        if (oCurDs.isSubGrid != "是") {
                            oTd.e_in_ext_type = "1";
                        }
                        if (oSubCont.style.display == "none") oTd.e_in_is_hide = "1";
                        var oXml = SetDom(oCurDs.format);
                        for (var ii = 0; ii < oXml.documentElement.childNodes.length; ii++) {
                            if (oXml.documentElement.childNodes(ii).childNodes(0).text.toUpperCase() == oSubCont.field.toUpperCase()) {
                                oTd.e_in_dataset_colno = ii;
                                if (oCurDs.isSubGrid == "是") {
                                    if (oXml.documentElement.childNodes(ii).childNodes(16).text == "是") {
                                        oTd.e_in_ext_type = "2";
                                    } else {
                                        oTd.e_in_ext_type = "3";
                                    }
                                }
                            }
                        }
                    }
                    oSubCont.style.display = "none";
                    sbConts.append(oSubCont.outerHTML);
                    oTd.innerHTML = "";
                    oTd.innerText = oTd.backupValue;
                    oTd.removeAttribute("backupValue");
                }
            }
            var oTable = obj.childNodes(0);
            oTable.e_report_type = "4";
            var sb = new Sys.StringBuilder("<root>");
            for (var jj = 0; jj < arrDs.length; jj++) {
                var oo = _getPrimaryKeys($id(arrDs[jj]));
                sb.append("<ds>");
                sb.append("<id>" + arrDs[jj] + "</id>");
                sb.append("<cols>" + oo.cols + "</cols>");
                sb.append("<keys>" + oo.keys + "</keys>");
                sb.append("</ds>");
            }
            sb.append("</root>");
            if (arrDs.length > 0) oTable.e_in_xml = escape(sb.toString());
            var s1 = e_TransReportStr(oTable, false);
            s1 = new Eapi.EformEbiao().attachMergeTag(s1);
            s1 = RepStr(s1, "'", "&apos;");
            s1 = RepStr(s1, ">\r\n", ">");
            obj.sourTableStr = s1;
            obj.e_datasource = oTable.e_datasource;
            obj.innerHTML = sbConts.toString();
            obj.removeAttribute("ondragstart");
            obj.removeAttribute("ondrop");
            obj.removeAttribute("ondragend");
            obj.removeAttribute("onmovestart");
            obj.fc_onkeydown = "new Eapi.EformEbiao().keypressMove();";
        }
    }

    var obj;
    var l;
    var oNode = oContXml.documentElement.selectSingleNode("tab");
    if (oNode != null) {
        var l = oNode.childNodes.length;
        for (var i = 0; i < l; i++) {
            var obj = eval(oNode.childNodes(i).text)
            var sHtm = new Sys.StringBuilder();

            sHtm.append("<div class=\"tab-pane\" showtype=\"luna\" IsHideTitle=" + obj.IsHideTitle + " id=\"" + obj.id + "\" controltype=\"tab\" style=\"position:absolute;left:" + obj.style.left + ";top:" + obj.style.top + ";width:" + obj.style.width + ";Height:" + obj.style.height + "\"  ");
            TransAttr1(obj, sHtm);
            sHtm.append(" > ");
            var sHeight = obj.style.posHeight - 18;
            var l1 = obj.childNodes(0).rows(0).cells.length;
            for (var j = 0; j < l1; j++) {
                sHtm.append("<div class=\"tab-page\" style=\"width:" + obj.style.width + ";height:" + sHeight + "\" >");
                sHtm.append("<h2 class=\"tab\">" + obj.childNodes(0).rows(0).cells(j).innerText + "</h2>");
                sHtm.append(HideListBoxSave(obj.childNodes(j + 1)));
                sHtm.append("</div>");
            }
            sHtm.append("</div>");
            sHtm.append("<script>");
            sHtm.append("var " + obj.id + " = new WebFXTabPane( document.getElementById( \"" + obj.id + "\" ) );");
            sHtm.append("</scr" + "ipt>");
            obj.outerHTML = sHtm.toString();
        }
    }
    sRun = fcpubdata.area.outerHTML;

    sRun = RepStr(sRun, " fc_onclick=", " onclick=");
    sRun = RepStr(sRun, " fc_ondblclick=", " ondblclick=");
    sRun = RepStr(sRun, " fc_onfocus=", " onfocus=");
    sRun = RepStr(sRun, " fc_onblur=", " onblur=");
    sRun = RepStr(sRun, " fc_onkeydown=", " onkeydown=");
    var stmp11 = "()";
    sRun = RepStr(sRun, " onmove=move" + stmp11, "");
    sRun = RepStr(sRun, " onresize=resize" + stmp11, "");
    sRun = RepStr(sRun, " oncontrolselect=controlselect" + stmp11, "");
    sRun = RepStr(sRun, " onresizeend=resizeEnd" + stmp11 + " onresizestart=resizeStart" + stmp11 + " onmoveend=moveEnd" + stmp11, "");
    var sAttach = new Sys.StringBuilder();
    var sjslib = fcpubdata.area.jslib;
    if (isSpace(sjslib) == false) {
        var arr = sjslib.split("\r\n");
        var l = arr.length;
        for (var i = 0; i < l; i++) {
            if (isSpace(arr[i])) continue;
            //动态路径全部替换为静态相对路径
            //sAttach.append("<script type='text/javascript' src='" + basePath + "/js/" + arr[i] + "'></script>");
            //removed by wuqk 2012-11-13
            //sAttach.append("<script type='text/javascript' src='../../../js/" + arr[i] + "'></script>");
            sAttach.append("<script type='text/javascript' src='../DHCWebForm/js/" + arr[i] + "'></script>");
        }
    }
    //sAttach.append("<link href=../../../css/tabstyle.css type=text/css rel=stylesheet>");
    sAttach.append("<link href=../DHCWebForm/css/tabstyle.css type=text/css rel=stylesheet>");
    if (IsSpace(fcpubdata.area.cssFile) == false) {
        sAttach.append("<link href='" + basePath + fcpubdata.area.cssFile + "' type=text/css rel=stylesheet>");
    }

    var sCode = "<script >document.styleSheets[0].addRule(\"fc\\\\:fc_code\",\"behavior: url(../../../htc/fc_code.htc)\",0);</" + "script>";
    var boolAdded = false;
    var l = oContXml.documentElement.childNodes.length;
    for (var i = 0; i < l; i++) {
        if (oContXml.documentElement.childNodes(i).childNodes.length > 0) {
            var comtype = oContXml.documentElement.childNodes(i).nodeName;
            switch (comtype) {
                case "dropdownlist":
                    if (boolAdded == false) {
                        sAttach.append(sCode);
                        boolAdded = true;
                    }
                    break;
                case "spin":
                    sAttach.append("<script >document.styleSheets[0].addRule(\".xpSpin\",\"behavior: url(../../../htc/NumEdit.htc)\",0);</" + "script>");
                    break;
                case "tab":
                    sAttach.append("<script src='../../../js/webfxlayout.js'></" + "script><link id='luna-tab-style-sheet' type='text/css' rel='stylesheet' href='../../../css/luna/tab.css'  />");
                    break;
                case "grid":
                    sAttach.append("<script >document.styleSheets[0].addRule(\"fc\\\\:webgrid\",\"behavior: url(../../../htc/webgrid.htc)\",0);</" + "script>");
                    sAttach.append("<script src='../../../js/fcwebgrid.js'></" + "script>");
                    if (boolAdded == false) {
                        sAttach.append(sCode);
                        boolAdded = true;
                    }
                    break;
                case "dataset":
                    sAttach.append("<script >document.styleSheets[0].addRule(\"fc\\\\:dataset\",\"behavior: url(../../../htc/dataset.htc)\",0);</" + "script>");
                    sAttach.append("<script src='../../../js/fcdataset.js'></" + "script>");
                    break;
                case "shape":
                    //sAttach.append("<link type='text/css' rel='stylesheet' href='../../../css/shape.css'  />");
                    sAttach.append("<link type='text/css' rel='stylesheet' href='../DHCWebForm/css/shape.css'  />");
                    break;
                case "tree":
                    sAttach.append("<link type='text/css' rel='stylesheet' href='../../../css/xtree.css'  />");
                    sAttach.append("<script src='../../../js/xtree.js'></" + "script>");
                    break;
                case "ebiao":
                    sAttach.append("<script src='../../../js/fcebiao.js'></" + "script>");
                    sAttach.append("<script src='../../../ereport/js/loadreport.js'></" + "script>");
                    break;
                case "upload":
                    sAttach.append("<script src='../../../js/fcupload.js'></" + "script>");
                    break;
                case "chart":
                    sAttach.append("<script src='../../../js/fcgraph.js'></" + "script>");
                    break;
                case "button":
                    sAttach.append("<link type='text/css' rel='stylesheet' href='../../../css/Button.css'/>");
                    break;
                case "text":
                    sAttach.append("<link type='text/css' rel='stylesheet' href='../../../css/TextStyle.css'/>");
                    break;
                case "textarea":
                    if (isUseMask) {
                        sAttach.append("<script >document.styleSheets[0].addRule(\".fcmask\",\"behavior: url(../../../htc/fcmask.htc)\",0);</" + "script>");
                        sAttach.append("<script language='vbscript' src='../../../js/fcmask.vbs'></" + "script>");
                    }
                    break;
                case "ebshow":
                    sAttach.append("<script src='../../../ereport/js/ebshow.js'></" + "script>");
                    break;



            }
        }
    }

    sRun = sAttach.toString() + sRun + sAttachEnd;
    return sRun;

    function _getPrimaryKeys(oDs) {
        var sRet = "";
        var oXml = SetDom(oDs.format);
        for (var ii = 0; ii < oXml.documentElement.childNodes.length; ii++) {
            if (oXml.documentElement.childNodes(ii).childNodes(16).text == "是") {
                sRet += ii + ",";
            }
        }
        if (sRet != "") sRet = sRet.substring(0, sRet.length - 1);
        return { cols: oXml.documentElement.childNodes.length, keys: sRet };
    }
    function _RepStrEnter(sRun, s, sFind, sRep) {
        var ilen = s.length;
        var ipos = sRun.indexOf(s);
        if (ipos > -1) {
            sRun = sRun.substring(0, ipos) + sRep + sRun.substring(ipos + ilen, sRun.length);
        } else {
            ipos = sRun.indexOf(sFind);
            if (ipos > -1) {
                sRun = sRun.substring(0, ipos) + sRep + sRun.substring(ipos + ilen, sRun.length);
            }
        }
        return sRun;
    }

    function imgwebgrid_webgrid(oimgGrid) {
        var sRetDs = "";
        var sRetGrid = new Sys.StringBuilder();
        var sFormat = "";
        var sonSetText = "";
        var sonGetText = "";
        var sonValid = "";
        var sGridFormat = new Sys.StringBuilder();
        var sonclick = new Sys.StringBuilder();
        var sondblclick = new Sys.StringBuilder();
        var sonkeydown = new Sys.StringBuilder();
        sGridFormat.append(" format=\"<cols>");
        sonclick.append(" onclick='bill_ongridclick(\"<" + oimgGrid.id + ">");
        sondblclick.append(" ondblclick='bill_ongriddblclick(\"<" + oimgGrid.id + ">");
        sonkeydown.append(" onkeydown='bill_ongridkeydown(\"<" + oimgGrid.id + ">");
        if (isSpace(oimgGrid.dataset) == false) {
            var ods_formatxml = eval(oimgGrid.dataset);
            if (isSpace(ods_formatxml.formatxml) == false) {
                var oXml = SetDom(ods_formatxml.formatxml);
                var l = oXml.documentElement.childNodes.length;
                for (var i = 0; i < l; i++) {
                    var fdname = oXml.documentElement.childNodes(i).childNodes(0).text;
                    var datatype = oXml.documentElement.childNodes(i).childNodes(2).text;
                    var displaylabel = oXml.documentElement.childNodes(i).childNodes(1).text;
                    var size = oXml.documentElement.childNodes(i).childNodes(3).text;
                    var precision = oXml.documentElement.childNodes(i).childNodes(4).text;
                    if (oXml.documentElement.childNodes(i).childNodes(9).text == "是") {
                        sGridFormat.append("<col>");
                        sGridFormat.append("<fname>" + fdname + "</fname>");
                        sGridFormat.append("<cname>" + displaylabel + "</cname>");
                        sGridFormat.append("<width>" + size + "</width>");
                        sGridFormat.append("<dtype>" + datatype + "</dtype>");
                        sGridFormat.append("<readonly>" + oXml.documentElement.childNodes(i).childNodes(8).text + "</readonly>");
                        sGridFormat.append("<visible>" + oXml.documentElement.childNodes(i).childNodes(9).text + "</visible>");
                        sGridFormat.append("<u></u><v></v><s></s><r></r>");

                        sGridFormat.append("<columnwidth>" + oXml.documentElement.childNodes(i).childNodes(19).text + "</columnwidth>");
                        sGridFormat.append("<align>" + oXml.documentElement.childNodes(i).childNodes(18).text + "</align>");
                        sGridFormat.append("</col>");
                        sonclick.append("<col>" + quot_xml(oXml.documentElement.childNodes(i).childNodes(24).text) + "</col>");
                        sondblclick.append("<col>" + quot_xml(oXml.documentElement.childNodes(i).childNodes(25).text) + "</col>");
                        sonkeydown.append("<col>" + quot_xml(oXml.documentElement.childNodes(i).childNodes(23).text) + "</col>");
                    }


                }
            }
        }
        sGridFormat.append("</cols>\" ");
        sonclick.append("</" + oimgGrid.id + ">\")' ");
        sondblclick.append("</" + oimgGrid.id + ">\")' ");
        sonkeydown.append("</" + oimgGrid.id + ">\")' ");

        sRetGrid.append("<fc:webgrid visible='" + oimgGrid.visible + "' readonly='" + oimgGrid.readonly + "' autoappend='" + oimgGrid.autoappend + "' autowidth='" + oimgGrid.autowidth + "' autoheight='" + oimgGrid.autoheight + "' canselect='" + oimgGrid.canselect + "' " + _GetGridProp("SetRowHeight", oimgGrid.SetRowHeight) + _GetGridProp("hideVscroll", oimgGrid.hideVscroll) + _GetGridProp("hideHscroll", oimgGrid.hideHscroll) + _GetGridProp("autosize", oimgGrid.autosize) + _GetGridProp("bodyrowheight", oimgGrid.bodyrowheight) + _GetGridProp("bodyrows", oimgGrid.bodyrows));
        sRetGrid.append(" id=\"" + oimgGrid.id + "\" controltype=\"grid\" dataset=" + oimgGrid.dataset + " ");
        try {
            if (oimgGrid.parentNode.id == "fcpagesub" || oimgGrid.parentNode.controltype == "div") {
                sRetGrid.append(" ParentPos='相对' ");
            }
        } catch (e) { }
        sRetGrid.append(" left=" + oimgGrid.style.posLeft + " top=" + oimgGrid.style.posTop + " height=" + (oimgGrid.style.posHeight - 17) + " width=" + (oimgGrid.style.posWidth - 17));
        if (oimgGrid.usertitle == "是") {
            sRetGrid.append(" multihead=\"" + oimgGrid.usertitlehtml + "\" ");
            sRetGrid.append(" headrows=\"" + oimgGrid.titlerows + "\" ");
        }
        sRetGrid.append(sGridFormat);
        sRetGrid.append(sonclick);
        sRetGrid.append(sondblclick);
        sRetGrid.append(sonkeydown);
        sRetGrid.append(" >");
        var tabcss = "BORDER-COLLAPSE:collapse;TABLE-LAYOUT:fixed;left:0px;POSITION:absolute;top:0px;";
        var trcss = "";
        var tmps = CssPart(oimgGrid.csstext1);
        if (isSpace(tmps) == false) {
            tabcss += tmps;
        }
        var tmps = CssPart(oimgGrid.csstext2);
        trcss = tmps;
        var tmprowheight = oimgGrid.titlerowheight;
        if (isSpace(tmprowheight) == false) {
            trcss += ";height:" + tmprowheight;
        }


        sRetGrid.append("<table id=t cellPadding=1 cellSpacing=0  frame=box "
+ " style=\"" + tabcss + "\" >"
+ "<tr style=\"" + trcss + " \" class=\"fcGridFirstRow\" ><td></td></tr>"
+ "</table></fc:webgrid>");
        return sRetGrid.toString();
        function _GetGridProp(propName, propValue) {
            var s_SetRowHeight = propValue;
            if (IsSpace(s_SetRowHeight)) {
                s_SetRowHeight = "";
            } else {
                s_SetRowHeight = " " + propName + "='" + s_SetRowHeight + "' ";
            }
            return s_SetRowHeight
        }
    }
    function imgdataset_dataset(oimgGrid) {
        var sRetDs = new Sys.StringBuilder();
        var sRetGrid = "";
        var sFormat = new Sys.StringBuilder();
        var sonSetText = new Sys.StringBuilder();
        var sonGetText = new Sys.StringBuilder();
        var sonValid = new Sys.StringBuilder();
        var sGridFormat = "";
        var sonclick = "";
        var sondblclick = "";
        var sonkeydown = "";
        sRetDs.append("<fc:dataset");
        sRetDs.append(" id=\"" + oimgGrid.id + "\" controltype=\"dataset\"");
        sRetDs.append(" opensortno='" + oimgGrid.opensortno + "'");
        sRetDs.append(" isSubGrid='" + oimgGrid.isSubGrid + "'");
        if (isSpace(oimgGrid.pubpara) == false) {
            sRetDs.append(" pubpara='" + oimgGrid.pubpara + "'");
        }
        if (isSpace(oimgGrid.chnname) == false) {
            sRetDs.append(" chnname='" + oimgGrid.chnname + "'");
        }
        if (isSpace(oimgGrid.fieldtrans) == false) {
            sRetDs.append(" fieldtrans='" + oimgGrid.fieldtrans + "'");
        }
        if (isSpace(oimgGrid.temptable) == false) {
            sRetDs.append(" temptable=" + oimgGrid.temptable);
        }
        if (isSpace(oimgGrid.saveastable) == false) {
            sRetDs.append(" saveastable=" + oimgGrid.saveastable);
        }
        if (isSpace(oimgGrid.BeforeOpen) == false) {
            sRetDs.append(" BeforeOpen='bill_dsevent(\"BeforeOpen\",\"" + quot_42(oimgGrid.BeforeOpen) + "\")'");
        }
        if (isSpace(oimgGrid.AfterOpen) == false) {
            sRetDs.append(" AfterOpen='bill_dsevent(\"AfterOpen\",\"" + quot_42(oimgGrid.AfterOpen) + "\")'");
        }
        if (isSpace(oimgGrid.BeforePost) == false) {
            sRetDs.append(" BeforePost='bill_dsevent(\"BeforePost\",\"" + quot_42(oimgGrid.BeforePost) + "\")'");
        }
        if (isSpace(oimgGrid.AfterPost) == false) {
            sRetDs.append(" AfterPost='bill_dsevent(\"AfterPost\",\"" + quot_42(oimgGrid.AfterPost) + "\")'");
        }
        if (isSpace(oimgGrid.BeforeScroll) == false) {
            sRetDs.append(" BeforeScroll='bill_dsevent(\"BeforeScroll\",\"" + quot_42(oimgGrid.BeforeScroll) + "\")'");
        }
        if (isSpace(oimgGrid.AfterScroll) == false) {
            sRetDs.append(" AfterScroll='bill_dsevent(\"AfterScroll\",\"" + quot_42(oimgGrid.AfterScroll) + "\")'");
        }

        sFormat.append(" format=\"<fields>");
        sonSetText.append(" onSetText='bill_ondatasetsettext(\"<dsid>");
        sonGetText.append(" onGetText='bill_ondatasetgettext(\"<dsid>");
        sonValid.append(" onValid='bill_ondatasetvalid(\"<dsid>");

        if (isSpace(oimgGrid.formatxml) == false) {
            var oXml = SetDom(oimgGrid.formatxml);
            var l = oXml.documentElement.childNodes.length;
            var bln = false;
            if (l > 0) {
                if (oXml.documentElement.childNodes(0).childNodes.length <= 26) bln = true;
            }
            for (var i = 0; i < l; i++) {
                var fdname = oXml.documentElement.childNodes(i).childNodes(0).text;
                var datatype = oXml.documentElement.childNodes(i).childNodes(2).text;
                var displaylabel = oXml.documentElement.childNodes(i).childNodes(1).text;
                var size = oXml.documentElement.childNodes(i).childNodes(3).text;
                var precision = oXml.documentElement.childNodes(i).childNodes(4).text;
                sFormat.append("<field>");
                sFormat.append("<fieldname>" + fdname + "</fieldname>");
                sFormat.append("<datatype>" + datatype + "</datatype>");
                sFormat.append("<displaylabel>" + displaylabel + "</displaylabel>");
                sFormat.append("<size>" + size + "</size>");
                sFormat.append("<precision>" + precision + "</precision>");
                sFormat.append("<fieldkind>" + oXml.documentElement.childNodes(i).childNodes(5).text + "</fieldkind>");
                sFormat.append("<defaultvalue>" + oXml.documentElement.childNodes(i).childNodes(6).text + "</defaultvalue>");
                sFormat.append("<displayformat>" + oXml.documentElement.childNodes(i).childNodes(7).text + "</displayformat>");
                sFormat.append("<isnull>" + oXml.documentElement.childNodes(i).childNodes(11).text + "</isnull>");
                sFormat.append("<iskey>" + oXml.documentElement.childNodes(i).childNodes(10).text + "</iskey>");
                sFormat.append("<valid>" + oXml.documentElement.childNodes(i).childNodes(12).text + "</valid>");
                sFormat.append("<procvalid>" + oXml.documentElement.childNodes(i).childNodes(13).text + "</procvalid>");
                sFormat.append("<link>" + oXml.documentElement.childNodes(i).childNodes(15).text + "</link>");
                sFormat.append("<target>" + oXml.documentElement.childNodes(i).childNodes(16).text + "</target>");
                sFormat.append("<href>" + oXml.documentElement.childNodes(i).childNodes(17).text + "</href>");
                sFormat.append("<visible>" + oXml.documentElement.childNodes(i).childNodes(9).text + "</visible>");
                sFormat.append("<primarykey>" + oXml.documentElement.childNodes(i).childNodes(14).text + "</primarykey>");
                if (bln) {
                    sFormat.append("<fieldvalid></fieldvalid>");
                    sFormat.append("<tag></tag>");
                } else {
                    sFormat.append("<fieldvalid>" + oXml.documentElement.childNodes(i).childNodes(26).text + "</fieldvalid>");
                    sFormat.append("<tag>" + oXml.documentElement.childNodes(i).childNodes(27).text + "</tag>");
                }
                sFormat.append("</field>");
                sonSetText.append("<" + fdname + ">"
+ quot_xml(oXml.documentElement.childNodes(i).childNodes(21).text) + "</" + fdname + ">");
                sonGetText.append("<" + fdname + ">"
+ quot_xml(oXml.documentElement.childNodes(i).childNodes(20).text) + "</" + fdname + ">");
                sonValid.append("<" + fdname + ">"
+ quot_xml(oXml.documentElement.childNodes(i).childNodes(22).text) + "</" + fdname + ">");


            }
        }
        sFormat.append("</fields>\"");
        sonSetText.append("</dsid>\")' ");
        sonGetText.append("</dsid>\")' ");
        sonValid.append("</dsid>\")' ");
        sRetDs.append(sFormat);
        if (isSpace(oimgGrid.opensql) == false) {
            sRetDs.append(" sqltrans=\"" + SqlPropTrans(oimgGrid.opensql) + "\"");
        }
        var oNode = oContXml.documentElement.selectSingleNode("grid");
        if (oNode != null) {
            var l = oNode.childNodes.length;
            for (var i = 0; i < l; i++) {
                var oimgGrid1 = eval(oNode.childNodes(i).text);
                if (oimgGrid1.iscrosstab == "是") {
                    var s1 = new Sys.StringBuilder();
                    s1.append("<sql>" + SqlPropTrans(oimgGrid1.crosstabsql) + "</sql>");
                    s1.append("<no>" + oimgGrid1.crosstabdatatype + "</no>");
                    s1.append("<no>" + oimgGrid1.crosstabsumtype + "</no>");
                    var i1 = 0;
                    if (oimgGrid1.rcount == "是") i1 += 1;
                    if (oimgGrid1.rsum == "是") i1 += 2;
                    if (oimgGrid1.rmin == "是") i1 += 4;
                    if (oimgGrid1.rmax == "是") i1 += 8;
                    if (oimgGrid1.ravg == "是") i1 += 10;
                    var i2 = 0;
                    if (oimgGrid1.ccount == "是") i2 += 1;
                    if (oimgGrid1.csum == "是") i2 += 2;
                    if (oimgGrid1.cmin == "是") i2 += 4;
                    if (oimgGrid1.cmax == "是") i2 += 8;
                    if (oimgGrid1.cavg == "是") i2 += 10;
                    s1.append("<no>" + i1 + "</no>");
                    s1.append("<no>" + i2 + "</no>");
                    s1.append("<format>" + oimgGrid1.crosstabformat + "</format>");
                    s1.append("<rowstr>" + oimgGrid1.rowtitle + "</rowstr>");
                    s1.append("<colstr>" + oimgGrid1.coltitle + "</colstr>");
                    sRetDs.append(" crossvalue=\"" + s1.toString() + "\" ");
                }
            }
        }
        sRetDs.append(sonSetText);
        sRetDs.append(sonGetText);
        sRetDs.append(sonValid);
        sRetDs.append(" ></fc:dataset>");

        return sRetDs.toString();
    }
    function TransAttr1(obj, sHtml) {
        var sAttr = "";
        if (typeof obj.CustomAttr != "undefined") {
            sAttr = obj.CustomAttr;
            var re = /\r\n/g;
            sAttr = sAttr.replace(re, " ");
        }
        sHtml.append(sAttr);

    }

}


function OpenControlNo(s, ArrNum) {
    var arr = s.split(";");
    var l = arr.length;
    for (var i = 0; i < l; i++) {
        var arr1 = arr[i].split(":");
        ArrNum[arr1[0]] = arr1[1];
    }
    return ArrNum;
}

function quot_xml(s) {
    s = RepStr(s, "'", "&amp;quot;");
    return s;

}

function quot_42(s) {
    var s1 = "";
    s = RepStr(s, "'", s1 + "\\42");
    return s;

}



function TransXml(sRun) {
    sRun = RepStr(sRun, "&", "&amp;");
    sRun = RepStr(sRun, ">", "&gt;");
    sRun = RepStr(sRun, "<", "&lt;");
    sRun = RepStr(sRun, "\r\n", "&#13;&#10;");
    if (fcpubdata.databaseTypeName == "sqlserver" || fcpubdata.databaseTypeName == "mysql") sRun = RepStr(sRun, "'", "&apos;&apos;");
    return sRun;

}


function UnTransXml(sRun) {
    sRun = RepStr(sRun, "&amp;", "&");
    sRun = RepStr(sRun, "&gt;", ">");
    sRun = RepStr(sRun, "&lt;", "<");
    sRun = RepStr(sRun, "&#13;&#10;", "\r\n");
    sRun = RepStr(sRun, "&apos;", "'");

    return sRun;

}

function TransSql(sRun) {
    if (fcpubdata.databaseTypeName == "oracle" || fcpubdata.databaseTypeName == "db2") return sRun;
    sRun = RepStr(sRun, "'", "''");
    return sRun;

}


function HideListBoxSave(oPage) {
    var sTag1
    var oList = oPage.all.tags("select")
    var sRet
    var l = oList.length
    for (var i = 0; i < l; i++) {
        if (oList(i).style.posWidth > 0) {
            return oPage.innerHTML;
        } else {
            oList(i).style.width = oList(i).backwidth
            oList(i).style.height = oList(i).backheight
        }
    }
    sRet = oPage.innerHTML;
    for (var i = 0; i < l; i++) {
        oList(i).style.posWidth = 0
        oList(i).style.posHeight = 0
    }
    return sRet
}

function e_savedj() {
    var obj = parent.dialogArguments;
    var arr = DesignDjSave("不提示", "是", "是");
    obj.eform_design = escape(arr[0]);
    obj.eform_run = escape(arr[1]);
    obj.eform_function = escape(arr[2]);
    obj.eform_addhtml = escape(arr[3]);
    blnChange = false;
    parent.close();
}

function e_opendj() {
    var obj = parent.dialogArguments;
    var s1 = obj.eform_design;
    if (typeof s1 == "undefined") s1 = "";
    var s2 = obj.eform_function;
    if (typeof s2 == "undefined") s2 = "";
    var s3 = obj.eform_addhtml;
    if (typeof s3 == "undefined") s3 = "";
    DesignDjOpenSub([new Eapi.Str().trim(unescape(s1)), "", unescape(s2), unescape(s3)]);
    fcpubdata.area.entertype = "展现";
}
