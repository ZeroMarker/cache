var operCharge={
    currentArcim:null,
    editingRow:{
        index:-1,
        data:null
    },
    selecedOrderSet:{
		rowId:"",
		desc:""
    },
    selectedArcim:null
};
function initPage(){
    operDataManager.initFormData();
    initChargeBox();
    initChargeForm();
    initOrderSetBox();
    //initCharge();
}

function initChargeBox(){
    var arcimDescEditorOptions=getAricmDescEditorOptions(),
        uomEditorOptions=getUomEditorOptions(),
        qtyEditorOptions=getQtyEditorOptions(),
        execDeptEditorOptions=getExecDeptEditorOptions();
    var columns=[[
        {field:"CheckStatus",title:"选择",width:50,checkbox:true},
        {field:"OrderCatDesc",title:"分类",width:80},
        {field:"ArcimID",title:"项目",width:240,hidden:true},
        {field:"ArcimDesc",title:"项目",width:300,editor:{type:"combogrid",options:arcimDescEditorOptions}},
        // {field:"Spec",title:"规格",width:50},
        {field:"Qty",title:"数量",width:50,editor:{type:"numberbox",options:qtyEditorOptions}},
        {field:"Unit",title:"单位",width:60,hidden:true},
        {field:"UnitDesc",title:"单位",width:60,editor:{type:"combobox",options:uomEditorOptions}},
        {field:"Price",title:"单价",width:60},
        {field:"TotalPrice",title:"金额",width:80,formatter:function(value,row,index){
            var Qty=Number(row.Qty),
                price=Number(row.Price);
            return (Qty*price).toFixed(3);
        }},
        {field:"InstrDesc",title:"用法",width:80},
        {field:"BillDeptDesc",title:"开单科室",width:80},
        {field:"ExecDept",title:"接收科室",width:80,hidden:true},
        {field:"ExecDeptDesc",title:"接收科室",width:100,editor:{type:"combobox",options:execDeptEditorOptions}},
        {field:"StatusDesc",title:"医嘱状态",width:70},
        {field:"BillStatus",title:"计费状态",width:70,formatter:function(value,row,index){
            if(row.OrdExecInfo){
                var arr=row.OrdExecInfo.split("#");
                if(arr.length>0){
                    return arr[0];
                }
            }
        }},
        {field:"CollectQty",title:"发药数量",width:70,formatter:function(value,row,index){
            if(row.OrdExecInfo){
                var arr=row.OrdExecInfo.split("#");
                if(arr.length>1){
                    return arr[1];
                }
            }
        }},
        {field:"PrescNo",title:"处方号",width:120}, 
        {field:"UpdateUserDesc",title:"记录人",width:60},
        {field:"UpdateDT",title:"记录时间",width:170},
        {field:"AuditUserDesc",title:"审核人",width:60},
        {field:"AuditDT",title:"审核时间",width:170},
        {field:"CancelUserDesc",title:"撤销人",width:60},
        {field:"CancelDT",title:"撤销时间",width:170}
    ]];

    $("#chargeBox").datagrid({
        title:"患者手术医嘱列表",
        toolbar:"#chargeTools",
        fit:true,
        selectOnCheck:false,
        checkOnSelect:false,
        headerCls:"panel-header-gray",
        columns:columns,
        url:ANCSP.DataQuery,
        queryParams:{
            ClassName: ANCLS.BLL.ChargeRecord,
            QueryName: "FindChargeRecordDetails",
            Arg1: session.DeptID,
            Arg2: session.OPSID,
            ArgCnt: 2
        },
        rowStyler:function(index,row){
            if(row.Status==="A"){
                return "background-color:#94E290"
            }else{

            }
        },
        onLoadSuccess:function(data){
            if(data && data.rows && data.rows.length>0){
                var totalSum=0;
                for(var i=0;i<data.rows.length;i++){
                    var rowData=data.rows[i];
                    if(rowData.Status!=="N" && rowData.Status!=="A") continue;
                    totalSum+=Number(rowData.Price)*Number(rowData.Qty);
                }
                $("#totalsum").text("总金额："+totalSum.toFixed(2));
            }
        },
        onBeforeEdit:function(rowIndex,rowData){
            operCharge.editingRow.index=rowIndex;
            operCharge.editingRow.data=rowData;
        },
        onClickCell:onClickCell,
        onEndEdit:onEndEdit
    });

    // $("#chargeBox").datagrid("enableCellEditing");
}

function initChargeForm(){
    var arcimDescEditorOptions=getAricmDescEditorOptions();
    $("#ArcimID").combogrid(arcimDescEditorOptions);

    $("#Unit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindUom";
            param.Arg1=param.q?param.q:"";
            param.ArgCnt = 1;
        },
        mode:"remote"
    });

    $("#ExecDept").combobox({
        valueField:"Id",
        textField:"Desc",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission,
            param.QueryName="FindRecvLoc"
            param.Arg1=session.EpisodeID;
            param.Arg2=session.DeptID;
            param.Arg3=operCharge.selectedArcim || '';
            param.ArgCnt=3;
        },
        onLoadSuccess:function(data){
            if(data && data.length>0){
                var row=data[0];
                $(this).combobox("setValue",row.Id);
                $(this).combobox("setText",row.Desc);
            }else{
                $(this).combobox("setValue",session.DeptID);
                $(this).combobox("setText",session.DeptDesc);
            }
        }
    });

    $("#OrderSet").combobox({
        valueField:"OSRowId",
        textField:"OSDesc",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.OEOrder,
            param.QueryName="FindUserFavItems"
            param.Arg1=session.DeptID;
            param.ArgCnt=1;
        },
        onSelect:function(record){
            operCharge.selecedOrderSet.rowId=record.OSRowId;
			operCharge.selecedOrderSet.desc=record.OSDesc;
            $("#orderSetBox").datagrid("reload");
			$("#orderSetDialog").dialog("setTitle","医嘱套-"+record.OSDesc);
            $("#orderSetDialog").dialog("open");
        }
    });

    $("#Instruction").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.OEOrder,
            param.QueryName="FindInstruction"
            param.Arg1=param.q || '';
            param.ArgCnt=1;
        }
    });

    $("#Qty").keypress(function(e) {
        if (e.keyCode == 13) {
            saveOrder();
        }
    });

    $("#btnSaveOrder").linkbutton({
        onClick:saveOrder
    });

    $("#btnDelOrder").linkbutton({
        onClick:delOrder
    });

    $("#btnAuditOrder").linkbutton({
        onClick:auditOrder
    });

    $("#btnCancelOrder").linkbutton({
        onClick:cancelOrder
    });

    $("#btnReload").linkbutton({
        onClick:function(){
            $("#chargeBox").datagrid("reload");
        }
    });
}

function clearChargeForm(){
	$("#chargeForm").form("clear");
	$("#ExecDept").combobox("setValue",session.DeptID);
    $("#ExecDept").combobox("setText",session.DeptDesc);
	$("#chargeBox").datagrid("clearChecked");
	$("#chargeBox").datagrid("clearSelections");
}

function initOrderSetBox(){
    var columns=[[
        {field:"CheckStatus",title:"选择",checkbox:true},
        {field:"ArcimDesc",title:"医嘱项",width:400},
        {field:"PackQty",title:"数量",width:80,editor:{type:"numberbox",options:{precision:2}}},
        {field:"PackUomDesc",title:"单位",width:80}
    ]];

    $("#orderSetBox").datagrid({
        fit:true,
        columns:columns,
        url:ANCSP.DataQuery,
        // checkOnSelect:false,
        // selectOnCheck:false,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.OEOrder;
            param.QueryName="FindOrderSetItems";
            param.Arg1=operCharge.selecedOrderSet.rowId;
            param.ArgCnt=1;
        },
        onClickCell:function(rowIndex,field,value){
            // $(this).datagrid("beginEdit",rowIndex);
        },
        onLoadSuccess:function(data){
            if(data && data.rows && data.rows.length>0){
                for(var i=0;i<data.rows.length;i++){
                    var dataRow=data.rows[i];
                    $(this).datagrid("beginEdit",i);
                }
                $(this).datagrid("selectAll");
            }
        },
        onBeginEdit:function(index,row){
            var editor=$(this).datagrid("getEditor",{
                index:index,
                field:"PackQty"
            });
            if(!editor) return;
            var rows=$(this).datagrid("getRows");
            $(editor.target).keydown(function(e){
                if (e.keyCode===38){
                    // var curRow=rows[index];
                    // curRow.PackQty=$(this).val();
                    // $("#orderSetBox").datagrid("refreshRow",index);
                    // $("#orderSetBox").datagrid("acceptChanges");
                    // $("#orderSetBox").datagrid("endEdit",index);
                    if(index>0){
                        // $("#orderSetBox").datagrid("beginEdit",index-1);
                        var preEditor=$("#orderSetBox").datagrid("getEditor",{
                            index:index-1,
                            field:"PackQty"
                        });
                        if(preEditor){
                            $(preEditor.target).focus();
                            $(preEditor.target).select();
                        }
                    }
                }
                if (e.keyCode===40){
                    // var curRow=rows[index];
                    // curRow.PackQty=$(this).val();
                    // $("#orderSetBox").datagrid("refreshRow",index);
                    // $("#orderSetBox").datagrid("acceptChanges");
                    // $("#orderSetBox").datagrid("endEdit",index);
                    if(index<rows.length-1){
                        // $("#orderSetBox").datagrid("beginEdit",index+1);
                        var preEditor=$("#orderSetBox").datagrid("getEditor",{
                            index:index+1,
                            field:"PackQty"
                        });
                        if(preEditor){
                            $(preEditor.target).focus();
                            $(preEditor.target).select();
                        }
                    }
                }
            });
        },
        onEndEdit:function(index,row,changes){
            // if(changes.PackQty && changes.PackQty!=null){
            //     $(this).datagrid("checkRow",index);
            // }
        }
    });

    //$("#orderSetBox").datagrid("enableCellEditing");

    $("#orderSetDialog").dialog({
        onClose:function(){
            $("#orderSetBox").datagrid("clearSelections");
            $("#orderSetBox").datagrid("clearChecked");
            $("#OrderSet").combobox("clear");
        }
    });
    $("#btnConfirmOrderSet").linkbutton({
        onClick:function(){
            endEditDataBox($("#orderSetBox"));
            var checkedOSItems=$("#orderSetBox").datagrid("getSelections");
            if(checkedOSItems && checkedOSItems.length>0){
                saveOrderForOS(checkedOSItems);
            }else{
                $.messager.alert("提示","未选择任何项目，请勾选后再进行操作。","warning");
            }
        }
    });

    $("#btnCloseOrderSet").linkbutton({
        onClick:function(){
            $("#orderSetDialog").dialog("close");
            
        }
    });
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

function saveOrderForOS(OSItems){
    var chargeRecordList=[];
    for(var i=0;i<OSItems.length;i++){
        var OSItem=OSItems[i];
        chargeRecordList.push({
            OperSchedule:session.OPSID,
            LocationDr:session.DeptID,
            RecordSheet:session.RecordSheetID,
            UpdateUser:session.UserID,
            CreateUser:session.UserID,
            BillDept:session.DeptID,
            UserDept:session.DeptID,
            ExecDept:session.DeptID,
            ArcimDesc:OSItem.ArcimDesc,
            ArcimID:OSItem.ArcimID,
            Unit:OSItem.PackUom,
            Qty:OSItem.PackQty,
            DoseQty:OSItem.DoseQty,
            DoseUom:OSItem.DoseUom,
            ChargeItemDesc:OSItem.ArcimDesc,
            Price:OSItem.Price
        });
    }

    var ret = dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: "SaveChargeRecordDetails",
        jsonData: dhccl.formatObjects(chargeRecordList)
    }, function(data) {
        if (data.indexOf("S^") === 0) {
			$("#orderSetDialog").dialog("close");
            $("#chargeBox").datagrid("reload");
            //$("#chargeForm").form("clear");
        } else {
            $.messager.alert("提示", "收费项目保存失败，原因：" + data, "error");
        }
    });
}

function saveOrder(){
    var validateRet=$("#chargeForm").form("validate");
    if(!validateRet) return;
    var chargeRecord=$("#chargeForm").serializeJson();
    chargeRecord.Price=$("#Price").val();
    chargeRecord.Qty=$("#Qty").val();
    chargeRecord.BillDept=session.DeptID;
    chargeRecord.UserDept=session.DeptID;
    chargeRecord.UpdateUser=session.UserID;
    chargeRecord.ChargeItemDesc=$("#ArcimID").combobox("getText");
    chargeRecord.ArcimDesc=$("#ArcimID").combobox("getText");
    chargeRecord.OperSchedule=session.OPSID;
    chargeRecord.LocationDr=session.DeptID;
    chargeRecord.RecordSheet=session.RecordSheetID;
    chargeRecord.Type="N";
    if (!chargeRecord.RowId || chargeRecord.RowId===""){
        chargeRecord.CreateUser=session.UserID;
    }
    var ret = dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: "SaveChargeRecordDetails",
        jsonData: dhccl.formatObjects(chargeRecord)
    }, function(data) {
        if (data.indexOf("S^") === 0) {
            $("#chargeBox").datagrid("reload");
            clearChargeForm();
        } else {
            $.messager.alert("提示", "收费项目保存失败，原因：" + data, "error");
        }
    });
}

function delOrder(){
    var selectedRows=$("#chargeBox").datagrid("getChecked");
    if(!selectedRows || selectedRows.length<=0){
        $.messager.alert("提示","请先勾选需要删除的医嘱，再进行操作。","warning");
    }else{
        for(var rowInd=0;rowInd<selectedRows.length;rowInd++){
            var rowData=selectedRows[rowInd];
            if(rowData.Status!=="N"){
                $.messager.alert("提示","勾选的医嘱中存在已核实的医嘱，不能删除。","warning");
                return;
            }
        }
        $.messager.confirm("提示","是否要删除已勾选的医嘱？",function(result){
            if(result){
                var dataList=[];
                for (var i = 0; i < selectedRows.length; i++) {
                    var selectedRow = selectedRows[i];
                    dataList.push({
                        ClassName: ANCLS.Model.ChargeRecordDetail,
                        RowId: selectedRow.RowId
                    });
                }
                var dataListStr=dhccl.formatObjects(dataList);
                var ret = dhccl.runServerMethod(CLCLS.BLL.DataService, "DelDatas", dataListStr);
                if (ret.success) {
                    clearChargeForm();
                    $("#chargeBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", "删除清点纪录失败，原因：" + ret.result, "error");
                }
            }
        });
    }
}

function auditOrder(){
    var ret=dhccl.runServerMethod(ANCLS.BLL.ChargeRecord,"AuditOrderList",session.OPSID,session.DeptID,session.UserID);
    if(ret.success){
        $.messager.alert("提示","医嘱审核成功！","info");
        $("#chargeBox").datagrid("reload");
    }else{
        $.messager.alert("提示","医嘱审核失败，原因："+ret.result,"error");
    }
}

function cancelOrder(){
    var checkedRows=$("#chargeBox").datagrid("getChecked");
    if(checkedRows && checkedRows.length>0){
        var rowidArr=[];
        for(var i=0;i<checkedRows.length;i++){
            var row=checkedRows[i];
            rowidArr.push(row.RowId);
        }
        var ret=dhccl.runServerMethod(ANCLS.BLL.ChargeRecord,"CancelOrderList",rowidArr.join("^"),session.UserID);
        if(ret.success){
            $.messager.alert("提示","医嘱撤销成功！","info");
            $("#chargeBox").datagrid("reload");
        }else{
            $.messager.alert("提示","医嘱撤销失败，原因："+ret.result,"error");
        }
    }else{
        $.messager.alert("提示","请先勾选需要撤销的医嘱，再进行操作。","warning");
    }
}

function initCharge() {
    var columns = [
        [{
                field: "CheckStatus",
                title: "选择",
                width: 60,
                checkbox: true
            },
            {
                field: "ArcimDesc",
                title: "名称",
                width: 240
            },
            {
                field: "Spec",
                title: "规格",
                width: 120
            },
            {
                field: "Qty",
                title: "数量",
                width: 60
            },
            {
                field: "Price",
                title: "单价",
                width: 80
            },
            {
                field: "UnitDesc",
                title: "单位",
                width: 80
            },
            {
                field: "BarCode",
                title: "条码",
                width: 180
            },
            {
                field: "Operators",
                title: "操作",
                width: 80,
                formatter: function(value, row, index) {
                    var html = "<a href='#' id='ChargeRecord" + row.RowId + "' class='hisui-linkbutton chargerecord-btn' data-options='plain:true' iconcls='icon-remove' data-rowid='" + row.RowId + "'></a>";
                    return html;
                }
            }
        ]
    ];

    var dataForm = new DataForm({
        datagrid: $("#chargeBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#chargeTools",
        form: $("#chargeForm"),
        modelType: ANCLS.Model.ChargeRecordDetail,
        queryType: ANCLS.BLL.ChargeRecord,
        queryName: "FindChargeRecordDetails",
        queryParams: {
            Arg1: session.DeptID,
            Arg2: session.OPSID,
            ArgCnt: 2
        },
        dialog: null,
        addButton: $("#btnAddCharge"),
        editButton: $("#btnEditCharge"),
        delButton: $("#btnDelCharge"),
        queryButton: null,
        submitCallBack: null,
        onSubmitCallBack: setChargeParam,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: setChargeRecord,
        submitAction: saveChargeRecord,
        singleSelect: false,
        delAction: delChargeRecord
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        // onBeforeLoad: function (param) {
        //     param.Arg1 = session.DeptID;
        //     param.Arg2=session.OPSID;
        //     param.ArgCnt = 2;
        // },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                var materialDescArr = [];
                var materials = [];
                var materialsArr = [];
                for (var i = 0; i < data.rows.length; i++) {
                    var materialData = data.rows[i];
                    if (materialData.ChargeCategoryDesc !== "高值耗材" && materialData.ChargeItem !== "") {
                        continue;
                    }
                    var desc = materialData.ChargeItemDesc + materialData.Price; //+(materialData.Spec?"("+materialData.Spec+")":"");
                    var index = materialDescArr.indexOf(desc);
                    if (index > -1) {
                        materials[index].Qty = Number(materials[index].Qty) + Number(materialData.Qty);
                    } else {
                        materialDescArr.push(desc);
                        materials.push({
                            Desc: materialData.ChargeItemDesc,
                            Qty: materialData.Qty,
                            Unit: materialData.UnitDesc
                        });
                    }
                    //materialsArr.push(materialData.ChargeItemDesc+" "+materialData.Qty+materialData.UnitDesc);
                }

                for (var index in materials) {
                    materialsArr.push(materials[index].Desc + " " + materials[index].Qty + materials[index].Unit);
                }

                $("#SpecialItemsDesc").val(materialsArr.join(splitchar.comma));
            }

            if (data && data.rows && data.rows.length > 0) {
                $(".chargerecord-btn").linkbutton({
                    onClick: function() {
                        var rowid = $(this).attr("data-rowid");
                        $.messager.confirm("确认", "是否删除该收费记录？", function(result) {
                            if (result) {
                                var dataList = [];
                                dataList.push({
                                    ClassName: ANCLS.Model.ChargeRecordDetail,
                                    RowId: rowid
                                });
                                var dataListStr = dhccl.formatObjects(dataList);
                                var ret = dhccl.runServerMethod(ANCLS.BLL.ChargeRecord, "RemoveChargeRecordDetails", dataListStr);
                                if (ret.success) {
                                    $("#chargeForm").form("clear");
                                    $("#chargeBox").datagrid("reload");
                                } else {
                                    $.messager.alert("提示", "删除清点纪录失败，原因：" + ret.result, "error");
                                }
                                // var msg = dhccl.removeData(ANCLS.Model.ChargeRecordDetail, rowid);
                                // dhccl.showMessage(msg, "删除", null, null, function () {
                                //     $("#chargeBox").datagrid("reload");
                                // });
                            }
                        });
                    }
                });
            }
        }
    });

    $("#ChargeItem").combogrid({
        panelWidth: 400,
        idField: 'RowId',
        textField: 'Description',
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindChargeItemByCondition";
            param.Arg1 = session.DeptID;
            param.Arg2 = param.q ? param.q : "";
            param.ArgCnt = 2;
        },
        columns: [
            [
                { field: 'Description', title: '项目名称', width: 200 },
                { field: 'Price', title: '单价', width: 80 },
                { field: 'UnitDesc', title: '单位', width: 60 }
                // {field:'Spec',title:'规格',width:80},
                // {field:'Manufacturer',title:'制造商',width:60},
                // {field:'Vendor',title:'供应商',width:60}
            ]
        ],
        mode: "remote",
        onSelect: function(rowIndex, rowData) {
            $("#Unit").combobox("setValue", rowData.Unit);
            $("#Qty").numberbox("setValue", 1);
            chargeParam = rowData;
        }
    });

    // $("#StockItem").next("span").find("input").focus(function(){
    //     try{
    //         window.parent.CLCom.receiveData(AddMatRecord);
    //     }catch(ex){
    //         console.log(ex.message);
    //     }
    // });

    $("#Unit").combobox({
        valueField: "RowId",
        textField: "LocalDesc",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.StockManager;
            param.QueryName = "FindUom";
            param.ArgCnt = 0;
        }
    });

    $("#ChargeSet").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ChargeRecord;
            param.QueryName = "FindChargeSets";
            param.Arg1 = session.DeptID;
            param.ArgCnt = 1;
        },
        onSelect: function(record) {
            $("#chargeSetDialog").dialog("open");
            $("#chargeSetBox").datagrid("reload");
            var chargeSetDesc = $("#ChargeSet").combobox("getText");
            $("#chargeSetDialog").dialog("setTitle", "收费套餐-" + chargeSetDesc);
            return;
            $.messager.confirm("确认", "是否添加该收费套餐的收费项目？", function(r) {
                if (r) {
                    var dataList = dhccl.getDatas(ANCSP.DataQuery, {
                        ClassName: ANCLS.BLL.ChargeRecord,
                        QueryName: "FindChargeSetItems",
                        Arg1: record.RowId,
                        ArgCnt: 1
                    }, "json");
                    if (dataList.length > 0) {
                        var chargeList = [];
                        for (var i = 0; i < dataList.length; i++) {
                            var chargeData = dataList[i];
                            chargeList.push({
                                RowId: "",
                                ChargeItem: chargeData.ChargeItem,
                                BillDept: session.DeptID,
                                ExecDept: session.DeptID,
                                UserDept: session.DeptID,
                                Unit: chargeData.Uom,
                                Qty: (chargeData.DefaultQty) ? chargeData.DefaultQty : 1,
                                OperSchedule: session.OPSID,
                                UpdateUser: session.UserID,
                                ChargeClassName: ANCLS.Model.ChargeRecordDetail,
                                ChargeItemDesc: chargeData.SetItemDesc,
                                Price: chargeData.Price,
                                Type: "N"
                            });
                        }
                        dhccl.saveDatas(ANCSP.DataListService, {
                            jsonData: dhccl.formatObjects(chargeList),
                            ClassName: ANCLS.BLL.ChargeRecord,
                            MethodName: "SaveChargeRecordDetails"
                        }, function(data) {
                            var result = dhccl.resultToJson(data);
                            if (result.success) {
                                $("#chargeBox").datagrid("reload");
                            } else {
                                $.messager.alert("提示", "添加套餐项目失败，原因：" + result.result, "error");
                            }
                        });
                        // for (var i = 0; i < dataList.length; i++) {
                        //     $("#surSupplyBox").datagrid("appendRow", {
                        //         StockItemDr:dataList[i].StockItem,
                        //         StockTransferDr:"",
                        //         LocationDr:session.DeptID,
                        //         StockItemDesc: dataList[i].StockItemDesc,
                        //         StockItemSpec: dataList[i].StockItemSpec,
                        //         Qty:(dataList[i].DefaultQty) ? dataList[i].DefaultQty : 1,
                        //         UomDr:dataList[i].Uom,
                        //         UomDesc: dataList[i].UomDesc,
                        //         StockCatDesc: dataList[i].StockCatDesc
                        //     });
                        // }
                    }
                }
            });
        }
    });

    $("#ScanMatBarCode").keypress(function(e) {
        if (e.keyCode == 13) {
            // dhccl.saveDatas(ANCSP.MethodService, {
            //     ClassName: ANCLS.BLL.ANMobileScanInfo,
            //     MethodName: "AddStockConsume",
            //     Arg1: $(this).val(),
            //     Arg2: session.OPSID,
            //     Arg3: session.ModuleCode,
            //     Arg4: session.UserID,
            //     Arg5: session.DeptID,
            //     ArgCnt: 5
            // }, function (data) {
            //     if(data.indexOf("^S")==0){
            //         $("#surSupplyBox").datagrid("reload");
            //     }else{
            //         $.messager.alert("提示","扫码失败，原因："+data,"error");
            //     }

            // });
            addMatRecord($(this).val());
        }
    });

    $("#ScanMatBarCode").focus(function() {
        try {
            dhcclcomm.OpenCom("COM1", "115200");
            scanCode = "Material";
        } catch (ex) {
            console.log(ex.message);
        }

    });

    $("#chargeSetBox").datagrid({
        fit: true,
        singleSelect: false,
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
                    field: "RowId",
                    title: "RowId",
                    width: 100,
                    hidden: true
                },
                {
                    field: "ChargeItemDesc",
                    title: "项目名称",
                    width: 120
                },
                {
                    field: "DefQty",
                    title: "数量",
                    width: 80,
                    editor: {
                        type: 'numberbox'
                    }
                },
                {
                    field: "UomDesc",
                    title: "单位",
                    width: 100
                }
            ]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ChargeRecord;
            param.QueryName = "FindChargeSetItems";
            var chargeSetId = $("#ChargeSet").combobox("getValue");
            param.Arg1 = chargeSetId;
            param.ArgCnt = 1;
        }
    });

    $("#btnConfirmChargeSet").linkbutton({
        onClick: function() {
            var selectedSetItems = $("#chargeSetBox").datagrid("getSelections");
            var chargeList = [];
            if (selectedSetItems && selectedSetItems.length > 0) {
                for (var i = 0; i < selectedSetItems.length; i++) {
                    var chargeSetItem = selectedSetItems[i];
                    chargeList.push({
                        RowId: "",
                        ChargeItem: chargeSetItem.ChargeItem,
                        BillDept: session.DeptID,
                        ExecDept: session.DeptID,
                        UserDept: session.DeptID,
                        Unit: chargeSetItem.Uom,
                        Qty: (chargeSetItem.DefQty) ? chargeSetItem.DefQty : 1,
                        OperSchedule: session.OPSID,
                        UpdateUser: session.UserID,
                        ChargeClassName: ANCLS.Model.ChargeRecordDetail,
                        ChargeItemDesc: chargeSetItem.ChargeItemDesc,
                        Price: chargeSetItem.Price,
                        Status: "N"
                    });
                }
                dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: dhccl.formatObjects(chargeList),
                    ClassName: ANCLS.BLL.ChargeRecord,
                    MethodName: "SaveChargeRecordDetails"
                }, function(data) {
                    var result = dhccl.resultToJson(data);
                    if (result.success) {
                        $("#chargeBox").datagrid("reload");
                        $("#chargeSetDialog").dialog("close");
                        $("#ChargeSet").combobox("clear");
                    } else {
                        $.messager.alert("提示", "添加套餐项目失败，原因：" + result.result, "error");
                    }
                });
            }
        }
    });

    $("#btnExitChargeSet").linkbutton({
        onClick: function() {
            //$("#chargeSetBox").datagrid("clear");
            $("#chargeSetDialog").dialog("close");
            $("#ChargeSet").combobox("clear");

        }
    });

    $("#btnPrintChargeRecord").linkbutton({
        onClick: function() {
            printChargeRecord();
        }
    });

    $("#chargeSetBox").datagrid("enableCellEditing");

    //initChargeRecord();
}

function saveChargeRecord(param) {
    var ret = dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.ChargeRecord,
        MethodName: "SaveChargeRecordDetails",
        jsonData: dhccl.formatObjects(param)
    }, function(data) {
        if (data.indexOf("S^") === 0) {
            $("#chargeBox").datagrid("reload");
            $("#chargeForm").form("clear");
        } else {
            $.messager.alert("提示", "收费项目保存失败，原因：" + data, "error");
        }
    })
}

function initChargeRecord() {
    var ret = dhccl.runServerMethod(ANCLS.BLL.ChargeRecord, "GetChargeRecord", session.OPSID, session.UserID);
    if (ret && ret.result) {
        $("#ChargeRecord").val(ret.result);
    }
}

function setChargeParam(param) {
    var selectedRow = $("#chargeBox").datagrid("getSelected");
    param.BillDept = session.DeptID;
    param.UserDept = session.DeptID;
    param.ExecDept = session.DeptID;
    param.ChargeItem = $("#ChargeItem").combogrid("getValue");
    param.ChargeItemDesc = $("#ChargeItem").combogrid("getText");
    param.OperSchedule = session.OPSID;
    param.UpdateUser = session.UserID;
    if (!selectedRow) {
        param.StockItemDr = chargeParam.StockItemID ? chargeParam.StockItemID : "";
        param.UomDr = chargeParam.Unit;
        param.Price = chargeParam.Price;
        param.StockItemDesc = chargeParam.StockItemDesc;
        param.Unit = $("#Unit").combobox("getValue");
    } else {
        param.RowId = selectedRow.RowId;
        param.StockItemDr = selectedRow.StockItemDr;
        param.UomDr = selectedRow.UomDr;
        param.Price = selectedRow.Price;
        param.StockItemDesc = selectedRow.StockItemDesc;
        param.Unit = $("#Unit").combobox("getValue");
    }
    // param.StockItemDr=chargeParam.StockItemID?chargeParam.StockItemID:"";
    param.LocationDr = session.DeptID;
    // param.UomDr=chargeParam.Unit;
    param.RecordSheet = session.RecordSheetID;
    param.StockConsume = "";
    // param.Price=chargeParam.Price;
    param.Type = "N";
    // param.StockItemDesc=chargeParam.StockItemDesc;
    // param.Unit=chargeParam.Unit;
    param.Qty = $("#Qty").numberbox("getValue");
}

function setChargeRecord(record) {
    $("#ChargeItem").combogrid("setText", record.ChargeItemDesc);
}

function getAricmDescEditorOptions(){
    return {
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.OEOrder;
            param.MethodName = "GetArcimJSON";
            param.Arg1=param.page;
            param.Arg2=param.rows;
            param.Arg3 = param.q?param.q:"";
            param.Arg4 = session.GroupID;
            param.Arg5 = session.DeptID;
            param.Arg6=session.EpisodeID;
            param.ArgCnt = 6;
        },
        pagination:true,
        pageSize:10,
        panelWidth:450,
        panelHeight:400,
        delay:500,
        pageNumber:1,
        idField: "ArcimId",
        textField: "ArcimDesc",
        columns:[[
            {field:"ArcimId",title:"ID",hidden:true},
            {field:"ArcimDesc",title:"医嘱项目",width:330},
            {field:"BaseUomDesc",title:"单位",width:40},
            {field:"Price",title:"单价",width:60}
        ]],
        mode: "remote",
        onSelect:function(rowIndex,row){
            // var chargeData=operCharge.editingRow.data;
            // chargeData.Price=record.Price;
            // chargeData.ArcimID=record.ArcimId;
            // chargeData.Unit=record.BaseUomId;
            // var qtyEditor=$("#chargeBox").datagrid("getEditor",{index:operCharge.editingRow.index,field:"Qty"});
            // $(qtyEditor.target).numberbox("setValue",1);
            // var uomEditor=$("#chargeBox").datagrid("getEditor",{index:operCharge.editingRow.index,field:"UnitDesc"});
            // $(uomEditor.target).combobox("setText",record.BaseUomDesc);
            // $("#chargeBox").datagrid("acceptChanges");
            operCharge.selectedArcim=row.ArcimId;
            $("#ExecDept").combobox("reload");
            $("#Unit").combobox("setValue",row.BaseUomId);
            $("#Price").val(row.Price);
            $("#Instruction").combobox("setValue",row.InstrId);
            $("#Instruction").combobox("setText",row.InstrDesc);
            var Qty=$("#Qty").numberbox("getValue");
            if(Qty===""){
                $("#Qty").numberbox("setValue",1);
            }
            
        },
        onHidePanel:function(){
            $("#Qty").focus();
            $("#Qty").select();
        }
    }
}

function getUomEditorOptions(){
    return {
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindUom";
            param.Arg1=param.q?param.q:"";
            param.ArgCnt = 1;
        },
        mode:"remote"
    }
}

function getQtyEditorOptions(){
    return {
        min:0,
        max:1000000,
        precision:2
    }
}

function getExecDeptEditorOptions(){
    return {
        valueField:"Id",
        textField:"Desc",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName="DHCCL.BLL.Admission",
            param.QueryName="FindRecvLoc"
            param.Arg1="";
            param.Arg2=session.DeptID;
            param.Arg3="";
            param.ArgCnt=3;
        },
        onLoadSuccess:function(data){
            if(data && data.length>0){
                $(this).combobox("setValue",session.DeptID);
                $(this).combobox("setText",session.DeptDesc);
            }
        }
    }
}

var editIndex = undefined;
function endEditing(){
    if (editIndex == undefined){return true}
    if ($('#chargeBox').datagrid('validateRow', editIndex)){
        $('#chargeBox').datagrid('endEdit', editIndex);
        editIndex = undefined;
        return true;
    } else {
        return false;
    }
}
function onClickCell(index, field){
    return;
    if (editIndex != index){
        if (endEditing()){
            $('#chargeBox').datagrid('selectRow', index)
                    .datagrid('beginEdit', index);
            var ed = $('#chargeBox').datagrid('getEditor', {index:index,field:field});
            if (ed){
                ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
            }
            editIndex = index;
        } else {
            setTimeout(function(){
                $('#chargeBox').datagrid('selectRow', editIndex);
            },0);
        }
    }
}
function onEndEdit(index, row){
    
}

$(document).ready(initPage);