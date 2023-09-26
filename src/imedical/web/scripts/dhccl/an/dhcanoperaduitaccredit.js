var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];
$(function(){
    initControls();
    initDataGrid();
})

//初始化组件
function initControls(){
    var anaactloc=$HUI.combobox("#ANAACtloc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        required:true,
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="";
            param.EpisodeID="";
        },
        onLoadSuccess:function(data){
            anaactloc.setValue(logLocId);
        } 
    });
    anaactloc.disable();
    var ANAACtpcp=$HUI.combobox("#ANAACtpcp",{
        url:$URL+"?ClassName=web.UDHCANOPArrange&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        required:true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=anaactloc.getValue();
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
        },
        defaultFilter:4,
        blurValidValue:true
    });
    var startdate=new Date();
    var enddate=new Date(startdate.getTime() + 3*24*60*60*1000);
    $("#ANAAStartDate").datebox('setValue',$.fn.datebox.defaults.formatter(startdate));
    $("#ANAAEndDate").datebox('setValue',$.fn.datebox.defaults.formatter(enddate));
}
//加载数据表格
function initDataGrid(){
    var selectRowId=0,preRowId=0;
    var aduitaccreditdata=$HUI.datagrid("#AduitAccreditData",{
        fit: true,
        fitColumns:true,
        singleSelect: true,
        // nowrap: false,
        title:'科主任授权信息维护',
        iconCls:'icon-paper',
        headerCls:'panel-header-gray',
        border:true,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANAduitAccredit",
            QueryName:"FindAduitAccreditList",
            curLocId:($("#ANAACtloc").combobox('getValue')=="")?logLocId:$("#ANAACtloc").combobox('getValue')
        },
        columns:[
            [
                { field: "ANAARowId", title: "系统号", width: 60, sortable: true },
                { field: "ANAACtlocId", title: "授权科室Id", width: 90 ,hidden:true},
                { field: "ANAACtlocDesc", title: "授权科室", width: 200 },
                { field: "ANAACtpcpId", title: "授权医生Id", width:90 ,hidden:true},
                { field: "ANAACtpcpDesc", title: "授权医生", width: 100 },
                { field: "ANAAStartDT", title: "授权开始时间", width: 200 },
                { field: "ANAAEndDT", title: "授权结束时间", width: 200 },
                { field: "ANAACreateUserName", title: "创建授权医生", width: 100 },
                { field: "ANAACreateDT", title: "创建日期", width: 160 }
            ]
        ],
        onSelect:function(rowIndex,rowData){
            
        },
        toolbar:[
            {
                iconCls:'icon-add',
                text:'新增',
                handler:function(){
                    saveAduitAccreditHandler();
                }
            },
            {
                iconCls:'icon-edit',
                text:'修改',
                handler:function(){
                    var selectObj=$("#AduitAccreditData").datagrid('getSelected');
                    if(selectObj)
                    {
                        saveAduitAccreditHandler(selectObj);
                    }else{
                        $.messager.alert("提示","请选择你要修改的行！","warning");
                        return;
                    }
                }
            },
            {
                iconCls:'icon-remove',
                text:'删除',
                handler:function(){
                    var selectObj=$("#AduitAccreditData").datagrid('getSelected');
                    if(selectObj)
                    {
                        deleteAduitAccredit(selectObj.ANAARowId);
                    }else{
                        $.messager.alert("提示","请选择你要删除的行！","warning");
                        return;
                    }
                }
            }
        ]
    })
}
function saveAduitAccreditHandler(obj)
{   var titleName="新增手术审核授权";
    if(obj)
    {
	    titleName="修改手术审核授权";
        $("#ANAARowID").val(obj.ANAARowId);
        $("#ANAACtloc").combobox('setValue',obj.ANAACtlocId);
        $("#ANAACtpcp").combobox('setValue',obj.ANAACtpcpId);
        $("#ANAAStartDate").datebox('setValue',obj.ANAAStartDT.split(" ")[0]);
        $("#ANAAStartTime").timespinner('setValue',obj.ANAAStartDT.split(" ")[1]);
        $("#ANAAEndDate").datebox('setValue',obj.ANAAEndDT.split(" ")[0]);
        $("#ANAAEndTime").timespinner('setValue',obj.ANAAEndDT.split(" ")[1]);
        
    }else{
		$("#ANAACtloc").combobox('setValue',logLocId);
		var startdate=new Date();
    	var enddate=new Date(startdate.getTime() + 3*24*60*60*1000);
    	$("#ANAAStartDate").datebox('setValue',$.fn.datebox.defaults.formatter(startdate));
    	$("#ANAAEndDate").datebox('setValue',$.fn.datebox.defaults.formatter(enddate));
	}
    $("#AduitAccreditDialog").show();
    $("#AduitAccreditDialog").dialog({
        iconCls:'icon-w-save',
        title:titleName,
        resizable:true,
        modal:true,
        buttons:[
            {
				text:'确认',
				handler:function(){
                    saveAduitAccredit();
                }
            },
            {
				text:'关闭',
				handler:function(){
                    $("#AduitAccreditDialog").dialog('close');
                }
            }
        ]
    })
}
function saveAduitAccredit(){
    var rowId=$("#ANAARowID").val();
    var ANAACtloc=$("#ANAACtloc").combobox('getValue');
    var ANAACtpcp=$("#ANAACtpcp").combobox('getValue');
	var ANAACtpcpDesc=$("#ANAACtpcp").combobox('getText');
    var ANAAStartDate=$("#ANAAStartDate").datebox('getValue');
	var ANAAStartTime=$("#ANAAStartTime").timespinner('getValue');
	var ANAAEndDate=$("#ANAAEndDate").datebox('getValue');
	var ANAAEndTime=$("#ANAAEndTime").timespinner('getValue');
    if(ANAACtloc=="")
    {
        $.messager.alert("提示","授权科室不能为空！","info");
        return;
    }
    if((ANAACtpcp=="")||(ANAACtpcpDesc==""))
    {
        $.messager.alert("提示","授权医生不能为空！","info");
        return;
    }
    if(ANAAStartDate=="")
    {
        $.messager.alert("提示","授权开始日期不能为空！","info");
        return;
    }
    if(ANAAStartTime=="")
    {
        $.messager.alert("提示","授权开始时间不能为空！","info");
        return;
    }
    var result=$.m({
        ClassName:"web.DHCANAduitAccredit",
        MethodName:"SaveAduitAccredit",
        rowId:rowId,
        ctlocId:ANAACtloc,
        ctpcpId:ANAACtpcp,
        startDate:ANAAStartDate,
        startTime:ANAAStartTime,
        endDate:ANAAEndDate,
        endTime:ANAAEndTime,
        userId:logUserId
    },false)
    if(result>0)
    {
        $.messager.alert("提示","系统号为"+result+"的授权信息保存成功！","info");
        $("#conditionForm").form('clear');
        $("#AduitAccreditDialog").dialog('close');
        $("#AduitAccreditData").datagrid("reload");
    }else
    {
        $.messager.alert("提示","授权信息保存失败！","info");
        return ;
    }
}

function deleteAduitAccredit(rowId){
    var result=$.m({
        ClassName:"web.DHCANAduitAccredit",
        MethodName:"DeleteAduitAccredit",
        RowID:rowId
    },false);
    if(result==0)
    {
        $.messager.alert("提示","授权信息删除成功！","info");
        $("#conditionForm").form('clear');
        $("#AduitAccreditData").datagrid("reload");
    }else
    {
        $.messager.alert("提示","授权信息删除失败！","info");
        return ;
    }
}