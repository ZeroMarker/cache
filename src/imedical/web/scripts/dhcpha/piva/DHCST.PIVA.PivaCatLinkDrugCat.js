/*
模块:		静脉配液中心
子模块:		静脉配液中心-配液类别关联药品配液分类维护
Creator:	hulihua
CreateDate:	2016-12-16
*/

var editRow = ""; editDRow = ""; polid = "";
var dataArray = [{"value":"1","text":'并且'}, {"value":"2","text":'或者'}];
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){

	//初始化界面默认信息
	InitDefault();

	//初始化关联药品配液分类列表
	InitLinkDrugCatList();
})

///初始化界面默认信息
function InitDefault(){
	polid=getParam("polid");  ///配液类别主表ID
}

///初始化关联药品配液分类列表
function InitLinkDrugCatList(){	
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
			url: url+'?action=GetAllPHCPivaCatList',  
			onSelect:function(option){
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'PivaCatDr'});
				$(ed.target).val(option.value);  					//设置用法ID
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'PivaCat'});
				$(ed.target).combobox('setValue', option.text);  	//设置用法Desc
			}
		}
	}
	
	var Flageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'RelationValue'});
				$(ed.target).val(option.value);  
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'RelationFlag'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}

	}
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor,hidden:true},
		{field:'RelationValue',title:'RelationValue',width:100,editor:textEditor,hidden:true},
		{field:'RelationFlag',title:'关系',align:'center',width:120,editor:Flageditor},
		{field:'PivaCatDr',title:'PivaCatDr',width:100,editor:textEditor,hidden:true},
		{field:'PivaCat',title:'药品配液分类',width:300,editor:tempEditor}
	]];
	
	/**
	 * 定义datagrid
	 */
	$('#linkdrugcatMainList').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaLinkPivaCat&params='+polid,
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
                $("#linkdrugcatMainList").datagrid('endEdit', editRow); 
            } 
            $("#linkdrugcatMainList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
	$('#linkdrugcatMainList').datagrid('loadData',{total:0,rows:[]}); 
}

/// 保存编辑行
function saveRow(){
	
	if(polid==""){		
		$.messager.alert('提示','请选择需要维护的配液分类！')
		return;	
	}
	
	if(editRow>="0"){
		$("#linkdrugcatMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#linkdrugcatMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PivaCat=="")||(rowsData[i].PivaCat==null)){
			$.messager.alert("提示","需要关联的药品配液分类不能为空!"); 
			return false;
		}
		if((rowsData[i].RelationFlag=="")||(rowsData[i].RelationFlag==null)){
			$.messager.alert("提示","关联关系不能为空!"); 
			return false;
		}

		var tmp=polid+"^"+rowsData[i].ID+"^"+rowsData[i].PivaCatDr+"^"+rowsData[i].RelationValue;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVALinkItm",params)
	if(data!=""){
		if(data==-1){
			$.messager.alert("提示","需要关联的药品配液类别为空,不能保存!"); 
		}else if(data==-2){	
			$.messager.alert('提示','更新失败!');		
		}else if(data==-3){	
			$.messager.alert('提示','需要关联的关联关系为空,不能保存!');		
		}else if(data==-11){	
			$.messager.alert('提示','已存在该药品配液分类的关联关系,不能保存!');		
		}
		else{	
			$.messager.alert('提示','更新成功!');
			$("#linkdrugcatMainList").datagrid('reload');		
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
		$("#linkdrugcatMainList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#linkdrugcatMainList").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', PivaCatDr:'', PivaCat:'',RelationFlag:''}
	});
	$("#linkdrugcatMainList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){			
	if ($("#linkdrugcatMainList").datagrid('getSelections').length != 1) {		
		$.messager.alert('提示','请选一个删除');
		return;
	}
	
	var rowsData = $("#linkdrugcatMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				if (rowsData.ID!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVALinkItm",rowsData.ID)
					if(data!=""){
						if(data==-1){
							$.messager.alert("提示","没有选中需要删除的记录!"); 
						}else if(data==-2){	
							$.messager.alert('提示','删除失败!');		
						}else{	
							$.messager.alert('提示','删除成功!');		
						}
						$("#linkdrugcatMainList").datagrid('reload');
					}
				}else{
				         var rowIndex = $('#linkdrugcatMainList').datagrid('getRowIndex', rowsData);
         				$('#linkdrugcatMainList').datagrid('deleteRow', rowIndex);  
				}
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

