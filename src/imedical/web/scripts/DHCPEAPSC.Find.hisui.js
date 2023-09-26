
//DHCPEAPSC.Find.hisui.js
//����	��쿨״̬��ѯ	
//����	2019.04.18
//������  xy

$(function(){
	 
	InitCombobox();
	 
	InitAPSCFindDataGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    $("#CardNo").keydown(function(e) {
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

	 $("#Type").combobox('setValue',"C");
   
})

	
function InitCombobox()
{
	// ��쿨����
	var CTypeObj = $HUI.combobox("#Type",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'35',
		})
	
	// ��쿨״̬
	var StatusObj = $HUI.combobox("#Status",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCStatus&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'130',
		})
	

}

//��ѯ
function BFind_click(){
	
	$("#APSCFindQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPSCDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			CardNo:$("#CardNo").val(),
			Type:$("#Type").combobox('getValue'),
			Status:$("#Status").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
			})
	
}

function InitAPSCFindDataGrid(){
	
	$HUI.datagrid("#APSCFindQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPSCDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			CardNo:$("#CardNo").val(),
			Type:$("#Type").combobox('getValue'),
			Status:$("#Status").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
				
		},
		
		columns:[[
			
			{field:'TRowID',title:'TRowID',hidden: true},
		    {field:'TRegNo',width:'120',title:'�ǼǺ�'},
			{field:'TName',width:'100',title:'����'},
			{field:'TType',width:'150',title:'��쿨����'},
			{field:'TCardNo',width:'150',title:'���𿨺�'},
			{field:'TDate',width:'100',title:'����'},
			{field:'TTime',width:'100',title:'ʱ��'},
			{field:'TStatus',width:'100',title:'״̬'},
			{field:'TSourceNo',title:'���ݺ�',hidden: true},
			{field:'TUser',width:'100',title:'����Ա'},
			{field:'TRemark',width:'80',title:'��ע'}
	
					
		]]
			
	})
		
}



