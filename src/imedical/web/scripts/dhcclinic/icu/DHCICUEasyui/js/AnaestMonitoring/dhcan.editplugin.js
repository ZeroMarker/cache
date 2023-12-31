//
/**
 * EditPlugin的构造函数
 * @param {object} options
 * @author yongyang 20171128 
 */
function EditPlugin(options) {
    this.dataItem = options.dataItem;
    this.target = options.target;
    this.buttonVisible = (typeof options.buttonVisible != 'boolean') ? true : options.buttonVisible;
    this.width = this.dataItem.rect.right - this.dataItem.valueStartPos.x;
    this.element = null;
    this.editbox = null;
    this.isClosed = false;
    if (!this.dataItem.editType) {
        this.isClosed = true;
        return;
    }
    this.render();
    this.focus();
}

/**
 * EditPlugin的处理方法
 */
EditPlugin.prototype = {
    /**
     * 构造方法
     */
    constructor: EditPlugin,
    beforeRender: function() {
        var dataItem = this.dataItem;
        if (dataItem.editType == 'checkbox') {
            this.save();
            return false;
        }
        return true;
    },
    /**
     * 渲染方法
     */
    render: function() {
        var _this = this;
        var dataItem = this.dataItem;
        if (!this.beforeRender()) return null;
        if (!dataItem || !dataItem.editType) return null;
        if ($("#editview-" + dataItem.code).length) return null;

        var position = dataItem.valueStartPos;
        var canvasHeight = $(record.sheet.canvas).height();

        var parent = $($(this.target).parent());
        var scrollTop = parent.scrollTop();
        var scrollLeft = parent.scrollLeft();

        var htmlArr = [];
        htmlArr.push("<div id='" + "editplugin-" + dataItem.code + "' class='edit-plugin'");
        htmlArr.push("style='position:absolute;float:left;z-index:100;");
        htmlArr.push("top:" + (position.y - 5 - scrollTop + 50) + "px;");
        htmlArr.push("left:" + (position.x - scrollLeft) + "px'>");
        htmlArr.push("</div>");

        var editPlugin = $(htmlArr.join(""));
        $(this.target).before(editPlugin);

        var saveButton = $('<a href="javascript:;" style="position:absolute;top:0px;">保存</a>')
            .linkbutton({
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            })
            .appendTo(editPlugin);
        var cancelButton = $('<a href="javascript:;" style="position:absolute;top:35px;">取消</a>')
            .linkbutton({
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            })
            .appendTo(editPlugin);

        if (position.x - scrollLeft + dataItem.width + 90 > parent.width()) {
            saveButton.css({
                left: -90
            });
            cancelButton.css({
                left: -90
            });
        } else {
            saveButton.css({
                right: -90
            });
            cancelButton.css({
                right: -90
            });
        }

        if (!this.buttonVisible) {
            saveButton.hide();
            cancelButton.hide();
        }

        var editOptions = this.setOptions();
        var editorWidth = editOptions.width || this.width;
        var editbox = $("<input id='" + dataItem.code + "' style='width:" + editorWidth + "px;'>").appendTo(editPlugin);
        $(editbox).data("DataItem", dataItem);
        $(editbox)[dataItem.editType](editOptions);

        if (dataItem.style) {
            editbox.css(dataItem.style);
        }

        if (dataItem.hasTemplate) {
            this.templateView = window.textHistoryView.instance;
            if (this.templateView) {
                this.templateView.setKeyField(dataItem.code);
                this.templateView.setCallback(function(item) {
                    var originalText = $(editbox)[dataItem.editType]('getValue');
                    $(editbox)[dataItem.editType]('setValue', originalText + ' ' + item.Text);
                });
                this.templateView.position({ x: (position.x - scrollLeft), y: (dataItem.rect.bottom + 15 - scrollTop) });
                this.templateView.open();
            }
        }

        this.editbox = editbox;
        this.loadEditPluginData();

        $(editPlugin).data("EditPlugin", this);

        $(editPlugin).bind("keyup", function(e) {
            var state = $(this).data("EditPlugin");
            if (state.keyHandler) {
                if (e.keyCode == "13" && state.keyHandler.enter) {
                    state.keyHandler.enter.call(state, e);
                }
                if (e.keyCode == "37" && state.keyHandler.left) {
                    state.keyHandler.left.call(state, e);
                }
                if (e.keyCode == "38" && state.keyHandler.up) {
                    state.keyHandler.up.call(state, e);
                }
                if (e.keyCode == "39" && state.keyHandler.right) {
                    state.keyHandler.right.call(state, e);
                }
                if (e.keyCode == "40" && state.keyHandler.down) {
                    state.keyHandler.down.call(state, e);
                }
            }
        });

        this.element = editPlugin;
    },
    refreshPosition: function() {
        var dataItem = this.dataItem;
        var position = dataItem.valueStartPos;

        var parent = $($(this.target).parent());
        var scrollTop = parent.scrollTop();
        var scrollLeft = parent.scrollLeft();

        this.element.css({
            top: position.y - 5 - scrollTop + 50,
            left: position.x - scrollLeft
        });
    },
    /**
     * 设置焦点到自身，焦点移动到可见的第一个输入框
     */
    focus: function() {
        if (this.element) {
            var visibleInputs = $(this.element).find("input:visible");
            if (visibleInputs.length > 0) $(visibleInputs[0]).focus();
        }
    },
    /**
     * 设置参数
     *  将配置中的Options中字段值为"{*}"格式的替换为相应的值，现在仅有session、context、schedule三个对象
     * @example "{schedule.Operation}"替换为record.sheet.dataContext.schedule.Operation的值
     */
    setOptions: function() {
        var editPlugin = this;
        var SEPARATOR = '.';
        var paramOriginalData = {
            record: record,
            context: record.context,
            schedule: record.sheet.dataContext.schedule,
            session: session
        }
        var editOptions = JSON.parse(JSON.stringify(this.dataItem.editOptions || {}));
        replaceParam(editOptions);
        $.extend(editOptions, {
            width: editOptions.width || this.width,
            url: ANCSP.DataQuery,
            operScheduleId: record.context.opsId,
            onClose: function() {
                editPlugin.close();
            },
            onSaveSuccess: function(data) {
                editPlugin.updateSchedule(data);
                editPlugin.close();
            },
            onSaveError: function(errorMsg) {
                $.messager.alert("error", errorMsg);
            }
        });

        if (this.dataItem.editType === 'combobox') {
            $.extend(editOptions, {
                formatter: function(row) {
                    var opts = $(this).combobox('options');
                    var textField = opts.textField;
                    var html;
                    html = (row[textField] || '') + '<span class="combobox-item-icon"></span>';
                    return html;
                }
            });

            editOptions.url = composeUrl(editOptions.url, editOptions.queryParams);
        }

        //this.dataItem.editOptions = editOptions;
        return editOptions;

        function composeUrl(url, params) {
            var result = url + '?';
            var needConnectionChar = false;
            for (var key in params) {
                if (needConnectionChar) result = result + '&';
                result = result + key + '=' + params[key];
                needConnectionChar = true;
            }

            return result;
        }

        function replaceParam(param) {
            $.each(param, function(field, value) {
                if (typeof value == "object" ||
                    typeof value == "array") {
                    replaceParam(value);
                } else if (typeof value == "string" &&
                    value.indexOf("{") == 0 &&
                    value.indexOf("}") == (value.length - 1)) {
                    var originalField = value.slice(1, value.length - 1);
                    var originalFieldArr = originalField.split(SEPARATOR);
                    var obj = paramOriginalData;
                    var originalValue = null;

                    $.each(originalFieldArr, function(ind, e) {
                        obj = obj[e];
                        if (!obj) return false;
                        if (ind == (originalFieldArr.length - 1)) {
                            originalValue = obj;
                        }
                    });

                    param[field] = originalValue;
                }
            })
        }
    },
    /**
     * 加载数据至编辑框，采用对象加载的方式
     * @author yongyang 20171114
     */
    loadEditPluginData: function() {
        var dataItem = this.dataItem;
        var editbox = this.editbox;
        var data = {};
        $.each(dataItem.fields, function(index, e) {
            data[e] = record.sheet.dataContext.schedule[e];
        });
        if (dataItem.idField) {
            data.RowId = record.sheet.dataContext.schedule[dataItem.idField] || "";
        } else {
            data.RowId = record.sheet.dataContext.schedule.RowId;
        }
        $(editbox)[dataItem.editType]("setDHCData", data);
    },
    /**
     * 更新数据到缓存中
     * @param {object} data 
     * @author yongyang 20171130
     */
    updateSchedule: function(data) {
        var dataContext = record.sheet.dataContext;
        $.extend(data, { RowId: dataContext.schedule.RowId });
        $.extend(dataContext.schedule, data);
        record.sheet.drawPage();
    },
    /**
     * 保存数据，多选框点击时调用
     */
    commonSave: function() {
        var dataItem = this.dataItem;
        var data = {};
        if (dataItem.editType == 'checkbox') {
            if (dataItem.value == dataItem.valueOfChecked)
                data[dataItem.code] = dataItem.valueOfUnchecked;
            else data[dataItem.code] = dataItem.valueOfChecked;

            var length = dataItem.fields.length;
            var field;
            for (var i = 0; i < length; i++) {
                field = dataItem.fields[i];
                if (dataItem.code != field) {
                    data[field] = data[dataItem.code];
                }
            }
        }

        var _this = this;
        var rowId = "";
        if (this.dataItem.idField) {
            rowId = record.sheet.dataContext.schedule[this.dataItem.idField] || "";
        } else {
            rowId = record.sheet.dataContext.schedule.RowId;
        }
        if (this.dataItem.onBeforeSave && this[this.dataItem.onBeforeSave]) {
            this[this.dataItem.onBeforeSave].call(this, data);
        }

        var savingData = $.extend({}, data, {
            ClassName: this.dataItem.className,
            RowId: rowId
        });
        dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
            _this.updateSchedule(data);
            _this.close();
        });
    },
    /**
     * 计算多字段的值
     */
    calculateFields: function(savingData) {
        var result = '';
        var source = record.sheet.dataContext.schedule;
        var calculateOptions = this.dataItem.calculateOptions;
        if (calculateOptions && calculateOptions.formula) {
            var formula = calculateOptions.formula;
            var reg = /{\S*?}/g;
            var matches = formula.matchRegAll(reg); //[...formula.matchAll(reg)];
            var length = matches.length;
            var match, field, value;
            var start = 0,
                end = 0,
                offset = 0;
            for (var i = 0; i < length; i++) {
                match = matches[i];
                field = match[0].slice(1, match[0].length - 1);
                value = '';
                if (field) value = source[field];
                if (field && typeof savingData[field] != 'undefined') value = savingData[field];
                start = match.index;
                end = start + match[0].length;
                formula = formula.slice(0, start + offset) + value + formula.slice(end + offset, formula.length);
                offset += value.length - field.length - 2;
            }

            result = simplyMathExpress(formula) + '';
            if (calculateOptions.resultFields && calculateOptions.resultFields.length > 0) {
                var length = calculateOptions.resultFields.length;
                var field;
                for (var i = 0; i < length; i++) {
                    field = calculateOptions.resultFields[i];
                    savingData[field] = result;
                }
            }
        }

        /**
         * 计算带括号的数学公式
         * 递归算法
         */
        function execMathExpress(formula) {
            var bracketReg = /\([\(,\S,\)]*\)/g;
            var matches = formula.matchRegAll(bracketReg);

            var length = matches.length;
            var match, formulaFragment, value;
            var start = 0,
                end = 0,
                offset = 0;
            for (var i = 0; i < length; i++) {
                match = matches[i];
                formulaFragment = match[0].slice(1, match[0].length - 1);
                value = '1';
                if (formulaFragment) {
                    if (formula.match(bracketReg)) value = execMathExpress(formulaFragment);
                    else value = simplyMathExpress(formulaFragment);
                }
                start = match.index;
                end = start + match[0].length;
                formula = formula.slice(0, start + offset) + value + formula.slice(end + offset, formula.length);
                offset += value.length - formulaFragment.length - 2;
            }

            return simplyMathExpress(formula);
        }

        /**
         * 计算简单数学公式,
         * 先只考虑顺序执行,后续有需要可以添加括号及执行优先级
         */
        function simplyMathExpress(formula) {
            var result = 0;
            var operatorReg = /[\-,\+,\*,\/,\%,^]/g;
            var matches = formula.matchRegAll(operatorReg); //[...formula.matchAll(operatorReg)];
            var length = matches.length;
            var start = 0,
                end = 0,
                value = 0;

            if (length > 0) result = Number(formula.slice(0, matches[0].index));
            for (var i = 0; i < length; i++) {
                match = matches[i];
                start = match.index + 1;
                end = i < length - 1 ? matches[i + 1].index : formula.length;
                value = Number(formula.slice(start, end));;

                switch (match[0]) {
                    case '+':
                        result = result + value;
                        break;
                    case '-':
                        result = result - value;
                        break;
                    case '*':
                        result = result * value;
                        break;
                    case '\/':
                        result = result / value;
                        break;
                    case '\%':
                        result = result % value;
                        break;
                    case '^':
                        result = Math.pow(result, value);
                        break;
                    default:
                        result = result + value;
                        break;
                }
            }

            return result + '';
        }
    },
    /**
     * 保存
     * @param {object} param
     * @example param: { needConfirm: true }
     */
    save: function(param) {
        if (this.dataItem.saveHandler) {
            this[this.dataItem.saveHandler].call(this);
        } else if (this.editbox) {
            if ($(this.editbox)[this.dataItem.editType]("save", param)) {
                this.close();
            }
        } else {
            this.commonSave();
        }

        if (this.dataItem.onAfterSave &&
            record[this.dataItem.onAfterSave] &&
            typeof record[this.dataItem.onAfterSave] == 'function') {
            record[this.dataItem.onAfterSave].call(record);
        }
    },
    /**
     * 确认并保存
     */
    confirmAndSave: function() {
        this.save({ needConfirm: false });
    },
    /**
     * 保存数据到OperData表
     */
    saveOperData: function() {
        var _this = this;
        var dataItem = this.dataItem;
        var code = dataItem.code;
        var originalValue = dataItem.value || '';
        var value = '';
        var checked = false;

        var data = {};
        if (this.editbox) {
            var DHCData = $(this.editbox)[dataItem.editType]("getDHCData");
            value = DHCData[code];
            data[code] = value;
        }
        if (dataItem.editType == 'checkbox') {
            var arr = originalValue.split(',');
            var index = arr.indexOf(dataItem.valueOfChecked);
            checked = !(index > -1);
            if (checked) value = dataItem.valueOfChecked;
            else value = dataItem.valueOfUnchecked;

            if (dataItem.editOptions && dataItem.editOptions.multiple) {
                if (index > -1 && !checked) arr.splice(index, 1);
                if (checked) arr.push(value);
                value = arr.join(',');
            }

            data[code] = value;
        }

        var savingData = {
            ClassName: ANCLS.BLL.OperData,
            MethodName: 'SaveKeyValue',
            Arg1: session.RecordSheetID,
            Arg2: code,
            Arg3: value,
            Arg4: session.UserID,
            ArgCnt: 4
        }

        dhccl.saveDatas(ANCSP.MethodService, savingData, function(result) {
            _this.updateOperData(data);
            _this.close();
        });
    },
    /**
     * 更新数据到缓存中
     * @param {object} data 
     * @author yongyang 20171130
     */
    updateOperData: function(data) {
        var dataContext = record.sheet.dataContext;
        $.extend(dataContext.operDatas, data);
        record.sheet.drawPage();
    },
    /**
     * 关闭，清除相关HTML元素
     * @borrows 1.通过editbox的onClose触发
     * @borrows 2.当editbox的save方法返回true时，直接调用
     * @borrows 3.通过editbox的onSaveSuccess触发
     */
    close: function() {
        this.isClosed = true;
        if (this.templateView) {
            this.templateView.close();
        }
        if (this.element) {
            $(this.element).remove();
        }
    },
    /**
     * 比较数据项，一致时返回true，不一致返回false
     * @param {*} otherDataItem 
     * @returns 
     */
    isSameDataItem: function(otherDataItem) {
        return this.dataItem == otherDataItem;
    },
    /**
     * 按键处理方法
     */
    keyHandler: {
        enter: function(e) {
            this.save();
        }
    },
    /**
     * 鼠标事件处理方法
     */
    mouseHandler: {
        enter: function(e) {

        },
        leave: function(e) {

        }
    }
};