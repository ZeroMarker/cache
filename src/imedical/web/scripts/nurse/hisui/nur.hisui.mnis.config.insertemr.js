/// Creator:      EH
/// CreatDate:    2021-11-11
/// Description:  插护理病历 8.5
/// start -> assigned -> loc -> waiting -> hosp -> waited

/// 初始化
var init = function() {
	Object.assign(GV, {
		_ASSIGNED: true
	});
	Object.assign($HUI.locpanel(), {
		onSelect: insertEmrGridOnFindClick
	});
	$.waitUntil('GV._HOSPID', function() {
	    initPageDom();
		initEvent();
	});
	$(window).resize(resizePanel);
	resizePanel();
};
$(init);

function resizePanel() {
	var centerPanel = $('#insertEmrPanel').parent().parent();
	var centerHeight = centerPanel.height() / 3;
	centerPanel.layout('panel', 'north').panel('resize', { height: centerHeight });
	centerPanel.layout('panel', 'south').panel('resize', { height: centerHeight });
	centerPanel.layout('resize');
}
function initEvent() {
	/// 1.科室列表
	/// 2.模板列表
	$('#insertEmrGridAddBtn').bind('click', insertEmrGridOnAddClick);
	$('#insertEmrGridEditBtn').bind('click', insertEmrGridOnEditClick);
	$('#insertEmrGridDeleteBtn').bind('click', insertEmrGridOnDeleteClick);
	$('#insertEmrGridUpBtn').bind('click', insertEmrGridOnMoveUpClick);
	$('#insertEmrGridDownBtn').bind('click', insertEmrGridOnMoveDownClick);
	$('#insertEmrGridTestBtn').bind('click', insertEmrGridOnTestClick);
	/// 4.字段列表
	$('#insertEmrItemGridAddBtn').bind('click', insertEmrItemGridOnAddClick);
	$('#insertEmrItemGridEditBtn').bind('click', insertEmrItemGridOnEditClick);
	$('#insertEmrItemGridDeleteBtn').bind('click', insertEmrItemGridOnDeleteClick);
	$('#insertEmrItemGridUpBtn').bind('click', insertEmrItemGridOnMoveUpClick);
	$('#insertEmrItemGridDownBtn').bind('click', insertEmrItemGridOnMoveDownClick);
	$('#insertEmrItemGridTestBtn').bind('click', insertEmrItemGridOnTestClick);
	/// 3.内容列表
	$('#insertEmrValueGridAddBtn').bind('click', insertEmrValueGridOnAddClick);
	$('#insertEmrValueGridEditBtn').bind('click', insertEmrValueGridOnEditClick);
	$('#insertEmrValueGridDeleteBtn').bind('click', insertEmrValueGridOnDeleteClick);
	$('#insertEmrValueGridUpBtn').bind('click', insertEmrValueGridOnMoveUpClick);
	$('#insertEmrValueGridDownBtn').bind('click', insertEmrValueGridOnMoveDownClick);
	$('#insertEmrValueGridTestBtn').bind('click', insertEmrValueGridOnTestClick);
}
function initPageDom() {
	/// 1.科室列表
	var data = getData(getParams(['ClassName'], null, 'GetInsertEmrParameters'), false);
	GV['_InsertEmrParameter'] = data;
	GV['_CreateEditDiv'] = {};
	/// 2.模板列表
	$HUI.datagrid('#insertEmrGrid', {
		url: '',
		columns: [[
			{ field: 'operation', title: '操作', width: 120, formatter: getBoxFormatter(GV['_InsertEmrParameter']['operations']) },
			{ field: 'emrCode', title: '模板代码', width: 200 },
			{ field: 'activeFlag', title: '是否启用', width: 100, formatter: getBoxFormatter('flag') },
		    { field: 'condition', title: '条件', width: 200 },
		    { field: 'coverage', title: '是否覆盖', width: 100, formatter: getBoxFormatter('flag'),
		        editor: getBoxEditor('flag')
		    },
		    { field: 'reverse', title: '撤销操作', width: 120 },
		    { field: 'comment', title: '注释', width: 200 },
		    { field: 'ID', title: 'ID', width: 100, hidden: true }
		]],
		fitColumns: false,
		idField: 'ID',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('insertEmrGrid'),
		onSelect: gridOnSelectRow('insertEmrGrid', null, insertEmrItemGridOnFindClick),
		onLoadSuccess: function(data) {
			delete GV['_DblClickRow']['insertEmrGrid'];
			insertEmrItemGridOnFindClick();
		}
	});
	/// 4.字段列表
	$HUI.datagrid('#insertEmrItemGrid', {
		url: '',
		columns: [[
			{ field: 'title', title: '标题', width: 200 },
			{ field: 'key', title: '取值字段', width: 120 },
			{ field: 'value', title: '结尾', width: 200 },
			{ field: 'item', title: '保存字段', width: 120 },
		    { field: 'condition', title: '条件', width: 200 },
		    { field: 'conversion', title: '转换', width: 200 },
		    { field: 'ID', title: 'ID', width: 100, hidden: true }
		]],
		fitColumns: false,
		idField: 'ID',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('insertEmrItemGrid'),
		onSelect: gridOnSelectRow('insertEmrItemGrid', null, insertEmrValueGridOnFindClick),
		onLoadSuccess: function(data) {
			delete GV['_DblClickRow']['insertEmrItemGrid'];
			insertEmrValueGridOnFindClick();
		}
	});
	/// 3.模块列表
	$HUI.datagrid('#insertEmrValueGrid', {
		url: '',
		columns: [[
			{ field: 'title', title: '标题', width: 200 },
			{ field: 'key', title: '取值字段', width: 120 },
			{ field: 'value', title: '结尾', width: 200 },
			{ field: 'item', title: '保存字段', width: 120 },
		    { field: 'condition', title: '条件', width: 200 },
		    { field: 'conversion', title: '转换', width: 200 },
		    { field: 'ID', title: 'ID', width: 100, hidden: true }
		]],
		fitColumns: false,
		idField: 'ID',
		singleSelect: true,
		onDblClickRow: gridOnDblClickRow('insertEmrValueGrid'),
		onLoadSuccess: function(data) {
			delete GV['_DblClickRow']['insertEmrValueGrid'];
		}
	});
}
/// 1.科室列表
/// 2.模板列表
function gridOnSelectRow(id, PcFn, PsFn) {
	return function(index, row) {
		if (typeof(PcFn) == 'function') {
			if (PcFn(index, row) === false) { return false; }
		}
		if (GV['_DblClickRow'][id] != index) {
	        GV['_DblClickRow'][id] = index;
            if (typeof(PsFn) == 'function') {
	            PsFn(index, row);
            }
	    }
	};
}
function gridOnDblClickRow(id, PcFn, PsFn) {
	return function(index, row) {
		if (typeof(PcFn) == 'function') {
			if (PcFn(index, row) === false) { return false; }
		}
		gridOnEditRow(id)(index, row);
	    if (typeof(PsFn) == 'function') {
            PsFn(index, row);
        }
	};
}
function createComboDiv(element) {
	var div = '', options = ',valueField:\'value\',textField:\'desc\'';
	var id = '', title = '', value = '', width = 210, data = [], url = '', required = '';
	if (element != undefined) {
		if (element.id != undefined) {
			id = ' id="' + element.id + '"';
		}
		if (element.title != undefined) {
			title = element.title;
		}
		if (element.value != undefined) {
			value = ' value="' + element.value + '"';
		}
		if (element.width != undefined) {
			width = String(element.width).replace('px', '');
		}
		if (element.data != undefined) {
			data = element.data;
		}
		if (element.url != undefined) {
			url = element.url;
		}
		if (element.required != undefined && element.required == true) {
			options += ',required:true';
			required = ' required-label';
		}
		if (url != '') {
			url = ',url:\'' + url + '\'';
		} else {
			var ul = '';
			for (var i = 0; i < data.length; i++) {
				var li = '', dataElement = data[i];
				for (var o in dataElement) {
					li += (li != '') ? ',' : '';
					li += o + ':\'' + dataElement[o] + '\'';
				}
				ul += i > 0 ? ',' : '';
				ul += '{' + li + '}';
			}
			if (ul != '') {
				url = ',data:[' + ul + ']';
			}
		}
	}
	options += url;
	div += '<div class="div-dialog-body-item"><div class="div-dialog-body-item-label' + required + '">' + title + '</div>';
	div += '<input' + id + ' class="combo-text hisui-combobox" autocomplete="off" style="width:' + width + 'px;height:28px;line-height:28px" data-options="enterNullValueClear:false,panelHeight:\'auto\',panelMaxHeight:\'398px\'' + options + '"' + value + '/></div>';
	return div;
}
function createInputDiv(element) {
	var div = '', options = '', id = '', title = '', value = '', width = 203, display = '', required = '';
	if (element != undefined) {
		if (element.id != undefined) {
			id = ' id="' + element.id + '"';
		}
		if (element.title != undefined) {
			title = element.title;
		}
		if (element.value != undefined) {
			value = ' value="' + element.value + '"';
		}
		if (element.width != undefined) {
			width = String(element.width).replace('px', '');
		}
		if (element.hidden != undefined && element.hidden == true) {
			display = ' style="display:none"';
		}
		if (element.required != undefined && element.required == true) {
			options = ' data-options="required:true"';
			required = ' required-label';
		}
	}
	div += '<div class="div-dialog-body-item"'+ display + '><div class="div-dialog-body-item-label' + required + '">' + title + '</div>';
	div += '<input' + id + ' class="hisui-validatebox textbox validatebox-text" style="width:' + width + 'px;height:28px;line-height:28px"' + options + ' onchange="inputOnChange(this)"' + value + '/></div>';
	return div;
}
function createTextareaDiv(element) {
	var div = '', options = '', id = '', title = '', value = '', width = 203, display = '', required = '', lines = 0;
	if (element != undefined) {
		if (element.id != undefined) {
			id = ' id="' + element.id + '"';
		}
		if (element.title != undefined) {
			title = element.title;
		}
		if (element.value != undefined) {
			value = element.value;
		}
		if (element.width != undefined) {
			width = String(element.width).replace('px', '');
		}
		if (element.hidden != undefined && element.hidden == true) {
			display = ' style="display:none"';
		}
		if (element.required != undefined && element.required == true) {
			options = ' data-options="required:true"';
			required = ' required-label';
		}
		if (element.lines != undefined) {
			lines = element.lines;
		}
	}
	var height = 54;
	if (Number(lines) > 0) {
		height = Math.max(28, 28 * lines - 2);
	}
	div += '<div class="div-dialog-body-item"'+ display + '><div class="div-dialog-body-item-label' + required + '">' + title + '</div>';
	div += '<textarea' + id + ' class="hisui-validatebox textbox validatebox-text" style="width:' + width + 'px;height:' + height + 'px;line-height:26px;resize:none;white-space:pre-wrap"' + options + ' onchange="inputOnChange(this,1)">' + value + '</textarea></div>';
	
	return div;
}
function inputOnChange(element, m) {
	var value = String(element.value);
	var trim = value.myTrim(value, m);
	if (trim != value) {
		element.value = trim;
		$(element).validatebox('validate');
	}
}
function createEditDiv(id, row, data) {
	var columns = data || $('#' + id).datagrid('options').columns[0];
	var div = '', items = [], height = 10, requiredItems = [];
	switch (id) {
		case 'insertEmrGrid':
			requiredItems = ['operation', 'emrCode'];
			break;
		case 'insertEmrItemGrid':
			requiredItems = ['item'];
			break;
		default:
			break;
	}
	for (var i = 0; i < columns.length; i++) {
		var field = columns[i].field;
		var title = columns[i].title;
		var value = (typeof (row) == 'object' && row.hasOwnProperty(field)) ? convertValue(row[field], 'text', true) : undefined;
		var data = [];
		var required = requiredItems.indexOf(field) > -1;
		switch (field) {
			case 'operation':
			case 'reverse':
				if (GV['_InsertEmrParameter'] && GV['_InsertEmrParameter']['operations'].length > 0) {
					data = GV['_InsertEmrParameter']['operations'];
				}
				break;
			case 'activeFlag':
			case 'coverage':
				data = 'flag';
				break;
			case 'key':
				var operation = getOperation();
				if (GV['_InsertEmrParameter'] && GV['_InsertEmrParameter']['keys'][operation].length > 0) {
					data = GV['_InsertEmrParameter']['keys'][operation];
				}
				break;
			default:
				break;
		}
		switch (field) {
			case 'operation':
			case 'reverse':
			case 'activeFlag':
			case 'coverage':
			case 'key':
				if (data.length > 0) {
					div += createComboDiv({
						id: field,
						title: title,
						value: value,
						data: getBoxData(data),
						required: required
					});
					height += 28 + 10;
				} else {
					div += createInputDiv({
						id: field,
						title: title,
						value: value,
						required: required
					});
					height += 30 + 10;
				}
				items.push(field);
				break;
			case 'condition':
			case 'comment':
			case 'title':
			case 'conversion':
				div += createTextareaDiv({
					id: field,
					title: title,
					value: value,
					required: required
				});
				height += 56 + 10;
				items.push(field);
				break;
			default:
				var lines = columns[i].lines;
				if (lines) {
					div += createTextareaDiv({
						id: field,
						title: title,
						value: value,
						required: required,
						lines: lines
					});
					var lineHeight = 56;
					if (Number(lines) > 0) {
						lineHeight = Math.max(30, 28 * lines);
					}
					height += lineHeight + 10;
				} else {
					var hidden = columns[i].hidden;
					div += createInputDiv({
						id: field,
						title: title,
						value: value,
						hidden: hidden,
						required: required
					});
					if (!hidden) {
						height += 30 + 10;
					}
				}
				items.push(field);
				break;
		}
	}
	GV['_CreateEditDiv'][id] = {
		div: div,
		height: height,
		items: items
	}
	return div;
}
function gridCellValue(id, name, value) {
	var currentValue = '';
	var selectedRows = $('#' + id).datagrid('getSelections');
	if (selectedRows.length > 0) {
		var row = selectedRows[0];
		if (row.hasOwnProperty(name)) {
			currentValue = row[name];
		}
	}
	return currentValue;
}
function gridOnEditRow(id, PcFn, PsFn) {
	return function(index, row) {
		if (typeof(PcFn) == 'function') {
			if (PcFn(index, row) === false) { return false; }
		}
		GV['_DblClickRow'][id] = index;
		var div = createEditDiv(id);
		var height = Math.min(document.body.offsetHeight - 20, GV['_CreateEditDiv'][id].height + 37 + 60);
		$('#insertEmrDialog').window({
			title: getGridTitle(id),
			iconCls: getGridIconCls(id),
			height: height
		}).window('center').window('open');
		setButtonText('insertEmrDialogSaveBtn', '保存');
		$('#insertEmrDialogForm').children().first().html(div);
		$.parser.parse($('#insertEmrDialogForm'));
		/// 创建带有默认值的textarea时出现一个回车不显示的问题
		var items = GV['_CreateEditDiv'][id].items;
		items.forEach(function(name, index) {
			var div = $('#' + name);
			var value = (typeof (row) == 'object' && row.hasOwnProperty(name)) ? convertValue(row[name], 'text', true) : undefined;
			if (value != undefined) {
				if (div[0].className.indexOf('combobox') > -1) {
					div.combobox('setValue', value);
				} else {
					div.val(value);
					div.validatebox('validate');
				}
			}
		});
		$('#insertEmrDialogSaveBtn').unbind().bind('click', function() {
			eval(id + 'OnSaveClick();');
		});
		$('#insertEmrDialogCloseBtn').unbind().bind('click', function() {
			$('#insertEmrDialog').window('close');
		});
		if (typeof(PsFn) == 'function') {
            PsFn(index, row);
        }
	};
}
function gridOnMoveRow(id, direction, PcFn, PsFn) {
	return function(index, row) {
		if (typeof(PcFn) == 'function') {
			if (PcFn(index, row) === false) { return false; }
		}
		if (direction == -1 && index <= 0) { return false; }
		var length = $('#' + id).datagrid('getRows').length;
		if (direction == 1 && index >= length - 1) { return false; }
		$('#' + id).datagrid('deleteRow', index);
		$('#' + id).datagrid('insertRow', {
			index: index + direction,
			row: row
		});
		$('#' + id).datagrid('selectRow', index + direction);
		if (typeof(PsFn) == 'function') {
            PsFn(index, row);
        }
	};
}
function gridOnAddClick(id) {
	return gridOnEditRow(id)();
}
function gridOnEditClick(id) {
	var selectedRows = $('#' + id).datagrid('getSelections');
	if (selectedRows.length > 0) {
		var row = selectedRows[0];
		var index = $('#' + id).datagrid('getRowIndex', row);
		return gridOnEditRow(id)(index, row);
	}
}
function gridOnMoveClick(id, direction, methodName) {
	var selectedRows = $('#' + id).datagrid('getSelections');
	if (selectedRows.length > 0) {
		var row = selectedRows[0];
		var index = $('#' + id).datagrid('getRowIndex', row);
		return gridOnMoveRow(id, direction, null, function() {
			var ID = [];
			var rows = $('#' + id).datagrid('getRows');
			rows.forEach(function(row, index) {
				ID.push(row['ID']);
				if (row.hasOwnProperty('ordinal')) {
					row['ordinal'] = index + 1;
				}
			});
			getData(getParams(['ClassName'], null, methodName, {
				sorted: ID.join('^')
			}), false);
		})(index, row);
	}
}
function gridOnSaveClick(id, PcFn, PSFn, fn) {
	return function() {
		var nullFlag = false;
		if (typeof(PcFn) == 'function') {
			if (PcFn() === false) { nullFlag = true; }
		}
		if (nullFlag) {
		} else {
			var row = {};
			var items = GV['_CreateEditDiv'][id].items;
			items.forEach(function(name, index) {
				var div = $('#' + name);
				var value = '';
				if (div[0].className.indexOf('combobox') > -1) {
					value = div.combobox('getValue');
				} else {
					value = convertValue(div.val(), 'text');
				}
				row[name] = value;
			});
			var err = 0, msg = '', calls = 0;
			var queryParams = {
				ClassName: GV._CLASSNAME
			};
			if (typeof(PSFn) == 'function') {
				var params = PSFn(row);
				for (var name in params) {
					queryParams[name] = params[name];
				}
			}
		    $cm(queryParams, function(ret) {
				calls++;
				if (String(ret).indexOf('"success":0') > -1) {
					var success = eval('(' + ret + ')');
					err = 2, msg = success.msg;
				} else if (!(parseInt(ret) < 0)) {
					if (err == 0) {
						err = 1;
					}
				} else {
					err = 2, msg = ret;
				}
				if (calls == 1) {
					if (err == 2) {
						$.messager.popover({ msg: '保存失败:' + msg, type: 'alert', timeout: 5000, style: { height: 'auto', top: '', left: '' } });
					}
					if (err == 1) {
						$.messager.popover({ msg: '保存成功!', type: 'success', timeout: 1000 });
						eval(id + 'OnFindClick();');
						$('#insertEmrDialogCloseBtn').click();
						if (typeof(fn) == 'function') {
							fn(err);
						};
					}
				}
			});
		}
	};
}
function gridOnTestClick(id, ID) {
	return function(result) {
		var data = [{
			field: 'regNo',
			title: '登记号'
		}, {
			field: 'barcode',
			title: '条码'
		}, {
			field: 'ID',
			title: 'ID',
			hidden: true
		}];
		var row = {
			regNo: '0000000520',
			barcode: '5004-1-11',
			ID: ID
		};
		if ($.isArray(result)) {
			row.regNo = $('#regNo').val();
			row.barcode = $('#barcode').val();
			row.ID = $('#ID').val();
			result.forEach(function(item, index) {
				var name = item.id, value = item.value;
				var lines = function(value) {
					var f = $('#regNo').css('font-size') + ' ' + $('#regNo').css('font-family')
					, w = $('#regNo').css('width')
					, m = '28px', l = '26px'
					, o = $('<div></div>')
					.html(value)
					.css({ 'font': f, 'visibility': 'hidden', 'z-index': 10, 'white-space': 'pre-wrap', 'width': w || 'auto', '_height': m || 'auto', 'min-height': m || 'auto', 'line-height': l || 'auto' })
					.appendTo($('#insertEmrDialogForm')), e = o.height();
					o.remove();
					var d = parseInt(m);
					if (isNaN(d)) d = e;
					return e / d;
				}(item.value);
				data.push({
					field: name,
					title: name,
					lines: Math.min(3, lines)
				});
				if (row.hasOwnProperty(name)) {
					row[name] = value;
				}
			});
		}
		var div = createEditDiv(id, row, data);
		var height = Math.min(document.body.offsetHeight - 20, GV['_CreateEditDiv'][id].height + 37 + 60);
		if ($.isArray(result)) {
			$('#insertEmrDialog').window('resize', { height: height });
		} else {
			$('#insertEmrDialog').window({
				title: getGridTitle(id.replace('TestBtn', '')).substring(0, 2) + '测试',
				iconCls: getButtonIconCls(id),
				height: height
			}).window('center').window('open');
			setButtonText('insertEmrDialogSaveBtn', '测试');
		}
		$('#insertEmrDialogForm').children().first().html(div);
		$.parser.parse($('#insertEmrDialogForm'));
		$('#insertEmrDialogSaveBtn').unbind().bind('click', function() {
			var data = getData(getParams([], null, 'Test', {
				ClassName: 'Nur.MNIS.Service.InsertEmr',
				regNo: $('#regNo').val(),
				barcode: $('#barcode').val(),
				ID: $('#ID').val()
			}), false);
			if ($.isArray(data)) {
				gridOnTestClick(ID)(data);
			} else {
				$.messager.popover({ msg: '测试失败!', type: 'alert', timeout: 5000, style: { height: 'auto', top: '', left: '' } });
			}
		});
		$('#insertEmrDialogCloseBtn').unbind().bind('click', function() {
			$('#insertEmrDialog').window('close');
		});
		if ($.isArray(result)) {
			/// 创建带有默认值的textarea时出现一个回车不显示的问题
			result.forEach(function(item, index) {
				var name = item.id, value = item.value;
				var div = $('#' + name);
				if (value != undefined) {
					if (div[0].className.indexOf('combobox') > -1) {
						div.combobox('setValue', value);
					} else {
						div.val(value);
						div.validatebox('validate');
					}
				}
			});
			$("#insertEmrDialogForm textarea").each(function() {
				$(this).autoTextarea({
					maxHeight: $(this).height(),
					minHeight: 28
				});
			});
		} else {
			$('#insertEmrDialogSaveBtn').click();
		}
	}
}
function getOperation() {
	return gridCellValue('insertEmrGrid', 'operation');
}
function getInsertEmrID() {
	return gridCellValue('insertEmrGrid', 'ID');
}
function getInsertEmrItemID() {
	return gridCellValue('insertEmrItemGrid', 'ID');
}
function getInsertEmrValueID() {
	return gridCellValue('insertEmrValueGrid', 'ID');
}
function insertEmrGridOnFindClick() {
	return gridOnFindClick('insertEmrGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindInsertEmr');
	})();
}
function insertEmrGridOnSaveClick() {
	return gridOnSaveClick('insertEmrGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID'].concat(GV['_CreateEditDiv']['insertEmrGrid'].items), null, 'SaveInsertEmr', null, row);
	}, insertEmrGridOnFindClick)();
}
function insertEmrGridOnAddClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnAddClick('insertEmrGrid');
}
function insertEmrGridOnEditClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnEditClick('insertEmrGrid');
}
function insertEmrGridOnDeleteClick() {
	if (getNullFlag() == 'Y' || getInsertEmrID() == '') { return false; }
	$.messager.confirm("提示", "确定删除该条记录?", function (r) {
		if (r) {
			return gridOnDeleteClick('insertEmrGrid', null, function(row) {
				return getParams(['dataType', 'ID'], null, 'DeleteInsertEmr', null, row);
			}, insertEmrGridOnFindClick)();
		}
	});
}
function insertEmrGridOnMoveUpClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnMoveClick('insertEmrGrid', -1, 'SortInsertEmr');
}
function insertEmrGridOnMoveDownClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnMoveClick('insertEmrGrid', 1, 'SortInsertEmr');
}
function insertEmrGridOnTestClick() {
	var ID = getInsertEmrID();
	if (getNullFlag() == 'Y' || ID == '') { return false; }
	return gridOnTestClick('insertEmrGridTestBtn', ID)();
}
function insertEmrItemGridOnTestClick() {
	var ID = getInsertEmrItemID();
	if (getNullFlag() == 'Y' || ID == '') { return false; }
	return gridOnTestClick('insertEmrItemGridTestBtn', ID)();
}
function insertEmrValueGridOnTestClick() {
	var ID = getInsertEmrValueID();
	if (getNullFlag() == 'Y' || ID == '') { return false; }
	return gridOnTestClick('insertEmrValueGridTestBtn', ID)();
}
/// 4.字段列表
function insertEmrItemGridOnFindClick() {
	return gridOnFindClick('insertEmrItemGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindInsertEmrItem', null, {
			'insertEmrID': getInsertEmrID()
		});
	})();
}
function insertEmrItemGridOnSaveClick() {
	return gridOnSaveClick('insertEmrItemGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID'].concat(GV['_CreateEditDiv']['insertEmrItemGrid'].items), null, 'SaveInsertEmrItem', {
			'insertEmrID': getInsertEmrID()
		}, row);
	}, insertEmrItemGridOnFindClick)();
}
function insertEmrItemGridOnAddClick() {
	if (getNullFlag() == 'Y' || getInsertEmrID() == '') { return false; }
	return gridOnAddClick('insertEmrItemGrid');
}
function insertEmrItemGridOnEditClick() {
	if (getNullFlag() == 'Y' || getInsertEmrID() == '') { return false; }
	return gridOnEditClick('insertEmrItemGrid');
}
function insertEmrItemGridOnDeleteClick() {
	if (getNullFlag() == 'Y' || getInsertEmrItemID() == '') { return false; }
	$.messager.confirm("提示", "确定删除该条记录?", function (r) {
		if (r) {
			return gridOnDeleteClick('insertEmrItemGrid', null, function(row) {
				return getParams(['dataType', 'ID'], null, 'DeleteInsertEmrItem', null, row);
			}, insertEmrItemGridOnFindClick)();
		}
	});
}
function insertEmrItemGridOnMoveUpClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnMoveClick('insertEmrItemGrid', -1, 'SortInsertEmrItem');
}
function insertEmrItemGridOnMoveDownClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnMoveClick('insertEmrItemGrid', 1, 'SortInsertEmrItem');
}
/// 4.字段列表
function insertEmrValueGridOnFindClick() {
	return gridOnFindClick('insertEmrValueGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function() {
		return getParams(['hospID', 'locID'], 'FindInsertEmrValue', null, {
			insertEmrItemID: getInsertEmrItemID()
		});
	})();
}
function insertEmrValueGridOnSaveClick() {
	return gridOnSaveClick('insertEmrValueGrid', function() {
		if (getNullFlag() == 'Y') { return false; }
	}, function(row) {
		return getParams(['dataType', 'hospID', 'locID'].concat(GV['_CreateEditDiv']['insertEmrValueGrid'].items), null, 'SaveInsertEmrValue', {
			'insertEmrItemID': getInsertEmrItemID()
		}, row);
	}, insertEmrValueGridOnFindClick)();
}
function insertEmrValueGridOnAddClick() {
	if (getNullFlag() == 'Y' || getInsertEmrItemID() == '') { return false; }
	return gridOnAddClick('insertEmrValueGrid');
}
function insertEmrValueGridOnEditClick() {
	if (getNullFlag() == 'Y' || getInsertEmrItemID() == '') { return false; }
	return gridOnEditClick('insertEmrValueGrid');
}
function insertEmrValueGridOnDeleteClick() {
	if (getNullFlag() == 'Y' || getInsertEmrValueID() == '') { return false; }
	$.messager.confirm("提示", "确定删除该条记录?", function (r) {
		if (r) {
			return gridOnDeleteClick('insertEmrValueGrid', null, function(row) {
				return getParams(['dataType', 'ID'], null, 'DeleteInsertEmrValue', null, row);
			}, insertEmrValueGridOnFindClick)();
		}
	});
}
function insertEmrValueGridOnMoveUpClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnMoveClick('insertEmrValueGrid', -1, 'SortInsertEmrValue');
}
function insertEmrValueGridOnMoveDownClick() {
	if (getNullFlag() == 'Y') { return false; }
	return gridOnMoveClick('insertEmrValueGrid', 1, 'SortInsertEmrValue');
}
