/// Creator: bianshuai
/// CreateDate: 2015-04-23
//  Descript: 药学监护级别维护

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
$(function(){
	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'编码',width:160, editor:texteditor},
		{field:'Desc',title:'名称',width:200, editor:texteditor},
		{field:'Color',title:'颜色',width:50, editor:'color', 
			styler:function(value,row,index){
				return 'color:'+ value +';background-color:'+ value +';';
			}
		}
	]];
	
	//定义datagrid
	$('#dg').datagrid({
		//title:'监护级别维护',
		url:url+'?action=QueryMonLevel',  // qunianpeng 2016-08-01
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
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
        onLoadSuccess:function(data){
	        
	    }
	});
	
	initScroll("#dg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
 /*    $('#delete').bind('click',deleteRow); */
    $('#save').bind('click',saveRow);

    $('#dg').datagrid({
		url:url+'?action=QueryMonLevel',	
		queryParams:{
			params:""}
	});
})
// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#dg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#dg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#dg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	/*$.messager.alert('提示','<font style="color:red;">如需进行删除操作,请联系信息科！谢谢！</font>','warning');
	return;*/
	
	var rows = $("#dg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMonLevel',{"params":rows[0].ID}, function(data){
					$('#dg').datagrid('reload'); //重新加载
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
		$("#dg").datagrid('endEdit', editRow);
	}

	var rows = $("#dg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			$('#dg').datagrid('reload');
			return false;
		}
		var datas="";
		$.ajax({
			url:url+"?action=QueryMonLevel",
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
		//getallRows(datas,rows[i]);
		var favdata = eval("("+datas+")");
		var allRows=favdata.rows;
		for(var j=0;j<allRows.length;j++){
			if((rows[i].Code==allRows[j].Code)&&(rows[i].ID!=allRows[j].ID)){
				$.messager.alert("提示","编码已存在，请重新维护!");
				$('#dg').datagrid('reload');
				return true;
			}
			if((rows[i].Desc==allRows[j].Desc)&&(rows[i].ID!=allRows[j].ID)){
				$.messager.alert("提示","名称已存在，请重新维护!");
				$('#dg').datagrid('reload');
				return true;
			}
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+(rows[i].Color||"");
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveMonLevel',{"params":rowstr},function(data){
		$.messager.alert("提示","保存成功!"); //**修改增加保存成功提示
		$('#dg').datagrid('reload'); //重新加载
	});
}


var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

