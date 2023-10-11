/*
 * @Descripttion: 编辑器
 * @Author: yaojining
 */

$(function () {
	initEditor();
	listenEvents();
});

/**
 * @description: 初始化元素
 */
function initEditor() {
	$('span:has(.group-el)').attr('contenteditable', 'false');
	$('span:has(.group-el),span:has(.single-el)').hover(
		function () {
			$('#editor').attr('contenteditable', 'false');
			return false;
		},
		function () {
			$('#editor').attr('contenteditable', 'true');
			return false;
		}
	);
}

/**
 * @description: 删除Dom元素
 * @param {*} ele
 */
function del(ele) {
	var range = document.createRange();
	range.selectNode(ele);
	range.deleteContents();
}

/**
 * @description: 删除字符串
 * @param {*} ele
 */
function delStr(ele) {
	var cursorIndex = getCursortPosition(ele);
	if (cursorIndex < 1) {
		$('#editor').attr('contenteditable', 'true');
		if ((ele.nodeName == 'SPAN') || ((!!ele.nodeValue) && (ele.nodeValue.indexOf('\n\t') > -1))) {
			del(ele);
			return;
		} else {
			console.log(cursorIndex);
			return;
		}
	} else {
		$('#editor').attr('contenteditable', 'false');
	}
	var range = document.createRange();
	if (cursorIndex < 1) {
		console.log('小于0：' + cursorIndex)
	}
	if (ele.id == 'editor') {
		return;
	}
	range.setStart(ele, cursorIndex - 1);
	range.setEnd(ele, cursorIndex);
	range.deleteContents();
}

/**
 * @description: 设置预览内容
 * @param {*} content
 * @param {*} flag
*/
function setContent(content, flag) {
	if (flag == 0) {
		clearView();
	}
	$('#editor').append(content);
}

/**
 * @description: 加载知识库具体内容
 * @param {obj} content
 */
function loadContent(content) {
	var html = '';
	if (JSON.parse(GV.SwitchInfo.KnowWindow)) {
		$.each(content, function (i, c) {
			html += createHtml(c);
		});
		setContent(html, 0);
		bindClick(content);
	} else {
		$.each(content, function (i, c) {
			html += buildDom(c);
		});
		if (!!html) {
			setContent(html, 0);
			$.parser.parse('#editor');
			initEditor();
			setDefaultValue(content);
		}
	}
}

/**
 * @description: 弹出式录入方式创建界面html
 * @param {object} c
 * @return {string} eleHtml
 */
function createHtml(c) {
	var eleHtml = '';
	var desc = '';
	if (!!c.sourceData) {
		if ($.isPlainObject(c.sourceData)) {
			if (Array.isArray(c.sourceData.values)) {
				if (c.sourceData.values.length > 0) {
					$.each(c.sourceData.values, function (i, v) {
						desc = !!desc ? desc + ',' + v.Text : v.Text;
					});
				} else {
					desc = c.title;
				}
			} else if (!!c.sourceData.values) {
				desc = c.sourceData.values;
			} else {
				desc = c.title;
			}
		} else {
			desc = c.sourceData;
		}
	} else {
		desc = c.title;
	}
	if (c.type == 'O') {
		eleHtml = "<span contenteditable='false' style='background-color:#509de1;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
	} else if (c.type == 'M') {
		eleHtml = "<span contenteditable='false' style='background-color:#EE7942;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
	} else if (c.type == 'D') {
		eleHtml = "<span contenteditable='false' style='background-color:#4EEE94;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
	} else if (c.type == 'N') {
		eleHtml = "<span contenteditable='false' style='background-color:#8552a1;border:1px dotted black'><a href='javascript:void(0);' id=" + c.id + " style='color:white;'>" + desc + "</a></span>";
	} else if (c.type == 'I') {
		//分隔符
	} else {
		var reg = new RegExp('\r\n', 'g');
		desc = String(c.title).replace(reg, '<br>');
		eleHtml = "<span id='" + c.id + "'>" + desc + "</span>";
	}
	return eleHtml;
}

/**
 * @description: 绑定点击事件
 * @param {object} content
 */
function bindClick(content) {
	$.each(content, function (i, c) {
		if (c.type != 'FreeText') {
			$('#' + c.id).bind('click', c, eleClickHandler);
		}
	});
}

/**
 * @description: 评估单式创建Dom元素
 * @return {object} c
 * @return {string} html
 */
function buildDom(c) {
	var strRefTo = '';
	if ((typeof c.refTo != "undefined") && (c.refTo.length > 0)) {
		$.each(c.refTo, function (index, ref) {
			strRefTo = !!strRefTo ? strRefTo + "," + ref.Text : ref.Text;
		});
	}
	if (c.type == 'FreeText') {
		var reg = new RegExp('\r\n', 'g');
		var title = String(c.title).replace(reg, '<br>');
		return '<label id="' + c.id + '">' + title + '</label>';
	} else if (c.type == 'O') {
		var values = '';
		if (c.sourceData.values.length > 0) {
			$.each(c.sourceData.values, function (index, value) {
				values = !!values ? values + ',' + value.Value : value.Value;
			});
		}
		var options = '';
		if (c.sourceData.source.length > 0) {
			$.each(c.sourceData.source, function (index, option) {
				var ifSelected = false;
				if ($.inArray(String(option.Value), String(values).split(',')) > -1) {
					ifSelected = true;
				}
				if (ifSelected) {
					options += '<option value="' + option.Value + '" selected>' + option.Text + '</option>';
				} else {
					options += '<option value="' + option.Value + '">' + option.Text + '</option>';
				}
			});
		}
		return '<span><select class="hisui-combobox group-el" id="' + c.id + '" style="width:100px">' + options + '</select></span><span class="blank-span"> </span>';
	} else if (c.type == 'M') {
		var values = '';
		$.each(c.sourceData.values, function (index, value) {
			values = !!values ? values + ',' + value.Value : value.Value;
		});
		var options = '';
		$.each(c.sourceData.source, function (index, option) {
			var ifChecked = false;
			if ($.inArray(String(option.Value), String(values).split(',')) > -1) {
				ifChecked = true;
			}
			if (ifChecked) {
				options += '<option value="' + option.Value + '" checked="checked">' + option.Text + '</option>';
			} else {
				options += '<option value="' + option.Value + '">' + option.Text + '</option>';
			}
		});
		return '<span><select class="hisui-combobox group-el" data-options="multiple:true,rowStyle:\'checkbox\'" id="' + c.id + '" style="width:180px">' + options + '</select></span><span class="blank-span"> </span>';
	} else if (c.type == 'D') {
		if ((c.dateFlag == "Y") && (c.timeFlag == "N")) {
			return '<span><input class="hisui-datebox textbox datebox-f combo-f group-el" id="' + c.id + '" value="2022-12-16" refFrom="' + c.refFrom + '" refTo="' + strRefTo + '" style="width:120px"></input></span><span class="blank-span"> </span>';
		} else if ((c.dateFlag == "N") && (c.timeFlag == "Y")) {
			return '<span><input class="hisui-datebox textbox datebox-f combo-f group-el" id="' + c.id + '" value="12:00" refFrom="' + c.refFrom + '" refTo="' + strRefTo + '" style="width:80px"></input></span><span class="blank-span"> </span>';
		} else {
			return '<span><input class="hisui-datetimebox textbox combo-f datetimebox-f group-el" id="' + c.id + '" value="2022-12-16 12:00" refFrom="' + c.refFrom + '" refTo="' + strRefTo + '" style="width:180px"></input></span><span class="blank-span"> </span>';
		}
	} else if (c.type == 'N') {
		return '<span><input class="hisui-numberbox textbox group-el" data-options="precision:1,forcePrecisionZoer:false,fix:false" id="' + c.id + '" value="' + c.sourceData + '" style="width:80px;" refFrom="' + c.refFrom + '" refTo="' + strRefTo + '"></span><span class="blank-span"> </span>';
	} else {
		return '';
	}
}

/**
 * @description: 设置默认值
 * @param {*} content
 */
function setDefaultValue(content) {
	$.each(content, function (i, c) {
		if (c.type == 'M') {
			var arrvalue = [];
			$.each(c.sourceData.values, function (index, value) {
				arrvalue.push(value.Value);
			});
			$('#' + c.id).combobox('setValues', arrvalue);
		}
	});
}

/**
 * @description: 插入内容
 * @return {string} content
 */
function insertContent(content) {
	if (websys_isIE) {
		// console.log(GV.EditorSelection);
		if ($.isEmptyObject(GV.EditorSelection)) {
			$('#editor').append('<label>' + content + '</label>');
			return;
		}
		var id = GV.EditorSelection.id;
		if (!id) {
			$('#editor').append('<label>' + content + '</label>');
			return;
		}
		var oldval = GV.EditorSelection.innerText;
		var preText = oldval.substring(0, GV.EditorSelection.focusOffset);
		var nextText = oldval.substring(GV.EditorSelection.focusOffset)
	} else {
		var selection = window.getSelection();
		var anchorNode = selection.anchorNode;
		if (!anchorNode) {
			$('#editor').append('<label>' + content + '</label>');
			return;
		};
		var id = anchorNode.parentNode.id;
		if (!id) {
			$('#editor').append('<label>' + content + '</label>');
			return;
		}
		var oldval = anchorNode.parentNode.innerText;
		var range = selection.getRangeAt(0);
		var preText = oldval.substring(0, range.endOffset);
		var nextText = oldval.substring(range.endOffset)
	}
	var newval = preText + content + nextText;
	$('#' + id).text(newval);
}

/**
 * @description: 获取预览内容
 * @param {*} content
 * @param {*} flag
*/
function getEditorContent() {
	var result = '';
	var childs = $('#editor')[0].childNodes;
	if (JSON.parse(GV.SwitchInfo.KnowWindow)) {
		$.each(childs, function (index, child) {
			if (!child.innerText) {
				if (!!child.textContent) {
					var text = child.textContent.replace('{', '').replace('}', '');
					result = result == '' ? child.textContent : result + child.textContent;
				}else{
					return true;
				}
			} else {
				var text = child.innerText.replace('{', '').replace('}', '');
				result = result == '' ? text : result + text;
			}
		});
	} else {
		if (childs.length > 0) {
			for (var i = 0; i < childs.length; i++) {
				var item = childs[i];
				if ((item.nodeName == '#comment') || (item.className == 'blank-span')) {
					continue;
				}
				if ((item.nodeName == 'SPAN') && (!!item.children)) {
					item = item.children[0];
				}
				if ((!item.innerText)&&(!!item.textContent)) {
					result = result == '' ? item.textContent : result + item.textContent;
				} else {
					var text = item.innerText.replace('{', '').replace('}', '');
					var type = item.id.substring(0, 1);
					if (type == "D") {
						text = $("#" + item.id).datebox('getValue');
					} else if ((type == "O") || (type == "M")) {
						text = $("#" + item.id).combobox('getText');
					} else if (type == "N") {
						text = $("#" + item.id).val();
					}
					if ((item.firstChild) && (item.firstChild.id) && (item.firstChild.id.substring(0, 1) == "D")) {
						text = $("#" + childs[i].firstChild.id).spinner('getValue');
					}
					var isHideFlag = false;
					if (type == "F") {
						var refFrom = item.getAttribute("refFrom");
						for (var j = 0; j < childs.length; j++) {
							if (j == i) continue;
							var stype = childs[j].id.substring(0, 1);
							if (stype == type) continue;
							var refTo = childs[j].getAttribute("refTo");
							if ((childs[j].firstChild) && (childs[j].firstChild.id) && (childs[j].firstChild.id.substring(0, 1) == "D")) {
								refTo = childs[j].firstChild.getAttribute("refTo");
							}
							if (!refTo) continue;
							var arrRefTo = String(refTo).split(',');
							if ($.inArray(refFrom, arrRefTo) < 0) continue;
							var stext = childs[j].innerText.replace('{', '').replace('}', '');
							if (stype == "D") {
								stext = $("#" + childs[j].id).datebox('getValue');
							} else if ((stype == "O") || (stype == "M")) {
								stext = $("#" + childs[j].id).combobox('getText');
							}
							if ((childs[j].firstChild) && (childs[j].firstChild.id) && (childs[j].firstChild.id.substring(0, 1) == "D")) {
								stext = $("#" + childs[j].firstChild.id).spinner('getValue');
							}
							if (!stext) {
								isHideFlag = true;
							}
						}
					}
					if (!isHideFlag) {
						result = result == '' ? text : result + text;
					}
				}
			}
		} else {
			result = $('#editor').innerText || $('#editor')[0].innerText;
		}

	}
	result = result.replace(/\r/g,'').replace(/\n/g,'').replace(/\t/g,'');
	var oriText = $('#editor').text();
	return result;
}
/**
 * @description: 点击dom
 */
function eleClickHandler(e) {
	GV.currentDomID = e.data.id;
	var currentText = $('#' + e.data.id)[0].innerText.replace(/\s+/g, '');
	if (!e.data.type) {
		$.message.popover({ msg: 'DOM元素类型为空！', type: 'error', timeout: 500 });
		return;
	}
	if (e.data.type == 'O') {
		$('#comboDom').empty();
		$('#comboDom').combobox({
			valueField: 'Value',
			textField: 'Text',
			data: e.data.sourceData.source,
			value: currentText,
			defaultFilter: 4
		});
	} else if (e.data.type == 'N') {
		$('#txtNumber').val(currentText);
	} else if (e.data.type == 'M') {
		$('#ulDom').empty();
		currentText = currentText.replace(new RegExp("，", ("gm")), ",");
		var checkedArr = currentText.split(',');
		$.each(e.data.sourceData.source, function (index, data) {
			var ifChecked = $.inArray(data.Text, checkedArr) >= 0 ? 'checked' : '';
			$('#ulDom').append("<li><input class='hisui-checkbox' type='checkbox' " + ifChecked + " label='" + data.Text + "'></li>");
		});
		$.parser.parse('#panelDom' + e.data.type);

	} else if (e.data.type == 'D') {
		//赋初值
		var displayValue = $('#' + e.data.id)[0].innerText;
		var curDateTime = displayValue.split(/\s/);
		if (curDateTime.length > 1) {
			$('#dateDomD').datebox('setValue', curDateTime[0]);
			$('#timeDomD').timespinner('setValue', curDateTime[1]);
		} else if (e.data.dateFlag == 'Y') {
			$('#dateDomD').datebox('setValue', curDateTime[0]);
		} else {
			$('#timeDomD').timespinner('setValue', curDateTime[0]);
		}
		//控制显示
		if (e.data.dateFlag != e.data.timeFlag) {
			if (e.data.dateFlag == 'Y') {
				$('#row1').css('display', 'block');
			} else {
				$('#row1').css('display', 'none');
			}
			if (e.data.timeFlag == 'Y') {
				$('#row2').css('display', 'block');
			} else {
				$('#row2').css('display', 'none');
			}
		} else {
			$('#row1').css('display', 'block');
			$('#row2').css('display', 'block');
		}
	}
	$('#dialogDom' + e.data.type).dialog({
		title: e.data.title,
		cache: false,
		modal: true,
		closed: false,
		onOpen: function () {
			if ($('#txtNumber').length > 0) {
				$('#txtNumber').focus();
				$('#txtNumber').bind('keypress', function (event) {
					if (event.keyCode == "13") {
						$('#btnOkDom' + e.data.type).click();
					}
				});
			}
		}
	});

	//$('#dialogDom' + e.data.type).dialog('open');

	//监听确定取消事件
	$('#btnOkDom' + e.data.type).bind('click', {
		appendId: e.data.id,
		typ: e.data.type,
		data: e.data.sourceData,
		dateFlag: e.data.dateFlag,
		timeFlag: e.data.timeFlag
	}, domClickHandler);
}
/**
* @description: 元素的点击事件
* @param {e} 
*/
function domClickHandler(e) {
	if (e.data.appendId == GV.currentDomID) {
		if (e.data.typ == 'O') {
			var comboText = $('#comboDom').combobox('getText');
			$('#' + e.data.appendId)[0].innerText = comboText;
		} else if (e.data.typ == 'M') {
			var checkboxText = '';
			$('#ulDom li input').each(function (index, element) {
				if (element.checked == true) {
					checkboxText = checkboxText == '' ? element.id : checkboxText + ',' + element.id;
				}
			});
			$('#' + e.data.appendId)[0].innerText = checkboxText;
		} else if (e.data.typ == 'D') {
			var datetimeText = '';
			var dateText = '';
			var timeText = '';
			var dateText = $('#dateDomD').datebox('getValue');
			var timeText = $('#timeDomD').spinner('getValue');
			datetimeText = dateText + ' ' + timeText;
			if ((e.data.dateFlag == 'Y') && (e.data.timeFlag == 'N')) {
				datetimeText = dateText;
			}
			if ((e.data.dateFlag == 'N') && (e.data.timeFlag == 'Y')) {
				datetimeText = timeText;
			}
			$('#' + e.data.appendId)[0].innerText = datetimeText;
		} else if (e.data.typ == 'N') {
			var numberValue = $('#txtNumber').val();
			$('#' + e.data.appendId)[0].innerText = numberValue;
		}
	}
	$('#dialogDom' + e.data.typ).dialog('close');
}

/**
 * @description: 编辑器内获取光标位置
 * @param {*} element
 * @return {*} caretOffset
 */
function getCursortPosition(element) {
	var caretOffset = 0;
	var doc = element.ownerDocument || element.document;
	var win = doc.defaultView || doc.parentWindow;
	var sel;
	if (typeof win.getSelection != 'undefined') {//谷歌、火狐
		sel = win.getSelection();
		if (sel.rangeCount > 0) {//选中的区域
			var range = win.getSelection().getRangeAt(0);
			var preCaretRange = range.cloneRange();//克隆一个选中区域
			preCaretRange.selectNodeContents(element);//设置选中区域的节点内容为当前节点
			preCaretRange.setEnd(range.endContainer, range.endOffset);  //重置选中区域的结束位置
			caretOffset = preCaretRange.toString().length;
		}
	} else if ((sel = doc.selection) && sel.type != 'Control') {//IE
		var textRange = sel.createRange();
		var preCaretTextRange = doc.body.createTextRange();
		preCaretTextRange.moveToElementText(element);
		preCaretTextRange.setEndPoint('EndToEnd', textRange);
		caretOffset = preCaretTextRange.text.length;
	}
	return caretOffset;
}

/**
 * @description: 清屏
 */
function clearView() {
	$('#editor').empty();
}

/**
 * @description: 编辑器事件监听
 */
function listenEvents() {
	$('#editor').keydown(function (event) {
		var selObj = window.getSelection();
		if (selObj.rangeCount < 1) {
			return;
		}
		var range = selObj.getRangeAt(0);
		if (!range.collapsed) {
			return;
		}
		switch (event.keyCode) {
			// 退格键
			case 8: {
				if (websys_isIE) {
					// IE浏览器下
					if ((!!range.startContainer) && (!!range.startContainer.nodeValue) && (!range.startContainer.nodeValue.trim()) && (!!range.startContainer.parentNode.previousSibling) && (range.startContainer.parentNode.previousSibling.nodeName == 'SPAN')) {
						console.log('末尾删除：');
						console.log(range.startContainer.parentNode.previousSibling);
						del(range.startContainer.parentNode.previousSibling);
					}
					if ((!!range.startContainer) && (range.startContainer.nodeName == 'SPAN')) {
						console.log('特殊处理：');
						console.log(range.startContainer);
						del(range.startContainer);
					} else {
						console.log('字符串:');
						console.log(range.startContainer);
						delStr(range.startContainer);
					}
					return false;
				} else {
					// 谷歌浏览器下
					if ((!!range.startContainer) && (!!range.startContainer.nodeValue) && (!range.startContainer.nodeValue.trim()) && (!!range.startContainer.parentNode.previousSibling) && (range.startContainer.parentNode.previousSibling.nodeName == 'SPAN')) {
						console.log('末尾删除：');
						console.log(range.startContainer.parentNode.previousSibling);
						del(range.startContainer.parentNode.previousSibling);
						return false;
					} else {
						console.log('正常删除，不用处理');
					}
				}
				break;
			}
		}
	});

	if (websys_isIE) {
		$('#editor').keyup(function (event) {
			$('#editor').attr('contenteditable', 'true');
		});
	
		$('#editor').focus(function (e) {
			var selection = window.getSelection();
			GV.EditorSelection.focusOffset=JSON.parse(JSON.stringify(selection.focusOffset));
			if (selection.anchorNode.parentNode) {
				GV.EditorSelection.innerText=JSON.parse(JSON.stringify(selection.anchorNode.parentNode.innerText));
				GV.EditorSelection.id=JSON.parse(JSON.stringify(selection.anchorNode.parentNode.id));
			}
		});
	}
	
}
