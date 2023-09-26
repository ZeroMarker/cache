/// Creator: bianshuai
/// CreateDate: 2015-04-23
//  Descript: 药学监护级别维护

var editRow="";editparamRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[双击行即可编辑]</span>';
var dataArray = [{"value":"G","text":'安全组'}, {"value":"L","text":'科室'}, {"value":"U","text":'人员'}]; //, {"value":"D","text":'全院'}
var monSubClassID = "";
var LgHospID=session['LOGON.HOSPID']
$(function(){
	
	// 定义columns
	var columns=[[
		{field:"monSubClassID",title:'ID',width:90,align:'center',hidden:true},
		{field:"monSubClassCode",title:'代码',width:160,editor:texteditor},
		{field:'monSubClassDesc',title:'学科分类',width:300,editor:texteditor}
	]];
	// 定义datagrid
	$('#discatdg').datagrid({
		title:'学科分类'+titleNotes,
		url:url+'?action=QueryMonSubClass',
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
                $("#discatdg").datagrid('endEdit', editRow); 
            } 
            $("#discatdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        if ((editRow != "")||(editRow == "0")) { 			//当单击某行，关闭之前的打开编辑行  qunianpeng 2016-09-22s
              	  $("#discatdg").datagrid('endEdit', editRow); 
                } 
	    	monSubClassID=rowData.monSubClassID;    ///状态ID
	    	$('#locdg').datagrid('loadData',{total:0,rows:[]});
			$('#locdg').datagrid({
				url:'dhcpha.clinical.action.csp?action=QueryMonSubClassItm',	
				queryParams:{
					monSubClassID:monSubClassID,
					hospID:LgHospID
				}
			});
	    }
	});
	
	initScroll("#discatdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    $('#discatdg').datagrid({
		url:url+'?action=QueryMonSubClass',	
		queryParams:{
			params:''}
	});
	
	InitMonSubClassItm();
})

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#discatdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#discatdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {monSubClassID: '',monSubClassCode:'',monSubClassDesc: ''}
	});
	$("#discatdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	/*$.messager.alert('提示','<font style="color:red;font-weight:bold;">如需进行删除操作,请联系信息科！谢谢！</font>','warning');
	return;*/
	
	var rows = $("#discatdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMonSubClass',{"params":rows[0].monSubClassID}, function(data){
					$('#discatdg').datagrid('reload'); //重新加载
					$('#locdg').datagrid('reload'); //重新加载
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
		$("#discatdg").datagrid('endEdit', editRow);
	}

	var rows = $("#discatdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].monSubClassCode=="")||(rows[i].monSubClassDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			$('#discatdg').datagrid('reload'); //重新加载
			return false;
		}
		var tmp=rows[i].monSubClassID+"^"+rows[i].monSubClassCode+"^"+rows[i].monSubClassDesc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveMonSubClass',{"params":rowstr},function(data){
		if(data==1){
		$.messager.alert("提示","该学科分类已经存在!");
		}
		else{
	    $.messager.alert("提示","保存成功!");
		}
		$('#discatdg').datagrid('reload'); //重新加载
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
var monLocEditor={
	type: 'combobox',//设置编辑格式
	options: {
		//required: true,//设置编辑规则属性
		valueField: "value", 
		textField: "text",
		mode:'remote',	
		url: url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'',	//qunianpeng 2017/8/14 支持拼音码和汉字
		onSelect:function(option){
			var ed=$("#locdg").datagrid('getEditor',{index:editparamRow,field:'monLocID'});
			$(ed.target).val(option.value);  //设置科室ID
			var ed=$("#locdg").datagrid('getEditor',{index:editparamRow,field:'monLocDesc'});
			$(ed.target).combobox('setValue', option.text);  //设置科室Desc
		}
	}
}
/// =====================================初始化学科分类=============================
function InitMonSubClassItm()
{	
	// 定义columns
	var columns=[[
		{field:"monSubClassItmID",title:'monSubClassItmID',width:100,align:'center',hidden:true},
		{field:'monLocID',title:'科室id',width:110,editor:'text'},
		{field:"monLocDesc",title:'科室',width:320,
			editor: monLocEditor
		}
	]];
	
	// 定义datagrid
	$('#locdg').datagrid({
		title:'关联科室',
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
	    	if ((editparamRow != "")||(editparamRow == "0")) {  //qunianpeng  2016-08-09
               		 $("#locdg").datagrid('endEdit', editparamRow); 
           	 } 
           	 $("#locdg").datagrid('beginEdit', rowIndex); 
           	 editparamRow = rowIndex; 
           	 var ed=$("#locdg").datagrid('getEditor',{index:editparamRow,field:'monLocID'}); //设置ID列不可编辑 qunianpeng 2016-09-22
		$(ed.target).attr("disabled",true);
            }
	});
	
	initScroll("#locdg");//初始化显示横向滚动条
	$('#locdg').datagrid('loadData',{total:0,rows:[]});
	//按钮绑定事件
    $('#insparam').bind('click',insparamRow); 
    $('#delparam').bind('click',delparamRow);
    $('#savparam').bind('click',savparamRow);
    
}

// 插入新行
function insparamRow()
{
	if(editparamRow>="0"){
		$("#locdg").datagrid('endEdit', editparamRow);//结束编辑，传入之前编辑的行
	}
	$("#locdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {monSubClassItmID: '',monLocDesc:'',monLocID: ''}
	});
	$("#locdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editparamRow=0;
}

// 删除选中行
function delparamRow()
{
	var rows = $("#locdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMonSubClassItm',{"params":rows[0].monSubClassItmID}, function(data){
					$('#locdg').datagrid('reload'); //重新加载
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
		$("#locdg").datagrid('endEdit', editparamRow);
	}

	var rows = $("#locdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];

	var subClassRows=$("#discatdg").datagrid('getSelections'); //qunianpeng 2016-08-09
	if(subClassRows.length<=0){
		$.messager.alert("提示","请选择学科分类!");
		return;
	}
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].monLocID == "")||(rows[i].monLocDesc == undefined)){  // qunianpeng  2016-08-09
			$.messager.alert("提示","代码或描述不能为空!"); 
			$('#locdg').datagrid('reload'); 
			return false;
		}
		var tmp=rows[i].monSubClassItmID+"^"+monSubClassID+"^"+rows[i].monLocID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("%");
	if(rowstr==""){
		$('#locdg').datagrid('reload'); //重新加载
	}
	//保存数据
	$.post('dhcpha.clinical.action.csp?action=SaveMonSubClassItm',{"params":rowstr},function(data){
		if(data==1){
			 $.messager.alert("提示","该关联科室已经存在!");
		}	
		$('#locdg').datagrid('reload'); //重新加载
		
	});
}
