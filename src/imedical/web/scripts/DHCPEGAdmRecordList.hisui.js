
//名称	DHCPEGAdmRecordList.hisui.js
//功能	团体日志操作记录
//创建	2020.12.22
//创建人  xy

$(function(){
	

	Info();

	InitGAdmRecordListGrid();  
     
  
})

function Info(){
	
	var Info=tkMakeServerCall("web.DHCPE.GAdmRecordManager","GetBaseInfo",GAdmId);
	var Arr=Info.split("^");
	$("#GName").val(Arr[0]);
	$("#GCode").val(Arr[1]);
	$("#PreDate").val(Arr[2]);
	
}

function InitGAdmRecordListGrid(){
	
	$HUI.datagrid("#GAdmRecordListGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		
		queryParams:{
			ClassName:"web.DHCPE.GAdmRecordManager",
			QueryName:"FindGAdmRecord",
			GAdmId:GAdmId	
				
		},
		columns:[[

		    {field:'TDate',width:'100',title:'日期'},
			{field:'TTime',width:'90',title:'时间'},
			{field:'TType',width:'100',title:'类型'},
			{field:'TRemark',width:'450',title:'信息'},
			{field:'TUser',width:'90',title:'操作人'},
			{field:'TID',title:'ID',hidden: true}
						
		]]
			
	})
		
}



