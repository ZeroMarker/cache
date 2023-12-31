function initPage(){
    initForm();
    initStockBox();
    initArticleBox();
}

function initForm(){
    var today=getDefaultDate();
    $("#startDate,#endDate").datebox("setValue",today);
    // 手术间
    $("#SFArcimID").combobox({
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
        mode:"remote"
    });

    $("#SFUom").combobox({
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

    $("#btnAdd,#btnEdit").linkbutton({
        onClick:saveStock
    });

    $("#btnDel").linkbutton({
        onClick:function(){
            var selectedRow=$("#stockBox").datagrid("getSelected");
            delStock([selectedRow]);
        }
    });

    $("#btnClear").linkbutton({
        onClick:function(){
            $("#stockForm").form("clear");
        }
    });

    $("#btnBatchRemove").linkbutton({
        onClick:function(){
            var selectedRows=$("#stockBox").datagrid("getSelections");
            delStock(selectedRows);
        }
    });

    $("#btnQuery").linkbutton({
        onClick:function(){
            $("#stockBox").datagrid("reload");
        }
    });
}

function initStockBox(){
    var columns=[[
        {field:"CheckStatus",title:"选择",width:60,checkbox:true},
        {field:"StockItemDesc",title:"耗材名称",width:160},
        {field:"Spec",title:"耗材规格",width:80},
        {field:"UomDesc",title:"耗材单位",width:80},
        {field:"StockCatDesc",title:"耗材类型",width:80},
        {field:"Qty",title:"入库数量",width:80},
        {field:"MFRDesc",title:"制造商",width:100},
        {field:"VendorDesc",title:"供应商",width:100},
        {field:"ExpiryDate",title:"有效期",width:180},
        {field:"BatchNo",title:"批号",width:80},
        {field:"BarCode",title:"条码号",width:180},
        {field:"SterilizationNo",title:"灭菌批号",width:80},
        {field:"RegCert",title:"注册证号",width:80},
        {field:"Note",title:"备注",width:80}
    ]];

    $("#stockBox").datagrid({
        headerCls:"panel-header-gray",
        iconCls:"icon-template",
        fit:true,
        title:"耗材入库明细",
        toolbar: "#stockTools",
        url: ANCSP.DataQuery,
        columns:columns,
        queryParams:{
            ClassName:CLCLS.BLL.StockManager,
            QueryName:"FindStockTransfer",
            Arg1:session.DeptID,
            Arg2:"",
            Arg3:"",
            Arg4:"",
            Arg5:"",
            ArgCnt:5
        },
        onBeforeLoad:function(param){
            param.Arg2=$("#filterStockItem").combobox("getValue");
            param.Arg3=$("#startDate").datebox("getValue");
            param.Arg4=$("#endDate").datebox("getValue");
            param.Arg5=$("#filterStockCat").combobox("getValue");
        },
        onSelect:function(index,row){
            $("#stockForm").form("load",row);
        },
        onBeginEdit:function(index,row){
            var editor=$(this).datagrid("getEditor",{
                index:index,
                field:"PrepareQty"
            });
            if(!editor) return;
            var rows=$(this).datagrid("getRows");
            $(editor.target).keydown(function(e){
                if (e.keyCode===38){
                    $("#stockBox").datagrid("acceptChanges");
                    if(index>0){
                        $("#stockBox").datagrid("beginEdit",index-1);
                        var preEditor=$("#stockBox").datagrid("getEditor",{
                            index:index-1,
                            field:"PrepareQty"
                        });
                        if(preEditor){
                            $(preEditor.target).focus();
                            $(preEditor.target).select();
                        }
                    }
                }
                if (e.keyCode===40){
                    $("#stockBox").datagrid("acceptChanges");
                    if(index<rows.length-1){
                        $("#stockBox").datagrid("beginEdit",index+1);
                        var preEditor=$("#stockBox").datagrid("getEditor",{
                            index:index+1,
                            field:"PrepareQty"
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
            if(changes.PrepareQty){
                $(this).datagrid("checkRow",index);
            }
        }
    });

    $("#stockBox").datagrid("enableCellEditing");
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
        title:"常用耗材",
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

function getDefaultDate(){
    var todayDate=new Date(),
        nextDateStr=todayDate.format("yyyy-MM-dd");
    return nextDateStr;
}

function saveBathStock(reservationList){
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
    
}

function saveStock(){
    var validation=$("#reservationForm").form("validate");
    if(!validation) return;
    var reservation=$("#reservationForm").serializeJson();
    var idSelector=$(this).attr("id");
    if(idSelector==="btnAddReservation"){
        reservation.RowId="";
    }
    var saveResult=saveBathStock([reservation]);
    if (saveResult.indexOf("S^")===0){
        $.messager.alert("提示","保存麻醉物品预约成功。","info");
        $("#reservationBox").datagrid("reload");
    }else{
        $.messager.alert("提示","保存麻醉物品预约失败。原因："+saveResult,"error");
    }
}

function delStock(reservationList){
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