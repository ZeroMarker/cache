/*
 * @Descripttion: 右键菜单
 * @Author: yaojining
 */

var refTabs = ['Know'];
var curElement = null;

/**
 * @description: 获取外层window
 * @return: window
 */
function getOutWindow(currentWindow) {
    if (!currentWindow) {
        currentWindow = window;
    }
    if ((currentWindow.GV) && (currentWindow.GV.BaseFlag)) {
        return currentWindow;
    }
    if ((currentWindow.parent.GV) && (currentWindow.parent.GV.BaseFlag)) {
        return currentWindow.parent;
    } else {
        if (!currentWindow.parent) {
            return window;
        }
        return getOutWindow(currentWindow.parent);
    }
}

/**
 * @description: 创建右键菜单
 * @param {*} selector
 * @param {*} refType
 */
function buildMenu(selector, refType) {
    $(selector).bind('contextmenu', function (e) {
        if ($('#menu').length == 0) {
            $('body').append(document.getElementById('menuTemplate').innerHTML);
            $('#menu').menu();
        }
        $('#menu').empty();
        $('#menu').menu('appendItem', {
            id: 'menuCut',
            text: '剪切',
            iconCls: 'icon-cut',
            onclick: cutHandler
        });
        $('#menu').menu('appendItem', {
            id: 'menuCopy',
            text: '复制',
            iconCls: 'icon-copy',
            onclick: copyHandler
        });
        $('#menu').menu('appendItem', {
            id: 'menuPaste',
            text: '粘贴',
            iconCls: 'icon-paste',
            onclick: pasteHandler
        });
        //添加引用
        if (refType.indexOf('Common') > -1) {
            $('#menu').menu('appendItem', {
                id: 'menuRefer',
                text: '引用',
                iconCls: 'icon-paper-link-pen',
                onclick: function () {
                    showRefer(selector);
                }
            });
        }
        //添加特殊符号
        if (refType.indexOf('Symbol') > -1) {
            $('#menu').menu('appendItem', {
                id: 'specialChar',
                text: '特殊符号',
                iconCls: 'icon-sum',
                onclick: showChar
            });
        }
        e.preventDefault();
        $('#menu').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
    });
    $(selector).mouseup(function (e) {
        curElement = e.target;
        window.clipboardContent = getSelectionText(e.target);
		// 超融合
        if (e.button == 0) {
            var mwin = ("undefined" != typeof window.websys_getMenuWin_origin) ? websys_getMenuWin_origin() : websys_getMenuWin();
            var screens = (typeof websys_getMWScreens == 'function') && (websys_getMWScreens()) ? websys_getMWScreens().screens : [];
            if ((mwin.DisableSecondScreen == false) && ((screens.length > 1) || ((screens.length == 1) && (screens[0].PrimaryScreen == true))) && (typeof websys_emit == 'function')) {
                showRefer(selector);
            }
	    }
    });
}

/**
 * @description: 点击右键引用菜单
 * @param {object} selector
 */
function showRefer(selector) {
    arrtab = $(selector).data('RefConfig');
    if (typeof arrtab != 'undefined') {
        refTabs = arrtab.length < 1 ? refTabs : arrtab;
    }
    getOutWindow().openDgRefer(arrtab);
}

/**
 * @description: 点击特殊符号菜单
 */
function showChar() {
    getOutWindow().openDgChar();
}

/**
 * @description: 获取当前编辑的元素
 * @return {*}
 */
function getCurrentElement() {
    return curElement;
}

/**
 * @description: 获取当前编辑的元素的ID
 * @return {*}
 */
function getCurElementId() {
    return curElement.id;
}

/**
 * @description: 获取当前编辑的元素的文本
 * @return {*}
 */
function getCurElementValue() {
    return $(curElement).val();
}

/**
 /**
  * @description: 往表单元素写入引用的内容
  * @return {String} input
  * @return {Function} callback
  */
function writeInto(input, callback) {
    updateRefer(input, 'refer');
    if (typeof callback == 'function') {
        callback();
    }
}

/**
 /**
  * @description: 往表单元素写入特殊符号
  * @return {String} input
  * @return {Function} callback
  */
function writeChars(input, callback) {
    updateRefer(input, 'chars');
    if (typeof callback == 'function') {
        callback();
    }
}

/**
 * @description: 获取选中元素的文本
 * @param {obj} 
 * @return: 光标位置 
 */
function getCursortPosition(obj) {
    var cursorIndex = 0;
    if (document.selection) {
        // IE Support
        obj.focus();
        var range = document.selection.createRange();
        range.moveStart('character', -obj.value.length);
        cursorIndex = range.text.length;
    } else if (obj.selectionStart || obj.selectionStart == 0) {
        // another support
        cursorIndex = obj.selectionStart;
    }
    return cursorIndex;
}

/**
 * @description: 更新引用信息
 * @param {curElement, editContent, curPosition, op} 
 */
function updateRefer(editContent, op) {
    var curPosition = getCursortPosition(curElement);
    var toPreview = op == 'refer' ? getOutWindow().getReferWindow().GV.SwitchInfo.ToPreview : false;
    if ((JSON.parse(toPreview)) && (op != 'paste') && (op != 'chars')) {
        SetOneValue(curElement.id, editContent);   //将原有文本替换
    } else {
        var startText = curPosition == 0 ? '' : curElement.value.substring(0, curPosition);
        if (startText.trim() == '/') {
            startText = '';
        }
        var endText = curElement.value.substring(curPosition);
        SetOneValue(curElement.id, startText + editContent + endText);  //在原有文本追加
    }
}

/**
 * @description: 剪切
 */
function cutHandler(e) {
    var preText = curElement.value.toString().substr(0, curElement.selectionStart);
    var nexText = curElement.value.toString().substr(curElement.selectionEnd);
    curElement.value = preText + nexText;
    copyHandler(e);
}

/**
 * @description: 复制
 */
function copyHandler(e) {
    if (typeof window.clipboardData == 'undefined') {
        //非IE
        if (navigator.clipboard) {
            // chrome49以上
            navigator.clipboard.writeText(clipboardContent);  //chrome49不支持
        } else {
            $('body').attr('data-clipboard-text', clipboardContent);
            // 复制可以，但是粘贴无权限
            var input = document.createElement('textarea');
            input.value = clipboardContent;
            document.body.appendChild(input);
            input.select();
            document.execCommand('copy');
            document.body.removeChild(input);
        }
    } else {
        //IE
        window.clipboardData.setData('Text', clipboardContent);
    }
}

/**
 * @description: 粘贴
 */
function pasteHandler(e) {
    var clipContent = '';
    if (typeof window.clipboardData == 'undefined') {
        //非IE
        if (navigator.clipboard) {
            // chrome49以上
            navigator.clipboard.readText().then(function(clipText) {
                if (!!clipText) {
                    updateRefer(clipText, 'paste');
                }
            });
        } else {
            clipContent = $('body').attr('data-clipboard-text');
            if (!!clipContent) {
	            updateRefer(clipContent, 'paste');
	        }
        }
    } else {
        //IE
        clipContent = window.clipboardData.getData('Text');
        if (!!clipContent) {
            updateRefer(clipContent, 'paste');
        }
    }
    
}

/**
 * @description: 获取高亮选中的内容
 * @return: 
 */
function getSelectionText() {
    if (!curElement) {
        return false;
    }
    var selectedText = '';
    var elem = document.getElementById(curElement.id);
    if (elem) {
        if (typeof document.selection != 'undefined') {
            selectedText = document.selection.createRange().text;
        } else {
            selectedText = elem.value.substr(elem.selectionStart, elem.selectionEnd - elem.selectionStart);
        }
    }
    return selectedText.trim();
}