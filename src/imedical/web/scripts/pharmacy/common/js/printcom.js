/**
 * @creator: Huxiaotian 2019-11-20
 * @desc:    ҩ��ҩ���ӡ����������װ(xml & ��Ǭ)  ==> ҩ����Ʒ��ͳһ���� - ��
 * @js:      scripts/pharmacy/common/js/printcom.js
 * @others:  dependent on jQuery and websys.Broker.cls
 */
var PRINTCOM = {
	/*
	 * @desc: ������������
	 */
	XMLTemplate: {},
	PrtAryData: new Array(),
	ImgUserInfo: new Array(), // todo...
	ImgSuffix: 'jpg',
	QRCount: 0,
	BackSlash: {},
	ImgGetFrom: {
		ClassName: 'PHA.COM.Print',
		MethodName: 'GetBase64Str'
	},
	ClsSaveBase64IMG: (function () {
		try {
			return new ActiveXObject('Base64IMGSave.ClsSaveBase64IMG');
		} catch (err) {
			return null;
		}
	})(),
	DOMDocumentObject: (function () {
		var retobj = null;
		try {
			retobj = new ActiveXObject('MSXML2.DOMDocument.4.0');
			retobj.async = false;
			return retobj;
		} catch (err) {
			return null;
		}
		return retobj;
	})(),
	IsIECore: (function () {
		if (!!window.ActiveXObject || 'ActiveXObject' in window) {
			return true;
		} else {
			return false;
		}
	})(),
	AppPath: (function () {
		var cspUrl = window.location.href;
		var cspUrlArr = cspUrl.split('/');
		return '/' + cspUrlArr[3] + '/' + cspUrlArr[4] + '/';  // '/imedical/web/' or '/dthealth/web/'
	})(),
	/*
	 * @desc: xmlģ���ӡ�������
	 */
	XML: function (_options) {
		_options.printBy = _options.printBy || '';
		// local data
		if (_options.data) {
			var retJson = _options.data;
			if (retJson.Grid) {
				retJson.List = this.getListData(retJson.Grid);
			}
			if (_options.printBy.toUpperCase() == 'INV') {
				PRINTCOM.PrintByVB(retJson, _options);
			} else {
				var LODOP = getLodop();
				if (!LODOP) {
					return;
				}
				if (_options.oneTask == true) {
					PRINTCOM.PrintByLodopTask(retJson, _options, LODOP);
				} else {
					PRINTCOM.PrintByLodop(retJson, _options, LODOP, true, true);
				}
			}
			return;
		}
		// $.cm(
		this.jsRunServer(
			_options.dataOptions,
			function (retJson) {
			if (retJson.msg) {
				alert(retJson.msg);
				return;
			}
			_options.printBy = _options.printBy || '';
			if (_options.printBy.toUpperCase() == 'INV') {
				PRINTCOM.PrintByVB(retJson, _options);
			} else {
				var LODOP = getLodop();
				if (!LODOP) {
					return;
				}
				if (_options.oneTask == true) {
					PRINTCOM.PrintByLodopTask(retJson, _options, LODOP);
				} else {
					PRINTCOM.PrintByLodop(retJson, _options, LODOP, true, true);
				}
			}
		}, function (error) {
			alert(error.responseText);
		});
	},
	/*
	 * @desc: ʹ��VB��ӡ�ؼ�
	 * json:  {Para:{}, List:[str1,str2,...]}
	 */
	PrintByVB: function (retJson, _options) {
		// VBԤ����ӡ
		if (_options.preview) {
			this.PrintByVBPreview(retJson, _options);
			return;
		}
		// VBֱ�Ӵ�ӡ
		var imageCAFields = _options.imageCAFields || [];
		var aptListFields = _options.aptListFields || [];
		var templateName = _options.XMLTemplate;
		var myPara = '';
		var myList = '';
		var paraObj = retJson.Para || {};
		var listArr = retJson.List || [];
		for (var mKey in paraObj) {
			if (imageCAFields.indexOf(mKey) >= 0) {
				var userInfo = paraObj[mKey];
				var retCode = this.GetGifInfo(userInfo);
				if (retCode == 0) {
					paraObj[mKey] = 'C:/' + userInfo + '.' + this.ImgSuffix;
				} else {
					paraObj[mKey] = '';
				}
			}
			if (myPara == '') {
				myPara = mKey + String.fromCharCode(2) + paraObj[mKey];
			} else {
				myPara += '^' + mKey + String.fromCharCode(2) + paraObj[mKey];
			}
		}
		// ��չ������
		_options.extendFn = _options.extendFn || function () {
			return {}
		}
		var extObj = _options.extendFn(retJson);
		var pageNoExt = 0;
		var pageNoExtIndex = 0;
		if (_options.page) {
			// ��Ҫ��ҳ(js��ָ����ҳ)
			var pageNoStr = '';
			var pageInfo = _options.page;
			var pageRows = pageInfo.rows;
			var listPageArr = this.splitArray(listArr, pageRows);
			var listPages = listPageArr.length; // ��ҳ��
			for (var p = 0; p < listPages; p++) {
				var onePageData = listPageArr[p]; // [rowstr, rowstr]
				var onePageRows = onePageData.length;
				myList = '';
				for (var c = 0; c < onePageRows; c++) {
					if (myList == '') {
						myList = onePageData[c];
					} else {
						myList += String.fromCharCode(2) + onePageData[c];
					}
				}
				// ҳ��
				pageNoStr = pageInfo.format || '';
				pageNoStr = pageNoStr.replace('{1}', p + 1);
				pageNoStr = pageNoStr.replace('{2}', listPages);
				if (pageNoStr != '') {
					if (pageNoExt == 0) {
						extObj.elements = extObj.elements || [];
						extObj.elements.push({
							type: 'text',
							name: 'pageNums',
							x: pageInfo.x || 10,
							y: pageInfo.y || 10,
							value: pageNoStr,
							fontbold: pageInfo.fontbold || 'false',
							fontname: pageInfo.fontname || '����',
							fontsize: pageInfo.fontsize || 12
						})
						pageNoExt = 1;
						pageNoExtIndex = extObj.elements.length - 1;
					} else {
						extObj.elements[pageNoExtIndex].value = pageNoStr; // �ڶ�ҳ��ʼ�ı�ҳ��ֵ����
					}
				}
				extObj.pageRows = onePageRows;
				extObj.jsPageRows = pageRows;
				extObj.aptListFields = aptListFields;
				extObj.listBorder = _options.listBorder;
				extObj.endPageFields = _options.endPageFields;
				extObj.backSlash = _options.backSlash;
				extObj.invCurrentRow = _options.invCurrentRow;
				extObj.pageNo = p + 1;
				extObj.listPages = listPages;
				this.PrintByVBDirect(myPara, myList, templateName, extObj);
			}
		} else {
			// ����Ҫ��ҳ(vb��ӡ�ؼ���������Զ���ҳ����,����û����ʾҳ��)
			var allRows = listArr.length;
			for (var c = 0; c < allRows; c++) {
				if (myList == '') {
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
			extObj.invCurrentRow = _options.invCurrentRow;
			extObj.pageNo = 1;
			extObj.listPages = 1;
			this.PrintByVBDirect(myPara, myList, templateName, extObj);
		}
	},
	PrintByVBPreview: function (retJson, _options) {
		var pWidth = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		var pHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var previewInfo = _options.preview;
		if (previewInfo == true) {
			previewInfo = {};
		}
		previewInfo.backgroundColor = previewInfo.backgroundColor || 'white';
		previewInfo.showButtons = previewInfo.showButtons || false;
		previewInfo.x = previewInfo.x || 0;
		previewInfo.y = previewInfo.y || 0;
		previewInfo.width = previewInfo.width || (pWidth - 30);
		previewInfo.height = previewInfo.height || (pHeight - 30);
		// Ĭ��ֵ
		_options.imageCAFields = _options.imageCAFields || [];
		_options.aptListFields = _options.aptListFields || [];
		_options.extendFn = _options.extendFn || function () {
			return {}
		}
		_options.extObj = _options.extendFn(retJson);
		var pid = tkMakeServerCall('PHA.COM.Print', 'SetPreviewParams', JSON.stringify(_options));
		var pUrl = this.AppPath + 'csp/pha.com.xmlprintpreview.csp?pid=' + pid;
		if ('undefined' !== typeof websys_getMWToken){
			pUrl += "&MWToken=" + websys_getMWToken();
		}
		if (!this.OptionsByPid) {
			this.OptionsByPid = {};
		}
		this.OptionsByPid[pid] = _options;
		// csp��iframeǶ��Ԥ��
		var iframeID = _options.iframeID || '';
		if (iframeID != '') {
			$('#' + iframeID).attr('src', pUrl);
			return;
		}
		// ����Ԥ��
		var openWinInfo = '';
		openWinInfo += 'left=' + previewInfo.x + ', ';
		openWinInfo += 'top=' + previewInfo.y + ', ';
		openWinInfo += 'width=' + previewInfo.width + ', ';
		openWinInfo += 'height=' + previewInfo.height + ', ';
		openWinInfo += 'toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no';
		window.open(pUrl, 'XMLԤ������' + Math.random().toString().replace('.',''), openWinInfo);
	},
	PrintByVBDirect: function (pStr, lStr, template, extObj) {
		// ����ԭʼXMLģ��
		this.loadXMLTemplate(template);
		var tempXmlStr = this.XMLTemplate[template];
		var docobj = this.CreateXMLDOM(tempXmlStr, true);
		if (docobj == null) {
			return;
		}
		var invXMLDoc = docobj.getElementsByTagName('invoice')[0];
		var xmlPLDatas = invXMLDoc.getElementsByTagName('PLData');
		var xmlPLData = xmlPLDatas[0];
		var xmlTxtDatas = invXMLDoc.getElementsByTagName('TxtData');
		var xmlTxtData = xmlTxtDatas[0];
		var xmlPICDatas = invXMLDoc.getElementsByTagName('PICData');
		var xmlPICData = xmlPICDatas[0];
		var xmlListData = invXMLDoc.getElementsByTagName('ListData')[0]; // ��һ��
		// �˴����Ż� todo...
		var endPageFields = extObj.endPageFields || [];
		var exceptFields = extObj.pageNo == extObj.listPages ? endPageFields : []; // ���һҳ����
		var removeFields = extObj.pageNo != extObj.listPages ? endPageFields : []; // ��Ҫɾ����
		if (extObj.pageNo > 1) {
			for (var x = 0; x < xmlPLDatas.length; x++) {
				if (xmlPLDatas[x].getAttribute('RePrtHeadFlag') != 'Y') {
					this.removeChildNodes(xmlPLDatas[x], 'PLine');
				}
			}
			for (var x = 0; x < xmlTxtDatas.length; x++) {
				if (xmlTxtDatas[x].getAttribute('RePrtHeadFlag') != 'Y') {
					this.removeChildNodes(xmlTxtDatas[x], 'txtdatapara', exceptFields);
				} else {
					this.removeChildNodesByName(xmlTxtDatas[x], 'txtdatapara', removeFields);
				}
			}
			for (var x = 0; x < xmlPICDatas.length; x++) {
				if (xmlPICDatas[x].getAttribute('RePrtHeadFlag') != 'Y') {
					this.removeChildNodes(xmlPICDatas[x], 'PICdatapara', exceptFields);
				} else {
					this.removeChildNodesByName(xmlPICDatas[x], 'PICdatapara', removeFields);
				}
			}
		} else {
			if (extObj.listPages > 1) {
				for (var x = 0; x < xmlTxtDatas.length; x++) {
					this.removeChildNodesByName(xmlTxtDatas[x], 'txtdatapara', endPageFields);
				}
				for (var x = 0; x < xmlTxtDatas.length; x++) {
					this.removeChildNodesByName(xmlTxtDatas[x], 'PICdatapara', endPageFields);
				}
			}
		}
		// ��չXMLģ��: 1.��ӡ��; 2.Ԫ��; 3.���߿�; 4.����ӦlabelԪ��
		var prtDevice = extObj.PrtDevice || '';
		var extElements = extObj.elements || [];
		var pageRows = extObj.pageRows || 0;
		var aptListFields = extObj.aptListFields;
		var listBorder = extObj.listBorder;
		var backSlash = null;
		for (var x = 0; x < xmlTxtDatas.length; x++) {
			var xmlBackSlash = this.getBackSlashInfo(template, xmlTxtDatas[x], xmlListData);
			if (xmlBackSlash != null) {
				backSlash = xmlBackSlash;
				backSlash.fromList = extObj.backSlash ? extObj.backSlash.fromList : 0;
				break;
			}
		}
		if (backSlash == null) {
			backSlash = extObj.backSlash;
		}
		// 1.��ӡ��
		if (prtDevice != '') {
			invXMLDoc.setAttribute('PrtDevice', prtDevice);
		}
		// 2.Ԫ��
		for (var i = 0; i < extElements.length; i++) {
			var oneElement = extElements[i];
			if (oneElement.type == 'line') {
				var iPLine = docobj.createElement('PLine');
				iPLine.setAttribute('BeginX', oneElement.sx);
				iPLine.setAttribute('BeginY', oneElement.sy);
				iPLine.setAttribute('EndX', oneElement.ex);
				iPLine.setAttribute('EndY', oneElement.ey);
				iPLine.setAttribute('fontcolor', oneElement.fontcolor || '');
				xmlPLData.appendChild(iPLine);
			}
			if (oneElement.type == 'text') {
				var iText = docobj.createElement('txtdatapara');
				iText.setAttribute('name', oneElement.name);
				iText.setAttribute('xcol', oneElement.x);
				iText.setAttribute('yrow', oneElement.y);
				iText.setAttribute('defaultvalue', oneElement.value);
				iText.setAttribute('printvalue', oneElement.value);
				iText.setAttribute('fontbold', oneElement.fontbold);
				iText.setAttribute('fontname', oneElement.fontname);
				iText.setAttribute('fontsize', oneElement.fontsize);
				iText.setAttribute('fontcolor', oneElement.fontcolor || '');
				if (oneElement.isqrcode == 'true') {
					iText.setAttribute('isqrcode', oneElement.isqrcode);
					iText.setAttribute('width', oneElement.width);
					iText.setAttribute('height', oneElement.height);
				}
				if (typeof oneElement.barcodetype == 'string' && oneElement.barcodetype != '') {
					iText.setAttribute('barcodetype', oneElement.barcodetype);
					iText.setAttribute('width', oneElement.width);
					iText.setAttribute('height', oneElement.height);
				}
				if (oneElement.angle > 0) {
					iText.setAttribute('angle', oneElement.angle);
				}
				xmlTxtData.appendChild(iText);
			}
			if (oneElement.type == 'pic') {
				var iPIC = docobj.createElement('PICdatapara');
				iPIC.setAttribute('name', oneElement.name);
				iPIC.setAttribute('xcol', oneElement.x);
				iPIC.setAttribute('yrow', oneElement.y);
				iPIC.setAttribute('defaultvalue', oneElement.value);
				iPIC.setAttribute('printvalue', oneElement.value);
				iPIC.setAttribute('width', oneElement.width);
				iPIC.setAttribute('height', oneElement.height);
				xmlPICData.appendChild(iPIC);
			}
		}
		// 3.���߿�
		var xmlListStartY = 0;
		var xmlListRowHeight = 0;
		var xmlPageRows = 0;
		if (xmlListData) {
			xmlListRowHeight = parseFloat(xmlListData.getAttribute('YStep'));
			xmlPageRows = parseFloat(xmlListData.getAttribute('PageRows'));
			var firstListItm = xmlListData.getElementsByTagName('Listdatapara')[0];
			if (firstListItm) {
				xmlListStartY = parseFloat(firstListItm.getAttribute('yrow')) - 1;
			}
			var invCurrentRow = extObj.invCurrentRow > 0 ? extObj.invCurrentRow : '0';
			xmlListData.setAttribute('CurrentRow', invCurrentRow); // ��ҩ��ûɶ��,ǿ������Ϊ0. todo...
		}
		if (extObj.jsPageRows) {
			xmlPageRows = extObj.jsPageRows; // ��js��ָ����ÿҳ����Ϊ׼
		}
		if (pageRows > xmlPageRows) {
			pageRows = xmlPageRows;
		}
		var tblHeight = xmlListRowHeight * pageRows;
		// list�߿�
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
			// ÿҳ��line��һ��
			var tblLineArr = [];
			if (styleArr.indexOf(1) >= 0) {
				tblLineArr.push({
					type: 'line',
					sx: lbStartX,
					sy: xmlListStartY,
					ex: lbEndX,
					ey: xmlListStartY
				});
			}
			var xmlListStartYNew = xmlListStartY;
			if (styleArr.indexOf(2) >= 0) {
				var lineY = 0;
				for (var i = 0; i < pageRows; i++) {
					lineY = (xmlListRowHeight * (i + 1)) + xmlListStartY;
					tblLineArr.push({
						type: 'line',
						sx: lbStartX,
						sy: lineY,
						ex: lbEndX,
						ey: lineY
					});
				}
				if (headBorder) {
					var xmlListStartYNew = xmlListStartY - xmlListRowHeight;
					tblLineArr.push({
						type: 'line',
						sx: lbStartX,
						sy: xmlListStartYNew,
						ex: lbEndX,
						ey: xmlListStartYNew
					});
				}
			}
			if (styleArr.indexOf(3) >= 0) {
				var colsNode = xmlListData.getElementsByTagName('Listdatapara');
				var cols = colsNode.length;
				for (var j = 1; j < cols; j++) {
					var colNode = colsNode[j];
					var colStartX = colNode.getAttribute('xcol');
					tblLineArr.push({
						type: 'line',
						sx: colStartX,
						sy: xmlListStartYNew,
						ex: colStartX,
						ey: xmlListStartY + tblHeight
					});
				}
			}
			if (styleArr.indexOf(4) >= 0) {
				tblLineArr.push({
					type: 'line',
					sx: lbStartX,
					sy: xmlListStartYNew,
					ex: lbStartX,
					ey: xmlListStartY + tblHeight
				});
				tblLineArr.push({
					type: 'line',
					sx: lbEndX,
					sy: xmlListStartYNew,
					ex: lbEndX,
					ey: xmlListStartY + tblHeight
				});
			}
			// ��չ������ģ��
			var mTblLines = tblLineArr.length;
			for (var k = 0; k < mTblLines; k++) {
				var oneLineInfo = tblLineArr[k];
				var iPLine = docobj.createElement('PLine');
				iPLine.setAttribute('BeginX', oneLineInfo.sx);
				iPLine.setAttribute('BeginY', oneLineInfo.sy);
				iPLine.setAttribute('EndX', oneLineInfo.ex);
				iPLine.setAttribute('EndY', oneLineInfo.ey);
				xmlPLData.appendChild(iPLine);
			}
		}
		// ��б��
		if (backSlash) {
			xmlListData.setAttribute('BackSlashWidth', '0');
			if (xmlPageRows > pageRows) {
				var fromList = backSlash.fromList || 0;
				var backSlashEndY = xmlListStartY + (xmlListRowHeight * pageRows) + fromList;
				var iPLine = docobj.createElement('PLine');
				iPLine.setAttribute('BeginX', backSlash.startX);
				iPLine.setAttribute('BeginY', backSlash.startY);
				iPLine.setAttribute('EndX', backSlash.endX);
				iPLine.setAttribute('EndY', backSlashEndY);
				xmlPLData.appendChild(iPLine);
			}
		}
		// 4.����ӦlabelԪ��
		if (aptListFields.length > 0) {
			tblHeight = xmlListRowHeight * (pageRows - 1);
			if (xmlTxtDatas && xmlTxtDatas.length > 0) {
				for (var x = 0; x < xmlTxtDatas.length; x++) {
					var txtDataParas = xmlTxtDatas[x].getElementsByTagName('txtdatapara');
					for (var j = 0; j < txtDataParas.length; j++) {
						var itm = txtDataParas[j];
						var name = itm.getAttribute('name');
						if (aptListFields.indexOf(name) < 0) {
							continue;
						}
						var ptop = itm.getAttribute('yrow');
						itm.setAttribute('yrow', (parseFloat(ptop) + tblHeight));
					}
				}
			}
			if (xmlPICDatas && xmlPICDatas.length > 0) {
				for (var x = 0; x < xmlPICDatas.length; x++) {
					var picDataParas = xmlPICDatas[x].getElementsByTagName('PICdatapara');
					for (var j = 0; j < picDataParas.length; j++) {
						var itm = picDataParas[j];
						var name = itm.getAttribute('name');
						if (aptListFields.indexOf(name) < 0) {
							continue;
						}
						var ptop = itm.getAttribute('yrow');
						itm.setAttribute('yrow', (parseFloat(ptop) + tblHeight));
					}
				}
			}
		}
		// 5.����VB��ӡ�ؼ�
		try {
			if (this.IsIECore) {
				var PObj = new ActiveXObject('DHCOPPrint.ClsBillPrint');
				var rtn = PObj.ToPrintHDLP(pStr, lStr, docobj); // ToPrintDoc(pStr, pStr, docobj);
			} else {
				var prtXmlStr = this.XML2String(docobj);
				var rtn = DHCOPPrint.ToPrintHDLPStr(pStr, lStr, prtXmlStr); // for Chrome
			}
		} catch (e) {
			alert('err:' + e.message + 'at PRINTCOM.printByVB()');
			return;
		}
	},

	/*
	 * @desc: ʹ��LODOP��ӡ�ؼ� -- ʵ�ֶ�ҳ����ʹ�õ�һ�����ӡ
	 * json: [{Para:{}, List:[str1,str2,...]}, {Para:{}, List:[str1,str2,...]}, ...]
	 * json: [{Para:{}, List:[{},{},...]}, {Para:{}, List:[{},{},...]}, ...]
	 */
	PrintByLodopTask: function (retJson, _options, LODOP) {
		var tLen = retJson.length;
		var isFirst = false;
		var isEnd = false;
		for (var t = 0; t < tLen; t++) {
			if (tLen == 1) {
				this.PrintByLodop(retJson[t], _options, LODOP, true, true);
				return;
			}
			if (t == 0) {
				isFirst = true;
			} else if (t == tLen - 1) {
				isFirst = t > 0 ? false : isFirst;
				isEnd = true;
			} else {
				isFirst = false;
				isEnd = false;
			}
			this.PrintByLodop(retJson[t], _options, LODOP, isFirst, isEnd);
		}
	},
	/*
	 * @desc: ʹ��LODOP��ӡ�ؼ�
	 * json:  {Para:{}, List:[str1,str2,...]}
	 * json:  {Para:{}, List:[{},{},...]}
	 */
	PrintByLodop: function (retJson, _options, LODOP, isFirst, isEnd) {
		if (_options.callBase) {
			this.Call_DHC_PrintByLodop(retJson, _options, LODOP);
			return;
		}
		var paraObj = retJson.Para || {};
		var listArr = retJson.List || [];
		var isObjData = (listArr.length > 0 && this.dataType(listArr[0]) == '[object Object]') ? true : false;
		var imageCAFields = _options.imageCAFields || [];
		var aptListFields = _options.aptListFields || [];
		var templateName = _options.XMLTemplate;
		var endPageFields = _options.endPageFields || [];
		// ����ԭʼXMLģ��
		this.loadXMLTemplate(templateName);
		var tempXmlStr = this.XMLTemplate[templateName];
		var xmlTemp = this.parseXmlTemp(tempXmlStr);
		var colArr = isObjData ? this.sortCols(xmlTemp.ListData.cols) : xmlTemp.ListData.cols;
		var invHeight = xmlTemp.invoice.attr.heightMM;
		var invWidth =  xmlTemp.invoice.attr.widthMM;
		_options.invHeight = invHeight;
		_options.invWidth = invWidth;
		_options.isObjData = isObjData;
		// ��չ��: ��ӡ��
		_options.extendFn = _options.extendFn || function () {
			return {}
		}
		var extObj = _options.extendFn(retJson);
		var prtDevice = extObj.PrtDevice || '';
		if (prtDevice != '') {
			xmlTemp.invoice.PrtDevice = prtDevice;
		}
		// ��ʼ��LODOP
		if (isFirst == true) {
			LODOP.PRINT_INIT('LODOP_' + templateName);
			this.LODOP_CreateInv(LODOP, xmlTemp.invoice.attr, _options);
			_options.isNeedSelPrt = xmlTemp.invoice.attr.isNeedSelPrt;
		}
		// ��չ��: ҳ��Ԫ��
		var aptListFieldsInfo = [];
		var extElements = extObj.elements || [];
		for (var i = 0; i < extElements.length; i++) {
			var oneItm = extElements[i];
			// ��չ����
			if (oneItm.type == 'line') {
				oneItm.rePrint = 'Y';
				oneItm.BeginY = oneItm.sy;
				oneItm.BeginX = oneItm.sx;
				oneItm.EndY = oneItm.ey;
				oneItm.EndX = oneItm.ex;
				this.print_Line(LODOP, oneItm);
				continue;
			}
			// ��չͼƬ
			if (oneItm.type == 'pic') {
				var isNeedBase64 = imageCAFields.indexOf(oneItm.name) >= 0 ? true : false;
				oneItm.rePrint = 'Y';
				oneItm.value = this.getImgVal(oneItm.value, isNeedBase64);
				oneItm.yrow = oneItm.y;
				oneItm.xcol = oneItm.x;
				if (aptListFields.indexOf(oneItm.name) >= 0) {
					oneItm.yrowFixed = oneItm.yrow;
					aptListFieldsInfo.push(oneItm);
					continue;
				}
				this.print_Img(LODOP, oneItm);
				continue;
			}
			// ��չ�ı� (�ı�&��ά��&������)
			if (oneItm.type == 'text') {
				oneItm.rePrint = 'Y';
				oneItm.width = oneItm.width || (invWidth - 20);
				oneItm.height = oneItm.height || 20;
				oneItm.yrow = oneItm.y;
				oneItm.xcol = oneItm.x;
				if (aptListFields.indexOf(oneItm.name) >= 0) {
					oneItm.yrowFixed = oneItm.yrow;
					aptListFieldsInfo.push(oneItm);
					continue;
				}
				this.print_Txt(LODOP, oneItm);
			}
		}
		// XML - Line (����)
		var lines = xmlTemp.PLData.lines;
		for (var i = 0; i < lines.length; i++) {
			var iLine = lines[i];
			this.print_Line(LODOP, iLine);
		}
		// XML - Img (ͼƬ)
		var imgs = xmlTemp.PICData.imgs;
		for (var i = 0; i < imgs.length; i++) {
			var iImg = imgs[i];
			var isNeedBase64 = imageCAFields.indexOf(iImg.name) >= 0 ? true : false;
			iImg.value = this.getPrintVal(paraObj[iImg.name], iImg);
			iImg.value = this.getImgVal(iImg.value, isNeedBase64);
			iImg.onlyEndPage = endPageFields.indexOf(iImg.name) >= 0 ? true : false;
			iImg.rePrint = iImg.onlyEndPage == true || iImg.rePrintFixed == 'Y' ? 'Y' : 'N';
			iImg.type = 'img';
			if (aptListFields.indexOf(iImg.name) >= 0) {
				iImg.yrowFixed = iImg.yrow;
				aptListFieldsInfo.push(iImg);
				continue;
			}
			this.print_Img(LODOP, iImg);
		}
		// XML - Text (�ı�&��ά��&������)
		var txts = xmlTemp.TxtData.txts;
		for (var i = 0; i < txts.length; i++) {
			var iTxt = txts[i];
			iTxt.value = this.getPrintVal(paraObj[iTxt.name], iTxt);
			iTxt.onlyEndPage = endPageFields.indexOf(iTxt.name) >= 0 ? true : false;
			iTxt.rePrint = iTxt.onlyEndPage == true || iTxt.rePrintFixed == 'Y' ? 'Y' : 'N';
			iTxt.type = 'txt';
			if (aptListFields.indexOf(iTxt.name) >= 0) {
				iTxt.yrowFixed = iTxt.yrow;
				aptListFieldsInfo.push(iTxt);
				continue;
			}
			this.print_Txt(LODOP, iTxt);
		}
		if (!_options.backSlash) {
			_options.backSlash = xmlTemp.TxtData.backSlash;
		}
		// XML - List (�б�)
		var listOpts = xmlTemp.ListData;
		if (listOpts.attr) {
			var xmlListPageRows = listOpts.attr.PageRows;
			var xmlListRowHeight = listOpts.attr.YStep;
			var pageNoInfo = null;
			if (_options.page) {
				var pageInfo = _options.page;
				pageNoInfo = {
					xcol: pageInfo.x || pageInfo.xcol || 10,
					yrow: pageInfo.y || pageInfo.xcol || 10,
					value: '',
					fontbold: pageInfo.fontbold || 'false',
					fontname: pageInfo.fontname || '����',
					fontsize: pageInfo.fontsize || 12,
					showSingleNo: (pageInfo.showSingleNo == false ? false : true)
				}
				xmlListPageRows = pageInfo.rows > 0 ? pageInfo.rows : xmlListPageRows;
				listOpts.attr.PageRows = xmlListPageRows; // jsָ������������
			}
			var listNeedHeight = listOpts.minyrow + (xmlListPageRows * xmlListRowHeight);
			if (listNeedHeight > invHeight) {
				console.log('list��Ҫ�����߶ȴ���page�ĸ߶ȣ����ܵ��´�ӡ���ݲ���ȫ������');
			}
			var pageDataArr = this.splitArray(listArr, xmlListPageRows);
			var pageDataLen = pageDataArr.length;
			for (var p = 0; p < pageDataLen; p++) {
				var pageData = pageDataArr[p];
				if (pageNoInfo != null) {
					var pageNoStr = pageInfo.format || '';
					pageNoStr = pageNoStr.replace('{1}', p + 1);
					pageNoStr = pageNoStr.replace('{2}', pageDataLen);
					pageNoInfo.value = pageNoStr;
				}
				listOpts.pageNoInfo = pageNoInfo;
				listOpts.pageTotal = pageDataLen;
				listOpts.pageNo = p + 1;
				listOpts.aptListFieldsInfo = aptListFieldsInfo;
				listOpts.pageData = pageData;
				if (p > 0) {
					LODOP.NEWPAGE();
				}
				this.PrintByLodopOnePage(LODOP, listOpts, _options);
			}
		}
		// ��ʼ��ӡ
		if (isEnd == true) {
			// print
			if (_options.copies > 0) {
				LODOP.SET_PRINT_COPIES(_options.copies);
			}
			if (_options.saveFileName) {
				LODOP.SET_SAVE_MODE('FILE_PROMPT', _options.saveFilePrompt);
				LODOP.SAVE_TO_FILE(_options.saveFileName);
			} else if (_options.preview) {
				LODOP.PREVIEW();
			} else {
				if (_options.isNeedSelPrt) {
					LODOP.PRINTA();
				} else {
					LODOP.PRINT();
				}
			}
		} else {
			// new page
			LODOP.NEWPAGE();
		}
	},
	PrintByLodopOnePage: function (LODOP, listOpts, _options) {
		var pageNoInfo = listOpts.pageNoInfo;
		var pageTotal = listOpts.pageTotal;
		var pageNo = listOpts.pageNo;
		var aptListFieldsInfo = listOpts.aptListFieldsInfo;
		var pageData = listOpts.pageData;
		var curPageRows = pageData.length;
		var xmlListStartY = listOpts.minyrow;
		var xmlListRowHeight = listOpts.attr.YStep;
		var xmlListPageRows = listOpts.attr.PageRows;
		var colArr = listOpts.cols;
		var borderSpace = 0.5;
		var listBorder = _options.listBorder;
		var backSlash = _options.backSlash;
		var invWidth = _options.invWidth;
		// 1.���߿�
		var tblHeight = xmlListRowHeight * curPageRows;
		if (listBorder) {
			borderSpace = listBorder.space || 0.5;
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
			// ÿҳ��line��һ��
			if (styleArr.indexOf(1) >= 0) {
				this.print_Line(LODOP, {
					BeginY: xmlListStartY,
					BeginX: lbStartX,
					EndY: xmlListStartY,
					EndX: lbEndX
				});
			}
			var xmlListStartYNew = xmlListStartY;
			if (styleArr.indexOf(2) >= 0) {
				var lineY = 0;
				for (var i = 0; i < curPageRows; i++) {
					lineY = (xmlListRowHeight * (i + 1)) + xmlListStartY;
					this.print_Line(LODOP, {
						BeginY: lineY,
						BeginX: lbStartX,
						EndY: lineY,
						EndX: lbEndX
					});
				}
				if (headBorder) {
					var xmlListStartYNew = xmlListStartY - xmlListRowHeight;
					this.print_Line(LODOP, {
						BeginY: xmlListStartYNew,
						BeginX: lbStartX,
						EndY: xmlListStartYNew,
						EndX: lbEndX
					});
				}
			}
			if (styleArr.indexOf(3) >= 0) {
				var cols = colArr.length;
				for (var j = 1; j < cols; j++) {
					var oneCol = colArr[j];
					var colStartX = oneCol.xcolFixed;
					this.print_Line(LODOP, {
						BeginY: xmlListStartYNew,
						BeginX: colStartX,
						EndY: xmlListStartY + tblHeight,
						EndX: colStartX
					});
				}
			}
			if (styleArr.indexOf(4) >= 0) {
				var xArr = [lbStartX, lbEndX];
				for (var xa = 0; xa < xArr.length; xa++) {
					var ix = xArr[xa];
					this.print_Line(LODOP, {
						BeginY: xmlListStartYNew,
						BeginX: ix,
						EndY: xmlListStartY + tblHeight,
						EndX: ix
					});
				}
			}
		}
		// 2.��б��
		if (backSlash && curPageRows < xmlListPageRows) {
			var fromList = backSlash.fromList || 0;
			var backSlashEndY = xmlListStartY + (xmlListRowHeight * curPageRows) + fromList;
			this.print_Line(LODOP, {
				BeginY: backSlash.startY,
				BeginX: backSlash.startX,
				EndY: backSlashEndY,
				EndX: backSlash.endX
			});
		}
		// 3.ҳ��
		if (pageNoInfo) {
			if (pageNoInfo.showSingleNo == true || pageTotal > 1) {
				pageNoInfo.width = 100;
				pageNoInfo.height = 20;
				this.print_Txt(LODOP, pageNoInfo);
			}
		}
		// 4.����ӦlabelԪ��
		for (var i = 0; i < aptListFieldsInfo.length; i++) {
			tblHeight = xmlListRowHeight * (curPageRows - 1);
			var oneItm = aptListFieldsInfo[i];
			if (pageNo > 1 && oneItm.rePrint != 'Y') {
				continue; // ���˽��ڵ�һҳ��ӡ��Ԫ��
			}
			if (pageNo != pageTotal && oneItm.onlyEndPage == true) {
				continue; // ���˽������һҳ��ӡ��Ԫ��
			}
			oneItm.yrow = oneItm.yrowFixed + tblHeight;
			var rePrint = oneItm.rePrint;
			oneItm.rePrint = 'N';
			if (oneItm.type == 'img') {
				this.print_Img(LODOP, oneItm);
			} else {
				this.print_Txt(LODOP, oneItm);
			}
			oneItm.rePrint = rePrint;
		}
		// 5.��ӡ���
		this.print_List(LODOP, listOpts, _options);
	},
	// ��ӡ����
	print_Line: function(LODOP, lineOpts) {
		LODOP.ADD_PRINT_LINE(lineOpts.BeginY + 'mm', lineOpts.BeginX + 'mm', lineOpts.EndY + 'mm', lineOpts.EndX + 'mm', 0, 1);
		if (lineOpts.rePrint == 'Y') {
			LODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
		}
		if (lineOpts.fontcolor && lineOpts.fontcolor != '') {
			LODOP.SET_PRINT_STYLEA(0, 'FontColor', lineOpts.fontcolor);
		}
	},
	// ��ӡͼƬ
	print_Img: function(LODOP, imgOpts) {
		LODOP.ADD_PRINT_IMAGE(imgOpts.yrow + 'mm', imgOpts.xcol + 'mm', imgOpts.width + 'mm', imgOpts.height + 'mm', imgOpts.value);
		LODOP.SET_PRINT_STYLEA(0, 'Stretch', 1);
		if (imgOpts.rePrint == 'Y') {
			LODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
			if (imgOpts.onlyEndPage == true) {
				LODOP.SET_PRINT_STYLEA(0, 'PageIndex', 'Last');
			}
		}
	},
	// ��ӡ�ı� (�ı�&��ά��&����)
	print_Txt: function(LODOP, txtOpts) {
		if (txtOpts.isqrcode == 'true') {
			// ��ά��
			if (typeof txtOpts.value == 'undefined' || txtOpts.value == null || txtOpts.value == '') {
				return; // TODO...
			}
			LODOP.ADD_PRINT_BARCODE(txtOpts.yrow + 'mm', txtOpts.xcol + 'mm', txtOpts.width + 'mm', txtOpts.height + 'mm', 'QRCode', txtOpts.value);
			if (txtOpts.rePrint == 'Y') {
				LODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
				if (txtOpts.onlyEndPage == true) {
					LODOP.SET_PRINT_STYLEA(0, 'PageIndex', 'Last');
				}
			}
			if((',1,2,3,5,7,10,14,').indexOf(',' + txtOpts.qrcodeversion + ',') > -1) {
				LODOP.SET_PRINT_STYLEA(0, "QRCodeVersion", txtOpts.qrcodeversion);		
			}
		} else if (('undefined' != typeof txtOpts.barcodetype) && (txtOpts.barcodetype != null)) {
			// ����
			if (typeof txtOpts.value == 'undefined' || txtOpts.value == null || txtOpts.value == '') {
				return; // TODO...
			}
			LODOP.ADD_PRINT_BARCODE(txtOpts.yrow + 'mm', txtOpts.xcol + 'mm', txtOpts.width + 'mm', txtOpts.height + 'mm', txtOpts.barcodetype, txtOpts.value);
			if (txtOpts.rePrint == 'Y') {
				LODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
				if (txtOpts.onlyEndPage == true) {
					LODOP.SET_PRINT_STYLEA(0, 'PageIndex', 'Last');
				}
			}
			if (txtOpts.angle && txtOpts.angle != '') {
				LODOP.SET_PRINT_STYLEA(0, 'Angle', txtOpts.angle);
			}
			if (txtOpts.isshowtext == 'N') {
				LODOP.SET_PRINT_STYLEA(0, 'ShowBarText', 0);
			}
		} else {
			// �ı�
			LODOP.ADD_PRINT_TEXT(txtOpts.yrow + 'mm', txtOpts.xcol + 'mm', txtOpts.width + 'mm', txtOpts.height + 'mm', txtOpts.value);
			LODOP.SET_PRINT_STYLEA(0, 'FontSize', txtOpts.fontsize);
			LODOP.SET_PRINT_STYLEA(0, 'FontName', txtOpts.fontname);
			if (txtOpts.fontbold == 'true') {
				LODOP.SET_PRINT_STYLEA(0, 'Bold', 1);
			}
			if (txtOpts.fontcolor && txtOpts.fontcolor != '') {
				LODOP.SET_PRINT_STYLEA(0, 'FontColor', txtOpts.fontcolor);
			}
			if (txtOpts.angle && txtOpts.angle != '') {
				LODOP.SET_PRINT_STYLEA(0, 'Angle', txtOpts.angle);
			}
			if (txtOpts.rePrint == 'Y') {
				LODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
				if (txtOpts.onlyEndPage == true) {
					LODOP.SET_PRINT_STYLEA(0, 'PageIndex', 'Last');
				}
			}
		}
	},
	// ��ӡ�б�
	print_List: function(LODOP, listOpts, _options) {
		if (_options.isObjData) {
			this.print_List_ByObj(LODOP, listOpts, _options);
		} else {
			this.print_List_ByStr(LODOP, listOpts, _options);
		}
	},
	// ��ӡ�б� - ����Ϊ����(һҳ)
	print_List_ByObj: function(LODOP, listOpts, _options){
		var listAttr = listOpts.attr;
		var listCols = listOpts.cols;
		var lCols = listCols.length;
		var pageData = listOpts.pageData;
		var lRows = pageData.length;
		var rowHeight = listAttr.YStep;
		var invWidth = _options.invWidth;
		var listBorder = _options.listBorder;
		var listItems = _options.listItems || {};
		var borderSpace1 = this.getNumber(listBorder ? listBorder.space : 0.5, 0.5);
		var borderSpace2 = borderSpace1 * 2;
		for (var i = 0; i < lRows; i++) {
			var oneRowData = pageData[i];
			for (var j = 0; j < lCols; j++) {
				var oneCol = listCols[j];
				oneCol.xcol = oneCol.xcolFixed + borderSpace1;
				oneCol.yrow = oneCol.yrowFixed + (i * rowHeight);
				oneCol.value = this.getPrintVal(oneRowData[oneCol.name], oneCol);
				// ��� (�������һ��)
				if (i == 0) {
					this.listItemProp(oneCol, listItems[oneCol.name]);
					var def_width = 10;
					if (j + 1 < lCols) {
						def_width = listCols[j + 1].xcol - oneCol.xcol;
					} else if (listBorder && listBorder.endX) {
						def_width = listBorder.endX - oneCol.xcol;
					} else {
						def_width = invWidth - oneCol.xcol;
					}
					if (_options.autoColWidth) {
						oneCol.width = def_width;
					} else {
						oneCol.width = oneCol.width > 0 ? oneCol.width : (def_width > 0 ? def_width : invWidth);
					}
					var def_height = rowHeight - 1;
					oneCol.fHeight = oneCol.height > 0 ? oneCol.height : def_height;
					oneCol.iHeight = parseInt(oneCol.fHeight);
					oneCol.rHeight = rowHeight;
				}
				oneCol.height = oneCol.fHeight;
				if (oneCol.coltype == 'img') {
					this.print_Img(LODOP, oneCol);
				} else {
					this.move_Txt(oneCol, _options);
					oneCol.height = oneCol.iHeight;
					this.print_Txt(LODOP, oneCol);
				}
				this.print_List_Format(LODOP, _options, oneCol.name);
			}
		}
		return;
	},
	// ��ӡ�б� - ����Ϊ�ַ���(һҳ)
	print_List_ByStr: function(LODOP, listOpts, _options){
		var listAttr = listOpts.attr;
		var listCols = listOpts.cols;
		var lCols = listCols.length;
		var pageData = listOpts.pageData;
		var lRows = pageData.length;
		var rowHeight = listAttr.YStep;
		var invWidth = _options.invWidth;
		var listBorder = _options.listBorder;
		var listItems = _options.listItems || {};
		var borderSpace1 = this.getNumber(listBorder ? listBorder.space : 0.5, 0.5);
		var borderSpace2 = borderSpace1 * 2;
		for (var i = 0; i < lRows; i++) {
			var oneRowData = pageData[i].split('^');
			for (var j = 0; j < lCols; j++) {
				var oneCol = listCols[j];
				oneCol.xcol = oneCol.xcolFixed + borderSpace1;
				oneCol.yrow = oneCol.yrowFixed + (i * rowHeight);
				oneCol.value = this.getPrintVal(oneRowData[j], oneCol);
				// ��� (�������һ��)
				if (i == 0) {
					this.listItemProp(oneCol, listItems[j]);
					var def_width = 10;
					if (j + 1 < lCols) {
						def_width = listCols[j + 1].xcol - oneCol.xcol;
					} else if (listBorder && listBorder.endX) {
						def_width = listBorder.endX - oneCol.xcol;
					} else {
						def_width = invWidth - oneCol.xcol;
					}
					if (_options.autoColWidth) {
						oneCol.width = def_width;
					} else {
						oneCol.width = oneCol.width > 0 ? oneCol.width : (def_width > 0 ? def_width : invWidth);
					}
					var def_height = rowHeight - 1;
					oneCol.fHeight = oneCol.height > 0 ? oneCol.height : def_height;
					oneCol.iHeight = parseInt(oneCol.fHeight);
				}
				oneCol.height = oneCol.fHeight;
				if (oneCol.coltype == 'img' || oneCol.coltype == 'pic') {
					this.print_Img(LODOP, oneCol);
				} else {
					this.move_Txt(oneCol, _options);
					oneCol.height = oneCol.iHeight;
					this.print_Txt(LODOP, oneCol);
				}
				this.print_List_Format(LODOP, _options, oneCol.name);
			}
		}
		return;
	},
	// �б��ʽ��
	print_List_Format: function(LODOP, _options, itemName){
		LODOP.SET_PRINT_STYLEA(0, 'TextNeatRow', true);
		if (_options.listColAlign) {
			var alignTxt = _options.listColAlign[itemName];
			var alignNum = 1;
			if (alignTxt == 'center') {
				alignNum = 2;
			} else if (alignTxt == 'right') {
				alignNum = 3;
			}
			LODOP.SET_PRINT_STYLEA(0, 'Alignment', alignNum);
		}
		if (_options.listAutoWrap == false) {
			LODOP.SET_PRINT_STYLEA(0, 'LineSpacing', '10mm'); // ���Զ�����,�������
		} else {
			LODOP.SET_PRINT_STYLEA(0, 'LineSpacing', '-1.5mm');
		}
	},
	
	/**
	 * @creator: Huxiaotian 2019-12-11
	 * @desc: 	 ��Ǭ��ӡ����
	 * @params:  _options.QRFileName: 'xxx.raq' ���� 'xxx.rpx'
	 *           _options.Params: {p1:v1, p2:v2}
	 *           _options.preview: {top:0, left:0, width:800, height:400}
	 *           _options.iframeID: csp�����iframe
	 * 			 isNewRQ : �Ƿ���������°���Ǭ, Ĭ���ϰ汾
	 * @others:  ���isNewRQΪtrue, ����Ҫ��csp������DHCCPMRQCommon.js
	 */
	RQ: function (_options, isNewRQ) {
		var mParams = _options.Params || {};
		var iframeID = _options.iframeID || '';
		// Ƕ��ҳ���
		if (iframeID != '') {
			var url = this.AppPath + 'csp/dhccpmrunqianreportprint.csp';
			url += '?reportName=' + _options.QRFileName;
			for (var mKey in mParams) {
				url += '&' + mKey + '=' + mParams[mKey]; // todo... ; encodeURIComponent()
			}
			$('#' + iframeID).attr('src', url);
			return;
		}
		// 8.4�°���Ǭ������ (����: DHCCPMRQCommon.js)
		if (isNewRQ) {
			try {
				if (_options.preview) {
					var previewInfo = _options.preview;
					if (previewInfo == true) {
						previewInfo = {};
					}
					var width = previewInfo.width || (w - 30);
					var height = previewInfo.height || (h - 30);
					var paramStr = _options.QRFileName;
					for (var mKey in mParams) {
						paramStr += '&' + mKey + '=' + mParams[mKey]; // todo... ; encodeURIComponent()
					}
					DHCCPM_RQPrint(paramStr, width, height);
				} else {
					var paramStr = '{' + _options.QRFileName + '(';
					var firstFlag = 1;
					for (var mKey in mParams) {
						paramStr += firstFlag == 1 ? (mKey + '=' + mParams[mKey]) : (';' + mKey + '=' + mParams[mKey]);
						firstFlag = 0;
					}
					paramStr += ')}';
					DHCCPM_RQDirectPrint(paramStr);
				}
			} catch(e){
				alert(e.message);
			}
			return;
		}
		// 8.4�°���Ǭ����ǰ
		if (_options.preview) {
			// Ԥ��
			var url = this.AppPath + 'csp/dhccpmrunqianreportprint.csp';
			url += '?reportName=' + _options.QRFileName;
			for (var mKey in mParams) {
				url += '&' + mKey + '=' + mParams[mKey]; // todo... ; encodeURIComponent()
			}
			this.QRCount = this.QRCount + 1; // ���Դ򿪶��Ԥ������
			var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
			var h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			var previewInfo = _options.preview;
			if (previewInfo == true) {
				previewInfo = {};
			}
			previewInfo.top = previewInfo.top || 0;
			previewInfo.left = previewInfo.left || 0;
			previewInfo.width = previewInfo.width || (w - 30);
			previewInfo.height = previewInfo.height || (h - 30);
			var openWinInfo = ''; // �´򿪵Ĵ�����Ϣ
			openWinInfo += 'top=' + previewInfo.top + ', ';
			openWinInfo += 'left=' + previewInfo.left + ', ';
			openWinInfo += 'width=' + previewInfo.width + ', ';
			openWinInfo += 'height=' + previewInfo.height + ', ';
			openWinInfo += 'toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no';
			window.open(url, '��ǬԤ������' + this.QRCount, openWinInfo);
		} else {
			// ֱ�Ӵ�ӡ
			var filename = '{' + _options.QRFileName + '(';
			var firstFlag = 1;
			for (var mKey in mParams) {
				if (firstFlag == 1) {
					filename += mKey + '=' + mParams[mKey];
					firstFlag = 0;
				} else {
					filename += ';' + mKey + '=' + mParams[mKey];
				}
			}
			filename += ')}';
			try {
				var printobj = window.document.Dtreport1_directPrintApplet;
				printobj.print(filename);
			} catch (e) {
				alert('ֱ�Ӵ�ӡ����:\n(1)���鱾��JDK��������;\n(2)����csp������Object��ǩ.');
			}
		}
	},
	
	/**
	 * --------------------------����Ϊ���߷���---------------------------
	 * @creator: Huxiaotian 2019-12-11
	 * @desc:    ���ô�ӡҳ����
	 */
	LODOP_CreateInv: function (LODOP, invoiceAttr, _options) {
		var invWidth = invoiceAttr.widthMM;
		var invHeight = invoiceAttr.heightMM;
		var invOrientCode = invoiceAttr.LandscapeOrientation;
		var intOrient = 1; // Ĭ������
		if (invOrientCode == 'X'){
			intOrient = 1; // ����
		} else if (invOrientCode == 'Y'){
			intOrient = 2; // ����
		} else if (invOrientCode == 'Z') {
			intOrient = 3; // ���� + ����ͣ
		}
		var invPrtPaperSet = invoiceAttr.PrtPaperSet; // HEAD-��ģ�� or WIN-����ӡ��ֽ��
		var invPrtDevice = invoiceAttr.PrtDevice; // ��ӡ��
		var invPrtPage = invoiceAttr.PrtPage; // ֽ����,��:A4/A5��
		var invPaperDesc = invoiceAttr.PaperDesc // ֽ������ - ����
		var invNotFindPrtDevice = invoiceAttr.NotFindPrtDevice;
		var invPageFooter = invoiceAttr.PageFooter; // ҳ��
		
		if (invPrtPaperSet == 'HAND') {
			var lodopPageWidth = invWidth + 'mm';
			var lodopPageHeight = invHeight + 'mm';
			var lodopPageName = '';
		} else if(_options && _options.saveFileName) {
			// ����ͼƬ���п�Ⱥ͸߶�
			var lodopPageWidth = invWidth + 'mm';
			var lodopPageHeight = (parseFloat(invHeight) + 2) + 'mm';
			var lodopPageName = '';
		} else {
			var lodopPageWidth = 0;
			var lodopPageHeight = 0;
			var lodopPageName = invPrtPage;
		}
		if (invPageFooter && invPageFooter != '') {
			LODOP.ADD_PRINT_TEXT('92mm', '8mm', '40mm', '10mm', invPageFooter);
			LODOP.SET_PRINT_STYLEA(0, 'ItemType', 2);
			LODOP.SET_PRINT_STYLEA(0, 'Horient', 2);
			LODOP.SET_PRINT_STYLEA(0, 'Vorient', 1);
		}
		
		LODOP.SET_PRINT_PAGESIZE(intOrient, lodopPageWidth, lodopPageHeight, lodopPageName);
		if (invPrtDevice != '') {
			var isFindPrinter = false;
			// ��׼ƥ��
			for (var i = 0; i < LODOP.GET_PRINTER_COUNT(); i++) {
				if (LODOP.GET_PRINTER_NAME(i) == invPrtDevice) {
					LODOP.SET_PRINTER_INDEX(i);
					isFindPrinter = true;
					break;
				}
			}
			// ģ��ƥ��
			invPrtDevice = invPrtDevice.toUpperCase();
			for (var i = 0; i < LODOP.GET_PRINTER_COUNT(); i++) {
				if (isFindPrinter) {
					break;
				}
				if (LODOP.GET_PRINTER_NAME(i).toUpperCase().indexOf(invPrtDevice) > -1) {
					LODOP.SET_PRINTER_INDEX(i);
					isFindPrinter = true;
					break;
				}
			}
			if (isFindPrinter == false && invNotFindPrtDevice == 'SELF') {
				invoiceAttr.isNeedSelPrt = true; // ��ӡʱ�û��Լ�ѡ��
			}
		} else {
			LODOP.SET_PRINTER_INDEX(-1); // set default printer
		}
	},
	/*
	 * @creator: Huxiaotian 2019-12-10
	 * @desc:    xml�ַ���ת����xmldoc����
	 */
	CreateXMLDOM: function (xmlString, isNeedIE) {
		if (!xmlString || xmlString == '') {
			alert('PRINTCOM.CreateXMLDOM(): xmlģ������Ϊ�գ�');
			return null;
		}
		var xmlDoc = null;
		try {
			if (isNeedIE) {
				var xmlDoc = this.DOMDocumentObject;
				if (xmlDoc == null) {
					alert('PRINTCOM.CreateXMLDOM(): IE������밲װ: msxmlchs.msi');
					return null;
				}
				var rtn = xmlDoc.loadXML(xmlString);
				return xmlDoc;
			}
			if (window.DOMParser && document.implementation && document.implementation.createDocument) {
				domParser = new DOMParser();
				xmlDoc = domParser.parseFromString(xmlString, 'text/xml');
			} else if (this.IsIECore) {
				var xmlDoc = this.DOMDocumentObject;
				if (xmlDoc == null) {
					alert('PRINTCOM.CreateXMLDOM(): IE������밲װ: msxmlchs.msi');
					return null;
				}
				var rtn = xmlDoc.loadXML(xmlString);
			} else {
				alert('PRINTCOM.CreateXMLDOM(): �����������֧��xml������');
				return null;
			}
		} catch (e) {
			alert('PRINTCOM.CreateXMLDOM(): ' + e.message);
			return null;
		}
		return xmlDoc;
	},
	/*
	 * @creator: Huxiaotian 2019-12-23
	 * @desc:    xmldoc����ת����xml�ַ���
	 */
	XML2String: function (xmlObject) {
		if (this.IsIECore) {
			return xmlObject.xml;
		} else {
			return (new XMLSerializer()).serializeToString(xmlObject);
		}
	},
	/*
	 * @creator: Huxiaotian 2019-12-10
	 * @desc:    dom��Ԫ�ذ���ǩ����ɾ��
	 * @param:   xmlNode, xml�ڵ�,����: <TxtData></TxtData>
	 * @param:   removeTag, ��ǩ����, ����: txtdatapara
	 * @param:   exceptFields, ɾ��txtdatapara��ǩʱ��Ҫ������Ԫ��name����ֵ, ����: patNo,����name='patNo'ʱ�����ñ�ǩ
	 */
	removeChildNodes: function (xmlNode, removeTag, exceptFields) {
		var exceptFields = exceptFields || [];
		var chlNodes = xmlNode.getElementsByTagName(removeTag);
		var chls = chlNodes.length;
		var attrName;
		if (this.IsIECore) {
			for (var i = 0; i < chls; i++) {
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
	 * @desc:    dom��Ԫ�ذ���ǩ����ɾ��ָ��name���Ե�text
	 * @param:   xmlNode, xml�ڵ�,����: <TxtData></TxtData>
	 * @param:   removeTag, ��ǩ����, ����: txtdatapara
	 * @param:   nameFields, ɾ��txtdatapara��ǩʱ,ֻɾ��name������nameFields�еı�ǩ
	 */
	removeChildNodesByName: function (xmlNode, removeTag, nameFields) {
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
	 * @desc: ����xmlģ�岢����
	 */
	loadXMLTemplate: function (templateName) {
		// ����ģ�����ټ���
		if (this.XMLTemplate[templateName]) {
			return;
		}
		// xmlģ����ص�����
		try {
			this.PrtAryData.length = 0;
			var PrtConfig = tkMakeServerCall('web.DHCXMLIO', 'ReadXML', 'PRINTCOM_SetXml', templateName);
			try {
				eval(PrtConfig); // �����token�������. TODO...
			} catch(e){}
			for (var i = 0; i < this.PrtAryData.length; i++) {
				this.PrtAryData[i] = this.TextEncoder(this.PrtAryData[i]);
			}
		} catch (e) {
			alert(e.message);
			return;
		}
		// ��ȡ������֯�ַ���
		var mystr = '';
		for (var i = 0; i < this.PrtAryData.length; i++) {
			mystr += this.PrtAryData[i];
		}
		this.XMLTemplate[templateName] = mystr;
		return;
	},

	/*
	 * @desc: �����ַ��������
	 */
	TextEncoder: function (transtr) {
		if (transtr.length == 0) {
			return '';
		}
		var dst = transtr;
		try {
			dst = this.replaceAll(dst, '\\"', '\"');
			dst = this.replaceAll(dst, '\\r\\n', '\r\t');
			dst = this.replaceAll(dst, '\\r', '\r');
			dst = this.replaceAll(dst, '\\n', '\n');
			dst = this.replaceAll(dst, '\\t', '\t');
		} catch (e) {
			alert(e.message);
			return '';
		}
		return dst;
	},
	replaceAll: function (src, fnd, rep) {
		if (src.length == 0) {
			return '';
		}
		try {
			var myary = src.split(fnd);
			var dst = myary.join(rep);
		} catch (e) {
			alert(e.message);
			return ''
		}
		return dst;
	},
	/*
	 * @creator: Huxiaotian 2019-12-10
	 * @desc:    ��ȡ��������
	 */
	dataType: function (val) {
		return Object.prototype.toString.call(val);
	},
	/*
	 * @creator: Huxiaotian 2018-11-02
	 * @desc:    ���鰴һ���ĳ��Ȳ�ֳɶ�ά����
	 */
	splitArray: function (arr, len) {
		if (arr.length == 0 || len == 0) {
			return [arr];
		} else if (arr.length == len) {
			return [arr];
		} else {
			var maxIndex = Math.ceil(arr.length / len) - 1;
		}
		var retArr = [];
		for (var i = 0; i <= maxIndex; i++) {
			var stIndex = i * len;
			if (i < maxIndex) {
				var endIndex = stIndex + (len - 1);
			} else {
				var endIndex = arr.length - 1;
			}
			var curLen = endIndex - stIndex;
			var tmpArr = [];
			for (var j = 0; j <= curLen; j++) {
				tmpArr[j] = arr[stIndex + j];
			}
			retArr[i] = tmpArr;
		}
		return retArr;
	},
	/**
	 * @desc:   base64�ַ���д��c�̳�ΪXXX.gif�ļ�, �ļ�λ��: 'C:/XXX.gif'
	 * @params: userInfo - ����this.ImgGetFrom.MethodName�����,������UserID����UserCode
	 * @others: IE�������֧�ָ÷���,��Ҫ��ע��DLL: Base64IMGSave.ClsSaveBase64IMG
	 */
	GetGifInfo: function (userInfo) {
		if (userInfo == '') {
			return -1;
		}
		var ImgBase64 = this.getBase64Str(userInfo);
		var myobj = this.ClsSaveBase64IMG;
		if (myobj && ImgBase64 != '') {
			var sReigstNo = userInfo;
			var sFiletype = this.ImgSuffix;
			var rtn = myobj.WriteFile(sReigstNo, ImgBase64, sFiletype);
			if (!rtn) {
				console.log('PRINTCOM.GetGifInfo(): base64ǩ��ͼƬת������');
				return -1;
			}
			return 0;
		} else {
			console.log('PRINTCOM.GetGifInfo(): ClsSaveBase64IMG����δ���壡');
			return -1;
		}
		return -1;
	},
	/*
	 * @creator: Huxiaotian 2019-12-24
	 * @desc:    ����grid��ȡList�б�����(grid������easyui grid/ hisui grid/ jgGrid/ extjs grid)
	 * @others:  ���ǵ�����ҳ���ӡʱ��ȡ������Ӧ����ҳ�汣��һ��
	 */
	getListData: function (_mGridOpt) {
		var mGridurl = '';
		var mGridQueryParams = {};
		var type = _mGridOpt.type || '';
		if (type.toUpperCase() == 'EXTJS') {
			// todo...
		} else if (type.toUpperCase() == 'JQGRID') {
			mGridUrl = $('#' + _mGridOpt.grid).jqGrid('getGridParam', 'url');
			mGridQueryParams = $('#' + _mGridOpt.grid).jqGrid('getGridParam', 'postData');
		} else {
			var _mGridOptions = $('#' + _mGridOpt.grid).datagrid('options');
			mGridUrl = _mGridOptions.url;
			mGridQueryParams = _mGridOptions.queryParams;
		}
		mGridQueryParams['page'] = 1;
		mGridQueryParams['rows'] = 9999;
		var retList = [];
		$.ajax({
			url: mGridUrl,
			type: 'post',
			async: false,
			dataType: 'json',
			data: mGridQueryParams, // {k:v, k:v, ...}
			success: function (jsonData) {
				retList = jsonData.rows;
				if (jsonData.footer) {
					var footerLen = jsonData.footer.length;
					for (var i = 0; i < footerLen; i++) {
						retList.push(jsonData.footer[i]);
					}
				}
			},
			error: function (XMLHR) {
				errorFn(XMLHR);
			}
		});
		return retList;
	},
	/*
	 * @creator: Huxt 2019-12-28
	 * @desc: ��ȡ�������(lines) -- Ŀǰֻ��Ե�ҳ�Ĵ���������
	 * @param: mOeoriStr 	- ÿ��ҽ������ҽ��IDƴ�ɵ��ַ���
	 * @param: vRows 		- û��ҽ����ռ�õ�����
	 * @param: vRowHeight 	- ÿ�е��и�
	 * @param: vFromTop     - ������ſ�ʼλ��
	 * @param: vFromLeft 	- ������ŵ���ߵľ���
	 * @param: vWidth 		- ������ſ��
	 * @param: vIndent 		- ������ļ��
	 * @param: vOrient 		- ������ķ���(left or right)
	 */
	groupLines: function (mOeoriStr, vRows, vRowHeight, vFromTop, vFromLeft, vWidth, vIndent, vOrient) {
		/*
		var vRows = 1;
		var vRowHeight = 10;
		var vFromTop = 80;
		var vFromLeft = 0;
		var vWidth = 5;
		var vIndent = 2;
		var vOrient = 'left';
		var mOeoriStr = '1,2,1,2,2,3,4,5';
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
				if (vOrient == 'right') {
					fromLeft = vFromLeft + vWidth;
				}
				// ����+����+����
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
	 * @desc: �����������
	 * @param: mOeoriStr - ÿ��ҽ������ҽ��IDƴ�ɵ��ַ���
	 */
	getGroups: function (mOeoriStr) {
		var groupNew = [];
		var mOeoriArr = mOeoriStr.split(',');
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
	 * @desc:    invģʽ�»�ȡ��б����Ϣ
	 */
	getBackSlashInfo: function (templateName, xmlTxtData, xmlListData) {
		if ('undefined' != typeof this.BackSlash[templateName]) {
			return this.BackSlash[templateName];
		}
		var backSlash = null;
		var backSlashWidth = parseFloat(xmlListData.getAttribute('BackSlashWidth'));
		if (isNaN(backSlashWidth) || backSlashWidth == 0) {
			this.BackSlash[templateName] = backSlash;
			return this.BackSlash[templateName];
		}
		var txtDataParas = xmlTxtData.getElementsByTagName('txtdatapara');
		for (var j = 0; j < txtDataParas.length; j++) {
			var itm = txtDataParas[j];
			var pname = itm.getAttribute('name');
			var pleft = itm.getAttribute('xcol');
			var ptop = itm.getAttribute('yrow');
			if (pname == 'startPoint' && backSlashWidth != 0) {
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
	 * @creator: Huxt 2021-07-22
	 * @desc:    ����xmlģ��Ϊ���� (��߾��Ժ���-mmΪ��λ)
	 */
	parseXmlTemp: function(tempXmlStr) {
		var xmlDoc = this.CreateXMLDOM(tempXmlStr);
		if (xmlDoc == null) {
			return;
		}
		var xmlInvoice = xmlDoc.getElementsByTagName('invoice')[0];
		var xmlPLData = xmlInvoice.getElementsByTagName('PLData');
		var xmlPICData = xmlInvoice.getElementsByTagName('PICData');
		var xmlTxtData = xmlInvoice.getElementsByTagName('TxtData');
		var xmlListData = xmlInvoice.getElementsByTagName('ListData')[0]; // ��һ��
		var retTemp = {
			invoice: this.parse_invoice(xmlInvoice),
			PLData: this.parse_PLData(xmlPLData),
			PICData: this.parse_PICData(xmlPICData),
			TxtData: this.parse_TxtData(xmlTxtData),
			ListData: this.parse_ListData(xmlListData)
		}
		var backSlash = retTemp.TxtData.backSlash;
		var backSlashWidth = retTemp.ListData.attr.BackSlashWidth
		if (backSlash != null && backSlashWidth > 0) {
			backSlash.endX = backSlash.endX + backSlashWidth;
		}
		return retTemp;
	},
	// ����xmlģ���е� - ҳ������
	parse_invoice: function(xmlInvoice){
		var invoiceAttr = {};
		var tempAttrs = xmlInvoice.attributes;
		for (var i = 0; i < tempAttrs.length; i++) {
			var iAttr = tempAttrs[i];
			invoiceAttr[iAttr.name] = iAttr.value;
		}
		invoiceAttr.heightMM = invoiceAttr.height * 10;
		invoiceAttr.widthMM = invoiceAttr.width * 10;
		return {
			attr: invoiceAttr
		}
	},
	// ����xmlģ���е� - ����
	parse_PLData: function(xmlPLData){
		if (!xmlPLData) {
			return {
				attr: null,
				lines: []
			}
		}
		var tempLines = [];
		for (var i = 0; i < xmlPLData.length; i++) {
			var iXmlPLData = xmlPLData[i];
			var RePrtHeadFlag = iXmlPLData.getAttribute('RePrtHeadFlag');
			var PLine = iXmlPLData.getElementsByTagName('PLine');
			for (var j = 0; j < PLine.length; j++) {
				var jPLine = PLine[j];
				tempLines.push({
					rePrint: RePrtHeadFlag,
					rePrintFixed: RePrtHeadFlag,
					BeginX: this.getNumber(jPLine.getAttribute('BeginX'), 1),
					BeginY: this.getNumber(jPLine.getAttribute('BeginY'), 1),
					EndX: this.getNumber(jPLine.getAttribute('EndX'), 10),
					EndY: this.getNumber(jPLine.getAttribute('EndY'), 10),
					fontcolor: jPLine.getAttribute('fontcolor')
				});
			}
		}
		return {
			attr: null,
			lines: tempLines
		}
	},
	// ����xmlģ���е� - ͼƬ
	parse_PICData: function(xmlPICData){
		if (!xmlPICData) {
			return {
				attr: null,
				imgs: []
			}
		}
		var tempImgs = [];
		for (var i = 0; i < xmlPICData.length; i++) {
			var iXmlPICData = xmlPICData[i];
			var RePrtHeadFlag = iXmlPICData.getAttribute('RePrtHeadFlag');
			var PICdatapara = iXmlPICData.getElementsByTagName('PICdatapara');
			for (var j = 0; j < PICdatapara.length; j++) {
				var jPICdatapara = PICdatapara[j];
				var xcol = this.getNumber(jPICdatapara.getAttribute('xcol'), 10);
				var yrow = this.getNumber(jPICdatapara.getAttribute('yrow'), 10);
				var width = this.getNumber(jPICdatapara.getAttribute('width'), 30);
				var height = this.getNumber(jPICdatapara.getAttribute('height'), 30);
				tempImgs.push({
					rePrint: RePrtHeadFlag,
					rePrintFixed: RePrtHeadFlag,
					name: jPICdatapara.getAttribute('name'),
					xcol: xcol,
					yrow: yrow,
					width: width,
					height: height,
					defaultvalue: jPICdatapara.getAttribute('defaultvalue'),
					printvalue: jPICdatapara.getAttribute('printvalue')
				});
			}
		}
		return {
			attr: null,
			imgs: tempImgs
		}
	},
	// ����xmlģ���е� - �ı�&��ά��&������
	parse_TxtData: function(xmlTxtData){
		if (!xmlTxtData) {
			return {
				attr: null,
				txts: [],
				backSlash: null
			}
		}
		var tempBackSlash = null;
		var tempTxts = [];
		for (var i = 0; i < xmlTxtData.length; i++) {
			var iXmlTxtData = xmlTxtData[i];
			var RePrtHeadFlag = iXmlTxtData.getAttribute('RePrtHeadFlag');
			var txtdatapara = iXmlTxtData.getElementsByTagName('txtdatapara');
			for (var j = 0; j < txtdatapara.length; j++) {
				var jTxtdatapara = txtdatapara[j];
				var txtName = jTxtdatapara.getAttribute('name');
				var xcol = this.getNumber(jTxtdatapara.getAttribute('xcol'), 10);
				var yrow = this.getNumber(jTxtdatapara.getAttribute('yrow'), 10);
				var width = this.getNumber(jTxtdatapara.getAttribute('width'), 210); // Ĭ��A4���
				var height = this.getNumber(jTxtdatapara.getAttribute('height'), 30);
				if (txtName == 'startPoint') {
					tempBackSlash = {
						startX: xcol,
						startY: yrow,
						endX: xcol
					};
				}
				tempTxts.push({
					rePrint: RePrtHeadFlag,
					rePrintFixed: RePrtHeadFlag,
					name: txtName,
					xcol: xcol,
					yrow: yrow,
					width: width,
					height: height,
					defaultvalue: jTxtdatapara.getAttribute('defaultvalue'),
					printvalue: jTxtdatapara.getAttribute('printvalue'),
					fontbold: jTxtdatapara.getAttribute('fontbold'),
					fontname: jTxtdatapara.getAttribute('fontname'),
					fontsize: jTxtdatapara.getAttribute('fontsize'),
					fontcolor: jTxtdatapara.getAttribute('fontcolor'),
					angle: jTxtdatapara.getAttribute('angle'),
					isqrcode: jTxtdatapara.getAttribute('isqrcode'), // �ж��Ƿ��ά��
					qrcodeversion: jTxtdatapara.getAttribute('qrcodeversion'), // ��ά������
					barcodetype: jTxtdatapara.getAttribute('barcodetype'), // �ж��Ƿ�����
					isshowtext: jTxtdatapara.getAttribute('isshowtext') // ��������
				});
			}
		}
		return {
			attr: null,
			txts: tempTxts,
			backSlash: tempBackSlash
		}
	},
	// ����xmlģ���е� - List�б�
	parse_ListData: function(xmlListData){
		if (!xmlListData) {
			return {
				attr: null,
				cols: [],
				minyrow: 0
			}
		}
		var minyrow = 0;
		var ListAttr = {};
		var ListCols = [];
		tempAttrs = xmlListData.attributes;
		for (var i = 0; i < tempAttrs.length; i++) {
			var iAttr = tempAttrs[i];
			ListAttr[iAttr.name] = iAttr.value;
		}
		ListAttr.YStep = this.getNumber(ListAttr.YStep, 20);
		ListAttr.PageRows = this.getNumber(ListAttr.PageRows, 30);
		ListAttr.BackSlashWidth = this.getNumber(ListAttr.BackSlashWidth, 0);
		var Listdatapara = xmlListData.getElementsByTagName('Listdatapara');
		for (var j = 0; j < Listdatapara.length; j++) {
			var jListdatapara = Listdatapara[j];
			var xcol = this.getNumber(jListdatapara.getAttribute('xcol'), 10);
			var yrow = this.getNumber(jListdatapara.getAttribute('yrow'), 10);
			var width = this.getNumber(jListdatapara.getAttribute('width'), 0); // �Ͱ汾��Ŀ����ע��Ĭ��ֵ TODO...
			var height = this.getNumber(jListdatapara.getAttribute('height'), 0);
			var coltype = jListdatapara.getAttribute('coltype');
			var isqrcode = (coltype == 'qrcode') ? 'true' : 'false';
			ListCols.push({
				name: jListdatapara.getAttribute('name'),
				xcol: xcol,
				yrow: yrow,
				xcolFixed: xcol,
				yrowFixed: yrow,
				width: width,
				height: height,
				defaultvalue: jListdatapara.getAttribute('defaultvalue'),
				printvalue: jListdatapara.getAttribute('printvalue'),
				fontbold: jListdatapara.getAttribute('fontbold'),
				fontname: jListdatapara.getAttribute('fontname'),
				fontsize: jListdatapara.getAttribute('fontsize'),
				fontcolor: jListdatapara.getAttribute('fontcolor'),
				angle: jListdatapara.getAttribute('angle'), // ����
				coltype: coltype, // text & img & barcode & qrcode
				isqrcode: isqrcode, // �ж��Ƿ��ά��
				qrcodeversion: jListdatapara.getAttribute('qrcodeversion'), // ��ά������
				barcodetype: jListdatapara.getAttribute('barcodetype'), // �ж��Ƿ�����
				isshowtext: jListdatapara.getAttribute('isshowtext') // ��������
			});
			if (yrow < minyrow || minyrow == 0) {
				minyrow = yrow;
			}
		}
		return {
			attr: ListAttr,
			cols: ListCols,
			minyrow: minyrow
		}
	},
	// ��ȡ��ӡֵ
	getPrintVal: function(pVal, pItem){
		if (typeof pVal != 'undefined' && pVal != null) {
			return pVal;
		}
		if (pItem.defaultvalue) {
			return pItem.defaultvalue;
		}
		if (pItem.printvalue) {
			return pItem.printvalue;
		}
		return '';
	},
	// ��ȡͼƬֵ
	getImgVal: function(oldVal, isNeedBase64){
		oldVal = oldVal || '';
		if (oldVal == '') {
			return '';
		}
		var newVal = oldVal; // local path
		if (isNeedBase64) {
			var base64Str = this.getBase64Str(oldVal);
			newVal = '<img border="0" src="' + 'data:image/jpg;base64,' + base64Str + '"/>'; // base64
		} else if (oldVal.indexOf('http:') == 0 || oldVal.indexOf('data:') == 0) {
			newVal = '<img border="0" src="' + oldVal + '"/>'; // url
		}
		return newVal;
	},
	// �Ӻ�̨��ȡbase64�ַ���
	getBase64Str: function(pVal){
		var b64Str = tkMakeServerCall(this.ImgGetFrom.ClassName, this.ImgGetFrom.MethodName, pVal);
		return b64Str;
	},
	// ת������
	getNumber: function(oVal, defVal){
		var nVal = parseFloat(oVal);
		if (isNaN(nVal)) {
			return defVal;
		}
		return nVal;
	},
	// ������
	sortCols: function(colArr){
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
		return colArr;
	},
	/*
	 * @creator: Huxiaotian 2018-11-02
	 * @desc:    �Զ���ajax (��hisui�����µļ���)
	 */
	jsRunServer: function (_options, successFn, errorFn) {
		$.ajax({
			url: 'websys.Broker.cls',
			type: 'post',
			async: false, // �޸�Ϊͬ��. 2021-09-06
			dataType: 'json',
			data: _options,
			success: function (jsonData) {
				successFn(jsonData);
			},
			error: function (XMLHR) {
				errorFn(XMLHR);
			}
		});
	},
	/**
	 * ���������ʽ���û�������ƽ̨�ķ��� (����: �����ظ�����)
	 * Huxt 2022-3-24
	 * ��Ҫ��csp����: <script type="text/javascript" src='../scripts/DHCPrtComm.js'></script>
	 */
	Call_DHC_PrintByLodop: function(retJson, _options, LODOP) {
		// ����xmlģ��
		DHCP_GetXMLConfig('', _options.XMLTemplate);
		var mystr = '';
		for (var i = 0; i < PrtAryData.length; i++) {
			mystr = mystr + PrtAryData[i];
		}
		var nameArr = getNameArr(mystr);
		// ��ʽ����ӡ����
		// get inpara
		var paraObj = retJson.Para || {};
		var inparaArr = [];
		for (var p in paraObj) {
			inparaArr.push(p + String.fromCharCode(2) + paraObj[p]);
		}
		var inpara = inparaArr.join('^');
		// get inlist
		var listArr = retJson.List || [];
		for (var il = 0; il < listArr.length; il++) {
			var ilData = listArr[il];
			if (typeof ilData == 'object') {
				listArr[il] = obj2Str(ilData, nameArr);  // ���������������
			}
		}
		var inlist = listArr.join(String.fromCharCode(2));
		// ��������
		if (_options.callBase == true) {
			_options.callBase = {};
		}
		var jsonArr = _options.callBase.jsonArr;
		var reportNote = _options.callBase.reportNote;
		var otherCfg = _options.callBase.otherCfg;
		if (!reportNote) {
			reportNote = "LODOP_" + _options.XMLTemplate;
		}
		// ���ô�ӡ
		DHC_PrintByLodop(LODOP, inpara, inlist, jsonArr, reportNote, otherCfg);
		return;
		// =====================
		function obj2Str(objData, nameArr){
			var retArr = [];
			for (var n = 0; n < nameArr.length; n++) {
				var nVal = objData[nameArr[n]];
				nVal = (typeof nVal == 'undefiend' || nVal == null) ? '' : nVal;
				retArr.push(nVal);
			}
			return retArr.join('^');
		}
		function getNameArr(xmlStr) {
			var nameArr = [];
			var xmlDoc = PRINTCOM.CreateXMLDOM(xmlStr);
			if (xmlDoc == null) {
				return;
			}
			var xmlInvoice = xmlDoc.getElementsByTagName('invoice')[0];
			var xmlListData = xmlInvoice.getElementsByTagName('ListData')[0]; // ��һ��
			var Listdatapara = xmlListData.getElementsByTagName('Listdatapara');
			for (var j = 0; j < Listdatapara.length; j++) {
				var jListdatapara = Listdatapara[j];
				var name = jListdatapara.getAttribute('name');
				nameArr.push(name);
			}
			return nameArr;
		}
	},
	// ����listitem��������. Huxt 2022-07-14
	listItemProp: function(oneCol, listItem){
		for (var k in listItem) {
			oneCol[k] = listItem[k];
		}
	},
	move_Txt: function(oneCol, _options) {
		if (oneCol.maxTextLen > 0) {
			oneCol.value = this.cutStr(oneCol.value, oneCol.maxTextLen);
		}
		if (_options.listValign !== 'center') {
			return;
		}
		var maxLines = _options.listTxtRows;
		if (!(maxLines > 0)) {
			var charHeight = this.charHeight(oneCol.fontsize)
			maxLines = parseInt(oneCol.rHeight / charHeight);
		}
		var jsWrapLen = 0;
		var wrapLen = oneCol.wrapLen;
		if (!(wrapLen > 0)) {
			var charWidth = this.charWidth(oneCol.fontsize);
			wrapLen = parseInt(oneCol.width / charWidth) * 2;
		} else {
			jsWrapLen = wrapLen;
		}
		var txtLines = 1;
		var lineHeight = oneCol.rHeight;
		if (wrapLen > 0 && maxLines > 0) {
			var txtArr = this.splitStr(oneCol.value, wrapLen);
			txtLines = txtArr.length > maxLines ? maxLines : txtArr.length;
			if (jsWrapLen > 0) {
				oneCol.value = txtArr.join('\n'); // ��jsָ���ĳ��Ȼ���
			}
			lineHeight = oneCol.rHeight / maxLines;
		}
		var txtHeight = txtLines * lineHeight;
		oneCol.yrow = oneCol.yrow + ((oneCol.rHeight - txtHeight) / 2);
	},
	splitStr: function (inStr, inputLen) {
		inStr = '' + inStr;
		var subStr = '';
		var retArr = [];
		do {
			subStr = this.cutStr(inStr, inputLen);
			if (subStr == '') {
				return retArr;
			}
			retArr.push(subStr);
			inStr = inStr.substr(subStr.length);
		} while (subStr != '');
		return retArr;
	},
	cutStr: function(inStr, inputLen) {
		inStr = '' + inStr;
		if (inStr == null) {
			inStr = "";
		}
		var cuttedStr = "";
		var inStrLen = inStr.length;
		var charlen = 0;
		for (var chari = 0; chari < inStrLen; chari++) {
			var c = inStr.charCodeAt(chari);
			if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
				charlen++;
			} else {
				charlen += 2;
			}
			if (charlen <= inputLen) {
				cuttedStr = cuttedStr + inStr.charAt(chari);
			} else {
				return cuttedStr;
			}
		}
		return inStr;
	},
	charWidth: function(fontSize){
		return parseFloat(fontSize) / 2.82;
	},
	charHeight: function(fontSize){
		return parseFloat(fontSize) / 2.82;
	}
}
function PRINTCOM_SetXml(ConStr) {
	PRINTCOM.PrtAryData[PRINTCOM.PrtAryData.length] = ConStr;
}
