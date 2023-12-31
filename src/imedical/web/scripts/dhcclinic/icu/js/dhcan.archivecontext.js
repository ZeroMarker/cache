function ArchiveContext(opts) {
    this.ratio = opts.ratio;
    if(!this.ratio.fontRatio) this.ratio.fontRatio = 1;
    this.offset = opts.offset;
    this.drawingDataList = [];
}

/** 
 * 绘制实线
 */
ArchiveContext.prototype.drawLine = function (startPos, endPos, strokeStyle, lineWidth, lineCap) {
    var curLineWidth = 1;
    if (lineWidth) {
        curLineWidth = lineWidth;
    }

    var startPosY = startPos.y * this.ratio.y + this.offset.y;
    var startPosX = startPos.x * this.ratio.x + this.offset.x;
    var endPosY = endPos.y * this.ratio.y + this.offset.y;
    var endPosX = endPos.x * this.ratio.x + this.offset.x;

    var drawingData = {
        drawingType: "drawLine",
        data: {
            "startPosY": startPosY,
            "startPosX": startPosX,
            "endPosY": endPosY,
            "endPosX": endPosX,
            "curLineWidth": curLineWidth,
            "strokeStyle": strokeStyle
        }
    };
    this.drawingDataList.push(drawingData);
}

/**
 * 绘制虚线
 */
ArchiveContext.prototype.drawDashLine = function (startPos, endPos, strokeStyle, lineDash, lineWidth, lineCap) {
    var curLineWidth = 1;
    if (lineWidth) {
        curLineWidth = lineWidth;
    }

    var startPosY = startPos.y * this.ratio.y + this.offset.y;
    var startPosX = startPos.x * this.ratio.x + this.offset.x;
    var endPosY = endPos.y * this.ratio.y + this.offset.y;
    var endPosX = endPos.x * this.ratio.x + this.offset.x;

    var drawingData = {
        drawingType: "drawDashLine",
        data: {
            "startPosY": startPosY,
            "startPosX": startPosX,
            "endPosY": endPosY,
            "endPosX": endPosX,
            "curLineWidth": curLineWidth,
            "strokeStyle": strokeStyle
        }
    };
    this.drawingDataList.push(drawingData);
}

/**
 * 绘制矩形
 */
ArchiveContext.prototype.drawRectangle = function (rect, strokeStyle, lineDash) {
    var lineStyle = 0;
    if (lineDash) {
        lineStyle = 1;
    }
    var curRect = {
        top: rect.top * this.ratio.y + this.offset.y,
        left: rect.left * this.ratio.x + this.offset.x,
        width: rect.width * this.ratio.x,
        height: rect.height * this.ratio.y
    };

    var drawingData = {
        drawingType: "drawRectangle",
        data: {
            "top": curRect.top,
            "left": curRect.left,
            "width": curRect.width,
            "height": curRect.height,
            "lineStyle": lineStyle,
            "strokeStyle": strokeStyle
        }
    };
    this.drawingDataList.push(drawingData);
}

/**
 * 填充矩形
 */
ArchiveContext.prototype.fillRectangle = function (rect, fillStyle) {
    var curRect = {
        top: rect.top * this.ratio.y + this.offset.y,
        left: rect.left * this.ratio.x + this.offset.x,
        width: rect.width * this.ratio.x,
        height: rect.height * this.ratio.y
    };
    var drawingData = {
        drawingType: "fillRectangle",
        data: {
            "top": curRect.top,
            "left": curRect.left,
            "width": curRect.width,
            "height": curRect.height,
            "fillStyle": fillStyle
        }
    };
    this.drawingDataList.push(drawingData);
}

/**
 * 绘制文本
 */
ArchiveContext.prototype.drawString = function (text, startPos, fillStyle, fontStyle, baseline, direction, maxWidth) {
    var VOrient = 0;
    if (baseline === "bottom") {
        VOrient = 1;
    } else if (baseline === "middle") {
        VOrient = 2;
    }
    var textWidth = "100%";
    if (maxWidth && Number(maxWidth) > 0) {
        textWidth = Number(maxWidth) * this.ratio.x;
    }

    var fontArr = fontStyle.split(" "),
        fontSize = Number(fontArr[1].replace("px", "")),
        fontWeight = fontArr[0],
        fontName = fontArr[2];
    if (fontArr.length > 3) {
        for (var i = 3; i < fontArr.length; i++) {
            fontName += " " + fontArr[i];
        }
    }
    var startPosY = startPos.y * this.ratio.y + this.offset.y,
        startPosX = startPos.x * this.ratio.x + this.offset.x,
        fontSize = fontSize * this.ratio.x * this.ratio.fontRatio;

    var drawingData = {
        drawingType: "drawString",
        data: {
            "startPosY": startPosY,
            "startPosX": startPosX,
            "textWidth": textWidth,
            "fontSize": fontSize,
            "text": text,
            "fontName": fontName,
            "fillStyle": fillStyle,
            "vOrient": VOrient,
            "fontWeight": fontWeight
        }
    };
    this.drawingDataList.push(drawingData);
}

/**
 * 绘制文本
 */
ArchiveContext.prototype.drawVerticalString = function (text, startPos, fillStyle, fontStyle, fontSize, baseline, direction) {
    var VOrient = 0;
    if (baseline === "bottom") {
        VOrient = 1;
    } else if (baseline === "middle") {
        VOrient = 2;
    }
    var textWidth = "100%";

    var fontArr = fontStyle.split(" "),
        fontSize = Number(fontArr[1].replace("px", "")),
        fontWeight = fontArr[0],
        fontName = fontArr[2];
    if (fontArr.length > 3) {
        for (var i = 3; i < fontArr.length; i++) {
            fontName += " " + fontArr[i];
        }
    }

    var startPosY = startPos.y * this.ratio.y + this.offset.y,
        startPosX = startPos.x * this.ratio.x + this.offset.x,
        fontSize = fontSize * this.ratio.x * this.ratio.fontRatio;
    for (var i = 0; i < text.length; i++) {
        var drawingData = {
            drawingType: "drawString",
            data: {
                "startPosY": startPosY + i * fontSize,
                "startPosX": startPosX,
                "textWidth": textWidth,
                "fontSize": fontSize,
                "text": text[i],
                "fontName": fontName,
                "fillStyle": fillStyle,
                "vOrient": VOrient,
                "fontWeight": fontWeight
            }
        };
        this.drawingDataList.push(drawingData);
    }

}

/**
 * 绘制圆形（圆弧）
 */
ArchiveContext.prototype.drawCircle = function (circle, strokeStyle, fillStyle) {
    var startPosX = circle.x * this.ratio.x + this.offset.x,
        startPosY = circle.y * this.ratio.y + this.offset.y,
        radius = circle.radius * this.ratio.x;
    var drawingData = {
        drawingType: "drawCircle",
        data: {
            "startPosY": startPosY,
            "startPosX": startPosX,
            "radius": radius,
            "strokeStyle": strokeStyle,
            "fillStyle": fillStyle
        }
    };
    this.drawingDataList.push(drawingData);
}

ArchiveContext.prototype.drawImage = function (rect, url) {
    var top = rect.top * this.ratio.y + this.offset.y;
    var left = rect.left * this.ratio.x + this.offset.x;
    var width = rect.width * this.ratio.x + this.offset.x;
    var height = rect.height * this.ratio.y + this.offset.y;
    var drawingData = {
        drawingType: "drawImage",
        data: {
            "top": top,
            "left": left,
            "width": width,
            "height": height,
            "url": url
        }
    };
    this.drawingDataList.push(drawingData);
}

/**
 * 测量文本宽度
 */
ArchiveContext.prototype.measureTextWidth = function (text, fillStyle, fontStyle, baseline) {
    var alphabetReg = /\w|\s|\d|[\-,\+]/g;
    var fontArr = fontStyle.split(" "),
        fontSize = Number(fontArr[1].replace("px", ""));
    var matchCount = text.match(alphabetReg);
    fontSize = fontSize * this.ratio.x;
    var result = text.length * fontSize;
    return result;
};

/**
 * 测量中文文本的宽度，默认测量一个中文文字的宽度
 */
ArchiveContext.prototype.measureChineseWidth = function (text, fillStyle, fontStyle, baseline) {
    var fontArr = fontStyle.split(" "),
        fontSize = Number(fontArr[1].replace("px", ""));
    fontSize = fontSize * this.ratio.x;
    return fontSize;
}

ArchiveContext.prototype.clearRect = function (x, y, width, height) {

}

/**
 * 增加一页
 */
ArchiveContext.prototype.addPage = function () {
    var drawingData = {
        drawingType: "addPage",
        data: {

        }
    };
    this.drawingDataList.push(drawingData);
}

ArchiveContext.prototype.archives = function (para) {
    var dataList = this.drawingDataList;
    var dataListStr = JSON.stringify(dataList);
    $.ajax({
        url: para.archiveServerUrl,
        async: true,
        data: {
            "type": para.type,
            "id": para.id,
            "date": para.date,
            "filename": para.filename,
            "datalist": dataListStr,
            "pageWidth": para.pageWidth,
            "pageHeight": para.pageHeight,
            "random": Math.random()
        },
        dataType: "text",
        type: "POST",
        success: function (data, textStatus) {
            if (para.onSuccess) {
                para.onSuccess(data);
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var errorMsg = para.archiveServerUrl + "无法连接！请检查归档服务器！";
            if (para.onError) {
                para.onError(errorMsg);
            }
        }
    });
}

ArchiveContext.prototype.archivesTest = function (para) {
    var result = $.ajax({
        url: para.archiveServerUrl,
        async: true,
        dataType: "text",
        type: "GET",
        async: false
    });
    console.dir(result);
}