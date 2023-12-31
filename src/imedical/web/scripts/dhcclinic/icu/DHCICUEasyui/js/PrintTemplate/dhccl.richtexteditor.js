/**
 * 富文本编辑框
 * dhccl.richtexteditor.js
 */

function RichTextEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 550,
        height: 400
    });

    this.onSave = opt.onSave;
    this.value = opt.value;

    this.init();
}

RichTextEditor.prototype = {
    constructor: RichTextEditor,

    init: function () {
        this.dom = $("<div></div>").appendTo("body");
        this.render();
    },

    render: function () {
        var $this = this;

        var buttons = $("<div></div>");

        var btnSave = $('<a href="#"></a>').linkbutton({
            text: '确定',
            iconCls: 'icon-save',
            onClick: function () {
                $this.save();
                $this.close();
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
            title: "文本编辑器",
            modal: true,
            closed: true,
            buttons: buttons
        });

        this.container = $("<div></div>");
        this.container.css({
            width: 530,
            height: 290,
            border: "1px solid #ccc",
            margin: 10
        });

        this.textarea = $('<textarea class="textbox" />');
        this.textarea.css({
            "width": 520,
            "height": 280
        });
        this.textarea.appendTo(this.container);
        this.setValue(this.value);

        this.dlg.dialog({
            content: $this.container
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

    setValue: function(val){
        this.textarea.val(val);
    },

    getValue: function(){
        return this.textarea.val();
    },

    save: function () {
        var val = this.getValue();
        if(this.onSave){
            this.onSave(val);
        }
    }
}