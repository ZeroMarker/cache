
//保存参数值的object
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');

function ArcValChange() {
	$("#TariCode").val($("#ArcCode").val());
	$("#TariDesc").val($("#ArcDesc").val());
}

/*
 * 医嘱项(计费项)名称,根据参数确定内容
 */
function InciDescValChange() {
	var value = $("#InciDesc").val();
	var spec = $("#Spec").val();
	var model = $("#Model").val();
	if (CodeMainParamObj['ArcimDescAutoMode'] == '1') {
		if (!isEmpty(spec)) {
			value = value + "[" + spec + "]";
		}
	} else if (CodeMainParamObj['ArcimDescAutoMode'] == '2') {
		if (!isEmpty(spec) && !isEmpty(model)) {
			value = value + "[" + spec + "][" + model + "]";
		}else if(!isEmpty(spec)){
			value = value + "[" + spec + "]";
		}
	}
	$("#ArcDesc").val(value);
	$("#TariDesc").val(value);
}
