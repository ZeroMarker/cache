/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description ��������������-HIS���
 */
$(function() { 
	var GLOBAL = {
		TabCode: 'His'
	};
	/**
	 * @description ��ʼ������
	 */
	function initUI() {
		SwitchFunc.GetConfiguration(GLOBAL);
		listenEvents();
	}
	/**
	 * @description ����
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
				$.messager.popover({ msg: '����ɹ�!', type: 'success' });
			} else {
				$.messager.popover({ msg: '����ʧ��!' + ret, type: 'error' });
			}
		});
	}
	/**
	 * @description ��ʼ����̬Ԫ��
	 */
	function initSyncElements(item, value) {	
	}
	/**
	 * @description �¼�����
	 */
	function listenEvents() {
		$('#btnSave').bind('click',save);
	}
	initUI();
	
	return SwitchInTab = {
		InitSyncElements: initSyncElements
	}
});