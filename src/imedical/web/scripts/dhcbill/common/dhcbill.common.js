/**
* dhcbill.common.js
*/

/**
 * 格式化金额
 * @method formatAmt
 * @param {String} val
 * @author ZhYW
 * formatAmt(123.455)
 */
function formatAmt(val) {
    if ((!val) || (isNaN(val))) {
        return val;
    }
    return parseFloat(val).toFixed(2);
}

/**
 * @method getDefStDate
 * @param {String} space
 * @author ZhYW
 * getDefStDate(-1)
 */
function getDefStDate(space) {
    if (isNaN(space)) {
        space = -30;
    }
    var dateObj = new Date();
    dateObj.setDate(dateObj.getDate() + space);
    var myYear = dateObj.getFullYear();
    var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
    var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
    var sysDateFormat = $.m({ClassName: "websys.Conversions", MethodName: "DateFormat"}, false); //同步调用取系统配置日期格式
    if (sysDateFormat == 1) {
        return myMonth + '/' + myDay + '/' + myYear;
    }
    if (sysDateFormat == 3) {
        return myYear + '-' + myMonth + '-' + myDay;
    }
    return myDay + '/' + myMonth + '/' + myYear;
}

/**
 * 获取指定的URL参数值
 * @method getParam
 * @param {String} paramName
 * getParam("name")
 */
function getParam(paramName) {
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=") > 1) {
        arrSource = unescape(this.location.search).substring(1, this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound) {
            if (arrSource[i].indexOf("=") > 0) {
                if (arrSource[i].split("=")[0].toLowerCase() == paramName.toLowerCase()) {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                }
            }
            i++;
        }
    }
    return paramValue;
}

/**
 * 将卡号格式化为定义长度
 * @method formatCardNo
 * @param {String} cardType, cardNo
 * formatCardNo('', '')
 */
function formatCardNo(cardType, cardNo) {
	if (!cardNo) {
		return cardNo;
	}
    var cardNoLen = getCardNoLength(cardType);
    return formatString(cardNo, cardNoLen, "0");
}

/**
 * 获取卡号长度
 * @method getCardNoLength
 * @param {String} cardType
 * getCardNoLength('')
 */
function getCardNoLength(cardType) {
    var cardTypeAry = cardType.split("^");
    return cardTypeAry[17] || "";
}

/**
* 不足最大长度前边补0或空
*/
function formatString(str, n, tag) {
	return (Array(n).join(tag) + str).slice(-n);
}

/**
 * 禁止Backspace键使浏览器后退
 */
function banBackSpace(e) {
    e = e || window.event;
    //各种浏览器下获取事件对象
    var obj = e.relatedTarget || e.srcElement || e.target || e.currentTarget;
    //按下Backspace键
    var key = e.keyCode || e.which || e.charCode;
    if (key == 8) {
        var tagName = obj.nodeName; //标签名称
        //如果标签不是input或者textarea则阻止Backspace
        if (tagName != 'INPUT' && tagName != 'TEXTAREA') {
            return stopDefault(e);
        }
        var tagType = obj.type.toUpperCase(); //标签类型
        //input标签除了下面几种类型，全部阻止Backspace
        if (tagName == 'INPUT' && (tagType != 'TEXT' && tagType != 'TEXTAREA' && tagType != 'PASSWORD')) {
            return stopDefault(e);
        }
        //input或者textarea输入框如果不可编辑则阻止Backspace
        if ((tagName == 'INPUT' || tagName == 'TEXTAREA') && (obj.readOnly || obj.disabled)) {
            return stopDefault(e);
        }
    }
}

/**
 * 阻止元素发生默认的行为
 */
function stopDefault(e) {
    if (e.preventDefault) {
        //W3C
        e.preventDefault();
    }
    if (e.returnValue) {
        //IE
        e.returnValue = false;
    }
    return false;
}

/**
 * 防止事件冒泡
 */
function cancelBubble(e) {
    if (e.stopPropagation) {
        e.stopPropagation();
    } else {
        e.cancelBubble = true;
    }
}

/**
 * 加载ComboGrid数据
 * @method loadComboGridStore
 * @param {String} gridId
 * @param {Object} queryParams
 * @author ZhYW
 */
function loadComboGridStore(gridId, queryParams) {
    setTimeout(function () {
        var grid = $('#' + gridId).combogrid('grid'); //获取数据表格对象
        $.extend(grid.datagrid('options'), {
            url: $URL,
            queryParams: queryParams
        });
        grid.datagrid('load');
    }, 100);
}

/**
 * 加载DataGrid数据
 * @method loadDataGridStore
 * @param {String} gridId
 * @param {Object} queryParams
 * @author ZhYW
 */
function loadDataGridStore(gridId, queryParams) {
    setTimeout(function () {
        var grid = $('#' + gridId);
        $.extend(grid.datagrid('options'), {
            url: $URL,
            queryParams: queryParams
        });
        grid.datagrid('load');
    }, 100);
}

/**
 * 加载TreeGrid数据
 * @method loadTreeGridStore
 * @param {String} gridId
 * @param {Object} queryParams
 * @author ZhYW
 */
function loadTreeGridStore(gridId, queryParams) {
    setTimeout(function () {
        var grid = $('#' + gridId);
        $.extend(grid.treegrid('options'), {
            url: $URL,
            queryParams: queryParams
        });
        grid.treegrid('load');
    }, 100);
}

/**
 * 设置DataGird单元格的值
 * @param {String} fieldName
 * @param {} value
 * @param {Integer} index
 * @param {gridId} gridId
 * @author ZhYW
 */
var HISUIDataGrid = {
    setFieldValue: function (fieldName, value, index, gridId) {
        var grid = $('#' + gridId);
        if (index === undefined || index === '') {
            index = 0;
        }
        var row = grid.datagrid('getRows')[index];
        if (row != null) {
            var editor = grid.datagrid('getEditor', {
                    index: index,
                    field: fieldName
                });
            if (editor != null) {
                this.setValueToEditor(editor, value);
            } else {
                var view = $('.datagrid-view');
                for (var i = 0; i < view.length; i++) {
                    if ($(view[i]).children(grid.selector).length > 0) {
                        var view = $(view[i]).children('.datagrid-view2');
                        var td = $(view).find('.datagrid-body td[field="' + fieldName + '"]')[index];
                        var div = $(td).find('div')[0];
                        $(div).text(value);
                    }
                }
                row[fieldName] = value;
            }
            grid.datagrid('clearSelections');
        }
    },

    //设置datagrid的编辑器的值
    setValueToEditor: function (editor, value) {
        switch (editor.type) {
	    case 'text':
            editor.target.val(param.value);
            break;
        case 'combobox':
            editor.target.combobox('setValue', value);
            break;
        case 'combotree':
            editor.target.combotree('setValue', value);
            break;
        case 'textbox':
            editor.target.textbox('setValue', value);
            break;
        case 'validatebox':
            editor.target.val(value);
            break;
        case 'numberbox':
            editor.target.numberbox("setValue", value);
            break;
        case 'datebox':
            editor.target.datebox("setValue", value);
            break;
        case 'datetimebox':
            editor.target.datebox("setValue", value);
            break;
        default:
            editor.html = value;
        }
    }
}

function numCompute(num1, num2, caloption) {
    var num1 = parseFloat(num1);
    if (isNaN(num1)) {
        num1 = 0;
    }
    var num2 = parseFloat(num2);
    if (isNaN(num2)) {
        num2 = 0;
    }
    switch (caloption) {
    case "-":
        var res = num1 - num2;
        break;
    case "+":
        var res = num1 + num2;
        break;
    case "*":
        var res = num1 * num2;
        break;
    case "%":
        var res = num2 / num1;
        break;
    default:
        var res = num1 * num2;
    }
    res = parseFloat(res) + 0.00001;
    return res.toFixed(2);
}

/**
 * 日期格式校验
 */
function checkDate(str) {
    if (str == "") {
        return true;
    }
    var dateFormat = $.m({ClassName: "websys.Conversions", MethodName: "DateFormat"}, false);
    if (dateFormat == 4) {
        var regStr = /^((((0[1-9]|[12][0-9]|3[01])\/(0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|((0[1-9]|[1][0-9]|2[0-8])\/02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
    } else if (dateFormat == 1) {
        var regStr = /^((((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-8])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
    } else {
        var regStr = /^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
    }
    if (str.match(regStr) == null) {
        return false;
    }
    return true;
}

/**
 * 字符转ASCII码,以冒号(:)拼接返回
 */
function charTransAsc(str) {
    if ((str === "") || (typeof str == "undefind")) {
        return "";
    }
    var rtnStr = "";
    var len = str.length;
    for (var i = 0; i < len; i++) {
        var oneStr = str.substr(i, 1);
        if (rtnStr == "") {
            rtnStr = oneStr.charCodeAt();
        } else {
            rtnStr = rtnStr + ":" + oneStr.charCodeAt();
        }
    }
    return rtnStr;
}

/**
 * ASCII码转字符,以冒号(:)拼接传入
 */
function ascTransChar(ascStr) {
    if ((ascStr === "") || (typeof ascStr == "undefind")) {
        return "";
    }
    var rtnStr = "";
    var ascAry = ascStr.split(':');
    for (var i = 0; i < ascAry.length; i++) {
        if (rtnStr == "") {
            rtnStr = String.fromCharCode(ascAry[i]);
        } else {
            rtnStr = rtnStr + String.fromCharCode(ascAry[i]);
        }
    }
    return rtnStr;
}

function toRound(num, len, rNum) {
	if (!(len > 0)) {
		len = 0;
	}
    return Math.round(((num * Math.pow(10, len + 1)) - (rNum - 5) + 0.5) / Math.pow(10, 1)) / Math.pow(10, len);
}

function getEntityClassInfoToXML(parseInfo) {
    try {
        var xmlStr = "";
        var myAry = parseInfo.split("^");
        var xmlObj = new XMLWriter();
        xmlObj.BeginNode(myAry[0]);
        for (var i = 1; i < myAry.length; i++) {
            xmlObj.BeginNode(myAry[i]);
            var myVal = getValueById(myAry[i]) || "";
            xmlObj.WriteString(myVal);
            xmlObj.EndNode();
        }
        xmlObj.Close();
        xmlStr = xmlObj.ToString();
    } catch (e) {
        $.messager.alert("提示", "Error: " + e.message, "error");
    }
    return xmlStr;
}

/**
 * 获取session串
 */
function getSessionStr() {
    var myAry = [];
    myAry[myAry.length] = session['LOGON.USERID'];
    myAry[myAry.length] = session['LOGON.GROUPID'];
    myAry[myAry.length] = session['LOGON.CTLOCID'];
    myAry[myAry.length] = session['LOGON.HOSPID'];
    myAry[myAry.length] = session['LOGON.LANGID'];
    return myAry.join("^");
}

/**
 * 阻止快捷键默认事件
 */
function prevDefHotKey(e) {
    var key = e.keyCode || e.which || e.charCode;
    var defKeyAry = [112, 114, 116, 122];
    if ((defKeyAry.indexOf(key) != -1) || (e.ctrlKey && (key == 82))) {
        return stopDefault(e);
    }
    return true;
}

function getPersistClsObj(clsName, id) {
	return $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: clsName, id: id}, false);
}

function getPropValById(tabName, id, prop) {
	return $.m({ClassName: "web.DHCBillCommon", MethodName: "GetPropValById", tabName: tabName, id: id, prop: prop}, false);
}

function getPageCfgValue(cspName, code, groupId, hospId) {
	return $.m({ClassName: "web.DHCBillPageConf", MethodName: "GetPageConfValue", cspName: cspName, code: code, groupId: groupId, hospId: hospId}, false);
}

//Cookie操作
function setCookie(c_name, value, expiredays) {
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + expiredays);
    var cookieVal = c_name + "=" + escape(value) + ((expiredays == null) ? "" : ";expires=" + exdate.toGMTString());
    document.cookie = cookieVal;
}

//获取Cookie
function getCookie(c_name) {
    if (document.cookie.length > 0) {
        var c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            var c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) {
                c_end = document.cookie.length;
            }
            //document.write(document.cookie.substring(c_start, c_end) + "<br>");
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }
    return "";
}