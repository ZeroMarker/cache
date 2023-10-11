var A4W = 210; //默认A4宽
var A4H = 297; //默认A4高
var rate = 2.5; //默认像素比率2
var tableOX = 5;  //表格左上角原点x
var tableOY = 35;   //表格左上角原点Y
var tableH = 165;  //表格高度
var tableW = 290;  //表格宽度
var borderWidth = 0.5;// 边框线宽度
var patInfoHeight = 10; //患者基本信息的高度
var leftRulerW = 20;  //左侧标尺宽度
var cellW = (tableW - leftRulerW) / 25; //上折线图小格宽度   (表格宽度-左侧标尺-右侧标尺)/26列  右侧标尺列和小格相等
var cellH = ((tableH / 3) * 2 - patInfoHeight) / 10; //上折线图小格高度   (表格高度/2-患者信息高度-折线图下信息高度)/10行
var TopH = (tableH / 3) * 2 //表格上半部分高度

/////表格上半部分折线图
var originX = tableOX + leftRulerW, originY = tableOY;;	//折线图原点坐标
var UnitTime = 3600, charLineWidth = 0.25; //一格的秒数 线宽
var txBaseVal = 180, txUnitVal = 10, txColor = "red", txSymbol = "●", txLineColor = "red"; //胎心 起始值、一格的值、符号颜色、符号、线颜色
var gkBaseVal = 11, gkUnitVal = 1, gkColor = "red", gkSymbol = "○", gkLineColor = "red"; //宫口 起始值、一格的值、符号颜色、符号、线颜色
var xlBaseVal = 6, xlUnitVal = 1, xlColor = "blue", xlSymbol = "×", xlLineColor = "blue"; //先露 起始值、一格的值、符号颜色、符号、线颜色

/////表格下半部分
var bottomText = ["血  压", "宫  缩", "备注", "签名", "时间"] //表格下半部分文字
var bottomColumnH = (tableH / 3) / bottomText.length  //表格下半部分每行的高度
var gridOX = originX, gridOY = tableOY + ((tableH / 3) * 2); //表格原点


if (SVG.supported) {
	var draw = SVG('drawing');
	var box = draw.viewbox({ x: 0, y: 0, width: A4H, height: A4W });
	drawCommonLine(draw);  //整体框架线
	drawChartHLine(draw);  // 折线图横线
	drawChartVLine(draw);  // 折线图竖线
	drawBotHLine(draw);  //画下半页横线
	drawBotVLine(draw);  //画下半页竖线
	drawStyleText(draw);  //画样式表格上的文字
	drawPatData();   //数据填充

} else {
	alert('SVG not supported')
}
/**
 * 画框架线,外边框/标尺/中间线/患者信息线
 */
function drawCommonLine(draw) {
	draw.line(tableOX, tableOY, tableOX + tableW, tableOY).stroke({ width: borderWidth }).attr('id', 'topBoder');  // 上边框    
	draw.line(tableOX, tableOY + tableH, tableOX + tableW, tableOY + tableH).stroke({ width: borderWidth }).attr('id', 'botBorder');  // 下边框
	draw.line(tableOX, tableOY, tableOX, tableOY + tableH).stroke({ width: borderWidth }).attr('id', 'leftBorder'); // 左边框    
	draw.line(tableOX + tableW, tableOY, tableOX + tableW, tableOY + tableH).stroke({ width: borderWidth }).attr('id', 'rightBorder');  // 右边框
	draw.line(tableOX + leftRulerW, tableOY + patInfoHeight, tableOX + tableW, tableOY + patInfoHeight).stroke({ width: borderWidth }).attr('id', 'patInfoBoder');  // 姓名等信息框的下边框
	draw.line(tableOX + leftRulerW, tableOY, tableOX + leftRulerW, tableOY + tableH).stroke({ width: borderWidth }).attr('id', 'leftRulerLine');  // 左侧标尺线
}
/**
 * 画折线图横线
 */
function drawChartHLine(draw) {
	for (i = 1; i <= 10; i++) {  //折线图横线
		if (i == 5) {
			draw.line(tableOX + leftRulerW, i * cellH + tableOY + patInfoHeight, tableOX + tableW, i * cellH + tableOY + patInfoHeight).stroke({ width: borderWidth, color: 'black' }).attr('id', 'chartHline' + i);
		} else {
			draw.line(tableOX + leftRulerW, i * cellH + tableOY + patInfoHeight, tableOX + tableW, i * cellH + tableOY + patInfoHeight).stroke({ width: borderWidth, color: 'black' }).attr('id', 'chartHline' + i);
		}

	}
	draw.line(tableOX, 10 * cellH + tableOY + patInfoHeight, tableOX + tableW, 10 * cellH + tableOY + patInfoHeight).stroke({ width: borderWidth }).attr('id', 'chartHline' + 11);
}

/**
 * 画折线图纵线
 */
function drawChartVLine(draw) {
	for (i = 1; i <= 25; i++) {  //折线图纵线
		draw.line(i * cellW + tableOX + leftRulerW, tableOY + patInfoHeight - patInfoHeight, i * cellW + tableOX + leftRulerW, 10 * cellH + tableOY + patInfoHeight).stroke({ width: borderWidth }).attr('id', 'chartHline' + i);
	}
}

/**
 * 画产程图下半页横线
 */
function drawBotHLine(draw) {

	var charTop = 10 * cellH + patInfoHeight
	var bottomCell = (tableH - charTop) / (bottomText.length)
	for (i = 1; i <= (bottomText.length); i++) {
		drawText(draw, bottomText[i - 1], "SimSun", "4", "start", tableOX, tableOY + charTop + i * bottomCell - 5);
		draw.line(tableOX, tableOY + charTop + i * bottomCell, tableOX + tableW, tableOY + charTop + i * bottomCell).stroke({ width: borderWidth }).attr('id', 'chartHline' + i); //验签时间下横线
	}
}

/**
 * 画产程图下半页纵线
 */
function drawBotVLine(draw) {
	for (i = 1; i <= 25; i++) {  //折线图纵线
		draw.line(i * cellW + tableOX + leftRulerW, tableOY + TopH, i * cellW + tableOX + leftRulerW, tableOY + tableH).stroke({ width: borderWidth }).attr('id', 'pageBotVline' + i);
	}
}

function drawStyleText(draw) {
	drawText(draw, session['LOGON.HOSPDESC'], "SimSun", 8, "start", 100, 5);  //测试文字
	drawText(draw, "产  程  图", "SimSun", 8, "start", 140, 15, '1.50em', "bold");  //测试文字    
	drawLeftRulerText(draw);
	drawRightRulerText(draw, true);
	drawTimeRulerText(draw);
	var fontSize = 4;
	drawText(draw, "产程时间", "SimSun", fontSize, "start", tableOX, tableOY - 5);
}
/**
 * 绘制左侧标尺刻度文字
 * @param {*} draw 
 */
function drawLeftRulerText(draw) {
	var fontSize = 4;
	for (i = 0; i <= 10; i++) {
		if (i == 10) {
			drawText(draw, 10 - i + "", "SimSun", fontSize, "start", tableOX + 7, i * cellH + tableOY + patInfoHeight - 4);
		} else {
			drawText(draw, 10 - i + "", "SimSun", fontSize, "start", tableOX + 7, i * cellH + tableOY + patInfoHeight - 2);
		}
	}
	drawVText(draw, "宫", "SimSun", fontSize, "start", tableOX + 7, tableOY + 0.5, fontSize, "1.0", "normal");
	drawVText(draw, "○", "SimSun", fontSize, "start", tableOX + 7, tableOY + 5, fontSize, "1.0", "normal", "red");
	drawVText(draw, "先", "SimSun", fontSize, "start", tableOX, tableOY + 0.5, fontSize, "1.0", "normal");
	drawVText(draw, "×", "SimSun", fontSize, "start", tableOX, tableOY + 5, fontSize, "1.0", "bold", "blue");

}
/**
 * 绘制右侧标尺刻度文字
 * @param {*} draw 
 */
function drawRightRulerText(draw, transform) {
	var fontSize = 4;
	for (i = 0; i <= 10; i++) {
		var text = 0;
		if (transform) {
			text = 5 - i;
		} else {
			text = i - 5;
		}
		if (text > 0) text = "+" + text;
		if (i == 0) {
			drawText(draw, text + "", "SimSun", fontSize, "start", tableOX, i * cellH - cellH / 5 + tableOY + patInfoHeight);
		}
		else if (i == 10) {
			drawText(draw, text + "", "SimSun", fontSize, "start", tableOX, i * cellH + tableOY + patInfoHeight - 4);
		}
		else {
			drawText(draw, text + "", "SimSun", fontSize, "start", tableOX, i * cellH + tableOY + patInfoHeight - 2);
		}
	}
	var fontSize = 4;
	for (i = 0; i <= 10; i++) {
		if (i == 10) {
			drawText(draw, 170 - i * 10 + "", "SimSun", fontSize, "start", tableOX + 13, i * cellH + tableOY + patInfoHeight - 4);
		} else {
			drawText(draw, 170 - i * 10 + "", "SimSun", fontSize, "start", tableOX + 13, i * cellH + tableOY + patInfoHeight - 2);
		}
	}
	drawVText(draw, "胎", "SimSun", fontSize, "start", tableOX + 14, tableOY + 0.5, fontSize, "1.0", "normal");
	drawVText(draw, "●", "SimSun", fontSize, "start", tableOX + 14, tableOY + 5, fontSize, "1.0", "normal", "red");
}
/**
 * 绘制直线图底部时间刻度文字
 * @param {*} draw 
 */
function drawTimeRulerText(draw) {
	var fontSize = 4;
	var i = page == 1 ? 0 : 25
	for (; i < 25 * page; i++) {
		drawText(draw, i + "", "SimSun", fontSize, "start", (i % 25) * cellW + tableOX + leftRulerW - 2, tableOY - 5);
	}
}

/**
 * @description 打印
 */
function printSVG() {
	var LODOP = getLodop();
	LODOP.PRINT_INIT("产程图");
	var printData = document.getElementById("drawing").innerHTML;
	LODOP.SET_PRINT_PAGESIZE(2, 2100, 2970, "A4");
	LODOP.ADD_PRINT_HTM(0, 0, "40%", "100%", printData);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
	LODOP.PRINTA();
	//LODOP.PREVIEW();
}

/**
 * @description  获取产程图数据
 */
function drawPatData() {
	$cm({
		ClassName: "Nur.DHCNurCurve",
		MethodName: 'getPrintData',
		EpisodeID: EpisodeID,
		page: page || 1
	}, function (printData) {
		drawPatInfo(printData.patient);
		drawChartData(printData.chartData);
		drawGridData(printData.gridData);
	});
}

/**
 * @description 表头病人信息数据
 * @param {*} patient 
 */
function drawPatInfo(patient) {
	drawText(draw, "姓名:" + patient.name, "SimSun", 5, "start", tableOX, tableOY - 12, '1em', "bold");
	drawText(draw, "年龄:" + patient.age, "SimSun", 5, "start", tableOX + 60, tableOY - 12, '1em', "bold");
	drawText(draw, "产程开始时间:" + (patient.contraDateTime || ""), "SimSun", 5, "start", tableOX + 100, tableOY - 12, '1em', "bold");
	drawText(draw, "床号:" + patient.bedCode, "SimSun", 5, "start", tableOX + 200, tableOY - 12, '1em', "bold");
	drawText(draw, "住院号:" + patient.medicareNo, "SimSun", 5, "start", tableOX + 230, tableOY - 12, '1em', "bold");
	//drawText(draw,"检查时间","SimSun",4,"start",tableOX,tableOY+tableH+2,'1em',"normal");
	/*检查时间*/
	/*
	if (patient.contraDateTime != "")
	{
		var time = patient.contraDateTime.split(" ")[1]
		time = time.split(":")[0]
		var startPoint = parseInt(time) < 10 ? time.substring(1,2) : time
		var fontSize=4;
		var text = page==1 ? parseInt(startPoint) : (parseInt(startPoint)+25)%24
		for(i=0; i<25; i++){
			drawText(draw,((text%24) == 0 ? 24 : (text%24)) +"","SimSun",fontSize,"start", i*cellW+tableOX+leftRulerW-2,tableOY+tableH+2);
			text += 1
		}
	}
	*/
}

/**
 * @description 画折线
 * @param {*} chartData 
 * @returns 
 */
function drawChartData(chartData) {
	if (!chartData) return;
	drawTxChart(chartData.txData);
	drawGkChart(chartData.gkData);
	drawXlChart(chartData.xlData);
}

/**
 * @description 画胎心折线
 * @param {*} txData 
 * @returns 
 */
function drawTxChart(txData) {
	if (!txData) return;
	var preX = 0, preY = 0;
	for (i = 0; i < txData.length; i++) {
		var ivalue = txData[i].iValue.split("/")[0]
		var VAL = (txBaseVal - ivalue) / txUnitVal;
		var TIME = txData[i].timeVal / UnitTime;
		var y = originY + VAL * cellH;
		var x = originX + TIME * cellW;
		drawText(draw, txSymbol, "SimSun", 5, "start", x - 2.5, y - 2.5, '1em', "bold", txColor); //减去字体大小的一半，保证坐标点在符号的中心
		if (i != 0) {
			draw.line(preX, preY, x, y).stroke({ width: charLineWidth, color: txLineColor }).attr('id', 'txChar');
		}
		preX = x, preY = y;
	}

	//双胎心
	var preX = 0, preY = 0;
	for (i = 0; i < txData.length; i++) {
		var ivalue = txData[i].iValue.split("/")[1]
		if (!!ivalue)
		{
			var VAL = (txBaseVal - ivalue) / txUnitVal;
			var TIME = txData[i].timeVal / UnitTime;
			var y = originY + VAL * cellH;
			var x = originX + TIME * cellW;
			drawText(draw, txSymbol, "SimSun", 5, "start", x - 2.5, y - 2.5, '1em', "bold", txColor); //减去字体大小的一半，保证坐标点在符号的中心
			if (preX != 0) {
				draw.line(preX, preY, x, y).stroke({ width: charLineWidth, color: txLineColor }).attr('id', 'txChar');
			}
			preX = x, preY = y;
		}
	}
}

/**
 * @description 画宫口折线
 * @param {*} gkData 
 * @returns 
 */
function drawGkChart(gkData) {
	if (!gkData) return;
	var preX = originX, preY = originY + 11 * cellH, preValue = "";
	for (i = 0; i < gkData.length; i++) {
		var VAL = (gkBaseVal - gkData[i].iValue) / gkUnitVal;
		var TIME = gkData[i].timeVal / UnitTime;
		var y = originY + VAL * cellH;
		var x = originX + TIME * cellW;
		if ((gkData[i].iValue >= 3) && (preValue != "") && (preValue <= 3) && (preX != "")) {
			var warningY = originY + 8 * cellH
			var warningX = getPointX(warningY, preX, preY, x, y)
			draw.line(warningX, warningY, parseFloat(warningX) + 6 * cellW, originY + cellH).stroke({ width: charLineWidth, color: "gray" }).attr('id', 'gkChar');
			draw.line(parseFloat(warningX) + 4 * cellW, warningY, parseFloat(warningX) + 10 * cellW, originY + cellH).stroke({ width: charLineWidth, color: "gray" }).attr('id', 'gkChar');
		}
		if (gkData[i].noSymbol != "Y") {
			drawText(draw, gkSymbol, "SimSun", 5, "start", x - 2.5, y - 2.5, '1em', "bold", gkColor); //减去字体大小的一半，保证坐标点在符号的中心
		}
		draw.line(preX, preY, x, y).stroke({ width: charLineWidth, color: gkLineColor }).attr('id', 'gkChar');
		if (gkData[i].outFlag == "Y") {
			draw.line(x, y, x, y + cellH / 2).stroke({ width: charLineWidth, color: gkLineColor }).attr('id', 'gkChar');
			draw.line(x, y + cellH / 2, x + 1, y + cellH / 2 - 1).stroke({ width: charLineWidth, color: gkLineColor }).attr('id', 'gkChar');
			draw.line(x, y + cellH / 2, x - 1, y + cellH / 2 - 1).stroke({ width: charLineWidth, color: gkLineColor }).attr('id', 'gkChar');
		}
		if (!!gkData[i].printFullGKText) {
			drawText(draw, gkData[i].printFullGKText, "SimSun", 4, "start", x - 2.5, y - 6.5, '1em', "bold", "red");
		}
		if (!!gkData[i].printPregText) {
			drawText(draw, gkData[i].printPregText, "SimSun", 4, "start", x + 3.5, y + 2.5, '1em', "bold", "red");
		}
		preX = x, preY = y;
		preValue = gkData[i].iValue
	}
}

/**
 * @description 画先露高低折线
 * @param {*} xlData 
 * @returns 
 */
function drawXlChart(xlData) {
	// xlBaseVal xlUnitVal xlColor xlSymbol xlLineColor
	if (!xlData) return;
	var preX = originX, preY = originY + 11 * cellH;
	for (i = 0; i < xlData.length; i++) {
		var VAL = (xlBaseVal - xlData[i].iValue) / xlUnitVal; //坐标反着来加个负号
		var TIME = xlData[i].timeVal / UnitTime;
		var y = originY + VAL * cellH;
		var x = originX + TIME * cellW;
		drawText(draw, xlSymbol, "SimSun", 5, "start", x - 2.5, y - 2.5, '1em', "bold", xlColor); //减去字体大小的一半，保证坐标点在符号的中心
		draw.line(preX, preY, x, y).stroke({ width: charLineWidth, color: xlLineColor }).attr('id', 'txChar');
		preX = x, preY = y;
	}
}

/**
 * @description 画下半部分表格数据
 * @param {*} gridData 
 * @returns 
 */
function drawGridData(gridData) {
	if (!gridData) return;
	for (i = 0; i < gridData.length; i++) {
		var x = gridOX + gridData[i].rowNum * cellW;
		var y = gridOY
		var PregBlood = gridData[i].PregBlood
		if (!!PregBlood && PregBlood.indexOf("/") > -1) {
			var PregBloodList = PregBlood.split("/")
			drawText(draw, PregBloodList[0] + "/", "SimSun", 4, "start", x + 1, y + 4, '1em', "normal");
			drawText(draw, PregBloodList[1], "SimSun", 4, "start", x + 1, y + 8, '1em', "normal");
		} else {
			drawText(draw, PregBlood, "SimSun", 4, "start", x + 1, y + 4, '1em', "normal");
		}
		var PregFrequency = gridData[i].PregFrequency
		if (!!PregFrequency && PregFrequency.indexOf("/") > -1) {
			var PregFrequencyList = PregFrequency.split("/")
			drawText(draw, PregFrequencyList[0] + "/", "SimSun", 4, "start", x + 1, y + bottomColumnH + 4, '1em', "normal");
			drawText(draw, PregFrequencyList[1], "SimSun", 4, "start", x + 1, y + bottomColumnH + 8, '1em', "normal");
		} else {
			drawText(draw, PregFrequency, "SimSun", 4, "start", x + 1, y + bottomColumnH + 4, '1em', "normal");
		}
		drawText(draw, gridData[i].PregHandle, "SimSun", 3, "start", x + 1, y + bottomColumnH * 2 + 4, '1em', "normal");
		// draw,content,family,size,anchor,x,y,leading,weight,color
		// draw,content,width,family,size,alignment,color,x,y,leading,weight,id,maxRows,printed
		drawTextWrap(draw, gridData[i].PregUserID, cellW, "SimSun", 3, "start", "", x + 1, y + bottomColumnH * 3 + 4, '1em', "normal", "", 2)
		drawText(draw, gridData[i].PregTime, "SimSun", 3, "start", x + 1, y + bottomColumnH * 4 + 4, '1em', "normal");
	}
}

/**
 * @description 用来计算画处理线和警戒线坐标用
 */
function getPointX(y, x1, y1, x2, y2) {
	var a = ((y2 - y1) / (x2 - x1)).toFixed(2)
	var b = y1 - a * x1
	var x = ((y - b) / a).toFixed(2)
	return x
}