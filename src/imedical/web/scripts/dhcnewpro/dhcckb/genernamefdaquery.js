$(document).ready(function() {
   
    initButton();
    
    initdicGrid();       			 //加载统计数据 
   
})
//加载结果数据
function initdicGrid(){
	

	///  定义columns
	var columns=[[
		
		{field:"GenerName",width:150,title:"药物通用名"},
		{field:"DrugPreMet",width:300,title:"用药方式"},
		{field:"PregnancyDrugLevel",width:220,title:"妊娠期分级"},
		{field:"Note",width:420,title:"备注"},
	]];
	
	///  定义datagrid
	var option = {
		fitColumn:true,
		rownumbers : true,
		singleSelect : true,
		remoteSort:false,
		//fit : true,
		pageSize : [30],
		pageList : [30,60,90,1000],
	 	onClickRow: function (rowIndex, rowData) {
					        
 	 	}  
	};
	var GenerName = $("#GenerName").val();
	var DrugPreMet =  $("#DrugPreMet").val();
	var PregnancyDrugLevel =  $("#PregnancyDrugLevel").val();
	var Note =  $("#Note").val();
	var params = GenerName +"^"+ DrugPreMet+"^"+PregnancyDrugLevel+"^"+Note;
	var uniturl =  $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryFDADrug&params="+params;
	new ListComponent('maingrid', columns, uniturl, option).Init();

}

///查询字典
function Query()
{
	var GenerName = $("#GenerName").val();
	var DrugPreMet =  $("#DrugPreMet").val();
	var PregnancyDrugLevel =  $("#PregnancyDrugLevel").val();
	var Note =  $("#Note").val();
	var params = GenerName +"^"+ DrugPreMet+"^"+PregnancyDrugLevel+"^"+Note;;
	$("#maingrid").datagrid('load',{'params':params});

}



///查询
function initButton()
{
	$('#find').bind("click",Query);
	

}

