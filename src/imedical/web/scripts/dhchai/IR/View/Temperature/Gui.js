//页面Gui
function InitTemperatureWin(){
	var obj = new Object();
    $("#cboWeeks").attr("data-param",PaadmID)
    $.form.SelectRender('cboWeeks');

	InitTemperatureWinEvent(obj);
	return obj;
}
