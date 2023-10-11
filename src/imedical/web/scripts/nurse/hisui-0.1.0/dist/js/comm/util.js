/*
 * @Descripttion: 通用工具
 * @Author: yaojining
 */

/**
 * @description: popover提示
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
 * @description: confirm提示
 */
function confirm() {
    var callbackFun = arguments[0];
    var msg = !!arguments[1] ? arguments[1] : $g('确定进行此操作吗？');
    $.messager.confirm($g('提示'), msg, function (r) {
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
 * @description: 获取时间(同步)
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
 * @description: 获取时间
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
 * @description 获取指定form中的所有的<input>对象   
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
 * @description: 序列化容器内所有指定类型元素的键值对象
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
 * @description: 为指定容器内的所有元素赋值
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
 * @description: 加载提示
 */
function onloading() {
    $('<div class="datagrid-mask"></div>').css({
        display: 'block',
        width: '100%',
        height: $(window).height()
    }).appendTo('body');
    $('<div class="datagrid-mask-msg"></div>').html($g('数据加载中，请稍候...')).appendTo('body').css({
        display: 'block',
        left: ($(document.body).outerWidth(true) - 190) / 2,
        top: ($(window).height() - 45) / 2
    });
}

/**
 * @description: 取消提示
 */
function removeload() {
    $('.datagrid-mask').remove();
    $('.datagrid-mask-msg').remove();
}

/**
 * @description: 进度提示
 */
 function onProgress(title, msg, text) {
    $.messager.progress({
        title: title,
        msg: msg,
        text: text
    });
}

/**
 * @description: 进度完成
 */
 function progressEnd() {
    $.messager.progress('close')
}

/**
* @description 往头菜单传递病人信息
*/
function passPatientToMenu(node) {
	var frm = dhcsys_getmenuform();
	// 8.5标版做了规定：需要去掉在非主要界面切换病人往头菜单传递就诊信息的功能，避免在医嘱管理界面录入医嘱时串信息的风险。
	// 所以修改PassToMenuFlag默认值，PassToMenuFlag-1:传递，非1:不传递，默认不传递。
	if ((frm) && (PassToMenuFlag == 1)) {
		frm.EpisodeID.value = node.episodeID;
		frm.PatientID.value = node.patientID;
	}
}

/**
 * @description: token改造方案
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
 * @description: 设置展示样式
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
 * @description: 判断是否是弹窗显示
 * @return {bool} true/false
 */
function isOpenWindow() {
	return (!!$(window.opener).width());
}