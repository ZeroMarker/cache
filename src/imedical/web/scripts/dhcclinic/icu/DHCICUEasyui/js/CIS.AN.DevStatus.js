$(function(){
	//InitFormItem();
	//InitGroupData();
	function GetQueryString(name)
	{
	     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
	     var r = window.location.search.substr(1).match(reg);
	     if(r!=null)return  unescape(r[2]); return null;
	}
	var opsId=""
	if (session.OPSID)
	{
		opsId=session.OPSID;
	}
	else
	{
		icuaId=GetQueryString("opsId");
	}
	function Search(){
		var devInfoStr=dhccl.runServerMethodNormal("CIS.AN.BL.DeviceStatus","GetOpDevInfo",opsId);
		var devInfo=JSON.parse(devInfoStr);
		$("#anStartTime").html(devInfo.AnStartDatetime);
		$("#anEndTime").html(devInfo.AnEndDatetime);
		$("#pacuStartTime").html(devInfo.PACUStartDatetime);
		$("#pacuEndTime").html(devInfo.PACUEndDatetime);
		$("#opsId").html(devInfo.OpsId);
		$("#anId").html(devInfo.AnId);
		$("#lastDataListTable").datagrid("loadData",{total:0,rows:[]});
		$("#equipTable").datagrid("loadData",{total:0,rows:[]});
		for(var i=0;i<devInfo.LastDataList.length;i++){
			var item=devInfo.LastDataList[i];
			$("#lastDataListTable").datagrid("insertRow",{
				index:1,
				row:item
			});
		}
		for(var i=0;i<devInfo.EquipList.length;i++){
			var item=devInfo.EquipList[i];
			$("#equipTable").datagrid("insertRow",{
				index:1,
				row:item
			});
		}
	}
	$("#searchBtn").click(function(){
		Search();
	});
	
	InitView();
	Search();
});

function InitView(){
	var columns = [
        [
        	{ field: "Name", title: "名称", width: 120},
        	{ field: "Date", title: "日期", width: 120 },
            { field: "Time", title: "时间", width: 120 },
            { field: "Value", title: "值", width: 120 },
        ]
    ];
    $("#lastDataListTable").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        columns:columns
    });
    var columns = [
        [
            { field:"operator" ,title: "操作", width: 50 ,align:'center',width:$(this).width()*0.1,
				formatter:function(value, row, index){
					var str = '<a href="#" name="查询" onclick="onClickRowButton(\''+row.EquipId+'\')" class="easyui-linkbutton" >查询</a>';
					return str;
				}},
            { field: "Name", title: "设备名称", width: 200,},
            { field: "EquipId", title: "设备Id", width: 80,},
            { field: "DeviceModel", title: "设备型号", width: 150,},
            { field: "IP", title: "IP地址", width: 150,},
            { field: "Port", title: "通信端口", width: 80,},
            { field: "StartTime", title: "开始时间", width: 150 },
            { field: "EndTime", title: "结束时间", width: 150 },
            { field: "LastCollectTime", title: "最近一次采集数据", width: 150 },
            { field: "Status", title: "当前状态", width: 500 },
            { field: "" }
            
        ]
    ];
    $("#equipTable").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        columns:columns,
        onClickCell: function (index, field, value) {
	        if (field=="Status"){
		        $.messager.confirm('设备状态',value,function(r){
				   
				});
				
	        }
	    },
    });
    
    var columns = [
        [
        	{ field: "Name", title: "名称", width: 120},
            { field: "CollectDate", title: "日期", width: 120 },
            { field: "CollectTime", title: "时间", width: 120 },
            { field: "Value", title: "值", width: 120 },
        ]
    ];
    equipDataTable=$("#equipDataTable").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        columns:columns,
        url: ANCSP.DataQuery,
        
    });
}
var curSlectEquipId=""
var equipDataTable="";
function onClickRowButton(equipId){
	curSlectEquipId=equipId;
	var param={}
	param.ClassName="CIS.AN.BL.DeviceStatus";
    param.QueryName="FindDataByEquipId";
    param.Arg1 = equipId;
    param.ArgCnt=1;
	equipDataTable.datagrid("reload",param);
}