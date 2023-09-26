/** sufan 
  * 2018-04-09
  *
  * 配送排班维护
 */
var editRow = ""; 
var ParrefId = "";   //上级ID
/// 页面初始化函数
function initPageDefault(){

	initSchelist();       	/// 初始页面DataGrid排班表
	initShiftlist();		/// 班次维护
	initButton();           /// 页面Button绑定事件	
}
///检查分类 
function initSchelist(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 日期编辑格
	var datebox={
		type: 'datebox',//设置编辑格式
		options: {
			required: false//设置编辑规则属性
		}
	}

	// 定义columns
	var columns=[[
		{field:"SchtCode",title:'排班代码',width:200,align:'center',editor:textEditor},
		{field:"SchtDesc",title:'排班描述',width:200,align:'center',editor:textEditor},
		{field:"StartDate",title:'开始日期',width:150,align:'center',editor:datebox,hidden:true},
		{field:"StartTime",title:'开始时间',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"EndDate",title:'结束日期',width:150,align:'center',editor:datebox,hidden:true},
		{field:"EndTime",title:'结束时间',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"LastRowID",title:'LastRowID',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SchtId",title:'ID',width:20,hidden:true}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#schelist").datagrid('endEdit', editRow); 
            } 
            $("#schelist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//双击选择行编辑
           ParrefId = rowData.SchtId;
           $('#shiftlist').datagrid('reload',{params:"",LastRowId:rowData.SchtId});
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QuerySchType&params="+""+"&LastRowId="+0;
	new ListComponent('schelist', columns, uniturl, option).Init(); 
}

function initShiftlist()
{
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	/// 日期编辑格
	var datebox={
		type: 'datebox',//设置编辑格式
		options: {
			required: false//设置编辑规则属性
		}
	}

	// 定义columns
	var columns=[[
		{field:"SchtCode",title:'班次代码',width:140,align:'center',editor:textEditor},
		{field:"SchtDesc",title:'班次描述',width:140,align:'center',editor:textEditor},
		{field:"StartDate",title:'开始日期',width:140,align:'center',editor:datebox},
		{field:"StartTime",title:'开始时间',width:140,align:'center',editor:textEditor},
		{field:"EndDate",title:'结束日期',width:140,align:'center',editor:datebox},
		{field:"EndTime",title:'结束时间',width:140,align:'center',editor:textEditor},
		{field:"LastRowID",title:'LastRowID',width:140,align:'center',editor:textEditor,hidden:true},
		{field:"SchtId",title:'ID',width:20,hidden:true}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#shiftlist").datagrid('endEdit', editRow); 
            } 
            $("#shiftlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QuerySchType";
	new ListComponent('shiftlist', columns, uniturl, option).Init(); 
}
/// 页面 Button 绑定事件
function initButton(){
	
	///  增加排班类型
	$('#insert').bind("click",insertRow);
	
	///  保存排班类型
	$('#save').bind("click",saveRow);
	
	///  删除排班类型
	$('#delete').bind("click",delRow);
	
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findSchelist(); //调用查询
        }
    });
    
     // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findSchelist(); //调用查询
    });
    
    //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findSchelist(); //调用查询
    }); 
    
    ///  增加班次
	$('#subinsert').bind("click",insertsubRow);
	
	///  保存班次
	$('#subsave').bind("click",savesubRow);
	
	///  删除班次
	$('#subdelete').bind("click",delsubRow);
    
 
}

/// 插入排班类型
function insertRow(){

	if(editRow>="0"){
		$("#schelist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#schelist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {SchtId: '',SchtCode:'',SchtDesc: '',StartDateTime:'',EndDateTime:''}
	});
    
	$("#schelist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存排班类型
function saveRow(){
	
	if(editRow>="0"){
		$("#schelist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#schelist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SchtCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].SchtDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		var tmp=rowsData[i].SchtId +"^"+ rowsData[i].SchtCode +"^"+ rowsData[i].SchtDesc +"^"+ rowsData[i].StartDate +"^"+ rowsData[i].StartTime +"^"+ rowsData[i].EndDate +"^"+ rowsData[i].EndTime +"^"+ 0;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISScheduleType","SaveSchType",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#schelist').datagrid('reload');  //重新加载
	});
}

/// 删除
function delRow(){
	
	var rowsData = $("#schelist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISScheduleType","DelSchType",{"SchtId":rowsData.SchtId},function(jsonString){
					
					$('#schelist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 插入班次
function insertsubRow(){
	var rowData = $("#schelist").datagrid('getSelected')
	if(rowData==null){
		$.messager.alert("提示","请先选择排班类型！");
		return;
	}
	
	if(editRow>="0"){
		$("#shiftlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#shiftlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {SchtId: '',SchtCode:'',SchtDesc: '',StartDateTime:'',EndDateTime:''}
	});
    
	$("#shiftlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存排班类型
function savesubRow(){
	
	var rowData = $("#schelist").datagrid('getSelected')
	var LastRowId=rowData.SchtId;
	if(editRow>="0"){
		$("#shiftlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#shiftlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SchtCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].SchtDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		var tmp=rowsData[i].SchtId +"^"+ rowsData[i].SchtCode +"^"+ rowsData[i].SchtDesc +"^"+ rowsData[i].StartDate +"^"+ rowsData[i].StartTime +"^"+ rowsData[i].EndDate +"^"+ rowsData[i].EndTime +"^"+ LastRowId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISScheduleType","SaveSchType",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#shiftlist').datagrid('reload');  //重新加载
	});
}

/// 删除
function delsubRow(){
	
	var rowsData = $("#shiftlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISScheduleType","DelSchType",{"SchtId":rowsData.SchtId},function(jsonString){
					
					$('#shiftlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 查询
function findSchelist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#schelist').datagrid('load',{params:params}); 
}	 
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
