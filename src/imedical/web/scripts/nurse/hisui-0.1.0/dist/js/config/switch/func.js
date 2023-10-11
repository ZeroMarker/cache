/*
 * @Descripttion: 功能开关配置-功能js
 * @Author: yaojining
 */

var Page = location.href.split("csp/")[1];

/**
 * @description 取元素
 */
function getElementArr() {
	var arrItem = $cm({
		ClassName: 'NurMp.Service.Switch.Config',
		MethodName: 'getSwitchElements',
		Type: GLOBAL.PageCode,
		ClsName: GLOBAL.ClsName
	}, false);
	return arrItem;
}
/**
 * @description 查询配置信息
 */
function getConfiguration() {
	$cm({
		ClassName: "NurMp.Service.Switch.Config",
		MethodName: "getConfiguration",
		HospitalID: GLOBAL.HospitalID || '',
		PageCode: GLOBAL.PageCode,
		GroupID: '',
		LocID: $("#cbLoc").length > 0 ? $("#cbLoc").combobox("getValue") : '',
		ModelID: ($('#cbModel').length > 0) && (!!$('#cbModel').combotree('tree').tree('getSelected')) ? $('#cbModel').combotree('tree').tree('getSelected').id : ''
	}, function (jsonData) {
		if (!$.isEmptyObject(jsonData)) {
			for (var item in jsonData) {
				var domID = '#' + item;
				var itemValue = jsonData[item];
				var domType = $(domID).attr('class');
				if (!!domType) {
					if (item.indexOf('Backcolor') > -1) {
						$(domID).color('setValue', itemValue);
					} else {
						if (domType.indexOf('combobox') > -1) {
							$(domID).combobox('setValues', itemValue.split(','));
						} else if (domType.indexOf('textbox') > -1) {
							$(domID).val(itemValue);
						} else if (domType.indexOf('switchbox') > -1) {
							var switchVal = JSON.parse(itemValue);  //itemValue == true ? true : false;
							$(domID).switchbox('setValue', switchVal);
						}
					}
				} else if (domID.indexOf('Group') > -1) {
					var name = $(domID).selector.split('#')[1];
					$HUI.radio("input[name='" + name + "']").setValue(false);
					if (!!itemValue) {
						var arrValue = itemValue.split(/,/);
						$.each(arrValue, function (index, value) {
							$HUI.radio("input[name='" + name + "'][value='" + value + "']").setValue(true);
						});
					}
				} else {
					var name = $(domID).selector.split('#')[1];
					$HUI.radio("input[name='" + name + "']").setValue(false);
					$HUI.radio("input[name='" + name + "'][value='" + itemValue + "']").setValue(true);
				}
				if (typeof initSyncElements == 'function') {
					initSyncElements(item, itemValue);
				}
			}
		}
	});
}
/**
 * @description 取各个元素值
 */
function getElementValue(boolFlag, AtFlag) {
	var result = '';
	$.each(getElementArr(), function (index, domID) {
		var domVal = '';
		var domType = $('#' + domID).attr('class');
		if (!!domType) {
			if (domID.indexOf('Backcolor') > -1) {
				domVal = $('#' + domID).color('getValue');
			} else {
				if (domType.indexOf('combobox') > -1) {
					arrVals = $('#' + domID).combobox('getValues');
					domVal = arrVals.join(',');
				} else if (domType.indexOf('textbox') > -1) {
					domVal = $('#' + domID).val();
				} else if (domType.indexOf('switchbox') > -1) {
					domVal = $('#' + domID).switchbox('getValue');
					if (!boolFlag) {
						domVal = domVal ? '1' : '0';
					}
				} else if (domType.indexOf('hisui-radio') > -1) {
					domVal = $('#' + domID).radio('getValue');
					if (!boolFlag) {
						domVal = domVal ? '1' : '0';
					}
				}
			}
		} else if (domID.indexOf('Group') > -1) {
			$("input[name=" + domID + "]").each(function (index, item) {
				if (item.checked) {
					domVal = !!domVal ? domVal + ',' + item.value : item.value;
				}
			});
		} else {
			domVal = $("input[name=" + domID + "]:checked").val();
		}
		if (typeof (domVal) == 'undefined') {
			return true;
		}
		var parValue = domVal.toString();
		if (AtFlag) {
			parValue = domID + '@' + domVal.toString();
		}
		result = result != '' ? result + '^' + parValue : parValue;
	});
	return result;
}

/**
 * @description 安全组
 */
function initGroup() {
	var callbackFun = arguments[0];
	$HUI.combogrid("#cbGroup", {
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Common.Base.User",
			QueryName: "FindUserGroup",
			rows: 1000
		},
		mode: 'remote',
		idField: 'Id',
		textField: 'Desc',
		columns: [[
			//{ field: 'Checkbox', title: 'sel', checkbox: true },
			{ field: 'Desc', title: '名称', width: 80 },
			{ field: 'Id', title: 'ID', width: 20 }
		]],
		//multiple: true,
		//singleSelect: false,
		fitColumns: true,
		panelWidth: 400,
		panelHeight: 420,
		delay: 500,
		//pagination: true,
		enterNullValueClear: true,
		onBeforeLoad: function (param) {
			var desc = "";
			if (param['q']) {
				desc = param['q'];
			}
			param = $.extend(param, { HospDr: GLOBAL.HospitalID, TableName: GLOBAL.ConfigTableName, SearchDesc: desc });
			return true;
		},
		onSelect: function (rowIndex, rowData) {
			queryValues();
		},
		onLoadSuccess: function (data) {
			if (typeof callbackFun == 'function') {
				callbackFun();
			}
		}
	});
}
/**
 * @description 科室
 */
function initLoc() {
	var callbackFun = arguments[0];
	$HUI.combogrid("#cbLoc", {
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Common.Base.Hosp",
			QueryName: "FindHospLocs",
			rows: 1000
		},
		mode: 'remote',
		idField: 'LocId',
		textField: 'LocDesc',
		columns: [[
			//{ field: 'Checkbox', title: 'sel', checkbox: true },
			{ field: 'LocDesc', title: '名称', width: 100 },
			{ field: 'HospDesc', title: '院区', width: 100 },
			{ field: 'LocId', title: 'ID', width: 40 }
		]],
		//multiple: true,
		//singleSelect: false,
		fitColumns: true,
		panelWidth: 500,
		panelHeight: 420,
		delay: 500,
		//pagination: true,
		enterNullValueClear: true,
		onBeforeLoad: function (param) {
			var desc = "";
			if (param['q']) {
				desc = param['q'];
			}
			param = $.extend(param, { HospitalID: GLOBAL.HospitalID, ConfigTableName: GLOBAL.ConfigTableName, SearchDesc: desc });
			return true;
		},
		onSelect: function (rowIndex, rowData) {
			queryValues();
		},
		onLoadSuccess: function (data) {
			if (typeof callbackFun == 'function') {
				var arrRowIds = new Array();
				$.each(data.rows, function (index, row) {
					arrRowIds.push(row.LocId);
				});
				callbackFun(arrRowIds);
			}
		}
	});
}
/**
 * @description 模板
 */
function initModel() {
	if ($('#cbModel').length > 0) {
		var ArrayLoc = arguments[0];
		var cbtreeModel = $HUI.combotree('#cbModel', {
			//multiple: true,
			lines: true,
			// panelWidth: 400,
			panelHeight: 500,
			delay: 500,
			onSelect: function (node) {
				queryValues();
			}
		});
		$cm({
			ClassName: "NurMp.Service.Template.Directory",
			MethodName: "getTemplates",
			HospitalID: GLOBAL.HospitalID,
			TypeCode: 'L',
			LocID: typeof (ArrayLoc) != 'undefined' ? ArrayLoc.join('^') : '',
			IconFlag: false
		}, function (data) {
			cbtreeModel.loadData(data);
			queryValues();
		});
	} else {
		queryValues();
	}
}

/**
 * @description 查通用
 */
function findCommon() {
	clearSelect();
	queryValues();
}
/**
 * @description 清空选择
 */
function clearSelect() {
	if ($('#cbGroup').length > 0) {
		$('#cbGroup').combobox('clear');
	}
	if ($('#cbLoc').length > 0) {
		$('#cbLoc').combobox('clear');
	}
	if ($('#cbModel').length > 0) {
		$('#cbModel').combotree('clear');
	}
}
/**
 * @description: combo赋值
 * @param {*} rowData
 */
function comboSetValue(rowData) {
	if ((!rowData.GroupId) && (!rowData.LocId) && (!rowData.ModelId)) {
		findCommon();
		return;
	}
	clearSelect();
	if ($('#cbGroup').length > 0) {
		$('#cbGroup').combogrid('setValue', rowData.GroupId);
	}
	if ($('#cbLoc').length > 0) {
		$('#cbLoc').combogrid('setValue', rowData.LocId);
	}
	if ($('#cbModel').length > 0) {
		$('#cbModel').combotree('setValue', rowData.ModelId);
	}
}
/**
 * @description 查授权明细
 */
function findAuth() {
	var groupId = $("#cbGroup").length > 0 ? $("#cbGroup").combobox("getValue") : '';
	var locId = $("#cbLoc").length > 0 ? $("#cbLoc").combobox("getValue") : '';
	var modelId = ($('#cbModel').length > 0) && (!!$('#cbModel').combotree('tree').tree('getSelected')) ? $('#cbModel').combotree('tree').tree('getSelected').id : ''
	var url = 'nur.emr.config.switch.auth.csp?HospitalID=' + GLOBAL.HospitalID + "&GroupID=" + groupId + "&LocID=" + locId + "&ModelID=" + modelId + "&Page=" + GLOBAL.PageCode;
	$('#dgAuth').window({
		title: '授权明细',
		content: "<iframe id='iframeAuthLoc' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
		width: 900,
		height: 600,
		collapsible: false,
		minimizable: false,
		maximizable: false
	});
	$("#dgAuth").window("open");
}

/**
 * @description: 关闭窗口
 */
function closeWin() {
	$("#dgAuth").window("close");
}
/**
 * @description: 序列化容器内所有指定类型元素数组
 * @param {String} contentId
 * @param {String} arrFlag
 * @return {Object} elements
 */
function elementsToArray(contentId) {
	var arrElements = new Array();
	var elements = new Object();
	$.each($(contentId).find('div, input, select'), function (index, element) {
		if (!element.id) {
			return true;
		}
		if (!!elements[element.id]) {
			return true;
		}
		var eltype = $(element).attr('type');
		if (!eltype) {
			return true;
		}
		if ((eltype != 'combobox') && (eltype != 'checkbox') && (eltype != 'radio') && (eltype != 'color') && (eltype != 'textbox') && (eltype != 'switchbox') && (eltype != 'combogrid') && ($(element).is(':hidden'))) {
			return true;
		}
		arrElements.push(element.id);
		elements[element.id] = index;
	});
	return arrElements;
}
/**
 * @description: 序列化容器内所有指定类型元素的键值对象
 * @param {String} contentId
 * @param {String} arrFlag
 * @return {Object} elements
 */
function queryElements(contentId, arrFlag) {
	var elements = new Object();
	$.each($(contentId).find('div, input, select'), function (index, element) {
		if (!element.id) {
			return true;
		}
		if (!!elements[element.id]) {
			return true;
		}
		var eltype = $(element).attr('type');
		if (!eltype) {
			return true;
		}
		if ((eltype != 'combobox') && (eltype != 'checkbox') && (eltype != 'radio') && (eltype != 'color') && (eltype != 'textbox') && (eltype != 'switchbox') && (eltype != 'combogrid') && ($(element).is(':hidden'))) {
			return true;
		}
		var props = new Object();
		var value = '';
		var defValue = '';
		var desc = '';
		if ((eltype == 'textbox') || (eltype == 'password')) {
			value = $(element).val();
			defValue = $(element).attr('value') || '';
		} else if ((eltype == 'checkbox') || (eltype == 'radio')) {
			$('input[name=' + element.name + ']').each(function (index, item) {
				if (item.checked) {
					value = !!value ? value + ',' + item.value : item.value;
				}
			});
			defValue = $(element).attr('defValue') || '';
			element.id = element.name;
		} else if (eltype == 'combogrid') {
			value = $(element).combogrid('getValues').join(',');
			defValue = $(element).attr('defValue') || '';
		} else {
			eval('value = $(element).' + eltype + '("getValue");');
			if (eltype == 'switchbox') {
				defValue = $(element).switchbox('options').checked;
			} else {
				defValue = $(element).attr('defValue') || '';
			}
		}
		props['value'] = value;
		props['defValue'] = defValue;
		var desc = $(element).parent().prev().find('label').text();
		if (eltype == 'timespinner') {
			desc = $(element).parent().parent().prev().find('label').text();
		}
		if (((eltype == 'checkbox') || (eltype == 'radio')) && ($(element).parent()[0].tagName == 'LI')){
			desc = $(element).parent().parent().parent().prev().find('label').text();
		}
		if (!desc.trim()) {
			props['desc'] = $(element).attr('placeholder');
		} else {
			props['desc'] = desc;
		}
		props['status'] = $(element).attr('status') || '1';
		props['remark'] = $(element).parent().next().find('label').text();
		props['defType'] = eltype == 'switchbox' ? 'Bool' : 'String';
		var visible = $(element).css('visibility');
		props['visible'] = visible == 'hidden' ? '2' : '1';
		elements[element.id] = props;
	});
	if (arrFlag) {
		var arrayElements = new Array();
		arrayElements.push(elements);
		return arrayElements;
	}
	return elements;
}
/**
 * @description 查询配置信息
 */
function queryValues() {
	$cm({
		ClassName: "NurMp.Service.Switch.Config",
		MethodName: "GetConfiguration",
		HospitalID: GLOBAL.HospitalID || '',
		PageCode: GLOBAL.PageCode,
		GroupID: $("#cbGroup").length > 0 ? $("#cbGroup").combobox("getValue") : '',
		LocID: $("#cbLoc").length > 0 ? $("#cbLoc").combobox("getValue") : '',
		ModelID: ($('#cbModel').length > 0) && (!!$('#cbModel').combotree('tree').tree('getSelected')) ? $('#cbModel').combotree('tree').tree('getSelected').id : ''
	}, function (jsonData) {
		if (!$.isEmptyObject(jsonData)) {
			setExistValues(jsonData);
		} else {
			setNullValues();
		}
		if (typeof initAfterSetValue == 'function') {
			initAfterSetValue();
		}
	});
}
/**
 * @description: 设置值
 */
function setExistValues(jsonData) {
	var elements = queryElements('.switchTable tr td, .form_table tr td', false);
	for (var item in elements) {
		var domID = '#' + item;
		var itemValue = typeof (jsonData[item]) != 'undefined' ? jsonData[item] : '';
		var domType = $(domID).attr('type');
		if ((domType == 'textbox') || (domType == 'password')) {
			$(domID).val(itemValue);
		} else if (domType == 'numberbox') {
			$(domID).numberbox('setValue', parseInt(itemValue));
		} else if (domType == 'combobox') {
			$(domID).combobox('setValues', String(itemValue).split(','));
		} else if (domType == 'switchbox') {
			if (!itemValue) {
				itemValue = false;
			}
			var switchVal = JSON.parse(itemValue);  //itemValue == true ? true : false;
			$(domID).switchbox('setValue', switchVal);
		} else if (domType == 'checkbox') {
			var name = $(domID).selector.split('#')[1];
			$("input[name='" + name + "']").checkbox('setValue',false);
			if (!!itemValue) {
				var arrValue = itemValue.split(/,/);
				$.each(arrValue, function (index, value) {
					$("input[name='" + name + "'][value='" + value + "']").checkbox('setValue',true);
				});
			}
		} else if (domType == 'radio') {
			var name = $(domID).selector.split('#')[1];
			$("input[name='" + name + "']").radio('setValue',false);
			$("input[name='" + name + "'][value='" + itemValue + "']").radio('setValue',true);
		} else if (domType == 'color') {
			$(domID).color('setValue', itemValue);
		} else if (domType == 'timespinner') {
			$(domID).timespinner('setValue', itemValue);
		} else if (domType == 'combogrid') {
			$(domID).combogrid('setValues', String(itemValue).split(','));
		} else {
			console.log(domType);
		}
		if (typeof initSyncElements == 'function') {
			initSyncElements(item, itemValue, jsonData);
		}
	}
}
/**
 * @description: 设置空值
 */
function setNullValues() {
	var elements = queryElements('.switchTable tr td, .form_table tr td', false);
	for (var item in elements) {
		var domID = '#' + item;
		var domType = $(domID).attr('type');
		if ((domType == 'textbox') || (domType == 'password')) {
			$(domID).val('');
		} else if (domType == 'numberbox') {
			$(domID).numberbox('setValue', '');
		} else if (domType == 'combobox') {
			var data = $(domID).combobox('getData');//获取所有下拉框数据
			if (data.length > 0) {
				$(domID).combobox('select', data[0].value);
			} else {
				$(domID).combobox('clear');
			}
		} else if (domType == 'switchbox') {
			$(domID).switchbox('setValue', false);
		} else if (domType == 'checkbox') {
			var name = $(domID).selector.split('#')[1];
			$("input[name='" + name + "']").checkbox('setValue',false);
		} else if (domType == 'radio') {
			var name = $(domID).selector.split('#')[1];
			$("input[name='" + name + "']").radio('setValue',false);
		} else if (domType == 'color') {
			$(domID).color('setValue', '#ffffff');
		} else {
			console.log(domType);
		}
	}
}
/**
 * @description: 帮助弹窗
 */
function showDgHelp() {
	var url = 'nur.emr.config.switch.help.csp?Page=' + GLOBAL.PageCode;
	$("#a_help").popover({
		title: '帮助',
		content: "<iframe id='iframeAuthLoc' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
		height: 550,
		width: 800,
		offsetLeft: 0
	});
}

/**
 * @description: 显示模板选择弹框
 */
function showDgTemplates(which) {
	var splitChar = '||';
	var modelIds = $('#' + which).val();
	var locId = $("#cbLoc").combobox("getValue");
	var url = 'nur.emr.config.switch.selmodel.csp?HospitalID=' + GLOBAL.HospitalID + '&ConfigTableName=' + GLOBAL.ConfigTableName + '&Model=' + modelIds + '&Loc=' + locId;
	$('#dialog-model').dialog({
		title: '选择应用模板',
		buttons: [{
			text: '确定',
			handler: function () {
				var arrNewModel = $("#iframeAuthModel")[0].contentWindow.GV.ArrSelModel;
				var strModelIds = arrNewModel.join(',');
				$("#" + which).val(strModelIds);
				if (typeof initAfterSetValue == 'function') {
					initAfterSetValue();
				}
				$("#dialog-model").dialog("close");
			}
		}, {
			text: '关闭',
			handler: function () {
				$("#dialog-model").dialog("close");
			}
		}],
		width: 600,
		height: 568,
		content: "<iframe id='iframeAuthModel' scrolling='auto' frameborder='0' src='" + buildMWTokenUrl(url) + "' style='width:100%; height:100%; display:block;'></iframe>",
	}).dialog('open');
}

/**
 * @description 事件监听
 */
function listenEvents() {
	if ($('#btnFindCommon').length > 0) {
		$('#btnFindCommon').bind('click', findCommon);
	}
	if ($('#btnFindAuth').length > 0) {
		$('#btnFindAuth').bind('click', findAuth);
	}
	if ($('#btnSave').length > 0) {
		$('#btnSave').bind('click', save);
	}
	if ($('#a_help').length > 0) {
		showDgHelp();
	}
	if (typeof listenEvent == 'function') {
		listenEvent();
	}
}