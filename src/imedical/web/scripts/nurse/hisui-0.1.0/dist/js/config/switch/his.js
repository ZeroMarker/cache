/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description 护理病历开关配置-HIS相关
 */
$(function() { 
	var GLOBAL = {
		TabCode: 'His'
	};
	/**
	 * @description 初始化界面
	 */
	function initUI() {
		SwitchFunc.GetConfiguration(GLOBAL);
		listenEvents();
	}
	/**
	 * @description 保存
	 */
	function save() {
		var config = SwitchFunc.GetElementValue(GLOBAL, false, false);
		$cm({
			ClassName: "NurMp.Config",
			MethodName: "setValue",
			FieldName: "HisVersion",
			Value: config
		},function(ret){
			if (parseInt(ret) == 0) {
				$.messager.popover({ msg: '保存成功!', type: 'success' });
			} else {
				$.messager.popover({ msg: '保存失败!' + ret, type: 'error' });
			}
		});
	}
	/**
	 * @description 初始化动态元素
	 */
	function initSyncElements(item, value) {	
	}
	/**
	 * @description 事件监听
	 */
	function listenEvents() {
		$('#btnSave').bind('click',save);
	}
	initUI();
	
	return SwitchInTab = {
		InitSyncElements: initSyncElements
	}
});