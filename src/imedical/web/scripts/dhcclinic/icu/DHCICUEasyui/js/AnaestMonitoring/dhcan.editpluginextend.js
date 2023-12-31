//
/**
 * @description easyui 组件添加扩展方法，处理数据以及保存,麻醉监护中一般每修改一次即刻保存
 * @author yongyang 20171114
 */
Array.prototype.trim = function() {
    var newArr = [].concat(this);
    $.each(this, function(ind, e) {
        if ($.trim(e) == "") {
            newArr.slice(ind, 1);
        }
    });
    return newArr;
}

String.prototype.matchRegAll = function(regex) {
    if (!regex instanceof RegExp) return [];

    var subject = this,
        match,
        matches = [];

    while (match = regex.exec(subject)) {
        var zeroLengthMatch = !match[0].length;
        if (zeroLengthMatch && regex.lastIndex > match.index)
            regex.lastIndex--;
        if (zeroLengthMatch)
            regex.lastIndex++;
        else matches.push(match);
    }

    return matches;
}

$.extend($.fn.combobox.methods, {
    /**
     * @description 设置对应麻醉监护的数据
     * @param {object} data
     */
    setDHCData: function(target, data) {
        var dataItem = $(target).data("DataItem");
        var opts = $(target).combobox("options");
        var textCode = dataItem.code;
        var text = data[dataItem.code] || "";
        $(target).data("DHCData", data);

        var value = "";
        $.each(dataItem.fields, function(ind, e) {
            if (e != textCode) {
                value = data[e];
            }
        });

        if (text && !value) value = text;

        value = value || "";

        $(target).combobox("setText", text);
        if (opts.multiple) {
            if (!(value === "")) $(target).combobox("setValues", value.split(","));
        } else {
            $(target).combobox("setValue", value);
        }
    },
    /**
     * @description 获取对应麻醉监护的数据
     * @returns {object} data
     */
    getDHCData: function(target) {
        var dataItem = $(target).data("DataItem");
        var opts = $(target).combobox("options");
        var textCode = dataItem.code;
        var data = {};

        $.each(dataItem.fields, function(ind, e) {
            if (opts.multiple) {
                if (e == textCode) {
                    data[e] = $(target).combobox("getText");
                } else {
                    data[e] = ($(target).combobox("getValues")).join(",");
                }
            } else {
                if (e == textCode) data[e] = $(target).combobox("getText");
                else {
                    data[e] = $(target).combobox("getValue");
                }
            }
        });
        return data;
    },
    /**
     * @description 保存数据
     * @returns false: 表示进入异步保存处理步骤
     * @returns true: 表示保存方法已全部执行完成
     */
    save: function(target, param) {
        var opts = $(target).data("combobox").options;
        var originalData = $(target).data("DHCData");
        var dataItem = $(target).data("DataItem");
        var originalText = originalData[dataItem.code];
        var presentText = $(target).combobox("getText");
        originalText = originalText || "";
        presentText = presentText || "";

        var DHCData = $(target).combobox("getDHCData");
        var savingData = $.extend({}, DHCData, {
            ClassName: dataItem.className,
            RowId: originalData.RowId
        });

        if (opts.onBeforeSave) {
            if (!opts.onBeforeSave.call(target, savingData)) return true;
        }

        if (originalText != presentText) {
            if (!param || !param.needConfirm) saveData();
            else {
                $.messager.confirm("请确认保存当前修改",
                    "<div style='height:52px;'>“" + dataItem.title + "”的数据已修改：" + originalText + " → " + presentText + "</div><div><em style='vertical-align:bottom;'>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
                    saveData);
            }
            return false;
        }
        return true;

        function saveData() {
            dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                if (result.indexOf("S^") >= 0) {
                    if (opts.onSaveSuccess) {
                        opts.onSaveSuccess.call(target, DHCData);
                    }
                } else {
                    if (opts.onSaveError) {
                        opts.onSaveError.call(target, result);
                    }
                }
            });
        }
    },
    /**
     * @description 销毁对应控件，避免重复添加导致DOM过大
     */
    destroy: function(target, param) {
        var combo = $(target).data("combo");
        if (combo) {
            var panel = combo.panel;
            panel.parent().remove();
        }

        $(target).textbox("destroy");
        $(target).remove();
    },
    /**
     * @description 关闭
     */
    close: function(target, param) {
        var opts = $(target).combobox("options");
        if (target) {
            $(target).combobox("destroy");
        }
        if (opts.onClose) {
            opts.onClose.call(target);
        }
    }
});
if ($.fn.validatebox)
    $.extend($.fn.validatebox.methods, {
        setValue: function(target, value) {
            $(target).val(value);
        },
        getValue: function(target) {
            return $(target).val();
        },
        setText: function(target, value) {
            $(target).val(value);
        },
        getText: function(target) {
            return $(target).val();
        },
        enable: function(target) {
            $(target).attr('disabled', false);
        },
        disable: function(target) {
            $(target).attr('disabled', true);
        },
        /**
         * @description 设置对应麻醉监护的数据
         * @param {object} data
         */
        setDHCData: function(target, data) {
            var dataItem = $(target).data("DataItem");
            var text = data[dataItem.code] || "";
            $(target).validatebox("setValue", text);
            $(target).data("DHCData", data);
        },
        /**
         * @description 获取对应麻醉监护的数据
         * @returns {object} data
         */
        getDHCData: function(target) {
            var dataItem = $(target).data("DataItem");
            var data = {};
            data[dataItem.code] = $(target).validatebox("getValue");
            return data;
        },
        /**
         * @description 保存数据
         * @returns {boolean} false: 表示进入异步保存处理步骤; true: 表示保存方法已全部执行完成
         */
        save: function(target, param) {
            var opts = $(target).data("validatebox").options;
            var originalData = $(target).data("DHCData");
            var dataItem = $(target).data("DataItem");
            var originalText = originalData[dataItem.code];
            var originalText = originalData[dataItem.code];
            var presentText = $(target).validatebox("getValue");
            originalText = originalText || "";
            presentText = presentText || "";

            var DHCData = $(target).validatebox("getDHCData");
            var savingData = $.extend({}, DHCData, {
                ClassName: dataItem.className,
                RowId: originalData.RowId
            });

            if (opts.onBeforeSave) {
                if (!opts.onBeforeSave.call(target, savingData)) return true;
            }

            if (originalText != presentText) {
                if (!param || !param.needConfirm) saveData();
                else {
                    $.messager.confirm("请确认保存当前修改",
                        "<div style='height:52px;'>“" + dataItem.title + "”的数据已修改:" + originalText + " → " + presentText + "</div><div><em>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
                        saveData);
                }

                return false;
            }

            return true;

            function saveData() {
                dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                    if (result.indexOf("S^") >= 0) {
                        if (opts.onSaveSuccess) {
                            opts.onSaveSuccess.call(target, DHCData);
                        }
                    } else {
                        if (opts.onSaveError) {
                            opts.onSaveError.call(target, result);
                        }
                    }
                });
            }
        },
        /**
         * @description 销毁对应控件，避免重复添加导致DOM过大
         */
        destroy: function(target, param) {

        },
        /**
         * @description 关闭
         */
        close: function(target, param) {
            var opts = $(target).validatebox("options");
            if (target) {
                $(target).validatebox("destroy");
            }
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        },
        resize: function(target, width) {
            $(target).width(width - 2);
        }
    });
if ($.fn.textbox)
    $.extend($.fn.textbox.methods, {
        /**
         * @description 设置对应麻醉监护的数据
         * @param {object} data
         */
        setDHCData: function(target, data) {
            var dataItem = $(target).data("DataItem");
            var text = data[dataItem.code] || "";
            $(target).textbox("setValue", text);
            $(target).data("DHCData", data);
        },
        /**
         * @description 获取对应麻醉监护的数据
         * @returns {object} data
         */
        getDHCData: function(target) {
            var dataItem = $(target).data("DataItem");
            var data = {};
            data[dataItem.code] = $(target).textbox("getValue");
            return data;
        },
        /**
         * @description 保存数据
         * @returns {boolean} false: 表示进入异步保存处理步骤; true: 表示保存方法已全部执行完成
         */
        save: function(target, param) {
            var opts = $(target).data("textbox").options;
            var originalData = $(target).data("DHCData");
            var dataItem = $(target).data("DataItem");
            var originalText = originalData[dataItem.code];
            var originalText = originalData[dataItem.code];
            var presentText = $(target).textbox("getValue");
            originalText = originalText || "";
            presentText = presentText || "";

            var DHCData = $(target).textbox("getDHCData");
            var savingData = $.extend({}, DHCData, {
                ClassName: dataItem.className,
                RowId: originalData.RowId
            });

            if (opts.onBeforeSave) {
                if (!opts.onBeforeSave.call(target, savingData)) return true;
            }

            if (originalText != presentText) {
                if (!param || !param.needConfirm) saveData();
                else {
                    $.messager.confirm("请确认保存当前修改",
                        "<div style='height:52px;'>“" + dataItem.title + "”的数据已修改:" + originalText + " → " + presentText + "</div><div><em>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
                        saveData);
                }

                return false;
            }

            return true;

            function saveData() {
                dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                    if (result.indexOf("S^") >= 0) {
                        if (opts.onSaveSuccess) {
                            opts.onSaveSuccess.call(target, DHCData);
                        }
                    } else {
                        if (opts.onSaveError) {
                            opts.onSaveError.call(target, result);
                        }
                    }
                });
            }
        },
        /**
         * @description 销毁对应控件，避免重复添加导致DOM过大
         */
        destroy: function(target, param) {

        },
        /**
         * @description 关闭
         */
        close: function(target, param) {
            var opts = $(target).textbox("options");
            if (target) {
                $(target).textbox("destroy");
            }
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    });
/**
 * 储存已选择项，避免远程加载选项数据后界面已选择项变为数字
 */
if ($.fn.tagbox)
    $.extend($.fn.tagbox.defaults, {
        onBeforeLoad: function(value) {
            var opts = $(this).tagbox("options");
            if (opts.mode == "remote") {
                var values = $(this).tagbox("getValues");
                var datalist = $(this).tagbox("getData");
                var selectedData = [];
                $.each(values, function(i, thisValue) {
                    $.each(datalist, function(index, row) {
                        if (row[opts.valueField] == thisValue) {
                            selectedData.push(row);
                            return false;
                        }
                    });
                });
                if (selectedData.length > 0) {
                    $(this).data("postLoadProcess", {
                        remainSelectedData: true
                    });
                }
                $(this).data("selectedData", selectedData);
            }
        },
        /**
         * 添加选项数据
         */
        onLoadSuccess: function(data) {
            var opts = $(this).tagbox("options");
            var postLoadProcess = $(this).data("postLoadProcess");
            if (opts.mode == "remote" && postLoadProcess) {
                $(this).data("postLoadProcess", null);
                if (postLoadProcess.remainSelectedData) {
                    var selectedData = $(this).data("selectedData") || [];
                    var datalist = $(this).tagbox("getData");
                    $(this).tagbox("loadData", datalist.concat(selectedData));
                }
            }
        }
    });
if ($.fn.datetimebox)
    $.extend($.fn.datetimebox.methods, {
        focus: function(target) {
            $(target).siblings('.datebox').find('input').focus();
        },
        warn: function(target) {
            $(target).siblings('.datebox').find('input').css({ color: 'red' });
        },
        normalize: function(target) {
            $(target).siblings('.datebox').find('input').css({ color: 'black' });
        },
        /**
         * 初始化滚轮监听事件，滚动修改日期时间
         * @param {*} jq 
         */
        initiateWheelListener: function(jq) {
            return jq.each(function() {
                _initiate(this);
            });

            function _initiate(target) {
                var textInput = $(target).data('combo').combo.find('input.combo-text')[0];
                if (textInput) {
                    $(textInput).on('mousewheel', function(e, args) {
                        e.preventDefault();
                        e.stopPropagation();
                        var delta = e.originalEvent.wheelDelta || e.originalEvent.detail;
                        var direction = delta > 0 ? 1 : -1;
                        if ($(this).attr('disabled') == 'disabled') return;
                        _onWheel(target, this, direction);
                    });
                }
            }

            function _onWheel(target, input, direction) {
                var text = $(input).val();
                var selectionStart = $(input)[0].selectionStart;
                var selectionEnd = $(input)[0].selectionEnd;

                var number = 0,
                    start = 0,
                    end = 0,
                    limitMin = 0,
                    limitMax = 0;
                if (selectionStart >= 0 && selectionStart <= 4) { // yyyy
                    start = 0;
                    end = 4;
                    limitMin = 1000;
                    limitMax = 9999;
                } else if (selectionStart >= 5 && selectionStart <= 7) { // MM
                    start = 5;
                    end = 7;
                    limitMin = 1;
                    limitMax = 12;
                } else if (selectionStart >= 8 && selectionStart <= 10) { // DD
                    start = 8;
                    end = 10;
                    limitMin = 1;
                    limitMax = 31;
                } else if (selectionStart >= 11 && selectionStart <= 13) { // HH
                    start = 11;
                    end = 13;
                    limitMin = 0;
                    limitMax = 23;
                } else if (selectionStart >= 14 && selectionStart <= 16) { // mm
                    start = 14;
                    end = 16;
                    limitMin = 0;
                    limitMax = 59;
                } else if (selectionStart >= 17 && selectionStart <= 19) { // ss
                    start = 17;
                    end = 19;
                    limitMin = 0;
                    limitMax = 59;
                }
                number = Number(text.substring(start, end));

                if (!number) number = 0;

                number = number + direction;

                if (number > limitMax) number = limitMin;
                if (number < limitMin) number = limitMax;

                text = text.slice(0, start) + (number < 10 ? '0' : '') + number + text.slice(end);
                $(input).val(text);
                $(target).datetimebox('setValue', text);

                $(input)[0].selectionStart = selectionStart;
                $(input)[0].selectionEnd = selectionEnd;

                //$(input).siblings('input.combo-value').val(text);
            }
        },
        /**
         * 初始化键入监听事件，小时修改后自动跳转至分钟
         * @param {*} jq 
         */
        initiateKeyUpListener: function(jq) {
            return jq.each(function() {
                _initiate(this);
            });

            function _initiate(target) {
                var textInput = $(target).data('combo').combo.find('input.combo-text')[0];
                if (textInput) {
                    $(textInput).on('keyup', function(e, args) {
                        _onKeyUp(target, this);
                    });
                    $(textInput).on('focus', function(e, args) {
                        _onFocus(target, this);
                    });
                }
            }

            function _onKeyUp(target, input) {
                var text = $(input).val();
                var selectionStart = $(input)[0].selectionStart;
                var selectionEnd = $(input)[0].selectionEnd;

                var number = 0,
                    start = selectionStart,
                    end = selectionEnd,
                    previousStart = 0,
                    previousEnd = 0,
                    limitMin = undefined,
                    limitMax = undefined,
                    isWrongFormat = false;
                if (selectionStart == 4) { // yyyy->MM
                    previousStart = 0;
                    previousEnd = 4;
                    start = 5;
                    end = 7;
                    limitMin = 1000;
                    limitMax = 9999;
                } else if (selectionStart == 7) { // MM->DD
                    previousStart = 5;
                    previousEnd = 7;
                    start = 8;
                    end = 10;
                    limitMin = 1;
                    limitMax = 12;
                } else if (selectionStart == 10) { // DD->HH
                    previousStart = 8;
                    previousEnd = 10;
                    start = 11;
                    end = 13;
                    limitMin = 1;
                    limitMax = 31;
                } else if (selectionStart == 13) { // HH->mm
                    previousStart = 11;
                    previousEnd = 13;
                    start = 14;
                    end = 16;
                    limitMin = 0;
                    limitMax = 23;
                } else if (selectionStart == 16) { // mm->ss
                    previousStart = 14;
                    previousEnd = 16;
                    start = 17;
                    end = 19;
                    limitMin = 0;
                    limitMax = 59;
                }

                if (limitMin != undefined && limitMax != undefined) {
                    number = Number(text.substring(previousStart, previousEnd));
                    if (!number) number = 0;
                    if (number > limitMax) number = limitMax, isWrongFormat = true;
                    if (number < limitMin) number = limitMin, isWrongFormat = true;

                    if (isWrongFormat) {
                        text = text.slice(0, previousStart) + (number < 10 ? '0' : '') + number + text.slice(previousEnd);
                        $(input).val(text);
                        $(target).datetimebox('setValue', text);
                    }
                } else {
                    var num = text.replace(/[^0-9]/ig, "");
                    if (num.length >= 14) {
                        text = num.slice(0, 4) + '-' +
                            num.slice(4, 6) + '-' +
                            num.slice(6, 8) + ' ' +
                            num.slice(8, 10) + ':' +
                            num.slice(10, 12) + ':' +
                            num.slice(12, 14);
                        $(input).val(text);
                        $(target).datetimebox('setValue', text);
                    }
                }

                $(input)[0].selectionStart = start;
                $(input)[0].selectionEnd = end;
            }

            function _onFocus(target, input) {
                var text = $(input).val();

                if (text.length > 13) {
                    $(input)[0].selectionStart = 11;
                    $(input)[0].selectionEnd = 13;
                }
            }
        }
    });
if ($.fn.tagbox)
    $.extend($.fn.tagbox.methods, {
        /**
         * @description 设置对应麻醉监护的数据
         * @param {object} data
         */
        setDHCData: function(target, data) {
            var dataItem = $(target).data("DataItem");
            var opts = $(target).tagbox("options");
            var textCode = dataItem.code;
            var text = data[dataItem.code] || "";
            $(target).data("DHCData", data);

            var value = "";
            $.each(dataItem.fields, function(ind, e) {
                if (e != textCode) {
                    value = data[e];
                }
            });

            if (text && !value) value = text;

            value = value || "";

            $(target).tagbox("setText", text);
            $(target).tagbox("setValue", value);
        },
        /**
         * @description 重写setValue方法
         * @param {string} value
         */
        setValue: function(target, value) {
            if (value) $(target).tagbox("setValues", value.split(","));
            else $(target).tagbox("setValues", []);
        },
        getText: function(target) {
            var text = "",
                textArr = [];

            $(target).data("combo").combo.find("span.tagbox-label").each(function() {
                textArr.push($(this).text());
            });
            text = textArr.join(",");

            return text;
        },
        getValue: function(target) {
            var values = $(target).tagbox('getValues');
            return values.join(',');
        },
        /**
         * @description 获取对应麻醉监护的数据
         * @returns {object} data
         */
        getDHCData: function(target) {
            var dataItem = $(target).data("DataItem");
            var opts = $(target).combobox("options");
            var textCode = dataItem.code;
            var data = {};

            var text = "",
                value = "";
            text = $(target).tagbox("getText");
            value = ($(target).tagbox("getValues")).join(",");

            $.each(dataItem.fields, function(ind, e) {
                if (e == textCode) {
                    data[e] = text;
                } else {
                    data[e] = value;
                }
            });

            return data;
        },
        /**
         * @description 保存数据
         * @returns false: 表示进入异步保存处理步骤
         * @returns true: 表示保存方法已全部执行完成
         */
        save: function(target, param) {
            var opts = $(target).data("tagbox").options;
            var originalData = $(target).data("DHCData");
            var dataItem = $(target).data("DataItem");
            var presentData = $(target).tagbox("getDHCData");

            var originalText = originalData[dataItem.code];
            var presentText = presentData[dataItem.code];

            var savingData = $.extend({}, presentData, {
                ClassName: dataItem.className,
                RowId: originalData.RowId
            });

            if (opts.onBeforeSave) {
                if (!opts.onBeforeSave.call(target, savingData)) return true;
            }

            if (originalText != presentText) {
                if (!param || !param.needConfirm) saveData();
                else {
                    $.messager.confirm("请确认保存当前修改",
                        "<div style='height:52px;'>“" + dataItem.title + "”的数据已修改：" + originalText + " → " + presentText + "</div><div><em style='vertical-align:bottom;'>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
                        function(confirmed) { if (confirmed) saveData(); });
                }
                return false;
            }
            return true;

            function saveData() {
                dhccl.saveDatas(ANCSP.DataService, savingData, function(result) {
                    if (result.indexOf("S^") >= 0) {
                        if (opts.onSaveSuccess) {
                            opts.onSaveSuccess.call(target, presentData);
                        }
                    } else {
                        if (opts.onSaveError) {
                            opts.onSaveError.call(target, result);
                        }
                    }
                });
            }
        }
    });

$.extend($.fn.linkbutton.methods, {
    resize: function(jq, _1d) {
        return jq.each(function() {
            _1(this, _1d);
        });

        function _1(_2, _3) {
            var _4 = $.data(_2, "linkbutton").options;
            if (_3) {
                $.extend(_4, _3);
            }
            if (_4.width || _4.height || _4.fit) {
                var _5 = $(_2);
                var _6 = _5.parent();
                var _7 = _5.is(":visible");
                if (!_7) {
                    var _8 = $("<div style=\"display:none\"></div>").insertBefore(_2);
                    var _9 = { position: _5.css("position"), display: _5.css("display"), left: _5.css("left") };
                    _5.appendTo("body");
                    _5.css({ position: "absolute", display: "inline-block", left: -20000 });
                }
                _5._size(_4, _6);
                var _a = _5.find(".l-btn-left");
                _a.css("margin-top", 0);
                _a.css("margin-top", parseInt((_5.height() - _a.height()) / 2) + "px");
                if (!_7) {
                    _5.insertAfter(_8);
                    _5.css(_9);
                    _8.remove();
                }
            }
        }
    }
});