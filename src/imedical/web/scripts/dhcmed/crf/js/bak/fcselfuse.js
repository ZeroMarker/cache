
Eform.SysForm = function () { }
Eform.SysForm.prototype =
{
    getBillType: GetBillType,
    billTypeNameToPath: BillTypeNameToPath,
    selColor: SelColor,
    selFgColor: SelFgColor,
    selFunction: SelFunction,
    setButtonImage: function () {
        var oRunForm = new Eapi.RunForm();
        oRunForm.setButtonImage($id("cmdOk"), "../images/ef_run_button_ok.gif");
        oRunForm.setButtonImage($id("cmdClose"), "../images/ef_run_button_close.gif");
        var i = 1;
        var bmpPath = fcpubdata.path + "/" + fcpubdata.root + "/css/skins/" + fcpubdata.skins + "/images/ef_run_downarrow.gif";

        while ($id("cmdDropDown" + i) != null) {
            var obj = $id("cmdDropDown" + i);
            obj.style.width = "16px";
            obj.style.height = "18px";
            oRunForm.setButtonImage(obj, bmpPath);
            i++;
        }
    },
    setValue: function (oCont, value) {
        if (IsSpace(value) == false) {
            if (oCont.controltype == "radio") {
                new Eapi.BaseCont().setRadioValue(oCont, value);
            } else if (oCont.controltype == "checkbox") {
                new Eapi.BaseCont().setCheckBoxValue(oCont, value);
            } else {
                oCont.value = value;
            }
        }
    },
    jsonToCont: function (oJson, arrContId) {
        for (var i = 0; i < arrContId.length; i++) {
            this.setValue($id(arrContId[i]), oJson[arrContId[i]]);
        }
    },
    contToJson: function (oJson, arrContId) {
        for (var i = 0; i < arrContId.length; i++) {
            oJson[arrContId[i]] = $id(arrContId[i]).value;
        }
    }
}
if (Type.parse("Eform.SysForm") == null) Eform.SysForm.registerClass("Eform.SysForm");

Eform.Prop = function () { }
Eform.Prop.prototype =
{
    displayAction: PropWinDisplayAction,
    fontAction: PropWinFontAction,
    changePosition: PropWinChangePosition,
    termStyle: PropWinClickTermStyle,
    selField: PropWinSelField,
    changeDs: PropWinChangeDs,
    onload: PropWinOnload,
    clickOk: PropWinClickOk
}
if (Type.parse("Eform.Prop") == null) Eform.Prop.registerClass("Eform.Prop");


function GetAllDjFileName(sPath) {
    if (typeof sPath == "undefined") sPath = "";
    return new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/PathFile" + fcpubdata.dotnetVersion + "?GetAllDjFileName", "<vpath>" + fcpubdata.path + "</vpath>" + "<subpath>" + sPath + "</subpath>");
}

function GetBillType() {
    var oXml = SetDomFile(fcpubdata.path + "/" + fcpubdata.root + "/billtype.xml");
    var sRet = new Sys.StringBuilder();
    if (oXml.documentElement != null) {
        var l = oXml.documentElement.childNodes.length - 1;
        for (var i = 0; i < l; i++) {
            var stext = oXml.documentElement.childNodes(i).childNodes(1).text;
            var svalue = oXml.documentElement.childNodes(i).childNodes(2).text;
            var spath = oXml.documentElement.childNodes(i).childNodes(3).text;
            var sextname = oXml.documentElement.childNodes(i).childNodes(4).text;
            sRet.append("<option value=\"" + svalue + "\" extname=\"" + sextname + "\" path=\"" + spath + "\">" + stext + "</option>");

        }
    }
    return sRet.toString();
}

function BillTypeNameToPath(name) {
    var oXml = SetDomFile(fcpubdata.path + "/" + fcpubdata.root + "/billtype.xml");
    var oRet = new Object();
    if (oXml.documentElement != null) {
        var l = oXml.documentElement.childNodes.length - 1;
        for (var i = 0; i < l; i++) {
            var svalue = oXml.documentElement.childNodes(i).childNodes(2).text;
            var spath = oXml.documentElement.childNodes(i).childNodes(3).text;
            var extname = oXml.documentElement.childNodes(i).childNodes(4).text;
            if (svalue == name) {
                oRet.path = spath;
                oRet.extname = extname;
                break;
            }

        }
    }
    return oRet;
}

function contselfield(arr) {

    if (arr.length == 0) {
        alert("请增加了数据集后再试!");
        return;
    }
    var sRet = DjOpen('fieldsel', arr, '展现', '有模式窗口', '直接', '选择字段');
    if (typeof sRet != "undefined") {
        var arr1 = sRet.split(",");
        return arr1;
    }
}

function SelColor(obj, sTag) {
    var oFont = $id('displayfont');
    if (typeof obj != "undefined") oFont = $id(obj.id);
    var sInitColor = oFont.style.backgroundColor;
    if (sTag == 1) {
        if (isSpace(oFont.style.borderColor)) {
            sInitColor = "#0080ff";
        } else {
            sInitColor = oFont.style.borderColor;
        }
    } 
    var sColor;
    if (isSpace(sInitColor))
        sColor = dlgHelper.ChooseColorDlg();
    else
        sColor = dlgHelper.ChooseColorDlg(sInitColor);
    sColor = sColor.toString(16);
    if (sColor.length < 6) {
        var sTempString = "000000".substring(0, 6 - sColor.length);
        sColor = sTempString.concat(sColor);
    }
    if (typeof (sTag) == "undefined") {
        oFont.style.backgroundColor = sColor;
        oFont.changebg = "是";
    } else {
        //修改了设置边框颜色的方法
        if (sTag == 1) sTag = "borderColor";

        oFont.style.borderColor = sColor;
        oFont.changeborder = true;
        //        var sCommand = obj.id + ".style." + sTag + "=\"" + sColor + "\"";
        //        eval(sCommand);
    }
}


function SelFgColor(obj) {
    var oFont = $id('displayfont');
    if (typeof obj != "undefined") oFont = $id(obj.id);

    var sInitColor = oFont.style.color;
    var sColor;
    if (isSpace(sInitColor))
        sColor = dlgHelper.ChooseColorDlg();
    else
        sColor = dlgHelper.ChooseColorDlg(sInitColor);
    sColor = sColor.toString(16);
    if (sColor.length < 6) {
        var sTempString = "000000".substring(0, 6 - sColor.length);
        sColor = sTempString.concat(sColor);
    }
    oFont.style.color = sColor;
}


function SelFunction(obj) {
    var arr = new Array();
    //arr[0] = fcpubdata.obj[5];
    arr[0] = $(obj).val();
    try {
        //arr[1] = arrRegFuncList;
        //该参数是双击控件的时候传递给控件属性页面的参数，这里再转发给事件函数配置界面，可以根据需要读取里面的数据。
        arr[1] = window.dialogArguments;
    } catch (e) { }
    var sRet = DjOpen('FuncConfig', arr, '展现', '有模式窗口', '直接', '选择函数');
    if (isSpace(sRet) == false) {
        if (sRet.startsWith("$valid(")) {
            obj.value += sRet;
        } else {
            obj.value = sRet;
        }
    }

}

function GridChangeRow(up, ogrid1) {
    var ogrid;
    if (typeof ogrid1 == "undefined") {
        ogrid = SKBILLgrid1;
    } else {
        ogrid = ogrid1;
    }
    var ods = eval(ogrid.dataset);
    if ((up && ods.RecNo == 0) || (up == false && ods.RecNo >= ods.RecordCount - 1)) return;
    var oP = ods.oDom.documentElement;
    var oNode, oNode1;
    if (up) {
        if (ogrid.TopRow > 0 && ogrid.Row == ogrid.TopRow + 1) {
            ogrid.VscrollTo(ogrid.TopRow - 1);
        }
        oNode = oP.childNodes(ods.RecNo).cloneNode(true);
        oNode1 = oP.childNodes(ods.RecNo - 1).cloneNode(true);
        oP.replaceChild(oNode1, oP.childNodes(ods.RecNo));
        oP.replaceChild(oNode, oP.childNodes(ods.RecNo - 1));
    } else {
        if (ogrid.Vmax > 0 && ogrid.TopRow < ogrid.Vmax && ogrid.Row > ogrid.TopRow + 1) {
            ogrid.VscrollTo(ogrid.TopRow + 1);
        }


        oNode = oP.childNodes(ods.RecNo).cloneNode(true);
        oNode1 = oP.childNodes(ods.RecNo + 1).cloneNode(true);
        oP.replaceChild(oNode1, oP.childNodes(ods.RecNo));
        oP.replaceChild(oNode, oP.childNodes(ods.RecNo + 1));
    }
    if (up) {
        ogrid.tab.rows(ods.RecNo + 1).swapNode(ogrid.tab.rows(ods.RecNo));
        ods.RecNo--;
    } else {
        ogrid.tab.rows(ods.RecNo + 1).swapNode(ogrid.tab.rows(ods.RecNo + 2));
        ods.RecNo++;
    }
}

function BillEventHeadOpen(svalue, obj) {
    var s = svalue;
    var ilen = 14;
    if (typeof s == "function") {
        s = s.toString();
        ilen = BillEventHeadOpenTmp(s);
        obj.value = s.substring(ilen + 23, s.length - 4);
    } else {
        if (IsSpace(s)) {
            obj.value = "";
        } else {
            ilen = BillEventHeadOpenTmp(s);
            obj.value = s.substring(ilen, s.length - 2);
        }
    }
}
function BillEventHeadOpenTmp(s) {
    var iRet = 14;
    if (s.indexOf("bill_ondblclick") >= 0) {
        iRet = 17;
    } else if (s.indexOf("bill_onexit") >= 0) {
        iRet = 13;
    } else if (s.indexOf("bill_onkeydown") >= 0) {
        iRet = 16;
    }
    return iRet;
}

function SetPasswordEdit(SKDBedit2) {
    var s1 = SKDBedit2.outerHTML;
    var sRet = repStr(s1, '<INPUT ', '<INPUT type=password ');
    SKDBedit2.outerHTML = sRet;
}

function getDsType(sourType) {
    var stype = sourType;
    stype = stype.toLowerCase();
    if (stype == "char" || stype == "string" || stype == "varchar" || stype == "nchar" || stype == "nvarchar" || stype == "varchar2" || stype == "nvarchar2")
        stype = "字符";
    if (stype == "text" || stype == "ntext" || stype == "clob" || stype == "nclob" || stype == "long")
        stype = "文本";
    if (stype == "decimal" || stype == "float" || stype == "real" || stype == "money" || stype == "smallmoney" || stype == "numeric")
        stype = "实数";
    if (stype == "int32" || stype == "smallint" || stype == "bit" || stype == "int" || stype == "bigint" || stype == "tinyint" || stype == "integer")
        stype = "整数";
    if (stype == "date" || stype == "datetime" || stype == "smalldatetime")
        stype = "日期";
    if (stype == "image" || stype == "blob" || stype == "varbinary" || stype == "binary" || stype == "raw" || stype == "long raw" || stype == "bfile")
        stype = "图象";
    if ((stype != "日期") && stype != "实数" && stype != "整数" && stype != "文本" && stype != "图象")
        stype = "字符";
    return stype;
}


function SaveFile(sFile, sHtml) {
    try {
        var fso = new ActiveXObject("Scripting.FileSystemObject");
    } catch (e) {
        alert("因当前IE禁止运行ActiveX控件,请调低IE的安全属性后再运行此功能!");
        return;
    }
    var char1 = unescape("%5C");
    var sFile1 = repStr(sFile, char1, char1 + char1);
    try {
        var a = fso.CreateTextFile(sFile1, false);
    } catch (e) {
        alert("文件" + sFile + "已存在.");
        return;
    }
    var s1 = "";
    if (typeof sHtml == "undefined") {
        s1 = t.outerHTML;
    } else {
        s1 = sHtml;
    }
    a.WriteLine(s1);
    a.Close();
    alert("文件成功保存到: " + sFile);

}

function loadhtml(shtml, djsn, typePath, extname, callback, context) {

    var dtype = fcpubdata.databaseTypeName;
    if (fcpubdata.area.isfile == "是") dtype = "file";
    var sXml = "<No>" + shtml + "</No>" + "<No>" + djsn + "</No>" + "<No>" + dtype + "</No>" + "<No>" + fcpubdata.path + "</No>" + "<typepath>" + typePath + "</typepath>" + "<extname>" + extname + "</extname>";
    return new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?loadhtml", sXml, callback, context);
}


//控件汉字名称china的验证方法，验证完成之后要修改控件的显示名称。
//英文名称对用户来说并没有实际的意义，就按照默认的英文加数字就可以
function CheckContSameName(oContXml, sid, obj, SKbillsheet) {
    var oldid = obj.id;
    sid = new Eapi.Str().trim(sid);

    var sRet = "";
    var oList = oContXml.documentElement.selectNodes("//id[. ='" + obj.id + "']");
    if (oList.length > 0) {
        var oNode = oContXml.documentElement.selectSingleNode("//id[. ='" + oldid + "']");
        if (oNode != null) {
            //id不再变更，修改的只是显示的名字
            //oNode.text = sid;
            //obj.id = sid;
            SKbillsheet.ownerDocument.parentWindow.parent.objlist.execScript("objlist_edit('" + oldid + "','" + sid + "')");
        }
        var sxml = SKbillsheet.billtaborder;
        if (isSpace(sxml) == false) {
            var oXml = SetDom(sxml);
            oNode = oXml.documentElement.selectSingleNode("//taborder[. ='" + oldid + "']");
            if (oNode != null) {
                //id不再变更，修改的只是显示的名字
                //oNode.text = sid;
                SKbillsheet.billtaborder = oXml.documentElement.xml;
            }
        }
    }
    return sRet;
}

function SetTextValue(oP, oCont) {
    if (IsSpace(oP)) {
        oCont.value = "";
    } else {
        oCont.value = oP;
    }
}

function SetCheckBoxPutValue(oP, oCont) {
    if (IsSpace(oP)) {
        SetCheckBoxValue(oCont, "否");
    } else {
        SetCheckBoxValue(oCont, oP);
    }
}

function e_SetCheckBoxValue(value, oCont) {
    if (IsSpace(value) == false) {
        SetCheckBoxValue(oCont, value);
    }
}
function e_SetComboValue(value, oCont) {
    if (IsSpace(value) == false) {
        oCont.value = value;
    }
}
function e_SetRadioValue(value, oCont) {
    if (IsSpace(value) == false) {
        SetRadioValue(oCont, value);
    }
}

function e_SetPropValue(obj, propName, value) {
    if (IsSpace(value)) {
        obj.removeAttribute(propName);
    } else {
        obj.setAttribute(propName, value);
    }
}

function SetPosOnChange(oCont, pos) {
    var obj = event.srcElement;
    if (obj.value == txtLeft.value) {
        oCont.style.left = obj.value;
    }
    if (obj.value == txtTop.value) {
        oCont.style.top = obj.value;
    }
    if (obj.value == txtWidth.value) {
        oCont.style.width = obj.value;
    }
    if (obj.value == txtHeight.value) {
        oCont.style.height = obj.value;
    }
}


function RepDqMarks(obj) {
    if (obj.value.indexOf('"') != -1)
        return false;
}


function IsCheckDataField(obj1, obj2) {
    if (IsSpace(obj1.value) == false && IsSpace(obj2.value) == true || IsSpace(obj1.value) == true && IsSpace(obj2.value) == false)
        return false;
}


function PropWinDisplayAction(obj, chkObj) {
    if (chkObj.value == '否') {
        obj.style.display = "none";
    } else {
        obj.style.cssText = RepStr(obj.style.cssText, "DISPLAY: none;", "");
    }
}

function PropWinFontAction(obj, obj1) {
    if (obj1.change == "是") {
        obj.style.color = obj1.style.color;
        obj.style.fontStyle = obj1.style.fontStyle;
        obj.style.textDecoration = obj1.style.textDecoration;
        obj.style.fontFamily = obj1.style.fontFamily;
        obj.style.fontSize = obj1.style.fontSize;
        obj.style.fontWeight = obj1.style.fontWeight;
    }

}

function PropWinChangePosition() {
    if (cboPosition.value != "absolute") {
        txtLeft.value = "";
        txtTop.value = "";
    }
    if (cboPosition.value != "absolute") {
        txtLeft.disabled = true;
        txtTop.disabled = true;
    } else {
        txtLeft.disabled = false;
        txtTop.disabled = false;
    }
}

function PropWinClickTermStyle() {
    var arr1 = new Array();
    var obj = fcpubdata.obj[0];
    arr1[0] = fcpubdata.obj[1];
    arr1[1] = obj.termStyle;
    var sxml = DjOpen('termcard', arr1, '展现', '有模式窗口', '直接', '条件格式');
    if (typeof (sxml) == "undefined") {
        return;
    }
    obj.termStyle = sxml;
}

function PropWinSelField() {
    var arrtmp = contselfield(fcpubdata.obj[1]);
    if (typeof arrtmp != "undefined") {
        $id("txtDataset").value = arrtmp[0];
        $id("txtField").value = arrtmp[1];
        $id("txtFieldChn").value = arrtmp[2];
    }
}

function PropWinChangeDs() {
    if ($id("rdoDs").value != "2") $id("rdoDs").value = 1;
    if ($id("rdoDs").value == "2") {
        $id("txtListText").style.width = 0;
        $id("txtListValue").style.width = 0;
        $id("lblListValue").style.width = 0;
        $id("txtListSql").style.width = 315
    } else {
        $id("txtListText").style.width = 138;
        $id("txtListValue").style.width = 138;
        $id("lblListValue").style.width = 50;
        $id("txtListSql").style.width = 0
    }
}

/*
* 由于对数据集控件的改动比较大，这里对数据集控件的加载做了一个专门的处理
* sbin amend 2010-10-14
*/
function PropWinOnload() {
    if (fcpubdata.obj == null) {
        return false;
    }
    var obj = fcpubdata.obj[0];
    if (typeof displayfont == "object") {
        var obj1 = displayfont;
        if (displayfont.length > 1) {
            obj1 = displayfont[0];
        }
        if (obj.style.backgroundColor == "") {
            obj1.style.backgroundColor = "#ffffff";
        } else {
            obj1.style.backgroundColor = obj.style.backgroundColor;
        }

        obj1.style.color = obj.style.color;
        obj1.style.fontStyle = obj.style.fontStyle;
        obj1.style.textDecoration = obj.style.textDecoration;
        obj1.style.fontFamily = obj.style.fontFamily;
        obj1.style.fontSize = obj.style.fontSize;
        obj1.style.fontWeight = obj.style.fontWeight;

        obj1.style.borderColor = obj.style.borderColor;

    }
    SetTextValue(obj.id, txtId);
    var bmpPath = fcpubdata.path + "/" + fcpubdata.root + "/css/skins/" + fcpubdata.skins + "/images/ef_run_downarrow.gif";

    if (typeof cmdActionSet == "object") cmdActionSet.style.display = fcpubdata.actionButtonDisplay;

    if (typeof cmdEclick == "object") SetButtonImage(cmdEclick, bmpPath);
    if (typeof cmdEdblclick == "object") SetButtonImage(cmdEdblclick, bmpPath);
    if (typeof cmdEfocus == "object") SetButtonImage(cmdEfocus, bmpPath);
    if (typeof cmdEblur == "object") SetButtonImage(cmdEblur, bmpPath);
    if (typeof cmdEkey == "object") SetButtonImage(cmdEkey, bmpPath);
    if (typeof cmdEchange == "object") SetButtonImage(cmdEchange, bmpPath);


    if (typeof cmdBgcolor == "object") SetButtonImage(cmdBgcolor, "../images/ef_run_button_color.gif");
    if (typeof cmdFont == "object") SetButtonImage(cmdFont, "../images/ef_run_button_font.gif");
    SetButtonImage($id("cmdOk"), "../images/ef_run_button_ok.gif");
    SetButtonImage($id("cmdClose"), "../images/ef_run_button_close.gif");

    if (typeof chkLeftLine == "object") CheckBoxPutValue(obj.style.borderLeftWidth, chkLeftLine, '0px');
    if (typeof chkTopLine == "object") CheckBoxPutValue(obj.style.borderTopWidth, chkTopLine, '0px');
    if (typeof chkBottomLine == "object") CheckBoxPutValue(obj.style.borderBottomWidth, chkBottomLine, '0px');
    if (typeof chkRightLine == "object") CheckBoxPutValue(obj.style.borderRightWidth, chkRightLine, '0px');
    if (typeof chkDisplay == "object") CheckBoxPutValue(obj.style.display, chkDisplay, 'none');
    SetTextValue(obj.style.width, txtWidth);
    SetTextValue(obj.style.height, txtHeight);
    SetTextValue(obj.style.top, txtTop);
    SetTextValue(obj.style.left, txtLeft);

    if (typeof chkDisabled == "object") {
        if (obj.disabled == false) {
            SetCheckBoxValue(chkDisabled, "是");
        } else {
            SetCheckBoxValue(chkDisabled, "否");
        }
    }

    //是否创建索引
    //debugger;
//    if (typeof chkIndex == "object") { 
//        chkIndex.checked = obj.createIndex;
//    }

    $id("cboPosition").value = obj.style.position;
    var tmpB = true;
    if (obj.style.position == "absolute") {
        tmpB = false
    }

    $id("txtLeft").disabled = tmpB;
    $id("txtTop").disabled = tmpB;
    if (typeof txtValue == "object") SetTextValue(obj.value, txtValue);
    if (typeof txtDataset == "object") SetTextValue(obj.dataset, txtDataset);
    if (typeof txtField == "object") SetTextValue(obj.field == "" || obj.field == null ? "100" : obj.field, txtField);
    if (typeof txtFieldChn == "object") SetTextValue(obj.china == "" || obj.china == null ? obj.id : obj.china, txtFieldChn);

    //当中文名称变化的时候，修改objlist的option的Value的值 sbin amend 2010-10-08
    var contype = $(obj).attr("controltype");
    if (contype == "text" || contype == "dictionary" || contype == "datetext" || contype == "numbertext" || contype == "timetext" || contype == "textarea" || contype == "checkbox" || contype == "radio") {
        
    }else if (contype == "button") {
        if ($id("txtValue") != null) {
            $id("txtValue").onchange = function uf_id_onchange() {
                var sR = CheckContSameName(fcpubdata.obj[3], $id("txtValue").value, obj, fcpubdata.obj[2]);
                if (sR != "") {
                    alert(sR);
                    event.returnValue = false;
                }
            }
        }
    } else {
        if ($id("SKDBedit4") != null) {
            $id("SKDBedit4").onchange = function uf_id_onchange() {
                var sR = CheckContSameName(fcpubdata.obj[3], $id("SKDBedit4").value, obj, fcpubdata.obj[2]);
                if (sR != "") {
                    alert(sR);
                    event.returnValue = false;
                }
            }
        }
    }
    //
    if ($id("txtField") != null) {
        $id("txtField").onchange = function uf_field_onchange() {
            if ($("#txtField").val() == "") {
                $("#txtField").val("100")
            }
            var reg = /^[0-9]*$/;
            var blret = reg.test($("#txtField").val());
            if (!blret) {
                alert("不合法的长度值！");
                $("#txtField").val("100");
            }
        }
    }

    if ($id("SKDBedit9") != null && $id("SKDBedit8") != null) {
        var uf_check_onchange = function () {
            if ($("#txtValue").val() != $("#SKDBedit9").val() && $("#txtValue").val() != $("#SKDBedit8").val()) {
                $("#txtValue").val($("#SKDBedit9").val());
            }
        }
        $id("SKDBedit9").onchange = uf_check_onchange;
        $id("SKDBedit8").onchange = uf_check_onchange;
        $id("txtValue").onchange = uf_check_onchange;
    }

    if (typeof txtEclick == "object") {
        $(txtEclick).val($(obj).attr("EventFuncEntityEclick"));
    }
    if (typeof txtEdblclick == "object") {
        $(txtEdblclick).val($(obj).attr("EventFuncEntityEdblclick"));
    }
    if (typeof txtEfocus == "object") {
        $(txtEfocus).val($(obj).attr("EventFuncEntityEfocus"));
    }
    if (typeof txtEblur == "object") {
        $(txtEblur).val($(obj).attr("EventFuncEntityEblur"));
    }
    if (typeof txtEkey == "object") {
        $(txtEkey).val($(obj).attr("EventFuncEntityEkey"));
    }
    if (typeof txtEchange == "object") {
        $(txtEchange).val($(obj).attr("EventFuncEntityEchange"));
    }
    if (typeof chkReadOnly == "object") {
        if (obj.readOnly == true) {
            SetCheckBoxValue(chkReadOnly, "是");
        } else {
            SetCheckBoxValue(chkReadOnly, "否");
        }
    }
    if (typeof chkNotBg == "object") {
        if (IsSpace(obj.NotBg)) {
            SetCheckBoxValue(chkNotBg, "否");
        } else {
            SetCheckBoxValue(chkNotBg, obj.NotBg);
        }
    }
    if (typeof txtCustomAttr == "object") {
        SetTextValue(obj.CustomAttr, txtCustomAttr);
        txtCustomAttr.ondblclick = EventCodeOpenBigWindow;
    }
    if (typeof cboAlign == "object") cboAlign.value = obj.style.textAlign;
    if (typeof txtListText == "object") SetTextValue(obj.temptext, txtListText);
    if (typeof txtListValue == "object") SetTextValue(obj.tempvalue, txtListValue);
    if (typeof txtListSql == "object") SetTextValue(obj.sql, txtListSql);
    if (typeof rdoDs == "object") {
        SetRadioValue(rdoDs, obj.check);
    }
    new Eapi.RunForm().getConts();

    function CheckBoxPutValue(oP, oCont, vValue) {
        if (oP == vValue) {
            SetCheckBoxValue(oCont, "否");
        } else {
            SetCheckBoxValue(oCont, "是");
        }
    }
}

function EventCodeOpenBigWindow() {
    var obj = event.srcElement;
    var sret = DjOpen("inputBigText", obj.value, "展现", "有模式窗口", "直接", "");
    if (typeof (sret) != "undefined") {
        obj.value = sret;
        try {
            obj.fireEvent("onchange");
        } catch (e) { }
    }
}

/*
* 当配置属性的按钮点击确定的时候触发该事件进行保存当前配置的信息
* 由于数据集的取值方式和以前的取值方式已经完全不同
* 这里对数据集的处理做出了单独的处理。处理方式也很简单，直接将配置的JSON字符串保存到属性ConfigStr中去
* sbin amend 2010-10-14
*/
function PropWinClickOk() {
    var obj = fcpubdata.obj[0];
    var curControlType = $(obj).attr("controltype");

    //检测ID是否被修改，如果修改要对应的修改右边的树形上的ID
    if (typeof txtId == "object") {
        var newid = $("#txtId").val();
        if (newid == "") {
            alert("ID不能为空，无法保存！");
            return;
        }
        var oldid = obj.id;
        
        if (newid != oldid) {
            fcpubdata.obj[2].ownerDocument.parentWindow.parent.objlist.execScript("objlist_replaceid('" + oldid + "','" + newid + "','" + $("#txtFieldChn").val() + "')");
            obj.id = newid;
        }
    }
    //对ID的处理完毕

    if (curControlType== "dictionary") {
        var DataSetConfigStr = $("#DataSetConfig").val();
        $(obj).attr("ConfigStr", DataSetConfigStr);
    }
    
    //处理外部数据接口配置
    $(obj).attr("ExternalDataInterfaceConfig", $("#ExternalDataConfig").length > 0 ? $("#ExternalDataConfig").val() : "");

    //处理内部接口配置
    if (typeof selFieldID == "object") {
        if ($("#selFieldID").val() != "") {
            var InternalDataInterface = new Object();
            InternalDataInterface["ControlID"] = obj.id;
            InternalDataInterface["FormCatalog"] = $("#selFormCatalog").val();
            InternalDataInterface["FormID"] = $("#selFormID").val();
            InternalDataInterface["FormName"] = $("#selFormID").find("option[selected=true]").text().split("|")[1];
            InternalDataInterface["FieldID"] = $("#selFieldID").val();
            InternalDataInterface["AdmBatchMode"] = $("#selInternalTimes").val();
            InternalDataInterface["ObtainMode"] = $("#selObtainModel").val();
            $(obj).attr("InternalDataInterfaceConfig", $.toJSON(InternalDataInterface));
        } else {
            $(obj).removeAttr("InternalDataInterfaceConfig");
        }
    }
    //处理内部数据接口

    //处理报表配置
    if (typeof selectedFields == "object") {
        var sfVal = $("#selectedFields").val();
        if (sfVal != "") {
            $(obj).attr("selectedFields", sfVal);
        }
        else {
            $(obj).removeAttr("selectedFields");
        }
    }

    if (typeof displayfont == "object") {
        var obj1 = displayfont;
        if (obj1.changebg == "是") {
            obj.style.backgroundColor = obj1.style.backgroundColor;
        } 

        if (obj1.style.borderColor == "") {
            obj1.style.borderColor = "#7F9DB9";
        }
        //目前默认是1个像素，以后如果修改这里需要跟着变化 sbin amend 2010-09-25
        if (curControlType == "dictionary") {
//            var sunObj = $(obj).find("input[type='text']")[0];
//            sunObj.style.borderWidth = "1px";
//            sunObj.style.borderColor = obj1.style.borderColor;
        } else if (curControlType == "button") { //按钮暂时没有设置边框属性的地方。
            
        } else {
            obj.style.borderWidth = "1px";
            obj.style.borderColor = obj1.style.borderColor;
        }

        if (curControlType == "dictionary") {
            //PropWinFontAction($(obj).find("input[type='text']")[0], obj1);
        } else {
            PropWinFontAction(obj, obj1);
        }
        
    }
    if (typeof txtValue == "object") {
        obj.value = txtValue.value;
    }
    if (typeof chkDisabled == "object") {
        if (chkDisabled.value == '否') {
            obj.disabled = true;
        } else {
            obj.disabled = false;
        }
    }

    //添加是否存创建索引的判断
//    if (typeof chkIndex == "object") {
//        obj.createIndex = chkIndex.checked;
//    }

    if (typeof chkDisplay == "object") PropWinDisplayAction(obj, chkDisplay);
    if (typeof chkNotBg == "object") {
        obj.NotBg = chkNotBg.value;
        if (chkNotBg.value == '是') {
            obj.style.backgroundColor = "";
        }
    }

    if (curControlType != "button") {
        if (typeof chkLeftLine == "object") {
            var Tmpobj = obj;
//            if (curControlType == "dictionary") {
//                Tmpobj = $(obj).find("input[type='text']")[0];
//            }
            if (chkLeftLine.value == '否') {
                Tmpobj.style.borderLeftWidth = 0;
            } else {
                Tmpobj.style.borderLeft = "1px solid " + obj1.style.borderColor;
            }
        }
        if (typeof chkTopLine == "object") {
            var Tmpobj = obj;
//            if (curControlType == "dictionary") {
//                Tmpobj = $(obj).find("input[type='text']")[0];
//            }
            if (chkTopLine.value == '否') {
                Tmpobj.style.borderTopWidth = 0;
            } else {
                Tmpobj.style.borderTop = "1px solid " + obj1.style.borderColor;
            }

        }
        if (typeof chkBottomLine == "object") {
            var Tmpobj = obj;
//            if (curControlType == "dictionary") {
//                Tmpobj = $(obj).find("input[type='text']")[0];
//            }
            if (chkBottomLine.value == '否') {
                Tmpobj.style.borderBottomWidth = 0;
            } else {
                Tmpobj.style.borderBottom = "1px solid " + obj1.style.borderColor;
            }
        }
        if (typeof chkRightLine == "object") {
            var Tmpobj = obj;
//            if (curControlType == "dictionary") {
//                Tmpobj = $(obj).find("input[type='text']")[0];
//            }
            if (chkRightLine.value == '否') {
                Tmpobj.style.borderRightWidth = 0;
            } else {
                Tmpobj.style.borderRight = "1px solid " + obj1.style.borderColor;
            }
        }
    }
    
    obj.style.position = $id("cboPosition").value;
    if (typeof txtCustomAttr == "object") {
        if (txtCustomAttr.value.indexOf('"') != -1 || txtCustomAttr.value.indexOf("'") != -1) {
            alert("自定义属性中不支持双引号或单引号。")
            return true;
        }
        if (IsSpace(txtCustomAttr.value))
            obj.removeAttribute("CustomAttr");
        else
            obj.CustomAttr = txtCustomAttr.value;
    }

    if (typeof txtFieldChn == "object") {
        obj.china = txtFieldChn.value;
        if (curControlType == "fieldset") {
            $(obj).find("legend").text(txtFieldChn.value);
        } else if (curControlType == "text" || curControlType == "dictionary" || curControlType == "datetext" || curControlType == "numbertext" || curControlType == "timetext" || curControlType == "textarea" || curControlType == "checkbox" || curControlType == "radio") {
            CheckContSameName(fcpubdata.obj[3], $id("txtFieldChn").value, obj, fcpubdata.obj[2]);
        }

    }

    var sMsg = "不支持双引号!";
    var s = "";
    if (typeof txtEclick == "object") {
        s = new Eapi.Str().trim(txtEclick.value)
        if (s == "") {
            obj.removeAttribute('fc_onclick')
        } else {
            var EventObj = eval("(" + s + ")");
            $(obj).removeAttr('onclick');
            obj.fc_onclick = "bill_onclick(\"" + EventObj.FuncExpress + "\")";
            $(obj).attr("EventFuncEntityEclick", s);
        }
    }
    if (typeof txtEchange == "object") {
        s = new Eapi.Str().trim(txtEchange.value)
        if (s == "") {
            obj.removeAttribute('onchange')
        } else {
            var EventObj = eval("(" + s + ")");
            $(obj).removeAttr('onchange');
            obj.onchange = "bill_onclick(\"" + EventObj.FuncExpress + "\")";
            $(obj).attr("EventFuncEntityEchange", s);
        }
    }
    if (typeof txtEdblclick == "object") {
        s = new Eapi.Str().trim(txtEdblclick.value)
        if (s == "") {
            obj.removeAttribute('fc_ondblclick')
        } else {
            var EventObj = eval("(" + s + ")");
            $(obj).removeAttr('ondblclick');
            obj.fc_ondblclick = "bill_ondblclick(\"" + EventObj.FuncExpress + "\")";
            $(obj).attr("EventFuncEntityEdblclick", s);
        }
    }
    if (typeof txtEfocus == "object") {
        s = new Eapi.Str().trim(txtEfocus.value)
        if (s == "") {
            obj.removeAttribute('fc_onfocus')
        } else {
            var EventObj = eval("(" + s + ")");
            $(obj).removeAttr('onfocus');
            obj.fc_onfocus = "bill_onenter(\"" + EventObj.FuncExpress + "\")";
            $(obj).attr("EventFuncEntityEfocus", s);
        }
    }
    if (typeof txtEblur == "object") {
        s = new Eapi.Str().trim(txtEblur.value)
        if (s == "") {
            obj.removeAttribute('fc_onblur')
        } else {
            var EventObj = eval("(" + s + ")");
            $(obj).removeAttr('onblur');
            obj.fc_onblur = "bill_onexit(\"" + EventObj.FuncExpress + "\")";
            $(obj).attr("EventFuncEntityEblur", s);
        }
    }
    if (typeof txtEkey == "object") {
        s = new Eapi.Str().trim(txtEkey.value)
        if (s == "") {
            obj.removeAttribute('fc_onkeydown')
        } else {
            var EventObj = eval("(" + s + ")");
            $(obj).removeAttr('onkeydown');
            obj.fc_onkeydown = "bill_onkeydown(\"" + EventObj.FuncExpress + "\")";
            $(obj).attr("EventFuncEntityEkey", s);
        }
    }
    if (typeof txtDataset == "object") {
        s = new Eapi.Str().trim(txtDataset.value)
        if (s == "") {
            obj.removeAttribute('dataset')
        } else {
            obj.dataset = s;
        }
    }
    if (typeof txtField == "object") {
        s = new Eapi.Str().trim(txtField.value);
        var reg = /^[0-9]*$/;
        var blret = reg.test(s);
        if (!blret) {
            alert("不合法的长度值！");
            return true;
        }else {
            obj.field = s;
        }
    }
    if (typeof txtFieldChn == "object") {
        s = new Eapi.Str().trim(txtFieldChn.value)
        if (s == "") {
            obj.removeAttribute('china')
        } else {
            obj.china = s;
        }
    }
    if (typeof cboAlign == "object") obj.style.textAlign = cboAlign.value;
    if (typeof chkReadOnly == "object") {
        if (chkReadOnly.value == '是') {
            obj.readOnly = true;
        } else {
            obj.readOnly = false;
            obj.removeAttribute("readOnly")
        }
    }
    if (typeof rdoDs == "object" && typeof txtListText == "object" && typeof txtListValue == "object" && typeof txtListSql == "object") {
        if (rdoDs.value == "2") {
            obj.check = 2;
        } else {
            obj.check = 1;
        }
        var stxt = txtListText.value.split("\r\n");
        var sval = txtListValue.value.split("\r\n");
        var sHtml = new Sys.StringBuilder();
        if (IsSpace(txtListText.value) == false) {
            for (var i = 0; i < stxt.length; i++) {
                try {
                    s1 = stxt[i];
                    s2 = sval[i];
                    if (typeof s1 == "undefined") {
                        s1 = "";
                    }
                    if (typeof s2 == "undefined") {
                        s2 = "";
                    }
                } catch (e) {
                    s1 = "";
                    s2 = "";
                }
                var sSel = "";
                if (typeof txtValue == "object") {
                    if (s2 == txtValue.value) sSel = " selected ";
                }
                sHtml.append("<option value='" + s2 + "'" + sSel + ">" + s1 + "</option>");
            }
        }
        var slen = stxt.length;
        var lent = sval.length;
        if (IsSpace(txtListText.value) == false && IsSpace(txtListValue.value) == false) {
            if (slen != lent) {
                alert("显示值和取值的长度不相等,请修改!");
                return true;
            }
        }
        if (IsSpace(txtListText.value) == false && IsSpace(txtListValue.value) == true) {
            txtListValue.value = txtListText.value;
        }
        obj.tempvalue = txtListValue.value;
        obj.temptext = txtListText.value;
        obj.sql = txtListSql.value;
        obj.options.length = 0;
        obj.outerHTML = SelectAddOption(obj, sHtml.toString());
    }
    return false;
}



function GetCreateTable(stablename, sfieldxml, bAddGzid, bAll, sField) {
    var sNewLine = "\r\n";
    var sRet = new Sys.StringBuilder();
    var oXml = SetDom(sfieldxml);
    var l = oXml.documentElement.childNodes.length - 1;
    if (bAll) l++;
    var sF = "";
    var autoFieldName = "";
    if (fcpubdata.area.idtype == "2") {
        var oDsMain = $id(fcpubdata.dsMain);
        if (oDsMain != null) {
            if (oDsMain.saveastable == stablename) {
                autoFieldName = fcpubdata.area.keyfield;
            }
        }
    }
    for (var j = 0; j < l; j++) {
        sF += oXml.documentElement.childNodes(j).childNodes(0).text;
        var stype = oXml.documentElement.childNodes(j).childNodes(2).text;
        var slen = oXml.documentElement.childNodes(j).childNodes(3).text;
        var sDot = oXml.documentElement.childNodes(j).childNodes(4).text;
        if (oXml.documentElement.childNodes(j).childNodes(0).text == autoFieldName && autoFieldName != "") {
            sF += " int IDENTITY (1, 1) NOT NULL , ";
        } else if (stype == "整数") {
            sF += " integer null ,";
        } else if (stype == "实数") {
            sF += " decimal(" + slen + "," + sDot + ") null ,";
        } else if (stype == "文本") {
            sF += " text null ,";
        } else if (stype == "图象") {
            sF += " image null ,";
        } else if (stype == "日期") {
            sF += " datetime null ,";
        } else {
            sF += " varchar(" + slen + ") null ,";
        }
    }
    if (IsSpace(sField) == false) sF += sField;
    if (bAddGzid) {
        sF += "GZID varchar(11) null ";
    } else {
        sF = sF.substring(0, sF.length - 1) + sNewLine;
    }
    sRet.append("if exists(select * from sysobjects where name='" + stablename + "')" + sNewLine);
    sRet.append(" drop table " + stablename + " " + sNewLine + ";");
    sRet.append("create table " + stablename + " (" + sNewLine);
    sRet.append(sF + ")" + sNewLine);
    return sRet.toString();

}

function DsCreateTable(oDs, sField) {
    var DsMain = $id("DsMain");
    if (typeof oDs != "undefined") DsMain = oDs;
    var sql = GetCreateTable(DsMain.saveastable, DsMain.formatxml, false, true, sField);
    var arr = sql.split(";");
    var l = arr.length;
    var sRet = new Sys.StringBuilder();
    for (var i = 0; i < l; i++) {
        var s1 = new Eapi.Str().trim(arr[i])
        if (IsSpace(s1) == false) {
            sRet.append("<no>" + s1 + "</no>");
        }
    }
    if (sRet.toString() != "") {
        var s = InsertSqls(sRet.toString())
        if (IsSpace(s)) {
            return "";
        } else {
            return s;
        }
    }

}

function e_ConvertDataTypeToValue(chnName) {
    var ret = 9;
    switch (chnName) {
        case "整数": ret = 17; break;
        case "实数": ret = 19; break;
        case "字符串": ret = 6; break;
        case "日期": ret = 2; break;
        case "时间": ret = 3; break;
        case "日期时间": ret = 4; break;
        case "布尔": ret = 5; break;
        case "整数组": ret = 273; break;
        case "实数组": ret = 275; break;
        case "字符串组": ret = 262; break;
        case "默认": ret = 9; break;
        default: ret = chnName; break;
    }
    return ret;
}
function e_ConvertDataTypeToName(ivalue) {
    var ret = "默认";
    switch (ivalue) {
        case "17": ret = "整数"; break;
        case "19": ret = "实数"; break;
        case "6": ret = "字符串"; break;
        case "2": ret = "日期"; break;
        case "3": ret = "时间"; break;
        case "4": ret = "日期时间"; break;
        case "5": ret = "布尔"; break;
        case "273": ret = "整数组"; break;
        case "275": ret = "实数组"; break;
        case "262": ret = "字符串组"; break;
        case "9": ret = "默认"; break;
    }
    return ret;
}

function e_GetFieldName(sSql, callback, context) {
    if (typeof sSql == "undefined" || sSql == "undefined") { return ""; }
    var sXml = "<No>" + RepXml(sSql) + "</No>";
    var retX = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?GetFieldName", sXml, callback, context);
    return retX;
}

function e_PropWinOnload() {
    if (typeof cmdOk == "object")
        e_SetButtonImage(cmdOk, "../images/ef_run_button_ok1.gif");
    if (typeof cmdClose == "object")
        e_SetButtonImage(cmdClose, "../images/ef_run_button_close1.gif");
    if (typeof cmdAdd == "object")
        e_SetButtonImage(cmdAdd, "../images/ef_run_button_add.gif");
    if (typeof cmdDel == "object")
        e_SetButtonImage(cmdDel, "../images/ef_run_button_del.gif");
    if (typeof cmdAdd1 == "object")
        e_SetButtonImage(cmdAdd1, "../images/ef_run_button_add.gif");
    if (typeof cmdDel1 == "object")
        e_SetButtonImage(cmdDel1, "../images/ef_run_button_del.gif");
    if (typeof cmdEdit == "object")
        e_SetButtonImage(cmdEdit, "../images/ef_run_button_edit.gif");

}

function e_SetButtonImage(sbutton, spathgif) {
    var obutton = eval(sbutton);
    obutton.style.backgroundImage = "url(" + spathgif + ")";
    obutton.style.cursor = "hand";
    obutton.style.borderTop = "";
    obutton.style.borderBottom = "";
    obutton.style.borderLeft = "";
    obutton.style.borderRight = "";


}

function EbiaoRunQuery() {
    var owin;
    var owin1 = window.dialogArguments;
    var s1 = "";
    if (typeof owin1 != "undefined") {
        s1 = owin1.sPubDjContent;
    }
    if (IsSpace(s1)) {
        owin = parent;
    } else {
        owin = owin1;
    }
    if (ActEbiaoPara(owin) == false) return;
    owin.toolbar.execScript("RunReport(curPageNo,'从参数表单上运行');");
    if (IsSpace(s1) == false) {
        window.close();
    }

}

function ActEbiaoPara(oWin) {
    if (typeof oWin == "undefined") oWin = parent;
    var sxml = oWin.oPubXmlFile.documentElement.getAttribute("e_argsbak");
    if (IsSpace(sxml)) {
        alert("没有报表参数!");
        return false;
    }
    var oX = SetDom("<root>" + unescape(sxml) + "</root>");
    var newPara = new Sys.StringBuilder();
    var basePara = oWin.toolbar.pubBasePara;
    var sMsg = "";
    for (var i = 0; i < oX.documentElement.childNodes.length; i++) {
        var objid = oX.documentElement.childNodes(i).childNodes(4).text;
        var curParaValue = oX.documentElement.childNodes(i).childNodes(5).text;
        if (IsSpace(objid) == false) {
            var objValue = "";
            try {
                objValue = eval(objid).value;
            } catch (e) { }
            if (typeof objValue == "undefined") objValue = "";
            switch (oX.documentElement.childNodes(i).childNodes(2).text) {
                case "整数":
                    {
                        if (IsInt(objValue) == false) {
                            sMsg = oX.documentElement.childNodes(i).childNodes(1).text + "的值不是整数!";
                            alert(sMsg);
                            return false;
                        }
                        break;
                    }
                case "实数":
                    {
                        if (IsNum(objValue) == false) {
                            sMsg = oX.documentElement.childNodes(i).childNodes(1).text + "的值不是实数!";
                            alert(sMsg);
                            return false;
                        }
                        break;
                    }
                case "字符串":
                    {
                        var swidth = oX.documentElement.childNodes(i).childNodes(3).text;
                        if (IsSpace(swidth) == false) {
                            if (objValue.length > ToInt(swidth)) {
                                sMsg = oX.documentElement.childNodes(i).childNodes(1).text + "的长度超长!";
                                alert(sMsg);
                                return false;
                            }
                        }
                        break;
                    }

            }
            curParaValue = objValue;
        }
        var tmp1 = "&" + oX.documentElement.childNodes(i).childNodes(0).text + "=";
        if (basePara.indexOf(tmp1) < 0) {
            var tempParamValue = escape(curParaValue);
            if (fcpubdata.dotnetVersion == "") tempParamValue = escape(tempParamValue);
            newPara.append(tmp1 + tempParamValue);
        }
    }
    oWin.toolbar.pubPara = newPara.toString();
    oWin.toolbar.cacheId = "";
    return true;
}


function ClearBgColor(obj) {
    obj.style.backgroundColor = "transparent";
}

function ActionQueryCond() {
    var sql = "";
    for (var i = 0; i < DsMain.Fields.Field.length; i++) {
        if (IsSpace(DsMain.Field(i).Value) == false) {
            sql += DsMain.Field(i).FieldName + "='" + DsMain.Field(i).Value + "' and ";
        }
    }
    if (sql != "") sql = " where " + sql.substring(0, sql.length - 4);
    PubQueryGridDs.opensql = "select * from " + DsMain.saveastable + sql;
}

function GetBindInfos() {
    var sRet = new Sys.StringBuilder();
    var l = oContXml.documentElement.childNodes.length;
    for (var i = 0; i < l; i++) {
        if (IsBindContType(oContXml.documentElement.childNodes(i).nodeName)) {
            var oSub = oContXml.documentElement.childNodes(i);
            for (var j = 0; j < oSub.childNodes.length; j++) {
                var sId = oSub.childNodes(j).text;
                var oId = $id(sId);
                var sDs = oId.dataset;
                var sField = oId.field;
                if (IsSpace(sDs) || IsSpace(sField)) continue;
                var fieldInfos = GetFieldInfos(sDs, sField);
                if (fieldInfos != "") {
                    sRet.append("<info><contid>" + sId + "</contid><dataset>" + sDs + "</dataset>" + fieldInfos + "</info>");
                }
            }
        }
    }
    return sRet.toString();
    function IsBindContType(typeName) {
        var ArrName = new Array();
        ArrName[0] = "checkbox";
        ArrName[1] = "radio";
        ArrName[2] = "listbox"
        ArrName[3] = "textarea"
        ArrName[4] = "combobox"
        ArrName[5] = "dbimg";
        ArrName[6] = "text";
        ArrName[7] = "dropdownlist";
        ArrName[8] = "spin";
        for (var i = 0; i < ArrName.length; i++) {
            if (typeName == ArrName[i]) return true;
        }
        return false;
    }
    function GetFieldInfos(sDs, sField) {
        var sFormat = new Sys.StringBuilder();
        var oXml = SetDom($id(sDs).formatxml);
        var l = oXml.documentElement.childNodes.length;
        for (var i = 0; i < l; i++) {
            var fdname = oXml.documentElement.childNodes(i).childNodes(0).text;
            if (fdname == sField) {
                var datatype = oXml.documentElement.childNodes(i).childNodes(2).text;
                var displaylabel = oXml.documentElement.childNodes(i).childNodes(1).text;
                var size = oXml.documentElement.childNodes(i).childNodes(3).text;
                var precision = oXml.documentElement.childNodes(i).childNodes(4).text;
                sFormat.append("<fieldname>" + fdname + "</fieldname>");
                sFormat.append("<datatype>" + datatype + "</datatype>");
                sFormat.append("<displaylabel>" + displaylabel + "</displaylabel>");
                sFormat.append("<size>" + size + "</size>");
                sFormat.append("<precision>" + precision + "</precision>");
                break;
            }
        }
        return sFormat.toString();
    }
}


Eapi.DbStru = function () { }
Eapi.DbStru.prototype =
{
    listTables: function (oCont) {
        if (oCont.tagName.indexOf("dataset") >= 0)
            this._listTablesToGrid(oCont);
        else
            this._listTablesToDropdownlist(oCont);
    },
    _listTablesToGrid: function (dsGrid) {
        if (fcpubdata.dbStruDict == "") {
            new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?GetAllTables", "<returnType>dataset</returnType><sFilter></sFilter>",
function (result) {
    var retX = result.value;
    var obj = result.context;
    obj.OpenXmlData(retX);
}
, dsGrid);
        } else {
            var sql = "select tbname,chnname from FC_TBLIST order by tbname";
            if (fcpubdata.dbStruDict == "FC_DBSTRU") sql = "select distinct tbname,tbchnname as chnname from FC_DBSTRU order by tbname";
            dsGrid.Open(sql, "nouse", function () { });
        }

    },
    _listTablesToDropdownlist: function (cboTableName) {
        cboTableName.onclickopen = function () {
            if (fcpubdata.dbStruDict == "FC_FLDLIST") {
                cboTableName.sql1 = "select tbname,chnname from FC_TBLIST where tbname like ':v_get%' order by tbname";
            } else if (fcpubdata.dbStruDict == "FC_DBSTRU") {
                cboTableName.sql1 = "select distinct tbname,tbchnname as chnname from FC_DBSTRU where tbname like ':v_get%' order by tbname";
            } else if (fcpubdata.dbStruDict == "") {
                cboTableName.xml = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?GetAllTables", "<returnType>dropdownlist</returnType><sFilter>" + new Eapi.Str().trim(cboTableName.value) + "</sFilter>");
            }
        }
    },
    listFields: function (tableName, oCont) {
        if (oCont.tagName.indexOf("dataset") >= 0)
            this._listFieldsToGrid(tableName, oCont);
        else
            this._listFieldsToDropdownlist(tableName, oCont);
    },
    _listFieldsToGrid: function (tableName, dsGrid) {
        var sql = "";
        if (fcpubdata.dbStruDict == "FC_DBSTRU") {
            sql = "select * from FC_DBSTRU where tbname='" + tableName + "' order by fdname";
        } else if (fcpubdata.dbStruDict == "FC_FLDLIST") {
            var s = "fdname";
            var s1 = "tbname";
            if (fcpubdata.databaseTypeName == "oracle") {
                s = "upper(new Eapi.Str().trim(fdname))";
                s1 = "new Eapi.Str().trim(tbname)"
            }
            sql = "select * from FC_FLDLIST where " + s + " in (select " + s + " from FC_TBSTRU where " + s1 + "='" + tableName + "') order by fdname ";
            if (fcpubdata.databaseTypeName == "mysql") {
                sql = "select a.* from FC_FLDLIST a ,FC_TBSTRU b where a.fdname=b.fdname and b.tbname='" + tableName + "' order by a.fdname";
            }
        }
        if (fcpubdata.dbStruDict == "") {
            var retX = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?GetFieldName", "<sql></sql><returnType>dataset</returnType><tableName>" + tableName + "</tableName>");
            dsGrid.OpenXmlData(retX);
        } else {
            dsGrid.Open(sql);
        }

    },
    _listFieldsToDropdownlist: function (tableName, cboFields) {
        var sql = "";
        if (fcpubdata.dbStruDict == "FC_DBSTRU") {
            sql = "select fdname,chnname from FC_DBSTRU where tbname='" + tableName + "' order by fdname";
        } else if (fcpubdata.dbStruDict == "FC_FLDLIST") {
            var s = "fdname";
            var s1 = "tbname";
            if (fcpubdata.databaseTypeName == "oracle") {
                s = "upper(new Eapi.Str().trim(fdname))";
                s1 = "new Eapi.Str().trim(tbname)"
            }
            sql = "select fdname,chnname from FC_FLDLIST where " + s + " in (select " + s + " from FC_TBSTRU where " + s1 + "='" + tableName + "') order by fdname ";
            if (fcpubdata.databaseTypeName == "mysql") {
                sql = "select a.fdname,a.chnname from FC_FLDLIST a ,FC_TBSTRU b where a.fdname=b.fdname and b.tbname='" + tableName + "' order by a.fdname";
            }
        }
        if (cboFields.tagName.toUpperCase() == "SELECT") {
            if (fcpubdata.dbStruDict == "") {
                var sOption = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?GetFieldName", "<sql>select * from " + tableName + "</sql><returnType>option</returnType><tableName></tableName>");
                cboFields.outerHTML = SelectAddOption(cboFields, sOption);
            } else {
                SqlCombo(cboFields, sql);
            }
        } else {
            if (fcpubdata.dbStruDict == "") {
                cboFields.xml = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?GetFieldName", "<sql>select * from " + tableName + "</sql><returnType>dropdownlist</returnType><tableName></tableName>");
            } else {
                cboFields.sql1 = sql;
            }
        }
    }
}
if (Type.parse("Eapi.DbStru") == null) Eapi.DbStru.registerClass("Eapi.DbStru");