var alertTitle = $g("alertTitle")
var SaveErrorTip = $g("SaveFail") ;
var UpdateErrorTip = $g("UpdateFail");
var DelHandlerTip = $g("DelSucc");
var alertMsg = $g("Press the key combination [Alt + T] to translate."); //�밴[Alt+T]��ϼ�,�ڵ���������з���
function SaveHandler(){
	$.messager.alert(alertTitle,SaveErrorTip);	//js�ڷ���
}
function UpdateHandler(){
	$.messager.alert(alertTitle,UpdateErrorTip);	//js�ڷ���
}
function DelHandler(){
	$.messager.alert(alertTitle,DelHandlerTip);
}
$(function(){
	$.messager.popover({msg: alertMsg, style:{top:10,left:document.body.scrollLeft/2},type:'alert',timeout: 0});
});