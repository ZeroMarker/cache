/** sufan 
  * 2018-08-23
  *
  * 
 */
var NodeDr =getParam("NodeDr");  ///岗位ID
var editRow="" ;
///初始换界面数据
function initPageDefault(){
	
	initSerGroList();		/// 初始化界面datagrid
	initButton();  		/// 初始化事件
}

/// 初始化界面datagrid
function initSerGroList()
{
	
	var Groupeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISWorkNodeLinkGroup&MethodName=QuerySerGroup",
			//required:true,
			panelHeight:"200",  //设置容器高度自动增长
			mode:'remote',
			onSelect:function(option){
				///设置类型值
				var ed=$("#nodeserglist").datagrid('getEditor',{index:editRow,field:'SerGroupIDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#nodeserglist").datagrid('getEditor',{index:editRow,field:'SerGroupId'});
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
		{field:"NodeGroId",title:'NodeGroId',width:100,hidden:true,editor:textEditor},
		{field:"SerGroupId",title:'SerGroupId',width:100,hidden:true,editor:textEditor},
		{field:"SerGroupIDesc",title:'服务组',width:220,align:'center',editor:Groupeditor},
		{field:"NodeDr",title:'NodeDr',width:220,hidden:true,editor:textEditor},
	]];
	///  定义datagrid  
	var option = {
		singleSelect : true,
	 	onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#nodeserglist").datagrid('endEdit', editRow); 
            } 
            $("#nodeserglist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNodeLinkGroup&MethodName=QueryWorkLinkGroup&NodeId="+NodeDr;
	new ListComponent('nodeserglist', columns, uniturl, option).Init(); 
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
		$("#nodeserglist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#nodeserglist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {NodeGroId: '',SerGroupId:'',SerGroupIDesc:'',NodeDr: NodeDr}
	});
    
	$("#nodeserglist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 保存岗位
function saveRow()
{
	if(editRow>="0"){
		$("#nodeserglist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#nodeserglist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SerGroupId==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行服务组为空！"); 
			return false;
		}
		var tmp= rowsData[i].NodeGroId +"^"+ rowsData[i].NodeDr +"^"+ rowsData[i].SerGroupId +"^"+ rowsData[i].SerGroupIDesc ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISWorkNodeLinkGroup","SaveNodeGroup",{"params":params},function(jsonString){
		if(jsonString=="0")
		{
			$('#nodeserglist').datagrid('reload'); //重新加载
		}
		
	});
}

/// 删除岗位
function deleteRow()
{
	var rowsData = $("#nodeserglist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISWorkNodeLinkGroup","DelNodeGroup",{"NodeGroupId":rowsData.NodeGroId},function(data){
					$('#nodeserglist').datagrid('reload'); //重新加载
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