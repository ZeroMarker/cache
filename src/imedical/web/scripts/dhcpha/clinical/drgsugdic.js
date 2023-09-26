/// Creator: bianshuai
/// CreateDate: 2014-11-11
//  Descript: 用药建议字典表维护

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[双击行即可编辑]</span>';
$(function(){
	
	// 定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'代码',width:160,editor:texteditor},
		{field:'Desc',title:'描述',width:300,editor:texteditor}
	]];
	
	// 定义datagrid
	$('#drgsugdicdg').datagrid({
		title:'用药建议字典表维护'+titleNotes,
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
                $("#drgsugdicdg").datagrid('endEdit', editRow); 
            } 
            $("#drgsugdicdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#drgsugdicdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            find(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         find(); //调用查询
    });
    
    $('#drgsugdicdg').datagrid({
		url:url+'?action=QueryDrgSugDic',	
		queryParams:{
			params:''}
	});
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#drgsugdicdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#drgsugdicdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#drgsugdicdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#drgsugdicdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelDrgSugDic',{"params":rows[0].ID}, function(data){
					$('#drgsugdicdg').datagrid('reload'); //重新加载
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
		$("#drgsugdicdg").datagrid('endEdit', editRow);
	}

	var rows = $("#drgsugdicdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			$('#drgsugdicdg').datagrid('reload');
			return false;
		}
		//下面方法获取所有行   hzg 2018-7-25
		var datas="";
		$.ajax({
		url:url+"?action=QueryDrgSugDic",
		//页数1，行数是datagrid的总行数，其他参数和需要获取行对象的datagrid是一样的
		data: {
			page: "1",rows: '100'
			},
		type: "POST",
		async: false,//true,
		//dataType: "json",
		success: function (data,rows) {
			//getallRows(datas,rows[i])
			if(data){
				datas=data;
				}
			 }

		});		
		//getallRows(datas,rows[i]);
		var favdata = eval("("+datas+")");
		var allRows=favdata.rows;
		for(var j=0;j<allRows.length;j++){
			if((rows[i].Code==allRows[j].Code)&&(rows[i].Desc==allRows[j].Desc)){
				$.messager.alert("提示","模板已存在，请重新维护!");
							$('#drgsugdicdg').datagrid('reload');
							return true;
				}
					}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveDrgSugDic',{"params":rowstr},function(data){
		$.messager.alert("提示","保存成功!"); //**修改增加保存成功提示
		$('#drgsugdicdg').datagrid('reload'); //重新加载
	});
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 查询
function find()
{
	var adrStatusCode=$('#code').val();
	var adrStatusDesc=$('#desc').val();
	var params=adrStatusCode+"^"+adrStatusDesc;
	$('#drgsugdicdg').datagrid('load',{params:params}); 
}