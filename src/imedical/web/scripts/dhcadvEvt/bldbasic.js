/// Creator: congyue
/// CreateDate: 2016-01-13
//  Descript: 输血患者体征字典维护
 
var editRow="";  //当前编辑行号
var url="dhcadv.repaction.csp";
var typeArray= [{"value":"A","text":"患者体征"}, {"value":"B","text":"临床症状"}];
$(function(){
	//Type类型
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:typeArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型ID
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'TypeID'});
				$(ed.target).val(option.value); 
				///设置类型
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue',option.text); 
			} 
		}
	}
	
	// 定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'代码',width:160,editor:texteditor},
		{field:'Desc',title:'描述',width:300,editor:texteditor},
		{field:'TypeID',title:'类型ID',width:100,editor:texteditor,hidden:true},
		//{field:'Type',title:'类型',width:300,editor:typeEditor},
		{field:"Type",title:'类型',width:300,editor:texteditor,
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
		options: {
			data:typeArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型ID
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'TypeID'});
				$(ed.target).val(option.value); 
				///设置类型
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue',option.text); 
			} 
		}
			}
		}
	]];
	
	// 定义datagrid
	$('#bldbasdg').datagrid({
		title:'',
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
            	$("#bldbasdg").datagrid('endEdit', editRow); 
			} 
            $("#bldbasdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	initScroll("#bldbasdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            queryBldBasic(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         queryBldBasic(); //调用查询
    });
    
    $('#bldbasdg').datagrid({
		url:url+'?action=QueryBldBasic',	
		queryParams:{
			params:""}
	});
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#bldbasdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#bldbasdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: '',TypeID: '',Type: ''}
	});
	$("#bldbasdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#bldbasdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelBldBasic',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if(data==-1){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}
					$('#bldbasdg').datagrid('reload'); //重新加载
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
		$("#bldbasdg").datagrid('endEdit', editRow);
	}

	var rows = $("#bldbasdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].Type=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].TypeID
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//保存数据
	$.post(url+'?action=SaveBldBasic',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
			//return;	//2017-03-17 保存失败，刷新字典表	
		}else {
			$.messager.alert('提示','操作失败','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#bldbasdg').datagrid('reload'); //重新加载
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
function queryBldBasic()
{
	var bldBasicCode=$('#code').val();
	var bldBasicDesc=$('#desc').val();
	var params=bldBasicCode+"^"+bldBasicDesc;
	$('#bldbasdg').datagrid('load',{params:params}); 
}
