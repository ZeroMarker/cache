var applist={
    initPage:function(){
        var _this=applist;
        _this.initQueryOptions();
        _this.initListBox();
    },

    initQueryOptions:function(){
        // 默认开始和结束日期
        dhccl.parseDateFormat();
        $("#OperDate").datebox("setValue",(new Date()).format("yyyy-MM-dd"));

        // 麻醉状态
        $("#OperStatus").combobox({
            valueField: "RowId",
            textField: "Description",
            url: ANCSP.DataQuery,
            onBeforeLoad: function (param) {
                param.ClassName = ANCLS.BLL.CodeQueries;
                param.QueryName = "FindOperStatus";
                param.ArgCnt = 0;
            }
        });

        $("#RegNo").keyup(function(e){
            if(e.keyCode===13){
                var text=$(this).val();
                if(text && text.length<10){
                    var zeroArr=[];
                    for(var i=0;i<10-text.length;i++){
                        zeroArr.push(0);
                    }
                    $(this).val(zeroArr.join("")+text);
                }
                queryOperList();
            }
        });
        
    },

    initListBox:function(){
        var columns=[[
            {field:"CheckStatus",title:"勾选",checkbox:true},
            {field:"StatusDesc",title:"状态",width:50,styler:function(value,row,index){
                return "background-color:" + row.StatusColor + ";";
            }}, 
            {field:"SourceTypeDesc",title:"类型",width:50,styler: function (value, row, index) {
                switch (row.SourceType) {
                    case "B":
                        return "background-color:"+SourceTypeColors.Book+";";
                    case "E":
                        return "background-color:"+SourceTypeColors.Emergency+";";
                    default:
                        return "background-color:white;";
                }
            }},
            {field:"OperDate",title:"麻醉日期",width:100},
            {field:"PatName",title:"患者姓名",width:76},
            {field:"PatGender",title:"性别",width:45},
            {field:"PatAge",title:"年龄",width:50},
            {field:"PatDeptDesc",title:"科室",width:120},
            {field:"PatBedCode",title:"床号",width:60},
            {field:"PrevDiagnosis",title:"诊断描述",width:160},
            {field:"SpecialConditions",title:"病情简介",width:160},
            {field:"OperDesc",title:"麻醉目的",width:200},
            {field:"OperNote",title:"备注",width:120},
            {field:"DrugAllergyNote",title:"药物过敏",width:160},
            {field:"AppCareProvDesc",title:"申请医生",width:80},
            {field:"AppDocPhoneNo",title:"申请医生电话",width:100},
            {field:"AnaMethodDesc",title:"麻醉方法",width:100},
            {field:"AnesthesiologistDesc",title:"麻醉医生",width:80},
            {field:"RegNo",title:"登记号",width:100}
            
        ]];
        $("#applistBox").datagrid({
            fit:true,
            title:"麻醉预约列表",
            headerCls:"panel-header-gray",
            iconCls:"icon-paper",
            rownumbers: true,
            pagination: true,
            pageSize: 300,
            pageList: [50, 100, 200,300,400,500],
            remoteSort: false,
            toolbar:"#applistTool",
            columns:columns,
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                param.ClassName=ANCLS.BLL.OperScheduleList;
                param.QueryName="FindOperScheduleList";
                param.Arg1=$("#OperDate").datebox("getValue");
                param.Arg2=$("#OperDate").datebox("getValue");
                param.Arg3=session.DeptID;
                param.Arg4="";
                param.Arg5="";
                param.Arg6="";
                param.Arg7=$("#OperStatus").combobox("getValue");
                param.Arg8="";
                param.Arg9=$("#RegNo").val();
                param.Arg10=$("#MedicareNo").val(); 
                param.Arg11="";
                param.Arg12="N";
                param.Arg13="N";
                param.ArgCnt=13;
            },
            onSelect:function(rowIndex,rowData){
            },
            onUnselect:function(rowIndex,rowData){
            },
            onLoadSuccess:function(data){
            }
        });
    },

    action:{
        /**
         * 查询麻醉申请列表
         */
        queryAppList:function(){
            $("#applistBox").datagrid("reload");
        },

        /**
         * 室外麻醉工作站
         */
        outANWorkstation:function(){
            var rowData=$("#applistBox").datagrid("getSelected");
            if(!rowData){
                $.messager.alert("提示","请先选择一条手术，再进入室外麻醉工作站！","warning");
            }
            var menuCode="OANWSMenu";
            var href="CIS.AN.Workstation.csp?opsId=" + rowData.RowId + "&PatientID=" + rowData.PatientID + "&EpisodeID=" + rowData.EpisodeID + "&AnaesthesiaID=" + rowData.ExtAnaestID + "&QueryDate=" + rowData.OperDate + "&menuCode=" + menuCode;
            window.location.href=href;
        },

        /**
         * 修改麻醉申请
         */
        editApp:function(){
            var rowData=$("#applistBox").datagrid("getSelected");
            if(!rowData){
                $.messager.alert("提示","请先选择预约记录，再进行修改。","warning");
                return;
            }
            var showDialog="Y";
            var url="CIS.AN.AnaApplication.csp?opsId="+rowData.OPSID+"&opaId="+rowData.OPAID+"&EpisodeID="+rowData.EpisodeID+"&PatientID="+rowData.PatientID+"&showDialog="+showDialog+"&moduleCode=AN_OPA_006";
            applist.dialog=new ANDialog({
                title:rowData.PatName+"的麻醉预约记录",
                width:900,
                height:500,
                iconCls:"icon-w-edit",
                csp:url,
                queryParams:true
            });
            applist.dialog.open();

        },

        /**
         * 取消麻醉申请
         */
        cancelApp:function(){
            var selectedData=$("#applistBox").datagrid("getSelected");
            if(!selectedData){
                $.messager.alert("提示","请先选择预约记录，再取消申请。","warning");
                return;
            }
            var selectedRows=$("#applistBox").datagrid("getSelections");
            if((selectedRows)&&(selectedRows.length>1)){
                $.messager.alert("提示","请选择单条手术进行操作，不能取消多条。","warning");
                return;
            }
            var canCancelOperation=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"CanCancelOperation",selectedData.OPSID,session.UserID,session.GroupID,"btnCancelOperation");
            if(canCancelOperation.indexOf("E^")===0){
                $.messager.alert("提示",canCancelOperation,"warning");
                return;
            }
            var reason=new Reason({
                title:"预约取消原因",
                reasonHandle:function(reason){
                    var ret=dhccl.runServerMethodNormal(ANCLS.BLL.OperScheduleList,"CancelOperation",selectedData.OPSID,reason,session.UserID);
                    if(ret.indexOf("S^")===0){
                        $.messager.popover({msg:"预约取消成功",timeout:1500,type:"success"});
                        $("#applistBox").datagrid("reload");
                    }else{
                        $.messager.alert("提示","预约取消失败，原因："+ret,"error");
                    }
                }
            });
            reason.open();
        }
    }
}

$(document).ready(applist.initPage);