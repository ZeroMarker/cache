///����:������ع�������������
///����:������ع�������������
///��д��:lxt
///��д����:2018-7-19

//�������ֵ��object
var InPoParamObj = GetAppPropValue('DHCSTPOM');
//��������ȫ�ֱ���
var INPO_LOCTYPE = 'All';
//���������
var PoLocParams=JSON.stringify(addSessionParams({Type:INPO_LOCTYPE}));
var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
///return:����ʱ��
function NeedDate(){
	var Today = new Date();
	var Days = InPoParamObj.NeedDays
	if(isEmpty(Days)){
		return Today;
	}
	var NeedDate = DateAdd(Today, 'd', parseInt(Days));
	return DateFormatter(NeedDate);
}