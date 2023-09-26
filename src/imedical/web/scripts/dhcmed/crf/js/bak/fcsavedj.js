


Eapi.SaveForm = function () { }
Eapi.SaveForm.prototype =
{
    SaveBill: SaveBill,
    DelBill: DelBill,
    DelRow: DelRow,
    DelGridRow: DelGridRow,
    MultiDelGridRow: MultiDelGridRow,
    DjSave: DjSave,
    DjSaveShow: DjSaveShow,
    GridSaveShow: GridSaveShow,
    GridSave: GridSave,
    AddBill: AddBill
}
Eapi.SaveForm.registerClass("Eapi.SaveForm");


function SaveBill(iTag, strXmlSql) {
    var d = new Date();
    var t = d.getTime();
    if (NotCanSave()) return "展现状态不能保存";
    var owin = new Eapi.Str().showWait("正在保存......");
    var draftTable = "draft";
    var draftsubTable = "draftsub";
    var draftdescValue = "";
    if (iTag == 5) {
        draftdescValue = window.showModalDialog(fcpubdata.path + "/DHCForm/common/inputmsg.htm", "请输入草稿说明:", "status:no;dialogHeight:105px;dialogWidth:470px;dialogTop:180;dialogLeft:250px");
    }
    var oDsMain = $id(fcpubdata.dsMain);
    if (oDsMain == null) return "只有表单上含有主数据集控件(就是指没有绑定到表格的数据集控件)时才能保存!";
    var arrImgValue = "";
    var arrImgName = "";
    var arrImgChange = "";
    var sProcName = fcpubdata.area.runsave;
    var billkeyfield = fcpubdata.area.keyfield;
    var strRet = "";
    var xmlSql = new Sys.StringBuilder();
    var sInsert = "";
    var s1 = "";
    var gzid = "";
    var tmpTable, saveasTable, xmlFields, oXmlField, arrField, kk, sF, tmp_sF, sV, arri, arrRet, sQuot;
    if ((isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") || iTag == 4) {
        gzid = getgzid();
        if (gzid == fcpubdata.sendHttpErrMsg) return fcpubdata.sendHttpErrMsg;
    }
    if (oDsMain.Empty != "null") {
        if (oDsMain.Update() == 1) {
            new Eapi.Str().showWait("end");
            return "主数据集不能通过数据校验";
        }
        var sTmpErrMsg = validAllForm();
        if (sTmpErrMsg != "") return sTmpErrMsg;

        tmpTable = oDsMain.temptable;
        saveasTable = oDsMain.saveastable;
        if (iTag == 4) saveasTable = "";
        xmlFields = oDsMain.format;
        oXmlField = SetDom(xmlFields);
        arrField = Save_GetFieldArr(oDsMain, oXmlField);
        if (arrField == null) {
            return fcpubdata.sendHttpErrMsg;
        }
        kk = arrField.length;
        sF = Save_GetsF(arrField, oXmlField, "主");
        sV = "";
        var sU = "";
        var ltmp = oDsMain.FieldCount;
        for (var j = 0; j < ltmp; j++) {
            if (oDsMain.Field(j).DataType == "图象") {
                arrImgValue = oDsMain.Field(j).Value;
                arrImgName = oDsMain.Field(j).FieldName;
                arrImgChange = oDsMain.Field(j).valid;
                break;
            }
        }
        for (arri = 0; arri < kk; arri++) {
            i = arrField[arri];
            if (fcpubdata.area.idtype == "3" && fcpubdata.keyValue == "" && oDsMain.Field(i).FieldName.toUpperCase() == fcpubdata.area.keyfield.toUpperCase()) {
                sV += fcpubdata.area.codeheader + ".nextval,";
                continue;
            }
            arrRet = Save_GetsVsU(oDsMain, 0, i, billkeyfield, sV, sU, "是");
            sV = arrRet.sV;
            sU = arrRet.sU;
        }

        if ((isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") || iTag == 4) {
            tmp_sF = InsertTmpTableFields(oDsMain);
            sInsert = "Insert into " + tmpTable + " (" + tmp_sF + "GZID) Values (" + InsertTmpTableSql(oDsMain, oDsMain.RecNo) + "'" + gzid + "')";
            xmlSql.append("<no>" + repXml(sInsert) + "</no>");
            if (fcpubdata.area.idtype == "3" && fcpubdata.keyValue == "") {
                sV = RepStr(sV, fcpubdata.area.codeheader + ".nextval", ":get_keyfield");
            }
        }
        if (isSpace(saveasTable) == false) {
            if (sV.length > 0) sV = sV.substring(0, sV.length - 1);
            if (sU.length > 0) sU = sU.substring(0, sU.length - 1);
            if (fcpubdata.keyValue == "") {
                sInsert = "Insert into " + saveasTable + " (" + sF + ") Values (" + sV + ")";
            } else {
                var sWhere1 = "";
                if (fcpubdata.area.idtype == "5") {
                    sWhere1 = MultiKeyWhere(MultiKeyTmp(oDsMain), oDsMain.RecNo, oDsMain);
                } else {
                    sQuot = "'";
                    if (oDsMain.Field(billkeyfield).DataType == "整数" || oDsMain.Field(billkeyfield).DataType == "实数") sQuot = "";
                    sWhere1 = billkeyfield + "=" + sQuot + fcpubdata.keyValue + sQuot;
                }
                sInsert = "Update " + saveasTable + " set " + sU + " where " + sWhere1;
            }
            xmlSql.append("<no>" + repXml(sInsert) + "</no>");
            if (iTag == 5) {
                sInsert = "Insert into " + draftTable + " (" + sF + ",draftdesc) Values (" + sV + ",'" + draftdescValue + "')";
                xmlSql.append("<no>" + repXml(sInsert) + "</no>");
            }

        }
    }


    var oArrGrid = window.document.all.tags("webgrid");
    for (var iGrid = 0; iGrid < oArrGrid.length; iGrid++) {
        if (oArrGrid[iGrid].readonly == "是") continue;
        var dssub1 = eval("window." + oArrGrid[iGrid].dataset);
        if (dssub1.pubpara == "是") continue;

        if (DsBeforeSave(dssub1, oArrGrid[iGrid])) return;
        var sTmpErrMsg = validDsGrid(dssub1);
        if (sTmpErrMsg != "") {
            alert(sTmpErrMsg);
            return sTmpErrMsg;
        }
        if (SaveBillSub(dssub1, billkeyfield, iTag, xmlSql, sProcName) == false) continue;

    }
    var arrDss = fcpubdata.controls["dataset"];
    for (var iEbiao = 0; iEbiao < arrDss.length; iEbiao++) {
        if (arrDss[iEbiao].isSubGrid == "是") {
            if (arrDss[iEbiao].Update() == 1) return;
            if (SaveBillSub(arrDss[iEbiao], billkeyfield, iTag, xmlSql, sProcName) == false) continue;
        }
    }
    if (iTag != 4) {
        if (isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") {
            xmlSql.append("<runsave>{ call " + repXml(new Eapi.Str().trim(sProcName)) + "(?,?) };" + fcpubdata.area.dj_sn + ";" + gzid + "</runsave>");
        }
        if (isSpace(strXmlSql) == false) {
            xmlSql.append(strXmlSql);
        }
    } else {
        var sName = window.showModalDialog(fcpubdata.path + "/DHCForm/common/inputmsg.htm", "请输入挂帐说明:", "status:no;dialogHeight:105px;dialogWidth:470px;dialogTop:180;dialogLeft:250px");
        s1 = "insert into billgz (gzid,sgzname,sgzdate,semployeeid,sbilltag) values ('" + gzid + "','" + sName + "','" + curDateTime() + "','" + getuser() + "','" + fcpubdata.area.codeheader + "')";
        xmlSql.append("<no>" + s1 + "</no>");
    }

    var strHead = "";
    if (fcpubdata.keyValue == "") {
        var sidtype = fcpubdata.area.idtype;
        if (isSpace(sidtype)) sidtype = "";
        if (sidtype == "4" || sidtype == "5") {
            var tmp1 = "";
            try {
                tmp1 = oDsMain.Field(fcpubdata.area.keyfield).Value;
            } catch (e) { }
            strHead = "<fc" + tmp1 + ">" + fcpubdata.area.codeheader + "</fc" + tmp1 + ">";
        } else {
            if (sidtype == "1" || sidtype == "") {
                if (IsSpace(fcpubdata.area.keyfield) == false) {
                    if (oDsMain.Field(fcpubdata.area.keyfield).DataType == "整数") {
                        sidtype = "7";
                    }
                }
            }
            strHead = "<add" + sidtype + ">" + fcpubdata.area.codeheader + "</add" + sidtype + ">";
        }
    } else {
        strHead = "<fc" + fcpubdata.keyValue + ">" + fcpubdata.area.codeheader + "</fc" + fcpubdata.keyValue + ">";
    }

    strHead += xmlSql.toString();
    var blnOk = "";
    var strReturn = "";
    var sRet = djupdate(strHead);
    if (sRet == fcpubdata.sendHttpErrMsg) return fcpubdata.sendHttpErrMsg;
    if (isSpace(sRet) == false) {
        strRet = sRet;
    }
    if (iTag != 4 && isSpace(sProcName) == false && isSpace(oDsMain.temptable) == false) {
        xmlSql.clear();
        xmlSql.append("<no>" + "delete from " + oDsMain.temptable + " where GZID='" + gzid + "'" + "</no>");
        try {
            if (oArrGrid.length > 0 && isSpace(dssub1.temptable) == false)
                xmlSql.append("<no>" + "delete from " + dssub1.temptable + " where GZID='" + gzid + "'" + "</no>");
        } catch (e) { }
        var sRet1 = inserts(xmlSql.toString());
        if (isSpace(sRet1) == false) {
            alert(sRet1);
        }
    }

    if (sRet.indexOf('错误:') < 0) {
        if (arrImgValue != "" && arrImgChange == "变") {
            var stable = fcpubdata.area.mastertable;
            if (IsSpace(stable)) stable = oDsMain.saveastable;
            if (isSpace(stable)) {
                var stip1 = "请设置" + fcpubdata.dsMain + "的保存表名!";
                alert(stip1);
                return stip1;
            }

            var sRet11 = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/imagefield" + fcpubdata.dotnetVersion + "?key=writeimage&sTablename=" + stable + "&sImgname=" + arrImgName + "&sKeyname=" + fcpubdata.area.keyfield + "&sKeyvalue=" + strRet + "&sKeyname1=" + escape(fcpubdata.path) + "&sKeyvalue1=" + escape(arrImgValue), "");
            if (IsSpace(sRet11) == false) {
                alert(sRet11);
                return sRet11;
            } else {
                oDsMain.Field(arrImgName).valid = "";
            }
        }

        if (HaveUpload() == true) upload_save(strRet);

        blnOk = "ok";
        if (oDsMain.Empty != "null" && fcpubdata.area.keyfield != "") {
            oDsMain.bEdit = true;
            oDsMain.Field(fcpubdata.area.keyfield).Value = strRet;
            oDsMain.Update();
            oDsMain.fset_cont1();
        }
    } else {
        strReturn = strRet + " 运行的命令为: " + strHead;
        alert(strRet);
        return strReturn;
    }

    try {
        fcpubdata.keyValue = oDsMain.Field(fcpubdata.area.keyfield).Value;
    } catch (e) { }
    oDsMain.bAdd = false;
    oDsMain.bEdit = false;

    new Eapi.Str().showWait("end");
    fcpubdata.isEdit = false;

    if (iTag == 1) {
        window.returnValue = "ok";
        CloseBill();
        return strReturn;
    }
    if (iTag == 3) {
        AddBill();
        return strReturn;
    }

    if (iTag == 2) {
        return strReturn;
    }

    d = new Date();
    var t1 = d.getTime();

    if (blnOk == "ok") {

        CloseBill();
    }
    return strReturn;
}
function SaveBillSub(dssub1, billkeyfield, iTag, xmlSql, sProcName) {


    if (IsSpace(dssub1.otherkey)) {
        billkeyfield = fcpubdata.area.keyfield;
    } else {
        billkeyfield = dssub1.otherkey;
    }
    tmpTable = dssub1.temptable;
    saveasTable = dssub1.saveastable;
    if (iTag == 4) saveasTable = "";
    var sOtherSave = false;
    if (isSpace(saveasTable) == false && fcpubdata.keyValue != "" && fcpubdata.area.OtherSave == "是") {
        xmlSql.append(SubTableEditSave(dssub1, billkeyfield));
        sOtherSave = true;
    } else {
        dssub1.ReSum();


        if (isSpace(saveasTable) == false && fcpubdata.keyValue != "") {
            sQuot = "'";
            if (dssub1.Field(billkeyfield).DataType == "整数" || dssub1.Field(billkeyfield).DataType == "实数") sQuot = "";
            sInsert = "delete from " + saveasTable + " where " + billkeyfield + "=" + sQuot + fcpubdata.keyValue + sQuot;
            xmlSql.append("<no>" + repXml(sInsert) + "</no>");
        }

        var sSubKeyFieldName = getSubKeyName(dssub1, billkeyfield);
        xmlFields = dssub1.format;
        oXmlField = SetDom(xmlFields);
        arrField = Save_GetFieldArr(dssub1, oXmlField);
        if (arrField == null) {
            return false;
        }
        kk = arrField.length;
        sF = Save_GetsF(arrField, oXmlField, "从");
        if ((isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") || iTag == 4) {
            tmp_sF = InsertTmpTableFields(dssub1);
        }
        var ll = dssub1.RecordCount;
        for (var ii = 0; ii < ll; ii++) {
            if (dssub1.oDom.documentElement.childNodes(ii).getAttribute("rowstate") == "new") continue;
            sV = "";
            for (arri = 0; arri < kk; arri++) {
                i = arrField[arri];
                arrRet = Save_GetsVsU(dssub1, ii, i, billkeyfield, sV, "", "从", sSubKeyFieldName);
                sV = arrRet.sV;
            }

            if ((isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") || iTag == 4) {
                sInsert = "Insert into " + tmpTable + " (" + tmp_sF + "GZID) Values (" + InsertTmpTableSql(dssub1, ii) + "'" + gzid + "')";
                xmlSql.append("<no>" + repXml(sInsert) + "</no>");
            }
            if (isSpace(saveasTable) == false) {

                if (sV.length > 0) {
                    sV = sV.substring(0, sV.length - 1);
                }
                sInsert = "Insert into " + saveasTable + " (" + sF + ") Values (" + sV + ")";
                xmlSql.append("<no>" + repXml(sInsert) + "</no>");
                if (iTag == 5) {
                    sInsert = "Insert into " + draftsubTable + " (" + sF + ") Values (" + sV + ")";
                    xmlSql.append("<no>" + repXml(sInsert) + "</no>");
                }
            }
        }
    }

    return true;
}

function getgzid() {
    return new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?getRecnum", "<no>LGZ</no>");
}


function djupdate(sSql) {
    return new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?djupdate", sSql);
}

function savegrid(sSql) {
    return new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?savegrid", sSql);
}


function TmpTableAddField(tmpTable, sF, sV, gzid) {
    sF = sF + ",";
    var oDsMain = $id(fcpubdata.dsMain);
    var sInsert = "Insert into " + tmpTable + " (" + sF + "GZID) Values (" + sV + "'" + gzid + "')";

    var sFadd = "";
    var sVadd = "";
    var s11 = oDsMain.format;
    if (isSpace(s11) == false) {
        var oXml = new ActiveXObject("Microsoft.XMLDOM");
        oXml.async = false;
        oXml.loadXML(s11);
        var oList = oXml.documentElement.selectNodes("//field[fieldkind='临时计算项']");
        for (var iList = 0; iList < oList.length; iList++) {
            var sExp = oList.item(iList).childNodes(6).text;
            var sFieldName = oList.item(iList).childNodes(0).text;
            var vValue = eval(sExp);
            sFadd += sFieldName + ",";
            sVadd += "'" + vValue + "',";
        }
        sInsert = "Insert into " + tmpTable + " (" + sF + sFadd + "GZID) Values (" + sV + sVadd + "'" + gzid + "')";
    }
    return sInsert;
}

function DelBill() {
    if (NotCanSave()) return;
    var ret = window.confirm("确定删除吗？");
    if (ret == false) {
        return;
    }
    var oDsMain = $id(fcpubdata.dsMain);
    if (oDsMain == null) {
        alert("请在表单模版上增加一个主数据集控件(指没有绑定到表格控件的数据集控件)后再试此功能");
        return;
    }
    var sTable = fcpubdata.area.mastertable;
    if (isSpace(sTable)) sTable = oDsMain.saveastable;
    if (isSpace(sTable)) {
        alert("请设置" + fcpubdata.dsMain + "的保存表名!");
        return;
    }
    var sdjbh = oDsMain.Field(fcpubdata.area.keyfield).Value;
    var sInsert = "update " + sTable + " set beactive='否'" + " where " + fcpubdata.area.keyfield + "='" + sdjbh + "'";
    var sRet = fc_insert(sInsert);
    if (isSpace(sRet) == false) {
        alert(sRet);
    } else {
        oDsMain.Delete();
        AddBill();
    }
}

function DelRow(dsGrid) {
    if (NotCanSave()) return;
    var ret = window.confirm("确定删除当前行吗？");
    if (ret == false) {
        return;
    }
    if (arguments.length == 0)
        dsGrid = dssub1;
    var sTable = fcpubdata.area.mastertable;
    if (isSpace(sTable)) {
        sTable = dsGrid.saveastable;
    }
    if (isSpace(sTable)) {
        alert("请设置表格数据集的另存表名!");
        return;
    }
    var arr = MultiKeyTmp(dsGrid);
    var sWhere = "";
    sWhere = MultiKeyWhere(arr, dsGrid.RecNo, dsGrid);
    if (isSpace(sWhere)) {
        var sdjbh = dsGrid.Field(fcpubdata.area.keyfield).Value;
        sWhere = fcpubdata.area.keyfield + "='" + sdjbh + "'";
    }


    var sInsert = "update " + sTable + " set beactive='否'" + " where " + sWhere;
    var sRet = fc_insert(sInsert);
    if (isSpace(sRet) == false) {
        alert(sRet);
    } else {
        dsGrid.Delete();
    }
}

function DelGridRow(dsGrid) {
    if (NotCanSave()) return;
    var ret = window.confirm("确定删除当前行吗？");
    if (ret == false) {
        return;
    }

    if (arguments.length == 0) {
        dsGrid = dssub1;
    }
    var sTable = dsGrid.saveastable;
    var arr = MultiKeyTmp(dsGrid);
    var sWhere = "";
    sWhere = MultiKeyWhere(arr, dsGrid.RecNo, dsGrid);
    if (isSpace(sWhere)) {
        var sdjbh = dsGrid.Field(fcpubdata.area.keyfield).Value;
        var sQuot = "'";
        if (dsGrid.Field(fcpubdata.area.keyfield).DataType == "整数" || dsGrid.Field(fcpubdata.area.keyfield).DataType == "实数") {
            sQuot = "";
        }
        sWhere = fcpubdata.area.keyfield + "=" + sQuot + sdjbh + sQuot;
    }
    var sInsert = "delete from " + sTable + " where " + sWhere;
    var sRet = fc_insert(sInsert);
    if (isSpace(sRet) == false) {
        alert(sRet + " 运行的命令为: " + sInsert);
    } else {
        dsGrid.Delete();
    }
}

function MultiDelGridRow(dsGrid, iMultiSelCol) {
    if (NotCanSave()) return;
    var ret = window.confirm("确定删除吗？");
    if (ret == false) {
        return;
    }

    if (arguments.length == 0) {
        dsGrid = dssub1;
    }
    if (typeof iMultiSelCol == "undefined") iMultiSelCol = 0;
    var sTable = dsGrid.saveastable;
    var arr = MultiKeyTmp(dsGrid);
    var sWhere = "";
    var l = dsGrid.oDom.documentElement.childNodes.length - 1;
    for (var i = 0; i < l; i++) {
        if (dsGrid.oDom.documentElement.childNodes(i).childNodes(iMultiSelCol).text == "是") {
            var sWhere1 = MultiKeyWhere(arr, i, dsGrid);
            if (isSpace(sWhere1)) {
                var sdjbh = dsGrid.oDom.documentElement.childNodes(i).childNodes(dsGrid.FieldNameToNo(fcpubdata.area.keyfield)).text;
                var sQuot = "'";
                if (dsGrid.Field(fcpubdata.area.keyfield).DataType == "整数" || dsGrid.Field(fcpubdata.area.keyfield).DataType == "实数") {
                    sQuot = "";
                }
                sWhere1 = fcpubdata.area.keyfield + "=" + sQuot + sdjbh + sQuot;
            }
            if (IsSpace(sWhere1) == false) {
                sWhere += "(" + sWhere1 + ") or ";
            }
        }
    }
    if (sWhere != "") {
        sWhere = sWhere.substring(0, sWhere.length - 3);
    }
    var sInsert = "delete from " + sTable + " where " + sWhere;
    var sRet = fc_insert(sInsert);
    if (isSpace(sRet) == false) {
        alert(sRet + " 运行的命令为: " + sInsert);
    } else {
        dsGrid.Open();
    }
}


function table_have_field1(tablename) {
    var sXml = dataset_select("select * from " + tablename + " where 1=2", 1, 1);
    if (sXml == fcpubdata.sendHttpErrMsg) return fcpubdata.sendHttpErrMsg;
    var oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML(sXml);
    if (oXml.documentElement == null) {
        alert("很可能是数据库中无" + tablename + "表,或者是select * from " + tablename + " where 1=2 执行出错!");
        return;
    }
    var sFields = oXml.documentElement.childNodes(0).childNodes(1).xml;
    oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML(sFields);
    return oXml;
}
function table_have_field2(oXml, fieldname) {
    var oNode = oXml.documentElement.selectSingleNode("field[fieldname='" + fieldname.toLowerCase() + "']");
    if (oNode == null)
        return false;
    else
        return true;
}

function SaveOneGrid(sExit, ogridDs, strXmlSql) {
    if (NotCanSave()) return;
    var oDs;
    if (typeof ogridDs == "undefined") {
        oDs = dssub1;
    } else {
        oDs = ogridDs;
    }





    if (typeof (oDs.isSubGrid) == "undefined") {
        if (DsBeforeSave(oDs)) return;
        var sTmpErrMsg = validDsGrid(oDs);
        if (sTmpErrMsg != "") {
            alert(sTmpErrMsg);
            return sTmpErrMsg;
        }
    } else {
        if (oDs.Update() == 1) return;
    }
    var billkeyfield = fcpubdata.area.keyfield;
    var sProcName = fcpubdata.area.runsave;
    oDs.dset_cont();
    var saveasTable = oDs.saveastable;
    if (isSpace(saveasTable)) {
        alert("数据集" + oDs.id + "的保存表名不能为空!");
        return;
    }
    var tmpTable = oDs.temptable;
    if (isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") {
        var gzid = getgzid();
        if (gzid == fcpubdata.sendHttpErrMsg) return fcpubdata.sendHttpErrMsg;
        var tmp_sF = InsertTmpTableFields(oDs);
    }
    var xmlFields = oDs.format;
    var oXmlField = SetDom(xmlFields);
    var arrField = Save_GetFieldArr(oDs, oXmlField);
    if (arrField == null) {
        return fcpubdata.sendHttpErrMsg;
    }
    var fieldLen = arrField.length;
    var sF = Save_GetsF(arrField, oXmlField);
    var arr = MultiKeyTmp(oDs);

    var xmlSql = new Sys.StringBuilder();
    var ll = oDs.RecordCount;
    for (var ii = 0; ii < ll; ii++) {

        if (oDs.oDom.documentElement.childNodes(ii).getAttribute("rowstate") == "add" || oDs.oDom.documentElement.childNodes(ii).getAttribute("rowstate") == "edit") {
            var sWhere = "";
            var sV = "";
            var sU = "";
            for (var arri = 0; arri < fieldLen; arri++) {
                i = arrField[arri];
                var arrRet = Save_GetsVsU(oDs, ii, i, billkeyfield, sV, sU);
                sV = arrRet.sV;
                sU = arrRet.sU;
            }
            if (sV.length > 0) sV = sV.substring(0, sV.length - 1);
            if (sU.length > 0) sU = sU.substring(0, sU.length - 1);
            if (isSpace(saveasTable) == false) {
                sWhere = MultiKeyWhere(arr, ii, oDs);
                var s11111 = "";
                if (isSpace(sWhere)) {
                    try {
                        s11111 = oDs.oDom.documentElement.childNodes(ii).childNodes(oDs.FieldNameToNo(billkeyfield)).text;
                    } catch (e) { };
                    sWhere = billkeyfield + "='" + s11111 + "'";
                }
                if (isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") {
                    var sInsert = "Insert into " + tmpTable + " (" + tmp_sF + "GZID) Values (" + InsertTmpTableSql(oDs, ii) + "'" + gzid + "')";
                    xmlSql.append("<no>" + repXml(sInsert) + "</no>");
                }
                var s11 = fc_select("select * from " + saveasTable + " where " + sWhere, 1, 1);
                var sHave = "存在";
                if (s11.length < 16) sHave = "不存在";

                if (sHave == "不存在" || oDs.oDom.documentElement.childNodes(ii).getAttribute("rowstate") == "add") {
                    if (fcpubdata.area.idtype == "3") {
                        sV = RepStr(sV, ":get_keyfield", fcpubdata.area.codeheader + ".nextval");
                    }
                    sInsert = "Insert into " + saveasTable + " (" + sF + ") Values (" + sV + ")";
                    var sstmp1 = fcpubdata.area.codeheader;
                    if (isSpace(sstmp1)) sstmp1 = "no";
                    if (fcpubdata.area.idtype == "6" || fcpubdata.area.idtype == "8") {
                        sstmp1 = "runsave" + fcpubdata.area.idtype + fcpubdata.area.codeheader;
                    } else if ((fcpubdata.area.idtype == "1" || fcpubdata.area.idtype == "") && IsSpace(fcpubdata.keyfield) == false) {
                        if (oDs.Field(fcpubdata.keyfield).DataType == "整数") {
                            sstmp1 = "runsave7" + fcpubdata.area.codeheader;
                        }
                    }
                    xmlSql.append("<" + sstmp1 + ">" + repXml(sInsert) + "</" + sstmp1 + ">");
                } else {
                    var sUpdate = "Update " + saveasTable + " Set " + sU + " where " + sWhere;
                    xmlSql.append("<no>" + repXml(sUpdate) + "</no>");
                }
            }
        }
    }
    if (isSpace(sProcName) == false) {
        xmlSql.append("<runsave>{ call " + repXml(new Eapi.Str().trim(sProcName)) + "(?,?) };" + fcpubdata.area.dj_sn + ";" + gzid + "</runsave>");
    }
    if (IsSpace(strXmlSql) == false) {
        xmlSql.append(strXmlSql);
    }
    if (xmlSql.isEmpty()) return;
    var sRet = "";
    var sRet1 = savegrid(xmlSql.toString());
    if (isSpace(sRet1) == false) {
        sRet = sRet1 + " 运行的命令为: " + xmlSql;
        alert(sRet);
    } else {
        fcpubdata.isEdit = false;
        ClearEditTag(oDs);
        alert("保存成功！");
    }
    if (isSpace(sProcName) == false && fcpubdata.databaseTypeName != "mysql") {
        sRet1 = inserts("<no>" + "delete from " + tmpTable + " where GZID='" + gzid + "'" + "</no>");
        if (isSpace(sRet1) == false) {
            alert(sRet1);
        }
    }
    if (sExit == "退出") {
        window.returnValue = "ok";
        CloseBill();
    }
    return sRet;
}

function ClearEditTag(oDs) {
    for (var ii = 0; ii < oDs.RecordCount; ii++) {
        oDs.oDom.documentElement.childNodes(ii).setAttribute("rowstate", "");
    }
}

function MultiKeyTmp(dssub1) {
    var arr = new Array();
    var xmlFields = dssub1.format;
    var oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML(xmlFields);
    var oList = oXml.documentElement.selectNodes("//field[primarykey='是']");
    for (var iList = 0; iList < oList.length; iList++) {
        var sFieldName = oList.item(iList).childNodes(0).text;
        var no = dssub1.FieldNameToNo(sFieldName);
        arr[iList] = no;
    }
    return arr;
}

function MultiKeyWhere(arr, curRecNo, dssub1) {
    var sWhere = "";
    for (var i = 0; i < arr.length; i++) {
        var sQuot = "'";
        if (dssub1.oDataField.childNodes(arr[i]).childNodes(1).text == "整数" || dssub1.oDataField.childNodes(arr[i]).childNodes(1).text == "实数") sQuot = "";
        sWhere += dssub1.oDataField.childNodes(arr[i]).childNodes(0).text + "=" + sQuot
+ dssub1.oDom.documentElement.childNodes(curRecNo).childNodes(arr[i]).text + sQuot + " and ";
    }
    if (sWhere != "") {
        sWhere = sWhere.substring(0, sWhere.length - 4);
    }
    return sWhere;
}


function NotCanSave() {
    if (parent.piAction == 3) {
        alert("单据展现状态,不能保存!");
        return true;
    }
    return false;
}

function DjSave(sExit) {
    var sRet = "";
    if (sExit == "退出") {
        sRet = SaveBill(1);
    } else if (typeof (sExit) == "undefined") {
        sRet = SaveBill(2);
    } else {
        sRet = SaveBill(2, sExit);
    }
    return sRet;
}

function DjSaveShow() {
    var b = DjSave(); if (IsSpace(b)) { alert('保存成功') } else { alert(b) }
}

function GridSaveShow(odsgrid) {
    var b = GridSave(odsgrid); if (IsSpace(b)) {
    } else { alert(b) }
}


function GridSave(odsgrid, sExit) {
    if (sExit == "退出" || typeof (sExit) == "undefined")
        return SaveOneGrid(sExit, odsgrid);
    else
        return SaveOneGrid("", odsgrid, sExit);
}

function RepUpdateSql(svalue) {
    var sRet = repStr(svalue, "'", "''");
    return sRet;
}


function AddBill() {
    var oDsMain = $id(fcpubdata.dsMain);
    if (oDsMain == null) {
        alert("请在表单模版上增加一个主数据集控件(指没有绑定到表格控件的数据集控件)后再试此功能");
        return;
    }
    var sErr = oDsMain.OpenEmpty();
    var o = window.document.all.tags("dataset");
    for (var ii = 0; ii < o.length; ii++) {
        if (o[ii].id != fcpubdata.dsMain) {
            o[ii].PageSize = -1;
            sErr = o[ii].OpenEmpty();
        }
    }
    fcpubdata.keyValue = "";

}

function BeforeSaveFieldTrans(sXml, fieldname, fieldvalue, mRecNo) {
    if (isSpace(sXml)) return fieldvalue;
    var oXml = SetDom(sXml);
    var l = oXml.documentElement.childNodes.length;
    for (var i = 0; i < l; i++) {
        if (oXml.documentElement.childNodes(i).childNodes(0).text == fieldname) {
            var ss = unescape(oXml.documentElement.childNodes(i).childNodes(1).text);
            ss = eval(ss);
            return ss;
        }
    }
    return fieldvalue;
}

function ReAllLineSum(dssub1) {
    var tmpNo = dssub1.RecNo;
    for (var i = 0; i < dssub1.RecordCount; i++) {
        dssub1.LineSum(null, i);
    }
    dssub1.RecNo = tmpNo;

}



function getSubKeyName(dssub1, MainKey) {
    var xmlFields = dssub1.format;
    var oXml = new ActiveXObject("Microsoft.XMLDOM");
    oXml.async = false;
    oXml.loadXML(xmlFields);
    var oList = oXml.documentElement.selectNodes("//field[primarykey='是']");
    for (var iList = 0; iList < oList.length; iList++) {
        var sFieldName = oList.item(iList).childNodes(0).text;
        if (sFieldName.toUpperCase() != MainKey.toUpperCase()) {
            return sFieldName;
        }
    }
    return "";
}

function Save_GetFieldArr(dssub1, oXml) {
    var arrField = new Array();
    var saveasTable = dssub1.saveastable;
    var arri, i;
    if (isSpace(saveasTable) == false) {
        var ooXml = table_have_field1(saveasTable);
        if (typeof ooXml != "object") return null;

        arri = 0;
        for (i = 0; i < dssub1.FieldCount; i++) {
            if (dssub1.Field(i).DataType == "图象") continue;
            if (table_have_field2(ooXml, oXml.documentElement.childNodes(i).childNodes(0).text)) {
                arrField[arri] = i;
                arri++;
            }
        }
    } else {
        arri = 0;
        for (i = 0; i < dssub1.FieldCount; i++) {
            if (dssub1.Field(i).DataType == "图象") continue;
            arrField[arri] = i;
            arri++;
        }
    }
    return arrField;
}

function Save_GetsF(arrField, oXml, bMainTab) {
    var sF = "";
    for (var arri = 0; arri < arrField.length; arri++) {
        i = arrField[arri];
        var curFieldName = oXml.documentElement.childNodes(i).childNodes(0).text;
        if (fcpubdata.area.idtype == "2" && curFieldName.toUpperCase() == fcpubdata.area.keyfield.toUpperCase() && bMainTab != "从") {
        } else {
            sF += curFieldName + ",";
        }
    }

    if (sF.length > 0) {
        sF = sF.substring(0, sF.length - 1);
    }
    return sF;
}

function Save_GetsVsU(oDs, ii, i, billkeyfield, sV, sU, bMainTab, sSubKeyFieldName) {
    var bool = true;
    var s1 = "";
    var s11111 = "";
    billkeyfield = billkeyfield.toLowerCase();
    var curFieldName = oDs.Field(i).FieldName.toLowerCase();
    var curFieldValue = "";
    if (bMainTab == "是") {
        curFieldValue = oDs.Field(i).Value;
    } else {
        curFieldValue = oDs.oDom.documentElement.childNodes(ii).childNodes(i).text;
    }
    if (fcpubdata.area.idtype == "2" && curFieldName == billkeyfield && bMainTab != "从") {

    } else if (bMainTab == "从" && curFieldName == sSubKeyFieldName.toLowerCase()) {
        sV += "'" + IGetSubTableKeyValue(ii, sSubKeyFieldName) + "',";
    } else {
        var irecno = ii;
        if (bMainTab == "是") irecno = -1;
        s1 = oDs.fieldTrans(i, irecno);
        if (curFieldName == billkeyfield) {
            if (typeof fcpubdata.area.idtype == "undefined" || fcpubdata.area.idtype == "1" || fcpubdata.area.idtype == "2" || fcpubdata.area.idtype == "3" || fcpubdata.area.idtype == "6" || fcpubdata.area.idtype == "8") {
                s1 = ":get_keyfield";
                if (bMainTab != "是") {
                    s11111 = curFieldValue;
                    if (isSpace(s11111) == false) s1 = s11111;
                }
            } else {
                var oDsTmp = $id(fcpubdata.dsMain);
                if (typeof (bMainTab) == "undefined") {
                    oDsTmp = oDs;
                }
                if (IsSpace(billkeyfield) == false)
                    s1 = oDsTmp.Field(billkeyfield).Value;
            }
        }
        if (oDs.Field(i).DataType == "整数" || oDs.Field(i).DataType == "实数") {
            if (oDs.Field(i).FieldName == fcpubdata.gridNoFieldName) {
                sV += (ii + 1) + ",";
            } else {
                if (isSpace(s1)) {
                    sV += "0,";
                    s1 = "0";
                } else {
                    sV += s1 + ",";
                }
            }
        } else if (oDs.Field(i).DataType == "自定") {
            sV += "" + s1 + ",";
        } else if (oDs.Field(i).DataType == "日期" && fcpubdata.databaseTypeName == "oracle") {
            sV += "" + "to_date('" + s1 + "','yyyy-mm-dd')" + ",";
        } else {
            s1 = RepUpdateSql(s1);
            sV += "'" + s1 + "',";
        }
        var squot = "'";
        if (oDs.Field(i).DataType == "自定" || oDs.Field(i).DataType == "整数" || oDs.Field(i).DataType == "实数") {
            squot = "";
        }
        if (oDs.Field(i).DataType == "日期" && fcpubdata.databaseTypeName == "oracle") {
            squot = "";
            s1 = "to_date('" + s1 + "','yyyy-mm-dd')";
        }
        if (curFieldName != billkeyfield) {
            sU += oDs.Field(i).FieldName + "=" + squot + s1 + squot + ",";
        }
    }
    var arrRet = {
        sV: "",
        sU: ""
    }
    arrRet.sV = sV;
    arrRet.sU = sU;
    return arrRet;
}



function SubTableEditSave(oDs, billkeyfield) {
    var sWhere = "", s1, ii;
    var saveasTable = oDs.saveastable;
    var ll = oDs.RecordCount;
    var SubKeyName = getSubKeyName(oDs, billkeyfield);
    var iSubKeyNo = oDs.FieldNameToNo(SubKeyName);
    var xmlSql = new Sys.StringBuilder();
    var sList = new Sys.StringBuilder();
    for (ii = 0; ii < ll; ii++) {
        s1 = oDs.oDom.documentElement.childNodes(ii).childNodes(iSubKeyNo).text;
        if (isSpace(s1) == false) {
            sList.append("'" + s1 + "'");
        }
    }
    s1 = sList.toString(",");
    s1 = "delete from " + saveasTable + " where " + billkeyfield + "='" + fcpubdata.keyValue
+ "' and " + SubKeyName + " not in (" + s1 + ")";
    xmlSql.append("<no>" + s1 + "</no>");

    var xmlFields = oDs.format;
    var oXmlField = SetDom(xmlFields);
    var arrField = Save_GetFieldArr(oDs, oXmlField);
    if (arrField == null) {
        return fcpubdata.sendHttpErrMsg;
    }
    var fieldLen = arrField.length;
    var sF = Save_GetsF(arrField, oXmlField, "从");
    var sInsert = "";
    var oldValue = "";
    var newValue = "";
    var sEditSql = new Sys.StringBuilder();
    var sAddSql = new Sys.StringBuilder();
    for (ii = 0; ii < ll; ii++) {
        var sRowTag = oDs.oDom.documentElement.childNodes(ii).getAttribute("rowstate");
        oldValue = oDs.oDom.documentElement.childNodes(ii).childNodes(iSubKeyNo).text;
        newValue = IGetSubTableKeyValue(ii);
        sWhere = " where " + billkeyfield + "='" + fcpubdata.keyValue + "' and " + SubKeyName + "='" + oldValue + "'";
        if (sRowTag == "add" || sRowTag == "edit") {
            var sV = "";
            var sU = "";
            for (var arri = 0; arri < fieldLen; arri++) {
                i = arrField[arri];
                var arrRet = Save_GetsVsU(oDs, ii, i, billkeyfield, sV, sU, "从", SubKeyName);
                sV = arrRet.sV;
                sU = arrRet.sU;
            }
            if (sV.length > 0) sV = sV.substring(0, sV.length - 1);
            if (sU.length > 0) sU = sU.substring(0, sU.length - 1);
            if (sRowTag == "add") {
                sInsert = "Insert into " + saveasTable + " (" + sF + ") Values (" + sV + ")";
                sAddSql.append("<no>" + repXml(sInsert) + "</no>");
            } else {
                sInsert = "Update " + saveasTable + " set " + sU + " " + sWhere;
                sEditSql.append("<no>" + repXml(sInsert) + "</no>");
            }
        } else {
            sInsert = "update " + saveasTable + " set " + SubKeyName + "='" + newValue + "' " + sWhere;
            sEditSql.append("<no>" + repXml(sInsert) + "</no>");
        }
    }
    xmlSql.append(sEditSql.toString());
    xmlSql.append(sAddSql.toString());
    return xmlSql.toString();
}

function InsertTmpTableFields(oDs) {
    var oF = oDs.oDom.documentElement.childNodes(oDs.oDom.documentElement.childNodes.length - 1).childNodes(1);
    var l = oF.childNodes.length;
    var sFieldName = '';
    for (var i = 0; i < l; i++) {
        sFieldName += oF.childNodes(i).childNodes(0).text + ",";
    }
    return sFieldName;
}


function InsertTmpTableSql(oDs, curRow) {
    var oV = oDs.oDom.documentElement.childNodes(curRow);
    var l = oV.childNodes.length;
    var sV = '';
    for (var i = 0; i < l; i++) {
        var s1 = oV.childNodes(i).text;
        if (oDs.Field(i).DataType == "整数" || oDs.Field(i).DataType == "实数") {
            if (oDs.Field(i).FieldName == fcpubdata.gridNoFieldName) {
                sV += (ii + 1) + ",";
            } else {
                if (isSpace(s1)) {
                    sV += "0,";
                    s1 = "0";
                } else {
                    sV += s1 + ",";
                }
            }
        } else if (oDs.Field(i).DataType == "自定") {
            sV += "" + s1 + ",";
        } else if (oDs.Field(i).DataType == "日期" && fcpubdata.databaseTypeName == "oracle") {
            sV += "" + "to_date('" + s1 + "','yyyy-mm-dd')" + ",";
        } else {
            s1 = RepUpdateSql(s1);
            sV += "'" + s1 + "',";
        }
    }
    return sV;
}

