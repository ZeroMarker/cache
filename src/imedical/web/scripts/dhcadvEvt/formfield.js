/// author:     bianshuai
/// date:       2016-04-11
/// descript:   表单业务字段维护

var editRow = ""; editDRow = "";
$(function(){
	
	//初始化对照关系列表
	InitdgMainList();
	
	//初始化界面按钮事件
	InitWidListener();
})

/// 界面元素监听事件
function InitWidListener(){

	$("div#tb a:contains('新增')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
	
}

///初始化病人列表
function InitdgMainList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'validatebox',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'FieldCode',title:'代码',width:160,editor:textEditor},
		{field:'FieldDesc',title:'描述',width:160,editor:textEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',//表单业务字段维护
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
		onLoadSuccess:function(data){
		}
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVFormField&MethodName=QryFormField";
	var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	dgMainListComponent.Init();
}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].FieldCode=="")||(rowsData[i].FieldDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].FieldCode +"^"+ rowsData[i].FieldDesc;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCADVFormField","saveFormField",{"mListData":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#dgMainList').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#dgMainList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].aitCode == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', FieldCode:'', FieldDesc:''}
	});
	$("#dgMainList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVFormField","delFormField",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#dgMainList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

