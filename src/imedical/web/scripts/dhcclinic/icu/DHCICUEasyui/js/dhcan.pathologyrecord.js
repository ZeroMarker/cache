var pathRecord={
    operSchedule:null
};
function initPage(){
    initPathologyRecordBox();
    initSpecimenBox();
    
}

function initPathologyRecordBox(){
    var columns=[[
        {field:"ItemDesc",title:"名称",width:160},
        {field:"CreateDT",title:"时间",width:160}
    ]];

    $("#pathologyRecordBox").datagrid({
        fit:true,
        title:"病理申请列表",
        headerCls:"panel-header-gray",
        iconCls:"icon-template",
        columns:columns,
        singleSelect:true,
        url:ANCSP.MethodService,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.Pathology;
            param.MethodName="GetPathologyAppInfo";
            param.Arg1=session.EpisodeID;
            param.ArgCnt=1;
        },
        onSelect:function(index,row){
            loadPISAppInfo(row);
            $("#specimenBox").datagrid("reload",{
                // ClassName:ANCLS.BLL.Pathology,
                // QueryName:"FindSpecimen",
                Arg1:row.PisID
                // ArgCnt:1
            });
        }
    });
}

function initSpecimenBox(){
    var columns=[[
        {field:"CheckStatus",title:"选择",checkbox:true},
        {field:"Description",title:"标本名称",width:240,editor:{type:"validatebox"}},
        {field:"Qty",title:"标本数量",width:80,editor:{type:"numberbox"}},
        {field:"Note",title:"备注",width:360,editor:{type:"validatebox"}},
        {field:"StatusDesc",title:"状态",width:80},
        {field:"Operator",title:"<a href='#' id='btnAdd' class='hisui-linkbutton' data-options='iconCls:\"icon-add\",plain:true'></a>",
         formatter:function(value,row,index){
             if(row.Status==="R") return "";
            return "<a href='#' class='hisui-linkbutton remove-btns' data-options='iconCls:\"icon-remove\",plain:true' data-rowindex='"+index+"' data-rowid='"+(row.RowId?row.RowId:"")+"'></a>"
        }}
    ]];

    $("#specimenBox").datagrid({
        fit:true,
        headerCls:'panel-header-gray',
        toolbar:"#specimenTools",
        title:"标本信息",
        columns:columns,
        url:ANCSP.MethodService,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.Pathology;
            param.MethodName="GetPathSpecimenInfo";
            // param.Arg1="";
            param.ArgCnt=1;
        },
        onLoadSuccess:function(data){
            $(".remove-btns").linkbutton({
                onClick:removeSpecimenInfo
            });
        },
        onClickRow:function(rowIndex,rowData){
            if(rowData.Status!=="R"){
                $(this).datagrid("beginEdit",rowIndex);
            }
        }
    });

    $("#btnAdd").linkbutton({
        onClick:function(){
            var selectedApp=$("#pathologyRecordBox").datagrid("getSelected");
            if (!selectedApp){
                $.messager.alert("提示","请先选择病理申请记录，再进行添加。","warning");
                return;
            }
            $("#specimenBox").datagrid("appendRow",{
                Description:"",
                Qty:"",
                Note:""
            });
            var rows=$("#specimenBox").datagrid("getRows");
            if(rows && rows.length>0){
                $("#specimenBox").datagrid("beginEdit",rows.length-1);
            }
            $(".remove-btns").linkbutton({
                onClick:removeSpecimenInfo
            });
        }
    });

    $("#btnSave").linkbutton({
        onClick:function(){
            var selectedApp=$("#pathologyRecordBox").datagrid("getSelected");
            if(!selectedApp){
                $.messager.alert("提示","请先选择病理申请记录，再进行保存。","warning");
                return;
            }
            dhccl.endEditDataBox("specimenBox");
            var dg=$("#specimenBox");
            var rows=dg.datagrid("getRows");
            
            if(rows && rows.length>0){
                var specimenArr=[];
                for(var i=0;i<rows.length;i++){
                    var row=rows[i];
                    if(!row.Description || row.Status==="A") continue;
                    if(specimenArr.length===0){
                        specimenArr.push({
                            FlowID:selectedApp.No,
                            Frost:selectedApp.FrostFlag,
                            AppDate:selectedApp.CreateDate,
                            AppTime:selectedApp.CreateTime,
                            AppDoc:selectedApp.ApplyDocId,
                            EpisodeID:session.EpisodeID,
                            OrderDesc:selectedApp.ItemDesc,
                            OrderID:selectedApp.Oeori,
                            EMRRecord:selectedApp.MedRecord,
                            AdmDiagnosis:selectedApp.MedDiag,
                            SurgicalRecord:selectedApp.OperRes,
                            Infection:selectedApp.InfDisHis,
                            AppDept:selectedApp.ApplyLocId,
                            RecvDept:selectedApp.LocID,
                            EmgFlag:selectedApp.EmgFlag,
                            CommonFlag:selectedApp.CommonFlag,
                            OperSchedule:session.OPSID,
                            ExternalID:selectedApp.PisID,
                            ClassName:ANCLS.Model.PathologyRecord
                        });
                    }
                    specimenArr.push({
                        Description:row.Description,
                        RowId:(row.RowId?row.RowId:""),
                        Qty:row.Qty,
                        Note:row.Note,
                        ClassName:ANCLS.Model.Specimen,
                        UpdateUser:session.UserID,
                        SeqNo:(i+1),
                        Status:"N",
                        ExternalID:(row.ExternalID || '')
                    });
                }
                if(specimenArr.length>0){
                    var specimenData=dhccl.formatObjects(specimenArr);
                    var ret=dhccl.runServerMethod(ANCLS.BLL.Pathology,"SavePathologyRecord",specimenData);
                    if (ret.success){
                        $("#specimenBox").datagrid("reload");
                    }else{
                        $.messager.alert("提示","标本信息保存失败。原因："+ret.result,"error");
                    }
                }
            }
        }
    });

    $("#btnSubmit").linkbutton({
        onClick:function(){
            var selectedApp=$("#pathologyRecordBox").datagrid("getSelected");
            if (!selectedApp){
                $.messager.alert("提示","请先选择病理申请记录，再进行提交。","warning");
                return;
            }
            
            var checkedRows=$("#specimenBox").datagrid("getChecked");
            var savedAll=true;
            for(var i=0;i<checkedRows.length;i++){
                var dataRow=checkedRows[i];
                dataRow.ClassName=ANCLS.Model.Specimen;
                if(!dataRow.RowId || dataRow.RowId===""){
                    savedAll=false;
                }
            }
            if(savedAll===false){
                $.messager.alert("提示","勾选的标本信息存在未保存的标本信息，请先保存再提交。","warning");
                return;
            }
            if (checkedRows && checkedRows.length>0){
                $.messager.confirm("提示","是否要提交勾选的标本信息？",function(r){
                    if(r){
                        var dataPara=dhccl.formatObjects(checkedRows);
                        var ret=dhccl.runServerMethod(ANCLS.BLL.Pathology,"SubmitSpecimen",selectedApp.PisID,dataPara);
                        if(ret.success){
                            $("#specimenBox").datagrid("reload",{
                                Arg1:selectedApp.PisID
                            });
                            $("#specimenBox").datagrid("clearChecked");
                        }else{
                            $.messager.alert("提示","标本信息提交失败。原因："+ret.result,"error");
                        }
                    }
                })
            }else{
                $.messager.alert("提示","请先勾选需要提交的标本信息，再进行操作。","warning");
            }
        }
    });

    $("#btnPrintBarCode").linkbutton({
        onClick:function(){
            // 重新加载患者信息（有可能已换手术间）
            operDataManager.reloadPatInfo(function(appData){
                pathRecord.operSchedule=appData;
            });
            var selectedApp=$("#pathologyRecordBox").datagrid("getSelected");
            if (!selectedApp){
                $.messager.alert("提示","请先选择病理申请记录，再进行打印条码。","warning");
                return;
            } 
            var checkedRows=$("#specimenBox").datagrid("getChecked");
            var auditAll=true;
            for(var i=0;i<checkedRows.length;i++){
                var dataRow=checkedRows[i];
                if(dataRow.Status!=="A"){
                    auditAll=false;
                }
            }
            if(auditAll===false){
                $.messager.alert("提示","勾选的标本信息存在未提交的标本信息，请先提交再打印。","warning");
                return;
            }
            if (checkedRows && checkedRows.length>0){
                $.messager.confirm("提示","是否要打印勾选标本的条码？",function(r){
                    if(r){
                        printSpecimenTag(checkedRows,pathRecord.operSchedule,selectedApp);
                    }
                })
            }else{
                $.messager.alert("提示","请先勾选需要打印条码的标本信息，再进行操作。","warning");
            }
        }
    })
    // $("#specimenBox").datagrid("enableRowEditing");
}

function loadPISAppInfo(appData){
    if(appData){
        $("#OrderDesc").val(appData.ItemDesc);
        $("#AppDocDesc").val(appData.ApplyDocDesc);
        $("#EmgFlag").val(appData.EmgFlag==="Y"?"是":"否");
        $("#AppLocDesc").val(appData.ApplyLocDesc);
        $("#RecvDeptDesc").val(appData.LocDesc);
        $("#FrozenDesc").val(appData.FrostFlag==="Y"?"是":"否");
        $("#MedRecord").val(appData.MedRecord);
        $("#OperRes").val(appData.OperRes);
    }
}

function removeSpecimenInfo(){
    var rowIndex=$(this).attr("data-rowindex");
    var rowId=$(this).attr("data-rowid");
    if(rowIndex>=0){
        $.messager.confirm("提示","是否删除标本信息？",function(r){
            if(r){
                if(!rowId){
                    $("#specimenBox").datagrid("deleteRow",rowIndex);
                }else{
                    var ret=dhccl.runServerMethod(ANCLS.BLL.Pathology,"RemoveSpecimen",rowId);
                    if(ret.success){
                        $("#specimenBox").datagrid("deleteRow",rowIndex);
                    }else{
                        $.messager.alert("提示","标本信息删除失败。原因："+ret.result,"error");
                    }
                }
            }
        });
    }
}

function printSpecimenTag(specimenDatas,operSchedule,PISAppInfo){
    var lodop=getLodop();
    //if(lodop.SET_PRINTER_INDEX(PrintSetting.SpecimenManager.BarCodePrinter)){
        lodop.PRINT_INIT("病理标本标签");
        lodop.SET_PRINT_PAGESIZE(1, "5cm","3cm","");
        var basePos={x:5,y:5},startPos={x:basePos.x,y:basePos.y},lineHeight=17,fontHeight=15,barCodeSize={width:180,height:50};
        var maxWidth=180;
        var patInfo=operSchedule.PatName+" "+operSchedule.PatGender+" "+operSchedule.PatAge+" "+operSchedule.RegNo+" "+operSchedule.PatDeptDesc;
        for(var i=0;i<specimenDatas.length;i++){
            var specimenData=specimenDatas[i];
            if(i>0){
                lodop.NEWPAGE();
            }
            var specimenInfo=operSchedule.RoomDesc+" "+specimenData.SeqNo+"："+specimenData.Description+"_"+specimenData.Qty
            var specimenCode=PISAppInfo.Oeori+"-"+specimenData.SeqNo;
            specimenCode=specimenCode.replace("||","-");
            lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",fontHeight,patInfo);
            startPos.y+=lineHeight;
            lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,"100%",fontHeight,specimenInfo);
            startPos.y+=lineHeight;
            lodop.ADD_PRINT_BARCODE(startPos.y,startPos.x,barCodeSize.width,barCodeSize.height,"128A",specimenCode);
            startPos.y+=barCodeSize.height+5;
            lodop.ADD_PRINT_TEXT(startPos.y,startPos.x,maxWidth,fontHeight,PISAppInfo.ItemDesc);
            lodop.SET_PRINT_STYLEA(0,"Alignment",2); 
            startPos.x=basePos.x;
            startPos.y=basePos.y;
        }
        lodop.PREVIEW();
    //}

}

$(document).ready(initPage);