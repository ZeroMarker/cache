/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 不良反应报告流程定义

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp";
var dataArray = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];

$(function(){
	
	//定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"StatusID",title:'StatusID',width:160,editor:texteditor,hidden:true},
		{field:"Status",title:'流程',width:160,editor:{  //设置其为可编辑
			type: 'combobox',//设置编辑格式
			options: {
				valueField: "val", 
				textField: "text",
				url: url+'?action=SelAdrStatus',
				onSelect:function(option){
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'StatusID'});
					$(ed.target).val(option.val);  //设置科室ID
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'Status'});
					$(ed.target).combobox('setValue', option.text);  //设置科室Desc
				}
			}
		}},
		{field:'NextStatusID',title:'NextStatusID',width:300,editor:texteditor,hidden:true},
		{field:'NextStatus',title:'下一流程',width:160,editor:{  //设置其为可编辑
			type: 'combobox',//设置编辑格式
			options: {
				valueField: "val", 
				textField: "text",
				url: url+'?action=SelAdrStatus',
				onSelect:function(option){
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'NextStatusID'});
					$(ed.target).val(option.val);  //设置科室ID
					var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'NextStatus'});
					$(ed.target).combobox('setValue', option.text);  //设置科室Desc
				}
			}
		}},
		{field:'CombDepend',title:'依赖关系',width:120,
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto",  //设置容器高度自动增长
					onSelect:function(option){
						///设置类型值
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'CombDepend'});
						$(ed.target).combobox('setValue', option.text);  //设置科室Desc
					} 
				}
		}}
	]];
	
	//定义datagrid
	$('#dg').datagrid({
		//title:'流程定义',
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
            if ((editRow != "")||(editRow == "0")) {   //qunianpeng 2016-07-25
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
			
			
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'NextStatus'});
			var unitUrl='dhcpha.clinical.action.csp?action=SelAdrStatus';
			$(ed.target).combobox('reload',unitUrl);


        }
	});
	
	initScroll("#dg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    $('#dg').datagrid({
		url:url+'?action=QueryAdrProcess',	
		queryParams:{
			params:""}
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
		row: {ID: '',Code:'',Desc: '',Category:''}
	});
	$("#dg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#dg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdrProcess',{"params":rows[0].ID}, function(data){
					$('#dg').datagrid('reload'); //重新加载
				});
				//最后一条数据删除后，页面为空 duwensheng 2016-09-09
				if($("#dg").datagrid('getRows').length==1){
					$('#dg').datagrid('loadData',{total:0,rows:[]});
					$('#dg').datagrid('reload'); //重新加载
				}
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
	for(var i=0;i<rows.length;i++)
	{
             if((rows[i].StatusID=="")||(rows[i].NextStatusID=="")||(rows[i].CombDepend=="")){
			$.messager.alert("提示","流程或下一流程或依赖关系不能为空!"); 
			return false;
		}
		
		var tmp=rows[i].ID+"^"+rows[i].StatusID+"^"+rows[i].NextStatusID+"^"+rows[i].CombDepend;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");   
	  //wangxuejian 2016-10-10
	$.post(url+'?action=SaveAdrProcess',{"params":rowstr},function(data){

		if(data==0)
		{
	        $.messager.alert("提示","保存成功!");
		}
		if(data==1)
		{
				$.messager.alert("错误提示","数据重复,请核对!","error");
		}   
		$('#dg').datagrid('reload'); //重新加载
		});
	}
	/*//保存数据，如果数据相同，插入失败 duwensheng 2016-09-07
	var rowdata=$("#dg").datagrid('getRows'); //行数据
	var len=rowdata.length;
	var sum=0; //定义和
	for(var m=1;m<len;m++){
		var dataold=rowdata[m].Status+','+rowdata[m].NextStatus+','+rowdata[m].CombDepend; //已有数据
		var datanew=rowdata[0].Status+','+rowdata[0].NextStatus+','+rowdata[0].CombDepend; //新插数据
		if(dataold!=datanew){
			var sum=sum+1; 
		}
	}
	if(sum==(len-1)){ //不存在重复数据,提交
		$.post(url+'?action=SaveAdrProcess',{"params":rowstr},function(data){
		$('#dg').datagrid('reload'); //重新加载
		});
	}
	else{
		alert("数据重复,请核对!");
		$('#dg').datagrid('reload'); //重新加载
	}*/



var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}
