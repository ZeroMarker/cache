// /����: �˻���ع�������������
// /����: �˻���ع�������������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.02

//�������ֵ��object
var IngrtParamObj = GetAppPropValue('DHCSTRETURNM');

/*��������������ԣ�
 * Ĭ�ϲ�����ʼ����^Ĭ�ϲ��ҽ�ֹ����
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-09-26
 * description:ȡ�����ؽ����漰�Ĳ������ñ��浽ȫ�ֱ���gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.ingdretaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
 * creator:zhangdongmei,2012-09-26
 * description:ȡĬ�ϵ���ʼ����
 * params: 
 * return:��ʼ����
 * */
function DefaultStDate(){
	if(gParam.length<1){
		GetParam();	
	}
	
	var today=new Date();
	if(gParam.length<1){
		return today;
	}
	
	var defaStDate=gParam[0];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:ȡĬ�ϵĽ�ֹ����
 * params: 
 * return:��ֹ����
 * */
function DefaultEdDate(){
	if(gParam.length<1){
		GetParam();	
	}
	var today=new Date();
	if(gParam.length<2){
		return today;
	}

	var defaEdDate=gParam[1];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}