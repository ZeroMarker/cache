//===========================================================================================
// Author：      lidong
// Date:		 2022-8-30
// Description:	 用户岗位管理
//===========================================================================================
var editaddRow=0;

var nodeArr=[];	
function initPageDefault(){
	InitButton();			// 按钮响应事件初始化
	InitDataList();			// 实体DataGrid初始化定义
	
}

/// 按钮响应事件初始化
function InitButton(){

	$("#insert").bind("click",insertRow);	// 增加新行
	
	$("#save").bind("click",saveRow);		// 保存
	
	$("#delete").bind("click",DeleteRow);	// 删除
	
	$("#find").bind("click",QueryUserList);	// 查询
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	
	/// 代码.描述查询
	$('#queryName').searchbox({
	    searcher:function(value,name){
	   		QueryUserList();
	    }	   
	});	
	
}
/// 实体DataGrid初始定义通用名
function InitDataList(){
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 姓名
	var Nameeditor={
		type:'combobox',
	  	 options:{
		  	valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'UserID'});
				$(ed.target).val(option.value);
			},
	  		onShowPanel:function(){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetUserComboxData&q="+'';
				$(ed.target).combobox('reload',unitUrl);	
	    			}	  
				
	  	 	}
	  	 
	 }
		 
	// 职务
	var Roleeditor={
		 type:'combobox',
		 options:{
		  	valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'RoleName'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'RoleID'});
				$(ed.target).val(option.value);
			},
			onShowPanel:function(){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'RoleName'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetRoleComboxData&q="+'';
				$(ed.target).combobox('reload',unitUrl);	
					}	  
				
		 	}
		 }
	// 岗位
	var Jobeditor={type:'combobox',
	  	 options:{
		  	valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'JobName'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'JobID'});
				$(ed.target).val(option.value);
			},
	  		onShowPanel:function(){
				var ed=$("#UserList").datagrid('getEditor',{index:editaddRow,field:'JobName'});
				var unitUrl=$URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetJobComboxData&q="+'';
				$(ed.target).combobox('reload',unitUrl);	
	    			}	  
				
	  	 	}
		 }
	// 定义columns
	var columns=[[   	 
			{field:'RowID',title:'RowID',hidden:true},
			{field:'UserID',title:'姓名ID',width:200,align:'left',editor:textEditor,hidden:true},
			{field:'UserName',title:'姓名',width:200,align:'left',editor:Nameeditor,hidden:false},
			{field:'RoleID',title:'职务ID',width:200,align:'left',editor:textEditor,hidden:true},
			{field:'RoleName',title:'职务',width:200,align:'left',editor:Roleeditor,hidden:false},
			{field:'JobID',title:'岗位ID',width:200,align:'left',editor:textEditor,hidden:true},
			{field:'JobName',title:'岗位',width:200,align:'left',editor:Jobeditor,hidden:false},
						
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){
	 		editaddRow=rowIndex; 	
 		 }, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            editaddRow=rowIndex;
            if (editaddRow != ""||editaddRow == 0) { 
                $("#UserList").datagrid('endEdit', editaddRow); 
            } 
            $("#UserList").datagrid('beginEdit', rowIndex); 
            var editors = $('#UserList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                    $("#UserList").datagrid('endEdit', rowIndex);
                  });   
                  
            } 
             
        }
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBUserAuthority&MethodName=GetUserListByName&UserName=";
	new ListComponent('UserList', columns, uniturl, option).Init();
	
}
/// 实体datagrid查询
function QueryUserList()
{
	var params = $HUI.searchbox("#queryName").getValue();
	$('#UserList').datagrid('load',{
		UserName:params
	}); 
}

/// 实体datagrid重置
function InitPageInfo(){	

	$HUI.searchbox('#queryName').setValue("");
	QueryUserList();	

}

// 插入新行
function insertRow(){
	
	if(editaddRow>="0"){
		$("#UserList").datagrid('endEdit', editaddRow);		//结束编辑，传入之前编辑的行
	}
	$("#UserList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {}
	});
	$("#UserList").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editaddRow=0;
}
/// 保存编辑行
function saveRow(){
	
	if(editaddRow>="0"){
		$("#UserList").datagrid('endEdit', editaddRow);
	}

	var rowsData = $("#UserList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].UserName=="")||(rowsData[i].RoleName=="")||(rowsData[i].JobName=="")){
			$.messager.alert("提示","姓名或职务或岗位不能为空!","info"); 
			return false;
		}

		var tmp=$g(rowsData[i].RowID) +"^"+ $g(rowsData[i].UserName) +"^"+ $g(rowsData[i].RoleName)+"^"+ $g(rowsData[i].JobName)+"^"+ $g(rowsData[i].UserID)+"^"+ $g(rowsData[i].RoleID)+"^"+ $g(rowsData[i].JobID);
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	
	//保存数据
	runClassMethod("web.DHCCKBUserAuthority","SaveUpdate",{"params":params},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else if(jsonString == -100){
			$.messager.alert('提示','保存失败,已存在该条数据！','warning');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		InitPageInfo();		
		
	});
}

/// 实体datagrid删除选中行
function DeleteRow(){
	 
	var rowsData = $("#UserList").datagrid('getSelected'); 						// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBUserAuthority","DeleteUser",{"RowID":rowsData.RowID},function(jsonString){
					if (jsonString == 0){
						$('#UserList').datagrid('reload'); //重新加载
					}else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}					
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