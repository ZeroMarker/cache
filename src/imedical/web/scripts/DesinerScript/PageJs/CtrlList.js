//判断点击时是否执行了添加控件的事件
var addCtrlEvent = false;

$(document).ready(function() {
    $(".Toolheader").click(ToolClassClick);
    $(".CtrlItem").mouseover(CtrlItem_Over);
    $(".CtrlItem").mouseout(CtrlItem_Out);
    $(".CtrlItem").mousedown(CtrlItem_Down);
    $(".CtrlItem").mouseup(CtrlItem_Up);
    $(".CtrlItem").click(CtrlItem_Click);
    this.body.onclick = frmCtrlList_click;
});
//点击控件类别栏,展开或关闭相应控件列表
function ToolClassClick() {
    if ($(this).next().css("display") == "none") {
        $(this).find("div").removeClass();
        $(this).find("div").addClass("ToolIcon_Exp");
    } else {
        $(this).find("div").removeClass();
        $(this).find("div").addClass("ToolIcon_Col");
    }
    $(this).next().toggle(400);
}

//鼠标移动到控件项上时的样式
function CtrlItem_Over() {
    $(this).addClass("CtrlItem_Over");
}

//鼠标移出到控件项上时的样式
function CtrlItem_Out() {
    $(this).removeClass("CtrlItem_Over");
    $(this).removeClass("CtrlItem_Down");
}

//鼠标按下时的样式
function CtrlItem_Down() {
    $(this).addClass("CtrlItem_Down");
}

//鼠标松开时的样式
function CtrlItem_Up() {
    $(this).removeClass("CtrlItem_Down");
}

//鼠标点击时执行的操作
function CtrlItem_Click() {
    addCtrlEvent = true;
    
    var ctrlType = $(this).attr("ctrlType");
    parent.frLayout.editor.AddCtrl(ctrlType);
}

// 修复 IE 下 PNG 图片不能透明显示的问题
function fixPNG(myImage) {
    var arVersion = navigator.appVersion.split("MSIE");
    var version = parseFloat(arVersion[1]);
    if ((version >= 5.5) && (version < 7) && (document.body.filters)) {
        var imgID = (myImage.id) ? "id='" + myImage.id + "' " : "";
        var imgClass = (myImage.className) ? "class='" + myImage.className + "' " : "";
        var imgTitle = (myImage.title) ? "title='" + myImage.title + "' " : "title='" + myImage.alt + "' ";
        var imgStyle = "display:inline-block;" + myImage.style.cssText;
        var strNewHTML = "<span " + imgID + imgClass + imgTitle
           + " style=\"" + "width:" + myImage.width
           + "px; height:" + myImage.height
           + "px;" + imgStyle
           + "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader"
           + "(src=\'" + myImage.src + "\');\"></span>";
        myImage.outerHTML = strNewHTML;
    }
}

//页面点击时的处理
function frmCtrlList_click() {
    if (addCtrlEvent) {
        addCtrlEvent = false;
    }
    else {
        //parent.frLayout.editor.options.selectCtrls = new Array();
        parent.frLayout.editor.ShowCtrlSelEdge();
    }
}