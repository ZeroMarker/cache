/**
 * 生命体征数据总览编辑
 * @author yongyang 2018-04-03
 */
$.extend($.fn.validatebox.defaults.rules, {
    numeric: {
        validator: function(value, param) {
            return (/^\d*\.?\d*$/).test(value);
        },
        message: 'Please enter a right number.'
    }
});

$.extend($.fn.datagrid.defaults.editors, {
    vitalsignbox: {
        init: function(container, options) {
            var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container);
            $(input).validatebox({
                validateType: 'numeric'
            });

            return input;
        },
        destroy: function(target) {
            $(target).remove();
        },
        getValue: function(target) {
            var value = $(target).data('data');
            if (typeof value === 'object') {
                value.DataValue = $(target).validatebox('getValue');
            } else {
                value = {
                    RowId: '',
                    ParaItem: '',
                    StartDT: '',
                    StartDate: '',
                    StartTime: '',
                    OriginalValue: '',
                    DataValue: $(target).validatebox('getValue')
                };
            }
            return value;
        },
        setValue: function(target, value) {
            if (typeof value === 'object') {
                $(target).data('data', value);
                value.OriginalValue = value.OriginalValue === undefined ? value.DataValue : '';
                $(target).validatebox('setValue', value.DataValue);
            } else {
                var data = {
                    RowId: '',
                    ParaItem: '',
                    StartDT: '',
                    StartDate: '',
                    StartTime: '',
                    OriginalValue: value || '',
                    DataValue: value || ''
                };
                $(target).data('data', data);
                $(target).validatebox('setValue', value);
            }
        },
        resize: function(target, width) {
            $(target).validatebox('resize', width);
        }
    }
});

(function(global, factory) {
    if (!global.vitalSignDataManager) factory(global.vitalSignDataManager = {});
}(this, function(exports) {

    function init(opt) {
        var view = new VitalSignDataManager(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function VitalSignDataManager(opt) {
        this.dom = null;
        this.options = { width: 800, height: 500 };
        this.saveHandler = opt.saveHandler;
        $.extend(this.options, opt);
        this.init();
    }

    VitalSignDataManager.prototype = {
        constructor: VitalSignDataManager,
        /**
         * 初始化
         */
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                iconCls: 'icon-save',
                text: '保存',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);
            var btn_close = $('<a href="#"></a>').linkbutton({
                iconCls: 'icon-cancel',
                text: '关闭',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                closed: true,
                title: '生命体征数据总览',
                width: 800,
                height: 500,
                top: 100,
                modal: true,
                buttons: buttons,
                onOpen: function() {
                    _this.isSaved = false;
                },
                onBeforeClose: function() {
                    return _this.verifySavingStatus();
                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.container = $(this.dom.find('.panel-body'));
        },
        /**
         * 初始化表格
         */
        initGrid: function(data) {
            if (this.datagrid) {
                this.destroyDataGrid();
            }
            this.datagrid = $('<table></table>').appendTo(this.container);

            var tool = $('<div style="padding:5px;"></div>');
            this.initGridTool(tool, data.groups);

            this.datagrid.datagrid({
                fit: true,
                singleSelect: true,
                rownumbers: true,
                fitColumns: false,
                toolbar: tool,
                frozenColumns: [
                    [
                        { field: "ParaItemDesc", title: "项目", width: 100 }
                    ]
                ],
                columns: setColumnsAttr(data.columns),
                onBeginEdit: function(index, row) {
                    var field = "",
                        nextField = "";
                    var _this = $(this);
                    var fields = _this.datagrid('getColumnFields');
                    var length = fields.length;
                    var firstField = fields[0];
                    for (var i = 0; i < length; i++) {
                        field = fields[i];
                        var ed = _this.datagrid('getEditor', { index: index, field: field });
                        if (ed) {
                            if (ed.target) {
                                if (i < length - 1) nextField = fields[i + 1];
                                ed.target.keyup(function(e) {
                                    if (e.keyCode == 13) {
                                        var value = $(this).data('data');
                                        if (typeof value === 'object') {
                                            value.OriginalValue = value.OriginalValue === undefined ? value.DataValue : value.OriginalValue;
                                            value.DataValue = $(this).val();
                                            $(this).data('data', value);
                                            $(this).validatebox('setValue', value.DataValue);
                                        } else {
                                            var data = {
                                                RowId: '',
                                                ParaItem: '',
                                                StartDT: '',
                                                StartDate: '',
                                                StartTime: '',
                                                OriginalValue: $(this).val() || '',
                                                DataValue: $(this).val() || ''
                                            };
                                            $(this).data('data', data);
                                            $(this).validatebox('setValue', $(this).val());
                                        }
                                        _this.datagrid('endEdit', index);
                                        _this.datagrid('editCell', { index: nextField ? index : index + 1, field: nextField ? nextField : firstField });
                                    }
                                });
                            }
                        }
                    }
                },
                onEndEdit: function(index, row, changes) {

                },
                onAfterEdit: function(index, row, changes) {

                },
                onCancelEdit: function(index, row) {

                }
            });
            this.datagrid.datagrid('enableCellEditing');
        },
        /**
         * 初始化表格工具
         */
        initGridTool: function(container, groups) {
            var _this = this;
            $.each(groups, function(index, group) {
                var button = $('<a href="#" class="vsdm-tool-button"></a>');
                button.text(group.text);
                button.data('data', group);
                button.linkbutton({
                    onClick: function() {
                        var group = $(this).data('data');
                        _this.showGrid(group);
                    }
                });
                container.append(button);
            })
        },
        /**
         * 打开
         */
        open: function() {
            this.dom.dialog('open');
            this.saved = false;
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        /**
         * 清空
         */
        clear: function() {
            this.destroyDataGrid();
        },
        /**
         * 加载数据
         */
        loadData: function(data) {
            this.initGrid(data.timeColumnList);
            this.datagrid.datagrid('loadData', data.rows);
        },
        /**
         * 显示表格
         */
        showGrid: function(group) {
            var datagrid = this.datagrid;
            var options = datagrid.datagrid('options');
            //单列分别隐藏和显示，是否会效率不高？界面闪烁？
            $.each(options.columns[0], function(index, col) {
                datagrid.datagrid('hideColumn', col.field);
            });

            $.each(group.columns, function(index, colField) {
                datagrid.datagrid('showColumn', colField);
            });
        },
        /**
         * 删除表格元素
         */
        destroyDataGrid: function() {
            this.container.empty();
            this.datagrid = null;
        },
        /**
         * 核实保存状态
         */
        verifySavingStatus: function() {
            var _this = this;
            if (this.hasUnsavedData() && !this.saved) {
                $.extend($.messager.defaults, {
                    ok: '是',
                    cancel: '否'
                });
                $.messager.confirm('数据未保存', '有已修改的数据但还未保存，是否保存？', function(confirmed) {
                    if (confirmed) _this.save();
                    else _this.saveHandler();
                    _this.saved = true;
                    _this.close();
                });
                $.extend($.messager.defaults, {
                    ok: '确认',
                    cancel: '取消'
                });
                return false;
            }
            return true;
        },
        /**
         * 是否有未保存的数据
         */
        hasUnsavedData: function() {
            if (!this.datagrid || this.isSaved) return;
            var options = this.datagrid.datagrid('options');
            var rows = this.datagrid.datagrid('getRows');
            var columns = options.columns[0];
            var rowLength = rows.length;
            var colLength = columns.length;
            for (var i = 0; i < rowLength; i++) {
                var row = rows[i];
                for (var j = 0; j < colLength; j++) {
                    var column = columns[j];
                    var value = row[column.field];
                    if (!value || value.OriginalValue === undefined) continue;
                    if (value.RowId === '' && value.DataValue === '') continue;
                    if (value.RowId === '' || value.OriginalValue != value.DataValue) {
                        return true;
                    }
                }
            }
            return false;
        },
        /**
         * 保存数据
         */
        save: function() {
            var datagrid = this.datagrid;
            var row = datagrid.datagrid('getSelected');
            if (row) {
                var rowIndex = datagrid.datagrid('getRowIndex', row);
                datagrid.datagrid('endEdit', rowIndex);
            }

            var savingDatas = this.getEditedDatas();
            this.saveHandler(savingDatas);
            this.isSaved = true;
        },
        /**
         * 获取已改变的数据
         */
        getEditedDatas: function() {
            var options = this.datagrid.datagrid('options');
            var rows = this.datagrid.datagrid('getRows');
            var columns = options.columns[0];
            var rowLength = rows.length;
            var colLength = columns.length;
            var createUserID = session.UserID;
            var savingDatas = [];
            var vitalSignDataClassName = ANCLS.Model.AnaData;
            for (var i = 0; i < rowLength; i++) {
                var row = rows[i];
                for (var j = 0; j < colLength; j++) {
                    var column = columns[j];
                    var value = row[column.field];
                    if (!value || value.OriginalValue === undefined) continue;
                    if (value.RowId === '') {
                        if (value.DataValue != '') {
                            savingDatas.push($.extend({}, value, {
                                RowId: '',
                                SheetRecord: '',
                                ParaItem: row.ParaItem,
                                DataItem: row.DataItem || '',
                                StartDate: column.date,
                                StartTime: column.time,
                                EndDate: column.date,
                                EndTime: column.time,
                                EditFlag: 'N',
                                ClassName: vitalSignDataClassName,
                                CreateUserID: createUserID
                            }));
                        }
                    } else if (value.OriginalValue != value.DataValue) {
                        savingDatas.push($.extend({}, value, {
                            ParaItem: row.ParaItem,
                            DataItem: row.DataItem || '',
                            StartDate: column.date,
                            StartTime: column.time,
                            EndDate: column.date,
                            EndTime: column.time,
                            DataValue: value.OriginalValue,
                            EditFlag: 'D',
                            ClassName: vitalSignDataClassName
                        }));
                        if (value.DataValue) savingDatas.push($.extend({}, value, {
                            RowId: '',
                            SheetRecord: '',
                            FromData: value.RowId,
                            ParaItem: row.ParaItem,
                            DataItem: row.DataItem || '',
                            StartDate: column.date,
                            StartTime: column.time,
                            EndDate: column.date,
                            EndTime: column.time,
                            EditFlag: 'N',
                            ClassName: vitalSignDataClassName,
                            CreateUserID: createUserID
                        }));
                    }
                }
            }

            return savingDatas;
        }
    }

    /**
     * 值转换方法，当单元格中数据为一个对象时能否成功调用？
     * @param {*} value 
     * @param {*} row 
     * @param {*} index 
     */
    function cellFormatter(value, row, index) {
        if (typeof value === 'object') {
            if (value.OriginalValue != undefined && value.OriginalValue != value.DataValue) {
                if (Number(value.DataValue) > 0) {
                    return '<span title="此数值已修改过但还未保存！">' + value.DataValue + '</span>';
                } else if (value.DataValue === '') return '<div style="width:40px;height:30px;" title="原数值(' + value.OriginalValue + ')已被删除但还未保存！">' + value.DataValue + '</div>';
            }
            return value.DataValue || '';
        } else return value || '';
    }

    /**
     * 单元格样式
     * @param {*} value 
     * @param {*} row 
     * @param {*} index 
     */
    function cellStyler(value, row, index) {
        if (typeof value === 'object') {
            if (value.OriginalValue != undefined && value.OriginalValue != value.DataValue) {
                if (Number(value.DataValue) > 0) return { style: 'border: #4b9be4 solid 0.5px;font-style: italic;' };
                else if (value.DataValue === '') return { style: 'border: #ff0000 solid 0.5px;' };
            }
        }
    }

    /**
     * 设置列属性
     * @param {*} columns 
     */
    function setColumnsAttr(columns) {
        $.each(columns, function(index, col) {
            $.extend(col, {
                width: 50,
                editor: 'vitalsignbox',
                formatter: cellFormatter,
                styler: cellStyler
            });
        });
        return [columns];
    }

    return exports;
}));