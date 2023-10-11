// ����: ��������ķ�װ
// ����: ��������ķ�װ
// ��д�ߣ�wfg
// ��д����:2019-4-3

// ����panelĬ��iconCls
// $.fn.panel.defaults.iconCls='icon-paper';
// ������tree
(function($) {
	$.parser.plugins.push('packagecombotree');// ע����չ���
	$.fn.packagecombotree = function(options, param) { // ������չ���
		// ��optionsΪ�ַ���ʱ��˵��ִ�е��Ǹò���ķ�����
		if (typeof options === 'string') {
			return $.fn.combotree.apply(this, arguments);
		}
		options = options || {};
		// ���������һ��ҳ����ֶ��ʱ��this��һ�����ϣ�����Ҫͨ��each������
		return this.each(function() {
			var jq = $(this);
			// $.fn.combotree.parseOptions(this)�����ǻ�ȡҳ���е�data-options�е�����
			var opts = $.extend({
				setDefaults: true,		// �Ƿ�Ĭ����ʾ
				onLoadSuccess: function() {
					jq.combotree('options')['setDefaultFun']();
					jq.combotree('textbox').bind('blur', function() {
						if (isEmpty(jq.combotree('getText'))) {
							jq.combotree('setValue', '');
						}
					});
				},
				setDefaultFun: function() {
					// ��ʱ��д��
				}
			}, $.fn.combotree.parseOptions(this), options);
			
			var StrParam = '^';
			var Data = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetPackageCommboTree',
				gLoc: gLocId,
				StrParam: StrParam
			}, false);
			// �����ö���myopts�ŵ�$.fn.combotree���������ִ�С�
			var myopts = $.extend(true, {
				StrParam: StrParam,		// �˲�������Ĭ��ֵ��ȡֵ����
				data: Data,
				editable: true
			}, opts);
			
			$.fn.combotree.call(jq, myopts);
		});
	};
	// ��չsetFilter����  (������������ )
	$.extend($.fn.combotree.methods, {
		setFilterByLoc: function(jq, LocId, xLocId, ScgSet) {
			if (isEmpty(xLocId)) { xLocId = ''; }
			if (isEmpty(ScgSet)) { ScgSet = ''; }
			var StrParam = LocId + '^' + gUserId + '^' + xLocId + '^' + ScgSet;
			var Data = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetPackageCommboTree',
				NodeId: 'AllSCG',
				StrParam: StrParam,
				Type: 'M'
			}, false);
			$(jq).combotree('options')['StrParam'] = StrParam;
			$(jq).combotree('loadData', Data);
			$(jq).combotree('options')['setDefaultFun']();
		}
	});
	
	/*
	 * SimpleCombo
	 * js���趨��data: [{'RowId':***,'Description':***},...]
	 */
	$.parser.plugins.push('simplecombobox');
	$.fn.simplecombobox = function(options, param) {
		if (typeof options === 'string') {
			return $.fn.combobox.apply(this, arguments);
		}
		options = options || {};
		var DefaData = [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'Y', 'Description': '��' }, { 'RowId': 'N', 'Description': '��' }];
		return this.each(function() {
			var jq = $(this);
			var opts = $.extend({}, $.fn.combobox.parseOptions(this), options);
			var Data = options.data || DefaData;
			var myopts = $.extend(true, {
				data: Data,
				valueField: 'RowId',
				textField: 'Description'
			}, opts);
			$.fn.combobox.call(jq, myopts);
		});
	};
	
	/*
	 * combobox���˷�ʽ, ������jQuery.hisui.js
	 * Ĭ�ϵ�filter���˹���
	 * 1��text�ֶ���ƥ�� �����ִ�Сд
	 * 2��text�ֶΰ���ƥ�� �����ִ�Сд
	 * 3��(�ݲ�ʹ��)text�ֶ���ƥ���ƴ������ĸ��ƥ��(������ֻȡ��ȡ���ĵ�һ��ƴ����ƴ) �����ִ�Сд��Ϊͬ5 2020-06-12
	 * 4��(�ݲ�ʹ��)text�ֶΰ���ƥ���ƴ������ĸ����ƥ��(������ֻȡ��ȡ���ĵ�һ��ƴ����ƴ) �����ִ�Сд��Ϊͬ6 2020-06-12
	 * 5��text�ֶ���ƥ���ƴ������ĸ��ƥ��(���Ƕ�����) �����ִ�Сд 2020-05-26
	 * 6��text�ֶΰ���ƥ���ƴ������ĸ����ƥ��(���Ƕ�����) �����ִ�Сд 2020-05-26
	 */
	$.extend($.fn.combobox.defaults, {
		valueField: 'RowId',
		textField: 'Description',
		defaultFilter: 6
	});
	$.extend($.fn.lookup.defaults, {
		width: 'auto',
		panelWidth: 200,
		isCombo: true,
		url: $URL,
		mode: 'local',
		filter: function(q, row) {
			var v = row[$(this).lookup('options')['textField']];
			return v.indexOf(q.toLowerCase()) > -1 || $.hisui.toChineseSpell(v).toLowerCase().indexOf(q.toLowerCase()) > -1;
		},
		idField: 'RowId',
		textField: 'Description',
		columnsLoader: function() {
			return [[{ field: 'Description', title: '', width: 100 }]];
		},
		fitColumns: true,
		pagination: false
	});

	// ����updateRow getChanges ��ȡ����ֵ������
	$.extend($.fn.datagrid.methods, {
		updateRow: function(jq, param) {
			return jq.each(function() {
				var target = this;
				var state = $.data(target, 'datagrid');
				var opts = state.options;
				var row = opts.finder.getRow(target, param.index);
				var updated = false;
				for (var field in param.row) {
					if (row[field] != param.row[field]) {
						updated = true;
						break;
					}
				}
				if (updated) {
					if ($.inArray(row, state.insertedRows) == -1) {
						if ($.inArray(row, state.updatedRows) == -1) {
							state.updatedRows.push(row);
						}
					}
					$.extend(row, param.row);
					opts.view.updateRow.call(opts.view, this, param.index, param.row);
				}
			});
		}
	});
	
	/*
	 * mulcombobox��ѡ
	 */
	$.parser.plugins.push('mulcombobox');
	$.fn.mulcombobox = function(options, param) {
		if (typeof options === 'string') {
			return $.fn.combobox.apply(this, arguments);
		}
		options = options || {};
		return this.each(function() {
			var jq = $(this);
			var opts = $.extend({}, $.fn.combobox.parseOptions(this), options);
			var myopts = $.extend(true, {
				valueField: 'RowId',
				textField: 'Description',
				multiple: true,
				rowStyle: 'checkbox',
				selectOnNavigation: false,
				separator: ','	// Ĭ����,�ָ�
			}, opts);
			$.fn.combobox.call(jq, myopts);
		});
	};
	
	$.extend($.fn.radio.defaults, {
		requiredSel: true
	});
	
	/*
	* ��ɫ�༭��
	* PS:��Ҫҳ��CSP����colorpicker.js���JS
	* <LINK REL="stylesheet" TYPE="text/css" HREF="../scripts_lib/jQuery/colorpicker/css/colorpicker.css"></LINK>
	* <script type="text/javascript" src="../scripts_lib/jQuery/colorpicker/js/colorpicker.js"></script>
	*/
	$.extend($.fn.datagrid.defaults.editors, {
		colorpicker: {
			init: function(container, options) {
				var input = $('<input>').appendTo(container);
				input.ColorPicker({
					color: '#0000ff',
					onShow: function(colpkr) {
						$(colpkr).fadeIn(500);
						return false;
					},
					onHide: function(colpkr) {
						$(colpkr).fadeOut(500);
						return false;
					},
					onChange: function(hsb, hex, rgb) {
						input.css('backgroundColor', '#' + hex);
						input.val('#' + hex);
					}
				});
				return input;
			},
			getValue: function(target) {
				return $(target).val();
			},
			setValue: function(target, value) {
				$(target).val(value);
				$(target).css('backgroundColor', value);
				$(target).ColorPickerSetColor(value);
			},
			resize: function(target, width) {
				var input = $(target);
				if ($.boxModel == true) {
					input.width(width - (input.outerWidth() - input.width()));
				} else {
					input.width(width);
				}
			}
		}
	});
})(jQuery);