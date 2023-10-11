var COL = [
	{
		code: "ordDate",
		text: $g("����"),
		width: 20
	},
	{
		code: "ordTime",
		text: $g("ʱ��"),
		width: 17
	},
	{
		code: "ordName",
		text:  $g("ҽ��"),
		width: 101
	},
	{
		code: "ordDoctor",
		text: $g("ҽ��ǩ��"),
		width: 18,
	},
	{
		code: "execNurse",
		text: $g("��ʿǩ��"),
		width: 18,
	},
	{
		code: "execDateTime",
		text: $g("ʱ��"),
		width: 20,
	}
]


var A4W = 210; // A4
var A4H = 297; //  A4
var FONTRATE = 3;
var OPOINT = { //ԭ��  ������Ͻǵ�
	X: 8, //������Ͻǵ�x����
	Y: 25 // ������Ͻǵ�y����
}
//var PAGE_TOTAL_ROWS=30 //������ͷ������һ��ֽһ��������

var COL_W = (function () { //���������еĿ��
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
		text : $g("��ʱҽ����"),
		fontSize : 5,
		fontWeight : "Bold",
		alignment : "Center",
		width : COL_W,
		x : OPOINT.X,
		y : 10
	},
	{
		text : $g("����:"),
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
		text : $g("�Ա�:"),
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
		text : $g("����:"),
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
		text : $g("����:"),
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
		text : $g("�ǼǺ�:"),
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
		text : $g("�Ʊ�:"),
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
		text : $g("����:"),
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
		text : $g("������:"),
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
	H: 8, //ҽ�����и߶�
	W: COL_W //ҽ�����п��
};
var ROWNUM = 0;
var HEAD_ROW_NUM = 2;  //��ͷռ������
var LINE = {
	WIDTH: 0.3,
	COLOR: "blue"
}

var FONT = {
	FAMILY: "����",
	SIZE: 3,
	COLOR: "Blue"
}

var IfPrinted = false //�жϱ�ҳ�Ƿ��ӡ��

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
* ����ҽ����Ӧ��������Ϣ
*/
function drawOrderTexts(order, child) {
	var y = OPOINT.Y + ROW.H * ROWNUM
	var orderName = child || order.ordName;
	var curX = OPOINT.X
	COL.forEach(function (single) {
		var width = parseInt(single.width)
		if (single.code == "ordName") {
			drawTextWrap(draw, order[single.code], width-1, FONT.FAMILY, FONT.SIZE, "start", FONT.COLOR, curX+1, y, "", "normal", order.row, 2, order[single.code + "_Print"]);
			/*��������Ϣ eg.--����ҽ��*/
			if (!!order.otherMsg) {
				drawTextWrap(draw, order.otherMsg, width / 2, FONT.FAMILY, FONT.SIZE - 0.5, "start", FONT.COLOR, curX + width / 2, y + ROW.H / 2 - 0.5, "", "normal", order.row, 2, order["otherMsg_Print"]);
			}
		} else {
			if (single.text.indexOf("ǩ��") > -1) {
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
					//��ͬ�����ں�ʱ�� �� --- 
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
* ��ҽ���º��ߺ�ɫ��
*/
function drawBottomRedLine() {
	var x1 = OPOINT.X;
	var y1 = OPOINT.Y + (ROWNUM) * ROW.H;
	var x2 = ROW.W + OPOINT.X
	var y2 = y1;
	draw.line(x1, y1, x2, y2).stroke({ width: "0.8", color: "red" }).attr('id', 'sheet_h_line_' + ROWNUM);
}

/**
* ��ҽ���Ϻ��ߺ�ɫ��
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
* ��ҽ���º���
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
* ��������
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
* ��ҽ��������
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
 * ������ʱҽ������ͷ
 * 
 */
function drawTableHead() {
	function drawHeadLine(x, y, x1, y1) {
		draw.line(x, y, x1, y1).stroke({ width: LINE.WIDTH, color: LINE.COLOR }).attr('class', IfPrinted ? 'printed' : 'unPrinted');

	}

	function drawHeadText(text, x, y, width) {
		drawText(draw, text, width, FONT.FAMILY, FONT.SIZE, "Center", FONT.COLOR, x, y, "", "normal", "head_1", IfPrinted);
	}
	drawHeadLine(OPOINT.X, OPOINT.Y, ROW.W + OPOINT.X, OPOINT.Y) //��һ������
	drawHeadLine(OPOINT.X, OPOINT.Y, OPOINT.X, OPOINT.Y + 2 * ROW.H) //�������

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
	drawHeadLine(OPOINT.X, OPOINT.Y + 2 * ROW.H, ROW.W + OPOINT.X, OPOINT.Y + 2 * ROW.H) //��һ������
	ROWNUM = ROWNUM + 2;
}

/**
* ��ҽ���º���
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
* ����ͷ������ ��ʱҽ������ͷջ����
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
 * ������ʱҽ������ͷ
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
	var textContent = "������" + patInfo.name + " �Ա�" + patInfo.sex + " ���䣺" + patInfo.age + " ���ţ�" + patInfo.bedCode + " �ǼǺţ�" + patInfo.regNo
		+ " �Ʊ�" + patInfo.loc + " ������" + patInfo.ward + " �����ţ�" + patInfo.medcareNO;
	drawText(draw, textContent, COL_W, FONT.FAMILY, FONT.SIZE, "", FONT.COLOR, OPOINT.X, OPOINT.Y - yPY, "", "normal", "patInfo", IfPrinted);
	drawText(draw, patInfo.hospital, COL_W, FONT.FAMILY, FONT.SIZE + 2, "Center", FONT.COLOR, OPOINT.X, OPOINT.Y - 20, "", "normal", "patInfo", IfPrinted);
	drawText(draw, $g("��ʱҽ����"), COL_W, FONT.FAMILY, FONT.SIZE + 2, "Center", FONT.COLOR, OPOINT.X, OPOINT.Y - 15, "", "normal", "patInfo", IfPrinted);
	*/
}


/**
 * ������ʱҽ������ͷ
 * 
 */
function drawPageNum(num) {
	//var yPY=26;    
	var textContent = $g("��")+" " + num + " "+$g("ҳ")
	drawText(draw, textContent, COL_W, FONT.FAMILY, FONT.SIZE + 1, "Center", FONT.COLOR, OPOINT.X, A4H - 3*ROW.H, "", "normal", "patInfo", IfPrinted);
}