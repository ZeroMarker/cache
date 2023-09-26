/**
 * creator:		yunhaibao
 * createdate:	2018-05-22
 * description:	药房对应HISUI的一些插件扩展
 */
$(function() {
    /// combobox添加getValue方法,原默认是继承自combo
    $.fn.combobox.methods = $.extend({}, $.fn.combobox.methods, {
        /*
        getValue: function(jq) {
            var id = jq[0].id;
            var val = $('#' + id).combo('getValue')
            if (val == undefined) {
                val = "";
            }
            return val;
        },*/
        query: function(jq, _options) {
            return jq.each(function() {
                var comboOpts = $(this).combobox("options");
                if ($(this).combobox("options").ClassName) {
                    var _url = "DHCST.QUERY.BROKER.csp?DataType=Array&ClassName=" + comboOpts.ClassName + "&QueryName=" + comboOpts.QueryName;
                    for (var _qField in _options) {
                        var _qValue = _options[_qField];
                        _url += "&" + _qField + "=" + _qValue;
                    }
                    comboOpts.url = _url;
                    $(this).combobox('clear');
                    $(this).combobox('reload');
                }
            })
        }
    });
    // 验证
    $.extend($.fn.validatebox.defaults.rules, {
        // 是否正数
        PosNumber: {
            validator: function(value, param) {
                var regTxt = /^[0-9]+\.?[0-9]{0,9}$/;
                return regTxt.test(value);
            },
            message: '请输入正数'
        }
    });
    // datagrid 扩充属性---待定
    $.extend($.fn.datagrid.defaults, {
        // 当前编辑行
        editIndex: undefined
    });
    // datagrid 扩充方法
    $.extend($.fn.datagrid.methods, {
        // 判断是否修改完成
        // flag:    add-代表增加新行
        endEditing: function(jq) {
            return jq.each(function() {
                var editIndex = $(this).datagrid('options').editIndex;
                if (editIndex == undefined) {

                } else {
                    if ($(this).datagrid('validateRow', editIndex)) {
                        $(this).datagrid('endEdit', editIndex);
                        $(this).datagrid('options').editIndex = undefined;
                    } else {
                        //setTimeout(function() {
                        $(this).datagrid('selectRow', editIndex);
                        //}, 0);
                        //$(this).datagrid('cancelEdit', editIndex);
                        //$(this).datagrid('options').editIndex = undefined;
                    }
                }
            })
        },
        cancelEditRow: function(jq) {
            return jq.each(function() {
                var editIndex = $(this).datagrid('options').editIndex;
                if (editIndex == undefined) {

                } else {
                    $(this).datagrid('cancelEdit', editIndex);
                    $(this).datagrid('options').editIndex = undefined;
                }
            })
        },
        // 增加编辑行
        addNewRow: function(jq, _options) {
            return jq.each(function() {
                $(this).datagrid('endEditing');
                if ($(this).datagrid('options').editIndex == undefined) {
                    if (_options.defaultRow) {
                        $(this).datagrid('appendRow', _options.defaultRow);
                    } else {
                        $(this).datagrid('appendRow', {});
                    }

                    var rowIndex = $(this).datagrid("getRows").length - 1;
                    $(this).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
                    var ed = $(this).datagrid('getEditor', { index: rowIndex, field: _options.editField });
                    if ((ed.type).indexOf("combo") >= 0) {
                        $(ed.target).combobox('textbox').focus();
                    } else {
                        $(ed.target).focus();
                    }
                    $(this).datagrid('options').editIndex = rowIndex;

                }
            });
        },
        // 开始编辑行
        beginEditRow: function(jq, _options) {
            return jq.each(function() {
                $(this).datagrid('endEditing');
                if ($(this).datagrid('options').editIndex == undefined) {
                    var rowIndex = _options.rowIndex;
                    var editField = _options.editField;
                    $(this).datagrid('selectRow', _options.rowIndex).datagrid('beginEdit', rowIndex);
                    if ($(window.event.target).parent().attr('field')) {
                        editField = $(window.event.target).parent().attr('field');
                    }
                    if (editField) {
                        var ed = $(this).datagrid('getEditor', { index: rowIndex, field: editField });
                        if (ed) {
                            $(ed.target).focus();
                        }
                    }
                    $(this).datagrid('options').editIndex = _options.rowIndex;
                }
            });
        },
        // 清空
        clear: function(jq) {
            return jq.each(function() {
                $(this).datagrid('loadData', { total: 0, rows: [] });
                var _queryParams = $(this).datagrid("options").queryParams;
                var _baseParams = {};
                if (_queryParams.ClassName) {
                    _baseParams.ClassName = _queryParams.ClassName;
                }
                if (_queryParams.QueryName) {
                    _baseParams.QueryName = _queryParams.QueryName;
                }
                $(this).datagrid("options").queryParams = _baseParams;
            })
        },
        // 查询
        // _options:除ClassName,QueryName之外的查询参数
        query: function(jq, _options) {
            return jq.each(function() {
                if ($(this).datagrid("options").pageNumber == 0) {
                    $(this).datagrid("options").pageNumber = 1;
                }
                var _queryParams = $(this).datagrid("options").queryParams;
                $.extend(_queryParams, _options);
                $(this).datagrid('reload');
            })
        }
    });

    // datagrid-editor 扩展
    $.extend($.fn.datagrid.defaults.editors, {
        timespinner: {
            init: function(container, options) {
                var input = $('<input/>').appendTo(container);
                input.timespinner(options);
                return input;
            },
            getValue: function(target) {
                var val = $(target).timespinner('getValue');
                return val;
            },
            setValue: function(target, value) {
                $(target).timespinner('setValue', value);
            },
            resize: function(target, width) {
                $(target).timespinner("resize", width);
            }
        }
    });

});
/* 修改checkbox样式...
var newChk = $.extend({}, $.fn.datagrid.defaults.view, {
    render: function(_6d0, _6d1, _6d2) {
        var _6d3 = $.data(_6d0, "datagrid");
        var opts = _6d3.options;
        var rows = _6d3.data.rows;
        var _6d4 = $(_6d0).datagrid("getColumnFields", _6d2);
        if (_6d2) {
            if (!(opts.rownumbers || (opts.frozenColumns && opts.frozenColumns.length))) {
                return;
            }
        }
        var _6d5 = ["<table class=\"datagrid-btable\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tbody>"];
        for (var i = 0; i < rows.length; i++) {
            var css = opts.rowStyler ? opts.rowStyler.call(_6d0, i, rows[i]) : "";
            var _6d6 = "";
            var _6d7 = "";
            if (typeof css == "string") {
                _6d7 = css;
            } else {
                if (css) {
                    _6d6 = css["class"] || "";
                    _6d7 = css["style"] || "";
                }
            }
            var cls = "class=\"datagrid-row " + (i % 2 && opts.striped ? "datagrid-row-alt " : " ") + _6d6 + "\"";
            var _6d8 = _6d7 ? "style=\"" + _6d7 + "\"" : "";
            var _6d9 = _6d3.rowIdPrefix + "-" + (_6d2 ? 1 : 2) + "-" + i;
            _6d5.push("<tr id=\"" + _6d9 + "\" datagrid-row-index=\"" + i + "\" " + cls + " " + _6d8 + ">");
            _6d5.push(this.renderRow.call(this, _6d0, _6d4, _6d2, i, rows[i]));
            _6d5.push("</tr>");
        }
        _6d5.push("</tbody></table>");
        $(_6d1).html(_6d5.join(""));
        $("input:checkbox").checkbox();
    }
});
*/