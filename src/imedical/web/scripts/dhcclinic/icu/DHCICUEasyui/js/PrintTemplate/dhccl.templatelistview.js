/**
 * 模板列表视图界面
 * dhccl.templatelistview.js
 */

function TemplateListView(opt) {
    this.options = $.extend({}, opt, {
        width: 650,
        height: 500
    });

    this.onSave = opt.onSave;
    this.onStylesChanged = opt.onStylesChanged;
    this.printTemplateList = this.getData();
    this.selectedStyleIndex = null;
    this.editIndex = undefined;

    this.init();
}

TemplateListView.prototype = {
    constructor: TemplateListView,

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
                if (!$this.checkSelectedRow()) {
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
            title: "打印模板列表",
            modal: true,
            closed: true,
            buttons: buttons
        });

        this.container = $("<div></div>");
        this.container.css({
            width: 600,
            height: 350,
            border: "1px solid #ccc",
            margin: 10
        });

        this.dataView = $("<table></table>").appendTo(this.container);
        this.dataView.datagrid({
            fit: true,
            singleSelect: true,
            rownumbers: true,
            iconCls: 'icon-edit',
            width: 550,
            columns: [
                [{
                    field: "RowId",
                    title: "RowId",
                    width: 80
                }, {
                    field: "Code",
                    title: "代码",
                    width: 140,
                    editor: "text"
                }, {
                    field: "Description",
                    title: "描述",
                    width: 140,
                    editor: "text"
                }]
            ],
            toolbar: [{
                text: '增加',
                iconCls: 'icon-add',
                handler: function () {
                    $this.dataView.datagrid("appendRow", {
                        RowId: "",
                        Code: "",
                        Description: ""
                    });
                }
            }, {
                text: '保存',
                iconCls: 'icon-save',
                handler: function () {
                    var row = $this.dataView.datagrid('getSelected');
                    if (row) {
                        var index = $this.dataView.datagrid('getRowIndex', row);
                        $this.dataView.datagrid('endEdit', index);
                        var rows = $this.dataView.datagrid('getChanges');
                        $this.saveData(rows[0]);
                    } else {
                        $.messager.alert("提示", "请选择需要保存的行！");
                    }
                }
            }],
            onClickCell: function (index, field, value) {
                $this.dataView.datagrid('selectRow', index).datagrid('beginEdit', index);
            },
            onDblClickRow: function(rowIndex, rowData){
                if (!$this.checkSelectedRow()) {
                    return;
                }
                $this.save();
                $this.close();
            },
            data: $this.printTemplateList
        });

        this.dlg.dialog({
            content: $this.container
        });
    },

    getData: function () {
        var result = [];

        $.ajax({
            url: "CIS.AN.DataQuery.csp",
            async: false,
            data: {
                ClassName: "web.DHCICUPrintTemplate",
                QueryName: "FindICUPrintTemplate",
                ArgCnt: 0
            },
            type: "post",
            dataType: "json",
            success: function (data) {
                result = data;
            }
        });
        return result;
    },

    saveData: function (data) {
        var $this = this;
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: 'CIS.AN.MethodService.csp',
            async: false,
            cache: false,
            data: {
                ClassName: 'web.DHCICUPrintTemplate',
                MethodName: "SavePrintTemplateInfo",
                Arg1: data.RowId,
                Arg2: data.Code,
                Arg3: data.Description,
                ArgCnt: 3
            },
            success: function (ret) {
                var value = $.trim(ret);
                if (value.indexOf("S^") === 0) {
                    $.messager.popover({
                        msg: "保存成功",
                        type: "success"
                    });
                    var printTemplateData = $this.getData();
                    $this.dataView.datagrid("loadData", printTemplateData);
                } else {
                    $.messager.alert("提示", "上传数据失败，原因：" + ret, "error");
                }
            }
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
                } else {
                    $this.styleArray.push(singleStyle);
                    $this.onStylesChanged($this.styleArray);
                    $this.dataView.datagrid("loadData", $this.styleArray);
                }
            }
        });
        singleStyleEditor.open();
    },

    delSingleStyleValue: function (styleValue) {
        var index = this.styleArray.indexOf(styleValue);
        if (index > -1) {
            this.styleArray.splice(index, 1);
            this.onStylesChanged(this.styleArray);
            this.dataView.datagrid("loadData", this.styleArray);
        }
    },

    checkStyleCodeExist: function (styleCode) {
        for (var i = 0; i < this.styleArray.length; i++) {
            var style = this.styleArray[i];
            if (style.StyleCode == styleCode) {
                return true;
            }
        }
        return false;
    },

    checkSelectedRow: function () {
        var row = this.dataView.datagrid("getSelected");
        if (row) {
            if (row.RowId) {
                return true;
            } else {
                $.messager.alert("提示", "RowId为空，请先保存");
                return false;
            }
        } else {
            $.messager.alert("提示", "请选择一行");
            return false;
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
            if (row) {
                var rowId = row.RowId;
                this.onSave(rowId);
            }
        }
    }
}