$(document).ready(function () {
    var dataBox = $("#dataBox"),
        dataForm = $("#dataForm"),
        dataDialog = $("#dataDialog");
    var selectDataBox,
        dataList = [];
    dataBox.treegrid({
        title: "手术包",
        idField: "RowId",
        treeField: "Description",
        columns: [
            [{
                    field: "Description",
                    title: "描述",
                    width: 160
                },
                {
                    field: "Code",
                    title: "代码",
                    width: 60
                },
                {
                    field: "MainKitsDesc",
                    title: "主手术包",
                    width: 60
                },
                {
                    field: "ActiveDesc",
                    title: "激活",
                    width: 50
                }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindSurgicalKits",
            ArgCnt: 0
        },
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        pageSize: 200,
        pageList: [10, 15, 20, 50, 100, 200],
        onSelect: function (index, row) {
            selectDataBox = $(this).treegrid("getSelected");
            if (selectDataBox) {
                $("#surKitMaterialBox").datagrid({
                    queryParams: {
                        ClassName: ANCLS.BLL.CodeQueries,
                        QueryName: "FindSurKitMaterial",
                        Arg1: selectDataBox.RowId,
                        ArgCnt: 1
                    }
                });
            }
        }
    });

    //手术物品Box
    $("#surgicalMaterialsBox").datagrid({
        fit: true,
        rownumbers: true,
        toolbar: "#surgicalMaterialsTools",
        title: "手术物品列表",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindSurgicalMaterials",
            ArgCnt: 0
        },
        columns: [
            [{
                    field: "RowId",
                    title: "顺序号",
                    width: 50,
                    hidden: true
                },
                {
                    field: "Description",
                    title: "手术物品",
                    width: 120
                }
            ]
        ]
    })
    //选择手术物品Box
    $("#selectSurMaterialsBox").datagrid({
        fit: true,
        singleSelect: true,
        rownumbers: true,
        headerCls: 'panel-header-gray',
        title: "手术包手术物品列表",
        columns: [
            [{
                    field: "RowId",
                    title: "顺序号",
                    width: 50,
                    hidden: true
                },
                {
                    field: "Description",
                    title: "手术物品",
                    width: 120
                }
            ]
        ]
    })

    //手术物品默认Box
    $("#surKitMaterialBox").datagrid({
        fit: true,
        title: "手术包-手术物品",
        toolbar: "#surKitMaterialTools",
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [10, 15, 20, 50, 100, 200],
        url: ANCSP.DataQuery,
        columns: [
            [{
                    field: "RowId",
                    title: "ID",
                    width: 50,
                    hidden: true
                },
                {
                    field: "SurgicalMaterialsDesc",
                    title: "手术物品",
                    width: 100
                },
                {
                    field: "DefaultQty",
                    title: "默认数量",
                    width: 100,
                    editor: {
                        type: 'numberbox'
                    }
                }, {
                    field: "Seq",
                    title: "序号",
                    width: 50
                }
            ]
        ],
        // onClickCell: function(rowIndex, field, value) {
        //     var dataGrid = $(this)
        //     dataGrid.datagrid('beginEdit', rowIndex);
        //     var rowData = dataGrid.datagrid("getRows")[rowIndex];
        //     var ed = dataGrid.datagrid('getEditor', { index: rowIndex, field: "DefaultQty" })
        //     $(ed.target).textbox('textbox').focus();
        //     $(ed.target).textbox('textbox').bind('blur', function() {
        //         dataGrid.datagrid('endEdit', rowIndex);
        //         var surKitMaterialList = [];
        //         var newValue = $(this).val();
        //         if (newValue != value) {
        //             surKitMaterialList.push({
        //                 RowId: rowData.RowId,
        //                 SurgicalMaterialsDesc: rowData.SurgicalMaterialsDesc,
        //                 DefaultQty: newValue,
        //                 ClassName: ANCLS.Code.KitMaterials
        //             })
        //         }
        //         if (surKitMaterialList.length > 0) {
        //             var jsonData = dhccl.formatObjects(surKitMaterialList);
        //             $.ajax({
        //                 url: ANCSP.DataListService,
        //                 data: {
        //                     jsonData: jsonData
        //                 },
        //                 type: "post",
        //                 async: false,
        //                 success: function(data) {
        //                     dhccl.showMessage(data, "保存", null, null, function() {});
        //                 }
        //             });
        //         }
        //     })
        // }

    });

    dataForm.form({
        url: dhccl.csp.dataService,
        onSubmit: function (param) {
            param.ClassName = ANCLS.Code.SurgicalKits;
            var isValid = $(this).form("validate");
            return isValid;
        },
        success: function (data) {
            dhccl.showMessage(data, "保存", null, null, function () {
                dataForm.form("clear");
                dataBox.treegrid("reload");
                $("#MainKits").combobox("reload");
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
                handler: function () {
                    dataForm.submit();
                }
            }, {
                text: "取消",
                iconCls: "icon-cancel",
                handler: function () {
                    dataDialog.dialog("close");
                }
            }],
            onClose: function () {
                dataForm.form("clear");
            },
            onOpen: function () {}
        });
    }

    $("#btnAdd").linkbutton({
        onClick: function () {
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
        onClick: function () {
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
        onClick: function () {
            if (dhccl.hasRowSelected(dataBox, true)) {
                $.messager.confirm("确认", "是否删除该数据记录？", function (result) {
                    if (result) {
                        var selectedRow=dataBox.datagrid("getSelected");
                        var msg = dhccl.removeData("DHCAN.Code.SurgicalKits", selectedRow.RowId);
                        dhccl.showMessage(msg, "删除", null, null, function () {
                            dataForm.form("clear");
                            dataBox.treegrid("reload");
                        })
                    }
                });
            }
        }
    });


    //添加
    $("#btnAppend").linkbutton({
        onClick: function () {
            if (selectDataBox) {
                var selectSurgicalMaterials = $("#surgicalMaterialsBox").datagrid("getSelections");

                if (selectSurgicalMaterials.length > 0) {
                    for (i = 0; i < selectSurgicalMaterials.length; i++) {
                        var RowId = selectSurgicalMaterials[i].RowId;
                        var Desc = selectSurgicalMaterials[i].Description;
                        var kitMaterialRows = $("#surKitMaterialBox").datagrid("getRows");
                        var seq = "10000";
                        if (kitMaterialRows.length > 0) {
                            var lastedKitMaterial = kitMaterialRows[kitMaterialRows.length - 1];
                            seq = lastedKitMaterial.Seq ? ((Number(lastedKitMaterial.Seq) + 1) + "") : "10000"
                        }
                        if (IsAncopc(RowId)) {
                            $.messager.alert("提示", "手术物品'" + RowId + "-" + Desc + "'已添加！", "warning");
                            continue;
                        }
                        var data = {
                            "SurgicalKits": selectDataBox.RowId,
                            "SurgicalMaterials": RowId,
                            "SurgicalMaterialsDesc": Desc,
                            "DefaultQty": 1,
                            "Seq": seq
                        };
                        // dataList.push(data);
                        $("#surKitMaterialBox").datagrid("appendRow", data)
                    }
                    // $("#selectSurMaterialsBox").datagrid({
                    //     data: dataList
                    // });
                    $("#surgicalMaterialsBox").datagrid("unselectAll");
                }
            } else {
                $.messager.alert("提示", "请先选择手术包", "warning");
                return;
            }
        }
    });
    //移除
    $("#btnRemove").linkbutton({
        onClick: function () {
            if (dhccl.hasRowSelected($("#surKitMaterialBox"), true)) {
                $.messager.confirm("确认", "是否删除该数据记录？", function (result) {
                    if (result) {
                        var selectedRow = $("#surKitMaterialBox").datagrid("getSelected");
                        var msg = dhccl.removeData("DHCAN.Code.KitMaterials", selectedRow.RowId);
                        dhccl.showMessage(msg, "删除", null, null, function () {
                            $("#surKitMaterialBox").datagrid("reload");
                        });
                    }
                });

            }
        }

    });
    //上
    $("#btnUp").linkbutton({
        onClick: function () {
            var selectRow = $("#surKitMaterialBox").datagrid("getSelected");
            var index = $("#surKitMaterialBox").datagrid("getRowIndex", selectRow);
            if (index == 0) {
                $.messager.alert("提示", "数据已经是第一行了！", "warning");
                return;
            }
			var rows=$("#surKitMaterialBox").datagrid("getRows");
			var prevRow=rows[index-1];
			var prevSeq=prevRow.Seq;
			var curSeq=selectRow.Seq;
			selectRow.Seq=prevSeq;
			prevRow.Seq=curSeq;
            $("#surKitMaterialBox").datagrid("deleteRow", index);
            $("#surKitMaterialBox").datagrid("insertRow", {
                index: index - 1,
                row: selectRow
            });
			$("#surKitMaterialBox").datagrid("updateRow", {
                index: index,
                row: prevRow
            });
            $("#surKitMaterialBox").datagrid("selectRow", index - 1);

        }
    });
    //下
    $("#btnDown").linkbutton({
        onClick: function () {
            var selectRow = $("#surKitMaterialBox").datagrid("getSelected");
            var totalRows = $("#surKitMaterialBox").datagrid("getRows");
            console.log(totalRows);
            var index = $("#surKitMaterialBox").datagrid("getRowIndex", selectRow);
            if (index == totalRows.length - 1) {
                $.messager.alert("提示", "数据已经是最后一行了！", "warning");
                return;
            }
			var rows=$("#surKitMaterialBox").datagrid("getRows");
			var prevRow=rows[index+1];
			var prevSeq=prevRow.Seq;
			var curSeq=selectRow.Seq;
			selectRow.Seq=prevSeq;
			prevRow.Seq=curSeq;
            $("#surKitMaterialBox").datagrid("deleteRow", index);
            $("#surKitMaterialBox").datagrid("insertRow", {
                index: index + 1,
                row: selectRow
            });
			$("#surKitMaterialBox").datagrid("updateRow", {
                index: index,
                row: prevRow
            });
            $("#surKitMaterialBox").datagrid("selectRow", index + 1);
        }
    })
    $("#btnSave").linkbutton({
        onClick: function () {
            var selectSurMaterialsBoxList = $("#surKitMaterialBox").datagrid("getData");
            var surMaterialsList = [];
            if (!selectDataBox.MainKitsDesc) {
                $.messager.alert("提示", "主手术包不配置手术物品!", "warning");
                return;
            }
            if (selectSurMaterialsBoxList.total > 0) {
                for (var i = 0; i < selectSurMaterialsBoxList.rows.length; i++) {
                    var surMaterials = selectSurMaterialsBoxList.rows[i];
                    surMaterialsList.push({
                        RowId: surMaterials.RowId,
                        SurgicalKits: surMaterials.SurgicalKits,
                        SurgicalMaterials: surMaterials.SurgicalMaterials,
                        DefaultQty: surMaterials.DefaultQty,
                        Seq: surMaterials.Seq,
                        ClassName: ANCLS.Code.KitMaterials
                    });
                }
                var jsonData = dhccl.formatObjects(surMaterialsList);
                $.ajax({
                    url: ANCSP.DataListService,
                    data: {
                        jsonData: jsonData
                    },
                    type: "post",
                    async: false,
                    success: function (data) {
                        dhccl.showMessage(data, "保存", null, null, function () {});
                        $("#surKitMaterialBox").datagrid("reload");
                        //$("#selectSurMaterialsBox").datagrid("clear");
                        //$("#selectSurMaterialsBox").rows.clear();
                    }

                })

            } else {
                $.messager.alert("提示", "请添加手术包的手术物品！", "warning")
            }
        }
    });
    //手术包
    $("#MainKits").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function (param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalKits";
            param.Arg1 = "Y";
            param.ArgCnt = 1;
        },
        mode: "remote"
    });

    $("#surKitMaterialBox").datagrid("enableCellEditing");

})

//判断是否已选择的手术物品
function IsAncopc(RowId) {
    var selectSurMaterials = $("#surKitMaterialBox").datagrid("getData")
    for (var i = 0; i < selectSurMaterials.rows.length; i++) {
        var surMeterials = selectSurMaterials.rows[i].SurgicalMaterials;
        if (surMeterials == RowId) {
            return true;
        }
    }
    return false;
}