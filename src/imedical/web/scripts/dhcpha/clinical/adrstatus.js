/// Creator: bianshuai
/// CreateDate: 2014-09-18阿
//  Descript: 不良反应报告状态授权维护

var editRow="";editparamRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行即可编辑]</span>';
var dataArray = [{"value":"G","text":'安全组'}, {"value":"L","text":'科室'}, {"value":"U","text":'人员'}]; //, {"value":"D","text":'全院'}
var AdrStatusId = "";
$(function(){
	
	// 定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'代码',width:160,editor:texteditor},
		{field:'Desc',title:'描述',width:300,editor:texteditor}
	]];
	
	// 定义datagrid
	$('#adrstatusdg').datagrid({
		title:'不良反应报告状态授权'+titleNotes,
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
           if ((editRow != "")||(editRow=="0")) { 
                $("#adrstatusdg").datagrid('endEdit', editRow); 
            } 
            $("#adrstatusdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	    	AdrStatusId=rowData.ID;    ///状态ID
 			var params=AdrStatusId;
			$('#adrstatusparamdg').datagrid({
				url:'dhcpha.clinical.action.csp?action=QueryAdrStatusGrant',	
				queryParams:{
					params:params
				}
			});
	    }
	});
	
	initScroll("#adrstatusdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //调用查询
            findAdrStatus(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findAdrStatus(); //调用查询
    });
    
    $('#adrstatusdg').datagrid({
		url:url+'?action=QueryAdrStatus',	
		queryParams:{
			params:''}
	});
	
	InitAdrStatusParam();
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#adrstatusdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#adrstatusdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrstatusdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#adrstatusdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		/*$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {*/
			$.messager.alert('提示','删除所选的数据请务必确保其在流程定义表中删除干净，否则删除不掉！','warning');  //wangxuejian 2016 08 26
				$.post(url+'?action=DelAdrStatus',{"params":rows[0].ID}, function(data){
					$('#adrstatusdg').datagrid('reload'); //重新加载
                                        $('#adrstatusparamdg').datagrid('reload'); //重新加载   //wangxuejian 2016-09-08
					
				});
			//}
		//});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#adrstatusdg").datagrid('endEdit', editRow);
	}

	var rows = $("#adrstatusdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			$('#adrstatusdg').datagrid('reload'); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveAdrStatus',{"params":rowstr},function(data){
		$('#adrstatusdg').datagrid('reload'); //重新加载
	});
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 查询
function findAdrStatus()
{
	var adrStatusCode=$('#code').val();
	var adrStatusDesc=$('#desc').val();
	var params=adrStatusCode+"^"+adrStatusDesc;
	$('#adrstatusdg').datagrid('load',{params:params}); 
}

/// =====================================参数设置=============================
function InitAdrStatusParam()
{
	//设置其为可编辑
	var editPoint={
		type: 'combobox',     //设置编辑格式
		options: {
			valueField: "value",
			textField: "text",
			url: '',
			onSelect:function(option){
				var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'PointID'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Pointer'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			}
		}
	}
	
	// 定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:'TypeID',title:'TypeID',width:90,editor:'text',hidden:true},
		{field:"Type",title:'类型',width:110,editor:texteditor,
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //设置容器高度自动增长
					onSelect:function(option){
						///设置类型值
						var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'TypeID'});
						$(ed.target).val(option.value);  //设置科室ID
						var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Type'});
						$(ed.target).combobox('setValue', option.text);  //设置科室Desc
						///设置级联指针
						var paramType=option.value+"^"+LgGroupID;  //类型^安全组
						var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Pointer'});
						var unitUrl='dhcpha.clinical.action.csp?action=GetSSPPoint&params='+paramType;
						$(ed.target).combobox('reload',unitUrl);
					} 
				}
			}
		},
		{field:'Pointer',title:'指向',width:300,editor:editPoint},
		{field:'PointID',title:'PointID',width:130,editor:'text',hidden:true}
	]];
	
	// 定义datagrid
	$('#adrstatusparamdg').datagrid({
		title:'权限设置'+titleNotes,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:40,        // 每页显示的记录条数
		//pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		//pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
      
	        var row = $('#adrstatusparamdg').datagrid('getData').rows[rowIndex];

			if ((editparamRow != "")||(editparamRow=="0")) { 
                $("#adrstatusparamdg").datagrid('endEdit', editparamRow); 
            } 
            $("#adrstatusparamdg").datagrid('beginEdit', rowIndex); 

            editparamRow = rowIndex;
		
			 //双击编辑直接可以选择类型指向 duwensheng 2016-09-08
			var paramType=row.TypeID+"^"+LgGroupID;  //类型^安全组
			var ed=$("#adrstatusparamdg").datagrid('getEditor',{index:editparamRow,field:'Pointer'});
			var unitUrl='dhcpha.clinical.action.csp?action=GetSSPPoint&params='+paramType;
			$(ed.target).combobox('reload',unitUrl);


        }
	});
	
	initScroll("#adrstatusparamdg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#insparam').bind('click',insparamRow); 
    $('#delparam').bind('click',delparamRow);
    $('#savparam').bind('click',savparamRow);
}

// 插入新行
function insparamRow()
{
		var ttt=$("#adrstatusparamdg").datagrid('selectRow',editparamRow)

	if(editparamRow>="0"){
		$("#adrstatusparamdg").datagrid('endEdit', editparamRow);//结束编辑，传入之前编辑的行
	}
	$("#adrstatusparamdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrstatusparamdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editparamRow=0;
}

// 删除选中行
function delparamRow()
{
	var rows = $("#adrstatusparamdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrStatusGrant',{"params":rows[0].ID}, function(data){
					$('#adrstatusparamdg').datagrid('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savparamRow()
{
	if(editparamRow>="0"){
		$("#adrstatusparamdg").datagrid('endEdit', editparamRow);
	}

	var rows = $("#adrstatusparamdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if((rows[i].TypeID=="")||(rows[i].PointID=="")){
			$.messager.alert("提示","类型或指向不能为空!"); 
			$('#adrstatusparamdg').datagrid('reload');
			return false;
		}
		
		var tmp=rows[i].ID+"^"+AdrStatusId+"^"+rows[i].TypeID+"^"+rows[i].PointID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("!!");
	//保存数据
	$.post('dhcpha.clinical.action.csp?action=SaveAdrStatusGrant',{"params":rowstr},function(data){
		if(data==0){
			//$.messager.alert("提示","保存成功!");
			$('#adrstatusparamdg').datagrid('reload'); //重新加载
		}
	});
}

/// ==========================================================================
