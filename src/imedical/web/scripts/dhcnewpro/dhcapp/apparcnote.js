
/// bianshuai
/// 2016-04-11
/// 检查医嘱项注意事项

var editRow = ""; editDRow = ""; itmmastid = "";
$(function(){

	//初始化界面默认信息
	InitDefault();

	//初始化咨询信息列表
	InitDetList();

	//初始化界面按钮事件
	InitWidListener();
})

///初始化界面默认信息
function InitDefault(){
	itmmastid=getParam("itmmastid");  ///医嘱项ID
}


/// 界面元素监听事件
function InitWidListener(){

	/**
	 * 注意事项模板字典
	 */
	$("div#tb a:contains('新增')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
}

///初始化病人列表
function InitDetList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	//设置其为可编辑
	var tempEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			url: LINK_CSP+"?ClassName=web.DHCAPPNotItemTemp&MethodName=jsonNoteItemTemp&HospID="+LgHospID,  
			onSelect:function(option){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'itemTempId'});
				$(ed.target).val(option.value);  //设置产地ID
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'itemTempDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置产地Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'itemTempId',title:'itemTempId',width:100,editor:textEditor,hidden:true},
		{field:'itemTempDesc',title:'注意事项',width:300,editor:tempEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		//title:'检查医嘱项注意事项',
		//nowrap:false,
		border:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
		onLoadSuccess:function(data){
			var rows = $("#dgMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#dgMainList').datagrid('selectRow',0);
			}
		}
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcNote&MethodName=QueryAppArcNote&itmmastid="+itmmastid+"&HospID="+LgHospID;
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
	if (itmmastid == ""){
		$.messager.alert("提示","请选择一个选项!"); 
		return;	
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].itemTempId==""){
			$.messager.alert("提示","注意事项不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ itmmastid +"^"+ rowsData[i].itemTempId;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCAPPArcNote","saveArcNote",{"anArcNoteDataList":params},function(jsonString){
		if (jsonString == 1){
			$.messager.alert('提示','保存失败:内容重复！','warning');
		}
		$('#dgMainList').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if (itmmastid == ""){
		$.messager.alert("提示","请选择一个选项!"); 
		return;	
	}
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', itemTempId:'', itemTempDesc:''}
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
				runClassMethod("web.DHCAPPArcNote","delArcNote",{'anID':rowsData.ID},function(jsonString){
					$('#dgMainList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

