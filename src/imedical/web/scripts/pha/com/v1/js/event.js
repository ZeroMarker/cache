/**
 * ����:	 ҩ�������¼���
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 */
$(function () {
	/**
	 * ��ť�Ҽ����ÿ�ݼ�
	 */
	$("a[id]").on("contextmenu", function (e) {
		e.preventDefault();
		var _domObj = this;
		PHA_PLUS.Key("Menu", _domObj);
	});
	/**
	 * �������¼�
	 */

});
var PHA_EVENT = {
	Key: function () {
		/**
		 * ��ʼ�������¼�
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
		 * key�¼�һ�ΰ�
		 */
		hotkeys(BtnKeyCodeArr.join(","), function (e, h) {
			e.preventDefault();
			$("#" + BtnKeyArr[BtnKeyCodeArr.indexOf(h.key)]).click();
			return false;
		});
	}
};
// �������κα�ǩ,ȫ��������
hotkeys.filter = function (event) {
	//  var tagName = (event.target || event.srcElement).tagName;
	//  hotkeys.setScope(/^(INPUT|TEXTAREA|SELECT)$/.test(tagName) ? 'input' : 'other');
	return true;
}
PHA_EVENT.Key();