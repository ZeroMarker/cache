// /����: �����ع�������������
// /����: �����ع�������������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.26

/*��������������ԣ�
 * Ĭ�����۵��ڽ���^��ⷢƱ��^Ч����ʾ����^������Զ���ӡ^��˺��Զ���ӡ
^�ӳ��ʳ�����ʾ^����¼����۽��^�ɹ�Ա����Ϊ��^������Ͳ���Ϊ��^��֤����ۼ�^Ĭ�ϲ�����ʼ����^Ĭ�ϲ��ҽ�ֹ����
^����ҩƷ�������Զ���ʾ��ʷ��������б�^��ӡ��ʽ����
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
	var url='dhcst.ingdrecaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
 * description:��֤��Ʊ���Ƿ�����ڱ����ⵥ
 * params: invNo:��Ʊ��,ingr:�������id
 * return: true:������,��Ʊ����Ч��false:����,��Ʊ����Ч
 * */
function InvNoValidator(invNo,ingr){
	if(gParam.length<1){
		GetParam();
	}
	if(gParam.length<2){
		return true;
	}
	if(invNo==null || invNo==''){
		return true;
	}
	if(gParam[1]!='Y'){
		return true;      //����Ҫ��֤
	}
	
	var Flag=true;
	var url='dhcst.ingdrecaction.csp?actiontype=CheckInvnoExist&Ingr='+ingr+'&InvNo='+invNo;
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info==1){
			Flag=false;   //�÷�Ʊ���Ѵ����ڱ����ⵥ		
		}
	}
	return Flag;
}

/*
 * creator:zhangdongmei,2012-09-26
 * description:��֤Ч���Ƿ���Ҫ��ʾ
 * params: expDate:Ч�ڣ�"Y-m-d"
 * return: true:Ч�ں�������Ҫ��ʾ��false:Ч�ڲ�������Ҫ��ʾ
 * */
function ExpDateValidator(expDate){
	if(gParam.length<1){
		GetParam();
	}
	if(gParam.length<3){
		return true;
	}
	if (expDate == null || expDate.length <= 0) {
		return true;
	}
	var today=new Date().format('Y-m-d');
	if(expDate<today){
		return false;
	}
	var days=DaysBetween(expDate,today);
    if(days<gParam[2]){
    	return false;
    }    
    return true;
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
	if(gParam.length<11){
		return today;
	}
	
	var defaStDate=gParam[10];
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
	if(gParam.length<12){
		return today;
	}

	var defaEdDate=gParam[11];
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}