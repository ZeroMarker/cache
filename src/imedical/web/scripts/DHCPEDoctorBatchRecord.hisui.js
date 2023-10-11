
//����	DHCPEDoctorBatchRecord.hisui.js
//����	����¼��
//����	2023.02.14
//������  xy

$(function(){
		
	
	InitDoctorBatchRecordGrid();  
     
   //����¼��
   $("#BBatchResult").click(function() {
			BBatchResult_click();		
        });
    
    //��ѯ
	$("#BFind").click(function() {
			BFind_click();		
        });

      
})

//����¼��
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


//��ѯ
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



