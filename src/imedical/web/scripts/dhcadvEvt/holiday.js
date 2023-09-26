var editRow="";  //当前编辑行号
var url="dhcadv.repaction.csp";
var Active=[{"value":"工作日","text":'工作日'}, {"value":"节假日","text":'节假日'}];

var StDate=formatDateD(0) //本年度的01-01
var EndDate=formatDate(0); //系统的当前日期
$(function(){
	
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
			///设置类型值
				var ed=$("#holiday").datagrid('getEditor',{index:editRow,field:'Flag'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	
	     
	// 定义columns
	var columns=[[
		{field:"Date",title:'日期',width:150,editor:dateditor},
		{field:'Flag',title:'是否节假日',width:80,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center'},
	]];
	
// 定义datagrid
	$('#holiday').datagrid({
		title:'节假日字典维护',
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
                $("#holiday").datagrid('endEdit', editRow); 
            } 
            $("#holiday").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	
    //initScroll("#holiday");//初始化显示横向滚动条
    $("#stdate").datebox("setValue", StDate);  //Init起始日期
	$("#enddate").datebox("setValue", EndDate);  //Init结束日期
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#find').bind("click",Query);  //点击查询

    var params=StDate+"^"+EndDate
    $('#holiday').datagrid({
		url:url+'?action=QueryHoliday',
		queryParams:{
			params:params}
	});
	
})

//查询
function Query()
{
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期                 
	var params=StDate+"^"+EndDate;
    $('#holiday').datagrid('load',{params:params}); 		

}


 // 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#holiday").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#holiday").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Date:'',Flag:''}
	});
	$("#holiday").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#holiday").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelHoliday',{"params":rows[0].ID}, function(data){
                    if(data==0){
						$.messager.alert('提示','删除成功');		
					}else{
						$.messager.alert('提示','删除失败');
					}

					$('#holiday').datagrid('reload'); //重新加载
					
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
		$("#holiday").datagrid('endEdit', editRow);
	}

	var rows = $("#holiday").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Date=="")||(rows[i].Flag=="")){
			$.messager.alert("提示","日期不能为空!"); 
			return false;
			fush();
		}
		var tmp=rows[i].ID+"^"+rows[i].Date+"^"+rows[i].Flag;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveHoliday',{"params":rowstr},function(data){
	   if(data==0){
			$.messager.alert("提示","保存成功!");		
		}else if((data == -1)||((data == -2))){
			$.messager.alert('提示','日期重复,请核实后再试！','warning');
		}
			$('#holiday').datagrid('reload'); //重新加载
	});
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}


var dateditor={
	type: 'datebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

