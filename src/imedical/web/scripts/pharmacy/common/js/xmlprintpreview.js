/**
* @creator: Huxiaotian 2019-12-12
* @desc: 	药房药库xml打印预览公共csp
* @csp: 	csp/pha.com.xmlprintpreview.csp
* @js: 		scripts/pharmacy/common/js/xmlprintpreview.js
*/

/*
* @desc: 页面加载完成后开始调用
*/
window.onload = function (){
	PRE_COM.show(optionsObject);
}

/*
* @desc: 预览公共变量
*/
var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
PRE_COM = {
	URL: 'websys.Broker.cls',
	inputData: {},				//请求入参
	paraObj: {},				//Para
	listArr: [],				//List
	pageListArr: [], 			//二维数组
	pageColor: "white",			//纸张颜色: #f5f2ee
	pageWidth: w, 				//纸张宽度(px)
	pageHeight : h, 			//纸张高度(px)
	curPageIndex: 0,			//当前页数据索引
	curTblRows: 0,				//当前页数据的行数
	curTblHeight: '', 			//当前页表格高度(px)
	xmlDom: null,				//xml对象
	xmlTblRows: 0,				//js或者xml中配置的每页行数
	xmlTblHeight: 0,			//表格的最大高度(px)
	xmlTblRowHeight: 0,			//xml配置的表格每行高度(px)
	xmlBackSlashWidth: 0,		//xml配置的反斜杠宽度
	barCodeFont: 'C39P36DmTt',	//默认条码字体
	htmlStr: '',				//html字符串缓存
	QRCodeArr: [],				//二维码信息缓存
	htmlID: {lable:0, qrcode:0, img:0, shape:0, list:0},
	show: function(_options) {
		getJsonData(_options);
	}
}

/*
* @desc: 获取类方法的返回值,并存入公共变量
*/
function getJsonData(_options){
	PRE_COM.inputData = _options;
	PRE_COM.inputData.imageCAFields = PRE_COM.inputData.imageCAFields || [];
	PRE_COM.inputData.aptListFields = PRE_COM.inputData.aptListFields || [];
	//local data
	if (PRE_COM.inputData.data) {
		var jsonData = PRE_COM.inputData.data;
		initCommonVal(jsonData);
		initCurComVal();
		showHtmlFromXml();
		return;
	}
	//method data
	PRINTCOM.jsRunServer(
		_options.dataOptions,
		function(jsonData){
			initCommonVal(jsonData);
			initCurComVal();
			showHtmlFromXml();
		},
		function(error){
			alert(error.responseText);
		}
	);
}

/*
* @desc: 初始化公共参数
*/
function initCommonVal(jsonData){
	if (PRE_COM.xmlDom == null) {
		//dom
		var templateName = PRE_COM.inputData.XMLTemplate;
		PRINTCOM.loadXMLTemplate(templateName);
		var tempXmlStr = PRINTCOM.XMLTemplate[templateName];
	    var docobj = PRINTCOM.CreateXMLDOM(tempXmlStr);
	    PRE_COM.xmlDom = docobj;
	    var invXMLDoc = docobj.getElementsByTagName("invoice")[0];
	    
	    //list info
	    var xmlListData = invXMLDoc.getElementsByTagName("ListData")[0];
	    var xmlBackSlashWidth = parseFloat(xmlListData.getAttribute("BackSlashWidth"));
	    var currentRow = parseFloat(xmlListData.getAttribute("CurrentRow"));
		var pageRows = parseFloat(xmlListData.getAttribute("PageRows"));
		var xStep = convertPtToPx(xmlListData.getAttribute("XStep"));
		var yStep = convertPtToPx(xmlListData.getAttribute("YStep")); //行高
		var pageInfo = PRE_COM.inputData.page;
		if (pageInfo) {
			pageRows = pageInfo.rows;
		}
		PRE_COM.xmlTblRows = pageRows;
		PRE_COM.xmlTblRowHeight = yStep;
		PRE_COM.xmlTblHeight = yStep * pageRows;
		PRE_COM.xmlBackSlashWidth = xmlBackSlashWidth;
		//width & height
		var pHeight = parseFloat(invXMLDoc.getAttribute("height")) * 10; //mm
	    if(pHeight != null){
	        PRE_COM.pageHeight = convertPtToPx(pHeight); //px
	    }
	    var pWidth = parseFloat(invXMLDoc.getAttribute("width")) * 10; //mm
	    if(pWidth != null){
	        PRE_COM.pageWidth = convertPtToPx(pWidth); //px
	    }
	    //json
	    PRE_COM.paraObj = jsonData.Para || {};
		PRE_COM.listArr = jsonData.List || [];
		PRE_COM.pageListArr = PRINTCOM.splitArray(PRE_COM.listArr, pageRows);
	}
}

/*
* @desc: 当前页公共参数初始化
*/
function initCurComVal(){
	var rowHeight = PRE_COM.xmlTblRowHeight;
	var curPageIndex = PRE_COM.curPageIndex;
	var curTblRows = PRE_COM.pageListArr[curPageIndex].length; //防止下标越界 todo...
	var curTblHeight = rowHeight * (curTblRows - 1);
	PRE_COM.curTblRows = curTblRows;
	PRE_COM.curTblHeight = curTblHeight;
}

/*
* @desc: xml打印预览公共
*/
function showHtmlFromXml() {
	//页面整体
	var bodyLayout = document.getElementById("bodyLayout");
	bodyLayout.style.cssText = "height:" + PRE_COM.pageHeight + "px;width:" + PRE_COM.pageWidth + "px;background-color:" + PRE_COM.pageColor;
	//右侧按钮
	var preview = PRE_COM.inputData.preview;
	if(preview) {
		if (preview.showButtons == true){
			var buttons = "<button id='btn-pageUp' type='button' style='position:absolute;white-space:nowrap;left:"+(PRE_COM.pageWidth+10)+"px;top:10px;width:85px;text-align:left;' onclick='pageUp();'>"+btnPageUp+"</button>" +
				"<button id='btn-pageDown' type='button' style='position:absolute;white-space:nowrap;left:"+(PRE_COM.pageWidth+10)+"px;top:50px;width:85px;text-align:left;'  onclick='pageDown();'>"+btnpageDown+"</button>" +
				"<button id='btn-print' type='button' style='position:absolute;white-space:nowrap;left:"+(PRE_COM.pageWidth+10)+"px;top:90px;width:85px;text-align:left;'  onclick='printByInv();'>"+btnPrintByInv+"</button>" +
				"<button id='btn-exportpdf' type='button' style='position:absolute;white-space:nowrap;left:"+(PRE_COM.pageWidth+10)+"px;top:130px;width:85px;text-align:left;'  onclick='exportPDF();'>"+btnExportPDF+"</button>";
			setCtrlHtml("", buttons);
		}
	}
	//所有元素
	showOnePage();
}

/*
* @desc: 显示一页的所有元素
*/
function showOnePage(){
	var templateName = PRE_COM.inputData.XMLTemplate;
	var tempXmlStr = PRINTCOM.XMLTemplate[templateName];
	var docobj = PRINTCOM.CreateXMLDOM(tempXmlStr);
	var invXMLDoc = docobj.getElementsByTagName("invoice")[0];
	//var invXMLDoc = PRE_COM.xmlDom.getElementsByTagName("invoice")[0];
	var xmlPLData = invXMLDoc.getElementsByTagName("PLData")[0];
	var xmlTxtData = invXMLDoc.getElementsByTagName("TxtData")[0];
	var xmlPICData = invXMLDoc.getElementsByTagName("PICData")[0];
	var xmlListData = invXMLDoc.getElementsByTagName("ListData")[0];
	
	//1.页码
	var curPageIndex = PRE_COM.curPageIndex;
	var pageInfo = PRE_COM.inputData.page;
	if (pageInfo) {
		var pageNo = curPageIndex + 1;
		var format = pageInfo.format;
		var pageNoStr = pageInfo.format || "";
		pageNoStr = pageNoStr.replace("{1}", pageNo);
		pageNoStr = pageNoStr.replace("{2}", PRE_COM.pageListArr.length);
		var pleft = pageInfo.x;
		var ptop = pageInfo.y;
		var pfbold = pageInfo.fontbold;
		var pfname = pageInfo.fontname;
		var pfsize = pageInfo.fontsize;
		var pheight = 10; //mm
		var pwidth = 50; //mm
		addLabel({name:"pageNo", x:pleft, y:ptop, value:pageNoStr, fontbold:pfbold, fontname:pfname, fontsize:pfsize, height:pheight, width:pwidth});
	}
	
	//2.扩展元素(每页都显示)
	var preExtObj = PRE_COM.inputData.extObj;
	if (preExtObj) {
		var preExtElements = preExtObj.elements || [];
		var len = preExtElements.length;
		for(var i=0; i<len; i++){
			var oneItem = preExtElements[i];
			if(oneItem.type == 'line'){
				addLine(oneItem);
			}
			if(oneItem.type == 'pic'){
				addImage(oneItem);
			}
			if(oneItem.type == 'text'){
				addLabel(oneItem);
			}
		}
	}
	
	//3.原始模板
	addLabels(xmlTxtData);
	addImages(xmlPICData);
	addLines(xmlPLData);
	addList(xmlListData);
	showHtml();
}


/*
* @desc: 显示label(含二维码 & 条形码)
* @others: 长度单位为mm,需要通过convertPtToPx()转换
*/
function addLabels(xmlTxtData) {
	var endPageFields = PRE_COM.inputData.endPageFields || [];
	var isEndPageFlag = PRE_COM.curPageIndex == PRE_COM.pageListArr.length - 1 ? true : false;
	var xmlTxtDataRePrtHeadFlag = xmlTxtData.getAttribute("RePrtHeadFlag");
	var txtDataParas = xmlTxtData.getElementsByTagName("txtdatapara");
	for (var i=0; i<txtDataParas.length; i++) {
		var itm = txtDataParas[i];
		var pname = itm.getAttribute("name");
		var pleft = itm.getAttribute("xcol");
		var ptop = itm.getAttribute("yrow");
		if (pname == "startPoint" && PRE_COM.xmlBackSlashWidth != 0) {
			PRE_COM.inputData.backSlash = PRE_COM.inputData.backSlash || {};
			PRE_COM.inputData.backSlash.startX = parseFloat(pleft);
			PRE_COM.inputData.backSlash.startY = ptop;
			PRE_COM.inputData.backSlash.endX = parseFloat(pleft) + PRE_COM.xmlBackSlashWidth;
			continue;
		}
		var newRePrintFlag = endPageFields.indexOf(pname) >= 0 || xmlTxtDataRePrtHeadFlag == "Y" ? "Y" : "N";
		if (PRE_COM.curPageIndex >= 1 && newRePrintFlag != "Y") {
			continue;
		}
		if (endPageFields.indexOf(pname) >= 0 && isEndPageFlag == false) {
			continue;
		}
		var pdval = itm.getAttribute("defaultvalue");
		var ppval = itm.getAttribute("printvalue");
		var pfbold = itm.getAttribute("fontbold");
		var pfname = itm.getAttribute("fontname");
		var pfsize = itm.getAttribute("fontsize");
		var pisqrcode = itm.getAttribute("isqrcode");
		var pbarcodetype = itm.getAttribute("barcodetype");
		var pval = "undefined" != typeof PRE_COM.paraObj[pname] ? PRE_COM.paraObj[pname] : (pdval || ppval);
		if (pisqrcode == "true") {
			var pheight = itm.getAttribute("height");
			var pwidth = itm.getAttribute("width");
			addLabel({name:pname, x:pleft, y:ptop, value:pval, fontbold:pfbold, fontname:pfname, fontsize:pfsize, height:pheight, width:pwidth, isqrcode:pisqrcode});
		} else if (("undefined" != typeof pbarcodetype) && ( pbarcodetype != null)) {
			var pheight = itm.getAttribute("height");
			var pwidth = itm.getAttribute("width");
			var pangle = itm.getAttribute("angle") || "";
			var pisshowtext = itm.getAttribute("isshowtext") || "";
			addLabel({name:pname, x:pleft, y:ptop, value:pval, fontbold:pfbold, fontname:pfname, fontsize:pfsize, height:pheight, width:pwidth, barcodetype:pbarcodetype, angle:pangle, isshowtext:pisshowtext});
		} else {
			var pheight = itm.getAttribute("height") || 800;
			var pwidth = itm.getAttribute("width") || 800;
			var pangle = itm.getAttribute("angle") || "";
			addLabel({name:pname, x:pleft, y:ptop, value:pval, fontbold:pfbold, fontname:pfname, fontsize:pfsize, height:pheight, width:pwidth, angle:pangle});
		}
	}
}
//显示一条
function addLabel(oneItem) {
	var aptListFields = PRE_COM.inputData.aptListFields;
	var curTblHeight = PRE_COM.curTblHeight;
	var x = convertPtToPx(oneItem.x);
    var y = convertPtToPx(oneItem.y);
    if (aptListFields.indexOf(oneItem.name) >= 0) {
	    y = y + curTblHeight;
	}
	var ctrlHtml = "";
    if(oneItem.isqrcode == "true"){
        //显示二维码
        var cId = getNewCtrlId("qrcode");
        var qrWidth = convertPtToPx(oneItem.width);
    	var qrHeight = convertPtToPx(oneItem.height);
        ctrlHtml = "<div id ='" + cId + "' ";
        ctrlHtml += "style='position:absolute; margin:0px; padding:0px;left:" + x + "px;top:" + y + "px;width:" + qrWidth + "px;height:" + qrHeight + "px;'>";
        ctrlHtml += "</div>";
    	setCtrlHtml(cId, ctrlHtml);
    	PRE_COM.QRCodeArr.push({cId:cId, qrcode:{
	    	render: "table", 				// 渲染方式有table方式（IE兼容）和canvas方式
        	width: qrWidth, 				// 宽度
        	height: qrHeight, 				// 高度
        	text: utf16to8(oneItem.value), 	// 内容(若不包含中文可能有问题???)
        	typeNumber:-1,					// 计算模式
        	correctLevel:2,					// 二维码纠错级别
        	background:"#ffffff",			// 背景颜色
        	foreground:"#000000" 			// 二维码颜色
	    }});
    } else if (oneItem.barcodetype) {
		//条形码(暂时使用条码字体替代) todo...
		var fontFamily = oneItem.isshowtext == 'N' ? 'C39P36DmTt' : 'C39HrP60DmTt';
	    var cId = getNewCtrlId("label");
	    ctrlHtml = "<label ctrlType='label' id='" + cId + "' name='" + oneItem.name + "' ";
        ctrlHtml += "style='position:absolute;white-space:nowrap;left:" + x + "px;top:" + y + "px;";
        ctrlHtml += "font-size:" + getBarFontSize(oneItem.height, oneItem.width) + "pt;";
        ctrlHtml += "font-family:" + fontFamily + ";";
        if (oneItem.angle != "") {
	        ctrlHtml += "transform: rotate(-" + oneItem.angle + "deg);";
	    }
        ctrlHtml += "' >";
        if (oneItem.value) {
            ctrlHtml += oneItem.value.replace(/  /g, "&nbsp;") + "</label>";
        } else {
            ctrlHtml += "</label>";
        }
    	setCtrlHtml(cId, ctrlHtml);
	} else {
	    //文本或者字体条码
	    var cId = getNewCtrlId("label");
	    ctrlHtml = "<label ctrlType='label' id='" + cId + "' name='" + oneItem.name + "' ";
        ctrlHtml += "style='position:absolute;white-space:nowrap;left:" + x + "px;top:" + y + "px;";
        if (oneItem.fontsize != 12) {
            ctrlHtml += "font-size:" + oneItem.fontsize + "pt;";
        }else{
	       	ctrlHtml += "font-size:" + 12 + "pt;";
	    }
        if (oneItem.fontbold != "false") {
            ctrlHtml += "font-weight:bold;";
        }
        if (oneItem.fontname != "宋体") {
            ctrlHtml += "font-family:" + oneItem.fontname + ";";
        }else{
	       	ctrlHtml += "font-family:" + "宋体" + ";";
	    }
	    if (oneItem.angle != "") {
	        ctrlHtml += "transform: rotate(-" + oneItem.angle + "deg);";
	    }
        ctrlHtml += "' >";
        
        if (oneItem.value) {
            ctrlHtml += oneItem.value.replace(/  /g, "&nbsp;") + "</label>";
        } else {
            ctrlHtml += "</label>";
        }
    	setCtrlHtml(cId, ctrlHtml);
	}
}

/*
* @desc: 显示图片
* @others: 长度单位为mm,需要通过convertPtToPx()转换
*/
function addImages(xmlPICData){
	var endPageFields = PRE_COM.inputData.endPageFields || [];
	var isEndPageFlag = PRE_COM.curPageIndex == PRE_COM.pageListArr.length - 1 ? true : false;
	var xmlPICDataRePrtHeadFlag = xmlPICData.getAttribute("RePrtHeadFlag");
	var picDataParas = xmlPICData.getElementsByTagName("PICdatapara");
	for (var i=0; i<picDataParas.length; i++) {
		var item = picDataParas[i]
		var pname = item.getAttribute("name");
		var newRePrintFlag = endPageFields.indexOf(pname) >= 0 || xmlPICDataRePrtHeadFlag == "Y" ? "Y" : "N";
		if (PRE_COM.curPageIndex >= 1 && newRePrintFlag != "Y") {
			continue;
		}
		if (endPageFields.indexOf(pname) >= 0 && isEndPageFlag == false) {
			continue;
		}
		var pleft = item.getAttribute("xcol");
		var ptop = item.getAttribute("yrow");
		var pheight = item.getAttribute("height");
		var pwidth = item.getAttribute("width");
		var pdval = item.getAttribute("defaultvalue");	
		var ppval = item.getAttribute("printvalue");	
		var pfbold = item.getAttribute("fontbold");
		var pfname = item.getAttribute("fontname");
		var pfsize = item.getAttribute("fontsize");
		var pval = PRE_COM.paraObj[pname] || pdval || ppval;
		if (null == pheight){
			pheight = 20;
		}
		if (null == pwidth){
			pwidth = 20;
		}
		if (pval == "") {
			continue;
		}
		addImage({name:pname, x:pleft, y:ptop, value:pval, fontbold:pfbold, fontname:pfname, fontsize:pfsize, height:pheight, width:pwidth});
	}
}
//显示一张
function addImage(oneItem) {
	var imageCAFields = PRE_COM.inputData.imageCAFields;
	var aptListFields = PRE_COM.inputData.aptListFields;
	var curTblHeight = PRE_COM.curTblHeight;
	var x = convertPtToPx(oneItem.x);
    var y = convertPtToPx(oneItem.y);
    if (aptListFields.indexOf(oneItem.name) >= 0) {
	    y = y + curTblHeight;
	}
	var width = convertPtToPx(oneItem.width);
	var height = convertPtToPx(oneItem.height);
	
	var cId = getNewCtrlId("img");
    var ctrlHtml = "<img ctrlType='img' id=" + cId + " name=" + oneItem.name;
	ctrlHtml = ctrlHtml + " style='position:absolute;left:" + x + "px;top:" + y + "px;' width='" + width +"px' height='" + height + "px' ";
	if (imageCAFields.indexOf(oneItem.name) >= 0) {
		var retCode = PRINTCOM.GetGifInfo(oneItem.value); //生成gif
		if(retCode == 0){
			ctrlHtml = ctrlHtml + "src='file://C:/" + oneItem.value + '.' + PRINTCOM.ImgSuffix + "' ";
		}
	} else {
		ctrlHtml = ctrlHtml + "src='" + oneItem.value + "' ";
	}
	ctrlHtml = ctrlHtml + "/>";
	
	setCtrlHtml(cId, ctrlHtml);
}

/*
* @desc: 显示线条
* @others: 长度单位为mm,需要通过convertPtToPx()转换
*/
function addLines(xmlPLData){
	var xmlPlineRePrtHeadFlag = xmlPLData.getAttribute("RePrtHeadFlag");
	var pLines = xmlPLData.getElementsByTagName("PLine");
	for (var i=0; i<pLines.length; i++) {
		if (PRE_COM.curPageIndex > 1 && xmlPlineRePrtHeadFlag != "Y") {
			continue;
		}
		var item = pLines[i]
		var sx = parseFloat(item.getAttribute("BeginX"));	
		var sy = parseFloat(item.getAttribute("BeginY"));	
		var ex = parseFloat(item.getAttribute("EndX"));	
		var ey = parseFloat(item.getAttribute("EndY"));
		addLine({sx:sx, sy:sy, ex:ex, ey:ey});
	}
}
//显示一条
function addLine (oneItem) {
	var cId = getNewCtrlId("shape");
	var ctrlHtml = '<div ctrlType="shape" id="' + cId + '" name="' + oneItem.name + '" ';
	var width = convertPtToPx(parseFloat(oneItem.ex) - parseFloat(oneItem.sx));
	var height = convertPtToPx(parseFloat(oneItem.ey) - parseFloat(oneItem.sy));
	var sx = convertPtToPx(oneItem.sx);
	var sy = convertPtToPx(oneItem.sy);
	var ex = convertPtToPx(oneItem.ex);
	var ey = convertPtToPx(oneItem.ey);
	if (height == 0 && width != 0) {
		//横线
		if (width > 0) {
			ctrlHtml += 'style="POSITION:absolute;border-color:000000;border-top-style:solid;border-width:1px;TOP:' + sy + 'px; LEFT:' + sx + 'px;width:' + width + 'px;"> </div>';
		} else {
			ctrlHtml += 'style="POSITION:absolute;border-color:000000;border-bottom-style:solid;border-width:1px;TOP:' + sy + 'px; LEFT:' + sx + 'px;width:' + width + 'px;"> </div>';
		}
	} else if (width == 0 && height != 0) {
		//竖线
		if (height > 0) {
			ctrlHtml += 'style="POSITION:absolute;border-color:000000;border-left-style:solid;border-width:1px;TOP:' + sy + 'px; LEFT:' + sx + 'px;width:' + width + 'px;height:'+height+'px;"> </div>';
		} else {
			ctrlHtml += 'style="POSITION:absolute;border-color:000000;border-left-style:solid;border-width:1px;TOP:' + sy + 'px; LEFT:' + sx + 'px;width:' + width + 'px;height:'+height+'px;"> </div>';
		}
	} else {
		//斜线
		ctrlHtml = drawLineHtml(cId, sx, sy, ex, ey);
	}
	setCtrlHtml(cId, ctrlHtml);
}
//斜线(长度单位PX)
function drawLineHtml(lineId, startX, startY, endX, endY){
	var stX = startX;
	var stY = startY;
	var edX = endX;
	var edY = endY;
	if(startX > endX){
		stX = endX;
		edX = startX;
	}
	if(startY > endY){
		stY = endY;
		edY = startY;
	}
	var divH = edY - stY;
	var divW = edX - stX;
	var lineLength = Math.sqrt((divH*divH) + (divW*divW));
	lineLength = subFloat(lineLength,2);
	
	var a = Math.atan(divW/divH);
	var b = (180/3.14)*a;
	b = subFloat(b,2);
	var angle = b;
	if (startX >= endX && startY < endY) {
		angle = b; //第三象限(0~90)
	} else if (startX >= endX && startY > endY) {
		angle = 180 - b; //第二象限(90~180)
	} else if (startX < endX && startY <= endY) {
		angle = 0 - b; //第四象限(0~-90)
	} else if (startX < endX && startY >= endY) {
		angle = -180 + b; //第一象限(-90~-180)
	}
	
	var lineHtml = '<div ctrlType="shape" id="' + lineId + '" style="position:absolute;top:'+startY+';left:'+startX+';width:1px;height:'+lineLength+'px;background-color:black;display:block;transform:rotate('+angle+'deg);transform-origin:top;">' + '</div>';
	return lineHtml;
}

/*
* @desc: 显示list(表格)
* @others: 长度单位为mm,需要通过convertPtToPx()转换
*/
function addList(xmlListData) {
	var curPageIndex = PRE_COM.curPageIndex;
	var curTblHeight = PRE_COM.curTblHeight;
	var curTblRows = PRE_COM.curTblRows;
	var xmlTblRows = PRE_COM.xmlTblRows;
	var xmlTblHeight = PRE_COM.xmlTblHeight; //表格最大高度
	var xmlTblRowHeight = PRE_COM.xmlTblRowHeight;
	var pageHeight = PRE_COM.pageHeight;
	var myListArray = PRE_COM.pageListArr[curPageIndex]; //本页数据
	var currentRow = 1;
	var pageRows = PRE_COM.xmlTblRows;
	var postion = getStartXY(xmlListData);
	if((curTblHeight - postion.tblStartY) > pageHeight){
		curTblHeight = pageHeight - postion.tblStartY;
	}
	
	var cId = getNewCtrlId("list");
    var ctrlHtml = "<div ctrlType='list' id = '" + cId + "' ";
    ctrlHtml += "CurrentRow='" + currentRow + "' ";
    if (xmlListData.getAttribute("PageRows") != "1") {
        ctrlHtml += "PageRows='" + pageRows + "' ";
    }
    if (xmlListData.getAttribute("XStep") != "0") {
        ctrlHtml += "XStep='" + xStep + "' ";
    }
    ctrlHtml += "style='position:absolute; margin:0px; padding:0px;left:"+postion.tblStartX+"px;top:" + postion.tblStartY + "px;width:" + (postion.tblWidth + 100) + "px;height:" + curTblHeight + "px;'>";
    
	var rows = myListArray.length; //行数
    for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
	    var cols = xmlListData.childNodes.length; //列数
        var childHtml = "";
        var listItemStr = myListArray[rowIndex];
        if (PRINTCOM.dataType(listItemStr) == "[object Object]") {
	        //---object---
	        var listItemObj = listItemStr;
	        var colsNode = xmlListData.getElementsByTagName("Listdatapara");
			for (var j=0; j<cols; j++){
				var colNode = colsNode[j];
				var name = colNode.getAttribute("name");
				var xcol = colNode.getAttribute("xcol");
				var yrow = colNode.getAttribute("yrow");
				var strListSub = "undefined" != typeof listItemObj[name] ? listItemObj[name] : "";
				//DIV内部定位
	            var fromDivLeft = convertPtToPx(xcol) - postion.tblStartX;
	    		var fromDivTop = convertPtToPx(yrow) + (rowIndex * xmlTblRowHeight) - postion.tblStartY;
	    		//get label
	            var oneColLable = getListItem(colNode, fromDivLeft, fromDivTop, strListSub);
	            childHtml += oneColLable;
		        colIndex = colIndex + 1;
			}
	    } else {
		    //---string---
		    var listItemArr = listItemStr.split("^");
	        var colIndex = 0;
	        for (var cIndex = 0; cIndex < cols; cIndex++) {
	            var oneNode = xmlListData.childNodes[cIndex]; //代表某一列的属性
	            if(oneNode.nodeName.toUpperCase() == "#TEXT"){
		        	continue;
		    	}
	            listItemArr[colIndex] = "undefined" != typeof listItemArr[colIndex] ? listItemArr[colIndex] : "";
	            var strListSub = listItemArr[colIndex].toString();
	            //DIV内部定位
	            var fromDivLeft = convertPtToPx(oneNode.getAttribute("xcol")) - postion.tblStartX;
	    		var fromDivTop = convertPtToPx(oneNode.getAttribute("yrow")) + (rowIndex * xmlTblRowHeight) - postion.tblStartY;
	    		//get label
	            var oneColLable = getListItem(oneNode, fromDivLeft, fromDivTop, strListSub);
	            childHtml += oneColLable;
		        colIndex = colIndex + 1;
	        }
		}
        ctrlHtml += childHtml;
    }
    ctrlHtml += "</div>";
    setCtrlHtml(cId, ctrlHtml);
    
    //显示表格边框
    var listBorder = PRE_COM.inputData.listBorder;
    if (listBorder) {
	    var lbStyle = listBorder.style;
		var lbStartX = listBorder.startX;
		var lbEndX = listBorder.endX;
		var headBorder = listBorder.headBorder;
		var styleArr = [];
		if(lbStyle == 1){
			styleArr[0] = 1;
		}
		if(lbStyle == 2){
			styleArr[0] = 1; styleArr[1] = 2;
		}
		if(lbStyle == 3){
			styleArr[0] = 1; styleArr[1] = 2; styleArr[2] = 3;
		}
		if(lbStyle == 4){
			styleArr[0] = 1; styleArr[1] = 2; styleArr[2] = 3; styleArr[3] = 4;
		}
		//
		var tblStartY = convertPxToPt(postion.tblStartY);
		var tblEndY = convertPxToPt(postion.tblStartY + (curTblRows * xmlTblRowHeight));
		if(styleArr.indexOf(1) >= 0){
			addLine({sx:lbStartX, sy:tblStartY, ex:lbEndX, ey:tblStartY});
		}
		var tblStartYNew = tblStartY;
		if(styleArr.indexOf(2) >= 0){
			var lineY = 0;
			for(var i=0; i<curTblRows; i++){
				lineY = (xmlTblRowHeight * (i + 1)) + postion.tblStartY;
				lineY = convertPxToPt(lineY);
				addLine({sx:lbStartX, sy:lineY, ex:lbEndX, ey:lineY});
			}
			if (headBorder) {
				var tblStartYNew = tblStartY - convertPxToPt(xmlTblRowHeight); //需要打印表头的边框,则向上移动
				addLine({sx:lbStartX, sy:tblStartYNew, ex:lbEndX, ey:tblStartYNew});
			}
		}
		if(styleArr.indexOf(3) >= 0){
			var colsNode = xmlListData.getElementsByTagName("Listdatapara");
			var cols = colsNode.length;
			for (var j=1; j<cols; j++){
				var colNode = colsNode[j];
				var colStartX = colNode.getAttribute("xcol");
				addLine({sx:colStartX, sy:tblStartYNew, ex:colStartX, ey:tblEndY});
			}
		}
		if(styleArr.indexOf(4) >= 0){
			addLine({sx:lbStartX, sy:tblStartYNew, ex:lbStartX, ey:tblEndY});
			addLine({sx:lbEndX, sy:tblStartYNew, ex:lbEndX, ey:tblEndY});
		}
	}
	
	//反斜杠
	if (PRE_COM.inputData.backSlash) {
		if (xmlTblRows > curTblRows) {
			var backSlashOpt = PRE_COM.inputData.backSlash;
			var fromList = backSlashOpt.fromList || 0;
			var backSlashEndY = convertPxToPt(postion.tblStartY + (xmlTblRowHeight * curTblRows)) + fromList;
			addLine({sx:backSlashOpt.startX, sy:backSlashOpt.startY, ex:backSlashOpt.endX, ey:backSlashEndY});
		}
	}
}

//显示List中的一项 (表格中的一格)
function getListItem (oneNode, fromDivLeft, fromDivTop, showValue) {
    var cId = getNewCtrlId("label");
    var name = oneNode.getAttribute("name");
    var fontSize = oneNode.getAttribute("fontsize");
    var fontBold = oneNode.getAttribute("fontbold");
    var fontName = oneNode.getAttribute("fontname");
    // label
    var ctrlHtml = "<label ctrlType='label' id=" + cId + " name=" + name;
    ctrlHtml += " style='position:absolute;white-space:nowrap;left:" + fromDivLeft + "px;top:" + fromDivTop + "px;"
    if (fontSize != "12") {
        ctrlHtml += "font-size:" + fontSize + "pt;";
    }else{
	   	ctrlHtml += "font-size:" + 12 + "pt;";
	}
    if (fontBold != "false") {
        ctrlHtml += "font-weight:bold;";
    }
    if (fontName != "宋体") {
        ctrlHtml += "font-family:" + fontName + ";";
    }else{
		ctrlHtml += "font-family:" + "宋体" + ";";
	}
    ctrlHtml = ctrlHtml + "' ";
    
    showValue = showValue || "";
    if (showValue == "") {
        if (jQuery.trim(oneNode.getAttribute("defaultvalue")) != "") {
            ctrlHtml = ctrlHtml + ">" + oneNode.getAttribute("defaultvalue") + "</label>";
        } else {
	        ctrlHtml = ctrlHtml + "></label>";
	    }
    } else {
        ctrlHtml = ctrlHtml + ">" + showValue + "</label>";
    }
    return ctrlHtml;
}

//--------------------------------------------------
//取得开始坐标
function getStartXY (xmlNode) {
    var count = xmlNode.childNodes.length;
    var startX = null;
    var startY = null;
    var endX = null;
    var endY = null;
    for (var index = 0; index < count; index++) {
        var oneNode = xmlNode.childNodes[index];
        if(oneNode.nodeName.toUpperCase() == "#TEXT"){
	        continue;
	    }
        var xcol = parseFloat(oneNode.getAttribute("xcol"), 10);
        var yrow = parseFloat(oneNode.getAttribute("yrow"), 10);
        if (startX == null) {
            startX = xcol;
        }else {
            if (xcol < startX) {
                startX = xcol;
            }
        }
        if (startY == null) {
            startY = yrow;
        }else {
            if (yrow < startY) {
                startY = yrow;
            }
        }

        if (endX == null) {
            endX = xcol;
        }else {
            if (xcol > endX) {
                endX = xcol;
            }
        }
        if (endY == null) {
            endY = yrow;
        }else {
            if (yrow > endY) {
                endY = yrow;
            }
        }
    }
    return {
	    tblStartX: convertPtToPx(startX),
	    tblStartY: convertPtToPx(startY),
	    tblWidth: convertPtToPx(endX - startX),
	    tblHeight: convertPtToPx(endY - startY),
	};
}
//设定新控件的html
function setCtrlHtml (cId, ctrlHtml) {
	PRE_COM.htmlStr += ctrlHtml;
}
//显示信息
function showHtml () {
	var bodyLayout = document.getElementById("bodyLayout");
	bodyLayout.innerHTML = PRE_COM.htmlStr;
	renderQRCode();
}
//渲染二维码(较慢,放在最后)
function renderQRCode(){
	var qrLen = PRE_COM.QRCodeArr.length;
	for (var i=0; i<qrLen; i++) {
		var oneQRCode = PRE_COM.QRCodeArr[i];
		$('#'+oneQRCode.cId).qrcode(oneQRCode.qrcode)
	}
	PRE_COM.QRCodeArr.length = 0;
}
//清空打印页数据
function clearPage(){
	PRE_COM.htmlStr = "";
	var bodyLayout = document.getElementById("bodyLayout");
	bodyLayout.innerHTML = '';
}
//取得新控件Id
function getNewCtrlId (ctrlType) {
	var newCtrlId = "";
	for (var k in PRE_COM.htmlID) {
		if (k == ctrlType) {
			PRE_COM.htmlID[k] = PRE_COM.htmlID[k] + 1;
			newCtrlId = ctrlType + PRE_COM.htmlID[k];
			break;
		}
	}
	if (newCtrlId == "") {
		return "otherctrls";
	}
	return newCtrlId;
}
//将xml中的pt转化为px
function convertPtToPx (ptValue) {
    return subFloat((parseFloat(ptValue, 10)) * 3.78, 0);
}
//将html中的px转化为pt
function convertPxToPt (pxValue) {
    return subFloat((parseFloat(pxValue, 10)) / 3.78, 0);
}
//对数据四舍五入
function subFloat (num, v) {
    var vv = Math.pow(10, v);
    return Math.round(num * vv) / vv;
}
//中文编码格式转换
function utf16to8 (str) {
    var out, i, len, c;
    out = "";
    len = str.length;
    for (i = 0; i < len; i++) {
        c = str.charCodeAt(i);
        if ((c >= 0x0001) && (c <= 0x007F)) {
            out += str.charAt(i);
        } else if (c > 0x07FF) {
            out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));
            out += String.fromCharCode(0x80 | ((c >> 6) & 0x3F));
            out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
        } else {
            out += String.fromCharCode(0xC0 | ((c >> 6) & 0x1F));
            out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
        }
    }
    return out;
}

//按钮事件: 上一页
function pageUp () {
	if(PRE_COM.curPageIndex > 0){
		PRE_COM.curPageIndex = PRE_COM.curPageIndex - 1;
		clearPage();
		initCurComVal();
		showHtmlFromXml();
	} else {
		alert("Has reached the first page!");
	}
}
//按钮事件: 下一页
function pageDown () {
	if(PRE_COM.curPageIndex < PRE_COM.pageListArr.length - 1){
		PRE_COM.curPageIndex = PRE_COM.curPageIndex + 1;
		clearPage();
		initCurComVal();
		showHtmlFromXml();
	}else{
		alert("Has reached the last page!");
	}
}
//按钮事件: inv打印控件
function printByInv () {
	var inputData = PRE_COM.inputData;
	var printOptions = {
		printBy: inputData.printBy,
		XMLTemplate: inputData.XMLTemplate,
		dataOptions: inputData.dataOptions,
		preview: false,
		page: deepCopy(inputData.page),
		endPageFields: inputData.endPageFields,
		imageCAFields: inputData.imageCAFields,
		aptListFields: inputData.aptListFields,
		listBorder: deepCopy(inputData.listBorder),
		backSlash: inputData.backSlash,
		extendFn: function(data){
			//拷贝对象,防止源数据改变
			var ret = {};
			var preExtObj = inputData.extObj;
			if (!preExtObj) {
				return ret;
			}
			ret.elements = [];
			for (var k in preExtObj) {
				if (k == 'elements') {
					var elements = preExtObj[k];
					var eLen = elements.length;
					for(var i=0; i<eLen; i++){
						ret.elements.push(deepCopy(elements[i]));
					}
					
				} else {
					ret[k] = preExtObj[k];
				}
			}
			return ret;
		}
	};
	if (inputData.data) {
		printOptions.data = inputData.data;
	}
	PRINTCOM.XML(printOptions);
}
//导出PDF
function exportPDF () {
	if(confirm("您确认下载该PDF文件吗?")){
		var pdfFileName = PRE_COM.inputData.XMLTemplate + ".pdf";
		var pdf = new jsPDF('p','pt','a4');
		pdf.internal.scaleFactor = 1.5; //设置打印比例,值越大打印越小
		var options = {
			pagesplit: true, 			//设置是否自动分页
			background: '#FFFFFF'		//如果导出的pdf为黑色背景
		};
		var printHtml = $('#bodyLayout').get(0);
		pdf.addHTML(printHtml,15, 15, options,function() {
			pdf.save(pdfFileName);
		});
	}
}
// 对象深拷贝(返回结果都是Object,没有Array)
function deepCopy (source) {
	var result={};
	for (var key in source) {
		result[key] = typeof source[key]==='object'? deepCopy(source[key]): source[key];
	}
	return result;
}
// 根据宽高返回条码字条的大小(可能不太准确)
function getBarFontSize(height, width) {
	var fontSize = parseInt(height) * 3 - 4;
	return fontSize;
}