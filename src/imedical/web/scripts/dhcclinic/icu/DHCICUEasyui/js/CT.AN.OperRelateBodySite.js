$(document).ready(function () {
    var dataBox = $("#dataBox"),
        dataForm = $("#dataForm"),
        dataDialog = $("#dataDialog");
    var selectDataBox,
        dataList = [];
    dataBox.datagrid({
        title: "手术名称",
        iconCls:"icon-paper",
        idField: "RowId",
        treeField: "Description",
        headerCls:"panel-header-gray",
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperation",
            Arg1: $("#filterDesc").val(),
            ArgCnt: 1
        },
        
        onBeforeLoad: function(param) {
	        param.Arg1 = $("#filterDesc").val();
            param.ArgCnt = 1;
        },
        columns: [
            [{
                    field: "Description",
                    title: "描述",
                    width: 180
                },
                {
                    field: "Code",
                    title: "代码",
                    width: 180
                },
            ]
        ],
        fit: true,
        singleSelect: true,
        rownumbers: true,
        pagination: true,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        pageSize: 200,
        pageList: [10, 15, 20, 50, 100, 200],
        onSelect: function (index, row) {
            selectDataBox = $(this).datagrid("getSelected");
            if (selectDataBox) {
                $("#operBodySiteBox").datagrid({
                    queryParams: {
                        ClassName: ANCLS.BLL.CodeQueries,
                        QueryName: "FindOperBodySite",
                        Arg1: selectDataBox.RowId,
                        ArgCnt: 1
                    }
                });
            }
        }
    });

    //手术物品Box
    $("#bodySiteBox").datagrid({
        fit: true,
        rownumbers: true,
        toolbar: "#bodySiteTools",
        title: "手术部位",
        iconCls:"icon-paper",
        headerCls:"panel-header-gray",
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBodySite",
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
                    title: "手术部位",
                    width: 120
                }
            ]
        ]
    })
    $("#btnQuery").click(function(){
        $("#dataBox").datagrid('reload');
    });

    //手术物品默认Box
    $("#operBodySiteBox").datagrid({
        fit: true,
        title: "手术名称-手术部位",
         iconCls:"icon-paper",
        toolbar: "#operBodySiteTools",
        headerCls:"panel-header-gray",
        singleSelect: true,
        rownumbers: true,
        // pagination: true,
        // pageSize: 200,
        // pageList: [10, 15, 20, 50, 100, 200],
        url: ANCSP.DataQuery,
        columns: [
            [{
                    field: "RowId",
                    title: "ID",
                    width: 50,
                    hidden: true
                },
                {
                    field: "BodySiteDesc",
                    title: "手术部位",
                    width: 120
                }
            ]
        ], 

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
                        var msg="删除成功";
                        if(selectedRow.RowId!="")
                    {    msg = dhccl.removeData(ANCLS.Code.SurgicalKits, selectedRow.RowId);
                      }
                        dhccl.showMessage(msg, "删除", null, null, function () {
                            dataForm.form("clear");
                            dataBox.treegrid("reload");
                        })
                    }
                });
            }
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function () {
            var uuu=$("#filterDesc").val();
            $("#dataBox").treegrid("reload");
        }
    });

    //添加
    $("#btnAppend").linkbutton({
        onClick: function () {
            if (selectDataBox) {
                var selectSurgicalMaterials = $("#bodySiteBox").datagrid("getSelections");

                if (selectSurgicalMaterials.length > 0) {
                    for (i = 0; i < selectSurgicalMaterials.length; i++) {
                        var RowId = selectSurgicalMaterials[i].RowId;
                        var Desc = selectSurgicalMaterials[i].Description;
                        var kitMaterialRows = $("#operBodySiteBox").datagrid("getRows");
                        var seq = "10000";
                        if (kitMaterialRows.length > 0) {
                            var lastedKitMaterial = kitMaterialRows[kitMaterialRows.length - 1];
                            seq = lastedKitMaterial.Seq ? ((Number(lastedKitMaterial.Seq) + 1) + "") : "10000"
                        }
                        if (IsAncopc(RowId)) {
                            $.messager.alert("提示", "手术部位'" + RowId + "-" + Desc + "'已添加！", "warning");
                            continue;
                        }
                        var data = {
                            "Operation": selectDataBox.RowId,
                            "BodySite": RowId,
                            "BodySiteDesc": Desc
                        };
                        $("#operBodySiteBox").datagrid("appendRow", data)
                    }
                    $("#bodySiteBox").datagrid("unselectAll");
                }
            } else {
                $.messager.alert("提示", "请先选择手术名称", "warning");
                return;
            }
        }
    });
    //移除
    $("#btnRemove").linkbutton({
        onClick: function () {
            if (dhccl.hasRowSelected($("#operBodySiteBox"), true)) {
                $.messager.confirm("确认", "是否删除该数据记录？", function (result) {
                    if (result) {
                        var selectedRow = $("#operBodySiteBox").datagrid("getSelected");
                        var msg="S^";
                        if(selectedRow.RowId!=undefined)
                        {
                             msg = dhccl.removeData(ANCLS.Code.OperLinkBodySite, selectedRow.RowId);
                             //return;
                        }
                        dhccl.showMessage(msg, "删除", null, null, function () {
                            //$("#operBodySiteBox").datagrid("reload");
                            var row = $("#operBodySiteBox"). datagrid( "getSelected");
                            if (row) {
                                       var rowIndex = $( '#operBodySiteBox').datagrid("getRowIndex", row);
                                       $( "#operBodySiteBox") .datagrid( "deleteRow",rowIndex);
                                       return;
                                 }
                        });
                    }
                });

            }
        }

    });
   
    $("#btnSave").linkbutton({
        onClick: function () {
            var selectOperBodySiteBoxList = $("#operBodySiteBox").datagrid("getData");
            var surMaterialsList = [];
            if (!selectDataBox) {
                $.messager.alert("提示", "请选择一个手术名称", "warning");
                return;
            }
            if (selectOperBodySiteBoxList.total > 0) {
                for (var i = 0; i < selectOperBodySiteBoxList.rows.length; i++) {
                    var operBodySite = selectOperBodySiteBoxList.rows[i];
                    surMaterialsList.push({
                        RowId: operBodySite.RowId,
                        Operation: operBodySite.Operation,
                        BodySite: operBodySite.BodySite,
                        Active: "Y",
                        //Seq: operBodySite.Seq,
                        ClassName: ANCLS.Code.OperLinkBodySite
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
                        $("#operBodySiteBox").datagrid("reload");
                    }

                })

            } else {
                $.messager.alert("提示", "请添加手术部位！", "warning")
            }
        }
    });


    $("#operBodySiteBox").datagrid("enableCellEditing");

})

//判断是否已选择的手术物品
function IsAncopc(RowId) {
    var selectSurMaterials = $("#operBodySiteBox").datagrid("getData")
    for (var i = 0; i < selectSurMaterials.rows.length; i++) {
        var surMeterials = selectSurMaterials.rows[i].SurgicalMaterial;
        if (surMeterials == RowId) {
            return true;
        }
    }
    return false;
}