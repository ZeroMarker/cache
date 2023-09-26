/// author:    bianshuai
/// date:      2018-06-21
/// descript:  MDT会诊字典维护

var editRow = ""; editDRow = "";
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化咨询信息列表
	InitMainList();
	
	/// 初始化界面按钮事件
	InitWidListener();
}

/// 界面元素监听事件
function InitWidListener(){
	
}

///初始化病人列表
function InitMainList(){
	
	/**
	 * 文本编辑格
	 */
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 诊断
	var MRCEditor={
		type:'combogrid',
		options:{
			    fitColumns:true,
			    fit: true,//自动大小
			    showHeader:false,  
				pagination : true,
				panelWidth:600,
				textField:'MrDesc',
				mode:'remote',
				url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=GetMRCICDDx",
				columns:[[
				    {field:'MRCID',title:'ID',width:100,hidden:true},
				    {field:'MRCCode',title:'代码',width:100},
				    {field:'MRCDesc',title:'描述',width:300}
				]],
				onSelect:function(rowIndex, rowData) {
					
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MrID'});
					$(ed.target).val(rowData.MRCID);
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MrCode'});
					$(ed.target).val(rowData.MRCCode);
    			}		   
			}
		}
		
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'MrID',title:'MrID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'MrCode',title:'代码',width:100,editor:textEditor,align:'center'},
		{field:'MrDesc',title:'描述',width:300,editor:MRCEditor,align:'center'},
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsultDiag&MethodName=QryConsultDiag";
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].MrID==""){
			$.messager.alert("提示","诊断不能为空!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].MrID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMConsultDiag","Save",{"mListData":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#main').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	/// 检查第一行是否为空行
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//开启编辑并传入要编辑的行
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', MrID:'', MrDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMConsultDiag","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('提示','此项已和医嘱项绑定,不能删除！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
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