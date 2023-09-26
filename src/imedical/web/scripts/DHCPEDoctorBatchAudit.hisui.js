
//����	DHCPEDoctorBatchAudit.hisui.js
//����	�����ܼ����
//����	2020.05.09
//������  xy
$(function(){
		
	
	InitDoctorBatchAuditGrid();  
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
	  
      
    //�����ܼ�
	$("#BBatchAudit").click(function() {	
		BBatchAudit_click();		
        });
        
     info();
      
})

function info(){
	
	if(MainDoctor=="Y"){
		$("#BBatchAudit").linkbutton({text:'��������'});
		$("#NoResultFlag")[0].parentNode.children[1].style.display="none";
		$("#tNoResultFlag").hide();
	}
	else{$("#BBatchAudit").linkbutton({text:'��������'});}
	
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
			{field:'TRecordNum',width:130,title:'����'},
			{field:'TRegNo',width:100,title:'�ǼǺ�'},
			{field:'TName',width:100,title:'����'},
			{field:'TSex',width:100,title:'�Ա�'},
			{field:'TGroup',width:220,title:'��λ'},  
			{field:'TDepart',width:180,title:'����'},
			{field:'TErrInfo',width:450,title:'������Ϣ '},
			{field:'TAge',width:80,title:'����'}
			
			
		]],
			
	});
}

