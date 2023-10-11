
//入口函数
$(function(){
	setPageLayout(); //设置页面布局
	setElementEvent(); //设置元素事件
});
//设置页面布局
function setPageLayout(){
	initDicDataTypeCombo(); //初始化字典类型下拉框
	initDicDataGridItem();  //初始化字典明细列表
}
//设置元素事件
function setElementEvent(){
	initSaveBtnEvent(); //初始化保存按钮事件
	initDeleteBtnEvent(); //初始化删除按钮事件
	initClearBtnEvent(); //初始化清空按钮事件
	initImportBtnEvent(); //初始化导入按钮事件
}
//初始化字典明细列表
function initDicDataGridItem(){
	$('#DicList').datagrid({
		pagination:true, // 分页工具栏
		pageSize:5,
    	pageList:[5, 15, 20], 
		singleSelect:true,
		striped:true, // 显示斑马线效果
		height: 600,
		rownumbers:true,
		fit:true,
		url:$URL,
		queryParams:{
			ClassName:"BILL.EINV.BL.COM.DicDataCtl",
			QueryName:"QueryDicDataInfo",
			Type:'SYS'
		},
		columns:[[
			{field:'ID',title:'ID',hidden:true},
			{field:'DicType',title:'字典类型',width:150},
			{field:'DicCode',title:'字典编码',width:150},
			{field:'DicDesc',title:'字典描述',width:150},
			{field:'DicBill1',title:'字典对照信息1',width:100},
			{field:'DicBill2',title:'字典对照信息2',width:100},
			{field:'DicDemo',title:'备注',width:100},
			{field:'XStr1',title:'备用1',width:100},
			{field:'XStr2',title:'备用2',width:100},
			{field:'XStr3',title:'备用3',width:100},
			{field:'XStr4',title:'备用4',width:100},
			{field:'XStr5',title:'备用5',width:100}
			
		]],
		onClickRow:function(rowIndex, rowData){
			var row = $('#DicList').datagrid('getSelected');
			if(row != null){
				SetInputInfo(row); //将选中的那条记录数据显示到页面上	
			}
		}
	});
}
//初始化字典类型下拉框
function initDicDataTypeCombo(){
	$HUI.combobox("#DicType",{
		valueField:'DicCode',
		textField:'DicDesc',
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="BILL.EINV.BL.COM.DicDataCtl";
			param.QueryName='QueryDetComboxInfo';
			param.ResultSetType='Array';
			$("#DicType").combobox('setValue',"SYS");
		},
		onSelect:function(){
			ReloadDicDataGridItem(); //重新加载字典列表信息
			ClearInputInfo();	//清空输入框
		}
	});
}
//初始化保存按钮事件
function initSaveBtnEvent(){
	$('#UpdateBtn').click(function(){    
        SaveDicDataInfo(); //保存字典信息
    });
} 
//保存字典信息
function SaveDicDataInfo(){
	var DicType = $('#DicType').combobox('getValue') //字典类型
	var DicCode = $('#DicCode').val();		//字典编码
	if($.trim(DicCode) == ""){
		$.messager.alert('提示信息',"字典编码不能为空！");
		return;
	}
	var DicDesc = $('#DicDesc').val();		//字典描述
	var DicBill1 = $('#DicBill1').val();	//对照代码
	var DicBill2 = $('#DicBill2').val();	//对照描述
	var DicDemo = $('#DicDemo').val();		//备注
	var XStr1 = $('#XStr1').val();			//备注1
	var XStr2 = $('#XStr2').val();			//备注2
	var XStr3 = $('#XStr3').val();			//备注3
	var XStr4 = $('#XStr4').val();			//备注4
	var XStr5 = $('#XStr5').val();			//备注5
	var DataStr = DicType+"^"+DicCode+"^"+DicDesc+"^"+DicBill1+"^"+DicBill2+"^"+DicDemo+"^"+XStr1+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5+"^"+UserID;
	
	var row = $('#DicList').datagrid('getSelected');
	if(row == null){
		var MethodName="SaveDicdataInfo";
		Save(DataStr,MethodName);
	}else{
		DataStr = row.ID+"^"+DataStr;
		var MethodName="UpdateDicDataInfo";
		Save(DataStr,MethodName); //调用后台保存方法
	}
}

//调用后台保存方法
function Save(DataStr,MethodName){
	$m({
		ClassName:"BILL.EINV.BL.COM.DicDataCtl",
		MethodName:MethodName,
		DataStr:DataStr
	},function(value){
		if(value.length != 0){
			$.messager.alert('消息',value);
			ClearInputInfo(); //清除页面输入框信息
			ReloadDicDataGridItem(); //重新加载字典列表信息
		}else{
			$.messager.alert('消息','服务器错误')
		}
	});
}
//初始化删除按钮事件
function initDeleteBtnEvent(){
	$('#DeleteBtn').click(function(){    
        DeleteDicDataInfo();  //删除字典信息 
    });
}
//删除字典信息
function DeleteDicDataInfo(){
	var row = $('#DicList').datagrid('getSelected');
	if(row == null){
		$.messager.alert('提示信息','请选择需要删除的行');
		return;
	}
	$.messager.confirm('对话框','您确定要删除该条记录吗?',function(r){
		if(r){
			var ID = selectedRow.ID;
			$m({
				ClassName:"BILL.EINV.BL.COM.DicDataCtl",
				MethodName:"DeleteDicDataInfo",
				ID:ID
			},function(value){
				if(value.length != 0){
					$.messager.alert('消息',value);
					ClearInputInfo(); //清除页面输入框信息
					ReloadDicDataGridItem(); //重新加载字典列表信息
				}else{
					$.messager.alert('消息','服务器错误')
				}
			});
		}
	});
} 
//初始化清空按钮事件
function initClearBtnEvent(){
	$('#clearBtn').click(function(){
		ClearInputInfo();	//清空页面输入框信息
	});
}
//初始化导入字典信息按钮事件
function initImportBtnEvent(){
	$('#ImportBtn').click(function(){
		var UserDr=UserID;
		var GlobalDataFlg="0";                          //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
		var ClassName="BILL.EINV.BL.COM.DicDataCtl";    //导入处理类名
		var MethodName="ImportDicdataByExcel";         	//导入处理方法名
		var ExtStrPam="";                   			//备用参数()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
} 
//重新加载字典列表信息
function ReloadDicDataGridItem(){
	var DicType = $('#DicType').combobox('getValue');
	$('#DicList').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.DicDataCtl",
		QueryName:"QueryDicDataInfo",
		Type:DicType
	});
}
//将选中的那条记录数据显示到页面上
function SetInputInfo(row){
	$("#DicType").combobox('setValue',row.DicType); //设置字典类型
	$('#DicCode').val(row.DicCode);		//字典编码
	$('#DicDesc').val(row.DicDesc);		//字典描述
	$('#DicBill1').val(row.DicBill1);		//对照代码
	$('#DicBill2').val(row.DicBill2);		//对照描述
	$('#DicDemo').val(row.DicDemo);		//备注
	$('#XStr1').val(row.XStr1);		//备注1
	$('#XStr2').val(row.XStr2);		//备注2
	$('#XStr3').val(row.XStr3);		//备注3
	$('#XStr4').val(row.XStr4);		//备注4
	$('#XStr5').val(row.XStr4);		//备注5
}
// 清空输入框
function ClearInputInfo(){
	$('#DicList').datagrid('clearSelections'); //清除选中行
	$('#DicCode').val("");		//字典编码
	$('#DicDesc').val("");		//字典描述
	$('#DicBill1').val("");		//对照代码
	$('#DicBill2').val("");		//对照描述
	$('#DicDemo').val("");		//备注
	$('#XStr1').val("");		//备注1
	$('#XStr2').val("");		//备注2
	$('#XStr3').val("");		//备注3
	$('#XStr4').val("");		//备注4
	$('#XStr5').val("");		//备注5
}