var divDetailInforID = "divInforDetail";
var LinePoint = Class.create();
LinePoint.prototype = {
    initialize: function(xValue, lblValue, isStart, isEnd, noEnd) {
        this.value = lblValue;
        this.xPoint = xValue;
        this.isStart = isStart;
        this.isEnd = isEnd;
        this.NoEnd = noEnd;
    }
};

var LineShape = Class.create();
LineShape.prototype = {
    initialize: function(pointArray, elm, options) {
        this.setOptions(options);
        this.LineContainer = elm;
        this.entity = document.createElement("div");
        this.entity.style.left = options.containerX + "px";
        this.showLine(pointArray);
    },
    setOptions: function(options) {
        this.options = {
            height: 80,                  //绘图区域高度
            topDistance: 10,             //上部填充
            pointWidth: 10,              //坐标点宽度
            pointHeight: 10,             //坐标点高度
            lineColor: "#ffd43a",         //连接线颜色
            lableCss: '',
            arrowCss: '',
            containerX: 0,
            widthPerUnit: 10,
            lineWidth: 2,
            maxWidth: 100,
            arrowStartCss: 'csLineArrowStart',
            arrowEndCss: 'csLineArrowEnd',
            startX: 0
        }
        Object.extend(this.options, options || {});
    },
    showLine: function(pointArray) {
        var This = this;
        var count = pointArray.length;
        var showPoints = new Array();
        for (var i = 0; i < count; i++) {
            var onePoint = pointArray[i];
            var showPoint = document.createElement("div");
            var spanValue = document.createElement("span");
            spanValue.Summary = onePoint.value.split("|")[1];
            ////wanghc 20140915
            if (spanValue.attachEvent){
            	spanValue.attachEvent("onmouseover", ShowDetailInfor);
            	spanValue.attachEvent("onmouseout", HiddenDetailInfor);
            }else{
	            spanValue.addEventListener("onmouseover", ShowDetailInfor,false);
            	spanValue.addEventListener("onmouseout", HiddenDetailInfor,false);
            }
            showPoint.isStart = onePoint.isStart;
            showPoint.isEnd = onePoint.isEnd;
            showPoint.NoEnd = onePoint.NoEnd;
            if (showPoint.isStart == true) {
                showPoint.className = this.options.arrowStartCss;
                //showPoint.Summary = escape(onePoint.value);
                //showPoint.attachEvent("onmouseover", ShowDetailInfor);
                //showPoint.attachEvent("onmouseout", HiddenDetailInfor);
            }
            else if (showPoint.isEnd == true) {
                showPoint.className = this.options.arrowEndCss;
                showPoint.style.width = this.options.pointWidth + "px";
                showPoint.style.height = this.options.pointHeight + "px";
            }
            showPoint.style.position = "absolute";
            showPoint.style.zIndex = "999";

            var summary = onePoint.value.split("|")[0];
            var spanWidth = 100;
            if (summary.length > 50) {
                summary = summary.substr(0, 50) + "...";
                spanWidth = 500;
            }
            else {
                spanWidth = summary.length * 12;
            }
            spanValue.style.position = "absolute";
            //var spanWidth = 480;
            //textSize(this.options.lableCss, summary);
            //            if (spanWidth > (this.options.maxWidth - 10)) {
            //                spanWidth = (this.options.maxWidth - 10)
            //            }
            spanValue.style.width = spanWidth + "px";
            spanValue.className = this.options.lableCss;
            spanValue.style.zIndex = "999";
            var left = parseInt(this.options.widthPerUnit * onePoint.xPoint, 10) + this.options.startX;

            showPoint.style.left = left + "px";
            showPoint.style.top = this.options.topDistance + "px";
            if ((left + spanWidth) > (this.options.maxWidth - 10)) {
                spanValue.style.left = (this.options.maxWidth - 10 - spanWidth) + "px";
            }
            else {
                spanValue.style.left = left + "px";
            }
            spanValue.style.top = (this.options.topDistance - this.options.pointHeight - 5) + "px";
            spanValue.innerHTML = summary;
            showPoints.push(showPoint);
            if (showPoint.isStart == true) {
                This.entity.appendChild(showPoint);
                //This.entity.appendChild(spanValue);
            }
            else if (showPoint.isEnd == true) {
                This.entity.appendChild(showPoint);
            }
            if (i == 0) {
                if (parseInt(spanValue.style.left.replace("px", ""), 10) < 5) {
                    spanValue.style.left = "5px";
                }
                This.entity.appendChild(spanValue);
            }
        }
        var length = showPoints.length
        for (var i = 0; i < length; i++) {
            if (i == 0) {
                var heightAdd = (this.options.pointHeight - this.options.lineWidth) / 2;
                if (showPoints[i].isEnd == true) {
                    This.drawLine(0,
													parseInt(showPoints[i].style.top.replace("px", ""), 10),
													parseInt(showPoints[i].style.left.replace("px", ""), 10),
													parseInt(showPoints[i].style.top.replace("px", ""), 10),
													this.options.pointWidth,
													heightAdd
													);
                }

                if (length == 1) {
                    if (showPoints[i].isStart == true) {
                        This.drawLine(parseInt(showPoints[i].style.left.replace("px", ""), 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    (this.options.maxWidth - 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    this.options.pointWidth,
													    heightAdd
													    );
                    }
                    else if (showPoints[i].isStart == false && showPoints[i].isEnd == false) {
                        This.drawLine(parseInt(showPoints[i].style.left.replace("px", ""), 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    (this.options.maxWidth - 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    this.options.pointWidth,
													    heightAdd
													    );
                    }
                }
            }
            else if (i > 0) {
                var heightAdd = (this.options.pointHeight - this.options.lineWidth) / 2;
                if (showPoints[i].isEnd == true) {
                    This.drawLine(parseInt(showPoints[i - 1].style.left.replace("px", ""), 10),
													parseInt(showPoints[i - 1].style.top.replace("px", ""), 10),
													parseInt(showPoints[i].style.left.replace("px", ""), 10),
													parseInt(showPoints[i].style.top.replace("px", ""), 10),
													this.options.pointWidth,
													heightAdd
													);
                }
                else if (showPoints[i].isStart == true) {
                    if (showPoints[i - 1].isStart == true) {
                        This.drawLine(parseInt(showPoints[i - 1].style.left.replace("px", ""), 10),
													parseInt(showPoints[i - 1].style.top.replace("px", ""), 10),
													parseInt(showPoints[i].style.left.replace("px", ""), 10),
													parseInt(showPoints[i].style.top.replace("px", ""), 10),
													this.options.pointWidth,
													heightAdd
													);
                    }
                    if (i == (length - 1)) {
                        This.drawLine(parseInt(showPoints[i].style.left.replace("px", ""), 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    (this.options.maxWidth - 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    this.options.pointWidth,
													    heightAdd
													    );
                    }
                }
                else if (showPoints[i].isStart == false && showPoints[i].isEnd == false) {
                    This.drawLine(parseInt(showPoints[i].style.left.replace("px", ""), 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    (this.options.maxWidth - 10),
													    parseInt(showPoints[i].style.top.replace("px", ""), 10),
													    this.options.pointWidth,
													    heightAdd
													    );
                }
            }
        }
        This.Constructor.call(This);
    },
    drawLine: function(startX, startY, endX, endY, pWidth, heightAdd) {
        startX = startX + (pWidth - 5);
        endX = (endX + 5);
        if ((endX - startX) < 0) {
            return;
        }
        startY = startY + heightAdd;
        endY = endY + heightAdd;
        var point = document.createElement("div");
        point.style.position = "absolute";
        point.style.backgroundColor = this.options.lineColor;
        point.style.fontSize = "0";
        point.style.width = (endX - startX) + "px";
        point.style.height = this.options.lineWidth + "px";

        point.style.top = endY + "px";
        point.style.left = startX + "px";
        this.entity.appendChild(point);
    },
    Constructor: function() {
        this.entity.style.position = "absolute";
        this.LineContainer.appendChild(this.entity);
    }
}

//取得文本的高度和宽度
function textSize(cssName, text) {
    var txtSpan = document.createElement("span");
    document.body.appendChild(txtSpan);
    txtSpan.style.visibility = "hidden";
    txtSpan.className = cssName;
    if (typeof txtSpan.textContent != "undefined") {
        txtSpan.textContent = text;
    }
    else {
        txtSpan.innerText = text;
    }
    var spanWidth = txtSpan.offsetWidth;
    txtSpan.parentNode.removeChild(txtSpan);
    return spanWidth;
}

//显示详细信息
function ShowDetailInfor() {
    var divInfor = document.getElementById(divDetailInforID);
    if (divInfor) {
        return;
    }
    var infor = event.srcElement.Summary;
    var divInfor = document.createElement("div");
    divInfor.id = divDetailInforID;
    var inforHtml = unescape(infor);
    var inforArray = inforHtml.split(",");
    for (var index = 0; index < inforArray.length;index++) {
        divInfor.innerHTML += inforArray[index] + "<br />";
    }
    //divInfor.innerHTML = unescape(infor);
    divInfor.style.top = (event.clientY + 5) + "px"; ;
    divInfor.style.left = (event.x + 5) + "px";
    divInfor.className = "csLineDivInfor";
    document.body.appendChild(divInfor);
}

//隐藏详细信息
function HiddenDetailInfor() {
    var divInfor = document.getElementById(divDetailInforID);
    if (divInfor) {
        divInfor.parentElement.removeChild(divInfor);
    }
}