var COL = []

var A4W = 210; // A4
var A4H = 297; //  A4
var FONTRATE = 3;
var OPOINT = { //原点  表格左上角点
    X: 8, //表格左上角点x坐标
    Y: 25 // 表格右上角点y坐标
}

var COL_W = (function () { //计算所有列的宽度
    var sum = 0;
    COL.forEach(function (single) {
        sum += parseInt(single.width);
    });
    return sum;
})();



var title = []

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

var DateTimeStyle="1"

var PageNumShow = "第 {currentPage} 页"

var totalPage=""

/*========================================================================================== */



function darwLongTableBak(sheet) {
    drawTableHead();
    if (sheet.pages != null && sheet.pages.length > 0) {
        var pageObj = sheet.pages[parseInt(page) - 1];
        drawLongOrders(pageObj.orders);
    }
    if (sheet.images != null && sheet.images.length > 0) {
        drawLogoImage(tabStyle.images);
    }
}

function initTable(SheetConfig,TextConfig,GeneralConfig)
{	
	COL = SheetConfig
	COL_W = (function () { //计算所有列的宽度
	    var sum = 0;
	    COL.forEach(function (single) {
	        sum += parseInt(single.width);
	    });
	    return sum;
	})();
	ROW.W = COL_W
	title = TextConfig
	var TableLocation = GeneralConfig.TableLocation
	if (!!TableLocation)
	{
		OPOINT.X = parseFloat(TableLocation.tableX) || OPOINT.X
		OPOINT.Y = parseFloat(TableLocation.tableY) || OPOINT.Y
		ROW.H = parseFloat(TableLocation.rowHeight) || ROW.H
	}
	if (!!GeneralConfig.DateTimeStyle)
	{
		DateTimeStyle = GeneralConfig.DateTimeStyle
	}
	if (!!GeneralConfig.PageNumShow)
	{
		PageNumShow = GeneralConfig.PageNumShow
	}
	if (!!GeneralConfig.totalPage)
	{
		totalPage = GeneralConfig.totalPage
	}
	
}

function drawTable(pageObj) {
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
	var orders = setDateTimeStyle(orders)
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
    /*
    order.children.forEach(function(child){
        drawOrderTexts(order,child);
        drawVLine();
        drawHLine();
    });
    */
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
        if (!!order[single.code])
        {
	        if (single.code == "ordName") {
	            drawTextWrap(draw, order[single.code], width-1, single.itemFontFamily, parseFloat(single.itemFontSize), single.itemFontAlign, FONT.COLOR, curX+1, y, "", single.itemFontWeight, order.row, 2, order[single.code + "_Print"]);
	            /*画其他信息 eg.--撤销医嘱*/
	            if (!!order.otherMsg) {
	                drawTextWrap(draw, order.otherMsg, width / 2, single.itemFontFamily, parseFloat(single.itemFontSize) - 0.5, single.itemFontAlign, FONT.COLOR, curX + width / 2, y + ROW.H / 2 - 0.5, "", single.itemFontWeight, order.row, 2, order["otherMsg_Print"]);
	            }
	        } else {
				if (single.columnName.indexOf($g("签名")) > -1) {
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
							drawTextWrap(draw, singleDesc, width, single.itemFontFamily, parseFloat(single.itemFontSize), single.itemFontAlign, FONT.COLOR, curX, y + i * ( ROW.H / length ) - moveY, "", single.itemFontWeight, order.row, 2, order[single.code + "_Print"]);
						}
						
					}
				} else {
					var text = order[single.code]
					
					drawTextWrap(draw, text, width, single.itemFontFamily, parseFloat(single.itemFontSize), single.itemFontAlign, FONT.COLOR, curX, y, "", single.itemFontWeight, order.row, 2, order[single.code + "_Print"]);
					
				}
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
    draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_h_line_' + ROWNUM).attr('class', IfPrinted ? 'printed' : 'unPrinted');
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
    draw.line(x1, y1, x2, y2).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('id', 'sheet_v_line_' + ROWNUM + "_col_0").attr('class', IfPrinted ? 'printed' : 'unPrinted');
    var i = 1;
    COL.forEach(function (single) {
        x1 = x1 + parseFloat(single.width);
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
            x_3Col += parseFloat(COL[i].width);
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
function darwContent(tabContent) {
    if (tabContent.lines != null && tabContent.lines.length > 0) {
        drawLines(tabContent.lines);
    }
    if (tabContent.texts != null && tabContent.texts.length > 0) {
        drawTexts(tabContent.texts);
    }
    return;
}
function darwCurve(tabCurve) {
    if (tabCurve.lines != null && tabCurve.lines.length > 0) {
        debugger;
        drawLines(tabCurve.lines);
    }
    if (tabCurve.texts != null && tabCurve.texts.length > 0) {
        drawTexts(tabCurve.texts);
    }
    if (tabCurve.points != null && tabCurve.points.length > 0) {
        drawPoints(tabCurve.points);
    }
    if (tabCurve.paths != null && tabCurve.paths[0] != null && tabCurve.paths[0].length > 0) {
        fillPath(tabCurve.paths);
    }
    return;
}

function drawLines(lines) {
    var i = 0;
    lines.forEach(function (line) {
        if (line.breakLineFlag == "N") {
            draw.line(line.x1, line.y1, line.x2, line.y2).stroke({ width: line.width, color: line.color }).attr('id', 'chartline' + i);
            i++;
        }

    });
}

function drawTexts(texts) {
    var i = 0;
    texts.forEach(function (text) {
        drawText(draw, text.content + "", text.width, text.fontFamily, text.fontSize / FONTRATE, text.alignment, text.fontColor, text.x, text.y, "", text.fontStyle, "text" + i);
        i++;
    });
}

function drawLogoImage(image) {
    var imageSVG = draw.image(image.image, image.width, image.height);
    imageSVG.attr('class', IfPrinted ? 'printed' : 'unPrinted')
    imageSVG.move(image.x, image.y);
}


/**
 * 绘制长期医嘱单表头
 * 
 */
function drawTableHead() {

    function drawHeadLine(x, y, x1, y1) {
        draw.line(x, y, x1, y1).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('class', IfPrinted ? 'printed' : 'unPrinted');

    }

    function drawHeadText(text, x, y, width, single) {
        drawText(draw, $g(text), width, single.textFontFamily, single.textFontSize, single.textFontAlign, FONT.COLOR, x, y, "", single.textontWeight, "head_1", IfPrinted);
    }
    drawHeadLine(OPOINT.X, OPOINT.Y, ROW.W + OPOINT.X, OPOINT.Y) //第一条横线
    drawHeadLine(OPOINT.X, OPOINT.Y, OPOINT.X, OPOINT.Y + 2 * ROW.H) //左边纵线

    var curX = OPOINT.X, firstRow = {}
    COL.forEach(function (single) {
        var width = parseInt(single.width)
        if (!!single.upperHeader) {
            if (!!firstRow[single.upperHeader]) {
                firstRow[single.upperHeader].width += width
            } else {
                firstRow[single.upperHeader] = { x: curX, width: width, single:single }
            }
            drawHeadText(single.columnName, curX, OPOINT.Y + ROW.H, width,single)
            drawHeadLine(curX, OPOINT.Y + ROW.H, curX + width, OPOINT.Y + ROW.H)
            curX += width
            drawHeadLine(curX, OPOINT.Y + ROW.H, curX, OPOINT.Y + 2 * ROW.H)
        } else {
            drawHeadText(single.columnName, curX, OPOINT.Y + ROW.H - 4, width, single)
            curX += width
            drawHeadLine(curX, OPOINT.Y, curX, OPOINT.Y + 2 * ROW.H)
        }

    })

    $.each(firstRow, function (key, value) {
        drawHeadText(key.replace("_", ""), value.x, OPOINT.Y, value.width, value.single)
        drawHeadLine(value.x + value.width, OPOINT.Y, value.x + value.width, OPOINT.Y + ROW.H)
    })
    drawHeadLine(OPOINT.X, OPOINT.Y + 2 * ROW.H, ROW.W + OPOINT.X, OPOINT.Y + 2 * ROW.H) //第一条横线
    ROWNUM = ROWNUM + 2;


}

/**
 * 绘制长期医嘱单表头
 * 
 */
function drawPatInfo(patInfo) {
	
	title.forEach(function(single){
		var text=""
		if (!!single["text"]){
			text = single["text"]
			drawTextWrap(draw, $g(text), parseFloat(single.textWidth), single.textFontFamily, parseFloat(single.textFontSize), single.textFontAlign, FONT.COLOR, parseFloat(single.printX), parseFloat(single.printY), "", single.textFontWeight, "patInfo", 2, IfPrinted,  "")
		}
		if (!!single["code"]){
			text = patInfo[single["code"]]
			drawTextWrap(draw, text, parseFloat(single.itemWidth), single.itemFontFamily, parseFloat(single.itemFontSize), single.itemFontAlign, FONT.COLOR, parseFloat(single.printX) + parseFloat(single.textWidth || 0) , parseFloat(single.printY), "", single.itemFontWeight, "patInfo", 2, IfPrinted, single.itemUnderline || "")
		}
	})
	
	/*
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
    */
    /*
    var yPY = 6;
    var textContent = "姓名：" + patInfo.name + " 性别：" + patInfo.sex + " 年龄：" + patInfo.age + " 床号：" + patInfo.bedCode + " 登记号：" + patInfo.regNo
        + " 科别：" + patInfo.loc + " 病区：" + patInfo.ward + " 病案号：" + patInfo.medcareNO;
    drawText(draw, textContent, COL_W, FONT.FAMILY, FONT.SIZE, "", FONT.COLOR, OPOINT.X, OPOINT.Y - yPY, "", "normal", "patInfo", IfPrinted);
    drawText(draw, patInfo.hospital, COL_W, FONT.FAMILY, FONT.SIZE + 2, "Center", FONT.COLOR, OPOINT.X, OPOINT.Y - 20, "", "normal", "patInfo", IfPrinted);
    drawText(draw, $g("长期医嘱单"), COL_W, FONT.FAMILY, FONT.SIZE + 2, "Center", FONT.COLOR, OPOINT.X, OPOINT.Y - 15, "", "normal", "patInfo", IfPrinted);
    */
}


/**
 * 绘制长期医嘱单表头
 * 
 */
function drawPageNum(num) {
    //var yPY=26;    
    var textContent =  $g(replacePageNumber(num,totalPage,PageNumShow))
    drawText(draw, textContent, COL_W, FONT.FAMILY, FONT.SIZE + 1, "Center", FONT.COLOR, OPOINT.X, A4H - 3*ROW.H, "", "normal", "patInfo", IfPrinted);
}


function replacePageNumber(currentPage, totalPage, text) {
  var replacedText = text.replace('{currentPage}', currentPage);
  replacedText = replacedText.replace('{totalPage}', totalPage);
  return replacedText;
}


function setDateTimeStyle(orders)
{
	var tempOrders = $.extend(true, [], orders);
	$.each(orders,function(i,single){
		if (i==0)
		{
			return true
		}
		var curDate = single.ordDate
		var curTime = single.ordTime
		var preDate = tempOrders[i-1].ordDate
		var preTime = tempOrders[i-1].ordTime
		var nextDate=""
		var nextTime=""
		if ( i != (orders.length - 1) )
		{
			nextDate = orders[i+1].ordDate
			nextTime = orders[i+1].ordTime
		}
		var value = getValueByStyleConfig(curDate,curTime,preDate,preTime,nextDate,nextTime)
		orders[i].ordDate = value.split("@")[0]
		orders[i].ordTime = value.split("@")[1]
		
	})
	return orders
}

/**
 * 根据 日期时间显示模式配置 获取数据
 * 
 */
function getValueByStyleConfig(curDate,curTime,preDate,preTime,nextDate,nextTime)
{
	//不显示横线
	if (DateTimeStyle == "1")
	{
		return curDate + "@" + curTime
	}
	//日期或时间相同显示横线
	if (DateTimeStyle == "2")
	{
		if (curDate == preDate)
		{
			curDate = "---"		
		}
		if (curTime == preTime)
		{
			curTime = "---"
		}
		return curDate + "@" + curTime
	}
	//日期和时间相同显示横线
	if (DateTimeStyle == "3")
	{
		if (curDate==preDate && curTime==preTime)
		{
			curDate = "---"	
			curTime = "---"
			return curDate + "@" + curTime
		}
	}
	//日期和时间相同中间医嘱显示横线
	if (DateTimeStyle == "4")
	{
		if (curDate==preDate && curTime==preTime && curDate==nextDate && curTime==nextTime)
		{
			curDate = "---"	
			curTime = "---"
			return curDate + "@" + curTime
		}
	}
	return curDate + "@" + curTime
	
}