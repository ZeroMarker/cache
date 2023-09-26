/// Descript: 检查分类关联医嘱子类维护
/// Creator : qunianpeng
/// Date    : 2017-03-19

var catID = "", editRow = "";

/// 页面初始化函数
function initPageDefault(){
			
	InitDefault();			/// 初始化界面默认信息
	initItmcatlist();	 	///	初始页面DataGrid医嘱子类表
	initButton();           /// 页面Button绑定事件	
}


///初始化界面默认信息
function InitDefault(){
	catID=getParam("itmmastid");  /// 医嘱项ID
}

/// 页面 Button 绑定事件
function initButton(){	

	///  增加医嘱子类
	$('#insertcat').bind("click",insertcatRow);
	
	///  保存医嘱子类
	$('#savecat').bind("click",savecatRow);
	
	///  删除医嘱子类
	$('#deletecat').bind("click",deletecatRow);
}

/// 初始化医嘱子类列表
function initItmcatlist()
{
	var Cateditor={  		/// 设置其为可编辑
		//类别
		type: 'combobox',	/// 设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=jsonArcItemCat",
			required:true,
			panelHeight:"280",  /// 设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// 文本编辑格
	var textEditor={
		type: 'text',		/// 设置编辑格式
		options: {
			required: true  /// 设置编辑规则属性
		}
	}
	// 定义columns
	var columns=[[
		{field:"CatDesc",title:'医嘱子类',width:300,editor:Cateditor},
		{field:"CatDr",title:'子类ID',width:150,align:'center',hidden:'true',editor:textEditor},
		{field:"CatLinkID",title:'ItmID',width:150,align:'center',hidden:'true',editor:textEditor}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {	/// 双击选择行编辑
            if (editRow != "") { 
                $("#itemlist").datagrid('endEdit', editRow); 
            } 
            $("#itemlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryCatLink&ItmId="+catID;
	new ListComponent('itemlist', columns, uniturl, option).Init();
}
/// 插入医嘱子类
function insertcatRow()
{
	if (catID == ""){
		$.messager.alert("提示","请选择一个选项!"); 
		return;	
	}	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);	/// 结束编辑，传入之前编辑的行
	}
	 
	$("#itemlist").datagrid('insertRow', {				/// 在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, 										/// 行数从0开始计算
		row: {CatDesc: '',CatDr:'',CatLinkID: ''}
	});
	$("#itemlist").datagrid('beginEdit', 0);			/// 开启编辑并传入要编辑的行
	editRow=0;
}

///保存检查项目部位
function savecatRow(){
	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);
	}
	
	var hospID = parent.$("#arccatlist").datagrid('getSelected').hospdr;  //这里医院ID不能取session中ID，要取左侧列表选中ID

	var rowsData = $("#itemlist").datagrid('getChanges');  
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if ((rowsData.CatDr=="")||(rowsData[i].CatDesc==""))
		{
			$.messager.alert("提示","请选择医嘱子类!");
			return false;
		}
		
		var tmp=rowsData[i].CatLinkID +"^"+ catID +"^"+ rowsData[i].CatDesc +"^"+ rowsData[i].CatDr +"^"+ hospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCAPPArcCat","Save",{"params":params},function(jsonString){
		if (jsonString == "0"){
			$.messager.alert('提示','保存成功！');
		}
		if (jsonString=="-11")
		{
			$.messager.alert('提示','该医嘱子类已关联其他分类，请重新选择！');
			}
		$('#itemlist').datagrid('reload'); 					/// 重新加载
	});
}
/// 删除
function deletecatRow(){
	
	var rowsData = $("#itemlist").datagrid('getSelected');	/// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	/// 提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelCatLink",{"CatLinkId":rowsData.CatLinkID},function(jsonString){
					$('#itemlist').datagrid('reload'); 		/// 重新加载
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