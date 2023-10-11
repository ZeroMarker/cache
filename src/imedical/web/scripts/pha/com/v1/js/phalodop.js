/*
* 药房使用lodop打印表格的公共方法
* pha/com/v1/js/phalodop.js
* Huxt 2021-05-13
* 标版更新于 2021-09-09
*/
var PHA_LODOP = {
	/*
	* 控制是否在一个界面预览
	*/
	PREVIEW_IN_BROWSE: false,
	/*
	* 公共方法入口
	* new PHA_LODOP.Init('任务名').Page('').PageNo('')...
	*/
	Init: function (taskName, LODOP) {
		for (var k in PHA_LODOP) {
			if (k == 'Init') {
				continue;
			}
			this[k] = PHA_LODOP[k];
		}
		this.LODOP = LODOP;
		if (!this.LODOP) {
			try {
				if (this.PREVIEW_IN_BROWSE) {
					this.LODOP = PHA_LODOP_GET(taskName, true); // todo...
				} else {
					this.LODOP = getLodop();
				}
			} catch(e){
				alert('getLodop Error: \n' + e.toString() + '\n请在csp添加<PHAPRINTCOM/>标签!');
				return this;
			}
		}
		this.LODOP.PRINT_INIT(taskName);
		return this;
	},
	// .Page('Orient:1; Width:0; Height:0; PageName:A4')
	Page: function (styleStr) {
		return this._Page(styleStr);
	},
	// .Printer('pdf')
	Printer: function (printerName) {
		return this._Printer(printerName);
	},
	// .PageNo('Top:10mm; Left:40mm;')
	PageNo: function (styleStr) {
		return this._PageNo(styleStr);
	},
	// .Text('文本内容', 'Top:10mm; Left:10mm; Width:120mm; Height:20mm')
	Text: function (contentStr, styleStr) {
		return this._Text(contentStr, styleStr);
	},
	// .Html({})
	Html: function (_htmlOpts) {
		return this._Html(_htmlOpts);
	},
	// .Image('本地路径/远程路径/base64', 'Top:10mm; Left:10mm; Width:120mm; Height:20mm')
	Image: function(contentStr, styleStr){
		return this._Image(contentStr, styleStr);
	},
	// .BarCode('条码/二维码内容', 'Top:10mm; Left:10mm; Width:120mm; Height:20mm; CodeType:128Auto')
	BarCode: function(contentStr, styleStr){
		return this._BarCode(contentStr, styleStr);
	},
	// .Chart('图标内容HTML', 'Top:10mm; Left:10mm; Width:120mm; Height:20mm; ChartType:1')
	Chart: function(contentStr, styleStr){
		return this._Chart(contentStr, styleStr);
	},
	// .Line('StTop:10mm; StLeft:10mm; EdTop:10mm; EdLeft:10mm; LineStyle:1, LineWidth:1')
	Line: function(styleStr){
		return this._Line(styleStr);
	},
	// .Rect('Top:10mm; Left:10mm; Width:120mm; Height:20mm; LineStyle:1, LineWidth:1')
	Rect: function(contentStr, styleStr){
		return this._Rect(contentStr, styleStr);
	},
	// .Ellipse('Top:10mm; Left:10mm; Width:120mm; Height:20mm; LineStyle:1, LineWidth:1')
	Ellipse: function(styleStr){
		return this._Ellipse(styleStr);
	},
	// .Data()
	Data: function(strDataStyle, varDataValue){
		return this._Data(strDataStyle, varDataValue);
	},
	// .Print()
	Print: function(){
		return this._Print();
	},
	// .Preview()
	Preview: function(autoClose){
		if (this.PREVIEW_IN_BROWSE) {
			PHA_LODOP_PREVIEW(this.LODOP, autoClose);
			return this;
		}
		return this._Preview(autoClose);
	},
	// .SaveToFile('C:\\test.jpg', false)
	SaveToFile: function(fileName, isPrompt){
		return this._SaveToFile(fileName, isPrompt);
	},
	
	/*
	* 以下为过程
	*/
	_Page: function (styleStr) {
		var opts = this._str2Object(styleStr);
		this.LODOP.SET_PRINT_PAGESIZE(opts.Orient, opts.Width, opts.Height, opts.PageName);
		return this;
	},
	_Printer: function (printerName) {
		var getPrinterIndex = function(pName){
			if (pName == '' || typeof pName == 'undefined' || pName == null) {
				return -1;
			}
			for (var i = 0; i < this.LODOP.GET_PRINTER_COUNT(); i++) {
				if (LODOP.GET_PRINTER_NAME(i) == pName) {
					return i;
				}
			}
			pName = pName.toUpperCase();
			for (var i = 0; i < LODOP.GET_PRINTER_COUNT(); i++) {
				if (LODOP.GET_PRINTER_NAME(i).toUpperCase().indexOf(pName) > -1) {
					return i;
				}
			}
			return -1;
		}
		this.LODOP.SET_PRINTER_INDEX(getPrinterIndex(printerName));
		return this;
	},
	_PageNo: function (styleStr) {
		var opts = this._str2Object(styleStr);
		if (opts.Format == '0') {
			this.LODOP.ADD_PRINT_HTM(opts.Top, opts.Left, '100%', 30, "<span tdata='pageNO'>##</span>/ <span tdata='pageCount'>##</span>");
		} else {
			this.LODOP.ADD_PRINT_HTM(opts.Top, opts.Left, '100%', 30, "<span tdata='pageNO'>第##页</span>/ <span tdata='pageCount'>共##页</span>");
		}
		this.LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		return this;
	},
	_Text: function (contentStr, styleStr) {
		var opts = this._str2Object(styleStr);
		this.LODOP.ADD_PRINT_TEXT(opts.Top, opts.Left, opts.Width, opts.Height, contentStr);
		this._addStyle(opts, ['Top', 'Left', 'Width', 'Height']);
		return this;
	},
	_Html: function (_htmlOpts) {
		_htmlOpts.type = _htmlOpts.type || "";
		_htmlOpts.Top = _htmlOpts.FromTop || _htmlOpts.Top || 10;
		_htmlOpts.Left = _htmlOpts.FromLeft || _htmlOpts.Left || 10;
		_htmlOpts.Width = _htmlOpts.DivWidth || _htmlOpts.Width || '98%';
		_htmlOpts.Height = _htmlOpts.DivHeight || _htmlOpts.Height || '98%';
		if (_htmlOpts.html) {
			this.LODOP.ADD_PRINT_HTM(_htmlOpts.Top, _htmlOpts.Left, _htmlOpts.Width, _htmlOpts.Height, _htmlOpts.html);
			return this;
		}
		var ptType = _htmlOpts.type.toUpperCase();
		if (!_htmlOpts.data && _htmlOpts.dataOptions) {
			_htmlOpts.data = this._printData(_htmlOpts.dataOptions, ptType);
		}
		if (_htmlOpts.fitColumns == true) {
			this._getFitColumns(_htmlOpts);
		}
		if(ptType == "TABLE") {
			// 此方法只能打印一个表格
			var printStr = this._getTableStr(_htmlOpts);
			this.LODOP.ADD_PRINT_TABLE(_htmlOpts.Top, _htmlOpts.Left,_htmlOpts.Width, _htmlOpts.Height, printStr);
		} else {
			// 此方法可以打印多个表格
			var printStr = this._getHtmStr(_htmlOpts);
			this.LODOP.ADD_PRINT_HTM(_htmlOpts.Top, _htmlOpts.Left, _htmlOpts.Width, _htmlOpts.Height, printStr);
		}
		return this;
	},
	_Image: function(contentStr, styleStr){
		var opts = this._str2Object(styleStr);
		this.LODOP.ADD_PRINT_IMAGE(opts.Top, opts.Left, opts.Width, opts.Height, contentStr);
		return this;
	},
	_BarCode: function(contentStr, styleStr){
		var opts = this._str2Object(styleStr);
		this.LODOP.ADD_PRINT_BARCODE(opts.Top, opts.Left, opts.Width, opts.Height, opts.CodeType, contentStr);
		return this;
	},
	_Chart: function(contentStr, styleStr){
		var opts = this._str2Object(styleStr);
		this.LODOP.ADD_PRINT_CHART(opts.Top, opts.Left, opts.Width, opts.Height, opts.ChartType, contentStr);
		return this;
	},
	_Line: function(styleStr){
		var opts = this._str2Object(styleStr);
		this.LODOP.ADD_PRINT_LINE(opts.StTop, opts.StLeft, opts.EdTop, opts.EdLeft, opts.LineStyle, opts.LineWidth);
		return this;
	},
	_Rect: function(contentStr, styleStr){
		var opts = this._str2Object(styleStr);
		if (contentStr != '' && contentStr != null) {
			this._Text(contentStr, styleStr);
		}
		this.LODOP.ADD_PRINT_RECT(opts.Top, opts.Left, opts.Width, opts.Height, opts.LineStyle, opts.LineWidth);
		return this;
	},
	_Ellipse: function(styleStr){
		var opts = this._str2Object(styleStr);
		this.LODOP.ADD_PRINT_ELLIPSE(opts.Top, opts.Left, opts.Width, opts.Height, opts.LineStyle, opts.LineWidth);
		return this;
	},
	_Data: function(strDataStyle, varDataValue){
		this.LODOP.ADD_PRINT_DATA(strDataStyle, varDataValue);
		return this;
	},
	_Print: function(){
		this.LODOP.PRINT();
		return this;
	},
	_Preview: function(autoClose){
		if (autoClose) {
			this.LODOP.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
		}
		this.LODOP.PREVIEW();
		return this;
	},
	_SaveToFile: function(fileName, isPrompt){
		if (isPrompt == true) {
			this.LODOP.SET_SAVE_MODE('FILE_PROMPT', 1);
		} else {
			this.LODOP.SET_SAVE_MODE('FILE_PROMPT', 0);
		}
		this.LODOP.SAVE_TO_FILE(fileName);
		return this;
	},
	_addStyle: function(styleOpts, usedKeyArr){
		for (var styleKey in styleOpts) {
			if (usedKeyArr.indexOf(styleKey) >= 0) {
				continue;
			}
			this.LODOP.SET_PRINT_STYLEA(0, styleKey, styleOpts[styleKey]);
		}
	},
	
	/*
	* 多个Table区域Div
	* 入参数据格式 _options.data: [ {main:{mainData},detail:[{rowData},{rowData},...]}, {main:{mainData},detail:[{rowData},{rowData}]}, ...]
	*/
	_getHtmStr: function(_options){
		// 默认值
		var mBorder = parseFloat(_options.border);
		_options.border = isNaN(mBorder) ? 1 : mBorder;
		_options.fontSize = _options.fontSize || 12;
		_options.width = _options.width || 195;
		_options.padding = _options.padding || 0;
		_options.formatHeader = _options.formatHeader || function(m){return null;}
		_options.formatFooter = _options.formatFooter || function(m){return null;}
		// 表格样式
		var retDivStr = "";
		retDivStr += "<div>";
		retDivStr += this._getTableStyle(_options);
		// 每组表格
		var _data = _options.data;
		var _dLen = _data.length;
		for (var g = 0; g < _dLen; g++) {
			var oneGroupMain = _data[g].main;
			var oneGroupDetail = _data[g].detail;
			if (!oneGroupMain) {
				retDivStr += "data must include main</div>";
				return retDivStr
			}
			if (!oneGroupDetail) {
				retDivStr += "data must include detail</div>";
				return retDivStr
			}
			if (g == 0) {
				firstFlag = true;
			} else {
				firstFlag = false;
			}
			_options._newdata = oneGroupDetail;
			retDivStr += this._headFootTable(firstFlag, _options.formatHeader(oneGroupMain, oneGroupDetail));
			retDivStr += this._formatTabelHtml(_options);
			retDivStr += this._headFootTable(true, _options.formatFooter(oneGroupMain, oneGroupDetail));
		}
		retDivStr += "</div>";
		return retDivStr;
	},
	/*
	* 单个Table区域Div
	* 入参数据格式 _options.data : [{rowData},{rowData},...]}
	*/
	_getTableStr: function(_options){
		// 默认值
		var mBorder = parseFloat(_options.border);
		_options.border = isNaN(mBorder) ? 1 : mBorder;
		_options.fontSize = _options.fontSize || 12;
		_options.width = _options.width || 195;
		_options.padding = _options.padding || 0;
		// 表格样式
		var retDivStr = "";
		retDivStr += "<div>";
		retDivStr += this._getTableStyle(_options);
		retDivStr += this._formatTabelHtml(_options);
		retDivStr += "</div>";
		return retDivStr;
	},
	/*
	* Table字符串统一入口
	* 入参数据格式: _options.data : [{rowData},{rowData},...]}
	*               _options.data
	*/
	_formatTabelHtml: function(_options){
		// 数据
		var mData;
		if (_options._newdata) {
			mData = _options._newdata;
		} else {
			mData = _options.data;
		}
		// 验证参数
		if (!_options.columns || _options.columns.length == 0) {
			return "<table><tr><td>colums undefined...</td></tr></table>";
		}
		if (!_options.data || _options.data.length == 0) {
			return "<table><tr><td>no data...</td></tr></table>";
		}
		// 表格
		var retTblStr = "<table class='" + "detailTbl" + "' border='" + _options.border + "' cellspacing='0' cellpadding='" + _options.padding + "'";
		if (_options.fontSize) {
			retTblStr += " style='font-size:" + this.val_pt(_options.fontSize) + ";'"
		}
		retTblStr += " ><thead><tr"
		if (_options.rowHeight) {
			retTblStr += " style='height:" + this.val_px(_options.rowHeight) + "'";
			// retTblStr += " height='" + this._printSize(_options.rowHeight) + "'"; // ie9版本css不兼容
		}
		retTblStr += ">";
		// 表格标题
		var thData = "";
		var oneCol = null;
		var mCols = _options.columns;
		var mColLen = mCols.length;
		for (var i = 0; i < mColLen; i++) {
			oneCol = mCols[i];
			if (typeof oneCol.name == 'undefined' && typeof oneCol.title == 'undefined') {
				return "<div>column must have property name or title<div>";
			}
			if (typeof oneCol.index == 'undefined' && typeof oneCol.field == 'undefined') {
				return "<div>column must have property index or field<div>";
			}
			oneCol.hidden = oneCol.hidden || false;
			if (oneCol.hidden == true) {
				continue;
			}
			oneCol.name = oneCol.name || oneCol.title;
			oneCol.index = oneCol.index || oneCol.field;
			oneCol.width = oneCol.width || 50;
			oneCol.align = oneCol.align || 'left';
			oneCol.valign = oneCol.valign || 'top';
			oneCol.rowspan = oneCol.rowspan || false;
			thData = oneCol.name;
			if (oneCol.maxTextLen >= 2) {
				thData = this._cutStr(thData, oneCol.maxTextLen);
			}
			retTblStr += "<th style='width:" + this.val_mm(oneCol.width) + ";' valign='" + oneCol.valign + "' align='" + oneCol.align + "'>" + thData + "</th>";
		}
		retTblStr += "</tr></thead><tbody>";
		// 表格数据
		var _rowSpanNum = 0, _lastCellVal = null;
		var mDataLen = mData.length;
		if (mDataLen == 0) {
			return retTblStr;
		}
		var tdData = "";
		var oneRowData = null;
		for (var j = 0; j < mDataLen; j++) {
			oneRowData = mData[j];
			retTblStr += "<tr";
			if (_options.rowHeight) {
				retTblStr += " style='height:" + this.val_px(_options.rowHeight) + "'";
				// retTblStr += " height='" + this._printSize(_options.rowHeight) + "'"; // ie9版本css不兼容
			}
			retTblStr += ">";
			for (var k = 0; k < mColLen; k++) {
				oneCol = mCols[k];
				if (oneCol.hidden == true) {
					continue;
				}
				tdData = (oneRowData[oneCol.index] || oneRowData[oneCol.index] == 0) ? oneRowData[oneCol.index] : '';
				if (oneCol.rowspan == true) {
					_lastCellVal = j > 0 ? mData[j - 1][oneCol.index] : null;
					if (tdData == _lastCellVal) {
						continue;
					}
					_rowSpanNum = this._rowSpanNum(mData, j, oneCol.index, tdData);
				}
				if (oneCol.maxTextLen >= 2) {
					tdData = this._cutStr(tdData, oneCol.maxTextLen); // 最大长度
				}
				retTblStr += "<td valign='" + oneCol.valign + "'";
				if (oneCol.align != 'left') {
					retTblStr += " align='" + oneCol.align + "'";
				}
				if (oneCol.cellattr) {
					retTblStr += " style='" + oneCol.cellattr(tdData, oneRowData, j) + "'"; // 样式
				}
				if (oneCol.styler) {
					retTblStr += " style='" + oneCol.styler(tdData, oneRowData, j) + "'"; // 样式
				}
				if (oneCol.formatter) {
					tdData = oneCol.formatter(tdData, oneRowData, j); // 格式化
				}
				if (oneCol.rowspan == true) {
					retTblStr += " rowspan='" + _rowSpanNum + "'";
				}
				// Huxt 2021-11-15 添加
				if (oneCol.addattr) {
					var addattr = oneCol.addattr(tdData, oneRowData, j);
					if (addattr) {
						for (var attrKey in addattr) {
							retTblStr += " " + attrKey + "='" + addattr[attrKey] + "'";
							if (attrKey == 'colspan') {
								k = k + addattr[attrKey];
							}
						}
					}
				}
				retTblStr += ">" + this._checkTd(tdData) + "</td>";
			}
			retTblStr += "</tr>";
		}
		retTblStr += "</tbody></table>";
		return retTblStr;
	},
	/*
	* 表头/表尾Table字符串
	*/
	_headFootTable: function (firstFlag, _tableOptions) {
	    var mainStr = "";
	    if (_tableOptions == null) {
	        return mainStr;
	    }
	    if (firstFlag == true) {
	        mainStr = "<table cellpadding='" + _tableOptions.padding + "' style='font-size:" + this._printSize(_tableOptions.fontSize) + "pt;margin-bottom:" + _tableOptions.padding + "px;' >";
	    } else {
	        mainStr = "<table cellpadding='" + _tableOptions.padding + "' style='font-size:" + this._printSize(_tableOptions.fontSize) + "pt;margin-bottom:" + _tableOptions.padding + "px;margin-top:" + this._printSize(_tableOptions.marginTop) + "mm;' >";
	    }
	    var tData = _tableOptions.data;
	    if (typeof tData == 'undefined') {
		    return;
		}
	    var tRows = tData.length;
	    var tRowData, tCols, tColData;
	    var tcolStyle = "";
	    for (var i = 0; i < tRows; i++) {
	        tRowData = tData[i];
	        mainStr += "<tr style='vertical-align:bottom;'>";
	        tCols = tRowData.length;
	        tcolStyle = "";
	        for (var j = 0; j < tCols; j++) {
	            tColData = tRowData[j];
	            var tdData = tColData.td;
	            if (tColData.width) {
	                tcolStyle += "width:" + this._printSize(tColData.width) + "mm;";
	            }
	            if (tColData.font) {
	                tcolStyle += "font-family:" + tColData.font + ";";
	            }
	            if (tColData.size >= 1) {
	                tcolStyle += "font-size:" + this._printSize(tColData.size) + "pt;";
	            }
	            if (tColData.bold == true) {
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
	            mainStr += ">" + this._checkTd(tdData) + "</td>";
	            tcolStyle = "";
	        }
	        mainStr += "</tr>";
	    }
	    mainStr += "</table>";
	    return mainStr;
	},
	/*
	* 计算跨行数
	*/
	_rowSpanNum: function(rowsData, startRowIndex, colIndex, cellVal){
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
	},
	/*
	* 表格边框样式
	*/
	_getTableStyle: function(_options){
		var bStyle = _options.borderStyle >= 0 ? _options.borderStyle : 4;
		bStyle = bStyle > 4 ? 4 : bStyle;
		var tableStyleStr = "";
		tableStyleStr += "<style>";
		tableStyleStr += "table {";
		tableStyleStr += "  border-collapse:collapse;";
		tableStyleStr += "  table-layout:fixed;";
		tableStyleStr += "  width:" + this.val_mm(_options.width) + ";";
		tableStyleStr += "}";
		// 0-无边框 & 4-全边框
		_options.border = bStyle == 4 ? 1 : 0;
		tableStyleStr += ".detailTbl {";
		tableStyleStr += "  border:" + this.val_px(_options.border) + " solid black;";
		tableStyleStr += "  border-collapse:collapse;";
		tableStyleStr += "  word-break:break-all;";
		tableStyleStr += "  font-size:" + this.val_pt(_options.fontSize) + ";";
		tableStyleStr += "}";
		// 1-标题与内容分割线
		if (bStyle == 1) {
			tableStyleStr += ".detailTbl th {";
			tableStyleStr += "  border-bottom:1px solid black;";
			tableStyleStr += "}";
		}
		// 2-仅横边框
		if (bStyle == 2) {
			tableStyleStr += ".detailTbl td {";
			tableStyleStr += "  border-bottom:1px solid black;";
			tableStyleStr += "}";
			tableStyleStr += ".detailTbl th {";
			tableStyleStr += "  border-bottom:1px solid black;";
			tableStyleStr += "  border-top:1px solid black;";
			tableStyleStr += "}";
		}
		// 3-其他
		if (bStyle == 3) {
			tableStyleStr += ".detailTbl td {";
			tableStyleStr += "  border-bottom:1px solid black;";
			tableStyleStr += "  border-right:1px solid black;";
			tableStyleStr += "}";
			tableStyleStr += ".detailTbl td:last-child {";
			tableStyleStr += "  border-right:0px;";
			tableStyleStr += "}";
			tableStyleStr += ".detailTbl th {";
			tableStyleStr += "  border-bottom:1px solid black;";
			tableStyleStr += "  border-right:1px solid black;";
			tableStyleStr += "  border-top:1px solid black;";
			tableStyleStr += "}";
			tableStyleStr += ".detailTbl th:last-child {";
			tableStyleStr += "  border-right:0px;";
			tableStyleStr += "}";
		}
		tableStyleStr += "</style>";
		return tableStyleStr;
	},
	/*
	* the following is util function
	* =========================================
	*/
	_printData: function(_dataOptions, ptType){
		// 获取数据
		_dataOptions.ResultSetType = 'Array';
		var d = this._serverData(_dataOptions);
		var dType = this._dataType(d);
		if (dType != '[object Array]') {
			var tipsInfo = '数据获取异常';
			if (dType == '[object Object]' && d.success == 0) {
				tipsInfo = tipsInfo + ':' + d.msg;
			}
			alert(tipsInfo);
			return [];
		}
		// 不分组
		if (ptType == 'TABLE') {
			return this._doSort(d, _dataOptions);
		}
		// 分组
		var gArr = [];
		var tArr = [];
		var groupFields = _dataOptions.groupFields || [];
		var l = d.length;
		for (var x = 0; x < l; x++) {
			var dx = d[x];
			var groupStr = '';
			for (var f = 0; f < groupFields.length; f++) {
				var _field = groupFields[f];
				groupStr = groupStr == '' ? dx[_field] : groupStr + '-' + dx[_field];
			}
			var gIndex = tArr.indexOf(groupStr);
			if (gIndex < 0) {
				tArr.push(groupStr);
				gArr.push({
					main: dx,
					detail: [dx]
				});
			} else {
				gArr[gIndex].detail.push(dx);
			}
		}
		if (gArr.length == 0) {
			gArr.push({
				main: d,
				detail: [d]
			});
		}
		// 组排序 TODO...
		// 各组内排序
		var gLen = gArr.length;
		for (var g = 0; g < gLen; g++) {
			this._doSort(gArr[g].detail, _dataOptions);
		}
		return gArr;
	},
	/*
	* 获取后台类方法或者Query的数据 (如果是类方法则必须返回json格式, 如: [{rowData}, {rowData}, ...])
	*/
	_serverData: function(_dataOptions){
		var retData = null;
		$.ajax({
			url: "websys.Broker.cls",
			type: "post",
			async: false,
			dataType: "json",
			data: _dataOptions,
			success: function(jsonData){
				retData = jsonData;
			},
			error: function(XMLHR){
				retData = {success:0, msg:XMLHR.responseText};
			}
	    });
	    return retData;
	},
	/*
	* 支持多列排序 (最多3列,多了影响效率且不好写)
	* dataArr : [{rowData}, {rowData}, ...]
	* _dataOptions.sortFields : 例如: ['name', 'age', 'sex']; 最多写3列
	* _dataOptions.sortType : DESC or ASC
	*/
	_doSort: function  (dataArr, _dataOptions) {
		var sortFields = _dataOptions.sortFields || [];
		if (typeof firstBy == 'undefined') {
			return dataArr;
		}
		if (sortFields.length == 0) {
			return dataArr;
		}
		var _sVal = function(v1, v2, i, tp){
			var vf1 = v1[sortFields[i]].toString();
			var vf2 = v2[sortFields[i]].toString();
			if (!isNaN(vf1) && !isNaN(vf2)) {
				return (_dataOptions.sortType == 'DESC' ? vf2 - vf1 : vf1 - vf2);
			}
			if (_dataOptions.sortType == 'DESC') {
				return 0 - vf1.localeCompare(vf2, 'zh-CN');
			}
			return vf1.localeCompare(vf2, 'zh-CN');
		}
		if (sortFields.length == 1) {
			var sFn = firstBy(function(v1, v2) {
				return _sVal(v1, v2, 0);
			});
		}
		if (sortFields.length == 2) {
			var sFn = firstBy(function(v1, v2) {
				return _sVal(v1, v2, 0);
			}).thenBy(function(v1, v2) {
				return _sVal(v1, v2, 1);
			});
		}
		if (sortFields.length >= 3) {
			var sFn = firstBy(function(v1, v2) {
				return _sVal(v1, v2, 0);
			}).thenBy(function(v1, v2) {
				return _sVal(v1, v2, 1);
			}).thenBy(function(v1, v2) {
				return _sVal(v1, v2, 2);
			});
		}
		return dataArr.sort(sFn);
	},
	_checkTd: function(tdVal){
		if (tdVal == 0) {
			return tdVal;
		}
		tdVal = (typeof tdVal == 'undefined') || (tdVal == null) ? '' : tdVal;
		tdVal = (tdVal == '') ? ' ' : tdVal;
		tdVal = isNaN(tdVal) ? tdVal.toString().replace(/ /g, "&nbsp;") : tdVal;
		return tdVal;
	},
	/*
	* sting to object
	*/
	_str2Object:  function (_str, _del) {
		var del = _del || ';';
		var arr = _str.split(del);
		var retObj = {};
		for (var i = 0; i < arr.length; i++) {
			var oStr = arr[i];
			if (oStr == '') {
				continue;
			}
			var oArr = oStr.split(':');
			var key = oArr[0];
			key = key.trim();
			var val = oArr.length > 1 ? oArr[1] : '';
			val = val.trim();
			retObj[key] = val;
		}
		return retObj;
	},
	/*
	* cut string by length
	*/
	_cutStr: function(inStr, inputLen){
		if (inStr == null){
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
			if(charlen <= inputLen){
				cuttedStr = cuttedStr + inStr.charAt(chari);
			} else {
				return cuttedStr;
			}
		}
		return inStr;
	},
	/*
	* get data type
	* you can get the following type from this function:
	* [object String] / [object Null] / [object Number] / [object Undefined] / [object Object] / [object Array]
	*/
	_dataType: function(val){
		return Object.prototype.toString.call(val);
	},
	_getFitColumns: function(_htmlOpts){
		var nColumns = [];
		var totalWidth = 0;
		var tColumns = _htmlOpts.columns;
		for (var t = 0; t < tColumns.length; t++) {
			var tCol = tColumns[t];
			var cWidth = parseFloat(tCol.width);
			if (isNaN(cWidth)) {
				continue;
			}
			var nCol = {};
			for (var tc in tCol) {
				nCol[tc] = tCol[tc];
			}
			nCol.width = cWidth;
			nColumns.push(nCol);
			totalWidth = totalWidth + cWidth;
		}
		for (var t = 0; t < nColumns.length; t++) {
			var nCol = nColumns[t];
			nCol.width = '' + ((nCol.width / totalWidth) * 100) + '%';
		}
		_htmlOpts.columns = nColumns;
	},
	/*
	* HTML页面缩放比例
	*/
	_detectZoom: function () {
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
	},
	/*
	* IE浏览器缩放(CHROME不受此影响),获取转换系数
	*/
	_getHtmlFactor: function() {
		var htmlFactor = 1;
		if (!!window.ActiveXObject || "ActiveXObject" in window) {
			var ratio = this._detectZoom();
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
	},
	/*
	* PC电脑比例,获取转换系数
	* 返回: 1, 1.25, 1.5, 1.75, 2 等值
	*/
	_getPCFactor: function(){
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
					cmdStr += 'return winDpi;}())';
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
	},
	/*
	* 外部调用缩放比例
	*/
	_printSize: function (val) {
		return this._htmlFactor * val;
	},
	/*
	* 缩放比例
	*/
	_htmlFactor: 1,
	/*
	* 转换为缩放之后带单位的数据3个方法
	*/
	val_mm: function (val) {
		var valStr = val.toString();
		return valStr.indexOf("%") > 0 ? valStr : ((val * this._htmlFactor) + "mm");
	},
	val_px: function (val) {
		var valStr = val.toString();
		return valStr.indexOf("%") > 0 ? valStr : ((val * this._htmlFactor) + "px");
	},
	val_pt: function (val) {
		var valStr = val.toString();
		return valStr.indexOf("%") > 0 ? valStr : ((val * this._htmlFactor) + "pt");
	}
}

/*
* 异步加载初始化比例
*/
setTimeout(function(){
	PHA_LODOP._htmlFactor = PHA_LODOP._getHtmlFactor() * PHA_LODOP._getPCFactor();
}, 0);

/*
* 这是一个来自网上的插件, 支持在js中多列排序
* 代码少不单独引用插件js, 直接在此加一个方法
*/
var firstBy = (function () {
	function identity(v) {
		return v;
	}
	function ignoreCase(v) {
		return typeof(v) === "string" ? v.toLowerCase() : v;
	}
	function makeCompareFunction(f, opt) {
		opt = typeof(opt) === "object" ? opt : {
			direction: opt
		};
		if (typeof(f) != "function") {
			var prop = f;
			f = function (v1) {
				return !!v1[prop] ? v1[prop] : "";
			}
		}
		if (f.length === 1) {
			var uf = f;
			var preprocess = opt.ignoreCase ? ignoreCase : identity;
			var cmp = opt.cmp || function (v1, v2) {
				return v1 < v2 ? -1 : v1 > v2 ? 1 : 0;
			}
			f = function (v1, v2) {
				return cmp(preprocess(uf(v1)), preprocess(uf(v2)));
			}
		}
		var descTokens = {
			"-1": '',
			desc: ''
		};
		if (opt.direction in descTokens)
			return function (v1, v2) {
				return -f(v1, v2)
			};
		return f;
	}
	function tb(func, opt) {
		var x = (typeof(this) == "function" && !this.firstBy) ? this : false;
		var y = makeCompareFunction(func, opt);
		var f = x ? function (a, b) {
			return x(a, b) || y(a, b);
		} : y;
		f.thenBy = tb;
		return f;
	}
	tb.firstBy = tb;
	return tb;
})();


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