// /����: �ɹ��ƻ���ع�������������
// /����: �ɹ��ƻ���ع�������������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.27

/*��������������ԣ�
 * �����Ƿ����Ϊ��^�Ƿ��Զ�����^Ĭ�ϲ�����ʼ����^Ĭ�ϲ��ҽ�ֹ����
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-09-27
 * description:ȡ�ɹ��ƻ���ؽ����漰�Ĳ������ñ��浽ȫ�ֱ���gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcst.inpurplanaction.csp?actiontype=GetParamProp&groupId='+groupId+'&locId='+locId+'&userId='+userId;
	var response=ExecuteDBSynAccess(url);
	if(response!=null || response!=''){
		gParam=response.split('^');
	}
	return;
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:ȡĬ�ϵ���ʼ����
 * params: 
 * return:��ʼ����
 * */
function DefaultStDate(){
	GetParam();
	var today=new Date();
	if(gParam.length<3){
		return today;
	}
	
	var defaStDate=gParam[2];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	StDate=StDate.format(App_StkDateFormat);
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:ȡĬ�ϵĽ�ֹ����
 * params: 
 * return:��ֹ����
 * */
function DefaultEdDate(){
	GetParam();
	var today=new Date();
	if(gParam.length<4){
		return today;
	}

	var defaEdDate=gParam[3];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	EdDate=EdDate.format(App_StkDateFormat);
	return EdDate;
}