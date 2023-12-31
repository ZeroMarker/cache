/**
 * 绘制线段
 * @param   startPos    {Point}     线段起点
 * @param   endPos      {Point}     线段终点
 * @param   strokeStyle {String}    线段描边样式
 * @param   lineWidth   {Number}    线段宽度
 * @param   lineCap     {String}    线帽
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
CanvasRenderingContext2D.prototype.drawLine = function(startPos, endPos, strokeStyle, lineWidth, lineCap) {
    this.save();
    this.strokeStyle = strokeStyle;
    if (lineWidth) {
        this.lineWidth = lineWidth;
    }
    if (lineCap) {
        this.lineCap = lineCap;
    }
    this.beginPath();
    this.moveTo(startPos.x, startPos.y);
    this.lineTo(endPos.x, endPos.y);
    this.stroke();
    this.closePath();
    this.restore();
}

/**
 * 绘制虚线
 * @param   startPos    {Point}     线段起点
 * @param   endPos      {Point}     线段终点
 * @param   strokeStyle {String}    线段描边样式
 * @param   lineDash    {Array}     线段绘制间隔以及宽度
 * @param   lineWidth   {Number}    线段宽度
 * @param   lineCap     {String}    线帽
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
CanvasRenderingContext2D.prototype.drawDashLine = function(startPos, endPos, strokeStyle, lineDash, lineWidth, lineCap) {
    this.save();
    this.strokeStyle = strokeStyle;
    if (lineWidth) {
        this.lineWidth = lineWidth;
    }
    if (lineCap) {
        this.lineCap = lineCap;
    }
    if (lineDash && lineDash instanceof Array) {
        this.setLineDash(lineDash)
    } else {
        this.setLineDash([1, 1])
    }

    this.beginPath();
    this.moveTo(startPos.x, startPos.y);
    this.lineTo(endPos.x, endPos.y);
    this.stroke();
    this.closePath();
    this.restore();
}

/**
 * 绘制矩形
 * @param   rect        {Rectangle}    绘制的矩形 
 * @param   strokeStyle {String}       矩形的描边样式
 * @returns void
 * @author  chenchangqing   2016/11/29
 */
CanvasRenderingContext2D.prototype.drawRectangle = function(rect, strokeStyle, lineDash) {
    this.save();
    this.strokeStyle = strokeStyle;
    if (lineDash) {
        if (lineDash instanceof Array) {
            this.setLineDash(lineDash);
        } else {
            this.setLineDash([1, 1]);
        }
    }
    this.strokeRect(rect.left, rect.top, rect.width, rect.height);
    this.restore();
}

/**
 * 绘制矩形
 * @param   rect        {Rectangle}    绘制的矩形 
 * @param   fillStyle {String}       矩形的描边样式
 * @returns void
 * @author  chenchangqing   20171024
 */
CanvasRenderingContext2D.prototype.fillRectangle = function(rect, fillStyle) {
    this.save();
    this.fillStyle = fillStyle;
    this.fillRect(rect.left, rect.top, rect.width, rect.height);
    this.restore();
}

/**
 * 绘制文本
 * @param   text        {String}    绘制的文本
 * @param   startPos    {Point}     文本起点
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   baseline    {String}     文本基线
 * @param   direction   {String}    文本方向
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
CanvasRenderingContext2D.prototype.drawString = function(text, startPos, fillStyle, fontStyle, baseline, direction, maxWidth) {
    this.save();
    this.fillStyle = fillStyle;
    this.font = fontStyle;
    if (baseline) {
        this.textBaseline = baseline;
    } else {
        this.textBaseline = "top";
    }

    if (direction) {
        this.direction = direction;
    }
    if (maxWidth && Number(maxWidth) > 0) {
        this.fillText(text, startPos.x, startPos.y, maxWidth);
    } else {
        this.fillText(text, startPos.x, startPos.y);
    }

    this.restore();
}

/**
 * 绘制文本
 * @param   text        {String}    绘制的文本
 * @param   startPos    {Point}     文本起点
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   fontSize    {Number}    文本字体大小
 * @param   baseline    {String}     文本基线
 * @param   direction   {String}    文本方向
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
CanvasRenderingContext2D.prototype.drawVerticalString = function(text, startPos, fillStyle, fontStyle, fontSize, baseline, direction) {
    this.save();
    this.fillStyle = fillStyle;
    this.font = fontStyle;
    if (baseline) {
        this.textBaseline = baseline;
    } else {
        this.textBaseline = "top";
    }
    if (direction) {
        this.direction = direction;
    }
    for (var i = 0; i < text.length; i++) {
        this.fillText(text[i], startPos.x, startPos.y + i * fontSize);
    }

    this.restore();
}

/**
 * 测量文本宽度
 * @param   text        {String}    绘制的文本
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   baseline    {String}     文本基线
 * @returns Float
 * @author  chenchangqing   2016/11/28
 */
CanvasRenderingContext2D.prototype.measureTextWidth = function(text, fillStyle, fontStyle, baseline) {
    this.save();
    this.fillStyle = fillStyle;
    this.font = fontStyle;
    if (baseline) {
        this.textBaseline = baseline;
    } else {
        this.textBaseline = "top";
    }
    var result = this.measureText(text).width;
    this.restore();
    return result;
};

/**
 * 测量中文文本的宽度，默认测量一个中文文字的宽度
 * @param   text        {String}    测量的文本
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   baseline    {String}    文本基线
 * @returns Float
 * @author  chenchangqing   2016/11/28
 */
CanvasRenderingContext2D.prototype.measureChineseWidth = function(text, fillStyle, fontStyle, baseline) {
    this.save();
    this.fillStyle = fillStyle;
    this.font = fontStyle;
    if (baseline) {
        this.textBaseline = baseline;
    } else {
        this.textBaseline = "top";
    }
    if (!text || text === "") {
        text = "国";
    }
    var result = this.measureText(text).width;
    this.restore();
    return result;
}

/**
 * 将HTML页面坐标转化为canvas坐标
 * @param   e   {Point}    鼠标点击的位置
 * @returns Point
 * @author  chenchangqing   2016/11/28
 */
HTMLCanvasElement.prototype.windowToCanvas = function(e) {
    var box = this.getBoundingClientRect();
    var ratio = window.devicePixelRatio || 1;
    return {
        x: e.clientX - box.left * (this.width / (box.width * ratio)),
        y: e.clientY - box.top * (this.height / (box.height * ratio))
    };
}


/**
 * 将canvas坐标转化为HTML页面坐标
 * @param   e   {Point}    鼠标点击的位置
 * @returns Point
 * @author  yongyang   2018/10/12
 */
HTMLCanvasElement.prototype.canvasToWindow = function(e) {
    var box = this.getBoundingClientRect();
    var ratio = window.devicePixelRatio || 1;
    return {
        x: e.x + box.left * (this.width / (box.width * ratio)),
        y: e.y + box.top * (this.height / (box.height * ratio))
    };
}

/**
 * 绘制圆形（圆弧）
 * @param {object} circle - 圆形(圆弧)对象，包括圆心坐标、半径
 * @param {string} strokeStyle - 绘制颜色
 * @param {string} fillStyle - 填充颜色
 * @author chenchangqing 20170911
 */
CanvasRenderingContext2D.prototype.drawCircle = function(circle, strokeStyle, fillStyle) {
    this.save();
    this.strokeStyle = strokeStyle;
    this.fillStyle = fillStyle;
    this.beginPath();
    this.arc(circle.x, circle.y, circle.radius, 0, circle.eAngle);
    if (fillStyle) {
        this.fill();
    } else {
        this.stroke();
    }

    this.closePath();
    this.restore();
}

function LodopContext(opts){
    this.lodop=opts.lodop;
    this.ratio=opts.ratio;
    this.offset=opts.offset;
}

/**
 * 绘制线段
 * @param   startPos    {Point}     线段起点
 * @param   endPos      {Point}     线段终点
 * @param   strokeStyle {String}    线段描边样式
 * @param   lineWidth   {Number}    线段宽度
 * @param   lineCap     {String}    线帽
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
LodopContext.prototype.drawLine = function(startPos, endPos, strokeStyle, lineWidth, lineCap) {
    var curLineWidth=1;
    if (lineWidth) {
        curLineWidth = lineWidth;
    }
    var startPosY=(startPos.y<endPos.y?startPos.y:endPos.y)*this.ratio.y+this.offset.y,
        startPosX=(startPos.x<endPos.x?startPos.x:endPos.x)*this.ratio.x+this.offset.x;
    var shapeType=0;
    var rectWidth=Math.abs(endPos.x-startPos.x);
    var rectHeight=Math.abs(endPos.y-startPos.y);
    if(startPos.x<=endPos.x && startPos.y<=endPos.y){
        shapeType=1;
    }
    if(startPos.x>endPos.x && startPos.y>endPos.y){
        shapeType=1;
    }
    rectWidth*=this.ratio.x;
    rectHeight*=this.ratio.y;
    this.lodop.ADD_PRINT_SHAPE(shapeType,startPosY,startPosX,rectWidth,rectHeight,0,curLineWidth,strokeStyle);
}

/**
 * 绘制虚线
 * @param   startPos    {Point}     线段起点
 * @param   endPos      {Point}     线段终点
 * @param   strokeStyle {String}    线段描边样式
 * @param   lineDash    {Array}     线段绘制间隔以及宽度
 * @param   lineWidth   {Number}    线段宽度
 * @param   lineCap     {String}    线帽
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
LodopContext.prototype.drawDashLine = function(startPos, endPos, strokeStyle, lineDash, lineWidth, lineCap) {
    var curLineWidth=1;
    if (lineWidth) {
        curLineWidth = lineWidth;
    }
    var startPosY=startPos.y*this.ratio.y+this.offset.y,
        startPosX=startPos.x*this.ratio.x+this.offset.x;
    var shapeType=0;
    var rectWidth=Math.abs(endPos.x-startPos.x);
    var rectHeight=0;
    if(startPos.x===endPos.x){
        shapeType=1;
        rectWidth=0;
        rectHeight=Math.abs(endPos.y-startPos.y);
    }
    rectWidth*=this.ratio.x;
    rectHeight*=this.ratio.y;
    this.lodop.ADD_PRINT_SHAPE(shapeType,startPosY,startPosX,rectWidth,rectHeight,2,curLineWidth,strokeStyle);
}

/**
 * 绘制矩形
 * @param   rect        {Rectangle}    绘制的矩形 
 * @param   strokeStyle {String}       矩形的描边样式
 * @returns void
 * @author  chenchangqing   2016/11/29
 */
LodopContext.prototype.drawRectangle = function(rect, strokeStyle, lineDash) {
    var lineStyle=0;
    if (lineDash) {
        lineStyle=1;
    }
    var curRect={
        top:rect.top*this.ratio.y+this.offset.y,
        left:rect.left*this.ratio.x+this.offset.x,
        width:rect.width*this.ratio.x,
        height:rect.height*this.ratio.y
    };
    this.lodop.ADD_PRINT_SHAPE(2,curRect.top,curRect.left,curRect.width,curRect.height,lineStyle,1,strokeStyle);
}

/**
 * 绘制矩形
 * @param   rect        {Rectangle}    绘制的矩形 
 * @param   fillStyle {String}       矩形的描边样式
 * @returns void
 * @author  chenchangqing   20171024
 */
LodopContext.prototype.fillRectangle = function(rect, fillStyle) {
    var curRect={
        top:rect.top*this.ratio.y+this.offset.y,
        left:rect.left*this.ratio.x+this.offset.x,
        width:rect.width*this.ratio.x,
        height:rect.height*this.ratio.y
    };
    this.lodop.ADD_PRINT_SHAPE(4,curRect.top,curRect.left,curRect.width,curRect.height,0,1,fillStyle);
}

/**
 * 绘制文本
 * @param   text        {String}    绘制的文本
 * @param   startPos    {Point}     文本起点
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   baseline    {String}     文本基线
 * @param   direction   {String}    文本方向
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
LodopContext.prototype.drawString = function(text, startPos, fillStyle, fontStyle, baseline, direction, maxWidth) {
    var VOrient=0;
    if (baseline==="bottom") {
        VOrient=1;
    }else if(baseline==="middle"){
        VOrient=2;
    }
    var textWidth="100%";
    if (maxWidth && Number(maxWidth) > 0) {
        textWidth=Number(maxWidth)*this.ratio.x;
    }

    var fontArr=fontStyle.split(" "),
        fontSize=Number(fontArr[1].replace("px","")),
        fontWeight=fontArr[0],
        fontName=fontArr[2];
    if(fontArr.length>3){
        for(var i=3;i<fontArr.length;i++){
            fontName+=" "+fontArr[i];
        }
    }
    var startPosY=startPos.y*this.ratio.y+this.offset.y,
        startPosX=startPos.x*this.ratio.x+this.offset.x,
        fontSize=fontSize*this.ratio.x;
    this.lodop.ADD_PRINT_TEXT(startPosY,startPosX,textWidth,fontSize,text);
    this.lodop.SET_PRINT_STYLEA(0,"FontName",fontName);
    this.lodop.SET_PRINT_STYLEA(0,"FontSize",fontSize*3/4);
    this.lodop.SET_PRINT_STYLEA(0,"FontColor",fillStyle);
    this.lodop.SET_PRINT_STYLEA(0,"VOrient",VOrient);
    this.lodop.SET_PRINT_STYLEA(0,"FontColor",fillStyle);

    if(fontWeight==="bold"){
        this.lodop.SET_PRINT_STYLEA(0,"Bold",1);
    }
    
}

/**
 * 绘制文本
 * @param   text        {String}    绘制的文本
 * @param   startPos    {Point}     文本起点
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   fontSize    {Number}    文本字体大小
 * @param   baseline    {String}     文本基线
 * @param   direction   {String}    文本方向
 * @returns void
 * @author  chenchangqing   2016/11/28
 */
LodopContext.prototype.drawVerticalString = function(text, startPos, fillStyle, fontStyle, fontSize, baseline, direction) {
    var VOrient=0;
    if (baseline==="bottom") {
        VOrient=1;
    }else if(baseline==="middle"){
        VOrient=2;
    }
    var textWidth="100%";
    // if (maxWidth && Number(maxWidth) > 0) {
    //     textWidth=maxWidth;
    // }

    var fontArr=fontStyle.split(" "),
        fontSize=Number(fontArr[1].replace("px","")),
        fontWeight=fontArr[0],
        fontName=fontArr[2];
    if(fontArr.length>3){
        for(var i=3;i<fontArr.length;i++){
            fontName+=" "+fontArr[i];
        }
    }

    var startPosY=startPos.y*this.ratio.y+this.offset.y,
        startPosX=startPos.x*this.ratio.x+this.offset.x,
        fontSize=fontSize*this.ratio.x;
    for (var i = 0; i < text.length; i++) {
        this.lodop.ADD_PRINT_TEXT(startPosY + i * fontSize,startPosX,textWidth,fontSize,text[i]);
        this.lodop.SET_PRINT_STYLEA(0,"FontName",fontName);
        this.lodop.SET_PRINT_STYLEA(0,"FontSize",fontSize*3/4);
        this.lodop.SET_PRINT_STYLEA(0,"FontColor",fillStyle);
        this.lodop.SET_PRINT_STYLEA(0,"VOrient",VOrient);
        this.lodop.SET_PRINT_STYLEA(0,"FontColor",fillStyle);

        if(fontWeight==="bold"){
            this.lodop.SET_PRINT_STYLEA(0,"Bold",1);
        }
    }
    
}

/**
 * 绘制圆形（圆弧）
 * @param {object} circle - 圆形(圆弧)对象，包括圆心坐标、半径
 * @param {string} strokeStyle - 绘制颜色
 * @param {string} fillStyle - 填充颜色
 * @author chenchangqing 20170911
 */
LodopContext.prototype.drawCircle = function(circle, strokeStyle, fillStyle) {
    var shapeType=3,
        color=strokeStyle;
    if (fillStyle) {
        shapeType=5;
        color=fillStyle;
    }
    var startPosX=(circle.x-circle.radius)*this.ratio.x+this.offset.x,
        startPosY=(circle.y-circle.radius)*this.ratio.y+this.offset.y,
        radius=circle.radius*this.ratio.x;
    this.lodop.ADD_PRINT_SHAPE(shapeType,startPosY,startPosX,radius*2,radius*2,0,1,color);
}

/**
 * 测量文本宽度
 * @param   text        {String}    绘制的文本
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   baseline    {String}     文本基线
 * @returns Float
 * @author  chenchangqing   2016/11/28
 */
LodopContext.prototype.measureTextWidth = function(text, fillStyle, fontStyle, baseline) {
    var alphabetReg = /\w|\s|\d|[\-,\+]/g;
    var fontArr=fontStyle.split(" "),
        fontSize=Number(fontArr[1].replace("px",""));
    var matchCount=text.match(alphabetReg);
    fontSize=fontSize*this.ratio.x;
    var result=text.length*fontSize; //-((matchCount && matchCount>0?matchCount:0)*fontSize)/2;
    return result;
};

/**
 * 测量中文文本的宽度，默认测量一个中文文字的宽度
 * @param   text        {String}    测量的文本
 * @param   fillStyle   {String}    文本填充样式
 * @param   fontStyle   {String}    文本字体样式
 * @param   baseline    {String}    文本基线
 * @returns Float
 * @author  chenchangqing   2016/11/28
 */
LodopContext.prototype.measureChineseWidth = function(text, fillStyle, fontStyle, baseline) {
    var fontArr=fontStyle.split(" "),
        fontSize=Number(fontArr[1].replace("px",""));
    fontSize=fontSize*this.ratio.x;
    return fontSize;
}

LodopContext.prototype.clearRect=function(x,y,width,height){
    
}
