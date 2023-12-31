$(document).ready(function() {
    var dataBox = $("#dataBox"),
        dataForm = $("#dataForm"),
        dataDialog = $("#dataDialog"),
        entityClass = ANCLS.Code.MenuItem,
        entityQuery = "FindMenuItems";
    //initialDataCommon(dataBox,dataForm,entityClass,entityQuery,dataDialog);
    dataBox.treegrid({
        idField: "RowId",
        treeField: "Description",
        border: false,
        // title: "菜单项",
        columns: [
            [
                { field: "Description", title: "名称", width: 240 },
                { field: "Code", title: "代码", width: 120 },
                { field: "MainItemDesc", title: "主菜单项", width: 120 },
                { field: "Url", title: "链接URL", width: 240 },
                { field: "Exp", title: "参数", width: 120 },
                { field: "MenuDesc", title: "菜单", width: 120 },
                { field: "LinkModuleDesc", title: "数据模块", width: 120 },
                { field: "SeqNo", title: "排序号", width: 80 },
                { field: "DisplayName", title: "显示名称", width: 120 }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: entityQuery,
            Arg1: $("#filterDesc").val(),
            Arg2: $("#filterMenu").combobox("getValue"),
            Arg3: "N",
            Arg4: session.HospID,
            ArgCnt: 4
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

    $("#LinkModule").combobox({
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
            param.QueryName = "FindDataModule";
            param.Arg1 = "";
            param.Arg2 = "";
            param.ArgCnt = 2;
        }
    });

    $("#filterMenu,#Menu").combobox({
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
            param.QueryName = "FindMenus";
            param.ArgCnt = 0;
        }
    });

    $("#MainItem").combobox({
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
            param.Arg2 = $("#filterMenu").combobox("getValue");
            param.Arg3 = "Y";
            param.Arg4 = session.HospID;
            param.ArgCnt = 4;
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function() {
            dataBox.treegrid("reload", {
                ClassName: ANCLS.BLL.CodeQueries,
                QueryName: entityQuery,
                Arg1: $("#filterDesc").val(),
                Arg2: $("#filterMenu").combobox("getValue"),
                Arg3: "N",
                Arg4: session.HospID,
                ArgCnt: 4
            });
            $("#MainItem").combobox("reload");
        }
    });

    dataForm.form({
        url: dhccl.csp.dataService,
        onSubmit: function(param) {
            param.ClassName = entityClass;
            param.HospitalID = session.HospID;
            var isValid = $(this).form("validate");
            return isValid;
        },
        // queryParams: {
        //     ClassName: entityClass
        // },
        success: function(data) {
            if (data.indexOf("键不唯一") === -1) {
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
            } else {
                $.messager.alert("提示", "代码重复!", "error")
                dataForm.form("clear");
                dataBox.treegrid("reload");
                return;
            }
        }
    });

    if (dataDialog) {
        dataDialog.dialog({
            buttons: [{
                text: "保存",
                iconCls: "icon-w-save",
                handler: function() {
                    dataForm.submit();
                }
            }, {
                text: "取消",
                iconCls: "icon-w-cancel",
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
                    iconCls: "icon-w-add"
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
                        iconCls: "icon-w-edit"
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


});

function initialQuery() {
    $("#MainItem").combobox("reload");
}