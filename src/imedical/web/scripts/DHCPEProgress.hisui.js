
//����	DHCPEProgress.hisui.js
//����	�����̲�ѯ
//����	2019.06.28
//������  xy

$(function(){
	
	
	InitPatientListGrid();  
	
	InitProgressGrid();  
	
	$("#BFind").click(function(){
  			BFind_click();
		});
	
	$("#RegNo").change(function(){
  			RegNoOnChange();
		});
		
	
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
			}
			
        });
})



function RegNoOnChange()
{
	var RegNo=$("#RegNo").val();
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
	}

	$("#PatientListGrid").datagrid('load',{
			ClassName:"web.DHCPE.ResultNew",
			QueryName:"SearchPatInfo",
			RegNo:$("#RegNo").val(),
			BDate:$("#BeginDate").datebox('getValue'),
			EDate:$("#EndDate").datebox('getValue'),
	
	}); 
}


function BFind_click()
{
	
	var BDate=$("#BeginDate").datebox('getValue');
	var EDate=$("#EndDate").datebox('getValue');
	var RegNo=$("#RegNo").val();
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
		}

	$("#PatientListGrid").datagrid('load',{
			ClassName:"web.DHCPE.ResultNew",
			QueryName:"SearchPatInfo",
			RegNo:$("#RegNo").val(),
			BDate:$("#BeginDate").datebox('getValue'),
			EDate:$("#EndDate").datebox('getValue'),
	
	});
	$('#ProgressGrid').datagrid('load', {
			ClassName:"web.DHCPE.AdmRecordManager",
			QueryName:"FindAdmRecord",
			AdmId:"",
		
	});

	  $("#Name,#Sex,#Birth,#CardNo,#Remark,#AdmId").val("")
}


function InitPatientListGrid(){
	$HUI.datagrid("#PatientListGrid",{
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
			ClassName:"web.DHCPE.ResultNew",
			QueryName:"SearchPatInfo",
			RegNo:$("#RegNo").val(),
			BDate:$("#BeginDate").datebox('getValue'),
			EDate:$("#EndDate").datebox('getValue'),
			
		},
		frozenColumns:[[
			{field:'PAPMINo',width:100,title:'�ǼǺ�'},
		]],
		columns:[[
	
		   {field:'PaadmID',title:'PaadmID',hidden: true},
			{field:'AdmDate',width:90,title:'�������'},
			{field:'Name',width:100,title:'����'},
			{field:'Age',width:50,title:'����'},
			{field:'Sex',width:50,title:'�Ա�'},
			{field:'VIPDesc',width:60,title:'VIP�ȼ�'},
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			$('#ProgressGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadProgressGrid(rowData);
			
		}
		
			
	})	
}

function loadProgressGrid(row){
	$('#ProgressGrid').datagrid('load', {
			ClassName:"web.DHCPE.AdmRecordManager",
			QueryName:"FindAdmRecord",
			AdmId:row.PaadmID,
		
	});
	$('#AdmId').val(row.PaadmID);
	var Info=tkMakeServerCall("web.DHCPE.AdmRecordManager","GetBaseInfo",$("#AdmId").val());
	var Arr=Info.split("^");
	$("#Name").val(Arr[0]);
	$("#Sex").val(Arr[1]);
	$("#Birth").val(Arr[2]);
	$("#CardNo").val(Arr[3]);
	var RemarkInfo=tkMakeServerCall("web.DHCPE.AdmRecordManager","GetAdmRecordReMarkInfo",$("#AdmId").val());
	$("#Remark").val(RemarkInfo)
}


function InitProgressGrid(){
	
	$HUI.datagrid("#ProgressGrid",{
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
			ClassName:"web.DHCPE.AdmRecordManager",
			QueryName:"FindAdmRecord",
			AdmId:$("#AdmId").val(),	
		},
		columns:[[
			 {field:'TID',title:'ID',hidden: true},
			{field:'TDate',width:120,title:'����'},
			{field:'TTime',width:130,title:'ʱ��'},
			{field:'TType',width:100,title:'����'},
			{field:'TRemark',width:400,title:'��Ϣ'},
			{field:'TUser',width:100,title:'������'},
			
		]],
		
})	
}