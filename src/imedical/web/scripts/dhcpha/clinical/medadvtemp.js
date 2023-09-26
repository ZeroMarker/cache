/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 用户用药建议模板

var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[双击添加]</span>';
var titleNotes2='<span style="font-weight:bold;color:red;">[双击删除]</span>';
var dataArray = [{"val":"L","text":'科室'}, {"val":"U","text":'人员'}];
var editparamRow="";

$(function(){
	
	// 定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"Code",title:'代码',width:100,editor:texteditor},
		{field:'Desc',title:'描述',width:300,editor:texteditor}
	]];
	
	// 定义datagrid
	$('#medadvdicdg').datagrid({
		title:'用药建议字典'+titleNotes,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			/*
			if(adrEvtEditRow>="0"){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//结束编辑，传入之前编辑的行
			}
			*/
			var tmpMedAdvID=rowData.ID;
			var tmpMedAdvCode=rowData.Code;
			var tmpMedAdvDesc=rowData.Desc;
			var rowData=$('#medadvtempdg').datagrid('getData');   //sufan 2016/9/12
			for(var i=0;i<rowData.rows.length;i++){
				var sugdesc=rowData.rows[i].Desc
				if (tmpMedAdvDesc==sugdesc){
					$.messager.alert("提示","该记录已存在！")
					return;
					}
				} 
			 $('#medadvtempdg').datagrid('insertRow',{
				 index: 0,	// index start with 0
				 row: {
					ID: tmpMedAdvID,
					Code: tmpMedAdvCode,
					Desc: tmpMedAdvDesc
				}
	         });
		}
	});
	
	initScroll("#medadvdicdg");//初始化显示横向滚动条
     
    //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findAdrStatus(); //调用查询
        }
    });
    
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findAdrStatus(); //调用查询
    });
    
    $('#medadvdicdg').datagrid({
		url:url+'?action=QueryDrgSugDic',	
		queryParams:{
			params:''}
	});
	
	InitAdrStatusParam();
	
	//保存类型
	$('#type').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:dataArray
	});
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#medadvdicdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#medadvdicdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#medadvdicdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#medadvdicdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrStatus',{"params":rows[0].ID}, function(data){
					$('#medadvdicdg').datagrid('reload'); //重新加载
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
		$("#medadvdicdg").datagrid('endEdit', editRow);
	}

	var rows = $("#medadvdicdg").datagrid('getChanges');
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
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveAdrStatus',{"params":rowstr},function(data){
		$('#medadvdicdg').datagrid('reload'); //重新加载
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
	var adrStatusCode="";  //$('#code').val();
	var adrStatusDesc=$('#desc').val();
	var params=adrStatusCode+"^"+adrStatusDesc;
	$('#medadvdicdg').datagrid('load',{params:params}); 
}

/// =====================================参数设置=============================
function InitAdrStatusParam()
{	
	// 定义columns
	var columns=[[
		{field:"medAdvID",title:'medAdvID',width:90,align:'center',hidden:true},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"Code",title:'代码',width:100,editor:texteditor},
		{field:'Desc',title:'描述',width:300,editor:texteditor}
	]];
	
	// 定义datagrid
	$('#medadvtempdg').datagrid({
		title:'科室/个人建议模板'+titleNotes2,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			delparamRow();
        }
	});
	
	initScroll("#medadvtempdg");//初始化显示横向滚动条
	
	$('#medadvtempdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',	
		queryParams:{
			params:session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']}
	});
	
	//按钮绑定事件
    $('#insparam').bind('click',insparamRow); 
    $('#delparam').bind('click',delparamRow);
    $('#savparam').bind('click',savparamRow);
}

// 插入新行
function insparamRow()
{
	var ttt=$("#medadvtempdg").datagrid('selectRow',editparamRow)

	if(editparamRow>="0"){
		$("#medadvtempdg").datagrid('endEdit', editparamRow);//结束编辑，传入之前编辑的行
	}
	$("#medadvtempdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#medadvtempdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editparamRow=0;
}

// 删除选中行
function delparamRow()
{
	var rows = $("#medadvtempdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				if(typeof rows[0].medAdvID!="undefined"){
					//删除表记录
					$.post(url+'?action=DelMedAdvTemp',{"params":rows[0].medAdvID}, function(data){
						$('#medadvtempdg').datagrid('reload'); //重新加载
					});
				}else{
					//删除界面项
					var index = $('#medadvtempdg').datagrid('getRowIndex',rows[0]); 
					$('#medadvtempdg').datagrid('deleteRow',index);  
				}
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
	/*
	if(editparamRow>="0"){
		$("#medadvtempdg").datagrid('endEdit', editparamRow);
	}
	*/
	var rows = $("#medadvtempdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		/*
		if((rows[i].ID=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		*/
		///考虑最后是否考虑新增
		var tmp="U"+"^"+session['LOGON.USERID']+"^"+rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post('dhcpha.clinical.action.csp?action=SaveMedAdvTemp',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert("提示","保存成功!");
			$('#medadvtempdg').datagrid('reload'); //重新加载
		}
	});
}

/// ==========================================================================
