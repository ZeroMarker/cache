/**
 * description: 药房药库页面设置公共 ( 页面设置初始化/快捷键设置/表格列设置 )
 * creator:     Huxt
 * createDate:  2021-03-19
 * others:      scripts/pha/sys/v1/set.js
 */
var PHA_SYS_SET = {
	PISTable: 'CF_PHA_IN.PageItmSet',
	JsGridOptions: [],
	UnbindIdArr: [],
	/*
	 * 初始化参数 (pha/com/v1/js/event.js中调用)
	 * PHA_SYS_SET.Init();
	 */
	Init: function(){
		// 参数
		var pJson = {
			ProCode: PHA_COM.App.ProCode || "",
			ProDesc: PHA_COM.App.ProDesc || "",
			Csp: PHA_SYS_SET.Com.GetCsp(),
			Name: PHA_SYS_SET.Com.GetName(),
			SessionStr: PHA_COM.Session.ALL
		};
		var pJsonStr = JSON.stringify(pJson);
		// 获取数据
		// var retJson = $.cm({
		var retJson = PHA_SYS_SET.Com.cm({
			ClassName: "PHA.SYS.Set.Query",
			MethodName: "GetParams",
			pMethodForm: 'PHA.SYS.Set.Query:AllFormOptions',
			pMethodCom: PHA_COM.App.ParamMethod || "",
			pJsonStr: pJsonStr
		}, false);
		if (retJson.success == 0 || retJson.form.success == 0 || retJson.com.success == 0) {
			var errStr = '获取配置数据失败:';
			errStr += JSON.stringify(retJson) + '。';
			errStr += '若提示[csp在系统中未维护]，您可以在界面按快捷键[ctrl+alt+i]生成！';
			errStr += 'at: js -> pha/sys/v1/set.js, rowNumber -> 38.';
			console.log(errStr);
			if (PHA_COM.ResizePhaColParam.auto) {
				PHA_COM.ResizePhaCol();
			}
			PHA_COM.Param.layoutMgr = retJson.layoutMgr || 'N';
			PHA_COM.Param.columnMgr = retJson.columnMgr || 'N';
			return;
		}
		// 公共参数 - 缓存备用
		PHA_COM.Param.layoutMgr = retJson.layoutMgr;
		PHA_COM.Param.columnMgr = retJson.columnMgr;
		PHA_COM.Param.Com = retJson.com;
		PHA_COM.Param.Form = retJson.form;
		// 页面设置 - 表单初始化
		PHA_SYS_SET.Form.Init(retJson.form);
	},
	/*
	 * 页面表单设置相关 (包含按钮、文本框、下拉框等)
	 */
	Form: {
		CreateType: 'HISUI',
		/*
		 * 初始化表单元素属性
		 * PHA_SYS_SET.Form.Init();
		 */
		Init: function (_allFormOpts) {
			// 定义 - 初始化方法
			var InitForm = {
				start: function (formOpts) {
					for (var iDomId in formOpts) {
						var oneDomOpts = formOpts[iDomId];
						var eleCode = oneDomOpts.eleCode;
						switch (eleCode) {
						case 'hisui-linkbutton':
							this.linkbutton(iDomId, oneDomOpts);
							break;
						case 'hisui-validatebox':
							this.validatebox(iDomId, oneDomOpts);
							break;
						case 'hisui-datebox':
							this.datebox(iDomId, oneDomOpts);
							break;
						case 'hisui-timespinner':
							this.timespinner(iDomId, oneDomOpts);
							break;
						case 'hisui-combobox':
							this.combobox(iDomId, oneDomOpts);
							break;
						case 'hisui-checkbox':
							this.checkbox(iDomId, oneDomOpts);
							break;
						default:
							break;
						}
					}
					return;
				},
				formRequired: function(domId, domOpts){
					var labelText = $("label[for='" + domId + "']").text() || "";
					labelText = labelText.replace('*', '');
					if (labelText != "") {
						var nLabelText = labelText;
						if (domOpts.required) {
							nLabelText = '<span style="color:red">*</span>' + labelText;
							var phaStr = $("#" + domId).attr('data-pha') || '';
							$("#" + domId).attr('data-pha', phaStr + ',required:true');
						}
						$("label[for='" + domId + "']").html(nLabelText);
					}
					return labelText;
				},
				linkbutton: function (domId, domOpts) {
					var $curObj = $('#' + domId);
					if ($curObj.length == 0) {
						return;
					}
					$curObj.linkbutton(domOpts);
					// 取消事件 (默认已绑定)
					if (domOpts.disabled == true) {
						PHA_SYS_SET.UnbindIdArr.push(domId); // $curObj.unbind();
					}
					// 右键不显示菜单 (默认已显示)
					if (domOpts.rightKey == false) {
						$curObj.unbind("contextmenu");
					}
					// 快捷键
					if (domOpts.hotkey && domOpts.hotkey != "") {
						hotkeys(domOpts.hotkey, function (e, h) {
							$curObj.click();
						});
					}
				},
				validatebox: function (domId, domOpts) {
					var $curObj = $('#' + domId);
					if ($curObj.length == 0) {
						return;
					}
					$curObj.validatebox(domOpts);
					// 默认值
					var val = domOpts.value || "";
					$curObj.val(val);
					// 是否必填
					var domTxt = this.formRequired(domId, domOpts);
					$curObj.on('contextmenu', function (e) {
						e.preventDefault();
						PHA_SYS_SET.Form.ValueSet.ShowMenu({
							domId: domId,
							domTxt: domTxt,
							itmType: 'hisui-validatebox'
						});
					});
				},
				datebox: function (domId, domOpts) {
					var $curObj = $('#' + domId);
					if ($curObj.length == 0) {
						return;
					}
					$curObj.datebox(domOpts);
					// 默认值
					$curObj.datebox('setValue', (domOpts.value || ""));
					// 是否必填
					var domTxt = this.formRequired(domId, domOpts);
					$curObj.datebox('textbox').on('contextmenu', function (e) {
						e.preventDefault();
						PHA_SYS_SET.Form.ValueSet.ShowMenu({
							domId: domId,
							domTxt: domTxt,
							itmType: 'hisui-datebox'
						});
					});
				},
				timespinner: function (domId, domOpts) {
					var $curObj = $('#' + domId);
					if ($curObj.length == 0) {
						return;
					}
					$curObj.timespinner(domOpts);
					// 默认值
					$curObj.timespinner('setValue', (domOpts.value || ""));
					// 是否必填
					var domTxt = this.formRequired(domId, domOpts);
					$curObj.on('contextmenu', function (e) {
						e.preventDefault();
						PHA_SYS_SET.Form.ValueSet.ShowMenu({
							domId: domId,
							domTxt: domTxt,
							itmType: 'hisui-timespinner'
						});
					});
				},
				combobox: function (domId, domOpts) {
					var $curObj = $('#' + domId);
					if ($curObj.length == 0) {
						return;
					}
					$curObj.combobox(domOpts);
					// 默认值 (数据是异步的)
					var val = domOpts.value || "";
					if (val != "") {
						PHA_SYS_SET.Com.SetComboDef(domId, val);
					}
					// 是否必填
					var domTxt = this.formRequired(domId, domOpts);
					$curObj.combobox('textbox').on('contextmenu', function (e) {
						e.preventDefault();
						PHA_SYS_SET.Form.ValueSet.ShowMenu({
							domId: domId,
							domTxt: domTxt,
							itmType: 'hisui-combobox'
						});
					});
				},
				checkbox: function (domId, domOpts) {
					var $curObj = $('#' + domId);
					if ($curObj.length == 0) {
						return;
					}
					$curObj.checkbox(domOpts);
				}
			}
			// 调用 - 初始化方法
			InitForm.start(_allFormOpts);
			if (PHA_COM.ResizePhaColParam.auto) {
				PHA_COM.ResizePhaCol();
			}
		},
		/*
		 * 按快组合键创建 (pha/com/v1/js/event.js中调用)
		 * PHA_SYS_SET.Form.Create();
		 */
		Create: function () {
			if (!PHA_SYS_SET.Com.CheckPermission('layoutMgr')) {
				return;
			}
			// var eleCodeJson = $.cm({
			var eleCodeJson = PHA_SYS_SET.Com.cm({
				ClassName: "PHA.SYS.Set.Query",
				MethodName: "GetEleCodeArr",
				parEleCode: PHA_SYS_SET.Form.CreateType,
				onlyCom: 'Y'
			}, false);
			if (eleCodeJson.success == 0) {
				PHA.Alert("提示", eleCodeJson.msg, -5);
				return;
			}
			var findClsData = {
				'hisui-validatebox': 'hisui-validatebox',
				'hisui-datebox': 'datebox-f',
				'hisui-timespinner': 'timespinner-f',
				'hisui-combobox': 'combobox-f',
				'hisui-checkbox': 'checkbox-f',
				'hisui-searchbox': 'searchbox-f',
				'hisui-radio': 'hisui-radio',
				'hisui-keywords': 'hisui-keywords',
				'hisui-combogrid': 'combogrid-f',
				'hisui-lookup': 'lookup'
			};
			var eleData = {};
			for (var iEleCode in eleCodeJson) {
				if (iEleCode == 'hisui-datagrid') {
					continue;
				}
				if (eleCodeJson[iEleCode].length == 0) {
					continue;
				}
				var findCls = findClsData[iEleCode];
				var $ele = $('.' + findCls);
				for (var j = 0; j < $ele.length; j++) {
					var oneEle = $ele[j];
					var _domId = oneEle.id;
					var _domName = oneEle.text;
					if (!_domId) {
						continue;
					}
					if (!_domName) {
						_domName = _domId;
					}
					if (_domId.indexOf('grid_set_') == 0) {
						continue; // TODO...
					}
					if (eleData[_domId]) {
						continue;
					}
					var clsStr = $('#' + _domId).attr('class');
					var huiCls = clsStr.split(' ')[0];
					var lblText = '';
					if (huiCls == 'hisui-linkbutton') {
						lblText = $('#' + _domId).text();
					} else {
						lblText = $("label[for='" + _domId + "']").text() || '';
						if (lblText == '') {
							var $lbl = $('#' + _domId).parent().prev();
							var $chl = $lbl.children();
							if ($chl.length == 0) {
								lblText = $lbl.text();
							} else {
								var chlTagName = $chl.eq(0).prop('tagName');
								if (typeof chlTagName != 'undefined' && chlTagName != 'INPUT') {
									lblText = $lbl.text();
								}
							}
						}
					}
					lblText = $.trim(lblText);
					if (lblText != "") {
						_domName = lblText;
					}
					var _domOptions = {}
					if (eleCodeJson[huiCls]) {
						var huiClsArr = huiCls.split('-');
						if (huiClsArr.length > 1) {
							var _huiKey = huiClsArr[1];
							var _tOptions = $('#' + _domId)[_huiKey]('options');
							for (var k in _tOptions) {
								if (eleCodeJson[huiCls].indexOf(k) >= 0) {
									_domOptions[k] = _tOptions[k];
								}
							}
						}
						var phaOptStr = $('#' + _domId).attr('data-pha') || '';
						var phaOpts = new Function('return {' + phaOptStr + '}')();
						if (phaOpts.requied || phaOpts.required) {
							_domOptions['required'] = true;
						}
					}
					eleData[_domId] = {
						ProCode: PHA_COM.App.ProCode || "",
						ProDesc: PHA_COM.App.ProDesc || "",
						Csp: PHA_SYS_SET.Com.GetCsp(),
						Name: PHA_SYS_SET.Com.GetName(),
						DomId: _domId,
						DomName: $.trim(_domName),
						DomOptions: _domOptions,
						SessionStr: PHA_COM.Session.ALL,
						EleCode: iEleCode
					};
				}
			}
			var eleDataStr = JSON.stringify(eleData);
			// 保存
			// $.m({
			PHA_SYS_SET.Com.cm({
				ClassName: "PHA.SYS.Set.Save",
				MethodName: "CreateDomDataByCfgMulti",
				pJsonStr: eleDataStr,
				dataType: 'text'
			}, function (retText) {
				// 判断状态
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("提示", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "生成成功，请到配置界面设置相关参数！",
					type: "success",
					timeout: 2000
				});
			});
		},
		/*
		 * 界面调用“清屏”按钮时,还原表单默认值
		 * PHA_SYS_SET.Form.ReSet();
		 */
		ReSet: function(_vObj, _outterId){
			_outterId = _outterId || '';
			if (_outterId != '' && $('#' + _outterId).length == 0) {
				return;
			}
			_vObj = _vObj || {};
			var _allFormOpts = PHA_COM.Param.Form;
			if (!_allFormOpts) {
				return;
			}
			for (var iDomId in _allFormOpts) {
				var formSelector = (_outterId == '') ? ('#' + iDomId) : ('#' + _outterId + ' #' + iDomId);
				var oneDomOpts = _allFormOpts[iDomId];
				var eleCode = oneDomOpts.eleCode;
				var huiKey = eleCode.split('-')[1];
				if (eleCode == 'hisui-checkbox') {
					var reSetVal = (typeof _vObj[iDomId] != 'undefined') ? _vObj[iDomId] : oneDomOpts.checked;
					if (reSetVal) {
						$(formSelector)[huiKey]('setValue', true);
					} else {
						$(formSelector)[huiKey]('setValue', false);
					}
					continue;
				}
				if (typeof oneDomOpts.value != 'undefined') {
					var reSetVal = (typeof _vObj[iDomId] != 'undefined') ? _vObj[iDomId] : oneDomOpts.value;
					if (eleCode == 'hisui-validatebox') {
						$(formSelector).val(reSetVal);
					} else if (eleCode == 'hisui-datebox') {
						$(formSelector)[huiKey]('setValue', PHA_UTIL.SysDate(reSetVal));
					} else if (eleCode == 'hisui-combobox') {
						PHA_SYS_SET.Com.SetComboDef(iDomId, reSetVal); // 2021-08-21. Huxt
					} else {
						$(formSelector)[huiKey]('setValue', reSetVal);
					}
				}
			}
		},
		/*
		 * 表单输入框设置默认值
		 * PHA_SYS_SET.Form.ValueSet.ShowMenu();
		 */
		ValueSet: {
			ShowMenu: function(_opts){
				if (!PHA_SYS_SET.Com.CheckPermission('layoutMgr')) {
					return;
				}
				var menuId = "PHA_SYS_SET_ValMenu";
				if ($('#' + menuId).length == 0) {
					var menuHtml = '';
					menuHtml += '<div id=' + menuId + ' class="hisui-menu" style="width: 135px; display: none;">';
					menuHtml += '	<div id="PHA_SYS_SET_ValMenu_Key" data-options="' + "iconCls:'icon-batch-cfg'" + '">设置默认值</div>';
					menuHtml += '</div>';
					$('body').append(menuHtml);
					$('#' + menuId).menu()
				}
				$('#' + menuId).menu('show', {
					left: event.pageX,
					top: event.pageY
				});
				$('#' + menuId).menu({
					onClick: function (item) {
						if (item.id == 'PHA_SYS_SET_ValMenu_Key') {
							PHA_SYS_SET.Form.ValueSet.Open(_opts);
						}
					}
				});
			},
			Open: function(_opts){
				var domId = _opts.domId || '';
				var domTxt = _opts.domTxt || '';
				var itmType = _opts.itmType || '';
				var pageItmId = PHA_SYS_SET.Com.GetPageItmId(domId, domTxt, itmType);
				if (pageItmId.split('^')[0] < 0 || pageItmId.indexOf('success') >= 0) {
					PHA.Alert("提示", "获取ID失败:" + pageItmId, -5);
					return;
				}
				var winId = 'PHA_SYS_SET_ValWin';
				var winTitle = '默认值设置';
				winTitle = (domTxt == '') ? winTitle : domTxt + ' - ' + winTitle;
				if ($('#' + winId).length == 0) {
					var winHtml = "";
					winHtml += "<div style='overflow:hidden'>";
					winHtml += "	<div class='pha-row'>";
					winHtml += "		<div class='pha-col'>";
					winHtml += "			<input id='PHA_SYS_SET_ValInput' class='hisui-validatebox' data-options='' style='width:300px' placeholder='请输入默认值...'></input>";
					winHtml += "		</div>";
					winHtml += "		<div class='pha-col'>";
					winHtml += "			<img id='PHA_SYS_SET_ValTips' src='../scripts_lib/hisui-0.1.0/dist/css/icons/tip.png' style='cursor:pointer;margin-top:5px;'>";
					winHtml += "		</div>";
					winHtml += "	</div>";
					winHtml += "	<div style='margin-top:15px;padding-right:28px;'>";
					winHtml += "		<center>" + PHA_SYS_SET.Com.GetTypeHtml() + "</center>";
					winHtml += "	</div>";
					winHtml += "</div>";
					$('body').append('<div id="' + winId + '"></div>');
					$('#' + winId).dialog({
						title: winTitle,
						collapsible: false,
						iconCls: "icon-w-config",
						border: false,
						closed: false,
						modal: true,
						width: 350,
						height: 180,
						content: winHtml,
						buttons: [{
								text: '保存',
								handler: function () {
									PHA_SYS_SET.Form.ValueSet.Save(winId);
								}
							}, {
								text: '关闭',
								handler: function () {
									$('#' + winId).dialog('close');
								}
							}
						]
					});
				}
				$('#' + winId).dialog('setTitle', winTitle);
				var dialogOpts = $('#' + winId).dialog('options');
				dialogOpts.domId = domId;
				dialogOpts.domTxt = domTxt;
				dialogOpts.itmType = itmType;
				dialogOpts.pageItmId = pageItmId;
				$('#' + winId).dialog('open');
				$('#PHA_SYS_SET_ValInput').focus();
				PHA_SYS_SET.Form.ValueSet.Query(winId);
			},
			Query: function(winId){
				var dialogOpts = $('#' + winId).dialog('options');
				var domId = dialogOpts.domId || '';
				var domTxt = dialogOpts.domTxt || '';
				var itmType = dialogOpts.itmType || '';
				var pageItmId = dialogOpts.pageItmId || '';
				var serverOpts = PHA_SYS_SET.Com.GetServerOpts(pageItmId);
				dialogOpts.val = serverOpts.value || "";
				dialogOpts.mSaveType = serverOpts.mSaveType || "";
				$("#PHA_SYS_SET_ValInput").val(serverOpts.defVal || serverOpts.value || "");
				var mSaveType = serverOpts.mSaveType || "";
				if (mSaveType != "") {
					PHA_SYS_SET.Com.SetSaveType(mSaveType);
				}
				var eleItmData = tkMakeServerCall('PHA.SYS.Set.Query', 'GetEleItmData', itmType, 'value');
				eleItmData = eval('(' + eleItmData + ')');
				$('#PHA_SYS_SET_ValTips').tooltip({
					title: eleItmData.memo,
					position: 'right',
					tipWidth: 240
				});
				$('#PHA_SYS_SET_ValTips').tooltip('update', eleItmData.memo);
			},
			Save: function(winId){
				var dialogOpts = $('#' + winId).dialog('options');
				var domId = dialogOpts.domId || '';
				var domTxt = dialogOpts.domTxt || '';
				var itmType = dialogOpts.itmType || '';
				var pageItmId = dialogOpts.pageItmId || '';
				var keyVal = $('#PHA_SYS_SET_ValInput').val() || "";
				var jsonData = {
					value: keyVal
				};
				var jsonDataStr = JSON.stringify(jsonData);
				var saveType = PHA_SYS_SET.Com.GetSaveType();
				PHA_SYS_SET.Com.cm({
					ClassName: "PHA.SYS.Set.Save",
					MethodName: "SavePageItmSet",
					pageItmId: pageItmId,
					pageItmSetOpts: jsonDataStr,
					saveType: saveType,
					sessionStr: PHA_COM.Session.ALL,
					dataType: 'text'
				}, function (retText) {
					var retArr = retText.split('^');
					if (retArr[0] < 0) {
						PHA.Alert("提示", retArr[1], retArr[0]);
						return;
					}
					PHA.Popover({
						msg: "保存成功，重新进入界面后生效！",
						type: "success",
						timeout: 1500
					});
					PHA_SYS_SET.Form.ValueSet.Query(winId);
				});
			}
		},
		/*
		 * 按钮右键 (pha/com/v1/js/event.js中调用)
		 * PHA_SYS_SET.Form.ButtonSet.ShowMenu();
		 */
		ButtonSet: {
			// 按钮右键时弹出“下拉菜单”
			ShowMenu: function (_domObj) {
				if (!PHA_SYS_SET.Com.CheckPermission('layoutMgr')) {
					return;
				}
				var menuId = "PHA_SYS_SET_BtnMenu";
				if ($('#' + menuId).length == 0) {
					var menuHtml = '';
					menuHtml += '<div id=' + menuId + ' class="hisui-menu" style="width: 135px; display: none;">';
					menuHtml += '	<div id="PHA_SYS_SET_BtnMenu_Key" data-options="' + "iconCls:'icon-batch-cfg'" + '">设置快捷键</div>';
					menuHtml += '	<div id="PHA_SYS_SET_BtnMenu_Tips" data-options="' + "iconCls:'icon-help'" + '">操作提示</div>';
					menuHtml += '</div>';
					$('body').append(menuHtml);
					$('#' + menuId).menu()
				}
				$('#' + menuId).menu('show', {
					left: event.pageX,
					top: event.pageY
				});
				$('#' + menuId).menu({
					onClick: function (item) {
						if (item.id == 'PHA_SYS_SET_BtnMenu_Key') {
							PHA_SYS_SET.Form.ButtonSet.Open(_domObj);
						}
						if (item.id == 'PHA_SYS_SET_BtnMenu_Tips') {
							PHA_SYS_SET.Form.ButtonSet.TipsWin(_domObj);
						}
					}
				});
			},
			// 点击“下拉菜单”弹出设置弹窗
			Open: function (_domObj) {
				var btn_id = _domObj.id;
				var btn_text = _domObj.text;
				btn_text = btn_text ? btn_text : btn_id;
				var pageItmId = PHA_SYS_SET.Com.GetPageItmId(btn_id, btn_text, 'hisui-linkbutton');
				if (pageItmId.split('^')[0] < 0 || pageItmId.indexOf('success') >= 0) {
					PHA.Alert("提示", "获取ID失败:" + pageItmId, -5);
					return;
				}
				// 打开弹窗
				var winId = 'PHA_SYS_SET_BtnWin';
				if ($('#' + winId).length == 0) {
					var winHtml = "";
					winHtml += "<div style='overflow:hidden'>";
					winHtml += "	<div style='padding-top:10px;padding-left:10px;padding-right:10px'>";
					winHtml += "		<div>";
					winHtml += "			<a id='PHA_SYS_SET_BtnWin_KeyTips' class='hisui-linkbutton' data-options='width:330,readonly:true' style='width:330px' title='快捷键格式: f2; ctrl+c; ctrl+alt+g...'>" + btn_text + " - " + "快捷键维护" + "</a>";
					winHtml += "		</div>";
					winHtml += "		<div>";
					winHtml += "			<input id='PHA_SYS_SET_BtnWin_KeyInput' class='hisui-validatebox' data-options='' style='width:323px' placeholder='请输入快捷键值...'></input>";
					winHtml += "		</div>";
					winHtml += "	</div>";
					winHtml += "	<div style='margin-top:15px;padding-right:28px;'>";
					winHtml += "		<center>" + PHA_SYS_SET.Com.GetTypeHtml() + "</center>";
					winHtml += "	</div>";
					winHtml += "</div>";
					$('body').append('<div id="' + winId + '"></div>');
					$('#' + winId).dialog({
						title: '快捷键设置',
						collapsible: false,
						iconCls: "icon-w-config",
						border: false,
						closed: false,
						modal: true,
						width: 350,
						height: 200,
						content: winHtml,
						buttons: [{
								text: '保存',
								handler: function () {
									PHA_SYS_SET.Form.ButtonSet.Save(winId);
								}
							}, {
								text: '关闭',
								handler: function () {
									$('#' + winId).dialog('close');
								}
							}
						]
					});
				}
				$('#PHA_SYS_SET_BtnWin_KeyTips').children().eq(0).children().eq(0).html(btn_text + " - " + "快捷键维护");
				var dialogOpts = $('#' + winId).dialog('options');
				dialogOpts.btn_id = btn_id;
				dialogOpts.btn_text = btn_text;
				dialogOpts.pageItmId = pageItmId;
				$('#' + winId).dialog('open');
				
				$("#PHA_SYS_SET_BtnWin_KeyInput").focus();
				$("#PHA_SYS_SET_BtnWin_KeyInput").on('keydown', function(e){
					e.stopPropagation();
					var oldVal = $(this).val();
					if (e.keyCode == 8) {
						var oldValArr = oldVal.split('+');
						oldValArr.length = oldValArr.length - 1;
						setTimeout(function(){
							$("#PHA_SYS_SET_BtnWin_KeyInput").val(oldValArr.join('+'));
						}, 5);
						return;
					}
					var keyStr = '';
					if (e.keyCode >= 48 && e.keyCode <= 57) {
						keyStr = (e.keyCode - 48).toString();
					} else if (e.keyCode >= 65 && e.keyCode <= 90) {
						keyStr = String.fromCharCode(e.keyCode);
					} else if (e.keyCode >= 112 && e.keyCode <= 135) {
						keyStr = 'f' + (e.keyCode - 111);
					} else {
						var _kObj = {
							188: ','
						};
						var _kStr = '8:backspace,9:tab,12:clear,13:enter,27:esc,32:space,37:left,38:up,39:right,40:down,46:delete,45:insert,36:home,35:end,33:pageup,34:pagedown,20:capslock,16:shift,18:alt,17:ctrl,224:cmd,91:cmd,190:.,191:/,192:`,173:-,189:-,61:=,187:=,59:;,186:;,222:\',219:[,221:],220:\\,225:\\';
						var _kArr = _kStr.split(',');
						for (var i = 0; i < _kArr.length; i++) {
							_kObj[_kArr[i].split(':')[0]] = _kArr[i].split(':')[1];
						}
						keyStr = _kObj[e.keyCode] || '';
					}
					if (keyStr == '' && (e.keyCode < 65 || e.keyCode > 90)) {
						return;
					}
					keyStr = keyStr.toLowerCase();
					keyStr = oldVal == '' ? keyStr : oldVal + '+' + keyStr;
					setTimeout(function(){
						$("#PHA_SYS_SET_BtnWin_KeyInput").val(keyStr);
					}, 5);
				});
				PHA_SYS_SET.Form.ButtonSet.Query(winId);
			},
			// 查询 - 快捷键
			Query: function (_winId) {
				var dialogOpts = $('#' + _winId).dialog('options');
				var btn_id = dialogOpts.btn_id;
				var btn_text = dialogOpts.btn_text;
				var pageItmId = dialogOpts.pageItmId;
				var serverOpts = PHA_SYS_SET.Com.GetServerOpts(pageItmId);
				dialogOpts.hotkey = serverOpts.hotkey || ""; // 传递值hotkey
				dialogOpts.mSaveType = serverOpts.mSaveType || ""; // 传递值mSaveType
				$("#PHA_SYS_SET_BtnWin_KeyInput").val(serverOpts.hotkey || "");
				var mSaveType = serverOpts.mSaveType || "";
				if (mSaveType != "") {
					PHA_SYS_SET.Com.SetSaveType(mSaveType);
				}
			},
			// 保存 - 快捷键
			Save: function (_winId) {
				// 数据
				var dialogOpts = $('#' + _winId).dialog('options');
				var btn_id = dialogOpts.btn_id;
				var btn_text = dialogOpts.btn_text;
				var pageItmId = dialogOpts.pageItmId;
				var oldHotkey = dialogOpts.hotkey;
				// 快捷键值
				var keyVal = $('#PHA_SYS_SET_BtnWin_KeyInput').val() || "";
				var jsonData = {
					hotkey: keyVal
				};
				var jsonDataStr = JSON.stringify(jsonData);
				// 保存权限
				var saveType = PHA_SYS_SET.Com.GetSaveType();
				// 保存
				// $.m({
				PHA_SYS_SET.Com.cm({
					ClassName: "PHA.SYS.Set.Save",
					MethodName: "SavePageItmSet",
					pageItmId: pageItmId,
					pageItmSetOpts: jsonDataStr,
					saveType: saveType,
					sessionStr: PHA_COM.Session.ALL,
					dataType: 'text'
				}, function (retText) {
					// 判断状态
					var retArr = retText.split('^');
					if (retArr[0] < 0) {
						PHA.Alert("提示", retArr[1], retArr[0]);
						return;
					}
					PHA.Popover({
						msg: "保存成功，重新进入界面后生效！",
						type: "success",
						timeout: 1500
					});
					// 刷新
					PHA_SYS_SET.Form.ButtonSet.Query(_winId);
				});
			},
			TipsWin: function (_domObj) {
				var btn_id = _domObj.id;
				var btn_text = _domObj.text;
				btn_text = btn_text ? btn_text : btn_id;
				var pageItmId = PHA_SYS_SET.Com.GetPageItmId(btn_id, btn_text, 'hisui-linkbutton');
				if (pageItmId.split('^')[0] < 0 || pageItmId.indexOf('success') >= 0) {
					PHA.Alert("提示", "获取ID失败:" + pageItmId, -5);
					return;
				}
				var serverOpts = PHA_SYS_SET.Com.GetServerOpts(pageItmId);
				var tips = serverOpts.tips || "";
				if (tips == "") {
					tips = "未维护提示信息！";
				}
				var contentStr = "";
				contentStr += "<div style='margin:10px;'>";
				contentStr += "	" + tips;
				contentStr += "</div>";
				var winId = "PHA_SYS_SET_BtnWin_TipsWin";
				if ($('#' + winId).length == 0) {
					$('body').append('<div id="' + winId + '"></div>');
				}
				$('#' + winId).dialog({
					title: '按钮操作提示',
					collapsible: false,
					iconCls: "icon-w-list",
					border: false,
					closed: false,
					modal: true,
					width: 450,
					height: 350,
					content: contentStr,
					buttons: [{
							text: '关闭',
							handler: function () {
								$('#' + winId).dialog('close');
							}
						}
					]
				});
				$('#' + winId).dialog('open');
			}
		}
	},

	/*
	 * 页面表格设置相关 (包含列设置、分页、行数、斑马线)
	 * 依赖js: pha/sys/v1/colset.win.js, 此js在pha.js中动态加载
	 */
	Grid: {
		/*
		 * 表格初始化 (pha/com/v1/js/pha.js中调用)
		 * PHA_SYS_SET.Grid.Init();
		 */
		Init: function (_gridID, _gridOptions, _fn) {
			if (_gridOptions.gridSave === false) {
				PHA.setEditorField && PHA.setEditorField(_gridID, _gridOptions.columns, _gridOptions.frozenColumns);
				_fn(_gridOptions);
				return;
			}
			if (!_gridOptions.columns) {
				PHA.setEditorField && PHA.setEditorField(_gridID, _gridOptions.columns, _gridOptions.frozenColumns);
				_fn(_gridOptions);
				return;
			}
			var appCsp = PHA_SYS_SET.Com.GetCsp();
			if (appCsp == "") {
				PHA.setEditorField && PHA.setEditorField(_gridID, _gridOptions.columns, _gridOptions.frozenColumns);
				_fn(_gridOptions);
				return;
			}
			_gridOptions.queryParams = _gridOptions.queryParams || {};
			// 回车跳转顺序
			var _fieldEnterSort = {};
			var editFieldSort = _gridOptions.editFieldSort || [];
			for (var e = 0; e < editFieldSort.length; e++) {
				_fieldEnterSort[editFieldSort[e]] = e + 1;
			}
			// 所有的列
			var oldCols = _gridOptions.columns[0];
			var oldFrozenCols = _gridOptions.frozenColumns ? _gridOptions.frozenColumns[0] : [];
			var oldAllCols = PHA_SYS_SET.Com.GetMergeCols(oldCols, oldFrozenCols, _fieldEnterSort);
			// 请求参数
			var reqParams = this.GetGridReqOpts(_gridID, _gridOptions, oldAllCols);
			var reqParamsStr = JSON.stringify(reqParams);
			// 同步获取后台
			var serverGridOpts = PHA_SYS_SET.Com.GetConfigSync({
				ClassName: "PHA.SYS.Set.Query",
				MethodName: "GridOptions",
				pJsonStr: reqParamsStr
			});
			if (serverGridOpts.success == 0) {
				console.log("Grid:获取[表格]配置失败！" + " Error:" + serverGridOpts.msg);
				PHA.setEditorField && PHA.setEditorField(_gridID, _gridOptions.columns, _gridOptions.frozenColumns);
				_fn(_gridOptions);
				return;
			}
			// 重组gridOptions数据
			var oldColObj = {};
			for (var c = 0; c < oldAllCols.length; c++) {
				var oCol = oldAllCols[c];
				oldColObj[oCol.field] = oCol;
			}
			var isTrans = (_gridOptions.isTrans === true) && (typeof $g == 'function');
			var pKeyArr = ['ClassName', 'QueryName', 'MethodName', 'totalFields', 'totalFooter'];
			for (var k in serverGridOpts) {
				// 列属性
				if (k == "columns" || k == "frozenColumns") {
					var newCols = serverGridOpts[k][0];
					for (var c = 0; c < newCols.length; c++) {
						var nCol = newCols[c];
						nCol.lineHeight = 24; // 统一处理某些IE版本不显示下划线  TODO...
						var oCol = oldColObj[nCol.field];
						if (oCol) {
							for (var m in oCol) {
								if (typeof nCol[m] == "undefined") {
									nCol[m] = oCol[m]; // 使用js定义的
								}
							}
						}
						if (nCol.formatter) {
							try {
								nCol.formatter = eval(nCol.formatter);  // 字符串转函数
							} catch (e) {}
						}
						if (nCol.styler) {
							try {
								nCol.styler = eval(nCol.styler);  // 字符串转函数
							} catch (e) {}
						}
						if (nCol.editor && nCol.editor.options) {
							nCol.editor.options.gridID = _gridID;  // 表格编辑器附加信息. Huxt 2022-03-13
							nCol.editor.options.field = nCol.field;
							nCol.editor.options.descField = nCol.descField;
						}
						if (isTrans) {
							nCol.title = $g(nCol.title); // 老版本easyui翻译
						}
						if (PHA_SYS_SET.Com.hasHtml(nCol.title)) {
							nCol.title = oCol.title; // 已翻译. Huxt 2022-12-20
						}
					}
					_gridOptions[k] = serverGridOpts[k];
					continue;
				}
				// 请求参数属性
				if (pKeyArr.indexOf(k) >= 0) {
					_gridOptions.queryParams[k] = serverGridOpts[k];
					continue;
				}
				// 其他属性
				_gridOptions[k] = serverGridOpts[k];
			}
			_fn(_gridOptions);
		},
		InitJqGrid: function(_gridID, _gridOptions, _fn){
			var colModel = _gridOptions.colModel;
			if (_gridOptions.gridSave === false) {
				_fn(_gridOptions);
				return;
			}
			if (!colModel) {
				_fn(_gridOptions);
				return;
			}
			var appCsp = PHA_SYS_SET.Com.GetCsp();
			if (appCsp == "") {
				_fn(_gridOptions);
				return;
			}
			var oldColObj = {};
			for (var c = 0; c < colModel.length; c++) {
				var iColModel = colModel[c];
				iColModel.title = iColModel.header;
				iColModel.field = iColModel.name || iColModel.index;
				oldColObj[iColModel.field] = iColModel;
			}
			_gridOptions.queryParams = _gridOptions.queryParams || {};
			_gridOptions.isReCreate = true;  // 每次进入界面都更新列信息
			var reqParams = this.GetGridReqOpts(_gridID, _gridOptions, colModel);
			var reqParamsStr = JSON.stringify(reqParams);
			// 同步获取后台
			var serverGridOpts = PHA_SYS_SET.Com.GetConfigSync({
				ClassName: "PHA.SYS.Set.Query",
				MethodName: "GridOptions",
				pJsonStr: reqParamsStr
			});
			if (serverGridOpts.success == 0) {
				console.log("Grid:获取[表格]配置失败！" + " Error:" + serverGridOpts.msg);
				_fn(_gridOptions);
				return;
			}
			// 重置列信息
			var serverColNames = [];
			var serverColumns = serverGridOpts.columns[0];
			for (var c = 0; c < serverColumns.length; c++) {
				var nCol = serverColumns[c];
				nCol.header = nCol.title;
				nCol.index = nCol.field;
				nCol.name = nCol.field;
				nCol.sortable = nCol.sortable == 1 ? true : false;
				nCol.hidden = nCol.hidden == 1 ? true : false;
				serverColNames.push(typeof $g == 'function' ? $g(nCol.header) : nCol.header);
				var oCol = oldColObj[nCol.field];
				if (oCol) {
					for (var m in oCol) {
						if (typeof nCol[m] == "undefined") {
							nCol[m] = oCol[m];
						}
					}
				}
			}
			_gridOptions.colModel = serverColumns;
			_gridOptions.colNames = serverColNames;
			_gridOptions.pageItmId = serverGridOpts.pageItmId;
			// 回调初始化
			_fn(_gridOptions);
		},
		OpenJqGrid: function(_gridID){
			var pageItmId = '';
			var $_dg = $('#' + _gridID);
			if ($_dg.parent().hasClass('datagrid-view')) {
				var dgOpts = $_dg.datagrid('options');
				pageItmId = dgOpts.pageItmId || '';
			} else {
				pageItmId = $_dg.jqGrid('getGridParam', 'pageItmId');
			}
			if (!pageItmId || pageItmId == '') {
				return;
			}
			var url = 'pha.com.v1.gridcolset.csp?pageItmId=' + pageItmId;
			if (typeof websys_showModal == 'undefined') {
				var _winHeight = 530;
				var _winWidth = 893;
				var _winTop = parseInt((window.innerHeight - _winHeight + 60) / 2);
				var _winLeft = parseInt((window.innerWidth - _winWidth) / 2);
				window.open(url, 'PAGEITEM-' + pageItmId, 'height=' + _winHeight + ', width=' + _winWidth + ', top=' + _winTop + ', left=' + _winLeft + ', toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
			} else {
				var _winHeight = 577;
				var _winWidth = 897;
				websys_showModal({
					url: url,
					title: '表格列设置',
					iconCls: "icon-w-list",
					width: _winWidth,
					height: _winHeight,
					resizable: false
				});
			}
		},
		/*
		 * 用户双击表头弹出表格设置窗口 (pha/com/v1/js/pha.js中调用)
		 * PHA_SYS_SET.Grid.Open();
		 */
		Open: function (_gridID) {
			if (!PHA_SYS_SET.Com.CheckPermission('columnMgr')) {
				return;
			}
			PHA_SYS_SET.Com.InitCss();
			var gridOpts = $('#' + _gridID).datagrid('options');
			var pageItmId = gridOpts.pageItmId || "";
			if (pageItmId == "") {
				return PHA.Popover({
					msg: "当前表格未启用列设置",
					type: "alert"
				});
			}
			var serverOpts = PHA_SYS_SET.Com.GetServerOpts(pageItmId);
			var pageItmSetId = serverOpts.colsSetId || "";
			var clsName = serverOpts.ClassName || "";
			var quyName = serverOpts.QueryName || "";
			if (pageItmSetId == "") {
				return PHA.Popover({
					msg: "当前表格未启用列设置",
					type: "alert"
				});
			}
			serverOpts.gridID = _gridID;
			serverOpts.pageItmId = pageItmId;
			// 表格列信息维窗口 - 公共
			var inputStr = PHA_SYS_SET.PISTable + "^" + pageItmSetId + "^" + clsName + "^" + quyName;
			COLSET_WIN.Open({
				// 初始信息
				showGridInfo: true,
				serverOpts: serverOpts,
				// 列信息 - 查询
				queryParams: {
					ClassName: 'PHA.SYS.Col.Query',
					QueryName: 'PHAINCol',
					inputStr: inputStr
				},
				// 列信息 - 保存
				onClickSave: function (initOpts, gridColsData, gridOptsData, saveType) {
					// 先验证一下pageItmId是否正常 (以防万一)
					var gridID = initOpts.serverOpts.gridID || "";
					var pageItmId = initOpts.serverOpts.pageItmId || "";
					var firstCol = gridColsData[0];
					var colPointer = firstCol.ColPointer;
					var colPointerArr = colPointer.split('||');
					var cPageItmId = colPointerArr[0] + "||" + colPointerArr[1];
					if (pageItmId != cPageItmId) {
						PHA.Popover({
							msg: "页面元素ID不一致，不能保存！",
							type: "alert"
						});
						return;
					}
					// 转换需要保存的数据
					if (saveType == "") {
						PHA.Popover({
							msg: "请选择保存类型：用户/安全组/科室/医院!",
							type: "alert"
						});
						return;
					}
					var jsonColsStr = JSON.stringify(gridColsData);
					var jsonOptsStr = JSON.stringify(gridOptsData);
					
					// 开始保存
					// $.m({
					PHA_SYS_SET.Com.cm({
						ClassName: "PHA.SYS.Set.Save",
						MethodName: "SaveGridData",
						jsonOptsStr: jsonOptsStr,
						jsonColsStr: jsonColsStr,
						saveType: saveType,
						sessionStr: PHA_COM.Session.ALL,
						dataType: 'text'
					}, function (retText) {
						// 判断状态
						var retArr = retText.split('^');
						if (retArr[0] < 0) {
							PHA.Alert("提示", retArr[1], retArr[0]);
							return;
						}
						PHA.Popover({
							msg: "保存成功，重新进入界面后生效！",
							type: "success",
							timeout: 1500
						});
						// 在initOpts中更新queryParams
						pageItmSetId = retText;
						var oldParamStr = initOpts.queryParams.inputStr;
						var oldParamArr = oldParamStr.split('^');
						oldParamArr[1] = pageItmSetId;
						var newParamStr = oldParamArr.join('^');
						initOpts.queryParams.inputStr = newParamStr;
						// 在initOpts中更新serverOpts
						var newServerOpts = PHA_SYS_SET.Com.GetServerOpts(pageItmId);
						newServerOpts.gridID = gridID;
						newServerOpts.pageItmId = pageItmId;
						initOpts.serverOpts = newServerOpts;
						initOpts.serverOpts.mSaveType = saveType;
						// 查询
						COLSET_WIN.Query();
						COLSET_WIN.QueryGridInfo();
					});
				},
				// 列信息 - 删除
				onClickDelete: function (initOpts, selectedRow, colId) {
					// $.m({
					PHA_SYS_SET.Com.cm({
						ClassName: "PHA.SYS.Col.Save",
						MethodName: "Delete",
						Id: colId,
						dataType: 'text'
					}, function (retText) {
						var retArr = retText.split('^');
						if (retArr[0] < 0) {
							PHA.Alert("提示", retArr[1], retArr[0]);
							return;
						}
						PHA.Popover({
							msg: "删除成功!",
							type: "success"
						});
						COLSET_WIN.Query();
					});
				}
			});
		},
		/*
		 * 开发者在js中修改了grid信息手动同步到后台 (pha/com/v1/js/event.js中调用)
		 * PHA_SYS_SET.Grid.SyncCols();
		 * 2021-08-19 Huxt. 修改为同步表格信息和列信息,将原来的[仅新增]修改为[新增和修改]
		 */
		SyncCols: function(){
			if (!PHA_SYS_SET.Com.CheckPermission('columnMgr')) {
				return;
			}
			var jsAllGridOpts = PHA_SYS_SET.JsGridOptions;
			if (jsAllGridOpts.length == 0) {
				PHA.Popover({
					msg: "没有需要同步的表格数据！",
					type: "alert"
				});
				return;
			}
			var jsAllGridOptsStr = JSON.stringify(jsAllGridOpts);
			// $.m({
			PHA_SYS_SET.Com.cm({
				ClassName: "PHA.SYS.Set.Save",
				MethodName: "SyncGridOptions",
				pJsonStr: jsAllGridOptsStr,
				dataType: 'text'
			}, function (retText) {
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("提示", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "同步成功，重新进入界面后生效，您也可以在设置界面查看！",
					type: "success",
					timeout: 2000
				});
			});
		},
		/**
		 * 获取表格的请求参数
		 * _gridID: 表格参数
		 * _gridOptions: js中定义的表格信息
		 * _jsAllCols: js中定义的列信息
		 */
		GetGridReqOpts: function(_gridID, _gridOptions, _jsAllCols) {
			var reqParams = {
				ProCode: PHA_COM.App.ProCode || "",
				ProDesc: PHA_COM.App.ProDesc || "",
				Csp: PHA_SYS_SET.Com.GetCsp(),
				Name: PHA_SYS_SET.Com.GetName(),
				DomId: _gridID,
				DomName: _gridOptions.gridName || "",
				DomOptions: {
					columns: _jsAllCols,
					ClassName: _gridOptions.queryParams.ClassName || "",
					QueryName: _gridOptions.queryParams.QueryName || "",
					MethodName: _gridOptions.queryParams.MethodName || "",
					pagination: (_gridOptions.pagination == false ? false : true),
					pageList: (_gridOptions.pageList || []).join(','),
					pageSize: _gridOptions.pageSize || 30,
					striped: _gridOptions.striped || false,
					nowrap: (_gridOptions.nowrap == false ? false : true),
					rownumbers: _gridOptions.rownumbers || false,
					fitColumns: _gridOptions.fitColumns || false,
					//showContextMenu: _gridOptions.showContextMenu || false,  // 停用. 2022-06-01
					exportChkCol: _gridOptions.exportChkCol || false,
					exportXls: _gridOptions.exportXls || false,
					printChkCol: _gridOptions.printChkCol || false,
					printOut: _gridOptions.printOut || false,
					showComCol: _gridOptions.showComCol
				},
				SessionStr: PHA_COM.Session.ALL,
				EleCode: 'hisui-datagrid',
				isReCreate: (_gridOptions.isReCreate === true ? 'Y' : 'N')
			};
			PHA_SYS_SET.JsGridOptions.push(reqParams); // js定义的缓存
			return reqParams;
		}
	},
	/*
	 * 公共
	 */
	Com: {
		// 授权方式 (初始化/取值/赋值)
		GetTypeHtml: function (_radioName) {
			_radioName = _radioName || "PHA_SYS_SET_Win_Type";
			var typeHtml = "";
			typeHtml += "<div class='pha-col'>";
			typeHtml += "	<input class='hisui-radio' type='radio' label='用户' name='" + _radioName + "' value='U' data-options='requiredSel:true' />";
			typeHtml += "</div>";
			typeHtml += "<div class='pha-col' style='margin-left:8px;'>";
			typeHtml += "	<input class='hisui-radio' type='radio' label='安全组' name='" + _radioName + "' value='G' data-options='requiredSel:true' />";
			typeHtml += "</div>";
			typeHtml += "<div class='pha-col' style='margin-left:8px;'>";
			typeHtml += "	<input class='hisui-radio' type='radio' label='科室' name='" + _radioName + "' value='L' data-options='requiredSel:true' />";
			typeHtml += "</div>";
			typeHtml += "<div class='pha-col' style='margin-left:8px;margin-right:12px;'>";
			typeHtml += "	<input class='hisui-radio' type='radio' label='医院' name='" + _radioName + "' value='A' data-options='requiredSel:true,checked:true' />";
			typeHtml += "</div>";
			return typeHtml;
		},
		GetSaveType: function (_radioName) {
			_radioName = _radioName || "PHA_SYS_SET_Win_Type";
			var checkedRadioObj = $("input[name='" + _radioName + "']:checked");
			var authType = checkedRadioObj == undefined ? "" : checkedRadioObj.val();
			if (authType == "" || authType == undefined) {
				return "";
			}
			return authType;
		},
		SetSaveType: function (authType, _radioName) {
			_radioName = _radioName || "PHA_SYS_SET_Win_Type";
			var $_radio = $("input[name='" + _radioName + "'][value='" + authType + "']");
			if ($_radio.length > 0) {
				$_radio.radio('setValue', true);
			}
		},
		// 合并列
		GetMergeCols: function (cols, frozenCols, _fieldEnterSort) {
			var oncCol = null;
			var newCols = [];
			for (var c = 0; c < frozenCols.length; c++) {
				oncCol = frozenCols[c];
				if (oncCol.checkbox == true) {
					oncCol.title = oncCol.title || oncCol.field;
					oncCol.width = 28;
					oncCol.ifExport = 0;
				}
				var enterSort = parseInt(_fieldEnterSort[oncCol.field]);
				if (enterSort > 0) {
					oncCol.enterSort = enterSort;
				}
				oncCol.frozen = 1;
				newCols.push(oncCol)
			}
			for (var c = 0; c < cols.length; c++) {
				oncCol = cols[c];
				if (oncCol.checkbox == true) {
					oncCol.title = oncCol.title || oncCol.field;
					oncCol.width = 28;
					oncCol.ifExport = 0;
				}
				var enterSort = parseInt(_fieldEnterSort[oncCol.field]);
				if (enterSort > 0) {
					oncCol.enterSort = enterSort;
				}
				oncCol.frozen = 0;
				newCols.push(oncCol)
			}
			return newCols;
		},
		// 根据domId获取表ID(pageItmId)
		GetPageItmId: function (_domId, _domName, _eleCode) {
			var appCsp = PHA_SYS_SET.Com.GetCsp();
			if (appCsp == "") {
				return "";
			}
			if (!_domName) {
				_domName = _domId;
			}
			var pJson = {
				ProCode: PHA_COM.App.ProCode || "",
				ProDesc: PHA_COM.App.ProDesc || "",
				Csp: PHA_SYS_SET.Com.GetCsp(),
				Name: PHA_SYS_SET.Com.GetName(),
				DomId: _domId,
				DomName: _domName,
				SessionStr: PHA_COM.Session.ALL,
				EleCode: _eleCode
			};
			var pJsonStr = JSON.stringify(pJson); ;
			// var pageItmId = $.m({
			var pageItmId = PHA_SYS_SET.Com.cm({
				ClassName: "PHA.SYS.Set.Query",
				MethodName: "jsGetPageItmId",
				pJsonStr: pJsonStr,
				dataType: 'text'
			}, false);
			return pageItmId;
		},
		// 字符串转对象
		string2Object: function (jsonStr) {
			try {
				var obj = eval('(' + jsonStr + ')'); // 返回code^desc格式的数据直接不处理
				return obj;
			} catch (e) {
				return {
					success: 0,
					message: e.message + ", jsonStr:" + jsonStr
				};
			}
		},
		// 获取某个元素的配置
		GetServerOpts: function (pageItmId) {
			// var retJsonStr = $.m({
			var retJsonStr = PHA_SYS_SET.Com.cm({
				ClassName: "PHA.SYS.Set.Query",
				MethodName: "jsGetPageItmSetByPri",
				pageItmId: pageItmId,
				sessionStr: PHA_COM.Session.ALL,
				dataType: 'text'
			}, false);
			var retJson = {};
			try {
				retJson = eval('(' + retJsonStr + ')');
			} catch (e) {}
			return retJson;
		},
		// 设置下拉框默认值
		SetComboDef: function (_domId, _defVal) {
			var defVal = _defVal || '';
			if (defVal == '') {
				return;
			}
			var defValArr = defVal.split(',');
			var allDefValArr = [];
			for (var l = 0; l < defValArr.length; l++) {
				allDefValArr.push(defValArr[l]);
			}
			for (var l = 0; l < defValArr.length; l++) {
				var iDefVal = defValArr[l];
				var sessionVal = session['LOGON.' + iDefVal];
				if (typeof sessionVal == 'undefined' || sessionVal == null) {
					continue;
				}
				allDefValArr.push(sessionVal);
			}
			PHA.SetComboVal(_domId, allDefValArr);
		},
		// 获取界面csp
		GetCsp: function () {
			if (PHA_SYS_SET.Csp) {
				return PHA_SYS_SET.Csp;
			}
			var pageCsp = "";
			if (typeof PHA_COM.App.Csp == "string" && PHA_COM.App.Csp != "") {
				pageCsp = PHA_COM.App.Csp;
			}
			if (typeof App_MenuCsp == "string" && App_MenuCsp != "") {
				pageCsp = App_MenuCsp;
			}
			PHA_SYS_SET.Csp = pageCsp;
			return pageCsp;
		},
		// 获取界面名称
		GetName: function () {
			if (PHA_SYS_SET.Name) {
				return PHA_SYS_SET.Name;
			}
			var pageName = "";
			if (typeof PHA_COM.App.Name == "string" && PHA_COM.App.Name != "") {
				pageName = PHA_COM.App.Name;
			}
			if (typeof App_MenuName == "string" && App_MenuName != "") {
				pageName = App_MenuName;
			}
			PHA_SYS_SET.Name = pageName;
			return pageName;
		},
		InitCss: function(_options){
			if (!$('#pha-sys-set-panel-body').length){
				$('head').append(
					'<style id="pha-sys-set-panel-body">' +
					'.panel-body, .panel-header {border-color: #d1d6da;}' +
					'</style>'
				);
			}
		},
		// 同步获取配置
		GetConfigSync: function(_postData){
			var retJson = PHA_SYS_SET.Com.cm(_postData, false);
		    return retJson;
		},
		CheckPermission: function(type, notShowTips){
			if (PHA_COM.Param[type] != 'Y') {
				if (notShowTips) {
					return false;
				}
				var type_obj = {
					'layoutMgr': '允许使用界面编辑器',
					'columnMgr': '允许使用列编辑器'
				}
				var typeDesc = type_obj[type] || '';
				PHA.Alert("温馨提示", "安全组未开启“" + typeDesc + "”的权限！<br/>如需使用请联系管理员到[基础数据平台-基础数据-安全组-安全组设置]界面设置！", -1);
				return false;
			}
			return true;
		},
		/*
		 * 解绑按钮的事件 (在pha/sys/v1/js/pha.js中调用)
		 * PHA_SYS_SET.Com.UnbindEvent();
		 */
		UnbindEvent: function(){
			var unbindIdArr = PHA_SYS_SET.UnbindIdArr;
			var unbindIdLen = unbindIdArr.length;
			for (var u = 0; u < unbindIdLen; u++) {
				$('#' + unbindIdArr[u]).unbind();
			}
			return;
		},
		/*
		 * 重新定义请求后台的方法
		 * 因为websys.Broker.cls不能接收部分关键字(如:object/pointer/...),修改为web.DHCST.Common.ActionURL.cls
		 * PHA_SYS_SET.Com.cm();
		 */
		cm: function(_dataOptions, successFn, errorFn){
			var runRet = null;
			var p_async = (successFn == false) ? false : true;
			var p_dataType = _dataOptions.dataType || 'json';
			$.ajax({
				url: "web.DHCST.Common.ActionURL.cls",
				type: "post",
				async: p_async,
				dataType: p_dataType,
				data: _dataOptions,
				success: function(retData){
					runRet = retData;
					successFn && successFn(runRet);
				},
				error: function(xhr){
					if (p_dataType == 'json') {
						runRet = {
							success: 0,
							msg: xhr.responseText,
							xhr: xhr
						};
					} else {
						runRet = xhr.responseText
					}
					errorFn && errorFn(runRet);
				}
		    });
		    return runRet;
		},
		/*
		 * 开发者删除整个页面配置信息，包含表格、列、表单等等 (pha/com/v1/js/event.js中调用)
		 * PHA_SYS_SET.Com.DeletePageCfg();
		 */
		DeletePageCfg: function(){
			var pageCsp = PHA_SYS_SET.Com.GetCsp();
			// $.m({
			PHA_SYS_SET.Com.cm({
				ClassName: "PHA.SYS.Set.Save",
				MethodName: "DeletePageCfg",
				pageCsp: pageCsp,
				dataType: 'text'
			}, function (retText) {
				var retArr = retText.split('^');
				if (retArr[0] < 0) {
					PHA.Alert("提示", retArr[1], retArr[0]);
					return;
				}
				PHA.Popover({
					msg: "删除成功，重新进入页面后生效！",
					type: "success",
					timeout: 2000
				});
			});
		},
		/*
		 * 浏览器缩放比例
		 * PHA_SYS_SET.Com.detectZoom();
		 */
		detectZoom: function() {
			var ratio = 0,
			screen = window.screen,
			ua = navigator.userAgent.toLowerCase();
			if (window.devicePixelRatio !== undefined) {
				ratio = window.devicePixelRatio;
			} else if (~ua.indexOf('msie')) {
				if (screen.deviceXDPI && screen.logicalXDPI) {
					ratio = screen.deviceXDPI / screen.logicalXDPI;
				}
			} else if (window.outerWidth !== undefined && window.innerWidth !== undefined) {
				ratio = window.outerWidth / window.innerWidth;
			}
			if (ratio) {
				ratio = Math.round(ratio * 100);
			}
			return ratio;
		},
		/*
		 * 检查字符串是否包含html标签
		 * PHA_SYS_SET.Com.hasHtml();
		 */
		hasHtml: function (inputStr) {
		    var  reg = /<[^>]+>/g;
		    return reg.test(inputStr);
		}
	}
}
