// /����:  �����ع�������������
// /��д�ߣ�wxj
// /��д����: 20220912

// �������ֵ��object
var RedParamObj = GetAppPropValue('DHCSTMREDOFFSET');
var SessionParams = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
// ȡĬ�ϵ���ʼ����
function DefaultStDate() {
	var Today = new Date();
	var DefaStartDate = RedParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);
}

// ȡĬ�ϵĽ�ֹ����
function DefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = RedParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}