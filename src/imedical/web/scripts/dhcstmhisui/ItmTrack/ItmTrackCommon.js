// ����: ��ֵ������ع�������������
// wangjiabin	2013-10-16

// �������ֵ��object
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');
var IngrParamObj = GetAppPropValue('DHCSTIMPORTM');
// ����ά������
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
// �Ƿ����ø�ֵ����
var UseItmTrack = ItmTrackParamObj.UseItmTrack == 'Y' ? true : false;
// �Դ������Ƿ�����
var hiddenOrigiBarCode = ItmTrackParamObj.HiddenOrigiBarCode == 'Y' ? true : false;

// ��ʼ����
function TrackDefaultStDate() {
	var Today = new Date();
	var DefaStartDate = ItmTrackParamObj.DefaStartDate;
	if (isEmpty(DefaStartDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);
}

// ��������
function TrackDefaultEdDate() {
	var Today = new Date();
	var DefaEndDate = ItmTrackParamObj.DefaEndDate;
	if (isEmpty(DefaEndDate)) {
		return DateFormatter(Today);
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}

/**
 * ������������ϵ,��Scg��CheckScg������,����true, ���򷵻�false
 * @param {} CheckScg
 * @param {} Scg
 * @return {Boolean}
 */
function CheckScgRelation(CheckScg, Scg) {
	if (isEmpty(CheckScg) || isEmpty(Scg)) {
		return true;
	}
	var ChildScg = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetAllChildScgStr', CheckScg, ',');
	var ChildScgArr = ChildScg.split(',');
	return (ChildScgArr.indexOf(Scg) >= 0);
}

function TypeRenderer(value) {
	var TypeDesc = value;
	if (value == 'G') {
		TypeDesc = '���';
	} else if (value == 'R') {
		TypeDesc = '�˻�';
	} else if (value == 'T') {
		TypeDesc = 'ת�Ƴ���';
	} else if (value == 'K') {
		TypeDesc = 'ת�ƽ���';
	} else if (value == 'P' || value == 'MP') {
		TypeDesc = 'סԺҽ��';
	} else if (value == 'Y' || value == 'MY') {
		TypeDesc = 'סԺҽ��ȡ��';
	} else if (value == 'A') {
		TypeDesc = '������';
	} else if (value == 'D') {
		TypeDesc = '��汨��';
	} else if (value == 'F' || value == 'MF') {
		TypeDesc = '����ҽ��';
	} else if (value == 'H' || value == 'MH') {
		TypeDesc = '����ҽ��ȡ��';
	} else if (value == 'RD') {
		TypeDesc = '����';
	} else if (value == 'PD') {
		TypeDesc = '�ɹ�';
	} else if (value == 'POD') {
		TypeDesc = '����';
	} else if (value == 'SG') {
		TypeDesc = '��¼���';
	} else if (value == 'ST') {
		TypeDesc = '��¼����';
	} else if (value == 'SK') {
		TypeDesc = '��¼����-����';
	} else if (value == 'SR') {
		TypeDesc = '��¼���-�˻�';
	} else if (value == 'SP') {
		TypeDesc = '��¼ҽ������';
	} else if (value == 'C') {
		TypeDesc = '����';
	} else if (value == 'L') {
		TypeDesc = '�����˻�';
	} else if (value == 'SMY') {
		TypeDesc = '��̨סԺҽ��ȡ��';
	} else if (value == 'SMH') {
		TypeDesc = '��̨����ҽ��ȡ��';
	}
	return TypeDesc;
}

function StatusFormatter(value) {
	var Status = value;
	if (value == 'Enable') {
		Status = '����';
	} else if (value == 'Return') {
		Status = '�˻�';
	} else if (value == 'Used') {
		Status = '��ʹ��';
	} else if (value == 'InScrap') {
		Status = '����';
	} else if (value == 'InAdj') {
		Status = '����';
	} else if (value == 'InIsTrf') {
		Status = '����';
	} else if (value == 'InDisp') {
		Status = '����';
	} else if (value == '') {
		Status = 'ע��';
	}
	return Status;
}

/*
 * ��������(OriginalStatus)����formatter
 */
function OriginalStatusFormatter(value) {
	var OriginalStatus = value;
	if (value == 'NotUnique') {
		OriginalStatus = '������';
	} else if (value == '') {
		OriginalStatus = 'Ψһ��';
	}
	return OriginalStatus;
}

/**
 * �����ϸ���ָ�ֵ���������Ƿ����
 * @param {ҵ��̨������} Type
 * @param {ҵ������rowid} Main
 * @return {Boolean} true:����, false:������
 */
function CheckHighValueLabels(Type, Main) {
	var CheckResult = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'CheckLabelsByPointer', Type, Main);
	if (!isEmpty(CheckResult)) {
		$UI.msg('error', '��ֵ���� ' + CheckResult + ' û��¼�������¼����������������������!');
		return false;
	}
	return true;
}