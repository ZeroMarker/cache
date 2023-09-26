/// bianshuai
/// 2016-04-11
/// 注意事项模板字典维护

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

	/**
	 * 注意事项模板字典
	 */
	$("div#tb a:contains('新增')").bind("click",insertRow);
	$("div#tb a:contains('删除')").bind("click",deleteRow);
	$("div#tb a:contains('保存')").bind("click",saveRow);
	
	/**
	 * 注意事项明细
	 */
	$("div#dtb a:contains('保存')").bind("click",saveItmTmpNotes);
	$("div#dtb a:contains('清空')").bind("click",clearItmTmpNotes);
	$("div#dtb a:contains('删除')").bind("click",delItmTmpNotes);
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
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitActCode'});
				$(ed.target).val(option.value);  //设置value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitActDesc'});
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
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitHospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitHospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'aitID',title:'aitID',width:100,hidden:true},
		{field:'aitCode',title:'代码',width:100,editor:textEditor},
		{field:'aitDesc',title:'描述',width:160,editor:textEditor},
		{field:'aitActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'aitActDesc',title:'是否可用',width:100,align:'center',editor:activeEditor},
		{field:'aitHospID',title:'aitHospID',width:100,editor:textEditor,hidden:true},
		{field:'aitHospDesc',title:'医院',width:200,editor:HospEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
			GetItemTempNotes(rowData.aitID);
	    },
		onLoadSuccess:function(data){
			var rows = $("#dgMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#dgMainList').datagrid('selectRow',0);
				var rowData = $('#dgMainList').datagrid('getSelected');
				GetItemTempNotes(rowData.aitID);
			}
		}
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPNotItemTemp&MethodName=QueryAppItemTemp";
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
		
		if((rowsData[i].aitCode=="")||(rowsData[i].aitDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		if(rowsData[i].aitHospID==""){
			$.messager.alert("提示","医院不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].aitID +"^"+ rowsData[i].aitCode +"^"+ rowsData[i].aitDesc +"^"+ rowsData[i].aitActCode +"^"+ rowsData[i].aitHospID;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCAPPNotItemTemp","saveItmTemp",{"ItmTempDataList":params},function(jsonString){

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
		row: {aitID:'', aitCode:'', aitDesc:'', aitActCode:'Y', aitActDesc:'是', aitHospID:'', aitHospDesc:''}
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
				runClassMethod("web.DHCAPPNotItemTemp","delItmTemp",{"ID":rowsData.aitID},function(jsonString){
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

/// 保存
function saveItmTmpNotes(){

	var rowsMData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsMData == null){
		$.messager.alert("提示", "请先选中模板字典，然后点击添加！");
		return;
	}

	var itemTempId = $("#itemTempId").val();   		///子表ID
	var itemTempDesc = $("#itemTempDesc").val(); 	///注意事项文字描述
	var params=itemTempId +"^"+ rowsMData.aitID +"^"+ itemTempDesc;

	//保存数据
	runClassMethod("web.DHCAPPNotItemTemp","saveItmTempD",{"ItmTempDataList":params},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示", "保存成功！");
			GetItemTempNotes(rowsMData.aitID);
		}else{
			$.messager.alert("提示", "保存失败！");
		}
	})
}

/// 删除选中注意事项行
function delItmTmpNotes(){
	
	var rowsMData = $("#dgMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsMData == null){
		$.messager.alert("提示", "请先选中模板字典，然后点击添加！");
		return;
	}
	
	var itemTempId = $("#itemTempId").val();   		///子表ID
	if (itemTempId == ""){
		$.messager.alert("提示", "删除失败,失败原因:数据为空！");
		return;
	}
	$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
		if (res) {
			runClassMethod("web.DHCAPPNotItemTemp","delItmTempD",{"ID":itemTempId},function(jsonString){
				if (jsonString == 0){
					$.messager.alert("提示", "删除成功！");
					GetItemTempNotes(rowsMData.aitID);
				}else{
					$.messager.alert("提示", "删除失败！");
				}
			})
		}
	});
}

/// 取模板字典描述
function GetItemTempNotes(aitID){
	
	$("#itemTempId").val('');     ///子表ID
	$('#itemTempDesc').html('');  ///清空

	/// 查询数据
	runClassMethod("web.DHCAPPNotItemTemp","GetItemTempNotes",{"aitID":aitID},function(jsonString){

		if (jsonString != null){
			//var jsonObj = jQuery.parseJSON(jsonString);
			var jsonObj = jsonString;
			$('#itemTempId').val(jsonObj.itemTempId);  ///注意事项ID
			$('#itemTempDesc').val(jsonObj.itemTempDesc.replace(new RegExp("<br>","g"),"\r\n"));  ///注意事项    ///sufan  2017-02-16  修改IE8回车不起作用
		}
	})
}

/// 清空
function clearItmTmpNotes(){

	$("#itemTempDesc").val('');
}

