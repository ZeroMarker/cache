/// Creator:    bianshuai
/// CreateDate: 2016-03-04
//  Descript:   专业方向维护

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
$(function(){
	
	$("#insert").bind("click",insertRow);
	$("#delete").bind("click",deleteRow);
	$("#save").bind("click",saveRow);
	
	InitProDirecList();    //初始化专业方向列表
	
})
//初始化专业方向列表
function InitProDirecList()
{


	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'编码',width:160,editor:texteditor},
		{field:'Desc',title:'名称',width:300,editor:texteditor}
	]];

	/**
	 * 定义datagrid
	 */
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#prodirList").datagrid('endEdit', editRow); 
            } 
            $("#prodirList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	};

	var prodirListComponent = new ListComponent('prodirList', columns, '', option);
	prodirListComponent.Init();
	
    queryProDirDetail();
	initScroll("#prodirList");//初始化显示横向滚动条

	
}
 /**
  * 查询咨询数据
  */
function queryProDirDetail(){
	
	//1、清空datagrid 
	$('#prodirList').datagrid('loadData', {total:0,rows:[]});
		
	$('#prodirList').datagrid({
		url:url + "?action=QueryProDirect",	
		queryParams:{
			params:""}
	});
}

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#prodirList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#prodirList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#prodirList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#prodirList").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=delProDirect',{"proDirectID":rows[0].ID}, function(data){
					$('#prodirList').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#prodirList").datagrid('endEdit', editRow);
	}

	var rows = $("#prodirList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			$('#prodirList').datagrid('reload'); 
			return false;
		}
		//QueryProDirect   2018-7-25 hzg
		//下面方法获取所有行  
		var datas="";
		$.ajax({
		url:url+"?action=QueryProDirect",
		//页数1，行数是datagrid的总行数，其他参数和需要获取行对象的datagrid是一样的
		data: {
			page: "1",rows: '100'
			},
		type: "POST",
		async: false,//true,
		//dataType: "json",
		success: function (data,rows) {
			if(data){
				datas=data;
				}
			 }

		});		
		var favdata = eval("("+datas+")");
		var allRows=favdata.rows;
		for(var j=0;j<allRows.length;j++){
					if((rows[i].Code==allRows[j].Code)){
							$.messager.alert("提示","模板已存在，请重新维护!");
							$('#prodirList').datagrid('reload');
							return true;
				}			
					}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		
		dataList.push(tmp);	
		
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=saveProDirect',{"params":rowstr},function(data){
		$.messager.alert("提示","保存成功!"); //**修改增加保存成功提示
		$('#prodirList').datagrid('reload'); //重新加载
	});
}



var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}