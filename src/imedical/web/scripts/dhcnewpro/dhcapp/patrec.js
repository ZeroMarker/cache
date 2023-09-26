/** Descript  : 病理病人病例维护
 *  Creator   : sufan
 *  CreatDate : 2018-01-04
 */
var editRow = ""; 
var ActiveArray = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];

/// 页面初始化函数
function initPageDefault(){
	initDiaglist();       	/// 初始页面DataGrid申请状态表
	initButton();           /// 页面Button绑定事件	
}

///申请状态列表 
function initDiaglist(){
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
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'HospDr'});
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
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'APFlag'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
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
		{field:"APCode",title:'代码',width:200,editor:textEditor},
		{field:"APDesc",title:'描述',width:200,editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"APFlag",title:'是否可用',width:80,align:'center',editor:Flageditor},
		{field:"HospDesc",title:'医院',width:200,editor:Hospeditor},
		{field:"HospDr",title:'医院ID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"APRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow === 0){ 
                $("#patreclist").datagrid('endEdit', editRow); 
            } 
            $("#patreclist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPPatRec&MethodName=QueryPatRec&HospID='+LgHospID;
	new ListComponent('patreclist', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function initButton(){
	
	///  增加申请状态
	$('#insert').bind("click",insertRecRow);
	
	///  保存申请状态
	$('#save').bind("click",saveRecRow);
	
	///  删除申请状态
	$('#delete').bind("click",deleteRecRow);
	
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findMetlist(); //调用查询
        }
    });
    
     // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findReclist(); //调用查询
    });
    
     //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findReclist(); //调用查询
    }); 
}

/// 插入申请状态
function insertRecRow(){

	if(editRow>="0"){
		$("#patreclist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#patreclist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {APRowID:'',APCode:'',APDesc:'',FlagCode:'Y',APFlag:'Y',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#patreclist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存申请状态
function saveRecRow(){
	
	if(editRow>="0"){
		$("#patreclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#patreclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].APCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].APDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"医院为空！"); 
			return false;
		}
		var tmp=rowsData[i].APRowID +"^"+ rowsData[i].APCode +"^"+ rowsData[i].APDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//保存数据
	runClassMethod("web.DHCAPPPatRec","SavePatRec",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#patreclist').datagrid('reload'); //重新加载
	});
}

/// 删除
function deleteRecRow(){
	
	var rowsData = $("#patreclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPPatRec","DeletePatRec",{"APRowID":rowsData.APRowID},function(jsonString){
					$('#patreclist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 查询
function findReclist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#patreclist').datagrid('load',{params:params}); 
}	 
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
