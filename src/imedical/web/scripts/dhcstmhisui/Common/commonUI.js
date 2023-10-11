/**
 * 公共UI组件
 */
function CommonUI() {
	/**
	 * 默认确认框标题
	 */
	this._DEFAULT_TITLE_CONFIRM = '请确认';

	/**
	 * 默认确认提示类型
	 */
	this._DEFAULT_CONFIRM_TYPE_MESSAGE = 'question';

	/**
	 * 默认ok按钮文本
	 */
	this._DEFAULT_OK_BUTTON_TEXT = '确定';

	/**
	 * 默认cancel按钮文本
	 */
	this._DEFAULT_CANCEL_BUTTON_TEXT = '取消';
	
	/**
	 * 消息确认框，用于替换原生confirm
	 * @param message 消息
	 * @param alertType 提示图标类型（可选,应在下列值之间：error|question|info|warning）
	 * @param okText 确定按钮文本（可选，有默认）
	 * @param okFunc 确定按钮处理函数（可选）
	 * @param cancelText 取消按钮文本（可选，有默认）
	 * @param cancelFunc 取消按钮处理函数（可选）
	 * @param title 标题（可选，有默认）
	 * @param hasCloseCross 有关闭按钮（可选，默认true）
	 * @param paramsobj okFunc需要的参数
	 */
	this.confirm = function(message, alertType, okText, okFunc, cancelText, cancelFunc, title, hasCloseCross, paramsobj) {
		var _alertType = alertType ? alertType : this._DEFAULT_CONFIRM_TYPE_MESSAGE;
		var _title = title ? title : this._DEFAULT_TITLE_CONFIRM;
		jQuery.messager.defaults.ok = this._DEFAULT_OK_BUTTON_TEXT;
		if (okText) {
			jQuery.messager.defaults.ok = okText;
		}
		jQuery.messager.defaults.cancel = this._DEFAULT_CANCEL_BUTTON_TEXT;
		if (cancelText) {
			jQuery.messager.defaults.cancel = cancelText;
		}
		jQuery.messager.confirm(_title, message, function(rlt) {
			if (rlt) { // ok
				var _paramsobj = paramsobj ? paramsobj : '';
				if (okFunc) okFunc(_paramsobj);
			} else { // cancel
				if (cancelFunc) cancelFunc();
			}
		});
		if (_alertType) {
			jQuery('body > .messager-window:last > .messager-body > .messager-icon')
				.removeClass('messager-question').addClass('messager-' + alertType);
		}
		if (!hasCloseCross) {
			jQuery('body > .messager-window:last > .panel-header > .panel-tool > .panel-tool-close').remove();
		}
	};
	
	/**
	 * msg 提示内容 ''
	 * type 提示类型 'error' 可选属性,'success','info','alert','error'
	 * timeout 显示时间长度(毫秒)/td> 3000 0表示一直显示不消失。
	 * showSpeed 显示速度 'fast' 可选属性,'fast','slow','normal',数字(毫秒数)
	 * showType 显示方式 'slide' 可选属性,'slide','fade','show'
	 * style 显示位置 顶部中间位置 right,top,left,bottom
	*/
	this.msg = function(type, msg, timeout, showSpeed, showType, style) {
		msg = msg || '', type = type || 'error', timeout = timeout || 4000, showSpeed = showSpeed || 'fast';
		showType = showType || 'slide', style = style || { top: document.body.scrollTop + document.documentElement.scrollTop + 40, left: '' };
		var alertlength = $('.messager-popover.alert').length;
		// var iconlength=$(".messager-popover.icon").length;
		var length = 0;
		if (alertlength > 1) { length = alertlength; }
		// if (iconlength>1){length=iconlength;}
		style.top += length * 50;
		var op = {
			msg: msg,
			type: type,
			timeout: timeout,
			showType: showType,
			style: style
		};
		try {
			$.messager.popover(op);
		} catch (e) {
			parent.$.messager.popover(op);
		}
	};
	
	/**
	 * xuchao
	 * 2018-07-05
	 * 按钮禁用1秒  防止重复点击
	 * 添加快捷键功能
	 * 示例代码 hotKey:''Ctrl+o'',
	 * tip 提示 快捷键功能
	*/
	this.linkbutton = function(id, options) {
		if (!isEmpty(ButtonCountObj[id])) {
			ButtonCountObj[id] = 0;
		}
		// 使用DeepClone,重写onClick方法,否则会有死循环错误
		var _options = DeepClone(options);
		_options = $.extend(_options, {
			onClick: function() {
				$HUI.linkbutton(id).disable();
				var Count = ButtonCountObj[id];
				options.onClick();
				setTimeout(function() {
					var CurCount = ButtonCountObj[id];
					if (Count == CurCount) { // /延时时间内是否处理过按钮，如果处理过则不再处理
						$HUI.linkbutton(id).enable();
					}
				}, 1000);
			}
		});
		if (_options.hotKey) {
			jQuery(document).bind('keydown', _options.hotKey, function(evt) {
				$HUI.linkbutton(id).disable();
				var Count = ButtonCountObj[id];
				_options.onClick();
				setTimeout(function() {
					var CurCount = ButtonCountObj[id];
					if (Count == CurCount) { // /延时时间内是否处理过按钮，如果处理过则不再处理
						$HUI.linkbutton(id).enable();
					}
				}, 1000);
				return false;
			});
		}
		$HUI.linkbutton(id, _options);
		var text = $(id).text();
		if (_options.hotKey) {
			var text = text + '(' + _options.hotKey + ')';
		}
		$(id).tooltip({
			position: 'right',
			content: '<span style="">' + text + '</span>',
			onHide: function() {
				$(id).tooltip('destroy');
			}
		});
	};
	
	/**
	 * 构造DataGrid组件
	 * @param id，如#UomList
	 * @param options ，Grid 配置参数对象
	 * @author XuChao
	 */
	this.datagrid = function(id, options) {
		if (!id) return;
		var columns = options.columns;
		// 处理cm公共属性
		var _columns = [[]];
		var _frozenCol = [[]];
		setcolumns(columns, id, _columns, _frozenCol, options);
		delete options.columns;
		
		var _options = {};
		var colSet = {
			text: '列设置',
			iconCls: 'icon-set-col',
			handler: function() {
				GridColSet(gridObj);
			}
		};
		var exportExcelBtn = {
			text: '导出当前页',
			iconCls: 'icon-export-data',
			handler: function() {
				gridObj.exportExcel();
			}
		};
		var exportAllBtn = {
			text: '导出所有',
			iconCls: 'icon-export-all',
			handler: function() {
				gridObj.exportAll();
			}
		};
		var addRow = {
			text: '新增',
			iconCls: 'icon-add',
			handler: function() { gridObj.commonAddRow(); }
		};
		var deleteRow = {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() { gridObj.commonDeleteRow(); }
		};
		var saveRow = {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() { _options.saveDataFn(); }
		};
		var myview = $.extend({}, $.fn.datagrid.defaults.view, {
			onAfterRender: function(target) {
				$('.datagrid-cell').mouseover(function() {
					// 判断文本是否溢出
					if (this.offsetWidth < this.scrollWidth) {
						var content = $(this).text();
						$(this).tooltip({
							content: content,
							trackMouse: true,
							onHide: function() {
								$(this).tooltip('destroy');
							}
						}).tooltip('show');
					}
				});
			}
		});
		jQuery.extend(_options, {
			columns: _columns,
			frozenColumns: _frozenCol,
			data: [],
			autoRowHeight: true,
			striped: false,
			method: 'post',
			nowrap: true,
			url: $URL,
			lazy: true,
			loadMsg: '加载中,请稍后...',
			pagination: true,
			rownumbers: true,
			singleSelect: true,
			pagePosition: 'bottom',
			pageNumber: 1,
			pageSize: 15,
			pageList: [5, 10, 15, 20, 30, 50, 80, 100],
			remoteSort: true,
			sortName: '',
			sortOrder: 'asc',
			border: false,
			fit: true,
			autoSizeColumn: false,
			fixRowNumber: true,
			view: myview,				// 列显示不完整，加tooltip提示
			beforeAddFn: function() {},	// 新增一行前,判断是否符合条件(返回值===false则不新增行).
			// 否则,获取新增行缺省值,返回值格式:object
			afterAddFn: function() {},	// 新增一行后,如需调用某方法控制界面控件等,可通过此参数设置
			beforeDelFn: function() {},	// 删除选中行前，,判断是否符合条件(返回值===false则不删除).
			afterDelFn: function() {},
			showFooter: false, // 合计行
			saveDataFn: function() {},
			onLoadError: function(error) {
				$CommonUI.msg('error', '加载数据失败');
			},
			onSelectChangeFn: function() {},	// onselect、onunselect、onSelectAll、onUnselectAll事件发生时调用，处理选中或取消选中后执行方法
			onSelect: function(index, row) {
				if (jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)) {
					gridObj.jdata.options.onSelectChangeFn();
				}
			},
			onUnselect: function(index, row) {
				if (jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)) {
					gridObj.jdata.options.onSelectChangeFn();
				}
			},
			onSelectAll: function(rows) {
				if (jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)) {
					gridObj.jdata.options.onSelectChangeFn();
				}
			},
			onUnselectAll: function(rows) {
				if (jQuery.isFunction(gridObj.jdata.options.onSelectChangeFn)) {
					gridObj.jdata.options.onSelectChangeFn();
				}
			}
		});
		// toolbar, 可定义'#TB'式样的字符串, 也可在js中定义数组; 未定义时,按空数组处理.
		if (isEmpty(options.toolbar)) {
			options.toolbar = [];
		}
		var ToolBarType = typeof (options.toolbar);
		if (ToolBarType == 'object') {
			if (options.showAddSaveDelItems) {
				options.toolbar.unshift(addRow, saveRow, deleteRow);
			} else if (options.showAddSaveItems) {
				options.toolbar.unshift(addRow, saveRow);
			} else if (options.showAddDelItems) {
				options.toolbar.unshift(addRow, deleteRow);
			} else if (options.showSaveItems) {
				options.toolbar.unshift(saveRow);
			} else {
				if (options.showDelItems) {
					options.toolbar.unshift(deleteRow);
				}
				if (options.showAddItems) {
					options.toolbar.unshift(addRow);
				}
			}
			if (options.showBar) {
				options.toolbar.push(colSet, exportExcelBtn, exportAllBtn);
			}
		} else if (ToolBarType == 'string') {
			if (options.showAddDelItems) {
				$('<a href="javascripts:void(0)">删除</a>').prependTo($(options.toolbar)).linkbutton({ iconCls: 'icon-cancel', plain: true }).click(function() { gridObj.commonDeleteRow(); });
				$('<a href="javascripts:void(0)">新增</a>').prependTo($(options.toolbar)).linkbutton({ iconCls: 'icon-add', plain: true }).click(function() { gridObj.commonAddRow(); });
			} else {
				if (options.showDelItems) {
					$('<a href="javascripts:void(0)">删除</a>').prependTo($(options.toolbar)).linkbutton({ iconCls: 'icon-cancel', plain: true }).click(function() { gridObj.commonDeleteRow(); });
				}
				if (options.showAddItems) {
					$('<a href="javascripts:void(0)">新增</a>').prependTo($(options.toolbar)).linkbutton({ iconCls: 'icon-add', plain: true }).click(function() { gridObj.commonAddRow(); });
				}
			}
			if (options.showBar) {
				$('<a href="javascripts:void(0)">列设置</a>').appendTo($(options.toolbar)).linkbutton({ iconCls: 'icon-set-col', plain: true }).click(function() { GridColSet(gridObj); });
				$('<a href="javascripts:void(0)">导出当前页</a>').appendTo($(options.toolbar)).linkbutton({ iconCls: 'icon-export-data', plain: true }).click(function() { gridObj.exportExcel(); });
				$('<a href="javascripts:void(0)">导出所有</a>').appendTo($(options.toolbar)).linkbutton({ iconCls: 'icon-export-all', plain: true }).click(function() { gridObj.exportAll(); });
			}
		}
		
		if (options) {
			_options = jQuery.extend(true, _options, options);
		}
		var ParamsObj = {};
		if (typeof _options.queryParams.Params !== 'undefined') {
			ParamsObj = JSON.parse(_options.queryParams.Params);
		}
		_options.queryParams.Params = jQuery.extend(true, ParamsObj, sessionObj);
		_options.queryParams.Params = JSON.stringify(_options.queryParams.Params);
		var gridObj = $HUI.datagrid(id, _options);
		// /公共方法
		gridObj.editIndex = undefined;
		// /是否可以end一行的编辑状态
		gridObj.checked = true;
		// /colSort 回车跳转顺序
		gridObj.colSort = null;
		// 增加某些列的editor,例子PurGrid.addEditor({field:'RpAmt',editor:{type:'numberbox',options:{required:true}}})
		gridObj.addEditor = function(param) {
			if (param instanceof Array) {
				$.each(param, function(index, item) {
					var e = $(id).datagrid('getColumnOption', item.field);
					e.editor = item.editor;
				});
			} else {
				var e = $(id).datagrid('getColumnOption', param.field);
				e.editor = param.editor;
			}
		};
		// 删除某些列的editor，例子PurGrid.removeEditor('Rp')
		gridObj.removeEditor = function(param) {
			if (param instanceof Array) {
				$.each(param, function(index, item) {
					var e = $(id).datagrid('getColumnOption', item);
					e.editor = {};
				});
			} else {
				var e = $(id).datagrid('getColumnOption', param);
				e.editor = {};
			}
		};
		// 刷新一行并恢复编辑状态
		gridObj.refreshRow = function() {
			if (this.editIndex == undefined) {
				return true;
			}
			$(id).datagrid('endEdit', this.editIndex).datagrid('refreshRow', this.editIndex).datagrid('selectRow', this.editIndex).datagrid('beginEdit', this.editIndex);
			gridObj.enter();
			if (!isEmpty(gridObj.FocusField)) {
				var editor = gridObj.getEditor({ index: gridObj.editIndex, field: gridObj.FocusField });
				$(editor.target).focus();
				$(editor.target).next().children().focus();
			}
			return true;
		};
		gridObj.EditorSetValue = function(field, value) {
			var editor = gridObj.getEditor({ index: gridObj.editIndex, field: field });
			var row = gridObj.getRows()[gridObj.editIndex];
			if (editor.type == 'combobox') {
				editor.target.combobox('setValue', value);
			} else if (editor.type == 'numberbox') {
				editor.target.numberbox('setValue', value);
			} else if (editor.type == 'datebox') {
				editor.target.datebox('setValue', value);
			} else if (editor.type == 'datetimebox') {
				editor.target.datetimebox('setValue', value);
			} else if (editor.type == 'combotree') {
				editor.target.combotree('setValue', value);
			} else if (editor.type == 'textbox') {
				editor.target.textbox('setValue', value);
			} else if (editor.type == 'text') {
				$(editor.target).val(value);
			}
			row[editor.field] = value;
		};
		// 判断grid是否编辑完成
		gridObj.endEditing = function(newEditIndex) {
			if (this.editIndex == undefined) { return true; }
			var ed = gridObj.getEditors(this.editIndex);
			if (ed.length === 0) { return true; }
			if (newEditIndex == this.editIndex) { return true; }
			
			var len = this.getRows().length;
			if (this.editIndex > len) { return true; }	// 处理前一页的editindex大于当前页的行数问题
			
			gridObj.checked = true;		// endEdit之前设置为true, onEndEdit中会根据情况进行赋值
			gridObj.endEdit(this.editIndex);
			var checkField = this.jdata.options.checkField;
			
			var CheckFieldValue;
			if (!isEmpty(checkField)) {
				var EditRow = this.getRows()[this.editIndex];
				if (!isEmpty(EditRow)) {
					CheckFieldValue = EditRow[checkField];
				}
				if (isEmpty(CheckFieldValue)) {
					var ed = gridObj.getEditor({ index: this.editIndex, field: checkField });
					if (!isEmpty(ed)) {
						CheckFieldValue = ed.target.val();
					}
				}
			}
			
			if (!isEmpty(checkField) && isEmpty(CheckFieldValue)) {
				// 设置checkField,且该字段值为空的,直接删除此行
				this.deleteRow(this.editIndex);
				this.editIndex = undefined;
				return true;
			} else if (gridObj.validateRow(this.editIndex)) {
				if (this.checked) {
					this.editIndex = undefined;
					return true;
				} else {
					gridObj.beginEdit(this.editIndex);
					return false;
				}
			} else {
				// var NowIndex=this.editIndex+1;
				// $UI.msg('alert',"第"+NowIndex+"行存在必填项未填写(有红色三角形警示的列)!");
				return false;
			}
		};
		gridObj.commonClickCell = function(index, field, value) {
			if (this.endEditing(index)) {
				this.editIndex = index;
				if (!gridObj.checkboxModle()) {
					gridObj.selectRow(index);	// 有checkbox的,通过checkOnSelect控制选择与否
				}
				gridObj.editCell({ index: index, field: field });
				// gridObj.beginEdit(index);
				gridObj.FocusField = field;
				if (field != '') {
					var ed = gridObj.getEditor({ index: index, field: field });
					if (ed != null) {
						$(ed.target).focus();
						$(ed.target).next().children().focus();
					}
				}
				gridObj.enter();
			}
		};
		// 编辑行事件
		gridObj.commonClickRow = function(index) {
			if (this.endEditing(index)) {
				this.editIndex = index;
				if (!gridObj.checkboxModle()) {
					gridObj.selectRow(index);	// 有checkbox的,通过checkOnSelect控制选择与否
				}
				gridObj.beginEdit(index);
				gridObj.enter();
			} else {
				gridObj.selectRow(this.editIndex);
			}
		};
		
		// 公用插入一行的方法
		gridObj.commonAddRow = function(rowObj) {
			if (jQuery.isFunction(gridObj.jdata.options.beforeAddFn)) {
				var beforeAddrowObj = gridObj.jdata.options.beforeAddFn();
				if (beforeAddrowObj === false) {
					return;
				}
			}
			if (this.endEditing()) {
				var row = $.extend({}, beforeAddrowObj, rowObj);
				// var EditRowIndex = 0;
				// 改为追加
				// gridObj.insertRow({index:EditRowIndex, row:row})
				gridObj.appendRow(row);
				var EditRowIndex = gridObj.getRows().length - 1;
				gridObj.beginEdit(EditRowIndex);
				gridObj.clearSelections();
				gridObj.selectRow(EditRowIndex);
				
				var FirstFocusField = gridObj.getFirstFocusField();
				if (!isEmpty(FirstFocusField)) {
					var ed = gridObj.getEditor({ index: EditRowIndex, field: FirstFocusField });
					if (isEmpty(ed)) {
						return;
					}
					$(ed.target).focus();
					$(ed.target).next().children().focus();
					gridObj.FocusField = FirstFocusField;
					this.editIndex = EditRowIndex;
				}
				gridObj.enter();
			}
			if (jQuery.isFunction(gridObj.jdata.options.afterAddFn)) {
				var afterAddFnObj = gridObj.jdata.options.afterAddFn();
				if (afterAddFnObj === false) {
					return;
				}
			}
		};
		gridObj.enter = function() {
			var ed = gridObj.getEditors(this.editIndex);
			for (var i = 0, Len = ed.length; i < Len; i++) {
				var e = ed[i];
				$(e.target).bind('keydown', function() {
					if (window.event.keyCode == 13) {
						var Field = $(this).parents('td[field]').attr('field');
						// keydown中记录当前跳转格子,在keyup事件中按此值进行控制
						if (gridObj.JumpGridField !== false) {
							gridObj.JumpGridField = Field;
						}
					}
				}).bind('keyup', function(ev) {
					if (window.event.keyCode == 13) {
						var Field = $(this).parents('td[field]').attr('field');
						// 回车响应事件
						var funWhileJump = gridObj.getColumnOption(Field)['funWhileJump'];
						if (!isEmpty(funWhileJump)) {
							funWhileJump($(this));
						}
						// jump属性为false时,回车不进行跳转,需自行在column定义中维护
						var JumpFlag = gridObj.getColumnOption(Field)['jump'];
						// JumpGridField为false时,设不进行重新赋值(后续不进行跳转)
						if (gridObj.JumpGridField === Field && JumpFlag !== false) {
							gridObj.startEditingNext(Field);
						}
						gridObj.JumpGridField = null;
					}
				});
				$(e.target).next().children().bind('keydown', function(ev) {
					if (window.event.keyCode == 13) {
						gridObj.keydownFlag = true;			// 中文输入法,IE触发不了keydown, 通过此属性控制keyup是否执行
						var EditorObj = $(this).parent().prev();
						if (EditorObj.hasClass('combogrid-f')) {
							gridObj.JumpGridField = null;
							// combogrid时,优先检测是否配置了回车函数
							try {
								var EnterFun = EditorObj.combogrid('options')['EnterFun'];
								if (!isEmpty(EnterFun)) {
									var q = $(this).val();
									EnterFun(q, EditorObj);
									return;
								}
							} catch (e) {}
						} else {
							var Field = $(this).parents('td[field]').attr('field');
							gridObj.JumpGridField = Field;
						}
					}
				}).bind('keyup', function(ev) {
					if (window.event.keyCode == 13) {
						if (gridObj.keydownFlag !== true) {
							return;
						}
						gridObj.keydownFlag = false;
						var Field = $(this).parents('td[field]').attr('field');
						var JumpFlag = gridObj.getColumnOption(Field)['jump'];
						if (gridObj.JumpGridField === Field && JumpFlag !== false) {
							gridObj.startEditingNext(Field);
						}
						gridObj.JumpGridField = null;
					}
				});
			}
		};
		// 停止回车跳转的方法,结合enter中用到的方法来实现
		gridObj.stopJump = function(target) {
			gridObj.JumpGridField = false;
		};
		// 公用编辑下一editor方法. Field为空时,编辑第1个.
		gridObj.startEditingNext = function(Field) {
			var NextField = gridObj.getNextFocusField(Field);
			if (isEmpty(NextField)) {
				gridObj.commonAddRow();
			} else {
				var editor = gridObj.getEditor({ index: gridObj.editIndex, field: NextField });
				$(editor.target).focus();
				$(editor.target).select();
				$(editor.target).next().children().focus();
				$(editor.target).next().children().select();
				gridObj.FocusField = NextField;
			}
		};
		// 公用删除行的方法(复制编辑行，删除编辑行，删除其他行，新增行赋值编辑行内容)
		gridObj.commonDeleteRow = function(ConfirmFlag, SelIndex) {
			// gridObj.endEditing();
			if (jQuery.isFunction(gridObj.jdata.options.beforeDelFn)) {
				var beforeDel = gridObj.jdata.options.beforeDelFn();
				if (beforeDel === false) {
					return;
				}
			}
			var arrData = []; // 处理后的数据
			var rowsData = [];
			if (!isEmpty(SelIndex)) {
				var row = gridObj.getRows()[SelIndex];
				rowsData.push(row);
			} else if (gridObj.checkboxModle()) {
				rowsData = gridObj.getChecked();
			} else {
				rowsData = gridObj.getSelections();
				var len = rowsData.length;
				if (len <= 0) {
					// /没有selections时候 看看cell
					var cell = gridObj.cell();
					if (cell) {
						var row = gridObj.getRows()[cell.index];
						rowsData.push(row);
					}
				}
			}
			var len = rowsData.length;
			if (len <= 0) {
				$UI.msg('alert', '请选择要删除的行!');
				return;
			}
			
			// 对于处于编辑状态的行,且不再删除范围内的, 需先删除,再insert(否则会有报错)
			var edrow = '';
			var ifDefAdd = false; // 删除后是否需要重新增加行(行为空或已选择时为false)
			if (!isEmpty(gridObj.editIndex)) {
				edrow = gridObj.getRows()[gridObj.editIndex];
				// 编辑行,不在选择删除的数据内,才进行特殊处理
				if ($.hisui.indexOfArray(rowsData, edrow) == -1) {
					var edField = gridObj.FocusField;
					edrow = gridObj.getRows()[gridObj.editIndex];
					var edRowId = edrow['RowId'];
					var ed = gridObj.getEditor({ index: gridObj.editIndex, field: edField });
					var edval = ed.target.val();
					if (isEmpty(edRowId)) {
						// 判断是否空行
						if (edval != '') { ifDefAdd = true; } else {
							var fields = gridObj.getColumnFields();
							for (var i = 0; i < fields.length; i++) {
								var value = edrow[fields[i]];
								if (!isEmpty(value)) { ifDefAdd = true; }
							}
						}
						edrow[edField] = edval;
						
						gridObj.deleteRow(gridObj.editIndex);
						gridObj.editIndex = undefined;
					}
				}
			}
			
			// 删除没有rowid的, 并组织需要后台删除的部分
			for (var i = len - 1; i >= 0; i--) {
				var row = rowsData[i];
				var index = gridObj.getRowIndex(row);
				if (isEmpty(row.RowId)) {
					gridObj.deleteRow(index);
				} else {
					arrData.unshift(row);
				}
			}
			if (arrData.length <= 0) {
				gridObj.editIndex = undefined;	// 删除后清除编辑行数
				$UI.msg('success', '删除成功!');
				InsertEditRow();
			} else {
				if (options.deleteRowParams && !isEmpty(options.deleteRowParams.ClassName) && !isEmpty(options.deleteRowParams.MethodName)) {
					if (ConfirmFlag !== false) {
						$UI.confirm('确定要删除选中行吗?', '', '', deleterows);
					} else {
						deleterows();
					}
				} else {
					$UI.msg('alert', '该模块数据一经维护,不允许删除!');
				}
				
				function deleterows() {
					$.cm({
						ClassName: options.deleteRowParams.ClassName,
						MethodName: options.deleteRowParams.MethodName,
						Params: JSON.stringify(arrData)
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							for (var i = len - 1; i >= 0; i--) {
								var row = rowsData[i];
								if (row.RowId) {
									var index = gridObj.getRowIndex(row);
									gridObj.deleteRow(index);
								}
							}
							gridObj.editIndex = undefined;		// 删除后清除编辑行数
							gridObj.reload();
							InsertEditRow();
						} else {
							$UI.msg('error', jsonData.msg);
						}
						
						if (jQuery.isFunction(gridObj.jdata.options.afterDelFn)) {
							var afterDelFnObj = gridObj.jdata.options.afterDelFn();
							if (afterDelFnObj === false) {
								return;
							}
						}
					});
				}
			}
			
			// 将删除前处于编辑状态的行,重新插入
			function InsertEditRow() {
				if (ifDefAdd && edrow) {
					var EditRowIndex = gridObj.getRows().length;
					gridObj.insertRow({
						index: EditRowIndex,
						row: edrow
					});
				}
			}
		};
		gridObj.exportExcel = function() {
			showMask();
			var data = gridObj.getRows();
			data = data || [];
			var cm = gridObj.jdata.options.frozenColumns[0].concat(gridObj.jdata.options.columns[0]);
			if (data.length == 0) {
				$UI.msg('alert', '没有数据需要导出!');
				hideMask();
				return false;
			}
			var op = gridObj.jdata.options.queryParams;
			var totalFieldsStr = op.totalFields;
			var totalFooterStr = op.totalFooter;
			var SumArr = '';
			if (!isEmpty(totalFieldsStr) && !isEmpty(totalFooterStr)) {
				SumArr = [{}];
				var FooterArr = totalFooterStr.split(':');
				var FooterTitleArr = FooterArr[0].split('"');
				var FooterListArr = FooterArr[1].split('"');
				SumArr[0][FooterTitleArr[1]] = FooterListArr[1];
				var FieldsArr = totalFieldsStr.split(',');
				for (var j = 0, Len = FieldsArr.length; j < Len; j++) {
					SumArr[0][FieldsArr[j]] = 0;
				}
				for (var i = 0; i < data.length; i++) {
					for (var j = 0, Len = FieldsArr.length; j < Len; j++) {
						var FieldTitle = FieldsArr[j];
						eval("SumArr[0]['" + FieldTitle + "'] = accAdd(Number(SumArr[0]['" + FieldTitle + "']), Number(data[i]['" + FieldTitle + "']))");
					}
				}
			}
			ExportExcel(data, cm, SumArr);
			hideMask();
		};
		gridObj.exportAll = function() {
			showMask();
			var data = gridObj.getRows();
			if (data.length == 0) {
				$UI.msg('alert', '没有数据需要导出!');
				hideMask();
				return false;
			}
			var op = gridObj.jdata.options.queryParams;
			var cm = gridObj.jdata.options.frozenColumns[0].concat(gridObj.jdata.options.columns[0]);
			// /重置参数
			op.page = 1;
			op.rows = 9999999;
			$.cm(op, function(data) {
				if (!data.rows || data.rows.length == 0) {
					$UI.msg('alert', '没有数据需要导出!');
					hideMask();
					return false;
				}
				ExportExcel(data.rows, cm, data.footer);
				hideMask();
			});
		};
		
		// 获取第一个编辑的field
		gridObj.getFirstFocusField = function() {
			var colSort = gridObj.jdata.options['colSort'] || columns[0];
			$.each(colSort, function(index, value) {
				if (isEmpty(gridObj.firstFocusField) && !isEmpty(value.editor) && value.hidden !== true) {
					gridObj.firstFocusField = value.field;
					return false;
				}
			});
			return gridObj.firstFocusField;
		};
		// 获取下一个编辑的field. 入参为空时,获取第一个可编辑field.
		gridObj.getNextFocusField = function(Field) {
			if (isEmpty(Field)) {
				return gridObj.getFirstFocusField();
			}
			
			var pField = '', nField = '';
			var colSort = gridObj.jdata.options['colSort'] || columns[0];
			$.each(colSort, function(index, value) {
				if (value.hidden !== true && !isEmpty(value.editor)) {
					if (!isEmpty(value.editor.options) && (value.editor.options.disabled || value.editor.options.editable === false)) {
						return true;
					}
					if (Field == pField) {
						nField = value.field;
						return false;
					}
					pField = value.field;
				}
			});
			return nField;
		};
		// 获取datagrid数据
		// 添加key
		gridObj.getChangesData = function(key) {
			if (this.getRows().length == 0) {
				return false;
			}
			if (!isEmpty(key)) {
				if (this.editIndex != undefined) {
					if ((this.editIndex + 1) > this.getRows().length) {
						this.editIndex = undefined;
						return false;
					}
					if ((isEmpty(this.getRows()[this.editIndex][key])) && (this.getRows().length == 1)) {
						return false;
					}
					if (!isEmpty(this.getRows()[this.editIndex][key])) {
						if (!this.endEditing()) {
							return false;
						}
					}
				}
			} else {
				if (!this.endEditing()) {
					return false;
				}
			}
			
			if (this.CheckDataNecessary() === false) {
				return false;
			}
			
			var inserted = gridObj.getChanges('inserted');
			var updated = gridObj.getChanges('updated');
			var rowsData = [];
			rowsData = rowsData.concat(updated);
			rowsData = rowsData.concat(inserted);
			rowsData = DeepClone(rowsData);
			var arrData = FormatGridData(rowsData, key);
			this.editIndex = undefined;		// 这句??
			return arrData;
		};
		// 获取datagrid数据所有
		gridObj.getRowsData = function() {
			if (!this.endEditing()) {
				return false;
			}
			var rowsData = gridObj.getRows();
			var arrData = FormatGridData(rowsData);
			return arrData;
		};
		gridObj.getSelectedData = function() {
			if (!this.endEditing()) {
				return false;
			}
			var rowsData = [];
			if (gridObj.checkboxModle()) {
				rowsData = gridObj.getChecked();
			} else {
				rowsData = gridObj.getSelections();
			}
			var arrData = FormatGridData(rowsData);
			return arrData;
		};
		
		function FormatGridData(rowsData, key) {
			var arrData = [];
			if (rowsData.length == 0) {
				return arrData;
			}
			
			var saveColArr = [];		// 记录保存需要的字段
			var AliasObj = {};			// 记录alias字段的object, {field: alias, ...}
			for (var col = 0, Len = columns[0].length; col < Len; col++) {
				if (columns[0][col].saveCol === true) {
					saveColArr[saveColArr.length] = columns[0][col].field;
				}
				var colField = columns[0][col].field;
				var colAlias = columns[0][col].alias;
				if (!isEmpty(colAlias)) {
					AliasObj[colField] = colAlias;
				}
			}
			
			for (var i = 0; i < rowsData.length; i++) {
				var row = rowsData[i];
				if (!isEmpty(saveColArr)) {
					// 按需要的字段, 简化下row的数据
					for (var rowKey in row) {
						if (saveColArr.indexOf(rowKey) == -1) {
							delete row[rowKey];
						}
					}
				}
				
				// 这里直接将row中的alias处理一下
				for (var ColField in row) {
					var ColAlias = AliasObj[ColField];
					if (!isEmpty(ColAlias)) {
						row[ColAlias] = row[ColField];
					}
				}
				
				if (!isEmpty(key) && isEmpty(row[key])) {
					continue;
				}
				arrData.unshift(row);
			}
			return arrData;
		}
		
		// 重新加载并取消选中
		gridObj.commonReload = function() {
			gridObj.clearSelections();
			gridObj.reload();
		};
		// 代替 ext的findExact   find
		gridObj.find = function(field, value) {
			var index = -1;
			var rowsData = gridObj.getRows();
			for (var i = 0; i < rowsData.length; i++) {
				var row = rowsData[i];
				if (row[field] == value) {
					index = i;
					return index;
				}
			}
			return index;
		};
		gridObj.checkboxModle = function() {
			var len = columns[0].length;
			for (var i = 0; i < len; i++) {
				var ck = columns[0][i].checkbox;
				if (ck) {
					return true;
				}
			}
			return false;
		};
		/*
		 * 根据necessary属性,检查是否有必填列为空
		 */
		gridObj.CheckDataNecessary = function(key) {
			key = key || this.jdata.options.checkField;
			
			var CheckField = [];
			var opt = gridObj.options();
			for (var i = 0; i < opt.columns[0].length; i++) {
				if (opt.columns[0][i].necessary === true) {
					CheckField.push(opt.columns[0][i].field + '^' + opt.columns[0][i].title);
				}
			}
			
			gridObj.endEditing();
			var Rows = gridObj.getRows();
			var CheckFlag = true, MsgArr = [];
			for (var i = 0, len = Rows.length; i < len; i++) {
				var Msg = '';
				var Record = Rows[i];
				for (var j = 0; j < CheckField.length; j++) {
					var CheckData = CheckField[j].split('^');
					var ColField = CheckData[0], ColTitle = CheckData[1];
					var val = Record[ColField];
					if (!isEmpty(key)) {
						var keydata = Record[key];
						if (isEmpty(val) && !isEmpty(keydata)) {
							Msg = Msg + ColTitle + '不能为空 ';
							CheckFlag = false;
						}
					} else {
						if (isEmpty(val)) {
							Msg = Msg + ColTitle + '不能为空 ';
							CheckFlag = false;
						}
					}
				}
				
				if (!isEmpty(Msg)) {
					MsgArr.push('第' + (i + 1) + '行' + Msg + '!');
				}
			}
			if (!isEmpty(MsgArr)) {
				$UI.msg('alert', MsgArr.join(' '));
			}
			return CheckFlag;
		};
		gridObj.setFooterInfo = function() {
			var op = gridObj.jdata.options.queryParams;
			var totalFieldsStr = op.totalFields;
			if (totalFieldsStr == null) {
				return false;
			}
			var rows = gridObj.getRows();
			var SumArr = [{}];
			var FieldsArr = totalFieldsStr.split(',');
			for (var j = 0, Len = FieldsArr.length; j < Len; j++) {
				SumArr[0][FieldsArr[j]] = 0;
			}
			var totalFooterStr = op.totalFooter;
			if (totalFooterStr != null) {
				var FooterArr = totalFooterStr.split(':');
				var FooterTitleArr = FooterArr[0].split('"');
				var FooterListArr = FooterArr[1].split('"');
				SumArr[0][FooterTitleArr[1]] = FooterListArr[1];
			}
			for (var i = 0; i < rows.length; i++) {
				for (var j = 0, Len = FieldsArr.length; j < Len; j++) {
					var FieldTitle = FieldsArr[j];
					eval("SumArr[0]['" + FieldTitle + "'] = accAdd(Number(SumArr[0]['" + FieldTitle + "']), Number(rows[i]['" + FieldTitle + "']))");
				}
			}
			gridObj.reloadFooter(SumArr);
		};
		
		/*
		*处理cm,添加公共属性
		*/
		function setcolumns(cm, id, _columns, _frozenCol, options) {
			var _cm = $.extend(true, [], cm);
			var op = {
				// halign:"center",
				// sortable:true,
				resizable: true
			};
			// //不显示列设置  不生成数数据
			if (options.showBar) {
				var MainObj = {
					AppName: 'DHCSTCOMMONM',
					CspName: App_MenuCspName,
					GridId: id
				};
				var Main = JSON.stringify(addSessionParams(MainObj));
				var SaveModInfo = $.m({
					ClassName: 'web.DHCSTMHUI.StkSysGridSet',
					MethodName: 'JsGetSaveMod',
					Main: Main
				}, false);
				if (SaveModInfo != '') {
					var MainStr = JSON.stringify(addSessionParams(MainObj));
					var colsetcm = DeepClone(cm);
					for (var i = 0, Len = colsetcm[0].length; i < Len; i++) {
						var ColObj = colsetcm[0][i];
						delete ColObj.editor;
					}
					var Detail = JSON.stringify(colsetcm[0].reverse());
					// cm[0].reverse();
					var newcm = $.cm({
						ClassName: 'web.DHCSTMHUI.StkSysGridSet',
						MethodName: 'Query',
						Main: MainStr,
						Detail: Detail
					}, false);
					if (!isEmpty(newcm) && newcm.length > 0) {
						// 有返回值按返回值
						var len = newcm.length;
						for (var i = 0; i < len; i++) {
							var field = newcm[i].field;
							var _cmobj = FindCmObj(_cm[0], field);
							var cmobj = jQuery.extend(true, _cmobj, op, newcm[i], { halign: newcm[i].align });
							if (cmobj.frozen == 'true') {
								_frozenCol[0].push(cmobj);
							} else {
								_columns[0].push(cmobj);
							}
						}
						
						// 初始化colSort
						var SortColumns = [].concat(_columns[0]);
						var Len = SortColumns.length;
						for (var i = Len - 1; i >= 0; i--) {
							var Column = SortColumns[i];
							var EnterSortNum = Number(Column['enterSort']);
							if (EnterSortNum <= 0) {
								SortColumns.splice(i, 1);
							} else {
								Column['enterSort'] = EnterSortNum;
							}
						}
						if (SortColumns.length > 0) {
							var Sort = function(array) {
								var d;
								for (var i = 0, len = array.length; i < len; i++) {
									for (j = 0; j < len; j++) {
										if (array[i].enterSort - array[j].enterSort < 0) {
											d = array[j];
											array[j] = array[i];
											array[i] = d;
										}
									}
								}
								return array;
							};
							options['colSort'] = Sort(SortColumns);
						}
					}
				}
			}
			
			if (_columns[0].length == 0) {
				var len = cm[0].length;
				for (var i = 0; i < len; i++) {
					// _columns[0].push(jQuery.extend(true,cm[0][i],op,{halign:cm[0][i].align}));
					var field = cm[0][i].field;
					var _cmobj = FindCmObj(_cm[0], field);
					if (_cmobj.checkbox == true) {
						_cmobj.frozen = true;
						cm[0][i].frozen = true;
					}
					if (_cmobj.frozen == true) {
						_frozenCol[0].push(jQuery.extend(true, cm[0][i], op, { halign: cm[0][i].align }));
					} else {
						_columns[0].push(jQuery.extend(true, cm[0][i], op, { halign: cm[0][i].align }));
					}
				}
			}
			return;
		}
		
		return gridObj;
	};
	
	/**
	 * 构造树组件
	 * @param obj dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param options 扩展选项（可选）
	 */
	this.tree = function(obj, url, data, onClick, onDblClick, checkbox, onlyLeafCheck, options) {
		if (obj) {
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				dnd: false, 		// 不能拖动
				cascadeCheck: true, // checkbox选择时联动
				lines: true 		// 导航虚线
			};
			if (url) {
				jQuery.extend(_options, { 'url': url });
			}
			if (null != data) {
				if ('string' === typeof (data) && data) {
					jQuery.extend(_options, { 'data': jQuery.parseJSON(data) });
				} else if ('object' === typeof (data) && data) {
					jQuery.extend(_options, { 'data': data });
				}
			}
			if (onClick) {
				jQuery.extend(_options, { 'onClick': onClick });
			}
			if (onDblClick) {
				jQuery.extend(_options, { 'onDblClick': onDblClick });
			}
			if (null != checkbox) {
				jQuery.extend(_options, { 'checkbox': checkbox });
			}
			if (null != onlyLeafCheck) {
				jQuery.extend(_options, { 'onlyLeafCheck': onlyLeafCheck });
			}
			options && jQuery.extend(_options, options);
			jqobj.tree(_options);
		}
	};

	/**
	 * 遍历区块数据组装成JSON字符串
	 * @param container dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param skipNames 跳过的name数组
	 * @param skipHidden 是否跳过HTML标准组件里的hidden字段
	 * @param skipDisabled 是否跳过disable字段
	 */
	this.loopBlock = function(container, skipNames, skipHidden, skipDisabled) {
		var attrs = {}; // 返回的对象
		var gettedNames = []; // 需跳过的组件名数组
		if (!skipNames) {
			skipNames = []; // 需跳过的name
		}
		var target = jQuery(document);
		if (container) {
			target = getJqueryDomElement(container);
		}
		// combo&datebox
		var cbxCls = ['combobox', 'combotree', 'combogrid', 'datetimebox', 'datebox', 'combo'];
		var ipts = jQuery('[comboName]', target);
		if (ipts.length) {
			ipts.each(function() {
				for (var i = 0; i < cbxCls.length; i++) {
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboName');
					if (jQuery(this).hasClass(type + '-f')) {
						var options = jQuery(this)[type]('options');
						if (skipDisabled && options['disabled']) {
							return true;
						}
						if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
							return true;
						}
						if (options['multiple']) {
							var val = jQuery(this)[type]('getValues');
							var separator = options['separator'];
							if (!isEmpty(separator)) {
								val = val.join(separator);
							}
							extendJSON(name, val);
						} else {
							var val = jQuery(this)[type]('getValue');
							// if(type=='datebox'){
							// val=formatDate(val)
							// }
							extendJSON(name, val);
						}
						break;
					}
				}
			});
		}
		// radio&checkbox
		var ipts = jQuery('input[name][type=radio], input[name][type=checkbox]', target);
		if (skipDisabled) ipts = ipts.not(':disabled');
		if (skipHidden) ipts = ipts.not(':hidden');
		if (ipts.length) {
			var iptsNames = [];
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
					return true;
				}
				if (name != '' && name != null && -1 === jQuery.inArray(name, iptsNames)) {
					iptsNames.push(name);
				}
			});
			for (var i = 0; i < iptsNames.length; i++) {
				var iptsFlts = ipts.filter('[name=' + iptsNames[i] + ']');
				var type = iptsFlts.eq(0).attr('type');
				if (type === 'radio') {
					iptsFlts.each(function() {
						if (jQuery(this).prop('checked')) {
							extendJSON(iptsNames[i], jQuery(this).val());
							return false;
						}
					});
				} else if (type === 'checkbox') {
					var vals = [];
					iptsFlts.each(function() {
						if (jQuery(this).prop('checked')) {
							vals.push(jQuery(this).val());
							// 2018-4-28
							// vals.push('Y')
						}
					});
					// /2018-4-27  直接值传入
					if (vals.length == 1) {
						vals = vals[0];
					} else if (vals.length < 1) {
						vals = '';
					}
					extendJSON(iptsNames[i], vals);
				}
			}
		}
		// numberbox&slider
		var cTypes = ['numberbox', 'slider'];
		for (var i = 0; i < cTypes.length; i++) {
			ipts = jQuery('input[' + cTypes[i] + 'name]', target);
			if (skipDisabled) ipts = ipts.not(':disabled');
			if (ipts.length) {
				ipts.each(function() {
					var name = jQuery(this).attr(cTypes[i] + 'Name');
					if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
						return true;
					}
					var val = jQuery(this)[cTypes[i]]('getValue');
					extendJSON(name, val);
				});
			}
		}
		// multiselect2side
		ipts = jQuery('.multiselect2side', target);
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (skipDisabled && $(this).next('.ms2side__div').find(':disabled').length) {
					return true;
				}
				if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this)['multiselect2side']('getValue');
				extendJSON(name, val);
			});
		}
		// select
		ipts = jQuery('select[name]', target);
		if (skipDisabled) ipts = ipts.not(':disabled');
		if (skipHidden) ipts = ipts.not(':hidden');
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this).val();
				extendJSON(name, val);
			});
		}
		// lookup
		ipts = jQuery('.lookup', target);
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (jQuery(this).lookup('options')['valueType'] === 'text') {
					var RowId = jQuery(this).lookup('getValue');
					var val = jQuery(this).lookup('getText');
					if (!isEmpty(RowId)) {
						val = '';
					}
				} else {
					var Text = jQuery(this).lookup('getText');
					var val = jQuery(this).lookup('getValue');
					if (isEmpty(Text)) {
						val = '';
					}
				}
				extendJSON(name, val);
			});
		}
		
		// keywords
		ipts = jQuery('ul.keywords', target);
		if (ipts.length) {
			ipts.each(function() {
				var KeyWordsObj = $(this).parent()[0];
				var name = $(KeyWordsObj).attr('name');
				var KeyWordsSelected = $HUI.keywords(KeyWordsObj).getSelected();
				var valArr = [];
				$.each(KeyWordsSelected, function(k, v) {
					valArr.push(v['id']);
				});
				var val = valArr.join(',');
				extendJSON(name, val);
			});
		}
		// validatebox&input
		ipts = jQuery('input[name]', target);
		if (skipDisabled) ipts = ipts.not(':disabled');
		if (skipHidden) ipts = ipts.not(':hidden');
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this).val();
				extendJSON(name, val);
			});
		}
		// textarea
		ipts = jQuery('textarea[name]', target);
		if (skipDisabled) ipts = ipts.not(':disabled');
		if (skipHidden) ipts = ipts.not(':hidden');
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
					return true;
				}
				var val = jQuery(this).val();
				// 返回取备注类型字段时，备注行之间的设定分隔符$c(3)  area单独处理 
				val = val.replace(/\r/g, '').replace(/\n/g, xMemoDelim());
				extendJSON(name, val);
			});
		}
		// function
		function extendJSON(name, val) {
			if (!name) return;
			if (-1 !== $.inArray(name, gettedNames)) {
				// 只获取第一个name的值
				return;
			} else {
				gettedNames.push(name);
			}
			val = 'undefined' !== typeof (val) ? val : '';
			var newObj = eval('({"' + name + '":' + jQuery.toJSON(val) + '})');
			jQuery.extend(attrs, newObj, sessionObj);
		}
		return attrs;
	};
	
	/**
	 * 通过JSON设置区块数据
	 * @param container dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param data json字符串或JSON对象
	 */
	this.fillBlock = function(container, data) {
		var json = data;
		if ('string' === typeof (data)) json = $.parseJSON(data);
		if (!json) return;
		var target = $(document);
		if (container) {
			target = getJqueryDomElement(container);
		}
		// 遍历并加载数据
		loopJSON(json);
		// 填充后的Json
		FormBlockJson[container] = this.loopBlock(container);
		function loopJSON(json) {
			if (!json) return;
			$.each(json, function(i, d) {
				if (null !== d) {
					setNameVal(i, d);
				}
			});
		}
		
		// 触发Combo的onSelect事件
		function FireComboSelect(Combo, RowId) {
			var opts = $.data(Combo, 'combobox').options;
			var Record = opts.finder.getRow(Combo, RowId);
			if (isEmpty(Record)) {
				Record = { RowId: RowId };
			}
			opts.onSelect.call(Combo, Record);
		}
		
		function setNameVal(name, val) {
			name = 'undefined' !== typeof (name) ? '' + name : '';
			if ('' === name) return;
			val = 'undefined' !== typeof (val) ? val : '';
			
			// combobox combotree combogrid datetimebox datebox combo
			var cbxCls = ['combobox', 'combotree', 'combogrid', 'datetimebox', 'datebox', 'combo'];
			var ipts = $('[comboname="' + name + '"]', target);
			if (ipts.length) {
				for (var i = 0; i < cbxCls.length; i++) {
					var type = cbxCls[i];
					if (ipts.hasClass(type + '-f')) {
						if (ipts[type]('options').multiple) {
							if ($.type(val) === 'array') {
								ipts[type]('setValues', val);
							} else if ($.type(val) === 'object') {
								// 如果是combo, 则进行AddComboData
								if (!isEmpty(val.RowId)) {
									ipts[type]('setValue', val.RowId);
								}
								val = val.RowId;
							} else {
								ipts[type]('setValue', val);
							}
						} else {
							if (type == 'datebox') {
								if (isEmpty(val)) { return val; }
								val = FormatDate(val);
								val = $.fn.datebox.defaults.formatter(val);
							} else if (type == 'datetimebox' && $.isNumeric(val)) {
								var valDate = new Date(); valDate.setTime(val);
								val = $.fn.datebox.defaults.formatter(valDate);
							} else if (type == 'combobox' && $.type(val) === 'object') {
								// 如果是combo, 则进行AddComboData
								if (!isEmpty(val.RowId) || !isEmpty(val.Description)) {
									AddComboData(ipts, val.RowId, val.Description);
								}
								val = val.RowId;
							} else if (type == 'combotree' && $.type(val) === 'object') {
								// 这里应该需要封装,时间原因,暂不做处理2020-06-12
								val = val.RowId;
							}
							ipts[type]('setValue', val);
						}
						if (type == 'combobox') {
							ipts.each(function() {
								// combo定义onSelect的,且val非空时处理(故不建议将combo中数据集的值的id字段按空处理)
								if (!isEmpty(val) && $.data(this, 'combobox').options.onSelect.toString() != 'function(e){}') {
									FireComboSelect(this, val);
								}
							});
						}
						return;
					}
				}
			}
			// numberbox slider
			var cTypes = ['numberbox', 'slider'];
			var f;
			for (var i = 0; i < cTypes.length; i++) {
				f = $('input[' + cTypes[i] + 'name="' + name + '"]', target);
				if (f.length) {
					f.eq(0)[cTypes[i]]('setValue', val);
					return;
				}
			}
			// timespinner
			f = $('input[name="' + name + '"].timespinner-f', target);
			if (f && f.length) {
				f.eq(0)['timespinner']('setValue', val);
				return;
			}
			// radio checkbox
			var opts = $('input[name="' + name + '"][type=checkbox]', target);
			if (opts.length) {
				opts.prop('checked', false);
				opts.each(function() {
					var f = $(this);
					// if ('array'==$.type(val) && val && -1!==$.inArray(f.val(), val)
					// || f.val() == String(val)){
					if ((val == true) || ('string' == $.type(val) && val == 'Y')) {
						// f.prop('checked', true);
						$HUI.checkbox(this).setValue(true);
					} else {
						$HUI.checkbox(this).setValue(false);
					}
				});
				return;
			}
			// radio checkbox
			var opts = $('input[name="' + name + '"][type=radio]', target);
			if (opts.length) {
				opts.prop('checked', false);
				opts.each(function() {
					var f = $(this);
					if ('array' == $.type(val) && val && -1 !== $.inArray(f.val(), val)
					|| f.val() == String(val)) {
						// $HUI.radio('#'+f.val()).setValue(true);
						$HUI.radio(this).setValue(true);
					}
				});
				return;
			}
			// lookup
			f = $('input[name="' + name + '"].lookup', target);
			if (f && f.length) {
				if ($.type(val) === 'object') {
					f.eq(0)['lookup']('setValue', val['RowId']);
					f.eq(0)['lookup']('setText', val['Description']);
				} else {
					f.eq(0)['lookup']('setValue', val);
				}
				return;
			}
			// keywords
			f = $('a[name="' + name + '"]>.keywords', target);
			if (f && f.length) {
				if (!isEmpty(val)) {
					var KeyWordsObj = $(f).parent()[0];
					var valArr = val.split(',');
					$.each(valArr, function(k, v) {
						$HUI.keywords(KeyWordsObj).select(v);
					});
				}
				return;
			}
			// input
			f = $('input[name="' + name + '"]', target);
			if (f && f.length) {
				f.val(val);
				// 如果是validatebox, 进行validate处理
				if (f.hasClass('hisui-validatebox')) {
					f.validatebox('validate');
				}
				return;
			}
			// textarea
			f = $('textarea[name="' + name + '"]', target);
			if (f && f.length) {
				val = handleMemo(val, xMemoDelim());
				f.val(val);
				return;
			}
			// select
			f = $('select[name="' + name + '"]', target);
			if (f && f.length) {
				if (f.hasClass('multiselect2side')) {
					f['multiselect2side']('setValue', val);
				} else {
					f.val(val);
				}
				return;
			}
		}
	};
	this.isChangeBlock = function(container) {
		var eq = JSON.stringify(FormBlockJson[container]) === JSON.stringify(this.loopBlock(container));
		return !eq;
	};
	/**
	 * 遍历区块数据清空
	 * @param container dom对象，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @author XuChao
	 */
	this.clearBlock = function(container) {
		var skipNames = []; // input 选择清空时候  跳过 checkbox,radio
		var target = jQuery(document);
		if (container) {
			target = getJqueryDomElement(container);
		}
		var val = '';
		// combo&datebox
		var cbxCls = ['combobox', 'combotree', 'combogrid', 'datetimebox', 'datebox', 'combo'];
		var ipts = jQuery('[comboName]', target);
		if (ipts.length) {
			ipts.each(function() {
				for (var i = 0; i < cbxCls.length; i++) {
					var type = cbxCls[i];
					var name = jQuery(this).attr('comboName');
					if (jQuery(this).hasClass(type + '-f')) {
						if (jQuery(this)[type]('options').multiple) {
							jQuery(this)[type]('setValues', val);
						} else {
							jQuery(this)[type]('setValue', val);
						}
						break;
					}
				}
			});
		}
		// radio&checkbox
		var ipts = jQuery('input[name][type=radio], input[name][type=checkbox]', target);
		if (ipts.length) {
			var iptsNames = [];
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (name != '' && name != null && -1 === jQuery.inArray(name, iptsNames)) {
					iptsNames.push(name);
					skipNames.push(name);
				}
			});
			for (var i = 0; i < iptsNames.length; i++) {
				var iptsFlts = ipts.filter('[name=' + iptsNames[i] + ']');
				var type = iptsFlts.eq(0).attr('type');
				if (type === 'radio') {
					iptsFlts.each(function() {
						var RadioOptions = this.getAttribute('data-options');
						if (isEmpty(RadioOptions)) {
							return;
						}
						try {
							eval('var RadioOptionsObj = ({' + RadioOptions + '})');
							if (!isEmpty(RadioOptionsObj) && RadioOptionsObj['checked'] == true) {
								$HUI.radio(this).setValue(true);
							}
						} catch (e) {}
					});
				} else if (type === 'checkbox') {
					var vals = [];
					iptsFlts.each(function() {
						if (jQuery(this).prop('checked')) {
							// 通过HUI设置值
							$HUI.checkbox(this).setValue(false);
							// jQuery(this).prop('checked',false);
						}
					});
				}
			}
		}
		// numberbox&slider
		var cTypes = ['numberbox', 'slider'];
		for (var i = 0; i < cTypes.length; i++) {
			ipts = jQuery('input[' + cTypes[i] + 'name]', target);
			if (ipts.length) {
				ipts.each(function() {
					var name = jQuery(this).attr(cTypes[i] + 'Name');
					jQuery(this)[cTypes[i]]('setValue', '');
				});
			}
		}
		// multiselect2side
		ipts = jQuery('.multiselect2side', target);
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				jQuery(this)['multiselect2side']('setValue', '');
			});
		}
		ipts = jQuery('.lookup', target);
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				$HUI.lookup(this).setValue('');
			});
		}
		// keywords
		ipts = $('ul.keywords', target);
		if (ipts.length) {
			ipts.each(function() {
				var KeyWordsObj = $(this).parent()[0];
				$HUI.keywords(KeyWordsObj).clearAllSelected();
			});
		}
		// select
		ipts = jQuery('select[name]', target);
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				jQuery(this).val('');
			});
		}
		// validatebox&input&textarea
		ipts = jQuery('input[name], textarea[name]', target);
		if (ipts.length) {
			ipts.each(function() {
				var name = jQuery(this).attr('name');
				if (skipNames && -1 !== jQuery.inArray(name, skipNames)) {
					return true;
				}
				jQuery(this).val('');
			});
		}
	};
	/**
	 * 将表单设置为可用(或不可用)状态
	 * @param {} container
	 * @param {} bool
	 */
	this.enableBlock = function(container, bool) {
		$(container + ' :input').each(function() {
			// 不做授权的元素,约定给需授权的元素添加class(nopageauthor),不需要控制编辑状态
			if ($(this).hasClass('nopageauthor') || ($(this).attr('type') == 'hidden')) {
				return true;
			}
			// 通过页面元素授权,对于 权限==N 的, 执行addClass('pageauthorno'). 这里不再控制其状态.
			if ($(this).hasClass('pageauthorno')) {
				return true;
			}

			if (bool) {
				// enable
				try {
					$(this).removeAttr('disabled');
				} catch (e) {}
				
				try {
					$(this).combo('enable');
				} catch (e) {}
				
				try {
					$HUI.checkbox(this).enable();
				} catch (e) {}
			} else {
				// disable
				try {
					$(this).attr('disabled', 'disabled');
				} catch (e) {}
				
				try {
					$(this).combo('disable');
				} catch (e) {}
				
				try {
					$HUI.checkbox(this).disable();
				} catch (e) {}
			}
		});
	};
	
	/**
	 * 下拉列表
	 * @param obj dom元素，可以是：dom元素的id | jQuery选择器 | dom对象 | jQuery对象
	 * @param value 值（url|object）
	 * @param textField 显示值（可选，textField）
	 * @param valueField 保存值（可选，valueField）
	 * @param options 扩展选项（可选）
	 */
	this.combobox = function(obj, value, textField, valueField, options) {
		if (obj) {
			var jqobj = getJqueryDomElement(obj);
			var _options = {
				panelHeight: 'auto'
			};
			if (null != textField) {
				jQuery.extend(_options, { 'textField': textField });
			}
			if (null != valueField) {
				jQuery.extend(_options, { 'valueField': valueField });
			}
			options && jQuery.extend(_options, options);
			if ('object' === typeof (value)) {
				// data
				jQuery.extend(_options, { 'data': value, 'mode': 'local' });
			} else {
				// url
				jQuery.extend(_options, { 'url': value, 'mode': 'remote' });
			}
			jqobj.combobox(_options);
		}
	};

	/**
	 * 清空Grid
	 * @param obj 对象
	*/
	this.clear = function(obj) {
		if (obj) {
			obj.clearSelections();
			obj.editIndex = null;
			obj.loadData({ total: 0, rows: [] });
			obj.setFooterInfo();
		}
	};
	/**
	 * 检查必填项
	 * 通过 返回true
	 * 不通过 返回 false
	*/
	this.checkMustInput = function(Block, json) {
		var length = FormMustInput[Block].length;
		for (var i = 0; i < length; i++) {
			var val = json[FormMustInput[Block][i].INCMIEleName];
			if (isEmpty(val)) {
				return false;
			}
		}
		return true;
	};
	
	/**
	 * 检查必填项
	 * 返回必填项名称
	*/
	this.returnMustInputName=function(Block,json){
		var length=FormMustInput[Block].length;
		var INCMIEleLabelStr="";
		for (var i=0;i<length;i++){
			var val=json[FormMustInput[Block][i].INCMIEleName];
			if(isEmpty(val)){
				if (INCMIEleLabelStr==""){
					var INCMIEleLabelStr=FormMustInput[Block][i].INCMIEleLabel;
				}else{
					var INCMIEleLabelStr=INCMIEleLabelStr+"^"+FormMustInput[Block][i].INCMIEleLabel;
				}
			}
		}
		return INCMIEleLabelStr;
	};
}

/* ====================================================================
								~CommonUI
======================================================================*/
/**
 * CommonUI默认实例
 */
var $UI = $CommonUI = new CommonUI();