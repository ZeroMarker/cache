$(document).ready(function() {
   
    initButton();
    
    initdicGrid();       			 //����ͳ������ 
   
})
//���ؽ������
function initdicGrid(){
	

	///  ����columns
	var columns=[[
		
		{field:"GenerName",width:150,title:"ҩ��ͨ����"},
		{field:"DrugPreMet",width:300,title:"��ҩ��ʽ"},
		{field:"PregnancyDrugLevel",width:220,title:"�����ڷּ�"},
		{field:"Note",width:420,title:"��ע"},
	]];
	
	///  ����datagrid
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

///��ѯ�ֵ�
function Query()
{
	var GenerName = $("#GenerName").val();
	var DrugPreMet =  $("#DrugPreMet").val();
	var PregnancyDrugLevel =  $("#PregnancyDrugLevel").val();
	var Note =  $("#Note").val();
	var params = GenerName +"^"+ DrugPreMet+"^"+PregnancyDrugLevel+"^"+Note;;
	$("#maingrid").datagrid('load',{'params':params});

}



///��ѯ
function initButton()
{
	$('#find').bind("click",Query);
	

}

