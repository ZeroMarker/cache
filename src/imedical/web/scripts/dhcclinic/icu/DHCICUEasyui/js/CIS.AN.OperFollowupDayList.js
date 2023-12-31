//20210802
var selectRow;

function initPage(){
    initForm();
    initFollowupBox();
    //var v = window.parent.$("#commonList").html();
    //alert(v)
}

function initForm(){

    //新增随访记录
    /*
    $("#btnAdd").linkbutton({
        onClick: function() {
            addFollowupList();
        }
    });

    //删除随访记录
    $("#btnDelete").linkbutton({
        onClick: function() {
            deleteFollowupList();
        }
    });
*/
    //新增随访内容框(确认)
    $("#btnConfirm").linkbutton({
        onClick: function() {
            confirmFollowupList();
        }
    });

    //新增随访内容框(取消)
    $("#btnCancel").linkbutton({
        onClick: function() {
            $("#addNoDate").dialog("close");
        }
    });

    $("#Moulds").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperFollowup;
            param.QueryName="FindFollowupMould";
            param.ArgCnt=0;
        },
        mode:"remote"
    });
}

//新增随访记录
function addFollowupList()
{
    $("#addNoDate").dialog("open")
    {
        $("#No").val("");
        dhccl.parseDateFormat();
        $HUI.timespinner("#FollowUpTime",{});
        var dateNeed=new Date();
       //  var today=(new Date()).format("yyyy-MM-dd HH:mm");
        var dateHisFormat=dhccl.runServerMethodNormal(ANCLS.BLL.OperFollowup,"GetHisDateFormat","");
        //alert(dateHisFormat)
        var needDate=dateNeed.getDate()
        var needMonth=(dateNeed.getMonth()+1)
        var needHour=dateNeed.getHours();
        var needMinite=dateNeed.getMinutes();
        if((needMonth>=0)&&(needMonth<=9))
        {
	        needMonth="0"+needMonth;
        }
        if((needDate>=0)&&(needDate<=9))
        {
	        needDate="0"+needDate;
        }
        if((needHour>=0)&&(needHour<=9))
        {
	        needHour="0"+needHour;
        }
        if((needMinite>=0)&&(needMinite<=9))
        {
	        needMinite="0"+needMinite;
        }
        var needYear=dateNeed.getFullYear()
        if(dateHisFormat=="DMY")
        {
	        
        var today=needDate+"/"+needMonth+"/"+needYear;
        }
        else if(dateHisFormat=="YMD")
        {
        var today=needYear+"-"+needMonth+"-"+needDate;
        }
        var curTime=needHour+":"+needMinite;
        
        $("#Date").datebox("setValue",today);
         $("#FollowUpTime").timespinner("setValue",curTime);
        $("#Moulds").combobox("setValue","1")   //默认模板
    };
}

//新增随访框(确认)
function confirmFollowupList()
{
    var no=$("#No").val();
    //old
    //var selectdate=$("#Date").datetimebox("getValue");
   // var date=selectdate.split(" ")[0];
   // var time=selectdate.split(" ")[1];
    //
      var date=$("#Date").datebox("getValue");
      var time= $("#FollowUpTime").timespinner("getValue");
         
    var moulId=$("#Moulds").combobox("getValue");
    //alert(no+"^"+date+"^"+time)
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"AddFollowupList",session.OPSID,session.UserID,no,date,time,moulId);
    if (ret=="0")
    {
        $.messager.alert("提示","添加成功！");
        $("#addNoDate").dialog("close");
        $("#followupList").datagrid("reload"); 
    }
    else
    {
        $.messager.alert("提示","添加失败，原因："+ret.result,"error")
    }
}

//删除随访记录
function deleteFollowupList()
{
    //alert(session.OPSID+"^"+session.UserID)
    //alert(selectRow.RowId+"^"+selectRow.Status)
    if(selectRow){
        $.messager.confirm("提示","是否删除此病人第"+selectRow.No+"次的随访记录",function (r)
        {
            if(r)
            {
                var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"DeleteFollowupList",selectRow.RowId);
                if (ret=="0")
                {
                    $.messager.alert("提示","删除成功！");
                    $("#followupList").datagrid("reload"); 
                }
                else
                {
                    $.messager.alert("提示","删除失败，原因："+ret,"error")
                }
            } 
        } );
    }
    else
    {
        $.messager.alert("提示","请选择一行！","error");
        return;
    }
   
}

//加载随访列表
function initFollowupBox(){

    // 设置表格属性
    var columns=[[
        {field:"DateTime",title:"随访日期",width:170},
        {field:"No",title:"随访次数",width:80},
        {field:"Type",title:"随访类型",width:90},
        {field:"User",title:"操作人员",width:80},
        {field:"Status",title:"状态",width:70},
        {field:"RowId",title:"RowId",width:1,hidden:true},
        {field:"MouldId",title:"MouldId",width:1,hidden:true},
    ]];
	//alert(session.OPSID)
    $("#followupList").datagrid({
        title:"术后随访记录",
        headerCls:"panel-header-gray",
		fit:true,
        columns:columns,
        //toolbar:"#followupTools",
        toolbar:[
            {
                iconCls:'icon-add',
                text:'新增',
                handler:function(){
                    addFollowupList()
                }
            },
            {
                iconCls:'icon-cancel',
                text:'删除',
                handler:function(){
                    deleteFollowupList();
                }
            }

        ],
        iconCls:"icon-paper",
        rownumber:true,
        idField:"RowId",
        pagination: true,
        pageSize: 50,
        pageList: [50, 100],
        checkOnSelect:false,
        selectOnCheck:false,
        singleSelect:true,
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperFollowup;
            param.QueryName="FindFollowupList";
            param.Arg1=session.OPSID;
            param.ArgCnt=1;
        },
        onSelect:function(rowIndex,rowData)
        {
            selectRow=rowData;
            var url='<iframe src="CIS.AN.OperFollowupDayDetails.csp?RowId='+rowData.RowId+'&opsId='+session.OPSID+'&MouldId='+rowData.MouldId+'&Index='+rowIndex+'" id="OperFollowupDayDetails" name="OperFollowupDayDetails" style="width: 550px;height: 100%;;border:none;"></iframe>';       
            window.parent.$("#commonDetails").empty();
            window.parent.$("#commonDetails").append(url);
        }
        
    });

}

$(document).ready(initPage);

