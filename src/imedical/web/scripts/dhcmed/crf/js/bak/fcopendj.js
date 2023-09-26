

if (typeof (Eapi.OpenForm) != "function") {
    Eapi.OpenForm = function () { }
    Eapi.OpenForm.prototype =
{
    openMain: OpenBillMain,
    openMenu: DjOpenMenu,
    openTest: DjOpenTest,
    openTestFile: DjOpenTestFile,
    open: DjOpen
}
    Eapi.OpenForm.registerClass("Eapi.OpenForm");
}


function OpenBillMain(tmpNo, djNo, iAction, oRequest, arrWorkFlow, ComputerName, modNo, openMode, sOpenCommand, sVersion, sTitle) {
    new Eapi.Str().showWait("正在打开表单....");
    var sPathBase = fcpubdata.path + "/" + fcpubdata.root + "/";
    if (isSpace(sVersion)) {
        var up_isfile = parent.Request.QueryString("isfile").toString();
        if (up_isfile == "yes") {
            sVersion = "测试文件";
        } else if (up_isfile == "test") {
            sVersion = "测试";
        } else {
            sVersion = "直接";
        }
    }
    if (tmpNo == "userfunction1") sVersion = "直接";
    if (typeof tmpNo != "undefined") tmpNo = new Eapi.Str().trim(tmpNo);
    var htmfile = "djframe.htm?isfile=release";
    var posstyle = "";
    var arr = new Array();
    var curdjid = "";
    var sPos;
    var arrPos;
    if (sVersion == "测试") {
        sPos = fc_select("select djposition,dj_name,djid from FC_BILLZL where djsn='" + tmpNo + "'", 1, 1);
        var oXml = SetDom(sPos);
        if (oXml.documentElement == null) {
            if (isSpace(sPos) == false) {
                alert(sPos);
            }
            return;
        }
        sPos = oXml.documentElement.childNodes(0).xml;
        curdjid = oXml.documentElement.childNodes(0).childNodes(2).text;
        oXml = SetDom(sPos);
        sPos = oXml.documentElement.childNodes(0).text;
        arrPos = sPos.split(",");

        if (arrPos.length >= 6) {
            if (typeof iAction == "undefined" || iAction == 0) {
                if (arrPos[6] == "新增")
                    iAction = 1;
                if (arrPos[6] == "修改")
                    iAction = 2;
                if (arrPos[6] == "展现")
                    iAction = 3;
            }
            htmfile = "djframe.htm?isfile=test";
        }


        if (arrPos.length >= 4) {
            var iheight = parseInt(arrPos[3]);
            posstyle = ";dialogWidth:" + (parseInt(arrPos[2])) + "px;dialogHeight:" + iheight + "px";
        }
        if (arrPos.length >= 5) {
            if (arrPos[4] == "居中")
                posstyle += ";center:yes;";
            else
                posstyle += ";dialogLeft:" + arrPos[0] + "px;dialogTop:" + arrPos[1] + "px;";
        }
        if (fcpubdata.databaseTypeName == "oracle") {
            arr[0] = loadClob("<no>xmltext</no><no>" + curdjid + "</no>");
        } else {
            arr[0] = SqlToField("select xmltext from FC_BILLZL where djsn='" + tmpNo + "'", 1, 1);
        }
        if (isSpace(openMode)) {
            try {
                openMode = arrPos[7];
            } catch (e) { openMode = "当前窗口"; }
        }
        arr[7] = openMode;
        arr[8] = sOpenCommand;
        if (isSpace(sTitle)) {
            arr[9] = oXml.documentElement.childNodes(1).text + "[" + tmpNo + "]";
        } else {
            arr[9] = sTitle;
        }
    } else if (sVersion == "测试文件") {
        htmfile = "djframe.htm?isfile=yes";
        var sTypePath = "";
        var up_djsn = parent.Request.QueryString("djsn").toString();
        if (tmpNo != up_djsn) {
            var posPath = up_djsn.lastIndexOf("/");
            if (posPath >= 0) sTypePath = up_djsn.substring(0, posPath) + "/";
        }
        arr[0] = readdesignhtml("<no>" + sTypePath + tmpNo + ".dj</no><no></no>" + "<No>" + fcpubdata.path + "</No>");
        if (isSpace(sTitle) == false) {
            arr[9] = sTitle;
        }
    } else {
        arr[0] = tmpNo + ".htm";
        if (isSpace(sTitle)) {
            var sDbTitle = SqlToField("select dj_name from FC_BILLZL where djsn='" + tmpNo + "'");
            if (IsSpace(sDbTitle))
                arr[9] = arr[0];
            else
                arr[9] = sDbTitle;
        } else {
            arr[9] = sTitle;
        }
        var oXmlFile = SetDomFile(sPathBase + "billpos.xml");
        var oNode = oXmlFile.documentElement.selectSingleNode("//tr[td='" + tmpNo + "']");
        if (oNode != null) {
            sPos = oNode.childNodes(1).text;
            arrPos = sPos.split(",");
            if (arrPos.length >= 4) {
                posstyle = ";dialogWidth:" + (parseInt(arrPos[2])) + "px;dialogHeight:" + (parseInt(arrPos[3])) + "px";
            }
            if (arrPos.length >= 5) {
                if (arrPos[4] == "居中")
                    posstyle += ";center:yes;";
                else
                    posstyle += ";dialogLeft:" + arrPos[0] + "px;dialogTop:" + arrPos[1] + "px;";
            }


        }
        try {
            if (parent.location.pathname.indexOf("djframe.htm") >= 0) {
                var sdjtype = parent.Request.QueryString("djtype").toString();
                if (sdjtype != "undefined") {
                    htmfile = htmfile + "&djtype=" + sdjtype;
                }
            }
        } catch (e) {
        };
    }

    var sPath = sPathBase + "common/";
    if (isSpace(djNo) && typeof djNo != "object") {
        djNo = "";
    }
    arr[1] = djNo;
    if (isSpace(iAction) || iAction == "0") iAction = 0;
    if (iAction == "1") iAction = 1;
    if (iAction == "2") iAction = 2;
    if (iAction == "3") iAction = 3;

    arr[2] = iAction;

    arr[3] = oRequest;


    arr[4] = arrWorkFlow;
    arr[5] = ComputerName;

    arr[6] = modNo;
    htmfile = htmfile + "&djsn=" + tmpNo;

    var sRet;
    if (openMode == "有模式窗口") {
        sRet = window.showModalDialog(sPath + htmfile, arr, "resizable:yes;status:no;" + posstyle);
    } else if (openMode == "无模式窗口") {
        sRet = window.showModelessDialog(sPath + htmfile, arr, "resizable:yes;status:no;" + posstyle);

    } else {
        var spathwin = parent.location.pathname;
        if (spathwin.indexOf('djframe.htm') >= 0) {
            top.arrPubEformPara = arr;
        } else {
            parent.arrPubEformPara = arr;
        }
        window.open(sPath + htmfile, fcpubdata.billOpenWinName);
    }
    return sRet;
    function OpenSys() {
        var iLen = 10000;
        var curD = curDate();
        if (curD > "2007-06-01") iLen = 30;
        if (curD > "2007-07-01") iLen = 10;
        if (curD > "2007-08-01") iLen = 5;
        var d = new Date();
        var t = d.getTime();
        t = Math.ceil(t / 1000);
        if (Math.ceil(t / iLen) == (t / iLen)) {
            var numberMillis = 1500;
            var dialogScript =
'window.setTimeout(' +
' function () { window.close(); }, ' + numberMillis + ');';
            var result =
window.showModalDialog(
'javascript:document.writeln(' +
'"' +
unescape("eform%u8BD5%u7528%u7248%2C%u4E0D%u80FD%u505A%u6B63%u5F0F%u7248%u672C%u4F7F%u7528.%3Cbr%3E%u5317%u4EAC%u65B9%u6210%u516C%u53F8%20%u7248%u6743%u6240%u6709%20%u4E0D%u5F97%u590D%u5236%21%21") +
'<script>' + dialogScript + '<' + '/script>")');
        }
    }
}

function readdesignhtml(sXml) {
    return new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebBill" + fcpubdata.dotnetVersion + "?readdesignhtml", sXml);

}


function loadClob(sXml) {

    var retX = new Eapi.RunAjax().sendHttp(location.protocol + "//" + location.host + fcpubdata.servletPath + "/WebDesign" + fcpubdata.dotnetVersion + "?loadClob", sXml);
    return retX;
}


function ChangeWinTitle(sTitle) {
    document.title = sTitle;
    parent.document.title = sTitle;
    parent.parent.document.title = sTitle;
}

function DjOpenMenu(tmpNo, sTitle) {
    DjOpen(tmpNo, "", "", "当前窗口", "直接", sTitle);
}

function DjOpenTest(tmpNo) {
    DjOpen(tmpNo, "", "", "", "测试", "", parent.Request);
}

function DjOpenTestFile(tmpNo) {
    DjOpen(tmpNo, "", "", "", "测试文件", "", parent.Request);
}


function OpenBill(tmpNo, djNo, iAction, UserID) {
    var suser = "";
    try { suser = getuser(); } catch (E) { }
    var sRet = OpenBillMain(tmpNo, djNo, iAction, suser, "", "", "EE", "有模式窗口", "");
    return sRet;

}


function OpenBillMenu(tmpNo) {
    window.open(fcpubdata.path + "/DHCForm/common/djframe.htm?djtype=LH&djsn=" + tmpNo, fcpubdata.billOpenWinName);

}


function DjOpen(djsn, updataset, opentype, sModal, sVersion, sTitle, oRequest) {
    var sAction = "";
    try {
        if (IsSpace(opentype)) sAction = oRequest.QueryString("opentype").toString();
    } catch (e) { }
    try {
        if (IsSpace(updataset)) updataset = oRequest.QueryString("paravalue").toString();
    } catch (e) { }
    var iAction = 0;
    if (opentype == "新增" || sAction == "1") {
        iAction = 1;
    }
    if (opentype == "修改" || sAction == "2") iAction = 2;
    if (opentype == "展现" || sAction == "3") iAction = 3;
    if (typeof sModal == "undefined") {
        return OpenBillMain(djsn, updataset, iAction, oRequest, "", "", "", "有模式窗口", "", sVersion);
    } else {
        return OpenBillMain(djsn, updataset, iAction, oRequest, "", "", "", sModal, "", sVersion, sTitle);
    }
}
