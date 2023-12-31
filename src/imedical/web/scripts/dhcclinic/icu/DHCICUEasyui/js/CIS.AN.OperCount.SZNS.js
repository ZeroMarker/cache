var operRecord={
    opts:{},
    init:function(){
        operRecord.initDefaultValue();
        operRecord.loadCommonData();
        operRecord.initFormOptions();

        operDataManager.initFormData(operRecord.initOperSchedule);
        operDataManager.setCheckChange();
        SignTool.loadSignature();

        operCount.initInstrumentsBox();
        operCount.initSurgicalKitOptions();

        operList.initOperBox();
        operList.loadOperList();
        operActions.initOperActions();
        operActions.changeActionEnable();

        formControls.disableSomeControls();
        formControls.changeControlsEnable();
        formControls.changeOperTimeReadonly();
        
        operRecord.setOperNurseDefVal();
        operRecord.loadOperNurse();
        operRecord.loadOperNurseShift();

        // 每10秒保存一次数据
        //setInterval("operRecord.saveOperRegister(true)",10000);
    },

    initOperSchedule:function(schedule){
        operRecord.opts.schedule=schedule;
        var scrubNurse=operRecord.opts.schedule.ScrubNurse || '';
        var scrubNurseArr=scrubNurse.split(",");
        var circualNurse=operRecord.opts.schedule.CircualNurse || '';
        var circualNurseArr=circualNurse.split(",");
        operRecord.opts.schedule.FirstScrubNurse=scrubNurseArr[0];
        operRecord.opts.schedule.SecondScrubNurse=scrubNurseArr.length>1?scrubNurseArr[1]:"";
        operRecord.opts.schedule.FirstCircualNurse=circualNurseArr[0];
        operRecord.opts.schedule.SecondCircualNurse=circualNurseArr.length>1?circualNurseArr[0]:"";
        $("#operNurForm").form("load",schedule);
    },

    initDefaultValue:function(){
        $(".liquid,.blood,.liquid-out").val("0");
    },

    initFormOptions:function(){
        $(".oper-nurse").combobox({
            valueField:"RowId",
            textField:"Description",
            data:operRecord.opts.careProvs,
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                param.ClassName=CLCLS.BLL.Admission;
                param.QueryName="FindCareProvByLoc";
                param.Arg1=param.q?param.q:"";
                param.Arg2=session.DeptID;
                param.ArgCnt=2;
            },
            onLoadSuccess:function(data){
                // if(data && data.length===1){
                //     $(this).combobox("setValue",data[0].RowId);
                //     $(this).combobox("hidePanel");
                // }
            },
            mode:"remote",
            onChange:function(newValue,oldValue){
                var id=$(this).attr("id");
                if(id==="SecondScrubNurse"){
                    if(newValue){
                        formControls.setScrubShiftEnable(true);
                    }else{
                        formControls.setScrubShiftEnable(false);
                        formControls.clearScrubShiftData();
                    }
                    
                }else if(id==="SecondCircualNurse"){
                    if(newValue){
                        formControls.setCircualShiftEnable(true);
                    }else{
                        formControls.setCircualShiftEnable(false);
                        formControls.clearCircualShiftData();
                    }
                    
                }
            }
        });
    
        $("#ABO").combobox({
            valueField:"Description",
            textField:"Description",
            data:operRecord.opts.ABO
        });
    
        $("#RH").combobox({
            valueField:"Description",
            textField:"Description",
            data:operRecord.opts.RHD
        });
    
        $("#OperSeq").combobox({
            valueField:"Description",
            textField:"Description",
            data:operRecord.opts.operSeqList
        });
    
        
        $("#OperRoom").combobox({
            editable:false,
            valueField:"RowId",
            textField:"Description",
            data:operRecord.opts.operRooms
        });
    
        $("#AnaMethod").combobox({
            valueField:"RowId",
            textField:"Description",
            data:operRecord.opts.anaMethodList
        });
        // $(".opertime").each(function(index,item){
        //     if(!$(this).val()){
        //         $(this).attr("readonly",true);
        //     }
        // });

        // $(".opertime").change(function(){
        //     if(!$(this).val()){
        //         $(this).attr("readonly",true);
        //     }else{
        //         $(this).removeAttr("readonly");
        //     }
        // });
        $(".opertime").on("input",function(){
            if(!$(this).val()){
                $(this).attr("readonly",true);
            }
        });
    
        $(".opertime").dblclick(function(){
            if($(this).val()) return;
            var now=(new Date()).format("HH:mm");
            $(this).val(now);
            $(this).removeAttr("readonly");
        });

        $("#PatArriveTime").dblclick(function(){
            if($(this).val()) return;
            var now=(new Date()).format("HH:mm");
            var firstPatArriveTime="07:45";
            var isFirstOper=dhccl.runServerMethodNormal(ANCLS.BLL.OperCount,"GetFirstArriveOper",session.RecordSheetID,"PatArriveTime",firstPatArriveTime);
            if(isFirstOper==="Y"){
                $(this).val(firstPatArriveTime)
            }else{
                $(this).val(now);
            }
            
            $(this).removeAttr("readonly");
        });
    },

    loadCommonData:function(){
        var operDeptID="";
        if(operRecord.opts.schedule){
            operDeptID=operRecord.opts.schedule.OperDeptID || '';
        }
        var queryPara = [{
            ListName: "anaMethodList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindAnaestMethod",
            Arg1:"",
            ArgCnt: 1
        },
        {
            ListName: "careProvs",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindCareProvByLoc",
            Arg1:"",
            Arg2:session.DeptID,
            ArgCnt: 2
        },
        {
            ListName: "operSeqList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDictDataByCode",
            Arg1:"OperSeq",
            ArgCnt: 1
        },
        {
            ListName: "ABO",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDictDataByCode",
            Arg1:"ABO",
            ArgCnt: 1
        },
        {
            ListName: "RHD",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDictDataByCode",
            Arg1:"RHD",
            ArgCnt: 1
        },
        {
            ListName: "sourceType",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindDictDataByCode",
            Arg1:"SourceType",
            ArgCnt: 1
        },
        {
            ListName: "operClassList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindOperClass",
            ArgCnt: 0
        },
        {
            ListName: "bodySiteList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBodySite",
            ArgCnt: 0
        },
        {
            ListName: "bladeTypeList",
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBladeType",
            ArgCnt: 0
        },
        {
            ListName: "appDepts",
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindLocationOld",
            Arg1:"",
            Arg2:"INOPDEPT^OUTOPDEPT^EMOPDEPT",
            ArgCnt: 2
        },
        {
            ListName: "operRooms",
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindOperRoom",
            Arg1:operDeptID,
            Arg2:"R",
            ArgCnt: 2
        }];
    
        var queryData = dhccl.getDatas(ANCSP.DataQueries, {
            jsonData: dhccl.formatObjects(queryPara)
        }, "json");
        if (queryData) {
            for (var key in queryData) {
                operRecord.opts[key] = queryData[key];
            }
        }
    },

    /**
     * 获取手术护士
     */
    getOperNurse:function(){
        var firstScrubNurse=$("#FirstScrubNurse").combobox("getValue");
        var secondScrubNurse=$("#SecondScrubNurse").combobox("getValue");
        var scrubNurses=[firstScrubNurse];
        if(secondScrubNurse){
            scrubNurses.push(secondScrubNurse);
        }
        
        var firstCircualNurse=$("#FirstCircualNurse").combobox("getValue");
        var secondCircualNurse=$("#SecondCircualNurse").combobox("getValue");
        var circualNurses=[firstCircualNurse];
        if(secondCircualNurse){
            circualNurses.push(secondCircualNurse);
        }

        var ScrubAssistant=$("#ScrubAssistant").combobox("getValue");
		
        var CircualAssistant=$("#CircualAssistant").combobox("getValue");
		
        return {ScrubNurse:scrubNurses.join(","),CircualNurse:circualNurses.join(","),ScrubAssistant,CircualAssistant};
    },

    /**
     * 获取手术护士的交接班信息
     */
    getOperNurseShift:function(){
        var shiftList=[];
        var firstScrubNurse=$("#FirstScrubNurse").combobox("getValue");
        var secondScrubNurse=$("#SecondScrubNurse").combobox("getValue");

        if(secondScrubNurse){
            var scrubShiftTime=$("#ScrubShiftTime").val();
            if(scrubShiftTime){
                shiftList.push({
                    OperSchedule:operRecord.opts.schedule.OPSID,
                    ShiftCareProvID:firstScrubNurse,
                    ReliefCareProvID:secondScrubNurse,
                    ShiftDate:operRecord.opts.schedule.OperDate,
                    ShiftTime:scrubShiftTime,
                    ShiftType:"SN",
                    CareProvDept:session.DeptID,
                    UpdateUser:session.UserID,
                    ClassName:ANCLS.Model.OperShift
                });
            }
        }
        var firstCircualNurse=$("#FirstCircualNurse").combobox("getValue");
        var secondCircualNurse=$("#SecondCircualNurse").combobox("getValue");
        if(secondCircualNurse){
            var circualShiftTime=$("#CircualShiftTime").val();
            if(circualShiftTime){
                shiftList.push({
                    OperSchedule:operRecord.opts.schedule.OPSID,
                    ShiftCareProvID:firstCircualNurse,
                    ReliefCareProvID:secondCircualNurse,
                    ShiftDate:operRecord.opts.schedule.OperDate,
                    ShiftTime:circualShiftTime,
                    ShiftType:"CN",
                    CareProvDept:session.DeptID,
                    UpdateUser:session.UserID,
                    ClassName:ANCLS.Model.OperShift
                });
            }
        }

        return shiftList;
    },


    loadOperNurseShift:function(){
        var shiftList=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:ANCLS.BLL.DataQueries,
            QueryName:"FindOperShift",
            Arg1:session.OPSID,
            Arg2:session.DeptID,
            Arg3:"SN^CN",
            ArgCnt:3
        },"json");
        if(shiftList && shiftList.length>0)
        {
            for(var i=0;i<shiftList.length;i++){
                var shift=shiftList[i];
                if(shift.ShiftType==="SN"){
                    $("#ScrubShiftTime").val(shift.ShiftTime);
                }else if(shift.ShiftType="CN"){
                    $("#CircualShiftTime").val(shift.ShiftTime);
                }
            }
        }
    },

    loadOperNurse:function(){
        $("#FirstScrubNurse").combobox("setValue",operRecord.opts.schedule.FirstScrubNurse);
        $("#SecondScrubNurse").combobox("setValue",operRecord.opts.schedule.SecScrubNurse);

        $("#FirstCircualNurse").combobox("setValue",operRecord.opts.schedule.FirstCircualNurse);
        $("#SecondCircualNurse").combobox("setValue",operRecord.opts.schedule.SecCirNurse);
    },

    setOperNurseDefVal:function(){
        $("#ScrubAssistant").combobox("setValue",operRecord.opts.schedule.ScrubAssistant);
        $("#CircualAssistant").combobox("setValue",operRecord.opts.schedule.CircualAssistant)
    },

    /// 判断数据是否完整
    isDataIntegrity:function(){
        var messages=[];
        var dataIntegrity=operDataManager.isDataIntegrityNew(".operdata","<br>");
        if(!dataIntegrity.integrity){
            messages.push(dataIntegrity.message);
        }
        var operRows=$("#operBox").datagrid("getRows");
        if(!operRows || operRows.length<=0){
            messages.push("实施手术不能为空。");
        }

        var operRoom=$("#OperRoom").combobox("getValue");
        if(!operRoom){
            messages.push("手术间(房号)不能为空。");
        }

        var operSeq=$("#OperSeq").combobox("getValue");
        if(!operSeq){
            messages.push("台序不能为空。");
        }

        var circualSignUser=$("#CircualNurseSign").triggerbox("getValue");
        if(!circualSignUser){
            messages.push("手术护理记录巡回护士签名不能为空。");
        }

        var operCountIntegrity=operCount.isOperCountIntegrity();
        if(!operCountIntegrity.integrity){
            messages=messages.concat(operCountIntegrity.messages);
        }

        return {integrity:messages.length<=0,messages:messages}
    },

    /**
     * 判断实施手术是否完整
     */
    isOperIntegrity:function(){
        var operRows=$("#operBox").datagrid("getRows");
        var messages=[];
        for(var i=0;i<operRows.length;i++){
            var operRow=operRows[i];
            var curMsgs=[];
            if(!operRow.Operation){
                curMsgs.push("手术名称");
            }
            if(!operRow.OperClass){
                curMsgs.push("手术分级");
            }
            if(!operRow.BodySite){
                curMsgs.push("手术部位");
            }
            if(!operRow.SurgeonDeptID){
                curMsgs.push("术者科室");
            }
            if(!operRow.Surgeon){
                curMsgs.push("主刀医生");
            }
            if(curMsgs.length>0){
                messages.push("第"+(i+1)+"条手术："+curMsgs.join(",")+" 不能为空。");
            }
        }

        return {integrity:messages.length<=0,messages:messages};
    },

    saveOperRegister:function(ignoreSuccessMsg){
        operList.endEditDataGrid("operBox");
        operList.endEditDataGrid("instrumentsBox");
        var regFormData=$("#operNurForm").serializeJson();
        var operNurse=operRecord.getOperNurse();
        var operSchedule={
            RowId:operRecord.opts.schedule.RowId,
            OperRoom:regFormData.OperRoom,
            ArrOperRoom:regFormData.OperRoom,
            OperSeq:regFormData.OperSeq,
            ArrOperSeq:regFormData.OperSeq,
            ScrubNurse:operNurse.ScrubNurse,
            ArrScrubNurse:operNurse.ScrubNurse,
            CircualNurse:operNurse.CircualNurse,
            ArrCircualNurse:operNurse.CircualNurse,
            ScrubAssistant:operNurse.ScrubAssistant,
            CircualAssistant:operNurse.CircualAssistant,
            ClassName:ANCLS.Model.OperSchedule
        };
        var saveDatas=[operSchedule];
        // var anaesthesia={
        //     RowId:operRecord.opts.schedule.MainAnaesthesia,
        //     AnaMethod:regFormData.AnaMethod,
        //     //TheatreOutTransLoc:regFormData.TheatreOutTransLoc,
        //     ClassName:ANCLS.Model.Anaesthesia
        // }
        // saveDatas.push(anaesthesia);

        // var operDataList=$("#operBox").datagrid("getRows");
        // if(operDataList && operDataList.length>0){
        //     var operIntegrity=operRecord.isOperIntegrity();
        //     if(!operIntegrity.integrity){
        //         $.messager.alert("提示",operIntegrity.messages.join("\n"),"warning");
        //         return false;
        //     }
        // }
        // for (var i = 0; i < operDataList.length; i++) {
        //     const operation = operDataList[i];
        //     operation.ClassName=ANCLS.Model.OperList;
        //     operation.OperSchedule=operSchedule.RowId;
        //     operation.RowId="";
        //     saveDatas.push(operation);
        // }
        
        var shiftList=operRecord.getOperNurseShift();
        for (var i = 0; i < shiftList.length; i++) {
            saveDatas.push(shiftList[i]);
        }

        var operDatas = operDataManager.getFormOperDatas(".operdata");
        for (var i = 0; i < operDatas.length; i++) {
            const operData = operDatas[i];
            operData.ClassName=ANCLS.Model.OperData;
            operData.RecordSheet=session.RecordSheetID;
            saveDatas.push(operData);
        }

        var boxIdList=['instrumentsBox'];
        for (var i = 0; i < boxIdList.length; i++) {
            const boxId = boxIdList[i];
            var countDatas=operCount.getCountDatas(boxId);
            for (var j = 0; j < countDatas.length; j++) {
                const countData = countDatas[j];
                saveDatas.push(countData);
            }
        }

        var dataPara=dhccl.formatObjects(saveDatas);
        var ret=dhccl.runServerMethod(ANCLS.BLL.OperApplication,"SaveRegister",dataPara,session.UserID);
        if(ret.success){
            if(!ignoreSuccessMsg) $.messager.popover({msg: '保存数据成功！',type:'success',timeout: 1500});
            operDatas = operDataManager.getOperDatas();
            operDataManager.setFormOperDatas(operDatas);
            $("#operBox").datagrid("reload");
            // $("#operShiftBox").datagrid("reload");
            $("#instrumentsBox").datagrid("reload");
            return true;
        }else{
            $.messager.alert("提示","保存数据失败，原因："+ret.result,"error");
            return false;
        }
    },

    submitOperRegister:function(){
        // 表单提交之前，保存数据
        var saveRes=operRecord.saveOperRegister(true);
        if(!saveRes) return;

        // 判断表单数据完整性
        var dataIntegrity=operRecord.isDataIntegrity();
        if(!dataIntegrity.integrity){
            $.messager.alert("提示",dataIntegrity.messages.join("<br>"),"warning");
            return;
        }

        var res=dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet,"SubmitSheet",session.RecordSheetID,session.UserID);
        if(res.indexOf("S^")===0){
            // 提交表单后，更改操作按钮的状态
            operActions.changeActionEnable();
            $.messager.popover({type:"success",timeout:1500,msg:"表单提交成功。"});
        }else{
            $.messager.alert("提示","表单提交失败，原因："+res,"error");
        }
    }
};

var operList={
    editIndex:-1,
    editData:null,
    firstEdit:false,

    initOperBox:function(){
        var _this=operList;
        var operationOptions=_this.getOperationOptions();
        var operClassOptions=_this.getOperClassOptions();
        var bladeTypeOptions=_this.getBladeTypeOptions();
        var bodySiteOptions=_this.getBodySiteOptions();
        var surgeonDeptOptions=_this.getSurgeonDeptOptions();
        var assistantOptions=_this.getAssistantOptions();
        var surgeonOptions=_this.getSurgeonOptions();
        $("#operBox").datagrid({
            iconCls:'icon-paper',
            bodyCls:"panel-header-gray",
            //toolbar:"#operTool",
            height:200,
            width:933,
            // nowrap:false,
            rownumbers:true,
            columns:[[
                //{field:"CheckStatus",title:"选择",checkbox:true},
                {field:"Operation",title:"手术名称",width:300,editor:{type:"combogrid",options:operationOptions},formatter:function(value,row,index){
                    return row.OperationDesc;
                }},
                {field:"OperNote",title:"手术备注",width:100,editor:{type:"validatebox"}},
                {field:"OperClass",title:"手术分级",width:76,editor:{type:"combobox",options:operClassOptions},formatter:function(value,row,index){
                    return row.OperClassDesc;
                }},
                {field:"BodySite",title:"手术部位",width:96,editor:{type:"combobox",options:bodySiteOptions},formatter:function(value,row,index){
                    return row.BodySiteDesc;
                }},
                {field:"SurgeonDeptID",title:"术者科室",width:100,editor:{type:"combobox",options:surgeonDeptOptions},formatter:function(value,row,index){
                    return row.SurgeonDeptDesc;
                }},
                {field:"Surgeon",title:"主刀医生",width:76,editor:{type:"combobox",options:surgeonOptions},formatter:function(value,row,index){
                    return row.SurgeonDesc;
                }},
                {field:"Assistant",title:"手术助手",width:112,editor:{type:"combobox",options:assistantOptions},formatter:function(value,row,index){
                    return row.AssistantDesc;
                }}
                // {field:"BladeType",title:"切口类型",width:76,editor:{type:"combobox",options:bladeTypeOptions},formatter:function(value,row,index){
                //     return row.BladeTypeDesc;
                // }}
            ]],
            onBeforeEdit:function(rowIndex,rowData){
                _this.editIndex=rowIndex;
                _this.editData=rowData;
                _this.firstEdit=true;
            },
            onAfterEdit:function(rowIndex,rowData,changes){
                _this.firstEdit=false;
            }
        });

       // $("#operBox").datagrid("enableCellEditing");

        $("#btnAddOperation").linkbutton({
            iconCls:"icon-add",
            plain:true,
            onClick:function(){
                operList.endEditDataGrid("operBox");
                $("#operBox").datagrid("appendRow",{
                    RowId:"",
                    Operation:"",
                    OperationDesc:"",
                    OperNote:"",
                    OperClass:"",
                    OperClassDesc:"",
                    BladeType:"",
                    BladeTypeDesc:"",
                    BodySite:"",
                    BodySiteDesc:"",
                    SurgeonDeptID:operRecord.opts.schedule.AppDeptID,
                    SurgeonDeptDesc:operRecord.opts.schedule.AppDeptDesc,
                    Surgeon:"",
                    SurgeonDesc:"",
                    Assistant:"",
                    AssistantDesc:"",
                    SurgeonExpert:"",
                    SKDOperID:""
                });
                var rows=$("#operBox").datagrid("getRows");
            }
        });

        $("#btnDelOperation").linkbutton({
            iconCls:"icon-remove",
            plain:true,
            onClick:function(){
                var selectedRow=$("#operBox").datagrid("getSelected");
                if(!selectedRow){
                    $.messager.alert("提示","请先选择需要删除的手术，再操作。","warning");
                }else{
                    $.messager.confirm("提示","是否删除选择的手术？",function(r){
                        if(r){
                            var rowIndex=$("#operBox").datagrid("getRowIndex",selectedRow);
                            $("#operBox").datagrid("deleteRow",rowIndex);
                        }
                    })
                    
                }
            }
        });
    },

    
    /**
     * 获取手术名称编辑控件的选项
     */
    getOperationOptions:function(){
        return {
            url: ANCSP.DataQuery,
            onBeforeLoad: function(param) {
                param.Arg4="";
                var rows=$("#operBox").datagrid("getRows");
                var rowData=rows[operList.editIndex];
                if(rows && rows.length>0 && operList.firstEdit && rowData.OperationDesc){
                    param.q=rowData.OperationDesc;
                    param.Arg4=rowData.Operation;
                    operList.firstEdit=false;
                }
                if(!param.q || param.q==="") return false;
                
                var surgeonDeptID=rowData.SurgeonDeptID || ''
                var surgeonID=rowData.Surgeon || '';
                
                param.ClassName = ANCLS.BLL.Operation;
                param.QueryName = "FindOperation";
                param.Arg1 = param.q?param.q:"";
                param.Arg2 = surgeonID;
                param.Arg3 = "";
                param.ArgCnt = 4;
            },
            panelWidth:600,
            panelHeight:400,
            idField: "RowId",
            textField: "Description",
            columns:[[
                {field:"RowId",title:"ID",hidden:true},
                {field:"Description",title:"名称",width:390},
                {field:"OperClassDesc",title:"分级",width:60},
                {field:"ICDCode",title:"ICD码",width:130},
                {field:"ExternalID",title:"ExternalID",hidden:true}
            ]],
            pagination:true,
            pageSize:10,
            mode: "remote",
            onSelect:function(rowIndex,rowData){
                operList.setComboboxFieldDesc(rowData,"OperationDesc","Description");
            }
        }
    },

    /**
     * 下拉框选择后，对表格的相应描述字段进行赋值。
     * 这样表格相应行结束编辑状态后，相应字段就不会显示成ID。
     * 相应字段显示方式参考列选项的formatter函数。
     * @param {object} record 下拉框选择项
     * @param {String} descField 表格描述字段
     * @param {String} textField 下拉框文本字段
     */
    setComboboxFieldDesc:function(record,descField,textField){
        var rows=$("#operBox").datagrid("getRows");
        var rowData=rows[operList.editIndex];
        if(rowData){
            rowData[descField]=record[textField];
        }
    },

    /**
     * 获取手术分级编辑控件的选项
     */
    getOperClassOptions:function(){
        return {
            valueField: "RowId",
            textField: "Description",
            data:operRecord.opts.operClassList,
            editable:false,
            onSelect:function(record){
                operList.setComboboxFieldDesc(record,"OperClassDesc","Description");
            }
        }
    },

    /**
     * 获取手术部位编辑控件的选项
     */
    getBodySiteOptions:function(){
        return {
            valueField: "RowId",
            textField: "Description",
            // data:operRecord.opts.bodySiteList,
            panelWidth:120,
            // filter:function(q,row){
            //     var filterDesc=q.toUpperCase();
            //     var desc=row.Description.toUpperCase();
            //     return (desc.indexOf(filterDesc)>=0)
            // },
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                var operId=operList.editData.Operation;
                param.ClassName=ANCLS.BLL.CodeQueries;
                param.QueryName="FindBodySiteByOper";
                param.Arg1=operId;
                param.ArgCnt=1;
            },
            onSelect:function(record){
                operList.setComboboxFieldDesc(record,"BodySiteDesc","Description");
            }
        }
    },

    /**
     * 获取术者科室编辑控件的选项
     */
    getSurgeonDeptOptions:function(){
        return {
            valueField: "RowId",
            textField: "Description",
            data:operRecord.opts.appDepts,
            panelWidth:120,
            filter:function(q,row){
                var filterDesc=q.toUpperCase();
                var desc=row.Description.toUpperCase();
                var alias=row.Alias.toUpperCase();
                return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
            },
            onSelect:function(record){
                operList.setComboboxFieldDesc(record,"SurgeonDeptDesc","Description");
                var operId=operList.editData.Operation;
                operList.loadSurgeons(operId,record.RowId);
                operList.loadAssistants(record.RowId);
            }
        }
    },

    /**
     * 获取手术助手编辑控件的选项
     */
    getAssistantOptions:function(){
        return {
            // data:operRecord.opts.appCareProvs,
            valueField: "RowId",
            textField: "Description",
            multiple:true,
            rowStyle:"checkbox",
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                var deptId=operList.editData.SurgeonDeptID;
                param.ClassName=CLCLS.BLL.Admission;
                param.QueryName="FindCareProvByLoc";
                param.Arg1="";
                param.Arg2=deptId;
                param.ArgCnt=2;
            },
            onSelect:function(record){
                var text=$(this).combobox("getText");
                operList.setComboboxFieldDesc({Description:text},"AssistantDesc","Description");
            }
        }
    },

    /**
     * 获取切口类型编辑控件的选项
     */
    getBladeTypeOptions:function(){
        return {
            valueField: "RowId",
            textField: "Description",
            data:operRecord.opts.bladeTypeList,
            editable:false,
            onSelect:function(record){
                operList.setComboboxFieldDesc(record,"BladeTypeDesc","Description");
            }
        }
    },

    /**
     * 获取手术医生编辑控件的选项
     */
    getSurgeonOptions:function(){
        return {
            //data:operRecord.opts.appCareProvs,
            valueField: "CareProvider",
            textField: "CareProvDesc",
            panelWidth:120,
            // filter:function(q,row){
            //     var filterDesc=q.toUpperCase();
            //     var desc=row.Description.toUpperCase();
            //     var alias=row.Alias.toUpperCase();
            //     return (desc.indexOf(filterDesc)>=0 || alias.indexOf(filterDesc)>=0)
            // },
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                var operId=operList.editData.Operation;
                var deptId=operList.editData.SurgeonDeptID;
                param.ClassName=ANCLS.BLL.ConfigQueries;
                param.QueryName="FindSurgeonByOper";
                param.Arg1=param.q?param.q:"";
                param.Arg2=deptId;
                param.Arg3="Y";
                param.Arg4=session.HospID;
                param.Arg5=operId;
                param.ArgCnt=5;
            },
            onSelect:function(record){
                operList.setComboboxFieldDesc(record,"SurgeonDesc","Description");
            },
            mode:"remote"
        }
    },

    /**
     * 加载手术医生
     */
    loadSurgeons:function(operId,deptId){
        var _this=operRecord;
        _this.opts.surgeons = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.ConfigQueries,
            QueryName: "FindSurgeonByOper",
            Arg1:"",
            Arg2:deptId,
            Arg3:"Y",
            Arg4:session.HospID,
            Arg5:operId,
            ArgCnt: 4
        }, "json");
    },

     /**
     * 加载手术助手
     */
    loadAssistants:function(deptId){
        var _this=operRecord;
        _this.opts.assistants = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: CLCLS.BLL.Admission,
            QueryName: "FindCareProvByLoc",
            Arg1:"",
            Arg2:deptId,
            ArgCnt: 2
        }, "json");
    },

    /**
     * 选择新的手术名称后，重新加载手术关联的部位选择项
     * @param {String} operId 手术名称ID
     */
    loadBodySites:function(operId){
        var _this=operRecord;
        _this.opts.bodySiteList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: "FindBodySiteByOper",
            Arg1:operId,
            ArgCnt: 1
        }, "json");
    },

    /**
     * 结束表格中所有单元格的编辑状态
     * @param {String} boxId 表格ID
     */
    endEditDataGrid:function(boxId){
        var rows=$('#'+boxId).datagrid('getRows');
        if(rows && rows.length>0){
            for (var i = 0; i < rows.length; i++) {
                const element = rows[i];
                $('#'+boxId).datagrid('endEdit',i);
            }
        }
    },

    /**
     * 重新加载手术名称列表
     */
    loadOperList:function(){
        var operList=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:ANCLS.BLL.OperationList,
            QueryName:"FindOperationList",
            Arg1:session.OPSID,
            ArgCnt:1
        },"json");
        if(operList && operList.length>0)
        {
            $("#operBox").datagrid("loadData",operList);
        }
    }
};

var operCount={
    editRow:{
        index:-1,
        data:null
    },
    initInstrumentsBox:function(){
        var columns=[[
            {field:"CheckStatus",title:"选择",checkbox:true},
            {field:"SurgicalMaterial",title:"手术物品ID",hidden:true},
            {field:"MaterialNote",title:"手术物品",width:200},
            {field:"PreopCount",title:"术前清点",width:120,editor:{type:"numberbox"},formatter:function(value,row,index){
                if(row.SurgicalMaterial==="CircualNurseSign" || row.SurgicalMaterial==="ScrubNurseSign"){
                    var valStr=""
                    if(value){
                        valStr="<span class='margin-bottom:5px;'>"+value+"</span>";
                    }
                    return "<a href='#' class='hisui-linkbutton signature-button' data-signtype='"+row.SurgicalMaterial+"' data-field='PreopCount' data-rowindex='"+index+"'></a>"+valStr;
                }

                return value;
            }},
            {field:"OperAddCount",title:"术中加数(数值)",hidden:true},
            {field:"AddCountDesc",title:"术中追加",width:160,editor:{type:"validatebox"},formatter:function(value,row,index){
                if(row.SurgicalMaterial==="CircualNurseSign" || row.SurgicalMaterial==="ScrubNurseSign"){
                    var valStr=""
                    if(value){
                        valStr="<span class='margin-bottom:5px;'>"+value+"</span>";
                    }
                    return "<a href='#' class='hisui-linkbutton signature-button' data-signtype='"+row.SurgicalMaterial+"' data-field='AddCountDesc' data-rowindex='"+index+"'></a>"+valStr;
                }

                return value;
            }},
            {field:"PreCloseCount",title:"关空腔脏器核对",width:120,editor:{type:"numberbox"},styler: function (value, row, index) {
                if(!operCount.operCountBalance(row,"PreCloseCount")){
                    return "background-color:#FFFFCC;";
                }
            },formatter:function(value,row,index){
                if(row.SurgicalMaterial==="CircualNurseSign" || row.SurgicalMaterial==="ScrubNurseSign"){
                    var valStr=""
                    if(value){
                        valStr="<span class='margin-bottom:5px;'>"+value+"</span>";
                    }
                    return "<a href='#' class='hisui-linkbutton signature-button' data-signtype='"+row.SurgicalMaterial+"' data-field='PreCloseCount' data-rowindex='"+index+"'></a>"+valStr;
                }

                return value;
            }},
            {field:"PostCloseCount",title:"关切口前核对",width:120,editor:{type:"numberbox"},styler: function (value, row, index) {
                if(!operCount.operCountBalance(row,"PostCloseCount")){
                    return "background-color:#FFFFCC;";
                }
            },formatter:function(value,row,index){
                if(row.SurgicalMaterial==="CircualNurseSign" || row.SurgicalMaterial==="ScrubNurseSign"){
                    var valStr=""
                    if(value){
                        valStr="<span class='margin-bottom:5px;'>"+value+"</span>";
                    }
                    return "<a href='#' class='hisui-linkbutton signature-button' data-signtype='"+row.SurgicalMaterial+"' data-field='PostCloseCount' data-rowindex='"+index+"'></a>"+ valStr;
                }

                return value;
            }},
            {field:"PostSewCount",title:"关切口后核对",width:120,editor:{type:"numberbox"},styler: function (value, row, index) {
                if(!operCount.operCountBalance(row,"PostSewCount")){
                    return "background-color:#FFFFCC;";
                }
            },formatter:function(value,row,index){
                if(row.SurgicalMaterial==="CircualNurseSign" || row.SurgicalMaterial==="ScrubNurseSign"){
                    var valStr=""
                    if(value){
                        valStr="<span class='margin-bottom:5px;'>"+value+"</span>";
                    }
                    return "<a href='#' class='hisui-linkbutton signature-button' data-signtype='"+row.SurgicalMaterial+"' data-field='PostSewCount' data-rowindex='"+index+"'></a>"+valStr;
                }

                return value;
            }}
        ]];
    
        $("#instrumentsBox").datagrid({
            fit:true,
            border: false,
            //title:"手术清点记录",
            // border:false,
            headerCls:"panel-header-gray",
            checkOnSelect:false,
            selectOnCheck:false,
            singleSelect: false,
            pagination: false,
            //iconCls:"icon-paper",
            url: ANCSP.DataQuery,
            toolbar: "#instrumentsTool",
            columns: columns,
            // rowStyler: function(index, row) {
            //     if(!operCount.operCountBalance(row)){
            //         return "background-color:yellow;";
            //     }
            // },
            queryParams: {
                ClassName: ANCLS.BLL.DataQueries,
                QueryName: "FindSurInventory",
                Arg1: session.RecordSheetID,
                ArgCnt: 1
            },
            onClickCell: function(index, field, value) {
                var countDatas=$(this).datagrid("getRows");
                if(countDatas && countDatas.length>0){
                    var id=$(this).attr("id");
                    //operCount.genCountData(id,field,countDatas);
                }
                operCount.renderSignButton();
            },
            onBeginEdit: function(rowIndex, rowData) {
                if(rowData.SurgicalMaterial==="CircualNurseSign" || rowData.SurgicalMaterial==="ScrubNurseSign"){
                    //$(this).datagrid("disableCellEditing");
                    // return false;
                    $(this).datagrid("cancelEdit",rowIndex);
                }else{
                    //$(this).datagrid("enableCellEditing");
                    var editor = $(this).datagrid("getEditor", {
                        index: rowIndex,
                        field: "AddCountDesc"
                    });
                    operCount.calcAddCount(editor,rowData);
                }
                operCount.editRow.data=rowData;
                operCount.editRow.index=rowIndex;
            },
            onLoadSuccess: function(data) {
                $(this).datagrid("clearChecked");
                operCount.appendSignRows();
                operCount.renderSignButton();
            }
        });
    
        $("#instrumentsBox").datagrid("enableCellEditing");

    },

    renderSignButton:function(){
        $(".signature-button").linkbutton({
            iconCls:"icon-write-order",
            plain:true,
            onClick:function(){
                var countRows=$("#instrumentsBox").datagrid("getRows");
                var rowIndex=$(this).attr("data-rowindex");
                var field=$(this).attr("data-field");
                var countData=operCount.getCountDatas("instrumentsBox");
                if(!countData || countData.length<=0){
                    return;
                }
                var countRow=countRows[rowIndex];
                if(countRow.SurgicalMaterial==="ScrubNurseSign" || countRow.SurgicalMaterial==="CircualNurseSign"){
                    var title=countRow.SurgicalMaterial==="ScrubNurseSign"?"洗手护士":"巡回护士";
                    var signCode=field+(countRow.SurgicalMaterial==="ScrubNurseSign"?"SNS":"CNS");
                    switch(field){
                        case "PreopCount":
                            title+="术前清点签名";
                            break;
                        case "AddCountDesc":
                            title+="术中追加签名";
                            break;
                        case "PreCloseCount":
                            title+="关空腔脏器前核对签名";
                            break;
                        case "PostCloseCount":
                            title+="关切口前核对签名";
                            break;
                        case "PostSewCount":
                            title+="关切口后核对签名";
                            break;    
                    }
                    
                    var CareProvType="NURSE";
                    var originalData = JSON.stringify(operCount.getCountDatas("instrumentsBox"));
                    var CASign=new CASignature({
                        title:title || "",
                        contentData:originalData,
                        signCode:signCode,
                        signBox:"#"+signCode,
                        signRow:{
                            data:countRow,
                            index:rowIndex,
                            field:field
                        },
                        imgBox:"#"+signCode+"Image",
                        CareProvType:CareProvType,
                        afterSign:function(signRow,signUserName){
                            signRow.data[field]=signUserName;
                            $("#instrumentsBox").datagrid("refreshRow",signRow.index);
                            operCount.renderSignButton();
                        }
                        //afterSignCallBack:afterSignCallBack
                    });
                    CASign.open();
                }
            }
        });
    },

    appendSignRows:function(){
        var signatureList=SignTool.getSignatureList();
        $("#instrumentsBox").datagrid("appendRow",{
            SurgicalMaterial: "ScrubNurseSign",
            SurgicalMaterialDesc: "洗手护士签名",
            MaterialNote: "洗手护士签名",
            PreopCount: getSignUserNameByCode("PreopCountSNS"),
            AddCountDesc: getSignUserNameByCode("AddCountDescSNS"),
            PreCloseCount: getSignUserNameByCode("PreCloseCountSNS"),
            PostCloseCount: getSignUserNameByCode("PostCloseCountSNS"),
            PostSewCount: getSignUserNameByCode("PostSewCountSNS"),
            BarCode: "",
            InventoryType:""
        });

        $("#instrumentsBox").datagrid("appendRow",{
            SurgicalMaterial: "CircualNurseSign",
            SurgicalMaterialDesc: "巡回护士签名",
            MaterialNote: "巡回护士签名",
            PreopCount: getSignUserNameByCode("PreopCountCNS"),
            AddCountDesc: getSignUserNameByCode("AddCountDescCNS"),
            PreCloseCount: getSignUserNameByCode("PreCloseCountCNS"),
            PostCloseCount: getSignUserNameByCode("PostCloseCountCNS"),
            PostSewCount: getSignUserNameByCode("PostSewCountCNS"),
            BarCode: "",
            InventoryType:""
        });

        function getSignUserNameByCode(signCode){
            var userName="";
            if(signatureList && signatureList.length>0){
                for(var i=0;i<signatureList.length;i++){
                    var signature=signatureList[i];
                    if(signCode===signature.SignCode){
                        userName=signature.FullName;
                    }
                }
            }
            return userName;
        }
    },

    /**
     * 初始化手术包和手术物品可选项。
     */
    initSurgicalKitOptions:function(){
        $("#ISurgicalKit").combobox({
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
            onSelect:function(record){
                var id=$(this).attr("id");
                operCount.selectedSurgicalKit(id,"手术包",record,"instrumentsBox");
            }
        });

        $("#SurgicalKitBox").datagrid({
            fit: true,
            singleSelect: false,
            checkOnSelect:false,
            selectOnCheck:false,
            rownumbers: true,
            headerCls:"panel-header-gray",
            bodyCls:"panel-header-gray",
            // style:{"border-color":"#333"},
            url: ANCSP.DataQuery,
            toolbar: "",
            columns: [[{
                        field: "CheckStatus",
                        title: "选择",
                        width: 60,
                        checkbox: true
                    },{
                        field: "SurgicalMaterial",
                        title: "SurgicalMaterial",
                        width: 100,
                        hidden: true
                    },{
                        field: "SurgicalMaterialDesc",
                        title: "项目名称",
                        width: 120
                    },{
                        field: "DefaultQty",
                        title: "数量",
                        width: 80
                    }]],
            onBeforeLoad: function(param) {
                param.ClassName = ANCLS.BLL.CodeQueries;
                param.QueryName = "FindSurKitMaterial";
                var surKitId = $("#ISurgicalKit").combobox("getValue");
                param.Arg1 = surKitId;
                param.ArgCnt = 1;
            },
            onLoadSuccess:function(data){
                $(this).datagrid("checkAll");
            }
        });

        $("#ISurgicalItem").combobox({
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
                var id=$(this).attr("id");
                operCount.addSurgicalItem("instrumentsBox",id,record,"I");
            }
        });

        $("#btnAddISurgicalItem").linkbutton({
            onClick:function(){
                var id=$(this).attr("id");
                var itemDesc=$("#ISurgicalItem").combobox("getText");
                if(!itemDesc) return;
                var record={
                    RowId:"",
                    Description:itemDesc,
                    AddCountDesc:"",
                    PreopCount:1,
                    PreCloseCount:"",
                    PostCloseCount:"",
                    PostSewCount:""
                }
                operCount.addSurgicalItem("instrumentsBox","ISurgicalItem",record,"I");
            }
        });

        $("#btnDelISurgicalItem").linkbutton({
            onClick:function(){
                var buttonId=$(this).attr("id");
                var boxId="instrumentsBox";
                var boxSelector="#"+boxId;
                var checkedRows=$(boxSelector).datagrid("getChecked");
                if(checkedRows && checkedRows.length>0){
                    $.messager.confirm("确认", "是否删除勾选清点记录？", function(result) {
                        if (result) {
                            operCount.delCountRecord(boxId,checkedRows);
                        }
                    });
                }else{
                    $.messager.alert("提示","请先勾选需要删除的清点记录，再进行操作。","warning");
                }
            }
        });

        $("#btnConfirmKit").linkbutton({
            onClick:function(){
                var opts=$("#surKitDialog").dialog("options");
                var countBoxId=opts.countBoxId;
                var comboBoxId=opts.comboBoxId;
                var kitItems=$("#SurgicalKitBox").datagrid("getChecked");
                if (kitItems && kitItems.length>0 && countBoxId){
                    for (var i = 0; i < kitItems.length; i++) {
                        const kitItem = kitItems[i];
                        var countItem=operCount.existsSurgicalItem(countBoxId,kitItem.SurgicalMaterial);
                        if(countItem.existence){
                            var addCountDesc=countItem.rowData.AddCountDesc?countItem.rowData.AddCountDesc:"";
                            countItem.rowData.AddCountDesc=addCountDesc+(addCountDesc?"+":"")+kitItem.DefaultQty;
                            countItem.rowData.OperAddCount=operCount.calExp(countItem.rowData.AddCountDesc);
                            $("#"+countBoxId).datagrid("refreshRow",countItem.rowIndex);
                        }else{
                            var ivType="I";
                            if(countBoxId==="dressingsBox"){
                                ivType="D";
                            }
                            var countRows=$("#"+countBoxId).datagrid("getRows");
                            var index=countRows.length-2;
                            $("#"+countBoxId).datagrid("insertRow", {index:index,row:{
                                SurgicalMaterial: kitItem.SurgicalMaterial,
                                SurgicalMaterialDesc: kitItem.SurgicalMaterialDesc,
                                MaterialNote: kitItem.SurgicalMaterialDesc,
                                PreopCount: (kitItem.DefaultQty) ? kitItem.DefaultQty : 1,
                                AddCountDesc:"",
                                PreCloseCount:"",
                                PostCloseCount:"",
                                PostSewCount:"",
                                InventoryType:ivType
                            }});
                        }

                    }
                    $("#surKitDialog").dialog("close");
                    $("#"+comboBoxId).combobox("clear");
                }
            }
        });

        $("#btnExitKit").linkbutton({
            onClick:function(){
                $("#surKitDialog").dialog("close");
                var opts=$("#surKitDialog").dialog("options");
                // var countBoxId=opts.countBoxId;
                var comboBoxId=opts.comboBoxId;
                $("#"+comboBoxId).combobox("clear");
            }
        });
    },

    /**
     * 术中加数编辑框文本变化，重新计算术中加数。
     */
    calcAddCount:function(editor,rowData){
        if (editor && editor.target) {
            $(editor.target).change(function(e) {
                var addCountStr = $(this).val();
                var operAddCount = 0;
                if (addCountStr) {
                    var addCountArr = addCountStr.split("+");       // 用户在术中加数编辑框中输入的文本必须是以+拼接数字字符串，如：1+1+2+4 表示术中加了4次器械，第1次加了1把，第2次加了1把，第3次加了2把，第4次加了4把。
                    for (var index = 0; index < addCountArr.length; index++) {
                        var element = Number(addCountArr[index]);
                        if (!isNaN(element)) {
                            operAddCount += element;
                        }
                    }
                    rowData.OperAddCount = operAddCount;
                }
            });
        }
    },

    /**
     * 判断某一器械各阶段的数量是否一致，即：(术前清点数+术中加数)=关前清点数/关后清点数/缝皮后清点数
     * @param {object} row 器械清点记录行数据对象
     */
    operCountBalance:function(row,field){
        var preopCount=isNaN(row.PreopCount)?0:Number(row.PreopCount),      // 术前清点数存在用户未填写数值的情况，需要判断值是否为数字。
            operAddCount=isNaN(row.OperAddCount)?0:Number(row.OperAddCount),
            fieldCount=isNaN(row[field])?0:Number(row[field]),
            preopTotalCount=preopCount+operAddCount;
        // 如果(术前清点数+术中加数)≠关前清点数或关后清点数或缝皮后清点数
        if (preopTotalCount!==fieldCount){
            return false;
        }
        return true;
    },

    selectedSurgicalKit:function(id,title,surgicalKit,countBoxId){
        $("#surKitDialog").dialog("open");
        var opts=$("#surKitDialog").dialog("options");
        opts.countBoxId=countBoxId;
        opts.comboBoxId=id;
        // $("#surKitDialog").dialog({
        //     countBoxId:countBoxId,
        //     comboBoxId:id
        // });
        $("#SurgicalKitBox").datagrid("reload");
        var surKitDesc = $("#"+id).combobox("getText");
        $("#surKitDialog").dialog("setTitle", title+"-" + surKitDesc);
        var comboBoxId=opts.comboBoxId;
        $("#"+comboBoxId).combobox("clear");
    },

    /**
     * 添加手术物品
     * @param {String} boxId 清点记录表格ID
     * @param {object} surgicalItem 手术物品json对象
     */
    addSurgicalItem:function(boxId,comboId,surgicalItem,ivType){
        var itemDesc=surgicalItem.RowId;
        if(!itemDesc){
            itemDesc=surgicalItem.Description;
        }
        var result=operCount.existsSurgicalItem(boxId,itemDesc);
        if(result.existence){
            $.messager.confirm("提示","手术清点列表已存在"+result.rowData.MaterialNote+"，确认之后将术中加数加1？",function(r){
                var addCountDesc=result.rowData.AddCountDesc?result.rowData.AddCountDesc:"";
                result.rowData.AddCountDesc=addCountDesc+(addCountDesc?"+":"")+"1";
                result.rowData.OperAddCount=calExp(result.rowData.AddCountDesc);
                $("#"+boxId).datagrid("refreshRow",result.rowIndex);
                //$("#"+boxId).datagrid("selectRow",result.rowIndex);
            });
        }else{
            $.messager.confirm("提示", "是否添加“" + surgicalItem.Description + "”到清点列表？", function(r) {
                if (r) {
                    var countRows=$("#"+boxId).datagrid("getRows");
                    var index=countRows.length-2;
                    $("#"+boxId).datagrid("insertRow",{index:index,row: {
                        SurgicalMaterial: surgicalItem.RowId,
                        SurgicalMaterialDesc: surgicalItem.Description,
                        MaterialNote: surgicalItem.Description,
                        PreopCount: (surgicalItem.PreopCount ? surgicalItem.PreopCount : 1),
                        AddCountDesc: (surgicalItem.AddCountDesc ? surgicalItem.AddCountDesc : ""),
                        PreCloseCount: (surgicalItem.PreCloseCount ? surgicalItem.PreCloseCount : ""),
                        PostCloseCount: (surgicalItem.PostCloseCount ? surgicalItem.PostCloseCount : ""),
                        PostSewCount: (surgicalItem.PostSewCount ? surgicalItem.PostSewCount : ""),
                        BarCode: "",
                        InventoryType:ivType
                    }});
                    $("#"+comboId).combobox("clear");
                }
            });
        }
    },

    /**
     * 判断清点记录表格存在手术物品的清点记录。
     * @param {string} boxId 清点记录表格ID
     * @param {string} surgicalItem 手术物品RowId或名称
     */
    existsSurgicalItem:function(boxId,surgicalItem){
        var result={
            existence:false,
            rowIndex:-1,
            rowData:null
        };
        var countRows=$("#"+boxId).datagrid("getRows");
        if(countRows && countRows.length>0){
            for(var countIndex=0;countIndex<countRows.length;countIndex++){
                var countRow=countRows[countIndex];
                if(countRow.SurgicalMaterial===surgicalItem || countRow.MaterialNote===surgicalItem){
                    result.existence=true;
                    result.rowIndex=countIndex;
                    result.rowData=countRow;
                    break;
                }
            }
        }
        return result;
    },

    /**
     * 批量删除清点记录
     * @param {String} boxId 表格ID
     * @param {Array} countDatas 需要删除清点记录数组
     */
    delCountRecord:function(boxId,countDatas){
        var saveDatas=[],delDatas=[];
        for (var i = 0; i < countDatas.length; i++) {
            const element = countDatas[i];
            var rowIndex=$("#"+boxId).datagrid("getRowIndex",element);
            var dto={
                ClassName:ANCLS.Model.SurInventory,
                RowId:element.RowId
            };
            var delObj={
                RowIndex:rowIndex,
                RowData:element
            }
            if(dto.RowId){
                saveDatas.push(dto);
            }
            delDatas.push(delObj);
        }
        if(saveDatas.length>0){
            var jsonStr=dhccl.formatObjects(saveDatas);
            var delResult=dhccl.removeDatas(jsonStr);
            if(delResult.indexOf("S^")===0){
                for (var i = 0; i < delDatas.length; i++) {
                    const element = delDatas[i];
                    var rowIndex=$("#"+boxId).datagrid("getRowIndex",element.RowData);
                    $("#"+boxId).datagrid("deleteRow",rowIndex);
                }
                $("#"+boxId).datagrid("clearChecked");
            }else{
                $.messager.alert("提示","删除失败，原因："+delResult,"error");
            }
        }else{
            for (var i = 0; i < delDatas.length; i++) {
                const element = delDatas[i];
                var rowIndex=$("#"+boxId).datagrid("getRowIndex",element.RowData);
                $("#"+boxId).datagrid("deleteRow",rowIndex);
            }
            $("#"+boxId).datagrid("clearChecked");
        }
        
    },

    /**
     * 用户点击单元格时，自动计算并生成清点记录数据。
     * @param {String} boxId 表格ID
     * @param {Array} countDatas 清点记录数组
     */
    genCountData:function(boxId,clickField,countDatas){
        var genFields=['PreCloseCount','PostCloseCount','PostSewCount'];
        if (genFields.indexOf(clickField)<0) return;    // 只有关前清点、关后清点和缝皮后清点数据自动生成
        for (var i = 0; i < countDatas.length; i++) {
            const element = countDatas[i];
            var curCount= parseFloat(element[clickField]);
            var preopCount=parseFloat(element['PreopCount']);
            preopCount=!isNaN(preopCount)?preopCount:0;
            var operAddCount=parseFloat(element['OperAddCount']);
            operAddCount=!isNaN(operAddCount)?operAddCount:0;
            if (curCount===(preopCount+operAddCount)) continue;
            element[clickField]=preopCount+operAddCount;
            $('#'+boxId).datagrid('updateRow',{
                index:i,
                data:element
            });
        }
    },

    getCountDatas:function(boxId){
        var countDatas=$('#'+boxId).datagrid('getRows');
        var saveDatas=[];
        if (countDatas && countDatas.length>0 && session.RecordSheetID){
            for (var i = 0; i < countDatas.length; i++) {
                const element = countDatas[i];
                if(element.SurgicalMaterial==="CircualNurseSign" || element.SurgicalMaterial==="ScrubNurseSign") continue;
                var surgicalCount={
                    RowId:element.RowId,
                    RecordSheet:session.RecordSheetID,
                    SurgicalMaterial:element.SurgicalMaterial,
                    MaterialNote:element.MaterialNote,
                    AddCountDesc:element.AddCountDesc,
                    InventoryType:element.InventoryType,
                    ClassName:ANCLS.Model.SurInventory
                }
                var preopCount=parseFloat(element.PreopCount);
                surgicalCount.PreopCount=!isNaN(preopCount)?preopCount:"";
                var operAddCount=parseFloat(element.OperAddCount);
                surgicalCount.OperAddCount=!isNaN(operAddCount)?operAddCount:"";
                var preCloseCount=parseFloat(element.PreCloseCount);
                surgicalCount.PreCloseCount=!isNaN(preCloseCount)?preCloseCount:"";
                var postCloseCount=parseFloat(element.PostCloseCount);
                surgicalCount.PostCloseCount=!isNaN(postCloseCount)?postCloseCount:"";
                var postSewCount=parseFloat(element.PostSewCount);
                surgicalCount.PostSewCount=!isNaN(postSewCount)?postSewCount:"";
                saveDatas.push(surgicalCount);
            }
        }
        return saveDatas;
    },

    getSignRows:function(boxId){
        var countDatas=$('#'+boxId).datagrid('getRows');
        var saveDatas=[];
        if (countDatas && countDatas.length>0 && session.RecordSheetID){
            for (var i = 0; i < countDatas.length; i++) {
                const element = countDatas[i];
                if(element.SurgicalMaterial!=="CircualNurseSign" && element.SurgicalMaterial!=="ScrubNurseSign") continue;
                var signCode="SNS";
                if(element.SurgicalMaterial==="CircualNurseSign"){
                    signCode="CNS";
                }
                var surgicalCount={
                    RowId:element.RowId,
                    RecordSheet:session.RecordSheetID,
                    SignType:element.SurgicalMaterial,
                    SignCode:signCode,
                    SignTypeDesc:element.MaterialNote,
                    PreopCount:element.PreopCount,
                    AddCountDesc:element.AddCountDesc,
                    PreCloseCount:element.PreCloseCount,
                    PostCloseCount:element.PostCloseCount,
                    PostSewCount:element.PostSewCount
                }
                
                saveDatas.push(surgicalCount);
            }
        }
        return saveDatas;
    },
    
    calExp:function(exp){
        var expArr=exp.split("+");
        var result=0;
        for(var i=0;i<expArr.length;i++){
            result+=Number(expArr[i]);
        }
        return result;
    },

    /**
     * 保存清点记录数据
     * @param {String} boxId 表格ID
     */
    saveCountDatas:function(){
        var boxIdList=['instrumentsBox'];
        var saveDatas=[];
        for (var i = 0; i < boxIdList.length; i++) {
            const boxId = boxIdList[i];
            var countDatas=getCountDatas(boxId);
            for (var j = 0; j < countDatas.length; j++) {
                const countData = countDatas[j];
                saveDatas.push(countData);
            }
        }
        if(saveDatas.length===0) return;
        var jsonData = dhccl.formatObjects(saveDatas);
        var data = dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData
        }, function(result) {
            if(result.indexOf("S^")===0){
                $('#instrumentsBox').datagrid("reload");
            }else{
                $.messager.alert("保存清点数据失败，原因："+result);
            }
            
        });
    },

    /**
     * 判断手术清点数据是否完整、清点数量前后是否一致以及清点签名是否完整
     */
    isOperCountIntegrity:function(){
        var operCountRows=operCount.getCountDatas("instrumentsBox"); //$("#instrumentsBox").datagrid("getRows");

        if(!operCountRows || operCountRows.length<=0){
            // 有手术存在没有任何器械清点的情况？
            return {integrity:true,messages:[]};
        }else{
            var messages=[],countMessages=[];
            for(var i=0;i<operCountRows.length;i++){
                var row=operCountRows[i];
                var curMessages=[];
                if(isNaN(row.PreopCount) || Number(row.PreopCount)===0){
                    curMessages.push("术前清点数不能为空或者为零");
                }
                if(!operCount.operCountBalance(row,"PreCloseCount")){
                    curMessages.push("关空腔脏器前核对");
                }
                if(!operCount.operCountBalance(row,"PostCloseCount")){
                    curMessages.push("关切口前核对");
                }
                if(!operCount.operCountBalance(row,"PostSewCount")){
                    curMessages.push("关切口核对");
                }
                if(curMessages.length>0){
                    countMessages.push(row.MaterialNote);
                }
            }
            if(countMessages.length>0){
                messages.push(countMessages.join(",")+"清点有误。");
            }

            var signRows=operCount.getSignRows("instrumentsBox");
            for(var i=0;i<signRows.length;i++){
                var signRow=signRows[i];
                var signMessages=[];
                if(!signRow.PreopCount){
                    signMessages.push("术前清点-"+signRow.SignTypeDesc+"未完成。");
                }
                if(!signRow.AddCountDesc){
                    signMessages.push("术中追加-"+signRow.SignTypeDesc+"未完成。");
                }
                if(!signRow.PreCloseCount){
                    signMessages.push("关空腔脏器前核对-"+signRow.SignTypeDesc+"未完成。");
                }
                if(!signRow.PostCloseCount){
                    signMessages.push("关切口前核对-"+signRow.SignTypeDesc+"未完成。");
                }
                if(!signRow.AddCountDesc){
                    signMessages.push("关切口后核对-"+signRow.SignTypeDesc+"未完成。");
                }
                if(signMessages.length>0){
                    messages.push("手术清点-"+signRow.SignTypeDesc+"不完整。");
                }
            }

            // $(".sign-table .signature").each(function(index,item){
            //     var signUser=$(item).triggerbox("getValue");
            //     var opts=$(item).triggerbox("options");
            //    if(!signUser) messages.push("手术清点："+opts.prompt+"未完成。");
            // });

            if(messages.length<=0){
                return {integrity:true,message:""};
            }else{
                return {integrity:false,message:messages.join("<br>"),messages:messages};
            }
        }
    }
};

var formControls={
    changeOperTimeReadonly:function(){
        $(".opertime").each(function(index,item){
            var value=$(item).val();
            if(!value){
                $(this).attr("readonly",true);
            }else{
                $(this).removeAttr("readonly");
            }
        });
    },
    setElectricKnifeEnale:function(enable){
        if(!enable){
            $("input[data-formitem='NegativePlateSite']").checkbox("disable");
            $("input[data-formitem='Thigh']").checkbox("disable");
            $("input[data-formitem='Crus']").checkbox("disable");
            $("#NegativePlateSite").attr("data-required","N");
        }else{
            $("input[data-formitem='NegativePlateSite']").checkbox("enable");
            $("input[data-formitem='Thigh']").checkbox("enable");
            $("input[data-formitem='Crus']").checkbox("enable");
            $("#NegativePlateSite").attr("data-required","Y");
        }   
    },

    clearElectricKnifeData:function(){
        $("input[data-formitem='NegativePlateSite']").checkbox("setValue",false);
        $("input[data-formitem='Thigh']").checkbox("setValue",false);
        $("input[data-formitem='Crus']").checkbox("setValue",false);
    },

    setBloodTransEnable:function(enable){
        if(!enable){
            $("#ABO,#RH").combobox("disable");
            $("#RedCellSuspension,#Plasma,#BloodOther").attr("disabled",true);
            $("#ABO,#RH,#RedCellSuspension,#Plasma,#BloodOther").removeAttr("data-required");
        }else{
            $("#ABO,#RH").combobox("enable");
            $("#RedCellSuspension,#Plasma,#BloodOther").removeAttr("disabled");
            $("#ABO,#RH,#RedCellSuspension,#Plasma,#BloodOther").attr("data-required","Y");
        }
    },

    clearBloodTransData:function(){
        $("#ABO,#RH").combobox("clear");
        $("#RedCellSuspension,#Plasma,#BloodOther").val("");
    },
    
    setTourniquetEnable:function(enable){
        if(!enable){
            $("input[data-formitem='UseTourniquetSite']").checkbox("disable");
            $("input[data-formitem='UpperLimb']").checkbox("disable");
            $("input[data-formitem='LowerLimb']").checkbox("disable");
            $("#TourniquetPressure").attr("disabled",true);
            $(".TourniquetTime").attr("disabled",true);
            $(".TourniquetDuration").attr("disabled",true);
            $(".TourniquetTime,.TourniquetDuration,#UseTourniquetSite,#TourniquetPressure").attr("data-required","N");
        }else{
            $("input[data-formitem='UseTourniquetSite']").checkbox("enable");
            $("input[data-formitem='UpperLimb']").checkbox("enable");
            $("input[data-formitem='LowerLimb']").checkbox("enable");
            $("#TourniquetPressure").removeAttr("disabled");
            $(".TourniquetTime").removeAttr("disabled");
            $(".TourniquetDuration").removeAttr("disabled");
            $(".TourniquetTime,.TourniquetDuration,#UseTourniquetSite,#TourniquetPressure").attr("data-required","Y");

        }
    },
    
    clearTourniquetData:function(){
        $("input[data-formitem='UseTourniquetSite']").checkbox("setValue",false);
        $("input[data-formitem='UpperLimb']").checkbox("setValue",false);
        $("input[data-formitem='LowerLimb']").checkbox("setValue",false);
        //$("#TourniquetPressure").val("/");
        //$(".TourniquetTime").val("/");
        //$(".TourniquetDuration").val("/");
    },
    
    setDrainageTubeEnable:function(enable){
        if(!enable){
            $("#DrainageTubeCount").attr("disabled",true);
            $("input[data-formitem='DrainageTubeType']").checkbox("disable");
            $("#DrainageTubeType,#DrainageTubeCount").attr("data-required","N");
        }else{
            $("#DrainageTubeCount").removeAttr("disabled");
            $("input[data-formitem='DrainageTubeType']").checkbox("enable");
            $("#DrainageTubeType,#DrainageTubeCount").attr("data-required","Y");
        }
    },
    
    clearDrainageTubeData:function(){
        $("#DrainageTubeCount").val("");
        $("input[data-formitem='DrainageTubeType']").checkbox("setValue",false);
    },
    
    setImplantsEnable:function(enable){
        if(!enable){
            $("#ImplantsDetail").attr("disabled",true);
            $("#BioMonResults").checkbox("disable");
            $("#ImplantsDetail,#BioMonResults").removeAttr("data-required");
        }else{
            $("#ImplantsDetail").removeAttr("disabled");
            $("#BioMonResults").checkbox("enable");
            $("#ImplantsDetail,#BioMonResults").attr("data-required","Y");
        }
    },
    
    clearImplantsData:function(){
        $("#ImplantsDetail").val("");
        $("#BioMonResults").checkbox("setValue",false);
    },
    
    setPathSpecimenEnable:function(enable){
        if(!enable){
            $("#SpecimenCount").attr("disabled",true);
            $("#PlacentaCount").attr("disabled",true);
            $("#SpecimenCount,#PlacentaCount").attr("data-required","N");
        }else{
            $("#SpecimenCount").removeAttr("disabled");
            $("#PlacentaCount").removeAttr("disabled");
            $("#SpecimenCount,#PlacentaCount").attr("data-required","Y");

        }
    },
    
    clearPathSpecimenData:function(){
        $("#SpecimenCount").val("");
        $("#PlacentaCount").val("");
    },
    
    setFrozenSectionEnable:function(enable){
        if(!enable){
            $("#FrozenSectionCount").attr("disabled",true);
            $("#FrozenSectionCount").attr("data-required","N");
        }else{
            $("#FrozenSectionCount").removeAttr("disabled");
            $("#FrozenSectionCount").attr("data-required","Y");
        }
    },
    
    clearFrozenSectionData:function(){
        $("#FrozenSectionCount").val("");
    },
    
    /**
     * 设置其它文本框可用性
     * @param {Boolean} enable 是否可用
     * @param {String} selector 文本框选择器
     */
    setOtherTextBoxEnable:function(enable,selector){
        if(!enable){
            $(selector).attr("disabled",true);
        }else{
            $(selector).removeAttr("disabled");
        }
    },
    
    /**
     * 清除其他文本框数据
     * @param {String} selector 文本框选择器
     */
    clearOtherTextBoxData:function(selector){
        $(selector).val("/");
    },

    /**
     * 改变控件可用性
     */
    changeControlsEnable:function(){
        $("#TheatreOutTransLoc4").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#TheatreOutTransLoc4");
                    formControls.setOtherTextBoxEnable(true,"#TheatreOutTransLocOther");
                }else{
                    formControls.setOtherTextBoxEnable(false,"#TheatreOutTransLocOther");
                    // $.messager.confirm("提示","是否清除其他文本数据，清除后不可恢复？",function(r){
                    //     if(r){
                    //         formControls.clearOtherTextBoxData("#TheatreOutTransLocOther");
                    //     }
                    // })
                    formControls.clearOtherTextBoxData("#TheatreOutTransLocOther");

                }
            }
        });

        // 手术体位
        $("#OperPosition6").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.setOtherTextBoxEnable(true,"#OperPositionOther");
                }else{
                    formControls.setOtherTextBoxEnable(false,"#OperPositionOther");
                    // $.messager.confirm("提示","是否清除其他文本数据，清除后不可恢复？",function(r){
                    //     if(r){
                    //         formControls.clearOtherTextBoxData("#OperPositionOther");
                    //     }
                    // })
                    formControls.clearOtherTextBoxData("#OperPositionOther");

                }
            }
        });

        // 皮肤消毒
        $("#SkinDesinfection3").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#SkinDesinfection3");
                    formControls.setOtherTextBoxEnable(true,"#SkinDesinfectionOther");
                }else{
                    formControls.setOtherTextBoxEnable(false,"#SkinDesinfectionOther");
                    // $.messager.confirm("提示","是否清除其他文本数据，清除后不可恢复？",function(r){
                    //     if(r){
                    //         formControls.clearOtherTextBoxData("#SkinDesinfectionOther");
                    //     }
                    // })
                    formControls.clearOtherTextBoxData("#SkinDesinfectionOther");

                }
            }
        });

        // 使用电刀
        $("#UseElectricKnife1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#UseElectricKnife1");
                    formControls.setElectricKnifeEnale(false);
                    formControls.clearElectricKnifeData();
                }
            }
        });
        $("#UseElectricKnife2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#UseElectricKnife2");
                    formControls.setElectricKnifeEnale(true);
                }
            }
        });

        $("#NegativePlateSite1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    $("#Thigh").attr("data-required","Y");
                }else{
                    $("#Thigh").removeAttr("data-required");
                }
            }
        });

        $("#NegativePlateSite2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    $("#Crus").attr("data-required","Y");
                }else{
                    $("#Crus").removeAttr("data-required");
                }
            }
        });


        // 使用止血带
        $("#UseTourniquet1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#UseTourniquet1");
                    formControls.setTourniquetEnable(false);
                    formControls.clearTourniquetData();
                }
            }
        });
        $("#UseTourniquet2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#UseTourniquet2");
                    formControls.setTourniquetEnable(true);
                }
            }
        });

        // 植入物
        $("#Implants1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#Implants1");
                    formControls.setImplantsEnable(false);
                    formControls.clearImplantsData();
                }
            }
        }); 
        $("#Implants2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#Implants2");
                    formControls.setImplantsEnable(true);
                }
            }
        });    

        // 病理标本
        $("#PathSpecimen1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#PathSpecimen1");
                    formControls.setPathSpecimenEnable(false);
                    formControls.clearPathSpecimenData();
                }
            }
        });
        $("#PathSpecimen2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#PathSpecimen2");
                    formControls.setPathSpecimenEnable(true);
                }
            }
        });  

        // 冰冻切片
        $("#FrozenSection1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#FrozenSection1");
                    formControls.setFrozenSectionEnable(false);
                    formControls.clearFrozenSectionData();
                }
            }
        }); 
        $("#FrozenSection2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#FrozenSection2");
                    formControls.setFrozenSectionEnable(true);
                }
            }
        });  

        // 放置引流
        $("#DrainageTube1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#DrainageTube1");
                    formControls.setDrainageTubeEnable(false);
                    formControls.clearDrainageTubeData();
                }
            }
        });  
        $("#DrainageTube2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#DrainageTube2");
                    formControls.setDrainageTubeEnable(true);
                }
            }
        });  

        $("#BloodTransfusion1").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#BloodTransfusion1");
                    formControls.setBloodTransEnable(false);
                    formControls.clearBloodTransData();
                }
            }
        });

        $("#BloodTransfusion2").checkbox({
            onCheckChange:function(e,value){
                if(value){
                    formControls.clearCheckboxChecked("#BloodTransfusion2");
                    formControls.setBloodTransEnable(true);
                }
            }
        });

        if($("#DrainageTube1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#DrainageTube1");
            formControls.setDrainageTubeEnable(false);
            formControls.clearDrainageTubeData();
        }
        if($("#DrainageTube2").checkbox("getValue")){
            formControls.clearCheckboxChecked("#DrainageTube2");
            formControls.setDrainageTubeEnable(true);
        }
        if($("#FrozenSection1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#FrozenSection1");
            formControls.setFrozenSectionEnable(false);
            formControls.clearFrozenSectionData();
        }
        if($("#FrozenSection1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#FrozenSection2");
            formControls.setFrozenSectionEnable(true);
        }
        if($("#FrozenSection2").checkbox("getValue")){
            formControls.clearCheckboxChecked("#FrozenSection2");
            formControls.setFrozenSectionEnable(true);
        }
        if($("#PathSpecimen1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#PathSpecimen1");
            formControls.setPathSpecimenEnable(false);
            formControls.clearPathSpecimenData();
        }
        if($("#PathSpecimen2").checkbox("getValue")){
            formControls.clearCheckboxChecked("#PathSpecimen2");
            formControls.setPathSpecimenEnable(true);
        }
        if($("#Implants1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#Implants1");
            formControls.setImplantsEnable(false);
            formControls.clearImplantsData();
        }
        if($("#Implants2").checkbox("getValue")){
            formControls.clearCheckboxChecked("#Implants2");
            formControls.setImplantsEnable(true);
        }
        if($("#UseTourniquet1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#UseTourniquet1");
            formControls.setTourniquetEnable(false);
            formControls.clearTourniquetData();
        }
        if($("#UseTourniquet2").checkbox("getValue")){
            formControls.clearCheckboxChecked("#UseTourniquet2");
            formControls.setTourniquetEnable(true);
        }
        if($("#UseElectricKnife1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#UseElectricKnife1");
            formControls.setElectricKnifeEnale(false);
            formControls.clearElectricKnifeData();
            $("#NegativePlateSite").removeAttr("data-required");
        }
        if($("#UseElectricKnife2").checkbox("getValue")){
            formControls.clearCheckboxChecked("#UseElectricKnife2");
            formControls.setElectricKnifeEnale(true);
            $("#NegativePlateSite").attr("data-required","Y");
        }
        if($("#SkinDesinfection3").checkbox("getValue")){
            formControls.clearCheckboxChecked("#SkinDesinfection3");
            formControls.setOtherTextBoxEnable(true,"#SkinDesinfectionOther");
        }
        if($("#OperPosition6").checkbox("getValue")){
            formControls.setOtherTextBoxEnable(true,"#OperPositionOther");
        }
        if($("#TheatreOutTransLoc4").checkbox("getValue")){
            formControls.clearCheckboxChecked("#TheatreOutTransLoc4");
            formControls.setOtherTextBoxEnable(true,"#TheatreOutTransLocOther");
        }
        if($("#BloodTransfusion1").checkbox("getValue")){
            formControls.clearCheckboxChecked("#BloodTransfusion1");
            formControls.setBloodTransEnable(false);
            formControls.clearBloodTransData();
        }
        if($("#BloodTransfusion2").checkbox("getValue")){
            formControls.clearCheckboxChecked("#BloodTransfusion2");
            formControls.setBloodTransEnable(true);
        }
    },

    clearCheckboxChecked:function(selector){
        var formItem=$(selector).attr("data-formitem");
        var dataMultiple=$("#"+formItem).attr("data-multiple");
        if(dataMultiple!=="N") return;
        var selectorId=$(selector).attr("id");
        $("input[data-formitem='"+formItem+"']").each(function(index,item){
            var curId=$(this).attr("id");
            if(curId===selectorId) return;
            $(this).checkbox("setValue",false);
        });
    },

    setScrubShiftEnable:function(enable){
        if(!enable){
            $("#ScrubShiftTime").attr("disabled",true);
        }else{
            $("#ScrubShiftTime").removeAttr("disabled");
        }
    },

    clearScrubShiftData:function(){
        $("#ScrubShiftTime").val("/");
    },

    setCircualShiftEnable:function(enable){
        if(!enable){
            $("#CircualShiftTime").attr("disabled",true);
        }else{
            $("#CircualShiftTime").removeAttr("disabled");
        }
    },

    clearCircualShiftData:function(){
        $("#CircualShiftTime").val("/");
    },

    disableSomeControls:function(){
       // formControls.setElectricKnifeEnale(false);
       // formControls.setTourniquetEnable(false);
       // formControls.setDrainageTubeEnable(false);
       // formControls.setImplantsEnable(false);
       // formControls.setPathSpecimenEnable(false);
       // formControls.setFrozenSectionEnable(false); 
       // formControls.setOtherTextBoxEnable(false,"#OperPositionOther,#SkinDesinfectionOther,#TheatreOutTransLocOther");
        formControls.setScrubShiftEnable(false);
        formControls.setCircualShiftEnable(false);
    
        $("#OperDate").datebox("disable");
    }
    
};

var operActions={
    /**
     * 初始化操作功能按钮
     */
    initOperActions:function(){
        $('#btnSave').linkbutton({
            onClick:function(){
                // saveCountDatas();
                // operDataManager.saveOperDatas();
                operRecord.saveOperRegister();
            }
        });

        $('#btnRefresh').linkbutton({
            onClick:function(){
                window.location.reload();
            }
        });

        $("#btnSubmit").linkbutton({
            onClick:function(){
                operRecord.submitOperRegister();
            }
        })

        $('#btnPrint').linkbutton({
            onClick:function(){
                $.get("CIS.AN.OperCountPrint.SZNS.csp?opsId="+session.OPSID,function(ret){
                    var jqueryObj=$("<div></div>").append(ret);
                    var operDatas = operDataManager.getOperDatas();
                    var signList=SignTool.loadSignature();
                    var signCodeArr=["CircualNurseSign","PreopScrubNurseSign","PreCloseScrubNurseSign","PostCloseScrubNurseSign","PostSewScrubNurseSign","PreopCirNurseSign","PreCloseCirNurseSign","PostCloseCirNurseSign","PostSewCirNurseSign"];
                    var relatedData=SignTool.getSignature(signList,signCodeArr);
                    jqueryObj.find("#CircualNurseSign").attr("value",relatedData.CircualNurseSign?relatedData.CircualNurseSign.SignUserName:"/");

                    var operDate=new Date(operRecord.opts.schedule.OperDate);
                    operRecord.opts.schedule.OperDateYear=operDate.getFullYear();
                    operRecord.opts.schedule.OperDateMonth=operDate.getMonth()+1;
                    operRecord.opts.schedule.OperDateDay=operDate.getDay();
                    for (var key in operRecord.opts.schedule) {
                        if (operRecord.opts.schedule.hasOwnProperty(key)) {
                            const value = operRecord.opts.schedule[key];
                            jqueryObj.find("#"+key).text(value);
                            jqueryObj.find("#"+key).attr("value",value);
                        }
                    }

                    for (var i = 0; i < operDatas.length; i++) {
                        const operData = operDatas[i];
                        var dataValue=operData.DataValue;
                        if(!dataValue) dataValue="/";
                        jqueryObj.find("#"+operData.DataItem).text(dataValue);
                        jqueryObj.find("#"+operData.DataItem).attr("value",dataValue);
                        jqueryObj.find("[data-formitem='"+operData.DataItem+"']").each(function(index,item){
                            var label=$(item).attr("label");
                            if((","+operData.DataValue+",").indexOf(label)>=0){
                                $(item).attr("checked","checked");
                            }
                        });
                    }

                    var countDatas=$("#instrumentsBox").datagrid("getRows");
                    var rowCount=19;
                    var htmlArr=[];
                    for (var i = 0; i < rowCount; i++) {
                        var firstData=null,secondData=null;
                        if(countDatas.length>i){
                            firstData=countDatas[i];
                        }
                        if(countDatas.length>(rowCount+i)){
                            secondData=countDatas[rowCount+i];
                        }
                        htmlArr.push(
                            "<tr style='height:18pt'>",
                            "<td style='text-align:center'>"+(firstData?(firstData.MaterialNote || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(firstData?(firstData.PreopCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(firstData?(firstData.OperAddCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(firstData?(firstData.PreCloseCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(firstData?(firstData.PostCloseCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(firstData?(firstData.PostSewCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(secondData?(secondData.MaterialNote || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(secondData?(secondData.PreopCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(secondData?(secondData.OperAddCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(secondData?(secondData.PreCloseCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(secondData?(secondData.PostCloseCount || "/"):"/")+"</td>",
                            "<td style='text-align:center'>"+(secondData?(secondData.PostSewCount || "/"):"/")+"</td>",
                            "</tr>");
                    }
                    var countData=null,displayCount=2*rowCount;
                    if(countDatas.length>displayCount){
                        countData=countDatas[displayCount];
                        displayCount+=1;
                    }
                    htmlArr.push(
                        "<tr style='height:18pt'>",
                        "<td style='text-align:center'></td>",
                        "<td style='text-align:center' colspan='2'>手术开始前</td>",
                        "<td style='text-align:center'>关前<br>清点</td>",
                        "<td style='text-align:center'>关后<br>清点</td>",
                        "<td style='text-align:center'>缝皮后<br>清点</td>",
                        "<td style='text-align:center'>"+(countData?(countData.MaterialNote || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PreopCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.OperAddCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PreCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PostCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PostSewCount || "/"):"/")+"</td>",
                        "</tr>");
                    if(countDatas.length>displayCount){
                        countData=countDatas[displayCount];
                        displayCount+=1;
                    }

                    
                    htmlArr.push(
                        "<tr style='height:18pt'>",
                        "<td style='text-align:center'>器械护士</td>",
                        "<td style='text-align:center' colspan='2'>"+(relatedData.PreopScrubNurseSign?relatedData.PreopScrubNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(relatedData.PreCloseScrubNurseSign?relatedData.PreCloseScrubNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(relatedData.PostCloseScrubNurseSign?relatedData.PostCloseScrubNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(relatedData.PostSewScrubNurseSign?relatedData.PostSewScrubNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.MaterialNote || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PreopCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.OperAddCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PreCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PostCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PostSewCount || "/"):"/")+"</td>",
                        "</tr>");
                    if(countDatas.length>displayCount){
                        countData=countDatas[displayCount];
                        displayCount+=1;
                    }
                    htmlArr.push(
                        "<tr style='height:18pt'>",
                        "<td style='text-align:center'>巡回护士</td>",
                        "<td style='text-align:center' colspan='2'>"+(relatedData.PreopCirNurseSign?relatedData.PreopCirNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(relatedData.PreCloseCirNurseSign?relatedData.PreCloseCirNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(relatedData.PostCloseCirNurseSign?relatedData.PostCloseCirNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(relatedData.PostSewCirNurseSign?relatedData.PostSewCirNurseSign.SignUserName:"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.MaterialNote || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PreopCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.OperAddCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PreCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PostCloseCount || "/"):"/")+"</td>",
                        "<td style='text-align:center'>"+(countData?(countData.PostSewCount || "/"):"/")+"</td>",
                        "</tr>");
                    var noteData=getOperDataByCode("OperCountNote");
                    htmlArr.push("<tr style='height:30pt;text-align:center'><td>备注</td><td colspan='11' style='text-align:left'>"+(noteData?noteData.DataValue:"")+"</td>");
                    jqueryObj.find("#countTable").append(htmlArr.join(""));
                    var firstPage="<head>"+jqueryObj.find("#head").html()+"</head><body>"+jqueryObj.find("#OperCountRecord").html()+"</body>";
                    var secondPage="<head>"+jqueryObj.find("#head").html()+"</head><body>"+jqueryObj.find("#OperNurRecord").html()+"</body>";
                    operActions.printMessage(secondPage,firstPage);

                    function getOperDataByCode(itemCode){
                        var retData=null;

                        if(operDatas && operDatas.length>0){
                            for (var i = 0; i < operDatas.length; i++) {
                                const operData = operDatas[i];
                                if(operData.DataItem===itemCode){
                                    retData=operData;
                                }
                            }
                        }
                        return retData;
                    }
                });
                //printDocument();
            }
        });
    },

    printMessage:function(firstPage,secondPage) {
        var count=operDataManager.printCount(session.RecordSheetID,session.ModuleCode)
        var ifMessage=operDataManager.ifPrintMessage()
        if(ifMessage!="Y"||Number(count)==0) operActions.printNew(firstPage,secondPage)
        else if(Number(count)>0){
            $.messager.confirm("提示","表单已打印"+count+"次,是否继续打印",function (r)
            {
                if(r)
                {
                    operActions.printNew(firstPage,secondPage)
                } 
            } );
        }
    },
    
    printNew:function(firstPage,secondPage){
        var lodop = getLodop();
        lodop.PRINT_INIT("OperCount" + session.OPSID);
        // lodop.SET_PRINT_MODE("POS_BASEON_PAPER",true);
        lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
        lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
        // lodop.ADD_PRINT_IMAGE(0,0,"17cm","4.2cm","<img src='../service/dhcanop/img/logo.zmdzx.png'>");
        // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
        
        lodop.ADD_PRINT_HTM("1.05cm","0.5cm","540pt","100%","<html>"+firstPage+"</html>");
        lodop.NEWPAGE();
        // lodop.ADD_PRINT_IMAGE(0,0,"17cm","4.2cm","<img src='../service/dhcanop/img/logo.zmdzx.png'>");
        // lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
        lodop.ADD_PRINT_HTM("1.05cm","0.5cm","540pt","100%","<html>"+secondPage+"</html>");
        lodop.PREVIEW();
        operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID)
    },

    changeActionEnable:function(){
        var res=dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet,"GetSheetEditFlag",session.RecordSheetID,session.UserID,session.GroupID);
        var permission=JSON.parse(res);
        if(permission.editFlag==="N"){
            $("#btnSave").linkbutton("enable");
            $("#btnSubmit").linkbutton("enable");
            $("#btnPrint").linkbutton("disable");
        }else if(permission.editFlag==="S" || permission.editFlag==="A"){
            if(permission.submitUser==="Y"){
                $("#btnSave").linkbutton("enable");
                $("#btnSubmit").linkbutton("enable");
                $("#btnPrint").linkbutton("enable");
            }else{
                $("#btnSave").linkbutton("disable");
                $("#btnSubmit").linkbutton("disable");
                $("#btnPrint").linkbutton("disable");
            }
        }
    }
}

$(document).ready(operRecord.init);

