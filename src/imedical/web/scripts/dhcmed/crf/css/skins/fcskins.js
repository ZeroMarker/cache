


Eform.Skins = function(){}
Eform.Skins.prototype =
{
preloadImages : function preloadImages(imagesPath) {
},
radio_checkbox : function (elType) {
var arr = fcpubdata.controls[elType];
if(typeof(arr) == "undefined" || arr == null) return;
for (var i = 0; i < arr.length; i++) {
for (var j = 0; j < arr[i].childNodes.length; j++) {
var curEle = arr[i].childNodes(j) ;
if(curEle.tagName == "SPAN"){
if(IsSpace(curEle.className))
curEle.className = "ef_"+elType+"_label";
}
if(curEle.tagName == "INPUT"){
curEle.className = "ef_out";
var statu=curEle.checked;
var oSpanLabel = curEle.nextSibling ;
var sDisabledCss = "out";
if(curEle.parentNode.disabled) sDisabledCss = "disabled";
var elem=curEle.parentNode.insertBefore(document.createElement("<span class='ef_input_"+elType+"_"+(statu?"":"no")+"check_"+sDisabledCss+"'></span>"),curEle);
j++;
elem.onclick = function (){
var curObj = event.srcElement;
if(curObj.parentNode.disabled) return;
if(curObj.className.indexOf('ef_input') < 0) curObj = curObj.previousSibling.previousSibling ;
var obj = curObj.nextSibling;
if(typeof(obj) == "undefined" || obj == null) return;
var cls=curObj.className;
if(cls.indexOf("no")>-1){
curObj.className=cls.replace("_nocheck_","_check_");
obj.checked=true;
}else{
if(elType=="checkbox"){
curObj.className=cls.replace("_check_","_nocheck_");
obj.checked=false;
}
}
if(obj.type=="radio"){
var radioEl=document.getElementsByName(obj.name);
for(var i=radioEl.length;i>0;i--){
if(radioEl[i-1].type&&radioEl[i-1].type=="radio"){
radioEl[i-1].previousSibling.className=radioEl[i-1].previousSibling.className.replace(/ef_input_radio_[^_]+_(out|over)/,"ef_input_radio_"+(radioEl[i-1].checked?"":"no")+"check_$1");
}
}
}
};

elem.onmouseover=function(){
this.className=this.className.replace("out","over");
};
elem.onmouseout=function(){
this.className=this.className.replace("over","out");
}
if(oSpanLabel.tagName == "SPAN"){
oSpanLabel.onclick = elem.onclick;
}

}
}
}
},
button : function(){
var arr = fcpubdata.controls["button"];
if(typeof(arr) == "undefined" || arr == null) return;
for (var i = 0; i < arr.length; i++) {
var oButton = arr[i];
if(IsSpace(oButton.style.backgroundImage) == false) continue;
var btnWidth=oButton.clientWidth;
var objXY = Sys.UI.DomElement.getLocation(oButton);
if(oButton.style.position == "absolute"){
objXY.x = oButton.style.pixelLeft;
objXY.y = oButton.style.pixelTop;
btnWidth = oButton.style.pixelWidth;
}
var sDisplay="",sDisabled="";
if(oButton.style.display=="none") sDisplay = "display:none;" ;
if(oButton.disabled) sDisabled = "disabled";
var elm=oButton.parentNode.insertBefore(document.createElement("<div "+sDisabled+" style='cursor:default;"+sDisplay+"position:absolute;top:"+objXY.y+"px;left:"+objXY.x+"px;width:"+btnWidth+"px;'></div>"),oButton);
var lBg=elm.appendChild(document.createElement("<div class='ef_input_button_out' style='float:left'></div>"));
lBg.innerHTML="<div style='float:left;width:5px'></div><div style='width:"+(btnWidth-10)+"px;height:100%;float:left;text-align:center;'>"+oButton.value+"</div>";
var rBg=elm.appendChild(document.createElement("<div style='float:left;width:5px' class='ef_input_button_right_out'></div>"));

elm.onmouseover=Function.createCallback(Function.createDelegate(this,this._button),["out","over"]);
elm.onmouseout=Function.createCallback(Function.createDelegate(this,this._button),[/over|down/,"out"]);
elm.onmousedown=Function.createCallback(Function.createDelegate(this,this._button),["over","down"]);
elm.onmouseup= Function.createCallback(Function.createDelegate(this,this._button),["down","over"]);

elm.onclick=oButton.onclick;
elm.id = oButton.id ;
oButton.outerHTML = "";
}
},
_button : function(arr){
var class1 = arr[0],class2=arr[1];
var obj = event.srcElement;
var lBg ,rBg;
if(obj.className.startsWith("ef_input_button_")){
lBg = obj;rBg=lBg.nextSibling;
} else if (obj.className.endsWith("ef_input_button_right_")){
lBg = obj.previousSibling;rBg=obj;
}else if(IsSpace(obj.id) == false && obj.childNodes.length == 2){
lBg = obj.childNodes(0);
rBg = obj.childNodes(1);
}else {
lBg = obj.parentNode;rBg = lBg.nextSibling;
}
if(lBg != null)
if(IsSpace(lBg.className) ==false) lBg.className=lBg.className.replace(class1,class2);
if(rBg != null)
if(IsSpace(rBg.className) ==false) rBg.className=rBg.className.replace(class1,class2);
},
textbox : function () {
var arr = fcpubdata.controls["text"];
if(typeof(arr) == "undefined" || arr == null) return;
for (var i = 0; i < arr.length; i++) {
var oText = arr[i];
Sys.UI.DomElement.addCssClass(oText,"ef_input_text_out");
oText.onmouseover=function(){
event.srcElement.className=event.srcElement.className.replace("out","over");
};
oText.onmouseout=function(){
event.srcElement.className=event.srcElement.className.replace("over","out");
};
}
},
textarea : function () {
var arr = fcpubdata.controls["textarea"];
if(typeof(arr) == "undefined" || arr == null) return;
for (var i = 0; i < arr.length; i++) {
var oText = arr[i];
Sys.UI.DomElement.addCssClass(oText,"ef_input_text_out");
oText.onmouseover=function(){
event.srcElement.className=event.srcElement.className.replace("out","over");
};
oText.onmouseout=function(){
event.srcElement.className=event.srcElement.className.replace("over","out");
};
}
},
label : function () {
var arr = fcpubdata.controls["label"];
if(typeof(arr) == "undefined" || arr == null) return;
for (var i = 0; i < arr.length; i++) {
var oText = arr[i];
Sys.UI.DomElement.addCssClass(oText,"ef_input_label_out");
}
},
init : function (){
this.radio_checkbox("radio");
this.radio_checkbox("checkbox");
this.button();
this.textbox();
this.textarea();
this.label();
}
}
if(Type.parse("Eform.Skins") == null) Eform.Skins.registerClass("Eform.Skins");
