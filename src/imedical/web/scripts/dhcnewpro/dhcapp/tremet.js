/** Descript  : 病理治疗方法维护
 *  Creator   : sufan
 *  CreatDate : 2017-01-04
 */
var editRow = ""; 
var ActiveArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];

/// 页面初始化函数
function initPageDefault(){
	initTrelist();       	/// 初始页面DataGrid申请状态表
	initButton();           /// 页面Button绑定事件	
}

///申请状态列表 
function initTrelist(){
	// 医院
	var Hospeditor={		//设置其为可编辑
		type: 'combobox',	//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#tremetlist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#tremetlist").datagrid('getEditor',{index:editRow,field:'HospDr'});
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
				var ed=$("#tremetlist").datagrid('getEditor',{index:editRow,field:'ATFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#tremetlist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
				$(ed.target).val(option.value); 
			} 
		}

	}
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 定义columns
	var columns=[[
		{field:"ATCode",title:'代码',width:200,editor:textEditor},
		{field:"ATDesc",title:'描述',width:200,editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"ATFlag",title:'是否可用',width:80,align:'center',editor:Flageditor},
		{field:"HospDesc",title:'医院',width:200,editor:Hospeditor},
		{field:"HospDr",title:'医院ID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"ATRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow === 0){ 
                $("#tremetlist").datagrid('endEdit', editRow); 
            } 
            $("#tremetlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTreMet&MethodName=QueryTreMet&HospID='+LgHospID;
	new ListComponent('tremetlist', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	///  增加申请状态
	$('#insert').bind("click",insertMetRow);
	
	///  保存申请状态
	$('#save').bind("click",saveMetRow);
	
	///  删除申请状态
	$('#delete').bind("click",deleteMetRow);
	
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findMetlist(); //调用查询
        }
    });
    
     // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findMetlist(); //调用查询
    });
    
     //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findMetlist(); //调用查询
    }); 
}

/// 插入申请状态
function insertMetRow(){

	if(editRow>="0"){
		$("#tremetlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#tremetlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ATRowID:'',ATCode:'',ATDesc:'',FlagCode:'Y',ATFlag:'Y',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#tremetlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存申请状态
function saveMetRow(){
	
	if(editRow>="0"){
		$("#tremetlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#tremetlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].ATCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].ATDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"医院为空！"); 
			return false;
		}
		var tmp=rowsData[i].ATRowID +"^"+ rowsData[i].ATCode +"^"+ rowsData[i].ATDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCAPPTreMet","SaveTreMet",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#tremetlist').datagrid('reload'); //重新加载
	});
}

/// 删除
function deleteMetRow(){
	
	var rowsData = $("#tremetlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPTreMet","DeleteTreMet",{"ATRowID":rowsData.ATRowID},function(jsonString){
					$('#tremetlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 查询
function findMetlist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#tremetlist').datagrid('load',{params:params}); 
}	 
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
