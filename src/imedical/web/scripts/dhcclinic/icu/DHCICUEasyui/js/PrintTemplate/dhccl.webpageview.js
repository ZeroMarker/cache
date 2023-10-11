/**
 * dhccl.webpageview.js
 * Web模板编辑
 * @param {*} opt 
 */
function WebpageView(opt) {
    this.options = $.extend({}, opt, {
        width: 900,
        height: 600,
    });

    this.value = this.options.value;

    this.init();
}

WebpageView.prototype = {
    constructor: WebpageView,

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
                
            }
        }).appendTo(buttons);

        var btnCancel = $('<a href="#"></a>').linkbutton({
            text: '关闭',
            iconCls: 'icon-cancel',
            onClick: function () {
                $this.close();
            }
        }).appendTo(buttons);

        this.container = $("<div></div>");
        this.webpageTemplate = new WebpageTemplate(this.container, {
            value: $this.value
        });
        this.dlg = this.dom.dialog({
            width: $this.options.width,
            height: $this.options.height,
            title: "网页模板查看",
            modal: true,
            closed: true,
            buttons: buttons,
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

    clear: function () {

    },

    save: function () {
        this.close();
    },

    setValue: function (value) {

    },

    getValue: function () {
        
    }
}