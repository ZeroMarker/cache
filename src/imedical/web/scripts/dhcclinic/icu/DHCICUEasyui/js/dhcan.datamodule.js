$(document).ready(function() {
    var dataBox = $("#dataBox"),
        dataForm = $("#dataForm"),
        dataDialog = $("#dataDialog"),
        entityClass = ANCLS.Code.DataModule,
        entityQuery = "FindDataModule";
    //initialDataCommon(dataBox,dataForm,entityClass,entityQuery,dataDialog);
    dataBox.treegrid({
        idField: "RowId",
        treeField: "Description",
        title: "数据模块",
        columns: [
            [
                { field: "Description", title: "名称", width: 240 },
                { field: "Code", title: "代码", width: 120 },
                { field: "ParentModuleDesc", title: "父模块", width: 120 },
                { field: "URL", title: "链接URL", width: 240 },
                { field: "MenuModuleDesc", title: "是否菜单", width: 120 },
                { field: "Icon", title: "图标", width: 120 },
                { field: "ActiveDesc", title: "是否激活", width: 120 },
                { field: "SeqNo", title: "排序号", width: 80 }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: entityQuery,
            Arg1: $("#filterDesc").val(),
            Arg2: $("#filterParent").combobox("getValue"),
            ArgCnt: 2
        },
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        pageSize: 200,
        pageList: [50, 100, 200],
        headerCls: "panel-header-gray"
    });

    $("#filterParent,#ParentModule").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: entityQuery,
        //     Arg1: "",
        //     Arg2: "",
        //     ArgCnt: 2
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = entityQuery;
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function() {
            dataBox.treegrid("reload", {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: entityQuery,
                Arg1: $("#filterDesc").val(),
                Arg2: $("#filterParent").combobox("getValue"),
                ArgCnt: 2
            })
        }
    });

    dataForm.form({
        url: dhccl.csp.dataService,
        onSubmit: function(param) {
            param.ClassName = entityClass;
            var isValid = $(this).form("validate");
            return isValid;
        },
        // queryParams: {
        //     ClassName: entityClass
        // },
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                dataForm.form("clear");
                dataBox.treegrid("reload");
                if (dataDialog) {
                    dataDialog.dialog("close");
                }
                if (initialQuery) {
                    initialQuery();
                }
            });
        }
    });

    if (dataDialog) {
        dataDialog.dialog({
            buttons: [{
                text: "保存",
                iconCls: "icon-save",
                handler: function() {
                    dataForm.submit();
                }
            }, {
                text: "取消",
                iconCls: "icon-cancel",
                handler: function() {
                    dataDialog.dialog("close");
                }
            }],
            onClose: function() {
                dataForm.form("clear");
            },
            onOpen: function() {}
        });
    }

    $("#btnAdd").linkbutton({
        onClick: function() {
            $("#RowId").val("");
            if (dataDialog) {
                dataDialog.dialog({
                    title: "新增",
                    iconCls: "icon-add"
                });
                dataDialog.dialog("open")
            } else {
                dataForm.submit();
            }

        }
    });

    $("#btnEdit").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataBox, true)) {
                if (dataDialog) {
                    dataDialog.dialog({
                        title: "修改",
                        iconCls: "icon-edit"
                    });
                    var selectedRow = dataBox.treegrid("getSelected");
                    dataForm.form("load", selectedRow);
                    dataDialog.dialog("open")
                } else {
                    dataForm.submit();
                }

            }
        }
    });

    $("#btnDel").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataBox, true)) {
                $.messager.confirm("确认", "是否删除该数据记录？", function(result) {
                    if (result) {
                        var selectedRow = dataBox.treegrid("getSelected");
                        var msg = dhccl.removeData(entityClass, selectedRow.RowId);
                        dhccl.showMessage(msg, "删除", null, null, function() {
                            dataForm.form("clear");
                            dataBox.treegrid("reload");
                        })
                    }
                });
            }
        }
    });

    $("#btnDataItem").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataBox, true)) {
                var selectedRow = dataBox.treegrid("getSelected"),
                    href = "dhcan.dataitem.csp?moduleId=" + selectedRow.RowId,
                    title = selectedRow.Description + "的元素";
                window.parent.addTab(title, href, true);
            }
        }
    });

    $("#btnDataOptions").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataBox, true)) {
                var selectedRow = dataBox.treegrid("getSelected"),
                    href = "dhcan.moddataoptions.csp?relatedModuleID=" + selectedRow.RowId,
                    title = selectedRow.Description + "的数据选项";
                $("#modDataOptionsDialog").dialog("setTitle", title);
                $("#modDataOptionsDialog").dialog({
                    content: "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>"
                });
                $("#modDataOptionsDialog").dialog("open");
            }
        }
    });
});

function initialQuery() {
    $("#filterParent,#ParentModule").combobox("reload");
}