var editRow="";editparamRow="";  //当前编辑行号
var url="dhcadv.repaction.csp";
$(function(){

      
	// 定义columns 
	var columns=[[
		{field:"ID",title:'ID',width:70,align:'center'},
		{field:"Code",title:'代码',width:120,editor:texteditor},
		{field:'Desc',title:'描述',width:200,editor:texteditor},
	]];
	
// 定义datagrid
	$('#advevent').datagrid({
		title:'',//不良事件名称
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            
            if ((editRow != "")||(editRow == "0")) { 
                $("#advevent").datagrid('endEdit', editRow); 
            } 
            $("#advevent").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	
    initScroll("#advevent");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#find').bind("click",Query);  //点击查询	

    
    $('#advevent').datagrid({
		url:url+'?action=QueryAdvEvent',
		queryParams:{
			params:''}
	});
	
})

//查询
function Query()
{
	var advdeCode=$('#code').val();
	var advdeDesc=$('#desc').val();                 
	var params=advdeCode+"^"+advdeDesc;
    $('#advevent').datagrid('load',{params:params}); 	

}


 // 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#advevent").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	var rows = $("#advevent").datagrid('getChanges')
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
	} 
	
	$("#advevent").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc:''}
	});
	$("#advevent").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#advevent").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdvEvent',{"params":rows[0].ID}, function(data){
				    if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if(data==-1){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}
					$('#advevent').datagrid('reload'); //重新加载
					
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
		$("#advevent").datagrid('endEdit', editRow);
	}

	var rows = $("#advevent").datagrid('getChanges')
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}

		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var params=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveAdvEvent',{"params":params},function(data){
		
		if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#advevent').datagrid('reload'); //重新加载
		
	});
}

// 编辑格
var texteditor={
	type: 'validatebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

