// /����: ���ת��������ع�������������
// /����: ���ת��������ع�������������
// /��д�ߣ�wyx
// /��д����: 2014.01.22
// DHCSTINRequestCommon.js

/*��������������ԣ�
 ���������Ƿ���Դ��ڹ�Ӧ�����
*/
var gParam=[]; 

/*
 * creator:wyx,2013-11-13
 * description:ȡ���ת��������ؽ����漰�Ĳ������ñ��浽ȫ�ֱ���gParam
 * params: 
 * return: 
 * */
function GetParam(ProLocId){
	if ((ProLocId==null)||(ProLocId==undefined)||(ProLocId=="")) {var locId=session['LOGON.CTLOCID'];}
	else {var locId=ProLocId;}
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	//var locId=session['LOGON.CTLOCID'];
	var url='dhcst.inrequestaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gParam=info.split('^');
		}
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
	var today=new Date();
	if(gParam.length<3){
		return today;
	}
	
	var defaStDate=gParam[2];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:ȡĬ�ϵĽ�ֹ����
 * params: 
 * return:��ֹ����
 * */
function DefaultEdDate(){
	var today=new Date();
	if(gParam.length<4){
		return today;
	}

	var defaEdDate=gParam[3];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}