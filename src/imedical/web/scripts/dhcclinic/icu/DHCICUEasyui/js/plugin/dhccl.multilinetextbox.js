/**
 * 医护人员多选框
 */
(function($) {
    $.fn.multilinetextbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.multilinetextbox.methods[options];
            if (method) return method($(this), param);
        } else {
            return this.each(function() {
                var state = $(this).data("multilinetextbox");
                if (!state) {
                    $(this).data("multilinetextbox", {
                        options: $.extend({}, $.fn.multilinetextbox.defaults, options),
                        data: []
                    })
                    state = $(this).data("multilinetextbox");

                    create(this);
                }
            });
        }
    }

    $.fn.multilinetextbox.methods = {
        options: function(target) {
            return $(target).data('multilinetextbox').options;
        },
        panel: function(target) {
            return $(target).data('multilinetextbox').panel;
        },
        /**
         * 获取值，以,分割
         * @param {*} target 
         */
        getValue: function(target) {
            var editor = $(target).data('editor');
            var value = $(editor).val();
            return value;
        },
        /**
         * 设置值，以,分割
         * @param {*} target 
         * @param {String} value
         */
        setValue: function(target, value) {
            var editor = $(target).data('editor');
            $(editor).val(value);
            return $(target);
        },
        destory: function(target) {
            $(target).data('editor_container').remove();
            $(target).remove();
        },
        close: function(target) {
            var opts = $(target).multilinetextbox('options');
            if (opts.onClose) {
                opts.onClose.call(target);
            }
        }
    }

    $.fn.multilinetextbox.defaults = {
        width: 180,
        height: 30
    }

    function create(target) {
        $(target).hide();
        var targetContainer = $('<span class="dhccl-textarea" style="display:inline-block;"></span>');
        $(target).after(targetContainer);
        $(target).data('editor_container',targetContainer);

        var options = $(target).multilinetextbox('options');
        targetContainer.width(options.width - 2);

        var editView = $('<textarea type="textarea" class="textbox" style="overflow:auto;"></textarea>').appendTo(targetContainer);
        editView.width(options.width - 2);
        editView.height(options.height);
        $(target).data('editor',editView);
    }
})(jQuery);