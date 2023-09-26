/** sufan 
  * 2018-04-09
  *
  * 岗位类型关联维护
 */
var NodeDr =getParam("NodeDr");  ///岗位ID

var editRow="" ;
///初始换界面数据
function initPageDefault(){
	
	initTypeList();		/// 初始化界面datagrid
	initButton();  		/// 初始化事件
}

/// 初始化界面datagrid
function initTypeList()
{
	
	var Typeeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisTypeCombobox",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#typelist").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#typelist").datagrid('getEditor',{index:editRow,field:'TypeId'});
				$(ed.target).val(option.id); 
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
		{field:"NodeTypeId",title:'NodeTypeId',width:100,hidden:true,editor:textEditor},
		{field:"TypeId",title:'TypeId',width:100,hidden:true,editor:textEditor},
		{field:"TypeDesc",title:'类型描述',width:220,align:'center',editor:Typeeditor},
		{field:"NodeId",title:'NodeId',width:220,hidden:true,editor:textEditor},
	]];
	///  定义datagrid  
	var option = {
		singleSelect : true,
	 	 onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#typelist").datagrid('endEdit', editRow); 
            } 
            $("#typelist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkLinkType&MethodName=QueryWorkLinkType&NodeId="+NodeDr;
	new ListComponent('typelist', columns, uniturl, option).Init(); 
}
/// 初始化事件
function initButton(){

	 ///  增加岗位
	$('#insert').bind("click",insertRow);
	
	///  保存岗位
	$('#save').bind("click",saveRow);
	
	///  删除岗位
	$('#delete').bind("click",deleteRow);
}

/// 增加岗位
function insertRow()
{
	if(NodeDr=="")
	{
		$.messager.alert("提示","请先选择岗位列表!");
		return;
	}
	if(editRow>="0"){
		$("#typelist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#typelist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {NodeTypeId: '',TypeId:'',TypeDesc:'',NodeId: ''}
	});
    
	$("#typelist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 保存岗位
function saveRow()
{
	if(editRow>="0"){
		$("#typelist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#typelist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].TypeDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行岗位类型为空！"); 
			return false;
		}
		var tmp=NodeDr +"^"+ rowsData[i].NodeTypeId +"^"+ rowsData[i].TypeId +"^"+ rowsData[i].TypeDesc +"^"+ rowsData[i].NodeId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISWorkLinkType","SaveNodeLinkType",{"params":params},function(jsonString){
		if(jsonString=="0")
		{
			$('#typelist').datagrid('reload'); //重新加载
		}
		
	});
}

/// 删除岗位
function deleteRow()
{
	var rowsData = $("#typelist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISWorkLinkType","DelNodeLinkType",{"NodeTypeId":rowsData.NodeTypeId},function(data){
					$('#typelist').datagrid('reload'); //重新加载
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