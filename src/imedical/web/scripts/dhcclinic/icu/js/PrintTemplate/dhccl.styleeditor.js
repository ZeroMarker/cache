/**
 * dhccl.styleeditor.js
 * 样式编辑
 * @param {*} opt 
 */
function StyleEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 600,
        height: 500
    });

    this.styleArray = opt.value;
    this.onSave = opt.onSave;
    this.onStylesChanged = opt.onStylesChanged;
    this.styleTextAreaArray = [];
    this.selectedStyleIndex = null;

    this.init();
}

StyleEditor.prototype = {
    constructor: StyleEditor,

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
                if(!$this.checkSelectedRow()){
                    return;
                }
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
            title: "表单设置及样式编辑",
            modal: true,
            closed: true,
            buttons: buttons
        });

        this.container = $("<div></div>");
        this.container.css({
            width: 550,
            height: 350,
            border: "1px solid #ccc",
            margin: 10
        });

        this.dataView = $("<table></table>").appendTo(this.container);
        this.dataView.datagrid({
            fit: true,
            singleSelect: true,
            rownumbers: true,
            width: 450,
            columns: [
                [{
                        field: "StyleCode",
                        title: "代码",
                        width: 140,
                        editor: "text"
                    },
                    {
                        field: "StyleDesc",
                        title: "描述",
                        width: 140,
                        editor: "text"
                    },
                    {
                        field: "edit",
                        title: "编辑",
                        width: 50,
                        align: 'center',
                        formatter: function (value, rec) {
                            var btn = '<a href="javascript:void(0)">编辑</a>';
                            return btn;
                        }
                    },
                    {
                        field: "add",
                        title: "增加",
                        width: 50,
                        align: 'center',
                        formatter: function (value, rec) {
                            if(["TitleStyle", "AreaStyle", "AreaItemStyle", "TableStyle"].indexOf(rec.StyleCode) >= 0){
                                var btn = '<a href="javascript:void(0)">增加</a>';
                                return btn;
                            }
                            
                        }
                    },
                    {
                        field: "del",
                        title: "删除",
                        width: 50,
                        align: 'center',
                        formatter: function (value, rec) {
                            if(["TitleStyle", "AreaStyle", "AreaItemStyle", "TableStyle"].indexOf(rec.StyleCode) == -1){
                                var btn = '<a href="javascript:void(0)">删除</a>';
                                return btn;
                            }
                        }
                    }
                ]
            ],
            onClickCell: function (index, field, value) {
                if (field == "edit") {
                    var record = $this.styleArray[index];
                    $this.selectedStyleIndex = index;
                    $this.editSingleStyleValue(record);
                }

                if(field == "add"){
                    var record = clone($this.styleArray[index], new WeakMap());
                    $this.selectedStyleIndex = index;
                    if(["TitleStyle", "AreaStyle", "AreaItemStyle", "TableStyle"].indexOf(record.StyleCode) >= 0){
                        $this.addSingleStyleValue(record);
                    }
                }

                if(field == "del"){
                    var record = $this.styleArray[index];
                    if(["TitleStyle", "AreaStyle", "AreaItemStyle", "TableStyle"].indexOf(record.StyleCode) == -1){
                        $this.delSingleStyleValue(record);
                        $this.selectedStyleIndex = null;
                    }
                }
            },
            data: $this.styleArray
        });

        this.dlg.dialog({
            content: $this.container
        });
    },

    editSingleStyleValue: function (styleValue) {
        var $this = this;
        var singleStyleEditor = new SingleStyleEditor({
            value: styleValue,
            onSave: function (singleStyle) {
                if ($this.selectedStyleIndex != null) {
                    $this.styleArray[$this.selectedStyleIndex] = singleStyle;
                    $this.onStylesChanged($this.styleArray);
                    $this.dataView.datagrid("loadData", $this.styleArray);
                }
            }
        });
        singleStyleEditor.open();
    },

    addSingleStyleValue: function (styleValue) {
        var $this = this;
        var singleStyleEditor = new SingleStyleEditor({
            value: styleValue,
            onSave: function (singleStyle) {
                if ($this.checkStyleCodeExist(singleStyle.StyleCode)) {
                    $.messager.alert("警告", singleStyle.StyleCode + "已存在，添加失败", "error");
                }else{
                    $this.styleArray.push(singleStyle);
                    $this.onStylesChanged($this.styleArray);
                    $this.dataView.datagrid("loadData", $this.styleArray);
                }
            }
        });
        singleStyleEditor.open();
    },

    delSingleStyleValue: function(styleValue){
        var index = this.styleArray.indexOf(styleValue); 
        if (index > -1) { 
            this.styleArray.splice(index, 1);
            this.onStylesChanged(this.styleArray);
            this.dataView.datagrid("loadData", this.styleArray); 
        }
    },

    checkStyleCodeExist: function(styleCode){
        for (var i = 0; i < this.styleArray.length; i++) {
            var style = this.styleArray[i];
            if (style.StyleCode == styleCode) {
                return true;
            }
        }
        return false;
    },

    checkSelectedRow: function(){
        if(this.dataView.datagrid("getSelected")){
            return true;
        }else{
            $.messager.alert("提示", "请选择一行");
            return;
        }
    },

    open: function () {
        this.dlg.dialog("open");
        this.dlg.dialog("center");
    },

    close: function () {
        this.dlg.dialog("close");
        this.dlg.dialog("destroy");
    },

    save: function () {
        if (this.onSave) {
            var row = this.dataView.datagrid("getSelected");
            if(row) {
                var styleCode = row.StyleCode;
                this.onSave(styleCode);
            }
        }
    }
}














/**
 * 样式编辑框
 * @param {*} opt 
 */

function SingleStyleEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 300,
        height: 520
    });

    this.styleValue = opt.value;
    this.onSave = opt.onSave;

    this.init();
}

SingleStyleEditor.prototype = {
    constructor: SingleStyleEditor,

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
            title: "样式编辑",
            modal: true,
            closed: true,
            buttons: buttons
        });

        this.container = $("<div></div>");
        this.setStyleValue(this.styleValue, this.container);
        this.dlg.dialog({
            content: $this.container
        });
    },

    getStyleValue: function (styleContaner) {
        var value = $(styleContaner).data("StyleObject");
        return value;
    },

    setStyleValue: function (style, styleContainer) {
        var $this = this;
        var table = $("<table></table>");
        $.each(style, function (key, value) {
            var tr = $("<tr></tr>").appendTo(table);
            var labelTD = $("<td></td>").appendTo(tr);
            var valueTD = $("<td></td>").appendTo(tr);
            var label = $('<label>' + key + ':</label>').appendTo(labelTD);
            if (typeof value == "object") {
                $this.setSubStyleValue(value, valueTD);
            } else {
                var textbox = $('<input type="text" class="textbox" style="width:150px;"/>').appendTo(valueTD);
                textbox.val(value);
                textbox.change(function () {
                    var value = $(this).val();
                    if (value == "true") value = true;
                    if (value == "false") value = false;
                    style[key] = value;
                });
            }
        });
        $(styleContainer).data("StyleObject", style);
        table.appendTo(styleContainer);
    },

    setSubStyleValue: function (subStyleValue, tdContainer) {
        var table = $("<table></table>").appendTo(tdContainer);
        table.css("border", "1px solid #ccc");
        $.each(subStyleValue, function (subKey, value) {
            var tr = $("<tr></tr>").appendTo(table);
            var td1 = $("<td></td>").appendTo(tr);
            var td2 = $("<td></td>").appendTo(tr);
            $('<label>' + subKey + ':</label>').appendTo(td1);
            var textbox = $('<input type="text" class="textbox" style="width:70px;"/>').appendTo(td2);
            textbox.val(value);
            textbox.change(function () {
                var value = $(this).val();
                if (value == "true") value = true;
                if (value == "false") value = false;

                if(["FontSize","LineWidth"].indexOf(subKey) >= 0){
                    if(isNaN(value)) {
                        $(this).css("background-color", "pink");
                        return;
                    }else{
                        $(this).css("background-color", "white");
                    }
                    value = parseInt(value);
                }
                if(subKey == "Weight"){
                    if(["normal", "bold", "bolder", "lighter"].indexOf(value) == -1){
                        $(this).css("background-color", "pink");
                        return;
                    }
                }

                subStyleValue[subKey] = value;
            });
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

    save: function () {
        if (this.onSave) {
            var value = this.getStyleValue(this.container);
            this.onSave(value);
        }
    }
}