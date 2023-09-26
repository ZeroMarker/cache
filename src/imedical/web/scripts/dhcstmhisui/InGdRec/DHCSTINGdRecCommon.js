// /����: �����ع�������������
// /����: �����ع�������������
// /��д�ߣ�lihui
// /��д����: 20180521

//�������ֵ��object
var IngrParamObj = GetAppPropValue('DHCSTIMPORTM');
var SessionParams=gGroupId+"^"+gLocId+"^"+gUserId+"^"+gHospId;
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');
/*
 * creator:zhangdongmei,2012-09-26
 * description:��֤��Ʊ���Ƿ�����ڱ����ⵥ
 * params: invNo:��Ʊ��,ingr:�������id
 * return: true:������,��Ʊ����Ч��false:����,��Ʊ����Ч
 * */
function InvNoValidator(invNo,ingr){
	if(isEmpty(IngrParamObj)){
		return true;
	}
	if(isEmpty(invNo)){
		return true;
	}
	if(IngrParamObj.CheckInvNo!='Y'){
		return true;      //����Ҫ��֤
	}
	var Flag=true;
	var InvnoExistFlag=tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckInvnoExist', ingr,invNo);
	
	if(InvnoExistFlag==1){
			Flag=false;   //�÷�Ʊ���Ѵ����ڱ����ⵥ		
	}
	return Flag;
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:��֤Ч���Ƿ���Ҫ��ʾ
 * params: expDate:Ч�ڣ�ARG_DATEFORMAT
 * return: true:Ч�ں�������Ҫ��ʾ��false:Ч�ڲ�������Ҫ��ʾ
 * */
function ExpDateValidator(expDate, Inci){
	if (isEmpty(expDate)) {
		return '';
	}
	var ExpChcekInfo = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRecItm', 'CheckExpDate', Inci, expDate);
	if(ExpChcekInfo != ''){
		return ExpChcekInfo;
	}
	return '';
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:ȡĬ�ϵ���ʼ����
 * params: 
 * return:��ʼ����
 * */
function DefaultStDate(){
	var Today = new Date();
	var DefaStartDate = IngrParamObj.DefaStartDate;
	if(isEmpty(DefaStartDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
	return DateFormatter(EdDate);		
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:ȡĬ�ϵĽ�ֹ����
 * params: 
 * return:��ֹ����
 * */
function DefaultEdDate(){
	var Today = new Date();
	var DefaEndDate = IngrParamObj.DefaEndDate;
	if(isEmpty(DefaEndDate)){
		return Today;
	}
	var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
	return DateFormatter(EdDate);
}
//��Ⱦ�ʽ���Դ
function SourceOfFundRender(v){
	var SourceOfFund = v;
	switch (v){
		case 'KS':
			SourceOfFund = '��������';
			break;
		case 'CZ':
			SourceOfFund = '�����ʽ�';
			break;
		case 'KT':
			SourceOfFund = '���⾭��';
			break;
		case 'KY':
		    SourceOfFund = '���л���';	
		    break;
		default :
			break
	}
	return SourceOfFund;
}
//�������Ĭ��ֵ
function GetIngrtypeDefa(){
	var TYPE="IM";
	var IngrtypeId=tkMakeServerCall("web.DHCSTMHUI.Common.Dicts","GetDefaOPtype",TYPE,gHospId);
	return IngrtypeId;
}