$(document).ready(function() {
   
    initButton();
    
    initdicGrid();       			 //����ͳ������ 
   
})
//���ؽ������
function initdicGrid(){
	

	///  ����columns
	var columns=[[
		{field:"Type",width:200,title:"����"},
		{field:"Code",width:300,title:"������"},
		{field:"Desc",width:300,title:"��������"},
		{field:"Dosform",width:100,title:"����Ŀ¼"}
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
	var dicDesc=$("#dicDesc").val();
	var params = dicDesc;
	var uniturl =  $URL+"?ClassName=web.DHCCKBIgnoreManage&MethodName=GetIgnoreData&params="+params;
	new ListComponent('maingrid', columns, uniturl, option).Init();

}

///��ѯ�ֵ�
function Query()
{

	var dicDesc=$("#dicDesc").val();
	var params = dicDesc;
	$("#maingrid").datagrid('load',{'params':params});

}

///��ʼ��combobox
function initCombobox()
{
	
}


///��ѯ
function initButton()
{
	$('#find').bind("click",Query);
	
}
