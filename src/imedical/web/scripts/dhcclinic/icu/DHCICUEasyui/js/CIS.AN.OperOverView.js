function initPage(){
    $(".textbox").attr("readonly","readonly");
    initAppForm(); 
}
/**
 * 初始化手术申请表单
 */
function initAppForm(){
    initOperBox();
    loadAppFormData();
}
function initOperBox(){
    var columns=[[
        {field:"RowId",title:"ID",hidden:true},
        {field:"Operation",title:"Operation",hidden:true},
        {field:"OperClass",title:"OperClass",hidden:true},
        {field:"Surgeon",title:"Surgeon",hidden:true},
        {field:"Assistant",title:"Assistant",hidden:true},
        {field:"OperInfo",title:"手术名称",width:360,formatter:function(value,row,index){
            let retArr=[row.OperationDesc];
            if(row.OperClassDesc){
                retArr.push("("+row.OperClassDesc);
            }
            if(row.BodySiteDesc){
                if (row.OperClassDesc) retArr.push(",")
                retArr.push(row.BodySiteDesc);
            }
            if(row.BladeTypeDesc){
                if(row.OperClassDesc || row.BodySiteDesc) retArr.push(",")
                retArr.push(row.BladeTypeDesc);
            }
            if(row.OperClassDesc || row.BodySiteDesc || row.BladeTypeDesc){
                retArr.push(")");
            }

            return retArr.join("");
        }},
        {field:"OperNote",title:"名称备注",width:180},
        {field:"SurgeonDeptDesc",title:"术者科室",width:100},
        {field:"SurgeonDesc",title:"主刀",width:80},
        {field:"AssistantDesc",title:"助手",width:140},
        {field:"SurgeonExpert",title:"外院专家",width:80}
    ]];
    $("#operationBox").datagrid({
        width: 992,
        height: 120,
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        singleSelect: true,
        rownumbers: true,
        url: ANCSP.DataQuery,
        columns:columns
    });
}
function loadAppFormData(){
    $("#appDetailForm").form("clear");
    setOperAppData();
    setOperList();
}
$('.time-circle').each(function (index) {
    $(this).on('click', function () {
        //$(this).css("background", "#CCCCCC");
    })
})
function setOperAppData(){
    let opsId=dhccl.getQueryString("opsId");
    if (!opsId){
        opsId=session.OPSID || '';
    }
    var appDatas=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperScheduleList,
        QueryName:"FindOperScheduleList",
        Arg1:"",
        Arg2:"",
        Arg3:"",
        Arg4:opsId,
        ArgCnt:4
    },"json");
    if(appDatas && appDatas.length>0){
        var Item=0;
        var appData=appDatas[0];
        $("#appDetailForm").form("load",appData);
        switch (appData.StatusCode){
			case "RoomIn":
                Item=5;
			break;
			case "RoomOut":
                Item=6;
			break;
			case "PACUIn":
                Item=8;
			break;
			case "Finish":
                Item=9;
			break;
			default:
            break;
        }
        for(var i=Item+1;i<=10;i++){
            $("#"+i).css("background","#CCCCCC");
            $("#Item"+i).css("background","#CCCCCC");
        }
    }
}
function setOperList(){
    let opsId=dhccl.getQueryString("opsId");
    if (!opsId){
        opsId=session.OPSID || '';
    }
    var operList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperationList,
        QueryName:"FindOperationList",
        Arg1:opsId,
        ArgCnt:1
    },"json");
    if(operList && operList.length>0)
    {
        $("#operationBox").datagrid("loadData",operList);
    }
}
$(document).ready(initPage);

