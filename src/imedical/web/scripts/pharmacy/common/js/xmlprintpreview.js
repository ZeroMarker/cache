/**
 * @creator: Huxiaotian 2019-12-12
 * @desc:    药房药库xml打印预览公共csp
 * @csp:     csp/pha.com.xmlprintpreview.csp
 * @js:      scripts/pharmacy/common/js/xmlprintpreview.js
 */

/*
 * @desc: 页面加载完成后开始调用
 */
window.onload = function () {
	PRE_COM.show(optionsObject);
}

/*
 * @desc: 预览公共变量
 */
var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
var PRE_COM = {
	URL: 'websys.Broker.cls',   // 请求路径
	inputData: {},              // 请求入参
	paraObj: {},                // Para
	listArr: [],                // List
	pageListArr: [],            // 二维数组
	pageColor: "white",         // 纸张颜色: #f5f2ee
	pageWidth: w,               // 纸张宽度(px)
	pageHeight: h,              // 纸张高度(px)
	curPageIndex: 0,            // 当前页数据索引
	curTblRows: 0,              // 当前页数据的行数
	curTblHeight: '',           // 当前页表格高度(px)
	xmlDom: null,               // xml对象
	xmlTblRows: 0,              // js或者xml中配置的每页行数
	xmlTblHeight: 0,            // 表格的最大高度(px)
	xmlTblRowHeight: 0,         // xml配置的表格每行高度(px)
	xmlBackSlashWidth: 0,       // xml配置的反斜杠宽度
	barCodeFont: 'C39P36DmTt',  // 默认条码字体
	htmlStr: '',                // html字符串缓存
	QRCodeArr: [],              // 二维码信息缓存
	origOptions: null,
	htmlID: {
		label: 0,
		qrcode: 0,
		img: 0,
		shape: 0,
		list: 0,
		otherctrls: 0
	},
	show: function (_options) {
		getJsonData(_options);
	}
}

/*
 * @desc: 获取类方法的返回值,并存入公共变量
 */
function getJsonData(_options) {
	PRE_COM.inputData = _options;
	addBodyColor(PRE_COM.inputData.preview);
	PRE_COM.pageColor = PRE_COM.inputData.preview.backgroundColor || 'white';
	PRE_COM.inputData.imageCAFields = PRE_COM.inputData.imageCAFields || [];
	PRE_COM.inputData.aptListFields = PRE_COM.inputData.aptListFields || [];
	try {
		PRE_COM.origOptions = window.parent.PRINTCOM.OptionsByPid[pid];
	} catch(e){
		console.log(e);
	}
	// local data
	if (PRE_COM.inputData.data) {
		var jsonData = PRE_COM.inputData.data;
		initCommonVal(jsonData);
		initCurComVal();
		showHtmlFromXml();
		return;
	}
	// method data
	PRINTCOM.jsRunServer(_options.dataOptions, function (jsonData) {
		initCommonVal(jsonData);
		initCurComVal();
		showHtmlFromXml();
	}, function (error) {
		alert(error.responseText);
	});
}

/*
 * @desc: 初始化公共参数
 */
function initCommonVal(jsonData) {
	if (PRE_COM.xmlDom == null) {
		// dom
		var templateName = PRE_COM.inputData.XMLTemplate;
		PRINTCOM.loadXMLTemplate(templateName);
		var tempXmlStr = PRINTCOM.XMLTemplate[templateName];
		var docobj = PRINTCOM.CreateXMLDOM(tempXmlStr);
		PRE_COM.xmlDom = docobj;
		var invXMLDoc = docobj.getElementsByTagName("invoice")[0];
		// list info
		var xmlListData = invXMLDoc.getElementsByTagName("ListData")[0];
		var xmlBackSlashWidth = parseFloat(xmlListData.getAttribute("BackSlashWidth"));
		var currentRow = parseFloat(xmlListData.getAttribute("CurrentRow"));
		var pageRows = parseFloat(xmlListData.getAttribute("PageRows"));
		var xStep = convertPtToPx(xmlListData.getAttribute("XStep"));
		var yStep = convertPtToPx(xmlListData.getAttribute("YStep")); // 行高
		var pageInfo = PRE_COM.inputData.page;
		if (pageInfo) {
			pageRows = pageInfo.rows;
		}
		PRE_COM.xmlTblRows = pageRows;
		PRE_COM.xmlTblRowHeight = yStep;
		PRE_COM.xmlTblHeight = yStep * pageRows;
		PRE_COM.xmlBackSlashWidth = xmlBackSlashWidth;
		// width & height
		var pHeight = parseFloat(invXMLDoc.getAttribute("height")) * 10; // mm
		if (pHeight != null) {
			PRE_COM.pageHeight = convertPtToPx(pHeight); // px
		}
		var pWidth = parseFloat(invXMLDoc.getAttribute("width")) * 10; // mm
		if (pWidth != null) {
			PRE_COM.pageWidth = convertPtToPx(pWidth); // px
		}
		// json
		PRE_COM.paraObj = jsonData.Para || {};
		PRE_COM.listArr = jsonData.List || [];
		PRE_COM.pageListArr = PRINTCOM.splitArray(PRE_COM.listArr, pageRows);
	}
}

/*
 * @desc: 当前页公共参数初始化
 */
function initCurComVal() {
	var rowHeight = PRE_COM.xmlTblRowHeight;
	var curPageIndex = PRE_COM.curPageIndex;
	var curTblRows = PRE_COM.pageListArr[curPageIndex].length; // 防止下标越界 todo...
	var curTblHeight = rowHeight * (curTblRows - 1);
	PRE_COM.curTblRows = curTblRows;
	PRE_COM.curTblHeight = curTblHeight;
}

/*
 * @desc: xml打印预览公共
 */
function showHtmlFromXml() {
	// 页面整体
	var bodyLayout = document.getElementById("bodyLayout");
	bodyLayout.style.cssText = "height:" + PRE_COM.pageHeight + "px;width:" + PRE_COM.pageWidth + "px;background-color:" + PRE_COM.pageColor + ';position: relative;';
	// 右侧按钮
	var preview = PRE_COM.inputData.preview;
	if (preview) {
		if (preview.showButtons == true) {
			var btnsDivPos = {
				width: '100px',
				height: '280px',
				top: 0,
				left: (PRE_COM.pageWidth) + 'px'
			}
			var btnArr = [
				['btn-pageUp', 'pageUp', btnPageUp],
				['btn-pageDown', 'pageDown', btnpageDown],
				['btn-print', 'printByInv', btnPrintByInv],
				['btn-exportpdf', 'exportPDF', btnExportPDF],
				['btn-exportjpg', 'exportJPG', btnExportJPG],
			];
			if (preview.buttonsAlign == 'top') {
				btnsDivPos = {
					width: '98%',
					height: '45px',
					top: 0,
					left: 0
				}
				bodyLayout.style.cssText += 'top:45px;'
			} else if (preview.buttonsAlign == 'bottom') {
				btnsDivPos = {
					width: '98%',
					height: '45px',
					bottom: 0,
					left: 0
				}
				bodyLayout.style.cssText += 'margin-bottom: 45px;'
			} else if (preview.buttonsAlign == 'left') {
				btnsDivPos = {
					width: '100px',
					height: '280px',
					top: 0,
					left: 0
				}
				bodyLayout.style.cssText += 'left:105px;'
			}
			
			// 背景色
			var bdBackgroundColor = '';
			var bd = document.getElementsByTagName('body');
			if (bd && bd.length > 0) {
				bdBackgroundColor = bd[0].style.backgroundColor
			}
			// 生成btns
			var buttons = '';
			for (var i = 0; i < btnArr.length; i++) {
				buttons += "<button id='" + btnArr[i][0] + "' type='button' style='white-space:nowrap;cursor:pointer;width:85px;text-align:left;float:left;margin-left:10px;margin-top:10px;' onclick='" + btnArr[i][1] + "();'>" + btnArr[i][2] + "</button>";
			}
			// 生成div
			var btnsDiv = '<div id="divBtns" style="position:fixed;white-space:nowrap;text-align:left;background-color:' + bdBackgroundColor + ';z-index:999;overflow:hidden;';
			for (var k in btnsDivPos) {
				btnsDiv += k + ':' + btnsDivPos[k] + ";";
			}
			btnsDiv += '">' + buttons + '</div>';
			// 渲染div
			// setCtrlHtml("", btnsDiv);
			if ($('#divBtns').length == 0) {
				$('body').append(btnsDiv);
			}
		}
	}
	// 所有元素
	showOnePage();
}

/*
 * @desc: 显示一页的所有元素
 */
function showOnePage() {
	var templateName = PRE_COM.inputData.XMLTemplate;
	var tempXmlStr = PRINTCOM.XMLTemplate[templateName];
	var docobj = PRINTCOM.CreateXMLDOM(tempXmlStr);
	var invXMLDoc = docobj.getElementsByTagName("invoice")[0];
	var xmlTxtData = invXMLDoc.getElementsByTagName("TxtData");
	var xmlPICData = invXMLDoc.getElementsByTagName("PICData");
	var xmlPLData = invXMLDoc.getElementsByTagName("PLData");
	var xmlListData = invXMLDoc.getElementsByTagName("ListData")[0]; // 仅一个
	// 1.页码
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
		var pheight = 10; // mm
		var pwidth = 50; // mm
		addLabel({
			name: "pageNo",
			x: pleft,
			y: ptop,
			value: pageNoStr,
			fontbold: pfbold,
			fontname: pfname,
			fontsize: pfsize,
			height: pheight,
			width: pwidth
		});
	}
	// 2.扩展元素(每页都显示)
	var preExtObj = PRE_COM.inputData.extObj;
	if (preExtObj) {
		var preExtElements = preExtObj.elements || [];
		var len = preExtElements.length;
		for (var i = 0; i < len; i++) {
			var oneItem = preExtElements[i];
			if (oneItem.type == 'line') {
				addLine(oneItem);
			}
			if (oneItem.type == 'pic') {
				addImage(oneItem);
			}
			if (oneItem.type == 'text') {
				addLabel(oneItem);
			}
		}
	}
	// 3.原始模板
	for (var p = 0; p < xmlTxtData.length; p++) {
		var pXmlTxtData = xmlTxtData[p];
		addLabels(pXmlTxtData);
	}
	for (var p = 0; p < xmlPICData.length; p++) {
		var pXmlPICData = xmlPICData[p];
		addImages(pXmlPICData);
	}
	for (var p = 0; p < xmlPLData.length; p++) {
		var pXmlPLData = xmlPLData[p];
		addLines(pXmlPLData);
	}
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
	for (var i = 0; i < txtDataParas.length; i++) {
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
		var pheight = itm.getAttribute("height");
		var pwidth = itm.getAttribute("width");
		var pdval = itm.getAttribute("defaultvalue");
		var ppval = itm.getAttribute("printvalue");
		var pfbold = itm.getAttribute("fontbold");
		var pfname = itm.getAttribute("fontname");
		var pfsize = itm.getAttribute("fontsize");
		var pfontcolor = itm.getAttribute("fontcolor");
		var pangle = itm.getAttribute("angle");
		var pisqrcode = itm.getAttribute("isqrcode");
		var pqrcodeversion = itm.getAttribute("qrcodeversion");
		var pbarcodetype = itm.getAttribute("barcodetype");
		var pisshowtext = itm.getAttribute("isshowtext");
		var pval = "undefined" != typeof PRE_COM.paraObj[pname] ? PRE_COM.paraObj[pname] : (pdval || ppval);
		
		addLabel({
			name: pname,
			x: pleft,
			y: ptop,
			width: pwidth,
			height: pheight,
			value: pval,
			fontbold: pfbold,
			fontname: pfname,
			fontsize: pfsize,
			fontcolor: pfontcolor,
			angle: pangle,
			isqrcode: pisqrcode,
			qrcodeversion: pqrcodeversion,
			barcodetype: pbarcodetype,
			isshowtext: pisshowtext
		});
	}
}
// 显示一条
function addLabel(oneItem, isListItem) {
	var aptListFields = PRE_COM.inputData.aptListFields;
	var curTblHeight = PRE_COM.curTblHeight;
	var x = convertPtToPx(oneItem.x);
	var y = convertPtToPx(oneItem.y);
	if (!isListItem && aptListFields.indexOf(oneItem.name) >= 0) {
		y = y + curTblHeight;
	}
	var ctrlHtml = "";
	if (oneItem.isqrcode == "true") {
		// 显示二维码
		var cId = getNewCtrlId("qrcode");
		var qrWidth = convertPtToPx(oneItem.width);
		var qrHeight = convertPtToPx(oneItem.height);
		var qrcodeversion = oneItem.qrcodeversion; // todo...
		ctrlHtml = "<div id ='" + cId + "' ";
		ctrlHtml += "style='position:absolute; margin:0px; padding:0px;left:" + x + "px;top:" + y + "px;width:" + qrWidth + "px;height:" + qrHeight + "px;'>";
		ctrlHtml += "</div>";
		setCtrlHtml(cId, ctrlHtml);
		PRE_COM.QRCodeArr.push({
			cId: cId,
			qrcode: {
				render: "table",               // 渲染方式有table方式（IE兼容）和canvas方式
				width: qrWidth,                // 宽度
				height: qrHeight,              // 高度
				text: utf16to8(oneItem.value), // 内容(若不包含中文可能有问题???)
				typeNumber: -1,                // 计算模式
				correctLevel: 2,               // 二维码纠错级别
				background: "#ffffff",         // 背景颜色
				foreground: "#000000"          // 二维码颜色
			}
		});
		if (isListItem) {
			return ctrlHtml;
		}
	} else if (oneItem.barcodetype && oneItem.barcodetype != '') {
		// 条形码(暂时使用条码字体替代) todo...
		var fontFamily = oneItem.isshowtext == 'N' ? 'C39P36DmTt' : 'C39HrP60DmTt';
		var cId = getNewCtrlId("label");
		ctrlHtml = "<label ctrlType='label' id='" + cId + "' name='" + oneItem.name + "' ";
		ctrlHtml += "style='position:absolute;white-space:nowrap;left:" + x + "px;top:" + y + "px;";
		ctrlHtml += "font-size:" + getBarFontSize(oneItem.height, oneItem.width) + "pt;";
		ctrlHtml += "font-family:" + fontFamily + ";";
		if (oneItem.fontcolor && oneItem.fontcolor != "") {
			ctrlHtml += "color:" + oneItem.fontcolor + ";";
		}
		if (oneItem.angle && oneItem.angle != "") {
			ctrlHtml += getRotateCssText(-oneItem.angle, 'left top');
		}
		ctrlHtml += "' >";
		if (typeof oneItem.value != 'undefined' && oneItem.value != null) {
			var showVal = oneItem.value; // .toString().split(' ').join(getSpaceStr());
			ctrlHtml += showVal + "</label>";
		} else {
			ctrlHtml += "</label>";
		}
		if (isListItem) {
			return ctrlHtml;
		}
		setCtrlHtml(cId, ctrlHtml);
	} else {
		// 文本或者字体条码
		var cId = getNewCtrlId("label");
		ctrlHtml = "<label ctrlType='label' id='" + cId + "' name='" + oneItem.name + "' ";
		ctrlHtml += "style='position:absolute;left:" + x + "px;top:" + y + "px;";
		var whiteSpace = 'nowrap;';
		if (oneItem.width > 0) {
			ctrlHtml += "width:" + convertPtToPx(oneItem.width) + "px;";
			whiteSpace = 'pre-wrap;overflow:hidden;'
		}
		if (oneItem.height > 0) {
			ctrlHtml += "height:" + convertPtToPx(oneItem.height) + "px;";
			whiteSpace = 'pre-wrap;overflow:hidden;'
		}
		ctrlHtml += "white-space:" + whiteSpace + "";
		if (oneItem.fontsize > 0 && oneItem.fontsize != 12) {
			ctrlHtml += "font-size:" + oneItem.fontsize + "pt;";
		} else {
			ctrlHtml += "font-size:" + 12 + "pt;";
		}
		if (oneItem.fontbold == "true") {
			ctrlHtml += "font-weight:bold;";
		}
		if (oneItem.fontname && oneItem.fontname != "宋体") {
			ctrlHtml += "font-family:" + oneItem.fontname + ";";
		} else {
			ctrlHtml += "font-family:" + "宋体" + ";";
		}
		if (oneItem.fontcolor && oneItem.fontcolor != "") {
			ctrlHtml += "color:" + oneItem.fontcolor + ";";
		}
		if (oneItem.itemStyler && oneItem.itemStyler != "") {
			ctrlHtml += oneItem.itemStyler;
		}
		if (oneItem.angle && oneItem.angle != "") {
			ctrlHtml += getRotateCssText(-oneItem.angle, 'left top');
		}
		ctrlHtml += "' >";
		if (typeof oneItem.value != 'undefined' && oneItem.value != null) {
			var showVal = oneItem.value.toString().split(' ').join(getSpaceStr());
			ctrlHtml += showVal + "</label>";
		} else {
			ctrlHtml += "</label>";
		}
		if (isListItem) {
			return ctrlHtml;
		}
		setCtrlHtml(cId, ctrlHtml);
	}
}

/*
 * @desc: 显示图片
 * @others: 长度单位为mm,需要通过convertPtToPx()转换
 */
function addImages(xmlPICData) {
	var endPageFields = PRE_COM.inputData.endPageFields || [];
	var isEndPageFlag = PRE_COM.curPageIndex == PRE_COM.pageListArr.length - 1 ? true : false;
	var xmlPICDataRePrtHeadFlag = xmlPICData.getAttribute("RePrtHeadFlag");
	var picDataParas = xmlPICData.getElementsByTagName("PICdatapara");
	for (var i = 0; i < picDataParas.length; i++) {
		var item = picDataParas[i];
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
		if (null == pheight) {
			pheight = 20;
		}
		if (null == pwidth) {
			pwidth = 20;
		}
		if (pval == "") {
			continue;
		}
		addImage({
			name: pname,
			x: pleft,
			y: ptop,
			value: pval,
			fontbold: pfbold,
			fontname: pfname,
			fontsize: pfsize,
			height: pheight,
			width: pwidth
		});
	}
}
// 显示一张
function addImage(oneItem, isListItem) {
	var imageCAFields = PRE_COM.inputData.imageCAFields;
	var aptListFields = PRE_COM.inputData.aptListFields;
	var curTblHeight = PRE_COM.curTblHeight;
	var x = convertPtToPx(oneItem.x);
	var y = convertPtToPx(oneItem.y);
	if (!isListItem && aptListFields.indexOf(oneItem.name) >= 0) {
		y = y + curTblHeight;
	}
	var width = convertPtToPx(oneItem.width);
	var height = convertPtToPx(oneItem.height);

	var cId = getNewCtrlId("img");
	var ctrlHtml = "<img ctrlType='img' id=" + cId + " name=" + oneItem.name;
	ctrlHtml = ctrlHtml + " style='position:absolute;left:" + x + "px;top:" + y + "px;' width='" + width + "px' height='" + height + "px' ";
	if (imageCAFields.indexOf(oneItem.name) >= 0) {
		/*
		var retCode = PRINTCOM.GetGifInfo(oneItem.value); // 生成gif
		if (retCode == 0) {
			ctrlHtml = ctrlHtml + "src='file://C:/" + oneItem.value + '.' + PRINTCOM.ImgSuffix + "' ";
		}
		*/
		ctrlHtml = ctrlHtml + "src='" + "data:image/jpg;base64," + PRINTCOM.getBase64Str(oneItem.value) + "' ";
	} else {
		ctrlHtml = ctrlHtml + "src='" + oneItem.value + "' ";
	}
	ctrlHtml = ctrlHtml + "/>";
	if (isListItem) {
		return ctrlHtml;
	}
	setCtrlHtml(cId, ctrlHtml);
}

/*
 * @desc: 显示线条
 * @others: 长度单位为mm,需要通过convertPtToPx()转换
 */
function addLines(xmlPLData) {
	var xmlPlineRePrtHeadFlag = xmlPLData.getAttribute("RePrtHeadFlag");
	var pLines = xmlPLData.getElementsByTagName("PLine");
	for (var i = 0; i < pLines.length; i++) {
		if (PRE_COM.curPageIndex >= 1 && xmlPlineRePrtHeadFlag != "Y") {
			continue;
		}
		var item = pLines[i];
		var sx = parseFloat(item.getAttribute("BeginX"));
		var sy = parseFloat(item.getAttribute("BeginY"));
		var ex = parseFloat(item.getAttribute("EndX"));
		var ey = parseFloat(item.getAttribute("EndY"));
		var fontcolor = item.getAttribute("fontcolor");
		addLine({
			sx: sx,
			sy: sy,
			ex: ex,
			ey: ey,
			fontcolor: fontcolor
		});
	}
}
// 显示一条
function addLine(oneItem) {
	var cId = getNewCtrlId("shape");
	var ctrlHtml = '<div ctrlType="shape" id="' + cId + '" name="' + oneItem.name + '" ';
	var width = convertPtToPx(parseFloat(oneItem.ex) - parseFloat(oneItem.sx));
	var height = convertPtToPx(parseFloat(oneItem.ey) - parseFloat(oneItem.sy));
	var sx = convertPtToPx(oneItem.sx);
	var sy = convertPtToPx(oneItem.sy);
	var ex = convertPtToPx(oneItem.ex);
	var ey = convertPtToPx(oneItem.ey);
	if (height == 0 && width != 0) {
		// 横线
		ctrlHtml += 'style="POSITION:absolute;border-color:000000;border-width:1px;border-color:' + (oneItem.fontcolor || '') + ';TOP:' + sy + 'px; LEFT:' + sx + 'px;width:' + width + 'px;';
		if (width > 0) {
			ctrlHtml += 'border-top-style:solid;';
		} else {
			ctrlHtml += 'border-bottom-style:solid;';
		}
		ctrlHtml += '"></div>';
	} else if (width == 0 && height != 0) {
		// 竖线
		ctrlHtml += 'style="POSITION:absolute;border-color:000000;border-width:1px;border-color:' + (oneItem.fontcolor || '') + ';TOP:' + sy + 'px; LEFT:' + sx + 'px;width:' + width + 'px;height:' + height + 'px;';
		if (height > 0) {
			ctrlHtml += 'border-left-style:solid;';
		} else {
			ctrlHtml += 'border-right-style:solid;';
		}
		ctrlHtml += '"></div>';
	} else {
		// 斜线
		ctrlHtml = drawLineHtml(cId, sx, sy, ex, ey, oneItem.fontcolor);
	}
	setCtrlHtml(cId, ctrlHtml);
}
// 斜线(长度单位PX)
function drawLineHtml(lineId, startX, startY, endX, endY, lineColor) {
	lineColor = lineColor || 'black';
	// 计算中点
	var mX = (startX + endX) / 2;
	var mY = (startY + endY) / 2;
	// 线长度
	var divWidth = Math.abs(startX - endX);
	var divHeight = Math.abs(startY - endY);
	var lineLength = parseInt(Math.sqrt(Math.pow(divWidth, 2) + Math.pow(divHeight, 2)));
	// 旋转角度
	var angle = Math.atan(divHeight / divWidth);
	angle = (180 / 3.14) * angle;
	angle = (startX < endX && startY > endY) || (startX > endX && startY < endY) ? -angle : angle;
	// 样式
	var cssText = '';
	cssText += 'position:absolute;';
	cssText += 'left:' + (mX - (lineLength / 2)) + 'px;';
	cssText += 'top:' + mY + 'px;';
	cssText += 'width:' + lineLength + 'px;';
	cssText += 'height:1px;';
	cssText += 'border-bottom:1px solid ' + lineColor + ';';
	cssText += getRotateCssText(angle);
	var lineHtml = '';
	lineHtml += '<div'
	lineHtml += ' ctrlType="shape" ';
	lineHtml += ' id="' + lineId + '" ';
	lineHtml += ' style="' + cssText + '" ';
	lineHtml += '></div>';
	return lineHtml;
	/*
	// 以下代码在IE有BUG,使用上面DIV旋转实现斜线. Huxt 2021-06-05
	var stX = startX;
	var stY = startY;
	var edX = endX;
	var edY = endY;
	if (startX > endX) {
		stX = endX;
		edX = startX;
	}
	if (startY > endY) {
		stY = endY;
		edY = startY;
	}
	var divH = edY - stY;
	var divW = edX - stX;
	var lineLength = Math.sqrt((divH * divH) + (divW * divW));
	lineLength = subFloat(lineLength, 2);
	var a = Math.atan(divW / divH);
	var b = (180 / 3.14) * a;
	b = subFloat(b, 2);
	var angle = b;
	if (startX >= endX && startY < endY) {
		angle = b; // 第三象限(0~90)
	} else if (startX >= endX && startY > endY) {
		angle = 180 - b; // 第二象限(90~180)
	} else if (startX < endX && startY <= endY) {
		angle = 0 - b; // 第四象限(0~-90)
	} else if (startX < endX && startY >= endY) {
		angle = -180 + b; // 第一象限(-90~-180)
	}
	var lineHtml = '<div ctrlType="shape" id="' + lineId + '" style="position:absolute;top:' + startY + ';left:' + startX + ';width:1px;height:' + lineLength + 'px;background-color:black;display:block;transform:rotate(' + angle + 'deg);transform-origin:top;">' + '</div>';
	return lineHtml;
	*/
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
	var xmlTblHeight = PRE_COM.xmlTblHeight; // 表格最大高度
	var xmlTblRowHeight = PRE_COM.xmlTblRowHeight;
	var pageHeight = PRE_COM.pageHeight;
	var myListArray = PRE_COM.pageListArr[curPageIndex]; // 本页数据
	var currentRow = 1;
	var pageRows = PRE_COM.xmlTblRows;
	var borderSpace = 0.5;
	var listBorder = PRE_COM.inputData.listBorder;
	borderSpace = listBorder && listBorder.space > 0 ? parseFloat(listBorder.space) : borderSpace;
	var halfBorderSpace = borderSpace / 2;
	
	var postion = getStartXY(xmlListData);
	if ((curTblHeight - postion.tblStartY) > pageHeight) {
		curTblHeight = pageHeight - postion.tblStartY; // px
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
	ctrlHtml += "style='position:absolute; margin:0px; padding:0px;left:" + postion.tblStartX + "px;top:" + (postion.tblStartY - halfBorderSpace) + "px;width:" + (postion.tblWidth + 100) + "px;height:" + curTblHeight + "px;'>";

	var rows = myListArray.length; // 行数
	for (var rowIndex = 0; rowIndex < rows; rowIndex++) {
		var colsNode = xmlListData.getElementsByTagName("Listdatapara");
		var cols = colsNode.length; // 列数
		if (cols == 0) {
			continue;
		}
		var childHtml = "";
		var listItemStr = myListArray[rowIndex];
		if (PRINTCOM.dataType(listItemStr) == "[object Object]") {
			// ---object---
			var listItemObj = listItemStr;
			for (var j = 0; j < cols; j++) {
				var colNode = colsNode[j]; // 某一列的属性
				var name = colNode.getAttribute("name");
				var xcol = colNode.getAttribute("xcol");
				var yrow = colNode.getAttribute("yrow");
				var strListSub = "undefined" != typeof listItemObj[name] ? listItemObj[name] : "";
				// DIV内部定位(px)
				var pcoltype = colNode.getAttribute("coltype");
				var fromDivLeft = convertPtToPx(xcol);
				var fromDivTop = convertPtToPx(yrow) + (rowIndex * xmlTblRowHeight);
				if (pcoltype != 'qrcode') {
					fromDivLeft = fromDivLeft - postion.tblStartX;
					fromDivTop = fromDivTop - postion.tblStartY;
				}
				var itemStyler = '';
				if (PRE_COM.origOptions && PRE_COM.origOptions.listItem) {
					if (PRE_COM.origOptions.listItem.styler) {
						itemStyler = PRE_COM.origOptions.listItem.styler(strListSub, listItemObj, rowIndex);
					}
					if (PRE_COM.origOptions.listItem.formatter) {
						strListSub = PRE_COM.origOptions.listItem.formatter(strListSub, listItemObj, rowIndex);
					}
				}
				// get label
				var oneColLabel = getListItem(colNode, fromDivLeft + borderSpace, fromDivTop, strListSub, itemStyler);
				childHtml += oneColLabel;
			}
		} else {
			// ---string---
			var listItemArr = listItemStr.split("^");
			for (var j = 0; j < cols; j++) {
				var colNode = colsNode[j]; // 某一列的属性
				var name = colNode.getAttribute("name");
				var xcol = colNode.getAttribute("xcol");
				var yrow = colNode.getAttribute("yrow");
				listItemArr[j] = "undefined" != typeof listItemArr[j] ? listItemArr[j] : "";
				var strListSub = listItemArr[j].toString();
				// DIV内部定位(px)
				var pcoltype = colNode.getAttribute("coltype");
				var fromDivLeft = convertPtToPx(xcol);
				var fromDivTop = convertPtToPx(yrow) + (rowIndex * xmlTblRowHeight);
				if (pcoltype != 'qrcode') {
					fromDivLeft = fromDivLeft - postion.tblStartX;
					fromDivTop = fromDivTop - postion.tblStartY;
				}
				var itemStyler = '';
				if (PRE_COM.origOptions && PRE_COM.origOptions.listItem) {
					if (PRE_COM.origOptions.listItem.styler) {
						itemStyler = PRE_COM.origOptions.listItem.styler(strListSub, listItemArr, rowIndex);
					}
					if (PRE_COM.origOptions.listItem.formatter) {
						strListSub = PRE_COM.origOptions.listItem.formatter(strListSub, listItemArr, rowIndex);
					}
				}
				// get label
				var oneColLabel = getListItem(colNode, fromDivLeft + borderSpace, fromDivTop, strListSub, itemStyler);
				childHtml += oneColLabel;
			}
		}
		ctrlHtml += childHtml;
	}
	ctrlHtml += "</div>";
	setCtrlHtml(cId, ctrlHtml);
	// 显示表格边框
	if (listBorder) {
		var lbStyle = listBorder.style;
		var lbStartX = listBorder.startX;
		var lbEndX = listBorder.endX;
		var headBorder = listBorder.headBorder;
		var styleArr = [];
		if (lbStyle >= 1) {
			for (var sa = 0; sa < lbStyle; sa++) {
				styleArr[sa] = sa + 1;
			}
		}
		// 每一页边框
		var tblStartY = convertPxToPt(postion.tblStartY - halfBorderSpace);
		var tblEndY = convertPxToPt(postion.tblStartY + (curTblRows * xmlTblRowHeight));
		if (styleArr.indexOf(1) >= 0) {
			addLine({
				sx: lbStartX,
				sy: tblStartY,
				ex: lbEndX,
				ey: tblStartY
			});
		}
		var tblStartYNew = tblStartY;
		if (styleArr.indexOf(2) >= 0) {
			var lineY = 0;
			for (var i = 0; i < curTblRows; i++) {
				lineY = (xmlTblRowHeight * (i + 1)) + postion.tblStartY - halfBorderSpace;
				lineY = convertPxToPt(lineY);
				addLine({
					sx: lbStartX,
					sy: lineY,
					ex: lbEndX,
					ey: lineY
				});
			}
			if (headBorder) {
				var tblStartYNew = tblStartY - convertPxToPt(xmlTblRowHeight); // 需要打印表头的边框,则向上移动
				addLine({
					sx: lbStartX,
					sy: tblStartYNew,
					ex: lbEndX,
					ey: tblStartYNew
				});
			}
		}
		if (styleArr.indexOf(3) >= 0) {
			var colsNode = xmlListData.getElementsByTagName("Listdatapara");
			var cols = colsNode.length;
			for (var j = 1; j < cols; j++) {
				var colNode = colsNode[j];
				var colStartX = colNode.getAttribute("xcol");
				addLine({
					sx: colStartX,
					sy: tblStartYNew,
					ex: colStartX,
					ey: tblEndY
				});
			}
		}
		if (styleArr.indexOf(4) >= 0) {
			addLine({
				sx: lbStartX,
				sy: tblStartYNew,
				ex: lbStartX,
				ey: tblEndY
			});
			addLine({
				sx: lbEndX,
				sy: tblStartYNew,
				ex: lbEndX,
				ey: tblEndY
			});
		}
	}
	// 反斜杠
	if (PRE_COM.inputData.backSlash) {
		if (xmlTblRows > curTblRows) {
			var backSlashOpt = PRE_COM.inputData.backSlash;
			var fromList = backSlashOpt.fromList || 0;
			var backSlashEndY = convertPxToPt(postion.tblStartY + (xmlTblRowHeight * curTblRows)) + fromList;
			addLine({
				sx: backSlashOpt.startX,
				sy: backSlashOpt.startY,
				ex: backSlashOpt.endX,
				ey: backSlashEndY
			});
		}
	}
}

// 显示List中的一项 (表格中的一格)
function getListItem(oneNode, fromDivLeft, fromDivTop, showValue, itemStyler) {
	var cId = getNewCtrlId("label");
	var pwidth = oneNode.getAttribute("width");
	var pheight = oneNode.getAttribute("height");
	var pname = oneNode.getAttribute("name");
	var pfsize = oneNode.getAttribute("fontsize");
	var pfbold = oneNode.getAttribute("fontbold");
	var pfname = oneNode.getAttribute("fontname");
	var pfontcolor = oneNode.getAttribute("fontcolor");
	var pangle = oneNode.getAttribute("angle");
	var pcoltype = oneNode.getAttribute("coltype"); // text & img & barcode & qrcode
	var pisqrcode = pcoltype == 'qrcode' ? 'true' : 'false';
	if (pisqrcode == 'true') {
		pwidth = pwidth == null || isNaN(pwidth) ? 10 : pwidth;
		pheight = pheight == null || isNaN(pheight) ? 10 : pheight;
	}
	var pqrcodeversion = oneNode.getAttribute("qrcodeversion");
	var pbarcodetype = oneNode.getAttribute("barcodetype");
	var pisshowtext = oneNode.getAttribute("isshowtext");
	
	if (pcoltype == 'img') {
		return addImage({
			name: pname,
			x: convertPxToPt(fromDivLeft),
			y: convertPxToPt(fromDivTop),
			width: pwidth,
			height: pheight,
			value: showValue,
			fontbold: pfbold,
			fontname: pfname,
			fontsize: pfsize,
			fontcolor: pfontcolor,
			angle: pangle,
			itemStyler: itemStyler
		}, true);
	} else {
		return addLabel({
			name: pname,
			x: convertPxToPt(fromDivLeft),
			y: convertPxToPt(fromDivTop),
			width: pwidth,
			height: pheight,
			value: showValue,
			fontbold: pfbold,
			fontname: pfname,
			fontsize: pfsize,
			fontcolor: pfontcolor,
			angle: pangle,
			isqrcode: pisqrcode,
			qrcodeversion: pqrcodeversion,
			barcodetype: pbarcodetype,
			isshowtext: pisshowtext,
			itemStyler: itemStyler
		}, true);
	}
}

// --------------------------------------------------
// 取得开始坐标
function getStartXY(xmlNode) {
	var count = xmlNode.childNodes.length;
	var startX = null;
	var startY = null;
	var endX = null;
	var endY = null;
	for (var index = 0; index < count; index++) {
		var oneNode = xmlNode.childNodes[index];
		if (oneNode.nodeName.toUpperCase() == "#TEXT") {
			continue;
		}
		var xcol = parseFloat(oneNode.getAttribute("xcol"), 10);
		var yrow = parseFloat(oneNode.getAttribute("yrow"), 10);
		if (startX == null) {
			startX = xcol;
		} else {
			if (xcol < startX) {
				startX = xcol;
			}
		}
		if (startY == null) {
			startY = yrow;
		} else {
			if (yrow < startY) {
				startY = yrow;
			}
		}

		if (endX == null) {
			endX = xcol;
		} else {
			if (xcol > endX) {
				endX = xcol;
			}
		}
		if (endY == null) {
			endY = yrow;
		} else {
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
// 设定新控件的html
function setCtrlHtml(cId, ctrlHtml) {
	PRE_COM.htmlStr += ctrlHtml;
}
// 显示信息
function showHtml() {
	var bodyLayout = document.getElementById("bodyLayout");
	bodyLayout.innerHTML = PRE_COM.htmlStr;
	renderQRCode();
}
// 渲染二维码(较慢,放在最后)
function renderQRCode() {
	var qrLen = PRE_COM.QRCodeArr.length;
	for (var i = 0; i < qrLen; i++) {
		var oneQRCode = PRE_COM.QRCodeArr[i];
		$('#' + oneQRCode.cId).qrcode(oneQRCode.qrcode)
	}
	PRE_COM.QRCodeArr.length = 0;
}
// 清空打印页数据
function clearPage() {
	PRE_COM.htmlStr = "";
	var bodyLayout = document.getElementById("bodyLayout");
	bodyLayout.innerHTML = '';
}
// 取得新控件Id
function getNewCtrlId(ctrlType) {
	var newCtrlId = "";
	for (var k in PRE_COM.htmlID) {
		if (k == ctrlType) {
			PRE_COM.htmlID[k] = PRE_COM.htmlID[k] + 1;
			newCtrlId = ctrlType + PRE_COM.htmlID[k];
			break;
		}
	}
	if (newCtrlId == "") {
		var ctrlType = 'otherctrls'
		PRE_COM.htmlID[ctrlType] = PRE_COM.htmlID[ctrlType] + 1;
		return ctrlType + PRE_COM.htmlID[ctrlType];
	}
	return newCtrlId;
}
// 将xml中的pt转化为px
function convertPtToPx(ptValue) {
	return subFloat((parseFloat(ptValue, 10)) * 3.78, 4);
}
// 将html中的px转化为pt
function convertPxToPt(pxValue) {
	return subFloat((parseFloat(pxValue, 10)) / 3.78, 4);
}
// 对数据四舍五入
function subFloat(num, v) {
	var vv = Math.pow(10, v);
	return Math.round(num * vv) / vv;
}
// 中文编码格式转换
function utf16to8(str) {
	var out, i, len, c;
	out = "";
	var len = str.length;
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
// 区域旋转
function getRotateCssText(angle, transformOrigin){
	var tCssText = '';
	tCssText += 'transform:rotate(' + angle + 'deg);';
	tCssText += '-ms-transform:rotate(' + angle + 'deg);';
	tCssText += '-moz-transform:rotate(' + angle + 'deg);';
	tCssText += '-webkit-transform:rotate(' + angle + 'deg);';
	tCssText += '-o-transform:rotate(' + angle + 'deg);';
	if (transformOrigin) {
		tCssText += 'transform-origin:' + transformOrigin + ';'; // 旋转中心
	}
	return tCssText;
}

// 按钮事件: 上一页
function pageUp() {
	if (PRE_COM.curPageIndex > 0) {
		PRE_COM.curPageIndex = PRE_COM.curPageIndex - 1;
		clearPage();
		initCurComVal();
		showHtmlFromXml();
	} else {
		alert(firstPageTips);
	}
}
// 按钮事件: 下一页
function pageDown() {
	if (PRE_COM.curPageIndex < PRE_COM.pageListArr.length - 1) {
		PRE_COM.curPageIndex = PRE_COM.curPageIndex + 1;
		clearPage();
		initCurComVal();
		showHtmlFromXml();
	} else {
		alert(endPageTips);
	}
}
// 按钮事件: inv打印控件
function printByInv() {
	var printOptions = getNewPrintData();
	if (existLodop()) {
		printOptions.printBy = 'lodop';
	}
	PRINTCOM.XML(printOptions);
}

// 导出PDF
function exportPDF() {
	if (confirm(confirmExportPdf)) {
		var pdfFileName = PRE_COM.inputData.XMLTemplate + ".pdf";
		var pdf = new jsPDF('p', 'pt', 'a4');
		pdf.internal.scaleFactor = 1.5; // 设置打印比例,值越大打印越小
		var options = {
			pagesplit: true, // 设置是否自动分页
			background: '#FFFFFF' // 如果导出的pdf为黑色背景
		};
		var printHtml = $('#bodyLayout').get(0);
		pdf.addHTML(printHtml, 15, 15, options, function () {
			pdf.save(pdfFileName);
		});
		// 下一页
		if (PRE_COM.curPageIndex < PRE_COM.pageListArr.length - 1) {
			pageDown();
			exportPDF();
		}
	}
}

// 导出为图片
function exportJPG(){
	var printOptions = getNewPrintData();
	if (existLodop()) {
		printOptions.printBy = 'lodop';
	}
	printOptions.saveFilePrompt = true;
	printOptions.saveFileName = exportJpgName + '_' + fileNamePre() + '.jpg';
	PRINTCOM.XML(printOptions);
}

// 获取新的打印数据
function getNewPrintData(){
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
		extendFn: function (data) {
			// 拷贝对象,防止源数据改变
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
					for (var i = 0; i < eLen; i++) {
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
	return printOptions;
}

// 图片文件前缀
function fileNamePre(){
	var dt = new Date();
	var y = dt.getFullYear();
	var m = dt.getMonth() + 1 < 10 ? '0' + (dt.getMonth() + 1) : (dt.getMonth() + 1);
	var d = dt.getDate() < 10 ? '0' + dt.getDate() : dt.getDate();
	var t = dt.getTime();
	return '' + y + m + d + '_' + t;
}

// 对象深拷贝(返回结果都是Object,没有Array)
function deepCopy(source) {
	var result = {};
	for (var key in source) {
		result[key] = typeof source[key] === 'object' ? deepCopy(source[key]) : source[key];
	}
	return result;
}

// 根据宽高返回条码字条的大小(可能不太准确)
function getBarFontSize(height, width) {
	var fontSize = parseInt(height) * 3 - 4;
	return fontSize;
}

// 判断是否可以调用lodop打印
function existLodop(){
	var lp;
	try {
		lp = getLodop();
	} catch(e){
		return false;
	}
	if (typeof lp == 'undefined') {
		return false;
	}
	return true;
}

// 页面整体的背景颜色
function addBodyColor(previewOpts){
	var bd = document.getElementsByTagName('body');
	if (!bd || bd.length == 0) {
		return;
	}
	if (previewOpts.bodyColor && previewOpts.bodyColor != '') {
		bd[0].style.backgroundColor = previewOpts.bodyColor;
	}
}

// 空格占位符
function getSpaceStr(){
	// return '&nbsp;';
	return '<span style="visibility:hidden">1</span>';
}
