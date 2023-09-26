/**
* @creator: Huxiaotian 2019-11-20
* @desc: 	药房药库打印公共方法封装(xml & 润乾)
* @js: 		scripts/pharmacy/common/js/printcom.js
* @others: 	dependent on jQuery and websys.Broker.cls
*/
PRINTCOM = {
	/*
	* @desc: 公共变量定义
	*/
	XMLTemplate: {},
	PrtAryData: new Array(),
	ImgUserInfo: new Array(), //todo...
	ImgSuffix: 'jpg',
	QRCount: 0,
	BackSlash: {},
	ImgGetFrom: {
		ClassName: 'PHA.COM.Print',
		MethodName: 'GetBase64Str'
	},
	ClsSaveBase64IMG: (function(){
		try {
			return new ActiveXObject("Base64IMGSave.ClsSaveBase64IMG");
		} catch(err) {
			return null;
		}
	})(),
	DOMDocumentObject: (function(){
		var retobj = null
		try {
			retobj = new ActiveXObject("MSXML2.DOMDocument.4.0");
			retobj.async = false;
			return retobj;
		} catch(err) {
			return null;
		}
		return retobj;
	})(),
	IsIECore: (function(){
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
		    return true;
		} else {
		    return false;
		}
	})(),
	AppPath: (function(){
		var cspUrl = window.location.href;
		var cspUrlArr = cspUrl.split("/");
		return "/" + cspUrlArr[3] + "/" +cspUrlArr[4] + "/"; // '/imedical/web/' or '/dthealth/web/'
	})(),
	
	/*
	* @desc: xml模板打印公共入口
	*/
	XML: function(_options){
		_options.printBy = _options.printBy || "";
		//local data
		if (_options.data) {
			var retJson = _options.data;
			if (retJson.Grid) {
				retJson.List = this.getListData(retJson.Grid);
			}
			if (_options.printBy.toUpperCase() == "INV") {
				PRINTCOM.PrintByVB(retJson, _options);
			} else {
				var LODOP = getLodop();
				if (_options.oneTask == true) {
					PRINTCOM.PrintByLodopTask(retJson, _options, LODOP);
				} else {
					PRINTCOM.PrintByLodop(retJson, _options, LODOP, true, true);
				}
			}
			return;
		}
		//$.cm(
		this.jsRunServer(
			_options.dataOptions, 
			function(retJson) {
				if (retJson.msg) {
					alert(retJson.msg);
					return;
				}
				_options.printBy = _options.printBy || "";
				if (_options.printBy.toUpperCase() == "INV") {
					PRINTCOM.PrintByVB(retJson, _options);
				} else {
					var LODOP = getLodop();
					if (_options.oneTask == true) {
						PRINTCOM.PrintByLodopTask(retJson, _options, LODOP);
					} else {
						PRINTCOM.PrintByLodop(retJson, _options, LODOP, true, true);
					}
				}
			},
			function(error) {
				alert(error.responseText);
			}
		);
	},
	/*
	* @desc: 使用VB打印控件
	* json: {Para:{}, List:[str1,str2,...]}
	*/
	PrintByVB: function(retJson, _options){
		//VB预览打印
		if(_options.preview){
			this.PrintByVBPreview(retJson, _options);
			return;
		}
		
		//VB直接打印
		var imageCAFields = _options.imageCAFields || [];
		var aptListFields = _options.aptListFields || [];
		var templateName = _options.XMLTemplate;
		var myPara = "";
		var myList = "";
		var paraObj = retJson.Para || {};
		var listArr = retJson.List || [];
		for (var mKey in paraObj) {
			if (imageCAFields.indexOf(mKey) >= 0) {
				var userInfo = paraObj[mKey];
				var retCode = this.GetGifInfo(userInfo);
				if (retCode == 0) {
					paraObj[mKey] = "C:/" + userInfo + "." + this.ImgSuffix;
				} else {
					paraObj[mKey] = "";
				}
			}
			if (myPara == "") {
				myPara = mKey + String.fromCharCode(2) + paraObj[mKey];
			} else {
				myPara += "^" + mKey + String.fromCharCode(2) + paraObj[mKey];
			}
		}
		//扩展项数据
		_options.extendFn = _options.extendFn || function(){return {}}
		var extObj = _options.extendFn(retJson);
		var pageNoExt = 0;
		var pageNoExtIndex = 0;
		if(_options.page){
			//需要分页(js中指定分页)
			var pageNoStr = "";
			var pageInfo = _options.page;
			var pageRows = pageInfo.rows;
			var listPageArr = this.splitArray(listArr, pageRows);
			var listPages = listPageArr.length; //总页数
			for (var p=0; p<listPages; p++) {
				var onePageData = listPageArr[p]; //[rowstr,rowstr]
				var onePageRows = onePageData.length;
				myList = "";
				for(var c=0; c<onePageRows; c++){
					if(myList == ""){
						myList = onePageData[c];
					} else {
						myList += String.fromCharCode(2) + onePageData[c];
					}
				}
				//页码
				pageNoStr = pageInfo.format || "";
				pageNoStr = pageNoStr.replace("{1}", p + 1);
				pageNoStr = pageNoStr.replace("{2}", listPages);
				if(pageNoStr != ""){
					if(pageNoExt == 0){
						extObj.elements = extObj.elements || [];
						extObj.elements.push({
							type: 'text',
							name: 'pageNums',
							x: pageInfo.x || 10,
							y: pageInfo.y  || 10,
							value: pageNoStr,
							fontbold: pageInfo.fontbold || 'false',
							fontname: pageInfo.fontname || '宋体',
							fontsize: pageInfo.fontsize || 12
						})
						pageNoExt = 1;
						pageNoExtIndex = extObj.elements.length - 1;
					} else {
						extObj.elements[pageNoExtIndex].value = pageNoStr; //第二页开始改变页码值即可
					}
				}
				extObj.pageRows = onePageRows;
				extObj.jsPageRows = pageRows;
				extObj.aptListFields = aptListFields;
				extObj.listBorder = _options.listBorder;
				extObj.endPageFields = _options.endPageFields;
				extObj.backSlash = _options.backSlash;
				extObj.pageNo = p + 1;
				extObj.listPages = listPages;
				this.PrintByVBDirect(myPara, myList, templateName, extObj);
			}
		} else {
			//不需要分页(vb打印控件里面会有自动分页机制,但是没有显示页码)
			var allRows = listArr.length;
			for(var c=0; c<allRows; c++){
				if(myList == ""){
					myList = listArr[c];
				} else {
					myList += String.fromCharCode(2) + listArr[c];
				}
			}
			extObj.pageRows = allRows;
			extObj.aptListFields = aptListFields;
			extObj.listBorder = _options.listBorder;
			extObj.endPageFields = _options.endPageFields;
			extObj.backSlash = _options.backSlash;
			extObj.pageNo = 1;
			extObj.listPages = 1;
			this.PrintByVBDirect(myPara, myList, templateName, extObj);
		}
	},
	PrintByVBPreview: function(retJson, _options){
		var pWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		var pHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var previewInfo = _options.preview;
		if (previewInfo == true) {
			previewInfo = {};
		}
		previewInfo.backgroundColor = previewInfo.backgroundColor || "white";
		previewInfo.showButtons = previewInfo.showButtons || false;
		previewInfo.x = previewInfo.x || 0;
		previewInfo.y = previewInfo.y || 0;
		previewInfo.width = previewInfo.width || (pWidth-30);
		previewInfo.height = previewInfo.height || (pHeight-30);
		
		_options.imageCAFields = _options.imageCAFields || [];
		_options.aptListFields = _options.aptListFields || [];
		_options.extendFn = _options.extendFn || function(){return {}}
		_options.extObj = _options.extendFn(retJson);
		var pid = tkMakeServerCall("PHA.COM.Print", "SetPreviewParams", JSON.stringify(_options));
		var pUrl = this.AppPath + "csp/pha.com.xmlprintpreview.csp?pid=" + pid;
		
		//csp中iframe嵌入预览
		var iframeID = _options.iframeID || "";
		if (iframeID != "") {
			$("#" + iframeID).attr("src", pUrl);
			return;
		}
		//弹窗预览
		var openWinInfo = "";
		openWinInfo += "left=" + previewInfo.x + ", ";
		openWinInfo += "top=" + previewInfo.y + ", ";
		openWinInfo += "width=" + previewInfo.width + ", ";
		openWinInfo += "height=" + previewInfo.height + ", ";
		openWinInfo += "toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no";
		window.open(pUrl, 'XML预览界面', openWinInfo);
	},
	PrintByVBDirect: function(pStr, lStr, template, extObj){
		//加载原始XML模板
		this.loadXMLTemplate(template);
		var tempXmlStr = this.XMLTemplate[template];
		var docobj = this.CreateXMLDOM(tempXmlStr); //IE & Chrome
		var invXMLDoc = docobj.getElementsByTagName("invoice")[0];
		var xmlPLData = invXMLDoc.getElementsByTagName("PLData")[0];
		var xmlTxtData = invXMLDoc.getElementsByTagName("TxtData")[0];
		var xmlPICData = invXMLDoc.getElementsByTagName("PICData")[0];
		var xmlListData = invXMLDoc.getElementsByTagName("ListData")[0];
		
		//此处待优化 todo...
		var endPageFields = extObj.endPageFields || [];
		if (extObj.pageNo > 1) {
			if (xmlPLData.getAttribute("RePrtHeadFlag") != "Y") {
				this.removeChildNodes(xmlPLData, "PLine");
			}
			if (xmlTxtData.getAttribute("RePrtHeadFlag") != "Y") {
				var exceptFields = extObj.pageNo == extObj.listPages ? endPageFields : []; //最后一页保留
				this.removeChildNodes(xmlTxtData, "txtdatapara", exceptFields);
			} else {
				var removeFields = extObj.pageNo != extObj.listPages ? endPageFields : [];
				this.removeChildNodesByName(xmlTxtData, "txtdatapara", removeFields);
			}
			if (xmlPICData.getAttribute("RePrtHeadFlag") != "Y") {
				var exceptFields = extObj.pageNo == extObj.listPages ? endPageFields : []; //最后一页保留
				this.removeChildNodes(xmlPICData, "PICdatapara", exceptFields);
			} else {
				var removeFields = extObj.pageNo != extObj.listPages ? endPageFields : [];
				this.removeChildNodesByName(xmlPICData, "PICdatapara", removeFields);
			}
		} else {
			if (extObj.listPages > 1) {
				var removeFields = extObj.pageNo != extObj.listPages ? endPageFields : [];
				this.removeChildNodesByName(xmlTxtData, "txtdatapara", endPageFields);
				this.removeChildNodesByName(xmlPICData, "PICdatapara", endPageFields);
			}
		}
		
		//扩展XML模板: 1.打印机; 2.元素; 3.表格边框; 4.自适应label元素
		var prtDevice = extObj.PrtDevice || "";
		var extElements = extObj.elements || [];
		var pageRows = extObj.pageRows || 0;
		var aptListFields = extObj.aptListFields;
		var listBorder = extObj.listBorder;
		var backSlash = null;
		var xmlBackSlash = this.getBackSlashInfo(template, xmlTxtData, xmlListData);
		if (xmlBackSlash != null) {
			backSlash = xmlBackSlash;
			backSlash.fromList = extObj.backSlash ? extObj.backSlash.fromList : 0;
		} else {
			backSlash = extObj.backSlash;
		}
		
		//1.打印机
		if(prtDevice != ""){
			invXMLDoc.setAttribute("PrtDevice", prtDevice);
		}
		//2.元素
		for (var i=0; i<extElements.length; i++) {
			var oneElement = extElements[i];
			if(oneElement.type == "line"){
				var iPLine = docobj.createElement("PLine");
				iPLine.setAttribute("BeginX", oneElement.sx);
				iPLine.setAttribute("BeginY", oneElement.sy);
				iPLine.setAttribute("EndX", oneElement.ex);
				iPLine.setAttribute("EndY", oneElement.ey);
				xmlPLData.appendChild(iPLine);
			}
			if(oneElement.type == "text"){
				var iText = docobj.createElement("txtdatapara");
				iText.setAttribute("name", oneElement.name);
				iText.setAttribute("xcol", oneElement.x);
				iText.setAttribute("yrow", oneElement.y);
				iText.setAttribute("defaultvalue", oneElement.value);
				iText.setAttribute("printvalue", oneElement.value);
				iText.setAttribute("fontbold", oneElement.fontbold);
				iText.setAttribute("fontname", oneElement.fontname);
				iText.setAttribute("fontsize", oneElement.fontsize);
				if(oneElement.isqrcode == "true"){
					iText.setAttribute("isqrcode", oneElement.isqrcode);
					iText.setAttribute("width", oneElement.width);
					iText.setAttribute("height", oneElement.height);
				}
				if(oneElement.barcodetype){
					iText.setAttribute("barcodetype", oneElement.barcodetype);
					iText.setAttribute("width", oneElement.width);
					iText.setAttribute("height", oneElement.height);
				}
				xmlTxtData.appendChild(iText);
			}
			if(oneElement.type == "pic"){
				var iPIC = docobj.createElement("PICdatapara");
				iPIC.setAttribute("name", oneElement.name);
				iPIC.setAttribute("xcol", oneElement.x);
				iPIC.setAttribute("yrow", oneElement.y);
				iPIC.setAttribute("defaultvalue", oneElement.value);
				iPIC.setAttribute("printvalue", oneElement.value);
				iPIC.setAttribute("width", oneElement.width);
				iPIC.setAttribute("height", oneElement.height);
				xmlPICData.appendChild(iPIC);
			}
		}
		//3.表格边框
		var xmlListStartY = 0;
		var xmlListRowHeight = 0;
		var xmlPageRows = 0;
		if (xmlListData) {
			xmlListRowHeight = parseFloat(xmlListData.getAttribute("YStep"));
			xmlPageRows = parseFloat(xmlListData.getAttribute("PageRows"));
			var firstListItm = xmlListData.getElementsByTagName("Listdatapara")[0];
			if (firstListItm) {
				xmlListStartY = parseFloat(firstListItm.getAttribute("yrow")) - 1;
			}
			xmlListData.setAttribute("CurrentRow", "0"); //对药房没啥用,强行设置为0. todo...
		}
		if (extObj.jsPageRows) {
			xmlPageRows = extObj.jsPageRows; //以js中指定的每页行数为准
		}
		if (pageRows > xmlPageRows) {
			pageRows = xmlPageRows;
		}
		var tblHeight = xmlListRowHeight * pageRows;
		//list边框
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
			//每页的line不一样
			var tblLineArr = [];
			if (styleArr.indexOf(1) >= 0) {
				tblLineArr.push({type: 'line', sx:lbStartX, sy:xmlListStartY, ex:lbEndX, ey:xmlListStartY});
			}
			var xmlListStartYNew = xmlListStartY;
			if (styleArr.indexOf(2) >= 0) {
				var lineY = 0;
				for(var i=0; i<pageRows; i++){
					lineY = (xmlListRowHeight * (i + 1)) + xmlListStartY;
					tblLineArr.push({type: 'line', sx:lbStartX, sy:lineY, ex:lbEndX, ey:lineY});
				}
				if (headBorder) {
					var xmlListStartYNew = xmlListStartY - xmlListRowHeight; //需要打印表头的边框,则向上移动
					tblLineArr.push({type: 'line', sx:lbStartX, sy:xmlListStartYNew, ex:lbEndX, ey:xmlListStartYNew}); //表头边框
				}
			}
			if (styleArr.indexOf(3) >= 0) {
				var colsNode = xmlListData.getElementsByTagName("Listdatapara");
				var cols = colsNode.length;
				for (var j=1; j<cols; j++){
					var colNode = colsNode[j];
					var colStartX = colNode.getAttribute("xcol");
					tblLineArr.push({type: 'line', sx:colStartX, sy:xmlListStartYNew, ex:colStartX, ey:xmlListStartY+tblHeight});
				}
			}
			if (styleArr.indexOf(4) >= 0) {
				tblLineArr.push({type: 'line', sx:lbStartX, sy:xmlListStartYNew, ex:lbStartX, ey:xmlListStartY+tblHeight});
				tblLineArr.push({type: 'line', sx:lbEndX, sy:xmlListStartYNew, ex:lbEndX, ey:xmlListStartY+tblHeight});
			}
			//扩展到现有模板
			var mTblLines = tblLineArr.length;
			for (var k=0; k<mTblLines; k++) {
				var oneLineInfo = tblLineArr[k];
				var iPLine = docobj.createElement("PLine");
				iPLine.setAttribute("BeginX", oneLineInfo.sx);
				iPLine.setAttribute("BeginY", oneLineInfo.sy);
				iPLine.setAttribute("EndX", oneLineInfo.ex);
				iPLine.setAttribute("EndY", oneLineInfo.ey);
				xmlPLData.appendChild(iPLine);
			}
		}
		//反斜杠
		if (backSlash) {
			xmlListData.setAttribute("BackSlashWidth", "0");
			if (xmlPageRows > pageRows) {
				var fromList = backSlash.fromList || 0;
				var backSlashEndY = xmlListStartY + (xmlListRowHeight * pageRows) + fromList;
				var iPLine = docobj.createElement("PLine");
				iPLine.setAttribute("BeginX", backSlash.startX);
				iPLine.setAttribute("BeginY", backSlash.startY);
				iPLine.setAttribute("EndX", backSlash.endX);
				iPLine.setAttribute("EndY", backSlashEndY);
				xmlPLData.appendChild(iPLine);
			}
		}
		//4.自适应label元素
		if(aptListFields.length > 0){
			tblHeight = xmlListRowHeight * (pageRows - 1);
			if (xmlTxtData){
				var txtDataParas = xmlTxtData.getElementsByTagName("txtdatapara");
				for (var j=0; j<txtDataParas.length; j++){
					var itm = txtDataParas[j];
					var name = itm.getAttribute("name");
					if(aptListFields.indexOf(name) < 0){
						continue;
					}
					var ptop = itm.getAttribute("yrow");
					itm.setAttribute("yrow", (parseFloat(ptop) + tblHeight));
				}
			}
			if (xmlPICData){
				var picDataParas = xmlPICData.getElementsByTagName("PICdatapara");
				for (var j=0; j<picDataParas.length; j++){
					var itm = picDataParas[j];
					var name = itm.getAttribute("name");
					if(aptListFields.indexOf(name) < 0){
						continue;
					}
					var ptop = itm.getAttribute("yrow");
					itm.setAttribute("yrow", (parseFloat(ptop) + tblHeight));
				}
			}
		}
		//5.调用VB打印控件
		try {
			if (this.IsIECore) {
				var PObj = new ActiveXObject("DHCOPPrint.ClsBillPrint");
				var rtn = PObj.ToPrintHDLP(pStr, lStr, docobj); //ToPrintDoc(pStr, pStr, docobj);
			} else {
				var prtXmlStr = this.XML2String(docobj);
				var rtn = DHCOPPrint.ToPrintHDLPStr(pStr, lStr, prtXmlStr); //for Chrome
			}
		} catch(e) {
			alert("err:" + e.message + "at PRINTCOM.printByVB()");
			return;
		}
	},
	
	/*
	* @desc: 使用LODOP打印控件 -- 实现多页数据使用单一任务打印
	* json: [{Para:{}, List:[str1,str2,...]}, {Para:{}, List:[str1,str2,...]}, ...]
	* json: [{Para:{}, List:[{},{},...]}, {Para:{}, List:[{},{},...]}, ...]
	*/
	PrintByLodopTask: function(retJson, _options, LODOP){
		var tLen = retJson.length;
		var isFirst = false;
		var isEnd = false;
		for (var t=0; t<tLen; t++) {
			if (tLen == 1) {
				this.PrintByLodop(retJson[t], _options, LODOP, true, true);
				return;
			}
			if (t == 0) {
				isFirst = true;
			} else if (t == tLen - 1) {
				isEnd = true;
			} else {
				isFirst = false;
				isEnd = false;
			}
			this.PrintByLodop(retJson[t], _options, LODOP, isFirst, isEnd);
		}
	},
	/*
	* @desc: 使用LODOP打印控件
	* json: {Para:{}, List:[str1,str2,...]}
	* json: {Para:{}, List:[{},{},...]}
	*/
	PrintByLodop: function(retJson, _options, LODOP, isFirst, isEnd){
		var paraObj = retJson.Para || {};
		var listArr = retJson.List || [];
		var isListObject = false;
		if (listArr.length > 0) {
			if(this.dataType(listArr[0]) == "[object Object]"){
				isListObject = true;
			}
		}
		var imageCAFields = _options.imageCAFields || [];
		var aptListFields = _options.aptListFields || [];
		var templateName = _options.XMLTemplate;
		var endPageFields = _options.endPageFields || [];
		
		//加载原始XML模板
		this.loadXMLTemplate(templateName);
		var tempXmlStr = this.XMLTemplate[templateName];
		var docobj = this.CreateXMLDOM(tempXmlStr); //IE & Chrome
		var invXMLDoc = docobj.getElementsByTagName("invoice")[0];
		var xmlPLData = invXMLDoc.getElementsByTagName("PLData")[0];
		var xmlTxtData = invXMLDoc.getElementsByTagName("TxtData")[0];
		var xmlPICData = invXMLDoc.getElementsByTagName("PICData")[0];
		var xmlListData = invXMLDoc.getElementsByTagName("ListData")[0];
		var colObj = this.FormatCols(xmlListData, isListObject);
		var colArr = colObj.colArr;
		var invAttr = invXMLDoc.attributes;
		var invHeight = invAttr.getNamedItem("height").value || 29.7;
		invHeight = parseFloat(invHeight) * 10; //mm
		var invWidth = invAttr.getNamedItem("width").value || 21;
		invWidth = parseFloat(invWidth) * 10; //mm
		//扩展项:打印机
		_options.extendFn = _options.extendFn || function(){return {}}
		var extObj = _options.extendFn(retJson);
		var prtDevice = extObj.PrtDevice || "";
		if (prtDevice != "") {
			invXMLDoc.setAttribute("PrtDevice", prtDevice);
		}
		//初始化LODOP
		//var LODOP = getLodop();
		//for Chrome clear
		//if (this.IsIECore == false){LODOP.clear();}
		if (isFirst == true) {
			LODOP.PRINT_INIT("LODOP_" + templateName);
			this.LODOP_CreateInv(LODOP, invXMLDoc);
		}
		
		//分页信息(每页行数 js优先,xml其次)
		var xmlPageRows = 0;
		if (xmlListData){
			xmlPageRows = parseFloat(xmlListData.getAttribute("PageRows"));
		}
		var pageRows = xmlPageRows;
		var pageNoInfo = null;
		if(_options.page){
			var pageInfo = _options.page
			pageRows = pageInfo.rows;
			pageNoInfo = {
				x: pageInfo.x || 10,
				y: pageInfo.y  || 10,
				value: '',
				fontbold: pageInfo.fontbold || 'false',
				fontname: pageInfo.fontname || '宋体',
				fontsize: pageInfo.fontsize || 12
			}
		}
		//扩展项:页面元素
		var aptListFieldsInfo = [];
		var extElements = extObj.elements || [];
		for (var i=0; i<extElements.length; i++) {
			var oneItm = extElements[i];
			if (oneItm.type == 'line'){
				LODOP.ADD_PRINT_LINE(oneItm.sy+"mm", oneItm.sx+"mm", oneItm.ey+"mm", oneItm.ex+"mm", 0, 1);
				LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
				continue;
			}
			if (oneItm.type == 'pic') {
				var pval = oneItm.value || ""; //local path
				if ("" == pval) {
					continue;
				}
				if (imageCAFields.indexOf(oneItm.name) >= 0) {
					var base64Str = tkMakeServerCall(ImgGetFrom.ClassName, ImgGetFrom.MethodName, pval);
					pval = "<img border='0' src='" + "data:image/jpg;base64," + base64Str + "'/>"; //base64
				} else if (pval.indexOf("http:")==0 || pval.indexOf("data:")==0){
					pval = "<img border='0' src='" + pval + "'/>"; //url
				}
				if (aptListFields.indexOf(oneItm.name) >= 0){
					oneItm.rePrint = "Y";
					oneItm.value = pval;
					aptListFieldsInfo.push(oneItm);
					continue;
				}
				LODOP.ADD_PRINT_IMAGE(oneItm.y+"mm", oneItm.x+"mm", oneItm.width+"mm", oneItm.height+"mm", pval);
				LODOP.SET_PRINT_STYLEA(0, "Stretch", 1);
				LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
				continue;
			}
			if(oneItm.type == 'text'){
				if (aptListFields.indexOf(oneItm.name) >= 0){
					oneItm.rePrint = "Y";
					if (!oneItm.width) {
						oneItm.width = (invWidth - 20) + "mm";
					}
					if (!oneItm.height) {
						oneItm.height = "20mm";
					}
					aptListFieldsInfo.push(oneItm);
					continue;
				}
				if (oneItm.isqrcode == 'true') {
					LODOP.ADD_PRINT_BARCODE(oneItm.y+"mm", oneItm.x+"mm", oneItm.width+"mm", oneItm.height+"mm", "QRCode", oneItm.value);
					LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
				} else if (oneItm.barcodetype) {
					LODOP.ADD_PRINT_BARCODE(oneItm.y+"mm", oneItm.x+"mm", oneItm.width+"mm", oneItm.height+"mm", oneItm.pbarcodetype, oneItm.value);
					LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
				} else {
					LODOP.ADD_PRINT_TEXT(oneItm.y+"mm", oneItm.x+"mm", (invWidth - 20) + "mm", "20mm", oneItm.value);
					LODOP.SET_PRINT_STYLEA(0, "FontSize", oneItm.fontsize);
					LODOP.SET_PRINT_STYLEA(0, "FontName", oneItm.fontname);
					if (oneItm.fontbold == "true") {
						LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
					}
					LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
				}
			}
		}
		
		//XML - Line
		if (xmlPLData) {
			var xmlPlineRePrtHeadFlag = xmlPLData.getAttribute("RePrtHeadFlag");
			var pLines = xmlPLData.getElementsByTagName("PLine");
			for (var j=0; j<pLines.length; j++) {
				var item = pLines[j]
				var sLeft = item.getAttribute("BeginX");	
				var sTop = item.getAttribute("BeginY");	
				var eLeft = item.getAttribute("EndX");	
				var eTop = item.getAttribute("EndY");
				LODOP.ADD_PRINT_LINE(sTop+"mm", sLeft+"mm", eTop+"mm", eLeft+"mm", 0, 1);
				if (xmlPlineRePrtHeadFlag == "Y") {
					LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
				}
			}
		}
		
		//XML - Img
		if (xmlPICData) {
			var xmlPICDataRePrtHeadFlag = xmlPICData.getAttribute("RePrtHeadFlag");
			var picDataParas = xmlPICData.getElementsByTagName("PICdatapara");
			for (var j=0; j<picDataParas.length; j++){
				var item = picDataParas[j]
				var pname = item.getAttribute("name");	
				var pleft = item.getAttribute("xcol");	
				var ptop = item.getAttribute("yrow");	
				var pheight = item.getAttribute("height");
				pheight = null == pheight ? 20 : pheight;
				var pwidth = item.getAttribute("width");
				pwidth = null == pwidth ? 20 : pwidth;
				var pdval = item.getAttribute("defaultvalue");	
				var ppval = item.getAttribute("printvalue");
				var endPageFlag = endPageFields.indexOf(pname) >= 0 ? true : false;
				var newRePrintFlag = endPageFlag == true || xmlPICDataRePrtHeadFlag == "Y" ? "Y" : "N";
				// 图片3种传值方式
				var pval = paraObj[pname] || pdval; // local path
				if (imageCAFields.indexOf(pname) >= 0) {
					var base64Str = tkMakeServerCall(this.ImgGetFrom.ClassName, this.ImgGetFrom.MethodName, pval);
					pval = "<img border='0' src='" + "data:image/jpg;base64," + base64Str + "'/>"; //base64
				} else if (pval.indexOf("http:")==0 || pval.indexOf("data:")==0){
					pval = "<img border='0' src='" + pval + "'/>"; // url
				}
				if ("" == pval) {
					continue;
				}
				// 自适应元素
				if (aptListFields.indexOf(pname) >= 0) {
					aptListFieldsInfo.push({type:'pic', name:pname, x:pleft, y:ptop, value:pval, width:pwidth, height:pheight, rePrint:newRePrintFlag, endPageFlag:endPageFlag});
					continue;
				}
				// 非自适应元素
				LODOP.ADD_PRINT_IMAGE(ptop+"mm", pleft+"mm", pwidth+"mm", pheight+"mm", pval);
				LODOP.SET_PRINT_STYLEA(0, "Stretch", 1);
				if (newRePrintFlag == "Y") {
					LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
					if (endPageFlag == true) {
						LODOP.SET_PRINT_STYLEA(0,"PageIndex","Last");
					}
				}
			}
		}
		
		//XML - Text(含二维码和条码)
		if (xmlTxtData) {
			var backSlashWidth = parseFloat(xmlListData.getAttribute("BackSlashWidth"));
			var xmlTxtDataRePrtHeadFlag = xmlTxtData.getAttribute("RePrtHeadFlag");
			var txtDataParas = xmlTxtData.getElementsByTagName("txtdatapara");
			for (var j=0; j<txtDataParas.length; j++) {
				var itm = txtDataParas[j];
				var pname = itm.getAttribute("name");
				var pleft = itm.getAttribute("xcol");
				var ptop = itm.getAttribute("yrow");
				if (pname == "startPoint" && backSlashWidth != 0) {
					_options.backSlash = _options.backSlash || {};
					_options.backSlash.startX = parseFloat(pleft);
					_options.backSlash.startY = ptop;
					_options.backSlash.endX = parseFloat(pleft) + backSlashWidth;
					continue;
				}
				var pdval = itm.getAttribute("defaultvalue");
				var ppval = itm.getAttribute("printvalue");
				var pfbold = itm.getAttribute("fontbold");
				var pfname = itm.getAttribute("fontname");
				var pfsize = itm.getAttribute("fontsize");
				var pisqrcode = itm.getAttribute("isqrcode");
				var pbarcodetype = itm.getAttribute("barcodetype");
				var pval = "undefined" != typeof paraObj[pname] ? paraObj[pname] : pdval;
				var endPageFlag = endPageFields.indexOf(pname) >= 0 ? true : false;
				var newRePrintFlag = endPageFlag == true || xmlTxtDataRePrtHeadFlag == "Y" ? "Y" : "N";
				if (pval == "") {
					continue;
				}
				if (pisqrcode == "true") {
					var pheight = itm.getAttribute("height");
					var pwidth = itm.getAttribute("width");
					// 自适应元素
					if (aptListFields.indexOf(pname) >= 0) {
						aptListFieldsInfo.push({type:'text', name:pname, x:pleft, y:ptop, value:pval, fontbold:pfbold, fontname:pfname, fontsize:pfsize, width:pwidth, height:pheight, isqrcode:pisqrcode, rePrint:newRePrintFlag, endPageFlag:endPageFlag});
						continue;
					}
					// 非自适应元素
					LODOP.ADD_PRINT_BARCODE(ptop+"mm", pleft+"mm", pwidth+"mm", pheight+"mm", "QRCode", pval);
					if (newRePrintFlag == "Y") {
						LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
						if (endPageFlag == true) {
							LODOP.SET_PRINT_STYLEA(0,"PageIndex","Last");
						}
					}
				} else if (("undefined" != typeof pbarcodetype) && ( pbarcodetype != null)) {
					var pheight = itm.getAttribute("height");
					var pwidth = itm.getAttribute("width");
					var pangle = itm.getAttribute("angle") || "";
					var pisshowtext = itm.getAttribute("isshowtext") || "";
					// 自适应元素
					if (aptListFields.indexOf(pname) >= 0) {
						aptListFieldsInfo.push({type:'text', name:pname, x:pleft, y:ptop, value:pval, fontbold:pfbold, fontname:pfname, fontsize:pfsize, width:pwidth, height:pheight, barcodetype:pbarcodetype, rePrint:newRePrintFlag, endPageFlag:endPageFlag, angle:pangle, isshowtext: pisshowtext});
						continue;
					}
					// 非自适应元素
					LODOP.ADD_PRINT_BARCODE(ptop+"mm", pleft+"mm", pwidth+"mm", pheight+"mm", pbarcodetype, pval);
					if (newRePrintFlag == "Y") {
						LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
						if (endPageFlag == true) {
							LODOP.SET_PRINT_STYLEA(0, "PageIndex", "Last");
						}
					}
					if (pangle != "") {
						LODOP.SET_PRINT_STYLEA(0, "Angle", pangle);
					}
				} else {
					var pheight = itm.getAttribute("height") || "800";
					var pwidth = itm.getAttribute("width") || "800";
					var pangle = itm.getAttribute("angle") || "";
					// 自适应元素
					if (aptListFields.indexOf(pname) >= 0) {
						aptListFieldsInfo.push({type:'text', name:pname, x:pleft, y:ptop, value:pval, fontbold:pfbold, fontname:pfname, fontsize:pfsize, width:pwidth, height:pheight, rePrint:newRePrintFlag, endPageFlag:endPageFlag, angle:pangle});
						continue;
					}
					// 非自适应元素
					LODOP.ADD_PRINT_TEXT(ptop+"mm", pleft+"mm", pwidth+"mm", pheight+"mm", pval);
					LODOP.SET_PRINT_STYLEA(0, "FontSize", pfsize);
					LODOP.SET_PRINT_STYLEA(0, "FontName", pfname);
					if (pfbold == "true") {
						LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
					}
					if (newRePrintFlag == "Y") {
						LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
						if (endPageFlag == true) {
							LODOP.SET_PRINT_STYLEA(0, "PageIndex", "Last");
						}
					}
					if (pangle != "") {
						LODOP.SET_PRINT_STYLEA(0, "Angle", pangle);
					}
				}
			}
		}
		
		//XML - List
		if(xmlListData){
			var xmlListStartY = 0;
			if (colObj.minyrow) {
				xmlListStartY = parseFloat(colObj.minyrow);
			}
			var ListExtObj = {
				aptListFieldsInfo: aptListFieldsInfo,
				listBorder: _options.listBorder,
				pageRows: pageRows,
				xmlListStartY: xmlListStartY,
				xmlListRowHeight: parseFloat(xmlListData.getAttribute("YStep")) || 6,
				isListObject: isListObject,
				invHeight: invHeight,
				invWidth: invWidth,
				listAutoWrap: _options.listAutoWrap,
				listColAlign: _options.listColAlign,
				backSlash: _options.backSlash
			};
			var listHeight = ListExtObj.xmlListStartY + (pageRows * ListExtObj.xmlListRowHeight);
			if (listHeight > ListExtObj.invHeight) {
				console.log("list的最大高度大于page的高度");
				//return;
			}
			var listPageArr = this.splitArray(listArr, pageRows);
			var listPages = listPageArr.length;
			for (var p=0; p<listPages; p++) {
				//页码
				if (pageNoInfo != null) {
					var pageNoStr = pageInfo.format;
					pageNoStr = pageNoStr.replace("{1}", p + 1);
					pageNoStr = pageNoStr.replace("{2}", listPages);
					pageNoInfo.value = pageNoStr;
					ListExtObj.pageNoInfo = pageNoInfo;
				}
				ListExtObj.pageNo = p + 1;
				ListExtObj.listPages  = listPages;
				//分页
				if(p > 0){
					LODOP.NEWPAGE();
				}
				//一页
				this.PrintByLodopOnePage(LODOP, colArr, listPageArr[p], ListExtObj);
			}
		}
		
		if (isEnd == true) {
			//print
			if (_options.saveFileName) {
				LODOP.SET_SAVE_MODE("FILE_PROMPT", _options.saveFilePrompt);
				LODOP.SAVE_TO_FILE(_options.saveFileName);
			} else if (_options.preview) {
				LODOP.PREVIEW();
			} else {
				LODOP.PRINT();
			}
			//for Chrome invk
			//if (this.IsIECore == false) {var rtn = LODOP.invk();}
		} else {
			//new page
			LODOP.NEWPAGE();
		}
	},
	PrintByLodopOnePage: function(LODOP, colArr, listArr, ListExtObj){
		var aptListFieldsInfo = ListExtObj.aptListFieldsInfo;
		var listBorder = ListExtObj.listBorder;
		var pageRows = ListExtObj.pageRows;
		var curPageRows = listArr.length;
		var xmlListStartY = ListExtObj.xmlListStartY - 1;
		var xmlListRowHeight = ListExtObj.xmlListRowHeight;
		var isListObject = ListExtObj.isListObject;
		var invWidth = ListExtObj.invWidth;
		var pageNoInfo = ListExtObj.pageNoInfo;
		var pageNo = ListExtObj.pageNo;
		var listPages = ListExtObj.listPages;
		var listAutoWrap = ListExtObj.listAutoWrap;
		var listColAlign = ListExtObj.listColAlign;
		var borderSpace = 0.5;
		var backSlash = ListExtObj.backSlash;
		//1.表格边框
		var tblHeight = xmlListRowHeight * curPageRows;
		if (listBorder) {
			borderSpace = listBorder.space || 0.5;
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
			//每页的line不一样
			if(styleArr.indexOf(1) >= 0){
				LODOP.ADD_PRINT_LINE(xmlListStartY+"mm", lbStartX+"mm", xmlListStartY+"mm", lbEndX+"mm", 0, 1);
			}
			var xmlListStartYNew = xmlListStartY;
			if(styleArr.indexOf(2) >= 0){
				var lineY = 0;
				for (var i=0; i<curPageRows; i++) {
					lineY = (xmlListRowHeight * (i + 1)) + xmlListStartY;
					LODOP.ADD_PRINT_LINE(lineY+"mm", lbStartX+"mm", lineY+"mm", lbEndX+"mm", 0, 1);
				}
				if (headBorder) {
					var xmlListStartYNew = xmlListStartY - xmlListRowHeight; //需要打印表头的边框,则向上移动
					LODOP.ADD_PRINT_LINE(xmlListStartYNew+"mm", lbStartX+"mm", xmlListStartYNew+"mm", lbEndX+"mm", 0, 1); //表头边框
				}
			}
			if(styleArr.indexOf(3) >= 0){
				var cols = colArr.length;
				for (var j=1; j<cols; j++){
					var oneCol = colArr[j];
					var colStartX = oneCol.xcol;
					LODOP.ADD_PRINT_LINE(xmlListStartYNew+"mm", colStartX+"mm", (xmlListStartY+tblHeight)+"mm", colStartX+"mm", 0, 1);
				}
			}
			if(styleArr.indexOf(4) >= 0){
				LODOP.ADD_PRINT_LINE(xmlListStartYNew+"mm", lbStartX+"mm", (xmlListStartY+tblHeight)+"mm", lbStartX+"mm", 0, 1);
				LODOP.ADD_PRINT_LINE(xmlListStartYNew+"mm", lbEndX+"mm", (xmlListStartY+tblHeight)+"mm", lbEndX+"mm", 0, 1);
			}
		}
		//2.反斜杠
		if (backSlash) {
			if (pageRows > curPageRows) {
				var fromList = backSlash.fromList || 0;
				var backSlashEndY = xmlListStartY + (xmlListRowHeight * curPageRows) + fromList;
				LODOP.ADD_PRINT_LINE(backSlash.startY+"mm", backSlash.startX+"mm", backSlashEndY+"mm", backSlash.endX+"mm", 0, 1);
			}
		}
		//3.页码
		if (pageNoInfo) {
			LODOP.ADD_PRINT_TEXT(pageNoInfo.y+"mm", pageNoInfo.x+"mm", "50mm", "10mm", pageNoInfo.value);
			LODOP.SET_PRINT_STYLEA(0, "FontSize", pageNoInfo.fontsize);
			LODOP.SET_PRINT_STYLEA(0, "FontName", pageNoInfo.fontname);
			if (pageNoInfo.fontbold == "true") {
				LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
			}
		}
		//4.自适应label元素
		for (var i=0; i<aptListFieldsInfo.length; i++) {
			tblHeight = xmlListRowHeight * (curPageRows - 1);
			var oneItm = aptListFieldsInfo[i];
			if (pageNo > 1 && oneItm.rePrint != 'Y') {
				continue; // 仅在第一页打印
			}
			if (pageNo != listPages && oneItm.endPageFlag == true) {
				continue; // 该元素只在最后一页打印
			}
			if (oneItm.type == 'pic') {
				LODOP.ADD_PRINT_IMAGE((parseFloat(oneItm.y) + tblHeight)+"mm", oneItm.x+"mm", oneItm.width+"mm", oneItm.height+"mm", oneItm.value);
				LODOP.SET_PRINT_STYLEA(0, "Stretch", 1);
			} else if (oneItm.isqrcode == 'true') {
				LODOP.ADD_PRINT_BARCODE((parseFloat(oneItm.y) + tblHeight)+"mm", oneItm.x+"mm", oneItm.width+"mm", oneItm.height+"mm", "QRCode", oneItm.value);
			} else if (oneItm.barcodetype) {
				LODOP.ADD_PRINT_BARCODE((parseFloat(oneItm.y) + tblHeight)+"mm", oneItm.x+"mm", oneItm.width+"mm", oneItm.height+"mm", oneItm.barcodetype, oneItm.value);
				if (oneItm.angle != "") {
					LODOP.SET_PRINT_STYLEA(0, "Angle", oneItm.angle);
				}
				if (oneItm.isshowtext == "N") {
					LODOP.SET_PRINT_STYLEA(0, "ShowBarText", 0);
				}
			} else {
				LODOP.ADD_PRINT_TEXT((parseFloat(oneItm.y) + tblHeight)+"mm", oneItm.x+"mm", oneItm.width+"mm", oneItm.height+"mm", oneItm.value);
				LODOP.SET_PRINT_STYLEA(0, "FontSize", oneItm.fontsize);
				LODOP.SET_PRINT_STYLEA(0, "FontName", oneItm.fontname);
				if (oneItm.fontbold == "true") {
					LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
				}
				if (oneItm.angle != "") {
					LODOP.SET_PRINT_STYLEA(0, "Angle", oneItm.angle);
				}
			}
		}
		//5.打印表格(由TEXT组成)
		var fromTop = 0;
		var borderSpace2 = borderSpace * 2;
		var cols = colArr.length;
		if (isListObject) {
			for (var i=0; i<curPageRows; i++) {
				var oneRowData = listArr[i];
				//fromTop = xmlListStartY + (i * xmlListRowHeight);
				for (var j=0; j<cols; j++) {
					var oneCol = colArr[j];
					fromTop = oneCol.yrow + (i * xmlListRowHeight);
					if (i == 0) {
						if (j + 1 < cols) {
							oneCol.width = colArr[j+1].xcol - oneCol.xcol;
						} else if(listBorder && listBorder.endX) {
							oneCol.width = listBorder.endX - oneCol.xcol;
						} else {
							oneCol.width = invWidth - oneCol.xcol;
						}
					}
					var pval = ("undefined" != typeof oneRowData[oneCol.name]) ? oneRowData[oneCol.name] : (oneCol.defaultvalue || oneCol.printvalue); //todo... oneRowData[oneCol.name]==0
					LODOP.ADD_PRINT_TEXT(fromTop+"mm", (oneCol.xcol+borderSpace)+"mm", (oneCol.width-borderSpace2)+"mm", xmlListRowHeight+"mm", pval);
					LODOP.SET_PRINT_STYLEA(0, "FontSize", oneCol.fontsize);
					LODOP.SET_PRINT_STYLEA(0, "FontName", oneCol.fontname);
					LODOP.SET_PRINT_STYLEA(0, "TextNeatRow", true);
					if (listColAlign) {
						var alignNum = 1;
						if (listColAlign[oneCol.name] == 'center') {
							alignNum = 2;
						}
						if (listColAlign[oneCol.name] == 'right') {
							alignNum = 3;
						}
						LODOP.SET_PRINT_STYLEA(0, "Alignment", alignNum); //效率??? todo...
					}
					if (listAutoWrap == false) {
						LODOP.SET_PRINT_STYLEA(0, "LineSpacing", "10mm"); //不自动换行,间距拉大
					} else {
						LODOP.SET_PRINT_STYLEA(0, "LineSpacing", "-1.5mm");
					}
					if (oneCol.fontbold == "true") {
						LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
					}
				}
			}
		} else {
			for (var i=0; i<curPageRows; i++) {
				var oneRowData = listArr[i].split("^");
				//fromTop = xmlListStartY + (i * xmlListRowHeight);
				for (var j=0; j<cols; j++) {
					var oneCol = colArr[j];
					fromTop = oneCol.yrow + (i * xmlListRowHeight);
					var pval = "undefined" != typeof oneRowData[j] ? oneRowData[j] : "";
					LODOP.ADD_PRINT_TEXT(fromTop+"mm", (oneCol.xcol+borderSpace)+"mm", "800mm", "10mm", pval);
					LODOP.SET_PRINT_STYLEA(0, "FontSize", oneCol.fontsize);
					LODOP.SET_PRINT_STYLEA(0, "FontName", oneCol.fontname);
					LODOP.SET_PRINT_STYLEA(0, "TextNeatRow", true);
					if (listColAlign) {
						var alignNum = 1;
						if (listColAlign[oneCol.name] == 'center') {
							alignNum = 2;
						}
						if (listColAlign[oneCol.name] == 'right') {
							alignNum = 3;
						}
						LODOP.SET_PRINT_STYLEA(0, "Alignment", alignNum); //效率??? todo...
					}
					if (listAutoWrap == false) {
						LODOP.SET_PRINT_STYLEA(0, "LineSpacing", "10mm"); //不自动换行,间距拉大
					} else {
						LODOP.SET_PRINT_STYLEA(0, "LineSpacing", "-1.5mm");
					}
					if (oneCol.fontbold == "true") {
						LODOP.SET_PRINT_STYLEA(0, "Bold", 1);
					}
				}
			}
		}
	},
	/**
	* @creator: Huxiaotian 2019-12-11
	* @desc: 润乾打印公共
	*/
	RQ: function(_options){
		var mParams = _options.Params || {};
		var iframeID = _options.iframeID || "";
		if (iframeID != "") {
			var url = this.AppPath + 'csp/dhccpmrunqianreportprint.csp';
			url += "?reportName=" + _options.QRFileName;
			for (var mKey in mParams) {
				url += "&" + mKey + "=" + mParams[mKey]; //TODO; encodeURIComponent()
			}
			$("#" + iframeID).attr("src", url);
			return;
		}
		
		if (_options.preview) {
			//预览
			var url = this.AppPath + 'csp/dhccpmrunqianreportprint.csp';
			url += "?reportName=" + _options.QRFileName;
			for(var mKey in mParams){
				url += "&" + mKey + "=" + mParams[mKey]; //TODO; encodeURIComponent()
			}
			this.QRCount = this.QRCount + 1; //可以打开多个预览界面
			var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
			var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			var previewInfo = _options.preview;
			previewInfo.top = previewInfo.top || 0;
			previewInfo.left = previewInfo.left || 0;
			previewInfo.width = previewInfo.width || (w-30);
			previewInfo.height = previewInfo.height || (h-30);
			var openWinInfo = ""; //新打开的窗体信息
			openWinInfo += "top=" + previewInfo.top + ", ";
			openWinInfo += "left=" + previewInfo.left + ", ";
			openWinInfo += "width=" + previewInfo.width + ", ";
			openWinInfo += "height=" + previewInfo.height + ", ";
			openWinInfo += "toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no";
			window.open(url, '润乾预览界面' + this.QRCount, openWinInfo);
		} else {
			//直接打印
			var filename = "{" + _options.QRFileName + "(";
			var firstFlag = 1;
			for(var mKey in mParams){
				if(firstFlag == 1){
					filename += mKey + "=" + mParams[mKey];
					firstFlag = 0;
				} else {
					filename += ";" + mKey + "=" + mParams[mKey];
				}
			}
			filename += ")}";
			try{
				var printobj = window.document.Dtreport1_directPrintApplet;
				printobj.print(filename);
			}catch(e){
				alert("直接打印出错:\n(1)请检查本地JDK环境配置;\n(2)请在csp中引用Object标签.");
			}
		}
	},
	
	/**
	* --------------------------以下为工具方法---------------------------
	* @creator: Huxiaotian 2019-12-11
	* @desc: 设置打印页属性
	*/
	LODOP_CreateInv: function(LODOP, invXMLDoc){
		var invAttr = invXMLDoc.attributes;
		var invHeight = invAttr.getNamedItem("height").value;
		var invWidth = invAttr.getNamedItem("width").value;
		var invOrient = "X"; 
		if (invAttr.getNamedItem("LandscapeOrientation")){
			invOrient = invAttr.getNamedItem("LandscapeOrientation").value;
		}
		var invPrtPaperSet = invAttr.getNamedItem("PrtPaperSet").value; //WIN
		var invPrtDevice = invAttr.getNamedItem("PrtDevice").value; //xps
		var invPrtPage = invAttr.getNamedItem("PrtPage").value; //A5
		var intOrient = 1; //默认1=纵向
		if (invOrient=="Y") intOrient=2;
		else if(invOrient=="X") intOrient=1;
		else if(invOrient=="Z"){intOrient=3;/*按内容高度算*/}
		if (invPrtPaperSet=="HAND"){
			var lodopPageWidth = invWidth*10+"mm"
			var lodopPageHeight = invHeight*10+"mm";
			var lodopPageName = "";	
		}else{
			var lodopPageWidth = 0 //表示无效
			var lodopPageHeight = 0;
			var lodopPageName = invPrtPage;
		}
		LODOP.SET_PRINT_PAGESIZE(intOrient, lodopPageWidth, lodopPageHeight, lodopPageName);
		if (invPrtDevice!=""){
			invPrtDevice = invPrtDevice.toUpperCase();
			for(var i=0;i< LODOP.GET_PRINTER_COUNT(); i++){
				if (LODOP.GET_PRINTER_NAME(i).toUpperCase().indexOf(invPrtDevice)>-1){ 
					LODOP.SET_PRINTER_INDEX(i);
					break;
				}
			}
		}else{
			LODOP.SET_PRINTER_INDEX(-1); //set default printer
		}
	},
	/*
	* @creator: Huxiaotian 2019-12-11
	* @desc: doc解析为js对象
	*/
	FormatCols: function(xmlListData, isListObject){
		var minyrow = 0;
		var colArr = [];
		var colsNode = xmlListData.getElementsByTagName("Listdatapara");
		var cols = colsNode.length;
		for (var j=0; j<cols; j++){
			var colNode = colsNode[j];
			var name = colNode.getAttribute("name");
			var xcol = parseFloat(colNode.getAttribute("xcol"));
			var yrow = parseFloat(colNode.getAttribute("yrow"));
			var defaultvalue = colNode.getAttribute("defaultvalue");
			var printvalue = colNode.getAttribute("printvalue");
			var fontbold = colNode.getAttribute("fontbold");
			var fontname = colNode.getAttribute("fontname");
			var fontsize = colNode.getAttribute("fontsize");
			var oneCol = {name:name, xcol:xcol, yrow:yrow, defaultvalue:defaultvalue, printvalue:printvalue, fontbold:fontbold, fontname:fontname, fontsize:fontsize};
			colArr.push(oneCol);
			if (yrow < minyrow || minyrow == 0) {
				minyrow = yrow;
			}
		}
		if (!isListObject) {
			return {colArr: colArr, minyrow: minyrow};
		}
		//排序
		var s = colArr.length, t;
		var tempExchangVal;
		while (s > 0) {
			for (t = 0; t < s - 1; t++) {
				if (colArr[t].xcol > colArr[t + 1].xcol) {
					tempExchangVal = colArr[t];
					colArr[t] = colArr[t + 1];
					colArr[t + 1] = tempExchangVal;
				}
			}
			s--;
		}
		return {colArr: colArr, minyrow: minyrow};
	},
	/*
	* @creator: Huxiaotian 2019-12-10
	* @desc: xml字符串转换成xmldoc对象
	*/
	CreateXMLDOM: function (xmlString){
	    var xmlDoc = null;
	    if (this.IsIECore){
			var xmlDoc = this.DOMDocumentObject;
			var rtn = xmlDoc.loadXML(xmlString);
	    } else if (window.DOMParser && document.implementation && document.implementation.createDocument){
			try{
			    domParser = new  DOMParser();
			    xmlDoc = domParser.parseFromString(xmlString, 'text/xml'); //"text/xml" or "application/xml" or "application/xhtml+xml"
			}catch(e){}
	    } else {
			return null;
	    }
	    return xmlDoc;
	},
	/*
	* @creator: Huxiaotian 2019-12-23
	* @desc: xmldoc对象转换成xml字符串
	*/
	XML2String: function(xmlObject) {
		if (this.IsIECore) {
			return xmlObject.xml;
		} else {
			return (new XMLSerializer()).serializeToString(xmlObject);
		}
	},
	/*
	* @creator: Huxiaotian 2019-12-10
	* @desc: dom子元素按标签名称删除
	* @param: xmlNode, xml节点,例如: <TxtData></TxtData>
	* @param: removeTag, 标签名称, 例如: txtdatapara
	* @param: exceptFields, 删除txtdatapara标签时需要保留的元素name属性值, 例如: patNo,即当name="patNo"时保留该标签
	*/
	removeChildNodes: function(xmlNode, removeTag, exceptFields){
		var exceptFields = exceptFields || [];
		var chlNodes = xmlNode.getElementsByTagName(removeTag);
		var chls = chlNodes.length;
		var attrName;
		if (this.IsIECore) {
			for (var i=0; i<chls; i++) {
				attrName = chlNodes[i].getAttribute('name');
				if (exceptFields.indexOf(attrName) >= 0) {
					continue;
				}
				xmlNode.removeChild(chlNodes[i]);
			}
		} else {
			for (var i = chls - 1; i >= 0; i--) {
				attrName = chlNodes[i].getAttribute('name');
				if (exceptFields.indexOf(attrName) >= 0) {
					continue;
				}
				xmlNode.removeChild(chlNodes[i]);
			}
		}
	},
	/*
	* @creator: Huxiaotian 2019-12-10
	* @desc: dom子元素按标签名称删除指定name属性的text
	* @param: xmlNode, xml节点,例如: <TxtData></TxtData>
	* @param: removeTag, 标签名称, 例如: txtdatapara
	* @param: nameFields, 删除txtdatapara标签时,只删除name属性在nameFields中的标签
	*/
	removeChildNodesByName: function(xmlNode, removeTag, nameFields){
		var nameFields = nameFields || [];
		if (nameFields.length == 0) {
			return;
		}
		var chlNodes = xmlNode.getElementsByTagName(removeTag);
		var chls = chlNodes.length;
		var attrName;
		if (this.IsIECore) {
			for (var i = 0; i < chls; i++) {
				attrName = chlNodes[i].getAttribute('name');
				if (nameFields.indexOf(attrName) >= 0) {
					xmlNode.removeChild(chlNodes[i]);
				}
			}
		} else {
			for (var i = chls - 1; i >= 0; i--) {
				attrName = chlNodes[i].getAttribute('name');
				if (nameFields.indexOf(attrName) >= 0) {
					xmlNode.removeChild(chlNodes[i]);
				}
			}
		}
	},
	/*
	* @desc: 加载xml模板并缓存
	*/
	loadXMLTemplate: function(templateName){
		//存在模板则不再加载
		if(this.XMLTemplate[templateName]){
			return;
		}
		//xml模板加载到数组
		try {
			this.PrtAryData.length = 0;
			var PrtConfig = tkMakeServerCall("web.DHCXMLIO", "ReadXML", "PRINTCOM_SetXml", templateName);
			for (var i=0; i < this.PrtAryData.length; i++) {
				this.PrtAryData[i] = this.TextEncoder(this.PrtAryData[i]);
			}
		} catch(e) {
			alert(e.message);
			return;
		}
		//读取数组组织字符串
		var mystr = "";
		for (var i=0; i < this.PrtAryData.length; i++) {
			mystr += this.PrtAryData[i];
		}
		this.XMLTemplate[templateName] = mystr;
		return;
	},
	
	/*
	* @desc: 特殊字符处理相关
	*/
	TextEncoder: function(transtr){
		if (transtr.length == 0){
			return "";
		}
		var dst = transtr;
		try {
			dst = this.replaceAll(dst, '\\"', '\"');
			dst = this.replaceAll(dst, "\\r\\n", "\r\t");
			dst = this.replaceAll(dst, "\\r", "\r");
			dst = this.replaceAll(dst, "\\n", "\n");
			dst = this.replaceAll(dst, "\\t", "\t");
		} catch(e) {
			alert(e.message);
			return "";
		}
		return dst;
	},
	replaceAll: function (src,fnd,rep) {
		if (src.length==0){ 
			return ""; 
		}
		try{
			var myary = src.split(fnd);
			var dst = myary.join(rep);
		}catch(e){
			alert(e.message);
			return ""
		}
		return dst; 
	},
	/*
	* @creator: Huxiaotian 2019-12-10
	* @desc: 获取数据类型
	*/
	dataType: function(val){
		return Object.prototype.toString.call(val);
	},
	/*
	* @creator: Huxiaotian 2018-11-02
	* @desc: 数组按一定的长度拆分成二维数组
	*/
	splitArray: function(arr, len){
		if(arr.length==0 || len==0){
			return [arr];
		}else if(arr.length==len){
			return [arr];
		}else{
			var maxIndex = Math.ceil(arr.length/len) - 1;
		}
		var retArr = [];
		for(var i=0; i<=maxIndex; i++){
			var stIndex = i*len;
			if(i<maxIndex){
				var endIndex = stIndex + (len-1);
			}else{
				var endIndex = arr.length - 1;
			}
			var curLen = endIndex - stIndex;
			var tmpArr = [];
			for(var j=0; j<=curLen; j++){
				tmpArr[j] = arr[stIndex+j];
			}
			retArr[i] = tmpArr;
		}
		return retArr;
	},
	/**
	* @desc: base64字符串写入c盘成为XXX.gif文件, 文件位置: "C:/XXX.gif"
	* @params: userInfo - 根据this.ImgGetFrom.MethodName的入参,可以是UserID或者UserCode
	* @others: IE浏览器下支持该方法,且要先注册DLL: Base64IMGSave.ClsSaveBase64IMG
	*/
	GetGifInfo: function (userInfo){
		if (userInfo == "") {
			return -1;
		}
		var ImgBase64 = tkMakeServerCall(this.ImgGetFrom.ClassName, this.ImgGetFrom.MethodName, userInfo);
		var myobj = this.ClsSaveBase64IMG;
		if (myobj && ImgBase64!="") {
			var sReigstNo = userInfo;
			var sFiletype = this.ImgSuffix;
			var rtn = myobj.WriteFile(sReigstNo, ImgBase64, sFiletype);
			if (!rtn) {
				console.log("at PRINTCOM.GetGifInfo(), base64签名图片转换错误");
				return -1;
			}
			return 0;
		} else {
			console.log("at PRINTCOM.GetGifInfo(), ClsSaveBase64IMG对象未定义");
			return -1;
		}
		return -1;
	},
	/*
	* @creator: Huxiaotian 2019-12-24
	* @desc: 根据grid获取List列表数据(grid可以是easyui grid/ hisui grid/ jgGrid/ extjs grid)
	* @others: 考虑到部分页面打印时获取的数据应当与页面保持一致
	*/
	getListData: function(_mGridOpt){
		var mGridurl = "";
		var mGridQueryParams = {};
		var type = _mGridOpt.type || "";
		if (type.toUpperCase() == "EXTJS") {
			//todo...
		} else if (type.toUpperCase() == "JQGRID") {
			mGridUrl = $('#' + _mGridOpt.grid).jqGrid('getGridParam','url');
			mGridQueryParams = $('#' + _mGridOpt.grid).jqGrid('getGridParam','postData');
		} else {
			var _mGridOptions = $("#" + _mGridOpt.grid).datagrid("options");
			mGridUrl = _mGridOptions.url;
			mGridQueryParams = _mGridOptions.queryParams;
		}
		mGridQueryParams["page"] = 1;
		mGridQueryParams["rows"] = 9999;
		var retList = [];
		$.ajax({
			url: mGridUrl,
			type: "post",
			async: false,
			dataType: "json",
			data: mGridQueryParams, //{k:v, k:v, ...}
			success: function(jsonData){
				retList = jsonData.rows;
				if (jsonData.footer) {
					var footerLen = jsonData.footer.length;
					for (var i=0; i<footerLen; i++) {
						retList.push(jsonData.footer[i]);
					}
				}
			},
			error: function(XMLHR){
				errorFn(XMLHR);
			}
	    });
	    return retList;
	},
	/*
	* @creator: Huxt 2019-12-28
	* @desc: 获取分组符号(lines) -- 目前只针对单页的处方！！！
	* @param: mOeoriStr 	- 每条医嘱的主医嘱ID拼成的字符串
	* @param: vRows 		- 没条医嘱所占用的行数
	* @param: vRowHeight 	- 每行的行高
	* @param: vFromTop 		- 分组符号开始位置
	* @param: vFromLeft 	- 分组符号到左边的距离
	* @param: vWidth 		- 分组符号宽度
	* @param: vIndent 		- 分组符的间距
	* @param: vOrient 		- 分组符的方向(left or right)
	*/
	groupLines: function(mOeoriStr, vRows, vRowHeight, vFromTop, vFromLeft, vWidth, vIndent, vOrient) {
	    /*
	    var vRows = 1;
	    var vRowHeight = 10;
	    var vFromTop = 80;
	    var vFromLeft = 0;
	    var vWidth = 5;
		var vIndent = 2;
		var vOrient = 'left';
		var mOeoriStr = "1,2,1,2,2,3,4,5";
		*/
	    var rLines = [];
	    var mGroups = this.getGroups(mOeoriStr);
	    var curGap = 0;
	    for (var r = 0; r < mGroups.length; r++) {
	        var oneGrp = mGroups[r];
	        var gap = oneGrp.end - oneGrp.start + 1;
	        
	        if (gap >= vRows * 2) {
	            var gropHeight = gap * vRowHeight;
	            var fromTop = vFromTop + (curGap * vRowHeight) + vIndent;
	            var fromLeft = vFromLeft;
	            if (vOrient == 'right'){
		            fromLeft = vFromLeft + vWidth;
		        }
	            //横线+竖线+横线
	            rLines.push({
	                type: 'line',
	                sx: vFromLeft,
	                sy: fromTop,
	                ex: vFromLeft + vWidth,
	                ey: fromTop
	            });
	            rLines.push({
	                type: 'line',
	                sx: fromLeft,
	                sy: fromTop,
	                ex: fromLeft,
	                ey: fromTop + gropHeight - vIndent
	            });
	            rLines.push({
	                type: 'line',
	                sx: vFromLeft,
	                sy: fromTop + gropHeight - vIndent,
	                ex: vFromLeft + vWidth,
	                ey: fromTop + gropHeight - vIndent
	            });
	        }
	        curGap = curGap + gap;
	    }
	    return rLines;
	},
	/*
	* @creator: Huxt 2019-12-28
	* @desc: 计算分组线条
	* @param: mOeoriStr - 每条医嘱的主医嘱ID拼成的字符串
	*/
	getGroups: function(mOeoriStr) {
	    var groupNew = [];
	    var mOeoriArr = mOeoriStr.split(",");
	    var mOeoriLen = mOeoriArr.length;
	    for (var i = 0; i < mOeoriLen; i++) {
	        if (i == 0) {
	            groupNew.push({
	                start: 1,
	                end: 1
	            });
	        } else {
	            var lastEnd = groupNew[groupNew.length - 1].end;
	            if (mOeoriArr[i - 1] == mOeoriArr[i]) {
	                groupNew[groupNew.length - 1].end = lastEnd + 1;
	            } else {
	                groupNew.push({
	                    start: lastEnd + 1,
	                    end: lastEnd + 1
	                });
	            }
	        }
	    }
	    return groupNew;
	},
	/*
	* @creator: Huxiaotian 2019-01-09
	* @desc: inv模式下获取反斜杠信息
	*/
	getBackSlashInfo: function(templateName, xmlTxtData, xmlListData) {
		if ("undefined" != typeof this.BackSlash[templateName]) {
			return this.BackSlash[templateName];
		}
		var backSlash = null;
		var backSlashWidth = parseFloat(xmlListData.getAttribute("BackSlashWidth"));
		if (backSlashWidth == 0) {
			this.BackSlash[templateName] = backSlash;
			return this.BackSlash[templateName];
		}
		var xmlTxtDataRePrtHeadFlag = xmlTxtData.getAttribute("RePrtHeadFlag");
		var txtDataParas = xmlTxtData.getElementsByTagName("txtdatapara");
		for (var j=0; j<txtDataParas.length; j++) {
			var itm = txtDataParas[j];
			var pname = itm.getAttribute("name");
			var pleft = itm.getAttribute("xcol");
			var ptop = itm.getAttribute("yrow");
			if (pname == "startPoint" && backSlashWidth != 0) {
				backSlash = {};
				backSlash.startX = parseFloat(pleft);
				backSlash.startY = ptop;
				backSlash.endX = parseFloat(pleft) + backSlashWidth;
				break;
			}
		}
		this.BackSlash[templateName] = backSlash;
		return this.BackSlash[templateName];
	},
	
	/*
	* @creator: Huxiaotian 2018-11-02
	* @desc: 自定义ajax (非hisui环境下的兼容)
	*/
	jsRunServer: function(_options, successFn, errorFn){
		$.ajax({
			url: "websys.Broker.cls",
			type: "post",
			async: true,
			dataType: "json",
			data: _options,
			success: function(jsonData){
				successFn(jsonData);
			},
			error: function(XMLHR){
				errorFn(XMLHR);
			}
	    });
	}
}
function PRINTCOM_SetXml(ConStr){
	PRINTCOM.PrtAryData[PRINTCOM.PrtAryData.length] = ConStr;
}
