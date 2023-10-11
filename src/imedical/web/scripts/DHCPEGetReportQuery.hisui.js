
//����	DHCPEGetReportQuery.hisui.js
//����	���ڱ���	
//����	2019.04.02
//������  xy
$(function(){
	 
	InitGetReportDataGrid();
	
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
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
	 	var RegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":RegNo
		}, false);
		
			$("#RegNo").val(RegNo)
		}

	if (RegNo=="") return false;
	BFind_click();
		
}

//��ѯ
function BFind_click(){
	
	var IsGroup=$("#IsGroup").checkbox('getValue');
	if(IsGroup){IsGroup=1;}
	else{IsGroup=0;}
	
	$("#GetReportQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.Report",
			QueryName:"FindGetReport",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			IsGroup:IsGroup,
			LocID:session['LOGON.CTLOCID']
			
			})
	
}


function InitGetReportDataGrid(){
	
	var IsGroup=$("#IsGroup").checkbox('getValue');
	if(IsGroup){IsGroup=1;}
	else{IsGroup=0;}
	
	$HUI.datagrid("#GetReportQueryTab",{
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
		
		queryParams:{
			ClassName:"web.DHCPE.Report",
			QueryName:"FindGetReport",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			IsGroup:IsGroup,
			LocID:session['LOGON.CTLOCID']
				
		},
		columns:[[
			{field:'TRegNo',width:'200',title:'�ǼǺ�'},
			{field:'TName',width:'200',title:'����'},
			{field:'TGroup',width:'400',title:'����'},
			{field:'TRegDate',width:'200',title:'ԤԼ����'},
			{field:'TGetReportDate',width:'200',title:'ȡ��������'}	
					
		]]
			
	})
		
}


