/**
 * ����:	 ҩ������-�����չ
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 * ��չ����:
 */

(function ($) {
    /**
     * datagrid ��������
     */
    $.extend($.fn.datagrid.defaults, {
        editIndex: undefined, // ��ǰ�༭��
        checking: ''
    });

    /**
     * datagrid����������̳��޸�
     */
    $.extend($.fn.datagrid.methods, {
        /**
         * ����һ��
         * @param {object} jq
         * @param {object} _options
         * @param {object} [_options.defaultRow] - ������,Ĭ�ϵ�������
         * @param {string} [_options.editField] - ������,Ĭ�ϵ�������
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
         * ��ʼ�༭��
         * @param {object} _options
         * @param {number} _options.rowIndex - Ҫ�༭����
         * @param {string} [_options.editField] - Ҫ�༭����
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
         * ��ʼ�༭��Ԫ��
         * @param {object} _options
         * @param {number} _options.index - Ҫ�༭����
         * @param {string} _options.field - Ҫ�༭����,��Ӧfield
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
         * �����б༭�������������򱣴�
         * @returns {boolean} true - �ɹ� , false - ʧ��
         */
        endEditing: function (jq, _options) {
            var $_grid = $('#' + jq[0].id);
            var editIndex = $_grid.datagrid('options').editIndex;
            // ע��:�ϸ����
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
         * ��ѯ
         * @param {object} _options  - Ҫ��д�Ĳ�ѯ����
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
         * ��ձ��,ͬʱ�����ѯ����
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
         * ��֤�����ظ�,ע�������PHA_UTIL.js�е�function
         * @param {array[]} chkKeyDataArr - ��ά����
         *                                  ����[[a,b],[c]],�����ж�abͬʱ�ظ�����c�ظ�
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
            var repeatObj = PHA_UTIL.Array.GetRepeat.apply(null, chkKeyDataArr); // ! ���ⲿ��,ע��
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
     * triggerbox ����Idֵ
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
     * lookup ����Valueֵ
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
     * combobox ���ӷ���
     */
    $.extend($.fn.combobox.methods, {
        /**
         * ����Ĭ��ֵ,��onloadsuccess��
         * @param {string} value - ��Ӧ��valueId��ֵ
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
         * ����Ĭ��ֵ������select,��onloadsuccess��
         * @param {string} value - ��Ӧ��valueId��ֵ
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
