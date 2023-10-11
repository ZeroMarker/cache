$(function(){
	function Search(){
		var wardId=$("#wardSelect").combobox("getValue");
		var bedId=$("#bedSelect").combobox("getValue");
		var devInfoStr=dhccl.runServerMethodNormal("web.DHCICUDeviceStatus","GetWardDevInfo",wardId,bedId);
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
            { field:"operator" ,title: "操作", width: 50 ,align:'center',
				formatter:function(value, row, index){
					
					var str = '<a href="#" name="详细" onclick="onClickRowButton(\''+row.IcuaId+'\')" class="easyui-linkbutton" >详细</a>';
					return str;
				}},
			{ field: "Name", title: "设备名称", width: 200,},
			{ field: "IPAddress", title: "IP地址", width: 150,},
			{ field: "Port", title: "通信端口", width: 120 },
			{ field: "LastCollectTime", title: "最近一次采集数据", width: 150 ,formatter:function(value, row, index){
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
            { field: "Status", title: "当前状态", width: 200 },
            
			{ field: "BedName", title: "床位", width: 100,},
			{ field: "PatName", title: "当前病人", width: 110,},
			{ field: "PatientNo", title: "病人ID", width: 150,},
			{ field: "IcuaId", title: "IcuaId", width: 100,},
			{ field: "ICUStatus", title: "记录状态", width: 80,},
            { field: "StartDatetime", title: "开始时间", width: 180,},
            { field: "EndDatetime", title: "结束时间", width: 180,},
           
            { field: "EquipId", title: "设备Id", width: 90,},
            
            
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
	    }
    });
    
    $("#wardSelect").combobox({
		valueField:'Id',
		textField:'Text',
		multiple:false,
		editable:true,
		panelHeight:"auto",
		url: "CIS.AN.DataQuery.csp",
		mode:"remote",
		onBeforeLoad: function(param){
			param.ClassName = "web.DHCICUDeviceStatus";
			param.QueryName = "FindWard";
			param.Arg1= $("#bedSelect").combobox("getText");
			param.ArgCnt= 1;
		},
		onChange:function()
		{
			$("#bedSelect").combobox("reload");
		}
	});
	$("#bedSelect").combobox({
		valueField:'Id',
		textField:'Text',
		multiple:false,
		editable:true,
		panelHeight:"auto",
		url: "CIS.AN.DataQuery.csp",
		mode:"remote",
		onBeforeLoad: function(param){
			param.ClassName = "web.DHCICUDeviceStatus";
			param.QueryName = "FindBed";
			var wardId=$("#wardSelect").combobox("getValue");
			param.Arg1= wardId;
			param.Arg2= $("#bedSelect").combobox("getText");
			param.ArgCnt= 2;
		}
	});
}

function onClickRowButton(icuaId)
{
    var windowsHeight=83;
    var screenHeight=140;
	 var customWidth=window.screen.width/1.5;
    var customHeight=800-windowsHeight; //window.screen.height/1.5; 
    //window.screen.height获得屏幕的高，window.screen.width获得屏幕的宽
    var iTop = (window.screen.height - screenHeight - 800) / 2; //获得窗口的垂直位置;
    var iLeft = (window.screen.width - 10 - customWidth) / 2; //获得窗口的水平位置;
    var url="DHC.ICU.DeviceStatus.csp?icuaId="+icuaId;
    // window.open(url, "",'width=customWidth,top='+iTop+',left='+iLeft+',height=300');
     window.open(url, "", 'top=' + iTop + ',left=' + iLeft +',width='+ customWidth +',height='+customHeight +
        ',toolbar=no,menubar=no,scrollbars=no,resizeable=no,location=no,status=no'); 
    //window.open(url, "", 'width=400,height=100, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no'); 
	//window.open("DHC.ICU.DeviceStatus.csp?icuaId="+icuaId);
}
