//页面Event
function InitWinEvent(obj){
	obj.RecRowID=""
    obj.LoadEvent = function(args){  
	//添加
 	$('#btnAdd').on('click', function(){
		obj.addNewMatchRecord();
 	});
 	//添加
 	$('#btnSave').on('click', function(){
		obj.btnSave_click()
 	});
	//删除
	$('#btnDelete').on('click', function(){
     	obj.btnDelete_click();
 	});
     }
	obj.gridQCMatchRule_onSelect = function (rd){
		if (obj.RecRowID!=rd.RowID) {
			$("#BTRuleType").combobox('setValue',rd.RuleType);
			Common_SetValue('BTRuleDesc',rd.RuleDesc);
			Common_SetValue('BTRuleAct',(rd.IsActive=="是"?1:0));
			$("#BTExpress").combobox('setValue',rd.RuleMethodID);
			$('#BTExpressParam').val(rd.RuleParam);
			$("#btnSave").linkbutton('enable');
			$("#btnDelete").linkbutton('enable');
			obj.RecRowID=rd.RowID
		}else{
			obj.gridQCMatchRule.clearSelections();
			obj.ClearForms();
			$("#btnDelete").linkbutton('disable');
			obj.RecRowID="";
			}
	}
	obj.ClearForms=function(){
		$("#BTRuleType").combobox('setValue',"");
		$("#BTExpress").combobox('setValue',"");
		Common_SetValue('BTRuleAct','');
		Common_SetValue('BTExpressParam','');
		$('#BTRuleDesc').val('');
		}
	//保存分类
	obj.btnSave_click = function(flg){
		var RuleType=$("#BTRuleType").combobox('getValue');
		var RuleMehod=$("#BTExpress").combobox('getValue');
		var RuleParam=$("#BTExpressParam").val();
		var RuleDesc=$("#BTRuleDesc").val();
		var IsActive=Common_GetValue('BTRuleAct')
		var rd=$('#gridQCMatchRule').datagrid('getSelected');
		if (rd) {var RowID=rd.RowID}
		else { var RowID=""}
		if (obj.QCEntityID=="") {
			$.messager.alert("错误提示", "未获取到病种ID", 'info');
			return;
			}
		var GridRows=$('#gridQCMatchRule').datagrid('getRows');
		var GridLen=GridRows.length;
		var inputStr	=obj.QCEntityID;
		var inputStr	=inputStr+"^"+RowID;
		var inputStr	=inputStr+"^"+RuleType;
		var inputStr	=inputStr+"^"+RuleDesc;
		var inputStr	=inputStr+"^"+RuleMehod;
		var inputStr	=inputStr+"^"+RuleParam;
		var inputStr	=inputStr+"^"+(GridLen+1);
		var inputStr	=inputStr+"^"+(IsActive?1:0);
		var flg= $m({
			ClassName:"DHCMA.CPW.SD.QCEntityMatchRule",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg)>0) {
				$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000})
				$('#gridQCMatchRule').datagrid('reload');
				obj.ClearForms();
				
		}else{
				$.messager.alert("错误提示", "数据保存错误!", 'info');
				
			}	
	}
}