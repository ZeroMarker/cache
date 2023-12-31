var operCount={
    schedule:null,
    contextMenu:null,
    contextMenuD:null,
    clickColumn:null
};
function initPage(){
    operDataManager.initFormData(loadApplicationData);
    initSurgicalInventory();
    initOperDressing();
    initDefaultValue();
    initOperationDesc();
    $("#btnSave").linkbutton({
        onClick: function() {
            SaveInventory("operDressingBox");
            SaveInventory("dataBox");
            operDataManager.saveOperDatas();
        }
    });
    $("#btnPrint").linkbutton({
        onClick: printOperCount
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });

    $("#btnFinishOper").linkbutton({
        onClick:finishOperation
    });

    $("#specialConditionOptions").combobox({
        onSelect:function(record){
            var specialCondition=$("#SpecialCondition").val();
            if(record && record.text && record.text!==""){
                if(specialCondition && specialCondition!==""){
                    specialCondition+="\r\n"+record.text;
                }else{
                    specialCondition=record.text;
                }
                $("#SpecialCondition").val(specialCondition)
                $(this).combobox("clear");
            }
        }
    });

}

function finishOperation(){
    var opsId=session.OPSID;
    $.messager.confirm("提示","注意：该操作将手术的状态置为<span style='color:red'>术毕</span>，请确保该手术是<span style='color:red'>局麻手术</span>，手术开始时间和结束时间都已保存，且没有<span style='color:red'>麻醉医生</span>参与。",function(r){
        if(r){
            var ret=dhccl.runServerMethod(ANCLS.BLL.OperArrange,"ChangeFinishStatus",opsId)
            if(ret.success){
                $.messager.alert("提示","更新手术状态成功！","info");
            }else{
                $.messager.alert("提示","更新手术状态失败！原因："+ret.result,"error");
            }
        }
        
    });
}

function initOperCountBox(){

}

function initOperDressing(){
    $("#operDressingBox").datagrid({
        fit: true,
        title:"敷料清点记录",
        // height:200,
        // width:900,
        headerCls:"panel-header-gray",
        singleSelect: false,
        // rownumbers: true,
        pagination: false,
        // pageList: [10, 20, 30, 40, 50, 100, 200],
        // pageSize: 200,
        url: ANCSP.DataQuery,
        toolbar:"#operDressingTools",
        // toolbar: "#dataTools",
        columns: [
            [{
                    field: "CheckStatus",
                    title: "选择",
                    width: 40,
                    checkbox: true
                },
                {
                    field: "RowId",
                    title: "RowId",
                    width: 100,
                    hidden: true
                },
                {
                    field: "SurgicalMaterials",
                    title: "手术物品",
                    width: 80,
                    hidden: true
                },
                {
                    field: "SurgicalMaterialsDesc",
                    title: "手术物品",
                    width: 120,
                    hidden: true
                },
                {
                    field: "MaterialNote",
                    title: "敷料名称",
                    width: 100
                },
                {
                    field: "PreopCount",
                    title: "术前清点",
                    width: 80,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "OperAddCount",
                    title: "术中加数",
                    width: 100,
                    hidden: true
                },
                {
                    field: "AddCountDesc",
                    title: "术中加数",
                    width: 160,
                    editor: {
                        type: 'validatebox'
                    }
                },
                {
                    field: "PreCloseCount",
                    title: "关腔前清点",
                    width: 90,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "PostCloseCount",
                    title: "关腔后清点",
                    width: 90,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "PostSewCount",
                    title: "缝皮后清点",
                    width: 90,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "InventoryType",
                    title: "物品类型",
                    width: 100,
                    hidden: true
                },
                {
                    field: "BarCode",
                    title: "无菌包条号",
                    width: 100,
                    hidden: true
                }
                // {
                //     field: "Operators",
                //     title: "操作",
                //     width: 80,
                //     formatter: function (value, row, index) {
                //         var html = "<a href='#'  class='hisui-linkbutton inventoryrecord-btn' data-options='plain:true' iconcls='icon-remove' data-rowid='" + (row.RowId?row.RowId:"") + "' data-index='"+index+"'></a>";
                //         return html;
                //     }
                // }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindDressingInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        rowStyler: function(index, row) {
            var preopCount=isNaN(row.PreopCount)?0:Number(row.PreopCount),
                operAddCount=isNaN(row.OperAddCount)?0:Number(row.OperAddCount),
                preCloseCount=isNaN(row.PreCloseCount)?0:Number(row.PreCloseCount),
                postCloseCount=isNaN(row.PostCloseCount)?0:Number(row.PostCloseCount),
                postSewCount=isNaN(row.PostSewCount)?0:Number(row.PostSewCount),
                preopTotalCount=preopCount+operAddCount;
            if (preopTotalCount!==preCloseCount || preopTotalCount!==postCloseCount || preopTotalCount!==postSewCount){
                return "background-color:yellow;";
            }
            
        },
        onClickCell: function(index, field, value) {
            if (index < 0) return;
            operCount.clickColumn=field;
            var countDatas = $("#operDressingBox").datagrid("getRows");
            var validField = "AddCountDesc",
                confirmMsg = null;
            switch (field) {
                // case "PreopCount":
                //     editValidFields = ["PreCloseCount", "PostCloseCount", "PostSewCount"];
                //     break;
                // case "AddCountDesc":
                //     editValidFields = ["PreCloseCount", "PostCloseCount", "PostSewCount"];
                //     break;
                case "PreCloseCount":
                    editValidFields = ["PostCloseCount", "PostSewCount"];
                    confirmMsg="是否生成关前清点数据？";
                    break;
                case "PostCloseCount":
                    validField = "PreCloseCount";
                    editValidFields = ["PostSewCount"];
                    confirmMsg="是否生成关后清点数据？";
                    break;
                case "PostSewCount":
                    validField = "PostCloseCount"
                    confirmMsg="是否生成关后清点数据？";
                    break;
            }
            if (field === "PreCloseCount" || field === "PostCloseCount" || field === "PostSewCount") {
                for (var i = 0; i < countDatas.length; i++) {
                    var countData = countDatas[i];
                    var countNum = parseFloat(countData[field]);
                    var preopNum = parseFloat(countData.PreopCount);
                    var addNum = parseFloat(countData.OperAddCount);
                    var equiv=(countNum===((!isNaN(preopNum) ? preopNum : 0) + (!isNaN(addNum) ? addNum : 0)));
                    if (!isNaN(countNum) && equiv){
                        continue;
                    }
                    //if (!isNaN(countNum) && countNum >= 0) continue; // 如果该单元格已有清点数据，则不进行自动计算。
                    
                    countData[field] = (!isNaN(preopNum) ? preopNum : 0) + (!isNaN(addNum) ? addNum : 0);
                    if(countData[field]===0) countData[field]="";
                    $("#operDressingBox").datagrid("updateRow", {
                        index: i,
                        row: countData
                    });
                }
                //SaveInventory("operDressingBox");
            }
        },
        onBeginEdit: function(rowIndex, rowData) {
            var editor = $(this).datagrid("getEditor", {
                index: rowIndex,
                field: "AddCountDesc"
            });
            if (editor && editor.target) {
                $(editor.target).change(function(e) {
                    var addCountStr = $(this).val();
                    var operAddCount = 0;
                    if (addCountStr) {
                        var addCountArr = addCountStr.split("+");
                        for (var index = 0; index < addCountArr.length; index++) {
                            var element = Number(addCountArr[index]);
                            if (!isNaN(element)) {
                                operAddCount += element;
                            }
                        }
                        rowData.OperAddCount = operAddCount;
                    }
                });
                // $(editor.target).numberbox({
                //     onChange:function(newValue,oldValue){
                //         var operAddCount=Number(rowData.OperAddCount);
                //         if(isNaN(operAddCount)){
                //             operAddCount=0;
                //         }
                //         var addCount=Number(newValue);
                //         if(!isNaN(addCount)){
                //             operAddCount+=addCount;
                //             rowData.OperAddCount=operAddCount;

                //             $(this).numberbox("setValue","");
                //         }
                //     }
                // });
            }
        },
        onAfterEdit: function(rowIndex, rowData, changes) {
            //SaveInventory("operDressingBox");
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                initInventoryDelBtns();
            }else{
                var startData=[{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "大纱",
                        MaterialNote: "大纱",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                        
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "小纱",
                        MaterialNote: "小纱",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "棉球",
                        MaterialNote: "棉球",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "脑棉",
                        MaterialNote: "脑棉",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "微创小纱",
                        MaterialNote: "微创小纱",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "缝针",
                        MaterialNote: "缝针",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "硅引固定片",
                        MaterialNote: "硅引固定片",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "吊带",
                        MaterialNote: "吊带",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "阻断带",
                        MaterialNote: "阻断带",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "花生米",
                        MaterialNote: "花生米",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    },{
                        SurgicalMaterials: "",
                        SurgicalMaterialsDesc: "吻合器引导针",
                        MaterialNote: "吻合器引导针",
                        PreopCount: "",
                        AddCountDesc: "",
                        PreCloseCount: "",
                        PostCloseCount: "",
                        PostSewCount: "",
                        BarCode: "",
                        InventoryType:"D"
                    }];
                for(var i=0;i<startData.length;i++){
                    var curData=startData[i];
                    $("#operDressingBox").datagrid("appendRow",curData);
                }
                
            }
        },
        onRowContextMenu: function(e, rowIndex, rowData){
            
            e.preventDefault();
            if(operCount.clickColumn!=="PreCloseCount" && operCount.clickColumn!=="PostCloseCount" && operCount.clickColumn!=="PostSewCount") return;
            if(!operCount.contextMenuD){
                createContextMenuD("operDressingBox",rowIndex,rowData);
            }
            
            operCount.contextMenuD.menu('show', {
                left: e.pageX,
                top: e.pageY
            });
            var opts = operCount.contextMenuD.menu("options");
            opts.rowIndex = rowIndex;
            opts.rowData = rowData;
        }
    });

    $("#operDressingBox").datagrid("enableCellEditing", function(index, field) {});
}
function createContextMenuD(boxId,rowIndex,rowData){
    var menuId=boxId+"Menu";
    operCount.contextMenuD = $("<div id='"+menuId+"'></div>").appendTo("body");
    operCount.contextMenuD.menu({});
    operCount.contextMenuD.menu("appendItem", {
        text: "清空本列清点数据",
        name: "ClearColumnData",
        onclick: function(){
            clearColumnData(boxId,rowIndex,rowData);
        }
    });
}

function createContextMenu(boxId,rowIndex,rowData){
    var menuId=boxId+"Menu";
    operCount.contextMenu = $("<div id='"+menuId+"'></div>").appendTo("body");
    operCount.contextMenu.menu({});
    operCount.contextMenu.menu("appendItem", {
        text: "清空本列清点数据",
        name: "ClearColumnData",
        onclick: function(){
            clearColumnData(boxId,rowIndex,rowData);
        }
    });
}

function clearColumnData(boxId,rowIndex,rowData){
    var rows=$("#"+boxId).datagrid("getRows");
    if(rows && rows.length>0){
        for(var i=0;i<rows.length;i++){
            var row=rows[i];
            if(row.hasOwnProperty(operCount.clickColumn)){
                row[operCount.clickColumn]="";
                $("#"+boxId).datagrid("refreshRow",i);
            }
        }
    }
}

function initSurgicalInventory() {
    //保存清点记录
    $("#btnSaveInventory").linkbutton({
        onClick: SaveInventory
    });

    $("#btnDelInventory,#btnDelInventory2").linkbutton({
        onClick: function() {
            var linkBoxSelector="#"+$(this).attr("data-linkbox");
            if (dhccl.hasRowSelected($(linkBoxSelector), true)) {
                var selectedRows = $(linkBoxSelector).datagrid("getSelections");
                if (selectedRows && selectedRows.length) {
                    $.messager.confirm("确认", "您确认要删除选中纪录？", function(r) {
                        if (r) {
                            var dataList = [],
                                dataIndexList = [],
                                delList = [];
                            for (var i = 0; i < selectedRows.length; i++) {
                                var selectedRow = selectedRows[i];
                                if (selectedRow.RowId && selectedRow.RowId !== "") {
                                    dataList.push({
                                        ClassName: ANCLS.Model.SurInventory,
                                        RowId: selectedRow.RowId
                                    });
                                }

                                var selectedRowIndex = $(linkBoxSelector).datagrid("getRowIndex", selectedRow);
                                dataIndexList.push(selectedRowIndex);
                                delList.push(selectedRow);
                            }
                            if (dataList.length > 0) {
                                var dataListStr = dhccl.formatObjects(dataList);
                                var ret = dhccl.runServerMethod(CLCLS.BLL.DataService, "DelDatas", dataListStr);
                                if (ret.success) {
                                    $("#dataForm").form("clear");
                                    // $("#dataBox").datagrid("reload");
                                } else {
                                    $.messager.alert("提示", "删除清点纪录失败，原因：" + ret.result, "error");
                                }
                            }
                            if (delList.length > 0) {
                                for (var i = 0; i < delList.length; i++) {
                                    var rowIndex = $(linkBoxSelector).datagrid("getRowIndex", delList[i]);
                                    $(linkBoxSelector).datagrid("deleteRow", rowIndex);
                                }
                            }
                            $(linkBoxSelector).datagrid("clearChecked");
                            // $("#dataBox").datagrid("deleteRow", selectRowIndex);
                            // var msg = dhccl.removeData(ANCLS.Model.SurInventory, selectRow.RowId)
                            // dhccl.showMessage(msg, "删除", null, null, function () {
                            //     $("#dataForm").form("clear");
                            //     $("#dataBox").datagrid("reload");
                            // });
                        }
                    });

                }
                // var selectRow = $("#dataBox").datagrid("getSelected");
                // var selectRowIndex = $("#dataBox").datagrid("getRowIndex", selectRow);
                // if ((selectRow.RowId) && (selectRow.RowId != "")) {
                //     $.messager.confirm("确认", "您确认要删除" + selectRow.SurgicalMaterialsDesc + "?", function (r) {
                //         if (r) {
                //             $("#dataBox").datagrid("deleteRow", selectRowIndex);
                //             var msg = dhccl.removeData(ANCLS.Model.SurInventory, selectRow.RowId)
                //             dhccl.showMessage(msg, "删除", null, null, function () {
                //                 $("#dataForm").form("clear");
                //                 $("#dataBox").datagrid("reload");
                //             });
                //         }
                //     });
                // }else{
                //     var selectRow = $("#dataBox").datagrid("getSelected");
                //     var selectRowIndex = $("#dataBox").datagrid("getRowIndex", selectRow);
                //     $.messager.confirm("确认", "您确认要删除" + selectRow.SurgicalMaterialsDesc + "?", function (r) {
                //         if (r) {
                //             $("#dataBox").datagrid("deleteRow",selectRowIndex);
                //         }
                //     });

                // }
            }
        }
    });

    //同步消毒包
    $("#btnAddMaterials").linkbutton({
        onClick: function() {
            var surMaterialsId = $("#SurgicalMaterials").val();
        }
    });
    //手术包
    $("#SurgicalKits").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalKits";
            param.Arg1 = "N";
            param.Arg2 = "Y";
            param.Arg3=param.q?param.q:"";
            param.ArgCnt = 3;
        },
        mode: "remote",
        onSelect: function(record) {
            $("#surInventoryDialog").dialog("open");
            $("#surInventoryBox").datagrid("reload");
            var surKitDesc = $("#SurgicalKits").combobox("getText");
            $("#surInventoryDialog").dialog("setTitle", "器械套餐-" + surKitDesc);
            return;
            $.messager.confirm("确认", "是否添加该手术包清点物品？", function(r) {
                if (r) {
                    var dataList = dhccl.getDatas(ANCSP.DataQuery, {
                        ClassName: ANCLS.BLL.CodeQueries,
                        QueryName: "FindSurKitMaterial",
                        Arg1: record.RowId,
                        ArgCnt: 1
                    }, "json");
                    if (dataList.length > 0) {
                        for (var i = 0; i < dataList.length; i++) {
                            $("#dataBox").datagrid("appendRow", {
                                SurgicalMaterials: dataList[i].SurgicalMaterials,
                                SurgicalMaterialsDesc: dataList[i].SurgicalMaterialsDesc,
                                MaterialNote: dataList[i].SurgicalMaterialsDesc,
                                PreopCount: (dataList[i].DefaultQty) ? dataList[i].DefaultQty : 1,
                                BarCode: ""
                            });
                        }
                    }
                }
            });
        }
    });
    //手术物品
    $("#SurgicalMaterials,#SurgicalMaterials2").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalMaterials";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        mode: "remote",
        onSelect: function(record) {

            addInventory(record);
            
        }
    });

    $("#btnAddInventory,#btnAddInventory2").linkbutton({
        onClick: function() {
            var linkItemSelector="#"+$(this).attr("data-linkitem");
            var linkBoxSelector="#"+$(this).attr("data-linkbox");
            var ivType=$(this).attr("data-ivtype");     // 物品类型：器械，敷料
            var matDesc = $(linkItemSelector).combobox("getText");
            if (matDesc === "") {
                $.messager.alert("提示", "手术物品名称不能为空。", "warning");
                return;
            }
            var record = {
                RowId: "",
                Description: $(linkItemSelector).combobox("getText")
            };
            addInventory(record,linkBoxSelector,linkItemSelector,ivType);
            // initInventoryDelBtns();
        }
    });

    //手术清点列表
    $("#dataBox").datagrid({
        fit: true,
        title:"手术器械清点记录",
        headerCls:"panel-header-gray",
        // height:600,
        // width:900,
        singleSelect: false,
        // rownumbers: true,
        pagination: false,
        // pageList: [10, 20, 30, 40, 50, 100, 200],
        // pageSize: 200,
        url: ANCSP.DataQuery,
        toolbar: "#dataTools",
        columns: [
            [{
                    field: "CheckStatus",
                    title: "选择",
                    width: 40,
                    checkbox: true
                },
                {
                    field: "RowId",
                    title: "RowId",
                    width: 100,
                    hidden: true
                },
                {
                    field: "SurgicalMaterial",
                    title: "手术物品",
                    width: 100,
                    hidden: true
                },
                {
                    field: "SurgicalMaterialDesc",
                    title: "手术物品",
                    width: 120,
                    hidden: true
                },
                {
                    field: "MaterialNote",
                    title: "手术物品",
                    width: 80
                },
                {
                    field: "PreopCount",
                    title: "术前清点",
                    width: 80,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "OperAddCount",
                    title: "术中加数",
                    width: 100,
                    hidden: true
                },
                {
                    field: "AddCountDesc",
                    title: "术中加数",
                    width: 160,
                    editor: {
                        type: 'validatebox'
                    }
                },
                {
                    field: "PreCloseCount",
                    title: "关腔前清点",
                    width: 90,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "PostCloseCount",
                    title: "关腔后清点",
                    width: 90,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "PostSewCount",
                    title: "缝皮后清点",
                    width: 90,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "BarCode",
                    title: "无菌包条号",
                    width: 100,
                    hidden: true
                }
                // {
                //     field: "Operators",
                //     title: "操作",
                //     width: 80,
                //     formatter: function (value, row, index) {
                //         var html = "<a href='#'  class='hisui-linkbutton inventoryrecord-btn' data-options='plain:true' iconcls='icon-remove' data-rowid='" + (row.RowId?row.RowId:"") + "' data-index='"+index+"'></a>";
                //         return html;
                //     }
                // }
            ]
        ],
        rowStyler: function(index, row) {
            var preopCount=isNaN(row.PreopCount)?0:Number(row.PreopCount),
                operAddCount=isNaN(row.OperAddCount)?0:Number(row.OperAddCount),
                preCloseCount=isNaN(row.PreCloseCount)?0:Number(row.PreCloseCount),
                postCloseCount=isNaN(row.PostCloseCount)?0:Number(row.PostCloseCount),
                postSewCount=isNaN(row.PostSewCount)?0:Number(row.PostSewCount),
                preopTotalCount=preopCount+operAddCount;
            if (preopTotalCount!==preCloseCount || preopTotalCount!==postCloseCount || preopTotalCount!==postSewCount){
                return "background-color:yellow;";
            }
            
        },
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindSurInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        onClickCell: function(index, field, value) {
            // if ((editIndex == undefined) && (field != "operators")) {
            //     if (field == "PreopCount" || field == "OperAddCount") {
            //         $('#dataBox').datagrid('beginEdit', index);
            //         var ed = $("#dataBox").datagrid('getEditors', index, field);
            //         $(ed.target).focus();
            //         editIndex = index;
            //     }
            // } else if ((editIndex != undefined) && (field != "operators")) {
            //     //$('#dataBox').datagrid('endEdit', editIndex);
            //     editIndex = undefined;
            // }
            if (index < 0) return;
            operCount.clickColumn=field;
            var countDatas = $("#dataBox").datagrid("getRows");
            var validField = "AddCountDesc",
                editValidFields = null;
            var confirmMessage="";
            switch (field) {
                case "PreopCount":
                    editValidFields = ["PreCloseCount", "PostCloseCount", "PostSewCount"];
                    break;
                case "AddCountDesc":
                    editValidFields = ["PreCloseCount", "PostCloseCount", "PostSewCount"];
                    confirmMessage="是否生成术中加数？(系统将把术中清点数为空的行自动计算为0)";
                    break;
                case "PreCloseCount":
                    editValidFields = ["PostCloseCount", "PostSewCount"];
                    confirmMessage="是否生成关腔前清点数据，系统将根据术前清点数和术中加数计算？(如果还未核对术前清点数和术中加数，请核对后确认。)";
                    break;
                case "PostCloseCount":
                    validField = "PreCloseCount";
                    editValidFields = ["PostSewCount"];
                    confirmMessage="是否生成关腔前清点数据，系统将根据关腔前清点数计算？(如果还未核对关腔前清点数，请核对后确认。)";
                    break;
                case "PostSewCount":
                    validField = "PostCloseCount"
                    confirmMessage="是否生成关腔前清点数据，系统将根据关腔后清点数计算？(如果还未核对关腔后清点数，请核对后确认。)";
                    break;
            }
            //if(confirmMessage==="") return;
            // if(value!==""){
            //     if (editValidFields && editValidFields.length > 0) {
            //         var validation = checkEditValid(countDatas[index], field, editValidFields);
            //         if (validation.integrity === false) {
            //             $.messager.alert("提示", validation.message, "warning");
            //             $("#dataBox").datagrid("cancelEdit", index);
            //             return;
            //         }
            //     }
            //     return;
            // }
            // $.messager.confirm("提示",confirmMessage,function(r){
            //     if(r){
                    
            //     }
            // });
            if (field === "PreCloseCount" || field === "PostCloseCount" || field === "PostSewCount") {
                // var validation = checkColDataIntegrity(validField);
                // if (validation.integrity === false) {
                //     $.messager.alert("提示", validation.message, "warning");
                //     $("#dataBox").datagrid("cancelEdit", index);
                //     return;
                // }
                for (var i = 0; i < countDatas.length; i++) {
                    var countData = countDatas[i];
                    var countNum = parseFloat(countData[field]);
                    //if (!isNaN(countNum) && countNum >= 0) continue; // 如果该单元格已有清点数据，则不进行自动计算。
                    var preopNum = parseFloat(countData.PreopCount);
                    var addNum = parseFloat(countData.OperAddCount);
                    var equiv=(countNum===((!isNaN(preopNum) ? preopNum : 0) + (!isNaN(addNum) ? addNum : 0)));
                    if (!isNaN(countNum) && equiv){
                        continue;
                    }
                    countData[field] = (!isNaN(preopNum) ? preopNum : 0) + (!isNaN(addNum) ? addNum : 0);
                    $("#dataBox").datagrid("updateRow", {
                        index: i,
                        row: countData
                    });
                }
                //SaveInventory();
            }// else if (field === "AddCountDesc") {
            //     for (var i = 0; i < countDatas.length; i++) {
            //         var countData = countDatas[i];
            //         var countNum = countData[field];
            //         if (countNum && countNum !== "") continue; // 如果该单元格已有清点数据，则不进行自动计算。
            //         countData[field] = "";
            //         countData["OperAddCount"] = 0;
            //         $("#dataBox").datagrid("updateRow", {
            //             index: i,
            //             row: countData
            //         });
            //     }
            //     SaveInventory();
            // }
            // if (editValidFields && editValidFields.length > 0) {
            //     var validation = checkEditValid(countDatas[index], field, editValidFields);
            //     if (validation.integrity === false) {
            //         $.messager.alert("提示", validation.message, "warning");
            //         $("#dataBox").datagrid("cancelEdit", index);
            //         return;
            //     }
            // }
            
        },
        onBeginEdit: function(rowIndex, rowData) {
            var editor = $(this).datagrid("getEditor", {
                index: rowIndex,
                field: "AddCountDesc"
            });
            if (editor && editor.target) {
                $(editor.target).change(function(e) {
                    var addCountStr = $(this).val();
                    var operAddCount = 0;
                    if (addCountStr) {
                        var addCountArr = addCountStr.split("+");
                        for (var index = 0; index < addCountArr.length; index++) {
                            var element = Number(addCountArr[index]);
                            if (!isNaN(element)) {
                                operAddCount += element;
                            }
                        }
                        rowData.OperAddCount = operAddCount;
                    }
                });
                // $(editor.target).numberbox({
                //     onChange:function(newValue,oldValue){
                //         var operAddCount=Number(rowData.OperAddCount);
                //         if(isNaN(operAddCount)){
                //             operAddCount=0;
                //         }
                //         var addCount=Number(newValue);
                //         if(!isNaN(addCount)){
                //             operAddCount+=addCount;
                //             rowData.OperAddCount=operAddCount;

                //             $(this).numberbox("setValue","");
                //         }
                //     }
                // });
            }
        },
        onAfterEdit: function(rowIndex, rowData, changes) {
            //SaveInventory();
        },
        onLoadSuccess: function(data) {
            $("#dataBox").datagrid("clearChecked");
            if (data && data.rows && data.rows.length > 0) {
                
                initInventoryDelBtns();
            }
        },
        onRowContextMenu: function(e, rowIndex, rowData){
            
            e.preventDefault();
            if(operCount.clickColumn!=="PreCloseCount" && operCount.clickColumn!=="PostCloseCount" && operCount.clickColumn!=="PostSewCount") return;
            if (!operCount.contextMenu) {
                createContextMenu("dataBox",rowIndex,rowData);
            }
            operCount.contextMenu.menu('show', {
                left: e.pageX,
                top: e.pageY
            });
            var opts = operCount.contextMenu.menu("options");
            opts.rowIndex = rowIndex;
            opts.rowData = rowData;
        }
    });

    $("#dataBox").datagrid("enableCellEditing", function(index, field) {});

    $("#surInventoryBox").datagrid({
        fit: true,
        singleSelect: false,
        checkOnSelect:false,
        selectOnCheck:false,
        rownumbers: true,
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [
            [{
                    field: "CheckStatus",
                    title: "选择",
                    width: 60,
                    checkbox: true
                },
                {
                    field: "SurgicalMaterial",
                    title: "SurgicalMaterial",
                    width: 100,
                    hidden: true
                },
                {
                    field: "SurgicalMaterialDesc",
                    title: "项目名称",
                    width: 120
                },
                {
                    field: "DefaultQty",
                    title: "数量",
                    width: 80
                }
            ]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurKitMaterial";
            var surKitId = $("#SurgicalKits").combobox("getValue");
            param.Arg1 = surKitId;
            param.ArgCnt = 1;
        },
        onLoadSuccess:function(data){
            $(this).datagrid("checkAll");
        }
    });

    $("#btnConfirmInventory").linkbutton({
        onClick: function() {
            var dataList = $("#surInventoryBox").datagrid("getChecked");
            if (dataList && dataList.length > 0) {
                var dataRows=$("#dataBox").datagrid("getRows");
				if((dataList.length+dataRows.length)>operCountConfig.inventoryMaxCount){
					$.messager.alert("提示","清点列表已有"+dataRows.length+"项，当前器械包已选择"+dataList.length+"项，加起来超过"+operCountConfig.inventoryMaxCount+"。打印时无法打印出超出的部分。","warning");
					return;
				}
                var existItems=false,existRow=null,existRowInd=-1;
                for (var i = 0; i < dataList.length; i++) {
                    var kitItem=dataList[i];
                    var ret=existsSurgicalItem("dataBox",kitItem.SurgicalMaterial);
                    if(ret.result){
                        ret.row.AddCountDesc=(ret.row.AddCountDesc?ret.row.AddCountDesc:"")+((ret.row.AddCountDesc && ret.row.AddCountDesc!=="")?"+":"")+kitItem.DefaultQty;
                        ret.row.OperAddCount=calExp(ret.row.AddCountDesc);
                        $("#dataBox").datagrid("refreshRow",ret.index);
                    }
                }
                for (var i = 0; i < dataList.length; i++) {
                    var kitItem=dataList[i];
                    var ret=existsSurgicalItem("dataBox",kitItem.SurgicalMaterial);
                    if(ret.result){
                        continue;
                    }
                    $("#dataBox").datagrid("appendRow", {
                        SurgicalMaterial: dataList[i].SurgicalMaterial,
                        SurgicalMaterialDesc: dataList[i].SurgicalMaterialDesc,
                        MaterialNote: dataList[i].SurgicalMaterialDesc,
                        PreopCount: (dataList[i].DefaultQty) ? dataList[i].DefaultQty : 1,
                        BarCode: ""
                    });
                    
                }
                $("#surInventoryDialog").dialog("close");
                $("#SurgicalKits").combobox("clear");
                initInventoryDelBtns();
                //SaveInventory();
            }
        }
    });

    $("#btnExitInventory").linkbutton({
        onClick: function() {
            //$("#chargeSetBox").datagrid("clear");
            $("#surInventoryDialog").dialog("close");
            $("#SurgicalKits").combobox("clear");

        }
    });

    $("#surInventoryDialog").dialog({
        onClose: function() {
            $("#SurgicalKits").combobox("clear");
        }
    });

    $("#btnConfirmInvtItem").linkbutton({
        onClick: function() {
            var record = {
                RowId: "",
                Description: $("#SIIMaterialNote").val(),
                PreopCount: $("#SIIPreopCount").numberbox("getValue"),
                AddCountDesc: $("#SIIOperAddCount").val(),
                PreCloseCount: $("#SIIPreCloseCount").numberbox("getValue"),
                PostCloseCount: $("#SIIPostCloseCount").numberbox("getValue"),
                PostSewCount: $("#SIIPostSewCount").numberbox("getValue"),
                BarCode: ""
            };
            addInventory(record);
            initInventoryDelBtns();
        }
    });

    $("#btnExitInvtItem").linkbutton({
        onClick: function() {
            //$("#chargeSetBox").datagrid("clear");
            $("#surInvtItemDialog").dialog("close");
            $("#SurgicalMaterials").combobox("clear");

        }
    });

}

function initDefaultValue(){
    // 获取输血数据
    var transBloodList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.AnaData,
        QueryName:"FindBloodDrugDatas",
        Arg1:session.OPSID,
        ArgCnt:1
    },"json");
    if (transBloodList && transBloodList.length>0){
        for(var i=0;i<transBloodList.length;i++){
            var transBlood=transBloodList[i];
            if(transBlood.Description==="自体血"){
                $("#Autoblood").numberbox("setValue",transBlood.SumQty);
            }else if (transBlood.Description==="新鲜冰冻血浆"){
                $("#FreshFrozenPlasma").numberbox("setValue",transBlood.SumQty);
            }else if (transBlood.Description==="普通冰冻血浆"){
                $("#FrozenPlasma").numberbox("setValue",transBlood.SumQty);
            }else if (transBlood.Description==="血小板"){
                $("#BloodPlatelet").numberbox("setValue",transBlood.SumQty);
            }else if (transBlood.Description==="冷沉淀"){
                $("#Cryoprecipitate").numberbox("setValue",transBlood.SumQty);
            }
        }
    }
    if(operCount.schedule){
        if(operCount.schedule.OperStartDT && $("#OperStartDT").datetimebox("getValue")===""){
            $("#OperStartDT").datetimebox("setValue",operCount.schedule.OperStartDT);
        }
        if(operCount.schedule.OperFinishDT && $("#OperFinishDT").datetimebox("getValue")===""){
            $("#OperFinishDT").datetimebox("setValue",operCount.schedule.OperFinishDT);
        }
    }
}

function calExp(exp){
    var expArr=exp.split("+");
    var result=0;
    for(var i=0;i<expArr.length;i++){
        result+=Number(expArr[i]);
    }
    return result;
}

function initInventoryDelBtns() {
    $(".inventoryrecord-btn").linkbutton({
        onClick: function() {
            var rowid = $(this).attr("data-rowid");
            $.messager.confirm("确认", "是否删除该清点记录？", function(result) {
                if (result) {
                    var dataIndex = $(this).attr("data-index");
                    if (rowid && rowid !== "") {
                        var msg = dhccl.removeData(ANCLS.Model.SurInventory, rowid);
                        // dhccl.showMessage(msg, "删除", null, null, function () {
                        //     // $("#dataBox").datagrid("reload");
                        // });
                    } else {


                    }
                    $("#dataBox").datagrid("deleteRow", dataIndex);

                }
            });
        }
    });
}

function addInventory(record,boxSelector,itemSelector,ivType) {
    var curBoxSelector="#dataBox",curItemSelector="#SurgicalMaterials",curIVType="I";
    if(boxSelector){
        curBoxSelector=boxSelector;
    }
    if(itemSelector){
        curItemSelector=itemSelector;
    }
    if(ivType){
        curIVType=ivType;
    }
    var rows=$(curBoxSelector).datagrid("getRows");
    if(rows && rows.length>0){
        for(var i=0;i<rows.length;i++){
            var row=rows[i];
            if ((record.RowId && record.RowId!=="" && row.SurgicalMaterials===record.RowId) || row.SurgicalMaterialsDesc===record.Description){
                $.messager.alert("提示","手术清点列表已存在"+row.SurgicalMaterialsDesc+"。","warning");
                $(curBoxSelector).datagrid("selectRow",i);
                return;
            }
        }
    }
    $.messager.confirm("提示", "是否添加“" + record.Description + "”到清点列表？", function(r) {
        if (r) {
            $(curBoxSelector).datagrid("appendRow", {
                SurgicalMaterials: record.RowId,
                SurgicalMaterialsDesc: record.Description,
                MaterialNote: record.Description,
                PreopCount: (record.PreopCount ? record.PreopCount : 1),
                AddCountDesc: (record.AddCountDesc ? record.AddCountDesc : ""),
                PreCloseCount: (record.PreCloseCount ? record.PreCloseCount : ""),
                PostCloseCount: (record.PostCloseCount ? record.PostCloseCount : ""),
                PostSewCount: (record.PostSewCount ? record.PostSewCount : ""),
                BarCode: "",
                InventoryType:curIVType
            });
            $(curItemSelector).combobox("clear");
            //SaveInventory();
        }
    });
}

function checkColDataIntegrity(colField,boxId) {
    var boxSelector="#dataBox";
    if(boxId && boxId!==""){
        boxSelector="#"+boxSelector;
    }
    var integrity = false;
    var message = "";
    var countDatas = $(boxSelector).datagrid("getRows");
    var colOpts = $(boxSelector).datagrid("getColumnOption", colField);
    if (!colOpts) {
        return integrity;
    }
    integrity = true;
    for (var i = 0; i < countDatas.length; i++) {
        var countData = countDatas[i];
        var countNum = parseFloat(countData[colField]);
        if (isNaN(countNum)) {
            integrity = false;
            message = colOpts.title + "的数据不完整！";
        }
    }
    return { integrity: integrity, message: message };
}

function checkEditValid(countData, colField, editValidFields) {
    var integrity = false;
    var message = "";
    var colOpts = $("#dataBox").datagrid("getColumnOption", colField);
    if (!colOpts) {
        return integrity;
    }
    integrity = true;
    for (var i = 0; i < editValidFields.length; i++) {
        var validField = editValidFields[i];
        var fieldOpts = $("#dataBox").datagrid("getColumnOption", validField);
        if (!fieldOpts) continue;
        var countNum = parseFloat(countData[validField]);
        if (!isNaN(countNum)) {
            integrity = false;
            message = fieldOpts.title + "已存在数据。";
            break;
        }
    }
    return { integrity: integrity, message: message };
}

function SaveInventory(boxId) {
    var boxSelector="#dataBox";
    if(boxId && boxId!==""){
        boxSelector="#"+boxId;
    }
    endEditDataBox($(boxSelector));
    var dataModuleList = $(boxSelector).datagrid("getRows");
    var surgicalInventoryList = [],
        surInventoryDetailList = [],
        inventoryList = [];
    var currentDate = new Date();
    var today = currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
    var currentTime = currentDate.toLocaleTimeString();
    if (session.RecordSheetID) {
        for (var i = 0; i < dataModuleList.length; i++) {
            var countData = dataModuleList[i];
            var preopNum = parseFloat(countData.PreopCount);
            var preCloseNum = parseFloat(countData.PreCloseCount);
            var postCloseNum = parseFloat(countData.PostCloseCount);
            var postSewNum = parseFloat(countData.PostSewCount);
            var addNum = parseFloat(countData.OperAddCount);
            var addNum=calcAddCount(countData.AddCountDesc);
            var surInventory = {};
            surInventory.RowId = countData.RowId;
            surInventory.RecordSheet = session.RecordSheetID;
            surInventory.SurgicalMaterial = countData.SurgicalMaterial;
            surInventory.MaterialNote = countData.MaterialNote;
            surInventory.AddCountDesc = countData.AddCountDesc ? countData.AddCountDesc : "";
            surInventory.InventoryType=countData.InventoryType?countData.InventoryType:"I";
            if (!isNaN(preopNum)) {
                surInventory.PreopCount = preopNum;
            }else{
                surInventory.PreopCount="";
            }
            if (!isNaN(preCloseNum)) {
                surInventory.PreCloseCount = preCloseNum;
            }else{
                surInventory.PreCloseCount="";
            }
            if (!isNaN(postCloseNum)) {
                surInventory.PostCloseCount = postCloseNum;
            }else{
                surInventory.PostCloseCount="";
            }
            if (!isNaN(postSewNum)) {
                surInventory.PostSewCount = postSewNum;
            }else{
                surInventory.PostSewCount="";
            }
            if (!isNaN(addNum)) {
                surInventory.OperAddCount = addNum;
            }else{
                surInventory.OperAddCount=""
            }
            surInventory.BarCode = countData.BarCode ? countData.BarCode : "";
            surInventory.ClassName = ANCLS.Model.SurInventory;
            surInventoryDetailList.push(surInventory);
        }

        var jsonData = dhccl.formatObjects(surInventoryDetailList);
        var data = dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData
        }, function(result) {
            // dhccl.showMessage(result, "保存", null, null, function() {
            //     $("#dataBox").datagrid("reload");
            // });
            $(boxSelector).datagrid("reload");
        });


    }
}

function calcAddCount(addCountDesc){
    var ret=0;
    if(addCountDesc){
        var arr=addCountDesc.split("+");
        for(var i=0;i<arr.length;i++){
            var value=Number(arr[i]);
            if(!isNaN(value)){
                ret+=value;
            }
        }
    }
    return ret;
}

function endEditDataBox(dataBox) {
    var dataRows = dataBox.datagrid("getRows");
    if (dataRows && dataRows.length > 0) {
        for (var i = 0; i < dataRows.length; i++) {
            var rowIndex = dataBox.datagrid("getRowIndex", dataRows[i]);
            dataBox.datagrid("endEdit", rowIndex);
        }
    }
}

//判断是否已添加该手术物品
function IsExist(RowId) {
    var dataBoxList = $("#dataBox").datagrid("getData");
    for (var i = 0; i < dataBoxList.total; i++) {
        var surMeterials = dataBoxList.rows[i].SurgicalMaterials;
        var materialNote = dataBoxList.rows[i].MaterialNote;
        if (surMeterials === RowId || materialNote === RowId) {
            return true;
        }
    }
    return false;
}

/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    operCount.schedule=operApplication;
}

function initOperationDesc(){
    if(operCount.schedule && $("#OperationDesc").val()===""){
        $("#OperationDesc").val(operCount.schedule.OperInfo);
    }
}

function isInvDataIntegrity(){
    
}

function getBloodTransInfo(){
    var ret="";
    var bloodVol=$("#FreshFrozenPlasma").numberbox("getValue");
    if(bloodVol){
        ret+="新鲜冰冻血浆 "+bloodVol+"ml";
    }
    
    bloodVol=$("#IRBC").numberbox("getValue");
    if(bloodVol){
        if(ret!=="") ret+=",";
        ret+="辐照红细胞 "+bloodVol+"U";
    }

    bloodVol=$("#Autoblood").numberbox("getValue");
    if(bloodVol){
        if(ret!=="") ret+=",";
        ret+="贮存式自体输血 "+bloodVol+"ml";
    }

    bloodVol=$("#BloodPlatelet").numberbox("getValue");
    if(bloodVol){
        if(ret!=="") ret+=",";
        ret+="单采血小板 "+bloodVol+"治疗量";
    }

    bloodVol=$("#FrozenPlasma").numberbox("getValue");
    if(bloodVol){
        if(ret!=="") ret+=",";
        ret+="普通冰冻血浆 "+bloodVol+"ml";
    }

    bloodVol=$("#WRBC").numberbox("getValue");
    if(bloodVol){
        if(ret!=="") ret+=",";
        ret+="洗涤红细胞 "+bloodVol+"U";
    }

    bloodVol=$("#SWRBC").numberbox("getValue");
    if(bloodVol){
        if(ret!=="") ret+=",";
        ret+="悬浮去白细胞红细胞 "+bloodVol+"U";
    }

    bloodVol=$("#Cryoprecipitate").numberbox("getValue");
    if(bloodVol){
        if(ret!=="") ret+=",";
        ret+="冷沉淀 "+bloodVol+"U";
    }
    return ret;
}

function printOperCount() {
    var dataIntegrity=operDataManager.isDataIntegrity(".operdata");
    if(dataIntegrity===false){
        $.messager.alert("提示","手术清点数据不完整！","warning");
        //return;
    }
    operDataManager.printCount(session.RecordSheetID,session.ModuleCode,true);
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperCount" + session.OPSID);
	lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printCount;
    if(lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer))
    {
        createPrintOnePage(lodop,operCount.schedule);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        printCount=lodop.PREVIEW();

    }else{
        createPrintOnePage(lodop,operCount.schedule);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        printCount=lodop.PREVIEW();
    }
    if(printCount>0){
        operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID);
    }
}

function createPrintOnePage(lodop,operSchedule) {  
    var prtConfig=sheetPrintConfig,
        logoMargin=prtConfig.logo.margin,
        logoSize=prtConfig.logo.size,
        titleFont=prtConfig.title.font,
        titleSize=prtConfig.title.size,
        titleMargin=prtConfig.title.margin,
        contentSize=prtConfig.content.size,
        contentFont=prtConfig.content.font;
    lodop.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    lodop.SET_PRINT_STYLE("FontSize", contentFont.size);
    lodop.SET_PRINT_STYLE("FontName", contentFont.name);
    lodop.ADD_PRINT_IMAGE(logoMargin.top,logoMargin.left,logoSize.width,logoSize.height,"<img src='"+prtConfig.logo.imgSrc+"'>");
    lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    
    var startPos={
        x:prtConfig.paper.margin.left,
        y:logoMargin.top+logoSize.height+logoMargin.bottom
    };
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "手术清点记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    lodop.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);

    startPos.y+=titleSize.height+titleMargin.bottom;
    var lineHeight=20;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "姓名："+(operSchedule?operSchedule.PatName:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+120, 200, 15, "性别："+(operSchedule?operSchedule.PatGender:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+200, 200, 15, "年龄："+(operSchedule?operSchedule.PatAge:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+300, 200, 15, "科室："+(operSchedule?operSchedule.PatDeptDesc:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+460, 200, 15, "床号："+(operSchedule?operSchedule.PatBedCode:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "住院号："+(operSchedule?operSchedule.MedcareNo:""));
    var anaestMethodInfo=operSchedule?operSchedule.AnaestMethodInfo:""
    if (!anaestMethodInfo || anaestMethodInfo===""){
        anaestMethodInfo=operSchedule?operSchedule.PrevAnaMethodDesc:"";
    }
    startPos.y+=lineHeight;
    var operInfo=$("#OperationDesc").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "手术方式：");
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+70, 640, 30, operInfo);

    startPos.y+=lineHeight+(operInfo.length>40?25:0);
    var bloodTransInfo=getBloodTransInfo();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 120, 15, "输血 血型："+(operSchedule.ABO));
    var bloodTransInfo=getBloodTransInfo();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+120, "100%", 15, "成分：");
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+160, 520, 30, bloodTransInfo);
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+200, 540, 30, "输血成分："+$("#BloodComponent").combobox("getText"));
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "输血量："+$("#BloodTransVol").val());
    // lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+640, 200, 15, "ml");
    
    startPos.y+=lineHeight+(bloodTransInfo.length>35?20:0);
    var htmlArr=[
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 14px;}",
        "table {table-layout:fixed;} td {text-align:center}",
        "tr {height:22px;} .textline {display:inline-block;width:100px;height:18px;border:none;border-bottom:1px solid #000;}</style>",
        "<table><thead><tr><th width='140'>器械名称</th><th width='40'>术前清点</th><th width='40'>术中加数</th><th width='40'>关体腔前</th><th width='40'>关体腔后</th><th width='40'>缝皮肤后</th>",
        "<th width='140'>器械名称</th><th width='40'>术前清点</th><th width='40'>术中加数</th><th width='40'>关体腔前</th><th width='40'>关体腔后</th><th width='40'>缝皮肤后</th></tr></thead><tbody>"
    ];

    var operCountRows = $("#dataBox").datagrid("getRows");
	var inventoryRows=operCountRows;
    var maxCount = 20;
    var operCountRow;
    var secCountRow;
    var operCount = {
        MaterialNote: "",
        PreopCount: "",
        OperAddCount: "",
        PreCloseCount: "",
        PostCloseCount: "",
        PostSewCount: ""
    }
    for (var i = 0; i < maxCount; i++) {
        if (i >= operCountRows.length) {
            operCountRow = operCount;
            secCountRow = operCount;
        } else {
            operCountRow = operCountRows[i];
            secCountRow = operCountRows.length > (i + maxCount) ? operCountRows[i + maxCount] : operCount;
        }

        htmlArr.push("<tr><td>" + (operCountRow.MaterialNote ? operCountRow.MaterialNote : "") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PreopCount?operCountRow.PreopCount:"") + "</td>");
        htmlArr.push("<td>" + (Number(operCountRow.OperAddCount)>0?operCountRow.OperAddCount:"") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PreCloseCount?operCountRow.PreCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PostCloseCount?operCountRow.PostCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PostSewCount?operCountRow.PostSewCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.MaterialNote ? secCountRow.MaterialNote : "") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PreopCount?secCountRow.PreopCount:"") + "</td>");
        htmlArr.push("<td>" + (Number(secCountRow.OperAddCount)>0?secCountRow.OperAddCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PreCloseCount?secCountRow.PreCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PostCloseCount?secCountRow.PostCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PostSewCount?secCountRow.PostSewCount:"") + "</td></tr>");
    }

    // var rowCount=20;
    // var countRows=$("#dataBox").datagrid("getRows");
    // for(var i=0;i<rowCount;i++){
    //     htmlArr.push("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
    // }
    htmlArr.push("<tr><td colspan='12'></td></tr>");
    htmlArr.push("<tr><th>敷料名称</th><th>术前清点</th><th>术中加数</th><th>关体腔前</th><th>关体腔后</th><th>缝皮肤后</th>");
    htmlArr.push("<th>敷料名称</th><th>术前清点</th><th>术中加数</th><th>关体腔前</th><th>关体腔后</th><th>缝皮肤后</th></tr>");
    
    operCountRows = $("#operDressingBox").datagrid("getRows");
    maxCount = 7;
    operCount = {
        MaterialNote: "",
        PreopCount: "",
        OperAddCount: "",
        PreCloseCount: "",
        PostCloseCount: "",
        PostSewCount: ""
    }
    for (var i = 0; i < maxCount; i++) {
        if (i >= operCountRows.length) {
            operCountRow = operCount;
            secCountRow = operCount;
        } else {
            operCountRow = operCountRows[i];
            secCountRow = operCountRows.length > (i + maxCount) ? operCountRows[i + maxCount] : operCount;
        }

        htmlArr.push("<tr><td>" + (operCountRow.MaterialNote ? operCountRow.MaterialNote : "") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PreopCount?operCountRow.PreopCount:"") + "</td>");
        htmlArr.push("<td>" + (Number(operCountRow.OperAddCount)>0?operCountRow.OperAddCount:"") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PreCloseCount?operCountRow.PreCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PostCloseCount?operCountRow.PostCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (operCountRow.PostSewCount?operCountRow.PostSewCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.MaterialNote ? secCountRow.MaterialNote : "") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PreopCount?secCountRow.PreopCount:"") + "</td>");
        htmlArr.push("<td>" + (Number(secCountRow.OperAddCount)>0?secCountRow.OperAddCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PreCloseCount?secCountRow.PreCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PostCloseCount?secCountRow.PostCloseCount:"") + "</td>");
        htmlArr.push("<td>" + (secCountRow.PostSewCount?secCountRow.PostSewCount:"") + "</td></tr>");
    }
    // rowCount=7;
    // for(var i=0;i<rowCount;i++){
    //     htmlArr.push("<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
    // }
    htmlArr.push("<tr><td colspan='12'></td></tr>");
    htmlArr.push("<tr style='height:80px;'><td colspan='12' valign='top' style='padding:5px;text-align:left'>特殊情况记录："+$("#SpecialCondition").val()+"</td></tr>");
    htmlArr.push("<tr style='height:30px;'><td colspan='6' style='padding:5px;'>器械护士签名：<span class='textline'></span>/<span class='textline'></span></td>");
    htmlArr.push("<td colspan='6' style='padding:5px;'>巡回护士签名：<span class='textline'></span>/<span class='textline'></span></td></tr>")
    htmlArr.push("</tbody></table>");
    
    lodop.ADD_PRINT_HTM(startPos.y,startPos.x,"RightMargin:1.5cm","BottomMargin:1cm",htmlArr.join(""));
	
	// 打印背面
	lodop.NEWPAGE();
	startPos.x=prtConfig.paper.margin.left;
	startPos.y=prtConfig.paper.margin.top;
	lodop.ADD_PRINT_RECT(startPos.y,startPos.x,"RightMargin:1.5cm",880,0,1);
	lodop.ADD_PRINT_TEXT(startPos.y+10,startPos.x+10,"100%",lineHeight,"体内植入物条形码粘贴处：");
	startPos.y+=900;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"填表说明：");
	startPos.y+=lineHeight;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"1.表格内的清点数必须用数字说明，不得用\"√\"表示。");
	startPos.y+=lineHeight;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"2.空格处可以填写其他手术物品。");
	startPos.y+=lineHeight;
	lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",lineHeight,"3.表格内的清点数目必须清晰，不得采用刮、粘、涂等方法涂改。");
}

function existsSurgicalItem(boxId,surgicalItemId){
    var result={result:false,row:null,index:-1};
    var inventoryItems=$("#"+boxId).datagrid("getRows");
    if(inventoryItems && inventoryItems.length>0){
        for(var i=0;i<inventoryItems.length;i++){
            var item=inventoryItems[i];
            if(item.SurgicalMaterial===surgicalItemId){
                result.result=true;
                result.row=item;
                result.index=i;
            }
        }
    }
    return result;
}

$(document).ready(initPage);