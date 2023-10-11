/*
 * @Descripttion: 右键引用公共
 * @Author: yaojining
 */

/**
 * @description: 初始化查询条件
 */
function initConditions() {
    if (($('.content_hidden_td').length > 0) && (JSON.parse(parent.GV.SwitchInfo.AllVisitFlag))) {
        $('.content_hidden_td').css('display', 'revert');
    }
    if ($('#startDate').length > 0) {
        getDateTime(1, -3, function (dt) {
            $('#startDate').datebox('setValue', dt);
        });
    }
    if (typeof initCondition == 'function') {
        initCondition();
    }
}

/**
 * @description: 请求配置
 */
function requestConfig() {
    var callbackFun = arguments.length > 0 ? arguments[0] : '';
    var ifSetGroup = arguments.length > 1 ? arguments[1] : true;
    var code = arguments.length > 2 ? arguments[2] : GV.code;
    $cm({
        ClassName: 'NurMp.Service.Refer.Setting',
        MethodName: 'getReferTabConfig',
        HospitalID: GV.hospitalID,
        Code: code,
    }, function (config) {
        if ((ifSetGroup) && (typeof organizeColumns == 'function')) {
            organizeColumns(config);
        }
        if ((!!GV) && (typeof GV.ConfigInfo != 'undefined') && (!!code)) {
            GV.ConfigInfo[code] = config;
        }
        if (typeof callbackFun == 'function') {
            return callbackFun(config);
        } else {
            console.log(config);
        }
    });
}

/**
 * @description: 组织列
 */
function organizeColumns(config) {
    if ($('#' + GV.groupID).length == 0) {
        return false;
    }
    var column_arr = new Array();
    var column_filter = new Array();
    var columns_frozen = config.frozenColumns;
    if ((!!columns_frozen) && (columns_frozen.length > 0)) {
        column_arr = column_arr.concat(columns_frozen[0]);
    }
    var columns = config.columns;
    if ((!!columns) && (columns.length > 0)) {
        column_arr = column_arr.concat(columns[0]);
    }
    if ((!columns_frozen) && (!columns)) {
        $.messager.alert($g('提示'), $g('未配置列属性，请到【护理病历配置-右键引用配置】页面进行维护！'));
        return false;
    }
    $.each(column_arr, function (i, c) {
        if (c.field == 'checkbox') {
            return true;
        }
        var column = { id: c.field, text: $g(c.title) };
        column_filter.push(column);
    });
    $('#' + GV.groupID).combobox({
        valueField: 'id',
        textField: 'text',
        multiple: true,
        rowStyle: 'checkbox',
        selectOnNavigation: false,
        data: column_filter,
        blurValidValue: true,
        allSelectButtonPosition: 'bottom',
        defaultFilter: 6,
        onLoadSuccess: function () {
            $m({
                ClassName: 'NurMp.Service.Refer.Handle',
                MethodName: 'gridWords',
                TabCode: GV.groupID,
                UserID: session['LOGON.USERID']
            }, function (column_selected) {
                if (!!column_selected) {
                	$('#' + GV.groupID).combobox('setValues', column_selected.split('^'));
	            }
            });
        }
    });
}

function saveWords() {
    var wordsStr = '';
    var wordsArr = $('#' + GV.groupID).combobox('getValues');
    for (var k = 0; k < wordsArr.length; k++) {
        var word = wordsArr[k];
        wordsStr = !!wordsStr ? wordsStr + '^' + word : word;
    }
    $cm({
        ClassName: GV.className,
        MethodName: 'saveWords',
        TabCode: GV.groupID,
        WordsStr: wordsStr,
        UserID: session['LOGON.USERID']
    }, function (result) {
        console.log('保存成功!');
    });
}

/**
 * @description: 写入预览
 * @param {content} 
 */
function writToPreview(content) {
    parent.insertContent(content);
}

/**
 * @description: 字符串替换
 * @param {content} 
 */
function replaceString(content, text, value) {
    if (!content) {
        return '';
    }
    if ((text == '日期') || (text == '时间')) {
        content = content.replace(new RegExp('{列名}:', 'g'), '').replace(new RegExp('{列名}：', 'g'), '')
    }
    return String(content.replace(new RegExp('{换行符}', 'g'), '\n').replace(new RegExp('{空格}', 'g'), ' ').replace(new RegExp('{列名}', 'g'), text).replace(new RegExp('{值}', 'g'), value));
}

/**
 * @description: 计算pageSize
 * @param {string} domId 
 * @return {string} size
 */
function pageSize(domId) {
    var grid_height = $('#' + domId).datagrid('options').height;
    var size = parseInt((grid_height - 40) / 40);
    return size;
}

/**
 * @description: 计算pageList
 
 * @return {array} list
 */
function pageList() {
    var domId = arguments.length > 0 ? arguments[0] : 'dataGrid';
    var size = pageSize(domId);
    var list = new Array();
    var start = 15
    if (size > 15) {
        start = 20;
    }
    list[0] = size;
    list[1] = start;
    list[2] = 30;
    list[3] = 40;
    list[4] = 50;
    list[5] = 100;
    return list;
}

/// 以项目+数值+单位 拼接引用值
function remakeItemData(itemData, checkDesc) {
    var symbol = checkDesc.indexOf('(') > -1 ? '(' : '（';
    var afterSym = symbol == '(' ? ')' : '）';
    var descArr = checkDesc.split(symbol);
    if (descArr.length > 1) {
        //itemData = descArr[0] + ':' + itemData + descArr[1].replace(afterSym,'');
        itemData = itemData + descArr[1].replace(afterSym, '');
    }
    return itemData;
}

/// 以项目+数值+单位 拼接引用值 血糖用
function remakeItemDataBg(itemData, checkDesc, timeValue) {
	if (checkDesc != "日期") checkDesc = checkDesc + "(";
	var symbol = checkDesc.indexOf('(') > -1 ? '(' : '（';
	var afterSym = symbol == '(' ? ')' : '）';
	var descArr = checkDesc.split(symbol);
	if (descArr.length > 1) {
		if (timeValue != "") {
			itemData = '时间:' + timeValue + " " + descArr[0] + ':' + itemData + descArr[1].replace(afterSym, '');
		} else {
			itemData = descArr[0] + ':' + itemData + descArr[1].replace(afterSym, '');
		}
	}
	return itemData;
}

/**
 * @description: 写入
 */
function writeIn() {
    // 极度个性化的程序需要单独写
    if (typeof customWriteIn == 'function') {
        customWriteIn();
        return false;
    }
    var result = '';
    // 交班特殊处理
    if (GV.code == 'Shift') {
        var tab = $('#clsTab').tabs('getSelected');
        if ((!tab) || (tab.length == 0)) {
            $.messager.popover({ msg: $g('未配置交班班次！'), type: 'alert' });
            return false;
        }
	    var index = $('#clsTab').tabs('getTabIndex',tab);			
	    var rows = $('#dg' + index).datagrid('getSelections');
    } else {
        var rows = $('#dataGrid').datagrid('getSelections');
    }
    if (rows.length == 0) {
        // 检验特殊处理
        if (GV.code == 'Lis') {
            $.messager.popover({ msg: $g('请选择检验项目！'), type: 'alert' });
        } else if (GV.code == 'Pacs') {
            $.messager.popover({ msg: $g('请选择检查项目！'), type: 'alert' });
        } else {
            $.messager.popover({ msg: $g('请选择需要引入的内容！'), type: 'alert' });
        }
        return false;
    }
    // 检验特殊处理
    var lisItems = rows;
    if (GV.code == 'Lis') {
        var data = $('#dataSubGrid').datagrid('getData');
        if (data.rows.length < 1) {
            $.messager.popover({ msg: $g('检验结果未出！'), type: 'alert' });
            return false;
        }
        rows = $('#dataSubGrid').datagrid('getSelections');
        if (rows.length < 1) {
            $.messager.popover({ msg: $g('请选择检验结果！'), type: 'alert' });
            return false;
        }
    } else if (GV.code == 'Pacs') {
        var current_class = $('#textContent').attr('class');
        if (current_class == 'noreport_textarea') {
            $.messager.popover({ msg: $g('检查报告未出!'), type: 'alert' });
            return;
        }
        result = $('#textContent').val();
    }else{
        console.log(GV.code);
    }
    if ($('#' + GV.groupID).length > 0) {
        var wordsArr = $('#' + GV.groupID).combobox('getValues');
        if (wordsArr.length == 0) {
            $.messager.popover({ msg: $g('请选择组合！'), type: 'alert' });
            return false;
        }
        var combo_data = $('#' + GV.groupID).combobox('getData');
        $.each(rows, function (index, row) {
            var subResult = '';
            if (!!GV.OtherConfig.referFormat) {
                subResult = replaceString(GV.OtherConfig.formatPrefix, $('#' + GV.groupID).combobox('getText'), '');
            }
            $.each(wordsArr, function (i, word) {
                if (!word) {
                    return true;
                }
                var itemData = row[word];
                itemData = String(itemData);
                // 医嘱名称特殊处理
                if (word.toLowerCase() == 'arcimdesc') {
                    var containIndex = itemData.indexOf('[');
                    if (containIndex == 0) {
                        itemData = itemData.split(']')[1];
                    }
                    containIndex = itemData.indexOf('[');
                    if (containIndex > 0) {
                        itemData = itemData.split('[')[0];
                    }
                }
                var itemText = $.hisui.getArrayItem(combo_data, 'id', word).text;
                // 生命体征特殊处理
                if (GV.code == 'Obs') {
                    itemData = remakeItemData(itemData, itemText)
                    var chars = itemText.indexOf('(') > -1 ? '(' : '（';
                    itemText = itemText.split(chars)[0];
                }
                // 检验特殊处理
                if (GV.code == 'Lis') {
                    if (itemData.indexOf("<sup>") > -1) {
                        itemData = $m({
                            ClassName: 'CF.NUR.EMR.SubScripts',
                            MethodName: 'numberScript',
                            NumberStr: itemData
                        }, false);
                    }
                }
                // 血糖特殊处理
                if (GV.code == 'Bg') {
                    var timeValue = '';
                    if (word.indexOf('Field') > -1)  {
                        var timeField = "Field" + (parseInt(word.split('Field')[1]) + 1);
                        timeValue = row[timeField];
                    }
                    itemData = remakeItemDataBg(itemData, itemText, timeValue)
                }
                if (!!GV.OtherConfig.referFormat) {
                    subResult = subResult + replaceString(GV.OtherConfig.referFormat, itemText, itemData);
                } else {
                    subResult = !subResult ? itemData : subResult + ' ' + itemData;
                }
            });
            if (!!GV.OtherConfig.referFormat) {
                result = result + subResult + replaceString(GV.OtherConfig.formatSuffix, '', '');
            } else {
                result = !!result ? result + '，' + subResult : subResult;
            }
        });
        // 检验特殊处理
        if (GV.code == 'Lis') {
            var lisName = '';
            if (!!lisItems[0].AuthDateTime) {
                lisName = lisItems[0].AuthDateTime.split(' ')[0];
            }
            if (!!lisItems[0].OrdItemName) {
                lisName = !!lisName ? lisName + ' ' + lisItems[0].OrdItemName : lisItems[0].OrdItemName;
            }
            result = lisName + "：" + result;
        }
        writToPreview(result);
        saveWords();
    } else {
        writToPreview(result);
    }
}

/**
 * @description: 公共监听事件
 */
function listenEvents() {
    if ($('.search_table .hisui-datebox').length > 0) {
        $('.search_table .hisui-datebox').datebox({
            onSelect: function (newVal, oldval) {
                $('#btnSearch').click();
            }
        });
    }
    if ($('.search_table .hisui-radio').length > 0) {
        $('.search_table .hisui-radio').radio({
            onCheckChange: function (e, value) {
                $('#btnSearch').click();
            }
        });
    }
    if ($('#btnSearch').length > 0) {
        $('#btnSearch').bind('click', reloadData);
    }
    if ($('#btnWriteIn').length > 0) {
        $('#btnWriteIn').bind('click', writeIn);
    }
    if (typeof listenEvent == 'function') {
        listenEvent();
    }
}