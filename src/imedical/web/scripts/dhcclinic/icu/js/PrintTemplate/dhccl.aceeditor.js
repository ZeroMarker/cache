/**
 * JS代码编辑框
 * dhccl.aceeditor.js
 */

function AceEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 550,
        height: 600
    });

    this.onSave = opt.onSave;
    this.value = opt.value;

    this.init();
}

AceEditor.prototype = {
    constructor: AceEditor,

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
                if($this.validate()){
                    $this.save();
                    $this.close();
                }
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
            title: "JS脚本编辑器",
            modal: true,
            closed: true,
            buttons: buttons,
            onClose: function(){
                $this.close();
            }
        });

        this.container = $("<div id='aceEditor'></div>");
        this.container.css({
            width: 510,
            height: 1000,
            border: "1px solid #ccc",
            margin: 10
        });

        this.textArea = $("<textarea id='CodeMirror'></textarea>").appendTo(this.container);
        this.textArea.css({
            "width": 505,
            "height": 995,
            "background-color": "black"
        });
        
        this.dlg.dialog({
            content: $this.container
        });

    },

    open: function () {
        this.dlg.dialog("open");
        this.dlg.dialog("center");

        this.codeMirrorEditor = CodeMirror.fromTextArea(document.getElementById('CodeMirror'), {
            value: "",
            mode: "javascript",
            height: 995,
            lineNumbers: true,
            theme: "monokai"
        });

        this.setValue(this.value);
    },

    close: function () {
        this.container.remove();
        this.dlg.dialog("close");
        this.dlg.dialog("destroy");
    },

    setValue: function (val) {
        this.codeMirrorEditor.setValue(val);
    },

    getValue: function () {
        return this.codeMirrorEditor.getValue();
    },

    validate: function () {
        return true;
    },

    save: function () {
        var val = this.getValue();
        if (this.onSave) {
            this.onSave(val);
        }
    }
}