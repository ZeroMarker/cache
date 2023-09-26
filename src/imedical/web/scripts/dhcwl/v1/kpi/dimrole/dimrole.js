/**
* Creator    :  wk
* CreatDate  :  2018-05-12
* Desc       :  维度角色展示界面
**/﻿
var ADD_KEY = 0;
var DELETE_KEY = 0;

var kpiBodyHeight = getViewportOffset().y;

var dimObj = $HUI.datagrid("#dimTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.DIMFunction',
		QueryName:'GetDimInforQuery'	
	},
	fitColumns:true,
	pagination:true,
	pageSize:15,
	pageList:[10,15,20,25,50,100,500],
	toolbar:'#dimToobar',
	onClickRow:function(rowIndex,rowData){
		var dimID = rowData.ID;
		dimRoleObj.load({ClassName:'web.DHCWL.V1.KPI.DIMFunction',QueryName:'GetDimRoleInforQuery',dimID:dimID});
	}
})

var dimRoleObj = $HUI.datagrid("#dimRoleTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.DIMFunction',
		QueryName:'GetDimRoleInforQuery',
		dimID:''
	},
	striped:true,
	pagination:true,
	pageSize:15,
	pageList:[15,20,25,50,100,500],
	toolbar:'#dimRoleToobar'
})

/*--鼠标悬停维度描述单元格响应方法--*/
function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}

/*--点击帮助按钮--*/
$("#dimHelpButton").click(function(e){
	var content='<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="../scripts/dhcwl/v1/kpi/dimrole/help/维度角色管理.htm"></iframe>'
	$("#helpDialog").show();
	$HUI.dialog("#helpDialog",{
		iconCls:'icon-w-paper',
		height:kpiBodyHeight-50,
		content:content,
		resizable:true,
		modal:true
	})
})

/*--点击新增按钮--*/
$("#dimRoleAddButton").click(function(e){
	if (ADD_KEY == 0){
		var passWord = getPassWord();
		$.messager.prompt("提示", "输入密码:", function (r) {
			if (r) {
				
				if (r == passWord){
					$.messager.popover({msg: '验证成功,请再次操作~',type:'success',timeout: 1000});
					ADD_KEY = 1;
				}else{
					myMsg("密码输入有误呦~");
					return;
				}
			} else {
				if (r != undefined){
					$.messager.popover({msg: '请输入有效密码！',type:'info',timeout: 2000,showType: 'show'});
				}
			}
		});
	}else{
		dimRoleConfig("add");
	}
})

/*--点击修改按钮--*/
$("#dimRoleModifyButton").click(function(e){
	if (ADD_KEY == 0){
		var passWord = getPassWord();
		$.messager.prompt("提示", "输入密码:", function (r) {
			if (r) {
				
				if (r == passWord){
					$.messager.popover({msg: '验证成功,请再次操作~',type:'success',timeout: 1000});
					ADD_KEY = 1;
				}else{
					myMsg("密码输入有误呦~");
					return;
				}
			} else {
				if (r != undefined){
					$.messager.popover({msg: '请输入有效密码！',type:'info',timeout: 2000,showType: 'show'});
				}
			}
		});
	}else{
		dimRoleConfig("modify");
	}
})

/*--点击删除按钮--*/
$("#dimRoleDeleteButton").click(function(e){
	if(DELETE_KEY == 0){
		var passWord = getPassWord() + 10;
		$.messager.prompt("提示", "为保障系统安全,请先输入密码验证:", function (r) {
			if (r) {
				
				if (r == passWord){
					$.messager.popover({msg: '验证成功,请再次操作~',type:'success',timeout: 1000});
					DELETE_KEY = 1;
				}else{
					myMsg("密码输入有误~");
					return;
				}
			} else {
				if (r != undefined){
					$.messager.popover({msg: '请输入有效密码！',type:'info',timeout: 2000,showType: 'show'});
				}
			}
		});
	}else{
		var dimRoleRow = $("#dimRoleTable").datagrid("getSelected");
		if(!dimRoleRow){
			myMsg("请先选择需要删除的角色");
			return;
		}
		var dimRoleID = dimRoleRow.ID;
		$.messager.confirm("删除", "确定删除么", function (r) {
			if (r) {
				$m({
					ClassName:'web.DHCWL.V1.KPI.DIMFunction',
					MethodName:'DeleteDimRole',
					dimRoleID:dimRoleID
				},function(txtData){
					dimRoleObj.reload();
					myMsg(txtData);
				});
			} else {
				return;
			}
		});
	}
})


/*--维度查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		dimObj.load({ClassName:"web.DHCWL.V1.KPI.DIMFunction",QueryName:"GetDimInforQuery",filterValue:value});
	}
})

function dimRoleConfig(operType)
{
	var dimRow,dimID;
	$("#dimRoleAddForm").form("reset");   //清空表单信息
	dimRow = $("#dimTable").datagrid("getSelected");   //判断是否选中了维度
	if (!dimRow){
		myMsg("请先选择对应的维度才能进行操作喲~");
		return;
	}
	dimID = dimRow.ID;   //获取选中维度ID
	var title = "";
	if (operType == "modify"){                                    //如果是修改给表单赋值
		//$("#dimRoleAddDialog").dialog({title:'维度角色修改'});    //修改dialog标题
		var roleCode,roleName,roleDesc,roleCreator;
		dimRoleRow = $("#dimRoleTable").datagrid("getSelected");  //判断是否选中了维度角色
		if (!dimRoleRow){
			myMsg("请先选择需要修改的维度角色");
			return;
		}
		$("#dimRoleCode").val(dimRoleRow.dimRoleCode);
		$("#dimRoleName").val(dimRoleRow.dimRoleName);
		$("#dimRoleDesc").val(dimRoleRow.dimRoleDesc);
		$("#dimRoleCreator").val(dimRoleRow.dimRoleCreator);
		$("#dimRoleAddForm").form("validate");   //表单内容合法性检查
		$("#dimRoleCode").attr("disabled",true);
		title="维度角色修改";
		dimIcon = "icon-w-edit";
	}else{
		$("#dimRoleCode").attr("disabled",false);
		title="维度角色新增";
		dimIcon = "icon-w-add";
	}
	$("#dimRoleAddDialog").show();
	//$("#dimRoleAddDialog").dialog('seTitle','维度角色新增');   //修改dialog标题
	$HUI.dialog("#dimRoleAddDialog",{
		iconCls:dimIcon,
		resizable:true,
		modal:true,
		title:title,
		buttons:[{
			text:'保存',
			handler:function(){
				var code,name,desc,creator,flag;
				if (!dimID){
					myMsg("获取维度信息失败");
					return;
				}
				code = $("#dimRoleCode").val();
				name = $("#dimRoleName").val();
				desc = $("#dimRoleDesc").val();
				creator = $("#dimRoleCreator").val();
				flag = $("#dimRoleAddForm").form("validate");   //表单内容合法性检查
				if (!flag){
					myMsg("请按照提示填写信息");
					return;
				}
				$m({
					ClassName:'web.DHCWL.V1.KPI.DIMFunction',
					MethodName:'AddDimRole',
					code:code,
					creator:creator,
					name:name,
					desc:desc, 
					dimID:dimID,
					operType:operType
				},function(txtData){
					myMsg(txtData);
					dimRoleObj.reload();
					$HUI.dialog("#dimRoleAddDialog").close();  //关闭表单弹框
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$("#dimRoleAddForm").form("reset");   //清空表单信息
				$HUI.dialog("#dimRoleAddDialog").close();  //关闭表单弹框
			}
		}]
	})
}