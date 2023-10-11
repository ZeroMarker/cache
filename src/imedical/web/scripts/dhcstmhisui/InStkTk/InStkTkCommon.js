var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
/*
 * 实盘类型 公用formatter
 */
function InputTypeFormatter(value) {
	var InputType = value;
	if (value == '1') {
		InputType = '按批次';
	} else if (value == '2') {
		InputType = '按品种';
	} else if (value == '3') {
		InputType = '按高值条码';
	}
	return InputType;
}