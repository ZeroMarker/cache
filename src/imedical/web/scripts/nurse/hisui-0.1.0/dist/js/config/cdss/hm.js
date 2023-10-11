/*
 * @Descripttion: 护理病历对接惠美cdss统一配置界面
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
 * @description: 加载
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
 * @description: 加载特殊的元素
 */
function loadextra(data) {
	//状态
	var status = data.CHStatus == 'Y' ? true : false;
	$('#CHStatus').switchbox('setValue', status);
}
/**
 * @description: 清空form
 */
function clearform() {
	$('#formhm').form('clear');
}
/**
 * @description: 保存
 */
function save() {
	var viewelements = serializeForm('formhm');
	viewelements["CHHospDr"] = GLOBAL.HospitalID;
	var status = $('#CHStatus').switchbox('getValue');
	viewelements["CHStatus"] = status ? 'Y' : 'N';
	if (!viewelements["CHSdkPath"]) {
		$.messager.alert('提示', '请输入JSSDK路径！');
		return;
	}
	if (!viewelements["CHAutherKey"]) {
		$.messager.alert('提示', '请输入认证密钥！');
		return;
	}
	if (!viewelements["CHExtendJsPath"]) {
		$.messager.alert('提示', '请输入扩展JS路径！');
		return;
	}
	if(viewelements["CHStatus"] == 'Y') {
		$.messager.confirm('重要提醒', '您正在开启cdss，请确保惠美CDSS已经调通且以上配置完全正确，否则会影响到护理病历正常业务！',function(r){
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
 * @description 获取指定form中的所有的<input>对象   
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
 * @description 序列化form元素 
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
 * @description: 打开cdss设置界面
 */
function showModelSet() {
	var operationWin = websys_createWindow("nur.emr.config.cdss.hmset.csp?HospitalID="+GLOBAL.HospitalID, "惠美CDSS护理病历参数设置", "top=200,left=400,width=75%,height=60%,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
}
/**
 * @description: 事件
 */
function listenEvent() {
	$('#btnsave').bind('click', save);
	$('#btnmodelset').bind('click', showModelSet);
}
