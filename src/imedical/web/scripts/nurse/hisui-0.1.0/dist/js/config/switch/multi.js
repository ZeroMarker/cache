/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description ��������������-�����Զ�Ժ��
 */
$(function() { 
	var GLOBAL = {
		TabCode: 'Multi'
	};
	/**
	 * @description ��ʼ������
	 */
	function initUI() {
		SwitchFunc.GetConfiguration(GLOBAL.TabCode);
		listenEvents();
	}
	/**
	 * @description ����
	 */
	function save() {
		var config = SwitchFunc.GetElementValue(GLOBAL.TabCode, true, true);
		$cm({
			ClassName: "NurMp.Service.Switch.Config",
			MethodName: "save",
			parr: config,
			HospitalID: '',
			DeptType: 'I'
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