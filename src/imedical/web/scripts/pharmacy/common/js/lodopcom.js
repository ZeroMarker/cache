/**
 * @creator: Huxiaotian 2019-03-26
 * @desc: lodop打印简化公共函数
 * @js: scripts/pharmacy/common/js/lodopcom.js
 */

/**
 * @desc: 公共变量
 */
var lodopCommonUom = "mm";
var boderCommonUom = "px";
var fontCommonUom = "pt";
var htmlFactor = 1;

/*
 * @creator: Huxt 2019-11-29
 * @desc: 简化Lodop Text打印
 */
function LODOP_TEXT(LODOP, strContent, styleStr) {
	// styleStr解析为对象
	var styleObj = {};
	styleStr = styleStr.replace(/ /g, "");
	var styleArr = styleStr.split(";");
	var styleLen = styleArr.length;
	var oneStyle,
	oneStyleArr,
	styleKey,
	styleVal;
	for (var i = 0; i < styleLen; i++) {
		oneStyle = styleArr[i];
		if (oneStyle == "") {
			continue;
		}
		oneStyleArr = oneStyle.split(":");
		if (oneStyleArr.length <= 1) {
			continue;
		}
		styleKey = oneStyleArr[0];
		styleVal = oneStyleArr[1];
		styleObj[styleKey] = styleVal;
	}
	// 打印执行
	LODOP.ADD_PRINT_TEXT(styleObj.FromTop, styleObj.FromLeft, styleObj.Width, styleObj.Height, strContent);
	for (var mKey in styleObj) {
		if (mKey == "FontName") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "FontSize") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "FontColor") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "Bold") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "Italic") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "Underline") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "Alignment") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "Angle") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "ItemType") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "HOrient") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "VOrient") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "PenWidth") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "PenStyle") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "Stretch") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "PreviewOnly") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
		if (mKey == "ReadOnly") {
			LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]);
			continue;
		}
	}
}

/*
 * @creator: Huxt 2019-11-29
 * @desc: 简化Lodop 表格打印
 */
function LODOP_HTML(LODOP, _options) {
	if (_options.type.toUpperCase() == "HTML") {
		LODOP.ADD_PRINT_HTM(_options.FromTop, _options.FromLeft, _options.Width, _options.Height, formatHtmStr(_options));
	} else if (_options.type.toUpperCase() == "TABLE") {
		LODOP.ADD_PRINT_TABLE(_options.Top, _options.Left, _options.Width, _options.Height, formatTableStr(_options));
	} else {
		alert("未指定表格打印方式");
	}
}

/*
 * @creator: Huxt 2019-11-29
 * @desc: 简化Lodop 页码打印
 */
function LODOP_PAGENO(LODOP, fromTop, fromLeft) {
	LODOP.ADD_PRINT_HTM(fromTop, fromLeft, '100%', 30, "<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
}

/**
 * Creator: Huxiaotian 2019-01-31
 * Desc: 分组表格格式(含每组的表头表尾)
 * Para: _options.fontSize - 表格文字字体, 数字, 单位为pt
 * 		 _options.width - 表格宽度, 百分比% 或者 数字,若是数字的单位为mm(毫米)
 * 		 _options.columns - 表格的列信息, 格式: [{},{}]
 * 		 _options.data - 表格数据, 格式: [{main:{}, detail:[{},{}]}, {main:{}, detail:[{},{}]}]
 * 		 _options.border - 表格边框宽度, 0:无边框; 1:有边框
 * 		 _options.formatHeader - 每组表头回调函数
 * 		 _options.formatFooter - 每组表尾回调函数
 * Others: 调用方式
 * 		var htmlStr = formatHtmStr({});
 * 		LODOP.ADD_PRINT_HTM("20mm", "5mm", "96%", "96%", htmlStr);
 *		LODOP.SET_PRINT_STYLEA(0, "Vorient", 3);
 */
function formatHtmStr(_options) {
	// set default options
	if (_options.columns == undefined || _options.columns.length == 0 || _options.columns == null) {
		return "<div>columns error...<div>";
	}
	_options.fontSize = _options.fontSize || 12;
	_options.width = _options.width || 500;
	_options.padding = _options.padding || 0;
	_options.formatHeader = _options.formatHeader || function (m) {
		return null;
	}
	_options.formatFooter = _options.formatFooter || function (m) {
		return null;
	}
	_options.data = _options.data || [];
	if (_options.border == undefined) {
		_options.border = 1;
	}
	if (isNaN(parseFloat(_options.border))) {
		_options.border = 1;
	}
	// fromat string
	var myData = _options.data;
	var myDayaLen = myData.length;
	if (myDayaLen == 0) {
		return "<div>no data...<div>";
	}
	var retDivStr = "<div><style>#detailTbl {border: " + val_px(_options.border) + " solid black; border-style:solid; border-collapse:collapse; word-break:break-all; font-size:" + val_pt(_options.fontSize) + ";} table{table-layout:fixed; width:" + val_mm(_options.width) + ";}</style>";
	if (_options.borderStyle == 2) {
		retDivStr = "<div><style>#detailTbl {border-top:1px solid black; border-bottom:1px solid black; border-collapse:collapse; word-break:break-all; font-size:" + val_pt(_options.fontSize) + ";} table{border-collapse:collapse; table-layout:fixed; width:" + val_mm(_options.width) + ";} #detailTbl td{border-bottom:1px solid black; } #detailTbl th{border-bottom:1px solid black; }</style>";
	}
	var firstFlag = false;
	for (var i = 0; i < myDayaLen; i++) {
		oneGroupMain = myData[i].main;
		oneGroupDetail = myData[i].detail;
		if (i == 0) {
			firstFlag = true;
		} else {
			firstFlag = false;
		}
		retDivStr += formatHFTable(firstFlag, _options.formatHeader(oneGroupMain));
		retDivStr += formatOneTabel({
			// fontSize: _options.fontSize, // 已设置了整体
			data: oneGroupDetail,
			columns: _options.columns,
			border: _options.border,
			rowHeight: _options.rowHeight,
			padding: _options.padding
		});
		retDivStr += formatHFTable(true, _options.formatFooter(oneGroupMain));
	}
	retDivStr += "</div>";
	// console.log(retDivStr);
	return retDivStr;
}

/**
 * Creator: Huxiaotian 2019-01-31
 * Desc: 单一表格格式的 (没有表头表位, 只是一个单一的表格)
 * Para: _options.fontSize - 表格文字字体, 数字, 单位为pt
 * 		 _options.width - 表格宽度, 百分比% 或者 数字,若是数字的单位为mm(毫米)
 * 		 _options.columns - 表格的列信息, 格式: [{},{}]
 * 		 _options.data - 表格数据, 格式: [{},{},{}]
 * 		 _options.border - 表格边框宽度, 0:无边框; 1:有边框
 * Others: 调用方式
 * 		var tblStr = formatTableStr({});
 * 		LODOP.ADD_PRINT_TABLE(145, 20, "92%", "92%", tblStr);
 */
function formatTableStr(_options) {
	if (_options.columns == undefined || _options.columns.length == 0 || _options.columns == null) {
		return "<div>columns error...<div>";
	}
	_options.fontSize = _options.fontSize || 12;
	_options.width = _options.width || 500;
	if (_options.border == undefined) {
		_options.border = 1;
	}
	if (isNaN(parseFloat(_options.border))) {
		_options.border = 1;
	}
	if (_options.data) {
		var retTblStr = "<style>table,td,th {border: " + val_px(_options.border) + " solid black; border-style:solid; border-collapse:collapse; font-size:" + val_pt(_options.fontSize) + ";} table{table-layout:fixed; width:" + val_mm(_options.width) + ";}</style><table><thead><tr";
		if (_options.rowHeight) {
			retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; // 设置行高
		}
		retTblStr += ">";
		// set title
		var thdata = "";
		var oneCol = null;
		var myCols = _options.columns;
		var myColsLen = myCols.length;
		for (var i = 0; i < myColsLen; i++) {
			oneCol = myCols[i];
			if (oneCol.name == undefined || oneCol.index == undefined) {
				return "<div>columns error...<div>";
			}
			oneCol.hidden = oneCol.hidden || false;
			if (oneCol.hidden == true) {
				continue;
			}
			thdata = oneCol.name;
			if (oneCol.maxTextLen) {
				if (oneCol.maxTextLen >= 2) {
					thdata = SplitInputStr(thdata, oneCol.maxTextLen);
				}
			}
			oneCol.width = oneCol.width || 50;
			oneCol.align = oneCol.align || 'left';
			retTblStr += "<th style='width:" + val_mm(oneCol.width) + "' align='" + oneCol.align + "'>" + thdata + "</th>";
		}
		retTblStr += "</tr></thead><tbody>";
		// set data
		var myData = _options.data || [];
		var myDayaLen = myData.length;
		if (myDayaLen == 0) {
			return retTblStr;
		}
		var oneRowData = null;
		var tdata = "";
		for (var j = 0; j < myDayaLen; j++) {
			oneRowData = myData[j];
			retTblStr += "<tr";
			if (_options.rowHeight) {
				retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; // 设置行高
			}
			retTblStr += ">";
			for (var k = 0; k < myColsLen; k++) {
				oneCol = myCols[k];
				if (oneCol.name == undefined || oneCol.index == undefined) {
					return "<div>columns error...<div>";
				}
				oneCol.hidden = oneCol.hidden || false;
				if (oneCol.hidden == true) {
					continue;
				}
				oneCol.align = oneCol.align || 'left';
				tdata = oneRowData[oneCol.index];
				if (oneCol.maxTextLen) {
					if (oneCol.maxTextLen >= 2) {
						tdata = SplitInputStr(tdata, oneCol.maxTextLen);
					}
				}
				//
				if (oneCol.align == 'left') {
					retTblStr += "<td valign='top' "
					if (oneCol.cellattr) {
						retTblStr += "style='" + oneCol.cellattr(tdata, oneRowData) + "'";
					}
					if (oneCol.colspan) {
						retTblStr += " colspan='" + oneCol.colspan + "'";
					}
					if (oneCol.rowspan) {
						retTblStr += " rowspan='" + oneCol.colspan + "'";
					}
					if (oneCol.addattr) {
						var addattr = oneCol.addattr(tdata, oneRowData);
						if (addattr) {
							for (var attrKey in addattr) {
								retTblStr += " " + attrKey + "='" + addattr[attrKey] + "'";
								if (attrKey == 'colspan') {
									k = k + addattr[attrKey];
								}
							}
						}
					}
					retTblStr += ">" + tdata + "</td>";
				} else {
					retTblStr += "<td valign='top' align='" + oneCol.align + "' "
					if (oneCol.cellattr) {
						retTblStr += "style='" + oneCol.cellattr(tdata, oneRowData) + "'";
					}
					if (oneCol.colspan) {
						retTblStr += " colspan='" + oneCol.colspan + "'";
					}
					if (oneCol.rowspan) {
						retTblStr += " rowspan='" + oneCol.colspan + "'";
					}
					if (oneCol.addattr) {
						var addattr = oneCol.addattr(tdata, oneRowData);
						if (addattr) {
							for (var attrKey in addattr) {
								retTblStr += " " + attrKey + "='" + addattr[attrKey] + "'";
								if (attrKey == 'colspan') {
									k = k + addattr[attrKey];
								}
							}
						}
					}
					retTblStr += ">" + tdata + "</td>";
				}
			}
			retTblStr += "</tr>";
		}
		retTblStr += "</tbody></table>";
		return retTblStr;
	}
	return "<div>no data, please check data or url...<div>";
}

// =========================以下为工具==========================
// 格式化一个表格字符串
// 内部调用
function formatOneTabel(_options) {
	if (_options.columns == undefined || _options.columns.length == 0 || _options.columns == null) {
		return "<table><tr><td>colums undefined...</td></tr></table>";
	}
	// _options.fontSize = _options.fontSize || 12;
	if (_options.border == undefined) {
		_options.border = 1;
	}
	if (isNaN(parseFloat(_options.border))) {
		_options.border = 1;
	}

	if (_options.data) {
		var retTblStr = "<table id='detailTbl' border='" + _options.border + "' cellspacing='0' cellpadding='" + _options.padding + "'";
		if (_options.fontSize) {
			retTblStr += " style='font-size:" + val_pt(_options.fontSize) + ";'"
		}
		retTblStr += " ><thead><tr"
		if (_options.rowHeight) {
			retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; // 设置行高
		}
		retTblStr += ">";
		// set title
		var thdata = "";
		var oneCol = null;
		var myCols = _options.columns;
		var myColsLen = myCols.length;
		for (var i = 0; i < myColsLen; i++) {
			oneCol = myCols[i];
			if (oneCol.name == undefined || oneCol.index == undefined) {
				return "<div>columns error...<div>";
			}
			oneCol.hidden = oneCol.hidden || false;
			if (oneCol.hidden == true) {
				continue;
			}
			oneCol.width = oneCol.width || 50;
			oneCol.align = oneCol.align || 'left';
			oneCol.rowspan = oneCol.rowspan || false;
			thdata = oneCol.name;
			if (oneCol.maxTextLen) {
				if (oneCol.maxTextLen >= 2) {
					thdata = SplitInputStr(thdata, oneCol.maxTextLen);
				}
			}
			retTblStr += "<th style='width:" + val_mm(oneCol.width) + "' align='" + oneCol.align + "'>" + thdata + "</th>";
		}
		retTblStr += "</tr></thead><tbody>";
		// set data
		var _rowSpanNum = 0,
		_lastCellVal = null;
		var myData = _options.data || [];
		var myDayaLen = myData.length;
		if (myDayaLen == 0) {
			return retTblStr;
		}
		var oneRowData = null;
		var tdata = "";
		for (var j = 0; j < myDayaLen; j++) {
			oneRowData = myData[j];
			retTblStr += "<tr";
			if (_options.rowHeight) {
				retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; // 设置行高
			}
			retTblStr += ">";
			//
			for (var k = 0; k < myColsLen; k++) {
				oneCol = myCols[k];
				if (oneCol.name == undefined || oneCol.index == undefined) {
					return "<div>columns error...<div>";
				}
				oneCol.hidden = oneCol.hidden || false;
				if (oneCol.hidden == true) {
					continue;
				}
				tdata = oneRowData[oneCol.index];
				if (oneCol.rowspan == true) {
					_lastCellVal = j > 0 ? myData[j - 1][oneCol.index] : null;
					if (tdata == _lastCellVal) {
						continue;
					}
					_rowSpanNum = rowSpanNum(myData, j, oneCol.index, tdata);
				}
				if (oneCol.maxTextLen) {
					if (oneCol.maxTextLen >= 2) {
						tdata = SplitInputStr(tdata, oneCol.maxTextLen);
					}
				}
				oneCol.align = oneCol.align || 'left';
				oneCol.valign = oneCol.valign || 'top';
				retTblStr += "<td valign='" + oneCol.valign + "' align='" + oneCol.align + "'"
				if (oneCol.cellattr) {
					retTblStr += " style='" + oneCol.cellattr(tdata, oneRowData) + "'";
				}
				if (oneCol.rowspan == true) {
					retTblStr += " rowspan='" + _rowSpanNum + "'";
				}
				if (oneCol.addattr) {
					var addattr = oneCol.addattr(tdata, oneRowData);
					if (addattr) {
						for (var attrKey in addattr) {
							retTblStr += " " + attrKey + "='" + addattr[attrKey] + "'";
							if (attrKey == 'colspan') {
								k = k + addattr[attrKey];
							}
						}
					}
				}
				tdata = tdata == '' ? '&nbsp;' : tdata;
				retTblStr += ">" + tdata + "</td>";
			}
			retTblStr += "</tr>";
		}
		retTblStr += "</tbody></table>";
		return retTblStr;
	}
	return "<table><tr><td>no data...</td></tr></table>";
}

// 计算合并行数
function rowSpanNum(rowsData, startRowIndex, colIndex, cellVal) {
	var retNum = 0;
	var rLen = rowsData.length;
	for (var r = startRowIndex; r < rLen; r++) {
		var rowData = rowsData[r];
		var tmpCellVal = rowData[colIndex];
		if (tmpCellVal != cellVal) {
			break;
		} else {
			retNum++;
		}
	}
	return retNum;
}

// 表头表尾Table字符串
function formatHFTable(firstFlag, _tableOptions) {
	var mainStr = "";
	if (_tableOptions == null) {
		return mainStr;
	}
	if (firstFlag == true) {
		mainStr = "<table style='font-size:" + printSize(_tableOptions.fontSize) + "pt;'>";
	} else {
		mainStr = "<table style='font-size:" + printSize(_tableOptions.fontSize) + "pt;margin-top:" + printSize(_tableOptions.marginTop) + "mm;'>";
	}
	var tData = _tableOptions.data;
	var tRows = tData.length;
	var tRowData,
	tCols,
	tColData;
	var tcolStyle = "";
	for (var i = 0; i < tRows; i++) {
		tRowData = tData[i];
		mainStr += "<tr style='vertical-align:bottom;'>";
		tCols = tRowData.length;
		tcolStyle = "";
		for (var j = 0; j < tCols; j++) {
			tColData = tRowData[j];
			if (tColData.width) {
				tcolStyle += "width:" + printSize(tColData.width) + "mm;";
			}
			if (tColData.font) {
				tcolStyle += "font-family:" + tColData.font + ";";
			}
			if (tColData.size) {
				tcolStyle += "font-size:" + printSize(tColData.size) + "pt;";
			}
			if (tColData.bold) {
				tcolStyle += "font-weight:bold;";
			}
			mainStr += "<td";
			if (tcolStyle != "") {
				mainStr += " style='" + tcolStyle + "'";
			}
			if (tColData.align) {
				mainStr += " align='" + tColData.align + "'";
			}
			if (tColData.valign) {
				mainStr += " valign='" + tColData.valign + "'";
			}
			if (tColData.colspan) {
				mainStr += " colspan='" + tColData.colspan + "'";
			}
			if (tColData.rowspan) {
				mainStr += " rowspan='" + tColData.rowspan + "'";
			}
			mainStr += ">" + tColData.td + "</td>";
			tcolStyle = "";
		}
		mainStr += "</tr>";
	}
	mainStr += "</table>";
	return mainStr;
}

/**
 * Creator: Huxiaotian 2019-01-31
 * Desc:    按指定的长度拆分字符串
 * Input:   inputStr - 字符串; inputLength - 为偶数,汉字按照2长度计算,英文字符按一个长度计算
 * Output:  指定长度的字符串
 */
function SplitInputStr(inputStr, inputLength) {
	if (inputStr == null) {
		inputStr = "";
	}
	var splitprintdesc = "";
	var inputDescLen = inputStr.length;
	var charlen = 0;
	for (var chari = 0; chari < inputDescLen; chari++) {
		var c = inputStr.charCodeAt(chari);
		if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
			charlen++;
		} else {
			charlen += 2;
		}
		if (charlen <= inputLength) {
			splitprintdesc = splitprintdesc + inputStr.charAt(chari);
		} else {
			return splitprintdesc;
		}
	}
	return inputStr;
}

// 获取数据类型
function getDataType(val) {
	var ss = Object.prototype.toString;
	return ss.call(val);
}

// 获取当前页面的缩放值
function detectZoom() {
	var ratio = 0,
	screen = window.screen,
	ua = navigator.userAgent.toLowerCase();
	if (window.devicePixelRatio !== undefined) {
		ratio = window.devicePixelRatio;
	} else if (~ua.indexOf('msie')) {
		if (screen.deviceXDPI && screen.logicalXDPI) {
			ratio = screen.deviceXDPI / screen.logicalXDPI;
		}
	} else if (window.outerWidth !== undefined && window.innerWidth !== undefined) {
		ratio = window.outerWidth / window.innerWidth;
	}
	if (ratio) {
		ratio = Math.round(ratio * 100);
	}
	return ratio;
}

// 获取转换系数
function getHtmlFactor() {
	var htmlFactor = 1;
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
		var ratio = detectZoom();
		if (ratio > 100) {
			var x = 1 - (100 / ratio); // 页面被放大,字体需缩小的比例
			return 1 - x;
		} else if (ratio < 100) {
			var x = (100 / ratio) - 1; // 页面被缩小,字体需放大的比例
			return 1 + x;
		} else {
			return htmlFactor;
		}
	} else {
		return htmlFactor;
	}
}

// PC电脑比例,获取转换系数 (返回: 1, 1.25, 1.5, 1.75, 2 等值)
function getPCFactor(){
	var winDpi = 1;
	try {
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
			var sysInfo = new ActiveXObject("PHALodopUtil.SysInfo");
			winDpi = sysInfo.GetWinDpi();
		} else {
			if (typeof CmdShell == 'object' && CmdShell != null) {
				// <ADDINS require="CmdShell"/>
				var cmdStr = '(function getWinDpi(x){';
				cmdStr += 'var sysInfo = new ActiveXObject("PHALodopUtil.SysInfo");';
				cmdStr += 'winDpi = sysInfo.GetWinDpi();';
				cmdStr += 'return winDpi;}());';
				CmdShell.notReturn = 0;
				var retJson = CmdShell.EvalJs(cmdStr);
				var tMsg = retJson.msg;
				var tRtn = parseFloat(retJson.rtn);
				if (tMsg == 'success' && tRtn > 0) {
					winDpi = tRtn;
				}
			}
		}
	} catch (e){}
	return winDpi;
}

// 外部调用缩放比例
function printSize(val) {
	return htmlFactor * val;
}

// 转换为缩放之后带单位的数据3个方法
function val_mm(val) {
	var valStr = val.toString();
	return valStr.indexOf("%") > 0 ? valStr : ((val * htmlFactor) + "mm");
}
function val_px(val) {
	var valStr = val.toString();
	return valStr.indexOf("%") > 0 ? valStr : ((val * htmlFactor) + "px");
}
function val_pt(val) {
	var valStr = val.toString();
	return valStr.indexOf("%") > 0 ? valStr : ((val * htmlFactor) + "pt");
}

// 初始化缩放比例
htmlFactor = getHtmlFactor() * getPCFactor();


/**
 * 实现Lodop多页签预览
 * 调用ie打开一个窗口
 * Huxt 2021-08-27
 */
if (typeof PHA_LODOP == 'undefined') {
	var PHA_LODOP = {};
}
PHA_LODOP.TempArr = [];
PHA_LODOP.LpCount = 0;
PHA_LODOP.WinCount = 0;
function PHA_LODOP_GET(title, isPreviewInBrose) {
	var LODOP;
	if (isPreviewInBrose == true || isPreviewInBrose == '1' || isPreviewInBrose == 'Y') {
		if (!needCLodop()) {
			if (document.getElementById('LODOP_PREVIEW_IN_BROWSE')) {
				PHA_LODOP.LpCount = PHA_LODOP.LpCount + 1;
				$('#LODOP_PREVIEW_TAB').append('<div class="lodop_tab_item" tabindex="0" lodopIndex="' + (PHA_LODOP.LpCount - 1) + '" id="LODOP_TAB' + PHA_LODOP.LpCount + '" linkTo="LODOP_OB' + PHA_LODOP.LpCount + '"><label class="lodop_tab_item_label">' + title + '</label><label class="lodop_tab_item_close">×<label></div>');
				var pHtml = '';
				pHtml += '<object id="LODOP_OB' + PHA_LODOP.LpCount + '" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" style="display:none;border:1px solid gray;border-radius:4px;"> ';
				pHtml += '<div id="LODOP_EM' + PHA_LODOP.LpCount + '" type="application/x-print-lodop" height=0 pluginspage="install_lodop32.exe"></div>';
				pHtml += '</object>';
				$('#LODOP_PREVIEW_CONTENT').append(pHtml);
				LODOP = getLodop(document.getElementById('LODOP_OB' + PHA_LODOP.LpCount), document.getElementById('LODOP_EM' + PHA_LODOP.LpCount));
				LODOP.isPreviewInBrose = true;
			} else {
				LODOP = getLodop();
			}
		} else {
			LODOP = getLodop();
		}
	} else {
		if (window.ActiveXObject || 'ActiveXObject' in window) {
			if (!document.getElementById('LODOP_OB_PHA')) {
				$('body').append('<object id="LODOP_OB_PHA" classid="clsid:2105C259-1E0C-4534-8141-A753534CB4CA" style="display:none;"> ');
			}
			LODOP = getLodop(document.getElementById('LODOP_OB_PHA')); // 如果还报[拒绝访问],则是没有安装lodop32.exe
		} else {
			LODOP = getLodop(); // IE直接调用用报[拒绝访问]
		}
	}
	return LODOP;
}
function PHA_LODOP_PREVIEW(LODOP, autoClose) {
	if (autoClose) {
		LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
		LODOP.autoClose = true;
	}
	if (LODOP.isPreviewInBrose) {
		LODOP.SET_SHOW_MODE("PREVIEW_IN_BROWSE", 1);
		LODOP.SET_SHOW_MODE("HIDE_PAPER_BOARD", 1);
		LODOP.SET_SHOW_MODE('HIDE_QBUTTIN_PREVIEW', 1);
		LODOP.SET_PREVIEW_WINDOW(1, 3, 1, 0, 0, '打印预览.开始打印'); // 点打印不选择纸张
		PHA_LODOP.TempArr.push(LODOP); // 浏览器点击页签时才调用PREVIEW()方法
	} else {
		LODOP.IsDoPreview = true;
		LODOP.PREVIEW();
	}
}
function PHA_LODOP_OPEN(_options) {
	var jsSrcArr = _options.jsSrc;
	var jsFunctionArr = _options.jsFunction;
	var cspUrl = window.location.href;
	var cspUrlArr = cspUrl.split("/");
	var AppPath = "/" + cspUrlArr[3] + "/" + cspUrlArr[4] + "/";
	// 获取URL
	var jsSrcStr = '';
	if (typeof jsSrcArr == 'string') {
		jsSrcArr = [jsSrcArr];
	}
	for (var j = 0; j < jsSrcArr.length; j++) {
		if (jsSrcStr == '') {
			jsSrcStr = 'jsLoad=' + encodeURIComponent(jsSrcArr[j]);
		} else {
			jsSrcStr += '&jsLoad=' + encodeURIComponent(jsSrcArr[j]);
		}
	}
	var jsFunctionStr = '';
	if (typeof jsFunctionArr == 'string') {
		jsFunctionArr = [jsFunctionArr];
	}
	for (var j = 0; j < jsFunctionArr.length; j++) {
		if (jsFunctionStr == '') {
			jsFunctionStr = 'jsFunction=' + encodeURIComponent(jsFunctionArr[j]);
		} else {
			jsFunctionStr += '&jsFunction=' + encodeURIComponent(jsFunctionArr[j]);
		}
	}
	PHA_LODOP.WinCount = PHA_LODOP.WinCount + 1;
	var winUrl = AppPath + 'csp/pha.com.lodoppreview.csp?' + jsSrcStr + '&' + jsFunctionStr;
	winUrl += '&USERID=' + session['LOGON.USERID'];
	winUrl += '&CTLOCID=' + session['LOGON.CTLOCID'];
	winUrl += '&GROUPID=' + session['LOGON.GROUPID'];
	var winName = '打印预览' + PHA_LODOP.WinCount;
	var winOptions = 'width=' + (window.screen.availWidth - 19) + ',height=' + (window.screen.availHeight - 65) + ',menubar=no,status=yes,toolbar=no,resizable=yes,top=10,left=10';
	// 打开预览窗口
	if (window.ActiveXObject || 'ActiveXObject' in window) {
		window.open(winUrl, winName, winOptions);
	} else {
		if (typeof CmdShell == 'object' && CmdShell != null) {
			var openUrl = cspUrlArr[0] + '//' + cspUrlArr[2] + winUrl;
			var hasLodopUtil = false;
			if (hasLodopUtil) {
				var cmdStr = '(function OpenUrl(x){';
				cmdStr += 'var sysBrowser = new ActiveXObject("PHALodopUtil.SysBrowser");';
				cmdStr += 'sysBrowser.OpenUrl("' + openUrl + '&tabPosition=left&notCloseWin=Y&IsWebBrowser=Y' + '");';
				cmdStr += 'return 1;}())';
				CmdShell.notReturn = 1;
				CmdShell.EvalJs(cmdStr);
			} else {
				var runStr = 'start /min iexplore.exe "' + openUrl + '"';
				CmdShell.notReturn = 1;
				CmdShell.Run(runStr);
			}
		} else {
			for (var i = 0; i < jsFunctionArr.length; i++){
				var jsFunction = jsFunctionArr[i];
				try {
					eval(jsFunction);
				} catch (e) {
					var eStr = '';
					for (var k in e) {
						eStr = (eStr == '') ? (k + ': ' + e[k]) : (eStr + '\n' + k + ': ' + e[k]);
					}
					alert(eStr);
				}
			}
		}
	}
	return;
}