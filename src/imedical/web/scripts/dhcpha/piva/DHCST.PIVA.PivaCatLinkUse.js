/*
模块:		静脉配液中心
子模块:		静脉配液中心-配液类别关联用法维护
Creator:	hulihua
CreateDate:	2016-12-16
*/

var editRow = ""; editDRow = ""; polid = "";
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){

	//初始化界面默认信息
	InitDefault();

	//初始化关联用法列表
	InitLinkUseList();
})

///初始化界面默认信息
function InitDefault(){
	polid=getParam("polid");  ///配液类别主表ID
}

///初始化关联用法列表
function InitLinkUseList(){	
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
			url: url+'?action=GetAllInstrucList',  
			onSelect:function(option){
				var ed=$("#linkuseMainList").datagrid('getEditor',{index:editRow,field:'InstrucDr'});
				$(ed.target).val(option.value);  					//设置用法ID
				var ed=$("#linkuseMainList").datagrid('getEditor',{index:editRow,field:'Instruc'});
				$(ed.target).combobox('setValue', option.text);  	//设置用法Desc
			}
		}
	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor,hidden:true},
		{field:'InstrucDr',title:'InstrucDr',width:100,editor:textEditor,hidden:true},
		{field:'Instruc',title:'用法',width:300,editor:tempEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	$('#linkuseMainList').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaLinkInstruc&params='+polid,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#linkuseMainList").datagrid('endEdit', editRow); 
            } 
            $("#linkuseMainList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
}

/// 保存编辑行
function saveRow(){
	
	if(polid==""){		
		$.messager.alert('提示','请选择需要维护的配液分类！')
		return;	
	}
	
	if(editRow>="0"){
		$("#linkuseMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#linkuseMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Instruc=="")||(rowsData[i].Instruc==null)){
			$.messager.alert("提示","需要关联的用法不能为空!"); 
			return false;
		}

		var tmp=polid+"^"+rowsData[i].ID+"^"+rowsData[i].InstrucDr;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVALinkInstruc",params)
	if(data!=""){
		if(data==-1){
			$.messager.alert("提示","需要关联的用法为空,不能保存!"); 
		}else if(data==-2){	
			$.messager.alert('提示','更新失败!',"error");		
		}else if(data==-11){	
			$.messager.alert('提示','该用法已维护!');		
		}else{	
			$.messager.alert('提示','更新成功!');
			$("#linkuseMainList").datagrid('reload');		
		}
	}
}

/// 插入新行
function insertRow(){
	if(polid==""){		
		$.messager.alert('提示','请选择需要维护的配液分类！')
		return;	
	}
	
	if(editRow>="0"){
		$("#linkuseMainList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#linkuseMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {POLID:'', POLMinVolume:'', POLMaxVolume:''}
	});
	$("#linkuseMainList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){			
	if ($("#linkuseMainList").datagrid('getSelections').length != 1) {		
		$.messager.alert('提示','请选一个删除');
		return;
	}
	
	var rowsData = $("#linkuseMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除所选的数据吗？", function (res) {//提示是否删除
			if (res) {
				if (rowsData.ID!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVALinkInstruc",rowsData.ID)
					if(data!=""){
						if(data==-1){
							$.messager.alert("提示","没有选中需要删除的记录!"); 
						}else if(data==-2){	
							$.messager.alert('提示','删除失败!');		
						}else{	
							$.messager.alert('提示','删除成功!');		
						}
						$("#linkuseMainList").datagrid('reload');
					}
				}else{
					var rowIndex = $('#linkuseMainList').datagrid('getRowIndex', rowsData);
     				$('#linkuseMainList').datagrid('deleteRow', rowIndex);  
				}
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

