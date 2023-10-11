/*
 * @Descripttion: ͨ�ù���
 * @Author: yaojining
 */

/**
 * @description: popover��ʾ
 */
function popover() {
    var result = arguments[0];
    if (result.status < 0) {
        $.messager.popover({
            msg: result.msg,
            type: 'error'
        });
    } else {
        $.messager.popover({
            msg: result.msg,
            type: 'success'
        });
    }
}
/**
 * @description: confirm��ʾ
 */
function confirm() {
    var callbackFun = arguments[0];
    var msg = !!arguments[1] ? arguments[1] : $g('ȷ�����д˲�����');
    $.messager.confirm($g('��ʾ'), msg, function (r) {
        if (r) {
            if (typeof callbackFun == 'function') {
                callbackFun();
            }
        } else {
            return;
        }
    });
}

/**
 * @description: ��ȡʱ��(ͬ��)
 * @param {String} days
 */
function oneDateTime() {
    var flag = arguments.length > 0 ? arguments[0] : '';
    var days = arguments.length > 1 ? arguments[1] : '';
    var dt = $cm({
        ClassName: 'NurMp.Common.Tools.Utils',
        MethodName: 'GetServerDateTime',
        MoveDays: days
    }, false);
    if (flag == 1) {
        return dt.date;
    } else if (flag == 2) {
        return dt.time;
    } else if (flag == 3) {
        return dt.dateTime;
    } else {
        return dt;
    }
    return dt;
}

/**
 * @description: ��ȡʱ��
 * @param {String} flag 
 * @param {String} days 
 * @param {function} callbackFun 
 */
function getDateTime() {
    var flag = arguments.length > 0 ? arguments[0] : '';
    var days = arguments.length > 1 ? arguments[1] : '';
    var callbackFun = arguments.length > 2 ? arguments[2] : '';
    $cm({
        ClassName: 'NurMp.Common.Tools.Utils',
        MethodName: 'GetServerDateTime',
        MoveDays: days
    }, function (dt) {
        if (typeof callbackFun == 'function') {
            if (flag == 1) {
                return callbackFun(dt.date);
            } else if (flag == 2) {
                return callbackFun(dt.time);
            } else if (flag == 3) {
                return callbackFun(dt.dateTime);
            } else {
                return callbackFun('');
            }
        } else {
            console.log(dt);
        }
    });
}

/**
 * @description ��ȡָ��form�е����е�<input>����   
 */
function getElements(formId) {
    var elements = $(formId).find('input, select');
    for (var i = 0; i < elements.length; i++) {
        if (!elements[i].id) {
            continue;
        }
    }
}

/**
 * @description: ���л�����������ָ������Ԫ�صļ�ֵ����
 * @param {String} contentId
 * @param {Boolean} arrFlag
 * @return {Object} elements
 */
function serializeElements(contentId, arrFlag) {
    var elements = new Object();
    $.each($(contentId).find('input, select'), function (index, element) {
        if (!element.id) {
            return true;
        }
        var eltype = $('#' + element.id).attr('type');
        if (!eltype) {
            return true;
        }
        if (eltype == 'textbox') {
            eval('value = $(element).val();');
        } else {
            eval('value = $(element).' + eltype + '("getValue");');
        }
        elements[element.id] = value === true ? 1 : (value === false ? 0 : value);
    });
    if (arrFlag) {
        var arrayElements = new Array();
        arrayElements.push(elements);
        return arrayElements;
    }
    return elements;
}

/**
 * @description: Ϊָ�������ڵ�����Ԫ�ظ�ֵ
 */
function deserializeElements(contentId, obj, callbackFun) {
    $.each($(contentId).find('input, select'), function (index, element) {
        if (!element.id) {
            return true;
        }
        var eltype = $('#' + element.id).attr('type');
        if (!eltype) {
            return true;
        }
        var value = obj[element.id];
        if (value == undefined) {
            if (eltype == 'checkbox') {
                value = 0;
            } else {
                value = '';
            }
        }
        if (eltype == 'textbox') {
            eval('$(element).val("' + value + '");');
        } else {
            eval('$(element).' + eltype + '("setValue","' + value + '");');
        }
    });
    if ((JSON.stringify(obj) == '{}') && (typeof callbackFun == 'function')) {
        callbackFun();
    }
}

/**
 * @description: ������ʾ
 */
function onloading() {
    $('<div class="datagrid-mask"></div>').css({
        display: 'block',
        width: '100%',
        height: $(window).height()
    }).appendTo('body');
    $('<div class="datagrid-mask-msg"></div>').html($g('���ݼ����У����Ժ�...')).appendTo('body').css({
        display: 'block',
        left: ($(document.body).outerWidth(true) - 190) / 2,
        top: ($(window).height() - 45) / 2
    });
}

/**
 * @description: ȡ����ʾ
 */
function removeload() {
    $('.datagrid-mask').remove();
    $('.datagrid-mask-msg').remove();
}

/**
 * @description: ������ʾ
 */
 function onProgress(title, msg, text) {
    $.messager.progress({
        title: title,
        msg: msg,
        text: text
    });
}

/**
 * @description: �������
 */
 function progressEnd() {
    $.messager.progress('close')
}

/**
* @description ��ͷ�˵����ݲ�����Ϣ
*/
function passPatientToMenu(node) {
	var frm = dhcsys_getmenuform();
	// 8.5������˹涨����Ҫȥ���ڷ���Ҫ�����л�������ͷ�˵����ݾ�����Ϣ�Ĺ��ܣ�������ҽ���������¼��ҽ��ʱ����Ϣ�ķ��ա�
	// �����޸�PassToMenuFlagĬ��ֵ��PassToMenuFlag-1:���ݣ���1:�����ݣ�Ĭ�ϲ����ݡ�
	if ((frm) && (PassToMenuFlag == 1)) {
		frm.EpisodeID.value = node.episodeID;
		frm.PatientID.value = node.patientID;
	}
}

/**
 * @description: token���췽��
 * @return {string} url
 */
function buildMWTokenUrl(url){
	if (typeof websys_getMWToken != 'undefined'){
		if (url.indexOf('?') == -1){
			url = url + '?MWToken=' + websys_getMWToken();
		} else {
			url = url + "&MWToken=" + websys_getMWToken();
		}
	}
	return url;
}

/**
 * @description: ����չʾ��ʽ
 */
function updateStyle() {
	var name = arguments.length > 0 ? arguments[0] : '';
	if (typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite') {
		if (isOpenWindow()) {
			$('body').addClass('white_background');
			if ($('.hisui-layout ').length > 0) {
				$('.hisui-layout').addClass('white_background');
			}
			if ($('.color_layout').length > 0) {
				$('.color_layout').addClass('white_background');
			}
		} else {
			if ($('.color_layout').length > 0) {
				$('.color_layout').addClass('gray_background');
			}
			if ($('.banner_row_layout_north').length > 0) {
				$('.banner_row_layout_north').addClass('gray_background');
			}
		}
		if ($('.layout-split-west').length > 0) {
			$('.layout-split-west').addClass('trans_split');
		}
		if ($('.accordion .accordion-header .panel-with-icon').length > 0) {
			$('.accordion .accordion-header .panel-with-icon').addClass('lite_accordion_icon_title');
		}
	}
}

/**
 * @description: �ж��Ƿ��ǵ�����ʾ
 * @return {bool} true/false
 */
function isOpenWindow() {
	return (!!$(window.opener).width());
}