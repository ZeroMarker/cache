//名称	DHCPEResultView.hisui.js
//功能  体检结果预览
//创建	2023.04.03
//创建人  xy

$(function(){
	
	//初始化
	InitResultViewDataGrid();
	
	/*
	//报告预览
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
    websys_lu(url, false, 'width=800,height=600,hisui=true,title='+retone[0]+$g("--结果明细"));
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
		nowrap:false,  //行高自适应
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列  
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
		
		    {field:'OrderItemID',hidden:true,title:'医嘱id'},
			{field:'STDesc',width:200,title:'科室'},
			{field:'Result',width:550,title:'检查结果'},
			{field:'Advice',width:600,title:'建议'},	
		]]	
	})
}

//报告预览
function BReportView_click(){
}
