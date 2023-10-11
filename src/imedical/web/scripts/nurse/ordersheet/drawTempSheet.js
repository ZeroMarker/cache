var COL = [
	{
		code: "ordDate",
		text: $g("日期"),
		width: 20
	},
	{
		code: "ordTime",
		text: $g("时间"),
		width: 17
	},
	{
		code: "ordName",
		text:  $g("医嘱"),
		width: 101
	},
	{
		code: "ordDoctor",
		text: $g("医生签名"),
		width: 18,
	},
	{
		code: "execNurse",
		text: $g("护士签名"),
		width: 18,
	},
	{
		code: "execDateTime",
		text: $g("时间"),
		width: 20,
	}
]


var A4W = 210; // A4
var A4H = 297; //  A4
var FONTRATE = 3;
var OPOINT = { //原点  表格左上角点
	X: 8, //表格左上角点x坐标
	Y: 25 // 表格右上角点y坐标
}
//var PAGE_TOTAL_ROWS=30 //包含表头，定义一张纸一共多少行

var COL_W = (function () { //计算所有列的宽度
	var sum = 0;
	COL.forEach(function (single) {
		sum += parseInt(single.width);
	});
	return sum;
})();


var title = [
	{
		text : "",
		code : "hospital",
		fontSize : 5,
		fontWeight : "Bold",
		alignment : "Center",
		width : COL_W,
		x : OPOINT.X,
		y : 5
	},
	{
		text : $g("临时医嘱单"),
		fontSize : 5,
		fontWeight : "Bold",
		alignment : "Center",
		width : COL_W,
		x : OPOINT.X,
		y : 10
	},
	{
		text : $g("姓名:"),
		fontSize : 3,
		width : 8,
		x : 8,
		y : 18
	},
	{
		code : "name",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 14,
		x : 16,
		y : 18
	},
	{
		text : $g("性别:"),
		fontSize : 3,
		width : 8,
		x : 30,
		y : 18
	},
	{
		code : "sex",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 7,
		x : 38,
		y : 18
	},
	{
		text : $g("年龄:"),
		fontSize : 3,
		width : 8,
		x : 45,
		y : 18
	},
	{
		code : "age",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 8,
		x : 53,
		y : 18
	},
	{
		text : $g("床号:"),
		fontSize : 3,
		width : 8,
		x : 60,
		y : 18
	},
	{
		code : "bedCode",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 8,
		x : 68,
		y : 18
	},
	{
		text : $g("登记号:"),
		fontSize : 3,
		width : 11,
		x : 75,
		y : 18
	},
	{
		code : "regNo",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 20,
		x : 86,
		y : 18
	},
	{
		text : $g("科别:"),
		fontSize : 3,
		width : 8,
		x : 106,
		y : 18
	},
	{
		code : "loc",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 30,
		x : 114,
		y : 18
	},
	{
		text : $g("病区:"),
		fontSize : 3,
		width : 8,
		x : 144,
		y : 18
	},
	{
		code : "ward",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 30,
		x : 152,
		y : 18
	},
	{
		text : $g("病案号:"),
		fontSize : 3,
		width : 11,
		x : 182,
		y : 18
	},
	{
		code : "medcareNO",
		fontSize : 3,
		fontWeight : "Bold",
		underline : true,
		width : 20,
		x : 193,
		y : 18
	}
]


var ROW = {
	H: 8, //医嘱单行高度
	W: COL_W //医嘱单行宽度
};
var ROWNUM = 0;
var HEAD_ROW_NUM = 2;  //表头占的行数
var LINE = {
	WIDTH: 0.3,
	COLOR: "blue"
}

var FONT = {
	FAMILY: "黑体",
	SIZE: 3,
	COLOR: "Blue"
}

var IfPrinted = false //判断本页是否打印过

/*========================================================================================== */

function drawTempTable(pageObj) {

	if (!!pageObj.orders[0].ordName_Print) {
		IfPrinted = true
	}

	drawTableHead();
	//return;
	if (pageObj.orders != null && pageObj.orders.length > 0) {
		if (!!LogoImage) {
			drawLogoImage(LogoImage);
		}
		drawOrders(pageObj.orders);
		drawPatInfo(pageObj.patinfo);
		drawPageNum(pageObj.page);
	}
}

function drawOrders(orders) {
	orders.forEach(function (order) {
		drawOrder(order);
	});
	if (ROWNUM < PAGE_TOTAL_ROWS) {
		var curEndRow = ROWNUM;
		for (var i = 0; i < (PAGE_TOTAL_ROWS - curEndRow); i++) {
			drawVLine();
			drawHLine();
		}
	}
}

function drawOrder(order) {
	drawOrderTexts(order);
	drawTeamLine(order);
	drawVLine();
	drawHLine();
    if (!!order.ordBottomRedLine) {
        drawBottomRedLine()
    }
    if (!!order.ordTopRedLine) {
        drawTopRedLine()
    }
	var i = 0;
}

var preOrdDate="",preOrdTime=""
/**
* 绘制医嘱对应的文字信息
*/
function drawOrderTexts(order, child) {
	var y = OPOINT.Y + ROW.H * ROWNUM
	var orderName = child || order.ordName;
	var curX = OPOINT.X
	COL.forEach(function (single) {
		var width = parseInt(single.width)
		if (single.code == "ordName") {
			drawTextWrap(draw, order[single.code], width-1, FONT.FAMILY, FONT.SIZE, "start", FONT.COLOR, curX+1, y, "", "normal", order.row, 2, order[single.code + "_Print"]);
			/*画其他信息 eg.--撤销医嘱*/
			if (!!order.otherMsg) {
				drawTextWrap(draw, order.otherMsg, width / 2, FONT.FAMILY, FONT.SIZE - 0.5, "start", FONT.COLOR, curX + width / 2, y + ROW.H / 2 - 0.5, "", "normal", order.row, 2, order["otherMsg_Print"]);
			}
		} else {
			if (single.text.indexOf("签名") > -1) {
				var desc = order[single.code]
				var descList = desc.split("/")
				var moveY = 0
				if (descList.length > 1)
				{
					moveY = 1
				}
				for (var i=0, length = descList.length; i < length; i++)
				{
					var singleDesc=descList[i]
					if (!!CAImages[singleDesc]) {
						drawImage(draw, CAImages[singleDesc], width, ROW.H/length, curX, y + i * ( ROW.H / length ), order.row, order[single.code + "_Print"]);
					} else {
						drawTextWrap(draw, singleDesc, width, FONT.FAMILY, FONT.SIZE, "Center", FONT.COLOR, curX, y + i * ( ROW.H / length ) - moveY, "", "normal", order.row, 2, order[single.code + "_Print"]);
					}
					
				}
			} else {
				var text = order[single.code]
				if (single.code == "ordDate")
				{
					//相同的日期和时间 画 --- 
					if (order[single.code] == preOrdDate)
					{
						text = "----"
					}
					
					preOrdDate=order[single.code]
				} 
				if(single.code == "ordTime")
				{
					if (order[single.code] == preOrdTime)
					{
						text = "----"
					}
					preOrdTime=order[single.code]
				}
				
				drawTextWrap(draw, text, width, FONT.FAMILY, FONT.SIZE, "Center", FONT.COLOR, curX, y, "", "normal", order.row, 2, order[single.code + "_Print"]);
			}
		}
		curX += width
	})

	drawRect(draw, OPOINT.X, y, ROW.W, ROW.H, "red", "unClicked", "rect_row_" + order.row)
	$("#rect_row_" + order.row).click(function () {
		$(this).attr("class") == "clicked" ? $(this).attr("class", "unClicked") : $(this).attr("class", "clicked")
	})
}


/**
* 画医嘱下横线红色线
*/
function drawBottomRedLine() {
	var x1 = OPOINT.X;
	var y1 = OPOINT.Y + (ROWNUM) * ROW.H;
	var x2 = ROW.W + OPOINT.X
	var y2 = y1;
	draw.line(x1, y1, x2, y2).stroke({ width: "0.8", color: "red" }).attr('id', 'sheet_h_line_' + ROWNUM);
}

/**
* 画医嘱上横线红色线
*/
function drawTopRedLine()
{
	var x1 = OPOINT.X;
    var y1 = OPOINT.Y + (ROWNUM-1) * ROW.H;
    var x2 = ROW.W + OPOINT.X
    var y2 = y1;
    draw.line(x1, y1, x2, y2).stroke({ width: "0.8", color: "red" }).attr('id', 'sheet_h_line_' + ROWNUM-1);
}

/**
* 画医嘱下横线
*/
function drawHLine() {
	var x1 = OPOINT.X;
	var y1 = OPOINT.Y + (ROWNUM + 1) * ROW.H;
	var x2 = ROW.W + OPOINT.X
	var y2 = y1;
	draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_h_line_' + ROWNUM).attr("class", IfPrinted ? 'printed' : 'unPrinted');
	ROWNUM = ROWNUM + 1;
}

/**
* 画列纵线
*/
function drawVLine() {
	var x1 = OPOINT.X;
	var y1 = OPOINT.Y + ROWNUM * ROW.H;;
	var x2 = x1;
	var y2 = OPOINT.Y + (ROWNUM + 1) * ROW.H;
	draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr("class", IfPrinted ? 'printed' : 'unPrinted');
	var i = 1;
	COL.forEach(function (single) {
		x1 = x1 + single.width;
		x2 = x1;
		draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_" + i).attr('class', IfPrinted ? 'printed' : 'unPrinted');
		i++;
	});
}
/**
* 画医嘱成组线
*/
function drawTeamLine(order) {
	if (!!order.groupFlag) {
		var ifGroupLinePrinted = !!order.ordName_Print
		var x_3Col = 0;
		for (var i = 0; i < 3; i++) {
			x_3Col += COL[i].width;
		}
		if (order.groupFlag == "T") {
			var x1 = x_3Col - 2 + OPOINT.X;
			var y1 = OPOINT.Y + ROWNUM * ROW.H + ROW.H / 2;
			var x2 = x1;
			var y2 = OPOINT.Y + ROWNUM * ROW.H + ROW.H;
			draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: "Red" }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr('class', ifGroupLinePrinted ? "printed" : "");
			draw.line(x1 - 1.5, y1, x2, y1).stroke({ width: LINE.WIDTH, color: "Red" }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr('class', ifGroupLinePrinted ? "printed" : "");
		}

		if (order.groupFlag == "M") {
			var x1 = x_3Col - 2 + OPOINT.X;
			var y1 = OPOINT.Y + ROWNUM * ROW.H;
			var x2 = x1;
			var y2 = OPOINT.Y + ROWNUM * ROW.H + ROW.H;
			draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: "Red" }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr('class', ifGroupLinePrinted ? "printed" : "");
		}

		if (order.groupFlag == "B") {
			var x1 = x_3Col - 2 + OPOINT.X;
			var y1 = OPOINT.Y + ROWNUM * ROW.H + ROW.H / 2;
			var x2 = x1;
			var y2 = OPOINT.Y + ROWNUM * ROW.H;
			draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: "Red" }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr('class', ifGroupLinePrinted ? "printed" : "");
			draw.line(x1 - 1.5, y1, x2, y1).stroke({ width: LINE.WIDTH, color: "Red" }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr('class', ifGroupLinePrinted ? "printed" : "");
		}

	}
}

function drawLogoImage(image) {
	var imageSVG = draw.image(image.image, image.width, image.height);
	imageSVG.attr('class', IfPrinted ? 'printed' : 'unPrinted')
	imageSVG.move(image.x, image.y);
}


/**
 * 绘制临时医嘱单表头
 * 
 */
function drawTableHead() {
	function drawHeadLine(x, y, x1, y1) {
		draw.line(x, y, x1, y1).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('class', IfPrinted ? 'printed' : 'unPrinted');

	}

	function drawHeadText(text, x, y, width) {
		drawText(draw, text, width, FONT.FAMILY, FONT.SIZE, "Center", FONT.COLOR, x, y, "", "normal", "head_1", IfPrinted);
	}
	drawHeadLine(OPOINT.X, OPOINT.Y, ROW.W + OPOINT.X, OPOINT.Y) //第一条横线
	drawHeadLine(OPOINT.X, OPOINT.Y, OPOINT.X, OPOINT.Y + 2 * ROW.H) //左边纵线

	var curX = OPOINT.X, firstRow = {}
	COL.forEach(function (single) {
		var width = parseInt(single.width)
		if (!!single.topText) {
			if (!!firstRow[single.topText]) {
				firstRow[single.topText].width += width
			} else {
				firstRow[single.topText] = { x: curX, width: width }
			}
			drawHeadText(single.text, curX, OPOINT.Y + ROW.H, width)
			drawHeadLine(curX, OPOINT.Y + ROW.H, curX + width, OPOINT.Y + ROW.H)
			curX += width
			drawHeadLine(curX, OPOINT.Y + ROW.H, curX, OPOINT.Y + 2 * ROW.H)
		} else {
			drawHeadText(single.text, curX, OPOINT.Y + ROW.H - 4, width)
			curX += width
			drawHeadLine(curX, OPOINT.Y, curX, OPOINT.Y + 2 * ROW.H)
		}

	})

	$.each(firstRow, function (key, value) {
		drawHeadText(key.replace("_", ""), value.x, OPOINT.Y, value.width)
		drawHeadLine(value.x + value.width, OPOINT.Y, value.x + value.width, OPOINT.Y + ROW.H)
	})
	drawHeadLine(OPOINT.X, OPOINT.Y + 2 * ROW.H, ROW.W + OPOINT.X, OPOINT.Y + 2 * ROW.H) //第一条横线
	ROWNUM = ROWNUM + 2;
}

/**
* 画医嘱下横线
*/
function drawHeadHLine() {
	var x1 = OPOINT.X;
	var y1 = OPOINT.Y + (ROWNUM + 2) * ROW.H;
	var x2 = ROW.W + OPOINT.X
	var y2 = y1;

	draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_h_line_' + ROWNUM).attr('class', IfPrinted ? 'printed' : 'unPrinted');


	ROWNUM = ROWNUM + 2;
}

/**
* 画表头列纵线 临时医嘱单表头栈两行
*/
function drawHeadVLine() {
	var x1 = OPOINT.X;
	var y1 = OPOINT.Y + ROWNUM * ROW.H;
	var x2 = x1;
	var y2 = OPOINT.Y + (ROWNUM + 2) * ROW.H;

	draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr('class', IfPrinted ? 'printed' : 'unPrinted');

	var i = 1;
	COL_W_ARRAY.forEach(function (colW) {
		x1 = x1 + colW;
		x2 = x1;
		draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_" + i).attr('class', IfPrinted ? 'printed' : 'unPrinted');

		i++;
	});
}
/**
 * 绘制临时医嘱单表头
 * 
 */
function drawPatInfo(patInfo) {
	
	title.forEach(function (single) {
	var text = ""
	if (!!single["text"]){
		text = single["text"]
	}
	if (!!single["code"]){
		text = patInfo[single["code"]]
	}
	drawTextWrap(draw, text, single["width"], FONT.FAMILY, single["fontSize"], single["alignment"] || "", FONT.COLOR, single["x"], single["y"], "", single["fontWeight"] || "", "patInfo", 2, IfPrinted, single["underline"] || "")
	});
	
	/*
	var yPY = 6;
	var textContent = "姓名：" + patInfo.name + " 性别：" + patInfo.sex + " 年龄：" + patInfo.age + " 床号：" + patInfo.bedCode + " 登记号：" + patInfo.regNo
		+ " 科别：" + patInfo.loc + " 病区：" + patInfo.ward + " 病案号：" + patInfo.medcareNO;
	drawText(draw, textContent, COL_W, FONT.FAMILY, FONT.SIZE, "", FONT.COLOR, OPOINT.X, OPOINT.Y - yPY, "", "normal", "patInfo", IfPrinted);
	drawText(draw, patInfo.hospital, COL_W, FONT.FAMILY, FONT.SIZE + 2, "Center", FONT.COLOR, OPOINT.X, OPOINT.Y - 20, "", "normal", "patInfo", IfPrinted);
	drawText(draw, $g("临时医嘱单"), COL_W, FONT.FAMILY, FONT.SIZE + 2, "Center", FONT.COLOR, OPOINT.X, OPOINT.Y - 15, "", "normal", "patInfo", IfPrinted);
	*/
}


/**
 * 绘制临时医嘱单表头
 * 
 */
function drawPageNum(num) {
	//var yPY=26;    
	var textContent = $g("第")+" " + num + " "+$g("页")
	drawText(draw, textContent, COL_W, FONT.FAMILY, FONT.SIZE + 1, "Center", FONT.COLOR, OPOINT.X, A4H - 3*ROW.H, "", "normal", "patInfo", IfPrinted);
}