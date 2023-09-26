
//DHCPEAPSC.Find.hisui.js
//功能	体检卡状态查询	
//创建	2019.04.18
//创建人  xy

$(function(){
	 
	InitCombobox();
	 
	InitAPSCFindDataGrid();
	
	//查询
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
	// 体检卡类型
	var CTypeObj = $HUI.combobox("#Type",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'35',
		})
	
	// 体检卡状态
	var StatusObj = $HUI.combobox("#Status",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCStatus&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'130',
		})
	

}

//查询
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
		    {field:'TRegNo',width:'120',title:'登记号'},
			{field:'TName',width:'100',title:'姓名'},
			{field:'TType',width:'150',title:'体检卡类型'},
			{field:'TCardNo',width:'150',title:'代金卡号'},
			{field:'TDate',width:'100',title:'日期'},
			{field:'TTime',width:'100',title:'时间'},
			{field:'TStatus',width:'100',title:'状态'},
			{field:'TSourceNo',title:'单据号',hidden: true},
			{field:'TUser',width:'100',title:'操作员'},
			{field:'TRemark',width:'80',title:'备注'}
	
					
		]]
			
	})
		
}



