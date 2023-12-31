/**
 * dhccl.templateeditor.js
 * 模板JSON文件编辑
 * @param {*} opt 
 */
function TemplateEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 600,
        height: 510
    });

    this.value = this.options.value;
    this.config = this.options.config;
    this.textArea = null;

    this.init();
}

TemplateEditor.prototype = {
    constructor: TemplateEditor,

    init: function () {
        this.dom = $("<div></div>").appendTo("body");
        this.render();
    },

    render: function () {
        var $this = this;

        var buttons = $("<div></div>");

        var btnDownload = $('<a href="#"></a>').linkbutton({
            text: '下载',
            iconCls: 'icon-download',
            onClick: function () {
                $this.downloadJson();
            }
        }).appendTo(buttons);

        var btnSave = $('<a href="#"></a>').linkbutton({
            text: '确定',
            iconCls: 'icon-save',
            onClick: function () {
                if ($this.validateJson()) {
                    $this.save();
                } else {
                    $.messager.alert("错误", "JSON数据有问题,请检查!", "error");
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
            title: "模板JSON文件编辑",
            modal: true,
            closed: true,
            buttons: buttons
        });

        this.container = $("<div></div>");

        this.textArea = $("<textarea></textarea>").appendTo(this.container);
        this.textArea.css({
            "width": 590,
            "height": 400
        });
        if (this.value) {
            this.setValue(this.value)
        }

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
        //this.dlg.dialog("destroy");
    },

    clear: function () {
        this.textArea.val("");
    },

    save: function () {
        var value = this.textArea.val();
        if (this.options.onSave) {
            this.options.onSave(value);
        }
        this.close();
    },

    setValue: function (value) {
        this.textArea.val(value);
    },

    getValue: function () {
        var value = this.textArea.val();
        return value;
    },

    validateJson: function () {
        var value = this.textArea.val();
        try {
            var sheetData = JSON.parse(value);
        } catch (error) {
            return false;
        }
        return true;
    },

    downloadJson: function () {
        if (!this.validateJson()) {
            $.messager.alert("错误", "JSON数据有问题,请检查!", "error");
            return;
        }

        var $this = this;
        var sheetDataStr = this.getValue();
        $.messager.prompt("提示", "请输入文件名:", function (result) {
            if (result) {
                var fileName = result + ".json";
                var datastr = "data:text/json;charset=utf-8," + encodeURIComponent(sheetDataStr);
                var downloadAnchorNode = document.createElement("a");
                downloadAnchorNode.setAttribute("href", datastr);
                downloadAnchorNode.setAttribute("download", fileName);
                downloadAnchorNode.click();
                downloadAnchorNode.remove();
                //$this.downloadFile(sheetDataStr, fileName);
            }
        });
    },

    downloadFile: function (content, filename) {
        var ele = document.createElement('a');
        ele.download = filename;
        ele.style.display = 'none';
        var blob = new Blob([content]);
        ele.href = URL.createObjectURL(blob);
        document.body.appendChild(ele);
        ele.click();
        document.body.removeChild(ele);
    },

    updateJson: function () {
        var sheetData = JSON.parse(this.value);
        var sheet = sheetData.Sheet;

        for (var i = 0; i < sheet.Pages.length; i++) {
            var page = sheet.Pages[i];

            for (var j = 0; j < page.Images.length; j++) {
                var image = page.Images[j];
                mergeObject(image, this.config.defaultImage);
            }

            for (var j = 0; j < page.Titles.length; j++) {
                var title = page.Titles[j];
                mergeObject(title, this.config.defaultTitle);
            }

            for (var j = 0; j < page.Areas.length; j++) {
                var area = page.Areas[j];
                mergeObject(area, this.config.defaultArea);

                for (var k = 0; k < area.AreaItems.length; k++) {
                    var areaItem = area.AreaItems[k];
                    switch (areaItem.Type) {
                        case "textbox":
                            mergeObject(areaItem, this.config.defaultTextboxAreaItem);
                            break;
                        case "combobox":
                            mergeObject(areaItem, this.config.defaultComboboxAreaItem);
                            break;
                        case "datebox":
                            mergeObject(areaItem, this.config.defaultDateboxAreaItem);
                            break;
                        case "signature":
                            mergeObject(areaItem, this.config.defaultSignatureAreaItem);
                            break;
                        case "checkbox":
                            mergeObject(areaItem, this.config.defaultCheckboxAreaItem);
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        var sheetDataStr = JSON.stringify({
            Sheet: sheet
        }, null, 2);

        this.setValue(sheetDataStr);

        function mergeObject(obj1, obj2) {
            for (var property in obj2) {
                if (!obj1.hasOwnProperty(property)) {
                    obj1[property] = obj2[property];
                }
            }
        }
    }
}