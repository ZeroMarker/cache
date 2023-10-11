/**
 * 名称:   药房公共-插件扩展
 * 编写人:  yunhaibao
 * 编写日期: 2019-03-12
 * 扩展包含:
 * scripts/pha/com/v1/js/extend.js
 */

(function ($) {
	/**
	 * datagrid 属性增加
	 */
	$.extend($.fn.datagrid.defaults, {
		editIndex: undefined, // 当前编辑行
		checking: '',
		isCellEdit: false,
		isAutoShowPanel: true,
		allowEnd: true
	});
	$.fn.datagrid.methods.orgGetRowIndex =
		$.fn.datagrid.methods.baseGetRowIndex ?
		$.fn.datagrid.methods.baseGetRowIndex :
		$.fn.datagrid.methods.getRowIndex;
	if (!$.easyui) {
		$.easyui = $.hisui;
	}
	var orgDeleteRow = $.fn.datagrid.methods.deleteRow;
	/**
	 * datagrid方法增加与继承修改
	 */
	$.extend($.fn.datagrid.methods, {
		/**
		 * 增加一行
		 * @param {object} jq
		 * @param {object} _options
		 * @param {object} [_options.defaultRow] - 新增后,默认的列数据
		 * @param {string} [_options.editField] - 新增后,默认的列数据
		 */
		addNewRow: function (jq, _options) {
			return jq.each(function () {
				if ($(this).datagrid('endEditing')) {
					if (_options.defaultRow) {
						$(this).datagrid('appendRow', _options.defaultRow);
					} else {
						$(this).datagrid('appendRow', {});
					}
					var rowIndex = $(this).datagrid('getRows').length - 1;
					$(this).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
					if (_options.editField) {
						var ed = $(this).datagrid('getEditor', {
							index: rowIndex,
							field: _options.editField
						});
						if (ed.type.indexOf('combo') >= 0) {
							$(ed.target).combobox('textbox').focus();
						} else {
							$(ed.target).focus();
						}
					}
					$(this).datagrid('options').editIndex = rowIndex;
				}
			});
		},
		/**
		 * 开始编辑行
		 * @param {object} _options
		 * @param {number} _options.rowIndex - 要编辑的行
		 * @param {string} [_options.editField] - 要编辑的列
		 */
		beginEditRow: function (jq, _options) {
			return jq.each(function () {
				if ($(this).datagrid('endEditing')) {
					$(this).datagrid('clearSelections');
					$(this).datagrid('selectRow', _options.rowIndex).datagrid('beginEdit', _options.rowIndex);
					$(this).datagrid('options').editIndex = _options.rowIndex;
					if (_options.editField) {
						var ed = $(this).datagrid('getEditor', {
							index: _options.rowIndex,
							field: _options.editField
						});
						if (ed.type.indexOf('combo') >= 0) {
							$(ed.target).combobox('textbox').focus();
						} else {
							$(ed.target).focus();
						}
					}
				}
			});
		},
		/**
		 * 开始编辑单元格
		 * @param {object} _options
		 * @param {number} _options.index - 要编辑的行
		 * @param {string} _options.field - 要编辑的列,对应field
		 */
		beginEditCell: function (jq, _options) {
			return jq.each(function () {
				if ($(this).datagrid('endEditing')) {
					var index = _options.index;
					var field = _options.field;
					$(this).datagrid('options').editIndex = index;
					$(this).datagrid('selectRow', index).datagrid('editCell', {
						index: index,
						field: field
					});
					if (field != '') {
						var ed = $(this).datagrid('getEditor', {
							index: index,
							field: field
						});
						if (ed != null) {
							$(ed.target).focus();
							$(ed.target).next().children().focus();
						}
					}
				}
			});
		},
		/**
		 * 触发行编辑结束，如果完成则保存
		 * @returns {boolean} true - 成功 , false - 失败
		 */
		endEditing: function (jq, _options) {
			var $_grid = $('#' + jq[0].id);
			var editIndex = $_grid.datagrid('options').editIndex;
			// 注意:严格等于
			if (editIndex == undefined) {
				return true;
			} else {
				if ($_grid.datagrid('validateRow', editIndex)) {
					$_grid.datagrid('endEdit', editIndex);
					$_grid.datagrid('options').editIndex = undefined;
					return true;
				} else {
					$_grid.datagrid('selectRow', editIndex);
					return false;
				}
			}
		},
		/**
		 * 查询
		 * @param {object} _options  - 要覆写的查询参数
		 */
		query: function (jq, _options) {
			return jq.each(function () {
				var _queryParams = $(this).datagrid('options').queryParams;
				var _$url = $(this).datagrid('options').url;
				if (_queryParams.pClassName) {
					delete _queryParams.ClassName
					delete _queryParams.QueryName
					delete _queryParams.MethodName
				}
				// 有问题
				if (_$url.indexOf('PHA.COM.Broker') > 0) {
					if (_queryParams.ClassName === '') {
						_queryParams.ClassName = 'PHA.COM.Broker'
							_queryParams.MethodName = 'Invoke'
					}
				}
				$.extend(_queryParams, _options);
				$(this).datagrid('load');
				$(this).datagrid('options').editIndex = undefined;
			});
		},
		/**
		 * 清空表格,同时清除查询参数
		 */
		clear: function (jq) {
			return jq.each(function () {
				var _queryParams = $(this).datagrid('options').queryParams;
				var _baseParams = {};
				var _baseKeyArr = ['ClassName', 'QueryName', 'MethodName', 'totalFields', 'totalFooter', 'pClassName', 'pMethodName'];
				for (var k = 0; k < _baseKeyArr.length; k++) {
					var _baseKey = _baseKeyArr[k];
					if (_queryParams[_baseKey]) {
						_baseParams[_baseKey] = _queryParams[_baseKey];
					}
				}
				$(this).datagrid('options').queryParams = _baseParams;
				$(this).datagrid('loadData', {
					total: 0,
					rows: [],
					footer: [{}
					]
				});
				$(this).datagrid('rejectChanges');
			});
		},
		/**
		 * 验证数据重复,注意调用了PHA_UTIL.js中的function
		 * @param {array[]} chkKeyDataArr - 二维数组
		 *                                  举例[[a,b],[c]],代表判断ab同时重复或者c重复
		 */
		checkRepeat: function (jq, chkKeyDataArr) {
			var retJson = {};
			var $this = $('#' + jq[0].id);
			var rows = $this.datagrid('getRows');
			var rowsLen = rows.length;
			var newRows = [];
			for (var i = 0; i < rowsLen; i++) {
				var iRow = rows[i];
				if ($this.datagrid('getRowIndex', iRow) < 0) {
					continue;
				}
				newRows.push(iRow);
			}
			chkKeyDataArr.unshift(newRows);
			var repeatObj = PHA_UTIL.Array.GetRepeat.apply(null, chkKeyDataArr); // ! 调外部了,注意
			var pos = repeatObj.pos;
			var repeatPos = repeatObj.repeatPos;
			var repeatKeyArr = repeatObj.keyArr;
			if (typeof pos === 'undefined') {
				return retJson;
			}
			var colTitleObj = {};
			var cols = $this.datagrid('options').columns[0];
			for (var cI = 0; cI < cols.length; cI++) {
				var colIModal = cols[cI];
				if (colIModal.hidden || colIModal.checkbox) {
					continue;
				}
				var cIField = colIModal.field;
				if (cIField) {
					colTitleObj[cIField] = colIModal.title;
				}
			}
			var titleArr = [];
			for (var j = 0; j < repeatKeyArr.length; j++) {
				var field = repeatKeyArr[j];
				titleArr.push(colTitleObj[field]);
			}
			return {
				pos: pos,
				repeatPos: repeatPos,
				titleArr: titleArr
			};
		},
		/**
		 * @description 更新一行数据,替代原来的updateRow方法,主要解决:
		 *              (1)处于编辑中的值的更新; (2)ie浏览器数字框不起作用; (3)联动更新
		 * Huxt 2021-04-18
		 */
		updateRowData: function (datagrid, data) {
			return datagrid.each(function () {
				// 获取参数
				var updData = data.row || {};
				var $_dg = $(this);
				var gridInfo = $.data(this, 'datagrid');
				var gridOpts = gridInfo.options;
				var rowData = gridOpts.finder.getRow(this, data.index);
				// 遍历更新列
				var tr = gridOpts.finder.getTr(this, data.index);
				for (var field in updData) {
					var fieldOption = $_dg.datagrid('getColumnOption', field);
					// 更新源数据
					var oldVal = _isNull(rowData[field]) ? '' : rowData[field];
					var fieldVal = updData[field];
					if (!fieldOption) {
						rowData[field] = fieldVal;
						continue;
					}
					var colEditor = fieldOption.editor;
					if (colEditor && colEditor.type === 'numberbox') {
						if (fieldVal !== '') {
							if (colEditor.options.gridPrecision !== undefined) {
								if (colEditor.options.gridPrecision !== '' && colEditor.options.gridPrecision >= 0) {
									fieldVal = Number(fieldVal).toFixed(colEditor.options.gridPrecision);
								}
							} else if (colEditor.options.precision >= 0) {
								fieldVal = Number(fieldVal).toFixed(colEditor.options.precision);
							}
						}
					}
					rowData[field] = fieldVal;
					var descVal = undefined;
					var descField = fieldOption.descField;
					if (!_isNull(descField)) {
						descVal = updData[descField];
						rowData[descField] = _isNull(descVal) ? fieldVal : descVal;
					}
					// 更新Grid显示
					tr.find("td[field='" + field + "']").each(function (i) {
						var dom_input_div = $(this).children()[0];
						if ($(dom_input_div).attr('class').indexOf('datagrid-editable') >= 0) {
							// 正在编辑的Cell
							var ed = $.data(dom_input_div, 'datagrid.editor');
							if (!_isNull(ed)) {
								if (['combobox', 'combogrid', 'lookup'].indexOf(ed.type) >= 0) {
									var cmg = null;
									if (ed.type == 'combogrid') {
										cmg = $.data(ed.target[0], 'combogrid');
										if (cmg) {
											$(cmg.grid).datagrid('options')._action = 'setValue';
										}
									}
									$(ed.target)[ed.type]('setValue', fieldVal);
									$(ed.target)[ed.type]('setText', descVal);
									if (cmg) {
										$(cmg.grid).datagrid('options')._action = '';
									}
								} else {
									if (ed.type == 'numberbox') {
										$(ed.target).numberbox('options').precision = colEditor.options.precision;
									}
									ed.actions.setValue(ed.target, fieldVal);
								}
							} else {
								$(dom_input_div).html(fieldVal);
							}
						} else {
							// 已结束编辑的Cell
							var newFieldVal = !_isNull(descVal) ? descVal : fieldVal;
							if ($.isFunction(fieldOption.formatter)) {
								fmtFieldVal = fieldOption.formatter(newFieldVal, rowData, data.index);
								if (!_isNull(fmtFieldVal)) {
									newFieldVal = fmtFieldVal;
								}
							}
							$(dom_input_div).html(newFieldVal);
						}
						if (colEditor && oldVal != fieldVal) {
							$(this).addClass('datagrid-value-changed');
						}
					});
					// 更新数据
					if (oldVal != fieldVal) {
						var uRows = gridInfo.updatedRows;
						var iRows = gridInfo.insertedRows;
						if (_existRow(iRows, rowData) == -1) {
							if (_existRow(uRows, rowData) == -1) {
								uRows.push(rowData);
							}
						}
					}
				}
			});
			function _existRow(e, t) {
				for (var i = 0, a = e.length; i < a; i++) {
					if (e[i] == t) {
						return i;
					}
				}
				return -1;
			}
			function _isNull(v) {
				return (typeof v === 'undefined' || v === null);
			}
		},
		/**
		 * @description 动态设置小数位数
		 * Huxt 2022-03-18
		 */
		setPrecision: function (jq, param) {
			return jq.each(function () {
				var $_dg = $(this);
				for (var f in param) {
					var precision = parseInt(param[f]);
					if (!isNaN(precision)) {
						var colOpts = $_dg.datagrid('getColumnOption', f);
						if (colOpts && colOpts.editor) {
							if (colOpts.editor.type == 'numberbox') {
								var edOpts = colOpts.editor.options;
								if (!edOpts) {
									continue;
								}
								var index = $_dg.datagrid('options').editIndex;
								if (!edOpts.precisionArr) {
									edOpts.precisionArr = [];
								}
								edOpts.precisionArr[index] = precision;
								edOpts.precision = precision;
							}
						}
					}
				}
			});
		},
		/**
		 * @description 开始编辑之前初始化这一行的小数位数
		 * Huxt 2022-03-18
		 */
		initPrecision: function (jq, index) {
			var $_dg = $(jq[0]);
			var dgOpts = $_dg.datagrid('options');
			if (dgOpts.precisionIndex != index) {
				dgOpts.precisionIndex = index;
				var allCols;
				var columns = dgOpts.columns[0];
				var frozenCols = dgOpts.frozenColumns ? dgOpts.frozenColumns[0] : undefined;
				if (typeof frozenCols !== 'undefined') {
					allCols = frozenCols.concat(columns);
				} else {
					allCols = columns;
				}
				for (var i = 0; i < allCols.length; i++) {
					var iCol = allCols[i];
					if (iCol.editor) {
						if (iCol.editor.type == 'numberbox') {
							var edOpts = iCol.editor.options;
							if (!edOpts) {
								continue;
							}
							if (!edOpts.precisionArr) {
								edOpts.precisionArr = [];
							}
							if (edOpts.precisionArr[index]) {
								edOpts.precision = edOpts.precisionArr[index];
							} else if (edOpts.tmp_precision >= 0) {
								edOpts.precision = edOpts.tmp_precision;
							}
						}
					}
				}
			}
		},
		/**
		 * @description 重写几个方法,防止表格编辑报些莫名的错误.
		 * Huxt 2022-03-13
		 */
		getPager: function (e) {
			var dg = $.data(e[0], "datagrid");
			if (dg) {
				return dg.panel.children("div.datagrid-pager");
			}
			return null;
		},
		loaded: function (e) {
			return e.each(function () {
				var pager = $(this).datagrid("getPager");
				if (!pager) {
					return false;
				}
				pager.pagination("loaded");
				var e = $(this).datagrid("getPanel");
				e.children("div.datagrid-mask-msg").remove();
				e.children("div.datagrid-mask").remove();
			});
		},
		getRowIndex: function (jq, row) {
			var opts = jq.datagrid('options');
			if ($.fn.datagrid.methods.baseGetRowIndex) {
				if (opts.view.type == 'scrollview') {
					var data = jq.datagrid('getData');
					var firstRows = data.firstRows;
					var index =  - 1;
					if ((firstRows) && (opts.id)) {
						if (typeof row == 'object') {
							index = $.easyui.indexOfArray(firstRows, row);
						} else {
							index = $.easyui.indexOfArray(firstRows, opts.idField, row);
						}
					}

					if (index >= 0) {
						return index;
					} else {
						index = jq.datagrid('baseGetRowIndex', row);
						return (index == -1) ? -1 : index + opts.view.index;
					}
				} else {
					return jq.datagrid('baseGetRowIndex', row);
				}
			} else {
				return jq.datagrid('orgGetRowIndex', row);
			}
		},
		// 强制完成行编辑 (有必填项未填时)
		forceEndEdit: function (e, index) {
			return e.each(function () {
				var a = $.data(this, "datagrid").options.finder.getTr(this, index);
				if (!a.hasClass("datagrid-row-editing")) {
					$(this).datagrid('endEdit', index);
					return;
				}
				var vdBoxs = a.find(".validatebox-text");
				for (var v = 0; v < vdBoxs.length; v++) {
					var vdData = $.data(vdBoxs[v], "validatebox");
					if (vdData) {
						vdData.options._novalidate = vdData.options.novalidate;
						vdData.options.novalidate = true;
					}
				}
				$(this).datagrid('endEdit', index);
				for (var v = 0; v < vdBoxs.length; v++) {
					var vdData = $.data(vdBoxs[v], "validatebox");
					if (vdData) {
						vdData.options.novalidate = vdData.options._novalidate;
					}
				}
			});
		},
		// 重写删除
		deleteRow: function (e, index) {
			orgDeleteRow(e, index);
			e.each(function () {
				var i = $.data(this, "datagrid");
				if (i) {
					i.options.cellData = {};
				}
			});
		}
	});
	/**
	 * triggerbox 增加Id值
	 */
	$.extend($.fn.triggerbox.defaults, {
		valueId: ''
	});
	$.extend($.fn.triggerbox.methods, {
		setValueId: function (target, val) {
			$(target).triggerbox('options').valueId = val;
		},
		getValueId: function (target) {
			var realVal = $(target).triggerbox('options').valueId;
			if ($(target).triggerbox('getValue') == '') {
				realVal = '';
			}
			return realVal;
		}
	});
	/**
	 * lookup 增加Value值
	 */
	$.extend($.fn.lookup.defaults, {
		value: ''
	});
	$.extend($.fn.lookup.methods, {
		setValue: function (target, val) {
			$(target).lookup('options').value = val;
		},
		getValue: function (target) {
			var realVal = $(target).lookup('options').value;
			if ($(target).lookup('getText') == '') {
				realVal = '';
			}
			return realVal;
		}
	});
	/**
	 * combobox 增加方法
	 */
	$.extend($.fn.combobox.methods, {
		/**
		 * 设置默认值,在onloadsuccess后
		 * @param {string} value - 对应的valueId的值
		 */
		setDefaultValue: function (jq, value) {
			return jq.each(function () {
				var $this = $.data(jq[0], 'combobox');
				var valueField = $this.options.valueField;
				var data = $.data(jq[0], 'combobox').data;
				for (var i = 0; i < data.length; i++) {
					if (data[i][valueField] == value) {
						$(jq[0]).combobox('setValue', value);
					}
				}
			});
		},
		/**
		 * 设置默认值并触发select,在onloadsuccess后
		 * @param {string} value - 对应的valueId的值
		 */
		selectDefault: function (jq, value) {
			return jq.each(function () {
				var $this = $.data(jq[0], 'combobox');
				var valueField = $this.options.valueField;
				var data = $.data(jq[0], 'combobox').data;
				for (var i = 0; i < data.length; i++) {
					if (data[i][valueField] == value) {
						$(jq[0]).combobox('select', value);
					}
				}
			});
		}
	});
	/**
	 * validatebox 增加验证价格
	 */
	$.extend($.fn.validatebox.defaults.rules, {
		price: {
			message: '请输入正确的价格',
			validator: function (value) {
				if (value !== '') {
					var regStr = /^[0-9]+(\.[0-9]{1,6})?$/;
					return regStr.test(value);
				} else {
					return true;
				}
			}
		}
	});

	/**
	 * 是否显示允许模态按钮
	 */
	$.extend($.fn.window.defaults, {
		modalable: false
	});
	$.extend($.fn.window.methods, {
		setModal: function (target, val) {
			// 设置是否允许模态化
			$(target).window('options').modal = val;
			$(target).window({});
			$(target).window('setModalable');
		},
		setModalable: function (target) {
			// 设置是否允许模态化
			$(target).window('options').modalable = true;
			var stickEle = $('<a class="pha-panel-tool-sticky"></a>');
			stickEle.unbind().on('click', function () {
				var modelFlag = $(target).window('options').modal === true ? false : true;
				$(target).window('setModal', modelFlag);
			});
			$(target).panel('header').find('.panel-tool').prepend(stickEle);
		}
	});
	// datagrid-filter 相关
	if ($.fn.datagrid.defaults.operators) {
		if (typeof $g == 'undefined') {
			var $g = function (v) {
				return v;
			}
		}
		$.fn.datagrid.defaults.operators.nofilter.text = $g('无');
		$.fn.datagrid.defaults.operators.contains.text = $g('包含');
		$.fn.datagrid.defaults.operators.equal.text = $g('等于');
		$.fn.datagrid.defaults.operators.notequal.text = $g('不等于');
		$.fn.datagrid.defaults.operators.beginwith.text = $g('前匹配');
		$.fn.datagrid.defaults.operators.endwith.text = $g('后匹配');
		$.fn.datagrid.defaults.operators.less.text = $g('小于');
		$.fn.datagrid.defaults.operators.lessorequal.text = $g('小于等于');
		$.fn.datagrid.defaults.operators.greater.text = $g('大于');
		$.fn.datagrid.defaults.operators.greaterorequal.text = $g('大于等于');
		$.extend($.fn.datagrid.defaults.operators, {
			notcontains: {
				text: '不包含',
				isMatch: function (source, value) {
					source = String(source);
					value = String(value);
					return source.toLowerCase().indexOf(value.toLowerCase()) < 0;
				}
			}
		});
		$.extend($.fn.datagrid.methods, {
			enableFilterAll: function (jq, filters) {
				return jq.each(function () {
					var $grid = $(this);
					filters = filters || [];
					var filterCols = [];
					var defaultOp = ['contains', 'notcontains', 'equal', 'notequal', 'beginwith', 'endwith'];
					var cols = [].concat($grid.datagrid('options').columns[0]);
					var frozenCols = $grid.datagrid('options').frozenColumns[0];
					if (frozenCols) {
						cols = cols.concat(frozenCols);
					}

					for (var i = 0, len = cols.length; i < len; i++) {
						var col = cols[i];
						if (col.hidden === true) {
							continue;
						}
						filterCols.push({
							field: col.field,
							op: defaultOp,
							type: 'text',
							defaultFilterOperator: 'contains'
						});
					}

					$grid.datagrid('enableFilter', $.extend([], filterCols, filters));
				});
			}
		});
	}
	/**
	 * tooltip没有内容时不显示
	 */
	$.fn.tooltip.methods.orgShow = $.fn.tooltip.methods.show;
	$.extend($.fn.tooltip.methods, {
		show: function (e, t) {
			return e.each(function () {
				var r = $.data(this, "tooltip");
				var o = r.options;
				var content = o.content || '';
				if (content != '') {
					$.fn.tooltip.methods.orgShow($(this), t);
				}
			});
		}
	});
	/**
	 * 重写popover,主要新增以下功能
	 * (1)根据文本长度自动时间
	 * (2)光标已送到提示框不消失,移走后提示框消失
	 */
	$.messager.phapopover = function (e) {
		if (!e.timeout) {
			e.timeout = e.msg.length * 150;
			if (e.timeout < 1000) {
				e.timeout = 1000;
			}
		}
		var t = {
			style: {
				top: "",
				left: ""
			},
			msg: "",
			type: "error",
			timeout: 3e3,
			showSpeed: "fast",
			showType: "slide"
		};
		var i = $.extend({}, t, e);
		var a = '<div class="messager-popover ' + i.type + '" style="display:none;">' + '<span class="messager-popover-icon ' + i.type + '"/><span class="content">' + $.hisui.getTrans(i.msg) + "</span>";
		if (i.timeout > 5e3)
			 + '<span class="close"></span>' + "</div>";
		var n = $(a).appendTo("body");
		if (i.style.left == "") {
			i.style.left = document.body.clientWidth / 2 - n.width() / 2;
		}
		if (i.style.top == "") {
			i.style.top = document.body.clientHeight / 2 - n.height() / 2;
		}
		n.css(i.style);
		switch (i.showType) {
		case null:
			n.show();
			break;
		case "slide":
			n.slideDown(i.showSpeed);
			break;
		case "fade":
			n.fadeIn(i.showSpeed);
			break;
		case "show":
			n.show(i.showSpeed);
			break;
		}
		n.find(".close").click(function () {
			n.remove();
		});
		var removeDiv = function (_action) {
			if (n.attr('ishover') == 'Y' && _action == 'auto') {
				return;
			}
			switch (i.showType) {
			case null:
				n.hide();
				break;
			case "slide":
				n.slideUp(i.showSpeed);
				break;
			case "fade":
				n.fadeOut(i.showSpeed);
				break;
			case "show":
				n.hide(i.showSpeed);
				break
			}
			setTimeout(function () {
				n.remove();
			}, i.timeout);
		}
		n.hover(function () {
			n.attr('ishover', 'Y');
		}, function () {
			removeDiv('fly');
		});
		if (i.timeout > 0) {
			var r = setTimeout(function () {
				removeDiv('auto');
			}, i.timeout);
		}
	}
})(jQuery);

/**
 * 重写lodashjs部分方法
 */
if (typeof _ == 'undefined') {
	_ = {};
}
(function (_) {
	// 加法
	_.add = function (n1, n2) {
		var r1, r2, m;
		try {
			r1 = n1.toString().split(".")[1].length;
		} catch (e) {
			r1 = 0;
		}
		try {
			r2 = n2.toString().split(".")[1].length;
		} catch (e) {
			r2 = 0;
		}
		m = Math.pow(10, r1 + r2);
		return (parseInt(n1 * m) + parseInt(n2 * m)) / m;
	}
	// 除法
	_.divide = function (n1, n2) {
		var t1 = 0, t2 = 0, r1, r2;
		try {
			t1 = n1.toString().split(".")[1].length;
		} catch (e) {}
		try {
			t2 = n2.toString().split(".")[1].length;
		} catch (e) {}
		with (Math) {
			var m = pow(10, t1 + t2);
			r1 = Number(n1) * m;
			r2 = Number(n2) * m;
			return r1 / r2;
		}
	}
	// 乘法
	_.multiply = function (n1, n2) {
		var m = 0, s1 = n1.toString(), s2 = n2.toString();
		try {
			m += s1.split(".")[1].length;
		} catch (e) {}
		try {
			m += s2.split(".")[1].length;
		} catch (e) {}
		return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m);
	}
	// 全部替换
	_.replaceAll = function (str, oldStr, newStr) {
		return str.replace(new RegExp(oldStr, 'gm'), newStr);
	}
	// 字符串转数字
	_.toFixed = function (n1, nLen) {
		var n = parseFloat(n1);
		if (isNaN(n)) {
			return n1;
		}
		return n.toFixed(nLen);
	}
	_.safecalc = function (funcName, n1, n2, toFixFlag) {
		if (n1 === undefined) {
			n1 = ''
		}
		if (n2 === undefined) {
			n2 = ''
		}
		n1 = n1.toString().replace(/[^\d\.-]/g, '');
		n2 = n2.toString().replace(/[^\d\.-]/g, '');
		var ret = _[funcName](n1, n2);
		if (isNaN(ret)) {
			return '';
		}
		if (ret === Infinity) {
			return '';
		}
		if (toFixFlag === true) {
			var n1Fixed = n1.toString().split('.')[1] || '';
			var n2Fixed = n2.toString().split('.')[1] || '';
			ret = _.toFixed(ret, Math.max(n1Fixed.length, n2Fixed.length));
		}
		return ret;
	},
	_.isLikeNumber = function (str) {
		if (str === true || str === false || str === '') {
			return false;
		}
		return isFinite(str)
	}
})(_);

/**
 * 信息条, 类似患者信息条
 * $('.js-pha-plan-banner').phabanner({
 *     title: '信息提示'
 * });
 * var dataArr = [{
 *     prepend: '制单:',
 *     info: ' 2022-03-03 11:22:33',
 *     append: '/'
 * }]
 * $('.js-pha-plan-banner').phabanner('loadData', dataArr);
 * 文档
 */
(function ($) {
	function loadData(target, dataArr) {
		var opts = $.data(target, 'phabanner').options;
		var labelTop = calcLabelTop(target);
		var bannerHtmlArr = [];
		for (var i = 0, length = dataArr.length; i < length; i++) {
			var cellArr = [];
			var rowData = dataArr[i];
			var prepend = rowData.prepend || '';
			var info = rowData.info;
			var append = rowData.append || '';
			var labelClass = rowData.labelClass || '';
			if (prepend !== '') {
				cellArr.push('<div class="prepend">' + prepend + '</div>');
			}
			if (info !== '') {
				if (labelClass === '') {
					cellArr.push('<div class="info">' + info + '</div>');
				} else {
					cellArr.push('<div class="pha-banner-label ' + labelClass + '" style="top:' + labelTop + 'px;">' + info + '</div>');
				}
			}
			if (append !== '') {
				cellArr.push('<div class="append">' + append + '</div>');
			}

			bannerHtmlArr.push(cellArr.join(''));
		}
		var htmlStr = '';
		if (!dataArr.length ) htmlStr = '<div class = "title">选择单据后, 显示详细信息</div>';
		else htmlStr = bannerHtmlArr.join('');
		$(target).children('.pha-banner').html(htmlStr);
	}
	function calcLabelTop(target) {
		var opts = $.data(target, 'phabanner').options;
		var labelTop = opts.labelTop || '';
		// pha-label 的高度定的20, 加边框22
		return labelTop !== '' ? labelTop : (opts.height - 22) / 2;
	}
	function create(target) {
		var state = $.data(target, 'phabanner');
		var opts = state.options;
		var bannerHtmlArr = [];
		var height = opts.height + 'px';
		bannerHtmlArr.push('<div class="pha-banner" style="height:' + height + ';line-height:' + height + ';">');
		bannerHtmlArr.push('    <div class="title">' + opts.title + '</div>');
		bannerHtmlArr.push('</div>');
		$(target).html(bannerHtmlArr.join(''));
	}
	$.fn.phabanner = function (options, param) {
		if (typeof options == 'string') {
			var methods = $.fn.phabanner.methods[options];
			return methods(this, param);
		}
		options = options || {};
		return this.each(function () {
			var state = $.data(this, 'phabanner');
			if (state) {
				$.extend(state.options, options);
				create(this);
			} else {
				state = $.data(this, 'phabanner', {
					options: $.extend({}, $.fn.phabanner.defaults, options)
				});
				create(this);
			}
		});
	};
	$.fn.phabanner.defaults = {
		title: '',
		height: 35
	};
	$.fn.phabanner.methods = {
		options: function (jq) {
			return $.extend($.data(jq[0], 'phabanner').options);
		},
		loadData: function (jq, dataArr) {
			return jq.each(function () {
				loadData(this, dataArr);
			});
		},
		reset: function (jq) {
			return jq.each(function () {
				create(this);
			});
		}
	};
})($);

/**
 * 月份下拉框插件
 * Huxt 2022-06-23
 */
(function ($) {
	function init(e, options) {
		var initOpts = $.extend({}, $.fn.phamonthbox.defaults, options);
		initOpts.onShowPanel = function () {
			var $combop = $(this).phamonthbox('panel');
			$combop.width($combop.width() - 1);
			options.onShowPanel && options.onShowPanel.call(this);
		}
		initOpts.onHidePanel = function () {
			var $input = $(e).combo('panel').find('input').filter('.combobox-f');
			var year = $input.combobox('getValue');
			var $td = $(e).combo('panel').find('td').filter('.calendar-selected');
			var mon = $td.attr('mon');
			setValue(e, year + '-' + mon);
			options.onHidePanel && options.onHidePanel.call(this);
		}
		$(e).combo(initOpts);
		var yearMin = initOpts.yearMin;
		var yearMax = initOpts.yearMax;
		var yearLabel = initOpts.yearLabel;
		var monArr = initOpts.monArr;
		var yearData = [];
		for (var y = yearMin; y <= yearMax; y++) {
			yearData.push({
				id: '' + y,
				text: '' + y
			});
		}
		var tMon = 0;
		var pContent = '';
		pContent += '<div style="margin:5px 0 5px 0;padding:0 0 5px 0;border-bottom:1px solid #ccc;text-align:center;">';
		pContent += '<div style="display:inline-block;vertical-align:middle;">' + yearLabel + '</div>';
		pContent += '<div style="display:inline-block;vertical-align:middle;padding-left:10px;"><input /></div>';
		pContent += '</div>';
		pContent += '<div>';
		pContent += '<table style="width:100%;text-align:center;margin-top:6px;" border="0" cellpadding="0" cellspacing="0">';
		for (var i = 0; i < monArr.length; i++) {
			var rowArr = monArr[i];
			pContent += '<tr style="height:35px;">';
			var cols = rowArr.length;
			var colWidth = ((1 / cols) * 100) + '%';
			for (var j = 0; j < cols; j++) {
				tMon++;
				var tMonStr = tMon.toString().length == 1 ? '0' + tMon : '' + tMon;
				pContent += '<td class="calendar-menu-month" style="width:' + colWidth + '" mon="' + tMonStr + '">' + rowArr[j] + '</td>';
			}
			pContent += '</tr>';
		}
		pContent += '</table>';
		pContent += '</div>';
		$(e).next().addClass('datebox');
		var $combop = $(e).combo('panel');
		$combop.addClass('panel-noscroll').html(pContent);
		$combop.find('input').combobox({
			width: 80,
			panelHeight: 160,
			valueField: 'id',
			textField: 'text',
			data: yearData,
			mode: 'local',
			filter: function (q, row) {
				var opts = $(this).combobox('options');
				return row[opts.textField].toString().indexOf(q) == 0;
			},
			onSelect: function (val) {
				var month = $combop.find('td').filter('.calendar-selected').attr('mon');
				setValue(e, val.text + '-' + month);
			}
		});
		$combop.find('td').hover(function () {
			$(this).addClass('calendar-menu-hover')
		}, function () {
			$(this).removeClass('calendar-menu-hover');
		}).on('click', function () {
			var year = $combop.find('input').combobox('getValue');
			var month = $(this).attr('mon');
			month = month.toString().length == 1 ? '0' + month : '' + month;
			setPanelYear(e, year);
			setPanelMonth(e, month);
			initOpts.onSelect && initOpts.onSelect.call(e, year + '-' + month);
			$.fn.phamonthbox.methods.hidePanel($(e)); // onHidePanel -> setValue
		});
		$(e).combo('textbox').on('keydown', function (ev) {
			setTimeout(function () {
				setValue(e, $(e).combo('textbox').val());
			}, 100);
		})
		initVal = (!initOpts.value || initOpts.value == '') ? new Date() : initOpts.value;
		setValue(e, initVal);
	}
	function setValue(e, val) {
		var d = $.data(e, 'combo');
		var year = '';
		var month = '';
		if (Object.prototype.toString.call(val) == '[object Date]') {
			year = val.getFullYear();
			month = val.getMonth() + 1;
		} else {
			val = val ? val : '';
			if (!(/^\d{4,4}-\d{1,3}$/.test(val))) {
				return;
			}
			var valArr = val.toString().split('-');
			year = valArr[0];
			month = parseInt(valArr[1]);
			if (month <= 0 || month > 12 || isNaN(month)) {
				return;
			}
		}
		month = month.toString().length == 1 ? '0' + month : month;
		$(e).combo('textbox').val(year + '-' + month);
		setPanelYear(e, year);
		setPanelMonth(e, month);
	}
	function getValue(e) {
		return $(e).combo('textbox').val();
	}
	function setPanelYear(e, year) {
		var $input = $(e).combo('panel').find('input').filter('.combobox-f');
		$input.combobox('setValue', year);
		$input.combobox('setText', year);
	}
	function setPanelMonth(e, month) {
		var $tds = $(e).combo('panel').find('td');
		$tds.removeClass('calendar-selected');
		$tds.filter('[mon="' + month + '"]').addClass('calendar-selected');
	}
	// 入口
	$.fn.phamonthbox = function (options, param) {
		if (typeof options == 'string') {
			var methods = $.fn.phamonthbox.methods[options];
			return methods(this, param);
		}
		options = options || {};
		return this.each(function () {
			init(this, options);
		});
	};
	$.fn.phamonthbox.defaults = $.extend({}, $.fn.combo.defaults, {
		panelWidth: 180,
		yearLabel: '年份',
		yearMin: 1971,
		yearMax: 2999,
		monArr: [
			['一月', '二月', '三月'],
			['四月', '五月', '六月'],
			['七月', '八月', '九月'],
			['十月', '十一月', '十二月']
		],
		onSelect: function (val) {}
	});
	$.fn.phamonthbox.methods = $.extend({}, $.fn.combo.methods, {
		setValue: function (e, val) {
			return e.each(function () {
				setValue(this, val);
			});
		},
		getValue: function (e) {
			return getValue(e[0]);
		}
	});
	/**
	 * 针对药库价格编辑的扩展,如下参数需要一起使用,
	 * 当小数位数不满minPrecision时, 补位
	 * 当小数位数大于maxPrecision时, 取舍(toFixed)
	 * 原因为 草药和西药的位数、基本单位和入库单位的位数均有不同要求,没必要每次表格内容变动都去动态更新, 只做最后保留即可
	 */
	$.extend($.fn.numberbox.defaults, {
		minPrecision: 2,
		maxPrecision: 6,
		phaOptions: {
			minPrecision: 2,
			maxPrecision: 6,
			min: 0,
			max: 9999999,
			gridPrecision: '',
			tipPosition: 'top',
			parser: function (t) {
				return $.fn.numberbox.defaults.phaParser.call(this, t)
			}
		},
		phaParser: function (t) {
			var newVal;
			try {
				// 先parser, 后formatter
				var tSecond = t.toString().split('.')[1];
				if (tSecond === undefined || tSecond === '') {
					return t;
				}
				var tSecondLen = tSecond.length;
				var i = $(this).numberbox('options');
				// var precision = i.precision || 0; // 结合min|max用, 不用这个了
				newVal = t;
				if (tSecondLen > i.maxPrecision) {
					newVal = parseFloat(t).toFixed(i.maxPrecision);
				} else if (tSecondLen < i.minPrecision) {
					newVal = parseFloat(t).toFixed(i.minPrecision);
				}
				// @TODO 校验最小最大值
				if (isNaN(newVal)) {
					// 非数字直接反空
					return '';
				}
			} catch (e) {
				newVal = ''
			}
			return newVal;
		}
	});
})($);

(function ($) {
	var defaults = {
		width: 'auto',
		content: '',
		handler: null
	};
	var methods = {
		create: function (options) {
			var eTarget = $(window.event.target).closest('a');
			if (eTarget.length === 0) {
				eTarget = $(window.event.target).closest('img');
			}
			if (eTarget.length === 0) {
				eTarget = $(window.event.target).closest('span');
			}
			var cRect = eTarget[0].getBoundingClientRect();
			var eWidth = cRect.width;
			var eHeight = cRect.height;
			var eTop = cRect.top;
			var eLeft = cRect.left;
			var $_pop = $(this.make());
			$_pop.find('.popconfirm-info').html(options.content);
			if (options.width !== 'auto') {
				$_pop.find('.pha-popconfirm-body').css({
					width: options.width
				});
			}
			$_pop.appendTo('body');
			$_pop.css({
				position: 'absolute',
				top: eTop + eHeight + 10,
				left: eLeft,
				display: 'block'
			});
			// debugger
			$_pop.find('.pha-tri,.pha-tri-white').css({
				left: eWidth / 2
			});
			$('.js-pha-popconfirm-confirm,.js-pha-popconfirm-cancel')
			.unbind()
			.click(function (e) {
				$_pop.remove();
				if (options.handler) {
					if ($(e.target).hasClass('js-pha-popconfirm-confirm')) {
						if (options.handler.confirm) {
							options.handler.confirm()
						}
					} else {
						if (options.handler.cancel) {
							options.handler.cancel()
						}
					}
				}
			});
		},
		make: function () {
			var htmlArr = [];
			htmlArr.push('<div class="pha-popconfirm">');
			htmlArr.push('<div class="pha-popconfirm-body">');
			htmlArr.push('    <div class="pha-tri pha-tri-up"></div>');
			htmlArr.push('    <div class="pha-tri-white pha-tri-white-up"></div>');
			htmlArr.push('    <div>');
			htmlArr.push('        <div class="popconfirm-info"></div>');
			htmlArr.push('        <div style="clear: both;"></div>');
			htmlArr.push('    </div>');
			htmlArr.push('    <div class="pha-popconfirm-footer">');
			htmlArr.push('        <a class="pha-sm-button pha-sm-button-default js-pha-popconfirm-cancel">取消</a>');
			htmlArr.push('        <a class="pha-sm-button pha-sm-button-primary js-pha-popconfirm-confirm">确认</a>');
			htmlArr.push('    </div>');
			htmlArr.push('  </div>');
			htmlArr.push('</div>');
			return htmlArr.join('');
		}
	};
	$.popconfirm = function (options, param) {
		// 此处this指dom元素, 本处未用
		// $('#ccc').popconfirm , 此时this = $('#ccc')
		// var opts = $.data(target, 'window').options;
		if ($('.pha-popconfirm')) {
			$('.pha-popconfirm').remove();
		}
		methods.create($.extend({}, defaults, options));
	};
})(jQuery);

/**
 * dom元素晃动, 抖动效果, 可用此使按钮晃动以提醒用户操作
 * @param {*} intShakes 抖动次数
 * @param {*} intDistance 抖动左右距离
 * @param {*} intDuration 持续时间
 * @returns 
 */
 (function ($) {
    $.fn.phashake = function (intShakes, intDistance, intDuration) {
        this.each(function () {
            var jqNode = $(this);
            jqNode.css({ position: 'relative' });
            for (var x = 1; x <= intShakes; x++) {
                jqNode
                    .animate({ left: intDistance * -1 }, intDuration / intShakes / 4)
                    .animate({ left: intDistance }, intDuration / intShakes / 2)
                    .animate({ left: 0 }, intDuration / intShakes / 4);
            }
        });
        return this;
    };
})(jQuery);