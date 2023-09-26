/** sufan 
  * 2018-04-09
  *
  * 配送服务组维护
 */
var editRow = ""; 
var editsubRow="";
var dataArray = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
/// 页面初始化函数
function initPageDefault(){

	initSerGrolist();       	/// 初始页面DataGrid排班表
	initGroLinklist();			/// 服务组关联科室
	initButton();           	/// 页面Button绑定事件	
}
///服务组列表 
function initSerGrolist(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	var Hospeditor={  //设置其为可编辑
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
				var ed=$("#sergrolist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#sergrolist").datagrid('getEditor',{index:editRow,field:'SergHosp'});
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
				var ed=$("#sergrolist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
				$(ed.target).combobox('setValue', option.value);  //设置是否可用
			} 
		}

	}

	// 定义columns
	var columns=[[
		{field:"SergCode",title:'代码',width:150,align:'center',editor:textEditor},
		{field:"SergDesc",title:'描述',width:150,align:'center',editor:textEditor},
		{field:"SergFlag",title:'是否可用',width:150,align:'center',editor:Flageditor},
		{field:"FlagCode",title:'FlagCode',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"HospDesc",title:'集团化医院',width:180,align:'center',editor:Hospeditor},
		{field:"SergHosp",title:'SergHosp',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SergId",title:'ID',width:20,hidden:true}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#sergrolist").datagrid('endEdit', editRow); 
            } 
            $("#sergrolist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//双击选择行编辑
           $('#groliklist').datagrid('reload',{SerGroId:rowData.SergId});
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDIDServiceGroupLink&MethodName=QuerySerGro";
	new ListComponent('sergrolist', columns, uniturl, option).Init(); 
}

///科室列表 
function initGroLinklist(){
	
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	var Loceditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo",
			//required:true,
			panelHeight:"400",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#groliklist").datagrid('getEditor',{index:editsubRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#groliklist").datagrid('getEditor',{index:editsubRow,field:'SgllLocId'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"SerGroId",title:'SerGroId',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SerGroDesc",title:'描述',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"SgllLocId",title:'SgllLocId',width:150,align:'center',editor:textEditor,hidden:true},
		{field:"LocDesc",title:'科室描述',width:200,align:'center',editor:Loceditor},
		{field:"SgllId",title:'ID',width:20,hidden:true}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editsubRow != "")||(editsubRow == "0")) { 
                $("#groliklist").datagrid('endEdit', editsubRow); 
            } 
            $("#groliklist").datagrid('beginEdit', rowIndex); 
            
            editsubRow = rowIndex; 
        },
        onClickRow: function (rowIndex, rowData) {//双击选择行编辑
           //$('#shiftlist').datagrid('reload',{params:"",LastRowId:rowData.SchtId});
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDIDServiceGroupLink&MethodName=QuerySgllLoc";
	new ListComponent('groliklist', columns, uniturl, option).Init(); 
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
         findSerglist(); //调用查询
    });
    
    //重置按钮绑定单击事件
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findSerglist(); //调用查询
    }); 
    
    ///  增加班次
	$('#subinsert').bind("click",insertsubRow);
	
	///  保存班次
	$('#subsave').bind("click",savesubRow);
	
	///  删除班次
	$('#subdelete').bind("click",delsubRow);
	
	
}

/// 插入配送服务组
function insertRow(){

	if(editRow>="0"){
		$("#sergrolist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#sergrolist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {SergId: '',SergCode:'',SergDesc: '',SergFlag:'Y',FlagCode:'Y',HospDesc:LgHospID,SergHosp:LgHospID}
	});
    
	$("#sergrolist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
///保存排班类型
function saveRow(){
	
	if(editRow>="0"){
		$("#sergrolist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#sergrolist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SergCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行代码为空！"); 
			return false;
		}
		if(rowsData[i].SergDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行描述为空！"); 
			return false;
		}
		if(rowsData[i].FlagCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行可用标识为空！"); 
			return false;
		}
		if(rowsData[i].SergHosp==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行医院信息为空！"); 
			return false;
		}
		var tmp=rowsData[i].SergId +"^"+ rowsData[i].SergCode +"^"+ rowsData[i].SergDesc +"^"+ rowsData[i].FlagCode +"^"+ rowsData[i].SergHosp;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDIDServiceGroupLink","SaveSerGro",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#sergrolist').datagrid('reload');  //重新加载
	});
}

/// 删除
function delRow(){
	
	var rowsData = $("#sergrolist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDIDServiceGroupLink","DelSerGro",{"SergRowId":rowsData.SergId},function(jsonString){
					
					$('#sergrolist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
///===================================================关联科室维护========================================================
/// 插入班次
function insertsubRow(){
	var rowData = $("#sergrolist").datagrid('getSelected');
	if(rowData==null){
		$.messager.alert("提示","请先选服务组！");
		return;
	}
	var SergId=rowData.SergId;
	if(editsubRow>="0"){
		$("#groliklist").datagrid('endEdit', editsubRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#groliklist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {SgllId: '',SerGroId:SergId,SerGroDesc: '',SgllLocId:'',LocDesc:''}
	});
    
	$("#groliklist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editsubRow=0;
}
///保存排班类型
function savesubRow(){
	
	
	if(editsubRow>="0"){
		$("#groliklist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#groliklist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SgllLocId==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行科室为空！"); 
			return false;
		}
		var tmp=rowsData[i].SgllId +"^"+ rowsData[i].SerGroId +"^"+ rowsData[i].SgllLocId ;
		dataList.push(tmp);
	} 
	
	var params=dataList.join("&&");
	
	//保存数据
	runClassMethod("web.DHCDIDServiceGroupLink","SaveSerLoc",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#groliklist').datagrid('reload');  //重新加载
	});
}

/// 删除
function delsubRow(){
	
	var rowsData = $("#groliklist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDIDServiceGroupLink","DelSerLoc",{"SgllRowId":rowsData.SgllId},function(jsonString){
					
					$('#groliklist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 查询
function findSerglist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#sergrolist').datagrid('load',{params:params}); 
}	 
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
