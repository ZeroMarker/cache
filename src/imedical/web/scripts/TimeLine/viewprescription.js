// 设定访问地址
var PatientInfo = new Array();
var MyList = new Array();
var accessURL = "../../web/web.DHCPrintDesigner.cls";
$(document).ready(function() {
    frm_onload();
});

//页面加载
function frm_onload() {
    GetData();
    OpenReport();
}

//读取报表模板
function OpenReport() {
    if(ReportId == "")
    {
      return;
  }
    var param = [{ name: 'ExcuteAction', value: 'ReadOne' }, { name: 'reportID', value: ReportId}];
    //读取报表
    $.ajax({
        type: 'POST',
        url: accessURL,
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
function removeTextNode(doc){
	if (!doc.childNodes) return;
	for (var i=0;i<doc.childNodes.length;i++){
		var node=doc.childNodes[i];
		if (node.nodeName=="#text") {
			doc.removeChild(node);
			i--;
		}else{
			removeTextNode(node);
		}
	}
}
///获取xml根节点 appsetting
function getPageNode(strXml){
	if (!!window.ActiveXObject || "ActiveXObject" in window){
		var docobj = CreateXMLDOM();
		docobj.async = false;
		var rtn = docobj.loadXML(strXml);
		if (rtn) var pageNode = docobj.childNodes[1].childNodes[0];
	}else{  //Chrome 
		var parser=new DOMParser();
		var docobj=parser.parseFromString(strXml,"text/xml");
		removeTextNode(docobj);  //会有很多文本节点  移除
		var pageNode = docobj.childNodes[0].childNodes[0];
	}
	return pageNode;
}
//将xml转化为html显示出来
function showDesinerFromXml(strXml) {
	var pageNode=getPageNode(strXml);
	//console.log(pageNode);
    var bdLayout = document.getElementById("dbLayout");
    if (pageNode) {
	    var pageHeight=convertPtToPx(parseFloat(pageNode.getAttribute("height")) * 10);
	    var pageWidth=convertPtToPx(parseFloat(pageNode.getAttribute("width")) * 10);
        bdLayout.style.height =  pageHeight+ "px";
        bdLayout.style.width =  pageWidth + "px";
        var canvas=document.getElementById("canvas");
		try{
			var ctx = canvas.getContext("2d");
			canvas.width=pageWidth;
			canvas.height=pageHeight;
		}catch(e){
			alert('不支持canvas');
			bdLayout.removeChild(canvas);
			var ctx=null;
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
                    break;
                case "PLDATA":
                    //xmlToLine(oneNode);
                    xmlToLineNew(oneNode,ctx);
                    break;
                case "LISTDATA":
                    if (childCount > 0) {
                        //xmlToTable(oneNode);
                        //xmlToList(oneNode);
                        xmlToListNew(oneNode);
                    }
                    break;
                case "PICDATA":
                    if (childCount > 0) {
                        xmlToImg(oneNode);
                    }
                    break;
                case "TESTPARAMDATA":
                    break;
                default:
                    break;
            }
        }
    }
    $('#divReport').html(GV_HtmlArray.join(''));  //改了setCtrlHtml 统一在这直接更新html
    var tempXmlData = $("#srcHtml").text();
    $("#srcHtml").text("");
    innitHtml = document.getElementById("dbLayout").outerHTML;
    $("#srcHtml").text(tempXmlData);
}


//将图片转化为html
function xmlToImg(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = getNewCtrlId("img");
        var ctrlHtml = "<img ctrlType='img' id=" + cId + " name=" + oneNode.getAttribute("name");
        ctrlHtml = ctrlHtml + " style='position:absolute;left:" + convertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + convertPtToPx(oneNode.getAttribute("yrow")) + "px;' ";
        if (oneNode.getAttribute("defaultvalue") != "") {
            ctrlHtml = ctrlHtml + "imgSrc='" + oneNode.getAttribute("defaultvalue") + "' ";
        }
        if (RePrtHeadFlag != "N") {
            ctrlHtml = ctrlHtml + "RePrtHeadFlag='" + RePrtHeadFlag + "' ";
        }
        ctrlHtml = ctrlHtml + "/>";
        setCtrlHtml(cId, ctrlHtml);
    }
}

//将xml中的list 转化为html中的list
function xmlToList(xmlNode) {
    var cList = MyList.length;
    for (var num = 0; num < cList; num++) {
        var count = xmlNode.childNodes.length;
        var cId = getNewCtrlId("list");
        var ctrlHtml = "<div ctrlType='list' id = '" + cId + "' ";
        ctrlHtml = ctrlHtml + "CurrentRow='" + xmlNode.getAttribute("CurrentRow") + "' ";
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
        var yPosition = num * convertPtToPx(xmlNode.getAttribute("YStep"));
        ctrlHtml = ctrlHtml + "style='position:absolute; margin:0px; padding:0px;left:" + postion[0] + "px;top:" + (postion[1] + padTop + yPosition) + "px;width:" + (postion[2] + 100) + "px;height:" + convertPtToPx(xmlNode.getAttribute("YStep")) + "px;'>";
        var childHtml = "";
        for (var index = 0; index < count; index++) {
            var oneNode = xmlNode.childNodes[index];
            childHtml = childHtml + xmlToListItem(oneNode, postion[0], postion[1] , MyList[num]);
        }
        ctrlHtml = ctrlHtml + childHtml + "</div>";
        setCtrlHtml(cId, ctrlHtml);
    }
}
function xmlToListNew(xmlNode) {
	var $hiddenDiv=$('<div style="position:absolute;top:-1000;"></div>').appendTo('body');
    var cList = MyList.length;
    var yPosition=0,lastListRowHeight=0;
    for (var num = 0; num < cList; num++) {
        var count = xmlNode.childNodes.length;
        var cId = getNewCtrlId("list");
        var ctrlHtml = "<div ctrlType='list' id = '" + cId + "' ";
        ctrlHtml = ctrlHtml + "CurrentRow='" + xmlNode.getAttribute("CurrentRow") + "' ";
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
        //var yPosition = num * convertPtToPx(xmlNode.getAttribute("YStep"));
        yPosition+=lastListRowHeight;
        ctrlHtml = ctrlHtml + "style='position:absolute; margin:0px; padding:0px;left:" + postion[0] + "px;top:" + (postion[1] + padTop + yPosition) + "px;width:" + (postion[2] + 100) + "px;height:" + convertPtToPx(xmlNode.getAttribute("YStep")) + "px;'>";
        var currListRowHeight=convertPtToPx(xmlNode.getAttribute("YStep"));
        for (var index = 0; index < count; index++) {
            var oneNode = xmlNode.childNodes[index];
            var childHtml = xmlToListItem(oneNode, postion[0], postion[1] , MyList[num].split("^")[index]);
            var $childHtml=$(childHtml).appendTo($hiddenDiv);
            currListRowHeight=Math.max(currListRowHeight,$childHtml.outerHeight()+parseInt($childHtml.css('top'))||0 );
            $childHtml.remove();
            childHtml = childHtml + childHtml;
        }
        ctrlHtml = ctrlHtml + childHtml + "</div>";
        setCtrlHtml(cId, ctrlHtml);
        lastListRowHeight=currListRowHeight;
    }
}

//将list中的一项转化为html list中的一项
function xmlToListItem(oneNode, startX, startY,showValue) {
    var cId = getNewCtrlId("label");
    var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + oneNode.getAttribute("name");
    ctrlHtml = ctrlHtml + " style='position:absolute;white-space:nowrap;left:" + (convertPtToPx(oneNode.getAttribute("xcol")) - startX) + "px;top:" + (convertPtToPx(oneNode.getAttribute("yrow")) - startY) + "px;"
    if (oneNode.getAttribute("fontsize") != "12") {
        ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
    }
    if (oneNode.getAttribute("fontbold") != "false") {
        ctrlHtml = ctrlHtml + "font-weight:bold;";
    }
    if (oneNode.getAttribute("fontname") != "宋体") {
        ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
    }
    ctrlHtml = ctrlHtml + "' ";
    if (showValue == "") {
        if ($.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue") + "</label>";
        }
    }
    else {
        ctrlHtml = ctrlHtml + ">" + showValue.replace("", "&nbsp;&nbsp;").replace(/\s/g, "&nbsp;") + "</label>";
    }
    return ctrlHtml;
}

//取得开始坐标
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

//xml中的label转化为html中的label
function xmlToLabel(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = getNewCtrlId("label");
        var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + oneNode.getAttribute("name");
        ctrlHtml = ctrlHtml + " style='position:absolute;white-space:nowrap;left:" + convertPtToPx(oneNode.getAttribute("xcol")) + "px;top:" + convertPtToPx(oneNode.getAttribute("yrow")) + "px;";
        if (oneNode.getAttribute("fontsize") != "12") {
            ctrlHtml = ctrlHtml + "font-size:" + oneNode.getAttribute("fontsize") + "pt;";
        }
        if (oneNode.getAttribute("fontbold") != "false") {
            ctrlHtml = ctrlHtml + "font-weight:bold;";
        }
        if (oneNode.getAttribute("fontname") != "宋体") {
            ctrlHtml = ctrlHtml + "font-family:" + oneNode.getAttribute("fontname") + ";";
        }
        ctrlHtml = ctrlHtml + "' ";
        var printValue = PatientInfo[oneNode.getAttribute("name")];
        if (printValue) {
            ctrlHtml = ctrlHtml + ">" + printValue.replace(/\s/g, "&nbsp;&nbsp;") + "</label>";
        }
        else if ($.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue").replace(/\s/g, "&nbsp;&nbsp;") + "</label>";
        }
        else {
            ctrlHtml = ctrlHtml + "></label>";
        }

        setCtrlHtml(cId, ctrlHtml);
    }
}

//将xml中的线z转化为html中的线
function xmlToLine(xmlNode) {
    var count = xmlNode.childNodes.length;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        var cId = getNewCtrlId("shape");
        var ctrlHtml = '<v:line ctrlType="shape" id="' + cId + '" name="' + oneNode.getAttribute("Name") + '" ';
        var BeginX = convertPtToPx(oneNode.getAttribute("BeginX"));
        var BeginY = convertPtToPx(oneNode.getAttribute("BeginY"));
        var EndX = convertPtToPx(oneNode.getAttribute("EndX"));
        var EndY = convertPtToPx(oneNode.getAttribute("EndY"));
        var width = EndX - BeginX;
        var height = EndY - BeginY;
        if (height == 0 && width != 0) {
            if (width > 0) {
                ctrlHtml = ctrlHtml + 'lineType ="1" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:10px;"  from = "0,0" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
            else {
                ctrlHtml = ctrlHtml + 'lineType ="1" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + EndX + 'px;width:' + Math.abs(width) + 'px;height:10px;"  from = "0,0" to = "' + Math.abs(width) + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
        }
        else if (width == 0 && height != 0) {
            if (height > 0) {
                ctrlHtml = ctrlHtml + 'lineType ="2" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:10px;height:' + height + 'px;"  from = "0,0" to = "0,' + height + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
            else {
                ctrlHtml = ctrlHtml + 'lineType ="2" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + BeginX + 'px;width:10px;height:' + Math.abs(height) + 'px;"  from = "0,0" to = "0,' + Math.abs(height) + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
            }
        }
        else if (height < 0 && width > 0) {
            height = BeginY - EndY;
            ctrlHtml = ctrlHtml + 'lineType ="3" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:' + height + 'px;"  from = "0,' + height + 'px" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height > 0 && width < 0) {
            width = BeginX - EndX;
            ctrlHtml = ctrlHtml + 'lineType ="3" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + EndX + 'px;width:' + width + 'px;height:' + height + 'px;"  from = "0,' + height + 'px" to = "' + width + 'px,0" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height > 0 && width > 0) {
            ctrlHtml = ctrlHtml + 'lineType ="4" style="POSITION: absolute; TOP:' + BeginY + 'px; LEFT:' + BeginX + 'px;width:' + width + 'px;height:' + height + 'px;"  from = "0,0" to = "' + width + 'px,' + height + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        else if (height < 0 && width < 0) {
            ctrlHtml = ctrlHtml + 'lineType ="4" style="POSITION: absolute; TOP:' + EndY + 'px; LEFT:' + EndX + 'px;width:' + Math.abs(width) + 'px;height:' + Math.abs(height) + 'px;"  from = "0,0" to = "' + Math.abs(width) + 'px,' + Math.abs(height) + 'px" fillcolor = "white" strokecolor = "black" strokeweight = ".75pt"><v:stroke></v:stroke></v:line>';
        }
        setCtrlHtml(cId, ctrlHtml);
    }
}
//将xml中的线z转化为html中的线
function xmlToLineNew(xmlNode,ctx) {
	if (ctx){
		var count = xmlNode.childNodes.length;
		ctx.beginPath();
	    for (var index = 0; index < count; index++) {
	        var oneNode = xmlNode.childNodes[index];
	        var cId = getNewCtrlId("shape");
	        var ctrlHtml = '<div ctrlType="shape" id="' + cId + '" name="' + oneNode.getAttribute("Name") + '" ';
	        var BeginX = convertPtToPx(oneNode.getAttribute("BeginX"),1);
	        var BeginY = convertPtToPx(oneNode.getAttribute("BeginY"),1);
	        var EndX = convertPtToPx(oneNode.getAttribute("EndX"),1);
	        var EndY = convertPtToPx(oneNode.getAttribute("EndY"),1);

	        //canvas 点在整数 线会粗
	        ctx.moveTo(Math.floor(BeginX)+0.5,Math.floor(BeginY)+0.5);
	        ctx.lineTo(Math.floor(EndX)+0.5,Math.floor(EndY)+0.5);
	    }
	    ctx.lineWidth = 1;
        ctx.strokeStyle = '#000';
        ctx.stroke();
		
	}else{
		xmlToLine(xmlNode);   //不支持canvas的，走原来的方法 使用vml画出来的线
	}

}
var GV_CtrlIdCounter={};
//取得新控件Id
function getNewCtrlId(ctrlType) {
	GV_CtrlIdCounter[ctrlType]=(GV_CtrlIdCounter[ctrlType]||0)+1;
	return ctrlType+GV_CtrlIdCounter[ctrlType];
    var index = 0;
    while (true) {
        index++;
        var cId = ctrlType + index;
        if ($("#" + cId).length == 0) {
            return cId;
        }
    }
};
var GV_HtmlArray=[];
//设定新控件的html
function setCtrlHtml(cId, ctrlHtml) {
	GV_HtmlArray.push(ctrlHtml);
	return;
	
    var divReport = document.getElementById("divReport");
    divReport.innerHTML += ctrlHtml;
    return;
};

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

//将xml中的pt转化为px  
//4舍5入方法支持小数位数  此方法也加个参数支持下
function convertPtToPx(ptValue,v) {
	v=v||0;
    return subFloat((parseFloat(ptValue, 10)) * 3.78, v);
}

//对数据四舍五入
function subFloat(num, v) {
    var vv = Math.pow(10, v);
    return Math.round(num * vv) / vv;
}

//获取显示的数据
function GetData() {
    if (IsCYPrescType ==1) {
        PrintPrescCY("", "",ReportData);
        PatientInfo=OrderPrescInfo;  
    }
    else {
        PrintPrescXY("", "");
    }
}

///西药打印
function PrintPrescXY(prescno, PreFlag) {
    try {
        var phl = "", prt = "";
        var zf = ''
        var tmparr = ReportData.split("!!")
        var patinfo = tmparr[0]
        var patarr = tmparr[0].split("^") ||[]
        //
        var PatNo = patarr[0];
        var PatientName = patarr[1];
        var PatientSex = patarr[2];
        var PatientAge = patarr[3];
        var ReclocDesc = patarr[11];
        var AdmDate = patarr[13] //就诊日期
        var PatH = patarr[5];
        var PyName = patarr[6];
        var FyName = patarr[7];
        var PatientCompany = patarr[12];  //工作单位
        var PatientMedicareNo = patarr[14]; //医保编号
        var PrescNo = patarr[15]
        var AdmDepDesc = patarr[23]
        var Doctor = patarr[24]
        var Paddress = patarr[19]
        var TelNo = patarr[18]
        var OrdDate = patarr[31]
        var PayDate = patarr[32]
        var PrtDate = patarr[10]
        var DMFlag = patarr[22]
        if (DMFlag != "") var DMFlag = '[' + DMFlag + ']'
        var BillFlag = patarr[33]
        var BillFlag = '[' + BillFlag + ']'
        var TelNo = patarr[18]
        var BillAuditFlag = patarr[34]
        //
        var diag = patarr[4] || "";
        var DiagnoseArray = diag.split(",")
        var DiagnoseArrayLen = DiagnoseArray.length
        var m = 0;

        var PrescTitle = ""
        var BillType = ""
        var PoisonClass = "";
        var MRNo = "";
        if(patarr.length>37){
       		MRNo = patarr[37];
        }
        var TotalSum = 0

        var barcode = "" //"*"+PrescNo+"*"
        if(patarr.length>38){
			PatientInfo['HosName'] = patarr[38]+"处方笺";
        }
        //var MyPara = 'PrescTitle' + String.fromCharCode(2) + PrescTitle;
        PatientInfo['PrescTitle'] = PrescTitle;
        //MyPara = MyPara + '^zf' + String.fromCharCode(2) + zf;
        PatientInfo['zf'] = zf;
        //MyPara = MyPara + '^PresType' + String.fromCharCode(2) + '处方笺';
        PatientInfo['PresType'] = '处方笺';
        //MyPara = MyPara + '^PatientMedicareNo' + String.fromCharCode(2) + PatientMedicareNo;
        PatientInfo['PatientMedicareNo'] = PatientMedicareNo;
        //MyPara = MyPara + '^PrescNo' + String.fromCharCode(2) + PrescNo;
        PatientInfo['PrescNo'] = PrescNo;
        //MyPara = MyPara + '^MRNo' + String.fromCharCode(2) + MRNo;
        PatientInfo['MRNo'] = MRNo;
        //MyPara = MyPara + '^PANo' + String.fromCharCode(2) + PatNo;
        PatientInfo['PANo'] = PatNo;
        //MyPara = MyPara + '^RecLoc' + String.fromCharCode(2) + ReclocDesc;
        PatientInfo['RecLoc'] = ReclocDesc;
        //MyPara = MyPara + '^Name' + String.fromCharCode(2) + PatientName;
        PatientInfo['Name'] = PatientName;
        //MyPara = MyPara + '^Sex' + String.fromCharCode(2) + PatientSex;
        PatientInfo['Sex'] = PatientSex;
        //MyPara = MyPara + '^Age' + String.fromCharCode(2) + PatientAge;
        PatientInfo['Age'] = PatientAge;
        //MyPara = MyPara + '^Address' + String.fromCharCode(2) + Paddress;
        PatientInfo['Address'] = Paddress;
        //MyPara = MyPara + '^AdmDep' + String.fromCharCode(2) + AdmDepDesc;
        PatientInfo['AdmDep'] = AdmDepDesc;
        //MyPara = MyPara + '^PatH' + String.fromCharCode(2) + PatH;
        PatientInfo['PatH'] = PatH;
        //MyPara = MyPara + '^PyName' + String.fromCharCode(2) + PyName;
        PatientInfo['PyName'] = PyName;
        //MyPara = MyPara + '^FyName' + String.fromCharCode(2) + FyName;
        PatientInfo['FyName'] = FyName;
        //MyPara = MyPara + '^Barcode' + String.fromCharCode(2) + barcode;
        PatientInfo['Barcode'] = barcode;
        //MyPara = MyPara + '^OrdDate' + String.fromCharCode(2) + OrdDate;
        PatientInfo['OrdDate'] = OrdDate;
        //MyPara = MyPara + '^PayDate' + String.fromCharCode(2) + PayDate;
        PatientInfo['PayDate'] = PayDate;
        //MyPara = MyPara + '^PrtDate' + String.fromCharCode(2) + PrtDate;
        PatientInfo['PrtDate'] = PrtDate;
        //MyPara = MyPara + '^DMFlag' + String.fromCharCode(2) + DMFlag;
        PatientInfo['DMFlag'] = DMFlag;
        //MyPara = MyPara + '^BillFlag' + String.fromCharCode(2) + BillFlag;
        PatientInfo['BillFlag'] = BillFlag;
        //MyPara = MyPara + '^TelNo' + String.fromCharCode(2) + TelNo;
        PatientInfo['TelNo'] = TelNo;
        //MyPara = MyPara + '^PrtRemark' + String.fromCharCode(2) + "说明:药品名称前有";
        PatientInfo['PrtRemark'] = "说明:药品名称前有";
        //MyPara = MyPara + '^PrtRemark1' + String.fromCharCode(2) + String.fromCharCode(9650) + "表示需皮试药品";
        PatientInfo['PrtRemark1'] = String.fromCharCode(9650) + "表示需皮试药品";
        //MyPara = MyPara + '^BillAuditFlag' + String.fromCharCode(2) + BillAuditFlag
        PatientInfo['BillAuditFlag'] = BillAuditFlag;
        PatientInfo['AdmDate']=AdmDate; //就诊日期没显示出来
        PatientInfo['Title']=PatientInfo['HosName']; //Title 替代了原来的HosName
	    //就诊日期label后面对应的是OrdDate
	    PatientInfo['OrdDate'] = AdmDate;
	    //就诊卡号 Name也变了
	    PatientInfo['patCardNo'] = PatientMedicareNo;
	    //费别
	    PatientInfo['BillType']=patarr[33];
	    PatientInfo['Company']=PatientCompany;
	    PatientInfo['PrescTitle']=({'':'','I':'【住院】','O':'【门诊】','E':'【急诊】','H':'【体检】'})[patarr[41]||''];
        //获取流水号
        var SerialNo=tkMakeServerCall("User.PAQue1PrtSerial","GetPrtSerial",PrescNo,"");
        if (SerialNo!=""){
	    	PatientInfo['PrescSerialNo']=SerialNo;   
	    }

        
        var intLen = 8
        for (var i = 0; i < DiagnoseArrayLen; i++) {

            ss = DiagnoseArray[i]
            strContent = DiagnoseArray[i]

            var m = m + 1;
            var diaglen = DiagnoseArray[i].length

            if (diaglen > 8) {

                while (strContent.length > intLen) {

                    strTemp = strContent.substr(0, intLen);
                    //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strTemp;
                    PatientInfo['Diagnose' + m] = strTemp;
                    m = m + 1
                    strContent = strContent.substr(intLen, strContent.length);

                }

                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strContent;
                PatientInfo['Diagnose' + m] = strContent;

            }
            else {
                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + ss;
                PatientInfo['Diagnose' + m] = ss;

            }

        }

        var sum = 0;
        var medinfo = tmparr[1]
        var medarr = medinfo.split("@")
        var mlength = medarr.length
        for (h = 0; h < mlength; h++) {
            var medrow = medarr[h]
            var rowarr = medrow.split("^")
            var OrderName = rowarr[0]
            var PackQty = rowarr[1] + rowarr[2]
            var DoseQty = rowarr[3]
            var Inst = rowarr[4]
            var Freq = rowarr[5]
            var Lc = rowarr[6]
            var totalprice = rowarr[8]
            var Ordremark = rowarr[10] || ""
            var Testflag = rowarr[9]
            var Seqno = rowarr[11]
	    if ("undefined"==typeof Seqno) continue;
            if (Testflag != "") {
                Seqno = Seqno + String.fromCharCode(9650)
            }
            if (Ordremark.length > 10) {
                Ordremark = Ordremark.substr(0, 10) + "...";
            }

            var OrderName = Seqno + " " + OrderName

            var firstdesc = OrderName + ' X ' + PackQty
            var inststring = "<br>          用法:每次" + DoseQty + "     " + Freq + "     " + Inst + "     " + Ordremark

            var firstdesc = firstdesc + String.fromCharCode(2) + inststring

            if (MyList == '') {
                MyList.push(firstdesc);
            } else {
                //MyList = MyList + String.fromCharCode(2) + firstdesc;
                MyList.push(firstdesc);
            }

            var sum = parseFloat(sum) + parseFloat(totalprice);
        }


        var TotalSum = sum.toFixed(2)
        //MyPara = MyPara + '^Sum' + String.fromCharCode(2) + TotalSum + '元';
        PatientInfo['Sum'] = TotalSum + '元';
        //MyPara = MyPara + '^AdmDep' + String.fromCharCode(2) + AdmDepDesc;
        PatientInfo['AdmDep'] = AdmDepDesc;
        //MyPara = MyPara + '^UserAddName' + String.fromCharCode(2) + Doctor;
        PatientInfo['UserAddName'] = Doctor;

        //DHCP_GetXMLConfig(XMLElementName, "DHCOutPrescXYPrt");
        //var myobj = document.getElementById("ClsBillPrint");
        //DHCP_PrintFun(myobj, MyPara, MyList);

    } catch (e) { alert(e.message) }
}

//草药通过DHCOPPrtCommon.js中的
/*
//打印处方草药   
function PrintPrescCY(prescno, PreFlag) {
    try {
        var totalmoney = 0;
        var phl = ""
        var prt = ""
        var zf = ''
        var MyList = "";
        var tmparr = ReportData.split("!!")
        var patinfo = tmparr[0]
        var ordinfo = tmparr[1]

        //
        var patarr = patinfo.split("^")
        var Quefac = patarr[26]
        var Queinst = patarr[25]
        var AdmDepDesc = patarr[23]
        var Queqty = patarr[27]
        var PatH = patarr[5];
        var ReclocDesc = patarr[11];
        var PyName = patarr[6];
        var FyName = patarr[7];
        var FyDate = patarr[8];
        var PrescNo = patarr[15];
        var PatNo = patarr[0];
        var Patloc = patarr[16];
        var PatientName = patarr[1];
        var PatientSex = patarr[2];
        var Doctor = patarr[24];
        var PatientAge = patarr[3];
        var Patcall = patarr[18];
        var Pataddress = patarr[19];
        var OrdDate = patarr[31];
        var Quecook = patarr[20];
        var Diag = patarr[4];
        var PayDate = patarr[32]
        var PrtDate = patarr[10]
        var barcode = "" //"*"+PrescNo+"*"
        var DMFlag = patarr[22]
        if (DMFlag != "") var DMFlag = '[' + DMFlag + ']'
        var BillFlag = patarr[33]
        var BillFlag = '[' + BillFlag + ']'
        var TelNo = patarr[18]
        var BillAuditFlag = patarr[34]

        //

        var ordarr = ordinfo.split("@")
        var OrdRows = ordarr.length
        var pc = new Array(new Array(), new Array());

        for (i = 0; i < OrdRows; i++) {

            var ordstr = ordarr[i];
            var SStr = ordstr.split("^")
            pc[i] = new Array();
            var OrderName = SStr[0]
            var Quenote = SStr[12]
            var Queuom = SStr[2]
            var Oneqty = SStr[1] / parseFloat(Quefac)
            var Price = SStr[7]
            var money = SStr[8]
            totalmoney = totalmoney + parseFloat(money); //金额

            pc[i][1] = OrderName + "" + Oneqty.toString() + Queuom + " " + Quenote //+" "+Price

        }
        var singlemoney = (totalmoney / parseFloat(Quefac)).toFixed(2)
        var totalmoney = totalmoney.toFixed(2);

        var FacInfo = "共" + Quefac + "剂" + " " + "用法:" + Queinst + "  一次用量:" + Queqty
        var MoneyInfo = "一付金额:" + singlemoney + "  合计金额:" + totalmoney


        var MyPara = "";
        var MyList = ""

        var m = 0;
        var PrescTitle = ""
        var PatientMedicareNo = ""
        var BillType = ""
        var PoisonClass = ""
       var MRNo = "";
        if(patarr.length>37){
       		MRNo = patarr[37];
        }
       if(patarr.length>38){
			PatientInfo['HosName'] = patarr[38]+"处方笺";
        }
        //var MyPara = 'PrescTitle' + String.fromCharCode(2) + PrescTitle;
        PatientInfo['PrescTitle'] = PrescTitle;
        //MyPara = MyPara + '^zf' + String.fromCharCode(2) + zf;
        PatientInfo['zf'] = zf;
        //MyPara = MyPara + '^PresType' + String.fromCharCode(2) + '处方笺';
        PatientInfo['PresType'] = '处方笺';
        //MyPara = MyPara + '^PatientMedicareNo' + String.fromCharCode(2) + PatientMedicareNo;
        PatientInfo['PatientMedicareNo'] = PatientMedicareNo;
        //MyPara = MyPara + '^PrescNo' + String.fromCharCode(2) + PrescNo;
        PatientInfo['PrescNo'] = PrescNo;
        //MyPara = MyPara + '^MRNo' + String.fromCharCode(2) + MRNo;
        PatientInfo['MRNo'] = MRNo;
        //MyPara = MyPara + '^PANo' + String.fromCharCode(2) + PatNo;
        PatientInfo['PANo'] = PatNo;
        //MyPara = MyPara + '^RecLoc' + String.fromCharCode(2) + ReclocDesc;
        PatientInfo['RecLoc'] = ReclocDesc;
        //MyPara = MyPara + '^Name' + String.fromCharCode(2) + PatientName;
        PatientInfo['Name'] = PatientName;
        //MyPara = MyPara + '^Sex' + String.fromCharCode(2) + PatientSex;
        PatientInfo['Sex'] = PatientSex;
        //MyPara = MyPara + '^Age' + String.fromCharCode(2) + PatientAge;
        PatientInfo['Age'] = PatientAge;
        //MyPara = MyPara + '^Address' + String.fromCharCode(2) + Pataddress;
        PatientInfo['Address'] = Pataddress;
        //MyPara = MyPara + '^AdmDep' + String.fromCharCode(2) + AdmDepDesc;
        PatientInfo['AdmDep'] = AdmDepDesc;
        //MyPara = MyPara + '^PatH' + String.fromCharCode(2) + PatH;
        PatientInfo['PatH'] = PatH;
        //MyPara = MyPara + '^PyName' + String.fromCharCode(2) + PyName;
        PatientInfo['PyName'] = PyName;
        //MyPara = MyPara + '^FyName' + String.fromCharCode(2) + FyName;
        PatientInfo['FyName'] = FyName;
        //MyPara = MyPara + '^Barcode' + String.fromCharCode(2) + barcode;
        PatientInfo['Barcode'] = barcode;
        //MyPara = MyPara + '^OrdDate' + String.fromCharCode(2) + OrdDate;
        PatientInfo['OrdDate'] = OrdDate;
        //MyPara = MyPara + '^PayDate' + String.fromCharCode(2) + PayDate;
        PatientInfo['PayDate'] = PayDate;
        //MyPara = MyPara + '^PrtDate' + String.fromCharCode(2) + PrtDate;
        PatientInfo['PrtDate'] = PrtDate;
        //MyPara = MyPara + '^DMFlag' + String.fromCharCode(2) + DMFlag;
        PatientInfo['DMFlag'] = DMFlag;
        //MyPara = MyPara + '^BillFlag' + String.fromCharCode(2) + BillFlag;
        PatientInfo['BillFlag'] = BillFlag;
        //MyPara = MyPara + '^TelNo' + String.fromCharCode(2) + TelNo;
        PatientInfo['TelNo'] = TelNo;
        //MyPara = MyPara + '^PrtRemark' + String.fromCharCode(2) + "说明:药品名称前有";
        PatientInfo['PrtRemark'] = "说明:药品名称前有";
        //MyPara = MyPara + '^PrtRemark1' + String.fromCharCode(2) + String.fromCharCode(9650) + "表示需皮试药品";
        PatientInfo['PrtRemark1'] = String.fromCharCode(9650) + "表示需皮试药品";
        //MyPara = MyPara + '^BillAuditFlag' + String.fromCharCode(2) + BillAuditFlag
        PatientInfo['BillAuditFlag'] = BillAuditFlag;
        //MyPara = MyPara + '^Sum' + String.fromCharCode(2) + totalmoney + '元';
        PatientInfo['Sum'] =  totalmoney + '元';
        //MyPara = MyPara + '^UserAddName' + String.fromCharCode(2) + Doctor;
        PatientInfo['UserAddName'] = Doctor;
        //MyPara = MyPara + "^FacInfo" + String.fromCharCode(2) + FacInfo;
        PatientInfo['FacInfo'] = FacInfo;
        //MyPara = MyPara + "^MoneyInfo" + String.fromCharCode(2) + MoneyInfo;
        PatientInfo['MoneyInfo'] = MoneyInfo;

        var DiagnoseArray = Diag.split(",")
        var DiagnoseArrayLen = DiagnoseArray.length
        var intLen = 8
        for (var i = 0; i < DiagnoseArrayLen; i++) {

            ss = DiagnoseArray[i]
            strContent = DiagnoseArray[i]

            var m = m + 1;
            var diaglen = DiagnoseArray[i].length

            if (diaglen > 8) {

                while (strContent.length > intLen) {

                    strTemp = strContent.substr(0, intLen);
                    //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strTemp;
                    PatientInfo['Diagnose' + m] = strTemp;
                    m = m + 1
                    strContent = strContent.substr(intLen, strContent.length);

                }

                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + strContent;
                PatientInfo['Diagnose' + m] = strContent;

            }
            else {
                //MyPara = MyPara + '^Diagnose' + m + String.fromCharCode(2) + ss;
                PatientInfo['Diagnose' + m] = ss;
            }

        }


        var k = 0;

        for (k = 1; k < OrdRows + 1; k++) {
            var l = 0;
            for (l = 1; l < 2; l++) {

                //MyPara = MyPara + "^txt" + k + l + String.fromCharCode(2) + pc[k - 1][l];
                PatientInfo['txt' + k + l] = pc[k - 1][l];

            }
        }


        //DHCP_GetXMLConfig(XMLElementName, "DHCOutPrescCY");


        //var myobj = document.getElementById("ClsBillPrint");
        //DHCP_PrintFun(myobj, MyPara, MyList);
    } catch (e) { alert(e.message) }
    return 0;
}*/