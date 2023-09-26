//取得控件的x坐标
function findPosX(obj) {
    var curleft = 0;
    //返回父类元素，大多说offsetParent返回body
    if (obj.offsetParent) {
        //遍历所有父类元素
        while (obj.offsetParent) {
            //当前元素的左边距
            curleft += obj.offsetLeft;
            obj = obj.offsetParent;
        }
    } else if (obj.x) curleft += obj.x;
    return curleft;
}

//取得控件的Y坐标
function findPosY(obj) {
    var curtop = 0;

    if (obj.offsetParent) {
        while (obj.offsetParent) {

            curtop += obj.offsetTop;
            obj = obj.offsetParent;
        }
    } else if (obj.y) curtop += obj.y;
    return curtop;
}

//转化为日期的字符串形式转化为时间形式
function ConvertToDateValue(dateTxt) {
    if (dateTxt == "") {
        return "";
    }
    var dtArry = dateTxt.split("-");
    var dtValue = new Date(dtArry[0], parseInt(dtArry[1], 10) - 1, dtArry[2]);
    return dtValue;
}

//将日期的时间形式转化为字符串形式
function formatDate(d) {
    var _todayDate = d.getDate();
    var _year = d.getFullYear();
    var _month = d.getMonth() + 1;
    if ((_month + "").length < 2) {
        _month = "0" + _month;
    }
    if ((_todayDate + "").length < 2) {
        _todayDate = "0" + _todayDate;
    }
    return _year + "-" + _month + "-" + _todayDate;
}

//取得日期和周几
function GetDateAndWeekDay(dateTxt) {
    var dtArr = dateTxt.split("-");
    var dt = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    var weekDay = dt.getDay();
    var weekDayTxt = "";
    switch (weekDay) {
        case 0: weekDayTxt = "(日)"; break;
        case 1: weekDayTxt = "(一)"; break;
        case 2: weekDayTxt = "(二)"; break;
        case 3: weekDayTxt = "(三)"; break;
        case 4: weekDayTxt = "(四)"; break;
        case 5: weekDayTxt = "(五)"; break;
        case 6: weekDayTxt = "(六)"; break;
    }

    return dateTxt + "&nbsp" + weekDayTxt;
}

//取得某月有多少天
function getDaysInMonth(yearvalue, monthvalue) {
    yearvalue = parseInt(yearvalue, 10);
    monthvalue = parseInt(monthvalue, 10);
    var datevalue = "";
    if (monthvalue == 1 || monthvalue == 3 || monthvalue == 5 || monthvalue == 7 || monthvalue == 8 || monthvalue == 10 || monthvalue == 12) {
        datevalue = 31;
    }
    else if (monthvalue == 4 || monthvalue == 6 || monthvalue == 9 || monthvalue == 11) {
        datevalue = 30;
    }
    else if (monthvalue == 2) {
        var leapYear = (((yearvalue % 4 == 0) && (yearvalue % 100 != 0)) || (yearvalue % 400 == 0)) ? 1 : 0;
        if (leapYear) {
            datevalue = 29;
        }
        else {
            datevalue = 28;
        }
    }
    return datevalue;
}

//设定禁止网页放大
function ForbidBlowup() {
    //禁止网页放大
    if (document.addEventListener) {
        document.addEventListener('DOMMouseScroll', scrollFunc, false);
    }
    window.onmousewheel = document.onmousewheel = scrollFunc;
}

//禁止网页放大
var scrollFunc = function(e) {
    e = e || window.event;
    //IE/Opera/Chrome  
    if (e.wheelDelta && event.ctrlKey) {
        event.returnValue = false;
    } else if (e.detail) {
        //Firefox  
        event.returnValue = false;
    }
}

//从URL中取得参数
function getUrlParam() {
    var URLParams = new Array();
    var aParams = location.search.substr(1).split('&');
    for (i = 0; i < aParams.length; i++) {
        var aParam = aParams[i].split('=');
        var oneParam = new Object();
        oneParam.Key = aParam[0];
        oneParam.Value = aParam[1];
        URLParams.push(oneParam);
    }
    return URLParams;
}