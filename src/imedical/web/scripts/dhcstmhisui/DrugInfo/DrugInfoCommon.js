
// �������ֵ��object
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
var DefMarkType = '';
function ArcValChange() {
	$('#TariCode').val($('#ArcCode').val());
	$('#TariDesc').val($('#ArcDesc').val());
}

// ���������޸�ʱ������
function InciCodeValChange() {
	$('#ArcCode').val($('#InciCode').val());
	$('#TariCode').val($('#InciCode').val());
}

/*
 * ҽ����(�Ʒ���)����,���ݲ���ȷ������
 */
function InciDescValChange() {
	var value = $('#InciDesc').val();
	var spec = $('#Spec').val();
	var model = $('#Model').val();
	if (CodeMainParamObj['ArcimDescAutoMode'] == '1') {
		if (!isEmpty(spec)) {
			value = value + '[' + spec + ']';
		}
	} else if (CodeMainParamObj['ArcimDescAutoMode'] == '2') {
		if (!isEmpty(spec) && !isEmpty(model)) {
			value = value + '[' + spec + '][' + model + ']';
		} else if (!isEmpty(spec)) {
			value = value + '[' + spec + ']';
		} else if (!isEmpty(model)) {
			value = value + '[' + model + ']';
		}
	}
	if ($('#ArcDesc').length > 0) {
		$('#ArcDesc').val(value);
		$('#TariDesc').val(value);
	}
}