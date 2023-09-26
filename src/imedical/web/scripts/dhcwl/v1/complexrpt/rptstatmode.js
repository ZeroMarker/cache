/**
 * Creator   : wk
 * Desc      : 出入转统计模式维护
 **/


var statModeObj = $HUI.datagrid("#statModeGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		QueryName:'GetStatMode'
	},
	fitColumns:true,
	toolbar:'#statModeToobar',
	pagination:true, //允许用户通过翻页导航数据
	pageSize:15,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100], //设置分页可选展示条数
	
});

/*--统计模式新增--*/
$("#addButton").click(function(e){
	$("#addInforForm").form('reset'); 
	$("#addDialog").show();
	$HUI.dialog("#addDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				// 检验是否符合要求
				var flag = $("#addInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				
				// 获取表单数据
				var code = $("#code").val();
				var desc = $("#desc").val();
				var exeCode = $("#exeCode").val();
				var activeFlag = $("#activeFlag").combobox('getValue');
				
				//访问后台代码保存
				$m({
					ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
					MethodName:'AddMode',
					code:code,
					desc:desc,
					exeCode:exeCode,
					flag:activeFlag
				},function(e){
					myMsg(e);
					$("#statModeGrid").datagrid("reload");
					$HUI.dialog("#addDialog").close();
				})
			}
		},{
			text:'取消',
			handler:function(e){
				$HUI.dialog("#addDialog").close();
			}
		}]
	})
})
/*--统计模式修改--*/
$("#modifyButton").click(function(e){
	$("#modifyInforForm").form('reset');
	var row = $("#statModeGrid").datagrid("getSelected");  //获取选中记录
	if (!row){
		myMsg("请先选择一条需要修改的统计模式");
		return;
	}
	var ID,code,desc,exeCode,activeFlag;   //获取选中记录明细
	ID = row.ID;
	code = row.code;
	desc = row.desc;
	exeCode = row.exeCode;
	activeFlag = row.activeFlag;
	
	$("#modifyCode").val(code);   //给修改表单赋值
	$("#modifyDesc").val(desc);
	$("#modifyExeCode").val(exeCode);
	$("#modifyActiveFlag").combobox('setValue',activeFlag);
	
	$("#modifyInforForm").form('validate');  //表单验证
	$("#modifyDialog").show();
	$HUI.dialog("#modifyDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#modifyInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				code = $("#modifyCode").val();
				desc = $("#modifyDesc").val();
				exeCode = $("#modifyExeCode").val();
				activeFlag = $("#modifyActiveFlag").combobox('getValue');
				if (activeFlag == "是"){
					activeFlag = "Y";
				}else if (activeFlag == "否"){
					activeFlag = "N";
				}
				
				$m({
					ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
					MethodName:'UpdateMode',
					ID:ID,
					code:code,
					desc:desc,
					exeCode:exeCode,
					flag:activeFlag
				},function(e){
					myMsg(e);
					$("#statModeGrid").datagrid("reload");
					$HUI.dialog("#modifyDialog").close();
				})
			}
		},{
			text:'取消',
			handler:function(e){
				$HUI.dialog("#modifyDialog").close();
			}
		}]
	})
})

/*--统计模式查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		statModeObj.load({ClassName:"web.DHCWL.V1.ComplexRpt.ComplexRptFun",QueryName:"GetStatMode",filterValue:value});
	}
})