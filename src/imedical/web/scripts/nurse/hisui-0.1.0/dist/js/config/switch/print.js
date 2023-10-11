/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description ��������������-��ӡ���
 */
$(function() { 
	var GLOBAL = {
		TabCode: 'Print'
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
		$('#btnManUpdate').bind('click', PrintActivexUpgrade);
	}
	initUI();
	
	return SwitchInTab = {
		InitSyncElements: initSyncElements
	}
});