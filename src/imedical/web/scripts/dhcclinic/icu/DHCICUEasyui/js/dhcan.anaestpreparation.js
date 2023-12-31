/**
 * 页面对象
 */
var page={
    /**
     * 患者信息Banner
     */
    banner:null,
    /**
     * lodop打印对象
     */
    lodop:null
};

/**
 * 初始化页面
 * @author chenchangqing 20190109
 */
function initPage(){
    // initPatBanner();
    // initOperList();
    initAnaestPreparation();
    initOrderSets();
}

/**
 * 初始化患者信息Banner
 */
function initPatBanner(){
    // 需要引用dhcan.operschedulebanner.js
    page.banner = operScheduleBanner.init('#patinfo_banner', {});
}

/**
 * 初始化手术列表
 * @author chenchangqing 20190109
 */
function initOperList(){
    // 初始化手术日期
    var today=(new Date()).format("yyyy-MM-dd");
    $("#filterDate").datebox("setValue",today);
    
    // 初始化手术间combobox
    $("#filterOPRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = "";
            param.Arg2="R";
            param.ArgCnt = 2;
        }
    });
    
    // 初始化手术列表表格
    $("#operListBox").datagrid({
        fit: true,
        title:"手术列表",
        singleSelect: true,
        toolbar: "#operListTools",
        url: ANCSP.DataQuery,
        // pagination: true,
        // pageList: [12, 30],
        // pageSize: 12,
        showPageList: false,
        showRefresh: false,
        sortName: "RoomInfo,OperSeqInfo",
        sortOrder: "asc,asc",
        remoteSort: false,
        multiSort: true,
        // afterPageText: "页",
        // beforePageText: '',
        displayMsg: "",
        columns: [
            [
                { field: "RoomDesc", title: "术间", width: 60 },
                { field: "OperSeq", title: "台次", width: 40 },
                { field: "RoomInfo", title: "术间", width: 60, hidden: true },
                { field: "OperSeqInfo", title: "台次", width: 40, hidden: true },
                { field: "Patient", title: "患者", width: 120 },
                { field: "OperationDesc", title: "手术名称", width: 200 },
                { field: "SurgeonDesc", title: "手术医生", width: 120 },
                { field: "AnaMethodDesc", title: "麻醉方法", width: 160 },
                { field: "AnaDoctor", title: "麻醉医生", width: 120 }
            ]
        ],
        rowStyler: function(index, row) {
            return "background-color:" + row.StatusColor + ";";
        },
        queryParams: {
            ClassName: dhcan.bll.operSchedule,
            QueryName: "FindOperScheduleList",
            ArgCnt: 14
        },
        onBeforeLoad: function(param) {
            var selectedRoomId = $("#filterOPRoom").combobox("getValue");
            var selectedRoomDesc = $("#filterOPRoom").combobox("getText");
            if (!selectedRoomDesc || selectedRoomDesc === splitchar.empty) {
                selectedRoomId = splitchar.empty;
            }
            param.Arg1 = $("#filterDate").datebox("getValue");
            param.Arg2 = $("#filterDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            param.Arg7 = "Application^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Stop^Cancel";
            param.Arg8 = selectedRoomId;
            param.Arg9 = "";
            param.Arg10 = "";
            param.Arg11 = "N";
            param.Arg12 = "N";
            param.Arg13 = "N";
            param.Arg14 = $("#filterPatName").val();
        },
        onSelect: function(rowIndex, rowData) {
            page.banner.loadData(rowData);
        }
    });
    
    // 查询手术列表
    $("#btnQuery").linkbutton({
        onClick: function() {
            $("#operListBox").datagrid("reload");
        }
    });
}

/**
 * 初始化麻醉物品预约
 * @author chenchangqing 20190109
 */
function initAnaestPreparation(){
    // 初始化麻醉医生Combobox
    // $("#filterAnaDoc").combobox({
    //     valueField: "RowId",
    //     textField: "Description",
    //     url: ANCSP.DataQuery,
    //     onBeforeLoad: function(param) {
    //         param.ClassName = CLCLS.BLL.Admission;
    //         param.QueryName = "FindCareProv";
    //         param.Arg1 = param.q?param.q:"";
    //         param.Arg2=session.DeptID;
    //         param.ArgCnt = 2;
    //     },
    //     mode:"remote"
    // });

    // 启用编辑功能
    // var rowEditor=new DataGridRowEditor({
    //     datagrid:"#anaestItemBox"
    // });

    var today=(new Date()).format("yyyy-MM-dd");
    $("#TargetDate").datebox("setValue",today);

    // 初始化麻醉物品表格
    $("#anaestItemBox").datagrid({
        fit: true,
        title:"麻醉物品预约",
        toolbar: "#anaestItemTools",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "CheckStatus", title: "选择", width: 60, checkbox:true },
                { field: "TargetDate", title: "手术日期", width: 120 },
                { field: "OperRoomDesc", title: "手术间", width: 80 },
                // { field: "Patient", title: "患者", width: 110 },
                { field: "ArcimDesc", title: "物品名称", width: 200 },
                { field: "PackQty", title: "数量", width: 40},
                { field: "PackUomDesc", title: "单位", width: 60},
                { field: "AnaDoctorDesc", title: "预约医生", width: 80},
                // { field: "CreateTime", title: "预约时间", width: 100},
                { field: "Operator", title: "操作", width: 80,formatter:function(value, row, index){
                    var html=["<span class='oper-btns'>"];
                    var dataRow=JSON.stringify(row);
                    // var addBtn="",rows=$("#anaestItemBox").datagrid("getRows");
                    // if(index===rows.length-1){
                    //     addBtn="<a href='#' class='hisui-linkbutton oper-btn-add' data-options='iconCls:\"icon-add\",plain:true' data-row='"+dataRow+"' data-rowindex='"+index+"'></a>";
                    // }
                    // html.push(addBtn);
                    // html.push("<a href='#' class='hisui-linkbutton oper-btn-edit' data-options='iconCls:\"icon-save\",plain:true' data-row='"+dataRow+"' data-rowindex='"+index+"'></a>");
                    html.push("<a href='#' class='hisui-linkbutton oper-btn-remove' data-options='iconCls:\"icon-remove\",plain:true' data-row='"+dataRow+"' data-rowindex='"+index+"'></a>")
                    html.push("</span>");
                    return html.join("");
                } }
                
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.Preparation,
            QueryName: "FindAnaestPreparation",
            ArgCnt: 4
        },
        onBeforeLoad: function(param) {
            param.Arg1 = session.DeptID;
            param.Arg2 = $("#TargetDate").datebox("getValue");
            param.Arg3 = session.UserID;
            // var selectedSchedule=$("#operListBox").datagrid("getSelected");
            // param.Arge4=selectedSchedule?selectedSchedule.RowId:"";
            param.Arg4="";
        },
        onLoadSuccess:function(data){
            // $(".oper-btn-add").linkbutton({
            //     onClick:function(){
            //         addAnaItemRow(rowEditor);
            //     }
            // });

            // $(".oper-btn-edit").linkbutton({
            //     onClick:editAnaItem
            // });

            $(".oper-btn-remove").linkbutton({
                onClick:removeAnaItem
            });
        },
        onSelect:function(index,row){
            $("#anaestItemForm").form("load",row);
            $("#ArcimID").combobox("setText",row.ArcimDesc);
        }
    });

    $("#ArcimID").combobox({
        valueField: "ArcimId",
        textField: "ArcimDesc",
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.OEOrder;
            param.MethodName = "GetArcimJSON";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.GroupID;
            param.Arg3=session.DeptID;
            param.Arg4="";
            param.ArgCnt = 4;
        },
        mode:"remote",
        onSelect:function(row){
            $("#PackUom").combobox("setValue",row.BaseUomId);
        }
    });

    $("#OperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindOperRoom";
            param.Arg1 = "";
            param.Arg2="R";
            param.ArgCnt = 2;
        }
    });

    $("#PackUom").combobox({
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

    // 麻醉物品保存
    $("#btnAddAnaItem").linkbutton({
        onClick:function(){
            var formData=$("#anaestItemForm").serializeJson();
            formData.ClassName=ANCLS.Model.AnaestPreparation;
            if (!formData.RowId || formData.RowId===""){
                formData.CreateUser=session.UserID;
                formData.AnaDoctor=session.UserID;
                // formData.TargetDate=$("filterDate").datebox("getValue");
                formData.Status="N";
                formData.Dept=session.DeptID;
            }
            formData.UpdateUser=session.UserID;
            
            
            var anaItems=[formData];
            dhccl.saveDatas(ANCSP.DataListService,{
                jsonData:dhccl.formatObjects(anaItems)
            },function(data){
                if(data.indexOf("S^")===0){
                    $.messager.alert("提示","添加麻醉物品成功！","info");
                    $("#anaestItemBox").datagrid("reload");
                    $("#anaestItemForm").form("clear");
                }else{
                    $.messager.alert("提示","添加麻醉物品失败，原因："+data,"error");
                }
            });
        }
    });

    $("#btnEditAnaItem").linkbutton({
        onClick:function(){
            var formData=$("#anaestItemForm").serializeJson();
            if(!formData.RowId || formData.RowId===""){
                $.messager.alert("提示","请先选择一行麻醉物品记录，再进行修改。","warning");
                return;
            }
            formData.ClassName=ANCLS.Model.AnaestPreparation;
            formData.UpdateUser=session.UserID;
            var anaItems=[formData];
            dhccl.saveDatas(ANCSP.DataListService,{
                jsonData:dhccl.formatObjects(anaItems)
            },function(data){
                if(data.indexOf("S^")===0){
                    $.messager.alert("提示","修改麻醉物品成功！","info");
                    $("#anaestItemBox").datagrid("reload");
                    $("#anaestItemForm").form("clear");
                }else{
                    $.messager.alert("提示","修改麻醉物品失败，原因："+data,"error");
                }
            });
        }
    });

    // 麻醉物品删除
    $("#btnDelAnaItem").linkbutton({
        onClick:function(){
            var selectedAnaItems=$("#anaestItemBox").datagrid("getSelections");
            if(selectedAnaItems && selectedAnaItems.length>0){
                $.messager.confirm("提示","确定要删除选择的麻醉物品？",function(result){
                    if(result){
                        var removeRet=removeAnaItems(selectedAnaItems);
                        if(removeRet && removeRet.indexOf("S^")===0){
                            $.messager.alert("提示","删除麻醉物品成功！","info");
                            $("#anaestItemBox").datagrid("reload");
                            initAnaestItemForm();
                        }else{
                            $.messager.alert("提示","删除麻醉物品失败，原因："+removeRet,"error");
                        }
                    }
                });
            }else{  
                $.messager.alert("提示","请先选择需要删除的麻醉物品。","warning");
            }
        }
    });

    $("#btnClearAnaItem").linkbutton({
        onClick:function(){
            initAnaestItemForm();
        }
    });

    $("#btnQueryAnaItem").linkbutton({
        onClick:function(){
            var targetDate=$("#TargetDate").datebox("getValue");
            if(!targetDate || targetDate===""){
                $.messager.alert("提示","未选择手术日期，无法查询。","warning");
            }else{
                $("#anaestItemBox").datagrid("reload");
            }
        }
    });
}

/**
 * 初始化医嘱套选择界面
 * @author chenchangqing 20190109
 */
function initOrderSets(){
    // 初始化医嘱套Combobox
    $("#filterOrderSet").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.MethodService,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.OEOrder;
            param.MethodName = "GetOrderSets";
            param.Arg1 = param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.Arg3=session.GroupID;
            param.Arge4=session.UserID;
            param.ArgCnt = 4;
        },
        onSelect:function(record){
            $("#orderSetBox").datagrid("reload");
        },
        mode:"remote"
    });

    // 启用编辑功能
    var rowEditor=new DataGridRowEditor({
        datagrid:"#orderSetBox"
    });

    // 初始化医嘱套表格
    $("#orderSetBox").datagrid({
        fit: true,
        title:"医嘱套",
        toolbar: "#orderSetTools",
        url: ANCSP.DataQuery,
        columns: [
            [
                { field: "CheckStatus", title: "选择", width: 60, checkbox:true },
                { field: "ArcimDesc", title: "名称", width: 200 },
                { field: "PackQty", title: "数量", width: 40,editor:{type:'numberbox'} },
                { field: "PackUomDesc", title: "单位", width: 60 }
            ]
        ],
        queryParams: {
            ClassName: CLCLS.BLL.OEOrder,
            QueryName: "FindOrderSetItems",
            ArgCnt: 1
        },
        onBeforeLoad: function(param) {
            param.Arg1=$("#filterOrderSet").combobox("getValue");
        },
        onClickCell:rowEditor.clickCell
    });

    

    // 添加医嘱项到麻醉物品
    $("#btnAddOrderSetItems").linkbutton({
        onClick:function(){
            if(rowEditor.endEditing()){
                var selectedItems=$("#orderSetBox").datagrid("getSelections");
                if(selectedItems && selectedItems.length>0){
                    var addRet=addAnaItems(selectedItems);
                    if(addRet.indexOf("S^")===0){
                        $.messager.alert("提示","添加麻醉物品成功！","info");
                        $("#anaestItemBox").datagrid("reload");
                    }else{
                        $.messager.alert("提示","添加麻醉物品失败，原因："+addRet,"error");
                    }
                }
            }
            
        }
    });
}

function initAnaestItemForm(){
    $("#anaestItemForm").form("clear");
    var today=(new Date()).format("yyyy-MM-dd");
    $("#TargetDate").datebox("setValue",today);
}

/**
 * 根据用户选择的医嘱套明细项，添加麻醉物品。
 * @param {Array} orderSetItems - 医嘱套明细项数组
 * @author chenchangqing 20190109
 */
function addAnaItems(orderSetItems){
    var anaItems=[],opsId="";
    // var selectedSchedule=$("#operListBox").datagrid("getSelected"),opsId="";
    // if(selectedSchedule){
    //     opsId=selectedSchedule.RowId;
    // }
    var targetDate=$("#TargetDate").datebox("getValue");
    var operRoom=$("#OperRoom").combobox("getValue");
    $.each(orderSetItems,function(index,item){
        anaItems.push({
            RowId:"",
            ClassName:ANCLS.Model.AnaestPreparation,
            OperSchedule:opsId,
            AnaDoctor:session.UserID,
            TargetDate:targetDate,
            ArcimID:item.ArcimID,
            CreateUser:session.UserID,
            UpdateUser:session.UserID,
            Dept:session.DeptID,
            PackQty:item.PackQty,
            PackUom:item.PackUom,
            DoseQty:item.DoseQty,
            DoseUom:item.DoseUom,
            OrderSetItem:item.RowId,
            Instruction:item.InstrId,
            RecvLoc:item.RecvLoc,
            Freq:item.Freq,
            Duration:item.Duration,
            Dept:session.DeptID,
            OperRoom:operRoom?operRoom:""
        });
    });

    var ret=dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:dhccl.formatObjects(anaItems)
    });
    return ret;
}

function addAnaItemRow(rowEditor){
    if (rowEditor.endEditing()){
        $('#anaestItemBox').datagrid('appendRow',{});
        rowEditor.editIndex = $('#anaestItemBox').datagrid('getRows').length-1;
        $('#anaestItemBox').datagrid('selectRow', rowEditor.editIndex)
                .datagrid('beginEdit', rowEditor.editIndex);
    }
}

function editAnaItem(rowEditor){
    if (rowEditor.endEditing()){
        $(rowEditor.dgSelector).datagrid("acceptChanges");
        var rowIndex=$(this).attr("data-rowindex");
        var rows=$(rowEditor.dgSelector).datagrid("getRows");
        var currentRow=rows[rowIndex];
        var saveRet=saveAnaItems([currentRow]);
        if(saveRet && saveRet.indexOf("S^")===0){
            $.messager.alert("提示","保存麻醉物品成功！","info");
            $("#anaestItemBox").datagrid("reload");
        }else{
            $.messager.alert("提示","保存麻醉物品失败，原因："+saveRet,"error");
        }
    }
}

function saveAnaItems(anaItems){
    $.each(anaItems,function(index,item){
        item.ClassName=ANCLS.Model.AnaestPreparation;
        if(!item.RowId || item.RowId===""){
            item.CreateUser=session.UserID;
        }
        item.UpdateUser=session.UserID;
    });

    var saveRet=dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:dhccl.formatObjects(anaItems)
    });

    return saveRet;
}

/**
 * 批量删除麻醉物品
 * @param {Array} selectedAnaItems - 用户选择的需要删除的麻醉物品
 * @author chenchangqing 20190109
 */
function removeAnaItems(selectedAnaItems){
    var removeAnaItems=[],removeRet="";
    
    
    $.each(selectedAnaItems,function(index,item){
        removeAnaItems.push({
            RowId:item.RowId,
            ClassName:ANCLS.Model.AnaestPreparation
        });
    });
    var paraStr=dhccl.formatObjects(removeAnaItems);
    removeRet=dhccl.removeDatas(paraStr);
    return removeRet;
    
}

function removeAnaItem(){
    var rowDataStr=$(this).attr("data-row");
    $.messager.confirm("确认","是否要删除选择的麻醉物品？",function(result){
        if(result){
            
            var rowData=JSON.parse(rowDataStr);
            if(rowData && rowData.RowId && rowData.RowId!==""){
                var removeRet=removeAnaItems([rowData]);
                if(removeRet && removeRet.indexOf("S^")===0){
                    $.messager.alert("提示","删除麻醉物品成功！","info");
                    $("#anaestItemBox").datagrid("reload");
                }else{
                    $.messager.alert("提示","删除麻醉物品失败，原因："+removeRet,"error");
                }
            }
        }
    });
    
}

$(document).ready(function(){
    initPage();
});