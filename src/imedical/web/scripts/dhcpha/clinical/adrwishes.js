/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 填报意愿字典表维护

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行即可编辑]</span>';
$(function(){
	
	// 定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'代码',width:160,editor:texteditor},
		{field:'Desc',title:'描述',width:300,editor:texteditor}
	]];
	
	// 定义datagrid
	$('#adrwishesdg').datagrid({
		title:'填报意愿'+titleNotes,
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
             if ((editRow != "")||(editRow=="0")) { 
                $("#adrwishesdg").datagrid('endEdit', editRow); 
            } 
            $("#adrwishesdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#adrwishesdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrWishes(this.id+"^"+$('#'+this.id).val()); //调用查询
            findAdrWishes(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findAdrWishes(); //调用查询
    });
    
    $('#adrwishesdg').datagrid({
		url:url+'?action=QueryAdrWishes',	
		queryParams:{
			params:''}
	});
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#adrwishesdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#adrwishesdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrwishesdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#adrwishesdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrWishes',{"params":rows[0].ID}, function(data){
					$('#adrwishesdg').datagrid('reload'); //重新加载
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
		$("#adrwishesdg").datagrid('endEdit', editRow);
	}

	var rows = $("#adrwishesdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			$('#adrwishesdg').datagrid('reload');
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveAdrWishes',{"params":rowstr},function(data){
		$('#adrwishesdg').datagrid('reload'); //重新加载
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
function findAdrWishes()
{
	var adrWishesCode=$('#code').val();
	var adrWishesDesc=$('#desc').val();
	var params=adrWishesCode+"^"+adrWishesDesc;
	$('#adrwishesdg').datagrid('load',{params:params}); 
}