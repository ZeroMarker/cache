/**
 * 增加新页面
 * @param {*} opt 
 */
function AddNewPageEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 390,
        height: 300
    });

    this.defaultPage = this.options.defaultPage;

    this.init();
}

AddNewPageEditor.prototype = {
    constructor: AddNewPageEditor,

    init: function () {
        this.dom = $("<div></div>").appendTo("body");
        this.render();
    },

    render: function () {
        var $this = this;

        var buttons = $("<div></div>");
        var btnSave = $('<a href="#"></a>').linkbutton({
            text: '保存',
            iconCls: 'icon-save',
            onClick: function () {
                $this.save();
            }
        }).appendTo(buttons);
        var btnCancel = $('<a href="#"></a>').linkbutton({
            text: '关闭',
            iconCls: 'icon-cancel',
            onClick: function () {
                $this.close();
            }
        }).appendTo(buttons);

        this.dlg = this.dom.dialog({
            width: $this.options.width,
            height: $this.options.height,
            title: "add new page",
            modal: true,
            closed: true,
            buttons: buttons
        });

        var table = $("<table></table>");
        this.valueTextboxObj = {};
        $.each(this.defaultPage, function (key, value) {
            if (Array.isArray(value)) return;

            var tr = $("<tr></tr>").appendTo(table);
            var labelTD = $("<td></td>").appendTo(tr);
            var valueTD = $("<td></td>").appendTo(tr);
            var label = $('<label>' + key + ':</label>').appendTo(labelTD);
            var textbox = $('<input type="text" class="textbox" style="width:150px;"/>').appendTo(valueTD);
            textbox.val(value);
            $this.valueTextboxObj[key] = textbox;
        });

        this.dlg.dialog({
            content: table
        });
    },

    open: function () {
        this.dlg.dialog("open");
        this.dlg.dialog("center");
    },

    close: function () {
        this.dlg.dialog("close");
        this.dlg.dialog("destroy");
    },

    clear: function () {

    },

    save: function () {
        this.close();
        var value = this.getValue();
        if (this.options.onAddNewPage) {
            this.options.onAddNewPage(value);
        }
    },

    getValue: function () {
        var $this = this;
        var result = {};
        $.each(this.valueTextboxObj, function (key, value) {
            result[key] = $($this.valueTextboxObj[key]).val();
            if (key == "PageNo") {
                result[key] = parseInt($($this.valueTextboxObj[key]).val());
            }
        });
        return result;
    }
}