/// Creator: congyue
/// CreateDate: 2015-10-21
//  Descript: 检查项目维护

var editRow="";  //当前编辑行号
var url="dhcadv.repaction.csp";
//dhcadv.mataevent.csp
var Flag = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行即可编辑]</span>';
$(function(){
	
	//标志
	var flagEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Flag,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				
				var ed=$("#mataeventdg").datagrid('getEditor',{index:editRow,field:'ItemActiveFlag'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	//单位
	var uomEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#mataeventdg").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//类别
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#mataeventdg").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"MataID",title:'ID',width:95,align:'center'},
		{field:"ItemCode",title:'代码',width:200,editor:texteditor,align:'center'},
		{field:'ItemDesc',title:'描述',width:200,editor:texteditor,align:'center'},
		{field:'ItemVal',title:'数据内容',width:200,editor:texteditor,align:'center'},
		{field:'ItemUom',title:'单位',width:200,editor:uomEditor,align:'center'},
		{field:'ItemActiveFlag',title:'启用标志',width:200,editor:flagEditor,align:'center'},
		{field:'Type',title:'类别',width:200,editor:typeEditor,align:'center'}
	]];
	
	// 定义datagrid
	$('#mataeventdg').datagrid({
		title:'检查项目名称'+titleNotes,
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
            	$("#mataeventdg").datagrid('endEdit', editRow); 
			}
            $("#mataeventdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#mataeventdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            queryMataEvent(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         queryMataEvent(); //调用查询
    });
    
    $('#mataeventdg').datagrid({
		url:url+'?action=QueryMataEvent',	
		queryParams:{
			params:""}
	});
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#mataeventdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#mataeventdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {MataID:'',ItemCode:'',ItemDesc:'',ItemVal:'',ItemUom:'',ItemActiveFlag:'',Type:''}
	});
	$("#mataeventdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#mataeventdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMaEvent',{"params":rows[0].MataID}, function(data){

					$('#mataeventdg').datagrid('reload'); //重新加载
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
		$("#mataeventdg").datagrid('endEdit', editRow);
	}
	var rows = $("#mataeventdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemCode=="")||(rows[i].ItemDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveMaEvent',{"params":rowstr},function(data){
		$('#mataeventdg').datagrid('reload'); //重新加载
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
function queryMataEvent()
{
	var maItemCode=$('#code').val();
	var maItemDesc=$('#desc').val();
	var params=maItemCode+"^"+maItemDesc;
	$('#mataeventdg').datagrid('load',{params:params}); 
}