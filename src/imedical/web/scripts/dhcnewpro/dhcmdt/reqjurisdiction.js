/// author:    bianshuai
/// date:      2016-04-11
/// descript:  会诊申请状态字典维护

var editRow = ""; editDRow = "";
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

}

/// 界面元素监听事件
function InitWidListener(){

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
	
	var ActFlagArr = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
	//设置其为可编辑
	var activeEditor={
		type: 'combobox',     //设置编辑格式
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置Desc
			}
		}
	}
	
	/// 医院
	var HospEditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'Hosp'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	
	var ctLocEditor = {
		type:'combobox',
		options:{
			id:'comboboxid',
			valueField:'value',
			mode:'remote',
			textField:'text',
			required:true,
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=QryEmConsLoc",
			required:true,
			editable:false,
			onSelect: function () {
				//获取选中的值
				var varSelect = $(this).combobox('getValue');
	 			var varEditor = $('#dgMainList').datagrid('getEditor', { index: editRow, field: 'LocID' });
				$(varEditor.target).val(varSelect);//清空类型值
			}
		}
	}
	
	var provTpEditor= {
		type:'combobox',
		options:{
			id:'comboboxid',
			valueField:'value',
			mode:'remote',
			textField:'text',
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
			required:true,
			editable:false,
			onSelect: function () {
				//获取选中的值
				var varSelect = $(this).combobox('getValue');	
	 			var varEditor = $('#dgMainList').datagrid('getEditor', { index: editRow, field: 'CarPrvTpID' });
				$(varEditor.target).val(varSelect);//清空类型值
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'id',title:'ID',width:200,hidden:true,align:'center'},
		{field:'Loc',title:'科室',width:200,editor:ctLocEditor,align:'center'},
		{field:'LocID',title:'科室ID',width:200,hidden:true,editor:textEditor,align:'center'},
		{field:'CarPrvTp',title:'职称',width:200,editor:provTpEditor,align:'center'},
		{field:'CarPrvTpID',title:'职称ID',width:200,hidden:true,editor:textEditor,align:'center'},
		{field:'Hosp',title:'医院',width:200,editor:HospEditor,align:'center'},
		{field:'HospID',title:'HospID',width:200,hidden:true,editor:textEditor,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTReqJurisdiction&MethodName=QryList";
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
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		if(rowsData[i].HospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].CarPrvTpID +"^"+ rowsData[i].HospID ;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCMDTReqJurisdiction","save",{"mParam":params},function(jsonString){

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
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', ctLoc:'', ctLocID:'', provTp:'', provTpID:'', HospDesc:'', HospID:''}
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
				runClassMethod("web.DHCMDTReqJurisdiction","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','此项已和医嘱项绑定,不能删除！','warning');
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