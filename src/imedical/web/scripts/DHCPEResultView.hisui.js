//����	DHCPEResultView.hisui.js
//����  �����Ԥ��
//����	2023.04.03
//������  xy

$(function(){
	
	//��ʼ��
	InitResultViewDataGrid();
	
	/*
	//����Ԥ��
	$("#BReportView").click(function() {	
		BReportView_click();		
    });
    */
    
    Info();
    
  	
})

function ShowLocResult( OEORDItemID) {
	var url = "dhcperesult.hisui.csp?OEORDItemID=" + OEORDItemID;
    var ret=tkMakeServerCall("web.DHCPE.TransResultDetail","GetInfoByOEORDID",OEORDItemID);
	var retone=ret.split("^");
    websys_lu(url, false, 'width=800,height=600,hisui=true,title='+retone[0]+$g("--�����ϸ"));
}

function Info(){
	
	var GSID=tkMakeServerCall("web.DHCPE.ResultDiagnosis", "GetSSId", EpisodeID);
	var AuditInfo = tkMakeServerCall("web.DHCPE.ResultDiagnosisNew", "GetAuditInfo", EpisodeID, GSID);
    //alert("AuditInfo :"+AuditInfo )
    $("#AuditDoctor").val(AuditInfo.split("^")[0]);
    $("#AuditDoctorDate").datebox("setValue", AuditInfo.split("^")[1]);
    
    $("#MainDoctor").val(AuditInfo.split("^")[2]);
    $("#MainDoctorDate").datebox("setValue", AuditInfo.split("^")[3]);
   
}

function InitResultViewDataGrid(){
	$HUI.datagrid("#ResultViewGrid",{
		url: $URL,
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		nowrap:false,  //�и�����Ӧ
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: false, //���Ϊtrue, ����ʾһ���к���  
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.Result",
			QueryName:"FindResult", 
			PAADM:EpisodeID,
		},
		onDblClickCell: function (rowIndex, field, value) {
  			var rows = $('#ResultViewGrid').datagrid('getRows');
  			var row = rows[rowIndex];
  			var OrderItemID = row.OrderItemID;
  			ShowLocResult(OrderItemID);
  			
		},
		columns:[[
		
		    {field:'OrderItemID',hidden:true,title:'ҽ��id'},
			{field:'STDesc',width:200,title:'����'},
			{field:'Result',width:550,title:'�����'},
			{field:'Advice',width:600,title:'����'},	
		]]	
	})
}

//����Ԥ��
function BReportView_click(){
}
