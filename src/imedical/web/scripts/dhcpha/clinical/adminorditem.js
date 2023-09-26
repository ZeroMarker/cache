/*
Creator:LiangQiang
CreatDate:2014-06-20
Description:病人住院用药明细查询
*/

function BodyLoadHandler()
{
	var Request = new Object();
    Request = GetRequest();
	var input = Request['input'];
	
	
    var url='dhcpha.clinical.action.csp' ;

	$('#inorditemgrid').datagrid({  
			  bordr:false,
			  //fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'code', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//行号 
			  pageSize:150,
			  pageList:[150,300],
			  columns:[[     
			  {field:'incidesc',title:'药品名称',width:120},   
			  {field:'qty',title:'数量',width:60},
			  {field:'uomdesc',title:'单位',width:60},
			  {field:'dosage',title:'剂量',width:60},
			  {field:'instruc',title:'用法',width:60},  
			  {field:'freq',title:'频率',width:60},
              {field:'doctor',title:'医生',width:60}
			  ]],
			  url:url,
			  queryParams: {
					action:'FindInPatOrdItemList',
					input:input
			  }

		  });





}



