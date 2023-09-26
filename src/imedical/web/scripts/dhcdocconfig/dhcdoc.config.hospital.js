$(function(){
	InitComboMainHospital("_HospList","MainHospital");
	$('#BSave').click(function() {
		SaveMainHospital("_HospList","MainHospital");
	});
	$('#ClearConfigData').click(ClearConfigDataClickHandler);
})
function InitComboMainHospital(param1,param2)
{
	var hospComp = GenHospComp("Doc_BaseConfig_Hospital");
	/*$("#"+param1+"").combobox({      
    	valueField:'HOSPRowId',   
    	textField:'HOSPDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.InstrArcim';
			param.QueryName = 'GetHos';
			param.ArgCnt =0;
		}  
	});*/
}
function SaveMainHospital(param1,param2)
{
	var MainHospital=$HUI.combogrid('#_HospList').getValue();
	if ((!MainHospital)||(MainHospital=="")) {
		MainHospital=session['LOGON.HOSPID'];
	}
	//var MainHospital=$("#"+param1+"").combobox('getValue');
	var DataList=param2+String.fromCharCode(1)+MainHospital;
	var value=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
	   	Coninfo:DataList,
	   	HospId:MainHospital
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});				
	}
}
function ClearConfigDataClickHandler() {
	$.messager.confirm("确认对话框","您确定已经仔细阅读提示内容,且继续要清除配置数据吗?",function(r){
		if (r) {
			var value=$.m({
				ClassName:"web.DHCDocConfig",
				MethodName:"ClearDocConfig",
				HospID:$HUI.combogrid('#_HospList').getValue()
			},false);
			if(value=="0"){
				$.messager.popover({msg: '保存成功!',type:'success'});					
			}else{
				$.messager.alert("结果提醒","未清除");
			}
		}else{
			$.messager.alert("结果提醒","未清除");
		}
	});
}