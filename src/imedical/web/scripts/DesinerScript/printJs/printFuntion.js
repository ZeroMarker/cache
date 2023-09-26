//var testXml = null;
var testParamData = null;
//显示设计界面
function showDisiner() {
    $("#divMain").show();
    $("#srcHtml").hide();
}

//显示xml界面
function showXml() {
    $("#divMain").hide();
    parent.frCtrlAttr.hideAll();
    var bdDesiner = document.getElementById("dbLayout");
    $("#srcHtml").width(bdDesiner.style.width);
    $("#srcHtml").height(bdDesiner.style.height);
    $("#srcHtml").show();
    getXml();
}

//生成Xml
function getXml() {
    var plDataReprt = "";
    var plData = "";
    var txtDataReprt = "";
    var txtData = "";
    var listData = "";
    var picDataReprt = "";
    var picData = "";
    var count = editor.options.element.children.length;
    for (var index = 0; index < count; index++) {
        var ctrl = editor.options.element.children[index];
        var ctrlXml = "";
        switch (ctrl.ctrlType) {
            case "label":
                ctrlXml = labelToXml(ctrl);
                if (ctrl.RePrtHeadFlag && ctrl.RePrtHeadFlag == "Y") {
                    txtDataReprt = txtDataReprt + ctrlXml;
                }
                else {
                    txtData = txtData + ctrlXml;
                }
                break;
            case "img":
                ctrlXml = imgToXml(ctrl);
                if (ctrl.RePrtHeadFlag && ctrl.RePrtHeadFlag == "Y") {
                    picDataReprt = picDataReprt + ctrlXml;
                }
                else {
                    picData = picData + ctrlXml;
                }
                break;
            case "reporttable":
                ctrlXml = tableToXml(ctrl);
                listData = listData + ctrlXml;
                break;
            case "list":
                ctrlXml = listToXml(ctrl);
                listData = listData + ctrlXml;
                break;
            case "shape":
                ctrlXml = lineToXml(ctrl);
                if (ctrl.RePrtHeadFlag && ctrl.RePrtHeadFlag == "Y") {
                    plDataReprt = plDataReprt + ctrlXml;
                }
                else {
                    plData = plData + ctrlXml;
                }
                break;
        }
    }
    var reult = "<?xml version=\"1.0\" encoding=\"gb2312\" ?>\r\n";
    reult = reult + "<appsetting>\r\n";
    reult = reult + "<invoice height=\"" + subFloat(convertPxToPt(editor.options.bdLayout.style.height.replace("px", "")) / 10, 2) + "\" ";
    reult = reult + "width=\"" + subFloat(convertPxToPt(editor.options.bdLayout.style.width.replace("px", "")) / 10, 2) + "\" ";
    if (editor.options.bdLayout.PrtPaperSet) {
        reult = reult + "PrtPaperSet=\"" + editor.options.bdLayout.PrtPaperSet + "\" ";
    }
    else {
        reult = reult + "PrtPaperSet=\"HAND\" ";
    }
    if (editor.options.bdLayout.LandscapeOrientation) {
        reult = reult + "LandscapeOrientation=\"" + editor.options.bdLayout.LandscapeOrientation + "\" ";
    }
    if (editor.options.bdLayout.PrtDevice) {
        reult = reult + "PrtDevice=\"" + editor.options.bdLayout.PrtDevice + "\" ";
    }
    else {
        reult = reult + "PrtDevice=\"\" ";
    }
    if (editor.options.bdLayout.PrtPage) {
        reult = reult + "PrtPage=\"" + editor.options.bdLayout.PrtPage + "\" ";
    }
    else {
        reult = reult + "PrtPage=\"\" ";
    }
    reult = reult + ">";
    if (txtData != "") {
        reult = reult + " \r\n<TxtData  RePrtHeadFlag=\"N\">" + txtData + "</TxtData>";
    }
    if (picData != "") {
        reult = reult + " \r\n<PICData RePrtHeadFlag=\"N\">" + picData + "</PICData>";
    }
    if (plData != "") {
        reult = reult + " \r\n<PLData RePrtHeadFlag=\"N\">" + plData + "</PLData>";
    }
    if (listData != "") {
        reult = reult + listData;
    }
    else {
        if (editor.options.otherData == null || editor.options.otherData.length == 0) {
            reult = reult + "\r\n<ListData PrintType=\"List\" YStep=\"4.5\" XStep=\"0\" CurrentRow=\"1\" PageRows=\"30\" RePrtHeadFlag=\"Y\"></ListData>";
        }
    }
    if (txtDataReprt != "") {
        reult = reult + " \r\n<TxtData  RePrtHeadFlag=\"Y\">" + txtDataReprt + "</TxtData>";
    }
    if (picDataReprt != "") {
        reult = reult + " \r\n<PICData RePrtHeadFlag=\"Y\">" + picDataReprt + "</PICData>";
    }
    if (plDataReprt != "") {
        reult = reult + " \r\n<PLData RePrtHeadFlag=\"Y\">" + plDataReprt + "</PLData>";
    }
    if (editor.options.otherData != null && editor.options.otherData.length > 0) {
        var count = editor.options.otherData.length;
        for (var index = 0; index < count; index++) {
            reult = reult + " \r\n" + editor.options.otherData[index];
        }
    }
    //ActiveX bug Edit
    if (reult.indexOf("<PLData RePrtHeadFlag") < 0) {
        reult = reult + "\r\n<PLData RePrtHeadFlag=\"Y\"></PLData>";
    }
    if (reult.indexOf("<PICData RePrtHeadFlag") < 0) {
        reult = reult + "\r\n<PICData RePrtHeadFlag=\"N\"></PICData>";
    }
    if (reult.indexOf("<TxtData") < 0) {
        reult = reult + "\r\n<TxtData RePrtHeadFlag=\"N\"></TxtData>";
    }
    if (testParamData != null) {
        reult = reult + "\r\n<TestParamData>" + escape(testParamData) + "</TestParamData>";
    }
    
    reult = reult + "\r\n</invoice></appsetting>";
    $("#srcHtml").text(reult);
}

//打印预览
function printView() {
    if (document.getElementById("srcHtml").style.display == "none") {
        getXml();
    }
    PrintFun($("#srcHtml").text());
}

function showDesinerFromXml(strXml) {
    //testXml = strXml;
    var docobj = CreateXMLDOM();
    docobj.async = false;
    var rtn = docobj.loadXML(strXml);
    if (rtn) {
        editor.options.otherData = new Array();
        var pageNode = docobj.childNodes[1].childNodes[0];
        editor.options.bdLayout.style.height = convertPtToPx(parseFloat(pageNode.getAttribute("height")) * 10) + "px";
        editor.options.bdLayout.style.width = convertPtToPx(parseFloat(pageNode.getAttribute("width")) * 10) + "px";
        if (pageNode.getAttribute("PrtPaperSet") != "HAND") {
            editor.options.bdLayout.PrtPaperSet = pageNode.getAttribute("PrtPaperSet");
        }
        if (pageNode.getAttribute("PrtDevice") != "") {
            editor.options.bdLayout.PrtDevice = pageNode.getAttribute("PrtDevice");
        }
        if (pageNode.getAttribute("PrtPage") != "") {
            editor.options.bdLayout.PrtPage = pageNode.getAttribute("PrtPage");
        }
        if (pageNode.getAttribute("LandscapeOrientation") != "") {
            editor.options.bdLayout.LandscapeOrientation = pageNode.getAttribute("LandscapeOrientation");
        }

        var count = pageNode.childNodes.length;
        for (var index = 0; index < count; index++) {
            var oneNode = pageNode.childNodes[index];
            var childCount = oneNode.childNodes.length;
            switch (oneNode.nodeName.toUpperCase()) {
                case "TXTDATA":
                    if (childCount > 0) {
                        xmlToLabel(oneNode);
                    }
                    else {
                        editor.options.otherData.push(oneNode.xml);
                    }
                    break;
                case "PLDATA":
                    //if (childCount > 0) {
                    xmlToLine(oneNode);
                    //}
                    //else {
                    //editor.options.otherData.push(oneNode.xml);
                    //}
                    break;
                case "LISTDATA":
                    if (childCount > 0) {
                        //xmlToTable(oneNode);
                        xmlToList(oneNode);
                    }
                    else {
                        editor.options.otherData.push(oneNode.xml);
                    }
                    break;
                case "PICDATA":
                    if (childCount > 0) {
                        xmlToImg(oneNode);
                    }
                    else {
                        editor.options.otherData.push(oneNode.xml);
                    }
                    break;
                case "TESTPARAMDATA":
                    testParamData = unescape(oneNode.text);
                    break;
                default:
                    editor.options.otherData.push(oneNode.xml);
                    break;
            }
        }
    }
    var tempXmlData = $("#srcHtml").text();
    $("#srcHtml").text("");
    innitHtml = document.getElementById("dbLayout").outerHTML;
    $("#srcHtml").text(tempXmlData);
}

//文本转化为xml
function labelToXml(ctrl) {
    var lblXml = "\r\n<txtdatapara ";
    lblXml = lblXml + "name = \"" + ctrl.name + "\" ";
    lblXml = lblXml + "xcol = \"" + convertPxToPt(ctrl.style.left.replace("px", "")) + "\" ";
    lblXml = lblXml + "yrow = \"" + convertPxToPt(ctrl.style.top.replace("px", "")) + "\" ";
    if (ctrl.style.fontSize) {
        lblXml = lblXml + "fontsize = \"" + ctrl.style.fontSize.replace("pt", "") + "\" ";
    }
    else {
        lblXml = lblXml + "fontsize = \"12\" ";
    }
    if (ctrl.style.fontWeight == "bold") {
        lblXml = lblXml + "fontbold = \"true\" ";
    }
    else {
        lblXml = lblXml + "fontbold = \"false\" ";
    }
    if (ctrl.style.fontFamily) {
        lblXml = lblXml + "fontname = \"" + ctrl.style.fontFamily + "\" ";
    }
    else {
        lblXml = lblXml + "fontname = \"宋体\" ";
    }
    if (ctrl.defaultvalue == "true") {
        lblXml = lblXml + "defaultvalue = \"" + ctrl.innerText + "\" ";
    }
    else {
        lblXml = lblXml + "defaultvalue = \"\" ";
    }
    if (ctrl.printvalue) {
        lblXml = lblXml + "printvalue = \"" + ctrl.printvalue + "\" ";
    }
    else {
        lblXml = lblXml + "printvalue = \"\" ";
    }
	//Lid 2015-11-01
	if((ctrl.isqrcode)&&(ctrl.isqrcode=="Y")){
		//打印二维码时再加载属性
		if (ctrl.isqrcode=="Y") {
			lblXml = lblXml + "isqrcode = \"true\" ";
		}
		else {
			lblXml = lblXml + "isqrcode = \"false\" ";
		}
		if (ctrl.width) {
			lblXml = lblXml + "width = \"" + ctrl.width + "\" ";
		}
		else {
			lblXml = lblXml + "width = \"30\" ";
		}
		if (ctrl.height) {
			lblXml = lblXml + "height = \"" + ctrl.height + "\" ";
		}
		else {
			lblXml = lblXml + "height = \"30\" ";
		}	
	}
	
    lblXml = lblXml + " ></txtdatapara>";
    return lblXml;
}

function xmlToLabel(xmlNode) {
    var count = xmlNode.childNodes.length;
    var RePrtHeadFlag = "N";
    if (xmlNode.getAttribute("RePrtHeadFlag") != "N") {
        RePrtHeadFlag = xmlNode.getAttribute("RePrtHeadFlag");
    }
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = editor.getNewCtrlId("label");
        var ctrlHtml = "<label ctrlType='label'id=" + cId + " name=" + oneNode.getAttribute("name");
        ctrlHtml = ctrlHtml + " style='position:absolute;white-space:nowrap;border: 1px dotted #C0C0C0;left:" + convertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + convertPtToPx(oneNode.getAttribute("yrow")) + "px;";
        if (oneNode.getAttribute("defaultvalue") != "") {
            //ctrlHtml = ctrlHtml + "height:15px;";
        }
        else {
            //ctrlHtml = ctrlHtml + "width:20px;";
        }
        if (oneNode.getAttribute("fontsize") != "12") {
            ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
        }
        if (oneNode.getAttribute("fontbold") != "false") {
            ctrlHtml = ctrlHtml + "font-weight:bold;";
        }
        if (oneNode.getAttribute("fontname") != "宋体") {
            ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
        }
        ctrlHtml = ctrlHtml + "' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ";
        if (oneNode.getAttribute("printvalue") != "") {
            ctrlHtml = ctrlHtml + "printvalue=\"" + oneNode.getAttribute("printvalue") + "\" ";
        }
        if (RePrtHeadFlag != "N") {
            ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
        }
        
		//Lid 2015-11-01 添加二维码属性
		var isQRCode=oneNode.getAttribute("isqrcode");
		if(isQRCode&&(isQRCode=="true")){
			if (isQRCode=="true") {
				ctrlHtml = ctrlHtml + "isqrcode=\"" + "Y" + "\" ";
			}else{
				ctrlHtml = ctrlHtml + "isqrcode=\"" + "N" + "\" ";
			}
			if (oneNode.getAttribute("width") != "") {
				ctrlHtml = ctrlHtml + "width=\"" + oneNode.getAttribute("width") + "\" ";
			}
			if (oneNode.getAttribute("height") != "") {
				ctrlHtml = ctrlHtml + "height=\"" + oneNode.getAttribute("height") + "\" ";
			}
		}
		
		if ($.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + "defaultvalue=\"true\" ";
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue").replace(/\s/g, "&nbsp;") + "</label>";
        }
        else {
            ctrlHtml = ctrlHtml + "defaultvalue=\"false\" ";
            ctrlHtml = ctrlHtml + ">" + "[" + oneNode.getAttribute("name") + "]" + "</label>";
        }

        editor.setCtrlHtml(cId, ctrlHtml);
    }
}

//图片转化为xml
function imgToXml(ctrl) {
    var imgXml = "\r\n<PICdatapara ";
    imgXml = imgXml + "name = \"" + ctrl.name + "\" ";
    imgXml = imgXml + "xcol = \"" + convertPxToPt(ctrl.style.left.replace("px", "")) + "\" ";
    imgXml = imgXml + "yrow = \"" + convertPxToPt(ctrl.style.top.replace("px", "")) + "\" ";
    imgXml += 'width="'+convertPxToPt(ctrl.style.width.replace("px", "")) +'" ';
    imgXml += 'height="'+convertPxToPt(ctrl.style.height.replace("px", "")) +'" ';
    imgXml = imgXml + "defaultvalue = \"" + ctrl.src + "\" ";
    if (ctrl.printvalue) {
        imgXml = imgXml + "printvalue = \"" + ctrl.printvalue + "\" ";
    }
    else {
        imgXml = imgXml + "printvalue = \"\" ";
    }
    imgXml = imgXml + " ></PICdatapara>";
    return imgXml;
}

function xmlToImg(xmlNode) {
    var count = xmlNode.childNodes.length;
    var RePrtHeadFlag = "N";
    if (xmlNode.getAttribute("RePrtHeadFlag") != "N") {
        RePrtHeadFlag = xmlNode.getAttribute("RePrtHeadFlag");
    }
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = editor.getNewCtrlId("img");
        var ctrlHtml = "<img ctrlType='img' id=" + cId + " name=" + oneNode.getAttribute("name");
        ctrlHtml = ctrlHtml + " style='position:absolute;width:" + convertPtToPx(oneNode.getAttribute("width")) + "px;height:" + convertPtToPx(oneNode.getAttribute("height")) + "px;left:" + convertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + convertPtToPx(oneNode.getAttribute("yrow")) + "px;' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd()";
        
        if (oneNode.getAttribute("defaultvalue") != "") {
            ctrlHtml = ctrlHtml + "src='" + oneNode.getAttribute("printvalue") + "' ";
        }
        if (oneNode.getAttribute("printvalue") != "") {
            ctrlHtml = ctrlHtml + "printvalue='" + oneNode.getAttribute("printvalue") + "' ";
        }
        if (RePrtHeadFlag != "N") {
            ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
        }
        ctrlHtml = ctrlHtml + "/>";
        editor.setCtrlHtml(cId, ctrlHtml);
    }
}

function tableToXml(ctrl) {
    var listXml = "\r\n <ListData PrintType=\"List\"  YStep=\"" + convertPxToPt(ctrl.style.height.replace("px", "")) + "\" ";
    if (ctrl.XStep) {
        listXml = listXml + "XStep=\"" + ctrl.XStep + "\" ";
    }
    else {
        listXml = listXml + "XStep=\"0\" ";
    }
    if (ctrl.CurrentRow) {
        listXml = listXml + "CurrentRow=\"" + ctrl.CurrentRow + "\" ";
    }
    else {
        listXml = listXml + "CurrentRow=\"0\" ";
    }
    if (ctrl.PageRows) {
        listXml = listXml + "PageRows=\"" + ctrl.PageRows + "\" ";
    }
    else {
        listXml = listXml + "PageRows=\"10\" ";
    }
    if (ctrl.RePrtHeadFlag) {
        listXml = listXml + "RePrtHeadFlag=\"" + ctrl.RePrtHeadFlag + "\" ";
    }
    else {
        listXml = listXml + "RePrtHeadFlag=\"N\" ";
    }
    listXml = listXml + ">";
    var fontStyle = " ";
    if (ctrl.style.fontSize) {
        fontStyle = fontStyle + "fontsize = \"" + ctrl.style.fontSize.replace("pt", "") + "\" ";
    }
    else {
        fontStyle = fontStyle + "fontsize = \"12\" ";
    }
    if (ctrl.style.fontWeight == "bold") {
        fontStyle = fontStyle + "fontbold = \"true\" ";
    }
    else {
        fontStyle = fontStyle + "fontbold = \"false\" ";
    }
    if (ctrl.style.fontFamily) {
        fontStyle = fontStyle + "fontname = \"" + ctrl.style.fontFamily + "\" ";
    }
    else {
        fontStyle = fontStyle + "fontname = \"宋体\" ";
    }
    var allTd = ctrl.rows[0].cells;
    var count = ctrl.rows[0].cells.length;
    var xStart = parseInt(ctrl.style.left.replace("px", ""), 10);
    var yStart = parseInt(ctrl.style.top.replace("px", ""), 10);
    if (ctrl.CurrentRow) {
        yStart = yStart - parseInt(ctrl.style.height.replace("px", ""), 10) * parseInt(ctrl.CurrentRow, 10);
    }
    for (var index = 0; index < count; index++) {
        var nodeName = "Listdatapara";
        if (allTd[index].xmlName) {
            nodeName = allTd[index].xmlName;
        }
        var tdXml = "\r\n<" + nodeName + " name=\"" + allTd[index].name + "\"";
        tdXml = tdXml + " xcol=\"" + convertPxToPt(xStart) + "\"";
        tdXml = tdXml + " yrow=\"" + convertPxToPt(yStart) + "\"";
        tdXml = tdXml + fontStyle;
        if (allTd[index].defaultvalue == "true") {
            tdXml = tdXml + "defaultvalue = \"" + allTd[index].innerText + "\" ";
        }
        else {
            tdXml = tdXml + "defaultvalue = \"\" ";
        }
        if (allTd[index].printvalue) {
            tdXml = tdXml + "printvalue = \"" + allTd[index].printvalue + "\" ";
        }
        else {
            tdXml = tdXml + "printvalue = \"\" ";
        }
        tdXml = tdXml + " ></" + nodeName + ">";
        xStart = xStart + parseInt(allTd[index].style.width.replace("px", ""), 10);
        listXml = listXml + tdXml;
    }
    listXml = listXml + "</ListData>";
    return listXml;
}

function xmlToTable(xmlNode) {
    var count = xmlNode.childNodes.length;
    var RePrtHeadFlag = "N";
    if (xmlNode.getAttribute("RePrtHeadFlag") != "N") {
        RePrtHeadFlag = xmlNode.getAttribute("RePrtHeadFlag");
    }
    var cId = editor.getNewCtrlId("reporttable");
    var ctrlHtml = "<table ctrlType='reporttable' id = '" + cId + "' cellpadding='0' cellspacing='1' ";
    if (RePrtHeadFlag != "N") {
        ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
    }
    if (xmlNode.getAttribute("CurrentRow") != "0") {
        ctrlHtml = ctrlHtml + "CurrentRow='" + xmlNode.getAttribute("CurrentRow") + "' ";
    }
    if (xmlNode.getAttribute("PageRows") != "10") {
        ctrlHtml = ctrlHtml + "PageRows='" + xmlNode.getAttribute("PageRows") + "' ";
    }
    if (xmlNode.getAttribute("XStep") != "0") {
        ctrlHtml = ctrlHtml + "XStep='" + xmlNode.getAttribute("XStep") + "' ";
    }
    var fontStyle = "";
    if (xmlNode.childNodes[0].getAttribute("fontsize") != "12") {
        fontStyle = fontStyle + "font-size:" + xmlNode.childNodes[0].getAttribute("fontsize") + "pt;";
    }
    if (xmlNode.childNodes[0].getAttribute("fontbold") != "false") {
        fontStyle = fontStyle + "font-weight:bold;";
    }
    if (xmlNode.childNodes[0].getAttribute("fontname") != "宋体") {
        fontStyle = fontStyle + "font-family:" + xmlNode.childNodes[0].getAttribute("fontname") + ";";
    }
    var postion = getStartXY(xmlNode);
    var padTop = 0;
    if (xmlNode.getAttribute("CurrentRow") != "0") {
        padTop = convertPtToPx(xmlNode.getAttribute("YStep")) * parseInt(xmlNode.getAttribute("CurrentRow"), 10);
    }
    ctrlHtml = ctrlHtml + "style='position:absolute;background-color: #99BBE8;left:" + postion[0] + "px;top:" + (postion[1] + padTop) + "px;width:" + (postion[2] + 50) + "px;height:" + convertPtToPx(xmlNode.getAttribute("YStep")) + "px;" + fontStyle + "'onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd()><tr style='background-color:white;'>";

    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var width = 50;
        if (index + 1 < count) {
            var nextNode = xmlNode.childNodes[index + 1];
            width = convertPtToPx(nextNode.getAttribute("xcol")) - convertPtToPx(oneNode.getAttribute("xcol"));
        }
        var tdHtml = "<td style='width:" + width + "px;' name='" + oneNode.getAttribute("name") + "'";
        if (oneNode.getAttribute("printvalue") != "") {
            tdHtml = tdHtml + " printvalue='" + oneNode.getAttribute("printvalue") + "' ";
        }
        if (oneNode.tagName != "Listdatapara") {
            tdHtml = tdHtml + " xmlName='" + oneNode.tagName + "' ";
        }
        if ($.trim(oneNode.getAttribute("defaultvalue")) != "") {
            tdHtml = tdHtml + "defaultvalue=\"true\" ";
            tdHtml = tdHtml + " >" + oneNode.getAttribute("defaultvalue") + "</td>";
        }
        else {
            tdHtml = tdHtml + "defaultvalue=\"false\" ";
            tdHtml = tdHtml + " >" + "[" + oneNode.getAttribute("name") + "]" + "</td>";
        }

        ctrlHtml = ctrlHtml + tdHtml;
    }
    ctrlHtml = ctrlHtml + "</tr></table>";
    editor.setCtrlHtml(cId, ctrlHtml);
}

function listToXml(ctrl) {
    var listXml = "\r\n <ListData PrintType=\"List\"  YStep=\"" + convertPxToPt(ctrl.style.height.replace("px", "")) + "\" ";
    if (ctrl.XStep) {
        listXml = listXml + "XStep=\"" + ctrl.XStep + "\" ";
    }
    else {
        listXml = listXml + "XStep=\"0\" ";
    }
    if (ctrl.CurrentRow) {
        listXml = listXml + "CurrentRow=\"" + ctrl.CurrentRow + "\" ";
    }
    else {
        listXml = listXml + "CurrentRow=\"1\" ";
    }
    if (ctrl.PageRows) {
        listXml = listXml + "PageRows=\"" + ctrl.PageRows + "\" ";
    }
    else {
        listXml = listXml + "PageRows=\"10\" ";
    }
    if (ctrl.RePrtHeadFlag) {
        listXml = listXml + "RePrtHeadFlag=\"" + ctrl.RePrtHeadFlag + "\" ";
    }
    else {
        listXml = listXml + "RePrtHeadFlag=\"N\" ";
    }
    listXml = listXml + ">";

    var allItems = ctrl.children;
    var count = allItems.length;
    var xStart = parseInt(ctrl.style.left.replace("px", ""), 10);
    var yStart = parseInt(ctrl.style.top.replace("px", ""), 10);
    if (ctrl.CurrentRow) {
        yStart = yStart - parseInt(ctrl.style.height.replace("px", ""), 10) * parseInt(ctrl.CurrentRow, 10);
    }
    for (var index = 0; index < count; index++) {
        var nodeName = "Listdatapara";
        if (allItems[index].xmlName) {
            nodeName = allItems[index].xmlName;
        }
        var itemXml = "\r\n<" + nodeName + " name=\"" + allItems[index].name + "\"";
        var xcol = parseInt(allItems[index].style.left.replace("px", ""), 10);
        var yrow = parseInt(allItems[index].style.top.replace("px", ""), 10);
        itemXml = itemXml + " xcol=\"" + convertPxToPt(xStart + xcol) + "\"";
        itemXml = itemXml + " yrow=\"" + convertPxToPt(yStart + yrow) + "\"";
        var fontStyle = " ";
        if (allItems[index].style.fontSize) {
            fontStyle = fontStyle + "fontsize = \"" + allItems[index].style.fontSize.replace("pt", "") + "\" ";
        }
        else {
            fontStyle = fontStyle + "fontsize = \"12\" ";
        }
        if (allItems[index].style.fontWeight == "bold") {
            fontStyle = fontStyle + "fontbold = \"true\" ";
        }
        else {
            fontStyle = fontStyle + "fontbold = \"false\" ";
        }
        if (allItems[index].style.fontFamily) {
            fontStyle = fontStyle + "fontname = \"" + allItems[index].style.fontFamily + "\" ";
        }
        else {
            fontStyle = fontStyle + "fontname = \"宋体\" ";
        }
        itemXml = itemXml + fontStyle;
        if (allItems[index].printvalue) {
            itemXml = itemXml + " printvalue=\"" + allItems[index].printvalue + "\" ";
        }
        else {
            itemXml = itemXml + " printvalue=\"\" ";
        }
        if (allItems[index].defaultvalue == "true") {
            itemXml = itemXml + "defaultvalue = \"" + allItems[index].innerText + "\" ";
        }
        else {
            itemXml = itemXml + "defaultvalue = \"\" ";
        }
        itemXml = itemXml + " ></" + nodeName + ">";
        listXml = listXml + itemXml;
    }
    listXml = listXml + "</ListData>";
    return listXml;
}

function xmlToList(xmlNode) {
    var count = xmlNode.childNodes.length;
    var RePrtHeadFlag = "N";
    if (xmlNode.getAttribute("RePrtHeadFlag") != "N") {
        RePrtHeadFlag = xmlNode.getAttribute("RePrtHeadFlag");
    }
    var cId = editor.getNewCtrlId("list");
    var ctrlHtml = "<div ctrlType='list' id = '" + cId + "' ";
    if (RePrtHeadFlag != "N") {
        ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
    }
    //if (xmlNode.getAttribute("CurrentRow")) {
        ctrlHtml = ctrlHtml + "CurrentRow='" + xmlNode.getAttribute("CurrentRow") + "' ";
    //}
    if (xmlNode.getAttribute("PageRows") != "1") {
        ctrlHtml = ctrlHtml + "PageRows='" + xmlNode.getAttribute("PageRows") + "' ";
    }
    if (xmlNode.getAttribute("XStep") != "0") {
        ctrlHtml = ctrlHtml + "XStep='" + xmlNode.getAttribute("XStep") + "' ";
    }
    var postion = getStartXY(xmlNode);
    var padTop = 0;
    if (xmlNode.getAttribute("CurrentRow") != "0") {
        padTop = convertPtToPx(xmlNode.getAttribute("YStep")) * parseInt(xmlNode.getAttribute("CurrentRow"), 10);
    }
    ctrlHtml = ctrlHtml + "style='position:absolute;border: 1px solid #99BBE8; margin:0px; padding:0px;left:" + postion[0] + "px;top:" + (postion[1] + padTop) + "px;width:" + (postion[2] + 100) + "px;height:" + convertPtToPx(xmlNode.getAttribute("YStep")) + "px;'onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd()>";
    var childHtml = "";
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        childHtml = childHtml + xmlToListItem(oneNode, postion[0], postion[1]);
    }
    ctrlHtml = ctrlHtml + childHtml + "</div>";
    editor.setCtrlHtml(cId, ctrlHtml);
}

function xmlToListItem(oneNode, startX, startY) {
    var cId = editor.getNewCtrlId("label");
    var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + oneNode.getAttribute("name");
    ctrlHtml = ctrlHtml + " style='position:absolute;border: 1px dotted #C0C0C0;left:" + (convertPtToPx(oneNode.getAttribute("xcol")) - startX) + "px;top:" + (convertPtToPx(oneNode.getAttribute("yrow")) - startY) + "px;"
    if (oneNode.getAttribute("fontsize") != "12") {
        ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
    }
    if (oneNode.getAttribute("fontbold") != "false") {
        ctrlHtml = ctrlHtml + "font-weight:bold;";
    }
    if (oneNode.getAttribute("fontname") != "宋体") {
        ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
    }
    ctrlHtml = ctrlHtml + "' onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() ";
    if (oneNode.getAttribute("printvalue") != "") {
        ctrlHtml = ctrlHtml + "printvalue='" + oneNode.getAttribute("printvalue") + "' ";
    }
    if (oneNode.tagName != "Listdatapara") {
        ctrlHtml = ctrlHtml + " xmlName='" + oneNode.tagName + "' ";
    }
    if ($.trim(oneNode.getAttribute("defaultvalue")) != "") {
        ctrlHtml = ctrlHtml + "defaultvalue=\"true\" ";
        ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue") + "</label>";
    }
    else {
        ctrlHtml = ctrlHtml + "defaultvalue=\"false\" ";
        ctrlHtml = ctrlHtml + ">" + "[" + oneNode.getAttribute("name") + "]" + "</label>";
    }
    return ctrlHtml;
}

function getStartXY(xmlNode) {
    var count = xmlNode.childNodes.length;
    var startX = null;
    var startY = null;
    var endX = null;
    var endY = null;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var xcol = parseFloat(oneNode.getAttribute("xcol"), 10);
        var yrow = parseFloat(oneNode.getAttribute("yrow"), 10);
        if (startX == null) {
            startX = xcol;
        }
        else {
            if (xcol < startX) {
                startX = xcol;
            }
        }
        if (startY == null) {
            startY = yrow;
        }
        else {
            if (yrow < startY) {
                startY = yrow;
            }
        }

        if (endX == null) {
            endX = xcol;
        }
        else {
            if (xcol > endX) {
                endX = xcol;
            }
        }
        if (endY == null) {
            endY = yrow;
        }
        else {
            if (yrow > endY) {
                endY = yrow;
            }
        }
    }
    var result = Array();
    result.push(convertPtToPx(startX));
    result.push(convertPtToPx(startY));
    result.push(convertPtToPx(endX - startX));
    result.push(convertPtToPx(endY - startY));
    return result;
}

//线转化为xml
function lineToXml(ctrl) {
    var lineXml = "\r\n<PLine ";
    if (ctrl.name) {
        lineXml = lineXml + "name = \"" + ctrl.name + "\" ";
    }
    if (ctrl.lineType == "1") {
        lineXml = lineXml + "BeginX = \"" + convertPxToPt(ctrl.style.left.replace("px", "")) + "\" ";
        lineXml = lineXml + "BeginY = \"" + convertPxToPt(ctrl.style.top.replace("px", "")) + "\" ";
        lineXml = lineXml + "EndX = \"" + convertPxToPt(parseInt(ctrl.style.left.replace("px", ""), 10) + parseInt(ctrl.style.width.replace("px", ""), 10)) + "\" ";
        lineXml = lineXml + "EndY = \"" + convertPxToPt(ctrl.style.top.replace("px", "")) + "\" ";
    }
    else if (ctrl.lineType == "2") {
        lineXml = lineXml + "BeginX = \"" + convertPxToPt(ctrl.style.left.replace("px", "")) + "\" ";
        lineXml = lineXml + "BeginY = \"" + convertPxToPt(ctrl.style.top.replace("px", "")) + "\" ";
        lineXml = lineXml + "EndX = \"" + convertPxToPt(ctrl.style.left.replace("px", "")) + "\" ";
        lineXml = lineXml + "EndY = \"" + convertPxToPt(parseInt(ctrl.style.top.replace("px", ""), 10) + parseInt(ctrl.style.height.replace("px", ""), 10)) + "\" ";
    }
    else if (ctrl.lineType == "3") {
        lineXml = lineXml + "BeginX = \"" + convertPxToPt(ctrl.style.left.replace("px", "")) + "\" ";
        lineXml = lineXml + "BeginY = \"" + convertPxToPt(parseInt(ctrl.style.top.replace("px", ""), 10) + parseInt(ctrl.style.height.replace("px", ""), 10)) + "\" ";
        lineXml = lineXml + "EndX = \"" + convertPxToPt(parseInt(ctrl.style.left.replace("px", ""), 10) + parseInt(ctrl.style.width.replace("px", ""), 10)) + "\" ";
        lineXml = lineXml + "EndY = \"" + convertPxToPt(ctrl.style.top.replace("px", "")) + "\" ";
    }
    else if (ctrl.lineType == "4") {
        lineXml = lineXml + "BeginX = \"" + convertPxToPt(ctrl.style.left.replace("px", "")) + "\" ";
        lineXml = lineXml + "BeginY = \"" + convertPxToPt(ctrl.style.top.replace("px", "")) + "\" ";
        lineXml = lineXml + "EndX = \"" + convertPxToPt(parseInt(ctrl.style.left.replace("px", ""), 10) + parseInt(ctrl.style.width.replace("px", ""), 10)) + "\" ";
        lineXml = lineXml + "EndY = \"" + convertPxToPt(parseInt(ctrl.style.top.replace("px", ""), 10) + parseInt(ctrl.style.height.replace("px", ""), 10)) + "\" ";
    }
    lineXml = lineXml + " ></PLine>";
    return lineXml;
}

function xmlToLine(xmlNode) {
    var count = xmlNode.childNodes.length;
    var RePrtHeadFlag = "N";
    if (xmlNode.getAttribute("RePrtHeadFlag") != "N") {
        RePrtHeadFlag = xmlNode.getAttribute("RePrtHeadFlag");
    }
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = editor.getNewCtrlId("shape");
        var ctrlHtml = '<v:line ctrlType="shape" id="' + cId + '" name="' + oneNode.getAttribute("Name") + '" ';
        if (RePrtHeadFlag != "N") {
            ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
        }
        var BeginX = convertPtToPx(oneNode.getAttribute("BeginX"));
        var BeginY = convertPtToPx(oneNode.getAttribute("BeginY"));
        var EndX = convertPtToPx(oneNode.getAttribute("EndX"));
        var EndY = convertPtToPx(oneNode.getAttribute("EndY"));
        var width = EndX - BeginX;
        var height = EndY - BeginY;
        if (height == 0 && width != 0) {
            if (width > 0) {
                ctrlHtml = ctrlHtml + 'lineType ="1" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:10px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,0" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
            else {
                ctrlHtml = ctrlHtml + 'lineType ="1" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + EndX + 'px;width:' + Math.abs(width) + 'px;height:10px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,0" to = "' + Math.abs(width) + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
        }
        else if (width == 0 && height != 0) {
            if (height > 0) {
                ctrlHtml = ctrlHtml + 'lineType ="2" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:10px;height:' + height + 'px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,0" to = "0,' + height + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
            else {
                ctrlHtml = ctrlHtml + 'lineType ="2" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + BeginX + 'px;width:10px;height:' + Math.abs(height) + 'px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,0" to = "0,' + Math.abs(height) + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
        }
        else if (height < 0 && width > 0) {
            height = BeginY - EndY;
            ctrlHtml = ctrlHtml + 'lineType ="3" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:' + height + 'px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,' + height + 'px" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height > 0 && width < 0) {
            width = BeginX - EndX;
            ctrlHtml = ctrlHtml + 'lineType ="3" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + EndX + 'px;width:' + width + 'px;height:' + height + 'px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,' + height + 'px" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height > 0 && width > 0) {
            ctrlHtml = ctrlHtml + 'lineType ="4" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:' + height + 'px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,0" to = "' + width + 'px,' + height + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height < 0 && width < 0) {
            ctrlHtml = ctrlHtml + 'lineType ="4" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + EndX + 'px;width:' + Math.abs(width) + 'px;height:' + Math.abs(height) + 'px;" onresizestart=ctrlResizeStart() onresizeend=ctrlResizeEnd() onmovestart=ctrlMoveStart() onmoveend=ctrlMoveEnd() from = "0,0" to = "' + Math.abs(width) + 'px,' + Math.abs(height) + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        editor.setCtrlHtml(cId, ctrlHtml);
    }
}

function convertPxToPt(pxValue) {
    return subFloat(parseFloat(pxValue, 10) / 3.78, 3);
}

function convertPtToPx(ptValue) {
    return subFloat((parseFloat(ptValue, 10)) * 3.78, 0);
}

function subFloat(num, v) {
    var vv = Math.pow(10, v);
    return Math.round(num * vv) / vv;
}

//创建xml读取对象
function CreateXMLDOM() {
    var ActiveX = new Array("MSXML2.DOMDocument.5.0",
                                                        "MSXML2.DOMDocument.4.0",
                                                        "MSXML2.DOMDocument.3.0",
                                                        "MSXML2.DOMDocument",
                                                        "Microsoft.XMLDOM",
                                                        "MSXML.DOMDocument");
    for (var i = 0; i < ActiveX.length; i++) {
        try {
            return new ActiveXObject(ActiveX[i]);
        }
        catch (e) { }
    }
    return null;
}

//打印预览
function PrintFun(mystr) {
    try {
        var inpara = "";
        var inlist = "";
        var printParams = GetField();
        if (printParams[0].length != 0 || printParams[1]) {
            var result = window.showModalDialog("SetReportPrams.HTML", printParams, "location:No;status:No;help:No;dialogWidth:580px;dialogHeight:500px;scroll:no;");
            if (result) {
                inpara = result[0];
                inlist = result[1];
                testParamData = result[2];
            }
        }
        //var inlist = "01^02^03^04^05^06^07^08^09^10" + String.fromCharCode(2) + "01^02^03^04^05^06^07^08^09^10";
        var PObj = document.getElementById("ClsBillPrint");
        var docobj = CreateXMLDOM();
        docobj.async = false;
        var rtn = docobj.loadXML(mystr);

        //var docobj2 = CreateXMLDOM();
        //docobj2.async = false;
        //var rtn2 = docobj2.loadXML(testXml);
        if ((rtn)) {
            var rtn = PObj.ToPrintHDLP(inpara, inlist, docobj);
            //var rtn = PObj.ToPrintDocNew(inpara, inlist, docobj2);
        }
    } catch (e) {
        return;
    }
}

function SaveXml() {
    if (document.getElementById("srcHtml").style.display == "none") {
        getXml();
    }
    var reportXml = $("#srcHtml").text();
    var param = null;
    if (URLParams["action"] == "Add") {
        var result = window.showModalDialog("SetReportName.HTML", URLParams, "location:No;status:No;help:No;dialogWidth:240px;dialogHeight:170px;scroll:no;");
        if (!result) { return; }
        param = [{ name: 'ExcuteAction', value: 'Add' },
            { name: 'reportXml', value: reportXml },
            { name: 'reportName', value: result[0] },
            { name: 'reportNote', value: result[1]}]
    }
    else if (URLParams["action"] == "Update") {
        var result = window.showModalDialog("SetReportName.HTML", URLParams, "location:No;status:No;help:No;dialogWidth:240px;dialogHeight:170px;scroll:no;");
        if (!result) { return; }
        param = [{ name: 'ExcuteAction', value: 'Update' },
                { name: 'reportID', value: URLParams["reportId"] },
                { name: 'reportXml', value: reportXml },
                { name: 'reportNote', value: result[1]}]
    }
    //将数据保存到数据库
    $.ajax({
        type: 'POST',
        url: "../../web/web.DHCPrintDesigner.cls", //decodeURI(URLParams["accessURL"]),2019-03-21
        data: param,
        dataType: 'json',
        success: function(data) {
            if (URLParams["action"] == "Add") {
                URLParams["action"] = "Update";
                URLParams["reportId"] = data;
                URLParams["reportName"] = result[0];
            }
            URLParams["reportNote"] = result[1];
            var tempXmlData = $("#srcHtml").text();
            $("#srcHtml").text("");
            innitHtml = document.getElementById("dbLayout").outerHTML;
            $("#srcHtml").text(tempXmlData);
            alert("保存成功!");
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert("保存失败!你输入的报表名可能已经存在");
        }
    });
}

function OpenReport() {
    var param = [{ name: 'ExcuteAction', value: 'ReadOne' }, { name: 'reportID', value: URLParams["reportId"]}];
    //读取报表
    $.ajax({
        type: 'POST',
        url: "../../web/web.DHCPrintDesigner.cls", //decodeURI(URLParams["accessURL"]), 2019-03-21
        data: param,
        dataType: 'text',
        success: function(data) {
            showDesinerFromXml(data);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert("获取报表失败!");
        }
    });
}

function GetField() {
    var filedArray = new Array();
    var haveList = false;
    //var listFiledArray = new Array();
    var count = editor.options.element.children.length;
    for (var index = 0; index < count; index++) {
        var ctrl = editor.options.element.children[index];
        var ctrlXml = "";
        if (ctrl) {
            switch (ctrl.ctrlType) {
                case "label":
                    if (ctrl.defaultvalue == "false") {
                        filedArray.push(ctrl.name);
                    }
                    break;
                case "list":
                    var allItems = ctrl.children;
                    if (allItems.length > 0) {
                        haveList = true;
                    }
                    //for (var num = 0; num < count; num++) {
                    //    listFiledArray.push(allItems[num].name);
                    //}
                    break;
                default:
                    break;
            }
        }
    }
    //return [filedArray, listFiledArray, testParamData];
    return [filedArray, haveList, testParamData];
}