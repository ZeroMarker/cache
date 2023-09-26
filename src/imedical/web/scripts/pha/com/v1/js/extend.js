/**
 * 名称:	 药房公共-插件扩展
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12
 * 扩展包含:
 */

(function ($) {
    /**
     * datagrid 属性增加
     */
    $.extend($.fn.datagrid.defaults, {
        editIndex: undefined, // 当前编辑行
        checking: ''
    });

    /**
     * datagrid方法增加与继承修改
     */
    $.extend($.fn.datagrid.methods, {
        /**
         * 增加一行
         * @param {object} jq
         * @param {object} _options
         * @param {object} [_options.defaultRow] - 新增后,默认的列数据
         * @param {string} [_options.editField] - 新增后,默认的列数据
         */
        addNewRow: function (jq, _options) {
            return jq.each(function () {
                if ($(this).datagrid('endEditing')) {
                    if (_options.defaultRow) {
                        $(this).datagrid('appendRow', _options.defaultRow);
                    } else {
                        $(this).datagrid('appendRow', {});
                    }
                    var rowIndex = $(this).datagrid('getRows').length - 1;
                    $(this).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
                    if (_options.editField) {
                        var ed = $(this).datagrid('getEditor', {
                            index: rowIndex,
                            field: _options.editField
                        });
                        if (ed.type.indexOf('combo') >= 0) {
                            $(ed.target).combobox('textbox').focus();
                        } else {
                            $(ed.target).focus();
                        }
                    }
                    $(this).datagrid('options').editIndex = rowIndex;
                }
            });
        },
        /**
         * 开始编辑行
         * @param {object} _options
         * @param {number} _options.rowIndex - 要编辑的行
         * @param {string} [_options.editField] - 要编辑的列
         */
        beginEditRow: function (jq, _options) {
            return jq.each(function () {
                if ($(this).datagrid('endEditing')) {
                    $(this).datagrid('clearSelections');
                    $(this).datagrid('selectRow', _options.rowIndex).datagrid('beginEdit', _options.rowIndex);
                    $(this).datagrid('options').editIndex = _options.rowIndex;
                    if (_options.editField) {
                        var ed = $(this).datagrid('getEditor', {
                            index: _options.rowIndex,
                            field: _options.editField
                        });
                        if (ed.type.indexOf('combo') >= 0) {
                            $(ed.target).combobox('textbox').focus();
                        } else {
                            $(ed.target).focus();
                        }
                    }
                }
            });
        },
        /**
         * 开始编辑单元格
         * @param {object} _options
         * @param {number} _options.index - 要编辑的行
         * @param {string} _options.field - 要编辑的列,对应field
         */
        beginEditCell: function (jq, _options) {
            return jq.each(function () {
                if ($(this).datagrid('endEditing')) {
                    var index = _options.index;
                    var field = _options.field;
                    $(this).datagrid('options').editIndex = index;
                    $(this).datagrid('selectRow', index).datagrid('editCell', {
                        index: index,
                        field: field
                    });
                    if (field != '') {
                        var ed = $(this).datagrid('getEditor', {
                            index: index,
                            field: field
                        });
                        if (ed != null) {
                            $(ed.target).focus();
                            $(ed.target).next().children().focus();
                        }
                    }
                }
            });
        },
        /**
         * 触发行编辑结束，如果完成则保存
         * @returns {boolean} true - 成功 , false - 失败
         */
        endEditing: function (jq, _options) {
            var $_grid = $('#' + jq[0].id);
            var editIndex = $_grid.datagrid('options').editIndex;
            // 注意:严格等于
            if (editIndex == undefined) {
                return true;
            } else {
                if ($_grid.datagrid('validateRow', editIndex)) {
                    $_grid.datagrid('endEdit', editIndex);
                    $_grid.datagrid('options').editIndex = undefined;
                    return true;
                } else {
                    $_grid.datagrid('selectRow', editIndex);
                    return false;
                }
            }
        },
        /**
         * 查询
         * @param {object} _options  - 要覆写的查询参数
         */
        query: function (jq, _options) {
            return jq.each(function () {
                var _queryParams = $(this).datagrid('options').queryParams;
                $.extend(_queryParams, _options);
                $(this).datagrid('load');
                $(this).datagrid('options').editIndex = undefined;
            });
        },
        /**
         * 清空表格,同时清除查询参数
         */
        clear: function (jq) {
            return jq.each(function () {
                $(this).datagrid('loadData', {
                    total: 0,
                    rows: []
                });
                var _queryParams = $(this).datagrid('options').queryParams;
                var _baseParams = {};
                if (_queryParams.ClassName) {
                    _baseParams.ClassName = _queryParams.ClassName;
                }
                if (_queryParams.QueryName) {
                    _baseParams.QueryName = _queryParams.QueryName;
                }
                $(this).datagrid('options').queryParams = _baseParams;
            });
        },
        /**
         * 验证数据重复,注意调用了PHA_UTIL.js中的function
         * @param {array[]} chkKeyDataArr - 二维数组
         *                                  举例[[a,b],[c]],代表判断ab同时重复或者c重复
         */
        checkRepeat: function (jq, chkKeyDataArr) {
            var retJson = {};
            var $this = $('#' + jq[0].id);
            var rows = $this.datagrid('getRows');
            var rowsLen = rows.length;
            var newRows = [];
            for (var i = 0; i < rowsLen; i++) {
                var iRow = rows[i];
                if ($this.datagrid('getRowIndex', iRow) < 0) {
                    continue;
                }
                newRows.push(iRow);
            }
            chkKeyDataArr.unshift(newRows);
            var repeatObj = PHA_UTIL.Array.GetRepeat.apply(null, chkKeyDataArr); // ! 调外部了,注意
            var pos = repeatObj.pos;
            var repeatPos = repeatObj.repeatPos;
            var repeatKeyArr = repeatObj.keyArr;
            if (typeof pos === 'undefined') {
                return retJson;
            }
            var colTitleObj = {};
            var cols = $this.datagrid('options').columns[0];
            for (var cI = 0; cI < cols.length; cI++) {
                var colIModal = cols[cI];
                if (colIModal.hidden || colIModal.checkbox) {
                    continue;
                }
                var cIField = colIModal.field;
                if (cIField) {
                    colTitleObj[cIField] = colIModal.title;
                }
            }
            var titleArr = [];
            for (var j = 0; j < repeatKeyArr.length; j++) {
                var field = repeatKeyArr[j];
                titleArr.push(colTitleObj[field]);
            }
            return {
                pos: pos,
                repeatPos: repeatPos,
                titleArr: titleArr
            };
        }
    });
    /**
     * triggerbox 增加Id值
     */
    $.extend($.fn.triggerbox.defaults, {
        valueId: ''
    });
    $.extend($.fn.triggerbox.methods, {
        setValueId: function (target, val) {
            $(target).triggerbox('options').valueId = val;
        },
        getValueId: function (target) {
            var realVal = $(target).triggerbox('options').valueId;
            if ($(target).triggerbox('getValue') == '') {
                realVal = '';
            }
            return realVal;
        }
    });
    /**
     * lookup 增加Value值
     */
    $.extend($.fn.lookup.defaults, {
        value: ''
    });
    $.extend($.fn.lookup.methods, {
        setValue: function (target, val) {
            $(target).lookup('options').value = val;
        },
        getValue: function (target) {
            var realVal = $(target).lookup('options').value;
            if ($(target).lookup('getText') == '') {
                realVal = '';
            }
            return realVal;
        }
    });

    /**
     * combobox 增加方法
     */
    $.extend($.fn.combobox.methods, {
        /**
         * 设置默认值,在onloadsuccess后
         * @param {string} value - 对应的valueId的值
         */
        setDefaultValue: function (jq, value) {
            return jq.each(function () {
                var $this = $.data(jq[0], 'combobox');
                var valueField = $this.options.valueField;
                var data = $.data(jq[0], 'combobox').data;
                for (var i = 0; i < data.length; i++) {
                    if (data[i][valueField] == value) {
                        $(jq[0]).combobox('setValue', value);
                    }
                }
            });
        },
        /**
         * 设置默认值并触发select,在onloadsuccess后
         * @param {string} value - 对应的valueId的值
         */
        selectDefault: function (jq, value) {
            return jq.each(function () {
                var $this = $.data(jq[0], 'combobox');
                var valueField = $this.options.valueField;
                var data = $.data(jq[0], 'combobox').data;
                for (var i = 0; i < data.length; i++) {
                    if (data[i][valueField] == value) {
                        $(jq[0]).combobox('select', value);
                    }
                }
            });
        }
    });
})(jQuery);
