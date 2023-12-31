/**
 * 多行文本框
 */
(function($) {
    $.fn.textarea = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.textarea.methods[options];
            if (method) return method($(this), param);
        } else {
            var state = $(this).data("textarea");
            if (!state) {
                $(this).data("textarea", {
                    options: $.extend({}, $.fn.textarea.defaults, options)
                })
                state = $(this).data("textarea");

                create(this);
            }
        }
    }

    $.fn.textarea.methods = {
        dataItem: function(target) {
            return $(target).data('DataItem');
        },
        options: function(target) {
            return $(target).data('textarea').options;
        },
        setValue: function(target, value) {
            var editor = $(target).data('textarea').editor;
            $(editor).val(value);
        },
        getValue: function(target) {
            var editor = $(target).data('textarea').editor;
            return $(editor).val();
        },
        enable: function(target) {
            $(target).attr('disabled', false);
        },
        disable: function(target) {
            $(target).attr('disabled', true);
        },
        setDHCData: function(target, data) {
            var dataItem = $(target).data("DataItem");
            var text = data[dataItem.code] || "";
            $(target).textarea("setValue", text);
            $(target).data("DHCData", data);
        },
        getDHCData: function(target) {
            var dataItem = $(target).data("DataItem");
            var data = {};
            data[dataItem.code] = $(target).textarea("getValue");
            return data;

            return DHCData;
        },
        save: function(target, param) {
            var opts = $(target).data("textarea").options;
            var originalData = $(target).data("DHCData");
            var dataItem = $(target).data("DataItem");
            var originalText = originalData[dataItem.code];
            var originalText = originalData[dataItem.code];
            var presentText = $(target).textarea("getValue");
            originalText = originalText || "";
            presentText = presentText || "";

            var DHCData = $(target).textarea("getDHCData");
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
            var opts = $(target).textarea("options");
            if (target) {
                $(target).textarea("destroy");
            }
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        },
        resize: function(target, width) {
            $(target).width(width - 2);
        }
    }

    $.fn.textarea.defaults = {
        width: 200,
        height: 30
    }

    function create(target) {
        $(target).hide();
        var container = $('<span class="textarea"></span>').appendTo($(target).parent());
        var options = $(target).textarea('options');
        container.css({
            width: options.width,
            height: options.height
        });
        var textInput = $('<textarea class="textarea-text"></textarea>').appendTo(container);
        textInput.css({
            width: options.width,
            height: options.height
        });

        textInput.bind('keyup', function() {
            event.preventDefault();
            event.stopPropagation();
        });

        var textarea = $(target).data('textarea');
        textarea.editor = textInput;
    }
})(jQuery);