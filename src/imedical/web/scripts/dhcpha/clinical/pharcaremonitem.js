/// Creator: bianshuai
/// CreateDate: 2015-04-23
//  Descript: 药学监护项目维护

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[双击行即可编辑]</span>';
$(function(){
	
	// 定义columns
	var columns=[[
		{field:"monItmID",title:'monItmID',width:70,align:'center'},
		{field:"monItmCode",title:'代码',width:100,editor:texteditor},
		{field:'monItmDesc',title:'描述',width:200,editor:texteditor},
		{field:'monLevID',title:'MonLevID',width:70,editor:texteditor,hidden:true},
		{field:'monLevel',title:'级别',width:100,editor:monLevelEditor},
		{field:'monSubClassID',title:'monSubClassID',width:70,editor:texteditor,hidden:true},
		{field:'monSubClass',title:'学科分类',width:200,editor:monSubClassEditor}
	]];
	
	// 定义datagrid
	$('#dg').datagrid({
		//title:'监护项目'+titleNotes,
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
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#dg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('a:contains("增加")').bind('click',insertRow); 
   /*  $('a:contains("删除")').bind('click',deleteRow); */
    $('a:contains("保存")').bind('click',saveRow);
    $('a:contains("查询")').bind('click',queryMonItem);
    
    //监护级别
	$('#MonLevel').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		onShowPanel:function(){
			$('#MonLevel').combobox('reload',url+'?action=SelMonLevel')
		}
	});
	
	//学科分类
	$('#monSubClass').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		onShowPanel:function(){
			$('#monSubClass').combobox('reload',url+'?action=SelMonSubClass')
		}
	});
	    
    $('#dg').datagrid({
		url:url+'?action=QueryMonItem',	
		queryParams:{ monSubClassId:"", monLevId:""}
	});
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#dg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#dg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {monItmID: '',monItmCode:'',monItmDesc: '',monLevID:'',monLevel: '',monSubClassID:'',monSubClass: ''}
	});
	$("#dg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	/* $.messager.alert('提示','<font style="color:red;font-weight:bold;">如需进行删除操作,请联系信息科！谢谢！</font>','warning');
	return; */

	var rows = $("#dg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMonItem',{"params":rows[0].monItmID}, function(data){
					//获取datagrid行数   hezhigang  2018-7-20
					var rowsNew=$('#dg').datagrid('getRows').length;
					//rows<2表示当前尾页全部删除完，采用重载加载首页
					if(rowsNew<2){
						$('#dg').datagrid('load');
					}else{
						$('#dg').datagrid('reload');
					}
					//$('#dg').datagrid('reload'); //重新加载
                    //rows.length=0;   //***新增加的代码
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
		$("#dg").datagrid('endEdit', editRow);
	}

	var rows = $("#dg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++){
		if((rows[i].monItmDesc=="")||(rows[i].monLevID=="")||(rows[i].monSubClassID=="")||(rows[i].monItmCode=="")||(rows[i].monLevel==undefined)||(rows[i].monSubClass==0)){
			$.messager.alert("提示","<font style='color:red;font-weight:bold;'>代码/描述/级别/学科分类</font>有一项可能为空。请核实后,再试!"); 
			//$('#dg').datagrid('reload');
			return false;
		}
		//下面方法获取所有行   hzg 2018-7-25
		var datas="";
		$.ajax({
		url:url+"?action=QueryMonItem",
		//页数1，行数是datagrid的总行数，其他参数和需要获取行对象的datagrid是一样的
		data: {
			page: "1",rows: '9999'
			},
		type: "POST",
		async: false,//true,
		//dataType: "json",
		success: function (data,rows) {
			//getallRows(datas,rows[i])
			if(data){
				datas=data;
				}
			 }

		});		
		//getallRows(datas,rows[i]);
		var favdata = eval("("+datas+")");
		var allRows=favdata.rows;
		for(var j=0;j<allRows.length;j++){
					if((rows[i].monItmCode==allRows[j].monItmCode)&&(rows[i].monItmDesc==allRows[j].monItmDesc)&&(rows[i].monLevID==allRows[j].monLevID)&&(rows[i].monSubClassID==allRows[j].monSubClassID)){
							$.messager.alert("提示","模板已存在，请重新维护!");
							$('#dg').datagrid('reload');
							return true;
						}
					}
		var tmp=rows[i].monItmID+"^"+rows[i].monItmCode+"^"+rows[i].monItmDesc+"^"+rows[i].monLevID+"^"+rows[i].monSubClassID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveMonItm',{"params":rowstr},function(data){
		$('#dg').datagrid('reload'); //重新加载
	});
}

// 编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

//设置其为可编辑
var monLevelEditor={
	type: 'combobox',//设置编辑格式
	options: {
		//required: true,//设置编辑规则属性
		panelHeight:"auto",  //设置容器高度自动增长
		valueField: "value", 
		textField: "text",
		url: url+'?action=SelMonLevel',
		onSelect:function(option){
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monLevID'});
			$(ed.target).val(option.value);  //设置科室ID
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monLevel'});
			$(ed.target).combobox('setValue', option.text);  //设置科室Desc
		}
	}
}

//设置其为可编辑
var monSubClassEditor={
	type: 'combobox',//设置编辑格式
	options: {
		//required: true,//设置编辑规则属性
		panelHeight:"auto",  //设置容器高度自动增长
		valueField: "value", 
		textField: "text",
		url: url+'?action=SelMonSubClass',
		onSelect:function(option){
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monSubClassID'});
			$(ed.target).val(option.value);  //设置科室ID
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monSubClass'});
			$(ed.target).combobox('setValue', option.text);  //设置科室Desc
		}
	}
}

// 查询
function queryMonItem()
{
	var monSubClassId=$('#monSubClass').combobox('getValue');   //学科分类ID
	var monLevId=$('#MonLevel').combobox('getValue'); //监护级别ID
     if($('#monSubClass').combobox('getText')=="") //wangxuejian 2016-09-22  删除以后monSubClassId可能会返回0，判断monSubClassID将他置为空
	{
		monSubClassId=""
	}
	if( $('#MonLevel').combobox('getText')=="")
	{
		 monLevId=""
	}
	$('#dg').datagrid('load',{ monSubClassId:monSubClassId, monLevId:monLevId}); 
}