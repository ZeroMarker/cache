﻿/**
* Creator   : wk
* CreatDate : 2018-05-18
* Desc      : 指标区间维护界面
**/



 /*--将区间属性做成链接，点击后弹出产品对应的区间属性信息--*/
 function linkDimProGrid(value,row,index){
		return "<a href='javascript:void(0)' onclick='viewSecProFun(\"" + row.ID +"\",\""+ row.name +"\")' title='查看"+row.name+"区间属性信息'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png' />"+"\
			</a>";
 }

var init = function(){
	var selectName = "";
	/*--区间表--*/
	var secObj = $HUI.datagrid("#secTable",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.SECFunction',
			QueryName:'GetSecInforQuery'
		},
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100],
		toolbar:[]
	})

	/*--区间属性表--*/
	var secProObj = $HUI.datagrid("#secProTable",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.SECFunction',
			QueryName:'GetSecProInforQuery',
			secID:''
		},
		//striped:true,
		fitColumns:true,
		pagination:true,
		toolbar:"#secProToobar"
	})


	/*--区间属性新增--*/
	$("#seccProAddButton").click(function(e){
		secProConfigDialog("add");
	})

	/*--区间属性修改--*/
	$("#secProModifyButton").click(function(e){
		secProConfigDialog("modify");
	})

	/*--区间属性删除--*/
	$("#secProDeleteButton").click(function(e){
		var row = $("#secProTable").datagrid("getSelected");
		if (!row){
			myMsg("请先选择区间属性");
			return;
		}
		var secProID = row.ID;
		$.messager.confirm("删除","删除后将不能恢复,确认删除么",function(r){
			if (r){
				$m({
					ClassName:'web.DHCWL.V1.KPI.SECFunction',
					MethodName:'DeleteSecPro',
					dimProId:secProID
				},function(textData){
					myMsg(textData);
					secProObj.reload();
				})
			}else{
				return;
			}
		})
	})

	/*--方法用于打开维度新增、修改界面--*/
	function secProConfigDialog(operType){
		$("#secProAddForm").form('reset');
		var secRow = $("#secTable").datagrid("getSelected");
		if (!secRow){
			myMsg("请先选择区间之后再操作");
			return;
		}
		var sectionID = secRow.ID;
		var secName = secRow.name;
		var ID,sectionProID,title,icon;
		ID = "",sectionProID = "",title = "",icon = "";
		if (operType == "modify"){
			title = "区间维度属性修改";
			icon = "icon-w-edit";
			var row = $("#secProTable").datagrid("getSelected");
			if (!row){
				myMsg("请先选择需要修改的区间属性再进行操作");
				return;
			}
			
			sectionProID = row.ID;
			$("#secProCode").val(row.secProCode);
			$("#secProName").val(row.secProName);
			$("#secProDesc").val(row.secProDesc);
			$("#secProExCode").val(row.secProExeCode);
			$("#secProAddForm").form('validate');
			$("#secProCode").attr("disabled",true); 
		}else{
			title = "区间维度属性新增";
			icon = "icon-w-add";
			$("#secProCode").attr("disabled",false);
			$("#secProAddForm").form('validate');
		}
		$("#secProAddDialog").show();
		$HUI.dialog("#secProAddDialog",{
			resizable:true,
			modal:true,
			title:title,
			iconCls:icon,
			buttons:[{
				text:'保存',
				handler:function(){
					var proCode,proName,proDesc,proExeCode;
					proCode = $("#secProCode").val();
					proName = $("#secProName").val();
					proDesc = $("#secProDesc").val();
					proExeCode = $("#secProExCode").val();
					var isValid = $("#secProAddForm").form('validate');   //检查表单信息是否符合要求
					if (!isValid){
						myMsg("请按照提示填写内容");
						return;
					}
					//alert(proCode+"^"+proName+"^"+proDesc+"^"+proExeCode+"^"+proActFlag+"^"+dimProDeli);
					//return;
					$m({                                             //将信息保存到后台
						ClassName:'web.DHCWL.V1.KPI.SECFunction',
						MethodName:'updateSecPro',
						proID:sectionProID,
						sectionID:sectionID,
						proCode:proCode,
						proName:proName,
						proDesc:proDesc,
						proExeCode:proExeCode
					},function(txtData){
						myMsg(txtData);		  //弹框显示返回信息
						secProObj.reload();      //刷新当前页
						$HUI.dialog("#secProAddDialog").close();  //关闭弹窗
					});
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog("#secProAddDialog").close();
				}
			}]
		})
	}
	
	/*--调用该方法打开维度属性弹出框--*/
	this.viewSecProFun=function(value,name) {
		//alert(name);
		//return;
		var title = "区间维度属性---" + name;
		secProObj.load({ClassName:"web.DHCWL.V1.KPI.SECFunction",QueryName:"GetSecProInforQuery",secID:value}); 
		$("#secProDlg").show();
		var dimProDlgObj = $HUI.dialog("#secProDlg",{
			iconCls:'icon-w-list',
			resizable:true,
			title:title,
			modal:true
		});
	}
};
init();