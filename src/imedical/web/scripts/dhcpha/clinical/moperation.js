/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 手术项目维护

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
$(function(){
	
	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'手术编码',width:160,editor:texteditor},
		{field:'Desc',title:'手术名称',width:300,editor:texteditor},
		{field:'CatDr',title:'OpCatID',width:160,hidden:true,editor:texteditor},
		{field:'CatDesc',title:'手术类型',width:300,editor:opcategroyeditor}
	]];
	
	//定义datagrid
	$('#dg').datagrid({
		//title:'手术项目维护',
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
            if (editRow != "") { 
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#dg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //手术类别
	$('#opcategory').combobox({
		onShowPanel:function(){
			$('#opcategory').combobox('reload',url+'?action=SelOperCateGory')
		}
	});
	
	 //手术项目
	$('#opitem').combobox({
		onShowPanel:function(){
			$('#opitem').combobox('reload',url+'?action=SelOperItem')
		}
	});
    
    $('#dg').datagrid({
		url:url+'?action=QueryOperItem',	
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
		row: {ID: '',Code:'',Desc: '',Category:''}
	});
	$("#dg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#dg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelOperItem',{"params":rows[0].ID}, function(data){
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
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].CatDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveOperItem',{"params":rowstr},function(data){
		$('#dg').datagrid('reload'); //重新加载
	});
}


var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
	}
	
var opcategroyeditor={  //设置其为可编辑
	type: 'combobox',//设置编辑格式
	options: {
		//required: true,//设置编辑规则属性
		valueField: "val", 
		textField: "text",
		url: url+'?action=SelOperCateGory',
		onSelect:function(option){
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'CatDr'});
			$(ed.target).val(option.val);  //设置科室ID
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'CatDesc'});
			$(ed.target).combobox('setValue', option.text);  //设置科室Desc
		}
	}
}

// 查询
function query()
{
	var opitem=$('#opitem').combobox('getValue'); 
	var opcategory=$('#opcategory').combobox('getValue');
	//combobox 删除数据后为undefined
	if (opitem== undefined){opitem="";}
	if (opcategory== undefined){opcategory="";}
	var params=opitem+"^"+opcategory;
	$('#dg').datagrid('load',{params:params}); 
}