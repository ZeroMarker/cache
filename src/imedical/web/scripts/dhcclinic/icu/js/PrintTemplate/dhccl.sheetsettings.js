function SheetSettings(opts) {
    this.options = $.extend({
        width: 900,
        height: 500
    }, opts);
    this.operDataElements = opts.elements;
    this.init();
}

SheetSettings.prototype = {
    init: function () {
        this.dom = $("<div style='padding:10px 10px 0 10px;'></div>").appendTo("body");
        this.dataBox = $("<table></table>").appendTo(this.dom);
        this.initDialog();
        this.initDataGrid();
    },

    initDialog: function () {
        var $this = this;
        this.dom.dialog({
            title: "页面编辑器-" + $this.options.title,
            width: this.options.width,
            height: this.options.height,
            closed: true,
            modal: true,
            iconCls: "icon-edit",
            buttons: [{
                text: "退出",
                iconCls: "icon-w-cancel",
                handler: function () {
                    $this.exit();
                }
            }],
            onOpen: function () {
                $this.reload();
                if ($this.options.openCallBack)
                    $this.options.openCallBack();
            },
            onClose: function () {
                if ($this.options.closeCallBack)
                    $this.options.closeCallBack();
            }
        });
    },

    /**
     * 初始化数据表格
     */
    initDataGrid: function () {
        var $this = this;
        var columns = [
            [{
                field: "ElementDesc",
                title: "元素名称",
                width: 200,
            }, {
                field: "ElementID",
                title: "元素ID",
                width: 200,
            }, {
                field: "ControlType",
                title: "控件类型",
                width: 180
            }, {
                field: "Enable",
                title: "可用",
                width: 80,
                editor: {
                    type: "combobox",
                    options: {
                        valueField: "value",
                        textField: "value",
                        data: CommonArray.WhetherOrNot
                    }
                }
            }, {
                field: "Visible",
                title: "可见",
                width: 80,
                editor: {
                    type: "combobox",
                    options: {
                        valueField: "value",
                        textField: "value",
                        data: CommonArray.WhetherOrNot
                    }
                }
            }, {
                field: "Required",
                title: "必填项",
                width: 80,
                editor: {
                    type: "combobox",
                    options: {
                        valueField: "value",
                        textField: "value",
                        data: CommonArray.WhetherOrNot
                    }
                }
            }]
        ];

        var toolbar = [{
            text: "查询",
            iconCls: "icon-search",
            plain: true,
            handler: function () {
                $this.reload();
            }
        }, {
            text: "安全组",
            iconCls: "icon-save",
            plain: true,
            handler: function () {
                $this.save({
                    DataModule: $this.options.moduleId,
                    Site: window.location.host,
                    SSGroup: session.GroupID,
                    SSUser: "",
                    UpdateUser: session.UserID
                });
            }
        }, {
            text: "用户",
            iconCls: "icon-save",
            plain: true,
            handler: function () {
                $this.save({
                    DataModule: $this.options.moduleId,
                    Site: window.location.host,
                    SSGroup: session.GroupID,
                    SSUser: session.UserID,
                    UpdateUser: session.UserID
                });
            }
        }];

        var elementDatas = $this.getData();
        this.dataBox.datagrid({
            fit: true,
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            rownumbers: true,
            headerCls: "panel-header-gray",
            bodyCls: "panel-header-gray",
            url: ANCSP.DataQuery,
            columns: columns,
            toolbar: toolbar,
            data: elementDatas,
            sortName: "SeqNo",
            onClickRow: function (rowIndex, rowData) {
                $(this).datagrid("beginEdit", rowIndex);
            }
        });
    },

    /**
     * 保存
     */
    save: function (elementPermission) {
        var $this = this;
        elementPermission.ClassName = ANCLS.Config.SheetPermission;
        var saveDatas = [elementPermission];
        var permissionItems = $this.dataBox.datagrid("getRows");
        for (var i = 0; i < permissionItems.length; i++) {
            $this.dataBox.datagrid("endEdit", i);
            var permissionItem = permissionItems[i];
            if (!permissionItem.SheetPermission) permissionItem.SheetPermission = "";
            saveDatas.push({
                RowId: permissionItem.RowId,
                ElementID: permissionItem.ElementID,
                ElementDesc: permissionItem.ElementDesc,
                Enable: permissionItem.Enable,
                Visible: permissionItem.Visible,
                SheetPermission: permissionItem.SheetPermission,
                ControlType: permissionItem.ControlType,
                Required: permissionItem.Required,
                ClassName: ANCLS.Config.SheetElement
            });
        }
        if (saveDatas.length > 0) {
            var saveDataStr = dhccl.formatObjects(saveDatas);
            dhccl.saveDatas(ANCSP.DataListService, {
                ClassName: ANCLS.BLL.SheetSettings,
                MethodName: "SaveSheetSettings",
                jsonData: saveDataStr
            }, function (data) {
                if (data.indexOf("S^") === 0) {
                    $.messager.alert("提示", "保存成功", "info");
                } else {
                    $.messager.alert("提示", "保存失败，原因：" + data, "error");
                }
            })
        }
    },

    exit: function () {
        this.close();
    },

    reload: function () {
        this.dataBox.datagrid("reload");
    },

    open: function () {
        this.dom.dialog("open");
    },

    close: function () {
        this.dom.dialog("close");
    },

    getData: function () {
        var $this = this;

        var sheetElements = dhccl.getDatas(ANCSP.MethodService, {
            ClassName: ANCLS.BLL.SheetSettings,
            MethodName: "GetSheetElements",
            Arg1: session.ModuleID,
            Arg2: session.GroupID,
            Arg3: session.UserID,
            ArgCnt: 3
        }, "json");
        if (sheetElements && sheetElements.length > 0) {
            return sheetElements;
        }

        var elements = this.operDataElements;

        $(".hisui-linkbutton").each(function (index, item) {
            elements.push({
                ElementID: $(item).attr("id"),
                ElementDesc: $(item).text(),
                ControlType: "linkbutton",
                Enable: "Y",
                Visible: "Y",
                Required: "N",
                SheetPermission: "",
                RowId: ""
            });
        });

        return elements
    }
}