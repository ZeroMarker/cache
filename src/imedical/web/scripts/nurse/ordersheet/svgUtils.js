/*
 * @Author: songchao
 * @Date: 2020-11-11 19:42:58
 * @LastEditTime: 2021-05-13 21:46:59
 * @LastEditors: SongChao
 * @Description: In User Settings Edit
 * @FilePath: /mediway/imedical/web/scripts/nurse/temperature/svg/svgUtils.js
 */
/**
 * ��ϻ��������־
 * @param {*} draw 
 */
function drawOutFlag(draw, fontSize, x, y) {
	drawVText(draw, "��", "SimSun", fontSize, "start", x, y, fontSize, "1.0", "normal", "red");
	drawVText(draw, "��", "SimSun", fontSize, "start", x, y + fontSize / 2, fontSize, "1.0", "normal", "red");
}

/**
 * ��б��(Ѫѹ/����)
 */
function drawSlantLine(draw, yVal) {
	for (i = 0; i <= 25; i++) {  //����ͼ����
		draw.line(i * cellW + tableOX + leftRulerW, yVal + 2, i * cellW + cellW + tableOX + leftRulerW, yVal - 2).stroke({ width: borderWidth }).attr('id', 'pageBotVline' + i);
	}
}

/**
 * ��ͼ��
 */
function drawPoint(draw, icon, size, x, y, color, id) {
	var rowLeading = '1.0em';
	var fontWeight = 'normal';
	var text = draw.text(icon + "");
	var anchor = "start"

	//��ȡ������font
	text.font({
		size: size,
		anchor: anchor, //����λ�õ���Զ�λ��
		leading: rowLeading,
		weight: fontWeight
	});
	var span = text.tspan(icon + "").fill(color).attr('id', "tspan" + id);
	text.move(x - size / 3, y - size / 2);
}

/**
 * ������
 */
function drawText(draw, content, width, family, size, alignment, color, x, y, leading, weight, id, printed) {
	if (!!!content) {
		return
	}
	var content=String(content)
	var rowLeading = leading || '1.0em';
	var fontWeight = weight || 'normal';
	if (String(content).indexOf("<red>") > -1) {
		content = content.replace("<red>", "");
		color = "red";
	}
	if (!!printed) {
		var text = draw.text(content + "").attr('class', 'printed').attr("id", "text_row_" + id);
	} else {
		if (content != "") {
			var text = draw.text(content + "").fill(color).attr('class', 'unPrinted').attr('id', 'text_row_' + id);
		} else {
			var text = draw.text(content + "").fill(color).attr('id', 'text_row_' + id)
		}
	}
	
	text.attr('width', width)
	text.attr('startX', x)

	var anchor = alignment
	if (alignment == "Center") {
		x = x + width / 2
		anchor = "middle";
	}
	anchor = anchor || "start"
	//��ȡ������font
	text.font({
		family: family,
		size: size,
		anchor: anchor, //����λ�õ���Զ�λ��
		leading: rowLeading,
		weight: fontWeight
	});

	var span = text.tspan(content + "").attr('id', "span_row_" + id);
	
	if (span.length() > width) {
		console.log(span.length());
	}
	if (weight == "Underline") {
		//text.attr("text-decoration","underline");
		// debugger;
		draw.line(x, y + size, x + span.length(), y + size).stroke({ width: 0.25 });
	}

	text.move(x, y + 2);
	//text.clear();
}
/**
 * �����ֲ���ת90��
 */
function drawTextRotate90(draw, content, family, size, anchor, x, y, leading, weight) {
	var rowLeading = leading || '1.0em';
	var fontWeight = weight || 'normal';
	var text = draw.text(content);
	//��ȡ������font
	text.font({
		family: family,
		size: size,
		anchor: anchor, //����λ�õ���Զ�λ��
		leading: rowLeading,
		weight: fontWeight
	});
	text.rotate(90, x, y);
	text.move(x, y - size);	//y-size����ת90�Ⱥ󱣳�xy����
}
/**
 * ����������
 */
function drawVText(draw, content, family, size, anchor, x, y, fontHeight, leading, weight, color) {
	var rowLeading = leading || '1.0em';
	var fontWeight = weight || 'normal';
	var fontColor = color || "black";
	var yHeight = fontHeight || 5;
	for (i = 0; i < content.length; i++) {
		var text = draw.text(content[i]).fill(fontColor);
		//��ȡ������font
		text.font({
			family: family,
			size: size,
			anchor: anchor, //����λ�õ���Զ�λ��
			leading: rowLeading,
			weight: fontWeight
		});
		text.move(x, y + i * yHeight);
	}

}

/**
* ����������
*/
function drawTextWrap(draw, content, width, family, size, alignment, color, x, y, leading, weight, id, maxRows, printed, underline) {
	if (!!!content) {
		return
	}
	var content=String(content)
	var wrapContentArray = []
	var specialCharSum = 0  //ascall���ַ�����
	if (content.match(/[\x00-\xff]/g) != null) {
		var specialCharSum = content.match(/[\x00-\xff]/g).length
	}
	var chineseCharSum = content.length - specialCharSum //�����ַ�����
	var oneLineWidth = chineseCharSum * size + specialCharSum * (size / 2)
	if (oneLineWidth > width) {
		if (!!maxRows && oneLineWidth / width > maxRows)  //��������������,�����С��1
		{
			size = size - 1
		}
		wrapContentArray = textWrap(content, size, width)
	} else {
		wrapContentArray = [content]
	}

	var content = wrapContentArray.join("\n")
	var rowLeading = leading || '1.0em';
	var fontWeight = weight || 'normal';
	if (String(content).indexOf("<red>") > -1) {
		content = content.replace("<red>", "");
		color = "red";
	}
	if (!!printed) {
		var text = draw.text(content + "").attr('class', 'printed').attr('id', 'text_row_' + id);
	} else {
		if (content != "") {
			var text = draw.text(content + "").fill(color).attr('class', 'unPrinted').attr('id', 'text_row_' + id);
		} else {
			var text = draw.text(content + "").fill(color).attr('id', 'text_row_' + id)
		}
	}
	
	text.attr('width', width)
	text.attr('startX', x)
	
	var anchor = alignment
	if (alignment == "Center") {
		x = x + width / 2
		anchor = "middle";
	}
	if (alignment == "end") {
		x = x + width;
	}
	anchor = anchor || "start"
	//��ȡ������font
	text.font({
		family: family,
		size: size,
		anchor: anchor, //����λ�õ���Զ�λ��
		leading: rowLeading,
		weight: fontWeight
	});
	if (!!underline) {
		//text.attr("text-decoration","underline");
		// debugger;
		if (wrapContentArray.length == 1)
		{
			draw.line(x, y + 2 + size, x + getTextLength(content,size), y + 2 + size).stroke({ width: 0.25, color: color}).attr('class', !!printed ? 'printed': 'unPrinted');
		}else{
			draw.line(x, y + 1 + size, x + getTextLength(content.split("\n")[0],size), y + 1 + size).stroke({ width: 0.25, color: color}).attr('class', !!printed ? 'printed': 'unPrinted');
			draw.line(x, y + 1 + 2 * size, x + getTextLength(content.split("\n")[1],size), y + 1 + 2 * size).stroke({ width: 0.25, color: color}).attr('class', !!printed ? 'printed': 'unPrinted');
		}
	}

	text.move(x, wrapContentArray.length == 1 ? y + 2 : y + 1);
	//text.clear();
}

/**
* ����
*/
function textWrap(str, fontSize, width) {
	var strs = []; ///���й������顢��ֹ���ʲ�ֻ��С���ֹ���� 2.8g ��ֻ���
	while (str.length > 1) {
		if ((/[\x00-\xff]/g).test(str.charAt(0))) {
			//var pos = str.search(/[^\x00-\xff]|(^\s+)|(\s+$)|\s+/g)
			var pos = str.search("[^\x00-\xff]|[\\)\\] ]")
			pos = pos == -1 ? str.length : pos
			pos = (str.charAt(pos) == "]" || str.charAt(pos) == ")") ? pos + 1 : pos
			pos = pos == 0 ? 1 : pos
			strs.push(str.substring(0, pos))
		} else {
			strs.push(str.charAt(0))
			var pos = 1
		}
		str = str.substring(pos)
	}
	if (str != "") {
		strs.push(str);
	}

	/*����*/
	var multRows = [], singleStr = "", singleWidth = 0
	for (var index in strs) {
		var str = strs[index]
		var flag = (/[\x00-\xff]/g).test(str)
		var curWidth = flag ? str.length * (fontSize / 2) : str.length * fontSize
		if (singleWidth + curWidth < width) {
			singleStr = singleStr + str
			singleWidth = singleWidth + curWidth
			if (index == strs.length - 1) {
				multRows.push(singleStr)
				singleStr = ""
				singleWidth = 0
			}
			continue
		}
		multRows.push(singleStr)
		singleStr = str
		singleWidth = 0
	}
	if (singleStr != "") {
		multRows.push(singleStr)
	}
	return multRows
}

/*������*/
function drawRect(draw, x, y, width, height, color, className, id) {
	var rect = draw.rect(width, height).fill(color).attr("class", className).attr("id", id)
	rect.move(x, y)

}


function drawImage(draw, base64Str, width, height, x, y, id, printed) {
	var image = draw.image(base64Str, width, height);
	image.attr('id', "text_row_" + id);
	if (!!printed) {
		image.attr('class', 'printed');
	} else {
		image.attr('class', 'unPrinted');
	}
	image.move(x, y);
}

//��ȡ�ַ����ĳ���
function getTextLength(str, fontSize)
{
	var chatList = str.match(/[\x00-\xff]/g) || []
	return chatList.length * (fontSize / 2) + (str.length - chatList.length) * fontSize
}



