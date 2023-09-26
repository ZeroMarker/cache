/// Creator: congyue
/// CreateDate: 2015-12-15
//  Descript: 用药环节字典维护

var editRow=""; editmuliRow=""; //当前编辑行号
var url="dhcadv.repaction.csp";
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var MedUseLinkId = "";
$(function(){	
	// 定义columns
	var columns=[[  
		{field:"Code",title:'代码',width:150,editor:texteditor},
		{field:'Desc',title:'描述',width:150,editor:texteditor},
		{field:"ID",title:'ID',width:70,align:'center'}
	]];
	
	// 定义datagrid
	$('#meduselinkdg').datagrid({
		title:'用药环节',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#meduselinkdg").datagrid('endEdit', editRow); 
			}
            $("#meduselinkdg").datagrid('beginEdit', rowIndex);
            
            var edc = $("#meduselinkdg").datagrid('getEditor', {index:rowIndex, field:'Code'});
		 	
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	    	MedUseLinkId=rowData.ID;    ///工作流ID
 			var params=MedUseLinkId;
				$('#meduselinkitmdg').datagrid({
					url:'dhcadv.repaction.csp?action=QueryMedUseLinkItm',	
					queryParams:{
						params:params
					}
				
				});
 			
        } 
	});
	
	initScroll("#meduselinkdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
     //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findMedUseLink(); //调用查询
        }
    });
    
   
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findMedUseLink(); //调用查询
    });
    
    $('#meduselinkdg').datagrid({
		url:url+'?action=QueryMedUseLink',	
		queryParams:{
			params:''}
	});
	
	InitMULinkItmParam();
	
	//给datagrid一个空数据      
	$('#meduselinkitmdg').datagrid({		//乔庆澳  2016/7/13
		url:url+'?action=JoeClearPage',	
		queryParams:{
			params:''}
	});
	
	
})  //这里是functions结束


// 插入新行
function insertRow()
{	
	if(editRow>="0"){
		$("#meduselinkdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#meduselinkdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		
		row: {ID: '',Code:'',Desc: ''}
	});
	
	$("#meduselinkdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	var ed = $("#meduselinkdg").datagrid('getEditor', {index:0, field:'Code'});
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#meduselinkdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMedUseLink',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if(data==-1){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}
					$('#meduselinkdg').datagrid('reload'); //重新加载
					$('#meduselinkitmdg').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#meduselinkdg").datagrid('endEdit', editRow);
	}

	var rows = $("#meduselinkdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");

	//保存数据
	$.post(url+'?action=SaveMedUseLink',{"params":rowstr},function(data){
		
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert('提示','操作失败','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#meduselinkdg').datagrid('reload'); //重新加载
		
	});
}

// 编辑格
var texteditor={
	type: 'validatebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 查询
function findMedUseLink()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#meduselinkdg').datagrid('load',{params:params}); 
}
/// =====================================用药环节项目设置=============================
function InitMULinkItmParam()
{
		//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				
				var ed=$("#meduselinkitmdg").datagrid('getEditor',{index:editmuliRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}

	// 定义columns
	var columns=[[
		{field:'Code',title:'代码',width:150,editor:texteditor},
		{field:"Desc",title:'描述',width:150,editor:texteditor},
		{field:'Active',title:'是否可用',width:100,editor:activeEditor},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#meduselinkitmdg').datagrid({
		title:'用药环节项目',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if ((editmuliRow != "")||(editmuliRow == "0")) {
            	 $("#meduselinkitmdg").datagrid('endEdit', editmuliRow); 
			}            
            $("#meduselinkitmdg").datagrid('beginEdit', rowIndex); 
            editmuliRow = rowIndex; 
        }
       
	});
	
	initScroll("#meduselinkitmdg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#insmuli').bind('click',insmuliRow); 
    $('#delmuli').bind('click',delmuliRow);
    $('#savmuli').bind('click',savmuliRow);
	

}
// 插入新行
function insmuliRow()
{

	if( editmuliRow>="0"){
		$("#meduselinkitmdg").datagrid('endEdit',  editmuliRow);//结束编辑，传入之前编辑的行
	}
	$("#meduselinkitmdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: '',Active: 'Y'}
	});
	$("#meduselinkitmdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	 editmuliRow=0;
}

// 删除选中行
function delmuliRow()
{
	var rows = $("#meduselinkitmdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMedUseLinkItm',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if(data==-1){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}
					$('#meduselinkitmdg').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savmuliRow()
{
	if( editmuliRow>="0"){
		$("#meduselinkitmdg").datagrid('endEdit',  editmuliRow);
	}
	var rows = $("#meduselinkitmdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(MedUseLinkId==""){
			$.messager.alert("提示","请选择一条用药环节数据!"); 
			return false;
		}
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].Active=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+MedUseLinkId+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Active;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&")
	
	//保存数据
	$.post(url+'?action=SaveMedUseLinkItm',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert('提示','操作失败','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#meduselinkitmdg').datagrid('reload'); //重新加载
		
	});
	
}

