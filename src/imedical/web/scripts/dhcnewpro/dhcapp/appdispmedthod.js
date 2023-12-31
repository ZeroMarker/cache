/// Creator: sufan
/// CreateDate: 2016-4-15
//  Descript:后处理字典维护

var editRow="";editparamRow="";  //当前编辑行号
var dataArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];

$(function(){
	var Eventeditor={  //设置其为可编辑
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
				var ed=$("#medthodlist").datagrid('getEditor',{index:editRow,field:'hospdesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#medthodlist").datagrid('getEditor',{index:editRow,field:'adhospdr'});
				$(ed.target).val(option.value); 
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
				var ed=$("#medthodlist").datagrid('getEditor',{index:editRow,field:'apactiveflag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
			} 
		}

	}

	// 定义columns
	var columns=[[
		{field:"adcode",title:'代码',width:120,editor:texteditor},
		{field:"addesc",title:'描述',width:120,editor:texteditor},
	    {field:'adactiveflag',title:'是否可用',align:'center',width:120,editor:Flageditor},
		{field:'hospdesc',title:'医院',width:220,editor:Eventeditor},
		{field:"adhospdr",title:'adhospdr',width:100,align:'center',editor:texteditor,hidden:true},
		{field:"adrowid",title:'ID',width:100,align:'center',hidden:true}
	]];
	/*
	// 定义datagrid
	$('#medthodlist').datagrid({
		title:'后处理字典维护',
		url:LINK_CSP+'?ClassName=web.DHCAPPDispMedthod&MethodName=QueryMedthod',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:5,  // 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#medthodlist").datagrid('endEdit', editRow); 
            } 
            $("#medthodlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
	*/
	/// bianshuai 2017-01-01 修改，升级1.3.6后页面刷新异常
 	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow === 0) { 
                $("#medthodlist").datagrid('endEdit', editRow); 
            } 
            $("#medthodlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	
 	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPDispMedthod&MethodName=QueryMedthod";
	new ListComponent('medthodlist', columns, uniturl, option).Init();
	
 	//按钮绑定事件
	$('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //调用查询
            findAdrStatus(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findAdrStatus(); //调用查询
    });
    

})

// 插入新行
function insertRow(){
		
	if(editRow>="0"){
		/// 验证当前行
		if(!$("#medthodlist").datagrid('validateRow', editRow)){
			$.messager.alert("提示","医院不能为空!");
			return;
		}
		$("#medthodlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#medthodlist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {adrowid:'', adcode:'', addesc:'', adactiveflag:'Y', adhospdr:'',hospdesc:''}
	});
	$("#medthodlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
// 删除选中行
function deleteRow(){
	
	var rowsData = $("#medthodlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPDispMedthod","DelMedthod",{"params":rowsData.adrowid},function(jsonString){
					if (jsonString=="-11")
					{
						$.messager.alert("提示","该处理方法已经使用，不能删除!")
						}
					$('#medthodlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#medthodlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#medthodlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		/// 验证当前行
		if((rowsData[i].adcode=="")||(rowsData[i].addesc=="")){
			$.messager.alert("提示","代码或描述不能为空!");
			$('#medthodlist').datagrid('reload'); //重新加载			
			return false;
		}
		if (rowsData[i].adhospdr==""){
			$.messager.alert("提示","医院不能为空!");
			$('#medthodlist').datagrid('reload'); //重新加载			
			return false;
			}
		var tmp=rowsData[i].adrowid +"^"+ rowsData[i].adcode +"^"+ rowsData[i].addesc +"^"+ rowsData[i].adactiveflag +"^"+ rowsData[i].adhospdr;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPDispMedthod","SaveMedthod",{"params":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#medthodlist').datagrid('reload'); //重新加载
		/*if(jsonString==0){
			//$.messager.alert("提示","保存成功!"); 
			$('#medthodlist').datagrid('reload'); //重新加载
		}else if(jsonString==-99){
			$.messager.alert("提示","代码重复!"); 
			$('#medthodlist').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示","保存失败!"); 
			$('#medthodlist').datagrid('reload'); //重新加载
			}*/
	});
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 查询
function findAdrStatus()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#medthodlist').datagrid('load',{params:params}); 
}



