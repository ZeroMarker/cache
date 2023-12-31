/**
 * 表单设置 dhccl.pagesettingeditor.js
 * @param {*} dom 
 * @param {*} pageSetting 
 */

function PageSettingEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 700,
        height: 500
    });

    this.pageSetting = this.options.pageSetting;
    this.onSave = this.options.onSave;
    this.init();
}

PageSettingEditor.prototype = {
    constructor: PageSettingEditor,

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
            title: "表单设置",
            modal: true,
            closed: true,
            buttons: buttons
        });

        this.container = $("<div></div>");
        this.container.css({
            width: 670,
            height: 350,
            border: "1px solid #ccc",
            margin: 10
        });

        this.dlg.dialog({
            content: $this.container
        });

        var table = $("<table></table>").appendTo($(this.container));

        var tr1 = $("<tr></tr>").appendTo(table);
        $("<td>表单代码:</td>").appendTo(tr1);
        var valueTD11 = $("<td></td>").appendTo(tr1);
        this.codeTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD11);
        $("<td>表单描述:</td>").appendTo(tr1);
        var valueTD12 = $("<td></td>").appendTo(tr1);
        this.descTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD12);

        var tr2 = $("<tr></tr>").appendTo(table);
        $("<td>表单宽:</td>").appendTo(tr2);
        var valueTD21 = $("<td></td>").appendTo(tr2);
        this.widthTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD21);
        $("<td>表单高:</td>").appendTo(tr2);
        var valueTD22 = $("<td></td>").appendTo(tr2);
        this.heightTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD22);


        var tr3 = $("<tr></tr>").appendTo(table);
        $("<td>纸张类型:</td>").appendTo(tr3);
        var valueTD21 = $("<td></td>").appendTo(tr3);
        this.pageNameTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD21);
        $("<td>纸张方向:</td>").appendTo(tr3);
        var valueTD22 = $("<td></td>").appendTo(tr3);
        this.orientTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD22);
        $("<span style='color:red;'>*Vertical-竖向,Horizontal-横向<span>").appendTo(valueTD22);
        /*this.orientCombobox = $('<select class="hisui-combobox" style="width:100px;" />').appendTo(valueTD22);
        this.orientCombobox.combobox({
            valueField: "OrientCode",
            textField: "OrientDesc",
            multiple: false
        });
        this.orientCombobox.combobox("loadData",[{
            OrientCode: "Vertical",
            OrientDesc: "竖向打印"
        }, {
            OrientCode: "Horizontal",
            OrientDesc: "横向打印"
        }]);*/

        var tr4 = $("<tr></tr>").appendTo(table);
        $("<td>纸张宽:</td>").appendTo(tr4);
        var valueTD41 = $("<td></td>").appendTo(tr4);
        this.pageWidthTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD41);
        $("<td>纸张高:</td>").appendTo(tr4);
        var valueTD42 = $("<td></td>").appendTo(tr4);
        this.pageHeightTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD42);

        var tr5 = $("<tr></tr>").appendTo(table);
        $("<td>打印检查完整性:</td>").appendTo(tr5);
        var valueTD51 = $("<td></td>").appendTo(tr5);
        this.printCheckRequiredCheckbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD51);
        $("<td>归档检查完整性:</td>").appendTo(tr5);
        var valueTD52 = $("<td></td>").appendTo(tr5);
        this.archiveCheckRequiredCheckbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD52);

        var tr6 = $("<tr></tr>").appendTo(table);
        var valueTD61 = $("<td>加载JS路径:</td>").appendTo(tr6);
        var valueTD62 = $("<td colspan=3></td>").appendTo(tr6);
        this.scriptPathTextbox = $('<input type="text" class="textbox" style="width:500px;"/>').appendTo(valueTD62);

        var tr6 = $("<tr></tr>").appendTo(table);
        $("<td>是否双面打印:</td>").appendTo(tr6);
        var valueTD61 = $("<td></td>").appendTo(tr6);
        this.printDuplexCheckbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD61);
        $("<td></td>").appendTo(tr6);
        $("<td></td>").appendTo(tr6);

        var tr7 = $("<tr></tr>").appendTo(table);
        $("<td>页面加载方法:</td>").appendTo(tr7);
        var valueTD71 = $("<td></td>").appendTo(tr7);
        this.onLoadedMethodTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD71);
        $("<td>保存加载方法:</td>").appendTo(tr7);
        var valueTD72 = $("<td></td>").appendTo(tr7);
        this.onSavedMethodTextbox = $('<input type="text" class="textbox" style="width:100px;"/>').appendTo(valueTD72);

        this.setValue(this.pageSetting);
    },

    setValue: function (val) {
        if (val) {
            this.codeTextbox.val(val.Code);
            this.descTextbox.val(val.Desc);
            this.widthTextbox.val(val.Size.width);
            this.heightTextbox.val(val.Size.height);

            this.pageNameTextbox.val(val.PageName);
            this.orientTextbox.val(val.PageDirection);
            this.pageWidthTextbox.val(val.PageSize.width);
            this.pageHeightTextbox.val(val.PageSize.height);
            this.printCheckRequiredCheckbox.val(val.PrintCheckRequired);
            this.archiveCheckRequiredCheckbox.val(val.ArchiveCheckRequired);
            this.scriptPathTextbox.val(val.ScriptPath);
            this.printDuplexCheckbox.val(val.PrintDuplex);

            this.onLoadedMethodTextbox.val(val.OnLoadedMethod);
            this.onSavedMethodTextbox.val(val.OnSavedMethod);
        }
    },

    getValue: function (val) {
        var $this = this;
        var val = {
            Code: $this.codeTextbox.val(),
            Desc: $this.descTextbox.val(),
            Size: {
                width: parseInt($this.widthTextbox.val()),
                height: parseInt($this.heightTextbox.val())
            },
            PageName: $this.pageNameTextbox.val(),
            PageDirection: $this.orientTextbox.val(),
            PageSize: {
                width: $this.pageWidthTextbox.val(),
                height: $this.pageHeightTextbox.val()
            },
            PrintCheckRequired: $this.printCheckRequiredCheckbox.val() == "true" ? true : false,
            ArchiveCheckRequired: $this.archiveCheckRequiredCheckbox.val() == "true" ? true : false,
            ScriptPath: $this.scriptPathTextbox.val(),
            PrintDuplex: $this.printDuplexCheckbox.val() == "true" ? true : false,
            OnLoadedMethod: $this.onLoadedMethodTextbox.val(),
            OnSavedMethod: $this.onSavedMethodTextbox.val()
        }
        return val;
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
            var pageSetting = this.getValue();
            this.onSave(pageSetting);
        }
    }
}