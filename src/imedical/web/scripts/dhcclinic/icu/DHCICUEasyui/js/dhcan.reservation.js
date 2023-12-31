function initPage(){
    initForm();
    initReservationBox();
    initArticleBox();
}

function initForm(){
    // 默认手术日期
    var defOperDate=getDefaultOperDate();
    $("#AFOperDate,#filterOperDate,#RFOperDate").datebox("setValue",defOperDate);

    // 手术间
    $("#AFOperRoom,#filterOperRoom,#RFOperRoom").combobox({
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

    // 麻醉物品
    $("#RFArticle").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.NarcoticArticle;
            param.QueryName = "FindNarcoticArticle";
            param.Arg1 = param.q?param.q:"";
            param.Arg2="";
            param.Arg3="Y";
            param.ArgCnt = 3;
        },
        onSelect:function(record){
            $("#RFPackUom").combobox("setValue",record.Uom);
        },
        mode:"remote"
    });

    $("#RFPackUom").combobox({
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

    $("#RFResnProv,#AFResnProv").combobox({
        valueField: "UserId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1=param.q?param.q:"";
            param.Arg2=session.DeptID;
            param.ArgCnt = 2;
        },
        onLoadSuccess:function(data){
            initDefaultValue();
        },
        mode:"remote"
    });

    $("#btnAddReservation,#btnEditReservation").linkbutton({
        onClick:saveReservation
    });

    $("#btnDelReservation").linkbutton({
        onClick:function(){
            var selectedRow=$("#reservationBox").datagrid("getSelected");
            delReservation([selectedRow]);
        }
    });

    $("#btnClearReservation").linkbutton({
        onClick:function(){
            $("#reservationForm").form("clear");
        }
    });

    $("#btnBatchRemove").linkbutton({
        onClick:function(){
            var selectedRows=$("#reservationBox").datagrid("getChecked");
            delReservation(selectedRows);
        }
    });

    $("#btnAudit").linkbutton({
        onClick:function(){
            $("#reservationBox").datagrid("acceptChanges");
            var selectedRows=$("#reservationBox").datagrid("getSelections");
            if (selectedRows && selectedRows.length>0){
                var canAudit=true,message="";
                for(var i=0;i<selectedRows.length;i++){
                    var selectedRow=selectedRows[i];
                    $("#reservationBox").datagrid("endEdit",i);
                    if(isNaN(selectedRow.PrepareQty)){
                        canAudit=false;
                        message=selectedRow.ArticleDesc+"没有备货数量，不能审核。";
                        break;
                    }
                    selectedRow.Status="P";
                    selectedRow.UpdateUser=session.UserID;
                    selectedRow.PrepareProv=session.UserID;
                    selectedRow.ClassName=ANCLS.Model.Reservation;
                }
                if(canAudit){
                    var saveResult=saveBathReservation(selectedRows);
                    if (saveResult.indexOf("S^")===0){
                        $.messager.alert("提示","麻醉物品备货审核成功。","info");
                        $("#reservationBox").datagrid("reload");
                    }else{
                        $.messager.alert("提示","麻醉物品备货审核失败。原因："+saveResult,"error");
                    }
                }else{
                    $.messager.alert("提示",message,"warning");
                }
            }else{
                $.messager.alert("提示","请先选择需要备货审核的麻醉物品，再进行操作。","warning");
            }
        }
    });

    $("#btnQuery").linkbutton({
        onClick:function(){
            $("#reservationBox").datagrid("reload");
        }
    });

    $("#btnAddBatch").linkbutton({
        onClick:function(){
            var validation=$("#articleForm").form("validate");
            if(!validation) return;
            $("#articleBox").datagrid("acceptChanges");
            var selectedArticles=$("#articleBox").datagrid("getSelections");
            if(selectedArticles && selectedArticles.length>0){
                var reservationList=[];
                var operDate=$("#AFOperDate").datebox("getValue"),
                    operRoom=$("#AFOperRoom").combobox("getValue"),
                    resnProv=$("#AFResnProv").combobox("getValue");
                var canSave=true,message="";
                for(var i=0;i<selectedArticles.length;i++){
                    var article=selectedArticles[i];
                    if(!isNaN(article.PackQty)){
                        var packQty=Number(article.PackQty);
                        if(packQty<=0){
                            canSave=false;
                            message=article.Description+"数量为0，不能添加。";
                        }
                    }else{
                        canSave=false;
                        message=article.Description+"没有数量，不能添加。"
                    }
                    if(!canSave) break;
                    reservationList.push({
                        RowId:"",
                        OperDate:operDate,
                        OperRoom:operRoom,
                        Article:article.RowId,
                        Qty:article.PackQty,
                        Uom:article.Uom,
                        ResnProv:resnProv
                    });
                }
                if(canSave){
                    var saveResult=saveBathReservation(reservationList);
                    if (saveResult.indexOf("S^")===0){
                        $.messager.alert("提示","批量添加麻醉物品预约成功。","info");
                        $("#reservationBox").datagrid("reload");
                        $("#articleBox").datagrid("reload");
                    }else{
                        $.messager.alert("提示","批量添加麻醉物品预约失败。原因："+saveResult,"error");
                    }
                }else{
                    $.messager.alert("提示",message,"warning");
                }
                
            }else{
                $.messager.alert("提示","请先选择常用的麻醉物品，再进行操作。","warning");
            }
        }
    });
}

function initReservationBox(){
    var columns=[[
        {field:"CheckStatus",title:"选择",width:60,checkbox:true},
        {field:"OperDate",title:"手术日期",width:100},
        {field:"OperRoomDesc",title:"手术间",width:60},
        {field:"ArticleDesc",title:"麻醉物品",width:200},
        {field:"Qty",title:"预约数量",width:80},
        {field:"PrepareQty",title:"准备数量",width:80,editor:{type:"numberbox",options:{min:0,precision:1}},styler:function(value,row,index){
            if(row.Qty!==row.PrepareQty){
                return 'background-color:#ffee00;color:red;';
            }
        }},
        {field:"UomDesc",title:"单位",width:60},
        {field:"ResnProvDesc",title:"预约医生",width:80},
        {field:"ResnDT",title:"预约时间",width:180},
        {field:"PrepareProvDesc",title:"备货护士",width:80},
        {field:"PrepareDT",title:"备货时间",width:180},
        {field:"StatusDesc",title:"状态",width:80}
    ]];

    $("#reservationBox").datagrid({
        headerCls:"panel-header-gray",
        iconCls:"icon-template",
        fit:true,
        title:"麻醉物品预约列表",
        toolbar: "#reservationTools",
        singleSelect:true,
        checkOnSelect:false,
        selectOnCheck:false,
        url: ANCSP.DataQuery,
        columns:columns,
        queryParams:{
            ClassName:ANCLS.BLL.Reservation,
            QueryName:"FindReservation",
            Arg1:session.DeptID,
            Arg2:"",
            Arg3:"",
            Arg4:"",
            ArgCnt:4
        },
        onBeforeLoad:function(param){
            param.Arg2=$("#filterOperDate").datebox("getValue");
            param.Arg3=$("#filterOperRoom").combobox("getValue");
            param.Arg4=session.UserID;
        },
        onSelect:function(index,row){
            $("#reservationForm").form("load",row);
        }
        // onBeginEdit:function(index,row){
        //     var editor=$(this).datagrid("getEditor",{
        //         index:index,
        //         field:"PrepareQty"
        //     });
        //     if(!editor) return;
        //     var rows=$(this).datagrid("getRows");
        //     $(editor.target).keydown(function(e){
        //         if (e.keyCode===38){
        //             $("#reservationBox").datagrid("acceptChanges");
        //             if(index>0){
        //                 $("#reservationBox").datagrid("beginEdit",index-1);
        //                 var preEditor=$("#reservationBox").datagrid("getEditor",{
        //                     index:index-1,
        //                     field:"PrepareQty"
        //                 });
        //                 if(preEditor){
        //                     $(preEditor.target).focus();
        //                     $(preEditor.target).select();
        //                 }
        //             }
        //         }
        //         if (e.keyCode===40){
        //             $("#reservationBox").datagrid("acceptChanges");
        //             if(index<rows.length-1){
        //                 $("#reservationBox").datagrid("beginEdit",index+1);
        //                 var preEditor=$("#reservationBox").datagrid("getEditor",{
        //                     index:index+1,
        //                     field:"PrepareQty"
        //                 });
        //                 if(preEditor){
        //                     $(preEditor.target).focus();
        //                     $(preEditor.target).select();
        //                 }
        //             }
        //         }
        //     });
        // },
        // onEndEdit:function(index,row,changes){
        //     if(changes.PrepareQty){
        //         $(this).datagrid("checkRow",index);
        //     }
            
        // }
    });

    // $("#reservationBox").datagrid("enableCellEditing");
}

function initArticleBox(){
    var columns=[[
        {field:"CheckStatus",title:"选择",width:50,checkbox:true},
        {field:"Description",title:"麻醉物品",width:150},
        {field:"PackQty",title:"数量",width:60,editor:{type:"numberbox"}},
        {field:"UomDesc",title:"单位",width:50}
    ]];

    $("#articleBox").datagrid({
        headerCls:"panel-header-gray",
        iconCls:"icon-template",
        fit:true,
        title:"常用麻醉物品",
        toolbar: "#articleTools",
        url: ANCSP.DataQuery,
        columns:columns,
        queryParams:{
            ClassName:ANCLS.BLL.NarcoticArticle,
            QueryName:"FindNarcoticArticle",
            Arg1:"",
            Arg2:"",
            Arg3:"Y",
            ArgCnt:3
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
                    $("#articleBox").datagrid("acceptChanges");
                    if(index>0){
                        $("#articleBox").datagrid("beginEdit",index-1);
                        var preEditor=$("#articleBox").datagrid("getEditor",{
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
                    $("#articleBox").datagrid("acceptChanges");
                    if(index<rows.length-1){
                        $("#articleBox").datagrid("beginEdit",index+1);
                        var preEditor=$("#articleBox").datagrid("getEditor",{
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
            if(changes.PackQty){
                $(this).datagrid("checkRow",index);
            }
            
        }
    });

    $("#articleBox").datagrid("enableCellEditing");
}

function getDefaultOperDate(){
    var todayDate=new Date(),
        nextDate=todayDate.addDays(1),
        nextDateStr=nextDate.format("yyyy-MM-dd");
    return nextDateStr;
}

function saveBathReservation(reservationList){
    var saveResult="";
    if (reservationList && reservationList.length>0){
        for(var i=0;i<reservationList.length;i++){
            var reservation=reservationList[i];
            reservation.ClassName=ANCLS.Model.Reservation
            if (!reservation.RowId || reservation.RowId===""){
                reservation.Status="R";
                reservation.Dept=session.DeptID;
            }
            reservation.UpdateUser=session.UserID;
        }
        var reservationPara=dhccl.formatObjects(reservationList);
        saveResult=dhccl.saveDatas(ANCSP.DataListService,{
            jsonData:reservationPara,
            ClassName:ANCLS.BLL.Reservation,
            MethodName:"SaveReservation"
        });
    }
    return saveResult;
}

function initDefaultValue(){
    $("#AFResnProv,#RFResnProv").combobox("setValue",session.UserID);
}

function saveReservation(){
    var validation=$("#reservationForm").form("validate");
    if(!validation) return;
    var reservation=$("#reservationForm").serializeJson();
    var idSelector=$(this).attr("id");
    if(idSelector==="btnAddReservation"){
        reservation.RowId="";
    }
    var saveResult=saveBathReservation([reservation]);
    if (saveResult.indexOf("S^")===0){
        $.messager.alert("提示","保存麻醉物品预约成功。","info");
        $("#reservationBox").datagrid("reload");
    }else{
        $.messager.alert("提示","保存麻醉物品预约失败。原因："+saveResult,"error");
    }
}

function delReservation(reservationList){
    if (reservationList && reservationList.length>0){
        var canDel=true,message="";
        $.messager.confirm("提示","是否作废选择的麻醉物品?",function(r){
            if(r===false) return;
            for(var i=0;i<reservationList.length;i++){
                var reservation=reservationList[i];
                if (reservation.Status==="P"){
                    canDel=false;
                    message=reservation.ArticleDesc+"已备货，不能作废。";
                    break;
                }
                reservation.ClassName=ANCLS.Model.Reservation;
                reservation.Status="C";
                reservation.UpdateUser=session.UserID;
            }
            if(canDel){
                var reservationPara=dhccl.formatObjects(reservationList);
                var saveResult=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:reservationPara,
                    ClassName:ANCLS.BLL.Reservation,
                    MethodName:"SaveReservation"
                });
                if (saveResult.indexOf("S^")===0){
                    $.messager.alert("提示","麻醉物品作废成功。","info");
                    $("#reservationBox").datagrid("reload");
                }else{
                    $.messager.alert("提示","麻醉物品作废失败。原因："+saveResult,"error");
                }
            }else{
                $.messager.alert("提示",message,"warning");
            }
        });
        
    }else{
        $.messager.alert("提示","请先选择需要作废的麻醉物品，再进行操作。","warning");
    }
}

$(document).ready(initPage);