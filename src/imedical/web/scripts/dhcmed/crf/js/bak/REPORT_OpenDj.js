/*
 * 该文件负责打开报表的时候进行的数据的获取等功能
 * 作  者：liyansheng
 * 时  间：2011-11-18
 * 注  意：使用该文件时候请在前面引用jQuery-1.4.1类库
 */

 //报表数据
function GetReport() {
    var ret = "";
    if (window.opener != null && window.opener != "undefined") {
        ret = window.opener.curData;
    }
    return ret;
}


//取消事件
function UnBindEvent() {
    $(document).find("*").unbind();
    $(document).find("*").removeAttr("onmouseover");
    $(document).find("*").removeAttr("onmouseout");
}

//打印相关处理
function DoPrinted() {
    //打印：调整样式
    $(document).find("*").css("background-color", "white");
    $("#SKbillsheet").find("button").css("display", "none");
}


 //加载报表数据
 function DoBLLoadReport(parReport) {
     var parObj = parReport;
     for (var d in parObj) {
         var oval = d.toString();
         $("[selectedFields = '" + oval + "']").text(parObj[oval]);
         $("[selectedFields = '" + oval + "']").css("padding","2px;");
     }
 }


 $(document).ready(function () {

    //取消事件
     UnBindEvent();

     //打印样式处理
     DoPrinted();

     //加载数据
     DoBLLoadReport(GetReport());
 });