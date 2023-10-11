/// Creator：      EH
/// CreatDate：    2021-08-16
/// Description:   其他设置

function _settingpanel() {
	var _panel = this;
	_panel.click = function() {
	};
	/// 直接加载控件
	_panel.getDomValue_CSP = function() {
		var dom = '';
		var settings = GV['_GlobalSetting']['data'];
		var items = settings.split('!');
		for (var i = 0; i < items.length; i++) {
			var item = items[i].split('@');
			var value = '';
			var id = item[0];
			if (isElement(id)) {
				value = getElementValue(id);
			} else {
				var j = 0;
				while (true) {
					var dot = id + '.' + (++j).toString();
					if (isElement(dot)) {
						value += j > 1 ? '&' : '';
						value += getElementValue(dot);
					} else {
						break;
					}
				}
			}
			dom += (dom != '') ? '!' : '';
			dom += id + '@' + value;
		}
		return dom;
	};
	_panel.setDomValue_CSP = function(settings) {
		var items = settings.split('!');
		for (var i = 0; i < items.length; i++) {
			var item = items[i].split('@');
			var value = item[1];
			var id = item[0];
			if (isElement(id)) {
				setElementValue(id, value);
			} else {
				var valueSplit = value.split('&');
				var j = 0;
				while (true) {
					var dot = id + '.' + (++j).toString();
					if (isElement(dot)) {
						var valueDot = valueSplit.length >= j ? valueSplit[j - 1] : '';
						setElementValue(dot, valueDot);
					} else {
						break;
					}
				}
			}
		}
		GV['_GlobalSetting']['data'] = settings;
	};
	_panel.find_CSP = function() {
		if (getNullFlag() == 'Y') {
			_panel.hide();
			return false;
		}
		_panel.show();
		getData(getParams(['dataType', 'hospID', 'locID'], null, 'GetSetting'), _panel.setDomValue_CSP);
		_panel.createStandardizationDomAndFind();
	};
	_panel.save_CSP = function() {
		if (getNullFlag() == 'Y') { return false; }
		getData(getParams(['dataType', 'hospID', 'locID'], null, 'SaveSetting', {
			data: _panel.getDomValue_CSP()
		}), function(ret) {
			if (showResult(ret, '保存')) _panel.saveStandardizationValue();
		});
	};
	/// 动态创建控件
	_panel.getDomValue = function() {
		var dom = '';
		var data = GV['_GlobalSetting']['data'];
		for (var i = 0; i < data.length; i++) {
			var panel = data[i];
			var id = panel.id;
			var path = panel.path;
			var key = path;
			if (path != '') {
				key = path + '/';
			}
			key += id.toLowerCase();
			key = key.split('/').join('%2F');
			var el = '';
			var items = panel.children;
			for (var j = 0; j < items.length; j++) {
				var item = items[j];
				var value = item.value;
				var id = item.id;
				if (isElement(id)) {
					var div = '';
					value = getElementValue(id);
					var element = getElement(id);
					var className = element[0].className;
					if (className.indexOf('checkbox') > -1) {
						value = element.checkbox('getValue');
						div = '{' + id + ':' + value + '}';
					} else if (className.indexOf('numberbox') > -1) {
						div = '{' + id + ':' + value + '}';
					} else if (value != null) {
						div = '{"' + id + '":"' + value + '"}';
					}
					if (div != '') {
						if (el != '') {
							el += ',';
						}
						el += div;
					}
				}
			}
			if (el != '') {
				el = '[' + el + ']';
				if (dom != '') {
					dom += ',';
				}
				dom += '{"' + key + '":' + el + '}';
			}
		}
		if (dom != '') {
			dom = '[' + dom + ']';
		}
		dom = $.escape(dom);
		return dom;
	};
	_panel.setDomValue = function(settings) {
		var data = eval('(' + settings + ')');
		for (var i = 0; i < data.length; i++) {
			var panel = data[i];
			var items = panel.children;
			for (var j = 0; j < items.length; j++) {
				var item = items[j];
				var value = item.value;
				var id = item.id;
				if (isElement(id)) {
					setElementValue(id, value);
				}
			}
		}
		GV['_GlobalSetting']['data'] = data;
	};
	_panel.show = function() {
		$('#settingPanelBody').css('display', 'block');
		var tbar = $('#settingPanelTbar');
		var item = tbar.children();
		var layout = tbar.parent().parent().parent();
		if (item.length > 2) {
			item.eq(item.length - 1).css('display', 'block');
			item.eq(item.length - 2).css('display', 'flex');
		} else {
			tbar.css('display', 'block');
		}
		var height = Math.round(tbar[0].getBoundingClientRect().height.toFixed(2));
		layout.layout('panel', 'north').panel('resize', { height: height });
		layout.layout('resize');
	};
	_panel.hide = function() {
		$('#settingPanelBody').css('display', 'none');
		var tbar = $('#settingPanelTbar');
		var item = tbar.children();
		var layout = tbar.parent().parent().parent();
		if (item.length > 2) {
			item.eq(item.length - 1).css('display', 'none');
			item.eq(item.length - 2).css('display', 'none');
		} else {
			tbar.css('display', 'none');
		}
		var height = Math.round(tbar[0].getBoundingClientRect().height.toFixed(2));
		layout.layout('panel', 'north').panel('resize', { height: height });
		layout.layout('resize');
	};
	_panel.find = function() {
		if (GV._SettingFromCSP) { return _panel.find_CSP(); }
		if (getNullFlag() == 'Y' || !_panel.created) {
			_panel.hide();
			return false;
		}
		_panel.show();
		getData(getParams(['dataType', 'hospID', 'locID'], null, 'GetSettingDomPathValue'), _panel.setDomValue);
	};
	_panel.save = function() {
		if (GV._SettingFromCSP) { return _panel.save_CSP(); }
		/// 默认按全部院区
		if (getNullFlag() == 'Y') { return false; }
		getData(getParams(['dataType', 'hospID', 'locID'], null, 'SaveSettingDomPathValue', {
			dom: _panel.getDomValue()
		}), function(ret) {
			if (showResult(ret, '保存')) _panel.saveStandardizationValue();
		});
	};
	_panel.created = GV._SettingFromCSP || false;
	_panel.create = function() {
		if (_panel.created || GV._SettingFromCSP) {
			return;
		}
		var params = GV._SettingFromBackEnd ? {
			MethodName: 'GetSettingDomPath',
			dataType: 'text'
		} : {
			QueryName: 'FindSetting',
			ResultSetType: 'array'
		};
		getData(params, function(settings) {
			_panel.createDom(settings);
			_panel.created = true;
		});
	};
	_panel.createDom = function(settings) {
		var dom = '';
		if (typeof(settings) == 'string') {
			dom = settings;
		} else if (typeof(settings) == 'object') {
			dom = _panel.parse_in_table(settings);
		}
		if (dom != '') {
			$(dom).appendTo('#settingPanelBody');
			$.parser.parse($('#settingPanelBody'));
		}
	};
	_panel.createStandardizationDomAndFind = function() {
		getData(
			getParams(['ResultSetType', 'hospID', 'locID', 'configFlag'], 'FindStandardization'),
			function(settings) {
			var dom = '', set = '', div = '', items = [], setID = 'standardizationSet', lastDemandID = '';
			set += '<div id="' + setID + '" class="hisui-panel div-set" title="标化扩展" data-options="headerCls:\'panel-header-card-gray\'">';
			set += '<div class="div-set-body">';
			for (var i = 0; i < settings.length; i++) {
				var item = settings[i];
				var demandID = item.demandID;
				if (demandID == "2580162") continue;
				var elementID = item.elementID;
				var elementType = item.elementType
				var elementHTML = eval('(' + (item.elementHTML || '{}') + ')');
				var elementTitle = item.elementTitle;
				var elementValue = item.elementValue;
				items.push({ id: elementID, value: elementValue });
				var line = demandID != lastDemandID && i > 0 ? '<div class="div-tbar-dash" style="display: flex;"></div>' : '';
				var tip = (demandID != '' && (demandID != lastDemandID || i == 0)) ? '需求序号：' + demandID : '';
				lastDemandID = demandID;
				if (tip) elementTitle = '<div title="' + tip + '" class="hisui-tooltip" data-options="position:\'top\'">' + elementTitle + '</div>';
				switch (elementType) {
					case 'datebox':
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						div += '<input id="' + elementID + '" type="text" class="combo-text validatebox-text" autocomplete="off" style="width:118px;height:28px;line-height:28px">';
						break;
					case 'timebox':
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						div += '<input id="' + elementID + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false">';
						break;
					case 'texttime':
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						div += '<input id="' + elementID + '_Date" class="hisui-numberbox textbox numberbox numberbox-f validatebox-text" style="width:80px;height:28px;line-height:28px">';
						div += '<div style="width:5px"></div>';
						div += '<input id="' + elementID + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false">';
						break;
					case 'datetime':
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						div += '<input id="' + elementID + '_Date" type="text" class="combo-text validatebox-text" autocomplete="off" style="width:118px;height:28px;line-height:28px">';
						div += '<div style="width:5px"></div>';
						div += '<input id="' + elementID + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false">';
						break;
					case 'numberbox':
						var options = elementHTML.options || '';
						if (options != '') {
							options = ' data-options:"' + options + '"';
						}
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						div += '<input id="' + elementID + '" class="hisui-numberbox textbox numberbox numberbox-f validatebox-text" style="width:80px;height:28px;line-height:28px"' + options + '>';
						break;
					case 'combobox':
						var options = elementHTML.options || ',valueField:\'code\',textField:\'name\'', ul = '', data = elementHTML.data || [], url = elementHTML.url || '';
						if (url != '') {
							url = ',url:\'' + url + '\'';
						} else {
							for (var dataIndex = 0; dataIndex < data.length; dataIndex++) {
								var dataElement2Str = '', dataElement = data[dataIndex];
								for (var o in dataElement) {
									dataElement2Str += (dataElement2Str != '') ? ',' : '';
									dataElement2Str += o + ':\'' + dataElement[o] + '\'';
								}
								ul += dataIndex > 0 ? ',' : '';
								ul += '{' + dataElement2Str + '}';
							}
							if (ul != '') {
								url = ',data:[' + ul + ']';
							}
						}
						options += url;
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						var width = elementHTML.width != undefined ? String(elementHTML.width).replace('px', '') : 210;
						div += '<input id="' + elementID + '" class="combo-text hisui-combobox" autocomplete="off" style="width:' + width + 'px;height:28px;line-height:28px" data-options="enterNullValueClear:false,panelHeight:\'auto\',panelMaxHeight:\'398px\'' + options + '">';
						break;
					case 'textbox':
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						var width = elementHTML.width != undefined ? String(elementHTML.width).replace('px', '') : 210;
						div += '<input id="' + elementID + '" class="hisui-textbox textbox validatebox-text" style="width:' + width + 'px;height:28px;line-height:28px">';
						break;
					case 'checkbox':
						div += '<div class="div-set-body-item-label">' + elementTitle + '</div>';
						div += '<div style="width:40px;text-align:left;padding:3px 0">';
						div += '<input id="' + elementID + '" type="checkbox" class="hisui-checkbox">';
						div += '</div>';
						break;
					default:
						break;
				}
				if (div != '') {
					if (line) set += line;
					div = '<div class="div-set-body-item">' + div +'</div>';
					set += div;
					div = '';
				}
			}
			set += '</div>';
			set += '</div>';
			dom += set;
			set = '';
			var change = false;
			var oldItems = GV['_GlobalSetting']['standardizationData'];
			if (!oldItems) change = true;
			else if (oldItems.length != items.length) change = true;
			else {
				for (var i = 0; i < oldItems.length; i++) {
					var find = false;
					for (var j = 0; j < items.length; j++) {
						if (items[j].id == oldItems[i].id) {
							find = true;
							break;
						}
					}
					if (!find) {
						change = true;
						break;
					}
				}
			}
			if (dom != '' && change) {
				if (isElement(setID)) $('#' + setID).parent().remove();
				$(dom).appendTo('#settingPanelBody');
				$.parser.parse($('#settingPanelBody'));
			}
			for (var j = 0; j < items.length; j++) {
				var item = items[j];
				var value = item.value;
				var id = item.id;
				if (isElement(id)) {
					setElementValue(id, value);
				}
			}
			GV['_GlobalSetting']['standardizationData'] = items;
		});
	};
	_panel.saveStandardizationValue = function() {
		if (getNullFlag() == 'Y') { return false; }
		var items = GV['_GlobalSetting']['standardizationData'] || [];
		for (var j = 0; j < items.length; j++) {
			var item = items[j], id = item.id;
			if (isElement(id)) {
				var value = getElementValue(id);
				getData(getParams(['dataType', 'hospID', 'locID'], null, 'SaveStandardizationSub', {
					elementID: id, elementValue: value
				}), function(ret) {
					if (String(ret).indexOf('"success":0') > -1) {
						var success = eval('(' + ret + ')');
						var msg = success.msg;
						$.messager.popover({ msg: '标化扩展保存失败: ' + msg, type: 'alert', timeout: 5000 });
					} else if (!(parseInt(ret) < 0)) {
					} else {
						$.messager.popover({ msg: '标化扩展保存失败: ' + ret, type: 'alert', timeout: 5000 });
					}
				});	
			}
		}
	};
	_panel.parse = function(settings) {
		var dom = '';
		for (var i = 0; i < settings.length; i++) {
			var item = settings[i];
			var pathSplit = item.path.split('/');
			/// 是标题
			if (['hotlink', 'globalsetting'].indexOf(pathSplit[pathSplit.length - 1]) > -1) {
				var code = item.code;
				var name = item.name;
				var element = eval('(' + (item.element || '{}') + ')');
				var k = 0, m = 0, set = '', div = '';
				set += element.type == 'hidden' ? '<div style="display:none">' : '<div id="' + code + '" class="hisui-panel div-set" title="' + name + '" data-options="headerCls:\'panel-header-card-gray\'">';
				set += '<div class="div-set-body">';
				for (var j = i + 1; j < settings.length; j ++) {
					var child = settings[j];
					var childPathSplit = child.path.split('/');
					/// 是子集
					if (childPathSplit[childPathSplit.length - 1] == code.toLowerCase()) {
						var childCode = child.code;
						var childName = child.name;
						var childElement = eval('(' + (child.element || '{}') + ')');
						var childType = childElement.type;
						/// 单行文本
						if (['datetime', 'texttime'].indexOf(String(childType)) > - 1) {
							childElement.singleLine = true;
						}
						if (childElement.singleLine && div != '') {
							div += '</div>';
							set += div;
							div = '';
							m = 0;
						}
						if (m == 0 ) {
							div += '<div class="div-set-body-item">';
						}
						/// 控件
						switch (childType) {
							case 'datebox':
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								div += '<input id="' + childCode + '" type="text" class="combo-text validatebox-text" autocomplete="off" style="width:118px;height:28px;line-height:28px">';
								break;
							case 'timebox':
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								div += '<input id="' + childCode + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false">';
								break;
							case 'texttime':
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								div += '<input id="' + childCode + '_Date" class="hisui-numberbox textbox numberbox numberbox-f validatebox-text" style="width:80px;height:28px;line-height:28px">';
								div += '<div style="width:5px"></div>';
								div += '<input id="' + childCode + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false">';
								break;
							case 'datetime':
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								div += '<input id="' + childCode + '_Date" type="text" class="combo-text validatebox-text" autocomplete="off" style="width:118px;height:28px;line-height:28px">';
								div += '<div style="width:5px"></div>';
								div += '<input id="' + childCode + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false">';
								break;
							case 'numberbox':
								var options = childElement.options || '';
								if (options != '') {
									options = ' data-options:"' + options + '"';
								}
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								div += '<input id="' + childCode + '" class="hisui-numberbox textbox numberbox numberbox-f validatebox-text" style="width:80px;height:28px;line-height:28px"' + options + '>';
								break;
							case 'combobox':
								var options = childElement.options || ',valueField:\'code\',textField:\'name\'', ul = '', data = childElement.data || [], url = childElement.url || '';
								if (url != '') {
									url = ',url:\'' + url + '\'';
								} else {
									for (var dataIndex = 0; dataIndex < data.length; dataIndex++) {
										var dataElement2Str = '', dataElement = data[dataIndex];
										for (var o in dataElement) {
											dataElement2Str += (dataElement2Str != '') ? ',' : '';
											dataElement2Str += o + ':\'' + dataElement[o] + '\'';
										}
										ul += dataIndex > 0 ? ',' : '';
										ul += '{' + dataElement2Str + '}';
									}
									if (ul != '') {
										url = ',data:[' + ul + ']';
									}
								}
								options += url;
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								var width = element.width != undefined ? String(element.width).replace('px', '') : 210;
								div += '<input id="' + childCode + '" class="combo-text hisui-combobox" autocomplete="off" style="width:' + width + 'px;height:28px;line-height:28px" data-options="enterNullValueClear:false,panelHeight:\'auto\',panelMaxHeight:\'398px\'' + options + '">';
								break;
							case 'textbox':
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								var width = element.width != undefined ? String(element.width).replace('px', '') : 210;
								div += '<input id="' + childCode + '" class="hisui-textbox textbox validatebox-text" style="width:' + width + 'px;height:28px;line-height:28px">';
								break;
							case 'checkbox':
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								div += '<div style="width:40px;text-align:left;padding:3px 0">';
								div += '<input id="' + childCode + '" type="checkbox" class="hisui-checkbox">';
								div += '</div>';
								break;
							case 'hidden':
								div += '<input id="' + childCode + '" type="hidden">';
								berak;
							case 'label':
							default:
								div += '<div class="div-set-body-item-label">' + childName + '</div>';
								break;
						}
						if (div != '' && childType != 'hidden') {
							if (childElement.singleLine) {
								m = 2;
							} else {
								++m;
							}
							if (m == 2) {
								div += '</div>';
								set += div;
								div = '';
								m = 0;
							}
						}
						k++;
					}
				}
				if (div != '') {
					div += '</div>';
					set += div;
					div = '';
				}
				var type = element.type;
				/// 控件
				switch (type) {
					case 'button':
					case 'link':
						div += '<div class="div-set-body-item">';
						div += '<a id="' + code + '" group="' + code + '" href="javascript:void(0)" onclick="$HUI._settingpanel.click" class="l-btn l-btn-small l-btn-plain">';
						div += '<span class="l-btn-left l-btn-icon-left">';
						div += '<span class="l-btn-text">' + name + '</span>';
						div += 'span class="l-btn-icon icon-two-recta-gear"></span>';
						div += '</span>';
						div += '</a>';
						div += '</div>';
						break;
					case 'hidden':
						div += '<div class="div-set-body-item" style="display:none">';
						div += '<input id="' + code + '" type="hidden">';
						div += '</div>';
						break;
					case 'panel':
					default:
						break;
				}
				if (div != '') {
					set += div;
					div = '';
				}
				set += '</div>';
				set += '</div>';
				dom += set;
				set = '';
				i += k;
			}
		}
		return dom;
	};
	_panel.parse_in_table = function(settings) {
		var dom = '';
		for (var i = 0; i < settings.length; i++) {
			var item = settings[i];
			var pathSplit = item.path.split('/');
			/// 是标题
			if (['hotlink', 'globalsetting'].indexOf(pathSplit[pathSplit.length - 1]) > -1) {
				var code = item.code;
				var name = item.name;
				var element = eval('(' + (item.element || '{}') + ')');
				var k = 0, m = 0, set = '', div = '', one_line = ['datetime', 'texttime'], biserial = ['checkbox'], prevType = '';
				set += element.type == 'hidden' ? '<div style="display:none">' : '<div id="' + code + '" class="hisui-panel div-set" title="' + name + '" data-options="headerCls:\'panel-header-card-gray\'">';
				set += '<div class="div-set-body">';
				for (var j = i + 1; j < settings.length; j ++) {
					var child = settings[j];
					var childPathSplit = child.path.split('/');
					/// 是子集
					if (childPathSplit[childPathSplit.length - 1] == code.toLowerCase()) {
						var childCode = child.code;
						var childName = child.name;
						var childElement = eval('(' + (child.element || '{}') + ')');
						var childType = childElement.type;
						/// 单行文本
						if (one_line.indexOf(String(childType)) > - 1 ||
							!(biserial.indexOf(String(childType)) > -1 && (prevType == '' || biserial.indexOf(String(prevType)) > -1))
							) {
							childElement.singleLine = true;
						}
						prevType = childType;
						if (childElement.singleLine && div != '') {
							div += '</tr></table></div>';
							set += div;
							div = '';
							m = 0;
						}
						if (m == 0 ) {
							div += '<div class="div-set-body-item"><table><tr>';
						}
						/// 控件
						switch (childType) {
							case 'datebox':
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								div += '<td><input id="' + childCode + '" type="text" class="combo-text validatebox-text" autocomplete="off" style="width:118px;height:28px;line-height:28px"></td>';
								break;
							case 'timebox':
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								div += '<td><input id="' + childCode + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false"></td>';
								break;
							case 'texttime':
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								div += '<td><input id="' + childCode + '_Date" class="hisui-numberbox textbox numberbox numberbox-f validatebox-text" style="width:80px;height:28px;line-height:28px"></td>';
								div += '<td><div style="width:5px"></div></td>';
								div += '<td><input id="' + childCode + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false"></td>';
								break;
							case 'datetime':
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								div += '<td><input id="' + childCode + '_Date" type="text" class="combo-text validatebox-text" autocomplete="off" style="width:118px;height:28px;line-height:28px"></td>';
								div += '<td><div style="width:5px"></div></td>';
								div += '<td><input id="' + childCode + '" class="hisui-timespinner timespinner-f spinner-text spinner-f validatebox-text" style="border-radius:2px;width:80px;height:28px;line-height:28px" data-options="showSeconds:false"></td>';
								break;
							case 'numberbox':
								var options = childElement.options || '';
								if (options != '') {
									options = ' data-options:"' + options + '"';
								}
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								div += '<td><input id="' + childCode + '" class="hisui-numberbox textbox numberbox numberbox-f validatebox-text" style=""' + options + '></td>';
								break;
							case 'combobox':
								var options = childElement.options || ',valueField:\'code\',textField:\'name\'', ul = '', data = childElement.data || [], url = childElement.url || '';
								if (url != '') {
									url = ',url:\'' + url + '\'';
								} else {
									for (var dataIndex = 0; dataIndex < data.length; dataIndex++) {
										var dataElement2Str = '', dataElement = data[dataIndex];
										for (var o in dataElement) {
											dataElement2Str += (dataElement2Str != '') ? ',' : '';
											dataElement2Str += o + ':\'' + dataElement[o] + '\'';
										}
										ul += dataIndex > 0 ? ',' : '';
										ul += '{' + dataElement2Str + '}';
									}
									if (ul != '') {
										url = ',data:[' + ul + ']';
									}
								}
								options += url;
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								var width = element.width != undefined ? String(element.width).replace('px', '') : 210;
								div += '<td><input id="' + childCode + '" class="combo-text hisui-combobox" autocomplete="off" style="width:' + width + 'px;height:28px;line-height:28px" data-options="enterNullValueClear:false,panelHeight:\'auto\',panelMaxHeight:\'398px\'' + options + '"></td>';
								break;
							case 'textbox':
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								var width = element.width != undefined ? String(element.width).replace('px', '') : 210;
								div += '<td><input id="' + childCode + '" class="hisui-textbox textbox validatebox-text" style="width:' + width + 'px;height:28px;line-height:28px"></td>';
								break;
							case 'checkbox':
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								div += '<td><div style="width:40px;text-align:left;padding:3px 0">';
								div += '<input id="' + childCode + '" type="checkbox" class="hisui-checkbox">';
								div += '</div></td>';
								break;
							case 'hidden':
								div += '<td><input id="' + childCode + '" type="hidden"></td>';
								berak;
							case 'label':
							default:
								div += '<td><div class="div-set-body-item-label">' + childName + '</div></td>';
								break;
						}
						if (div != '' && childType != 'hidden') {
							if (childElement.singleLine) {
								m = 2;
							} else {
								++m;
							}
							if (m == 2) {
								div += '</tr></table></div>';
								set += div;
								div = '';
								m = 0;
							}
						}
						k++;
					}
				}
				if (div != '') {
					div += '</tr></table></div>';
					set += div;
					div = '';
				}
				var type = element.type;
				/// 控件
				switch (type) {
					case 'button':
					case 'link':
						div += '<div class="div-set-body-item"><table><tr>';
						div += '<td><a id="' + code + '" group="' + code + '" href="javascript:void(0)" onclick="$HUI._settingpanel.click" class="l-btn l-btn-small l-btn-plain">';
						div += '<span class="l-btn-left l-btn-icon-left">';
						div += '<span class="l-btn-text">' + name + '</span>';
						div += 'span class="l-btn-icon icon-two-recta-gear"></span>';
						div += '</span>';
						div += '</a></td>';
						div += '</tr></table></div>';
						break;
					case 'hidden':
					case 'panel':
					default:
						div += '<div class="div-set-body-item"><table><tr><td></td></tr></table></div>'
						break;
				}
				if (div != '') {
					set += div;
					div = '';
				}
				set += '</div>';
				set += '</div>';
				dom += set;
				set = '';
				i += k;
			}
		}
		return dom;
	};
	/// 初始化
	_panel.initEvent = function() {
		/// 其他设置
		GV['_GlobalSetting'] = {};
		_panel.create();
		$('#settingPanelSaveBtn').bind('click', _panel.save);
	};
	/// 等待参数传递
	setTimeout(function() {
		_panel.initEvent();
	}, 0);
}
$HUI.settingpanel = function() {
	if (!$HUI._settingpanel) {
		$HUI._settingpanel = new _settingpanel();
	}
	return $HUI._settingpanel;
};
$(function() {
	$HUI.settingpanel();
});
