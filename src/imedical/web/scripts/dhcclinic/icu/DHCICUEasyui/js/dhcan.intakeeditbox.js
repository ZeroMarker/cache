(function($) {
    /**
     * 术中入量编辑界面
     */
    $.fn.intakeeditbox = function(options, param) {
        if (typeof options == "string") {
            var method = $.fn.intakeeditbox.methods[options];
            if (method) return method($(this), param);
        } else {
            var state = $(this).data("intakeeditbox");
            if (state) {
                $.extend(state.options, options);
            } else {
                $(this).data("intakeeditbox", {
                    options: $.extend({}, $.fn.intakeeditbox.defaults, options),
                    data: []
                });
                state = $(this).data("intakeeditbox");
            }
            create(this);
        }
    }

    $.fn.intakeeditbox.methods = {
        options: function(target) {
            return $(target).data("intakeeditbox").options;
        },
        form: function(target) {
            return $(target).data("intakeeditbox").form;
        },
        setDHCData: function(target, data) {
            $(target).data("DHCData", data);
            var dataItem = $(target).data("DataItem");
            var form = $(target).intakeeditbox("form");
            $(form).form("load", data);
            $(target).val(data[dataItem.code]);
        },
        getDHCData: function(target) {
            var form = $(target).intakeeditbox("form");
            return $(form).serializeJson();
        },
        save: function(target) {
            var options = $(target).intakeeditbox("options");
            var DHCData = $(target).intakeeditbox("getDHCData");

            var savingData = $.extend({}, DHCData, {
                ClassName: dataItem.className
            });

            var originalText = dataItem.value;
            var presentText = savingData.TotalIn;

            /*
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
                dhccl.saveDatas(dhccl.csp.dataService, savingData, function(result) {
                    if (result.indexOf("S^") >= 0) {
                        if (opts.onSaveSuccess) {
                            opts.onSaveSuccess.call(target, DHCData);
                        }
                    } else {
                        if (opts.onSaveError) {
                            opts.onSaveError.call(target);
                        }
                    }
                });
            }*/

            if (options.onSaveSuccess) {
                options.onSaveSuccess.call(target, DHCData);
            }
        },
        close: function(target) {
            var options = $(target).intakeeditbox("options");
            if (options.onClose) {
                options.onClose.call(target);
            }
        }
    }

    var INTAKEEDITBOX_SERNO = 0;
    var editview = {
        render: function(target, container) {
            var state = $(target).data("intakeeditbox");
            var options = $(target).intakeeditbox("options");

            INTAKEEDITBOX_SERNO++;
            state.itemIdPrefix = "_intakeeditbox_i_";
            var htmlArr = [];
            htmlArr.push("<form>");

            $.each(options.items, function(ind, row) {
                var id = state.itemIdPrefix + ind;
                htmlArr.push("<div style='float:left;margin:5px;width:170px;'>");
                htmlArr.push("<div style='font-weight:bold;float:left;width:80px;text-align:right;padding:5px;'><label for='" + id + "'>" + row.label + "：</label></div>");
                htmlArr.push("<span><input name='" + row.name + "' id='" + id + "' style='width:60px;'></span>");
                htmlArr.push("<span style='padding-left:5px;'><label for='" + id + "'>" + row.unit + "</label></span>");
                htmlArr.push("</div>");
            });

            htmlArr.push("</form>");
            var form = $(htmlArr.join(""));
            $(container).append(form);

            $(form).form({
                onSubmit: function() {

                }
            });
            state.form = form;
            $(form).find(":input").textbox({

            });
        }
    };

    $.fn.intakeeditbox.defaults = {
        width: 400,
        height: 300,
        view: editview,
        onClose: null,
        onSave: null
    }

    function create(target) {
        var state = $(target).data("intakeeditbox");
        var opts = state.options;
        var width = opts.width;

        $(target).attr("readOnly", true);
        $(target).attr("width", width);

        var panel = $("<div class='intakeeditbox-panel'></div>");

        $(target).after(panel); //先直接加在当前元素之后，之后应该加在body中，然后自动计算其显示位置

        var footerHtmlArr = [];
        footerHtmlArr.push("<div>");
        footerHtmlArr.push("<a class='intakeeditbox-tool-cancel' href='javascript:;' style='float:right;margin:5px;' data-options='iconCls:\"icon-cancel\"'>关闭</a>");
        footerHtmlArr.push("<a class='intakeeditbox-tool-save' href='javascript:;' style='float:right;margin:5px;' data-options='iconCls:\"icon-save\"'>保存</a>");
        footerHtmlArr.push("</div>");
        var footer = $(footerHtmlArr.join(""));

        $(panel).panel({
            style: {
                position: "relative",
                "z-index": 102
            },
            width: width,
            height: opts.height || 200,
            footer: footer
        });

        $(footer).find("a.intakeeditbox-tool-save").linkbutton({
            handler: function() {
                $(target).intakeeditbox("save");
            }
        });

        $(footer).find("a.intakeeditbox-tool-cancel").linkbutton({
            handler: function() {
                $(target).intakeeditbox("close");
            }
        })

        $(target).data("panel", panel);

        opts.view.render.call(opts.view, target, panel);
    }

}(jQuery))