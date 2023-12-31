/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 手术项目维护

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
	$('#adrpatimpoinfodg').datagrid({
		title:'患者相关重要信息'+titleNotes,
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
            if ((editRow != "")||(editRow == "0")) {  //qunianpeng  2016-07-25
                $("#adrpatimpoinfodg").datagrid('endEdit', editRow); 
            } 
            $("#adrpatimpoinfodg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#adrpatimpoinfodg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //queryAdrPatImpoInfo(this.id+"^"+$('#'+this.id).val()); //调用查询
            findAdrPatImpoInfo(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findAdrPatImpoInfo(); //调用查询
    });
    
    $('#adrpatimpoinfodg').datagrid({
		url:url+'?action=QueryAdrPatImpoInfo',	
		queryParams:{
			params:''}
	});
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#adrpatimpoinfodg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#adrpatimpoinfodg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrpatimpoinfodg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#adrpatimpoinfodg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrPatImpoInfo',{"params":rows[0].ID}, function(data){
					$('#adrpatimpoinfodg').datagrid('reload'); //重新加载
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
		$("#adrpatimpoinfodg").datagrid('endEdit', editRow);
	}

	var rows = $("#adrpatimpoinfodg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
		        $('#adrpatimpoinfodg').datagrid('reload');
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveAdrPatImpoInfo',{"params":rowstr},function(data){
		$('#adrpatimpoinfodg').datagrid('reload'); //重新加载
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
function findAdrPatImpoInfo()
{
	var adrPatImpoInfoCode=$('#code').val();
	var adrPatImpoInfoDesc=$('#desc').val();
	var params=adrPatImpoInfoCode+"^"+adrPatImpoInfoDesc;
	$('#adrpatimpoinfodg').datagrid('load',{params:params}); 
}