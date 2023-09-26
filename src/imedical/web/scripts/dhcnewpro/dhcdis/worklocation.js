/** sufan 
  * 2018-04-09
  *
  * 岗位工作位置关联维护
 */
var NodeDr =getParam("NodeDr");  ///岗位ID
var editRow="" ;
///初始换界面数据
function initPageDefault(){
	
	ComboEditor(); 		/// 初始化编辑器
	initLocList();		/// 初始化界面datagrid
	initButton();  		/// 初始化事件
}

/// 初始化界面datagrid
function initLocList()
{
	var LocEditor={		//设置其为可编辑
		type: 'combogrid',	//设置编辑格式
		options:{
			required : true,
			id : 'NodeLocId',
			fitColumns : true,
			fit : true,//自动大小  
			pagination : true,
			panelWidth : 450,
			textField : 'NodeName',
			mode : 'remote',
			url : 'dhcapp.broker.csp?ClassName=web.DHCDISNodeLinkLoc&MethodName=QueryNodeLoc',
			columns:[[
					{field:'NodeLocId',hidden:true},
					{field:'NodeName',title:'名称',width:80},
					{field:'NodeCode',hidden:true,title:'代码',width:60},
					{field:'NodeType',title:'类型',width:40}
					]],
				onSelect:function(rowIndex, rowData) {
   					fillValue(rowIndex, rowData);
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
		{field:"NodeItmId",title:'NodeItmId',hidden:true,width:100,editor:textEditor},
		{field:"LocationId",title:'工作岗位位置Id',hidden:true,width:220,editor:textEditor},
		{field:"NodeCode",title:'工作岗位位置',width:220,align:'center',editor:LocEditor},
		{field:"LocFlagCode",title:'位置标识代码',hidden:true,width:220,editor:textEditor},
		{field:"LocFlag",title:'位置标识',width:220,align:'center',editor:textEditor},
	]];
	///  定义datagrid  
	var option = {
		singleSelect : true,
	 	 onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#locationlist").datagrid('endEdit', editRow); 
            } 
            $("#locationlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISNodeLinkLoc&MethodName=QueryNodeLinkLoc&NodeId="+NodeDr;
	new ListComponent('locationlist', columns, uniturl, option).Init(); 
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
		$("#locationlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#locationlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {NodeItmId: '',LocationId:'',NodeCode:'',LocFlagCode: '',LocFlag:''}
	});
    
	$("#locationlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

/// 保存岗位
function saveRow()
{
	if(editRow>="0"){
		$("#locationlist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#locationlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].NodeCode==""){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行工作岗位位置！"); 
			return false;
		}
		var tmp=NodeDr +"^"+ rowsData[i].LocationId +"^"+ rowsData[i].NodeCode +"^"+ rowsData[i].LocFlagCode +"^"+ rowsData[i].LocFlag +"^"+ rowsData[i].NodeItmId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISNodeLinkLoc","SaveNodeLinkLoc",{"params":params},function(jsonString){
		
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}
		$('#locationlist').datagrid('reload'); //重新加载
	});
}

/// 删除岗位
function deleteRow()
{
	var rowsData = $("#locationlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISNodeLinkLoc","DelNodeLinkLoc",{"NodeItmId":rowsData.NodeItmId},function(data){
					$('#locationlist').datagrid('reload'); //重新加载
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
	$('#locationlist').datagrid('load',{params:params}); 
}
function ComboEditor()
{
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
}
function fillValue(rowIndex, rowData)
{
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'LocationId'});			//项目ID赋值
	$(ed.target).val(rowData.NodeLocId);
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'NodeCode'});			//项目描述赋值
	$(ed.target).val(rowData.NodeName);
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'LocFlagCode'});			//代码
	$(ed.target).val(rowData.NodeCode);
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'LocFlag'});			//标识
	$(ed.target).val(rowData.NodeType);
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })