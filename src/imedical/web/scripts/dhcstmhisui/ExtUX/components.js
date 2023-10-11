// 名称: 常用组件的封装
// 描述: 常用组件的封装
// 编写者：XuChao
// 编写日期: 2018.03.19

// 设置panel默认iconCls
// $.fn.panel.defaults.iconCls='icon-paper';
// 设置dialog默认iconCls
$.fn.dialog.defaults.iconCls = 'icon-w-paper';
// 类组tree
(function($) {
	$.parser.plugins.push('stkscgcombotree');// 注册扩展组件
	$.fn.stkscgcombotree = function(options, param) { // 定义扩展组件
		// 当options为字符串时，说明执行的是该插件的方法。
		if (typeof options === 'string') {
			return $.fn.combotree.apply(this, arguments);
		}
		options = options || {};
		// 当该组件在一个页面出现多次时，this是一个集合，故需要通过each遍历。
		return this.each(function() {
			var jq = $(this);
			// $.fn.combotree.parseOptions(this)作用是获取页面中的data-options中的配置
			var opts = $.extend({
				setDefaults: true,		// 是否默认显示
				onLoadSuccess: function() {
					jq.combotree('options')['setDefaultFun']();
					jq.combotree('textbox').bind('blur', function() {
						if (isEmpty(jq.combotree('getText'))) {
							jq.combotree('setValue', '');
						}
					});
				},
				setDefaultFun: function() {
					jq.stkscgcombotree('clear');
					if (jq.stkscgcombotree('options')['setDefaults'] !== false) {
						var StrParam = jq.stkscgcombotree('options')['StrParam'];
						var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetDefaScg', StrParam);
						var ScgId = DefaInfo.split('^')[0], ScgDesc = DefaInfo.split('^')[1];
						if (ScgId && ScgDesc) {
							jq.stkscgcombotree('setValue', ScgId);
						}
					}
				}
			}, $.fn.combotree.parseOptions(this), options);
			var StrParam = '^^^^' + gHospId + '^' + StkGrpHospid;
			if ((StkGrpHospid != '') && (gHospId != StkGrpHospid)) {
				StrParam = '^^^^^' + StkGrpHospid;
			} else {
				StrParam = gLocId + '^' + gUserId + '^^^' + gHospId + '^' + StkGrpHospid;
			}
			var Data = $.cm({
				ClassName: 'web.DHCSTMHUI.Util.StkGrp',
				MethodName: 'GetScgChildNode',
				NodeId: 'AllSCG',
				StrParam: StrParam,
				Type: 'M'
			}, false);
			// 把配置对象myopts放到$.fn.combotree这个函数中执行。
			var myopts = $.extend(true, {
				StrParam: StrParam,		// 此参数用于默认值的取值方法
				data: Data,
				editable: true,
				panelWidth: 'auto',
				onShowPanel: function() { // 面板自适应
					$(this).combobox('panel').width('auto');
					var panelwidth = $(this).combobox('panel').width();
					var width = Number($(this).css('width').split('px')[0]);
					if (panelwidth < width) {
						if (width == 148) { // 引用textbox的宽度
							width = width + 5;
						} else { // style设置的宽度
							width = width - 2;
						}
						$(this).combobox('panel').width(width);
					} else { // 解决在IE下出现滚动条的问题
						$(this).combobox('panel').width(panelwidth + 20);// 下拉面板
						$(this).combobox('panel').parent().width('auto');// 面板外面还包裹了一层父节点
					}
				}
			}, opts);
			$.fn.combotree.call(jq, myopts);
		});
	};
	// 扩展setFilterByLoc方法
	$.extend($.fn.combotree.methods, {
		setFilterByLoc: function(jq, LocId, xLocId, ScgSet) {
			if (isEmpty(xLocId)) { xLocId = ''; }
			if (isEmpty(ScgSet)) { ScgSet = ''; }
			var StrParam = LocId + '^' + gUserId + '^' + xLocId + '^' + ScgSet + '^' + gHospId + '^' + StkGrpHospid;
			var Data = $.cm({
				ClassName: 'web.DHCSTMHUI.Util.StkGrp',
				MethodName: 'GetScgChildNode',
				NodeId: 'AllSCG',
				StrParam: StrParam,
				Type: 'M'
			}, false);
			$(jq).combotree('options')['StrParam'] = StrParam;
			$(jq).combotree('loadData', Data);
			$(jq).combotree('options')['setDefaultFun']();
		},
		// 扩展reload方法--ps:这种写法直接扩展给combotree了,不是特别好.
		load: function(jq, StkGrpHospidm) {
			var StrParam = '^^^^' + gHospId + '^' + StkGrpHospidm;
			if ((StkGrpHospidm != '') && (StkGrpHospidm != gHospId)) {
				StrParam = '^^^^^' + StkGrpHospidm;
			} else {
				StrParam = gLocId + '^' + gUserId + '^^^' + gHospId + '^' + StkGrpHospidm;
			}
			var Data = $.cm({
				ClassName: 'web.DHCSTMHUI.Util.StkGrp',
				MethodName: 'GetScgChildNode',
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
	 * js中需定义data: [{'RowId':***,'Description':***},...]
	 */
	$.parser.plugins.push('simplecombobox');
	$.fn.simplecombobox = function(options, param) {
		if (typeof options === 'string') {
			return $.fn.combobox.apply(this, arguments);
		}
		options = options || {};
		var DefaData = [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '是' }, { 'RowId': 'N', 'Description': '否' }];
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
	 * combobox过滤方式, 定义于jQuery.hisui.js
	 * defaultFilter含义说明:
	 * 	1:左匹配,不区分大小写(hisui默认)
	 * 	2:包含,不区分大小写
	 * 	3:左匹配,或拼音首字母左匹配
	 * 	4:包含,或拼音首字母包含,不区分大小写
	 */
	$.extend($.fn.combobox.defaults, {
		valueField: 'RowId',
		textField: 'Description',
		defaultFilter: 4
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

	// 修正updateRow getChanges 获取不到值的问题
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
	 * numberbox控制小数位数
	 */
	$.extend($.fn.numberbox.defaults, {
		isKeyupChange: false,
		precision: GetFmtNum('FmtRP'),
		fix: true,
		min: ''
	});
	
	/*
	 * mulcombobox多选
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
				separator: ','	// 默认用,分隔
			}, opts);
			$.fn.combobox.call(jq, myopts);
		});
	};
	
	$.extend($.fn.radio.defaults, {
		requiredSel: true
	});
})(jQuery);