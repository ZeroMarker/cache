/**
 * 名称:	 药房公共事件绑定
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12
 */
$(function () {
	/**
	 * 按钮右键设置快捷键
	 */
	$("a[id]").on("contextmenu", function (e) {
		e.preventDefault();
		var _domObj = this;
		PHA_PLUS.Key("Menu", _domObj);
	});
	/**
	 * 列设置事件
	 */

});
var PHA_EVENT = {
	Key: function () {
		/**
		 * 初始化配置事件
		 */
		var BtnKeyJson = {
			"btnFind": "alt+F",
			"btnSave": "f2"
		}
		var BtnKeyArr = [];
		var BtnKeyCodeArr = [];
		for (var btnId in BtnKeyJson) {
			BtnKeyArr.push(btnId);
			BtnKeyCodeArr.push(BtnKeyJson[btnId]);
		}
		/**
		 * key事件一次绑定
		 */
		hotkeys(BtnKeyCodeArr.join(","), function (e, h) {
			e.preventDefault();
			$("#" + BtnKeyArr[BtnKeyCodeArr.indexOf(h.key)]).click();
			return false;
		});
	}
};
// 不考虑任何标签,全部起作用
hotkeys.filter = function (event) {
	//  var tagName = (event.target || event.srcElement).tagName;
	//  hotkeys.setScope(/^(INPUT|TEXTAREA|SELECT)$/.test(tagName) ? 'input' : 'other');
	return true;
}
PHA_EVENT.Key();