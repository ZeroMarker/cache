/**
* @creator: Huxiaotian 2019-03-26
* @desc: lodop��ӡ�򻯹�������
* @js: scripts/pharmacy/common/js/lodopcom.js
*/

/**
* @desc: ��������
*/
var lodopCommonUom = "mm";
var boderCommonUom = "px";
var fontCommonUom = "pt";
var htmlFactor = 1;

/*
* @creator: Huxt 2019-11-29
* @desc: ��Lodop Text��ӡ
*/
function LODOP_TEXT(LODOP, strContent, styleStr){
	//styleStr����Ϊ����
	var styleObj = {};
	styleStr = styleStr.replace(/ /g, "");
	var styleArr = styleStr.split(";");
	var styleLen = styleArr.length;
	var oneStyle, oneStyleArr, styleKey, styleVal;
	for(var i=0; i<styleLen; i++){
		oneStyle = styleArr[i];
		if(oneStyle == ""){
			continue;
		}
		oneStyleArr = oneStyle.split(":");
		if(oneStyleArr.length <= 1){
			continue;
		}
		styleKey = oneStyleArr[0];
		styleVal = oneStyleArr[1];
		styleObj[styleKey] = styleVal;
	}
	//��ӡִ��
	LODOP.ADD_PRINT_TEXT(styleObj.FromTop, styleObj.FromLeft, styleObj.Width, styleObj.Height, strContent);
	for(var mKey in styleObj){
		if(mKey == "FontName"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "FontSize"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "FontColor"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "Bold"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "Italic"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "Underline"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "Alignment"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "Angle"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "ItemType"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "HOrient"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "VOrient"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "PenWidth"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "PenStyle"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "Stretch"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "PreviewOnly"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
		if(mKey == "ReadOnly"){LODOP.SET_PRINT_STYLEA(0, mKey, styleObj[mKey]); continue;}
	}
}

/*
* @creator: Huxt 2019-11-29
* @desc: ��Lodop ����ӡ
*/
function LODOP_HTML(LODOP, _options){
	if(_options.type.toUpperCase() == "HTML"){
		LODOP.ADD_PRINT_HTM(_options.FromTop, _options.FromLeft, _options.Width, _options.Height, formatHtmStr(_options));
	} else if(_options.type.toUpperCase() == "TABLE"){
		LODOP.ADD_PRINT_TABLE(_options.Top, _options.Left,_options.Width,_options.Height, formatTableStr(_options));
	} else {
		alert("δָ������ӡ��ʽ");
	}
}

/*
* @creator: Huxt 2019-11-29
* @desc: ��Lodop ҳ���ӡ
*/
function LODOP_PAGENO(LODOP, fromTop, fromLeft){
	LODOP.ADD_PRINT_HTM(fromTop,fromLeft,'100%',30, "<span tdata='pageNO'>��##ҳ</span>/<span tdata='pageCount'>��##ҳ</span>");
    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
}

/**
* Creator: Huxiaotian 2019-01-31
* Desc: �������ʽ(��ÿ��ı�ͷ��β)
* Para: _options.fontSize - �����������, ����, ��λΪpt
* 		_options.width - �����, �ٷֱ�% ���� ����,�������ֵĵ�λΪmm(����)
* 		_options.columns - ��������Ϣ, ��ʽ: [{},{}]
* 		_options.data - �������, ��ʽ: [{main:{}, detail:[{},{}]}, {main:{}, detail:[{},{}]}]
* 		_options.border - ���߿���, 0:�ޱ߿�; 1:�б߿�
* 		_options.formatHeader - ÿ���ͷ�ص�����
* 		_options.formatFooter - ÿ���β�ص�����
* Others: ���÷�ʽ
* 		var htmlStr = formatHtmStr({});
* 		LODOP.ADD_PRINT_HTM("20mm", "5mm", "96%", "96%", htmlStr);
*		LODOP.SET_PRINT_STYLEA(0, "Vorient", 3);
*/
function formatHtmStr(_options){
	//set default options
	if(_options.columns == undefined || _options.columns.length == 0 || _options.columns == null){
		return "<div>columns error...<div>";
	}
	_options.fontSize = _options.fontSize || 12;
	_options.width = _options.width || 500;
	_options.formatHeader = _options.formatHeader || function(m){return null;}
	_options.formatFooter = _options.formatFooter || function(m){return null;}
	_options.data = _options.data || [];
	if(_options.border == undefined){
		_options.border = 1;
	}
	if(isNaN(parseFloat(_options.border))){
		_options.border = 1;
	}
	
	//fromat string
	var myData = _options.data;
	var myDayaLen = myData.length;
	if (myDayaLen==0){
		return "<div>no data...<div>";
	}
	var retDivStr = "<div><style>#detailTbl {border: " + val_px(_options.border) + " solid black; border-style:solid; border-collapse:collapse; word-break:break-all; font-size:" + val_pt(_options.fontSize) + ";} table{table-layout:fixed; width:" + val_mm(_options.width) + ";}</style>";
	var firstFlag = false;
	for(var i=0; i<myDayaLen; i++){
		oneGroupMain = myData[i].main;
		oneGroupDetail = myData[i].detail;
		if(i==0){
			firstFlag = true;
		} else {
			firstFlag = false;
		}
		retDivStr += formatHFTable(firstFlag, _options.formatHeader(oneGroupMain));
		retDivStr += formatOneTabel({
			//fontSize: _options.fontSize, //������������
			data: oneGroupDetail,
			columns: _options.columns,
			border: _options.border,
			rowHeight: _options.rowHeight,
		});
		retDivStr += formatHFTable(true, _options.formatFooter(oneGroupMain));
	}
	retDivStr += "</div>";
	return retDivStr;
}

/**
* Creator: Huxiaotian 2019-01-31
* Desc: ��һ����ʽ�� (û�б�ͷ��λ, ֻ��һ����һ�ı��)
* Para: _options.fontSize - �����������, ����, ��λΪpt
* 		_options.width - �����, �ٷֱ�% ���� ����,�������ֵĵ�λΪmm(����)
* 		_options.columns - ��������Ϣ, ��ʽ: [{},{}]
* 		_options.data - �������, ��ʽ: [{},{},{}]
* 		_options.border - ���߿���, 0:�ޱ߿�; 1:�б߿�
* Others: ���÷�ʽ
* 		var tblStr = formatTableStr({});
* 		LODOP.ADD_PRINT_TABLE(145, 20, "92%", "92%", tblStr);
*/
function formatTableStr(_options){
	if(_options.columns == undefined || _options.columns.length == 0 || _options.columns == null){
		return "<div>columns error...<div>";
	}
	_options.fontSize = _options.fontSize || 12;
	_options.width = _options.width || 500;
	if(_options.border == undefined){
		_options.border = 1;
	}
	if(isNaN(parseFloat(_options.border))){
		_options.border = 1;
	}
	
	if(_options.data){
		var retTblStr = "<style>table,td,th {border: " + val_px(_options.border) + " solid black; border-style:solid; border-collapse:collapse; font-size:"+ val_pt(_options.fontSize) + ";} table{table-layout:fixed; width:"+ val_mm(_options.width) + ";}</style><table><thead><tr";
		if(_options.rowHeight){
			retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; //�����и�
		}
		retTblStr += ">";
		//set title
		var thdata = "";
		var oneCol = null;
		var myCols = _options.columns;
		var myColsLen = myCols.length;
		for(var i=0; i<myColsLen; i++){
			oneCol = myCols[i];
			if(oneCol.name == undefined || oneCol.index == undefined){
				return "<div>columns error...<div>";
			}
			oneCol.hidden = oneCol.hidden || false;
			if(oneCol.hidden == true){
				continue;
			}
			thdata = oneCol.name;
			if(oneCol.maxTextLen){
				if(oneCol.maxTextLen >= 2){
					thdata = SplitInputStr(thdata, oneCol.maxTextLen);
				}
			}
			oneCol.width = oneCol.width || 50;
			oneCol.align = oneCol.align || 'left';
			retTblStr += "<th style='width:" + val_mm(oneCol.width) + "' align='"+ oneCol.align +"'>" + thdata + "</th>";
		}
		retTblStr += "</tr></thead><tbody>";
		
		//set data
		var myData = _options.data || [];
		var myDayaLen = myData.length;
		if(myDayaLen == 0){
			return retTblStr;
		}
		var oneRowData = null;
		var tdata = "";
		for(var j=0; j<myDayaLen; j++){
			oneRowData = myData[j];
			retTblStr += "<tr";
			if(_options.rowHeight){
				retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; //�����и�
			}
			retTblStr += ">";
			for(var k=0; k<myColsLen; k++){
				oneCol = myCols[k];
				if(oneCol.name == undefined || oneCol.index == undefined){
					return "<div>columns error...<div>";
				}
				oneCol.hidden = oneCol.hidden || false;
				if(oneCol.hidden == true){
					continue;
				}
				oneCol.align = oneCol.align || 'left';
				tdata = oneRowData[oneCol.index];
				if(oneCol.maxTextLen){
					if(oneCol.maxTextLen >= 2){
						tdata = SplitInputStr(tdata, oneCol.maxTextLen);
					}
				}
				//
				if(oneCol.align == 'left'){
					retTblStr += "<td valign='top' "
					if(oneCol.cellattr){
						retTblStr += "style='" + oneCol.cellattr(tdata, oneRowData) + "'";
					}
					retTblStr += ">" + tdata + "</td>";
				} else {
					retTblStr += "<td valign='top' align='"+ oneCol.align +"' "
					if(oneCol.cellattr){
						retTblStr += "style='" + oneCol.cellattr(tdata, oneRowData) + "'";
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

//=========================����Ϊ����==========================
//��ʽ��һ������ַ���
//�ڲ�����
function formatOneTabel(_options){
	if(_options.columns == undefined || _options.columns.length == 0 || _options.columns == null){
		return "<table><tr><td>colums undefined...</td></tr></table>";
	}
	//_options.fontSize = _options.fontSize || 12;
	if(_options.border == undefined){
		_options.border = 1;
	}
	if(isNaN(parseFloat(_options.border))){
		_options.border = 1;
	}
	
	if(_options.data){
		var retTblStr = "<table id='detailTbl' border='"+_options.border+"' cellspacing='0' cellpadding='0'";
		if(_options.fontSize){
			retTblStr += " style='font-size:" + val_pt(_options.fontSize) + ";' >"
		}
		retTblStr += "<thead><tr"
		if(_options.rowHeight){
			retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; //�����и�
		}
		retTblStr += ">";
		//set title
		var thdata = "";
		var oneCol = null;
		var myCols = _options.columns;
		var myColsLen = myCols.length;
		for(var i=0; i<myColsLen; i++){
			oneCol = myCols[i];
			if(oneCol.name == undefined || oneCol.index == undefined){
				return "<div>columns error...<div>";
			}
			oneCol.hidden = oneCol.hidden || false;
			if(oneCol.hidden == true){
				continue;
			}
			oneCol.width = oneCol.width || 50;
			oneCol.align = oneCol.align || 'left';
			thdata = oneCol.name;
			if(oneCol.maxTextLen){
				if(oneCol.maxTextLen >= 2){
					thdata = SplitInputStr(thdata, oneCol.maxTextLen);
				}
			}
			retTblStr += "<th style='width:" + val_mm(oneCol.width) + "' align='"+ oneCol.align +"'>" + thdata + "</th>";
		}
		retTblStr += "</tr></thead><tbody>";
		
		//set data
		var myData = _options.data || [];
		var myDayaLen = myData.length;
		if(myDayaLen == 0){
			return retTblStr;
		}
		var oneRowData = null;
		var tdata = "";
		for(var j=0; j<myDayaLen; j++){
			oneRowData = myData[j];
			retTblStr += "<tr";
			if(_options.rowHeight){
				retTblStr += " height='" + val_mm(_options.rowHeight) + "'"; //�����и�
			}
			retTblStr += ">";
			//
			for(var k=0; k<myColsLen; k++){
				oneCol = myCols[k];
				if(oneCol.name == undefined || oneCol.index == undefined){
					return "<div>columns error...<div>";
				}
				oneCol.hidden = oneCol.hidden || false;
				if(oneCol.hidden == true){
					continue;
				}
				oneCol.align = oneCol.align || 'left';
				tdata = oneRowData[oneCol.index];
				if(oneCol.maxTextLen){
					if(oneCol.maxTextLen >= 2){
						tdata = SplitInputStr(tdata, oneCol.maxTextLen);
					}
				}
				if(oneCol.align == 'left'){
					retTblStr += "<td valign='top' "
					if(oneCol.cellattr){
						retTblStr += "style='" + oneCol.cellattr(tdata, oneRowData) + "'";
					}
					retTblStr += ">" + tdata + "</td>";
				} else {
					retTblStr += "<td valign='top' align='"+ oneCol.align +"' "
					if(oneCol.cellattr){
						retTblStr += "style='" + oneCol.cellattr(tdata, oneRowData) + "'";
					}
					retTblStr += ">" + tdata + "</td>";
				}
			}
			retTblStr += "</tr>";
		}
		retTblStr += "</tbody></table>";
		return retTblStr;
	}
	return "<table><tr><td>no data...</td></tr></table>";
}

// ��ͷ��βTable�ַ���
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
    var tRowData, tCols, tColData;
    var tcolStyle = "";
    for (var i = 0; i < tRows; i++) {
        tRowData = tData[i];
        mainStr += "<tr>";
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
* Desc: ��ָ���ĳ��Ȳ���ַ���
* Input: inputStr - �ַ���; inputLength - Ϊż��,���ְ���2���ȼ���,Ӣ���ַ���һ�����ȼ���
* Output: ָ�����ȵ��ַ���
*/
function SplitInputStr(inputStr, inputLength) {
	if (inputStr == null){
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
		if(charlen <= inputLength){
			splitprintdesc = splitprintdesc + inputStr.charAt(chari);
		} else {
			return splitprintdesc;
		}
	}
	return inputStr;
}

// ��ȡ��������
function getDataType(val) {
    var ss = Object.prototype.toString;
    return ss.call(val);
}

//��ȡ��ǰҳ�������ֵ
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

// ��ȡת��ϵ��
function getHtmlFactor(){
	var htmlFactor = 1;
	if (!!window.ActiveXObject || "ActiveXObject" in window){
		var ratio = detectZoom();
		if(ratio > 100){
			var x = 1 - (100/ratio); //ҳ�汻�Ŵ�,��������С�ı���
			return 1 - x;
		} else if(ratio < 100){
			var x = (100/ratio) - 1; //ҳ�汻��С,������Ŵ�ı���
			return 1 + x;
		} else {
			return htmlFactor;
		}
	} else {
		return htmlFactor;
	}
}

// �ⲿ�������ű���
function printSize(val){
	return htmlFactor*val;
}

// ת��Ϊ����֮�����λ������3������
function val_mm(val){
	var valStr = val.toString();
	return valStr.indexOf("%")>0 ? valStr : ((val*htmlFactor) + "mm");
}
function val_px(val){
	var valStr = val.toString();
	return valStr.indexOf("%")>0 ? valStr : ((val*htmlFactor) + "px");
}
function val_pt(val){
	var valStr = val.toString();
	return valStr.indexOf("%")>0 ? valStr : ((val*htmlFactor) + "pt");
}

// ��ʼ�����ű���
htmlFactor = getHtmlFactor();