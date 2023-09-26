/**
* Creator    : wk
* CreatDate  : 2018-07-18
* Desc       : 指标系统配置执行代码配置界面
**/

var init=function(){
	
	/*--配置执行代码展示表格--*/
	var exeCodeObj = $HUI.datagrid("#exeCodeGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
			QueryName:'GetExeCodeQuery'
		},
		fitColumns:true,
		toolbar:'#exeCodeToolbar'
	})
	
	
	/*--执行代码检索--*/
	$('#searchExeCode').searchbox({
		searcher:function(value,name){
			exeCodeObj.load({ClassName:"web.DHCWL.V1.KPI.SysConfigFunction",QueryName:"GetExeCodeQuery",filterValue:value});
		}
	})
	
	$("#exeCodeAddButton").click(function(e){
		
		$.messager.confirm("提示", "自定义的执行代码将在下次更新时删除,如有需要请联系管理员添加！！",function (r) {
			if (r) {
				$("#exeCodeAddDialog").show();
				$("#myExeFormShow").form('reset');
				$HUI.dialog("#exeCodeAddDialog",{
					resizable:true,
					modal:true,
					iconCls:'icon-w-add',
					buttons:[{
						text:'保存',
						handler:function(e){
							var subType,active,desc,exeCode,creator;
							//subType = $("#subTypeCombox").val();
							subType =  $("#subTypeCombox").combobox("getValue")
							//active = $("#activeCombox").val();
							active =  $("#activeCombox").combobox("getValue")
							desc = $("#exeCodeDesc").val();
							exeCode = $("#exeCode").val();
							creator = $("#exeCodeCreator").val();
							var flag = $("#myExeFormShow").form('validate');
							if (!flag){
								myMsg("请按照提示填写内容");
								return;
							}
							//alert(subType+"^"+active+"^"+desc+"^"+exeCode+"^"+creator);
							$m({
								ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
								MethodName:'AddExeCode',
								subType:subType,
								active:active,
								desc:desc,
								exeCode:exeCode,
								creator:creator
							},function(textData){
								$HUI.dialog("#exeCodeAddDialog").close();
								$("#exeCodeGrid").datagrid('reload');
								$("#myExeFormShow").form('reset');
								myMsg(textData);
							})
						}
					},{
						text:'取消',
						handler:function(e){
							$HUI.dialog("#exeCodeAddDialog").close();
							$("#myExeFormShow").form('reset');
						}
					}]
				})
			}
		})
	})
	
}
init();