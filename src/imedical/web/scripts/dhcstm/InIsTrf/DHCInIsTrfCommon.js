// /����: ���ת����ع�������������
// /����:���ת����ع�������������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.17

//�������ֵ��object
var InitParamObj = GetAppPropValue('DHCSTTRANSFERM');

/*��������������ԣ�
�������Ĭ������^Ĭ�ϲ�����ʼ����^Ĭ�ϲ��ҽ�ֹ����^������Զ���ӡ���ⵥ^������˺��Զ���ӡ���ⵥ
^�����˺��Զ���ӡ���ⵥ^�����Ƶ�ʱ�Զ���������^���ת���Ƿ������������
*/
var gParam=[]; 

/*
 * creator:zhangdongmei,2012-10-17
 * description:ȡ���ת����ؽ����漰�Ĳ������ñ��浽ȫ�ֱ���gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.dhcinistrfaction.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
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
	var today = new Date();
	var defaStDate = InitParamObj.DefaStartDate;
	if(defaStDate==null || defaStDate==""){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(defaStDate));
	
	return StDate;		
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:ȡĬ�ϵĽ�ֹ����
 * params: 
 * return:��ֹ����
 * */
function DefaultEdDate(){
	var today = new Date();
	var defaEdDate = InitParamObj.DefaEndDate;
	if(defaEdDate==null || defaEdDate==""){
		return today;
	}
	var EdDate=today.add(Date.DAY, parseInt(defaEdDate));
	return EdDate;
}

/*
 * creator:zhangdongmei,2012-10-17
 * description:ȡĬ�ϳ�����˿�ʼ����
 * params: 
 * return:��ֹ����
 * */
function AuditStDate(){
	var today = new Date();
	var AuditDays = InitParamObj.DefaDaysAudit;
	if(Ext.isEmpty(AuditDays)){
		return today;
	}
	var StDate=today.add(Date.DAY, parseInt(AuditDays));
	return StDate;
}

function ProvLocAuditRequired()
{
	var result="";
	if (gParam.length>8) result=gParam[8];
	return	result;
}
function IsSplit()
{
	var result="";
	if (gParam.length>=10) result=gParam[10];
	return	result;
}

function OutType()
{
	// ���ⷽʽ����������(1 ,2 ...)
	var result="";
	//alert(gParam);
	if (gParam.length>=11) result=gParam[11];
	return	result;
	
}

/**
 * �ж�������֮���Ƿ����֧���ϵ
 * @param {} provLoc	:��Ӧ����
 * @param {} requestLoc	:�������
 * @return {Boolean}	:true-ok false-����
 */
function CheckMainLoc(provLoc, requestLoc){
	if(ItmTrackParamObj.UseItmTrack == 'Y' && !Ext.isEmpty(provLoc) && !Ext.isEmpty(requestLoc)){
		if(provLoc == requestLoc){
			//������ͬ��,�����ڹ�������
			return false;
		}
		var MainLocInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLocInfo', requestLoc);
		var MainLoc = MainLocInfo.split('^')[0];
		var MainLocInfo2 = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLocInfo', provLoc);
		var MainLoc2 = MainLocInfo2.split('^')[0];
		if(MainLoc == provLoc || MainLoc2 == requestLoc){
			Msg.info('warning', '���������������Ŵ���֧���ϵ!');
			return false;
		}
	}
	return true;
}
