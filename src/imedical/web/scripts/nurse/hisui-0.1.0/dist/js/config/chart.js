/*
 * @Descripttion: 病历曲线图配置
 * @Author: yaojining
 * @Date: 2022-09-07
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_RecordsChart',
	ClassName: 'NurMp.Service.Template.Chart'
};
var init = function () {
	initHosp(initCondition);
	loadTemplateTree();
	listenEvent();
}

$(init);

/**
* @description: 查询条件
*/
function initCondition() {
	$HUI.combobox('#comobo_template', {
		valueField: 'id',
		textField: 'desc',
		defaultFilter: 2,
		loader: function (param, success, error) {
			$cm({
				ClassName: GLOBAL.ClassName,
				QueryName: 'GetAssessItems',
				keyword: '',
				loc: session['LOGON.CTLOCID'],
				Hospital: GLOBAL.HospitalID,
				rows: 99999
			}, function (data) {
				success(data.rows);
			});
		},
		onLoadSuccess: function() {
			$HUI.tree('#tree_template', 'reload');
		}
	});
	$('#LineColor').color({
		editable: false,
		value: '#000000'
	})
	// 自适应量程
	$('#Adaptive').checkbox({
		onCheckChange: function (e, value) {
			$('#Max').numberbox({
				disabled: value
			});
			$('#Min').numberbox({
				disabled: value
			});
			if (value) {
				$('#Max').numberbox('setValue', '');
				$('#Min').numberbox('setValue', '');
			}
		}
	});
	// 日期格式
	$('#DateFormat').combobox({
		valueField: 'value',
		textField: 'value',
		value: 'yyyy-mm-dd',
		data: [{
			value: 'yyyy-mm-dd'
		}, {
			value: 'dd/mm/yyyy'
		}, {
			value: 'yyyy年mm月dd日'
		}]
	});
}
/**
* @description: 初始化menu
*/
function initMenu(node) {
	$('#menu_model').empty();
	$('#menu_model').menu('appendItem', {
		id: 'delete',
		text: $g('删除'),
		iconCls: 'icon-remove',
		handler: function () {
			deleteFromModelList(node.id);
		}
	});
}
/**
* @description: 添加模板
*/
function loadTemplateTree() {
	$HUI.tree('#tree_template', {
		loader: function (param, success, error) {
			$cm({
				ClassName: GLOBAL.ClassName,
				QueryName: 'FindAddedTempList',
				HospitalID: GLOBAL.HospitalID,
				Filter: $HUI.searchbox('#searchbox_template').getValue()
			}, function (data) {
				success(data.rows);
			});
		},
		onLoadSuccess: function (node, data) {
			$('.tree-indent').css('width', '10px');
			$('.tree-file').css('display', 'none');
		},
		autoNodeHeight: true,
		onContextMenu: function (e, node) {
			initMenu(node);
			e.preventDefault();
			$('#tree_template').tree('select', node.target);
			$('#menu_model').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onClick: getProps
	});
}
/**
* @description: 添加模板
*/
function addToModelList() {
	debugger;
	if (!$('#comobo_template').combobox('getValue')) {
		$.messager.popover({ msg: '请选择模板！', type: 'info' });
		return;
	}
	var arrItems = new Array();
	var objElement = new Object();
	var record = $('#comobo_template').combobox('getValue');
	objElement['RCHospDR'] = GLOBAL.HospitalID;
	objElement['RCTemplateDR'] = record;
	objElement['RCUpdateUserDR'] = session['LOGON.USERID'];
	objElement['RCUpdateDate'] = 'DateNow';
	objElement['RCUpdateTime'] = 'TimeNow';
	arrItems.push(objElement);
	$cm({
		ClassName: 'NurMp.Service.Template.Chart',
		MethodName: 'SaveModel',
		Param: JSON.stringify(arrItems)
	}, function (result) {
		popover(result, $HUI.tree('#tree_template', 'reload'));
		deserializeElements('.table_content>tbody tr td', {}, setDefaultValues);
	});
}
/**
* @description: 删除模板
*/
function deleteFromModelList(id) {
	confirm(function () {
		$cm({
			ClassName: 'NurMp.Common.Logic.Handler',
			MethodName: 'Delete',
			ClsName: 'CF.NUR.EMR.RecordsChart',
			Ids: id
		}, function (result) {
			popover(result, $HUI.tree('#tree_template', 'reload'));
			deserializeElements('.table_content>tbody tr td', {}, setDefaultValues);
		});
	});

}
/**
 * @description: 保存属性
 */
function saveProps() {
	if (!$('#tree_template').tree('getSelected')) {
		$.messager.popover({ msg: '请选择模板！', type: 'info' });
		return;
	}
	var elements = serializeElements('.table_content>tbody tr td', false);
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: 'SaveProps',
		ClsName: 'CF.NUR.EMR.RecordsChart',
		UserID: session['LOGON.USERID'],
		Parref: $('#tree_template').tree('getSelected').id,
		Param: JSON.stringify(elements)
	}, function (result) {
		popover(result);
	});
}
/**
 * @description: 查询属性
 * @param {object} node
 */
function getProps(node) {
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: 'GetProps',
		HospitalID: GLOBAL.HospitalID,
		TemplateDR: node.templateDR
	}, function (result) {
		deserializeElements('.table_content>tbody tr td', result, setDefaultValues);
	});
}
/**
 * @description: 设置默认值
 */
function setDefaultValues() {
	$('#DateFormat').combobox('setValue', 'yyyy-mm-dd');
	$('#LineColor').color('setValue', '#000000');
	$('#Left').numberbox('setValue', '10');
	$('#Top').numberbox('setValue', '10');
	$('#Width').numberbox('setValue', '80');
	$('#Height').numberbox('setValue', '80');
	$('#comobo_template').combobox('clear');
}
/**
 * @description: 事件
 */
function listenEvent() {
	$('#btn_add').bind('click', addToModelList);
	$('#searchbox_template').searchbox({
		searcher: function (value) {
			$HUI.tree('#tree_template', 'reload');
		}
	});
	$('#btn_save').bind('click', saveProps);
}
