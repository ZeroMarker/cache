/*
 * @Descripttion: �������Խӻ���cdssͳһ���ý���
 * @Author: yaojining
 * @Date: 2022-06-22
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_CdssHm'
};
var init = function () {
	initHosp(formload);
	listenEvent();
	formload();
}

$(init);

/**
 * @description: ����
 */
function formload() {
	clearform();
	$cm({
		ClassName: 'NurMp.Common.Logic.Handler',
		MethodName: 'Find',
		ClsName: 'CF.NUR.EMR.CdssHm',
		TableName: GLOBAL.ConfigTableName,
		HospId: GLOBAL.HospitalID
	}, function (result) {
		if (result.status >= 0) {
			$('#formhm').form('load', result.data);
			loadextra(result.data);
		} else {
			$.messager.popover({ msg: result.msg + result.data, type: "error" });
		}
	});
}
/**
 * @description: ���������Ԫ��
 */
function loadextra(data) {
	//״̬
	var status = data.CHStatus == 'Y' ? true : false;
	$('#CHStatus').switchbox('setValue', status);
}
/**
 * @description: ���form
 */
function clearform() {
	$('#formhm').form('clear');
}
/**
 * @description: ����
 */
function save() {
	var viewelements = serializeForm('formhm');
	viewelements["CHHospDr"] = GLOBAL.HospitalID;
	var status = $('#CHStatus').switchbox('getValue');
	viewelements["CHStatus"] = status ? 'Y' : 'N';
	if (!viewelements["CHSdkPath"]) {
		$.messager.alert('��ʾ', '������JSSDK·����');
		return;
	}
	if (!viewelements["CHAutherKey"]) {
		$.messager.alert('��ʾ', '��������֤��Կ��');
		return;
	}
	if (!viewelements["CHExtendJsPath"]) {
		$.messager.alert('��ʾ', '��������չJS·����');
		return;
	}
	if(viewelements["CHStatus"] == 'Y') {
		$.messager.confirm('��Ҫ����', '�����ڿ���cdss����ȷ������CDSS�Ѿ���ͨ������������ȫ��ȷ�������Ӱ�쵽����������ҵ��',function(r){
			if (r) {
				$cm({
					ClassName: 'NurMp.Common.Logic.Handler',
					MethodName: 'SaveOneByIndex',
					ClsName: 'CF.NUR.EMR.CdssHm',
					IndexList: JSON.stringify({ Name: 'Hosp', Value: GLOBAL.HospitalID }),
					Param: JSON.stringify(viewelements)
				}, function (result) {
					if (result.status >= 0) {
						$.messager.popover({ msg: result.msg, type: "success" });
					} else {
						$.messager.popover({ msg: result.msg + result.data, type: "error" });
					}
				});
			} else {
				return;
			}
		});
	} else {
		$cm({
			ClassName: 'NurMp.Common.Logic.Handler',
			MethodName: 'SaveOneByIndex',
			ClsName: 'CF.NUR.EMR.CdssHm',
			IndexList: JSON.stringify({ Name: 'Hosp', Value: GLOBAL.HospitalID }),
			Param: JSON.stringify(viewelements)
		}, function (result) {
			if (result.status >= 0) {
				$.messager.popover({ msg: result.msg, type: "success" });
			} else {
				$.messager.popover({ msg: result.msg + result.data, type: "error" });
			}
		});
	}
	
	
}
/**
 * @description ��ȡָ��form�е����е�<input>����   
 */
function getElements(formId) {
	var form = document.getElementById(formId);
	var elements = new Array();
	var tagElements = form.getElementsByTagName('input');
	for (var j = 0; j < tagElements.length; j++) {
		elements.push(tagElements[j]);
	}
	return elements;
}
/**
 * @description ���л�formԪ�� 
 */
function serializeForm(formId) {
	var obj = {};
	var elements = getElements(formId);
	for (var i = 0; i < elements.length; i++) {
		if (!elements[i].name) continue;
		if (elements[i].type == "checkbox") {
			var ckVal = elements[i].checked ? "Y" : "N";
			obj[elements[i].name] = ckVal;
		} else {
			obj[elements[i].name] = elements[i].value;
		}
	}
	return obj;
}
/**
 * @description: ��cdss���ý���
 */
function showModelSet() {
	var operationWin = websys_createWindow("nur.emr.config.cdss.hmset.csp?HospitalID="+GLOBAL.HospitalID, "����CDSS��������������", "top=200,left=400,width=75%,height=60%,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}
/**
 * @description: �¼�
 */
function listenEvent() {
	$('#btnsave').bind('click', save);
	$('#btnmodelset').bind('click', showModelSet);
}
