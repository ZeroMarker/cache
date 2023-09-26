/*--过滤函数表格--*/
var filterObj = $HUI.datagrid("#filterFunGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
		QueryName:'GetFilterFunQuery'
	},
	fitColumns:true,
	toolbar:'#filterFunToolbar'
})

/*--过滤函数点击新增按钮--*/
$("#filterFunAddButton").click(function(e){
	$.messager.confirm("提示", "自定义的过滤函数将在下次更新时删除,如有需要请联系管理员添加！！",function (r) {
		if (r) {
			$("#filterAddDialog").show();
			$("#myFilterFormShow").form('reset');
			$HUI.dialog("#filterAddDialog",{
				iconCls:'icon-w-add',
				resizable:true,
				modal:true,
				buttons:[{
					text:'保存',
					handler:function(){
						var name,exeCode,desc,type;
						name = $("#filterFormName").val();
						exeCode = $("#filterExeCode").val();
						desc = $("#filterDesc").val();
						//type = $("#filterFormType").val();
						type =  $("#filterFormType").combobox("getValue")
						var flag = $("#myFilterFormShow").form('validate');
						if (!flag){
							myMsg("请按照提示填写内容");
							return;
						}
						//alert(name+"^"+exeCode+"^"+desc+"^"+type);
						$m({
							ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
							MethodName:'AddFilterFun',
							code:name,
							funcPrototype:type,
							execCode:exeCode,
							funcDesc:desc
						},function(textData){
							$HUI.dialog("#filterAddDialog").close();
							$("#filterFunGrid").datagrid('reload');
							$("#myFilterFormShow").form('reset');
							myMsg(textData);
						})
					}
				},{
					text:'取消',
					handler:function(){
						$HUI.dialog("#filterAddDialog").close();
						$("#myFilterFormShow").form('reset');
					}
				}]
			});
		} else {
		}
	});
})

/*--过滤函数查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		filterObj.load({ClassName:"web.DHCWL.V1.KPI.SysConfigFunction",QueryName:"GetFilterFunQuery",filterValue:value});
	}
})

/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
 }


/*--调整整个系统配置界面--*/
 $(window).resize(function () {  
	 $('#tt4').tabs({  
		 width: $("#tt4").parent().width(),  
		 height: $("#tt4").parent().height()  
	 });  
 })  
 $(function() {  
	 $('#tt4').tabs({  
		 width: $("#tt4").parent().width(),   
　　     height: $("#tt4").parent().height()  
		});  
 }); 
 
 

 
