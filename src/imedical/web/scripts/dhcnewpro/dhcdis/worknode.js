/** sufan 
  * 2018-04-09
  *
  * 配送岗位维护
 */
var editRow="" ;
///初始换界面数据
function initPageDefault(){
	
	initNodeList();		/// 初始化界面datagrid
	initButton();  		/// 初始化事件
}
var dataArray=[{value:0,text:"普通岗位"},{value:1,text:"管理岗位"}]
/// 初始化界面datagrid
function initNodeList()
{
	var Typeeditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			editable:false, 
			onSelect:function(option){
				///设置类型值
				var ed=$("#worknodelist").datagrid('getEditor',{index:editRow,field:'NodeType'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
				var ed=$("#worknodelist").datagrid('getEditor',{index:editRow,field:'NodeTypeCode'});
				$(ed.target).val(option.value);  //设置是否可用
			} 
		}

	}
	
	/// 文本编辑格
	var textEditor={
		type: 'text',		 //设置编辑格式
		options: {
			required: true   //设置编辑规则属性
		}
	}
	// 定义columns
	var columns=[[
		{field:"NodeCode",title:'岗位代码',width:220,align:'center',editor:textEditor},
		{field:"NodeDesc",title:'岗位描述',width:220,align:'center',editor:textEditor},
		{field:"NodePerNum",title:'岗位最大人数',width:120,align:'center',editor:textEditor},
		{field:"NodeTypeCode",title:'NodeTypeCode',width:120,hidden:'true',editor:textEditor},
		{field:"NodeType",title:'岗位类型',width:120,align:'center',editor:Typeeditor},
		{field:"NodeRowId",title:'ID',width:100,hidden:'true',align:'center'}
	]];
	///  定义datagrid  
	var option = {
		singleSelect : true,
	 	 onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#worknodelist").datagrid('endEdit', editRow); 
            } 
            $("#worknodelist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNode&MethodName=QueryDisNode";
	new ListComponent('worknodelist', columns, uniturl, option).Init(); 
}
/// 初始化事件
function initButton(){

	 ///  增加岗位
	$('#insert').bind("click",insertRow);
	
	///  保存岗位
	$('#save').bind("click",saveRow);
	
	///  删除岗位
	$('#delete').bind("click",deleteRow);
	
	///  查询
	$('#find').bind("click",findNodeist);
	
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findNodeist(); //调用查询
        }
    });
    
     //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findNodeist(); //调用查询
    }); 
}

/// 增加岗位
function insertRow()
{
	if(editRow>="0"){
		$("#worknodelist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#worknodelist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {NodeRowId: '',NodeCode:'',NodeDesc: '',NodePerNum:'',NodeTypeCode:''}
	});
    
	$("#worknodelist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 保存岗位
function saveRow()
{
	if(editRow>="0"){
		$("#worknodelist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#worknodelist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].NodeCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].NodeDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		if(rowsData[i].NodeTypeCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行岗位类型为空！"); 
			return false;
		}
		var tmp=rowsData[i].NodeRowId +"^"+ rowsData[i].NodeCode +"^"+ rowsData[i].NodeDesc +"^"+ rowsData[i].NodePerNum +"^"+ rowsData[i].NodeTypeCode;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//alert(params)
	//保存数据
	runClassMethod("web.DHCDISWorkNode","SaveDisNode",{"params":params},function(jsonString){
		
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#worknodelist').datagrid('reload'); //重新加载
	});
}

/// 删除岗位
function deleteRow()
{
	var rowsData = $("#worknodelist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISWorkNode","DelDisNode",{"NodeRowId":rowsData.NodeRowId},function(data){
					$('#worknodelist').datagrid('reload'); //重新加载
				}) 
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 查询
function findNodeist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#worknodelist').datagrid('load',{params:params}); 
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })