/// Descript: 检查医嘱维护
/// Creator : sufan
/// Date    : 2017-02-07
var cat =getParam("cat");  ///医嘱项ID 
var editRow = ""; editTRow = "";
/// 页面初始化函数
function initPageDefault(){
	initprintlist();       	/// 初始页面DataGrid打印模板
	initButton();          ///  页面Button绑定事件	
}
///检查分类 
function initprintlist(){
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns
	var columns=[[
		{field:"APTTemp",title:'打印模板',width:300,align:'center',editor:textEditor},
		{field:"CatDr",title:'CatDr',width:170,align:'center',hidden:'true',editor:textEditor},
		{field:"APTRowId",title:'ID',width:150,align:'center',hidden:'true',editor:textEditor}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#printlist").datagrid('endEdit', editRow); 
            } 
            $("#printlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPOtherOpt&MethodName=QueryPrintTemp&ItmID="+cat;
	new ListComponent('printlist', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	///  增加打印模板
	$('#insert').bind("click",insertRow);
	
	///  保存打印模板
	$('#save').bind("click",saveRow);
	
	///  删除打印模板
	$('#delete').bind("click",deleteRow);
}

/// 插入检查项目部位行
function insertRow(){
	if (cat=="")
	{
		$.messager.alert("提示","请先选择分类!");
		return false;
		}
	if(editRow>="0"){
		$("#printlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#printlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {APTRowId: '',APTTemp:'',CatDr: ''}
	});
    
	$("#printlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存检查项目部位
function saveRow(){
	
	if(editRow>="0"){
		$("#printlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#printlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if (rowsData[i].APTTemp=="")
		{
			$.messager.alert("提示","第"+(rowsData.length-i)+"行模板描述为空！");
			return false;
			}
		var tmp=rowsData[i].APTRowId +"^"+ cat +"^"+ rowsData[i].APTTemp ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPOtherOpt","SavePrint",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$.messager.alert('提示','保存成功！');
		}
		if (jsonString=="-12")
		{
			$.messager.alert('提示','该分类已关联该模板！');
			}
		$('#printlist').datagrid('reload'); //重新加载
		
	});
}

/// 删除
function deleteRow(){
	
	var rowsData = $("#printlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPOtherOpt","DeletePrtTemp",{"APTRowID":rowsData.APTRowId},function(jsonString){
					$('#printlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
