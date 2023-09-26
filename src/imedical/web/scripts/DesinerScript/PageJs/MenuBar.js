//判断点击时是否执行了命令
var excutCmdEvent = false;

$(document).ready(function() {
 $("td[name = 'menuItem']").mouseover(MenuItem_Over);
 $("td[name = 'menuItem']").mouseout(MenuItem_Out);
 $("td[name = 'menuItem']").mousedown(MenuItem_Down);
 $("td[name = 'menuItem']").mouseup(MenuItem_Up);
 $("td[name = 'menuItem']").click(MenuItem_Click);
 this.body.onclick = frmMenuBar_click;
});
 
 function MenuItem_Over() {
     $(this).removeClass();
     $(this).addClass("menuItem_Over");
 }
 function MenuItem_Out() {
     $(this).removeClass();
     $(this).addClass("menuItem_Normal");
 }
 function MenuItem_Down() {
     $(this).removeClass();
     $(this).addClass("menuItem_Down");
 }
 function MenuItem_Up() {
     $(this).removeClass();
     $(this).addClass("menuItem_Over");
 }
 
 //点击菜单项时执行的操作
 function MenuItem_Click() {
     excutCmdEvent = true;
     var comand = $(this).attr("cmd");
     parent.frLayout.editor.ExcuteCmd(comand);
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
 function frmMenuBar_click() {
     if (excutCmdEvent) {
         excutCmdEvent = false;
     }
     else {
         //parent.frLayout.editor.options.selectCtrls = new Array();
         parent.frLayout.editor.ShowCtrlSelEdge();
     }
 }