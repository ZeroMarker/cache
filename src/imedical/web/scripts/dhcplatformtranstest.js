var alertTitle = $g("alertTitle")
var SaveErrorTip = $g("SaveFail") ;
var UpdateErrorTip = $g("UpdateFail");
var DelHandlerTip = $g("DelSucc");
var alertMsg = $g("Press the key combination [Alt + T] to translate."); //请按[Alt+T]组合键,在弹出界面进行翻译
function SaveHandler(){
	$.messager.alert(alertTitle,SaveErrorTip);	//js内翻译
}
function UpdateHandler(){
	$.messager.alert(alertTitle,UpdateErrorTip);	//js内翻译
}
function DelHandler(){
	$.messager.alert(alertTitle,DelHandlerTip);
}
$(function(){
	$.messager.popover({msg: alertMsg, style:{top:10,left:document.body.scrollLeft/2},type:'alert',timeout: 0});
});