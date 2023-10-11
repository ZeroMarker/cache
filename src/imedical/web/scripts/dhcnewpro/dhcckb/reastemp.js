var editMRow="",UserList=[],LocList=[]
$(function(){
	$('#searchRT').click(searchRT);
	$('#resetRT').click(resetRT);
	initCombobox();
	
});

// 初始化搜索下拉框
function initCombobox(){
	runClassMethod("web.DHCCKBReasTemp","JsonUser",{},function(userData){
		UserList=userData;
		$("#userSearch").combobox("loadData",userData);
	})
	runClassMethod("web.DHCCKBReasTemp","JsonLoc",{},function(locData){
			LocList=locData;
			$("#locSearch").combobox("loadData",locData);
		})
}


// 下拉框显示调整
function ActiveFormat(value){
	if(value=="Y"){
		return "是";
	}else{
		return "否";
	}
};

// 级联，动态加载科室下拉框
function choosePoint(){
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTType'});
	var value = $(ed.target).combobox('getValue');
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTPointDesc'});
	if(value=="User"){
		$(ed.target).combobox("loadData",UserList);
	}else if(value=="Loc"){
		$(ed.target).combobox("loadData",LocList);
	}else{
		$(ed.target).combobox("loadData",'');
	}	
}

// 指向下拉框的数据规范化
function pointFormat(){
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTPointDesc'});
	var showText = $(ed.target).combobox('getText');
	var showId = $(ed.target).combobox('getValue');
	console.log(showId)
	$(ed.target).combobox('setValue', showText);
	var ed=$("#RTTable").datagrid('getEditor',{index:editMRow,field:'RTPoint'});
	$(ed.target).val(showId); 	
}

	

// 审核原因的搜索功能
function searchRT(){
		var userPoint = $("#userSearch").combobox("getValue");
		var locPoint = $("#locSearch").combobox("getValue");
		var text = $("#textSearch").val();
		var params = userPoint+"^"+locPoint+"^"+text;
		console.log(params);
		$("#RTTable").datagrid({
			url:'dhcapp.broker.csp?ClassName=web.DHCCKBReasTemp&MethodName=GetListByCondition',
			queryParams:{params:params},	
		})
	}
	
// 审核原因的搜索条件重置方法
function resetRT(){
		$("#userSearch").combobox("setValue","");
		$("#locSearch").combobox("setValue","");
		$("#textSearch").val("");
		$("#RTTable").datagrid({url:'dhcapp.broker.csp?ClassName=web.DHCCKBReasTemp&MethodName=GetList'})
	}

//审核原因新增加一行
function addRow(){
	if(editMRow>="0"){
		$("#RTTable").datagrid('endEdit', editMRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#RTTable").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].RTText == ""){
			$('#RTTable').datagrid('selectRow',0);
			$("#RTTable").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			editMRow=0;
			return;
		}
	}
	
	$("#RTTable").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {RowID:'', RTText:'',RTType:"User", RTPoint:'',RTPointDesc:'', RTActiveFlag:'Y'}
	});
	$("#RTTable").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editMRow=0;
	choosePoint();
}


//双击选择行编辑
function onDblClickRow(index,row){
	if ((editMRow != "")||(editMRow == "0")) { 
		$("#RTTable").datagrid('endEdit', editMRow); 
    } 
    $("#RTTable").datagrid('beginEdit', index); 
    editMRow = index;
    choosePoint();
}

//列表保存信息
function saveRow(){
	
	if(editMRow>="0"){
		$("#RTTable").datagrid('endEdit', editMRow);
	}

	var rowsData = $("#RTTable").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].RTText==""){
			$.messager.alert("提示","描述不能为空!"); 
			return false;
		}
		if(rowsData[i].RTType==""){
			$.messager.alert("提示","类型不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].RowID +"^"+ rowsData[i].RTText +"^"+ rowsData[i].RTType +"^"+ rowsData[i].RTPoint +"^"+ rowsData[i].RTActiveFlag;
		dataList.push(tmp);
	}
	var mListData=dataList.join("$$");
	console.log(mListData)
	//保存数据
	runClassMethod("web.DHCCKBReasTemp","Save",{"params":mListData},function(jsonString){
		if (jsonString == "-1"){
			$.messager.alert('提示','保存失败,请核实数据后再试！','warning');
			return;	
		}else{
			$.messager.alert('提示','保存成功！');
			editMRow=""
		}
		$('#RTTable').datagrid('reload'); //重新加载
	})
}

// 删除列表数据
function deleteRow(){
	var rowsData = $("#RTTable").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBReasTemp","Remove",{"RowID":rowsData.RowID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#RTTable').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}



