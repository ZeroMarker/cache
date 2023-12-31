/**
 * dhccl.tablecolumnseditor.js
 * 列编辑
 * @param {*} opt 
 */

function TableColumnsEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 700,
        height: 400
    });

    this.columnsInfo = opt.value;
    this.onSave = opt.onSave;

    this.init();
}

TableColumnsEditor.prototype = {
    constructor: TableColumnsEditor,

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

        this.dataView = $("<table></table>").appendTo(this.dom);
        this.dataView.datagrid({
            fit: true,
            singleSelect: true,
            rownumbers: true,
            columns: [
                [
                    { field: "ColumnCode", title: "列代码", width: 80, editor:"text"},
                    { field: "ColumnDesc", title: "列名", width: 150, editor:"text" },
                    { field: "RelativeWidth", title: "相对宽度", width: 80, editor:"numberbox" },
                    { field: "Type", title: "控件类型", width: 140, 
                        editor:{
                            type:"combobox",
                            options:{
                                valueField: "value",
                                textField: "text",
                                editable: false,
                                data: [
                                    {value:"textbox",text:"textbox"},
                                    {value:"checkbox",text:"checkbox"},
                                    {value:"combobox",text:"combobox"},
                                    {value:"datebox",text:"datebox"},
                                    {value:"datetimebox",text:"datetimebox"},
                                    {value:"timespinner",text:"timespinner"},
                                    {value:"numberspinner",text:"numberspinner"}
                                ]
                            }
                        }
                    },
                    { field: "Desc", title: "控件描述", width: 80, editor:"text" },
                    { field: "Editable", title: "是否可编辑", width: 80,  
                        editor:{
                            type:"combobox",
                            options:{
                                valueField: "value",
                                textField: "text",
                                data: [
                                    {value:"true",text:"true"},
                                    {value:"false",text:"false"}
                                ]
                            }
                        } 
                    },
                    { field: "UnderLine", title: "是否下划线", width: 80, 
                        editor:{
                            type:"combobox",
                            options:{
                                valueField: "value",
                                textField: "text",
                                data: [
                                    {value:"true",text:"true"},
                                    {value:"false",text:"false"}
                                ]
                            }
                        }  
                    },
                    { field: "Required", title: "是否必须", width: 80, 
                        editor:{
                            type:"combobox",
                            options:{
                                valueField: "value",
                                textField: "text",
                                data: [
                                    {value:"true",text:"true"},
                                    {value:"false",text:"false"}
                                ]
                            }
                        }  
                    },
                    { field: "DefaultValue", title: "默认值", width: 80, editor:"text" },
                    { field: "Unit", title: "单位", width: 80, editor:"text" },
                    { field: "Options", title: "下拉框多选值", width: 100, editor:"text" },
                    { field: "TextDirection", title: "文本方向", width: 80, 
                        editor:{
                            type:"combobox",
                            options:{
                                valueField: "value",
                                textField: "text",
                                data: [
                                    {value:"Horizontal",text:"Horizontal"},
                                    {value:"Vertical",text:"Vertical"}
                                ]
                            }
                        }  
                    },
                    { field: "ControlWidth", title: "控件宽度", width: 80, editor:"numberbox" }
                ]
            ],
            toolbar: [
                {
                    iconCls: "icon-add",
                    text: "增加一列",
                    handler: function(){
                        $this.addRow();
                    }
                },"-",{
                    iconCls: "icon-remove",
                    text: "删除一列",
                    handler: function(){
                        $this.deleteRow();
                    }
                },"-",{
                    iconCls: "icon-clear",
                    text: "删除所有列",
                    handler: function(){
                        $this.deleteAllRows();
                    }
                }
            ],
            data: $this.columnsInfo.value
        }).datagrid("enableCellEditing");;

        this.dlg = this.dom.dialog({
            width: $this.options.width,
            height: $this.options.height,
            title: "列编辑",
            modal: true,
            closed: true,
            buttons: buttons
        });
    },

    addRow: function(){
        this.dataView.datagrid('appendRow',{
            ColumnCode: "",
            ColumnDesc: "",
            RelativeWidth: 100,
            Desc: "",
            Editable: true,
            UnderLine: false,
            Required: false,
            DefaultValue: "",
            Unit:"",
            Options: "",
            TextDirection: "",
            ControlWidth: 0
        });
    },
    
    deleteRow: function(){
        var selectedRow = this.dataView.datagrid("getSelected");
        if(selectedRow){
            var index = this.dataView.datagrid("getRowIndex",selectedRow);
            this.dataView.datagrid("deleteRow", index);
        }else{
            $.messager.alert("提示", "请选中一行!!");
        }
    },

    deleteAllRows: function(){
        this.clear();
    },

    open: function () {
        this.dlg.dialog("open");
        this.dlg.dialog("center");
    },

    close: function () {
        this.clear();
        this.dlg.dialog("close");
        this.dlg.dialog("destroy");
    },

    clear: function () {
        this.dataView.datagrid("loadData", []);
    },

    save: function () {
        this.dataView.datagrid("acceptChanges");
        var columnsData = this.dataView.datagrid("getData").rows;
        var codeArr = [];
        var result = [];
        for(var i = 0; i < columnsData.length; i++){
            columnsData[i].RelativeWidth = parseInt(columnsData[i].RelativeWidth);
            var singleData = {
                ColumnCode : columnsData[i].ColumnCode == undefined ? "" : columnsData[i].ColumnCode,
                ColumnDesc : columnsData[i].ColumnDesc == undefined ? "" : columnsData[i].ColumnDesc,
                RelativeWidth : parseInt(columnsData[i].RelativeWidth),
                Type : columnsData[i].Type == undefined ? "" : columnsData[i].Type,
                Desc : columnsData[i].Desc == undefined ? "" : columnsData[i].Desc,  
                Editable : columnsData[i].UnderLine == "true" || columnsData[i].UnderLine == true,
                UnderLine: columnsData[i].UnderLine == "true" || columnsData[i].UnderLine == true,
                Required: columnsData[i].Required == "true" || columnsData[i].Required == true,
                DefaultValue: columnsData[i].DefaultValue == undefined ? "" : columnsData[i].DefaultValue,
                Unit: columnsData[i].Unit == undefined ? "" : columnsData[i].Unit,
                Options: columnsData[i].Options == undefined ? "" : columnsData[i].Options,
                TextDirection: columnsData[i].TextDirection == undefined ? "" : columnsData[i].TextDirection,
                ControlWidth: parseInt(columnsData[i].ControlWidth) == NaN ? 0 : parseInt(columnsData[i].ControlWidth)
            }
            
            if(singleData.ColumnCode == ""){
                $.messager.alert("提示","第" + (i+1) + "行代码为空");
                return;
            }

            if(codeArr.indexOf(singleData.ColumnCode) >= 0){
                $.messager.alert("提示","第" + (i+1) + "行代码重复");
                return;
            }
            codeArr.push(singleData.ColumnCode);
            result.push(singleData);
        }
        if(this.onSave) this.onSave(result);
        this.close();
    }
}