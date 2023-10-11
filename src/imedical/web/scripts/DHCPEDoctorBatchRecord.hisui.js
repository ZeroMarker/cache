
//名称	DHCPEDoctorBatchRecord.hisui.js
//功能	批量录入
//创建	2023.02.14
//创建人  xy

$(function(){
		
	
	InitDoctorBatchRecordGrid();  
     
   //批量录入
   $("#BBatchResult").click(function() {
			BBatchResult_click();		
        });
    
    //查询
	$("#BFind").click(function() {
			BFind_click();		
        });

      
})

//批量录入
function BBatchResult_click(){

	var ArrivedDate="",CheckDate="",DocID="",LocID="",GroupID="";
    
    var DocID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	var GroupID=session['LOGON.GROUPID'];
	
	var ArrivedDate=$("#ArrivedDate").datebox('getValue');
	
	var CheckDate=$("#CheckDate").datebox('getValue');
	
	var ret=tkMakeServerCall("web.DHCPE.DoctorBatchRecord","BatchSaveResult",ArrivedDate,CheckDate,DocID,GroupID,LocID);
	
	BFind_click();
	
}


//查询
function BFind_click()
{
	var ShowErrFlag="0"
	var ShowErr=$("#ShowErr").checkbox('getValue');
	if(ShowErr){ var ShowErrFlag="1"}
	else{var ShowErrFlag="0"}
	
	$("#DoctorBatchRecordGrid").datagrid('load',{
			ClassName:"web.DHCPE.DoctorBatchRecord",
			QueryName:"RecordQuery",
			ArrivedDate:$("#ArrivedDate").datebox('getValue'),
			ShowErr:ShowErrFlag,
			
			});

}


function InitDoctorBatchRecordGrid(){
	$HUI.datagrid("#DoctorBatchRecordGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.DoctorBatchRecord",
			QueryName:"RecordQuery",

		},
		
		columns:[[
			{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TRecordNum',width:130,title:'次数'},
			{field:'TRegNo',width:100,title:'登记号'},
			{field:'TName',width:100,title:'姓名'},
			{field:'TSex',width:100,title:'性别'},
			{field:'TGroup',width:220,title:'单位'},  
			{field:'TDepart',width:180,title:'部门'},
			{field:'TErrInfo',width:450,title:'错误信息 '},
			{field:'TAge',width:80,title:'年龄'}
				
		]],
			
	});
}



