/// author:     bianshuai
/// date:       2016-04-11
/// descript:   不良事件表单元素对照界面JS

var editRow = ""; editDRow = "";
$(function(){
	
	//初始化对照关系列表
	InitdgMainList();
	
	//初始化界面按钮事件
	InitWidListener();
})

/// 界面元素监听事件
function InitWidListener(){
	
	$HUI.combobox("#formname",{
		url:LINK_CSP+"?ClassName=web.DHCADVFormName&MethodName=listCombo",
		valueField:'value',
		textField:'text',
		mode:'remote',
		blurValidValue:true,
		onSelect:function(option){

	    }	
	})

	$("div#tb a:contains('新增')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
	
    $('#code,#desc').bind('keypress',function(event){   //sufan 2019-11-04 增加检索条件
        if(event.keyCode == "13")    
        {
            finddglist();
        }
    });
    
    $('#find').bind('click',function(event){
         finddglist();
    });
    $('#reset').bind('click',function(event){
	     $("#code,#desc").val("");
	     $HUI.combobox("#formname").setValue("")
         finddglist();
    });
    
	
}

///初始化病人列表
function InitdgMainList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 元素Combobox
	var FormDicEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:"",
			//required:true,
			//panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				/// 元素描述
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicDesc'});
				$(ed.target).combobox('setValue', option.text);
				/// 元素代码
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicCode'});
				$(ed.target).val(option.code);
				/// 元素ID
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	/// 字段Combobox
	var FormFieldEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormField",
			//required:true,
			//panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				/// 元素描述
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldDesc'});
				$(ed.target).combobox('setValue', option.text);
				/// 元素代码
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldCode'});
				$(ed.target).val(option.code);
				/// 元素ID
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	/// 表单Combobox
	var FormEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonForm",
			//required:true,
			//panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameCode'});
				$(ed.target).val(option.code);
				
				///设置级联指针
				var FormID=option.value;  //元素
				var FormDicDesced=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicDesc'});
				$(FormDicDesced.target).combobox('setValue', "");
				var unitUrl=LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormDic&FormID="+FormID;
				$(FormDicDesced.target).combobox('reload',unitUrl);
				var FormDicCodeed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicCode'});
				$(FormDicCodeed.target).val("");
			}
		}
	}
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'FieldID',title:'字段ID',width:120,editor:textEditor,hidden:true},
		{field:'FieldCode',title:'字段代码',width:120,editor:textEditor},
		{field:'FieldDesc',title:'字段描述',width:120,editor:FormFieldEditor},
		{field:'FormNameCode',title:'表单代码',width:220,editor:textEditor,hidden:true},
		{field:'FormNameDesc',title:'表单名称',width:220,editor:FormEditor},
		{field:'FormDicID',title:'元素ID',width:120,editor:textEditor,hidden:true},
		{field:'FormDicCode',title:'元素代码',width:220,editor:textEditor},
		{field:'FormDicDesc',title:'元素描述',width:120,editor:FormDicEditor}
	]];
	/**
	 * 定义datagrid
	 */
	$('#dgMainList').datagrid({
		columns:columns,
		fit:true,
		title:'', //不良事件表单元素对照关系
		//nowrap:false,
		url:'dhcapp.broker.csp?ClassName=web.DHCADVFormDicContrast&MethodName=QryDicContrast',
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
		singleSelect : true,
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
		onLoadSuccess:function(data){
		}
	});
	
	//var uniturl = LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=QryDicContrast";
	//var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	//dgMainListComponent.Init();
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
		
		if(rowsData[i].FieldID==""){
			$.messager.alert("提示","字段不能为空!"); 
			return false;
		}
		if(rowsData[i].FormDicID==""){
			$.messager.alert("提示","元素不能为空!"); 
			return false;
		}
		
		//row: {ID:'', FieldID:'', FieldCode:'', FieldDesc:'', FormID:'', FormNameCode:'', FormNameDesc:'', FormDicID:'', FormDicCode:'', FormDicDesc:''}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].FieldID +"^"+ rowsData[i].FormDicCode +"^"+ rowsData[i].FormNameCode;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCADVFormDicContrast","saveContrast",{"mListData":params},function(jsonString){

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
		//row: {ID:'', FieldID:'', FieldCode:'', FieldDesc:'', FormCode:'', FormNameDesc:'', FormID:'', FormNameDesc:''}
		row: {ID:'', FieldID:'', FieldCode:'', FieldDesc:'', FormNameCode:'',FormNameDesc:'', FormDicID:'', FormDicCode:'', FormDicDesc:''}
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
				runClassMethod("web.DHCADVFormDicContrast","delContrast",{"ID":rowsData.ID},function(jsonString){
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

// 查询
function finddglist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var formname=$HUI.combobox("#formname").getValue();
	var params=code+"^"+desc+"^"+formname;
	$('#dgMainList').datagrid('load',{params:params}); 
}