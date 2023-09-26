



Eapi.EformEbiao = function () { }
Eapi.EformEbiao.prototype =
{
    appendRow: function (oEbiao, gridDsNo, bInsert) {
        var oDs = this.getGridDs(oEbiao, gridDsNo);
        var curRow = 0;
        if (typeof (bInsert) == "undefined" || bInsert == false || IsSpace(oDs.e_curTd)) {
            curRow = oDs.RecordCount - 1 + ToInt(oDs.e_startRow);
            oDs.Append();
        } else {
            curRow = oDs.e_curTd.parentNode.rowIndex;
            oDs.Append("", curRow - ToInt(oDs.e_startRow));
        }
        var arrTr = this.getTrObjs(oEbiao, curRow);
        if (arrTr != null) this.insertRowSub(oEbiao, arrTr[0], bInsert);
        if (arrTr.length > 1) this.insertRowSub(oEbiao, arrTr[1], bInsert);
        this.fset_cont2(oDs, oEbiao);
        this.refreshContPos(oEbiao);
        this.hideConts(oDs);
    },
    insertRowSub: function (oEbiao, oTr, bInsert) {
        var oTrInsertPos = null;
        if (typeof (bInsert) == "undefined" || bInsert == false) {
            oTrInsertPos = oTr.nextSibling;
        } else {
            oTrInsertPos = oTr;
        }
        var oTrClone = oTr.cloneNode(true);
        if (oTrInsertPos == null) {
            oTr.parentNode.insertBefore(oTrClone);
        } else {
            oTr.parentNode.insertBefore(oTrClone, oTrInsertPos);
        }
    },
    getGridDs: function (oEbiao, gridDsNo) {
        var dsIds = oEbiao.gridDs;
        if (IsSpace(dsIds)) return;
        if (typeof (gridDsNo) == "undefined") gridDsNo = 0;
        var arrDs = dsIds.split(",");
        var oDs = $id(arrDs[gridDsNo]);
        return oDs;
    },
    deleteRow: function (oEbiao, gridDsNo) {
        var oDs = this.getGridDs(oEbiao, gridDsNo);
        if (IsSpace(oDs.e_curTd)) {
            alert("找不到要删除的行,请在要删除的行上点击一下!");
            return;
        }
        var curRow = oDs.e_curTd.parentNode.rowIndex;
        var arrTr = this.getTrObjs(oEbiao, curRow);
        if (arrTr != null) arrTr[0].parentNode.deleteRow(curRow);
        if (arrTr.length > 1) arrTr[1].parentNode.deleteRow(curRow);
        oDs.Delete();
        this.refreshContPos(oEbiao);
        this.hideConts(oDs);
    },
    keypressMove: function () {
        var oCont = event.srcElement;
        var oEbiao = oCont.parentNode;
        if (typeof (oCont.dataset) == "undefined") return;
        var oDs = $id(oCont.dataset);
        if (typeof (oDs.e_curTd) != "undefined") {
            var oTd = oDs.e_curTd;
            var newTd = null;
            var oTable = oTd.parentNode.parentNode.parentNode;
            var colNo = oTd.cellIndex;
            switch (event.keyCode) {
                case 38:
                    if (oTd.parentNode.rowIndex - 1 == ToInt(oDs.e_startRow)) colNo++;
                    if (oTd.parentNode.rowIndex - 1 >= ToInt(oDs.e_startRow)) {
                        newTd = oTable.rows(oTd.parentNode.rowIndex - 1).cells(colNo);
                    }
                    break;
                case 40:
                    if (oTd.parentNode.rowIndex == ToInt(oDs.e_startRow)) colNo--;
                    if (oTd.parentNode.rowIndex + 1 <= ToInt(oDs.e_startRow) + oDs.RecordCount) newTd = oTable.rows(oTd.parentNode.rowIndex + 1).cells(colNo);
                    break;
                case 13:
                    if (oTd.nextSibling == null) {
                        if (oTable.rows.length > oTd.parentNode.rowIndex + 1) newTd = oTable.rows(oTd.parentNode.rowIndex + 1).cells(0);
                    } else {
                        newTd = oTd.nextSibling;
                    }
                    break;
            }
            if (newTd != null) {
                new Eapi.EformEbiao().moveToTd(newTd, oEbiao);
            }
        }
    },
    moveToTd: function (oTd, oEbiao) {
        if (IsSpace(oTd.controlId)) return;
        var oCont = $id(oTd.controlId);
        if (typeof (oCont.dataset) == "undefined") return;
        if (typeof (oTd.isHideCont) != "undefined") return;
        var newRecNo = 0;
        var oDs = $id(oCont.dataset);
        if (typeof (oDs.e_startRow) == "undefined") {
            if (typeof (oDs.e_curTd) != "undefined" && oDs.e_curTd.cellIndex != -1) {
                oDs.e_curTd.innerText = oDs.fset_contall(oDs.Field(oCont.field));
                if (oDs.e_curTd.recNo != oTd.recNo) {
                    oDs.Update();
                }
            }
            newRecNo = ToInt(oTd.recNo);
        } else {
            if (typeof (oDs.e_curTd) != "undefined" && oDs.e_curTd.cellIndex != -1) {
                if (oDs.e_curTd.parentNode.rowIndex != oTd.parentNode.rowIndex) {
                    oDs.Update();
                }
            }
            newRecNo = oTd.parentNode.rowIndex - ToInt(oDs.e_startRow);
        }
        if (oDs.RecNo != newRecNo) oDs.SetPos(newRecNo);
        this.hideConts(oDs);
        this.moveCont(oCont, oTd);
        oDs.e_curTd = oTd;
    },
    fset_cont2: function (oDs, oEbiao) {
        if (typeof (oDs.e_startRow) == "undefined") return;
        var row = ToInt(oDs.e_startRow) + oDs.RecNo;
        var arrCells = this.getTdObjs(oEbiao, row);
        if (arrCells == null) return;
        this.refreshCells(oDs, arrCells[0]);
        if (arrCells.length > 1) this.refreshCells(oDs, arrCells[1]);
    },
    refreshCells: function (oDs, oCells) {
        for (var i = 0; i < oCells.length; i++) {
            if (IsSpace(oCells(i).controlId) == false) {
                var obj = $id(oCells(i).controlId);
                if (obj.dataset == oDs.id) {
                    oCells(i).innerText = oDs.fset_contall(oDs.Field(obj.field));
                }
            }
        }
    },
    getTdObjs: function (oEbiao, row) {
        var arr = this.getTrObjs(oEbiao, row);
        if (arr == null) return null;
        if (arr.length == 1) return [arr[0].cells];
        if (arr.length == 2) return [arr[0].cells, arr[1].cells];
    },
    getTrObjs: function (oEbiao, row) {
        var oArea = this.get4Area(oEbiao);
        var oDivMain = oEbiao.childNodes(0);
        var objRet = null;
        switch (oArea.mode) {
            case 1:
                if (row < oDivMain.childNodes(0).rows.length)
                    objRet = [oDivMain.childNodes(0).rows(row)];
                break;
            case 2:
                var oTab = oDivMain.childNodes(0).childNodes(0);
                if (row >= oTab.rows.length) {
                    row = row - oTab.rows.length;
                    if (row < oDivMain.childNodes(1).childNodes(0).rows.length)
                        objRet = [oDivMain.childNodes(1).childNodes(0).rows(row)];
                } else {
                    objRet = [oTab.rows(row)];
                }
                break;
            case 3:
                var oTab = oDivMain.childNodes(0).childNodes(0);
                if (row < oTab.rows.length) {
                    objRet = [oTab.rows(row), oDivMain.childNodes(1).childNodes(0).rows(row)];
                }
                break;
            case 4:
                var oTab = oDivMain.childNodes(0).childNodes(0);
                if (row >= oTab.rows.length) {
                    row = row - oTab.rows.length;
                    if (row < oDivMain.childNodes(2).childNodes(0).rows.length)
                        objRet = [oDivMain.childNodes(2).childNodes(0).rows(row), oDivMain.childNodes(3).childNodes(0).rows(row)];
                } else {
                    objRet = [oTab.rows(row), oDivMain.childNodes(1).childNodes(0).rows(row)];
                }
                break;
        }
        return objRet;
    },
    hideConts: function (oDs) {
        var sConts = oDs.e_contsId;
        if (IsSpace(sConts)) return;
        var arr = sConts.split(",");
        for (var i = 0; i < arr.length; i++) {
            var o = $id(arr[i]);
            if (o.style.display != "none") {
                o.style.display = "none";
            }
        }
    },
    refreshContPos: function (oEbiao) {
        var sInXml = oEbiao.childNodes(0).dsXml;
        if (typeof (sInXml) != "undefined") {
            sInXml = unescape(sInXml);
            var oXml = SetDom(sInXml);
            var oHide = oXml.documentElement.childNodes(0);
            for (var i = 0; i < oHide.childNodes.length; i++) {
                var sId = oHide.childNodes(i).nodeName;
                var oId = $id(sId);
                if (oHide.childNodes(i).text != "0") {
                    new Eapi.EformEbiao().moveCont(oId, $id("eb_cell_" + sId));
                }
            }
        }

    },
    click: function () {
        var oTd = event.srcElement;
        if (oTd.tagName != "TD") return;
        if (IsSpace(oTd.controlId)) return;
        var oCont = $id(oTd.controlId);
        var oEbiao = oCont.parentNode;
        this.moveToTd(oTd, oEbiao);
    },
    resize: function () {
        var oEbiao = event.srcElement;
        if (oEbiao.style.display == "none" || oEbiao.offsetWidth == 0 || oEbiao.offsetHeight == 0) return;
        var oArea = this.get4Area(oEbiao);
        var oDivMain = oEbiao.childNodes(0);
        if (oArea.mode == 1) return;

        var tmpwidth = oEbiao.offsetWidth - oArea.Area4.offsetLeft;
        if (tmpwidth < 0) tmpwidth = 0;
        oArea.Area4.style.width = tmpwidth;
        var tmpheight = oEbiao.offsetHeight - oArea.Area4.offsetTop;
        if (tmpheight < 0) tmpheight = 0;
        oArea.Area4.style.height = tmpheight;

        if (oArea.Area2 != null) {
            oArea.Area2.style.width = tmpwidth;
            if (oArea.Area4.scrollHeight > 0) {
                oArea.Area2.style.overflowY = "scroll";
            } else {
                oArea.Area2.style.overflowY = "hidden";
            }
        }
        if (oArea.Area3 != null) {
            oArea.Area3.style.height = tmpheight;
            if (oArea.Area4.scrollWidth > 0) {
                oArea.Area3.style.overflowX = "scroll";
            } else {
                oArea.Area3.style.overflowX = "hidden";
            }
        }
    },
    divScroll: function () {
        var Area4 = event.srcElment;
        var Area2 = null;
        var Area3 = null;
        if (Area4.parentNode.childNodes.length == 4) {
            Area2 = Area4.parentNode.childNodes(1);
            Area3 = Area4.parentNode.childNodes(2);
        } else {
            if (Area4.style.pixelTop != 0) {
                Area2 = Area4.parentNode.childNodes(0);
            } else {
                Area3 = Area4.parentNode.childNodes(0);
            }
        }
        if (Area3 != null) Area3.scrollTop = Area4.scrollTop;
        if (Area2 != null) Area2.scrollLeft = Area4.scrollLeft;
    },
    get4Area: function (oEbiao) {
        var mode = 0;
        var Area1 = null;
        var Area2 = null;
        var Area3 = null;
        var Area4 = null;
        var oDivMain = oEbiao.childNodes(0);
        if (oDivMain.childNodes.length <= 1) {
            Area4 = oDivMain;
            mode = 1;
        } else {
            if (oDivMain.childNodes.length == 4) {
                Area1 = oDivMain.childNodes(0);
                Area2 = oDivMain.childNodes(1);
                Area3 = oDivMain.childNodes(2);
                Area4 = oDivMain.childNodes(3);
                mode = 4;
            } else {
                if (Area4.style.pixelTop != 0) {
                    Area2 = oDivMain.childNodes(0);
                    mode = 2;
                } else {
                    Area3 = oDivMain.childNodes(0);
                    mode = 3;
                }
                Area4 = oDivMain.childNodes(1);
            }
        }
        return { mode: mode, Area1: Area1, Area2: Area2, Area3: Area3, Area4: Area4 };
    },
    getEmptyTd: function (oEbiao) {
        var oTable = oEbiao.childNodes(0);
        for (var i = 0; i < oTable.rows.length; i++) {
            for (var j = 0; j < oTable.rows(i).cells.length; j++) {
                if (oTable.rows(i).cells(j).children.length == 0) return oTable.rows(i).cells(j);
            }
        }
        return null;
    },
    tdToObj: function (obj, oTd) {
        switch (obj.controltype) {
            case "label":
                obj.innerText = oTd.innerText;
                break;
            case "button":
                break;
            case "radio":
                SetRadioValue(obj, oTd.innerText);
                break;
            case "checkbox":
                SetCheckBoxValue(obj, oTd.innerText);
                break;
            default:
                obj.value = oTd.innerText;
        }
    },
    moveCont: function (obj, oTd) {
        obj.style.display = "";
        obj.style.position = "absolute";
        var e = oTd;
        var l = e.offsetLeft;
        var t = e.offsetTop;
        while (e = e.offsetParent) {
            if (e.controltype == "ebiao") break;
            if (e.style.position != "absolute") {
                l += e.offsetLeft;
                t += e.offsetTop;
            } else {
                l += e.style.pixelLeft;
                t += e.style.pixelTop;
            }
        }
        obj.style.left = l;
        obj.style.top = t;
        obj.style.width = oTd.offsetWidth;
        obj.style.height = oTd.offsetHeight;
        obj.focus();
    },
    run: function (oEbiao) {
        var sTable = oEbiao.sourTableStr;
        sTable = RepStr(sTable, "&apos;", "'");
        var sParam = oEbiao.runParam;
        if (IsSpace(sParam)) sParam = "";
        var sFixUrl = "&tempfilepath=" + escape(fcpub.tempFilePath);
        var sXml = "<ds>" + getDataSourceInfo(oEbiao.e_datasource) + "</ds><rptStr>" + sTable + "</rptStr>";
        SendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/RunReport" + fcpubdata.dotnetVersion + "?key=calcStr" + sParam + sFixUrl, sXml, function (result) {
            var sRet = result.value;
            var oCont = result.context;
            oCont.insertAdjacentHTML("afterBegin", sRet);
            var sInXml = oCont.childNodes(0).dsXml;
            if (typeof (sInXml) != "undefined") {
                sInXml = unescape(sInXml);
                var oXml = SetDom(sInXml);
                var oHide = oXml.documentElement.childNodes(0);
                for (var i = 0; i < oHide.childNodes.length; i++) {
                    var sId = oHide.childNodes(i).nodeName;
                    var oId = $id(sId);
                    if (oHide.childNodes(i).text == "0") {
                        oId.style.display = "none";
                    } else {
                        oId.style.display = "";
                        new Eapi.EformEbiao().moveCont(oId, $id("eb_cell_" + sId));
                        new Eapi.EformEbiao().tdToObj(oId, $id("eb_cell_" + sId));
                    }
                }
                var oDss = oXml.documentElement.childNodes(1);
                for (var i = 0; i < oDss.childNodes.length; i++) {
                    var sId = oDss.childNodes(i).nodeName;
                    var sDsTr = oDss.childNodes(i).xml;
                    sDsTr = sDsTr.substring(sId.length + 2, sDsTr.length - (sId.length + 3));
                    var oDs = $id(sId);
                    var sDsXml = oDs.oDom.documentElement.childNodes(oDs.oDom.documentElement.childNodes.length - 1).xml;
                    sDsXml = "<root>" + sDsTr + sDsXml + "</root>";
                    oDs.OpenXmlData(sDsXml);
                }
                var oArea = new Eapi.EformEbiao().get4Area(oCont);
                var oDss = oXml.documentElement.childNodes(2);
                var gridds = "";
                for (var i = 0; i < oDss.childNodes.length; i++) {
                    var sId = oDss.childNodes(i).nodeName;
                    var oDs = $id(sId);
                    if (oDss.childNodes(i).childNodes(0).text != "") {
                        if (oArea.mode == 2 || oArea.mode == 4) {
                            oDs.e_startRow = ToInt(oDss.childNodes(i).childNodes(0).text) - oCont.childNodes(0).childNodes(0).childNodes(0).rows.length;
                        } else {
                            oDs.e_startRow = oDss.childNodes(i).childNodes(0).text;
                        }
                        gridds += sId + ",";
                    }
                    oDs.e_contsId = oDss.childNodes(i).childNodes(1).text;
                }
                if (gridds != "") {
                    gridds = gridds.substring(0, gridds.length - 1);
                    oCont.gridDs = gridds;
                }
            }

            oCont.onresize = function () { new Eapi.EformEbiao().resize(); };
            oCont.onclick = function () { new Eapi.EformEbiao().click(); };
        }, oEbiao);
    },
    attachMergeTag: function (sReportXml) {
        var arrRow = new Array();
        var arrData = new Array();

        var oXml = SetDom(sReportXml);
        var oList = oXml.documentElement.selectNodes("//TD[@e_merge!='']");
        var ll = oList.length;
        for (var i = 0; i < ll; i++) {
            var attrValue = oList.item(i).getAttribute("e_merge");
            var arrS = attrValue.split('-');
            var arrSS1 = arrS[0].split(',');
            var arrSS2 = arrS[1].split(',');
            var sRow = 0, sCol = 0, eRow = 0, eCol = 0;
            sRow = ToInt(arrSS1[0]) - 1;
            sCol = ToInt(arrSS1[1]) - 1;
            eRow = ToInt(arrSS2[0]) - 1;
            eCol = ToInt(arrSS2[1]) - 1;
            for (var j = 0; j <= eRow - sRow; j++) {
                var pos = 0;
                if (j > 0 || eCol - sCol > 0) {
                    pos = Array.indexOf(arrRow, j + sRow);
                    if (pos < 0) {
                        arrRow[arrRow.length] = j + sRow;
                        arrData[arrData.length] = new Array();
                        pos = arrRow.length - 1;
                    }
                }
                var k = 0;
                if (j == 0) k = 1;
                for (; k <= eCol - sCol; k++) {
                    var arrCol = arrData[pos];
                    arrCol[arrCol.length] = k + sCol;
                }
            }

        }
        for (var ii = 0; ii < arrRow.length; ii++) {
            var arr1 = arrData[ii];
            arr1.sort();
            var curRow = arrRow[ii];
            for (var jj = 0; jj < arr1.length; jj++) {
                var newCol = arr1[jj];

                var fcNode = oXml.createNode(1, "fc", "");
                var tmpNode = oXml.documentElement.childNodes(1).childNodes(curRow);
                tmpNode.insertBefore(fcNode, tmpNode.childNodes(newCol));
            }
        }
        return oXml.documentElement.xml;
    },
    dragEnter: function () {
        var obj = event.srcElement;
        fcpub.dragTag = 2;
        fcpub.dragInObj = obj;
        if (obj.tagName != "TD") {
            event.returnValue = false;
            fcpub.dragTag = 4;
            return;
        }
        if (obj.children.length > 0) {
            event.returnValue = false;
            fcpub.dragTag = 4;
            return;
        }
        obj.backupValue = obj.innerText;
        obj.innerText = "";
    },
    dragExit: function () {
        if (fcpub.dragTag == 4) {
            event.returnValue = false;
            return;
        }
        if (fcpub.dragTag == 1) {
            event.returnValue = false;
            return;
        }

        var oDrag = event.srcElement;
        var obj = oDrag.parentNode;
        if (typeof (obj.backupValue) != "undefined") {
            obj.innerText = obj.backupValue;
            obj.removeAttribute("backupValue");
        }
    },
    dragStart: function () {
        fcpub.dragTag = 1;
        fcpub.dragInObj = event.srcElement;
    },
    divDrop: function () {
//        if (fcpub) {
//            if (fcpub.dragTag == 1) {
//                event.returnValue = false;
//                fcpub.dragTag = 4;
//                return;
//            }
//        }

    },
    open: function (obj) {
        var oTable = new Object();
        oTable.html = obj.innerHTML;
        var k = 0;
        var arrConts = new Array();
        for (var i = 0; i < oContXml.documentElement.childNodes.length; i++) {
            for (var j = 0; j < oContXml.documentElement.childNodes(i).childNodes.length; j++) {
                var sId = oContXml.documentElement.childNodes(i).childNodes(j).text;
                var oCont = $id(sId);
                if (oCont != null && oCont.parentNode.tagName == "TD") {
                    var o = oCont.parentNode.parentNode.parentNode.parentNode.parentNode;
                    if (o.controltype == "ebiao" && o.id == obj.id) {
                        var oArr = new Object();
                        oArr.cont = oCont;
                        oArr.id = oCont.id;
                        oArr.html = oCont.outerHTML;
                        arrConts[k] = oArr;
                        arrConts[oCont.id] = oArr;
                        k++;
                    }
                }
            }
        }
        oTable.conts = arrConts;
        return oTable;
    },
    ret: function (obj, oRet, oTable) {
        if (typeof (oRet) == "undefined") return;
        obj.innerHTML = oRet.html;
        if (oTable.conts.length == 0) return;
        var oT = obj.childNodes(0);
        for (var i = 0; i < oT.rows.length; i++) {
            for (var j = 0; j < oT.rows(i).cells.length; j++) {
                var oCell = oT.rows(i).cells(j);
                var sId = oCell.eformContId;
                if (typeof (sId) != "undefined") {
                    new Eapi.Css().clearPart(oCell, "backgroundImage", "background-image");
                    new Eapi.Css().clearPart(oCell, "backgroundPosition", "background-position");
                    new Eapi.Css().clearPart(oCell, "backgroundRepeat", "background-repeat");
                    oCell.removeAttribute("eformContId");
                    oCell.backupValue = oCell.innerText;
                    oCell.innerHTML = oTable.conts[sId].html;
                }
            }
        }
        if (TooContXml()) { openobjlist(); }
    },
    load: function (oTable) {

        $id("t").outerHTML = oTable.html;
        var arrConts = oTable.conts;
        for (var i = 0; i < arrConts.length; i++) {
            var oCont = arrConts[i].cont;
            if (IsSpace(oCont.controltype) == false) {
                var oTd = $id("t").rows(oCont.parentNode.parentNode.rowIndex).cells(oCont.parentNode.cellIndex);
                oTd.style.backgroundImage = "url(../ereport/images/ef_ebiao_" + oCont.controltype + ".gif)";
                oTd.style.backgroundPosition = "right";
                oTd.style.backgroundRepeat = "no-repeat";
                oTd.eformContId = oCont.id;
                oTd.innerHTML = "";
                oTd.innerText = oTd.backupValue;
            }
        }
        LoadReportInit();
    },
    save: function () {
        SelObj.curTD.oTD.innerText = txtEdit.value;
        shiftMerge();
        blnChange = false;
        var objRet = new Object();
        var oTab = $id("t");
        oTab.style.position = "static";
        objRet.html = oTab.outerHTML;
        window.returnValue = objRet;
        window.close();
    }
}
Eapi.EformEbiao.registerClass("Eapi.EformEbiao");