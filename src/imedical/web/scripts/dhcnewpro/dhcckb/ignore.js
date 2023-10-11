$(document).ready(function() {
   
    initButton();
    
    initdicGrid();       			 //加载统计数据 
   
})
//加载结果数据
function initdicGrid(){
	

	///  定义columns
	var columns=[[
		{field:"Type",width:200,title:"类型"},
		{field:"Code",width:300,title:"忽略项"},
		{field:"Desc",width:300,title:"忽略条件"},
		{field:"Dosform",width:100,title:"问题目录"}
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
	var dicDesc=$("#dicDesc").val();
	var params = dicDesc;
	var uniturl =  $URL+"?ClassName=web.DHCCKBIgnoreManage&MethodName=GetIgnoreData&params="+params;
	new ListComponent('maingrid', columns, uniturl, option).Init();

}

///查询字典
function Query()
{

	var dicDesc=$("#dicDesc").val();
	var params = dicDesc;
	$("#maingrid").datagrid('load',{'params':params});

}

///初始化combobox
function initCombobox()
{
	
}


///查询
function initButton()
{
	$('#find').bind("click",Query);
	
}
