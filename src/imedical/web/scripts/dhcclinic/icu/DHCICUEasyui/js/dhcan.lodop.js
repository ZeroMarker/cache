function drawCheckBoxAndValue(lodop, opts) {
    var boxSize = { width: 12, height: 12 };
    var lineStyle = 0,
        lineWidth = 1;
    var startPos = opts.startPos;
    if(opts.title && opts.titleWidth>0){
        lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", "100%", opts.title);
        startPos.x+=opts.titleWidth;
    }
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, boxSize.width, boxSize.height, lineStyle, lineWidth);
    var emptyValue="/";
    if(typeof opts.emptyValue==="string"){
        emptyValue=opts.emptyValue;
    }
    var checkValue = opts.checked ? "√" : emptyValue;
    var offSetX = opts.checked ? 3 : (-2),
        offSetY = opts.checked ? 5 : 3;
    var checkTextMargin = 3;
    lodop.ADD_PRINT_TEXT(startPos.y - offSetY, startPos.x - offSetX, "100%", "100%", checkValue);
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    lodop.SET_PRINT_STYLEA(0, "Bold", 1);
    var textSize = opts.textSize;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + boxSize.width + checkTextMargin, "100%", textSize.height, opts.text);
    if(opts.infoLineWidth && opts.infoLineWidth>0){
        var lineStartPosX=startPos.x+boxSize.width+checkTextMargin+textSize.width,lineStartPosY=startPos.y+15;
        lodop.ADD_PRINT_LINE(lineStartPosY,lineStartPosX,lineStartPosY,lineStartPosX+opts.infoLineWidth,lineStyle,lineWidth);
        if(opts.infoLineValue)
            lodop.ADD_PRINT_TEXT(startPos.y,lineStartPosX,opts.infoLineWidth,textSize.height,opts.infoLineValue); 
        if(opts.infoLineUnit && opts.lineUnitWidth>0){
            lodop.ADD_PRINT_TEXT(startPos.y,lineStartPosX+opts.infoLineWidth+2,"100%",textSize.height,opts.infoLineUnit); 
        }

    }
}

function drawRectAndTitle(lodop, opts) {
    var rectSize = opts.rectSize,
        startPos = opts.startPos,
        lineStyle = 0,
        lineWidth = 1;
    var offSetY = (rectSize.height - 12) / 2;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, rectSize.width, rectSize.height, lineStyle, lineWidth);
    lodop.ADD_PRINT_TEXT(startPos.y + offSetY, startPos.x, rectSize.width, rectSize.height, opts.title);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
}

function drawRectAndTitleNormal(lodop, opts) {
    var rectSize = opts.rectSize,
        startPos = opts.startPos,
        lineStyle = 0,
        lineWidth = 1;
    var offSetY = (rectSize.height - (opts.fontSize?opts.fontSize:11)) / 2;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, rectSize.width, rectSize.height, lineStyle, lineWidth);
    lodop.ADD_PRINT_TEXT(startPos.y + offSetY, startPos.x, rectSize.width, rectSize.height, opts.title);
    // lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    if(opts.value && opts.value!=="" && opts.title===""){
        var padding={top:5,left:5};
        
        if(opts.valueVAlignment && opts.valueVAlignment==="center"){
            lodop.ADD_PRINT_TEXT(startPos.y+offSetY, startPos.x+padding.left, rectSize.width, rectSize.height, opts.value);
        }else{
            lodop.ADD_PRINT_TEXT(startPos.y+padding.top, startPos.x+padding.left, rectSize.width, rectSize.height, opts.value);
        }
    }
}

function drawTitleValueLine(lodop,opts){
    var startPos=opts.startPos,
        lineWidth=opts.lineWidth,
        titleWidth=opts.titleWidth,
        lineStyle = 0,
        lineWeight = 1,
        titleHeight=opts.titleHeight,
        valueHeight=opts.valueHeight,
        unitWidth=opts.unitWidth
        startPosX=startPos.x,
        paddingLeft=2;
    lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",titleHeight,opts.title);
    startPosX+=titleWidth;
    lodop.ADD_PRINT_TEXT(startPos.y,startPos.x+paddingLeft,lineWidth,valueHeight,opts.value);
    lodop.ADD_PRINT_LINE(startPos.y+titleHeight,startPosX,startPos.y+titleHeight,startPosX+lineWidth,lineStyle,lineWeight);
    if(opts.unit && opts.unit!==""){
        lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",titleHeight,opts.unit);
    }
}

function drawTitleValueLineGroup(lodop,optGroup){
    if(optGroup && optGroup.length>0){
        var startPosX=0,itemMargin=5;
        for(var i=0;i<optGroup.length;i++){
            var opts=optGroup[i];
            if(i===0){
                startPosX=opts.startPos.x;
            }else{
                opts.startPos.x=startPosX+itemMargin;
            }
            drawTitleValueLine(lodop,opts);
            startPosX=opts.startPos.x+opts.lineWidth+opts.titleWidth+opts.unitWidth;
        }
    }
}

function drawRectAndTitleGroup(lodop,optGroup){
    if(optGroup && optGroup.length>0){
        var startPosX=0,itemMargin=0;
        for(var i=0;i<optGroup.length;i++){
            var opts=optGroup[i];
            if(i===0){
                startPosX=opts.startPos.x;
            }else{
                opts.startPos.x=startPosX+itemMargin;
            }
            drawRectAndTitleNormal(lodop,opts);
            startPosX=opts.startPos.x+opts.rectSize.width;
        }
    }
}

function drawCheckBoxGroup(lodop,optGroup){
    if(optGroup && optGroup.length>0){
        var startPosX=0,itemMargin=5;
        for(var i=0;i<optGroup.length;i++){
            var opts=optGroup[i];
            if(i===0){
                startPosX=opts.startPos.x;
            }else{
                opts.startPos.x=startPosX+itemMargin;
            }
            drawCheckBoxAndValue(lodop,opts);
            startPosX=opts.startPos.x+opts.textSize.width+15+(opts.infoLineWidth>0?opts.infoLineWidth:0)+(opts.lineUnitWidth>0?opts.lineUnitWidth:0);
        }

        return startPosX;
    }

    return 0;
}