/** sufan 
  * 2018-04-09
  *
  * 岗位人员关联维护
 */
var NodeDr =getParam("NodeDr");  ///岗位ID
var editRow="" ;
///初始换界面数据
function initPageDefault(){
	
	initUserList();		/// 初始化界面datagrid
	initButton();  		/// 初始化事件
}

/// 初始化界面datagrid
function initUserList()
{
	
	var Usereditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser",
			//required:true,
			panelHeight:"400",  //设置容器高度自动增长
			mode:'remote',
			onSelect:function(option){
				///设置类型值
				var ed=$("#userlist").datagrid('getEditor',{index:editRow,field:'UserDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#userlist").datagrid('getEditor',{index:editRow,field:'UserId'});
				$(ed.target).val(option.value); 
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
		{field:"NodeUserId",title:'NodeUserId',width:100,hidden:true,editor:textEditor},
		{field:"UserId",title:'UserId',width:100,hidden:true,editor:textEditor},
		{field:"UserDesc",title:'人员姓名',width:220,align:'center',editor:Usereditor},
		{field:"NodeId",title:'NodeId',width:220,hidden:true,editor:textEditor},
	]];
	///  定义datagrid  
	var option = {
		singleSelect : true,
	 	onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#userlist").datagrid('endEdit', editRow); 
            } 
            $("#userlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNodeLinkUser&MethodName=QueryWorkLinkUser&NodeId="+NodeDr;
	new ListComponent('userlist', columns, uniturl, option).Init(); 
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
		$("#userlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#userlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {NodeUserId: '',UserId:'',UserDesc:'',NodeId: ''}
	});
    
	$("#userlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 保存岗位
function saveRow()
{
	if(editRow>="0"){
		$("#userlist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#userlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].UserDesc==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行人员姓名为空！"); 
			return false;
		}
		var tmp= rowsData[i].NodeUserId +"^"+ NodeDr +"^"+ rowsData[i].UserId +"^"+ rowsData[i].UserDesc +"^"+ rowsData[i].NodeId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//alert(params)
	//保存数据
	runClassMethod("web.DHCDISWorkNodeLinkUser","SaveNodeLinkUser",{"params":params},function(jsonString){
		//alert(jsonString)
		if(jsonString=="0")
		{
			$('#userlist').datagrid('reload'); //重新加载
		}
		
	});
}

/// 删除岗位
function deleteRow()
{
	var rowsData = $("#userlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISWorkNodeLinkUser","DelNodeLinkUser",{"NodeUserId":rowsData.NodeUserId},function(data){
					$('#userlist').datagrid('reload'); //重新加载
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