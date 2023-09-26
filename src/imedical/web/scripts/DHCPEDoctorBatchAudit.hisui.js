
//名称	DHCPEDoctorBatchAudit.hisui.js
//功能	批量总检初审
//创建	2020.05.09
//创建人  xy
$(function(){
		
	
	InitDoctorBatchAuditGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
	  
      
    //批量总检
	$("#BBatchAudit").click(function() {	
		BBatchAudit_click();		
        });
        
     info();
      
})

function info(){
	
	if(MainDoctor=="Y"){
		$("#BBatchAudit").linkbutton({text:'批量复审'});
		$("#NoResultFlag")[0].parentNode.children[1].style.display="none";
		$("#tNoResultFlag").hide();
	}
	else{$("#BBatchAudit").linkbutton({text:'批量初审'});}
	
}
function BBatchAudit_click(){
	var ArrivedDate=$("#ArrivedDate").datebox('getValue');
	//var AuditDate=$("#AuditDate").datebox('getValue');
	var AuditDate=""
	var NoResult="0"
	var NoResultFlag=$("#NoResultFlag").checkbox('getValue');
	if(NoResultFlag){ var NoResult="1"}
	else{var NoResult="0"}
	var DocID=session['LOGON.USERID'];
	
	var ret=tkMakeServerCall("web.DHCPE.DoctorBatchRecord","BatchAuditGen",ArrivedDate,AuditDate,DocID,MainDoctor,NoResult);
	BFind_click();
}


function BFind_click()
{
	var ShowErrFlag="0"
	var ShowErr=$("#ShowErr").checkbox('getValue');
	if(ShowErr){ var ShowErrFlag="1"}
	else{var ShowErrFlag="0"}
	
	$("#DoctorBatchAuditGrid").datagrid('load',{
			ClassName:"web.DHCPE.DoctorBatchRecord",
			QueryName:"AuditRecordQuery",
			ArrivedDate:$("#ArrivedDate").datebox('getValue'),
			ShowErr:ShowErrFlag,
			MainDoctor:MainDoctor,
			
			});

}


function InitDoctorBatchAuditGrid(){
	$HUI.datagrid("#DoctorBatchAuditGrid",{
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
			QueryName:"AuditRecordQuery",

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

