/// Creator: bianshuai
/// CreateDate:2014-06-20
/// Descript:科室审方维护JS

var editRow="";  //当前编辑行号
var url="dhcpha.clinical.action.csp"
var dataArray = [{ "value": "Y", "text": "是" }, { "value": "N", "text": "否" }]
$(function()
{
	$("#dg").datagrid({
		idField:"ID",
		url: url+"?actiontype=SelAuditPreCon",
		rownumbers:true,
		striped: true,
		pageList : [15, 30, 45],   // 可以设置每页记录条数的列表
		pageSize : 15 ,  // 每页显示的记录条数
		//fitColumns:true,
		sortName: "RowID", //初始化表格时依据的排序 字段 必须和数据库中的字段名称相同
		sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '正在加载信息...',
		columns: [[
		{	
			field:"ID",
			title:"ID",
			width:60,
			align:"center",
			hidden:true
		},{	
			field:"LocDr",
			title:"LocDr",
			width:60,
			align:"center",
			editor:'text' //,
			//hidden:true
		},{
			field:"LocDesc",
			title:"科室",
			width:200,
			align:"left",
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					required: true,//设置编辑规则属性
					valueField: "value", 
					textField: "text",
					url: url+'?actiontype=SelAllLoc&loctype=E',
					onSelect:function(option){
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'LocDr'});
						$(ed.target).val(option.value);  //设置科室ID
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'LocDesc'});
						$(ed.target).combobox('setValue', option.text);  //设置科室Desc
					}
				}
			}
		},{
			field:"ChargeFlag",
			title:"计费控制",
			width:80,
			align:"center",
			editable:true,
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					//required: true//设置编辑规则属性
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto"  //设置容器高度自动增长 
				}
			},
			formatter:function(val,rec){
				return unitformatter(val);
				}
		},{
			field:"DispenFlag",
			title:"发药控制",
			width:80,
			align:"center",
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					//required: true//设置编辑规则属性
					data:dataArray,
					valueField: "value", 
					textField: "text",
					panelHeight:"auto"  //设置容器高度自动增长 
					}
			},
			formatter:function(val,rec){
				return unitformatter(val);
				}
		},{
			field:"UserCode",
			title:"工号",
			width:100,
			align:"center",
			editor:'text'
		},{
			field:"UserName",
			title:"用户",
			width:100,
			align:"left",
			editor: {  //设置其为可编辑
				type: 'combobox',//设置编辑格式
				options: {
					required: true,//设置编辑规则属性
					valueField:"value", 
					textField: "text",
					url: url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID'],
					onSelect:function(option){
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'UserCode'});
						$(ed.target).val(option.value);  //设置用户工号
						var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'UserName'});
						$(ed.target).combobox('setValue', option.text); //设置用户姓名 
					}
				}
			}
		}]],
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})

	//科室
	$('#dept').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		  url:url+'?actiontype=SelAllLoc&loctype=E'
	}); 

	//用户
	$('#user').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?actiontype=SelUserByGrp&grpId='+session['LOGON.GROUPID'] 
	});  
	
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
		row: {ID: '',LocDr:'',LocDesc: '',ChargeFlag:'Y',DispenFlag: 'N',UserCode:"",UserName:''}
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
				$.post(url+'?actiontype=Delete',{"index":rows[0].ID}, function(data){
					$('#dg').datagrid('reload'); //重新加载
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
		if((rows[i].LocDr=="")||(rows[i].UserCode=="")){
			$.messager.alert("提示","科室或用户名不能为空!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].LocDr+"^"+rows[i].ChargeFlag+"^"+rows[i].DispenFlag;
		tmp=tmp+"^"+rows[i].UserCode;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	//保存数据
	$.post(url+'?actiontype=Update',{"datelist":rowstr},function(data){
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

// 查询
function query()
{
	var dept=$('#dept').combobox('getValue'); 
	var usercode=$('#user').combobox('getValue');
	//combobox 删除数据后为undefined
	if (dept== undefined){dept="";}
	if (usercode== undefined){usercode="";}
	var params=dept+"^"+usercode;
	$('#dg').datagrid('load',{params:params}); 
}
  
