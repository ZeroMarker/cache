// /����: ���ת����ع�������������
// /����:���ת����ع�������������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.17

/*��������������ԣ�
�������Ĭ������^Ĭ�ϲ�����ʼ����^Ĭ�ϲ��ҽ�ֹ����^������Զ���ӡ���ⵥ^������˺��Զ���ӡ���ⵥ
^�����˺��Զ���ӡ���ⵥ^�����Ƶ�ʱ�Զ���������^���ת���Ƿ������������^��ӡ����^��������������ϸ^����ҩƷ���Ƴ���
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-10-17
 * description:ȡ���ת����ؽ����漰�Ĳ������ñ��浽ȫ�ֱ���gParam
 * params: 
 * return: 
 * */
function GetParam(ProLocId){
	if ((ProLocId==null)||(ProLocId==undefined)||(ProLocId=="")) {var locId=session['LOGON.CTLOCID'];}
	else {var locId=ProLocId;}
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var url='dhcst.dhcinistrfaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
 * creator:zhangdongmei,2012-10-17
 * description:ȡĬ�ϵ���ʼ����
 * params: 
 * return:��ʼ����
 * */
function DefaultStDate(){
	GetParam();
	var today=new Date();
	if(gParam.length<2){
		return today;
	}
	
	var defaStDate=gParam[1];
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	StDate=StDate.format(App_StkDateFormat);
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:ȡĬ�ϵĽ�ֹ����
 * params: 
 * return:��ֹ����
 * */
function DefaultEdDate(){
	GetParam();
	var today=new Date();
	if(gParam.length<3){
		return today;
	}

	var defaEdDate=gParam[2];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	EdDate=EdDate.format(App_StkDateFormat);
	return EdDate;
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:ȡĬ�ϳ�����˿�ʼ����
 * params: 
 * return:��ֹ����
 * */
function AuditStDate(){
	var today=new Date();
	if(gParam.length<1){
		return today;
	}

	var AuditDays=gParam[0];	
	var StDate=today.add(Date.DAY, parseInt(AuditDays));
	return StDate;
}
//R:���¼�,T:ƽ��
//�˵����ʽά��Ϊ:"&TransFlag=TRA" �����,Ĭ��Ϊ��
//1:TransFlag=="REA"	��ת���˿�����еĹ�����������ʹ�ã���ȡ���Ĺ�������Ϊ�����ŵ��¼�
//2:TransFlag=="EJT"  	�ڵ��������Ƶ����������ա�����������ʹ��(ͬ��֮��Ĳ���)
//3:TransFlag=="REQ"	�����쵥�Ƶ����桢������ս���ʹ��(�¼����ϼ�����)/
//4:TransFlag=="RET"	��ҩƷ�˿��Ƶ���ʹ�ã�������Ϊ���������ϼ�����
//5:TransFlag=="TRA"	����ȷ����ʹ�ã�������Ϊ���������¼�
//6:TransFlag=="KSL"	��������??
//Ĭ�ϲ˵�
function GetProTransType(){
	if(TransFlag=="REA"){
	   return "R";
	}else if(TransFlag=="EJT"){
		return "T"
	}else if(TransFlag=="RET"){
		return "RF"
	}else if(TransFlag=="REQ"){
		return "RF"
	}else{
		return "T";
		}
	}
function GetRecTransType(){
	if((TransFlag=="TRA")||(TransFlag=="KSL")){
	   return "R";
	}else if(TransFlag=="EJT"){
		return "T"
	}else if(TransFlag=="RET"){
		return "RF"
	}else{
		return "T";
	}
}