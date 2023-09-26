/// Creator: lbb
/// CreateDate:2020-02-24
/// Descript:咨询身份维护JS

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp"
var dataArray = [{ "value": "Y", "text": "是" }, { "value": "N", "text": "否" }]
$(function()
{
	$("#dg").datagrid({
		idField:"rowid",
		url: url+"?action=GetPhConIdenInfo",  
		rownumbers:true,
		striped: true,
		pageList : [15, 30, 45],   // 可以设置每页记录条数的列表
		pageSize : 15 ,  // 每页显示的记录条数
		//fitColumns:true,
		//sortName: "rowid", //初始化表格时依据的排序 字段 必须和数据库中的字段名称相同
		//sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '正在加载信息...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50
			//hidden:true
		},{	
			field:"PhContCode",
			title:"代码",
			width:200,
			editor:'text'
		},
		{
			field:"PhContDesc",
			title:"描述",
			width:300,
			editor:'text'
		}]],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//设置分页控件   
	$('#dg').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '第',//页数文本框前显示的汉字 
		afterPageText: '页    共 {pages} 页',   
		displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录'
	});
})

// 格式化
function unitformatter(value, rowData, rowIndex){
    for (var i = 0; i < dataArray.length; i++){ 
        if (dataArray[i].value == value){ 
			if(value=="Y"){color="green";
			}else{
				color="red";}
			return '<span style="font-weight:bold;color:'+color+'">'+dataArray[i].text+'</span>';
        } 
    } 
}

// 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#dg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#dg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {rowid: '',PhContCode:'',PhContDesc: ''}
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
				$.post(url+'?action=DeletePhConIden',{"index":rows[0].rowid}, function(data){
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
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].PhContCode=="")||(rows[i].PhContDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			//$('#dg').datagrid('reload');
			return false;
		}
		//GetPhConBasInfo
		//下面方法获取所有行   hzg 2018-7-23
		var datas="";
		$.ajax({
			url:url+"?action=GetPhConIdenInfo",
			//页数1，行数是datagrid的总行数，其他参数和需要获取行对象的datagrid是一样的
			data: {
				page: "1",rows: '100'
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
			if((rows[i].PhContCode==allRows[j].PhContCode)&&(rows[i].PhContDesc==allRows[j].PhContDesc)){
				$.messager.alert("提示","模板已存在，请重新维护!");
							//$('#dg').datagrid('reload');
							return true;
				}
				
					}

		var tmp=rows[i].rowid+"^"+rows[i].PhContCode+"^"+rows[i].PhContDesc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	
	//保存数据
	$.post(url+'?action=UpdatePhConIden',{"dataList":rowstr},function(data){
		$.messager.alert("提示","保存成功!"); //**修改增加保存成功提示
		$('#dg').datagrid('reload'); //重新加载
	});
}


// 修改选中行
function modifyRow()
{
	var rows = $("#dg").datagrid('getSelections'); //选中一行进行编辑
	//选中一行的话触发事件
	if (rows.length == 1)
	{
		if(editRow!=""){
			$("#dg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
		}
		var index = $("#dg").datagrid('getRowIndex', rows[0]);//获取选定行的索引
		$("#dg").datagrid('beginEdit',index);
		editRow=index;  //记录当前编辑行
	}else{
		$.messager.alert("提示","请选中需编辑行!");
	}
}


  
