/*
 * @Descripttion: �Ҽ��˵�
 * @Author: yaojining
 */

var refTabs = ['Know'];
var curElement = null;

/**
 * @description: ��ȡ���window
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
 * @description: �����Ҽ��˵�
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
            text: '����',
            iconCls: 'icon-cut',
            onclick: cutHandler
        });
        $('#menu').menu('appendItem', {
            id: 'menuCopy',
            text: '����',
            iconCls: 'icon-copy',
            onclick: copyHandler
        });
        $('#menu').menu('appendItem', {
            id: 'menuPaste',
            text: 'ճ��',
            iconCls: 'icon-paste',
            onclick: pasteHandler
        });
        //�������
        if (refType.indexOf('Common') > -1) {
            $('#menu').menu('appendItem', {
                id: 'menuRefer',
                text: '����',
                iconCls: 'icon-paper-link-pen',
                onclick: function () {
                    showRefer(selector);
                }
            });
        }
        //����������
        if (refType.indexOf('Symbol') > -1) {
            $('#menu').menu('appendItem', {
                id: 'specialChar',
                text: '�������',
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
		// ���ں�
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
 * @description: ����Ҽ����ò˵�
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
 * @description: ���������Ų˵�
 */
function showChar() {
    getOutWindow().openDgChar();
}

/**
 * @description: ��ȡ��ǰ�༭��Ԫ��
 * @return {*}
 */
function getCurrentElement() {
    return curElement;
}

/**
 * @description: ��ȡ��ǰ�༭��Ԫ�ص�ID
 * @return {*}
 */
function getCurElementId() {
    return curElement.id;
}

/**
 * @description: ��ȡ��ǰ�༭��Ԫ�ص��ı�
 * @return {*}
 */
function getCurElementValue() {
    return $(curElement).val();
}

/**
 /**
  * @description: ����Ԫ��д�����õ�����
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
  * @description: ����Ԫ��д���������
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
 * @description: ��ȡѡ��Ԫ�ص��ı�
 * @param {obj} 
 * @return: ���λ�� 
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
 * @description: ����������Ϣ
 * @param {curElement, editContent, curPosition, op} 
 */
function updateRefer(editContent, op) {
    var curPosition = getCursortPosition(curElement);
    var toPreview = op == 'refer' ? getOutWindow().getReferWindow().GV.SwitchInfo.ToPreview : false;
    if ((JSON.parse(toPreview)) && (op != 'paste') && (op != 'chars')) {
        SetOneValue(curElement.id, editContent);   //��ԭ���ı��滻
    } else {
        var startText = curPosition == 0 ? '' : curElement.value.substring(0, curPosition);
        if (startText.trim() == '/') {
            startText = '';
        }
        var endText = curElement.value.substring(curPosition);
        SetOneValue(curElement.id, startText + editContent + endText);  //��ԭ���ı�׷��
    }
}

/**
 * @description: ����
 */
function cutHandler(e) {
    var preText = curElement.value.toString().substr(0, curElement.selectionStart);
    var nexText = curElement.value.toString().substr(curElement.selectionEnd);
    curElement.value = preText + nexText;
    copyHandler(e);
}

/**
 * @description: ����
 */
function copyHandler(e) {
    if (typeof window.clipboardData == 'undefined') {
        //��IE
        if (navigator.clipboard) {
            // chrome49����
            navigator.clipboard.writeText(clipboardContent);  //chrome49��֧��
        } else {
            $('body').attr('data-clipboard-text', clipboardContent);
            // ���ƿ��ԣ�����ճ����Ȩ��
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
 * @description: ճ��
 */
function pasteHandler(e) {
    var clipContent = '';
    if (typeof window.clipboardData == 'undefined') {
        //��IE
        if (navigator.clipboard) {
            // chrome49����
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
 * @description: ��ȡ����ѡ�е�����
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