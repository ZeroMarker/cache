//名称	dhcpe.ct.conclusion.js
//功能	系统配置 - 职业病体检 - 职业病结论分类
//创建	2021-08-04
//创建人  zhongricheng

$(function(){
	InitConclusionDataGrid();
	
	//修改
	$("#BUpdate").click(function() {
		BUpdate_click();	
	});
	
	//新增
	$("#BAdd").click(function() {
		BAdd_click();
	});
	
	//删除
	$("#BDelete").click(function() {
		BDelete_click();
	});
	
	//清屏
	$("#BClear").click(function() {
		BClear_click();
	});
});

// 修改
function BUpdate_click() {
	BSave_click("1");
}

// 新增
function BAdd_click() {
	BSave_click("0");
}

// 更新
function BSave_click(Type) {
	if (Type == "1") {
		var ID = $("#ID").val();
		if(ID == "") {
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if (Type == "0") {
		if($("#ID").val() != "") {
			$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
			return false;
		}
		var ID = "";
	}
	
	var Code = $("#Code").val();
	if ("" == Code) {
		$("#Code").focus();
		$HUI.validatebox("#Code", {required: true});
		$.messager.alert("提示", "编码不能为空", "info");
		return false;
	}
	var Desc = $("#Desc").val();
	if ("" == Desc) {
		$("#Desc").focus();
		$HUI.validatebox("#Desc", {required: true});
		$.messager.alert("提示","结论分类不能为空","info");
		return false;
	}
	
	var ExpInfo = $("#ExpInfo").val();
	var Remark = $("#Remark").val();
	var Severity = $("#Severity").numberbox('getValue');
	
	var ID = $("#ID").val();
	var check = $("#Active").checkbox('getValue');
	var Active = check?"Y":"N";
	
	var Str = Code+"^"+Desc+"^"+Active+"^"+""+"^"+ExpInfo+"^"+Severity+"^"+Remark;
	
	$.cm({
		ClassName:"web.DHCPE.CT.Conclusion",
		MethodName:"UpdateConclusion",
		ID:ID,
		InfoStr:Str,
		CTLOCID:session["LOGON.CTLOCID"],
		USERID:session["LOGON.USERID"]
	}, function(jsonData){
		if (jsonData.code == "-1") {
			$.messager.alert("提示", jsonData.msg, "error");
		} else {
			if (Type=="1") $.messager.alert("提示", "修改成功", "success");
			if (Type=="0") $.messager.alert("提示", "新增成功", "success");
			BClear_click();
		}
	});
}

//删除
function BDelete_click() {
	var RowId = $("#ID").val();
	if (RowId == "") {
		$.messager.alert("提示","请先选择待删除的记录","info");	
		return false;
	}
	
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			$.cm({
				ClassName:"web.DHCPE.CT.Conclusion",
				MethodName:"DeleteConclusion",
				ID:RowId
			}, function(jsonData){
				if (jsonData.code == "-1") {
					$.messager.alert("提示", "删除失败:" + jsonData.msg, "error");  
				} else {
					$.messager.alert("提示", "删除成功", "success");
					BClear_click();
				}
			});	
		}
	});
}

//清屏
function BClear_click() {
	$("#ID, #Code, #Desc, #ExpInfo, #Remark").val("");
	$("#Severity").numberbox('setValue','');
	$(".hisui-checkbox").checkbox('setValue',false);
	$HUI.validatebox("#Code,#Desc", {required: false,});
	
	$("#ConclusionQueryTab").datagrid('load',{
		ClassName:"web.DHCPE.CT.Conclusion",
		QueryName:"FindConclusion"
	});
}

function InitConclusionDataGrid() {
	$HUI.datagrid("#ConclusionQueryTab",{
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.Conclusion",
			QueryName:"FindConclusion",
		},
		columns:[[
		    {field:'TRowId',title:'TRowId',hidden: true},
			{field:'TCode',width:'120',title:'代码'},
			{field:'TDesc',width:'200',title:'结论分类'},
			{field:'TSeverity',width:'80',title:'严重程度',align:'center'},
			{field:'TActive',width:'60',title:'激活',align:'center', formatter:function(val, row, ind){
					return val=="Y"?"是":"否"
				}
			},
			{field:'TExpInfo',width:'300',title:'扩展信息'},
			{field:'TRemark',width:'500',title:'备注'}
		]],
		onSelect:function(rowIndex, rowData) {
			$("#ID").val(rowData.TRowId);
			$("#Code").val(rowData.TCode);
			$("#Desc").val(rowData.TDesc);
			$("#Severity").numberbox('setValue',rowData.TSeverity);
			$("#ExpInfo").val(rowData.TExpInfo);
			$("#Remark").val(rowData.TRemark);
			
			var check = rowData.TActive=="Y"?true:false;
			$("#Active").checkbox('setValue',check);
		}
	});
}