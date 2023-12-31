$(function(){
	function Search(){
		var operDeptId=$("#operDeptSelect").combobox("getValue");
		var opRoomId=$("#opRoomSelect").combobox("getValue");
		var devInfoStr=dhccl.runServerMethodNormal("CIS.AN.BL.DeviceStatus","GetOverviewDevInfo",operDeptId,opRoomId);
		var devInfo=JSON.parse(devInfoStr);
		$("#equipTable").datagrid("loadData",{total:0,rows:[]});
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
            { field:"operator" ,title: "操作", width: 55 ,align:'center',
				formatter:function(value, row, index){
					var str = '<a href="#" name="详细" onclick="onClickRowButton(\''+row.OpsId+'\')" class="easyui-linkbutton" >详细</a>';
					return str;
				}},
			{ field: "Name", title: "设备名称", width: 150,},
			
            { field: "RoomName", title: "手术间", width: 120,},
            { field: "IpAddress", title: "IP地址", width: 150,},
            { field: "Port", title: "通信端口", width: 100 },
            { field: "LastCollectTime", title: "最近数据时间", width: 150, formatter:function(value, row, index){
	            if (row.LastCollectTime!="")
	            {
		            var date=row.LastCollectTime.split(" ")[0];
		            var time=row.LastCollectTime.split(" ")[1];
		            var option='';
		            var str='<a title="'+date+'" class="hisui-tooltip">'+time+'</a>';
		            // var str="<span title='"+date+"'>"+time+"</span>"
		            return str;
	            }
	            else
	            {
		            return "";
	            }
	            
            }},
            { field: "Status", title: "当前状态", width: 500 },
            
			{ field: "EquipId", title: "设备Id", width: 100,},
			{ field: "PatName", title: "当前病人", width: 150,},
			{ field: "PatientNo", title: "病人ID", width: 150,},
			{ field: "OpsId", title: "OpsId", width: 100,},
			{ field: "OpStatus", title: "手术状态", width: 80,},
            { field: "AnStartDatetime", title: "开始时间", width: 100,},
            { field: "AnEndDatetime", title: "结束时间", width: 100,},
            { field: "PACUStartDatetime", title: "PACU开始时间", width: 100,},
            { field: "PACUEndDatetime", title: "PACU结束时间", width: 100,},
            
            
            
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
	    onLoadSuccess: function(){
                    $(".hisui-tooltip").tooltip({
                        onShow: function () {
                            $(this).tooltip('tip').css({
                                borderColor: '#000'
                            });
                        }
                    });

		}
    });
    
    $("#operDeptSelect").combobox({
		valueField:'Id',
		textField:'Text',
		multiple:false,
		editable:true,
		panelHeight:"auto",
		url: "CIS.AN.DataQuery.csp",
		mode:"remote",
		onBeforeLoad: function(param){
			param.ClassName = "CIS.AN.BL.DeviceStatus";
			param.QueryName = "FindOperLoc";
			param.Arg1= $("#operDeptSelect").combobox("getText");
			param.ArgCnt= 1;
		},
		onChange:function()
		{
			$("#opRoomSelect").combobox("reload");
		}
	});
	$("#opRoomSelect").combobox({
		valueField:'Id',
		textField:'Text',
		multiple:false,
		editable:true,
		panelHeight:"auto",
		url: "CIS.AN.DataQuery.csp",
		mode:"remote",
		onBeforeLoad: function(param){
			param.ClassName = "CIS.AN.BL.DeviceStatus";
			param.QueryName = "FindOperRoom";
			var wardId=$("#operDeptSelect").combobox("getValue");
			param.Arg1= wardId;
			param.Arg2= $("#opRoomSelect").combobox("getText");
			param.ArgCnt= 2;
		}
	});
}

function onClickRowButton(icuaId)
{
	window.open("CIS.AN.DevStatus.csp?opsId="+icuaId);
}