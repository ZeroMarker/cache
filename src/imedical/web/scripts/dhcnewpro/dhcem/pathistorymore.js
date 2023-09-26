/// author:    sufan
/// date:      2018-07-27
/// descript:  急诊毒性物质维护

var ActiveArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var editRow = ""; editDRow = "";
$(function(){
	///多院区设置
	MoreHospSetting("DHC_EmPatHistoryMore");
	InitWidListener();	//初始化界面按钮事件
	InitDetList();	    //初始化咨询信息列表
})
///多院区设置
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = findHisMorelist;
}

/// 界面元素监听事件
function InitWidListener(){

	$("#insert").bind("click",insertRow);
	$("#delete").bind("click",deleteRow);
	$("#save").bind("click",saveRow);
	
	// 查找
    $('#query').bind('click',function(event){
         findHisMorelist(); //调用查询
    });
    
    //同时给代码和描述绑定回车事件
    $('#Code,#Desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findHisMorelist(); //调用查询
        }
    });
    
    // 查找
    $('#reset').bind('click',function(event){
	     $('#Code').val("");
	     $('#Desc').val("");
         findHisMorelist(); //调用查询
    });
    
	
}

///初始化病人列表
function InitDetList(){
	/*
	 * 定义columns
	 */
 
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 医院
	var Hospeditor={		//设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'HospDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// 是否可用
	var Flageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:ActiveArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'PHIMIFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#HisMoreList").datagrid('getEditor',{index:editRow,field:'FlagCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	
	var columns=[[
		{field:'PHIMRowID',title:'ID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'PHIMICode',title:'代码',width:100,editor:textEditor,align:'center'},
		{field:'PHIMIDesc',title:'描述',width:100,editor:textEditor,align:'center'},
		{field:'HospDr',title:'HospDr',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'HospDesc',title:'集团化医院 ',width:100,editor:Hospeditor,align:'center',hidden:true},
		{field:'PHIMIFlag',title:'可用标识',width:100,editor:Flageditor,align:'center',formatter:function(value,row,index){
			if (value=='Y'){return '是';} 
			else {return '否';}
		 }},
		{field:'FlagCode',title:'FlagCode',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'Type',title:'类型',width:100,editor:textEditor,align:'center'} //hxy 2019-11-15 加类型
	]];
	
	var code=$('#Code').val();
	var desc=$('#Desc').val();
	var hospID = $HUI.combogrid("#_HospList").getValue();	
	var params=code+"^"+desc+"^"+hospID;
	
	$HUI.datagrid("#HisMoreList",{
		url: LINK_CSP+"?ClassName=web.DHCEMPatHistoryMore&MethodName=QueryPatHisMore&params="+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		title:'',
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#HisMoreList").datagrid('endEdit', editRow); 
            } 
            $("#HisMoreList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }	
	})
	

}

/// 保存编辑行
function saveRow(){
	
	if(editRow>="0"){
		$("#HisMoreList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#HisMoreList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PHIMICode==="")){
			$.messager.alert("提示","代码为空");     
			return false;
		}
		
		if((rowsData[i].PHIMIDesc==="")){
			$.messager.alert("提示","描述不能为空");     
			return false;
		}
		
		if((rowsData[i].HospDr==="")){
			$.messager.alert("提示","集团医院不能为空");     
			return false;
		}
		
		if((rowsData[i].FlagCode==="")){
			$.messager.alert("提示","可用标识不能为空");     
			return false;
		}
		
		
		
		var tmp=rowsData[i].PHIMRowID+"^"+rowsData[i].PHIMICode +"^"+ rowsData[i].PHIMIDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode+"^"+rowsData[i].Type ; //hxy 2019-11-15 Type
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//保存数据
	runClassMethod("web.DHCEMPatHistoryMore","SavePatHisMore",{"params":params},function(data){
		
		if (data==0){
			//$.messager.alert('提示','添加成功！');
		}
		if ((data=="-1")||(data=="-3")){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');	
		}
		if ((data=="-2")||(data=="-4")){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');	
		}
		
		$('#HisMoreList').datagrid('reload'); //重新加载
	})
}

/// 插入新行
function insertRow(){
	
	if(editRow>="0"){
		$("#HisMoreList").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	var HospID=$HUI.combogrid("#_HospList").getValue();
	$("#HisMoreList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {PHIMRowID:'',PHIMICode:'',PHIMIDesc:'',PHIMIFlag:'Y',FlagCode:'Y',HospDr:HospID,HospDesc:HospID}
	});
    
	$("#HisMoreList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#HisMoreList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMPatHistoryMore","DeletePatHisMore",{"PHIMRowID":rowsData.PHIMRowID},function(jsonString){
					if (jsonString != 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#HisMoreList').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 查询
function findHisMorelist()
{
	var code=$('#Code').val();
	var desc=$('#Desc').val();
	var hospID = $HUI.combogrid("#_HospList").getValue();	
	var params=code+"^"+desc+"^"+hospID;
	$('#HisMoreList').datagrid('load',{params:params}); 
}