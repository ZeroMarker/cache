﻿/**
*  Creator   : wk
*  CreatDate : 2018-05-22
*  Desc      : 指标类型维护界面 
**/

/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
    return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}


var init = function(){
	/*--指标类型表格--*/
	var typeObj = $HUI.datagrid("#kpiTypeGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.MKPIFLFunction',
			QueryName:'GetMKPIFLQuery'
		},
		pagination:true,
		pageSize:20,
		pageList:[10,15,20,50,100],
		toolbar:'#FLToobar',
		fitColumns:true
	})
	
	/*--指标类型新增--*/
	$("#FLAddButton").click(function(e){
		mFLConfigDialog("add");
	})
	
	/*--指标类型修改--*/
	$("#FLModifyButton").click(function(e){
		mFLConfigDialog("modify");
	})
	
	/*--指标类型删除--*/
	$("#FLDeleteButton").click(function(e){
		var flRow = $("#kpiTypeGrid").datagrid("getSelected");
		if(!flRow){
			myMsg("请先选择需要删除的指标类型");
			return;
		}
		var flRowCode = flRow.typeCode;
		$.messager.confirm("删除", "删除后将不能恢复,确定删除么", function (r) {
			if (r) {
				$m({
					ClassName:'web.DHCWL.V1.KPI.MKPIFLFunction',
					MethodName:'DeleteKpifl',
					flCode:flRowCode
				},function(txtData){
					typeObj.reload();
					myMsg(txtData);
				});
			} else {
				return;
			}
		});
	})
	
	
	/*--指标类型查询--*/
	$('#searchText').searchbox({
		searcher:function(value,name){
			typeObj.load({ClassName:"web.DHCWL.V1.KPI.MKPIFLFunction",QueryName:"GetMKPIFLQuery",filterValue:value});
		}
	})
	
	
	/*--指标类型新增与修改调用方法--*/
	function mFLConfigDialog(operType){
		$("#FLAddInforForm").form('reset');
		var typeID = "";
		if (operType == "modify"){
			var row = $("#kpiTypeGrid").datagrid("getSelected");
			if (!row){
				myMsg("请先选择一条记录再操作");
				return;
			}
			
			typeID = row.ID;
			$("#typeCode").val(row.typeCode);
			$("#typeName").val(row.typeName);
			$("#typeDesc").val(row.typeDesc);
			$("#typeCreator").val(row.typeCreator);
			$("#remark").val(row.typeRemark);
			$("#FLAddInforForm").form('validate');
			$("#typeCode").attr("disabled",true);
			title = "指标类型修改";
			typeIcon = "icon-w-edit";
		}else{
			$("#typeCode").attr("disabled",false);
			$("#FLAddInforForm").form('validate');
			typeIcon = "icon-w-add";
			title = "指标类型新增";
		}
		$("#FLAddDialog").show();
		$HUI.dialog("#FLAddDialog",{
			title:title,
			iconCls:typeIcon,
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var typeCode,typeName,typeDesc,typeExeCode,typeRemark;
					typeCode = $("#typeCode").val();
					typeName = $("#typeName").val();
					typeDesc = $("#typeDesc").val();
					typeCreator = $("#typeCreator").val();
					typeRemark = $("#remark").val();
					var isValid = $("#FLAddInforForm").form('validate');   //检查表单信息是否符合要求
					if (!isValid){
						myMsg("请按照提示填写内容");
						return;
					}
					//alert(proCode+"^"+proName+"^"+proDesc+"^"+proExeCode+"^"+proActFlag+"^"+dimProDeli);
					//return;
					$m({                                             //将信息保存到后台
						ClassName:'web.DHCWL.V1.KPI.MKPIFLFunction',
						MethodName:'updateKPIFL',
						ID:typeID,
						typeCode:typeCode,
						typeName:typeName,
						typeDesc:typeDesc,
						typeCreator:typeCreator,
						remark:typeRemark
					},function(txtData){
						myMsg(txtData);		  //弹框显示返回信息
						typeObj.reload();      //刷新当前页
						$HUI.dialog("#FLAddDialog").close();  //关闭弹窗
					});
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog("#FLAddDialog").close();
				}
			}]
		})
	}

}
init();