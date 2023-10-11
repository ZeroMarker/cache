/*
 * @Descripttion: 护理病历开关配置-CA认证
 * @Author: yaojining
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ClsName: 'CF.NUR.EMR.CA',
	ConfigTableName: 'Nur_IP_CA',
	PageCode: 'CA'
};
/**
 * @description 初始化界面
 */
function initUI() {
	initHosp(queryValues);
	initCondition();
	listenEvents();
}

$(initUI);

/**
 * @description 初始化条件
 */
function initCondition() {
	$HUI.combobox('#TabletValue', {
		valueField: 'id',
		textField: 'text',
		value: 'none',
		data: [
			{ id: 'none', text: "无" },
			{ id: 'DCDSV1', text: "信手书1.0" },
			{ id: 'DCDSV2', text: "信手书2.0" },
			{ id: 'HNCA', text: "河南CA" }
		],
		onSelect: function (record) {
			if (record.id != 'none') {
				if (record.id == "HNCA") {
					$('.serverIpTr').show();
				} else {
					$('.serverIpTr').hide();
				}
			} else {
				$('#ServiceIp').val('');
				$('.serverIpTr').hide();
			}
			// 严格身份模式
			if (record.id.indexOf('DCDSV') > -1) {
				$('.BJCAStrictIdentityTr').show();
			} else {
				$('.BJCAStrictIdentityTr').hide();
			}

		},
	});
	$HUI.combobox('#SignType', {
		valueField: 'id',
		textField: 'text',
		value: 'none',
		data: [
			{ id: 'none', text: "无" },
			{ id: 'UKEY', text: "UKEY" },
			{ id: 'PHONE', text: "PHONE" },
			{ id: 'PINPHONE', text: "PINPHONE" },
			{ id: 'FACE', text: "FACE" }
		]
	});
	$HUI.combobox("#ServerFactory", {
		valueField: 'ID',
		textField: 'Text',
		url: $URL + '?ClassName=NurMp.Service.CA.Handle&MethodName=getVerder',
		defaultFilter: 4
	});
	$HUI.combobox('#CAPatientPDFShowLogonType', {
		valueField: 'id',
		textField: 'text',
		value: 'PDFPad',
		multiple:true,
		rowStyle:'checkbox',
		panelHeight:"auto",
		data: [
			{ id: 'PDFWeChat', text: "微信小程序" },
			{ id: 'PDFPad', text: "Pad" }
		]
	});
}
/**
 * @description 保存
 */
function save() {
	var config = getElementValue(true, true);
	$cm({
		ClassName: "NurMp.Service.CA.Handle",
		MethodName: "save",
		parr: config,
		HospitalID: GLOBAL.HospitalID
	}, function (ret) {
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
function initSyncElements(item, value, jsonData) {
	if (item == 'SignPWDSwitchFlag') {
		if (JSON.parse(value) == true) {
			$('.cmTr').show();
			$('#SignPWDClassFunc').val(jsonData['SignPWDClassFunc']);
		} else {
			$('.cmTr').hide();
		}
	}
	if (item == 'SwitchFlag') {
		if (JSON.parse(value) == true) {
			$('.realCATr').show();
			$('#PictureFlag').switchbox('setValue', JSON.parse(jsonData['PictureFlag']));
			$('#ValidateFlag').switchbox('setValue', JSON.parse(jsonData['ValidateFlag']));
			$('#StrictFlag').switchbox('setValue', JSON.parse(jsonData['StrictFlag']));
		} else {
			$('.realCATr').hide();
		}
	}
	if (item == 'CAPuppet') {
		if (JSON.parse(value) == true) {
			$('.fakeCATr').show();
			$('#CAPuppetClassFunc').val(jsonData['CAPuppetClassFunc']);
		} else {
			$('.fakeCATr').hide();
		}
	}
	if (item == 'TabletValue') {
		if (String(value) == 'HNCA') {
			$('.serverIpTr').show();
		} else {
			$('.serverIpTr').hide();
		}
		if (String(value).indexOf('DCDSV') > -1) {
			$('.BJCAStrictIdentityTr').show();
			setTimeout(function(){
				$('#BJCAStrictIdentity').radio('setValue', JSON.parse(jsonData['BJCAStrictIdentity']));
			},200);
		} else {
			$('.BJCAStrictIdentityTr').hide();
		}
	}
}
/**
 * @description 事件监听
 */
function listenEvent() {
	$('#SwitchFlag').switchbox('options').onSwitchChange = function (e, obj) {
		$('.realCATr').toggle();
	};
	$('#CAPuppet').switchbox('options').onSwitchChange = function (e, obj) {
		$('.fakeCATr').toggle();
	};
	$('#SignPWDSwitchFlag').switchbox('options').onSwitchChange = function (e, obj) {
		$('.cmTr').toggle();
	};
}
