//日期时间框双击事件
function myfun() {
	$(".combo-text").on("dblclick", function () {
		var date = new Date();
		var _this = $(this).parent().prev();

		if (_this.hasClass("hisui-datebox")) {
			var value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
			_this.datebox('setValue', value);
		} else if (_this.hasClass("hisui-datetimebox")) {
			var value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();
			_this.datetimebox('setValue', value);
		}
	});

	$(".hisui-timespinner").dblclick(function () {
		var now = (new Date()).format("HH:mm");
		$(this).val(now);
	});

}
//window.onload = myfun;