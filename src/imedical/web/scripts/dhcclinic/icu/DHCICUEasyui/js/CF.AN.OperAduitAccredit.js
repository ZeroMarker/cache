var logUserId=session.UserID,
    logGroupId=session.GroupID,
    logLocId=session.DeptID;
$(function(){
    initControls();
    initDataGrid();
})

//初始化组件
function initControls(){
    
    $("#AccreditDept").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = $("#AccreditDept").val();
            param.Arg2 = "";
            param.ArgCnt = 2;
        },
        onSelect:function(){
            $("#AccreditCareProv").combobox("reload");
        }
    });
    $("#AccreditCareProv").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = $("#AccreditCareProv").val();
            param.Arg2 = $("#AccreditDept").combobox('getValue');
            param.ArgCnt = 2;
        }
    });
}
//加载数据表格
function initDataGrid(){
    var columns=[[
        {field:"AccreditLocation",title:"授权科室",width:100,hidden:true},
        {field:"AccreditCareProv",title:"授权医生",width:100,hidden:true},
        {field:"AccreditLocationDesc",title:"授权科室",width:100},
        {field:"AccreditCareProvDesc",title:"授权医生",width:100},
        {field:"AccreditStartDate",title:"开始日期",width:100},
        {field:"AccreditStartTime",title:"开始时间",width:100},
        {field:"AccreditEndDate",title:"结束日期",width:100},
        {field:"AccreditEndTime",title:"结束时间",width:100},
        {field:"CreatedUser",title:"创建授权医生",width:50,hidden:true},
        {field:"CreatedUserDesc",title:"创建授权医生",width:100},
        {field:"CreatedDate",title:"创建日期",width:100},
        {field:"CreatedTime",title:"创建时间",width:100},
        {field:"RowId",title:"RowId",width:50,hidden:true}
    ]];
    $("#AduitAccreditData").datagrid({
        fit:true,
        title:'科主任授权信息维护',
        headerCls:"panel-header-gray",
        iconCls:"icon-paper",
        rownumbers: true,
        pagination: true,
        pageSize: 300,
        pageList: [50, 100, 200,300,400,500],
        // remoteSort: false,
        // checkbox: true,
        // checkOnSelect:true,
        // selectOnCheck:true,
        singleSelect:true,
        columns:columns,
        url:ANCSP.DataQuery,
        onSelect:function(index,rowData){
            $("#AccreditDept").combobox("setValue",rowData.AccreditLocation);
            $("#AccreditCareProv").combobox("setValue",rowData.AccreditCareProv);
            $("#AccreditStartDate").datebox("setValue",rowData.AccreditStartDate);
            $('#AccreditStartTime').timespinner('setValue',rowData.AccreditStartTime);
            $("#AccreditEndDate").datebox("setValue",rowData.AccreditEndDate);
            $('#AccreditEndTime').timespinner('setValue',rowData.AccreditEndTime);
            $("#RowId").val(rowData.RowId)
        },
        onUnselect:function(){
            $("#AccreditDept").combobox("setValue","");
            $("#AccreditCareProv").combobox("setValue","");
            $("#AccreditStartDate").datebox("setValue","");
            $('#AccreditStartTime').timespinner('setValue',"");
            $("#AccreditEndDate").datebox("setValue","");
            $('#AccreditEndTime').timespinner('setValue',"");
            $("#RowId").val("")
        },
        onBeforeLoad:function(param){
            param.ClassName="CIS.AN.BL.OperAduitAccredit";
            param.QueryName="FindAduitAccreditList";
            param.Arg1=session.DeptID;
            param.ArgCnt=0;
        },
        toolbar:[
            {
                iconCls:'icon-add',
                text:'新增',
                handler:function(){
                    $("#dataDialog").dialog({
                        title: "新增",
                        iconCls: "icon-add",
                        buttons:[
                            {
                                text:'确认',
                                handler:function(){
                                    var deptID= $("#AccreditDept").combobox("getValue"),
                                    careProvID =$("#AccreditCareProv").combobox("getValue"),
                                    startDate=$("#AccreditStartDate").datebox("getValue"),
                                    startTime=$('#AccreditStartTime').timespinner('getValue'),
                                    endDate=$("#AccreditEndDate").datebox("getValue"),
                                    endTime=$('#AccreditEndTime').timespinner('getValue'),
                                    userID=session.UserID;
                                    var result=dhccl.runServerMethod("CIS.AN.BL.OperAduitAccredit","SaveAduitAccredit",deptID, careProvID, startDate, startTime, endDate, endTime, userID);
                                    if(result.success){
                                        $("#dataDialog").dialog('close');
                                        $('#AduitAccreditData').datagrid("reload");
                                    }else{
                                        $.messager.alert("提示","添加失败："+result.result,"info");
                                    }
                                }
                            },
                            {
                                text:'关闭',
                                handler:function(){
                                    $("#dataDialog").dialog('close');
                                }
                            }
                        ]
                    });
                    $("#dataDialog").dialog("open");
                }
            },
            {
                iconCls:'icon-edit',
                text:'修改',
                handler:function(){
                    var selectedObj=$("#AduitAccreditData").datagrid("getSelected");
                    if(!selectedObj){
                        $.messager.alert("提示","请选择一条记录","info");
                        return;
                    }
                    $("#dataDialog").dialog({
                        title: "修改",
                        iconCls: "icon-edit",
                        buttons:[
                            {
                                text:'确认',
                                handler:function(){
                                    var deptID= $("#AccreditDept").combobox("getValue"),
                                    careProvID =$("#AccreditCareProv").combobox("getValue"),
                                    startDate=$("#AccreditStartDate").datebox("getValue"),
                                    startTime=$('#AccreditStartTime').timespinner('getValue'),
                                    endDate=$("#AccreditEndDate").datebox("getValue"),
                                    endTime=$('#AccreditEndTime').timespinner('getValue'),
                                    userID=session.UserID,
                                    rowId=selectedObj.RowId;
                                    var result=dhccl.runServerMethod("CIS.AN.BL.OperAduitAccredit","SaveAduitAccredit",deptID, careProvID, startDate, startTime, endDate, endTime, userID,rowId);
                                    if(result.success){
                                        $("#dataDialog").dialog('close');
                                        $('#AduitAccreditData').datagrid("reload");
                                    }else{
                                        $.messager.alert("提示","操作失败："+result.result,"info");
                                    }
                                }
                            },
                            {
                                text:'关闭',
                                handler:function(){
                                    $("#dataDialog").dialog('close');
                                }
                            }
                        ]
                    });
                    $("#dataDialog").dialog("open");
                }
            },
            {
                iconCls:'icon-remove',
                text:'删除',
                handler:function(){
                    var selectedObj=$("#AduitAccreditData").datagrid("getSelected");
                    if(!selectedObj){
                        $.messager.alert("提示","请选择一条记录","info");
                        return;
                    }
                    var result=dhccl.runServerMethod("CIS.AN.BL.OperAduitAccredit","DeleteAduitAccredit",selectedObj.RowId);
                    if(result.success){
                        $("#dataDialog").dialog('close');
                        $('#AduitAccreditData').datagrid("reload");
                    }else{
                        $.messager.alert("提示","操作失败："+result.result,"info");
                    }
                }
            }
            
        ]
    });
}
