// /����: �ɹ��ƻ���ع�������������
// /����: �ɹ��ƻ���ع�������������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.27

//�������ֵ��object
var InPurPlanParamObj = GetAppPropValue('DHCSTPURPLANAUDITM');

/*��������������ԣ�
 * �����Ƿ����Ϊ��^�Ƿ��Զ�����^Ĭ�ϲ�����ʼ����^Ĭ�ϲ��ҽ�ֹ����^��Ӧ�̱���
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
	var url='dhcstm.inpurplanaction.csp?actiontype=GetParamProp&groupId='+groupId+'&locId='+locId+'&userId='+userId;
	var response=ExecuteDBSynAccess(url);
	//var jsonData=Ext.util.JSON.decode(response);
	//if(jsonData.success=='true'){
		//var info=jsonData.info;
		if(response!=null || response!=''){
			gParam=response.split('^');
		}
	//}
	/*
	Ext.Ajax.request({
		url:'dhcstm.ingdrecaction.csp',
		method:'post',
		params:{actiontype:'GetParamProp',GroupId:groupId,LocId:locId,UserId:userId},
		success:function(response,opts){
			var jsonData=Ext.util.JSON.decode(response.responseText);
			if(jsonData.success=='true'){
				var info=jsonData.info;
				if(info!=null || info!=''){
					gParam=info.split('^');
				}
			}
		}
	
	});
	*/
	return;
}

/*
 * creator:zhangdongmei,2012-09-27
 * description:ȡĬ�ϵ���ʼ����
 * params: 
 * return:��ʼ����
 * */
function DefaultStDate(){
	if(gParam.length<1){
		GetParam();
	}
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
	if(gParam.length<1){
		GetParam();
	}
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